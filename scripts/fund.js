const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const ContractFactory = await ethers.getContractFactory("FundMe");
  const fundMe = await ContractFactory.deploy(120);

  await fundMe.waitForDeployment(); // 等待合约部署完成
  console.log("Contract deployed to:", await  fundMe.getAddress());

// init 2 accounts
const [firstAccount, secondAccount] = await ethers.getSigners()
console.log(`2 accounts are ${firstAccount.address} and ${secondAccount.address}`)


// fund contract with first account
const fundTx = await fundMe.fund({value: ethers.parseEther("0.004")})
await fundTx.wait()

// check balance of contract
const balanceOfContract = await ethers.provider.getBalance(fundMe.target)
console.log(`Balance of the contract is ${balanceOfContract}`)

// fund contract with second account
const fundTxWithSecondAccount = await fundMe.connect(secondAccount).fund({value: ethers.parseEther("0.004")})
await fundTxWithSecondAccount.wait()

// check balance of contract
const balanceOfContractAfterSecondFund = await ethers.provider.getBalance(fundMe.target)
console.log(`Balance of the contract is ${balanceOfContractAfterSecondFund}`)

// check mapping 
const firstAccountbalanceInFundMe = await fundMe.fundersToAmount(firstAccount.address)
const secondAccountbalanceInFundMe = await fundMe.fundersToAmount(secondAccount.address)
console.log(`Balance of first account ${firstAccount.address} is ${firstAccountbalanceInFundMe}`)
console.log(`Balance of second account ${secondAccount.address} is ${secondAccountbalanceInFundMe}`)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment process error:", error);
    process.exit(1);
  });

  