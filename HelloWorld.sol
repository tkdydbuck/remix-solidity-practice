// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract AdderSubtractor {
    /// @notice Add two uint256 without reverting on overflow (wrap-around).
    /// @param a First operand.
    /// @param b Second operand.
    /// @return sum The wrapped sum a + b.
    /// @return err True if overflow occurred.
    function adder(uint256 a, uint256 b)
        external
        pure
        returns (uint256 sum, bool err)
    {
        unchecked { sum = a + b; }     // wrap-around OK
        err = (sum < a);               // overflow detection
    }

    /// @notice Subtract two uint256; if underflow, clamp to 0 and set err=true.
    /// @param a Minuend.
    /// @param b Subtrahend.
    /// @return diff Result (0 on underflow).
    /// @return err True if underflow occurred.
    function subtractor(uint256 a, uint256 b)
        external
        pure
        returns (uint256 diff, bool err)
    {
        if (a < b) {
            // 테스트 기대: 1 - 2 => 0, err=true
            return (0, true);
        }
        unchecked { diff = a - b; }    // 정상 범위
        return (diff, false);
    }
}
