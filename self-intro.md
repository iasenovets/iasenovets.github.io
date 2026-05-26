Below is the fully English version.

## 1. Concise self-introduction

Hi, my name is Artur Iasenovets. I am a master’s student in Network and Information Security at Chongqing University of Posts and Telecommunications, focused on applied cryptography and privacy-enhancing technologies. My main interests are fully homomorphic encryption, private information retrieval, blockchain privacy, and privacy-preserving computation.

My main research project is a BGV-based private information retrieval system for Hyperledger Fabric. I implemented it in Go using Lattigo: the client sends an encrypted query, and the blockchain peer evaluates it without learning which record is being retrieved. I also worked with CKKS and TenSEAL for encrypted aggregation in federated reinforcement learning, where clients train locally and the server aggregates encrypted model updates.

Before that, I worked as a software engineer in an EdTech startup, building backend, frontend, and CI/CD infrastructure. I also completed a security internship at Positive Technologies, where I worked on EDR utilities, threat intelligence pipelines, and SOC analysis. 

What I want to do next is grow as an applied cryptography / privacy-preserving systems engineer: not only studying cryptographic primitives, but building working prototypes, evaluating performance, and understanding how FHE can be used in practical systems like privacy-preserving AI, secure analytics, and confidential cloud computation.

## 2. Talking topic: FHE and its applications

Fully homomorphic encryption is a cryptographic technique that allows computation directly on encrypted data. Normally, if data is encrypted, a server cannot process it unless it first decrypts it. With FHE, the server can compute over ciphertexts, and after decryption the client gets the result as if the computation had been done on plaintext.

The simplest way to explain it is: the cloud can process your data without seeing your data.

Different FHE schemes are useful for different tasks. CKKS is commonly used for approximate real-number computation, so it is useful for machine learning, statistics, encrypted aggregation, and analytics. BGV and BFV are better suited for exact arithmetic over integers or modular values. TFHE is more suitable for Boolean circuits and bit-level computation.

The applications I find most interesting are privacy-preserving AI and confidential cloud computation. For example, in private ML inference, a user could send encrypted input to a cloud model, the cloud computes prediction on encrypted data, and only the user decrypts the result. In secure analytics, a company could compute statistics or recommendations over sensitive user data without directly exposing raw records. In federated learning, clients can train locally and send encrypted model updates, so the aggregator can combine updates without seeing individual contributions.

In my own work, I used this idea in two directions. First, I implemented BGV-based PIR for Hyperledger Fabric, where the peer evaluates an encrypted query without learning which record was requested. Second, I worked with CKKS/TenSEAL for encrypted aggregation in federated reinforcement learning. In that case, the learning itself is not fully encrypted, but the aggregation step is protected, which is a practical and more realistic near-term use of FHE.

The main challenge is performance. FHE is powerful, but ciphertexts are large, operations are slower than plaintext computation, and parameter selection is difficult. So practical work is not only about knowing the cryptography, but also about choosing the right scheme, packing data efficiently, managing noise or precision, and benchmarking latency, communication cost, and accuracy.

## 3. Talking topic: what I would like to work on

I would be interested in working on practical FHE systems and privacy-preserving computation prototypes. My strongest current direction is applied FHE: taking schemes like CKKS, BGV, or BFV and using them in real systems where privacy matters.

In the near term, I would like to deepen my understanding of CKKS and BGV internals: scale management, rescaling, modulus chains, packing, rotations, noise growth, and parameter selection. I have used libraries like Lattigo, TenSEAL, and Microsoft SEAL, but I want to become more confident not only using them, but also understanding what happens under the hood.

I would also like to work more with OpenFHE and compare different FHE frameworks in practice: how they handle CKKS/BGV/BFV, what their performance trade-offs are, and how suitable they are for applications like private inference, encrypted aggregation, secure analytics, and confidential cloud services.

Another direction I want to grow into is performance evaluation. I already have experience measuring latency, communication volume, and storage overhead, but I want to become better at deeper profiling: ciphertext size, key size, rotation key overhead, serialization cost, precision error, memory usage, and scalability with larger datasets or models.

Longer term, I also want to strengthen my background in lattice-based cryptography and post-quantum cryptography, especially LWE/RLWE, ML-KEM, and ML-DSA. But my immediate practical interest is FHE systems engineering: building prototypes, testing them, understanding their limitations, and helping move privacy-preserving computation closer to real deployment.
