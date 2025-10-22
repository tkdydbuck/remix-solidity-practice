// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/**
 * 표준 ERC-20 (SBS용 최소본)
 * - 이름/심볼/디시멀/총발행량
 * - balanceOf / transfer / allowance / approve / transferFrom
 * - Transfer/Approval 이벤트
 */
contract ERC20SBS {
    string public name = "BaseERC20SBS";
    string public symbol = "BES";
    uint8  public decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // 예시: 1,000,000 토큰을 배포자에게
        uint256 initial = 1_000_000 * (10 ** uint256(decimals));
        totalSupply = initial;
        balanceOf[msg.sender] = initial;
        emit Transfer(address(0), msg.sender, initial);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "to zero");
        uint256 fromBal = balanceOf[msg.sender];
        require(fromBal >= value, "insufficient");
        unchecked { balanceOf[msg.sender] = fromBal - value; }
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(to != address(0), "to zero");
        uint256 fromBal = balanceOf[from];
        require(fromBal >= value, "insufficient");
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= value, "allowance");
        unchecked {
            balanceOf[from] = fromBal - value;
            allowance[from][msg.sender] = allowed - value;
        }
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }
}
