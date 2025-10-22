// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Ballot {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public minDeposit;
    mapping(address => bool) public hasClaimed;
    mapping(address => uint256) public deposits;

    struct Issue {
        string description;
        EnumerableSet.AddressSet supportVoters;
        EnumerableSet.AddressSet opposeVoters;
        bool isClosed;
    }

    struct IssueView {
        string description;
        address[] supportVoters;
        address[] opposeVoters;
        bool isClosed;
    }

    Issue[] private issues;

    event Claimed(address indexed user);
    event IssueCreated(uint256 indexed issueIndex, string description);
    event Voted(address indexed voter, uint256 indexed issueIndex, bool support, uint256 deposit);

    constructor(uint256 _minDeposit) {
        minDeposit = _minDeposit;
    }

    // ✅ Your original claim function (unchanged)
    function claim() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        emit Claimed(msg.sender);
    }

    // Modified to fix storage initialization
    function createIssue(string memory description) external {
        issues.push(); // Initialize in storage first
        Issue storage newIssue = issues[issues.length - 1];
        newIssue.description = description;
        newIssue.isClosed = false;
        emit IssueCreated(issues.length - 1, description);
    }

    // Modified to add payable and all validations
    function vote(uint256 issueIndex, bool support) external payable {
        require(hasClaimed[msg.sender], "Must claim before voting");
        require(issueIndex < issues.length, "Invalid issue index");
        require(!issues[issueIndex].isClosed, "Issue closed");
        require(msg.value >= minDeposit, "Insufficient deposit");

        Issue storage issue = issues[issueIndex];
        require(
            !issue.supportVoters.contains(msg.sender) &&
            !issue.opposeVoters.contains(msg.sender),
            "Already voted"
        );

        if (support) {
            issue.supportVoters.add(msg.sender);
        } else {
            issue.opposeVoters.add(msg.sender);
        }

        deposits[msg.sender] += msg.value;
        emit Voted(msg.sender, issueIndex, support, msg.value);
    }

    // Modified to ensure consistent array output
    function getIssue(uint256 index) external view returns (IssueView memory) {
        require(index < issues.length, "Invalid index");
        Issue storage issue = issues[index];

        // Create empty arrays first
        address[] memory supportVoters = new address[](issue.supportVoters.length());
        address[] memory opposeVoters = new address[](issue.opposeVoters.length());

        // Manually populate arrays to ensure consistent encoding
        for (uint256 i = 0; i < issue.supportVoters.length(); i++) {
            supportVoters[i] = issue.supportVoters.at(i);
        }
        for (uint256 i = 0; i < issue.opposeVoters.length(); i++) {
            opposeVoters[i] = issue.opposeVoters.at(i);
        }

        return IssueView({
            description: issue.description,
            supportVoters: supportVoters,
            opposeVoters: opposeVoters,
            isClosed: issue.isClosed
        });
    }

    // Your original helper functions (unchanged)
    function closeIssue(uint256 issueIndex) external {
        require(issueIndex < issues.length, "Invalid index");
        issues[issueIndex].isClosed = true;
    }

    function withdrawDeposit() external {
        uint256 amount = deposits[msg.sender];
        require(amount > 0, "No deposit");
        deposits[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}