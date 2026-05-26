# Applied Cryptography Researcher | FHE Systems, PIR, PETs

[![ORCID](https://img.shields.io/badge/ORCID-0009--0008--0008--3746-brightgreen?logo=orcid)](https://orcid.org/0009-0008-0008-3746)
[![CV](https://img.shields.io/badge/CV-Applied%20Crypto-blue?logo=adobeacrobatreader)](/files/fhe_engineer/cv_fhe_applied_crypto_variant_a.pdf)
[![Academic CV](https://img.shields.io/badge/CV-Academic%20%2F%20PhD-lightgrey?logo=adobeacrobatreader)](/files/fhe_phd/cv_phd_variant_b.pdf)

#### I'm a master's student in Network and Information Security at CQUPT, researching fully homomorphic encryption, private information retrieval, and privacy-preserving systems. My work focuses on applied cryptography prototypes, including BGV-based PIR for Hyperledger Fabric and CKKS-based encrypted aggregation for federated reinforcement learning.

## Research Interests

Fully Homomorphic Encryption · Private Information Retrieval · Privacy-Preserving Computation · Secure Aggregation · Blockchain Privacy · Cyber Threat Intelligence

## Education

- M.S., Network & Information Security | [CQUPT](https://www.cqupt.edu.cn/en/) — Supervisor: [Prof. Tang Fei](https://faculty.cqupt.edu.cn/tangfei/en/index.htm) | GPA: 3.9/4.0 _(2024 – Present)_
- B.S., Information Systems and Technologies | Ukhta State Technical University | GPA: 4.5/5.0 (3.6/4.0) _(2022 – 2024)_
- B.S., Information Systems and Technologies | St. Petersburg State University of Telecommunications _(2020 – 2022)_

## Publications & Manuscripts

| Title | Venue / Status | Links |
| --- | --- | --- |
| Bringing Private Reads to Hyperledger Fabric via Private Information Retrieval | arXiv preprint (submitted to IEEE), Nov. 2025 | [arXiv](https://arxiv.org/abs/2511.02656) · [Repository](https://github.com/iasenovets/2_2_HLF_CPIR) |
| Adaptive Privacy-Aware Federated Reinforcement Learning with Trust-Weighted Secure Aggregation | Manuscript in preparation, 2026 | CKKS encrypted aggregation with TenSEAL |
| EVMK-SSE: Efficient and Verifiable Multi-Keyword Symmetric Searchable Encryption | J. King Saud Univ. Comput. Inf. Sci., Dec. 2025 | [DOI](https://doi.org/10.1007/s44443-025-00405-8) |
| MFCTIIF: Multi-Feed Cyber Threat Intelligence Integration Framework | International Research Journal, No. 1 (163), Jan. 2026 | [DOI](https://doi.org/10.60797/IRJ.2026.163.57) |

## Selected Research Projects

| Project | Description | Technologies |
| --- | --- | --- |
| [BGV-Based PIR for Hyperledger Fabric](https://github.com/iasenovets/2_2_HLF_CPIR) | Implemented a single-server HE-PIR prototype for private world-state reads using packed CTI records, client-side encrypted selection vectors, and chaincode-side ciphertext-plaintext evaluation. Evaluated latency, network traffic, storage overhead, and parameter/capacity constraints. | Go, Lattigo, Hyperledger Fabric, Docker, BGV, PIR, RLWE-based HE |
| CKKS-Based Encrypted Aggregation for Federated Reinforcement Learning | Implemented CKKS-encrypted model-update aggregation using TenSEAL with chunked model-update encoding. Clients train locally in plaintext while aggregation is performed over encrypted updates. Compared plaintext, DP, trust-weighted, HE, and HE+DAPI execution paths for network-defense learning. | Python, TenSEAL, PyTorch, NumPy, CKKS, Federated Learning, Reinforcement Learning |
| [YouKnow](https://github.com/AcademAI/youknow) | LLM application for generating personalized educational courses; included backend orchestration of structured LLM prompts and a full-stack web interface. | Python, Flask, Next.js, TypeScript, Prisma, Auth.js, AsyncIO, Langchain |

## Work Experience

**Graduate Researcher @ [CQUPT](https://www.cqupt.edu.cn/en/) — Applied Cryptography Group (_September 2024 – Present_)**

- Designed and implemented BGV-based private information retrieval for Hyperledger Fabric using Lattigo, including packed plaintext encoding, encrypted query generation, ciphertext-plaintext evaluation, and client-side decoding.
- Implemented CKKS-based encrypted aggregation for federated reinforcement learning using TenSEAL, PyTorch, and NumPy, including chunked model-update encoding.
- Evaluated privacy-preserving prototypes using latency, communication volume, storage overhead, ciphertext expansion, and parameter/capacity constraints.
- Contributed to research papers on FHE-based PIR, searchable encryption, cyber threat intelligence, and privacy-preserving federated learning.
- Participating in weekly research seminars, paper reviews, and collaborative research discussions within the group.

**Security Intern @ [Positive Technologies](https://pt-start.ptsecurity.com/) — Remote (_August 2024 – February 2025_)**

- Developed Python utilities for the MaxPatrol EDR product team, including regex-based Windows path/network configuration parsing, unit-test coverage, and a Windows Prefetch-based software allowlist/blocklist checker.
- Engineered a Python malware-processing pipeline for the Threat Intelligence team, fetching samples from VX-Underground, storing artifacts in S3/MinIO, scanning with YARA rules, and packaging the workflow as an Airflow DAG.
- Performed SOC analysis on CVE-2020-5902 and CVE-2023-38831 attack chains, including EVTX log forensics with Chainsaw, PowerShell deobfuscation, VBA macro analysis with oletools, IoC extraction, and MITRE ATT&CK mapping.

**Software Engineer @ [AcademAI](https://academai.ru) — Remote (_August 2023 – August 2024_)**

- Built a Flask REST API backend where each endpoint encapsulates a structured system prompt, orchestrating asynchronous LLM calls via Langchain to generate individual course components on demand.
- Built the frontend with Next.js, TypeScript, Prisma, and Auth.js, ensuring seamless user authentication and consistent UI across devices.
- Built a CI/CD pipeline using GitHub Actions with Docker containerization.

## Achievements

| Title | Description |
| --- | --- |
| Chinese Government Scholarship for Graduate Studies | Awarded a full scholarship by the Chinese government for the entire duration of the M.S. program at CQUPT (2024–2027). |
| 5 Science Conferences | Won 3 consecutive first places in paper evaluations at various scientific conferences while at USTU (Apr. 2022 – Apr. 2023). |
| [Kaspersky Cyberimmunity Hackathon 2.0](https://github.com/artias13/Events/blob/main/2023/kaspersky_hackathon_2023_winter.png) | Participated in Kaspersky’s Cyberimmunity Hackathon in Fall 2023, placing 11th out of 100+ teams. |
| [MIPT & Sber Phystech GigaChat Challenge Hackathon](https://github.com/artias13/Events/blob/main/2023/mfti_ai_hackathon_2023_winter.png) | Developed [YouKnow](https://youknow.academai.ru) using GigaChat and Kandinsky APIs within a 48-hour sprint. |
| [iTechPred 2023 Accelerator](https://github.com/artias13/Events/blob/main/2023/itechpred_2023_summer-winter.png) | Completed Petrozavodsk University’s acceleration program on technological entrepreneurship with the YouKnow project. |
| [SberStudent Accelerator](https://github.com/artias13/Events/blob/main/2023/sberstudent_academai_2023_fall.png) | Presented AcademAI at the regional demo day of the North-West District of the Sber Student Accelerator. |

## Documents

- [Applied Crypto / FHE CV](/files/cv.pdf)
- [Academic / PhD CV](/files/cv_academic_phd.pdf)
- [Selected certificates with English summaries](/files/certificates_selected_en_public_ready_v2.pdf)
