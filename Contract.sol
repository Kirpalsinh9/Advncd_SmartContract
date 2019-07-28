pragma solidity ^0.5.8;

library LibforChangeOwner{
    struct owner{
        address i;
    }
    
    function ChangeOwner(owner storage s,address newOwner) public returns(address) {
      return s.i = newOwner;
    }
}

contract Lottery
{
    struct player{
        string name;
        uint age;
        string region;
        address  payable user;
    }
   address public owner;
   using LibforChangeOwner for LibforChangeOwner.owner;
   LibforChangeOwner.owner newowner;
   uint public playercount;
   enum State{OPEN,CLOSED}
   player[]  playerList;
   
   mapping(address=>uint) public bet;
   State public currentstate;
   event winner(address _playeraddress); 
  
  constructor()public
  {
    owner=tx.origin;
    playercount=0;
  }
  
  modifier OnlyOwner()
    {
        require(tx.origin==owner);
        _;
    }
   modifier LotteryOpen(){
       require(currentstate == State.OPEN);
       _;
   } 
   modifier LotteryClosed{
       require(currentstate == State.CLOSED);
       _;
   }
   
   function ToOpenLottery() public OnlyOwner{
       currentstate = State.OPEN;
   }
   function ToCloseLottery() public OnlyOwner{
       currentstate = State.CLOSED;
   }
  function EnterLottery(string memory _name,uint _age,string memory _region) payable public LotteryOpen
  {
    require(tx.origin!=owner && msg.value>0.01 ether);
     playerList.push(player(_name,_age,_region,tx.origin));
     bet[tx.origin]=msg.value;
     playercount++;
  }

    function Random() private view returns(uint)
    {
        return uint(keccak256(abi.encode(block.number,block.coinbase)));
    }
    

   function PickWinner() public OnlyOwner payable LotteryClosed
      {   
        uint index=Random()%playerList.length;
        playerList[index].user.transfer(address(this).balance);
        emit winner(playerList[index].user);
     }
    
    function changeowner(address newOwner) public {
     owner = newowner.ChangeOwner(newOwner);
    }

}

contract Factory{
    uint public currentlotteryId;
    mapping(uint => Lottery) Lotteries;
    event Newlottery(address _owner,uint _id);
    
    function DeployLottery() public {
        currentlotteryId++;
        Lottery c = new Lottery();
        Lotteries[currentlotteryId] = c;
        emit Newlottery(msg.sender,currentlotteryId);
    }
    
    function getlotteryById(uint _id) public view returns (Lottery) {
        return Lotteries[_id];
    }
}

contract Dashboard{
    Factory database;
    constructor(address _database) public {
        database = Factory(_database);
    }
    
    function NewLottery() public returns (Lottery) {
        database.DeployLottery();
    }
    
    function getLotteryByID(uint _id) public view returns(Lottery){
        return database.getlotteryById(_id);
    }
    
    function OpenLotteryById(uint _id) public{
        Lottery c = Lottery(database.getlotteryById(_id));
        c.ToOpenLottery();
    }
    
    function CloseLotteryById(uint _id) public{
        Lottery c = Lottery(database.getlotteryById(_id));
        c.ToCloseLottery();
    }
    
    function EnterLotteryById(uint _id,string memory _name,uint _age,string memory _region)payable public{
        Lottery c = Lottery(database.getlotteryById(_id));
        c.EnterLottery.value(msg.value)(_name,_age,_region);
    }
    
    function PickWinnerById(uint _id) payable public{
        Lottery c = Lottery(database.getlotteryById(_id));
        c.PickWinner.value(msg.value)();
    }
    function getPlayersById(uint _id) public view returns(uint){
        Lottery c =Lottery(database.getlotteryById(_id));
        c.playercount();
    }
    function ChangeOwnerById(uint _id, address _newaddress) public{
        Lottery c = Lottery(database.getlotteryById(_id));
        c.changeowner(_newaddress);
    } 
}