// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract BeggingContract {
    address private immutable admin;
    uint256 private immutable duration;
    uint256 private immutable startTime;
    mapping(address=>uint256) private items;

    event EventDonate(address indexed user, uint256 amount);
    event EventWidthdraw(address indexed user, uint256 amount);

    //设置捐赠持续时间
    constructor(uint256 _duration){
        admin = msg.sender;
        startTime = block.timestamp;
        duration = _duration;
    }

    //向合约捐赠
    function donate() public payable returns(bool){
        require(block.timestamp < (startTime+duration), "donate had ended!");
        require(msg.value >0, "donate amout is more than 0");
        items[msg.sender] = items[msg.sender] + msg.value;

        emit EventDonate(msg.sender, msg.value);
        return true;
    }

    //获取指定地址的捐赠金额 
    function getDonate(address _addr) public view returns(uint256){
        require(_addr != address(0x0), 'invalid address');
        return items[_addr];
    }

    //合约提款
    function withdraw() public onlyOwner returns(bool){
        uint balance = address(this).balance;
        require(balance >0, "not enough eth!");
        
        payable(msg.sender).transfer(balance);
        /*(bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");*/

        emit EventWidthdraw(msg.sender, balance);
        return true;
    }

    //获取捐赠最多的3个地址,待完善
    function getTopDonator() public pure returns(address, address, address){
        return (address(0x0),address(0x0),address(0x0));
    }

    modifier onlyOwner {
        require(msg.sender == admin, 'only the owner can operate');
        _;
    }

    receive() external payable {}
}