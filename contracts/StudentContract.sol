//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract studentContract{
    // State variables

    // Struct
    struct Student{
        uint256 sudentId;
        uint256 class;
        uint256 grade;
        string name;
        bool isEnrolled;
        bool isGraduated;
        bool isSuspended;
        bytes32 certificate;
        AttendanceRecord[] attendance;
        Result[] results;
    }
    
    struct Result {
    uint256 subjectId;
    uint8 score;
    address gradedBy;
    uint256 timestamp;
   }

    struct AttendanceRecord {
    uint256 date;
    bool present;
    address markedBy;
    }

    // Events

    // Mapping
    mapping(address => Student) public student;

    // Modifiers
    // only Teacher modifier

    // Functions
    // Register students
    // function registerStudent(uint256 _studentId, string memory name,
    // uint256 class ) public 
    // Update student info
    // Suspend student
    // Return student
    // Reactivate 


    //Getter Functions
    // Get student info
    // View grades function
    // View attendance function

}