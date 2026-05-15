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
    event TeacherDeactivated(address indexed teacherWallet);
    event StudentEnrolled(address indexed studentWallet, uint256 courseId);
    event SchoolNameUpdated(string schoolName);
    
    // Modifiers
    modifier onlyAdmin(){
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _teacherContract, address _studentContract, string memory _schoolName){
        require(_teacherContract != address(0), "Invalid teacher contract");
        require(_studentContract != address(0), "Invalid student contract");
        require(bytes(_schoolName).length > 0, "Empty school name");

        admin = msg.sender;
        teacherContract = _teacherContract;
        studentContract = _studentContract;
        schoolName = _schoolName;
    }

    // functions
    function registerTeacher(string calldata name, address teacherWallet, uint256 subjectId) public onlyAdmin{
        require(teacherWallet != address(0), "Invalid address");
        require(!isTeacher[teacherWallet], "already a teacher");

        (bool success, ) = teacherContract.call(abi.encodeSignature(
            "registerTeacher(address, string, uint256)",
            teacherWallet,
            name,
            subjectId
        ));
        require(success, "Teacher registration failed");

        isTeacher[teacherWallet] = true;
        emit TeacherRegistered(teacherWallet, subjectId);
    }

    function deactivateTeacher(address wallet) external onlyAdmin {
        require(isTeacher[teacherWallet], "Not a Teacher");

        (bool success, ) = teacherContract.call(abi.encodeSignature(
            "deactivateTeacher(address)",
            teacherWallet
        ));
        require(sucess, "Teacher deactivation failed");

        isTeacher[teacherWallet] = false;
        emit TeacherDeactivated(teacherWallet);
    }

    function enrollStudent(uint256 courseId, address studentWallet, student calldata name) external onlyAdmin{
        require(studentWallet != address(0), "Invalid address");
        require(isStudent[studentWallet], "Already enrolled");

        (bool success, ) = studentContract.call(abi.encodeSignature(
            "enrollStudent(address, string, uint256)",
              studentWallet,
              name,
              courseId
        ));
        require(success, "Student enrollment failed");
        isStudent[studentWallet] = true;
        emit StudentEnrolled(studentWallet, courseId);
    }

    function setSchoolName(string calldata _schoolName) external onlyAdmin {
        require(bytes(_schoolName).length > 0, "Empty name");
        
        schoolName = _schoolName;
        emit SchoolNameUpdated(_schoolName);
    }

    function setTeacherContract(address _address) external onlyAdmin{
        require(_address != address(0), "Invalid contract");
        teacherContract = _address;
    }
    
    function setStudentContract(address _address) external onlyAdmin{
        require(_address != address(0), "Invalid contract");
        studentContract = _address;
    }
}