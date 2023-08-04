// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ecommerce {
    // Variables
    address[] public buyer;
    address payable public Amazon;

    // Constructor
    constructor() {
        Amazon = payable(msg.sender);
    }

    // Modifier: Restricts functions to the contract owner (Amazon)
    modifier owner {
        require(msg.sender == Amazon, "You are not the owner");
        _;
    }

    // Struct to represent product details
    struct Products {
        string product;
        address payable seller;
        uint price;
        uint unitsofproduct;
        uint productid;
    }
    Products[] public products;
    uint public numproducts;

    // Struct to represent buyer's purchase details
    struct Buyerdetails {
        address payable buyer;
        uint product;
        uint numberofunitspurchasedofproduct;
        uint orderid;
        uint priceofproduct;
        address payable selleradd;
        uint time;
        bool delivery;
    }
    Buyerdetails[] public buyerdetails;

    // Mapping to track whether a buyer has paid for a product
    mapping(address => bool) public paid;

    // Mapping to store the order ID of a buyer based on their address
    mapping(address => uint) public addressorderlist;

    // Events
    event registered(string title, uint productid, address selleradd);
    event boughtproduct(Buyerdetails);

    // Function to register a new product
    function Register(string memory _product, uint _price, uint _unitsofproduct) public {
        require(msg.sender != Amazon, "Owner can't write product description");
        require(_price > 0, "Product price should be greater than 0");

        Products memory tempproducts;
        tempproducts.seller = payable(msg.sender);

        // Check if the seller already has products listed and update the quantity
        for (uint i = 0; i < products.length; i++) {
            if (tempproducts.seller == products[i].seller) {
                products[i].unitsofproduct += _unitsofproduct;
            }
        }

        tempproducts.product = _product;
        tempproducts.price = _price * 10**18;
        tempproducts.unitsofproduct = _unitsofproduct;
        numproducts++;

        products.push(tempproducts);
        
        // Assign a product ID and emit the 'registered' event
        for (uint i = 0; i < products.length; i++) {
            products[i].productid = i;
            emit registered(_product, products[i].productid, msg.sender);
        }
    }

    // Function to restock a product by the seller
    function Restock(uint _productid, uint units) public {
        require(units > 0, "Units should be greater than zero");

        Products memory tempstock;
        tempstock.seller = payable(msg.sender);
        tempstock.productid = _productid;
        tempstock.unitsofproduct = units;

        uint x;
        x = products[_productid].unitsofproduct;

        for (uint i = 0; i < products.length; i++) {
            // If the seller and product ID match, update the quantity
            if (tempstock.seller == products[i].seller && tempstock.productid == products[i].productid) {
                products[i].unitsofproduct += units;
            }

            // If new product added, increase the product count
            if (x == 0 && tempstock.seller == products[i].seller && tempstock.productid == products[i].productid) {
                numproducts++;
            }
        }
    }

    // Function for a buyer to deposit payment and purchase a product
    function Deposit(uint _productid, uint units) public payable {
        require(units > 0, "Minimum 1 unit required to purchase");
        require(numproducts != 0, "We are out of products");
        require(units <= products[_productid].unitsofproduct, "Sorry, we don't have that many units");
        require(msg.sender != products[_productid].seller, "Seller can't buy own product");
        require(msg.value == products[_productid].price * units, "Please pay the exact price");
        require(products[_productid].unitsofproduct > 0, "Sorry, we are out of stock for this product");

        products[_productid].unitsofproduct -= units;

        // Decrease the product count if the product is out of stock
        for (uint i = 0; i < products.length; i++) {
            if (products[i].unitsofproduct == 0) {
                numproducts--;
            }
        }

        // Record buyer's purchase details
        Buyerdetails memory tempdetails;
        tempdetails.buyer = payable(msg.sender);
        tempdetails.product = _productid;
        tempdetails.numberofunitspurchasedofproduct = units;
        tempdetails.orderid = uint(sha256(abi.encodePacked(block.timestamp, block.difficulty)));
        tempdetails.priceofproduct = products[_productid].price;
        tempdetails.selleradd = products[_productid].seller;
        tempdetails.time = block.timestamp;
        buyerdetails.push(tempdetails);
        paid[msg.sender] = true;

        // Assign order ID to the buyer's address
        addressorderlist[msg.sender] = uint(tempdetails.orderid);

        // Emit the 'boughtproduct' event with the order details
        emit boughtproduct(tempdetails);
    }

    // Function to get the purchase details of a buyer
    function Buyersdetails() public view owner returns (Buyerdetails[] memory) {
        return buyerdetails;
    }

    // Function to get the order ID based on the buyer's address
    function Orderdetail() public view returns (uint) {
        return addressorderlist[msg.sender];
    }

    // Function for product delivery by the contract owner (Amazon)
    function Delivery(uint orderid) public payable {
        require(paid[msg.sender] != false, "You must first buy the product");

        Buyerdetails memory tempdetails;
        tempdetails.orderid = orderid;

        for (uint i = 0; i < buyerdetails.length; i++) {
            // If the order ID matches, process product delivery
            if (tempdetails.orderid == buyerdetails[i].orderid) {
                buyerdetails[i].selleradd.transfer((buyerdetails[i].priceofproduct * buyerdetails[i].numberofunitspurchasedofproduct * 99) / 100);
                Amazon.transfer((buyerdetails[i].priceofproduct * buyerdetails[i].numberofunitspurchasedofproduct) / 100);
                buyerdetails[i].delivery = true;
            }
        }
    }
}
