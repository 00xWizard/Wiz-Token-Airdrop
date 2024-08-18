# Wizard Token Airdrop

This protocol is an implementation of the Wizard Token (WIZ) Airdrop using a Merkle Tree to efficiently verify claims. The airdrop is facilitated by two smart contracts: `MerkleAirdop` and `WizardToken`, written in Solidity. Testing and deployment are managed using Foundry.

## Overview

- **`MerkleAirdop` Contract**: Allows eligible users to claim their WIZ tokens by verifying their address and claim amount against a Merkle root.
- **`WizardToken` Contract**: Implements a standard ERC20 token with minting functionality, minting `WIZ` tokens.

## Contracts

### MerkleAirdop.sol

This contract manages the airdrop distribution. Key features:
- **Merkle Proof Verification**: Ensures that users claiming tokens are eligible by verifying the Merkle proof.
- **Signature Verification**: Ensures that each claim is properly signed.
- **Event Emission**: Emits a `Claim` event upon successful token claims.
- **Claim Protection**: Prevents users from claiming tokens more than once.

### WizardToken.sol

This is an ERC20 token contract for the WIZ token. Key features:
- **Minting**: The contract owner can mint new WIZ tokens.
- **Transfer**: Tokens are transferred to the `MerkleAirdop` contract for distribution.

## Deployment

The `DeployMerkleAirdrop.s.sol` script handles the deployment of both contracts.

### Deployment Script

- **DeployMerkleAirdrop**: 
  - Deploys the `WizardToken` and `MerkleAirdop` contracts.
  - Mints and transfers tokens to the `MerkleAirdop` contract for distribution.

## Usage

To deploy and interact with the contracts:

1. Clone the repository:
    ```bash
    git clone https://github.com/your-repo/wizard-token-airdrop.git
    cd wizard-token-airdrop
    ```

2. Install Foundry:
    Follow the instructions to install Foundry [here](https://book.getfoundry.sh/getting-started/installation).

3. Compile the contracts:
    ```bash
    forge build
    ```

4. Deploy the contracts using the script:
    ```bash
    forge script script/DeployMerkleAirdrop.s.sol --broadcast --rpc-url YOUR_RPC_URL --private-key YOUR_PRIVATE_KEY
    ```

5. Run the tests:
    ```bash
    forge test
    ```

## Tests

The tests are implemented in `MerkleAirdropTest.t.sol`. The key tests include:
- Claim verification with Merkle proofs and signatures.
- Correct distribution of tokens.
- Prevention of multiple claims by the same user.

## License

This project is licensed under the MIT License.
