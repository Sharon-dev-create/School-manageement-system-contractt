//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract schoolToken {
    string public name = "School Token";
    string public symbol = "SCT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;
    address public registry;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    constructor(uint256 _initialSupply){
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyRegistry(){
        require(msg.sender == registry, "Only registry");
        _;
    }

    function setRegistry(address _registry) external onlyOwner{
        require(_registry != address(0), "Invalid registry");
        registry = _registry;
    }

    function mint(address _to, uint256 _value) external onlyRegistry{
        require(_to != address(0), "Invalid address");
        uint256 scaled = _value * (10 ** uint256(decimals));
        totalSupply += scaled;
        balanceOf[_to] += scaled;
        emit Mint(_to, scaled);
        emit Transfer(address(0), _to, scaled);
    }

    function burn(address _from, uint256 _value) external onlyRegistry{
        require(_from != address(0), "Invalid address");
        uint256 scaled = _value * (10 ** uint256(decimals));
        require(balanceOf[_from] >= scaled, "Insufficient balance to burn");
        balanceOf[_from] -= scaled;
        totalSupply -= scaled;
        emit Burn(_from, scaled);
        emit Transfer(_from, address(0), scaled);
    }

    function transfer(address _to, uint256 _value) public returns(bool){
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns(bool){
        require(_spender != address(0), "Invalid address");

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
        require(_from != address(0), "Invalid from address");
        require(_to != address(0), "Invalid to address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }
}