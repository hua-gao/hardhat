// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanToArabicConverter {
    // 罗马数字到阿拉伯数字的映射
    mapping(bytes1 => uint256) private romanValues;
    
    constructor() {
        // 初始化罗马数字对应值
        romanValues['I'] = 1;
        romanValues['V'] = 5;
        romanValues['X'] = 10;
        romanValues['L'] = 50;
        romanValues['C'] = 100;
        romanValues['D'] = 500;
        romanValues['M'] = 1000;
    }
    
    /**
     * @dev 将罗马数字字符串转换为阿拉伯数字
     * @param roman 罗马数字字符串（只支持大写字母）
     * @return 对应的阿拉伯数字
     */
    function convert(string memory roman) public view returns (uint256) {
        bytes memory romanBytes = bytes(roman);
        uint256 length = romanBytes.length;
        require(length > 0, "Empty string");
        
        uint256 total = 0;
        uint256 prevValue = 0;
        
        // 从右向左处理罗马数字
        for (uint256 i = length; i > 0; i--) {
            bytes1 currentChar = romanBytes[i-1];
            uint256 currentValue = romanValues[currentChar];
            require(currentValue != 0, "Invalid Roman numeral");
            
            // 如果当前值小于前一个值，则减去当前值（如IV=4）
            if (currentValue < prevValue) {
                total -= currentValue;
            } else {
                total += currentValue;
            }
            
            prevValue = currentValue;
        }
        
        return total;
    }
    
    /**
     * @dev 验证罗马数字是否有效
     * @param roman 罗马数字字符串
     * @return 是否有效
     */
    function isValidRoman(string memory roman) public view returns (bool) {
        bytes memory romanBytes = bytes(roman);
        uint256 length = romanBytes.length;
        if (length == 0) return false;
        
        // 检查每个字符是否有效
        for (uint256 i = 0; i < length; i++) {
            if (romanValues[romanBytes[i]] == 0) {
                return false;
            }
            
            // 检查非法重复（如VV, LL, DD）
            if (i > 0 && romanBytes[i] == romanBytes[i-1]) {
                bytes1 c = romanBytes[i];
                if (c == 'V' || c == 'L' || c == 'D') {
                    return false;
                }
            }
        }
        
        // 尝试转换验证
        try this.convert(roman) {
            return true;
        } catch {
            return false;
        }
    }
}