# 🎟️ Raffle Smart Contract

A decentralized lottery system powered by **Chainlink VRF v2.5**, built using **Foundry**. Participants enter the raffle by paying an ETH entrance fee, and a winner is selected randomly and fairly using Chainlink's provable randomness.

---

## 🚀 Features

- ✅ Verifiably random winner selection with Chainlink VRF
- ⏱️ Time-based raffle intervals
- 🛡️ Secure handling of ETH & randomness
- 🧪 Comprehensive unit and fuzz tests with Foundry
- ⚙️ Configurable for local and testnet deployments

---

## 🧱 Technologies

- [Solidity](https://docs.soliditylang.org/)
- [Foundry](https://book.getfoundry.sh/)
- [Chainlink VRF](https://docs.chain.link/vrf)
- [Anvil](https://book.getfoundry.sh/anvil/)
- [Etherscan](https://etherscan.io/)

---

## 📁 Project Structure

```
Raffle-Smart-Contract/
├── script/
│   ├── DeployRaffle.s.sol        # Deployment script
│   └── HelperConfig.s.sol        # Chainlink + network config
├── src/
│   └── Raffle.sol                # Main raffle contract
├── test/
│   └── RaffleTest.t.sol          # Unit & fuzz tests
├── foundry.toml                  # Foundry config
└── README.md                     # Project documentation
```

---

## ⚙️ Configuration

Create a `.env` file with:

```bash
PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your_project_id
ETHERSCAN_API_KEY=your_etherscan_key
```

You can configure network-specific values inside `HelperConfig.s.sol`.

---

## Run Locally

### Prerequisites

- [Foundry installed](https://book.getfoundry.sh/getting-started/installation)
- Git & Node.js installed

### Clone and Setup

```bash
git clone https://github.com/Shivang14d04/Raffle-Smart-Contract.git
cd Raffle-Smart-Contract
```

# Install dependencies

```
forge install
```

---

## 🧪 Testing

Run unit and fuzz tests with:

```bash
forge test -vv
```

For forked mainnet testing (e.g., simulate Chainlink behavior):

```bash
forge test --fork-url $SEPOLIA_RPC_URL -vv
```

---

## 📦 Deployment

### ➤ Local

```bash
anvil
forge script script/DeployRaffle.s.sol --fork-url http://127.0.0.1:8545 --broadcast --legacy
```

### ➤ Sepolia (Testnet)

```bash
forge script script/DeployRaffle.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

---

## 🎯 Contract Workflow

1. 🎫 Users join the raffle by paying the `entranceFee`
2. ⏳ After `interval` passes, upkeep is performed
3. 🔮 Chainlink VRF provides a random number
4. 🏆 A winner is selected and receives the ETH balance
5. ♻️ Raffle resets for the next round

---

## 🔒 Security

- Reentrancy-protected
- Only accepts valid ETH amounts
- Chainlink-based randomness
- Fails gracefully when conditions aren't met

---

## 🌐 Useful Links

- [Chainlink VRF Docs](https://docs.chain.link/vrf)
- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
