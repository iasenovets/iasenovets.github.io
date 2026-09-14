# PhD Supplementary Materials Structure

## Purpose

Create a working area for PhD application documents. The statement of purpose
will remain mostly reusable, while research proposals will support separate
advisor-specific versions without duplicating shared technical material.

## Directory Structure

```text
files/phd_materials/
├── statement_of_purpose/
│   ├── main.tex
│   └── main.pdf
└── research_proposals/
    ├── shared/
    │   └── proposal_content.tex
    └── advisors/
        └── _template/
            ├── main.tex
            └── main.pdf
```

## Document Responsibilities

- `statement_of_purpose/main.tex` is the single reusable SoP source and builds
  independently to `main.pdf`.
- `research_proposals/shared/proposal_content.tex` contains reusable research
  background, prior work, and core proposal material.
- `research_proposals/advisors/_template/main.tex` is a compilable starting
  point for new advisor versions. Each copied
  `research_proposals/advisors/<advisor_slug>/main.tex` remains an independent
  build entry point containing advisor-specific motivation, research fit, and
  framing while importing shared material where appropriate.
- Advisor folder names use stable lowercase slugs, such as `jane_smith`.

## Build and Validation

Documents use the repository's existing LaTeX workflow and build independently
with `latexmk`. Generated PDFs remain beside their corresponding `main.tex`
files. Initial scaffolding must compile successfully and contain clear placeholder
headings without fabricated advisor or application content.

## Scope

This setup creates the directories and starter LaTeX documents only. It does not
draft a statement of purpose, select a research proposal, or add a specific
advisor version beyond the reusable template.
