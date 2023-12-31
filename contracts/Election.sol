// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract Election {
    address public admin;
    uint256 candidateCount;
    uint256 voterCount;
    bool start;
    bool end;

    constructor() public {
        // Initilizing default values
        admin = msg.sender;
        candidateCount = 0;
        voterCount = 0;
        start = false;
        end = false;
    }

    function getAdmin() public view returns (address) {
        // Returns account address used to deploy contract (i.e. admin)
        return admin;
    }

    modifier onlyAdmin() {
        // Modifier for only admin access
        require(msg.sender == admin);
        _;
    }
    // Modeling a candidate
    struct Candidate {
        uint256 candidateId;
        string header;
        string slogan;
        uint256 voteCount;
    }
    mapping(uint256 => Candidate) public candidateDetails;

    // Adding new candidates
    function addCandidate(string memory _header, string memory _slogan)
        public
        // Only admin can add
        onlyAdmin
    {
        require(!start, "Election is Started !");
        //verification dro start election
        if(!start){
            Candidate memory newCandidate =
            Candidate({
                candidateId: candidateCount,
                header: _header,
                slogan: _slogan,
                voteCount: 0
            });
            candidateDetails[candidateCount] = newCandidate;
            candidateCount += 1;
        }
    }

    // Modeling a Election Details
    struct ElectionDetails {
        string adminName;
        string adminEmail;
        string adminTitle;
        string electionTitle;
        string organizationTitle;
    }
    ElectionDetails electionDetails;

    function setElectionDetails(
        string memory _adminName,
        string memory _adminEmail,
        string memory _adminTitle,
        string memory _electionTitle,
        string memory _organizationTitle
    )
        public
        // Only admin can add
        onlyAdmin
    {
        require(candidateCount>0, "Please add at least one Candidate");
        if(candidateCount>0){
            electionDetails = ElectionDetails(
                _adminName,
                _adminEmail,
                _adminTitle,
                _electionTitle,
                _organizationTitle
            );
            start = true;
            end = false;
        }
    }

    // Get Elections details
    function getAdminName() public view returns (string memory) {
        return electionDetails.adminName;
    }

    function getAdminEmail() public view returns (string memory) {
        return electionDetails.adminEmail;
    }

    function getAdminTitle() public view returns (string memory) {
        return electionDetails.adminTitle;
    }

    function getElectionTitle() public view returns (string memory) {
        return electionDetails.electionTitle;
    }

    function getOrganizationTitle() public view returns (string memory) {
        return electionDetails.organizationTitle;
    }

    // Get candidates count
    function getTotalCandidate() public view returns (uint256) {
        // Returns total number of candidates
        return candidateCount;
    }

    // Get voters count
    function getTotalVoter() public view returns (uint256) {
        // Returns total number of voters
        return voterCount;
    }

    // Modeling a voter
    struct Voter {
        address voterAddress;
        string name;
        string phone;
        bool isVerified;
        bool hasVoted;
        bool isRegistered;
    }
    address[] public voters; // Array of address to store address of voters
    mapping(address => Voter) public voterDetails;

    // Mapping to track unique voter addresses
    mapping(address => bool) private uniqueVoterAddresses;
    // Request to be added as voter
    //function registerAsVoter(string memory _name, string memory _phone) public {
    //    Voter memory newVoter =
    //      Voter({
    //          voterAddress: msg.sender,
    //          name: _name,
    //          phone: _phone,
    //          hasVoted: false,
    //          isVerified: false,
    //          isRegistered: true
    //      });
    //  voterDetails[msg.sender] = newVoter;
    //  voters.push(msg.sender);
    //  voterCount += 1;
    //}
    
// Request to be added as a voter
function registerAsVoter(string memory _name, string memory _phone) public {
    require(!uniqueVoterAddresses[msg.sender], "Voter is already registered.");
    
    Voter memory newVoter =
        Voter({
            voterAddress: msg.sender,
            name: _name,
            phone: _phone,
            hasVoted: false,
            isVerified: false,
            isRegistered: true
        });
    
    voterDetails[msg.sender] = newVoter;
    voters.push(msg.sender);
    uniqueVoterAddresses[msg.sender] = true;
    voterCount += 1;
}

    // Update voter information
    function updateVoterInfo(string memory _name, string memory _phone) public {
        require(uniqueVoterAddresses[msg.sender], "Voter is not registered.");
        
        Voter storage existingVoter = voterDetails[msg.sender];
        existingVoter.name = _name;
        existingVoter.phone = _phone;
    }

    // Get total unique voters count
    function getTotalUniqueVoters() public view returns (uint256) {
        return voters.length;
    }


    // Verify voter
    function verifyVoter(bool _verifedStatus, address voterAddress)
        public
        // Only admin can verify
        onlyAdmin
    {
        voterDetails[voterAddress].isVerified = _verifedStatus;
    }

    // Vote
    function vote(uint256 candidateId) public {
        require(voterDetails[msg.sender].hasVoted == false);
        require(voterDetails[msg.sender].isVerified == true);
        require(start == true);
        require(end == false);
        candidateDetails[candidateId].voteCount += 1;
        voterDetails[msg.sender].hasVoted = true;
    }

    // End election
    function endElection() public onlyAdmin {
        end = true;
        start = false;
    }

    // Get election start and end values
    function getStart() public view returns (bool) {
        return start;
    }

    function getEnd() public view returns (bool) {
        return end;
    }
}
