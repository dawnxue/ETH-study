// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DawnAPE is ERC721, Ownable {
    uint public constant MAX_APES = 10000; // 总量
    uint public nextTokenId = 0; // 用于跟踪下一个铸造的 tokenId

    // 构造函数
    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_) 
        Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4) // 使用默认部署者地址作为初始拥有者
    {
    }

    // 覆盖 baseURI 方法
    function _baseURI() internal pure override returns (string memory) {
        return "https://cdn.sanity.io/images/70kzkeor/production/8e5b5b3a2732e6c219f77e698b6f9a00faade409-2000x2000.png?w=200&auto=format";
    }
    
    // 免费铸造函数
    function mint() external {
        require(nextTokenId < MAX_APES, "All tokens have been minted");
        _mint(msg.sender, nextTokenId);
        nextTokenId++;
    }
}


// 本题步骤如下：
//1. 部署ERC721.SOL合约，部署地址为 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4， 输入参数为：“DawnAPE" "DAPE"，生成的合约地址为0x5A86858aA3b595FD6663c2296741eF4cd8BC4d01。
//2. NFT合约部署完成后，给0x5B38Da6a701c568545dCfcB03FcB875f56beddC4地址mint了tokenid为1的NFT。
//3. 部署NFTswap.sol 合约，部署地址为0x5B38Da6a701c568545dCfcB03FcB875f56beddC4，，生成的合约地址为0xC3Ba5050Ec45990f76474163c5bA673c244aaECA。
//4. 去NFT合约中将token为1的NFT授权给NFTswap.sol 合约。
//5. 在NFTswap.sol 合约中，用NFT持有者地址0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 list了tokenid为1的NFT，list 价格为1200000000000000000（12*10^17)
//6.切换账户0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2，purchase token id为1的NFT，输入ID:1,在value处输入价格为：1200000000000000000（12*10^17)，点击按钮"purchase"，购买成功。



