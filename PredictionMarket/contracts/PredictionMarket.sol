pragma solidity ^0.4.8;
contract PredictionMarket {

    address owner;

    mapping (address => uint) moneyBet;
    mapping (address => bool) choice;
    mapping (address => uint) winnings;
    //mapping (bool => uint) totalBets;
    

    address[] betters;
    uint numBetters;

    bool outcome;
    bool ended;


    function PredictionMarket() public {
        owner = msg.sender;
        numBetters = 0;
        ended = false;

    }


    function makeBet(bool _choice) public{
        if(msg.sender == owner && ended == true) {
            return;
        }

        betters.push(msg.sender);

        moneyBet[msg.sender] = msg.value;
        choice[msg.sender] = _choice;
        numBetters += 1;

    }

    function endPM(bool _outcome) public{
        if (msg.sender != owner) {
            return;
        }
        
        bool ended = true;
        bool outcome = _outcome;



        //totals money and total of the winners
        uint total = 0;
        uint winnerTotal = 0;
        for (uint i = 0; i < numBetters; i++) {
            total += moneyBet[betters[i]];
            if (choice[betters[i]] == _outcome) {
                winnerTotal += moneyBet[betters[i]];
            }
        }

        for(uint i = 0; i < numBetters; i++) {
            if (choice[betters[i]] == _outcome) {
                uint moneyWon = (moneyBet[betters[i]] / winnerTotal) / total;
                winnings[betters[i]] = moneyWon;
            }
        }
        
        
    }

    function withdraw() public returns (uint) {
        if(ended == false) {
            return 0;
        }

        uint moneyWon = winnings[msg.sender];

        if (moneyWon > 0) {
            winnings[msg.sender] = 0;
            if (!msg.sender.send(moneyWon)) {
                // No need to call throw here, just reset the amount owing
                winnings[msg.sender] = moneyWon;
                return 0;
            }
        }
        return moneyWon;

    }
    

}
