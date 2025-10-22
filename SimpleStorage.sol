// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract HelloBase {
    string public message = "Hello Base!";

    function setMessage(string calldata _m) external {
        message = _m;
    }
}
