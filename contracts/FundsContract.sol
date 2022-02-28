// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Funds{
    mapping(address => bool) addedDonors;
    mapping(uint => address) index_to_donor;

    uint8 numberOfDonors;
    receive() external payable{}
    function addFunds() external payable{
        if(addedDonors[msg.sender] == false){
            addedDonors[msg.sender] = true;
            index_to_donor[numberOfDonors] = msg.sender;
            numberOfDonors++;
        }
    }
    function getDonators() external view returns (address[] memory){
        address [] memory donators = new address [](numberOfDonors);
        for(uint i = 0; i<numberOfDonors; i++){
            donators[i] = index_to_donor[i];
        }
        return donators;
    }
}