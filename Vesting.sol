// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenVesting is Ownable, ReentrancyGuard {
    IERC20 public token;

    struct Vest {
        uint256 totalAmount;
        uint256 released;
        uint256 start;
        uint256 duration;
    }

    mapping(address => Vest) public vestings;

    event TokensReleased(address indexed beneficiary, uint256 amount);

    constructor(IERC20 _token) {
        token = _token;
    }

    // Create vesting schedule for a beneficiary
    function createVesting(address beneficiary, uint256 amount, uint256 start, uint256 duration) external onlyOwner {
        require(beneficiary != address(0), "Invalid address");
        require(amount > 0, "Amount must be > 0");
        vestings[beneficiary] = Vest(amount, 0, start, duration);
    }

    // Calculate releasable tokens
    function releasable(address beneficiary) public view returns (uint256) {
        Vest storage vest = vestings[beneficiary];
        if (block.timestamp < vest.start) return 0;
        uint256 elapsed = block.timestamp - vest.start;
        if (elapsed >= vest.duration) return vest.totalAmount - vest.released;
        return ((vest.totalAmount * elapsed) / vest.duration) - vest.released;
    }

    // Release tokens
    function release() external nonReentrant {
        Vest storage vest = vestings[msg.sender];
        uint256 amount = releasable(msg.sender);
        require(amount > 0, "No tokens to release");
        vest.released += amount;
        token.transfer(msg.sender, amount);
        emit TokensReleased(msg.sender, amount);
    }
}
