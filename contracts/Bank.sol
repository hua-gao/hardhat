// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.20;

contract  Bank {
    uint256 private balance;
    uint256 constant MIN_AMOUNT = 10;
    mapping (string => Account) accounts;
    struct Account {
        string id;
        uint256 balance;
    }

    constructor(uint256 _balance) {
        balance = _balance;
    }

    function getBalance() public view returns(uint256 ){
        return balance;
    } 

    function getAccountBalance(string memory id) public view returns(uint256 ){
        require(bytes(accounts[id].id).length>0, "invalid account id");
        return accounts[id].balance;
    } 

    function deposit(string memory id, uint256 amount) public {
        require(bytes(id).length >=6, "id's length must larger 6");
        require(amount > MIN_AMOUNT, "amount must larger 10");
        accounts[id].id = id;
        accounts[id].balance = accounts[id].balance + amount;
        balance = balance + amount;
    }

    function withdraw(string memory id, uint256 amount) public {
        require(bytes(id).length >=6, "id's length must larger 6");
        require(amount > MIN_AMOUNT, "amount must larger 10");
        require(accounts[id].balance > 0, "not enouth money");
        require(amount <= accounts[id].balance, "not enouth money");

        uint256 currentAmount  = accounts[id].balance;
        accounts[id].balance = 0;
        currentAmount = currentAmount - amount;
        accounts[id].balance = currentAmount;

        balance = balance - amount;
    }

     event Received(address sender, uint amount);

    receive() external payable {
       emit Received(msg.sender, msg.value);
    }

    event ReceivedFB(address sender, uint amount);
    
    fallback() external payable {
        emit ReceivedFB(msg.sender, msg.value);
    }
}

