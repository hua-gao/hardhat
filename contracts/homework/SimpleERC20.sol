// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleERC20 {
    string public name = "SimpleToken"; // 代币名称（例如显示在钱包里）
    string public symbol = "JJT"; // 代币符号（简称）
    uint8 public decimals = 18; // 小数精度（通常18位）
    uint256 public totalSupply; // 总供应量

    address public owner; // 合约的拥有者（只有拥有者可以铸造mint）

    mapping(address => uint256) private balances; // 每个地址持有的代币数量
    mapping(address => mapping(address => uint256)) private allowances; // 某个地址授权其他地址可以使用的金额

    // 以下两个事件是ERC20标准中必须要有的
    event Transfer(address indexed from, address indexed to, uint256 value); // 代币转账时触发的事件
    event Approval(address indexed owner, address indexed spender, uint256 value); // 授权操作时触发的事件

    constructor() {
        owner = msg.sender; // 构造函数中，将部署者设置为合约拥有者
    }

    modifier onlyOwner() { // onlyOwner 是一个修饰符，确保函数只能被合约拥有者调用。
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // 查询余额（提供某个地址的当前余额。）
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // 转账函数
    // 1.当前调用者将代币转给 to。
    // 2.检查余额和目标地址是否合法。
    // 3.更新余额并发出 Transfer 事件。
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // 授权和转账
    // approve: 授权 spender 使用我（调用者）的一部分代币。
    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // allowance: 查询授权额度。
    function allowance(address tokenOwner, address spender) public view returns (uint256) {
        return allowances[tokenOwner][spender];
    }

    //  扣款转账
    // 第三方（比如 DApp 合约）可以通过这个函数从 from 地址扣款，前提是已经获得授权。
    // 常用于交易所、DeFi 中代币流转。
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        require(balances[from] >= amount, "Insufficient balance");
        require(allowances[from][msg.sender] >= amount, "Not allowed");

        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // 铸造（Mint）
    // 1.只能由合约拥有者调用。
    // 2.给某个地址新增代币，并更新 totalSupply。
    // 3.Transfer 中的 from 地址为 address(0)，代表“从无到有”的铸造。
    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        totalSupply += amount;
        balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }
}