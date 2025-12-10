# 🛡️ Efficient Error Handling: Gas Benchmarking & Patterns

A comparative research project analyzing the gas impact of different error handling strategies in Solidity, specifically focusing on the transition from string-based requirements to modern Custom Errors.

## 🚀 Engineering Context

As a **Java Software Engineer**, exception handling typically prioritizes detailed observability (e.g., `throw new IllegalArgumentException("Detailed Error Message")`). The cost of storing these error strings is negligible in a server environment.

In the **EVM**, however, every byte of text stored in the contract bytecode increases deployment costs, and emitting those strings at runtime consumes additional gas. This project benchmarks standard validation patterns to quantify the trade-offs between Developer Experience (DX) and On-Chain Efficiency.

## 💡 Project Overview

The `RequireTest` contract implements and compares three distinct architectural patterns for validating transaction conditions (specifically, Access Control checks).

### 🔍 Key Technical Features:

* **Pattern 1: The Readable Approach (`require`):**
    * *Implementation:* `require(condition, "Error Message")`.
    * *Analysis:* While readable, the ASCII string "Caller must be admin" is hardcoded into the contract bytecode. This increases the deployment size and triggers memory expansion costs during execution.

* **Pattern 2: The Modern Approach (`Custom Errors`):**
    * *Implementation:* `revert TxOriginIsNotAdmin(address)`.
    * *Analysis:* Utilizing Solidity 0.8.4+ Custom Errors. Instead of a string, this returns a **4-byte selector**. This is the most gas-efficient method, as it allows passing dynamic context (like parameters) without the overhead of ASCII encoding.

* **Pattern 3: The Raw Approach (`if + revert`):**
    * *Implementation:* Standard `if` statement followed by `revert()`.
    * *Analysis:* Useful for absolute minimal gas usage when no context is required, though often discouraged due to poor debugging experience (no return data).

## 🔍 Technical Takeaways

* **Gas Savings:** Replacing `require` strings with **Custom Errors** significantly reduces deployment costs (smaller bytecode) and runtime gas (no memory expansion for string copying).
* **Standardization:** Adopting Custom Errors aligns with modern Solidity best practices, allowing client-side libraries (like viem or ethers.js) to decode errors programmatically via ABI rather than parsing text strings.

## 🛠️ Stack & Tools

* **Language:** Solidity `^0.8.24`.
* **Concepts:** Gas Profiling, ABI Encoding, Custom Errors.
* **License:** GPL-3.0-only.

---

*This project highlights the architectural shift required when moving from "Detailed Logging" in Web2 to "Bytecode Efficiency" in Web3.*