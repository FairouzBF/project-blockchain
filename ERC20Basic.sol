pragma solidity >=0.5.0 <0.5.17;

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function transferFrom( address from, address to, uint256 value) public returns (bool) {}
    function approve(address spender, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval( address indexed _owner, address indexed _spender, uint256 _value);
}