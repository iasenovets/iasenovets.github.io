# PolyU Markdown Organisation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Organise the PolyU package Markdown files into canonical root documents, section reviews, and purpose-specific audit directories without changing the content of any moved record.

**Architecture:** Keep the five active Markdown documents at the package root. Move completed review and audit records into the approved `reviews/` and `audits/` hierarchy, then replace the handoff README with a navigation index. Validate the move using explicit filename sets and SHA-256 hashes.

**Tech Stack:** POSIX filesystem operations, Bash, Markdown, `find`, `sha256sum`, `comm`, and `cmp`.

---

### Task 1: Validate the source set and capture record hashes

**Files:**
- Inspect: `files/phd_materials/asia/_base_email_draft_template/*.md`
- Reference: `docs/superpowers/specs/2026-10-09-polyu-markdown-organisation-design.md`

- [ ] **Step 1: Confirm the source contains exactly 39 root-level Markdown files**

Run:

```bash
base="files/phd_materials/asia/_base_email_draft_template"
find "$base" -mindepth 1 -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort
test "$(find "$base" -mindepth 1 -maxdepth 1 -type f -name '*.md' | wc -l)" -eq 39
```

Expected: the approved 39 filenames are printed and the count assertion exits successfully.

- [ ] **Step 2: Capture hashes for the 38 Markdown files whose contents must remain byte-identical**

Run inside the execution shell before moving files:

```bash
manifest=$(mktemp)
find "$base" -mindepth 1 -maxdepth 1 -type f -name '*.md' ! -name 'README.md' -print0 \
  | sort -z \
  | xargs -0 sha256sum \
  | sed "s#  $base/#  #" > "$manifest"
test "$(wc -l < "$manifest")" -eq 38
```

Expected: the temporary manifest contains 38 hashes. `README.md` is excluded because Task 3 intentionally updates it.

### Task 2: Create the approved hierarchy and move records

**Files:**
- Create directories: `files/phd_materials/asia/_base_email_draft_template/reviews/section4/`
- Create directories: `files/phd_materials/asia/_base_email_draft_template/reviews/section5/`
- Create directories: `files/phd_materials/asia/_base_email_draft_template/reviews/section6/`
- Create directories: `files/phd_materials/asia/_base_email_draft_template/audits/citations/`
- Create directories: `files/phd_materials/asia/_base_email_draft_template/audits/editorial/`
- Create directories: `files/phd_materials/asia/_base_email_draft_template/audits/final/`
- Move: the 34 completed review and audit Markdown records listed in the approved design

- [ ] **Step 1: Create the six destination directories**

```bash
mkdir -p \
  "$base/reviews/section4" \
  "$base/reviews/section5" \
  "$base/reviews/section6" \
  "$base/audits/citations" \
  "$base/audits/editorial" \
  "$base/audits/final"
```

Expected: all six directories exist beneath the package root.

- [ ] **Step 2: Move section-review records**

```bash
mv -- "$base/section4_content_review.md" "$base/section4_recommended_revision.md" "$base/reviews/section4/"
mv -- "$base/section5_methodology_review.md" "$base/section5_open_decisions.md" "$base/section5_recommended_revision.md" "$base/section5_timeline.md" "$base/section_5_5_changes.md" "$base/section_5_5_clarity_audit.md" "$base/reviews/section5/"
mv -- "$base/section6_changes.md" "$base/section6_open_decisions.md" "$base/section6_recommended_revision.md" "$base/section6_significance_review.md" "$base/reviews/section6/"
```

Expected: each section directory contains exactly the files assigned in the design.

- [ ] **Step 3: Move citation, editorial, and final audit records**

```bash
mv -- "$base/citation_changes.md" "$base/citation_locator_audit.md" "$base/empirical_system_references_audit.md" "$base/final_bibliography_audit.md" "$base/final_reference_changes.md" "$base/final_reference_style_audit.md" "$base/audits/citations/"
mv -- "$base/em_dash_cleanup_audit.md" "$base/em_dash_cleanup_changes.md" "$base/final_abbreviation_audit.md" "$base/final_style_audit.md" "$base/final_style_changes.md" "$base/prior_art_method_alignment_audit.md" "$base/prior_art_method_alignment_changes.md" "$base/proposal_compression_audit.md" "$base/proposal_compression_changes.md" "$base/proposal_compression_verification.md" "$base/terminology_consistency_audit.md" "$base/terminology_consistency_changes.md" "$base/audits/editorial/"
mv -- "$base/final_proposal_changes.md" "$base/final_proposal_consistency_audit.md" "$base/final_proposal_open_decisions.md" "$base/final_proposal_word_count.md" "$base/audits/final/"
```

Expected: all 34 non-core records are moved and only the five canonical Markdown documents remain at the package root.

### Task 3: Turn README into a package index

**Files:**
- Modify: `files/phd_materials/asia/_base_email_draft_template/README.md`

- [ ] **Step 1: Replace README with the approved navigation content**

Use `apply_patch` so the README contains:

```markdown
# PolyU PhD proposal package

## Canonical working files

- [`polyu_research_proposal.md`](polyu_research_proposal.md)
- [`references.bib`](references.bib)
- [`polyu_literature_master.md`](polyu_literature_master.md)
- [`phd_project_positioning.md`](phd_project_positioning.md)
- [`hkpfs_polyu_interview_notes_v17.md`](hkpfs_polyu_interview_notes_v17.md)

## Supporting material

- `GSB1A_PolyU_v3_section3.pdf`: official-form packaging reference.
- `cbpir_submission.pdf`: citation-locator style example.
- [`papers/`](papers/): primary-source PDFs for proposal references [1]–[11].

## Review and audit records

- [`reviews/section4/`](reviews/section4/): Section 4 content review and recommended revision.
- [`reviews/section5/`](reviews/section5/): methodology review, timeline, decisions and Section 5.5 clarity records.
- [`reviews/section6/`](reviews/section6/): significance review, decisions, revision and changes.
- [`audits/citations/`](audits/citations/): citation-locator, empirical-system, bibliography and reference-style records.
- [`audits/editorial/`](audits/editorial/): terminology, style, compression, abbreviation, punctuation and prior-art alignment records.
- [`audits/final/`](audits/final/): whole-proposal consistency, word-count, open-decision and final-change records.

The proposal and bibliography at the package root are canonical. Files under `reviews/` and `audits/` preserve completed working history.
```

Expected: README provides direct navigation and distinguishes canonical files from historical records.

### Task 4: Verify the organised package

**Files:**
- Verify: `files/phd_materials/asia/_base_email_draft_template/`
- Verify unchanged: `files/phd_materials/asia/_base_email_draft_template/polyu_research_proposal.md`
- Verify unchanged: `files/phd_materials/asia/_base_email_draft_template/references.bib`
- Verify unchanged: PDFs, `papers/`, TeX files, and LaTeX build artefacts

- [ ] **Step 1: Rebuild the relocated-file manifest and compare hashes**

```bash
after_manifest=$(mktemp)
{ find "$base" -mindepth 1 -maxdepth 1 -type f -name '*.md' ! -name 'README.md' -print0; \
  find "$base/reviews" "$base/audits" -type f -name '*.md' -print0; } \
  | sort -z \
  | xargs -0 sha256sum \
  | sed -E 's#  .*/([^/]+)$#  \1#' \
  | sort -k2 > "$after_manifest"
sort -k2 "$manifest" -o "$manifest"
cmp "$manifest" "$after_manifest"
```

Expected: `cmp` exits successfully, proving that all 34 moved records and the four unchanged core supporting Markdown documents are byte-identical.

- [ ] **Step 2: Verify the final Markdown layout and canonical files**

```bash
test "$(find "$base" -mindepth 1 -maxdepth 1 -type f -name '*.md' | wc -l)" -eq 5
test "$(find "$base/reviews" "$base/audits" -type f -name '*.md' | wc -l)" -eq 34
test -f "$base/polyu_research_proposal.md"
test -f "$base/polyu_literature_master.md"
test -f "$base/phd_project_positioning.md"
test -f "$base/hkpfs_polyu_interview_notes_v17.md"
test -f "$base/references.bib"
```

Expected: five root Markdown files, 34 organised records, and every canonical file present.

- [ ] **Step 3: Verify README links and untouched non-Markdown assets**

```bash
for path in \
  polyu_research_proposal.md references.bib polyu_literature_master.md \
  phd_project_positioning.md hkpfs_polyu_interview_notes_v17.md papers \
  reviews/section4 reviews/section5 reviews/section6 \
  audits/citations audits/editorial audits/final; do
  test -e "$base/$path"
done
test -f "$base/GSB1A_PolyU_v3_section3.pdf"
test -f "$base/cbpir_submission.pdf"
test -f "$base/email_draft_template.tex"
```

Expected: every README target resolves and the supporting non-Markdown assets remain in place.

- [ ] **Step 4: Remove temporary manifests and inspect the final tree**

```bash
rm -f -- "$manifest" "$after_manifest"
find "$base" -maxdepth 3 -printf '%y %P\n' | sort
```

Expected: the final tree matches the approved design and no temporary file remains.
