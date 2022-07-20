pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC721{
    event Transfer(address indexed from,address indexed to,uint indexed tokenId);
    event Approval(address indexed owner,address indexed approved,uint indexed tokenId);
    event ApprovalForAll(address indexed owner,address indexed operator,bool approved);
    function balanceOf(address)external view returns(uint);
    function ownerOf(uint)external view returns(address);
    function safeTransferFrom(address,address,uint)external;
    function transferFrom(address,address,uint)external;
    function approve(address,uint)external;
    function getApproved(uint)external view returns(address);
    function setApprovalForAll(address,bool)external;
    function isApprovedForAll(address,address)external view returns(bool);
    function safeTransferFrom(address,address,uint,bytes calldata)external;
}
interface IERC721Metadata{
    function name()external view returns(string memory);
    function symbol()external view returns(string memory);
    function tokenURI(uint)external view returns(string memory);
}
contract ERC721AC is IERC721,IERC721Metadata{
    address internal _owner;
    string _name;
    string _sym;
    mapping(uint=>address)internal _owners;
    mapping(address=>uint)internal _balances;
    mapping(uint=>address)internal _tokenApprovals;
    mapping(address=>mapping(address=>bool))internal _operatorApprovals;
    constructor(string memory name_,string memory sym_){
        (_owner,_name,_sym)=(msg.sender,name_,sym_);
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    function balanceOf(address a)external view override virtual returns(uint){
        return _balances[a];
    }
    function ownerOf(uint a)public view override virtual returns(address){
        return _owners[a]; 
    }
    function owner()external view returns(address){
        return _owner;
    }
    function name()external override view returns(string memory){
        return _name;
    }
    function symbol()external override view returns(string memory){
        return _sym;
    }
    function tokenURI(uint)external view override virtual returns(string memory){
        return"";
    }
    function approve(address a,uint b)external override{
        require(msg.sender==ownerOf(b)||isApprovedForAll(ownerOf(b),msg.sender));
        _tokenApprovals[b]=a;
        emit Approval(ownerOf(b),a,b);
    }
    function getApproved(uint a)public view override returns(address){
        return _tokenApprovals[a];
    }
    function setApprovalForAll(address a,bool b)external override{
        _operatorApprovals[msg.sender][a]=b;
        emit ApprovalForAll(msg.sender,a,b);
    }
    function isApprovedForAll(address a,address b)public view override returns(bool){
        return _operatorApprovals[a][b];
    }
    function transferFrom(address a,address b,uint c)public virtual override{unchecked{
        require(a==ownerOf(c)||getApproved(c)==a||isApprovedForAll(ownerOf(c),a));
        (_tokenApprovals[c]=address(0),_balances[a]-=1,_balances[b]+=1,_owners[c]=b);
        emit Approval(ownerOf(c),b,c);
        emit Transfer(a,b,c);
    }}
    function safeTransferFrom(address a,address b,uint c)external override{
        transferFrom(a,b,c);
    }
    function safeTransferFrom(address a,address b,uint c,bytes memory)external override{
        transferFrom(a,b,c);
    }
}
contract OnlyAccess {
    mapping(address=>uint)public _access;
    modifier onlyAccess(){
        require(_access[msg.sender]>0);
        _;
    }
    constructor(){
        _access[msg.sender]=1;
    }
    function ACCESS(address a,uint b)external onlyAccess{
        if(b==0)delete _access[a];
        else _access[a]=1;
    }
}
interface IERC20{
    function transferFrom(address,address,uint)external;
    function balanceOf(address)external view returns(uint);
    function allowance(address,address)external view returns(uint);
    function mint(address,uint)external;
}
contract RG is ERC721AC,OnlyAccess{
    uint public _count;
    uint public _release;
    mapping(uint=>uint)private _released;
    mapping(address=>uint[])private _tokens;
    mapping(address=>address)private upline;
    mapping(address=>uint)public downlineCounts;
    IERC20 private irg;
    IERC20 private iusdt;
    uint time;
    constructor(string memory name_,string memory sym_,address a,address b)ERC721AC(name_,sym_){
        (iusdt,irg)=(IERC20(a),IERC20(b));
        time=block.timestamp;
    }
    function tokenURI(uint)external pure override returns(string memory){
        return"https://ipfs.io/ipfs/bafybeieuti6mhg5p6pbf7n4emjqff5l6b4qv5pm7fbhqfy2i3rialwp52y/rg.json";
    }
    function toggleRelease()external onlyAccess{
        _release=_release==0?block.timestamp:0;
    }
    function mint(address a,uint b)external{unchecked{
        if(b<1)b=1;
        require(_count+b<5e3,"Token sales is over");
        require(iusdt.balanceOf(msg.sender)>=1e21*b,"Insufficient USDT");
        require(iusdt.allowance(msg.sender,address(this))>=1e21*b,"Insufficient allowance");
        if(upline[msg.sender]==address(0))upline[msg.sender]=a==address(0)?_owner:a;
        iusdt.transferFrom(msg.sender,address(this),1e21*b);
        iusdt.transferFrom(address(this),_owner,8e20*b);
        iusdt.transferFrom(address(this),upline[msg.sender],2e20*b);
        for(uint i;i<b;i++){
            (_count++,_balances[msg.sender]++,downlineCounts[upline[msg.sender]]++,
                _owners[_count]=msg.sender,_released[_count]=block.timestamp);
            _tokens[msg.sender].push(_count);
            emit Transfer(address(0),msg.sender,_count);
        }
    }}
    function burn(uint a)external onlyAccess{unchecked{
        require(msg.sender==_owner);
        _count-=a;
    }}
    function getDrip()public view returns(uint amt){unchecked{
        if(_release>0)for(uint i;i<_tokens[msg.sender].length;i++){ 
            uint r=_released[_tokens[msg.sender][i]];
            amt+=((block.timestamp-(r>_release?r:_release))*31709792e7);
        }
    }}
    function drip()external{unchecked{
        uint amt=getDrip();
        require(amt>0,"No drip available");
        irg.mint(msg.sender,amt);
        if(upline[msg.sender]!=address(0))irg.mint(upline[msg.sender],amt/100);
        for(uint i;i<_balances[msg.sender];i++)_released[_tokens[msg.sender][i]]=block.timestamp;
    }}
    function getTokens()external view returns(uint[]memory){
        return _tokens[msg.sender];
    }
}