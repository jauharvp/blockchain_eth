// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract MultiSwigWallet {
    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed To,
        uint value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    address[] public  owners;
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;

    struct Transactoin {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }
}