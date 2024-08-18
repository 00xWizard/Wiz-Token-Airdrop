// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// @title Wizard Token Contract
// @dev This contract defines the ERC20 token WIZ with minting functionality restricted to the owner.
contract WizardToken is ERC20, Ownable {
    // @dev Constructor that mints the initial supply of the WIZ token.
    constructor() ERC20("Wizard", "WIZ") Ownable(msg.sender) {}

    // @dev Function to mint new WIZ tokens. Only the owner can call this function.
    // @param to The address to receive the newly minted tokens.
    // @param amount The number of tokens to mint.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
