// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./OwnerContract.sol";
import "./LogContract.sol"; 
import "./IFunds.sol";

contract Funds is Owner,Log,IFunds{
    mapping(address => bool) addedDonors;
    mapping(uint => address) index_to_donor;

    uint8 numberOfDonors;
 
    modifier limitAmount(uint amount){
        require(amount <= 1000000000000000000 , "Cannot withdraw more than 1 Ether");
        _;
    }
    function emitLog() override public view returns(address){
        return msg.sender;
    }
    receive() external payable{}
    function addFunds() override external payable{
        if(addedDonors[msg.sender] == false){
            addedDonors[msg.sender] = true;
            index_to_donor[numberOfDonors] = msg.sender;
            numberOfDonors++;
        }
    }
    function transferOwnership(address newOwner) external onlyOwner(){
        owner = newOwner;
    }
    function withdraw(uint amount)external override limitAmount(amount){
        payable(msg.sender).transfer(amount);
    }
    function getDonators() external view returns (address[] memory){
        address [] memory donators = new address [](numberOfDonors);
        for(uint i = 0; i<numberOfDonors; i++){
            donators[i] = index_to_donor[i];
        }
        return donators;
    }
}

//const instance = await Funds.deployed()
// instance.addFunds({value:"10000000000000000",from:accounts[1]})
//instance.withdraw("10000000000000000",{from:accounts[1]})