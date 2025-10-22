// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// 간단한 외부 컨트랙트: 실패/성공을 선택적으로 발생시켜 try/catch 실습용
contract ExternalTarget {
    event Pinged(address from, bool willRevert);

    function ping(bool willRevert) external returns (string memory) {
        emit Pinged(msg.sender, willRevert);
        if (willRevert) {
            revert("ExternalTarget: forced revert");
        }
        return "pong";
    }
}

contract ControlPlayground {
    // 이벤트(로그)로 if/else 흐름 확인
    event Graded(uint256 score, string grade);
    event Summed(uint256 n, uint256 sum);
    event Factored(uint256 n, uint256 fact);
    event ExternalResult(string result);
    event ExternalFailed(string reason);

    // 1) if / else
    function grade(uint256 score) public returns (string memory) {
        string memory g;
        if (score >= 90) g = "A";
        else if (score >= 80) g = "B";
        else if (score >= 70) g = "C";
        else if (score >= 60) g = "D";
        else g = "F";
        emit Graded(score, g);
        return g;
    }

    // 2) for 루프 (상한을 두어 가스 폭탄 방지)
    function sumUpTo(uint256 n) public returns (uint256) {
        require(n <= 1_000, "n too big"); // 안전장치
        uint256 s;
        for (uint256 i = 1; i <= n; i++) {
            s += i;
        }
        emit Summed(n, s);
        return s;
    }

    // 3) while / do-while (역시 상한)
    function factorial(uint256 n) public returns (uint256) {
        require(n <= 20, "n too big"); // 21!부터는 256bit 범위 초과 위험
        uint256 i = 1;
        uint256 f = 1;
        while (i <= n) {
            f *= i;
            i++;
        }
        emit Factored(n, f);
        return f;
    }

    // 4) require / revert / assert
    uint256 public counter;
    function bump(uint256 by) public {
        require(by > 0, "by must be > 0"); // 사전조건
        uint256 old = counter;
        counter += by;

        // 불변식 예시: counter는 항상 old보다 크다
        assert(counter > old);
    }

    function strictOnlyEven(uint256 x) public pure returns (uint256) {
        if (x % 2 != 0) {
            revert("x must be even"); // 명시적 revert
        }
        return x / 2;
    }

    // 5) try / catch (외부 컨트랙트 호출)
    function callExternal(address target, bool willRevert) public returns (string memory) {
        try ExternalTarget(target).ping(willRevert) returns (string memory resp) {
            emit ExternalResult(resp);
            return resp; // "pong"
        } catch Error(string memory reason) {
            emit ExternalFailed(reason);
            return reason; // "ExternalTarget: forced revert"
        } catch {
            emit ExternalFailed("unknown error");
            return "unknown error";
        }
    }
}
