#!/usr/bin/env bash
# sq-charter: integrity check for squirrel charters. Exits nonzero on problems.
# Usage: scripts/sq-charter.sh [dir]   (default: .squirrels)
set -u

dir="${1:-.squirrels}"
statuses="dispatched foraging blocked reporting done stood-down"
accesses="read-only stash-write scoped-write"
types="afk review mock verify scribe report next done pr clarify coordinate"
fail=0

err() { echo "FAIL: $1" >&2; fail=1; }

shopt -s nullglob
files=("$dir"/SQ-[0-9][0-9][0-9][0-9].md)

if [ ${#files[@]} -eq 0 ]; then
  echo "no squirrels in $dir (ok)"
  exit 0
fi

# Frontmatter lines between the opening and closing '---', with CR stripped
# so files with CRLF line endings parse the same as LF files.
frontmatter() {
  awk '{ sub(/\r$/, "") }
       NR==1 && $0!="---" {exit}
       NR==1 {next}
       $0=="---" {exit}
       {print}' "$1"
}
# Value of field $2. Accepts an inline value (`key: a, b`) or a YAML block
# list (`key:` followed by `- a` lines), which is joined as "a, b".
field() {
  printf '%s\n' "$1" | awk -v k="$2" '
    found && /^[[:space:]]*(#.*)?$/ { next }
    found && /^[[:space:]]*-([[:space:]]|$)/ {
      v = $0; sub(/^[[:space:]]*-[[:space:]]*/, "", v); sub(/[[:space:]]+$/, "", v)
      if (v != "") out = (out == "" ? v : out ", " v)
      next
    }
    found { exit }
    index($0, k ":") == 1 {
      v = substr($0, length(k) + 2); sub(/^[[:space:]]+/, "", v); sub(/[[:space:]]+$/, "", v)
      if (v != "") { print v; printed = 1; exit }
      found = 1
    }
    END { if (!printed && out != "") print out }'
}
# Split a comma/space separated list of ids, tolerating [brackets].
ids() { printf '%s\n' "$1" | tr -d '[]' | tr ',' ' ' | tr -s ' ' '\n' | sed '/^$/d'; }

for f in "${files[@]}"; do
  base=$(basename "$f" .md)
  fm=$(frontmatter "$f")
  if [ -z "$fm" ]; then
    err "$f: missing frontmatter"
    continue
  fi

  id=$(field "$fm" id)
  status=$(field "$fm" status)
  access=$(field "$fm" access)
  type=$(field "$fm" type)
  parent=$(field "$fm" parent)
  children=$(field "$fm" children)
  depends=$(field "$fm" depends_on)

  [ "$id" = "$base" ] || err "$f: id '$id' does not match filename '$base'"
  case " $statuses " in *" $status "*) ;; *) err "$f: invalid status '$status'" ;; esac
  case " $accesses " in *" $access "*) ;; *) err "$f: invalid access '$access'" ;; esac
  if [ -n "$type" ]; then
    case " $types " in *" $type "*) ;; *) err "$f: invalid type '$type'" ;; esac
  fi

  for k in mandate scope budget stop_conditions; do
    [ -n "$(field "$fm" "$k")" ] || err "$f: missing or empty '$k'"
  done

  grep -q '^## Charter' "$f" || err "$f: missing '## Charter' section"
  grep -q '^## Report'  "$f" || err "$f: missing '## Report' section"

  # Coordination links.
  if [ "$type" = "coordinate" ]; then
    [ -n "$children" ] || err "$f: coordinate squirrel has no 'children'"
    [ -n "$parent" ] && case "$parent" in SQ-*) err "$f: coordinators do not nest (parent '$parent')" ;; esac
    for c in $(ids "$children"); do
      cf="$dir/$c.md"
      if [ ! -f "$cf" ]; then err "$f: child '$c' not found"; continue; fi
      cp=$(field "$(frontmatter "$cf")" parent)
      [ "$cp" = "$base" ] || err "$f: child '$c' has parent '$cp', expected '$base'"
    done
  elif [ -n "$children" ]; then
    err "$f: only coordinate squirrels may list 'children'"
  fi

  case "$parent" in
    SQ-*)
      pf="$dir/$parent.md"
      if [ ! -f "$pf" ]; then
        err "$f: parent '$parent' not found"
      else
        pfm=$(frontmatter "$pf")
        [ "$(field "$pfm" type)" = "coordinate" ] || err "$f: parent '$parent' is not a coordinate squirrel"
        ids "$(field "$pfm" children)" | grep -qx "$base" || err "$f: parent '$parent' does not list '$base' in children"
      fi
      ;;
  esac

  # depends_on orders siblings under one coordinator (SPEC: Coordination).
  if [ -n "$depends" ]; then
    case "$parent" in
      SQ-*) ;;
      *) err "$f: depends_on is only allowed between children of a coordinator (parent is '${parent:-unset}')" ;;
    esac
  fi
  for d in $(ids "$depends"); do
    [ "$d" = "$base" ] && { err "$f: depends on itself"; continue; }
    if [ ! -f "$dir/$d.md" ]; then err "$f: depends_on '$d' not found"; continue; fi
    dp=$(field "$(frontmatter "$dir/$d.md")" parent)
    [ "$dp" = "$parent" ] || err "$f: depends_on '$d' is not a sibling under the same coordinator"
  done
done

if [ "$fail" -eq 0 ]; then
  echo "squirrels verified: ${#files[@]} charter(s) ok"
fi
exit "$fail"
