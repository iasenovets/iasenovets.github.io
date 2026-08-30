---
layout: default
title: PIR Scheme Notes
---

<style>
.wrapper > header img {
  display: none;
}
</style>

# PIR Scheme Notes | Research Review

[Home](./) · [Study Plan](./study-plan) · [PIR Scheme Notes](./pir-schemes)

This page is a public index for my ongoing review of Private Information Retrieval (PIR) schemes. It is intentionally structured as a working research-notes template: detailed writeups, figures, and references can be added gradually.

Current review status: **reviewed up to Spiral / slide 56 in my PIR deck**.

[![View PIR review slides](https://img.shields.io/badge/PIR_Review-View_slides-blue?logo=microsoftpowerpoint)](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fiasenovets.github.io%2Ffiles%2FPIR_review.pptx)
[![Download PIR review slides](https://img.shields.io/badge/PIR_Review-Download_PPTX-orange?logo=microsoftpowerpoint)](/files/PIR_review.pptx)

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
