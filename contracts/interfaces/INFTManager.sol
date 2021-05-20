// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

interface INFTManager is IERC721 {
    function burn(uint256 tokenId) external;

    function mint() external;
}
