// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Animal.sol";
import "./Sheep.sol";
import "./Tiger.sol";

contract TestMain {

    function testMain() public returns(string memory){
        Animal animal = new Sheep();
        return animal.eat();
    }
}
