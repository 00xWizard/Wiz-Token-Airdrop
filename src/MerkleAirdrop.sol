// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// @title Merkle Airdrop Contract
// @dev This contract allows eligible users to claim airdropped tokens by verifying Merkle Proofs and signatures.
contract MerkleAirdop is EIP712 {
    using SafeERC20 for IERC20;

    // @dev Array to store claimers' addresses.
    address[] claimers;

    // @dev Merkle root for verifying the proofs.
    bytes32 private immutable i_merkleRoot;

    // @dev ERC20 token to be airdropped.
    IERC20 private immutable i_airdropToken;

    // @dev Errors to handle invalid proofs, double claims, and invalid signatures.
    error MerkleAirdop__InvalidProof();
    error MerkleAirdop__AlreadyClaimed();
    error MerkleAirdop__InvalidSignature();

    // @dev Mapping to track whether an address has claimed its tokens.
    mapping(address claimer => bool claimed) private s_hasClaimed;

    // @dev EIP712 message typehash for signature verification.
    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account, uint256 amount)");

    // @dev Struct representing a claim.
    struct AirdrioClaim {
        address account;
        uint256 amount;
    }

    // @dev Event emitted when a user claims their tokens.
    event Claim(address account, uint256 amount);

    // @param merkleRoot The root hash of the Merkle tree.
    // @param airdropToken The ERC20 token to be airdropped.
    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("WizardAirdrop", "1") {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    // @dev Allows users to claim their airdropped tokens by providing a valid proof and signature.
    // @param account The address of the claimer.
    // @param amount The amount of tokens to claim.
    // @param merkleProof Array of proofs to verify the Merkle tree.
    // @param v, r, s Components of the signature for EIP712 verification.
    function claim(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s)
        external
    {
        // Ensure the user has not already claimed.
        if (s_hasClaimed[account]) {
            revert MerkleAirdop__AlreadyClaimed();
        }

        // Validate the signature.
        if (!_isValidSingnature(account, getMessageHash(account, amount), v, r, s)) {
            revert MerkleAirdop__InvalidSignature();
        }

        // Generate the leaf node and verify it against the Merkle root.
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdop__InvalidProof();
        }

        // Mark the user as claimed and transfer the airdropped tokens.
        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    // @dev Generates the EIP712 hash for signing.
    // @param account The address of the claimer.
    // @param amount The amount of tokens to claim.
    function getMessageHash(address account, uint256 amount) public view returns (bytes32) {
        return
            _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPEHASH, AirdrioClaim({account: account, amount: amount}))));
    }

    // @dev Returns the Merkle root.
    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    // @dev Returns the airdrop token.
    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }

    // @dev Internal function to verify the validity of the signature.
    function _isValidSingnature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == account;
    }
}
