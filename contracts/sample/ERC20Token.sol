// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract ERC20Token {
    event Mint(address addr_, uint256 value);

    event Transfer(address from, address to, uint256 value);

    event Approval(address owner, address spender, uint256 value);

    string private name;
    string private symbol;
    address private admin;
    uint256 private totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        admin = msg.sender;
    }

     function mint(uint256 _amount) public onlyAdmin {
        totalSupply += _amount;
        _balances[msg.sender] = _balances[msg.sender] + _amount;
        emit Mint(msg.sender, _amount);
    }

    function getName() public view returns(string memory){
        return name;
    }

    function getSymbol() public view returns(string memory){
        return symbol;
    }

    function getDecimals() public pure  returns (uint8) {
        return 18;
    }

    //代币总数量
     function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    //查询指定账户余额
     function balanceOf(address _addr) public view returns(uint256) {
        return _balances[_addr];
    } 

    //普通转账
    function transfer(address to, uint _amount) public returns(bool){
        address owner = msg.sender;
        _transfer(owner, to, _amount);
        return true;
    }

    //一个账户到另外一个账户转账
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    //代理转账，须先检查身份授权较验
    function approve(address spender, uint256 _amount) public returns(bool){
        address owner = msg.sender;
        _approve(owner, spender, _amount);
        emit Approval(owner, spender, _amount);
        return true;
    }

    //代理转账
    function transferFrom(address from, address to, uint256 _amount) public returns(bool){
        address spender = msg.sender;
        _spendAllowance(from, spender, _amount);
        _transfer(from, to, _amount);
        return true;
    }

    //查询指定账号授权金额
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
   
    //消耗指定账号代转账授信金额 
    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    //更新授权金额
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    //合约部署者身份
    modifier onlyAdmin {
        require(msg.sender == admin, "Only owner can call this");
        _;
    }
}
