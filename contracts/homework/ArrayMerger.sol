// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayMerger {
    /**
     * @dev 合并两个升序排列的数组
     * @param a 第一个数组
     * @param b 第二个数组
     * @return 合并后的有序数组
     */
    function merge(uint[] memory a, uint[] memory b) public pure returns (uint[] memory) {
        uint[] memory merged = new uint[](a.length + b.length);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        
        // 合并过程
        while (i < a.length && j < b.length) {
            if (a[i] < b[j]) {
                merged[k++] = a[i++];
            } else {
                merged[k++] = b[j++];
            }
        }
        
        // 处理剩余元素
        while (i < a.length) {
            merged[k++] = a[i++];
        }
        
        while (j < b.length) {
            merged[k++] = b[j++];
        }
        
        return merged;
    }
}