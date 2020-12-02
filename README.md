# Staking Contracts


Installation
------------
To run, pull the repository from GitHub and install its dependencies. You will need [npm](https://www.npmjs.com/) installed.

    `npm ci`


## Deployed Contracts

### Kovan
- Reward Token: 0xaDD60aA601217F6d34C80495C556ab0D245747c3
- LP Token: 0xC1D32520113bbBb6E6522E78C9aaF4791A976844
- Farm: 0x94635861fF6eaF8F47112263C67D1828E752CD52

## Requirements

There should be 3 contracts.

 - Erc20 (ARTH, 18 decimals) Mintable, burnable, ownable.

 - Maha token (MAHA, 18 decimals) premined
Farming contract

How it should work:

When minted the user should get the percentage of the blockrate as per his % of the total minted token.

Eg. User 1 mints 100 ARTH.
The block rate is 80 MAHA.
User 1 has minted 100 out of 100 arth so they will be give 80 MAHA every block.
User 2 come and mints 100 more ARTH.
User 2 has minted 100 out of 200 ARTH so User 1 and User 2 would get 40 MAHA.
They both have minted 50% of the total supply.


Major changes to Unicrypt code

 - Change LPsupply to totalsupply of ARTH.
 - Here transferFrom happens AFTER LPsupply is calculated so if  _mint is called first then the state of totalsuplly changes before we want it to.
 - Instead of transfer from we can use mint function of the arth erc20
 - Instead of _mint of the farm token we will use transfer as the MAHA token is premined.