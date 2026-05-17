//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract studentContract{
    address public registry;
    // State variables

    // Struct
    struct Student{
        uint256 studentId;
        uint256 class;
        string name;
        bool isEnrolled;
        bool isGraduated;
        bool isSuspended;
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
    mapping (address => Result[]) public results;
    mapping(address => AttendanceRecord[]) public attendanceLog;

    address[] public studentList;

    // Events
    event StudentEnrolled(address indexed studentWallet, string name, uint256 courseId);

    // Modifiers
    // only Teacher modifier
    modifier onlyTeacher(){
       (bool ok, bytes memory data) = registry.call(
        abi.encodeWithSignature("isTeacher(address)", msg.sender)
       );
       require(ok, "Registry check failed");
       require(abi.decode(data, (bool)), "Not an active teacher");
       _;
    }

    modifier onlyEnrolled(address studentWallet){
        require(student[studentWallet].isEnrolled, "student not enrolled");
        _;
    }
    
    constructor(address _registry) {
        require(_registry != address(0), "Invalid registry");
         registry = _registry;
    }
    // Functions
    // Register students
    function enrollStudent(address studentWallet, string calldata name,
     uint256 courseId) external onlyTeacher{
         require(studentWallet != address(0), "Invalid address");
         require(bytes(name).length > 0, "Empty name");

         uint256 newStudentId = studentList.length + 1;

         student[studentWallet] = Student({
            studentId: newStudentId,
            class: courseId,
            name: name,
            isEnrolled: true,
            isGraduated: false,
            isSuspended: false
         });
         
         studentList.push(studentWallet);

         emit StudentEnrolled(studentWallet, name, courseId);
     }

    // Update student info
    // Suspend student
    // Return student
    // Reactivate 


    //Getter Functions
    // Get student info
    // View grades function
    // View attendance function

}