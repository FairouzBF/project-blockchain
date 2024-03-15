pragma solidity >=0.5.0 <0.5.17;

import "./ERC20Basic.sol";

contract Token is ERC20Basic {
    string public symbol = "LOL";
    string public name = "LOLCoin";
    uint8 public decimal = 15;

    using SafeMath for uint256;
    uint256 totalSupply_;

    constructor(uint256 total) public {
        totalSupply_ = total;
        __balanceOf[msg.sender] = totalSupply_;
    }

    mapping(address => uint256) private __balanceOf;
    mapping(address => mapping(address => uint256)) __allowances;

    event Transfer(address _addr, address _to, uint256 _value);
    event Approval(address _owner, address _spender, uint256 _value);

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address _addr) public view returns (uint256 balance) {
        return __balanceOf[_addr];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(_value <= __balanceOf[msg.sender]);
        __balanceOf[msg.sender] = __balanceOf[msg.sender].sub(_value);
        __balanceOf[_to] = __balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= __balanceOf[_from]);
        require(_value <= __allowances[_from][msg.sender]);

        __balanceOf[_from] = __balanceOf[_from].sub(_value);
        __allowances[_from][msg.sender] = __allowances[_from][msg.sender].sub(
            _value
        );
        __balanceOf[_to] = __balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        require(__allowances[msg.sender][_spender] == 0, "");
        __allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return __allowances[_owner][_spender];
    }
}


library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}