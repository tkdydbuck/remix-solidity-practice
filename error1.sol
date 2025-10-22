// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with its neighbor (a↔b, b↔c, c↔d)
     * and returns the absolute difference for each pairing.
     */
function diffWithNeighbor(
    uint _a,
    uint _b,
    uint _c,
    uint _d
) public pure returns (uint[] memory) {
    uint[] memory results = new uint[](3); // Declare and initialize

    // Compute absolute differences
    results[0] = (_a >= _b) ? (_a - _b) : (_b - _a);
    results[1] = (_b >= _c) ? (_b - _c) : (_c - _b);
    results[2] = (_c >= _d) ? (_c - _d) : (_d - _c);

    return results;
}

    /**
     * Changes the _base by the value of _modifier.
     * Constraints: _base >= 1000, _modifier in [-100, 100].
     * Use safe signed math then cast back to uint.
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        require(_base >= 1000, "base too small");
        require(_modifier >= -100 && _modifier <= 100, "modifier out of range");

        int result = int(_base) + _modifier;    // do the math in signed space
        require(result >= 0, "negative result"); // sanity guard
        return uint(result);
    }

    /**
     * Pop the last element from the internal array and return the popped value.
     * (Unlike built-in pop(), this function returns the removed value.)
     */
    uint[] arr;

    function popWithReturn() public returns (uint) {
        uint len = arr.length;
        require(len > 0, "empty");
        uint last = arr[len - 1];
        arr.pop();                 // actually shrink the array
        return last;
    }

    // Utility functions from the starter (unchanged)
    function addToArr(uint _num) public { arr.push(_num); }
    function getArr() public view returns (uint[] memory) { return arr; }
    function resetArr() public { delete arr; }
}
