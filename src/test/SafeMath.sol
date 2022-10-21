pragma solidity ^0.7.6;

library SafeMath {
    function add(uint256 a, uint256 b) internal view returns (uint) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}