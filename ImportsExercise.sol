// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    using SillyStringUtils for string;

    // 문서 요구: public 인스턴스 'haiku'
    SillyStringUtils.Haiku public haiku;

    // 3줄 저장
    function saveHaiku(
        string memory a,
        string memory b,
        string memory c
    ) public {
        haiku = SillyStringUtils.Haiku({ line1: a, line2: b, line3: c });
    }

    // 구조체 전체 반환 (public getter는 멤버별 반환이라 별도 구현)
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // 원본은 변경하지 않고, line3 끝에 shrug 추가된 사본을 반환
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory copy = haiku;
        copy.line3 = copy.line3.shruggie(); // using으로 연결된 라이브러리 호출
        return copy;
    }
}
