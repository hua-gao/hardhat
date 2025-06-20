// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20

interface IBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function getBalance() external view returns (uint256);
}

// 实现银行接口的合约
contract Bank is IBank {
    mapping(address => uint256) public balances;

    function deposit() external payable override {
        require(msg.value > 0, "amout is largen than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external override {
        require(balances[msg.sender] >= amount, "banance is not enouth");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getBalance() external view override returns (uint256) {
        return balances[msg.sender];
    }
}

// 使用银行接口的合约
contract BankUser {
    function depositToBank(address bankAddress) external payable {
        IBank bank = IBank(bankAddress);
        bank.deposit{value: msg.value}();
    }

    function withdrawFromBank(address bankAddress, uint256 amount) external {
        IBank bank = IBank(bankAddress);
        bank.withdraw(amount);
    }

    function getBankBalance(address bankAddress) external view returns (uint256) {
        IBank bank = IBank(bankAddress);
        return bank.getBalance();
    }
}