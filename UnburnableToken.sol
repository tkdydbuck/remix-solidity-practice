// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

error TokensClaimed();        // 같은 지갑의 2회 청구 금지
error AllTokensClaimed();     // 총 발행량 한도 도달
error UnsafeTransfer(address to); // zero 주소 또는 ETH 잔고 0 주소로의 전송 금지

contract UnburnableToken {
    mapping(address => uint256) public balances;

    uint256 public totalSupply;   // = 100,000,000
    uint256 public totalClaimed;  // 누적 청구량
    mapping(address => bool) private _claimed; // 지갑별 1회 청구 제한

    uint256 private constant CLAIM_AMOUNT = 1000;
    address private constant ZERO = address(0);

    constructor() {
        totalSupply = 100_000_000;
        // 초기 배분 없음(모두 claim으로만 배포)
    }

    /// 누구나 1회만 1000 토큰 청구. 한도 초과 시/재청구 시 revert.
    function claim() public {
        if (_claimed[msg.sender]) revert TokensClaimed();

        uint256 newTotal = totalClaimed + CLAIM_AMOUNT;
        if (newTotal > totalSupply) revert AllTokensClaimed();

        _claimed[msg.sender] = true;
        totalClaimed = newTotal;
        balances[msg.sender] += CLAIM_AMOUNT;
    }

    /// 수신자가 zero address가 아니고, Base Sepolia ETH 잔고가 > 0이어야만 전송 허용.
    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == ZERO || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        // 기본 전송(언더플로우는 0.8.x에서 자동 revert)
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
