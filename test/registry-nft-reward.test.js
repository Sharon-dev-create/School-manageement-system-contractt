const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SchoolRegistry NFT Reward", function () {
  let registry;
  let studentContract;
  let teacherContract;
  let token;
  let nftReward;
  let admin;
  let teacher;
  let student;

  beforeEach(async function () {
    [admin, teacher, student] = await ethers.getSigners();

    const placeholderTeacher = teacher.address;
    const placeholderStudent = student.address;

    const SchoolRegistry = await ethers.getContractFactory("SchoolRegistry");
    registry = await SchoolRegistry.deploy(
      placeholderTeacher,
      placeholderStudent,
      "Test School"
    );
    await registry.deployed();

    const StudentContract = await ethers.getContractFactory("studentContract");
    studentContract = await StudentContract.deploy(registry.address);
    await studentContract.deployed();

    const TeacherContract = await ethers.getContractFactory("teacherContract");
    teacherContract = await TeacherContract.deploy(registry.address, studentContract.address);
    await teacherContract.deployed();

    await registry.setTeacherContract(teacherContract.address);
    await registry.setStudentContract(studentContract.address);

    const SchoolToken = await ethers.getContractFactory("schoolToken");
    token = await SchoolToken.deploy(1000000);
    await token.deployed();
    await token.setRegistry(registry.address);
    await registry.setTokenContract(token.address);

    const NftReward = await ethers.getContractFactory("NftReward");
    nftReward = await NftReward.deploy(registry.address, "Test NFT", "TNFT");
    await nftReward.deployed();
    await registry.setNftContract(nftReward.address);
  });

  it("should allow the registry to reward an enrolled student with an NFT", async function () {
    await expect(registry.registerTeacher("Ms. Smith", teacher.address, 1))
      .to.emit(registry, "TeacherRegistered")
      .withArgs(teacher.address, 1);

    await expect(registry.enrollStudent(101, student.address, "Alice"))
      .to.emit(registry, "StudentEnrolled")
      .withArgs(student.address, 101);

    const uri = "https://example.com/metadata/1";
    const tx = await registry.rewardStudentNft(student.address, uri);
    const receipt = await tx.wait();
    const event = receipt.events.find((e) => e.event === "NftRewarded");
    expect(event).to.not.be.undefined;

    const tokenId = event.args.tokenId;
    expect(event.args.to).to.equal(student.address);
    expect(event.args.uri).to.equal(uri);

    expect(await nftReward.ownerOf(tokenId)).to.equal(student.address);
    expect(await nftReward.tokenURI(tokenId)).to.equal(uri);
  });
});