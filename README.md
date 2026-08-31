# Information Security Research Engineer

[Home](./) <!-- · [Study Plan](./study-plan) -->  · [PIR Notes](./pir-schemes)

#### I'm a master's student in Network and Information Security at CQUPT, in Cryptography and Applications Research Group with 4+ years of experience in software and security engineering. My interests lie in applied cryptography and privacy-enhancing technologies. I develop in Go, Python, and Rust, with some experience in Solidity. I translate cryptographic protocols from papers into code, conduct security, correctness and leakage analysis, and develop systems for private data search, retrieval, and processing based on homomorphic encryption.

[![ORCID](https://img.shields.io/badge/ORCID-0009--0008--0008--3746-brightgreen?logo=orcid)](https://orcid.org/0009-0008-0008-3746) [![Email](https://img.shields.io/badge/Email-L202420002%40stu.cqupt.edu.cn-red?logo=gmail)](mailto:L202420002@stu.cqupt.edu.cn) [![LinkedIn](https://img.shields.io/badge/LinkedIn-iasenovets-blue?logo=linkedin)](https://www.linkedin.com/in/iasenovets) [![TOEFL](https://img.shields.io/badge/TOEFL-C1-blue)](/files/toefl_8cd5f4a2b8ec8f34da49ea0faeef43f1.pdf) [![CV](https://img.shields.io/badge/CV-Download-blue?logo=adobeacrobatreader)](/files/phd/main.pdf)

**Research interests:** homomorphic encryption, private information retrieval, searchable encryption, private pattern matching, privacy-enhancing technologies, blockchain privacy.

## Education

- **M.S. in Network & Information Security**, [CQUPT](https://www.cqupt.edu.cn/en/) — Supervisor: [Prof. Tang Fei](https://faculty.cqupt.edu.cn/tangfei/en/index.htm); GPA: 3.98/4.0 — _Sep. 2024–Jul. 2027 (expected)_
- **B.S. in Information Systems and Technologies**, Ukhta State Technical University — GPA: 4.49/5.0 — _Mar. 2022–Jun. 2024_
- **B.S. studies in Information Systems and Technologies**, St. Petersburg State University of Telecommunications — _Sep. 2020–Mar. 2022 (transferred)_

## Selected Publications

- [**Bringing Private Reads to Hyperledger Fabric via Private Information Retrieval**](https://arxiv.org/abs/2511.02656) — arXiv preprint (submitted to IEEE), Nov. 2025 · [Repository](https://github.com/iasenovets/2_2_HLF_CPIR)
- [**EVMK-SSE: Efficient and Verifiable Multi-Keyword Symmetric Searchable Encryption**](https://doi.org/10.1007/s44443-025-00405-8) — _Journal of King Saud University — Computer and Information Sciences_, Dec. 2025
- [**MFCTIIF: Multi-Feed Cyber Threat Intelligence Integration Framework**](https://doi.org/10.60797/IRJ.2026.163.57) — _International Research Journal_, No. 1 (163), Jan. 2026
- **TWAPPA-FRL: Trust-Weighted Privacy-Preserving Aggregation for Federated Reinforcement Learning in Collaborative Intrusion Detection** — Manuscript submitted to IEEE, 2026 · Equal contribution

<!--
## Work Experience

- **Graduate Researcher**, [CQUPT](https://www.cqupt.edu.cn/en/) — _September 2024–Present_
- **Security Intern**, [Positive Technologies](https://pt-start.ptsecurity.com/) — _August 2024–February 2025_
- **Software Engineer**, [AcademAI](https://academai.ru) — _September 2023–August 2024_
- **Junior Software Engineer**, [ZVEK “Progress” LLC](https://zvekprogress.ru/) — _May 2022–August 2023_
-->

## Experiences

<details markdown="1">
<summary><strong>Research Experience</strong></summary>

- **Graduate Researcher**, [CQUPT](https://www.cqupt.edu.cn/en/) — _September 2024–Present_
  - **[HLF-CPIR](https://github.com/iasenovets/2_2_HLF_CPIR):** Designed and implemented BGV-based private information retrieval in Go using Lattigo for private world-state queries in Hyperledger Fabric, with query privacy under an honest-but-curious peer model based on the IND-CPA security of BGV.
  - **[TWAPPA-FRL](https://github.com/hetiantian10/TWAPPA-FRL):** Designed the architecture and implemented CKKS-based private aggregation of DQN model updates using TenSEAL, with IND-CPA-based client-update privacy under an honest-but-curious aggregator model and explicit leakage analysis.
  - **FPS/RFPS Private Pattern Search:** Implemented and validated a private pattern-search prototype, replacing the DFT-based matching transform under approximate-arithmetic CKKS with an NTT-based transform under exact-arithmetic BGV/BFV.
  - **[PIR Protocol Reconstruction](/pir-schemes):** Reconstructed preprocessing models, query construction, server computation, and response expansion for PIR protocols including Piano, FrodoPIR/SimplePIR, XPIR, SealPIR, and OnionPIR.

</details>

<details markdown="1">
<summary><strong>Industry Internships</strong></summary>

- **Information Security Engineer**, [Positive Technologies](https://global.ptsecurity.com/en/) — _August 2024–February 2025_
  - Developed Python tools with unit-test coverage for validating Windows paths, network configurations, and endpoint-control policies.
  - Built an automated malware-processing pipeline with an Airflow DAG that collected samples from MalwareBazaar, stored artifacts in S3, and scanned them with YARA.
  - Analyzed EVTX logs, PowerShell, and malicious VBA macros; extracted IoCs and mapped TTPs to MITRE ATT&CK for CVE-2020-5902 and CVE-2023-38831.

</details>

<details markdown="1">
<summary><strong>Industry Experience</strong></summary>

- **Software Engineer**, [AcademAI](https://academai.ru/) — _September 2023–August 2024_
  - **[YouKnow](https://github.com/AcademAI/youknow):** Developed the application layer with Next.js and TypeScript, Python/Flask services, a PostgreSQL/Prisma data layer, and Auth.js authentication for an LLM-based educational platform.
  - Integrated LangChain generation workflows with AsyncIO and Redis for asynchronous LLM orchestration and intermediate-state management.
  - Containerized the application with Docker, configured Nginx, deployed it to cloud-hosted VPS infrastructure, and built its GitHub Actions CI/CD workflow.
- **Junior Software Engineer**, [ZVEK “Progress” LLC](https://zvekprogress.ru/) — _May 2022–August 2023_
  - Designed and developed a full-stack warehouse QR-inventory system using Python and FastAPI, replacing a manual tracking process.
  - Interviewed 10+ stakeholders to gather requirements and owned the complete development lifecycle: backlogging, architecture design, code reviews, testing, debugging, and production deployment.

</details>

<!--
## Projects

- **[HLF-CPIR](https://github.com/iasenovets/2_2_HLF_CPIR):** Private world-state queries in Hyperledger Fabric using [private information retrieval](https://arxiv.org/abs/2511.02656).
- **[YouKnow](https://github.com/AcademAI/youknow):** LLM-based platform for generating personalized educational courses.
-->

## Achievements

Supporting documents: [Selected certificates with English summaries](/files/certificates_selected_en_public_ready_v2.pdf).

- **Chinese Government Scholarship (CSC) for Graduate Studies** — Full scholarship for the entire M.S. program at CQUPT — _2024–2027_
- **Sber Student Accelerator Regional Demo Day** — Completed the Sber Student Accelerator with the [AcademAI team](https://academai.ru/) and participated in the North-Western District regional demo day — _2023_
- **Winner, EdTech Project Competition** — Presented the [YouKnow LLM-based educational platform](https://github.com/AcademAI/youknow) and won the competition organized by the MIPT Phystech School, the Fund for Development of Phystech Schools, and Startech.Base — _2023_
- **MIPT & Sber Phystech GigaChat Challenge** — Developed the [YouKnow LLM-based educational platform](https://github.com/AcademAI/youknow) using GigaChat and Kandinsky APIs within a 48-hour sprint — _2023_
- **[Kaspersky Cyberimmunity Hackathon 2.0](https://github.com/iasenovets/cyberimmune2023_mi6)** — Placed 11th out of 100+ teams for developing traffic-monitoring solutions for low-altitude airspace security — _2023_
- **First Degree Diploma, Severgeoecotech** — Awarded first place in the Modern Information Technologies section of the 23rd International Youth Scientific Conference — _2022_
