// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract AdvancedEmployeeDirectory {
    address public owner;

    struct Employee {
        string name;
        uint32 salary;
        bool exists;
    }

    // 직원 ID → Employee 구조체
    mapping(uint256 => Employee) private employees;
    // 사용자 주소 → 직원 ID (직원 자신의 주소로 연결)
    mapping(address => uint256) private myEmployeeId;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // 직원 등록 (관리자만)
    function addEmployee(uint256 _id, address _addr, string calldata _name, uint32 _salary) external onlyOwner {
        employees[_id] = Employee({ name: _name, salary: _salary, exists: true });
        myEmployeeId[_addr] = _id;
    }

    // 직원 이름/급여 수정 (본인 주소로만)
    function updateMyInfo(string calldata _newName, uint32 _newSalary) external {
        uint256 id = myEmployeeId[msg.sender];
        require(employees[id].exists, "No employee record");
        employees[id].name = _newName;
        employees[id].salary = _newSalary;
    }

    // 직원 조회 (public)
    function getEmployee(uint256 _id) external view returns (string memory, uint32) {
        require(employees[_id].exists, "Employee not exists");
        Employee memory e = employees[_id];
        return (e.name, e.salary);
    }

    // 직원 삭제 (관리자만)
    function removeEmployee(uint256 _id) external onlyOwner {
        address addrToClear;
        // find address mapping (reverse lookup) (비효율적이지만 예제)
        // 여기선 사용자 주소가 매핑돼 있음을 가정하고 단순화:
        // myEmployeeId[..] 초기화 생략
        delete employees[_id];
    }

    // helper: 내 정보 조회
    function myInfo() external view returns (uint256 id, string memory name, uint32 salary) {
        uint256 myId = myEmployeeId[msg.sender];
        require(employees[myId].exists, "No employee record");
        Employee memory e = employees[myId];
        return (myId, e.name, e.salary);
    }
}
