// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

import "./ERC20.sol";

contract RewardToken is ERC20 {

    constructor(uint256 initialSupply_) public ERC20("MAHA Token", "MAHA") {
        _mint(msg.sender, initialSupply_);
    }
}