#!/usr/bin/env python3
"""Build a finite, hash-pinned English source overlay without Git or ROM inputs."""
from pathlib import Path, PurePosixPath
import argparse, hashlib, json, os, shutil, subprocess, sys
ROOT = Path(__file__).resolve().parent.parent

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def relative(value):
    if not isinstance(value, str) or '\0' in value or '\\' in value:
        raise ValueError('invalid manifest path')
    p = PurePosixPath(value)
    if p.is_absolute() or not p.parts or any(x in ('.', '..') for x in value.split('/')):
        raise ValueError('non-normalized manifest path: ' + value)
    if str(p) != value:
        raise ValueError('non-normalized manifest path: ' + value)
    return p

def safe(base, name):
    p = base.joinpath(*relative(name).parts)
    for q in (p, *p.parents):
        if q == base.parent:
            break
        if q.is_symlink():
            raise ValueError('symlink input: ' + str(q))
    if not p.resolve().is_relative_to(base.resolve()):
        raise ValueError('path outside input root')
    return p

def verified(path, record):
    if not path.is_file() or path.stat().st_size != record['size'] or digest(path) != record['sha256']:
        raise ValueError('source pin differs: ' + str(path))
    return {'size': record['size'], 'sha256': record['sha256']}

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--debug', choices=('0', '1'), default='0')
    ap.add_argument('--rgbds', default='')
    ap.add_argument('--rgbasm')
    ap.add_argument('--rgblink')
    ap.add_argument('--rgbgfx')
    ap.add_argument('--python')
    ap.add_argument('--rgbasmflags')
    ap.add_argument('--rgblinkflags', default='-p 0x00 -l layout.link')
    ap.add_argument('--check', action='store_true')
    args = ap.parse_args()
    if args.rgbasmflags is None:
        args.rgbasmflags = '-Weverything -P includes.asm -I .' + (' -E' if args.debug == '1' else '')
    mp = safe(ROOT, 'languages/en/manifest.json')
    manifest_bytes = mp.read_bytes()
    m = json.loads(manifest_bytes)
    if (m['version'] != 1 or m['language'] != 'en'
            or type(m.get('overrides_count')) is not int or m['overrides_count'] < 0
            or len(m['overrides']) != m['overrides_count']):
        raise ValueError('unsupported locale manifest')
    expected_methods = {'Makefile', 'tools/build_english.py', 'docs/LANGUAGE_BUILDS.md', 'tools/sprite_chain_check.py', 'tools/invariants_check.py', 'tools/data_consumers.py', 'tools/apply_renames.py', 'tools/localize_labels.py', 'tools/audio_to_macros.py', 'tools/retype_palettes.py', 'tools/crystal_match.py'}
    generated_2bpp = m.get('generated_2bpp')
    if not isinstance(generated_2bpp, dict):
        raise ValueError('missing generated .2bpp inventory')
    for name, record in generated_2bpp.items():
        relative(name)
        if not name.endswith('.2bpp') or type(record.get('size')) is not int or record['size'] <= 0:
            raise ValueError('invalid generated .2bpp record: ' + name)
        png_name = name[:-5] + '.png'
        if png_name not in m['fallback_files'] and png_name not in m['overrides']:
            raise ValueError('generated .2bpp has no selected PNG source: ' + name)
    if (set(m['method_files']) != expected_methods or type(m.get('fallback_count')) is not int
            or m['fallback_count'] < 0 or len(m['fallback_files']) != m['fallback_count']
            or set(m['fallback_files']) & expected_methods):
        raise ValueError('unknown method path or fallback inventory')
    inputs = {}
    png_rule_outputs = {}
    rules_path = safe(ROOT, 'gfx/png_rules.tsv')
    for line in rules_path.read_text(encoding='utf-8').splitlines():
        if line and not line.startswith('#') and not line.startswith('out\t'):
            fields = line.split('\t')
            if fields[0].endswith('.2bpp'):
                png_rule_outputs[fields[0]] = int(fields[6])
    if not set(generated_2bpp) <= set(png_rule_outputs):
        raise ValueError('generated .2bpp is not in the PNG rules')
    view_inputs = {}
    for name, record in m['fallback_files'].items():
        relative(name)
        if name.split('/')[0] in ('languages', 'build', '.git', '.cache') or name.endswith(('.gbc', '.zip', '.pyc')):
            raise ValueError('forbidden fallback input: ' + name)
        p = safe(ROOT, name)
        inputs[name] = verified(p, record)
        view_inputs[name] = p
    for name, record in m['method_files'].items():
        inputs[name] = verified(safe(ROOT, name), record)
        view_inputs[name] = safe(ROOT, name)
    for name, record in m['overrides'].items():
        relative(name)
        if name.split('/')[0] not in ('home', 'engine', 'data', 'gfx', 'audio', 'lib'):
            raise ValueError('unsupported locale payload: ' + name)
        if record['base_sha256'] is None:
            if name in m['fallback_files'] or safe(ROOT, name).exists():
                raise ValueError('new payload collides: ' + name)
        elif name not in m['fallback_files'] or inputs[name]['sha256'] != record['base_sha256']:
            raise ValueError('locale base pin differs: ' + name)
        if record['payload_path'] != 'languages/en/' + name:
            raise ValueError('payload path does not match owner')
        p = safe(ROOT, record['payload_path'])
        inputs[record['payload_path']] = verified(p, {'size': record['bytes'], 'sha256': record['payload_sha256']})
        view_inputs[name] = p
    tool_paths = {'make': shutil.which('make'), 'python': shutil.which(args.python) if args.python else sys.executable}
    for name in ('rgbasm', 'rgblink', 'rgbgfx'):
        tool_paths[name] = shutil.which(getattr(args, name) or args.rgbds + name)
    if any(v is None for v in tool_paths.values()):
        raise ValueError('missing required build executable')
    tools = {k: {'path': str(Path(v).resolve()), 'sha256': digest(Path(v).resolve())} for k, v in tool_paths.items()}
    key_data = {'manifest_sha256': hashlib.sha256(manifest_bytes).hexdigest(), 'inputs': inputs,
                'tools': tools, 'environment': {k: os.environ.get(k) for k in ('PATH', 'LANG', 'LC_ALL', 'TZ', 'PYTHONHASHSEED', 'PYTHONPATH')}, 'DEBUG': args.debug, 'RGBDS': args.rgbds, 'locale': 'en', 'RGBASMFLAGS': args.rgbasmflags, 'RGBLINKFLAGS': args.rgblinkflags}
    key = hashlib.sha256(json.dumps(key_data, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    out = safe(ROOT, 'build/en')
    out.mkdir(parents=True, exist_ok=True)
    lock = safe(out, '.lock')
    lock.mkdir()  # exclusive: concurrent locale builds fail before changing a view
    try:
        view, kp = safe(out, 'source'), safe(out, 'cache-key.json')
        def output_inventory():
            names = [str(p.relative_to(view)) for p in (view / 'build').rglob('*') if p.is_file()]
            if (view / 'mobile_trainer.gbc').is_file():
                names.append('mobile_trainer.gbc')
            names.extend(name for name in png_rule_outputs if safe(view, name).is_file())
            return {name: {'size': safe(view, name).stat().st_size, 'sha256': digest(safe(view, name))} for name in sorted(names)}
        reuse = view.is_dir() and kp.is_file() and json.loads(kp.read_text()).get('key') == key
        if reuse:
            recorded_outputs = json.loads(kp.read_text()).get('outputs')
            reuse = bool(recorded_outputs) and output_inventory() == recorded_outputs
        if reuse:
            actual_sources = {str(p.relative_to(view)) for p in view.rglob('*') if p.is_file() and p.relative_to(view).parts[0] != 'build' and p.name != 'mobile_trainer.gbc' and p.suffix != '.pyc' and '__pycache__' not in p.relative_to(view).parts}
            actual_sources -= set(png_rule_outputs)
            reuse = actual_sources == set(view_inputs) and all(safe(view, name).is_file() and digest(safe(view, name)) == digest(p) for name, p in view_inputs.items())
        if not reuse:
            if view.exists():
                shutil.rmtree(view)
            view.mkdir()
            for name, p in sorted(view_inputs.items()):
                target = safe(view, name)
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(p, target)  # BIN/PNG relative timestamps retained
                target.chmod(0o644)
            kp.write_text(json.dumps({'key': key, 'data': key_data}, indent=2) + '\n')
        argv = [tools['make']['path'], 'mobile_trainer.gbc', 'DEBUG=' + args.debug,
                'RGBASM=' + tools['rgbasm']['path'], 'RGBLINK=' + tools['rgblink']['path'],
                'RGBGFX=' + tools['rgbgfx']['path'], 'PYTHON=' + tools['python']['path'],
                'RGBASMFLAGS=' + args.rgbasmflags, 'RGBLINKFLAGS=' + args.rgblinkflags]
        build_options = argv[2:]
        subprocess.run(argv, cwd=view, check=True)
        view_pins = {name: inputs[m['overrides'][name]['payload_path']] if name in m['overrides'] else inputs[name] for name in view_inputs}
        for name, record in view_pins.items():
            verified(safe(view, name), record)
        rom = view / 'mobile_trainer.gbc'
        if digest(rom) != m['expected_ROM']:
            raise ValueError('English ROM differs from pinned verified locale')
        if args.check:
            for argv in ([tools['make']['path'], 'sym-check'], [tools['make']['path'], 'palette-check'],
                         [tools['make']['path'], 'png-check'], [tools['python']['path'], 'tools/gfx_export.py', 'check'],
                         [tools['python']['path'], 'tools/sprite_chain_check.py', '--rom', 'mobile_trainer.gbc', '--sym', 'build/mobile_trainer.sym']):
                if argv[0] == tools['make']['path']:
                    argv = argv + build_options
                subprocess.run(argv, cwd=view, check=True)
        for name, record in inputs.items():
            verified(safe(ROOT, name), record)
        for name, record in view_pins.items():
            verified(safe(view, name), record)
        built_outputs = output_inventory()
        for name, record in generated_2bpp.items():
            if name not in built_outputs or built_outputs[name]['size'] != record['size']:
                raise ValueError('generated .2bpp output missing or wrong size: ' + name)
        if not all(name in built_outputs for name in ('mobile_trainer.gbc', 'build/mobile_trainer.sym', 'build/mobile_trainer.map')):
            raise ValueError('missing locale metadata outputs')
        kp.write_text(json.dumps({'key': key, 'data': key_data, 'outputs': built_outputs, 'checks_completed': args.check}, indent=2) + '\n')
        for name in ('mobile_trainer.gbc', 'build/mobile_trainer.sym', 'build/mobile_trainer.map'):
            shutil.copy2(safe(view, name), safe(out, Path(name).name))
        print('English locale SHA-256 OK: ' + digest(rom))
        print('English outputs: ' + str(out))
    finally:
        lock.rmdir()

if __name__ == '__main__':
    main()
