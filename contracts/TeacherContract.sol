//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

contract teacherContract{

    // State Variables

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

    // Functions 
    // Register teacher

    // Assign subject and class

    // Deactivate teacher

    // Reactivate teacher

    // Mark attendance

    // update grades

    

    // Getter functions
    /// Get teacher info

    


}