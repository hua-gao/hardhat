// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringReverser {
    /**
     * @dev 反转字符串（仅处理ASCII字符）
     * @param str 输入字符串
     * @return 反转后的字符串
     */
    function reverse(string memory str) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        uint256 length = strBytes.length;
        bytes memory reversed = new bytes(length);
        
        for (uint i = 0; i < length; ) {
            reversed[i] = strBytes[length - 1 - i];
            unchecked { i++; } // Gas优化：禁用溢出检查
        }
        
        return string(reversed);
    }
}