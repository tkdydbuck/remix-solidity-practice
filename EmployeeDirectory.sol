// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract EmployeeDirectory {
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
