// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import "remix_test.sol";
import "./ifElse.sol";

contract MyTest {
    ifElse foo;

    function beforeEach() public {
        foo = new ifElse();
    }

    function checkFunction() public {
        Assert.equal(foo.evenCheck(2), true, "Should be true");
        Assert.equal(foo.evenCheck(1), false, "Should be false");
    }
}