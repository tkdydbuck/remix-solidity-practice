// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/* ====== Custom errors required by the spec ====== */
error HaikuNotUnique();
error NotYourHaiku(uint id);
error NoHaikusShared();

/* ====== Minimal ERC-721 interface (needed for ownership) ====== */
interface IERC165 { function supportsInterface(bytes4) external view returns (bool); }
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint);
    function ownerOf(uint id) external view returns (address);
    function getApproved(uint id) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function approve(address to, uint id) external;
    function setApprovalForAll(address operator, bool approved) external;
    function transferFrom(address from, address to, uint id) external;
    function safeTransferFrom(address from, address to, uint id) external;
    function safeTransferFrom(address from, address to, uint id, bytes calldata data) external;
}
interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint id, bytes calldata data)
        external returns (bytes4);
}

/* ====== ✅ REQUIRED CONTRACT NAME ====== */
contract HaikuNFT is IERC721 {
    /* ---------- REQUIRED PUBLICS ---------- */
    struct Haiku { address author; string line1; string line2; string line3; }
    Haiku[] public haikus;                               // public array
    mapping(address => uint[]) public sharedHaikus;      // public mapping
    uint public counter;                                 // public counter (next id)

    /* ---------- ERC721 state ---------- */
    mapping(address => uint) private _balances;
    mapping(uint => address)  private _ownerOf;
    mapping(uint => address)  private _approvals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /* ---------- constructor ---------- */
    constructor() {
        // id가 0이 되지 않도록 더미 슬롯 하나를 넣고 counter를 1로 시작
        haikus.push(Haiku({author: address(0), line1: "", line2: "", line3: ""}));
        counter = 1;
    }

    /* ---------- Uniqueness tracking: any line must be unique across all lines ever used ---------- */
    mapping(bytes32 => bool) private _usedLineHash; // keccak256(line)

    /* ---------- ERC165 ---------- */
    function supportsInterface(bytes4 iid) external pure override returns (bool) {
        return iid == 0x80ac58cd /* ERC721 */ || iid == 0x01ffc9a7 /* ERC165 */;
    }

    /* ---------- ERC721 views ---------- */
    function balanceOf(address a) public view override returns (uint) { require(a!=address(0),"zero"); return _balances[a]; }
    function ownerOf(uint id) public view override returns (address) { address o=_ownerOf[id]; require(o!=address(0),"not minted"); return o; }
    function getApproved(uint id) public view override returns (address) { require(_ownerOf[id]!=address(0),"not minted"); return _approvals[id]; }
    function isApprovedForAll(address o, address op) public view override returns (bool) { return _operatorApprovals[o][op]; }

    /* ---------- ✅ REQUIRED: mintHaiku (external) with uniqueness check ---------- */
    function mintHaiku(string calldata a, string calldata b, string calldata c)
        external
        returns (uint id)
    {
        // If any line has ever appeared as any line before, reject.
        if (_usedLineHash[keccak256(bytes(a))] ||
            _usedLineHash[keccak256(bytes(b))] ||
            _usedLineHash[keccak256(bytes(c))]) {
            revert HaikuNotUnique();
        }
        // mark all three as used
        _usedLineHash[keccak256(bytes(a))] = true;
        _usedLineHash[keccak256(bytes(b))] = true;
        _usedLineHash[keccak256(bytes(c))] = true;

        id = counter;                   // use current counter as tokenId
        counter = id + 1;               // next id (so after 10 mints, counter==11)

        haikus.push(Haiku({ author: msg.sender, line1: a, line2: b, line3: c }));

        _mint(msg.sender, id);
    }

    /* ---------- ✅ REQUIRED: shareHaiku ---------- */
    function shareHaiku(address _to, uint id) public {
        if (ownerOf(id) != msg.sender) revert NotYourHaiku(id);
        sharedHaikus[_to].push(id);
    }

    /* ---------- ✅ REQUIRED: getMySharedHaikus ---------- */
    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint[] storage ids = sharedHaikus[msg.sender];
        if (ids.length == 0) revert NoHaikusShared();

        Haiku[] memory list = new Haiku[](ids.length);
        for (uint i = 0; i < ids.length; i++) {
            list[i] = haikus[ids[i]];
        }
        return list;
    }

    /* ---------- standard approvals/transfers ---------- */
    function approve(address to, uint id) public override {
        address o = ownerOf(id);
        require(msg.sender == o || isApprovedForAll(o, msg.sender), "not authorized");
        _approvals[id] = to;
        emit Approval(o, to, id);
    }
    function setApprovalForAll(address op, bool ok) external override {
        _operatorApprovals[msg.sender][op] = ok;
        emit ApprovalForAll(msg.sender, op, ok);
    }
    function transferFrom(address from, address to, uint id) public override {
        require(from == ownerOf(id), "from != owner");
        require(to != address(0), "to zero");
        require(
            msg.sender == from || msg.sender == getApproved(id) || isApprovedForAll(from, msg.sender),
            "not authorized"
        );
        _approve(address(0), id);
        _balances[from] -= 1;
        _balances[to]   += 1;
        _ownerOf[id] = to;
        emit Transfer(from, to, id);
    }
    function safeTransferFrom(address from, address to, uint id) external override {
        safeTransferFrom(from, to, id, "");
    }
    function safeTransferFrom(address from, address to, uint id, bytes memory data) public override {
        transferFrom(from, to, id);
        if (to.code.length > 0) {
            require(
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, data)
                    == IERC721Receiver.onERC721Received.selector,
                "unsafe receiver"
            );
        }
    }

    /* ---------- internals ---------- */
    function _mint(address to, uint id) internal {
        require(_ownerOf[id] == address(0), "exists");
        _balances[to] += 1;
        _ownerOf[id] = to;
        emit Transfer(address(0), to, id);
    }
    function _approve(address to, uint id) internal {
        _approvals[id] = to;
        emit Approval(ownerOf(id), to, id);
    }
}
