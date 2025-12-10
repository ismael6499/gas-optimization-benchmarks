// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.24;

/// @title Error Handling Patterns
/// @author Agustin Acosta
/// @notice A comparison of different error handling strategies and their gas costs
contract RequireTest {

    error CallerIsNotAdmin(address caller);
    error InvalidAddress();

    address public admin;

    constructor(address _admin) {
        // Optimization: Use Custom Error instead of require string for deployment gas savings
        if (_admin == address(0)) revert InvalidAddress();
        admin = _admin;
    }

    function checkAdminWithIf() external view {
        // Using revert without arguments consumes less gas but provides no info
        if (msg.sender != admin) {
            revert(); 
        }
    }

    function checkAdminWithRequire() external view {
        // 'require' with a string is gas expensive due to storage/memory operations
        require(msg.sender == admin, "Caller must be admin");
    }

    function checkAdminWithCustomError() external view {
        // Custom Errors are the most gas efficient and informative approach
        if (msg.sender != admin) {
            revert CallerIsNotAdmin(msg.sender);
        }
    }
}