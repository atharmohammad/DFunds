import './App.css';
import Web3 from "web3";
import {useState,useEffect,useCallback} from "react"
import {loadContract} from "./utils/loadContract"

function App() {

  const [web3Api,setWeb3Api] = useState({
    provider:null,
    web3:null,
    contract:null,
    isProviderLoaded:false
  });

  const [account,setAccount] = useState(null);
  const [balance,setBalance] = useState(null);
  const canConnectToNetWork = account && web3Api.contract ;

  const setAccountListener = provider=>{
    provider.on("accountsChanged",accounts=>window.location.reload());
    provider.on("chainChanged",res=>window.location.reload());
    // provider._jsonRpcConnection.events.on("notification",payload=>{
    //   const {method} = payload;

    //   if(method == "metamask_unlockStateChanged" && account){
    //     setAccount(null);
    //   }
    // })
  }

  useEffect(()=>{
    const loadProvider = async()=>{
      let provider = null;
      if(window.ethereum){
        provider = window.ethereum;
      }else if(window.web3){
        provider = window.web3.currentProvider;
      }
      if(provider){
        setAccountListener(provider)
        const contract = await loadContract("Funds",provider);
        setWeb3Api({
          web3:new Web3(provider),
          provider,
          contract,
          isProviderLoaded:true
        })
      }else{
        setWeb3Api(prev=>({
          ...prev,
          isProviderLoaded:true
        }))
      }
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
    await contract.addFunds({from:account,value:"1000000000000000"})
    window.location.reload();
  },[web3Api,account])

  const handleWithdrawal = useCallback(async()=>{
    const {contract,web3} = web3Api;
    await contract.withdraw("1000000000000000",{from:account});
    window.location.reload();
  },[web3Api,account])



  return (
    <div className="App">
    {!web3Api.isProviderLoaded ? <p>...Loading ! </p> : (
      !web3Api.provider ? <p>No Wallet Found ! Install MetaMask</p> :
      <>
        <h3>{!account ? <button onClick={async()=>web3Api.provider.request({method:"eth_requestAccounts"})}>Connect</button> : account}</h3>
        <h2>Current Balance is {balance} Eth</h2>
        <button onClick={handleDonation} disabled={!canConnectToNetWork}>Donate</button>
        <button onClick={handleWithdrawal} disabled={!canConnectToNetWork}>Withdraw</button>
        {!canConnectToNetWork ? <p>Connect to Ganache Netwok !</p> : null}
      </>
    )}
    </div>
  );
}

export default App;
