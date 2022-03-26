// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./AdminContract.sol";
import "./LogContract.sol"; 
import "./IFunds.sol";

contract Funds is Admin,Log,IFunds{
    
    struct Fundraiser{
        string name;
        string description;
        uint amount;
        address creator;
        bool stopped;
    }

    mapping(uint => Fundraiser) Fundraisers;
    mapping(uint => mapping(address => bool)) addedDonors;
    mapping(uint => mapping(uint => address)) index_to_donor;
    mapping(uint => uint) Fundraisers_to_Funds;
    uint [] numberofDonors;
    uint numberOfFundraisers;
 
    modifier limitAmount(uint totalFunds,uint amount){
        require(amount <= totalFunds , "Cannot withdraw more than Total Funds");
        _;
    }
    modifier onlyFundraiserOwner(uint fundraiser){
        require(Fundraisers[fundraiser].creator == msg.sender , "UnAuthorised !");
        _;
    }

    function emitLog() override public view returns(address){
        return msg.sender;
    }

    function createFundraiser(string memory name , string memory description , uint targetAmount)external{
        Fundraisers[numberOfFundraisers].name = name;
        Fundraisers[numberOfFundraisers].description = description; 
        Fundraisers[numberOfFundraisers].amount = targetAmount; 
        Fundraisers[numberOfFundraisers].creator = msg.sender; 
        numberofDonors.push(0);
        numberOfFundraisers++;
    }

    function getFundraisers()external view returns (Fundraiser[] memory){
        Fundraiser [] memory fundraisers = new Fundraiser [](numberOfFundraisers);
        for (uint i = 0 ;i<numberOfFundraisers; i++){
            fundraisers[i] = Fundraisers[i];
        }
        return fundraisers;
    }

    function withdraw(uint amount,uint fundraiser)external override onlyFundraiserOwner(fundraiser) limitAmount(Fundraisers_to_Funds[fundraiser],amount){
        payable(msg.sender).transfer(amount);
        Fundraisers_to_Funds[fundraiser] -= amount;
    }

    function addFunds(uint fundraiser) override external payable{
        if(addedDonors[fundraiser][msg.sender] == false){
            addedDonors[fundraiser][msg.sender] = true;
            Fundraisers_to_Funds[fundraiser] = Fundraisers_to_Funds[fundraiser] + msg.value;
            index_to_donor[fundraiser][numberofDonors[fundraiser]] = msg.sender;
            numberofDonors[fundraiser]++;
        }
    }
    // function transferOwnership(address newOwner) external onlyOwner(){
    //     owner = newOwner;
    // }
    function getDonatorsOfFundraiser(uint fundraiser) external view returns (address[] memory){
        address [] memory donators = new address [](numberofDonors[fundraiser]);
        for(uint i = 0; i<numberofDonors[fundraiser]; i++){
            donators[i] = index_to_donor[fundraiser][i];
        }
        return donators;
    }

    function stopFunding(uint fundraiser) external onlyCreatorOrAdmin(Fundraisers[fundraiser].creator){
        Fundraisers[fundraiser].stopped = true;
    }

    function startFunding(uint fundraiser) external onlyAdmin(){
        Fundraisers[fundraiser].stopped = false;
    }
}

//const instance = await Funds.deployed()
// instance.addFunds({value:"10000000000000000",from:accounts[1]})
//instance.withdraw("10000000000000000",{from:accounts[1]})