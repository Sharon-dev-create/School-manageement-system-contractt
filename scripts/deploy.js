const hre = require("hardhat");

async function main() {
  const [deployer, teacherSigner, studentSigner] = await hre.ethers.getSigners();
  const placeholderTeacher = teacherSigner.address;
  const placeholderStudent = studentSigner.address;

  console.log("Deploying contracts with deployer:", deployer.address);

  const SchoolRegistry = await hre.ethers.getContractFactory("SchoolRegistry");
  const registry = await SchoolRegistry.deploy(
    placeholderTeacher,
    placeholderStudent,
    "School Management"
  );
  await registry.deployed();

  const StudentContract = await hre.ethers.getContractFactory("studentContract");
  const studentContract = await StudentContract.deploy(registry.address);
  await studentContract.deployed();

  const TeacherContract = await hre.ethers.getContractFactory("teacherContract");
  const teacherContract = await TeacherContract.deploy(registry.address, studentContract.address);
  await teacherContract.deployed();

  await registry.setTeacherContract(teacherContract.address);
  await registry.setStudentContract(studentContract.address);

  const SchoolToken = await hre.ethers.getContractFactory("schoolToken");
  const token = await SchoolToken.deploy(1000000);
  await token.deployed();
  await token.setRegistry(registry.address);
  await registry.setTokenContract(token.address);

  const NftReward = await hre.ethers.getContractFactory("NftReward");
  const nftReward = await NftReward.deploy(registry.address, "School NFT", "SNFT");
  await nftReward.deployed();
  await registry.setNftContract(nftReward.address);

  console.log("SchoolRegistry deployed to:", registry.address);
  console.log("StudentContract deployed to:", studentContract.address);
  console.log("TeacherContract deployed to:", teacherContract.address);
  console.log("SchoolToken deployed to:", token.address);
  console.log("NftReward deployed to:", nftReward.address);

  console.log("Registering teacher and enrolling student...");
  await registry.registerTeacher("Ms. Smith", teacherSigner.address, 1);
  await registry.enrollStudent(101, studentSigner.address, "Alice");

  const rewardTx = await registry.rewardStudentNft(studentSigner.address, "https://example.com/metadata/1");
  const rewardReceipt = await rewardTx.wait();
  const rewardEvent = rewardReceipt.events.find((event) => event.event === "NftRewarded");
  const tokenId = rewardEvent ? rewardEvent.args.tokenId : null;
  console.log("Issued NFT tokenId:", tokenId ? tokenId.toString() : "unknown");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});