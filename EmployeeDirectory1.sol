// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract EmployeeDirectory {
    // 직원 ID를 key, 직원 이름을 value로 저장
    mapping(uint256 => string) public employeeNames;

    // 직원 등록 또는 수정
    function setEmployee(uint256 _id, string calldata _name) public {
        employeeNames[_id] = _name;
    }

    // 직원 이름 조회
    function getEmployee(uint256 _id) public view returns (string memory) {
        return employeeNames[_id];
    }

    // 직원 삭제 (이름을 기본값 "" 로 초기화)
    function deleteEmployee(uint256 _id) public {
        delete employeeNames[_id];
    }
}
