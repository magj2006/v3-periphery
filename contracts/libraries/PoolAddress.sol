// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.19;

/// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
library PoolAddress {
    bytes32 internal constant POOL_INIT_CODE_HASH = 0x010013efaf9ef9b4a043d30718652726fe91aea02bf08336b2c3eb200ef82a97;

    /// @dev keccak256("0x")
    bytes32  internal constant INPUTHASH=0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    /// @dev keccak256("zksyncCreate2")
    bytes32 internal constant CREATE2_PREFIX = 0x2020dba91b30cc0006188af794c2fb30dd8520db7e2c088b7fc7c103c00ca494;

    /// @notice The identifying key of the pool
    struct PoolKey {
        address token0;
        address token1;
        uint24 fee;
    }

    /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
    /// @param tokenA The first token of a pool, unsorted
    /// @param tokenB The second token of a pool, unsorted
    /// @param fee The fee level of the pool
    /// @return Poolkey The pool details with ordered token0 and token1 assignments
    function getPoolKey(
        address tokenA,
        address tokenB,
        uint24 fee
    ) internal pure returns (PoolKey memory) {
        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
        return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
    }

    /// @notice Deterministically computes the pool address given the factory and PoolKey
    /// @param factory The Fikaswap V3 factory contract address
    /// @param key The PoolKey
    /// @return pool The contract address of the V3 pool
    function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
        require(key.token0 < key.token1);
//        pool = address(
//            uint256(
//                keccak256(
//                    abi.encodePacked(
//                        hex'ff',
//                        factory,
//                        keccak256(abi.encode(key.token0, key.token1, key.fee)),
//                        POOL_INIT_CODE_HASH
//                    )
//                )
//            )
//        );

        bytes32 _salt=keccak256(abi.encode(key.token0, key.token1, key.fee));
        bytes32 hash = keccak256(
              abi.encodePacked(CREATE2_PREFIX, bytes32(uint256(uint160(factory))), _salt, POOL_INIT_CODE_HASH, INPUTHASH)
        );

        pool = address(uint160(uint256(hash)));
    }

}
