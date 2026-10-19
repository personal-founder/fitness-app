#!/bin/bash
set -euo pipefail
read -r version revision repository < <(python -c 'import json; c=json.load(open("config/engineering-policy.json")); p=json.load(open(c["registries"]["toolchain"])); print(p["flutter"], p["flutter_revision"], p["repository"])')
sdk_dir="$RUNNER_TEMP/flutter"
git clone --depth 1 --branch "$version" "$repository" "$sdk_dir"
test "$(git -C "$sdk_dir" rev-parse HEAD)" = "$revision"
echo "$sdk_dir/bin" >> "$GITHUB_PATH"
"$sdk_dir/bin/flutter" --disable-analytics
