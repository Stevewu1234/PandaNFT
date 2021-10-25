//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract The_Merge_Panda is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenCounter;


    string private __baseUri;

    mapping (address => bool) internal userMinted;

    uint256 constant private MAX_AMOUNT = 5;

    constructor (string memory baseUri) ERC721("The Merge Panda", "PANDA") {
        __baseUri = baseUri;
    }

    /** ========== public view functions ========== */
    function getBaseUri() public view returns (string memory) {
        return __baseUri;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");

        string memory base = _baseURI();
        return string(abi.encodePacked(base, tokenId.toString(), ".json"));

    }

    /** ========== external mutative functions ========== */
    function setBaseUri(string memory newBaseUri) external onlyOwner {
        __baseUri = newBaseUri;
    }

    function mint() external {
        require(!userMinted[_msgSender()], "mint: you have minted");
        tokenCounter.increment();
        uint256 currentTokenId = tokenCounter.current();

        userMinted[_msgSender()] = true;

        require(currentTokenId <= MAX_AMOUNT, "mint: all tokens have been minted");
        _safeMint(_msgSender(), currentTokenId);
        
    }

    /** ========== internal view functions ========== */

    function _baseURI() internal view override returns (string memory) {
        return __baseUri;
    }

    /** ========== event ========== */
    event minted(address indexed account, uint256 tokenId);

}