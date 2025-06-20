// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Car {
    uint public speed;

    function drive() public virtual{

    }
}

contract ElectricCar is Car {
    uint public batteryLevel ;

    function drive() public override {

    } 
}