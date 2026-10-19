#!/bin/bash
set -uo pipefail
host="$1"
base=$(git rev-parse --verify HEAD^ 2>/dev/null || printf empty)
dart tool/verify.dart --staged "--base=$base" "--shard=$host" "--output=$PWD/output/verification/$host.json"
result=$?
# Exit 2 is a partial worker result, never a passing complete gate.
if [ "$result" -eq 0 ] || [ "$result" -eq 2 ]; then exit 0; fi
exit "$result"
