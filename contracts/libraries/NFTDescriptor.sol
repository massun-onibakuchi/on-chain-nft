// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/math/SignedSafeMath.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';
import './NFTSVG.sol';

library NFTDescriptor {
    using Strings for uint256;
    using SafeMath for uint256;
    using SafeMath for uint160;
    using SafeMath for uint8;
    using SignedSafeMath for int256;
    using HexStrings for uint256;

    struct URIParams {
        uint256 tokenId;
        uint256 blockNumber;
        uint256 stakeAmount;
        address uTokenAddress;
        string uTokenSymbol;
    }

    function constructTokenURI(URIParams memory params) public pure returns (string memory) {
        string memory name = string(abi.encodePacked(params.uTokenSymbol, '-NFT'));
        string memory description = generateDescription();
        string memory image = Base64.encode(bytes(generateSVGImage(params)));

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"',
                                description,
                                '", "image": "',
                                'data:image/svg+xml;base64,',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function escapeQuotes(string memory symbol) internal pure returns (string memory) {
        bytes memory symbolBytes = bytes(symbol);
        uint8 quotesCount = 0;
        for (uint8 i = 0; i < symbolBytes.length; i++) {
            if (symbolBytes[i] == '"') {
                quotesCount++;
            }
        }
        if (quotesCount > 0) {
            bytes memory escapedBytes = new bytes(symbolBytes.length + (quotesCount));
            uint256 index;
            for (uint8 i = 0; i < symbolBytes.length; i++) {
                if (symbolBytes[i] == '"') {
                    escapedBytes[index++] = '\\';
                }
                escapedBytes[index++] = symbolBytes[i];
            }
            return string(escapedBytes);
        }
        return symbol;
    }

    function addressToString(address addr) internal pure returns (string memory) {
        return (uint256(addr)).toHexString(20);
    }

    function toColorHex(uint256 base, uint256 offset) internal pure returns (string memory str) {
        return string((base >> offset).toHexStringNoPrefix(3));
    }

    function generateDescription() private pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    'This NFT represents a liquidity in stETH pool ',
                    'The owner of this NFT can remove the liquidity.\\n'
                )
            );
    }

    function generateSVGImage(URIParams memory params) internal pure returns (string memory svg) {
        NFTSVG.SVGParams memory svgParams =
            NFTSVG.SVGParams({
                tokenId: params.tokenId,
                blockNumber: params.blockNumber,
                stakeAmount: params.stakeAmount,
                uToken: addressToString(params.uTokenAddress),
                uTokenSymbol: params.uTokenSymbol,
                color0: toColorHex(uint256(keccak256(abi.encodePacked(params.uTokenAddress, params.tokenId))), 136),
                color1: toColorHex(uint256(keccak256(abi.encodePacked(params.uTokenAddress, params.tokenId))), 0)
            });

        return NFTSVG.generateSVG(svgParams);
    }
}
