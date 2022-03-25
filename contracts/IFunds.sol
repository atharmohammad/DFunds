// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IFunds{
    function addFunds(uint fundraiser) external payable;
    function withdraw(uint amount,uint fundraiser)external;
}