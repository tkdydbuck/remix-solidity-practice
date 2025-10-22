// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// ---- custom errors ----
error Unauthorized();
error NotEnoughFunds(uint256 requested, uint256 available);
error IndexOutOfBounds(uint256 index, uint256 length);

contract ErrorTriageExercise {
    address public owner;
    uint256[] private store;
    uint256 public vault;

    constructor() {
        owner = msg.sender;
        // 기본 데이터
        store.push(10);
        store.push(20);
        store.push(30);
        vault = 1 ether;
    }

    // ---------- OK (성공 케이스) ----------
    function ok() external pure returns (uint256) { return 42; }
    function okGet(uint256 i) external view returns (uint256) {
        require(i < store.length, "index too large");
        return store[i];
    }
    function okAppend(uint256 v) external { store.push(v); }

    // ---------- require ----------
    function requireFail() external pure { require(false, "require failed"); }
    function causeRequire() external pure { require(false, "require failed"); }

    // ---------- revert(string) ----------
    function revertString() external pure { revert("manual revert happened"); }
    function causeRevert() external pure { revert("manual revert happened"); }

    // ---------- custom error ----------
    function onlyOwner() external view { if (msg.sender != owner) revert Unauthorized(); }
    function customError() external view { if (vault < type(uint256).max) revert NotEnoughFunds(type(uint256).max, vault); }

    // ---------- panic(assert / div0) ----------
    function assertFail() external pure { assert(false); }                  // panic(0x01)
    function divideByZero() external pure returns (uint256) { uint256 x=1; return x/0; } // panic(0x12)

    // ---------- out-of-bounds ----------
    function outOfBounds(uint256 i) external view returns (uint256) {
        if (i >= store.length) revert IndexOutOfBounds(i, store.length);
        return store[i];
    }

    // ---------- helper ----------
    function length() external view returns (uint256) { return store.length; }
    function reset() external {
        delete store;
        store.push(10);
        store.push(20);
        store.push(30);
        vault = 1 ether;
    }
}
