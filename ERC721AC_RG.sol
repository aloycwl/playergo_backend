pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC721AC/ERC721AC.sol";
contract RG is ERC721AC{
    uint[]enumTokens;
    constructor(string memory name_,string memory sym_)ERC721AC(name_,sym_){}

    function tokenURI(uint)external pure override returns(string memory){
        return"https://ipfs.io/ipfs/bafybeieuti6mhg5p6pbf7n4emjqff5l6b4qv5pm7fbhqfy2i3rialwp52y/rg.json";
    }

    function getCount()public view returns(uint){
        return enumTokens.length;
    }

    function Mint()external{ 
        (_owners[getCount()]=msg.sender,_balances[msg.sender]++);
    }


}