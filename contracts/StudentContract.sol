//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract studentContract{
    // State variables

    // Struct
    struct student{
        uint256 sudentId;
        uint256 class;
        uint256 grade;
        string name;
        address student;
    }
    
    // Enums
    enum {
        Absent,
        Present
    }

    // Events

    // Mapping
    mapping(address => Student) public student;

    // Modifiers
    // only Teacher modifier

    // Functions

    // Register students
    // Update student info
    // deactivate student
    // Reactivate 


    //Getter Functions
    // Get student info
    // View grades function
    // View attendance function

}