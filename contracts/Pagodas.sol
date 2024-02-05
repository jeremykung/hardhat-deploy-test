// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Pagodas is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint maxSupply = 2;
    bool public allowListMintOpen = false;
    bool public publicMintOpen = false;
    mapping(address => bool) public allowList;

    constructor(address initialOwner)
        ERC721("Pagodas", "PGDS")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qme2S6N63JWvSdfWaRCWYe4cunaSS5VdAq4bGB9grkRwmR/";
    }

    function contractURI() public pure returns (string memory) {
        return "ipfs://QmTGmAbLp1koAq44hXut8KUnnBabVkrYBJjvVQmNksewSd";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // function safeMint(address to, string memory uri) public onlyOwner {
    //     uint256 tokenId = _nextTokenId++;
    //     _safeMint(to, tokenId);
    //     _setTokenURI(tokenId, uri);
    // }

    function allowListMint() public payable {
        require(msg.value == 0.001 ether, "Not enough funds, requires 0.001 ether");
        require(allowListMintOpen, "Allow list mint is closed.");
        require(allowList[msg.sender], "Address not on allow list. Use public mint.");
        internalMint();
    }

    function publicMint() public payable {
        require(msg.value == 0.01 ether, "Not enough funds, requires 0.01 ether");
        require(publicMintOpen, "Public mint is closed.");
        internalMint();
    }

    function internalMint() internal {
        require(totalSupply() < maxSupply, "Max supply reached, NFT sold outs!");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function allowListMintWindow(bool _openStatus) external onlyOwner {
        allowListMintOpen = _openStatus;
    }

    function publicMintWindow(bool _openStatus) external onlyOwner {
        publicMintOpen = _openStatus;
    }

    function addAllowList(address _address) external onlyOwner {
        allowList[_address] = true;
    }

    function addMultipleAllowList(address[] calldata _addresses) external onlyOwner {
        for(uint i = 0; i < _addresses.length; i++) {
            allowList[_addresses[i]] = true;
        }
    }

    function withdraw(address _address) external onlyOwner {
        uint balance = address(this).balance;
        payable(_address).transfer(balance);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}