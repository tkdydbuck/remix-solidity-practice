// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// ✅ Child contract moved outside
contract Child {
    address public owner;
    uint256 public value;

    constructor(address _owner, uint256 _value) {
        owner = _owner;
        value = _value;
    }
}

contract NewKeywordExercise {
    mapping(address => address[]) private _childrenOf;
    event ChildCreated(address indexed creator, address child, uint256 value);

    function createOne(uint256 initial) public returns (address child) {
        Child c = new Child(msg.sender, initial);
        _childrenOf[msg.sender].push(address(c));
        emit ChildCreated(msg.sender, address(c), initial);
        return address(c);
    }

    function deploy() external returns (address child) {
        Child c = new Child(msg.sender, 0);
        _childrenOf[msg.sender].push(address(c));
        emit ChildCreated(msg.sender, address(c), 0);
        return address(c);
    }

    function deploy(uint256 initial) external returns (address child) {
        Child c = new Child(msg.sender, initial);
        _childrenOf[msg.sender].push(address(c));
        emit ChildCreated(msg.sender, address(c), initial);
        return address(c);
    }

    function createMany(uint256[] calldata values) external returns (address[] memory addrs) {
        uint256 n = values.length;
        addrs = new address[](n);
        for (uint256 i = 0; i < n; i++) {
            Child c = new Child(msg.sender, values[i]);
            addrs[i] = address(c);
            _childrenOf[msg.sender].push(address(c));
            emit ChildCreated(msg.sender, address(c), values[i]);
        }
    }

    function getMyChildren() external view returns (address[] memory) {
        return _childrenOf[msg.sender];
    }

    function getUserChildren(address user) external view returns (address[] memory) {
        return _childrenOf[user];
    }

    function resetMyChildren() external {
        delete _childrenOf[msg.sender];
    }

    function getChildCount(address user) external view returns (uint256) {
        return _childrenOf[user].length;
    }
}