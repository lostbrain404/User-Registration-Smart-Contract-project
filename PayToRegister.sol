// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title User Registration Smart Contract
/// @author 
/// @notice This contract allows users to register by paying a registration fee.
/// @dev Events are emitted for registration and withdrawals. Only the owner can withdraw the balance.
contract UserDetails {
    
    /// @dev Represents user details stored in the contract.
    struct UserDetail {
        address owner;
        string message;
        uint256 amount;
        bool isActive;
    }

    /// @notice Registration fee required to register
    uint256 public registrationFee = 0.001 ether;

    /// @notice Address of the contract owner
    address private Owner;

    /// @dev Maps user address to their details
    mapping(address => UserDetail) private detailsList;

    /// @notice Emitted when a user successfully registers
    /// @param user The address of the registered user
    /// @param message The message submitted by the user
    /// @param amount The amount of Ether paid
    event UserRegistered(address indexed user, string message, uint256 amount);

    /// @notice Emitted when the contract owner withdraws the balance
    /// @param user The address of the owner
    /// @param amount The amount withdrawn
    event UserWithdrawn(address indexed user, uint256 amount);

    /// @notice Sets the contract deployer as the owner
    constructor() {
        Owner = msg.sender;
    }

    /// @dev Restricts access to owner-only functions
    modifier OnlyOwner() {
        require(msg.sender == Owner, "Only contract owner can perform this action");
        _;
    }

    /// @notice Registers the user with a message and payment
    /// @dev User must send at least the registration fee and be unregistered
    /// @param message The message to associate with the user
    function register(string memory message) external payable {
        require(msg.value >= registrationFee, "Insufficient Amount");
        require(!detailsList[msg.sender].isActive, "User already registered");

        detailsList[msg.sender] = UserDetail(msg.sender, message, msg.value, true);

        emit UserRegistered(msg.sender, message, msg.value);
    }

    /// @notice Returns the registered message for the calling user
    /// @return message The message associated with the user
    function getDetails() external view returns (string memory message) {
        require(detailsList[msg.sender].isActive, "User not active");
        return detailsList[msg.sender].message;
    }

    /// @notice Allows the owner to withdraw the full contract balance
    function withdrawBalance() external OnlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        (bool sent, ) = payable(Owner).call{value: balance}("");
        require(sent, "Withdraw failed");

        emit UserWithdrawn(Owner, balance);
    }

    /// @notice Updates the required registration fee
    /// @param newFee The new registration fee (in wei)
    function setRegistration(uint256 newFee) external OnlyOwner {
        registrationFee = newFee;
    }
}
