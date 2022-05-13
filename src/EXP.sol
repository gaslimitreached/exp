// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20SoulBound.sol";

contract EXP is ERC20SoulBound {
    error Ownable__NotOwner();
    error EXP__NotApprovedMinter();
    error EXP__NotAuthorized();
    error EXP__NotEnough();

    event MinterApproved(address indexed minter, bool approval);

    address public immutable owner;

    mapping(address => bool) public minters;

    modifier onlyMinters() {
        if (!minters[msg.sender]) revert EXP__NotApprovedMinter();
        _;
    }

    constructor() ERC20SoulBound("Experience", "EXP", uint8(18)) {
        owner = msg.sender;
    }

    function setApprovedMinter(address minter, bool approval) external {
        if (msg.sender != owner) revert Ownable__NotOwner();
        minters[minter] = true;
        emit MinterApproved(minter, approval);
    }

    function mint(address to, uint amount) external onlyMinters {
        _mint(to, amount);
    }

    function burn(address from, uint amount) external {
        if (!minters[msg.sender] && msg.sender != from) revert EXP__NotAuthorized();
        if (balanceOf[from] < amount) revert EXP__NotEnough();
        _burn(from, amount);
    }
}