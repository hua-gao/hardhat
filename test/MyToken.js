const { ethers } = require("hardhat")

const { expect } = require("chai")

let contract,adress
let account1, acount2;

describe("test the MyToken contract", async()=>{

    beforeEach(async()=>{
        [account1, account2] = await ethers.getSigners()
        //console.log("account1:", account1, "account2:", account2)
        let ContractFactory = await ethers.getContractFactory("MyToken")
        contract = await ContractFactory.deploy()
        contract.waitForDeployment()

        adress = await contract.getAddress()
        expect(adress).to.length.greaterThanOrEqual(0)
        console.log("contract deploy address is : ", adress)
    })

    it("test1", async()=>{
        console.log("this is test1");
        var tokenName = await contract.name()
        var tokenSynbol = await contract.symbol()
        console.log("tokenName:", tokenName);
        console.log("tokenSynbol:", tokenSynbol);
        expect(tokenName).to.equal("MyToken");
        expect(tokenSynbol).to.length.greaterThan(0);


        let balance1 = await contract.balanceOf(account1)
        console.log("balance2:", balance1)

        let balance2 = await contract.balanceOf(account2)
        console.log("balance2:", balance2)
    })


    it("test2", async()=>{

        console.log("this is test2");
    })
})