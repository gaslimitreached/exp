// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract ERC20SoulBound {
    error SoulBound__NonTransferable();
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    string public name;
    string public symbol;
    uint8 public immutable decimals;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function approve(address, uint256) public virtual returns (bool) {
        revert SoulBound__NonTransferable();
    }

    function transfer(address, uint256) public virtual returns (bool) {
        revert SoulBound__NonTransferable();
    }

    function transferFrom(
        address,
        address,
        uint256
    ) public virtual returns (bool) {
        revert SoulBound__NonTransferable();
    }

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked { balanceOf[to] += amount; }
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked { totalSupply -= amount; }
        emit Transfer(from, address(0), amount);
    }
}