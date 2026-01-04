# 🛡️ Efficient Error Handling: Gas Benchmarking & Patterns

![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636?style=flat-square&logo=solidity)
![Gas](https://img.shields.io/badge/Gas_Optimization-High-green?style=flat-square)
![License](https://img.shields.io/badge/License-GPL_3.0-blue?style=flat-square)

A comparative research implementation analyzing the gas impact of different error handling strategies in Solidity. This project quantifies the trade-offs between legacy string-based validation and modern **Custom Errors**.

In the EVM, every byte of text stored in the contract bytecode increases deployment costs, and emitting those strings at runtime triggers memory expansion. This repository demonstrates how moving to 4-byte error selectors significantly reduces on-chain footprint.

## 🏗 Architecture & Design Decisions

### 1. Gas Optimization (Bytecode vs. Selector)
- **Legacy Pattern (`require` strings):**
    - *Mechanism:* Stores full ASCII strings in the bytecode. At runtime, it requires memory allocation (`MSTORE`) to encode the error message.
    - *Cost:* High deployment cost (bytecode size) and higher runtime gas due to dynamic memory expansion.
- **Modern Pattern (Custom Errors):**
    - *Mechanism:* Utilizes Solidity 0.8.4+ specific `error Name()`.
    - *Optimization:* Returns a fixed **4-byte selector** (hash of the error signature). This avoids memory expansion for string encoding and allows dynamic parameters to be passed efficiently via the stack.

### 2. Architectural Trade-offs
- **Raw Reverts (`if + revert()`):**
    - Implemented for benchmarking the "absolute floor" of gas usage. While cheapest, it is architecturally discouraged for production systems due to the lack of debugging context (DX).
- **Semantic Validation:**
    - The `RequireTest` contract demonstrates that `revert CallerIsNotAdmin(msg.sender)` provides superior observability compared to generic strings, allowing off-chain indexers to decode the exact failure reason and context parameters programmatically.

## 🛠 Tech Stack

* **Core:** Solidity `^0.8.24`
* **Features:** Custom Errors (EIP-838), ABI Encoding
* **Focus:** Gas Profiling & Opcode Analysis

## 📝 Code Comparison

The benchmark isolates three distinct patterns for the same logical check:

```solidity
// 1. Expensive (String stored in bytecode)
require(msg.sender == admin, "Caller must be admin");

// 2. Optimized (4-byte selector)
if (msg.sender != admin) {
    revert CallerIsNotAdmin(msg.sender);
}
```

---
*Reference implementation for EVM gas optimization strategies.*
