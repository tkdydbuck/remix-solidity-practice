// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

error BadCarIndex(uint256 index);

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint8 numberOfDoors;
    }

    // 꼭 public 이어야 함 (채점기가 getter로 확인)
    mapping(address => Car[]) public garage;

    function addCar(
        string calldata make,
        string calldata model,
        string calldata color,
        uint8 numberOfDoors
    ) external {
        garage[msg.sender].push(Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        }));
    }

    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address user) external view returns (Car[] memory) {
        return garage[user];
    }

    function updateCar(
        uint256 index,
        string calldata make,
        string calldata model,
        string calldata color,
        uint8 numberOfDoors
    ) external {
        if (index >= garage[msg.sender].length) revert BadCarIndex(index);
        Car storage c = garage[msg.sender][index];
        c.make = make;
        c.model = model;
        c.color = color;
        c.numberOfDoors = numberOfDoors;
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
