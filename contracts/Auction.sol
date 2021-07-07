//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract auction {
    
    struct AuctionPrice{
        uint ItemId;
        address payable Owner;
        uint BidAmount;
        address payable HighestBidder;
    }
    AuctionPrice[] public AuctionList;
    
    uint highestbid = 0;
    uint AuctionId = 0;
    address KittyContract;
    IERC721 ItemInterface;
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    
    mapping(uint => address) Approved;
    
    //ItemInterface = IERC721();
    
    constructor() {
        AuctionId++;
        AuctionList.push(AuctionPrice(1,payable(msg.sender),highestbid,payable(msg.sender)));
    }
    
    //Function to select the auction item and Price
    function MakeBid (uint _id, uint _price) public {
        require(AuctionList[_id-1].Owner != msg.sender);
        require(_price>=highestbid);
        highestbid = _price;
        AuctionList[_id-1].BidAmount = _price;
        AuctionList[_id-1].HighestBidder = payable(msg.sender);
    }
    
    function _transfer(address payable _to, uint _id) internal {
        AuctionList[_id-1].Owner = _to;
        AuctionList[_id-1].BidAmount = 0;
        AuctionList[_id-1].HighestBidder = _to;
        emit Transfer(msg.sender, _to, _id);
    }
    
    function transferFrom(address payable from, address payable to, uint256 tokenId) payable external{
        require(Approved[tokenId] == msg.sender || AuctionList[tokenId-1].Owner == msg.sender);
        require(Approved[tokenId] == to && AuctionList[tokenId-1].HighestBidder == to);
        require(msg.value>=AuctionList[tokenId-1].BidAmount);
        //should send ether from to address to from address
        from.transfer(AuctionList[tokenId-1].BidAmount);
        _transfer(to,tokenId);
    }
    
    function approve(address to, uint256 tokenId) external {
        require(msg.sender == AuctionList[tokenId-1].Owner);
        require(AuctionList[tokenId-1].HighestBidder == to);
        Approved[tokenId] = to;
    }
    
}