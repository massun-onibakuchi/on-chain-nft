// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import '@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';

import './libraries/NFTDescriptor.sol';

abstract contract NFT is ERC721Burnable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        _setBaseURI('');
    }

    function _safeMint(address to, bytes memory data) internal virtual {
        super._safeMint(to, _tokenIdTracker.current(), data);
        _tokenIdTracker.increment();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), 'NFT: URI query for nonexistent token');
        return _tokenURI(tokenId);
    }

    function mint() public virtual;

    function _tokenURI(uint256 tokenId) internal view virtual returns (string memory);
}
