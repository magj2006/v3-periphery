// SPDX-License-Identifier: GPL-2.0-or-later
import 'node_modules/@fikaswap/v3-core/contracts/interfaces/IFikaswapV3Pool.sol';

pragma solidity ^0.8.19;

import '../contracts/libraries/PoolTicksCounter.sol';

contract PoolTicksCounterTest {
    using PoolTicksCounter for IFikaswapV3Pool;

    function countInitializedTicksCrossed(
        IFikaswapV3Pool pool,
        int24 tickBefore,
        int24 tickAfter
    ) external view returns (uint32 initializedTicksCrossed) {
        return pool.countInitializedTicksCrossed(tickBefore, tickAfter);
    }
}
