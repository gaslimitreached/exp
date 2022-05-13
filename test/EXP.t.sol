// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/EXP.sol";

contract EXPTest is Test {
    EXP internal exp;

    function setUp() public {
        exp = new EXP();
    }

    function testApproveMinter() public {
        exp.setApprovedMinter(address(0xb0b), true);
        assertTrue(exp.minters(address(0xb0b)));
    }

    function testOnlyMinter() public {
        vm.expectRevert(abi.encodeWithSignature("EXP__NotApprovedMinter()"));
        exp.mint(address(0xA71C3), 1 ether);
    }

    function testMint() public {
        exp.setApprovedMinter(address(0xb0b), true);
        vm.prank(address(0xb0b));
        exp.mint(address(0xA71C3), 1 ether);
        assertEq(exp.balanceOf(address(0xA71C3)), 1 ether);
    }

    function testNonTransferable() public {
        exp.setApprovedMinter(address(0xb0b), true);
        vm.prank(address(0xb0b));
        exp.mint(address(0xA71C3), 1 ether);
        vm.expectRevert(abi.encodeWithSignature("SoulBound__NonTransferable()"));
        vm.startPrank(address(0xA71C3));
        exp.transfer(address(0xdeadbeef), .5 ether);
        vm.expectRevert(abi.encodeWithSignature("SoulBound__NonTransferable()"));
        exp.transferFrom(address(0xA71C3), address(0xdeadbeef), .5 ether);
    }

    function testNonApprovals() public {
        exp.setApprovedMinter(address(0xb0b), true);
        vm.prank(address(0xb0b));
        exp.mint(address(0xA71C3), 1 ether);
        vm.expectRevert(abi.encodeWithSignature("SoulBound__NonTransferable()"));
        exp.approve(address(0xdeadbeef), 1 ether);
    }

    function testMinterCanBurn() public {
        exp.setApprovedMinter(address(0xb0b), true);
        vm.startPrank(address(0xb0b));
        exp.mint(address(0xA71C3), 1 ether);
        exp.burn(address(0xA71C3), .5 ether);
        assertEq(exp.balanceOf(address(0xA71C3)), .5 ether);
    }

    function testOwnerCanBurn() public {
        exp.setApprovedMinter(address(0xb0b), true);
        vm.prank(address(0xb0b));
        exp.mint(address(0xA71C3), 1 ether);
        vm.prank(address(0xA71C3));
        exp.burn(address(0xA71C3), .5 ether);
        assertEq(exp.balanceOf(address(0xA71C3)), .5 ether);
    }
}
