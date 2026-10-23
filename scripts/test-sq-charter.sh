#!/usr/bin/env bash
# Regression tests for scripts/sq-charter.sh. Exits nonzero if any case fails.
# Usage: bash scripts/test-sq-charter.sh
set -u

here=$(cd "$(dirname "$0")" && pwd)
root=$(dirname "$here")
validator="$here/sq-charter.sh"
templates="$root/squirrels/templates"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

pass=0
failed=0
n=0

# charter <dir> <id> [extra frontmatter lines...]
# Writes a minimal valid charter; extra lines are appended to its frontmatter.
# Lines that redefine a default field (status, scope, parent, ...) replace it.
charter() {
  d=$1 id=$2
  shift 2
  mkdir -p "$d"
  {
    echo '---'
    echo "id: $id"
    for k in status access mandate scope budget stop_conditions parent; do
      over=0
      for line in "$@"; do
        case "$line" in "$k:"*) over=1 ;; esac
      done
      [ "$over" -eq 1 ] && continue
      case $k in
        status) echo 'status: dispatched' ;;
        access) echo 'access: read-only' ;;
        mandate) echo 'mandate: Test squirrel.' ;;
        scope) echo 'scope: src/' ;;
        budget) echo 'budget: 10m' ;;
        stop_conditions) echo 'stop_conditions: scope ambiguity' ;;
        parent) echo 'parent: elephant-session' ;;
      esac
    done
    for line in "$@"; do printf '%s\n' "$line"; done
    echo '---'
    echo
    echo '## Charter'
    echo
    echo '## Report'
  } > "$d/$id.md"
}

# expect <pass|fail> <name> <dir> [message regex expected on stderr]
expect() {
  want=$1 name=$2 d=$3 pattern=${4:-}
  n=$((n + 1))
  out=$(bash "$validator" "$d" 2>&1)
  code=$?
  ok=1
  if [ "$want" = pass ] && [ "$code" -ne 0 ]; then ok=0; fi
  if [ "$want" = fail ] && [ "$code" -eq 0 ]; then ok=0; fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$out" | grep -Eq -- "$pattern"; then ok=0; fi
  if [ "$ok" -eq 1 ]; then
    pass=$((pass + 1))
    echo "ok   $n $name"
  else
    failed=$((failed + 1))
    echo "FAIL $n $name (want $want, exit $code)"
    printf '%s\n' "$out" | sed 's/^/     /'
  fi
}

t() { printf '%s/%s' "$work" "$1"; }

# --- Existing behaviour ---------------------------------------------------

mkdir -p "$(t empty)"
expect pass "empty directory" "$(t empty)" "no squirrels"

charter "$(t basic)" SQ-0001
expect pass "minimal valid charter" "$(t basic)" "1 charter\(s\) ok"

charter "$(t idmismatch)" SQ-0001 && sed 's/^id: SQ-0001/id: SQ-0002/' "$(t idmismatch)/SQ-0001.md" > "$work/x" && mv "$work/x" "$(t idmismatch)/SQ-0001.md"
expect fail "id does not match filename" "$(t idmismatch)" "does not match filename"

charter "$(t badstatus)" SQ-0001 'status: sleeping'
expect fail "invalid status" "$(t badstatus)" "invalid status 'sleeping'"

charter "$(t badaccess)" SQ-0001 'access: root'
expect fail "invalid access" "$(t badaccess)" "invalid access 'root'"

charter "$(t badtype)" SQ-0001 'type: nap'
expect fail "invalid type" "$(t badtype)" "invalid type 'nap'"

charter "$(t emptyscope)" SQ-0001 'scope:'
expect fail "empty scope" "$(t emptyscope)" "missing or empty 'scope'"

mkdir -p "$(t nofm)" && printf '# no frontmatter\n## Charter\n## Report\n' > "$(t nofm)/SQ-0001.md"
expect fail "missing frontmatter" "$(t nofm)" "missing frontmatter"

charter "$(t noreport)" SQ-0001 && sed '/^## Report/d' "$(t noreport)/SQ-0001.md" > "$work/x" && mv "$work/x" "$(t noreport)/SQ-0001.md"
expect fail "missing Report section" "$(t noreport)" "missing '## Report'"

charter "$(t coord)" SQ-0001 'type: coordinate' 'access: stash-write' 'children: SQ-0002, SQ-0003'
charter "$(t coord)" SQ-0002 'parent: SQ-0001'
charter "$(t coord)" SQ-0003 'parent: SQ-0001' 'depends_on: SQ-0002'
expect pass "coordinator with dependent siblings" "$(t coord)" "3 charter\(s\) ok"

charter "$(t nochildren)" SQ-0001 'type: coordinate'
expect fail "coordinator without children" "$(t nochildren)" "has no 'children'"

charter "$(t orphan)" SQ-0001 'type: coordinate' 'children: SQ-0002'
charter "$(t orphan)" SQ-0002
expect fail "child does not name coordinator as parent" "$(t orphan)" "child 'SQ-0002' has parent"

charter "$(t unlisted)" SQ-0001 'type: coordinate' 'children: SQ-0002'
charter "$(t unlisted)" SQ-0002 'parent: SQ-0001'
charter "$(t unlisted)" SQ-0003 'parent: SQ-0001'
expect fail "parent does not list child" "$(t unlisted)" "does not list 'SQ-0003'"

charter "$(t nest)" SQ-0001 'type: coordinate' 'children: SQ-0002'
charter "$(t nest)" SQ-0002 'type: coordinate' 'parent: SQ-0001' 'children: SQ-0003'
charter "$(t nest)" SQ-0003 'parent: SQ-0002'
expect fail "coordinators do not nest" "$(t nest)" "do not nest"

charter "$(t notcoord)" SQ-0001 'children: SQ-0002'
charter "$(t notcoord)" SQ-0002 'parent: SQ-0001'
expect fail "children on a non-coordinator" "$(t notcoord)" "only coordinate squirrels"

charter "$(t depself)" SQ-0001 'type: coordinate' 'children: SQ-0002'
charter "$(t depself)" SQ-0002 'parent: SQ-0001' 'depends_on: SQ-0002'
expect fail "depends on itself" "$(t depself)" "depends on itself"

charter "$(t depmissing)" SQ-0001 'type: coordinate' 'children: SQ-0002'
charter "$(t depmissing)" SQ-0002 'parent: SQ-0001' 'depends_on: SQ-0009'
expect fail "depends_on target missing" "$(t depmissing)" "'SQ-0009' not found"

charter "$(t depcross)" SQ-0001 'type: coordinate' 'children: SQ-0002'
charter "$(t depcross)" SQ-0002 'parent: SQ-0001' 'depends_on: SQ-0004'
charter "$(t depcross)" SQ-0003 'type: coordinate' 'children: SQ-0004'
charter "$(t depcross)" SQ-0004 'parent: SQ-0003'
expect fail "depends_on across coordinators" "$(t depcross)" "not a sibling"

# --- (a) YAML block lists -------------------------------------------------

charter "$(t block)" SQ-0001 'scope:' '  - src/' '  - tests/' 'stop_conditions:' '  - needs credentials' '  - scope ambiguity'
expect pass "block-list scope and stop_conditions" "$(t block)"

charter "$(t blockflush)" SQ-0001 'scope:' '- src/' '# comment' '' '- tests/'
expect pass "block list without indent, with comment and blank line" "$(t blockflush)"

charter "$(t blockempty)" SQ-0001 'scope:' 'budget: 5m'
expect fail "block-list key with no items" "$(t blockempty)" "missing or empty 'scope'"

charter "$(t blockdash)" SQ-0001 'stop_conditions:' '  -' '  - '
expect fail "block list of empty items" "$(t blockdash)" "missing or empty 'stop_conditions'"

charter "$(t blockcoord)" SQ-0001 'type: coordinate' 'children:' '  - SQ-0002' '  - SQ-0003'
charter "$(t blockcoord)" SQ-0002 'parent: SQ-0001'
charter "$(t blockcoord)" SQ-0003 'parent: SQ-0001' 'depends_on:' '  - SQ-0002'
expect pass "block-list children and depends_on" "$(t blockcoord)" "3 charter\(s\) ok"

charter "$(t blockbad)" SQ-0001 'type: coordinate' 'children:' '  - SQ-0002' '  - SQ-0005'
charter "$(t blockbad)" SQ-0002 'parent: SQ-0001'
expect fail "block-list children with a missing child" "$(t blockbad)" "child 'SQ-0005' not found"

# --- (b) CRLF line endings ------------------------------------------------

crlf() { sed 's/$/\r/' "$1" > "$work/x" && mv "$work/x" "$1"; }

charter "$(t crlf)" SQ-0001 'type: coordinate' 'children: SQ-0002, SQ-0003'
charter "$(t crlf)" SQ-0002 'parent: SQ-0001' 'scope:' '  - src/'
charter "$(t crlf)" SQ-0003 'parent: SQ-0001' 'depends_on: SQ-0002'
for f in "$(t crlf)"/*.md; do crlf "$f"; done
expect pass "CRLF charters with coordination and block list" "$(t crlf)" "3 charter\(s\) ok"

charter "$(t crlfbad)" SQ-0001 'status: sleeping'
crlf "$(t crlfbad)/SQ-0001.md"
expect fail "CRLF charter with invalid status" "$(t crlfbad)" "invalid status 'sleeping'$"

# --- (c) depends_on only between siblings under a coordinator -------------

charter "$(t deptop)" SQ-0001
charter "$(t deptop)" SQ-0002 'depends_on: SQ-0001'
expect fail "depends_on between top-level squirrels" "$(t deptop)" "only allowed between children of a coordinator"

charter "$(t depnoparent)" SQ-0001 'parent:'
charter "$(t depnoparent)" SQ-0002 'parent:' 'depends_on: SQ-0001'
expect fail "depends_on with no parent" "$(t depnoparent)" "parent is 'unset'"

# --- Shipped templates ----------------------------------------------------

tpl=$(t templates)
mkdir -p "$tpl"
i=0
for f in "$templates"/charter.md "$templates"/charter-*.md; do
  case "$f" in */charter-coordinate.md) continue ;; esac
  i=$((i + 1))
  id=$(printf 'SQ-%04d' "$i")
  sed "s/^id: SQ-\[NNNN\]/id: $id/" "$f" > "$tpl/$id.md"
done
c=$((i + 1))
cid=$(printf 'SQ-%04d' "$c")
kids=""
for k in 1 2 3; do
  kid=$(printf 'SQ-%04d' $((c + k)))
  kids="$kids${kids:+, }$kid"
  sed -e "s/^id: SQ-\[NNNN\]/id: $kid/" -e "s/^parent: elephant-session/parent: $cid/" "$templates/charter.md" > "$tpl/$kid.md"
done
sed -e "s/^id: SQ-\[NNNN\]/id: $cid/" -e "s/^children: .*/children: $kids/" "$templates/charter-coordinate.md" > "$tpl/$cid.md"
expect pass "all shipped templates" "$tpl" "charter\(s\) ok"

echo
echo "$pass/$n passed"
[ "$failed" -eq 0 ]
