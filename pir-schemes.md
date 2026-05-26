---
layout: default
title: PIR Scheme Notes
---

# PIR Scheme Notes | Research Review

[Home](./) · [Study Plan](./study-plan) · [PIR Scheme Notes](./pir-schemes) · [ORCID](https://orcid.org/0009-0008-0008-3746) · [CV](/files/old/phd/cv.pdf)

This page is a public index for my ongoing review of Private Information Retrieval (PIR) schemes. It is intentionally structured as a working research-notes template: detailed writeups, figures, and references can be added gradually.

Current review status: **reviewed up to Spiral / slide 56 in my PIR deck**.

## Purpose

The goal of this page is to track PIR schemes by construction family, assumptions, preprocessing model, communication cost, server computation, and practical deployment relevance.

## Review status

| Area | Status | Notes |
| --- | --- | --- |
| PIR taxonomy | Drafted | Covers ITPIR, CPIR, preprocessing PIR, and silent PPIR categories. |
| Piano | Reviewed | PRF-based client-stored database hints; strong online efficiency, but requires client-side preprocessing over the database. |
| BFV/BGV-style CPIR learning example | Reviewed | Used to understand LWE/RLWE, BFV/BGV-style operations, encrypted selection vectors, and ciphertext-plaintext evaluation. |
| FrodoPIR / SimplePIR | Reviewed | LWE-based preprocessing PIR with client-stored hints. |
| Hypercube PIR | Reviewed | General database-layout view used to understand XPIR, SealPIR, OnionPIR, and later RLWE-based PIR systems. |
| XPIR | Reviewed | Ring-LWE hypercube PIR baseline with larger query cost. |
| SealPIR | Reviewed | Compressed-query hypercube PIR using monomial encoding and query expansion. |
| OnionPIR | Reviewed | Response-efficient RLWE/BFV + RGSW construction using external products. |
| Spiral | In progress | Next detailed writeup target. |
| Respire | Planned | Placeholder. |
| HintlessPIR | Planned | Placeholder. |
| YPIR | Planned | Placeholder. |
| KsPIR | Planned | Placeholder. |
| InsPIRe | Planned | Placeholder. |

## Taxonomy template

| Category | Schemes | Main assumption | Preprocessing model | Notes |
| --- | --- | --- | --- | --- |
| Information-theoretic PIR | Chor et al., Goldberg et al., RAID-PIR | Non-colluding servers | Usually multi-server | Strong privacy, but deployment requires multiple non-colluding servers. |
| Single-server CPIR | XPIR, SealPIR, OnionPIR, Spiral | LWE/RLWE-style assumptions | No client preprocessing or server-stored client hints, depending on scheme | Practicality depends on communication, server computation, and ciphertext expansion. |
| Client-stored hint PPIR | FrodoPIR, SimplePIR, Piano | LWE or PRF-based assumptions | Client stores hints after preprocessing | Good online efficiency, but preprocessing and storage model matter. |
| Silent / server-side PPIR | HintlessPIR, YPIR, KsPIR, InsPIRe | Usually RLWE/LWE-based assumptions | Server-side preprocessing without explicit offline client communication | Interesting for reducing online interaction and amortizing work. |

## Scheme note template

Use this template for each scheme.

```md
## Scheme Name

**Paper:**  
**Venue / Year:**  
**Category:**  
**Hardness assumption:**  
**Preprocessing model:**  
**Database layout:**  
**Query structure:**  
**Server computation:**  
**Response structure:**  
**Client storage:**  
**Communication:**  
**Server time:**  
**Client time:**  
**Strengths:**  
**Limitations:**  
**Implementation notes:**  
**Relevance to my work:**  
```

## Current detailed notes

### Piano

**Category:** preprocessing PIR with client-stored database hints.  
**Assumption:** PRF-based construction.  
**Key idea:** the client stores secret hint sets and parities produced during a preprocessing pass over the database. Online queries modify a hint so that the server cannot identify the target index.

**Important implementation question:** Piano is attractive for online efficiency, but the client must keep hint sets secret. If the server learns the hint set, it can compare the online query against the stored set and infer the requested index.

**Relevance:** useful as a conceptual model for offline hinting, but less directly compatible with encrypted-at-rest databases unless the client can decrypt during preprocessing or another trusted/cryptographic mechanism is introduced.

### BFV/BGV-style CPIR learning example

**Category:** single-server computational PIR.  
**Assumption:** RLWE-based security.  
**Key idea:** the client encrypts a one-hot selection vector. The server multiplies encrypted selector slots by plaintext database records and homomorphically accumulates the result. The client decrypts only the selected record.

**Relevance:** directly related to my Hyperledger Fabric PIR work, where BGV is used to support private reads over packed CTI records.

### FrodoPIR / SimplePIR

**Category:** LWE-based preprocessing PIR with client-stored hints.  
**Key contrast:** these schemes reduce online cost through preprocessing and hint material. SimplePIR improves the setup/query structure and argues security for repeated fresh query randomness.

**To expand later:** exact setup/answer/query/recover algorithms, parameter choices, and amortized cost comparison.

### Hypercube PIR

**Category:** database layout strategy used by several RLWE-based PIR systems.  
**Key idea:** reshape the database into a multi-dimensional hypercube. The client sends encrypted unit vectors for each dimension. The server folds the database dimension by dimension until only the target record remains encrypted.

**Relevance:** useful for understanding XPIR, SealPIR, OnionPIR, and Spiral-style improvements.

### XPIR

**Category:** Ring-LWE hypercube CPIR.  
**Key idea:** database is arranged as a 2D or 3D hypercube; the client sends encrypted unit vectors. Server uses ciphertext-plaintext multiplication to select and fold entries.

**Limitation:** query size and response expansion remain significant.

### SealPIR

**Category:** compressed-query hypercube PIR.  
**Key idea:** query compression using monomial encoding and query expansion. This reduces query size compared with XPIR while keeping the same general hypercube computation style.

**Limitation:** response size remains affected by ciphertext expansion.

### OnionPIR

**Category:** response-efficient RLWE-based PIR.  
**Key idea:** combines BFV/RLWE with RGSW-style query material and external products. This reduces reply expansion and enables deeper hypercube folding with more manageable noise growth.

**Relevance:** important bridge toward understanding Spiral and more advanced RLWE-based PIR systems.

### Spiral

**Status:** in progress.  
**Next step:** add a structured summary of Spiral's main construction, preprocessing model, query structure, server computation, response compression, and comparison with SealPIR/OnionPIR.

## Next update tasks

1. Add full Spiral notes.
2. Add Respire section.
3. Add HintlessPIR / YPIR / KsPIR / InsPIRe sections.
4. Convert slide material into concise public notes.
5. Add references and links to papers/repositories.
6. Add a cost-comparison table across schemes.
