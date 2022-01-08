// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import 'base64-sol/base64.sol';

contract nft_contract is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string [] first_word = ["Fake", "True", "Essential", "Unnescessary","Lit", "Unrealistic", "Alive", "Drab", "Homeless", "Obnoxious"];
    string [] second_word = ["Bogo", "Doodoo", "Smelly", "Shinny", "Greedy", "Wild", "Frail", "Evil", "Bogus", "Bougie", "Goated"];
    string [] third_word = ["Cash", "Friends", "Happiness", "Hope", "Coffee", "Tea", "Tinder", "Couch", "Goose", "Nation"];

    event NFTMinted(address sender, uint256 tokenId);

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    
    constructor () ERC721 ("Square NFT", "SQUARE") {
        console.log("nft contract initialized");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function randFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 seed = random(string(abi.encodePacked("firstWord", Strings.toString(tokenId))));

        seed = seed % first_word.length;

        return first_word[seed];
    }

    function randSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 seed = random(string(abi.encodePacked("secondWord", tokenId)));

        seed = seed % second_word.length;

        return second_word[seed];
    }

    function randThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 seed =  random(string(abi.encodePacked("thirdWord", tokenId)));

        seed = seed % third_word.length;

        return third_word[seed];
    }

    function makeNFT() public {
        uint256 newItemId = _tokenIds.current();

        require(newItemId <= 49, "All available nfts have been minted");
        string memory first = randFirstWord(newItemId);
        string memory second = randSecondWord(newItemId);
        string memory third = randThirdWord(newItemId);
        string memory title = string(abi.encodePacked(first, second, third));

        string memory svg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        string memory jsonFormat = Base64.encode(bytes(string(abi.encodePacked(
            '{"name": "',
            title,
            '","description": "sQuArEs", "image":"data:image/svg+xml;base64,',
            Base64.encode(bytes(svg)),
            '"}'
        ))));

        string memory finalTokenUrl = string(abi.encodePacked("data:application/json;base64,", jsonFormat));

        console.log(finalTokenUrl);

        _safeMint(msg.sender, newItemId);
            
        _setTokenURI(newItemId, finalTokenUrl);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        
        _tokenIds.increment();

        emit NFTMinted(msg.sender, newItemId);
    }
}