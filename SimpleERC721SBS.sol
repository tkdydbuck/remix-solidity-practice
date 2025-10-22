// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// ───────── ERC165 ─────────
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// ───────── ERC721 ─────────
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 id) external view returns (address);
    function getApproved(uint256 id) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function approve(address to, uint256 id) external;
    function setApprovalForAll(address operator, bool approved) external;

    function transferFrom(address from, address to, uint256 id) external;
    function safeTransferFrom(address from, address to, uint256 id) external;
    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) external;
}

// ───────── 수신자 인터페이스 ─────────
interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 id, bytes calldata data)
        external returns (bytes4);
}

// ───────── 메타데이터(선택) ─────────
interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
}

contract SimpleERC721SBS is IERC721Metadata {
    string private _name = "BaseSBS";
    string private _symbol = "SBS";

    // owner → balance
    mapping(address => uint256) private _balances;
    // tokenId → owner
    mapping(uint256 => address) private _ownerOf;
    // tokenId → approved
    mapping(uint256 => address) private _approvals;
    // owner → operator → approved
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // 간단한 onlyOwner(민팅 보호용)
    address public owner;
    modifier onlyOwner() { require(msg.sender == owner, "not owner"); _; }
    constructor() { owner = msg.sender; }

    // ───── metadata
    function name() external view override returns (string memory) { return _name; }
    function symbol() external view override returns (string memory) { return _symbol; }

    // ───── views
    function supportsInterface(bytes4 iid) external pure override returns (bool) {
        return iid == 0x80ac58cd /* ERC721 */ ||
               iid == 0x5b5e139f /* ERC721Metadata */ ||
               iid == 0x01ffc9a7 /* ERC165 */;
    }
    function balanceOf(address a) public view override returns (uint256) { require(a != address(0), "zero"); return _balances[a]; }
    function ownerOf(uint256 id) public view override returns (address) { address o=_ownerOf[id]; require(o!=address(0),"not minted"); return o; }
    function getApproved(uint256 id) public view override returns (address) { require(_ownerOf[id]!=address(0),"not minted"); return _approvals[id]; }
    function isApprovedForAll(address o, address op) public view override returns (bool) { return _operatorApprovals[o][op]; }

    // ───── approvals
    function approve(address to, uint256 id) public override {
        address o = ownerOf(id);
        require(msg.sender == o || isApprovedForAll(o, msg.sender), "not authorized");
        _approvals[id] = to;
        emit Approval(o, to, id);
    }
    function setApprovalForAll(address op, bool ok) external override {
        _operatorApprovals[msg.sender][op] = ok;
        emit ApprovalForAll(msg.sender, op, ok);
    }

    // ───── transfers
    function transferFrom(address from, address to, uint256 id) public override {
        require(from == ownerOf(id), "from != owner");
        require(to != address(0), "to zero");
        require(
            msg.sender == from || msg.sender == getApproved(id) || isApprovedForAll(from, msg.sender),
            "not authorized"
        );
        _approve( address(0), id );
        _balances[from] -= 1;
        _balances[to]   += 1;
        _ownerOf[id] = to;
        emit Transfer(from, to, id);
    }
    function safeTransferFrom(address from, address to, uint256 id) external override {
        safeTransferFrom(from, to, id, "");
    }
    function safeTransferFrom(address from, address to, uint256 id, bytes memory data) public override {
        transferFrom(from, to, id);
        if (_isContract(to)) {
            require(
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, data)
                    == IERC721Receiver.onERC721Received.selector,
                "unsafe receiver"
            );
        }
    }

    // ───── mint (SBS 핵심)
    function mint(address to, uint256 id) external onlyOwner {
        require(to != address(0), "to zero");
        require(_ownerOf[id] == address(0), "exists");
        _balances[to] += 1;
        _ownerOf[id] = to;
        emit Transfer(address(0), to, id);
    }

    // ───── internal utils
    function _approve(address to, uint256 id) internal {
        _approvals[id] = to;
        emit Approval(ownerOf(id), to, id);
    }
    function _isContract(address a) private view returns (bool) {
        return a.code.length > 0;
    }
}
