// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ecommerce{
    
   
    address[]  buyer;
    address payable public  Amazon;

    constructor(){
        Amazon=payable(msg.sender);
    }

    modifier owner{
         require(msg.sender==Amazon,"You are not the owner");
         _;
    }

     struct Products{
        string product;
        address payable seller;
        uint price ;   
        uint unitsofproduct;
        uint productid;
    }
    Products[] public products;
    uint public numproducts;



     struct Buyerdetails{
        address payable buyer;
        uint product;
        uint numberofunitspurchasedofproduct; 
        uint orderid;
        uint priceofproduct;
        address payable selleradd;
        uint time;  
        bool delivery;  
    }

    Buyerdetails[]  buyerdetails;

    mapping(address=>bool)  paid;

    mapping(address=>uint) addressorderlist;

    event  registered(string title,uint productid,address selleradd);
    event  boughtproduct(Buyerdetails);
   

    function Register(string memory _product,uint _price,uint _unitsofproduct)public {
        require(msg.sender!=Amazon,"owner can't write product description");
        require(_price>0,"Product price should be greater than 0");
        Products memory tempproducts;
        tempproducts.seller=payable(msg.sender);
        for(uint i=0;i<products.length;i++){
             
            if(tempproducts.seller==products[i].seller){
                
                 products[i].unitsofproduct+=_unitsofproduct;   
                 
            }
        }
        tempproducts.product=_product;
        tempproducts.price=_price*10**18;
        tempproducts.unitsofproduct=_unitsofproduct;
        numproducts++;
        
        products.push(tempproducts);
        for(uint i=0;i<products.length;i++){
             products[i].productid=i;
              emit registered(_product,products[i].productid,msg.sender);     
        }   
    }


     function Restock(uint _productid ,uint units)public{
         require(units>0,"units should be greater then zero");
       
        Products memory tempstock;
            tempstock.seller=payable(msg.sender);
            tempstock.productid=_productid;
            tempstock.unitsofproduct=units;
             uint x;
                x=products[_productid].unitsofproduct;
                
            for(uint i=0;i<products.length;i++){
               
               if(tempstock.seller==products[i].seller && tempstock.productid==products[i].productid){
                    products[i].unitsofproduct+=units;
               }
                if(x==0 && tempstock.seller==products[i].seller && tempstock.productid==products[i].productid){
                    numproducts++;
                }
            }
           
            
    }

        function Deposit(uint _productid,uint units)public payable {
            require(units>0,"Minimum 1 unit required to purchase");
            require(numproducts!=0,"we are out of products");
            require(units<=products[_productid].unitsofproduct,"Sorry we don't have that many units");
            require(msg.sender!=products[_productid].seller,"Seller can't buy own product");    
            require(msg.value==products[_productid].price*units,"Please pay the exact price");
            require(products[_productid].unitsofproduct>0,"Sorry we are out of stock for this product");
            products[_productid].unitsofproduct-=units;

            for(uint i=0;i<products.length;i++){
                if(products[i].unitsofproduct==0){
                numproducts--;
                }
            }
           Buyerdetails memory tempdetails;
           tempdetails.buyer=payable(msg.sender);
           tempdetails.product=_productid;
           tempdetails.numberofunitspurchasedofproduct=units;
           tempdetails.orderid=uint(sha256(abi.encodePacked(block.timestamp,block.difficulty)));
           tempdetails.priceofproduct=products[_productid].price;
           tempdetails.selleradd=products[_productid].seller;
           tempdetails.time=block.timestamp;
           buyerdetails.push(tempdetails);
           paid[msg.sender]=true;

           addressorderlist[msg.sender]=uint(tempdetails.orderid);

            emit boughtproduct(tempdetails);
    
        }
    
    function Buyersdetails()public view owner returns(Buyerdetails[] memory){
        return buyerdetails;
    }

    function Orderdetail()public view returns(uint){
       return addressorderlist[msg.sender];
             
    }
    
    function Delivery(uint orderid)public payable {
        require(paid[msg.sender]!= false,"You must first buy product");


        Buyerdetails memory tempdetails;
        tempdetails.orderid=orderid;

        for(uint i=0;i<buyerdetails.length;i++){

           
            if(tempdetails.orderid==buyerdetails[i].orderid){
                buyerdetails[i].selleradd.transfer(((buyerdetails[i].priceofproduct*buyerdetails[i].numberofunitspurchasedofproduct)*(99))/100);
                Amazon.transfer(((buyerdetails[i].priceofproduct*buyerdetails[i].numberofunitspurchasedofproduct)*(1))/100);   
                 buyerdetails[i].delivery=true;
            }
        }
     }
}

// 1000000000000000000




// buydetails[i].buyer==msg.sender && buydetails[i].product==productid && buydetails[i].numberofunitspurchasedofproduct==unitspurchased







 //     Buydetails memory tempodetails;
    //     tempodetails.buyer=payable(msg.sender);
    //     tempodetails.product=productid;
    //     tempodetails.numberofunitspurchasedofproduct=unitspurchased;
    //    for(uint i=0;i<buydetails.length;i++){
    //        if(tempodetails==buydetails[i]){
    //             products[productid].seller.transfer(products[productid].price*unitspurchased);
    //        }
    //    }


  
   // function restock(uint _productid ,uint units)public{
    //     Products memory tempstock;
    //         tempstock.productid=_productid;
    //         tempstock.unitsofproduct=units;
    //         require
    // }


   
    // require(products[i].seller==tempstock.seller,"You are not the seller of this product");




     // function orderdetail()public view returns(uint){

        // Buyerdetails memory tempordetails;
        // tempordetails.buyer=payable(msg.sender);
        // for(uint i=0;i<buyerdetails.length;i++){

           
        //     if(tempordetails.buyer==buyerdetails[i].buyer){
        //         return buyerdetails[i].orderid;
        //     }
        // }
       
         
    // }



//     struct Timeorder{
//         uint ordercode;
//         uint time;
//         address buyeraddress;
//     }

//     // mapping(address=>timeorder) orderdetails;

//    Timeorder[] timeorder;


      //    Timeorder memory tempodetails;
        //    tempodetails.ordercode=tempdetails.orderid;
        //    tempodetails.time=block.timestamp;
        //    tempodetails.buyeraddress=msg.sender;
           
        //    timeorder.push(tempodetails);






         // Buyerdetails memory tempdetails;
        // tempdetails.buyer=payable(msg.sender);
        // for(uint i=0;i<buyerdetails.length;i++){
        //     if(tempdetails.buyer==buyerdetails[i].buyer){
        //         return buyerdetails[i].orderid;
                
        //     }
        // }      


        // address buyeradd,uint productbooughtid,uint unitsbought,uint orderid
