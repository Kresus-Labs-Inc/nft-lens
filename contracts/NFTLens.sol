//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

/// @title Nft Lens Contract
contract NFTLens is ERC1155URIStorage{
    uint256 tokenId;
    address superAdmin;
    mapping(address => bool)_isAdmin;

    event mintSuccessful(
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes data
    );

    /** @dev sets the deployer as super admin as well as admin who will have minting authority.
     * @param _superAdmin the super admin of the contract who can control admins.
     */
    constructor(address _superAdmin) ERC1155(""){
        superAdmin = _superAdmin;
        _isAdmin[_superAdmin] = true;
    }

    /** @dev Mints a new token after incrementing tokenId. Only Admins can call this function.
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
    ) external {
        require(_isAdmin[msg.sender], "NFT Lens: Caller not admin");
        _setTokenURI(_tokenURI);
        _callMint(_to, _amount, tokenId, _data);
    }

    /**
     * @dev Mints ERC1155 tokens to the array of `_to` addresses. Only Admins can call this function.
     * @param _to array of addresses to which tokens has to be minted.
     * @param _amounts array of uint256, number of tokens to be minted for each mint.
     * @param _tokenURI array of strings, metadata URL for the token metadata for each token to be minted.
     * @param _data additional data parameter for each mint.
     */
    function bulkMint(
        address[] memory _to,
        uint256[] memory _amounts,
        string memory _tokenURI,
        bytes memory _data
    ) external {
        uint256 len = _to.length;
        require(_isAdmin[msg.sender], "NFT Lens: Caller not admin");
        require(len == _amounts.length, "NFT Lens: Inconsistent lengths");
        _setTokenURI( _tokenURI);
        for(uint256 i=0;i<len;i++) {
            _callMint(_to[i], _amounts[i], tokenId, _data);
        }
    }

    /**
     * @dev Function to add or remove admins.
     * @param _admin address of the admin to add or remove.
     * @param _authorize boolean, true to add admin, false to remove.
     */
    function authorizeAdmin(address _admin, bool _authorize) external {
        require(msg.sender == superAdmin, "NFT Lens: Caller not Super admin");
        _isAdmin[_admin] = _authorize;
    }

    /**
     * @dev Function to change address of the super admin.
     * @param _newSuperAdmin address of the new super admin.
     */
    function changeSuperAdmin(address _newSuperAdmin) external {
        require(msg.sender == superAdmin, "NFT Lens: Caller not Super admin");
        superAdmin = _newSuperAdmin;
    }

    /**
     * @dev Internal function to call _mint from ERC1155 contract and to set the token URI.
     * @param _to address to which tokens has to be minted.
     * @param _amount number of token to be minted.
     * @param _data additional data parameter
     */
    function _callMint(
        address _to,
        uint256 _amount,
        uint256 _tokenId,
        bytes memory _data
    ) internal {
        _mint(_to, _tokenId, _amount, _data);
        emit mintSuccessful(
            _to,
            _tokenId,
            _amount,
            _data
        );
    }

    /**
     * @dev Internal function to set token URI for a token Id
     * @param _tokenURI URL which contains metadata for the token
     */
    function _setTokenURI(string memory _tokenURI) internal {
        tokenId += 1;
        _setURI(tokenId, _tokenURI);
    }

    /**
     * @dev Function to check if an address is admin. Returns true if address is admin else returns false.
     * @param _admin address to check
     */
    function isAdmin(address _admin) external view returns(bool){
        return _isAdmin[_admin];
    }
    
    /**
     * @dev Function to get the super admin address.
     */
    function getSuperAdmin() external view returns(address) {
        return superAdmin;
    }

    /**
     * @dev Function to get the current token id.
     */
    function getTokenId() external view returns(uint256) {
        return tokenId;
    }
}
