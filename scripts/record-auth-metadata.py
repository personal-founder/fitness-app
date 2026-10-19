# metadata_version: 1
# purpose: Apply format-safe metadata only to authentication-task artifacts.
# owner: unassigned
# related_adrs: [ADR-0005]
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAPPING = {
    'lib/app/theme/': [13], 'lib/core/auth/': [14],
    'lib/core/security/pin_': [18], 'lib/core/security/app_lock.dart': [18, 19],
    'lib/core/security/session_storage.dart': [20, 21],
    'lib/core/security/pkce_storage.dart': [20], 'lib/core/security/vault.dart': [20, 21],
    'lib/core/database/': [22], 'lib/core/widgets/': [13],
    'lib/features/welcome/': [13], 'lib/features/profile/': [15],
    'lib/features/auth/design_preview.dart': [23], 'lib/features/auth/lock_card.dart': [18, 19],
    'lib/features/auth/': [29, 14], 'lib/app/router.dart': [30], 'lib/': [28],
    'test/': [25], 'integration_test/': [25], 'scripts/verify-web.cjs': [25],
    'supabase/migrations/202610190001': [15], 'supabase/migrations/202610190002': [16],
    'supabase/migrations/202610190003': [17], 'supabase/tests/': [15, 17],
    'supabase/': [14], '.github/workflows/flutter.yml': [25], 'config/public.example.json': [14],
    'docs/reference/': [13, 24], 'docs/dependencies.md': [26],
    'docs/security-and-privacy.md': [18, 20, 21], 'docs/platform-support.md': [28],
    'docs/changes/2026-10-19-auth-foundation.md': [24, 25, 27],
    'ARCHITECTURE_AND_DATA.md': [28, 24], 'README': [24],
}
GENERATED = ('android/', 'ios/', 'macos/', 'linux/', 'windows/', 'web/')
SPECIAL = {'.gitignore', '.metadata', 'pubspec.lock', 'macro_app.iml', 'analysis_options.yaml'}
files = subprocess.check_output(['git', 'ls-files', '--others', '--exclude-standard'],
                                cwd=ROOT, text=True).splitlines()
for name in files:
    if name.endswith('.meta.yaml'):
        continue
    ids = next((v for k, v in MAPPING.items() if name.startswith(k)), None)
    generated = name.startswith(GENERATED) or name in SPECIAL
    if ids is None and not generated:
        continue
    target = ROOT / name
    if not target.is_file():
        continue
    ids = ids or [28]
    description = 'Supply Flutter platform runner configuration or assets.'
    if name.startswith('docs/reference/'):
        description = 'Preserve the supplied Macro App design and implementation reference.'
    elif not generated and not name.endswith('.json'):
        first_line = target.read_text(encoding='utf-8-sig').splitlines()[0]
        description = first_line.lstrip('/#- ') or 'Document the Macro App authentication foundation.'
    elif name.endswith('.json'):
        description = 'Supply public Supabase configuration placeholders.'
    metadata = ['metadata_version: 1',
                'purpose: ' + json.dumps(description),
                'owner: unassigned',
                'related_adrs: [' + ', '.join(f'ADR-{i:04}' for i in ids) + ']']
    if generated or name.startswith('docs/reference/') or name.endswith('.json'):
        metadata += ['target: ' + json.dumps(target.name)]
        if generated:
            metadata += ['generated_by: Flutter 3.47.7 tooling; platform edits recorded in the work log.']
        elif name.startswith('docs/reference/'):
            metadata += ['source: User-supplied implementation reference; preserved locally.']
        sidecar = target.with_name(target.name + '.meta.yaml')
        if not sidecar.exists():
            sidecar.write_text('\n'.join(metadata) + '\n', encoding='utf-8')
        continue
    content = target.read_text(encoding='utf-8-sig')
    if 'metadata_version:' in content[:300]:
        continue
    if name.endswith('.md'):
        content = '---\n' + '\n'.join(metadata) + '\n---\n' + content
    else:
        prefix = '-- ' if name.endswith('.sql') else '# ' if name.endswith(('.yml', '.toml')) else '// '
        content = '\n'.join(prefix + line for line in metadata) + '\n' + content
    target.write_text(content, encoding='utf-8')
