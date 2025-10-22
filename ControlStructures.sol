// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ControlStructures (Base Docs exercise)
/// @notice Implements fizzBuzz and a time-based doNotDisturb flow.
contract ControlStructures {
    // ----- Smart Contract FizzBuzz -----
    // Return:
    // - "FizzBuzz" if divisible by 3 and 5
    // - "Fizz"     if divisible by 3
    // - "Buzz"     if divisible by 5
    // - "Splat"    otherwise
    function fizzBuzz(uint _number) external pure returns (string memory) {
        if (_number % 15 == 0) return "FizzBuzz";
        if (_number % 3 == 0)  return "Fizz";
        if (_number % 5 == 0)  return "Buzz";
        return "Splat";
    }

    // ----- Do Not Disturb -----
    // Rules (Base docs):
    // - If _time >= 2400 -> PANIC (use assert)
    // - If _time > 2200 or _time < 800 -> revert with custom error AfterHours(_time)
    // - If 1200 <= _time <= 1259 -> revert with string "At lunch!"
    // - If  800 <= _time <= 1199 -> return "Morning!"
    // - If 1300 <= _time <= 1799 -> return "Afternoon!"
    // - If 1800 <= _time <= 2200 -> return "Evening!"
    error AfterHours(uint _time);

    function doNotDisturb(uint _time) external pure returns (string memory) {
        // 1) PANIC when _time >= 2400
        assert(_time < 2400); // triggers a panic error otherwise

        // 2) After-hours custom error
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        // 3) Lunch window
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }

        // 4) Time ranges
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }
        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }
        if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // theoretically unreachable (all cases covered above)
        return "Splat";
    }
}
