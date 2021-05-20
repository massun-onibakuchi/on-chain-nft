// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/math/SignedSafeMath.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';

library NFTSVG {
    using Strings for uint256;

    struct SVGParams {
        uint256 tokenId;
        uint256 blockNumber;
        uint256 stakeAmount;
        string uToken;
        string uTokenSymbol;
        string color0;
        string color1;
    }

    function generateSVG(SVGParams memory params) internal pure returns (string memory svg) {
        /*
        address: "0xe8ab59d3bcde16a29912de83a90eb39628cfc163",
        msg: "Forged in SVG for Uniswap in 2021 by 0xe8ab59d3bcde16a29912de83a90eb39628cfc163",
        sig: "0x2df0e99d9cbfec33a705d83f75666d98b22dea7c1af412c584f7d626d83f02875993df740dc87563b9c73378f8462426da572d7989de88079a382ad96c57b68d1b",
        version: "2"
        */
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGColor(params),
                    generateSVGRareMark(params.tokenId, params.uToken),
                    '</svg>'
                )
            );
    }

    function generateSVGDefs(SVGParams memory params) private pure returns (string memory svg) {
        // abi.encodePacked(
        svg = string(
            abi.encodePacked(
                '<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<g fill="black" font-family="Verdana" font-size="17">',
                '<text x="15" y="60" >',
                params.uTokenSymbol,
                '</text>',
                '<text x="15" y="90">Block: #',
                params.blockNumber.toString(),
                '</text>',
                '<text x="15" y="120">ID: ',
                params.tokenId.toString(),
                '</text>',
                '</g>'
            )
        );
    }

    function generateSVGColor(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g fill="#',
                params.color0,
                '">',
                '<path d="M169.773 240.488L167.432 244.079C141.034 284.574 146.93 337.608 181.606 371.585C202.007 391.573 228.743 401.569 255.481 401.571C255.481 401.571 255.481 401.571 169.773 240.488Z"/>',
                '<path opacity="0.6" d="M255.483 289.445L169.774 240.488C255.483 401.571 255.483 401.571 255.483 401.571C255.483 366.489 255.483 326.289 255.483 289.445Z"/>',
                '<path opacity="0.6" d="M341.275 240.488L343.616 244.079C370.014 284.574 364.118 337.608 329.442 371.585C309.042 391.573 282.305 401.569 255.567 401.571C255.567 401.571 255.567 401.571 341.275 240.488Z"/>',
                '<path opacity="0.2" d="M255.566 289.445L341.274 240.488C255.566 401.571 255.566 401.571 255.566 401.571C255.566 366.489 255.566 326.289 255.566 289.445Z"/>',
                '<path opacity="0.2" d="M255.584 180.09V264.527L329.412 222.336L255.584 180.09Z"/>',
                '<path opacity="0.6" d="M255.584 180.09L181.703 222.335L255.584 264.527V180.09Z"/>',
                '<path d="M255.584 109.054L181.703 222.338L255.584 179.974V109.054Z"/>',
                '<path opacity="0.6" d="M255.584 179.975L329.468 222.341L255.584 109V179.975Z"/>'
                '</g>'
            )
        );
    }

    function generateSVGRareMark(uint256 tokenId, string memory tokenAddress) private pure returns (string memory svg) {
        if (isRare(tokenId, tokenAddress)) {
            svg = string(
                abi.encodePacked('<rect x="16" y="16" width="258" height="468" rx="26" ry="26" fill="black" />')
            );
        } else {
            svg = '';
        }
    }

    function isRare(uint256 tokenId, string memory tokenAddress) internal pure returns (bool) {
        return uint256(keccak256(abi.encodePacked(tokenId, tokenAddress))) < type(uint256).max / 10;
    }
}
