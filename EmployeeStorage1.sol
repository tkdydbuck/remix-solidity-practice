// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @notice shares 총합이 5,000을 넘으면 발생
error TooManyShares();

contract EmployeeStorage {
    // 작은 정수형을 앞에 붙여 슬롯 패킹 유리
    uint32 private salary;   // 0 ~ 1,000,000
    uint16 private shares;   // 보유 주식 수 (예: 1000)

    // 동적 타입과 큰 정수는 별도 슬롯
    string public name;      // 직원 이름
    uint256 public idNumber; // 직원 ID (비연속)

    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50_000;
        idNumber = 112_358_132_134;
    }

    // 조회
    function viewSalary() external view returns (uint32) { return salary; }
    function viewShares() external view returns (uint16) { return shares; }

    /// @notice 주식 부여 로직
    /// - _newShares > 5000 → revert("Too many shares")
    /// - (shares + _newShares) > 5000 → revert TooManyShares()
    function grantShares(uint256 _newShares) external {
        if (_newShares > 5000) revert("Too many shares");
        uint256 next = uint256(shares) + _newShares;
        if (next > 5000) revert TooManyShares();
        shares = uint16(next);
    }

    // 선택: 급여/이름 수정 (급여 상한 체크)
    function setSalary(uint32 _salary) external {
        require(_salary <= 1_000_000, "salary too high");
        salary = _salary;
    }
    function setName(string calldata _name) external {
        name = _name;
    }

    // 디버그: 특정 스토리지 슬롯 값 조회 (패킹 확인용)
    function storageSlot(uint256 slot) external view returns (bytes32 val) {
        assembly { val := sload(slot) }
    }
}
