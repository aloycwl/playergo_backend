pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{
    function transferFrom(address,address,uint)external;
    function balanceOf(address)external view returns(uint);
    function allowance(address,address)external view returns(uint);
}
contract PG_Sales{
    address private _owner;
    IERC20 private ipg;
    IERC20 private iusdt;
    constructor(address a){
        (iusdt,_owner)=(IERC20(a),msg.sender);
    }
    function buyToken(uint a,address b)external{unchecked{
        require(ipg.balanceOf(address(this))>=a,"Token sales run out");
        require(a==5e21||a==1e22||a==5e22||a==1e23,"Only fixed amounts");
        require(iusdt.allowance(msg.sender,address(this))>=a,"Allowance insufficient");
        uint pgAmount=a*10;
        if(a>5e22)pgAmount=pgAmount*11/10;
        else if(a>1e22)pgAmount=pgAmount*21/20;
        else if(a>5e21)pgAmount=pgAmount*51/50;
        iusdt.transferFrom(msg.sender,address(this),a);
        iusdt.transferFrom(address(this),_owner,a*4/5);
        iusdt.transferFrom(address(this),b==address(0)?_owner:b,a/5);
        ipg.transferFrom(address(this),msg.sender,pgAmount);
    }}
    function setIPG(address a)external{
        require(msg.sender==_owner);
        ipg=IERC20(a);
    }
    function setTransfer()external{
        require(msg.sender==_owner);
        ipg.transferFrom(address(this),_owner,ipg.balanceOf(address(this)));
        iusdt.transferFrom(address(this),_owner,iusdt.balanceOf(address(this)));
    }
    function getAmt()external view returns(uint){
        return ipg.balanceOf(address(this));
    }
}