//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0<0.9.0;

contract Lottery{

    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
    }

    receive() payable external {
        require(msg.value == 0.1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager , "You are not manager, So you don't have authority to see this information.");
        return address(this).balance;
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function LotteryWinner() public {
        require(msg.sender == manager);
        require(participants.length>=4);

        uint r = random();
        uint index = r % participants.length;

        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}