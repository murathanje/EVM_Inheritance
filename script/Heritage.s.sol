// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Heritage.sol";

contract HeritageDeploymentScript is Script {
    function deployInheritance(IERC20 _token) public {
        Heritage.Inheritance inheritance = new Heritage.Inheritance(_token);
        console.log("Inheritance contract deployed to:", address(inheritance));
    }

    function run() public {
        // ERC20 token adresini ve diğer gerekli parametreleri burada belirtmelisiniz
        deployInheritance(/*_token=*/ address(0xYourTokenAddressHere));
    }
}