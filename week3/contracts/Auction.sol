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
        coin = IERC20(_erc20);
        // TODO: initialize the (payable) seller variable
        seller = payable(msg.sender);
    }

    function start() external {
        //TODO: require that msg.sender is the seller
        require(msg.sender == seller, "Only the seller can start the auction");
        //TODO: require the auction hasn't started yet
        require(started == false, "The auction has already started");
        //TODO: set started to true
        started = true;
        endAt = uint32(block.timestamp + 300); // 300 seconds should be long enough for the Demo and test.
        //TODO: transfer the nft from the seller to this contract
        nft.transferFrom(seller, address(this), nftId);
        //TODO: emit the start event
        emit Start();
    }

    // Here we give you some functions to interact the PennCoin ERC20 contract
    function ApproveCoin(uint256 _coinAmount) public returns (bool) {
        coin.approve(address(this), _coinAmount);
        return true;
    }

    function AcceptPayment(uint256 _tokenamount) public returns (bool) {
        require(
            _tokenamount <= GetAllowance(),
            "Please approve tokens before transferring"
        );
        coin.transferFrom(msg.sender, address(this), _tokenamount);
        return true;
    }

    function GetUserTokenBalance() public view returns (uint256) {
        return coin.balanceOf(msg.sender);
    }

    function GetAllowance() public view returns (uint256) {
        return coin.allowance(msg.sender, address(this));
    }

    function GetContractTokenBalance() public view returns (uint256) {
        return coin.balanceOf(address(this));
    }

    function bid(uint256 coinamount) external payable {
        //TODO: require the auction has started and hasn't ended
        require(started == true, "The auction has not started yet");
        require(ended == false, "The auction has already ended");

        //TODO: require the incoming bid is higher than the highest bid
        require(
            coinamount > highestBid,
            "The incoming bid is not higher than the highest bid"
        );
        //TODO: Use AcceptPayment() to transfer money from the bidder to the contract
        AcceptPayment(coinamount);

        //TODO: If there is alread a highest bidder, indicate they can now withdraw [highestBid] Penncoin using the bids map
        if (highestBidder != address(0)) {
            bids[highestBidder] = highestBid;
        }

        //TODO: set the highestbid to the new coinamount
        highestBid = coinamount;

        //TODO: set the highest bidder to msg.sender
        highestBidder = msg.sender;

        //TODO: emit the bid event
        emit Bid(msg.sender, coinamount);
    }

    function withdraw() external {
        //TODO: load the senders token balance from the bids map
        uint balance = bids[msg.sender];

        //TODO: set the senders balance to 0
        bids[msg.sender] = 0;

        //TODO: approve and transfer [balance] Penncoin to the sender
        ApproveCoin(balance);
        coin.transfer(msg.sender, balance);

        //TODO: emit the Withdraw event
        emit Withdraw(msg.sender, balance);
    }

    function end() external {
        //TODO: require that the action has started and not ended
        require(started == true, "The auction has not started yet");
        require(ended == false, "The auction has already ended");
        //TODO: require that the block timestamp is greater than endAt
        require(block.timestamp > endAt, "The auction has not ended yet");

        //TODO: set ended to true
        ended = true;
        //TODO: If no one made a bid, return the nft to the seller
        if (highestBidder == address(0)) {
            nft.transferFrom(address(this), seller, nftId);
        }
        //TODO: Otherwise, send the nft to the winner and transfer their bid to the seller
        else {
            nft.transferFrom(address(this), highestBidder, nftId);
            ApproveCoin(highestBid);
            coin.transfer(seller, highestBid);
        }
    }
}
