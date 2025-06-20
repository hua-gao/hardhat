const { expect } = require("chai");

beforeEach(async function () {
  // 获取合约工厂
  MyContract = await ethers.getContractFactory("MyContract");

  // 部署合约
  myContract = await MyContract.deploy(0); // 初始化值为 100
  await myContract.waitForDeployment();
});


describe("MyContract", function () {
  it("Should add amount", async function () {

    await myContract.addAmount(5);
    expect(await myContract.getAmout()).to.equal(5);
  });
});