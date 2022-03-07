import axios from "axios"
import contract from "@truffle/contract"

export const loadContract = async(name,provider)=>{
    const res = await axios.get(`/contracts/${name}.json`);
    const _contract = contract(res.data);
    _contract.setProvider(provider);
    const deployedContract = await _contract.deployed(); 
    return deployedContract;
}