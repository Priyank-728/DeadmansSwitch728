// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckedBlock;
    uint256 public constant blocksThreshold = 10;

    event FundsTransferred(address to, uint256 amount);

    constructor(address _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastCheckedBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function stillAlive() public onlyOwner {
        lastCheckedBlock = block.number;
    }

    function checkSwitch() public {
        require(block.number - lastCheckedBlock >= blocksThreshold, "The owner is still alive.");
        uint256 balance = address(this).balance;
        payable(beneficiary).transfer(balance);
        emit FundsTransferred(beneficiary, balance);
    }

    receive() external payable {}
}
