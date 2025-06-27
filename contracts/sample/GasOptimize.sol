// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract GasOptimize {

    uint public total;
    //优化方式
    //1、memory=>calldata
    //2、用临时变量存储存储状态变量，减少访问状态变量的次数
    //3、用临时变量存储反复访问的属性
    //4、条件短路 如条件表达中有多个，可将条件表达式直接放在if语句中，
    //5、i+=1=>i++
    //6、用临时变量存储反复访问的数组元素

    function sum(uint[] memory nums) external {
        for(uint i=0; i<nums.length; i+=1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLennThan99 = nums[i] < 99;
            if(isEven  && isLennThan99 ){
                total += nums[i];
            }
        }
    }
    
    function sumNew(uint[] calldata nums) external {
        uint256 _total = total;
        uint256 length = nums.length;
     
        for(uint i=0; i<length; i++) {
            uint256 num = nums[i];
            if(num % 2 == 0  && num < 99 ){
                _total += num;
            }
        }
        total = _total;
    }
}