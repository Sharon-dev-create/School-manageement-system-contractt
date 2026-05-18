//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract NftReward {
    string public name;
    string public symbol;
    address public owner;
    address public registry;
    uint256 private nextTokenId;

    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => address) public tokenApprovals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;
    mapping(uint256 => string) private _tokenURIs;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event NftRewarded(address indexed to, uint256 indexed tokenId, string uri);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyRegistry() {
        require(msg.sender == registry, "Only registry");
        _;
    }

    constructor(address _registry, string memory _name, string memory _symbol) {
        require(_registry != address(0), "Invalid registry");
        require(bytes(_name).length > 0, "Empty name");
        require(bytes(_symbol).length > 0, "Empty symbol");

        owner = msg.sender;
        registry = _registry;
        name = _name;
        symbol = _symbol;
    }

    function setRegistry(address _registry) external onlyOwner {
        require(_registry != address(0), "Invalid registry");
        registry = _registry;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenURIs[tokenId];
    }

    function mintReward(address to, string calldata uri) external onlyRegistry returns (uint256) {
        require(to != address(0), "Invalid address");
        require(bytes(uri).length > 0, "Empty token URI");

        nextTokenId += 1;
        uint256 tokenId = nextTokenId;

        ownerOf[tokenId] = to;
        balanceOf[to] += 1;
        _tokenURIs[tokenId] = uri;

        emit Transfer(address(0), to, tokenId);
        emit NftRewarded(to, tokenId, uri);
        return tokenId;
    }

    function approve(address spender, uint256 tokenId) external {
        address tokenOwner = ownerOf[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        require(spender != tokenOwner, "Approval to current owner");
        require(msg.sender == tokenOwner || isApprovedForAll[tokenOwner][msg.sender], "Not authorized");

        tokenApprovals[tokenId] = spender;
        emit Approval(tokenOwner, spender, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(operator != msg.sender, "Approval to caller");
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not authorized to transfer");
        require(ownerOf[tokenId] == from, "From address is not owner");
        require(to != address(0), "Invalid to address");

        _transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) external {
        address tokenOwner = ownerOf[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not authorized to burn");

        _clearApproval(tokenId);
        balanceOf[tokenOwner] -= 1;
        delete ownerOf[tokenId];
        delete _tokenURIs[tokenId];

        emit Transfer(tokenOwner, address(0), tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        _clearApproval(tokenId);

        ownerOf[tokenId] = to;
        balanceOf[from] -= 1;
        balanceOf[to] += 1;

        emit Transfer(from, to, tokenId);
    }

    function _clearApproval(uint256 tokenId) internal {
        if (tokenApprovals[tokenId] != address(0)) {
            delete tokenApprovals[tokenId];
        }
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return ownerOf[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address tokenOwner = ownerOf[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return (spender == tokenOwner || tokenApprovals[tokenId] == spender || isApprovedForAll[tokenOwner][spender]);
    }
}
