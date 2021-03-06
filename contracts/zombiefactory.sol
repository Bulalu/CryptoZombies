pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    //create dna
    //create zombie datatype which has name and dna
    //generate random dna according to  given name
    //assign zombies to owner
    //let a player only generate one zombie
    //keep track of how many zombies a player holds

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping(address => uint) ownerZombieCount;
    mapping(uint => address) zombieToOwner;
    // by convention private functions start with underscore _
    function _createZombie(string  memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] ++;
        emit NewZombie(id, _name, _dna);
        
    }

    function _generateRandomDna(string memory _str) private view returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }


}