pragma solidity 0.7.5;


import "./Ownable.sol";

contract MultiSig is Ownable {
    
    struct Transaction {
        address payable to;
        uint amount;
        uint numApproval;
    }
    
    mapping(uint => Transaction) transactionLog;
    mapping(uint => address[]) hasSignedlist;
    
    
    address[] ownerAddress;
    
    uint numApproval = 0;
    uint indexAggregator = 0;
    
    modifier exclusiveOnly {
        bool isOwner = false;
        for (uint i=0; i<ownerAddress.length; i++) {
            isOwner = (ownerAddress[i] == msg.sender) || isOwner;
        }
        require(isOwner);
        _; // run the function
        
    }
       
    function deposit() public payable returns (uint) {
        return msg.value;
    }
    
    function getBalance() public returns (uint256) {
         return address(this).balance;
    }
    
    function importOwner(address _owner) public onlyOwner returns (uint256) {
         ownerAddress.push(_owner);
    }
    
    function minNumApproval(uint _numApproval) public onlyOwner returns (uint) {
        numApproval = _numApproval;
        return _numApproval;
    }
    
    function createTransfer(uint256 _amount, address payable _to) public exclusiveOnly{
        transactionLog[indexAggregator++] = Transaction( _to, _amount, 0);
        
    }
    
    function _transfer(Transaction memory toSend) private exclusiveOnly{
        toSend.to.transfer(toSend.amount);

    }
    
    function sign(uint transactionIndex) public exclusiveOnly {
        bool hasSigned = false;
        for (uint i=0; i<hasSignedlist[transactionIndex].length; i++) {
            hasSigned = ( hasSignedlist[transactionIndex][i] == msg.sender) || hasSigned;
        }
        
        if(hasSigned == false) {
            transactionLog[transactionIndex].numApproval += 1;
            if(transactionLog[transactionIndex].numApproval >= numApproval) {
                _transfer(transactionLog[transactionIndex]);
            }
        }
        
    }
    
}