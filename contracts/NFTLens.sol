//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

/// @title Nft Lens Contract
contract NFTLens is ERC1155URIStorage{
    uint256 tokenId;

    event mintSuccessful(
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes data,
        string tokenURI
    );

    constructor() ERC1155(""){
    }

    /** @dev Mints a new token after incrementing tokenId.
     * @param _to to which address this token should be minted.
     * @param _amount Number of tokens to be minted.
     * @param _tokenURI URL to the token metadata.
     * @param _data additional data parameter.
     */
    function mint(
        address _to,
        uint256 _amount,
        string memory _tokenURI,
        bytes memory _data
    ) 
    external 
    {
        tokenId += 1;
        _mint(_to, tokenId, _amount, _data);
        _setURI(tokenId, _tokenURI);
        emit mintSuccessful(
            _to,
            tokenId,
            _amount,
            _data,
            _tokenURI
        );
    }
}
