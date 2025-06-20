// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract BaseContract {
    int public i;
    int8 public i8;
    int16 public i16;
    int24 public i24;
    int256 public i256;

    uint public ui;
    uint8 public ui8;
    uint16 public ui16;
    uint256 public ui256;

    bool public bo1 = true;
    bool public bo2 = false;

    bytes public b0;
    bytes1 public b1;
    bytes2 public b2;
    bytes3 public b3;
    bytes4 public b4;
    bytes5 public b5;
    bytes6 public b6;
    bytes7 public b7;
    bytes8 public b8;
    bytes32 public b255;

    string public s1;

    int[3] public ai1;
    string[3] public as1;


    int constant public MAX_COUNT = 10;
    int immutable public MIN_AMOUNT  = 100;

    struct Person {
        string name;
        uint age;
    }

    Person public p1;

    Person[] public persons;

    mapping(address addr => uint amount) accounts;

    int public finishStatus = 0;

    address public owner;

    // 声明一个地址变量
    address public myAddress;

    // 获取当前调用者的地址
    address public caller = msg.sender;

     event StatusChanged(uint newStatus);
     event Received(address sender, uint amount);
     event FallbackCalled(address sender, uint amount);

    constructor() {
        i = 10;
        ui = 10;
        persons.push(Person("gaohua027", 16));
        //MAX_COUNT = 10；
        MIN_AMOUNT = 20;
        owner = msg.sender;
    }

    function fun1(address _addr, uint _amount) public returns (bool){
        require(_amount > 0, "amount is not large 0");
        accounts[_addr] = _amount;

        finishStatus = 1;
         emit StatusChanged(uint(finishStatus)); //触发事件

        return true;
    }

    receive() external payable onlyOwner {
        emit Received(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value);
    }

    function overLoad(uint _in) public pure returns (uint) {
        return _in;
    }

    function overLoad(uint _in, bool _flag) public pure returns (uint) {
        return _flag ? _in : 0;
    }


    function sendHalf(address addr) public payable {
        require(msg.value % 2 == 0, "Even value required."); // 输入检查
        uint balanceBeforeTransfer = address(this).balance;
        payable(addr).transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2); // 内部错误检查
    }



    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    // 地址类型之间的比较
    function compareAddress(address addr1, address addr2) public pure returns (bool) {
        return addr1 == addr2;
    }

    // 地址类型的转换
    function toBytes(address addr) public pure returns (bytes memory) {
        return abi.encodePacked(addr);
    }
    
    function sendEther(address payable recipient) public payable {
        recipient.transfer(msg.value);
    }

    // 调用地址的代码（低级别调用）
    function callContract(address addr, bytes memory data) public returns (bool, bytes memory) {
        (bool success, bytes memory result) = addr.call(data);
        return (success, result);
    }
}