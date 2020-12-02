// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

import "./ERC20.sol";
import "./Ownable.sol";

interface IFarm {
    function deposit(address _account, uint256 _amount) external;
    function withdraw(address _account, uint256 _amount) external;
}

contract LPToken is Ownable, ERC20 {

    event FarmChanged(address indexed oldFarm, address indexed newFarm);

    IFarm public farm;

    constructor() public ERC20("ARTH Token", "ARTH") {
    }

    function setFarm(IFarm farm_) external onlyOwner {
        emit FarmChanged(address(farm), address(farm_));
        farm = farm_;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
        if (address(farm) != address(0)) {
            farm.deposit(account, amount);
        }
    }

    // TODO - clarify if this function is needed or not
    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
        if (address(farm) != address(0)) {
            farm.withdraw(account, amount);
        }
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
        if (address(farm) != address(0)) {
            farm.withdraw(_msgSender(), amount);
        }
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);

        if (address(farm) != address(0)) {
            farm.withdraw(account, amount);
        }
    }
}