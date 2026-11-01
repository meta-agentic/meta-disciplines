"""Join hard-wrapped paragraph lines into one line per paragraph, verified by rendering.

Usage: python scripts/unwrap_md.py [--check] FILE...  (CI runs --check over every tracked .md)
Paragraph ranges come from markdown-it's block parser, so code, tables, headings and
lists are untouched; only lines inside one paragraph are joined. Hard breaks (two
trailing spaces or a backslash) are kept. YAML front matter is left as is. Each file is
rewritten only if its rendered HTML, whitespace-collapsed, is identical before and after.
"""
import re, sys
from markdown_it import MarkdownIt

md = MarkdownIt('commonmark').enable('table').enable('strikethrough')

def split_front(text):
    m = re.match(r'\A---\n.*?\n---\n', text, re.S)
    return (text[:m.end()], text[m.end():]) if m else ('', text)

def render(body):
    return re.sub(r'\s+', ' ', md.render(body)).strip()

def unwrap(body):
    lines = body.split('\n')
    tokens = md.parse(body)
    depth = 0
    joins = []  # (start, end, quote_depth)
    for t in tokens:
        if t.type == 'blockquote_open': depth += 1
        elif t.type == 'blockquote_close': depth -= 1
        elif t.type == 'paragraph_open' and t.map and t.map[1] - t.map[0] > 1:
            joins.append((t.map[0], t.map[1], depth))
    for start, end, qd in reversed(joins):
        out = [lines[start]]
        for i in range(start + 1, end):
            prev = out[-1]
            if prev.endswith('  ') or prev.endswith('\\'):
                out.append(lines[i]); continue
            cont = lines[i].lstrip()
            for _ in range(qd):
                cont = re.sub(r'^>\s?', '', cont).lstrip()
            out[-1] = prev.rstrip() + ' ' + cont
        lines[start:end] = out
    return '\n'.join(lines)

check = '--check' in sys.argv
changed = bad = 0
for path in [a for a in sys.argv[1:] if a != '--check']:
    text = open(path, encoding='utf-8').read()
    front, body = split_front(text)
    new_body = unwrap(body)
    if new_body == body: continue
    if render(new_body) != render(body):
        print(f'RENDER DIFFERS, skipped: {path}'); bad += 1; continue
    changed += 1
    if check: print(f'would unwrap: {path}')
    else: open(path, 'w', encoding='utf-8').write(front + new_body)
print(f'{changed} file(s) {"to unwrap" if check else "unwrapped"}, {bad} skipped')
sys.exit(1 if (check and changed) or bad else 0)
