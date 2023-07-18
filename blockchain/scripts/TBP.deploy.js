const { ethers, upgrades } = require("hardhat");

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  // deploy
  const TBP = await hre.ethers.getContractFactory("TheBestPhotography");
  const tbp = await TBP.deploy("1689575477", "1689748277", "https://github.com/App-Voting/The-Best-Photography/blob/main/blockchain");
  await tbp.deployed();
  console.log("tbp deployed to:", tbp.address);

  await sleep(10000);

  await hre.run("verify:verify", {
    address: tbp.address,
    constructorArguments: ["1689575477", "1689748277", "https://github.com/App-Voting/The-Best-Photography/blob/main/blockchain"],
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
