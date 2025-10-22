// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

error InsufficientTokens(int256 newSenderBalance);

contract MinimalToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;

    constructor() {
        // 총발행량 3000, 3개 주소에 균등 분배(문서 예시)
        totalSupply = 3000;

        // Remix 첫 세 계정 예시(문서와 동일)
        // msg.sender
        balances[msg.sender] = totalSupply / 3;
        // 2번째 / 3번째 계정(문서 예시 주소)
        balances[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = totalSupply / 3;
        balances[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = totalSupply / 3;
    }

    function transfer(address _to, uint256 _amount) public {
        // 언더플로우를 에러로 명시적으로 처리 (문서 취지)
        int256 newSenderBalance = int256(balances[msg.sender]) - int256(_amount);
        if (newSenderBalance < 0) {
            revert InsufficientTokens(newSenderBalance);
        }

        balances[msg.sender] = uint256(newSenderBalance);
        balances[_to] += _amount;
    }
}
