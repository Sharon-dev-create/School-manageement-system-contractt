//SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

contract teacherContract {

    // State Variables
    address public registry;
    address public studentContract;

    // Struct
    struct Teacher{
        string teacherName;
        uint256 subjectId;
        uint256 registeredAt;
        bool isActive;     
    }

    // Events
    event TeacherRegistered(address indexed teaherWallet, string name, uint256 subjectId);
    event TeacherDeactivated(address indexed teacherWallet);
    event TeacherReactivated(address indexed teacherWallet);
    event AttendanceMarked(address indexed teacher, address indexed student,
     bool present, uint256 date);
        
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
        require(bytes(name).length > 0, "Empty name");
            
            teachers[teacherWallet] = Teacher({
                teacherName: name,
                subjectId: subjectId,
                isActive: true,
                registeredAt: block.timestamp
            });

            teacherList.push(teacherWallet);

            emit TeacherRegistered(teacherWallet, name, subjectId);
    }

    // Deactivate teacher
    function deactivaeTeacher(address teacherWallet) external onlyRegistry{
        require(teachers[teacherWallet].isActive, "Teacher Not active");
        teachers[teacherWallet].isActive = false;

        emit TeacherReactivated(teacherWallet);
    }

    // Reactivate teacher
    function reactivaeTeacher(address teacherWallet) external onlyRegistry{
        require(!teachers[teacherWallet].isActive, "Teacher is active");
        require(teachers[teacherWallet].registeredAt > 0, "Teacher not found");
        teachers[teacherWallet].isActive = true;

        emit TeacherDeactivated(teacherWallet);
    }

    // Mark attendance
    function markAttendance(address student, bool present, uint256 date) external onlyActiveTeacher {
        require(student != address(0), "invalid student address");
        require(date <= block.timestamp, "Date cannot be in the future");

        (bool success, ) = studentContract.call(abi.encodeWithSignature(
            "logAttendance(address, bool, uint256)",
            student,
            present,
            date
        ));
        require(success, "Attendance marking failed");

        emit AttendanceMarked(msg.sender, student, present, date);
    }
   

    // Getter/ View functions
    /// Get teacher info
    function getTeacher(address teacherWallet) external view returns(Teacher memory){
        return teachers[teacherWallet];
    }

    function isActiveTeacher(address teacherWallet) external view returns(bool){
        return teachers[teacherWallet].isActive;

    }  

    function getAllTeachers() external view returns(uint256) {
        return teacherList.length;
    }

    // Admin Utility
    function setRegistry(address _registry) external onlyRegistry{
        
    }

}