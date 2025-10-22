// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// Exercise 요구: 승인 안 된 앨범이면 커스텀 에러로 거절
error NotApproved(string album);

contract FavoriteRecords {
    // 승인된 앨범 목록: 이름 => true/false (public getter 필요)
    mapping(string => bool) public approvedRecords;
    // 유저별 즐겨찾기 여부: 유저주소 => (앨범이름 => true/false)
    mapping(address => mapping(string => bool)) public userFavorites;

    // 목록 반환을 위해 배열을 함께 유지(문서의 "helper array" 아이디어와 동일)
    string[] private _approvedList;
    mapping(address => string[]) private _favoritesList; // 유저별 즐겨찾기 리스트

    constructor() {
        // 문서에 지정된 9개 앨범 미리 로드
        _addApproved("Thriller");
        _addApproved("Back in Black");
        _addApproved("The Bodyguard");
        _addApproved("The Dark Side of the Moon");
        _addApproved("Their Greatest Hits (1971-1975)");
        _addApproved("Hotel California");
        _addApproved("Come On Over");
        _addApproved("Rumours");
        _addApproved("Saturday Night Fever");
    }

    // 내부: 승인 앨범 추가(배열과 매핑 동기화)
    function _addApproved(string memory name) internal {
        if (!approvedRecords[name]) {
            approvedRecords[name] = true;
            _approvedList.push(name);
        }
    }

    // ✅ 요구 함수: 승인된 앨범 전체 반환
    function getApprovedRecords() external view returns (string[] memory) {
        return _approvedList;
    }

    // ✅ 요구 함수: 승인된 경우에만 추가, 아니면 NotApproved로 revert
    function addRecord(string calldata album) external {
        if (!approvedRecords[album]) revert NotApproved(album);
        // 중복 방지: 처음 추가할 때만 리스트에 push
        if (!userFavorites[msg.sender][album]) {
            userFavorites[msg.sender][album] = true;
            _favoritesList[msg.sender].push(album);
        }
    }

    // ✅ 요구 함수: 특정 주소의 즐겨찾기 리스트 반환
    function getUserFavorites(address user)
        external
        view
        returns (string[] memory)
    {
        return _favoritesList[user];
    }

    // ✅ 요구 함수: 내 즐겨찾기 초기화
    function resetUserFavorites() external {
        // 매핑을 false로 되돌리고 배열 비우기
        string[] storage list = _favoritesList[msg.sender];
        for (uint256 i = 0; i < list.length; i++) {
            userFavorites[msg.sender][list[i]] = false;
        }
        delete _favoritesList[msg.sender];
    }

    // ────────── (SBS에서 다루는 msg.sender 활용 예시: balances) ──────────
    // 선택적이지만 학습페이지 흐름과 일치:
    mapping(address => uint256) public favoriteNumbers;

    function saveFavoriteNumber(uint _favorite) external {
        favoriteNumbers[msg.sender] = _favorite; // using msg.sender
    }
}
