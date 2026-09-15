# Metadata sanitization

Repository hooks automatically remove metadata from staged media and documents
before each commit. A pre-push check scans every outgoing commit and rejects the
push when metadata remains anywhere in the outgoing history.

Enable the versioned hooks once per clone:

```bash
./scripts/install-git-hooks.sh
```

The sanitizer prefers [`mat2`](https://github.com/jvoisin/mat2). When `mat2`
is unavailable, it automatically downloads the pinned official ExifTool 13.59
release into `.git/metadata-tools/` and verifies its SHA-256 checksum. PDF
fallback cleaning also requires `qpdf`, because ExifTool's PDF edits remain
recoverable until the file is rewritten. A Python standard-library helper
cleans DOCX, PPTX, and XLSX properties, thumbnails, ZIP comments, extra fields,
and timestamps.

Candidate files include common images, PDFs, Office/OpenDocument files, EPUBs,
audio, and video. Exact format coverage depends on the installed `mat2`
backends. The automatic fallback covers ExifTool-writable media, PDF, DOCX,
PPTX, and XLSX. It fails closed instead of committing a format it cannot safely
rewrite. Text and source files are ignored.

Recommended container packages are `mat2`, `qpdf`, `python3`, and `unzip`.
Without `mat2`, automatic ExifTool bootstrapping also requires `curl`, `perl`,
`tar`, and `sha256sum` or `shasum`.

The pre-commit hook refuses partially staged supported files because automatic
re-staging would otherwise include unstaged edits. Stage the complete file and
commit again.

Metadata cleaning rewrites files and invalidates digital signatures. It removes
embedded metadata on a best-effort basis; it cannot anonymize visible content,
watermarks, steganography, or every custom metadata field.

Run the sanitizer manually against staged files:

```bash
./scripts/sanitize-metadata.sh --staged
```

Run tests:

```bash
./scripts/tests/test-sanitize-metadata.sh
./scripts/tests/test-sanitize-office-metadata.py
```
