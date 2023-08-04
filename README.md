# Ecommerce Smart Contract

This is a Solidity smart contract for an E-commerce platform on the Ethereum blockchain. The contract facilitates the buying and selling of products between buyers and sellers. The owner of the contract can also restock products and process product deliveries.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Deployment](#deployment)
- [Contract Functions](#contract-functions)
  - [Register Product](#register-product)
  - [Restock Product](#restock-product)
  - [Buy Product](#buy-product)
  - [Get Buyer Details](#get-buyer-details)
  - [Get Order Details](#get-order-details)
  - [Product Delivery](#product-delivery)
- [Important Considerations](#important-considerations)
- [License](#license)

## Overview

The `Ecommerce` smart contract enables buyers and sellers to conduct transactions for products listed on the platform. Sellers can register products, set prices, and track available units. Buyers can purchase products and receive order details for delivery. The owner of the contract (Amazon) can restock products and process product deliveries.

## Getting Started

### Prerequisites

To interact with the smart contract, you will need:

- An Ethereum wallet (e.g., MetaMask) connected to the Ethereum Mainnet or Testnet.
- Sufficient Ether to perform transactions on the platform.

### Deployment

1. Deploy the `Ecommerce` smart contract to the Ethereum network using a Solidity-compatible development environment (e.g., Remix IDE, Truffle).
2. After deployment, the contract owner (Amazon) can register products using the `Register` function, providing product details such as name, price, and quantity.
3. Sellers can restock their products using the `Restock` function.
4. Buyers can purchase products using the `Deposit` function, providing the product ID and quantity. Buyers must pay the exact price in Ether to complete the purchase.
5. Buyers can check their purchase details using the `Buyersdetails` function and get order details using the `Orderdetail` function.
6. The contract owner (Amazon) can process product deliveries using the `Delivery` function.

## Contract Functions

### Register Product

The `Register` function allows sellers to register their products on the platform. Sellers provide the product name, price, and quantity of units available for sale. The function also emits a `registered` event with the product details.

### Restock Product

The `Restock` function enables sellers to restock their products. Sellers provide the product ID and the number of units to be added to the available stock.

### Buy Product

The `Deposit` function allows buyers to purchase products from the platform. Buyers provide the product ID and the desired quantity. The function verifies the product availability, price, and payment amount before completing the purchase. It also emits a `boughtproduct` event with the order details.

### Get Buyer Details

The `Buyersdetails` function provides buyers with their purchase details, including the product, quantity, and order ID.

### Get Order Details

The `Orderdetail` function allows buyers to get their order details using their Ethereum address.

### Product Delivery

The `Delivery` function is used by the contract owner (Amazon) to process product deliveries. The owner provides the order ID to confirm delivery, and the function transfers payment to the seller and Amazon, while setting the `delivery` status to true.

## Important Considerations

- Only the contract owner (Amazon) can restock products and process deliveries.
- Buyers must pay the exact product price in Ether to complete a purchase.
- The contract uses wei as the unit for Ether transactions, where 1 Ether = 10^18 wei.

## License

This smart contract is released under the MIT License. See the `LICENSE` file for more information.
