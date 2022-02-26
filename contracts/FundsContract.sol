// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Funds{
    address[] public donators ;
    receive() external payable{}
    function addFunds() external payable{
        donators.push(msg.sender);
    }
}