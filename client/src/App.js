import './App.css';
import Web3 from "web3";
import {useState,useEffect,useCallback} from "react"
import {loadContract} from "./utils/loadContract"

function App() {

  const [web3Api,setWeb3Api] = useState({
    provider:null,
    web3:null,
    contract:null
  });

  const [account,setAccount] = useState(null);
  const [balance,setBalance] = useState(null);

  const setAccountListener = provider=>{
    provider.on("accountsChanged",accounts=>setAccount(accounts[0]));
  }

  useEffect(()=>{
    const loadProvider = async()=>{
      let provider = null;
      if(window.ethereum){
        provider = window.ethereum;
      }else if(window.web3){
        provider = window.web3.currentProvider;
      }else if(!process.env.production){
        provider = new Web3.providers.HttpProvider("http://127.0.0.1:7545");
      }
      setAccountListener(provider)
      const contract = await loadContract("Funds",provider);
      console.log(contract)
      setWeb3Api({
        web3:new Web3(provider),
        provider,
        contract
      })
    }
    loadProvider();
  },[])

  useEffect(()=>{
    const getAccounts = async()=>{
      const accounts = await web3Api.web3.eth.getAccounts();
      setAccount(accounts[0]);
    }
    web3Api.web3 && getAccounts();
  },[web3Api.web3])

  useEffect(()=>{
    const loadBalance = async()=>{
      const {contract,web3} = web3Api;
      const balance = await web3.eth.getBalance(contract.address);
      setBalance(web3.utils.fromWei(balance,"ether"))
    }
    web3Api.contract && loadBalance()
  },[web3Api])

  const handleDonation = useCallback(async()=>{
    const {contract,web3} = web3Api;
    contract.addFunds({from:account,value:"1000000000000000"})
    window.location.reload();
  },[web3Api,account])

  const handleWithdrawal = useCallback(async()=>{
    const {contract,web3} = web3Api;
    contract.withdraw("1000000000000000",{from:account});
    window.location.reload();
  },[web3Api,account])

  return (
    <div className="App">
      <h3>{!account ? <button onClick={async()=>web3Api.provider.request({method:"eth_requestAccounts"})}>Connect</button> : account}</h3>
      <h2>Current Balance is {balance} Eth</h2>
      <button onClick={handleDonation}>Donate</button>
      <button onClick={handleWithdrawal}>Withdraw</button>
    </div>
  );
}

export default App;
