// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Animal.sol";

contract Sheep is Animal {
  
    function eat() public override pure returns(string memory)  {
        return "grass";
    }
}
