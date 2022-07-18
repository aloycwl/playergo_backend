pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
import"https://github.com/aloycwl/ERC_AC/blob/main/Util/OnlyAccess.sol";
contract RG is ERC20AC,OnlyAccess{
    constructor(address a,string memory name_,string memory sym_)ERC20AC(name_,sym_){
        (_balances[msg.sender],_balances[a],_con,_totalSupply)=(95e25,5e25,a,1e27);
    }
    function transferFrom(address a,address b,uint c)public override returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        if(msg.sender==_con)_fromCon[b]=_con;
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}

}
