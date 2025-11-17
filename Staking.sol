// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Staking is ReentrancyGuard {
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    uint256 public rewardRate = 1; // 1 token per block

    struct StakeInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    mapping(address => StakeInfo) public stakes;

    constructor(IERC20 _stakingToken, IERC20 _rewardToken) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Cannot stake 0");
        updateRewards(msg.sender);
        stakingToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender].amount += amount;
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(stakes[msg.sender].amount >= amount, "Insufficient staked");
        updateRewards(msg.sender);
        stakes[msg.sender].amount -= amount;
        stakingToken.transfer(msg.sender, amount);
    }

    function claimRewards() external nonReentrant {
        updateRewards(msg.sender);
        uint256 reward = stakes[msg.sender].rewardDebt;
        stakes[msg.sender].rewardDebt = 0;
        rewardToken.transfer(msg.sender, reward);
    }

    function updateRewards(address user) internal {
        StakeInfo storage stakeInfo = stakes[user];
        uint256 pending = stakeInfo.amount * rewardRate; // simple reward calculation
        stakeInfo.rewardDebt += pending;
    }
}
