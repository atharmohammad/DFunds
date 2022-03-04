// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
  
abstract contract Log {
    uint public testNum;
    constructor(){
        testNum = 1000;
    }
    function test()virtual pure public returns(uint){}
    function emitLog() virtual view public returns(address){}
}