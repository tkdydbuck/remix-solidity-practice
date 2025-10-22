// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleMapping {
    mapping(address => uint256) public balances;

    function setBalance(uint256 _balance) external {
        balances[msg.sender] = _balance;
    }

    function getBalance(address _addr) external view returns (uint256) {
        return balances[_addr];
    }

    function deleteBalance(address _addr) external {
        delete balances[_addr];
    }
}
