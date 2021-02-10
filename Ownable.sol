contract Ownable {
    address public owner;
    
    modifier onlyOwner {
         require(msg.sender == owner);
         _; // run the function
        
    }
    
    constructor (){
        owner = msg.sender;
    }

    
}