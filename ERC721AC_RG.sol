pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC721AC/ERC721AC.sol";
import"https://github.com/aloycwl/ERC_AC/blob/main/Util/OnlyAccess.sol";
interface IERC20{
    function transferFrom(address,address,uint)external;
    function balanceOf(address)external view returns(uint);
    function allowance(address,address)external view returns(uint);
}
contract RG is ERC721AC,OnlyAccess{
    uint public _count=1;
    uint private _release;
    mapping(uint=>uint)private _released;
    mapping(address=>uint[])private _tokens;
    IERC20 private ipg;
    IERC20 private iusdt;
    constructor(string memory name_,string memory sym_,address a)ERC721AC(name_,sym_){
        iusdt=IERC20(a);
    }
    function tokenURI(uint)external pure override returns(string memory){
        return"https://ipfs.io/ipfs/bafybeieuti6mhg5p6pbf7n4emjqff5l6b4qv5pm7fbhqfy2i3rialwp52y/rg.json";
    }
    function mint(address a)external{unchecked{
        require(_count<5e3,"Token sales is over");
        require(iusdt.balanceOf(msg.sender)>=1e21,"Insufficient USDT");
        require(iusdt.allowance(msg.sender,address(this))>=1e21,"Insufficient allowance");
        iusdt.transferFrom(msg.sender,address(this),1e21);
        iusdt.transferFrom(address(this),_owner,8e20);
        iusdt.transferFrom(address(this),a==address(0)?_owner:a,2e20);
        (_owners[_count]=msg.sender,_balances[msg.sender]++);
        emit Transfer(address(0),msg.sender,_count);
        _count++;
    }}
    function burn(uint a)external onlyAccess{unchecked{
        require(msg.sender==_owner);
        _count-=a;
    }}
    function toggleRelease()external onlyAccess{
        _release=_release==0?block.timestamp:0;
    }
    function getDrip()public view returns(uint){
        uint amt;
        for(uint i;i<_tokens[msg.sender].length;i++){
            if
        }
        return _release>0?block.timestamp-_release:0;
    }
    function drip()external{
        
    }
    function getTokens()external view returns(uint[]memory){
        return _tokens[msg.sender];
    }
}