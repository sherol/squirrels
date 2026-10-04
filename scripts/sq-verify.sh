#!/usr/bin/env bash
# sq-verify: integrity check for squirrel charters. Exits nonzero on problems.
# Usage: scripts/sq-verify.sh [dir]   (default: .squirrels)
set -u

dir="${1:-.squirrels}"
statuses="dispatched foraging blocked reporting done stood-down"
accesses="read-only stash-write scoped-write"
fail=0

err() { echo "FAIL: $1" >&2; fail=1; }

shopt -s nullglob
files=("$dir"/SQ-[0-9][0-9][0-9][0-9].md)

if [ ${#files[@]} -eq 0 ]; then
  echo "no squirrels in $dir (ok)"
  exit 0
fi

for f in "${files[@]}"; do
  base=$(basename "$f" .md)
  fm=$(awk 'NR==1 && $0!="---" {exit} NR==1 {next} $0=="---" {exit} {print}' "$f")
  if [ -z "$fm" ]; then
    err "$f: missing frontmatter"
    continue
  fi

  get() { printf '%s\n' "$fm" | sed -n "s/^$1:[[:space:]]*//p" | head -n1; }

  id=$(get id)
  status=$(get status)
  access=$(get access)

  [ "$id" = "$base" ] || err "$f: id '$id' does not match filename '$base'"
  case " $statuses " in *" $status "*) ;; *) err "$f: invalid status '$status'" ;; esac
  case " $accesses " in *" $access "*) ;; *) err "$f: invalid access '$access'" ;; esac

  for k in mandate scope budget stop_conditions; do
    [ -n "$(get "$k")" ] || err "$f: missing or empty '$k'"
  done

  grep -q '^## Charter' "$f" || err "$f: missing '## Charter' section"
  grep -q '^## Report'  "$f" || err "$f: missing '## Report' section"
done

if [ "$fail" -eq 0 ]; then
  echo "squirrels verified: ${#files[@]} charter(s) ok"
fi
exit "$fail"
