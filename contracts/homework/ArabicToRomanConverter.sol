// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArabicToRomanConverter {
    // 阿拉伯数字到罗马数字的映射
    struct RomanNumeral {
        uint256 value;
        string symbol;
    }
    
    RomanNumeral[] private romanNumerals;
    
    constructor() {
        // 初始化映射表（按从大到小排序）
        romanNumerals.push(RomanNumeral(1000, "M"));
        romanNumerals.push(RomanNumeral(900, "CM"));
        romanNumerals.push(RomanNumeral(500, "D"));
        romanNumerals.push(RomanNumeral(400, "CD"));
        romanNumerals.push(RomanNumeral(100, "C"));
        romanNumerals.push(RomanNumeral(90, "XC"));
        romanNumerals.push(RomanNumeral(50, "L"));
        romanNumerals.push(RomanNumeral(40, "XL"));
        romanNumerals.push(RomanNumeral(10, "X"));
        romanNumerals.push(RomanNumeral(9, "IX"));
        romanNumerals.push(RomanNumeral(5, "V"));
        romanNumerals.push(RomanNumeral(4, "IV"));
        romanNumerals.push(RomanNumeral(1, "I"));
    }
    
    /**
     * @dev 将阿拉伯数字转换为罗马数字
     * @param num 要转换的数字（1-3999）
     * @return 罗马数字字符串
     */
    function convert(uint256 num) public view returns (string memory) {
        require(num > 0 && num < 4000, "Number out of range (1-3999)");
        
        string memory result;
        
        for (uint256 i = 0; i < romanNumerals.length; i++) {
            while (num >= romanNumerals[i].value) {
                result = string(abi.encodePacked(result, romanNumerals[i].symbol));
                num -= romanNumerals[i].value;
            }
        }
        
        return result;
    }
    
    /**
     * @dev 批量转换多个数字
     * @param numbers 要转换的数字数组
     * @return 罗马数字字符串数组
     */
    function batchConvert(uint256[] memory numbers) public view returns (string[] memory) {
        string[] memory results = new string[](numbers.length);
        
        for (uint256 i = 0; i < numbers.length; i++) {
            results[i] = convert(numbers[i]);
        }
        
        return results;
    }
}