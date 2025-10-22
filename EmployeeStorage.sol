// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// 합계 초과 시: 문서 요구대로 newTotal 포함
error TooManyShares(uint256 newTotal);

contract EmployeeStorage {
    // 작은 정수형을 먼저 배치(슬롯 패킹)
    uint32 private salary;   // 0 ~ 1,000,000
    uint16 private shares;   // 초기 1000

    // 큰/동적 타입은 별도 슬롯
    string public name;
    uint256 public idNumber;

    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50_000;
        idNumber = 112_358_132_134;
    }

    // private 변수용 public accessor
    function viewSalary() public view returns (uint32) { return salary; }
    function viewShares() public view returns (uint16) { return shares; }

    // 요구사항:
    // 1) _newShares > 5000  → "Too many shares" (문자열 리버트)
    // 2) shares + _newShares > 5000 → 커스텀 에러 TooManyShares(newTotal)
    //    ※ 파라미터 타입을 uint16으로 두어 테스트 쪽 ABI와 완전히 일치시킴
    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares"); // 대소문자/공백 정확히
        }

        // 합계는 넉넉히 32비트에서 계산 후 비교
        uint32 next = uint32(shares) + uint32(_newShares);
        if (next > 5000) {
            revert TooManyShares(next);
        }

        shares = uint16(next);
    }

    // (채점용) 패킹 확인 – 그대로 둘 것
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly { r := sload(_slot) }
    }

    // (채점용) 상태 초기화
    function debugResetShares() public { shares = 1000; }
}
