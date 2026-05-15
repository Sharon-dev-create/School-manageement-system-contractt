//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract SchoolRegistry{
    // State variables
    string public schoolName;
    address public admin;
    address public teacherContract;
    address public studentContract;

    // Mapping
    mapping(address => bool) public isTeacher;
    mapping(address => bool) public isStudent;
    
    // Events
    event TeacherRegistered(address indexed teacherWallet, uint256 subjectId);
    
    // Modifiers
    modifier onlyAdmin(){
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _teacherContract, address _studentContract, string memory _schoolName){
        require(_teacherContract != address(0), "Invalid teacher contract");
    }
}