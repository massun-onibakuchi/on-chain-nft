// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@uniswap/lib/contracts/libraries/SafeERC20Namer.sol';

import './NFT.sol';
import './libraries/NFTDescriptor.sol';
import './interfaces/INFTManager.sol';

contract NFTManager is NFT, INFTManager, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 public constant STAKE_AMOUNT = 1e18;

    ///@dev ref to underlying token
    IERC20 public immutable uToken;

    constructor(
        string memory _name,
        string memory _symbol,
        IERC20 _uToken
    ) NFT(_name, _symbol) {
        uToken = _uToken;
    }

    function mint() public virtual override(INFTManager, NFT) nonReentrant() {
        uToken.safeTransferFrom(msg.sender, address(this), STAKE_AMOUNT);
        _safeMint(msg.sender, '');
    }

    function burn(uint256 tokenId) public virtual override(INFTManager, NFT) nonReentrant() {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Burnable: caller is not owner nor approved');
        _burn(tokenId);
        uToken.safeTransfer(msg.sender, STAKE_AMOUNT);
    }

    function _tokenURI(uint256 tokenId) internal view virtual override returns (string memory) {
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.URIParams({
                    tokenId: tokenId,
                    blockNumber: block.number,
                    stakeAmount: STAKE_AMOUNT,
                    uTokenSymbol: SafeERC20Namer.tokenSymbol(address(uToken)),
                    uTokenAddress: address(uToken)
                })
            );
    }
}
