// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SimpleAMM
 * @dev A simple Automated Market Maker (AMM) using x * y = k formula.
 * Includes addLiquidity, removeLiquidity, and swap functions.
 */
contract AMM is ReentrancyGuard {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);
    event SwapExecuted(address indexed swapper, uint256 amountIn, uint256 amountOut, bool isAToB);

    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token addresses");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    /** 
     * @dev Add liquidity to the pool
     */
    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA > 0 && amountB > 0, "Invalid amounts");

        // Transfer tokens from user to contract
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // Update reserves
        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    /**
     * @dev Remove liquidity proportionally
     */
    function removeLiquidity(uint256 shareA, uint256 shareB) external nonReentrant {
        require(shareA <= reserveA && shareB <= reserveB, "Not enough liquidity");

        reserveA -= shareA;
        reserveB -= shareB;

        tokenA.transfer(msg.sender, shareA);
        tokenB.transfer(msg.sender, shareB);

        emit LiquidityRemoved(msg.sender, shareA, shareB);
    }

    /**
     * @dev Swap tokenA for tokenB using x * y = k
     */
    function swapAforB(uint256 amountAIn, uint256 minBOut) external nonReentrant {
        require(amountAIn > 0, "Invalid input");

        // Calculate output using constant product formula
        uint256 amountBOut = (reserveB * amountAIn) / (reserveA + amountAIn);
        require(amountBOut >= minBOut, "Slippage too high");

        // CEI pattern: Effects first, then interactions
        reserveA += amountAIn;
        reserveB -= amountBOut;

        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        emit SwapExecuted(msg.sender, amountAIn, amountBOut, true);
    }

    /**
     * @dev Swap tokenB for tokenA using x * y = k
     */
    function swapBforA(uint256 amountBIn, uint256 minAOut) external nonReentrant {
        require(amountBIn > 0, "Invalid input");

        uint256 amountAOut = (reserveA * amountBIn) / (reserveB + amountBIn);
        require(amountAOut >= minAOut, "Slippage too high");

        reserveB += amountBIn;
        reserveA -= amountAOut;

        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);

        emit SwapExecuted(msg.sender, amountBIn, amountAOut, false);
    }
}
