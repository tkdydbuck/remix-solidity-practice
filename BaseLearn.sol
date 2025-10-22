// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract BaseLearnNFT is ERC721URIStorage {
    uint256 public tokenCounter;

    constructor() ERC721("BaseLearnPin", "BLP") {
        tokenCounter = 0;
    }

    function mintNFT() public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, "ipfs://QmBaseLearnPinMetadata"); // 예시 URI
        tokenCounter = tokenCounter + 1;
        return newItemId;
    }
}
