// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArraySearch {
    /**
     * @dev 在升序数组中查找目标值（二分查找）
     * @param arr 有序数组（升序）
     * @param target 要查找的值
     * @return 目标值的索引（未找到返回 type(uint).max）
     */
    function binarySearch(uint[] memory arr, uint target) public pure returns (uint) {
        uint left = 0;
        uint right = arr.length;
        
        while (left < right) {
            uint mid = left + (right - left) / 2;
            
            if (arr[mid] == target) {
                return mid;
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        
        return type(uint).max; // 未找到的特殊值
    }
}