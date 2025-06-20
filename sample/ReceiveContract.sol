//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ReceiveContract {

    event Received(address Sender, uint Value);

    error CallFailed(); 

    error SendFailed();

    // 接收ETH时释放Received事件
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    event fallbackCalled(address Sender, uint Value, bytes Data);

    // fallback
    fallback() external payable{
        emit fallbackCalled(msg.sender, msg.value, msg.data);
    }

     function getBalance() view public returns(uint) {
        require(address(this).balance > 0, "banane equal 0");
        return address(this).balance;
    }

    function transferETH(address payable _to, uint256 amount) external payable{
        _to.transfer(amount);
    }

    function sendETH(address payable _to, uint256 amount) external payable{
        // 处理下send的返回值，如果失败，revert交易并发送error
        bool success = _to.send(amount);
        if(!success){
            revert SendFailed();
        }
    }

    function callETH(address payable _to, uint256 amount) external payable{
        // 处理下call的返回值，如果失败，revert交易并发送error
        (bool success,) = _to.call{value: amount}("");
        if(!success){
            revert CallFailed();
        }
    }
}