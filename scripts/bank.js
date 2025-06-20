const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const ContractFactory = await ethers.getContractFactory("Bank");
  const contract = await ContractFactory.deploy(0);

  await contract.waitForDeployment(); // 等待合约部署完成
  console.log("Contract deployed to:", await  contract.getAddress());

  //0001存钱
  await contract.deposit("000001", 100);

  //查看0001存钱账户余额
  let accountBanlance = await contract.getAccountBalance("000001");
  console.log("000001 acountBanlance:", accountBanlance);
  
   //0002存钱
   await contract.deposit("000002", 350);

   //查看0001存钱账户余额
   accountBanlance = await contract.getAccountBalance("000002");
   console.log("000002 acountBanlance:", accountBanlance);

  //查看合约总余额
  const banlance = await contract.getBalance();
  console.log("acountBanlance:", banlance);


  //测试取款
  await contract.withdraw("000002", 18);

  //测试取款后的余额
  accountBanlance = await contract.getAccountBalance("000002");
  console.log("000002 acountBanlance:", accountBanlance);

  //测试取款后的总余额
  accountBanlance = await contract.getBalance();
  console.log("acountBanlance:", accountBanlance);

  console.log("finish");

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment process error:", error);
    process.exit(1);
  });