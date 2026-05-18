//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract schoolToken {
    string public name = "School Token";
    string public symbol = "SCT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    constructor(uint256 _initialSupply){
        totalSupply = _initialSupply * (10 ** uint256(decimals));

        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }
}