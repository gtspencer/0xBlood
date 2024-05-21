//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SpencersBlood is ERC721A("0xSpencersBlood", "0xBlood"), Ownable(msg.sender) {
    string private uri = "https://bafybeibzzdqfxaphjmz3d2iwhsaacqx35cqompf6b4fnt6em7smwwghuwi.ipfs.nftstorage.link/IMG_3491.jpg";

    mapping(uint256 => uint256) tokensToVolume;
    uint256 totalBloodSpilled = 0;
    uint256 constant MAX_BLOOD_SPILLED = 5000; // 5000 ml of blood in the human body

    constructor () {
    }

    function mint(address to, uint256 volume) external onlyOwner() {
        require(totalBloodSpilled + volume <= MAX_BLOOD_SPILLED, "Not enough blood left");

        tokensToVolume[_nextTokenId()] = volume;
        _safeMint(to, 1);
    }

    function updateUri(string memory newUri) external onlyOwner {
        uri = newUri;
    }

    function exists(uint256 tokenId) public view returns(bool) {
        return _exists(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token not minted");

        string memory bloodAmount = _toString(tokensToVolume[tokenId]);

        string memory metadata = string(abi.encodePacked('data:application/json,{"name": "0xSpencers Blood #', _toString(tokenId), '", "description": "', bloodAmount, ' ml of 0xSpencer Blood", "attributes": [{"trait_type": "Blood Type", "value":"O+"}, {"trait_type": "Volume", "value":"', bloodAmount, ' ml"}], "image": "', uri, '"}'));
        return metadata;
    }
}