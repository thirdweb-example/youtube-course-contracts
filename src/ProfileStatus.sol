// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@thirdweb-dev/contracts/extension/ContractMetadata.sol";

contract ProfileStatus is ContractMetadata {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    struct Status {
        string statusMessage;
        bool exists;
    }

    mapping(address => Status) public userStatus;

    event StatusCreated(address indexed wallet, string status);
    event StatusUpdated(address indexed wallet, string newStatus);

    function createStatus(string memory initialStatus) public {
        require(!userStatus[msg.sender].exists, "Status already exists.");

        userStatus[msg.sender] = Status({
            statusMessage: initialStatus,
            exists: true
        });

        emit StatusCreated(msg.sender, initialStatus);
    }

    function updateStatus(string memory newStatus) public {
        require(userStatus[msg.sender].exists, "Status does not exist.");

        userStatus[msg.sender].statusMessage = newStatus;

        emit StatusUpdated(msg.sender, newStatus);
    }

    function getStatus(address wallet) public view returns (string memory) {
        require(userStatus[wallet].exists, "Status does not exist.");

        return userStatus[wallet].statusMessage;
    }

    function _canSetContractURI() internal view virtual override returns (bool){
        return msg.sender == owner;
    }
}