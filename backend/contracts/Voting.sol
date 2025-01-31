// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        string party; 
        uint voteCount;
    }

    mapping (uint => Candidate) public candidates;
    mapping (address => bool) public voters;

    uint public countCandidates;
    uint256 public votingEnd;
    uint256 public votingStart;

    function addCandidate(string memory name, string memory party) public returns (uint) {
        countCandidates++;
        candidates[countCandidates] = Candidate(countCandidates, name, party, 0);
        return countCandidates;
    }
   
    function vote(uint candidateID) public {
        // Ensure the voting period is active
        require((votingStart <= block.timestamp) && (votingEnd > block.timestamp), "Voting is not active.");
   
        // Ensure the candidate ID is valid
        require(candidateID > 0 && candidateID <= countCandidates, "Invalid candidate ID.");

        // Ensure the voter has not already voted
        require(!voters[msg.sender], "You have already voted.");
              
        voters[msg.sender] = true;
        candidates[candidateID].voteCount++;      
    }
    
    function checkVote() public view returns (bool) {
        return voters[msg.sender];
    }
       
    function getCountCandidates() public view returns (uint) {
        return countCandidates;
    }

    function getCandidate(uint candidateID) public view returns (uint, string memory, string memory, uint) {
        return (candidateID, candidates[candidateID].name, candidates[candidateID].party, candidates[candidateID].voteCount);
    }

    function setDates(uint256 _startDate, uint256 _endDate) public {
        require((votingEnd == 0) && (votingStart == 0), "Voting dates are already set.");
        require((_startDate + 1000000 > block.timestamp) && (_endDate > _startDate), "Invalid voting dates.");
        votingEnd = _endDate;
        votingStart = _startDate;
    }

    function getDates() public view returns (uint256, uint256) {
        return (votingStart, votingEnd);
    }
}