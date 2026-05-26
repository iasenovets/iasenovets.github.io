---
layout: default
title: Study Plan
---

<style>
.wrapper > header img {
  display: none;
}
</style>

# Study Plan | FHE, PETs, and Applied Cryptography

[Home](./) · [Study Plan](./study-plan) · [PIR Scheme Notes](./pir-schemes)

This page tracks the topics I am currently strengthening for applied cryptography, fully homomorphic encryption, privacy-preserving computation, and future research work. The focus is practical: understand the theory well enough to build, evaluate, and explain working systems.

## Current priority

1. **Refresh FHE internals**
   - CKKS encoding, scaling, rescaling, modulus chains, ciphertext levels, rotations, and precision loss.
   - BGV plaintext modulus, batching/SIMD slots, noise budget, ciphertext-plaintext multiplication, and modulus switching.
   - Differences between CKKS, BGV, and BFV.

2. **Strengthen noise growth and parameter selection**
   - How addition and multiplication affect noise.
   - Why rescaling and modulus switching are needed.
   - How ring dimension, coefficient modulus chains, plaintext modulus, and scale affect security and depth.
   - Practical interpretation of parameters in Lattigo, Microsoft SEAL, TenSEAL, and OpenFHE.

3. **Improve packing and chunking strategies**
   - CKKS vector packing and model-update chunking.
   - Slot capacity, chunk aggregation, reconstruction after decryption, and communication overhead.
   - Data-layout choices for PIR and encrypted aggregation.

4. **Deepen hands-on FHE framework experience**
   - OpenFHE CKKS/BGV/BFV examples.
   - Microsoft SEAL CKKS/BFV refresh.
   - TenSEAL CKKSVector behavior, serialization size, chunking, and profiling.
   - Compare APIs and performance trade-offs across Lattigo, SEAL, TenSEAL, and OpenFHE.

## Next technical layer

5. **TFHE and Concrete basics**
   - Boolean gates, gate bootstrapping, programmable bootstrapping.
   - When TFHE-style computation is more suitable than CKKS/BGV.
   - Concrete / Zama workflow for encrypted inference and FHE compilation.

6. **PQC and lattice cryptography foundations**
   - LWE, RLWE, and Module-LWE.
   - Relationship between HE assumptions and PQC assumptions.
   - NIST PQC standards: ML-KEM/Kyber, ML-DSA/Dilithium, and SLH-DSA/SPHINCS+.
   - Basic security levels, key sizes, ciphertext/signature sizes, and use cases.

7. **Lattice security estimation**
   - Primal and dual attacks.
   - BKZ and root Hermite factor intuition.
   - Using LWE Estimator beyond HE parameter sanity checks.

## Performance engineering

8. **NTT and SIMD**
   - Polynomial multiplication and why NTT dominates lattice-crypto performance.
   - NTT-friendly primes, forward/inverse NTT, and relation to HE libraries.
   - SIMD batching, slot rotations, diagonal method, baby-step/giant-step, and ciphertext packing strategies.

9. **Benchmarking methodology**
   - CPU time vs wall-clock time.
   - Memory use, serialization/deserialization cost, encryption/decryption/evaluation breakdown.
   - Ciphertext size, key size, rotation-key overhead, multiplicative depth, remaining levels, precision error, and noise budget.

10. **Systems implementation**
    - Modern C++ basics sufficient to read SEAL/OpenFHE-style code.
    - Rust basics for reading cryptographic code.
    - CUDA/GPU acceleration only after the FHE and NTT foundations are stronger.

## Privacy-preserving ML and secure aggregation

11. **Clarify privacy-preserving ML terminology**
    - Encrypted aggregation vs encrypted inference vs encrypted training.
    - What is protected in HE-based federated aggregation.
    - What remains exposed when clients train locally in plaintext.

12. **Federated learning privacy risks**
    - Gradient leakage, membership inference, model inversion, update poisoning.
    - Honest-but-curious server vs malicious client threat models.

13. **Secure aggregation and differential privacy**
    - Bonawitz-style masking and dropout handling.
    - HE-based aggregation vs masking-based secure aggregation.
    - DP clipping, Gaussian mechanism, privacy budget, composition, local DP vs central DP, and DP-SGD.

## Research communication

14. **Explain prototypes as research systems**
    - Threat model, security goal, leakage model.
    - Why a selected HE scheme fits the task.
    - What is protected, what is not protected, and what assumptions are required.

15. **State limitations honestly**
    - Functional prototype, not optimized implementation.
    - Library-based FHE system, not a new cryptographic primitive.
    - HE aggregation, not fully encrypted learning.
    - Lattice-aware, not yet a PQC standards expert.

## Reading queue

- CKKS original paper.
- BFV/BGV overview material.
- OpenFHE documentation and examples.
- Microsoft SEAL examples.
- TenSEAL documentation and paper.
- NIST FIPS 203: ML-KEM.
- NIST FIPS 204: ML-DSA.
- TFHE / programmable bootstrapping overview.
- Secure aggregation for federated learning.
- HE-based federated learning surveys.

## Suggested order

1. CKKS/BGV refresh.
2. Noise growth and parameter selection.
3. OpenFHE hands-on practice.
4. PQC basics: ML-KEM and ML-DSA.
5. NTT/SIMD basics.
6. Benchmarking methodology.
7. Secure aggregation and differential privacy.
8. C++/Rust/CUDA only after the above.
