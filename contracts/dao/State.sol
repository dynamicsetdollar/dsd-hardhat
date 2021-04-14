/*
    Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "../token/IDollar.sol";
import "../oracle/IOracle.sol";
import "../external/Decimal.sol";

contract Account {
    enum Status { Frozen, Fluid, Locked }

    struct State {
        uint256 staged;
        uint256 balance;
        mapping(uint256 => uint256) coupons;
        mapping(address => uint256) couponAllowances;
        uint256 fluidUntil;
        uint256 lockedUntil;
    }

    struct State10 {
        uint256 depositedCDSD;
        uint256 interestMultiplierEntry;
        uint256 earnableCDSD;
        uint256 earnedCDSD;
        uint256 redeemedCDSD;
        uint256 redeemedThisExpansion;
        uint256 lastRedeemedExpansionStart;
    }
}

contract Epoch {
    struct Global {
        uint256 start;
        uint256 period;
        uint256 current;
    }

    struct Coupons {
        uint256 outstanding;
        uint256 expiration;
        uint256[] expiring;
    }

    struct State {
        uint256 bonded;
        Coupons coupons;
    }
}

contract Candidate {
    enum Vote { UNDECIDED, APPROVE, REJECT }

    struct State {
        uint256 start;
        uint256 period;
        uint256 approve;
        uint256 reject;
        mapping(address => Vote) votes;
        bool initialized;
    }
}

contract Storage {
    struct Provider {
        IDollar dollar;
        IOracle oracle;
        address pool;
    }

    struct Balance {
        uint256 supply;
        uint256 bonded;
        uint256 staged;
        uint256 redeemable;
        uint256 debt;
        uint256 coupons;
    }

    struct State {
        Epoch.Global epoch;
        Balance balance;
        Provider provider;
        mapping(address => Account.State) accounts;
        mapping(uint256 => Epoch.State) epochs;
        mapping(address => Candidate.State) candidates;
    }

    struct State13 {
        mapping(address => mapping(uint256 => uint256)) couponUnderlyingByAccount;
        uint256 couponUnderlying;
        Decimal.D256 price;
    }

    struct State16 {
        IOracle legacyOracle;
        uint256 epochStartForSushiswapPool;
    }

    struct State10 {
        mapping(address => Account.State10) accounts;

        uint256 globalInterestMultiplier;

        uint256 totalCDSDDeposited;
        uint256 totalCDSDEarnable;
        uint256 totalCDSDEarned;

        uint256 expansionStartEpoch;
        uint256 totalCDSDRedeemable;
        uint256 totalCDSDRedeemed;
    }

    struct State17 {
        Decimal.D256 contractionPrice;
        IOracle CDSDOracle;
    }
}

contract State {
    Storage.State _state;

    // DIP-13
    Storage.State13 _state13;

    // DIP-16
    Storage.State16 _state16;

    // DIP-10
    Storage.State10 _state10;

    // DIP-17
    Storage.State17 _state17;
}
