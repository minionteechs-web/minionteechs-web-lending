// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {WebLending} from "../src/Lending.sol";

/**
 * @title Deploy
 * @dev Deploy script for WebLending contract
 * 
 * Usage:
 *   - Local: forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
 *   - Testnet: forge script script/Deploy.s.sol --rpc-url <RPC_URL> --private-key <PK> --broadcast --verify
 */
contract Deploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the lending contract
        WebLending lending = new WebLending();

        vm.stopBroadcast();

        // Log the deployed address
        if (block.chainid == 31337) {
            // Anvil/Hardhat local
            string memory chainName = "Local (Anvil)";
        } else if (block.chainid == 11155111) {
            // Sepolia
            chainName = "Sepolia";
        } else if (block.chainid == 1) {
            // Mainnet
            chainName = "Ethereum Mainnet";
        }

        string memory deploymentInfo = string(
            abi.encodePacked(
                "\n=== WebLending Deployment ===\n",
                "Chain: ",
                chainName,
                "\n",
                "WebLending: ",
                vm.toString(address(lending)),
                "\n"
            )
        );

        emit log_string(deploymentInfo);
    }
}
