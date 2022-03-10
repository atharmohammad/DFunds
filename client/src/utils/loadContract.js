import axios from "axios"
import contract from "@truffle/contract"

export const loadContract = async(name,provider)=>{
    const res = await axios.get(`/contracts/${name}.json`);
    const _contract = contract(res.data);
    _contract.setProvider(provider);
    let deployedContract ;
    try{
        deployedContract = await _contract.deployed(); 
    }catch{
        console.log("Can't connect to network");
    }
    return deployedContract;
}