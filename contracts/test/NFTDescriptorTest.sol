pragma solidity =0.7.6;
pragma abicoder v2;

import '../libraries/NFTDescriptor.sol';
import '../libraries/NFTSVG.sol';
import '../libraries/HexStrings.sol';

contract NFTDescriptorTest {
    using HexStrings for uint256;

    function constructTokenURI(NFTDescriptor.URIParams calldata params) public pure returns (string memory) {
        return NFTDescriptor.constructTokenURI(params);
    }

    function addressToString(address _address) public pure returns (string memory) {
        return NFTDescriptor.addressToString(_address);
    }

    function generateSVGImage(NFTDescriptor.URIParams memory params) public pure returns (string memory) {
        return NFTDescriptor.generateSVGImage(params);
    }

    function toColorHex(address token, uint256 offset) public pure returns (string memory) {
        return NFTDescriptor.toColorHex(uint256(token), offset);
    }

    // function sliceTokenHex(address token, uint256 offset) public pure returns (uint256) {
    //     return NFTDescriptor.sliceTokenHex(uint256(token), offset);
    // }

    function isRare(uint256 tokenId, string memory poolAddress) public pure returns (bool) {
        return NFTSVG.isRare(tokenId, poolAddress);
    }
}
