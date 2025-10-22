// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] public senders;
    uint[] public timestamps;

    function getNumbers() public view returns (uint[] memory) {
        uint len = numbers.length;
        uint[] memory out = new uint[](len);
        for (uint i = 0; i < len; i++) {
            out[i] = numbers[i];
        }
        return out;
    }

    // ✅ 여기에서 fresh 변수를 선언해야 함
    function resetNumbers() public {
    uint[] memory fresh = new uint[](10); // Declare and initialize
    for (uint i = 0; i < 10; i++) {
        fresh[i] = i + 1;  // Fill with 1..10
    }
    numbers = fresh;  // Copy memory → storage
}

    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint constantY2K = 946_702_800;
        uint count;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > constantY2K) {
                count++;
            }
        }

        uint[] memory ts = new uint[](count);
        address[] memory snd = new address[](count);
        uint idx;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > constantY2K) {
                ts[idx] = timestamps[i];
                snd[idx] = senders[i];
                idx++;
            }
        }
        return (ts, snd);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }
}
