pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PennFT is ERC721 {
    // todo: think about what variables you need to store the NFT metadata
    string private _name;
    string private _symbol;

    //map from token id to token uri
    mapping(uint256 => string) private _tokenURIs;
    //map from token uri to owner
    mapping(string => address) private _tokenURItoOwner;
    //map from token uri to token id
    mapping(string => uint256) private _tokenURItoID;
    //map from token id to owner
    mapping(uint256 => address) private _tokenIDtoOwner;
    //map from owner to token id
    mapping(address => uint256) private _ownerToTokenID;

    //list of all token ids
    uint256[] private _tokenIDs;

    /**
        The constructor for the PennFT contract. Passes the name and symbol to the ERC721 constructor.
    */
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        // todo: initialize any variables you created here
        _name = _name;
        _symbol = _symbol;
    }

    /**
        @param tokenURI The tokenURI of the NFT
        @return The ID of the newly minted NFT
    */
    function mintNFT(
        address recipient,
        string memory tokenURI
    ) public returns (uint256) {
        // todo: finish this code

        //create new id
        uint256 new_id = _tokenIDs.length + 1;
        //add new id to list of token ids
        _tokenIDs.push(new_id);
        //add token uri to map from token id to token uri
        _tokenURIs[new_id] = tokenURI;
        //add token uri to map from token uri to owner
        _tokenURItoOwner[tokenURI] = recipient;
        //add token uri to map from token uri to token id
        _tokenURItoID[tokenURI] = new_id;
        //add token id to map from token id to owner
        _tokenIDtoOwner[new_id] = recipient;
        //add owner to map from owner to token id
        _ownerToTokenID[recipient] = new_id;

        _mint(recipient, new_id);
    }

    /**
     * Gets the URI of the specified token.
     * @param tokenId uint256 ID of the token to query the URI of
     * @return string URI of the token
     */
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        // todo: finish this code
        return _tokenURIs[tokenId];
    }

    /**
     * Gets the number of tokens in existence.
     * @return uint256 representing the number of tokens in existence
     */
    function tokenCount() public view returns (uint256) {
        // todo: finish this code
        // iterate through the tokenIDs list and return the number of tokens
        return _tokenIDs.length;
    }
}
