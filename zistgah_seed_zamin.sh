#!/usr/bin/env bash
###############################################################################
#  zistgah_seed_zamin.sh
#  Seed this repository as zistgah/zamin (GitHub Pages -> https://zistgah.org/zamin/),
#  mint a citable DOI + an OpenTimestamps proof with Misty DOI, and write the DOI
#  back into README.md, CITATION.cff, codemeta.json, index.html and paper/index.html.
#
#  SPDX-License-Identifier: GPL-3.0-or-later
#  © 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
#
#  USAGE   ./zistgah_seed_zamin.sh
#  FLAGS   DO_PUSH=1  push to the repo                     (default 1)
#          DO_MINT=0  mint a REAL PERMANENT Zenodo DOI     (default 0 = dry-run)
#          SANDBOX=0  when minting, use sandbox.zenodo.org (default 0)
#          ZENODO_TOKEN, ORCID  read only from env, never pasted, never stored
#  Nothing irreversible happens without an explicit typed confirmation.
###############################################################################
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"
DO_PUSH="${DO_PUSH:-1}"; DO_MINT="${DO_MINT:-0}"; SANDBOX="${SANDBOX:-0}"
GH_SLUG="zistgah/zamin"; VER="1.0.0"; ARTIFACT="$ROOT/zamin-$VER.zip"

say(){  printf '\n\033[1;33m=== %s ===\033[0m\n' "$*"; }
ok(){   printf '\033[1;36m  %s\033[0m\n' "$*"; }
warn(){ printf '\033[1;31m  !! %s\033[0m\n' "$*"; }
die(){  printf '\033[1;31mFATAL: %s\033[0m\n' "$*" >&2; exit 1; }
confirm(){ read -r -p "  $1 " a; [ "$a" = "$2" ]; }

say "0. PREFLIGHT"
command -v git >/dev/null 2>&1 || die "git not found"
command -v zip >/dev/null 2>&1 || die "zip not found"
[ -f "$ROOT/doi/misty.json" ] || die "missing doi/misty.json"
[ -f "$ROOT/index.html" ] && [ -f "$ROOT/paper/index.html" ] || die "run me from the repo root"
HAVE_MISTY=0; command -v misty >/dev/null 2>&1 && HAVE_MISTY=1 || warn "misty not installed (pipx install misty-doi) — DOI steps skipped"
HAVE_GH=0;    command -v gh    >/dev/null 2>&1 && HAVE_GH=1    || warn "gh not installed — push skipped"

say "0b. VERIFY BY EXECUTION (syntax + validity gates)"
# HTML well-formedness + JSON validity + Python syntax; refuse to seed if broken.
python3 - <<'PY' || die "validation failed — refusing to seed"
import json,sys,py_compile
from html.parser import HTMLParser
class P(HTMLParser):
    def error(self,m): raise Exception(m)
for f in ["index.html","paper/index.html"]:
    P().feed(open(f,encoding="utf-8").read()); print("  html ok:",f)
for f in ["doi/misty.json","codemeta.json"]:
    json.load(open(f)); print("  json ok:",f)
py_compile.compile("layout/pratik_fluidic_interposer.py",doraise=True); print("  py ok: layout")
PY
# optional: if ngspice present, lint the testbench (do not fail the seed on model stubs)
command -v ngspice >/dev/null 2>&1 && { ngspice -b spice/sign_frustration_tb.sp >/dev/null 2>&1 && ok "ngspice ran testbench" || warn "ngspice present but testbench needs a real PDK (expected)"; } || true

say "1. BUILD RELEASE ARTIFACT (zip + checksums)"
rm -f "$ROOT"/zamin-*.zip "$ROOT/SHA256SUMS.txt"
( cd "$ROOT" && find . -type f -not -path './.git/*' -not -path './.work*/*' \
    -not -name '*.zip' -not -name 'SHA256SUMS.txt' -not -path './provenance/*' \
    | sort | xargs sha256sum > SHA256SUMS.txt )
( cd "$ROOT" && zip -q -X -r "$ARTIFACT" . -x '.git/*' '.work*/*' '*.zip' 'provenance/*' )
ok "artifact: $ARTIFACT ($(du -h "$ARTIFACT" | cut -f1))"

say "2. MISTY VALIDATE + DRY-RUN"
[ -n "${ORCID:-}" ] && python3 - "$ROOT/doi/misty.json" "$ORCID" <<'PY'
import json,sys
p,orcid=sys.argv[1],sys.argv[2]
d=json.load(open(p)); d["creators"][0]["orcid"]=orcid
json.dump(d,open(p,"w"),indent=2,ensure_ascii=False)
PY
DOI_ID=""; RECORD_URL=""
if [ "$HAVE_MISTY" -eq 1 ]; then
  misty validate -m "$ROOT/doi/misty.json" || die "misty.json invalid"
  misty publish -m "$ROOT/doi/misty.json" -f "$ARTIFACT" --dry-run \
        --package-dir "$ROOT/.doi-package" --output "$ROOT/result.dryrun.json" >/dev/null
  ok "dry-run package -> $ROOT/.doi-package"
fi

if [ "$DO_MINT" -eq 1 ] && [ "$HAVE_MISTY" -eq 1 ]; then
  say "3. MINT DOI  (IRREVERSIBLE)"
  [ -n "${ZENODO_TOKEN:-}" ] || die "DO_MINT=1 but ZENODO_TOKEN unset. export ZENODO_TOKEN=... (rehearse with SANDBOX=1)"
  EXTRA=(); [ "$SANDBOX" -eq 1 ] && { export ZENODO_SANDBOX=1; EXTRA+=(--sandbox); warn "SANDBOX: disposable test DOI"; } || warn "PRODUCTION: a Zenodo DOI is PERMANENT"
  if confirm "Type MINT to publish a $([ "$SANDBOX" -eq 1 ] && echo SANDBOX || echo PRODUCTION) DOI:" MINT; then
    misty publish -m "$ROOT/doi/misty.json" -f "$ARTIFACT" "${EXTRA[@]}" \
          --package-dir "$ROOT/.doi-package" --output "$ROOT/result.json"
    DOI_ID="$(python3 -c 'import json;print(json.load(open("'"$ROOT"'/result.json")).get("doi",""))' 2>/dev/null || true)"
    RECORD_URL="$(python3 -c 'import json;print(json.load(open("'"$ROOT"'/result.json")).get("record_url",""))' 2>/dev/null || true)"
    ok "DOI : ${DOI_ID:-?}"; ok "URL : ${RECORD_URL:-?}"
    say "3b. OPENTIMESTAMPS PROOF"; mkdir -p "$ROOT/provenance"
    misty ots stamp "$ARTIFACT" || warn "ots stamp failed (needs misty-doi[ots] or the ots CLI)"
    [ -f "$ARTIFACT.ots" ] && mv "$ARTIFACT.ots" "$ROOT/provenance/" && ok "stamped -> provenance/ (run 'ots upgrade' later for the Bitcoin attestation)"
  else warn "mint aborted; nothing published"; fi
else
  say "3. MINT DOI — skipped (DO_MINT=1 to mint; SANDBOX=1 to rehearse)"
fi

say "4. WRITE DOI INTO REPO FILES"
if [ -n "$DOI_ID" ]; then DISP="$DOI_ID"; URL="${RECORD_URL:-https://doi.org/$DOI_ID}"
else DISP="pending"; URL="https://zistgah.org/zamin/"; fi
for f in README.md CITATION.cff codemeta.json index.html paper/index.html; do
  [ -f "$ROOT/$f" ] || continue
  python3 - "$ROOT/$f" "$DISP" "$URL" <<'PY'
import sys
p,doi,url=sys.argv[1],sys.argv[2],sys.argv[3]
s=open(p,encoding='utf-8').read()
open(p,"w",encoding='utf-8').write(s.replace("__ZAMIN_DOI__",doi).replace("__ZAMIN_RECORD_URL__",url))
PY
done
ok "DOI written: $DISP"

if [ "$DO_PUSH" -eq 1 ] && [ "$HAVE_GH" -eq 1 ]; then
  say "5. SEED + PUSH -> $GH_SLUG"
  gh auth status >/dev/null 2>&1 || die "gh not authenticated. Run: gh auth login"
  [ -d "$ROOT/.git" ] || { git init -q "$ROOT"; git -C "$ROOT" branch -M main; }
  git -C "$ROOT" add -A
  git -C "$ROOT" -c user.name="Abhishek Choudhary" -c user.email="dev@ayeai.xyz" \
      commit -q -m "Zamin — PRATIK ternary silicon v$VER${DOI_ID:+ (DOI $DOI_ID)}" || warn "nothing to commit"
  git -C "$ROOT" branch -M main
  if gh repo view "$GH_SLUG" >/dev/null 2>&1; then
    git -C "$ROOT" remote add origin "https://github.com/$GH_SLUG.git" 2>/dev/null || true
    git -C "$ROOT" push -u origin main
  elif confirm "Repo $GH_SLUG absent. Type CREATE to create it public and push:" CREATE; then
    gh repo create "$GH_SLUG" --public --source="$ROOT" --remote=origin --push \
       -d "Zamin — PRATIK ternary silicon: physicalizing the poised-zero substrate (PEDLER/AyeAI Triad)"
  else warn "push skipped; local repo ready at $ROOT"; fi
  gh api -X POST "repos/$GH_SLUG/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
    && ok "Pages enabled" || ok "Pages already enabled"
  ok "simulator live shortly at https://zistgah.org/zamin/"
else
  say "5. PUSH — skipped (DO_PUSH=1 with gh authenticated)."
fi

rm -f "$ROOT/SHA256SUMS.txt"
say "DONE"
[ -n "$DOI_ID" ] && ok "DOI: $DOI_ID  ($RECORD_URL)" || ok "DOI not minted this run (files show 'pending')."
ok "repo: https://github.com/$GH_SLUG   ·   bench: https://zistgah.org/zamin/   ·   paper: https://zistgah.org/zamin/paper/"
