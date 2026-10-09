# PolyU Markdown Organisation Design

## Goal

Organise the Markdown files in `files/phd_materials/asia/_base_email_draft_template/` so that canonical working documents remain immediately accessible and completed review/audit records are grouped by purpose.

## Scope

- Move Markdown files only.
- Keep the canonical proposal and its core supporting documents at the package root.
- Leave PDFs, `references.bib`, `papers/`, TeX files, and LaTeX build artefacts unchanged.
- Preserve the byte content of moved records.
- Update only `README.md` content to document the resulting layout and provide navigation.

## Resulting Layout

### Package root

- `README.md`
- `polyu_research_proposal.md`
- `polyu_literature_master.md`
- `phd_project_positioning.md`
- `hkpfs_polyu_interview_notes_v17.md`

### `reviews/section4/`

- `section4_content_review.md`
- `section4_recommended_revision.md`

### `reviews/section5/`

- `section5_methodology_review.md`
- `section5_open_decisions.md`
- `section5_recommended_revision.md`
- `section5_timeline.md`
- `section_5_5_changes.md`
- `section_5_5_clarity_audit.md`

### `reviews/section6/`

- `section6_changes.md`
- `section6_open_decisions.md`
- `section6_recommended_revision.md`
- `section6_significance_review.md`

### `audits/citations/`

- `citation_changes.md`
- `citation_locator_audit.md`
- `empirical_system_references_audit.md`
- `final_bibliography_audit.md`
- `final_reference_changes.md`
- `final_reference_style_audit.md`

### `audits/editorial/`

- `em_dash_cleanup_audit.md`
- `em_dash_cleanup_changes.md`
- `final_abbreviation_audit.md`
- `final_style_audit.md`
- `final_style_changes.md`
- `prior_art_method_alignment_audit.md`
- `prior_art_method_alignment_changes.md`
- `proposal_compression_audit.md`
- `proposal_compression_changes.md`
- `proposal_compression_verification.md`
- `terminology_consistency_audit.md`
- `terminology_consistency_changes.md`

### `audits/final/`

- `final_proposal_changes.md`
- `final_proposal_consistency_audit.md`
- `final_proposal_open_decisions.md`
- `final_proposal_word_count.md`

## README Update

Replace the former handoff-oriented README with a concise package index covering:

- canonical working documents;
- supporting PDFs and bibliography;
- primary-source papers;
- section review directories;
- citation, editorial, and final-QA audit directories.

The README will not change proposal content or describe archived records as canonical.

## Validation

After moving the files:

1. Confirm that exactly the five intended Markdown files remain at the package root.
2. Confirm that every other original Markdown filename appears exactly once in its assigned directory.
3. Compare SHA-256 hashes before and after for every moved Markdown record.
4. Confirm that `polyu_research_proposal.md`, `references.bib`, PDFs, papers, and TeX/build files are unchanged.
5. Confirm that README paths resolve to existing files or directories.
