pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
contract MockUSDT is ERC20AC{
    constructor(string memory name_,string memory sym_)ERC20AC(name_,sym_){}
    function MINT(address a)external{unchecked{
        (_totalSupply+=1e27,_balances[a]+=1e27);
        emit Transfer(address(this),a,1e27);
    }}
}