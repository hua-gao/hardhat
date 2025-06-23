// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity  ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//可升级NFT拍卖合约
contract UgradeableNftAution is Initializable, UUPSUpgradeable {
    address private admin;
    uint256 autionId;
    mapping(uint256=>Auction) auctions;

    //拍卖状态
    enum AuctionStatus { Active, Ended, Cancelled }

    //NFT所有者创建拍卖事件
    event AuctionCreated(
            address seller,
            address nftTokenAddress,
            uint256 nftTokenId,
            uint256 auctionId,
            uint256 startPrice,
            uint256 reversePrice,
            uint256 minBidPrice,
            uint256 startTime,
            uint256 endTime
        );

    //参与拍卖事件
    event BidPlaced(uint256 auctionId, address bidder, uint256 bidPrice);

    //取消拍卖
    event AuctionCancelled(uint256 auctionId);

    //结束拍卖
    event AuctionEnded(uint256 auctionId, address bidder, uint256 tokenId);

    struct Auction {
        address payable seller; //发起拍卖人的地址
        address nftTokenAddress;//nft合约地址
        uint256 nftTokenId;//nft id
        uint256 auctionId;//拍卖ID
        uint256 startPrice;//起拍价格
        uint256 reversePrice;//保底价

        uint256 startTime;//拍卖开始时间
        uint256 duration; //拍卖持续时间

        uint256 highestBid;
        address payable highestBidder;

        uint256 minBidPrice;

        uint256 endtime;//拍卖结束时间

        AuctionStatus status; //拍卖是否结果 
    }

     // 替代构造函数
    function initialize() public initializer {
        autionId = 0;
    }

    function createAuton(
        address _nftTokenAddress,
        uint256 _nftTokenId,
        uint256 _startPrice,
        uint256 _reversePrice,
        uint256 _minBidPrice,
        uint256 _startTime,
        uint256 _duration
    ) external {
        require(_startTime > block.timestamp, "Start time must be in future");
        require(_duration > 0, "Duration must be positive");
        require(_startPrice > 0, "start price  must be larger than 0");

        //只有NFT拥有者才可以转账
        require(IERC721(_nftTokenAddress).ownerOf(_nftTokenId) == msg.sender, "Not NFT owner");


        // 转移NFT到合约
        IERC721(_nftTokenAddress).approve(address(this), _nftTokenId);
        // IERC721(_nftAddress).safeTransferFrom(msg.sender, address(this), _tokenId);

        auctions[autionId] = Auction({
            seller: payable(msg.sender),
            nftTokenAddress: _nftTokenAddress,
            nftTokenId: _nftTokenId,
            auctionId: autionId,
            startPrice: _startPrice,
            reversePrice: _reversePrice,
            minBidPrice: _minBidPrice,
            startTime: _startTime,
            duration: _duration,
            highestBid: 0,
            highestBidder: payable(address(0x0)),
            endtime: 0,
            status: AuctionStatus.Active
        });

        emit AuctionCreated(
            msg.sender,
            _nftTokenAddress,
            _nftTokenId,
            autionId,
            _startPrice,
            _reversePrice,
            _minBidPrice,
            _startTime,
            _startTime + _duration
        );

        autionId++;
    }

    function placeBid(uint256 auctionId) external payable {
        require(auctions[auctionId].seller != address(0x0), "auctions is not existed!");

        Auction storage auction = auctions[auctionId];
        require(block.timestamp > auction.startTime, "auction is not started!");
        require(block.timestamp > auction.startTime+auction.duration, "auction is ended");
        require(msg.value > auction.highestBid, "Bid too low");
        require(msg.value >= auction.startPrice, "Bid below start price");

         // 返还前一个最高出价者的资金
        if (auction.highestBidder != address(0x0)) {
            auction.highestBidder.transfer(auction.highestBid);
        }
        auction.highestBidder = payable(msg.sender);
        auction.highestBid = msg.value;  

        emit BidPlaced(auctionId, msg.sender, msg.value);
    }

    function endAuction(uint256 auctionId) external {
        require(auctions[auctionId].seller != address(0x0), "auctions is not existed!");
        
        Auction storage auction = auctions[auctionId];

        require(auction.status == AuctionStatus.Active, "auction had ended");
        require(auction.seller != msg.sender, "is not the nft owner");
        require(block.timestamp > auction.startTime + auction.duration, "Auction not ended");
        require(auction.highestBid > auction.reversePrice, "hightbid is less than reverse price");

        // 转账NFT给最高出价者
        IERC721(auction.nftTokenAddress).transferFrom(address(this), auction.highestBidder, auction.nftTokenId);
            
        // 转账资金给卖家
        auction.seller.transfer(auction.highestBid);

        auction.status = AuctionStatus.Ended;
            
        emit AuctionEnded(auctionId, auction.highestBidder, auction.nftTokenId);
    }

    function cancelAuction(uint256 auctionId) external {
        require(auctions[auctionId].seller != address(0x0), "auctions is not existed!");
        
        Auction storage auction = auctions[auctionId];

        require(block.timestamp<auction.startTime+auction.duration, "auction had ended");
        require(auction.seller != msg.sender, "is not the nft owner");

        // 退回NFT给卖家
        IERC721(auction.nftTokenAddress).transferFrom(address(this), auction.seller, auction.nftTokenId);
        
        // 返还出价资金
        if (auction.highestBidder != address(0)) {
            auction.highestBidder.transfer(auction.highestBid);
        }

        auction.status = AuctionStatus.Cancelled;
        
        emit AuctionCancelled(auctionId);
    }

    /**
     * @dev 获取拍卖信息
     * @param auctionId 拍卖ID
     */
    function getAuctionInfo(uint256 auctionId) external view returns (Auction memory) {
        return auctions[auctionId];
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal view override {
        // 只有管理员可以升级合约
        require(newImplementation != address(0x0), "newImplementation");
        require(msg.sender == admin, "Only admin can upgrade");
    }
} 