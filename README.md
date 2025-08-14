 Skill-Proof Smart Contract

A Clarity smart contract for decentralized, on-chain verification of user skills and credentials on the Stacks blockchain.  
Skill-Proof enables individuals to register their skills, have them verified by trusted parties, and store proof of verification on-chain for transparent and immutable validation.

---

 Features
- **Register Skills** — Users can submit a skill with details such as name, description, and proficiency level.
- **Verify Skills** — Authorized verifiers can validate submitted skills.
- **Immutable Proof** — Once verified, skill records are permanently stored on-chain.
- **Public Queries** — Anyone can check a user's verified skills.
- **Duplicate Prevention** — Ensures skills are registered uniquely.

---

 Contract Functions

| Function Name     | Description |
|-------------------|-------------|
| `register-skill`  | Allows a user to register a new skill with metadata. |
| `verify-skill`    | Allows an authorized verifier to confirm a skill claim. |
| `get-skill`       | Retrieves details about a specific skill for a given user. |
| `is-verified`     | Checks if a given skill is verified for a user. |

---

 Data Structures

- **`skills`** — Stores skill details mapped by `(user, skill-id)`.
- **`verifications`** — Stores verification status mapped by `(user, skill-id)`.

---

 Usage

1. Register a Skill
```clarity
(contract-call? .skill-proof register-skill "Web Development" "Full-stack development with JavaScript and Clarity" u5)
(contract-call? .skill-proof verify-skill tx-sender "Web Development")
(contract-call? .skill-proof is-verified 'SP1234... "Web Development")
stx deploy --network=testnet --contract-name=skill-proof
