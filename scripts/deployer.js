/**
 * @dev Script to deploy
 * 
 * make sure truffle's build files are updated, for that run truffle compile
 * run command -> truffle exec scripts/deployer.js --network kovan 
 */

const RewardToken = artifacts.require("RewardToken");
const LPToken = artifacts.require("LPToken");
const Farm = artifacts.require("Farm");

// change these according to deployment requirements
const initialSupplyRewardToken = '10000';
let blockReward = 1;
const rewardDuration = 10000;
const totalRewardAmount = '1000';
const gasPriceGwei = '10';

module.exports = async (callback) => {
  try {

    let accounts = await web3.eth.getAccounts();
    console.log(`\nUsing account: ${accounts[0]}\n`);

    let latestBlock = await web3.eth.getBlock('latest');
    console.log(`\nLatest Block: ${latestBlock.number}\n`);

    let txParams = {
      gasPrice: web3.utils.toWei(gasPriceGwei, 'gwei')
    }

    console.log(`\nDeploying Reward Token...`);
    let RewardTokenC = await RewardToken.new(web3.utils.toWei(initialSupplyRewardToken, 'ether'), txParams);
    console.log(`Reward Token deployed at: `, RewardTokenC.address);

    console.log(`\nDeploying LP Token...`);
    let LPTokenC = await LPToken.new(txParams);
    console.log(`LP Token deployed at: `, LPTokenC.address);

    blockReward = web3.utils.toWei(blockReward.toString(), 'ether');
    let endBlock = parseFloat(latestBlock.number) + rewardDuration;
    let rewardEndBlock = parseFloat(latestBlock.number) + 1;

    console.log(`\nDeploying Farm...`);
    let FarmC = await Farm.new(RewardTokenC.address, '0', LPTokenC.address, blockReward, latestBlock.number, endBlock, rewardEndBlock, '1', txParams);
    console.log(`Farm deployed at: `, FarmC.address);

    console.log(`\nTransferring ${totalRewardAmount} Reward Token to Farm...`);
    await RewardTokenC.transfer(FarmC.address, web3.utils.toWei(totalRewardAmount, 'ether'));
    console.log(`Done`);

    console.log(`\nSetting Farm address in LP Token...`);
    await LPTokenC.setFarm(FarmC.address);
    console.log(`Done`);

    callback();
  } catch (err) {
    callback(err);
  }
};