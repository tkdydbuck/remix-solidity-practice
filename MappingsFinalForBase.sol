// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract BaseMappingsSubmission {
    // --- mappings-sbs ---
    mapping(address => uint256) public balances;

    function setBalance(uint256 _balance) external {
        balances[msg.sender] = _balance;
    }

    function getBalance(address _addr) external view returns (uint256) {
        return balances[_addr];
    }

    function deleteBalance(address _addr) external {
        delete balances[_addr];
    }

    // --- mappings-exercise ---
    mapping(uint256 => string) public employeeNames;

    function setEmployee(uint256 _id, string calldata _name) external {
        employeeNames[_id] = _name;
    }

    function getEmployee(uint256 _id) external view returns (string memory) {
        return employeeNames[_id];
    }

    function deleteEmployee(uint256 _id) external {
        delete employeeNames[_id];
    }
}
