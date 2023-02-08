// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address highestBidder, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;
    IERC20 public immutable coin;
    
    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, address _erc20, uint _startingBid) {
        nft = IERC721(_nft); 
        nftId = _nftId;
        highestBid = _startingBid;
        // TODO: initialize the coin variable
        // TODO: initialize the (payable) seller variable 
    }

    function start() external {
        //TODO: require that msg.sender is the seller
        //TODO: require the auction hasn't started yet
        //TODO: set started to true
        endAt = uint32(block.timestamp + 300); // 300 seconds should be long enough for the Demo and test.
        //TODO: transfer the nft from the seller to this contract
        //TODO: emit the start event
    }

    // Here we give you some functions to interact the PennCoin ERC20 contract 
    function ApproveCoin(uint256 _coinAmount) public returns(bool){
       coin.approve(address(this), _coinAmount);
       return true;
    }
    function AcceptPayment(uint256 _tokenamount) public returns(bool) {
       require(_tokenamount <= GetAllowance(), "Please approve tokens before transferring");
       coin.transferFrom(msg.sender, address(this), _tokenamount);
       return true;
    }
    function GetUserTokenBalance() public view returns(uint256){ 
       return coin.balanceOf(msg.sender);
    }
    function GetAllowance() public view returns(uint256){
       return coin.allowance(msg.sender, address(this));
    }
    function GetContractTokenBalance() public view returns(uint256){
       return coin.balanceOf(address(this));
    }

    function bid(uint256 coinamount) external payable {
        //TODO: require the auction has started and hasn't ended
        //TODO: require the incoming bid is higher than the highest bid
        //TODO: Use AcceptPayment() to transfer money from the bidder to the contract
        //TODO: If there is alread a highest bidder, indicate they can now withdraw [highestBid] Penncoin using the bids map
        //TODO: set the highestbid to the new coinamount
        //TODO: set the highest bidder to msg.sender
        //TODO: emit the bid event
    }

    function withdraw() external { 
        //TODO: load the senders token balance from the bids map
        //TODO: set the senders balance to 0
        //TODO: approve and transfer [balance] Penncoin to the sender
        //TODO: emit the Withdraw event
    }

    function end() external {
        //TODO: require that the action has started and not ended
        //TODO: require that the block timestamp is greater than endAt
        //TODO: set ended to true
        //TODO: If no one made a bid, return the nft to the seller
        //TODO: Otherwise, send the nft to the winner and transfer their bid to the seller
    }
}