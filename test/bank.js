const { expect } = require("chai");


beforeEach(async function () {
  // 获取合约工厂
  BankFactory = await ethers.getContractFactory("Bank");

  // 部署合约
  myContract = await BankFactory.deploy(0); // 初始化值为0
  await myContract.waitForDeployment();
});


describe("Bank Operation", function () {
  it("Should deposit account1", async function () {
    await myContract.deposit("000001", 100);
    expect(await myContract.getAccountBalance("000001")).to.equal(100);
    expect(await myContract.getBalance()).to.equal(100);
  });

  it("Should deposit account2", async function () {
    await myContract.deposit("000002", 150);
    expect(await myContract.getAccountBalance("000002")).to.equal(150);
    expect(await myContract.getBalance()).to.equal(150);
  });

  // it("Should bank balance", async function () {
  //   expect(await myContract.getBalance()).to.equal(0);
  // });

  it("Should withdraw", async function () {
    await myContract.withdraw("000001", 20);
    await myContract.withdraw("000001", 30);
    expect(await myContract.getAccountBalance("000001")).to.equal(50);

    expect(await myContract.withdraw("000001", 60)).to.be.revertedWith("not enouth money")
  });
});