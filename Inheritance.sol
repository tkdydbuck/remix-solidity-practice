// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/* 1) Abstract base */
abstract contract Employee {
    uint public idNumber;
    uint public managerId;

    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint);
}

/* 2) Salaried */
contract Salaried is Employee {
    uint public annualSalary;

    constructor(uint _idNumber, uint _managerId, uint _annualSalary)
        Employee(_idNumber, _managerId)
    {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

/* 3) Hourly (연간 2080시간 가정) */
contract Hourly is Employee {
    uint public hourlyRate;

    constructor(uint _idNumber, uint _managerId, uint _hourlyRate)
        Employee(_idNumber, _managerId)
    {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view override returns (uint) {
        return hourlyRate * 2080;
    }
}

/* 4) Manager 유틸 */
contract Manager {
    uint[] public reports;

    function addReport(uint _employeeId) public {
        reports.push(_employeeId);
    }

    function resetReports() public {
        delete reports;
    }
}

/* 5) Salesperson = Hourly 상속 */
contract Salesperson is Hourly {
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate)
        Hourly(_idNumber, _managerId, _hourlyRate)
    {}
}

/* 6) EngineeringManager = Salaried + Manager 다중상속 */
contract EngineeringManager is Salaried, Manager {
    constructor(uint _idNumber, uint _managerId, uint _annualSalary)
        Salaried(_idNumber, _managerId, _annualSalary)
    {}
}

/* 7) 제출용: 내부에서 필요한 컨트랙트들을 직접 배포해 둠 (인자 없음) */
contract InheritanceSubmissionAuto {
    Salesperson public salesPerson;
    EngineeringManager public engineeringManager;

    constructor() {
        // 문서 예시 값 고정
        salesPerson = new Salesperson(55555, 12345, 20);
        engineeringManager = new EngineeringManager(54321, 11111, 200000);
    }
}
