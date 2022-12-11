
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Deal {
	struct Parties
	{
		address buyerAddr; // payable - Enable sending money to them.
		address payable sellerAddr; // payable - Enable sending money to them.
	}

	struct Product
	{
		string name;
		uint quantity;
		uint price; // Price per single product.
	}

	struct Shipment
	{
		address payable courierAddr;
		uint price;
		uint date;
	}

	struct Order
	{
		Product product;
		Shipment shipment;
		uint total;
		bool initialized;
	}

	Parties parties;
	mapping (uint => Order) public orders;
	uint public orderCount;

	event OnOrderPlaced(address buyerAddr, string product, uint quantity, uint orderNumber);

	constructor(address buyer) public {
		parties.sellerAddr = payable(msg.sender);
		parties.buyerAddr = buyer;
		orderCount = 0;
	}

	function placeOrder(string calldata product, uint quantity, address courierAddr) public payable {
		require(parties.sellerAddr == msg.sender);

		uint total = 10 * quantity + 5;

		orders[orderCount] = Order(
			Product(product, quantity, 10),
			Shipment(payable(courierAddr), 5, block.timestamp),
			total,
			true
		);

		uint id = orderCount;
		orderCount++;

		emit OnOrderPlaced(
			parties.buyerAddr,
			product,
			quantity,
			id
		);
	}

	function getOrder(uint number) view public returns(address buyerAddr, string memory product, uint quantity, uint total, uint date) {
		require(orders[number].initialized);

		return (
			parties.buyerAddr,
			orders[number].product.name,
			orders[number].product.quantity,
			orders[number].product.price,
			orders[number].shipment.date
		);
	}
}
