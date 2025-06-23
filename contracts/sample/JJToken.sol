// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract JJToken is ERC20{
    address admin;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor() ERC20("JJToken", "JTK"){
        admin = msg.sender;
    }

    function toMint(uint256 amount) external{
        require(amount > 0, "amount must be larger than 0");
        _mint(admin, amount);
    }
}
