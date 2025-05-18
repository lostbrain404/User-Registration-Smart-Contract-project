# UserDetails Smart Contract

A simple Ethereum smart contract that allows users to register by paying a registration fee and submitting a message. The contract owner can withdraw collected funds and adjust the registration fee.

## 📜 Features

- User registration with payment
- Custom message per user
- Owner-only withdrawal
- Adjustable registration fee
- Event logging for transparency

## 🚀 Deployment

This contract is written in Solidity ^0.8.30.

### Prerequisites

- Solidity compiler (via [Remix](https://remix.ethereum.org) or Hardhat)
- MetaMask or other Web3 wallet

### Constructor

The contract sets the deployer as the owner:

```solidity
constructor() {
    Owner = msg.sender;
}

🔧 Functions
register(string memory message)

Registers a new user. Requires payment of at least registrationFee.

    Emits UserRegistered.

getDetails()

Returns the message associated with the calling address.
withdrawBalance()

Allows the contract owner to withdraw the balance. Emits UserWithdrawn.
setRegistration(uint256 newFee)

Updates the registration fee. Owner-only.
💻 Example

Register with 0.001 Ether:

contract.register("Hello World", { value: ethers.utils.parseEther("0.001") });

📦 License

MIT © [lostbrain404]
