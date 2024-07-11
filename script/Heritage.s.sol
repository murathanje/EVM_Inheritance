// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Heritage.sol";
import "../src/Token.sol";

/**
 * @title HeritageDeploymentScript
 * @dev A deployment script for the Heritage contract, utilizing Foundry's forge-std library for testing purposes.
 * This script demonstrates the setup and interaction with the Heritage contract, including token deployment, setting heirs, claiming inheritance, and checking balances.
 * It showcases the process of deploying a custom ERC20 token, approving it for use within the Heritage contract, and performing inheritance operations.
 *
 * Features:
 * - Deploys a custom ERC20 token named "Test" with symbol "TT".
 * - Deploys the Heritage contract with the newly created token.
 * - Simulates setting a heir and claiming inheritance through direct calls to the contract methods.
 * - Utilizes Foundry's VM functionalities for testing, such as broadcasting transactions and impersonating accounts.
 */

contract HeritageDeploymentScript is Script {
    Token token;
    address owner;
    address heir;
    Inheritance inheritance;

    /**
     * @dev Initializes the testing environment by deploying contracts and setting initial conditions.
     * Deploys a new ERC20 token and the Heritage contract. Approves the Heritage contract to spend tokens on behalf of the deployer.
     */
    function setUp() public {

        uint256 privateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        // Deploy a new ERC20 token named "Test" with symbol "TT" and an initial supply of 100 tokens.
        token = new Token("Test", "TT", 100);
        console.log("Token contract deployed to:", address(token));

        // Deploy the Heritage contract with the newly created token.
        inheritance = new Inheritance(token);
        console.log("Inheritance contract deployed to:", address(inheritance));

        // Approve the Heritage contract to spend 50 tokens on behalf of the deployer.
        token.approve(address(inheritance), 50 *(10**18));
    }

    /**
     * @dev Executes the main logic of the script, simulating inheritance operations.
     * Sets predefined addresses for owner and heir, then performs setting a heir and claiming inheritance actions.
     * Utilizes Foundry's VM for transaction broadcasting and account impersonation to simulate real-world interactions.
     */
    function run() public {
        owner = 0x97E7f2B08a14e4C0A8Dca87fbEB1F68b397c91df; // Predefined owner address
        heir = 0x538D8F0c878ff754cbc08D80DdAdF08BF7f6bEC7; // Predefined heir address

        // Set the heir for the owner and specify an inheritance amount.
        _setHeir(heir, 50*(10**18));
        console.log("setHeir yapildi");
        // Check the initial balances of the owner and heir.
        checkBalance(owner);
        checkBalance(heir);

        vm.stopBroadcast(); // Stop broadcasting transactions to simulate a pause in actions.

        // Retrieve a private key from the environment variables to simulate another account.
        uint256 privateKey = vm.envUint("CONTINUOUS_PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        // Attempt to claim inheritance as the heir.
        claim(owner, 50*(10**18));
        console.log("Claim yapildi");

        // Check balances after claiming inheritance.
        checkBalance(owner);
        checkBalance(heir);

        vm.stopBroadcast(); // Stop impersonating the account.
    }

    /**
     * @dev Wrapper function to call the setHeir method of the Heritage contract.
     * @param _heir Address of the heir to be set.
     * @param _amount Amount of tokens to be inherited.
     */
    function _setHeir(address _heir, uint256 _amount) private {
        inheritance.setHeir(_heir, _amount);
    }

    /**
     * @dev Wrapper function to call the claimInheritance method of the Heritage contract.
     * @param _owner Address of the owner whose inheritance is being claimed.
     * @param _amount Amount of tokens to claim.
     */
    function claim(address _owner, uint256 _amount) private {
        inheritance.claimInheritance(_owner, _amount);
    }

    /**
     * @dev Checks and logs the balance of a given address.
     * @param _owner Address whose token balance is checked.
     */
    function checkBalance(address _owner) private view {
        uint256 amount = token.balanceOf(_owner); // Retrieve the token balance of the specified address.
        console.log(_owner, "balance is:", amount); // Log the balance to the console.
    } 
}