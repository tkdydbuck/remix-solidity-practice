// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/**
 * Error Triage – 통합 연습 컨트랙트
 * - 다양한 실패 유형을 재현하는 함수들
 * - 성공/실패를 명확히 구분해 디버깅 훈련 가능
 */

error Unauthorized();
error NotEnoughFunds(uint requested, uint available);
error IndexOutOfBounds(uint index, uint length);

contract ErrorTriageSubmission {
    address public owner;
    uint[] private store;
    uint public balanceOfContract;

    constructor() {
        owner = msg.sender;
        // 초기 데이터
        store.push(10);
        store.push(20);
        store.push(30);
        balanceOfContract = 1 ether;
    }

    // 1) 성공 케이스: 단순 읽기
    function okGet(uint i) external view returns (uint) {
        require(i < store.length, "index too large");
        return store[i];
    }

    // 2) require 실패 케이스 (메시지 포함)
    function causeRequire(uint i) external view returns (uint) {
        require(i < store.length, "index out of range (require)");
        return store[i];
    }

    // 3) revert 실패 케이스 (문자열)
    function causeRevertString() external pure {
        revert("manual revert happened");
    }

    // 4) 커스텀 에러
    function causeCustomError(uint need) external view {
        if (need > balanceOfContract) {
            revert NotEnoughFunds(need, balanceOfContract);
        }
    }

    // 5) 권한 오류 (커스텀 에러)
    function onlyOwnerAction() external view {
        if (msg.sender != owner) revert Unauthorized();
    }

    // 6) Panic 오류: assert 실패 (0x01)
    function causeAssert() external pure {
        // 의도적 실패
        assert(false);
    }

    // 7) Panic 오류: 0으로 나누기 (0x12)
    function causeDivideByZero(uint x) external pure returns (uint) {
        uint z = x / 0; // 의도적 divide-by-zero
        return z;
    }

    // 8) 배열 인덱스 초과 – 커스텀 에러로 래핑
    function causeOutOfBounds(uint i) external view returns (uint) {
        if (i >= store.length) revert IndexOutOfBounds(i, store.length);
        return store[i];
    }

    // 9) 상태 변경 성공 케이스
    function okAppend(uint v) external {
        store.push(v);
    }

    // 10) 상태 리셋 (테스트 반복용)
    function reset() external {
        delete store;
        store.push(10);
        store.push(20);
        store.push(30);
        balanceOfContract = 1 ether;
    }

    // 11) 헬퍼: 길이 조회
    function length() external view returns (uint) {
        return store.length;
    }
}
