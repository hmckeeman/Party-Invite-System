// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PartyInvitations {
    address private owner;
    uint private invitePrice;
    uint private totalInvites;
    mapping(address => uint) private inviteBalances;

    event InviteCreated(uint indexed inviteId, address indexed creator, uint price);
    event InvitePurchased(address indexed buyer, uint numInvites, uint price);
    event InviteTransferred(address indexed from, address indexed to, uint numInvites);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can create invites");
        _;
    }

    constructor() {
        owner = msg.sender;
        invitePrice = 0; // Set the initial price to 0
        totalInvites = 0;
    }

    function createInvites(uint _numInvites, uint _price) public onlyOwner {
        require(_numInvites > 0, "Number of invites must be greater than 0");
        require(_price > 0, "Price must be greater than 0");

        for (uint i = 0; i < _numInvites; i++) {
            totalInvites++;
            emit InviteCreated(totalInvites, owner, _price);
        }
        invitePrice = _price;
    }

    function purchaseInvite(uint _numInvites) public payable {
        require(_numInvites > 0, "Number of invites must be greater than 0");
        require(msg.value == invitePrice * _numInvites, "Incorrect amount sent");
        require(totalInvites >= _numInvites, "Not enough invites available");

        inviteBalances[msg.sender] += _numInvites; // Corrected line
        emit InvitePurchased(msg.sender, _numInvites, invitePrice);
        totalInvites -= _numInvites;
    }

    function transferInvite(address _to, uint _numInvites) public {
        require(_numInvites > 0, "Number of invites must be greater than 0");
        require(inviteBalances[msg.sender] >= _numInvites, "Insufficient invites balance");

        inviteBalances[msg.sender] -= _numInvites;
        inviteBalances[_to] += _numInvites;
        emit InviteTransferred(msg.sender, _to, _numInvites);
    }

    function hasInvite(address _address) public view returns (bool) {
        return inviteBalances[_address] > 0;
    }

    function getInviteCount(address _address) public view returns (uint) {
        return inviteBalances[_address];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getInvitePrice() public view returns (uint) {
        return invitePrice;
    }

    function getTotalInvites() public view returns (uint) {
        return totalInvites;
    }
}
