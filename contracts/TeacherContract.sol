//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

contract teacherContract {

    // State Variables
    address public registry;
    address public studentContract;

    // Struct
    struct Teacher{
        uint256 teacherId;
        uint256 classId;
        uint256 gradeSubmitted;
        string teacherName;
        bool isActive;     
    }

    // Events
    // event for teacherRegistered
    // event for teacherDeactivated
    // event for teacherReactivated
    // event for subjectAssigned
    // event for attendanceMarked
        
    // Mappings
    mapping(address => Teacher) public teachers;
    address[] public teacherList;

    // Modifiers
    modifier onlyRegistry(){
        require(msg.sender == registry, "Only registry");
        _;
    }

    modifier onlyActiveTeacher(){
        require(teachers[msg.sender].isActive, "Not an active teacher");
        _;
    }

    constructor(address _registry, address _studentContract){
        require(_registry != address(0), "Invalid registry address");
        require(_studentContract != address(0), "Invalid student contract address");
        registry = _registry;
        studentContract = _studentContract;
    }

    // Functions 
    // Register teacher
    function registerTeacher(address teacherWallet, string calldata name, uint256 subjectId) external onlyRegistry{
        require(teacherWallet != address(0), "Invalid address");
        require(!teachers[teacherWallet].isActive, "Already a teacher");

        teachers[teacherWallet] = Teacher({
            teacherId: teacherList.length + 1,
            classId: subjectId,
            gradeSubmitted: 0,
            teacherName: name,
            isActive: true
        });
        teacherList.push(teacherWallet);
    }

    // Assign subject and class

    // Deactivate teacher

    // Reactivate teacher

    // Mark attendance

    // update grades

    

    // Getter functions
    /// Get teacher info

    


}