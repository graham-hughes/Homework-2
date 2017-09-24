pragma solidity ^0.4.15;

contract BettingContract {
	/* Standard state variables */
	address owner;
	address public gamblerA;
	address public gamblerB;
	address public oracle;
	uint[] outcomes;

	/* Structs are custom data structures with self-defined parameters */
	struct Bet {
		uint outcome;
		uint amount;
		bool initialized;
	}

	/* Keep track of every gambler's bet */
	mapping (address => Bet) bets;
	/* Keep track of every player's winnings (if any) */
	mapping (address => uint) winnings;

	/* Add any events you think are necessary */
	event BetMade(address gambler);
	event BetClosed();

	/* Uh Oh, what are these? */
	modifier OwnerOnly() {
		require(msg.sender == owner);
		_; 
	}
	modifier OracleOnly() {
		require(msg.sender == oracle);
		_;
	}

	/* Constructor function, where owner and outcomes are set */
	function BettingContract(uint[] _outcomes) {
		owner = msg.sender;
		outcomes = _outcomes;
	}

	/* Owner chooses their trusted Oracle */
	function chooseOracle(address _oracle) OwnerOnly() returns (address) {
		oracle = _oracle;
		return oracle;
	}

	/* Gamblers place their bets, preferably after calling checkOutcomes */
	function makeBet(uint _outcome) payable returns (bool) {
		if (msg.sender == oracle || msg.sender == ownder) {
			return false;
		}
		if (gamblerA == NULL) {
			gamblerA = msg.sender;
			Bet memory betA;
			
			betA.outcome = _outcome;
			betA.amount = msg.value;
			betA.initialized = true;
			
			bets[gamblerA] = betA;
			return true;
 		}
		else if (gamblerB == NULL) {
			gamblerB = msg.sender;
			Bet memory betB;
			
			betB.outcome = _outcome;
			betB.amount = msg.value;
			betB.initialized = true;
			
			bets[gamblerB] = betB;
			return true;
		}
		return false;
	}

	/* The oracle chooses which outcome wins */
	function makeDecision(uint _outcome) OracleOnly() {
		if (bets[gamblerA].outcome == _outcome && bets[gamblerA].outcome == _outcome) {
			winnings[gamblerA] = bets[gamblerA].amount;
			winnings[gamblerB] = bets[gamblerB].amount;
		}
		uint total = bets[gamblerA].amount + bets[gamblerB].amount;
		else if (bets[gamblerA].outcome == _outcome) {
			winnings[gamblerA] = total;
		}
		else if (bets[gamblerB].outcome == _outcome) {
			winnings[gamblerB] = total;
		} 
		else {
			winnings[oracle] = total;
		}
	}

	/* Allow anyone to withdraw their winnings safely (if they have enough) */
	function withdraw(uint withdrawAmount) returns (uint remainingBal) {
		if (winnings[msg.sender] > withdrawAmount) {
			winnings[msg.sender] = winnings[msg.sender] - withdrawAmount;
			msg.sender.transfer(amount);
			return winnings[msg.sender];
		}
		else {
			return winnings[msg.sender];
		}
	}
	
	/* Allow anyone to check the outcomes they can bet on */
	function checkOutcomes() constant returns (uint[]) {
		return outcomes;
	}
	
	/* Allow anyone to check if they won any bets */
	function checkWinnings() constant returns(uint) {
		return winnings[msg.sender];
	}

	/* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
	function contractReset() private {
		delete(gamblerA);
		delete(gamblerB);
		delete(oracle);
		delete(bets);
	}

	/* Fallback function */
	function() {
		revert();
	}
}
