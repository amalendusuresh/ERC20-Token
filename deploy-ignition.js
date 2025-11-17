module.exports = async ({ deployments, getNamedAccounts }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  // ✅ Deploy ERC20 Token
  const token = await deploy("MyToken", {
    from: deployer,
    args: [1000000], // initial supply
    log: true,
  });

  // ✅ Deploy AMM
  const amm = await deploy("AMM", {
    from: deployer,
    args: [token.address, token.address], // Example: same token for simplicity
    log: true,
  });

  // ✅ Deploy Staking Contract
  const staking = await deploy("Staking", {
    from: deployer,
    args: [token.address, token.address], // staking token & reward token
    log: true,
  });

  // ✅ Deploy Vesting Contract
  const vesting = await deploy("TokenVesting", {
    from: deployer,
    args: [token.address],
    log: true,
  });

  console.log("All contracts deployed successfully!");
  console.log("Token:", token.address);
  console.log("AMM:", amm.address);
  console.log("Staking:", staking.address);
  console.log("Vesting:", vesting.address);
};
