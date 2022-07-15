pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
contract PG is ERC20AC{
    mapping(address=>address)private _fromCon;
    address private _con;
    uint public _released;
    constructor(address a,string memory name_,string memory sym_)ERC20AC(name_,sym_){
        (_balances[msg.sender],_balances[a],_con,_totalSupply)=(95e25,5e25,a,1e27);
    }
    function transferFrom(address a,address b,uint c)public override returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        require(_released>0||_fromCon[a]!=_con);
        if(msg.sender==_con)_fromCon[b]=_con;
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}
    function toggleRelease()external{
        require(msg.sender==_owner);
        _released=_released==0?1:0;
    }
}