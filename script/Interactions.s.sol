// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.30;
import {Script , console} from "forge-std/Script.sol";
import {HelperConfig,Codeconstants} from "../script/HelperConfig.s.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";



contract CreateSubscription is Script{
    function CreateSubscriptionUsingConfig()public returns(uint256 , address){
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        address account = helperConfig.getConfig().account;
         (uint256 subId,) = createSubscription(vrfCoordinator,account);
        return (subId , vrfCoordinator);

    }

    function createSubscription(address vrfCoordinator , address account) public returns(uint256 , address){

        console.log("Creating subscription on chain id:", block.chainid);
        vm.startBroadcast(account);
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription Id is :" , subId);
        console.log("Please update the subcription id in your HelperConfig.s.sol");
        return (subId , vrfCoordinator);
    }


    function run() public{
        CreateSubscriptionUsingConfig();
    }

}

contract FundSubscription is Script,Codeconstants{
    uint256 public constant FUND_AMOUNT = 3 ether;
    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        address account = helperConfig.getConfig().account;
        fundSubscription(vrfCoordinator , subscriptionId,linkToken,account);

    }
    function fundSubscription(address vrfCoordinator , uint256 subscriptionId,address linkToken , address account) public{
        console.log("Funding subscription :" , subscriptionId);
        console.log("Using vrfCoordinator: ",vrfCoordinator);
        console.log("On ChainId: ",block.chainid);
        if(block.chainid ==LOCAL_CHAIN_ID){
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(subscriptionId, FUND_AMOUNT*100);
            vm.stopBroadcast();
        }
        else{
            vm.startBroadcast();
            LinkToken(linkToken).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subscriptionId));
            vm.stopBroadcast();
        }
    }
    function  run() public{
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {

    function addConsumerUsingConfig(address mostRecentyDeployed) public {
       HelperConfig helperConfig = new HelperConfig();
       uint256 subId =  helperConfig.getConfig().subscriptionId;
       address vrfCoordinator =  helperConfig.getConfig().vrfCoordinator;
       address account = helperConfig.getConfig().account;

       addConsumer(mostRecentyDeployed, vrfCoordinator, subId, account);

    }

    function addConsumer(address contractToAdtoVrf, address vrfCoordinator , uint256 subId , address account) public{
        console.log("Adding consumer contract:" ,contractToAdtoVrf );
        console.log("To vrfCoordinator:" , vrfCoordinator);
        console.log("On ChainId :" , block.chainid);
        vm.startBroadcast(account);
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subId, contractToAdtoVrf);
        vm.stopBroadcast();
    }

    function run() external{
        address mostRecentyDeployed = DevOpsTools.get_most_recent_deployment("Raffle", block.chainid);
        addConsumerUsingConfig(mostRecentyDeployed);
    }

}