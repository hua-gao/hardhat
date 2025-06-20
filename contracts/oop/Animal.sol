// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

abstract  contract Animal {
    uint256 private age;
    string private name;
    string internal food;

    constructor(){
    }

    function setAge(uint256 _age) public {
        age = _age;
    } 

    function setName(string memory _name) public {
        name = _name;
    }

    function getAge() public view returns(uint256) {
        return age;
    }

    function getName() public view returns(string memory){
        return name;
    }

    function getFood() public view returns(string memory){
        return food;
    }

    function eat() public virtual returns(string memory)  {

    }
}
