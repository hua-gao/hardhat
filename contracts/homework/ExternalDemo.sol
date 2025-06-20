// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExternalDemo {
    address public caller;

    // function first() public {
    //     second();
    // }

    // function second() public {
    //     caller = msg.sender;
    // }

    function first() public {
        this.second();
    }

    function second() external {
        caller = msg.sender;
    }

    // 调用external修饰的方法时，msg发生了变化。不是EOA发送的msg，而是first发送的msg.
    // 内部通过this调用external方法时，会消耗较高的gas， 不推荐使用
}