// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Token
 * @dev A simple ERC20 token contract that extends OpenZeppelin's ERC20 implementation.
 * This contract allows for the creation of a custom ERC20 token with a predefined initial supply.
 * The initial supply of tokens is minted to the deployer's address upon contract deployment.
 *
 * Features:
 * - **Initial Supply:** Upon deployment, a specified amount of tokens is minted to the deployer's address.
 */

contract Token is ERC20 {
    /**
     * @dev Constructor sets the name, symbol, and initial supply of the token upon deployment.
     * The initial supply is minted to the deployer's address in wei units.
     * @param name Name of the token.
     * @param symbol Symbol of the token.
     * @param initialSupply Initial supply of tokens, specified in the smallest unit of the token (e.g., wei for Ether-based tokens).
     */
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        // Convert the initial supply amount from the smallest unit (like wei for Ether) to the standard unit (like Ether)
        uint256 initialSupplyInWei = initialSupply * 1e18;

        // Mint the initial supply of tokens to the deployer's address.
        _mint(msg.sender, initialSupplyInWei);
    }
}