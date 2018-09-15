pragma solidity ^0.4.24;

contract RockPaperScissor{
    address public player1;
    address public player2;

    enum Move {NULL, ROCK, PAPER, SCISSORS}

    uint public stake;

    Move private player1Selection;
    Move private player2Selection;

    modifier onlyPlayer2{
        require(msg.sender == player2, "Only player 2 can call this function.");
        _;
    }

    event TokensCreated(address holder, uint amount);
    event NewMove(address player, Move selection);

    constructor(address _player2, Move _selection) payable public {
        player1 = msg.sender;
        player2 = _player2;
        stake = msg.value;
        player1Selection = _selection;
    }

    //Using the modifier onlyPlayer2
    function submitSelection(Move selection) payable onlyPlayer2 public{
        require(msg.value == stake, "Must submit the same stake as player 1");
        require(player2Selection == Move.NULL, "You have already made a selection");

        player2Selection = selection;
        emit NewMove(msg.sender, selection);
    }

    function determineWinner() public {
        require (player2Selection > Move.NULL, "Player 2 must have made a selection");
        uint totalStaked = address(this).balance;

        if (player1Selection == player2Selection) {
            player1.send(totalStaked / 2);
            player2.send(totalStaked / 2);
        } else if (player1Selection == Move.NULL) {
            player2.transfer(totalStaked);
        } else if (uint8(player1Selection) % 2 == uint8(player2Selection) % 2) {
            if (player1Selection == Move.ROCK) {
                player1.transfer(totalStaked);
            } else {
                player2.transfer(totalStaked);
            }
        } else {
            if (player1Selection> player2Selection) {
                player1.transfer(totalStaked);
            } else {
                player2.transfer(totalStaked);
            }
        }
    }
}
