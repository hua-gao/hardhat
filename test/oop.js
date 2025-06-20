const { expect } = require("chai");


beforeEach(async function () {
  // 获取合约工厂
  ContractFactory = await ethers.getContractFactory("Test");

  // 部署合约
  contract = await ContractFactory.deploy();
  await contract.waitForDeployment();
});


describe("Main", function () {
  it("Should sheep eat the grass", async function () {
    console.log(await contract.testMain());
    expect(await contract.testMain()).to.equal("grass");
  });
});