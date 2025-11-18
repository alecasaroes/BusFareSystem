
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BusFareSystem {

    // Address company will receive the payment
    address public busCompany;

    uint256 public farePerStop;

    struct Journey {
        uint256 startStop;
        uint256 timestamp;
        bool active;
    }
}