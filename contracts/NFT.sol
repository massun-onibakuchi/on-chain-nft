// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';

abstract contract NFT is ERC721 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    ///@dev tokenId counter (initial tokenId is 0, incrimented by one)
    Counters.Counter private _tokenIdTracker;

    mapping(uint256 => uint256) public stakedBlockNumber;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        _setBaseURI('');
    }

    function _safeMint(address to, bytes memory data) internal virtual {
        uint256 currentId = _tokenIdTracker.current();
        super._safeMint(to, currentId, data);
        stakedBlockNumber[currentId] = block.number;
        _tokenIdTracker.increment();
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
        delete stakedBlockNumber[tokenId];
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), 'NFT: URI query for nonexistent token');
        return _tokenURI(tokenId);
    }

    function mint() public virtual;

    function burn(uint256 tokenId) public virtual;

    function _tokenURI(uint256 tokenId) internal view virtual returns (string memory);
}
