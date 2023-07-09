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

    // mapping from tx index => owner => bool

    mapping(uint => mapping (address => bool)) public isConfirmed;

    Transactoin[] public transactions;

    modifier  onlyOwner(){
        require(isOwner[msg.sender], "not owner");
    _;
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier  notExecuted(uint _txIndex){
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }
    modifier notConfirmed(uint _txIndex){
        require(!isConfirmed[_txIndex][msg.sender],"tx already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _numConfirmationsRequired){
        require(_owners.length > 0, "Owners required");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,"invalid number of required confirmations");

        for (uint i =0; i < _owners.length; i++) 
        {
            address owner = _owners[i];

            require(owner != address(0), "inavlid owner");
            require(!isOwner[owner],"owner not unique");

            isOwner[owner] = true;
            owners.push(owner);

        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external  payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(
        address _to,
        uint _value,
        bytes memory _data
    ) public  onlyOwner {
        uint txIndex = transactions.length;

        transactions.push(
            Transactoin({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }
}