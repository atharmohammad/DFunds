// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Admin{
    address public admin;

    constructor(){
        admin = msg.sender;
    }

    modifier onlyCreatorOrAdmin(address creator){
        require(admin == msg.sender || msg.sender == creator,"Only Owner have access !");
        _;
    }

    modifier onlyAdmin(){
        require(admin == msg.sender,"Only Owner have access !");
        _;
    }
}