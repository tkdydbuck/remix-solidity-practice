// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

library SillyStringUtils {
    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    // line 끝에 🤷 이모지를 붙여서 반환
    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}

