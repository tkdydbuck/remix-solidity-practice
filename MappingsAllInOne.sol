// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MappingsTask {
    // ─────────────────────────────────────
    // 미션 1: mappings-sbs
    // 주소 → 정수형 잔액
    mapping(address => uint256) public balances;

    function setBalance(uint256 _balance) public {
        balances[msg.sender] = _balance;
    }

    function getBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }

    function deleteBalance(address _addr) public {
        delete balances[_addr];
    }

    // ─────────────────────────────────────
    // 미션 2: mappings-exercise
    // 직원 ID → 이름
    mapping(uint256 => string) public employeeNames;

    function setEmployee(uint256 _id, string calldata _name) public {
        employeeNames[_id] = _name;
    }

    function getEmployee(uint256 _id) public view returns (string memory) {
        return employeeNames[_id];
    }

    function deleteEmployee(uint256 _id) public {
        delete employeeNames[_id];
    }
}


