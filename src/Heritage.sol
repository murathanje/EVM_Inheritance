// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Inheritance
 * @dev This contract manages the inheritance of ERC20 tokens from an owner to a designated heir. It allows an owner to set a heir and specify an amount of tokens to be inherited. 
 * The heir can then claim these tokens under certain conditions. The contract interacts with any ERC20 compliant token.
 *
 * Features:
 * - Setting a Heir: Owners can designate a heir and specify an amount of tokens to be inherited.
 * - Claiming Inheritance: The designated heir can claim the inherited tokens once the conditions are met.
 * - Events: Emitted for setting a heir and claiming inheritance for transparency.
 */

contract Inheritance {
    struct InheritanceInfo {
        address heir; // The address of the heir who will inherit the tokens.
        address owner; // The address of the owner who sets the inheritance.
        uint256 amount; // The amount of tokens to be inherited.
        bool isSet; // Indicates if the inheritance is set for the owner.
    }

    IERC20 public token; // The instance of the ERC20 token being inherited.
    mapping(address => InheritanceInfo) public inheritances; // Maps owner addresses to their InheritanceInfo.

    event HeirSet(address indexed owner, address indexed heir, uint256 amount); // Emitted when a heir is set.
    event InheritanceClaimed(address indexed heir, address indexed owner, uint256 amount); // Emitted when inheritance is claimed.

    /**
     * @dev Constructor initializes the contract with the ERC20 token to be used for inheritance.
     * @param _token The address of the ERC20 token contract.
     */
    constructor(IERC20 _token) {
        token = _token;
    }

    /**
     * @dev Allows an owner to set a heir and specify an amount of tokens to be inherited.
     * Requires the owner to have approved the contract to spend the specified amount of tokens.
     * @param _heir The address of the heir.
     * @param _amount The amount of tokens to be inherited.
     */
    function setHeir(address _heir, uint256 _amount) external {
        require(!inheritances[msg.sender].isSet, "Heir is already set for this owner"); // Checks if a heir is not already set.
        require(_heir != address(0), "Invalid heir address"); // Ensures the heir address is valid.
        require(_amount > 0, "Amount must be greater than zero"); // Ensures the amount is positive.
        require(token.allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance"); // Checks allowance is sufficient.

        inheritances[msg.sender] = InheritanceInfo({
            heir: _heir,
            owner: msg.sender,
            amount: _amount,
            isSet: true
        });

        emit HeirSet(msg.sender, _heir, _amount);
    }

    /**
     * @dev Allows the designated heir to claim their inheritance.
     * Checks conditions such as heir being set, caller being the heir, sufficient balance, etc.
     * Transfers the inherited amount from the owner to the heir.
     * @param _owner The address of the owner whose inheritance is being claimed.
     * @param _amount The amount of tokens to claim.
     */
    function claimInheritance(address _owner, uint256 _amount) external {
        InheritanceInfo storage inheritance = inheritances[_owner];
        
        require(inheritance.isSet, "Heir is not set for this owner"); // Ensures a heir is set.
        require(msg.sender == inheritance.heir, "Only the designated heir can withdraw"); // Ensures only the heir can claim.
        require(inheritance.amount >= _amount, "Insufficient inheritance amount"); // Ensures sufficient inheritance amount.
        require(token.balanceOf(_owner) >= _amount, "Insufficient balance"); // Ensures owner has enough tokens.

        require(token.transferFrom(_owner, msg.sender, _amount), "Transfer failed"); // Transfers tokens from owner to heir.

        inheritance.amount -= _amount; // Deducts claimed amount from inheritance info.

        emit InheritanceClaimed(msg.sender, _owner, _amount);
    }
}