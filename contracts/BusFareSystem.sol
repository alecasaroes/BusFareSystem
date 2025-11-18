
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract BusPayment {
    address public busCompany;
    address public customer;
    uint256 public totalStops;
    
    // Pricing constants (in wei)
    uint256 public constant PRICE_UP_TO_10 = 1 ether;
    uint256 public constant PRICE_ABOVE_10 = 2 ether;
    
    // Events for tracking
    event StopAdded(address indexed customer, uint256 stopNumber, uint256 timestamp);
    event PaymentMade(address indexed customer, uint256 amount, uint256 stops, uint256 timestamp);
    event FundsWithdrawn(address indexed busCompany, uint256 amount, uint256 timestamp);
    
    // Modifiers
    modifier onlyCustomer() {
        require(msg.sender == customer, "Only customer can call this");
        _;
    }
    
    modifier onlyBusCompany() {
        require(msg.sender == busCompany, "Only bus company can call this");
        _;
    }
    
    constructor(address _customer) {
        busCompany = msg.sender;
        customer = _customer;
        totalStops = 0;
    }
    
    // Function to add a stop
    function addStop() public onlyCustomer {
        totalStops++;
        emit StopAdded(customer, totalStops, block.timestamp);
    }
    
    // Function to calculate current payment due
    function calculatePayment() public view returns (uint256) {
        if (totalStops == 0) {
            return 0;
        } else if (totalStops <= 10) {
            return PRICE_UP_TO_10;
        } else {
            return PRICE_ABOVE_10;
        }
    }
    
    // Function for customer to pay for their journey
    function makePayment() public payable onlyCustomer {
        uint256 amountDue = calculatePayment();
        require(totalStops > 0, "No stops recorded");
        require(msg.value == amountDue, "Incorrect payment amount");
        
        emit PaymentMade(customer, msg.value, totalStops, block.timestamp);
        
        // Reset stops after payment
        totalStops = 0;
    }
    
    // Function for bus company to withdraw accumulated funds
    function withdrawFunds() public onlyBusCompany {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        emit FundsWithdrawn(busCompany, balance, block.timestamp);
        
        payable(busCompany).transfer(balance);
    }
    
    // View function to check contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // View function to get current stop count
    function getCurrentStops() public view returns (uint256) {
        return totalStops;
    }
}