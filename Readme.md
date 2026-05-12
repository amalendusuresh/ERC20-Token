# ERC-20 Token Ecosystem (Token · Staking · AMM · Vesting)

A complete **DeFi token starter kit** built in Solidity — including an **ERC-20 token**, a **staking contract**, a **constant-product AMM**, and a **token vesting** module. Designed as a clean, audit-ready reference implementation for token launches and DeFi protocols.

![Solidity](https://img.shields.io/badge/Solidity-0.8.x-363636?logo=solidity)
![Hardhat](https://img.shields.io/badge/Built%20with-Hardhat-FFF100?logo=hardhat&logoColor=black)
![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-Contracts-4E5EE4)
![License](https://img.shields.io/badge/license-MIT-blue)
![Status](https://img.shields.io/badge/status-Active-success)

---

## ✨ Features

- ✅ **ERC-20 token** with standard mint/burn extensions
- ✅ **Staking contract** with time-weighted rewards
- ✅ **SimpleAMM** — Uniswap-V2-style constant-product market maker
- ✅ **Vesting contract** for team / investor token unlock schedules
- ✅ **Hardhat Ignition** deployment scripts
- ✅ Built on **OpenZeppelin** audited primitives
- ✅ Clean separation of concerns — each module is self-contained
- ✅ Ready for testnet & mainnet deployment

---

## 🏗️ Architecture

```
            ┌────────────────┐
            │    Token.sol   │  ◄── Core ERC-20
            └───────┬────────┘
                    │ (used by)
        ┌───────────┼────────────┬──────────────┐
        ▼           ▼            ▼              ▼
 ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐
 │ Staking.sol│ │SimpleAMM │ │Vesting   │ │  (Future) │
 │            │ │   .sol   │ │  .sol    │ │  Governor │
 └────────────┘ └──────────┘ └──────────┘ └───────────┘
```

### Smart Contracts

| Contract | Purpose |
|---|---|
| **`Token.sol`** | ERC-20 token implementation with controlled supply, mint, and burn |
| **`Staking.sol`** | Stake tokens to earn time-based rewards. Configurable APR and unstake cooldown |
| **`SimpleAMM.sol`** | Constant-product AMM (x * y = k) for token/ETH or token/token pairs |
| **`Vesting.sol`** | Linear vesting with cliff + duration for team and investor allocations |

---

## 📂 Project Structure

```
ERC20-Token/
├── Token.sol              # ERC-20 implementation
├── Staking.sol            # Token staking with rewards
├── SimpleAMM.sol          # Constant-product AMM
├── Vesting.sol            # Linear vesting w/ cliff
├── AMM/                   # AMM tests & scripts
├── Hardhat/               # Hardhat artifacts & helpers
├── deploy-ignition.js     # Hardhat Ignition deployment module
├── hardhat.config.js      # Hardhat configuration
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** ≥ 18.x
- **npm** or **yarn**
- A funded **Ethereum-compatible wallet** (Sepolia testnet recommended for first deploy)

### Installation

```bash
git clone https://github.com/amalendusuresh/ERC20-Token.git
cd ERC20-Token
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox @openzeppelin/contracts
npm install --save-dev hardhat-ignition
```

### Environment Setup

Create a `.env` file in the project root:

```bash
PRIVATE_KEY=your_wallet_private_key_here
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
MAINNET_RPC_URL=https://mainnet.infura.io/v3/YOUR_INFURA_KEY
ETHERSCAN_API_KEY=your_etherscan_api_key
```

---

## 🧪 Testing

Compile contracts:

```bash
npx hardhat compile
```

Run the full test suite:

```bash
npx hardhat test
```

Run with gas report:

```bash
REPORT_GAS=true npx hardhat test
```

Coverage:

```bash
npx hardhat coverage
```

---

## 🚢 Deployment

### Using Hardhat Ignition

```bash
npx hardhat ignition deploy deploy-ignition.js --network sepolia
```

### Local node (for testing)

```bash
npx hardhat node
# In a second terminal:
npx hardhat ignition deploy deploy-ignition.js --network localhost
```

### Verify on Etherscan

```bash
npx hardhat verify --network sepolia <DEPLOYED_CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

---

## 💡 How It Works

### Token

Standard ERC-20 with an `owner`-controlled mint function (or fixed supply, depending on configuration). Built on OpenZeppelin's audited `ERC20` base contract.

### Staking Flow

1. User calls `approve(stakingContract, amount)` on the token
2. User calls `stake(amount)` — tokens are transferred to the contract
3. Rewards accrue over time based on stake size and reward rate
4. User calls `claimRewards()` to collect earned tokens
5. User calls `unstake(amount)` to withdraw principal

### AMM (SimpleAMM)

A constant-product market maker:
- Liquidity providers deposit pairs of tokens and receive **LP shares**
- Swaps use the formula `x * y = k`, with a fee deducted from input
- LPs can withdraw their pro-rata share of the pool at any time

### Vesting

1. Owner calls `createVesting(beneficiary, totalAmount, cliff, duration)`
2. Before the cliff, **zero tokens** are claimable
3. After the cliff, tokens unlock **linearly** over the duration
4. Beneficiary calls `release()` to claim vested tokens

---

## 🔐 Security Considerations

- **OpenZeppelin foundations** — built on top of audited primitives
- **Reentrancy protection** on state-changing functions that handle external transfers
- **Access control** via `Ownable` for privileged operations
- **Safe math** — Solidity 0.8.x built-in overflow checks
- **Pull-payment** pattern for vesting and reward claims

> ⚠️ This codebase is a reference implementation and has not been formally audited. Use it as a learning resource or starting point — get a professional audit before deploying to mainnet with real funds.

---

## 🗺️ Roadmap

- [ ] Comprehensive Hardhat test suite for all modules
- [ ] Slither + Mythril static analysis CI
- [ ] Governance module (OpenZeppelin Governor)
- [ ] Multi-tier vesting schedules
- [ ] LP staking (stake AMM LP tokens for rewards)
- [ ] Subgraph for indexing AMM swaps & TVL
- [ ] Formal audit

---

## 📚 Tech Stack

- **Smart Contracts:** Solidity 0.8.x
- **Framework:** Hardhat + Hardhat Ignition
- **Libraries:** OpenZeppelin Contracts
- **Testing:** Hardhat + Chai + Ethers.js
- **Networks:** Ethereum (Sepolia / Mainnet), EVM-compatible chains

---

## 📄 License

MIT © [Amalendu Suresh](https://github.com/amalendusuresh)

---

## 🤝 Contact

**Amalendu Suresh** — Blockchain Engineer

- 💼 **LinkedIn:** [amalendu-blockchain](https://www.linkedin.com/in/amalendu-blockchain/)
- ✍️ **Medium:** [@amalenduvishnu](https://medium.com/@amalenduvishnu)
- 📧 **Email:** amalendusuresh95@gmail.com

If you find this project useful, please ⭐ star the repo!
