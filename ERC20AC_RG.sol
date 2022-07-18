pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
import"https://github.com/aloycwl/ERC_AC/blob/main/Util/OnlyAccess.sol";
contract RG is ERC20AC,OnlyAccess{
    constructor(string memory name_,string memory sym_)ERC20AC(name_,sym_){}
    function transferFrom(address a,address b,uint c)public override returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}
    function mint(address a,uint b)external onlyAccess{unchecked{
        (_balances[a]+=b,_totalSupply+=b);
        emit Transfer(address(this),a,b);
    }}
    function burn(uint a)external onlyAccess{unchecked{
        _totalSupply-=a;
        emit Transfer(address(this),address(0),a);
    }}
}
