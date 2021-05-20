// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import '@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';

contract NFTDescriptor {
    function tokenURI(Manager positionManager, uint256 tokenId) external view override returns (string memory) {
        return NFTDescriptor.constructTokenURI(NFTDescriptor.ConstructTokenURIParams({ tokenId: tokenId }));
    }
}

abstract contract NFT is ERC721Burnable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;
    address public _tokenDescriptor;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        _setBaseURI('');
    }

    function mint() public virtual;

    function _safeMint(address to, bytes memory data) internal virtual {
        super._safeMint(to, _tokenIdTracker.current(), data);
        _tokenIdTracker.increment();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), 'NFT: URI query for nonexistent token');
        return NFTDescriptor(_tokenDescriptor).tokenURI(this, tokenId);
    }
}

interface INFT is IERC721 {
    function burn(uint256 tokenId) external;

    function mint(address to) external;
}

contract Manager is NFT, ReentrancyGuard {
    using SafeERC20 for IERC20;

    uint256 public constant STAKE_AMOUNT = 1e18;
    IERC20 public immutable stETH;

    constructor(
        string memory _name,
        string memory _symbol,
        IERC20 _stETH
    ) NFT(_name, _symbol) {
        stETH = _stETH;
    }

    function mint() public virtual override nonReentrant() {
        stETH.safeTransferFrom(msg.sender, address(this), STAKE_AMOUNT);
        _safeMint(msg.sender, '');
    }

    function burn(uint256 tokenId) public virtual override nonReentrant() {
        super.burn(tokenId);
        stETH.safeTransfer(msg.sender, STAKE_AMOUNT);
    }
}
