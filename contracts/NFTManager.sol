// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721Burnable {
    using Counters for Counters.Counter;

    address public immutable manager;
    Counters.Counter private _tokenIdTracker;

    constructor(
        string memory _name,
        string memory _symbol,
        address _manager
    ) ERC721(_name, _symbol) {
        manager = _manager;
    }

    function mint(address to) public virtual onlyManager(msg.sender) {
        _safeMint(to, "");
    }

    function _safeMint(address to, bytes memory data) internal virtual {
        super._safeMint(to, _tokenIdTracker.current(), data);
        _tokenIdTracker.increment();
    }

    function burn(uint256 tokenId) public virtual override {}

    modifier onlyManager(address caller) {
        require(caller == manager, "nft/only-manager");
        _;
    }
}

interface INFT is IERC721 {
    function burn(uint256 tokenId) external;

    function mint(address to) external;
}

contract Manager {
    using SafeERC20 for IERC20;
    uint256 public constant MIN_STAKE_AMOUNT = 1e18;
    INFT public immutable nft;
    IERC20 public immutable stETH;

    mapping(address => uint256) public balances;

    constructor(INFT _nft, IERC20 _stETH) {
        nft = _nft;
        stETH = _stETH;
    }

    function mint() public virtual {
        stETH.safeTransferFrom(msg.sender, address(this), MIN_STAKE_AMOUNT);
        nft.mint(msg.sender);
    }

    function burn(uint256 tokenId) public virtual {}
}
