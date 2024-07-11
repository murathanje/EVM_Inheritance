// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Inheritance {
    struct InheritanceInfo {
        address heir;
        address owner;
        uint256 amount;
        bool isSet;
    }

    ERC20 public token;
    mapping(address => InheritanceInfo) public inheritances;

    event HeirSet(address indexed owner, address indexed heir, uint256 amount);
    event InheritanceClaimed(address indexed heir, address indexed owner, uint256 amount);

    constructor(ERC20 _token) {
        token = _token;
    }

    function setHeir(address _heir, uint256 _amount) external {
        require(!inheritances[msg.sender].isSet, "Heir is already set for this owner");
        require(_heir != address(0), "Invalid heir address");
        require(_amount > 0, "Amount must be greater than zero");

        token.approve(address(this), _amount);

        inheritances[msg.sender] = InheritanceInfo({
            heir: _heir,
            owner: msg.sender,
            amount: _amount,
            isSet: true
        });

        emit HeirSet(msg.sender, _heir, _amount);
    }

    function claimInheritance(address _owner, uint256 _amount) external {
        InheritanceInfo storage inheritance = inheritances[_owner];
        
        require(inheritance.isSet, "Heir is not set for this owner");
        require(msg.sender == inheritance.heir, "Only the designated heir can withdraw");
        require(inheritance.amount >= _amount, "Insufficient inheritance amount");
        require(token.balanceOf(_owner) >= _amount, "Insufficient balance");

        token.transferFrom(_owner, msg.sender, _amount);

        inheritance.amount -= _amount;

        emit InheritanceClaimed(msg.sender, _owner, _amount);
    }
}