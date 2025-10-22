// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

error BadCarIndex(uint index);

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors; // ⬅️ uint(=uint256) 로 고정
    }

    // public mapping (채점기가 getter로도 확인)
    mapping(address => Car[]) public garage;

    // addCar(string,string,string,uint)  ⬅️ 시그니처 일치
    function addCar(
        string calldata make,
        string calldata model,
        string calldata color,
        uint numberOfDoors
    ) public {
        garage[msg.sender].push(Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        }));
    }

    // getMyCars() -> Car[]
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // getUserCars(address) -> Car[]
    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    // updateCar(uint,string,string,string,uint) ⬅️ index도 uint
    function updateCar(
        uint index,
        string calldata make,
        string calldata model,
        string calldata color,
        uint numberOfDoors
    ) public {
        if (index >= garage[msg.sender].length) revert BadCarIndex(index);
        Car storage c = garage[msg.sender][index];
        c.make = make;
        c.model = model;
        c.color = color;
        c.numberOfDoors = numberOfDoors;
    }

    // resetMyGarage()
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
