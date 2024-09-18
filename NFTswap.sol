// 本题步骤如下：
//1. 部署ERC721.SOL合约，部署地址为 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4， 输入参数为：“DawnAPE" "DAPE"，生成的合约地址为0x5A86858aA3b595FD6663c2296741eF4cd8BC4d01。
//2. NFT合约部署完成后，给0x5B38Da6a701c568545dCfcB03FcB875f56beddC4地址mint了tokenid为1的NFT。
//3. 部署NFTswap.sol 合约，部署地址为0x5B38Da6a701c568545dCfcB03FcB875f56beddC4，，生成的合约地址为0xC3Ba5050Ec45990f76474163c5bA673c244aaECA。
//4. 去NFT合约中将token为1的NFT授权给NFTswap.sol 合约。
//5. 在NFTswap.sol 合约中，用NFT持有者地址0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 list了tokenid为1的NFT，list 价格为1200000000000000000（12*10^17)
//6.切换账户0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2，purchase token id为1的NFT，输入ID:1,在value处输入价格为：1200000000000000000（12*10^17)，点击按钮"purchase"，购买成功。


//ERC721.SOL合约代码链接：https://github.com/dawnxue/ETH-study/blob/main/ERC721.sol



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract NFTSwap {
    // ERC721 NFT 接口
    IERC721 public nftContract;

    // 订单结构
    struct Order {
        address owner;
        uint256 price;
        bool active;
    }

    // 订单映射
    mapping(uint256 => Order) public orders;

    // 构造函数，设置 NFT 合约地址
    constructor(address _nftContract) {
        nftContract = IERC721(_nftContract);
    }

    // 卖家挂单
    function list(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner of the NFT");
        require(orders[tokenId].owner == address(0) || !orders[tokenId].active, "Order already exists");

        orders[tokenId] = Order({
            owner: msg.sender,
            price: price,
            active: true
        });
    }

    // 卖家撤单
    function revoke(uint256 tokenId) external {
        require(orders[tokenId].owner == msg.sender, "Not the owner of the order");
        require(orders[tokenId].active, "Order not active");

        delete orders[tokenId];
    }

    // 卖家更新价格
    function update(uint256 tokenId, uint256 newPrice) external {
        require(orders[tokenId].owner == msg.sender, "Not the owner of the order");
        require(orders[tokenId].active, "Order not active");

        orders[tokenId].price = newPrice;
    }

    // 买家购买 NFT
    function purchase(uint256 tokenId) external payable {
        Order memory order = orders[tokenId];
        require(order.active, "Order not active");
        require(msg.value == order.price, "Incorrect price");

        // Transfer NFT from seller to buyer
        nftContract.transferFrom(order.owner, msg.sender, tokenId);

        // Transfer funds to seller
        payable(order.owner).transfer(msg.value);

        // Clear the order
        delete orders[tokenId];
    }
}
