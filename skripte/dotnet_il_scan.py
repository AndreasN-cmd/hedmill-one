#!/usr/bin/env python3
# dotnet_il_scan.py - nur lesend. Listet je Methode einer .NET-DLL die geladenen Strings (ldstr) und aufgerufenen
# Methoden/Felder, als JSON. Gebraucht 24.11.2026 fuer das HEDS-Plugin (Jobliste/Autostart, docs/09-werkstueckwechsler.md).
# Aufruf am Mac: python3 -I skripte/dotnet_il_scan.py <dll> <ausgabe.json>
import sys, struct
data = open(sys.argv[1], 'rb').read()
pe = struct.unpack_from('<I', data, 0x3c)[0]
nsec = struct.unpack_from('<H', data, pe+6)[0]
optsz = struct.unpack_from('<H', data, pe+20)[0]
opt = pe+24
magic = struct.unpack_from('<H', data, opt)[0]
dd = opt + (96 if magic == 0x10b else 112)
secs = []
so = opt + optsz
for i in range(nsec):
    o = so + i*40
    vs, va, rs, ra = struct.unpack_from('<IIII', data, o+8)
    secs.append((va, max(vs, rs), ra))
def rva2off(r):
    for va, sz, ra in secs:
        if va <= r < va+sz: return r - va + ra
    raise ValueError(hex(r))
cli_rva = struct.unpack_from('<I', data, dd+14*8)[0]
cli = rva2off(cli_rva)
md_rva, md_sz = struct.unpack_from('<II', data, cli+8)
md = rva2off(md_rva)
vlen = struct.unpack_from('<I', data, md+12)[0]
p = md+16+vlen
nstreams = struct.unpack_from('<H', data, p+2)[0]; p += 4
streams = {}
for i in range(nstreams):
    off, sz = struct.unpack_from('<II', data, p); p += 8
    e = data.index(b'\0', p); name = data[p:e].decode(); p = (e+4) & ~3
    streams[name] = (md+off, sz)
tbl = streams.get('#~') or streams.get('#-')
t = tbl[0]
heapsizes = data[t+6]
valid = struct.unpack_from('<Q', data, t+8)[0]
q = t+24
rows = [0]*64
for i in range(64):
    if valid >> i & 1:
        rows[i] = struct.unpack_from('<I', data, q)[0]; q += 4
SI = 4 if heapsizes & 1 else 2; GI = 4 if heapsizes & 2 else 2; BI = 4 if heapsizes & 4 else 2
def idx(t_): return 4 if rows[t_] > 0xffff else 2
def cidx(tables, bits):
    m = max(rows[x] if x is not None else 0 for x in tables)
    return 2 if m < (1 << (16-bits)) else 4
TypeDefOrRef = cidx([2,1,0x1b],2); HasConstant = cidx([4,8,0x17],2)
HasCustomAttribute = cidx([6,4,1,2,8,9,0xa,0,0xe,0x17,0x14,0x11,0x1a,0x1b,0x20,0x23,0x26,0x27,0x28,0x2a,0x2c,0x2b],5)
HasFieldMarshal = cidx([4,8],1); HasDeclSecurity = cidx([2,6,0x20],2); MemberRefParent = cidx([2,1,0x1a,6,0x1b],3)
HasSemantics = cidx([0x14,0x17],1); MethodDefOrRef = cidx([6,0xa],1); MemberForwarded = cidx([4,6],1)
Implementation = cidx([0x26,0x23,0x27],2); CustomAttributeType = cidx([None,None,6,0xa,None],3)
ResolutionScope = cidx([0,0x1a,0x23,1],2); TypeOrMethodDef = cidx([2,6],1)
S, G, B = SI, GI, BI
schema = {
 0x00:[2,S,G,G,G], 0x01:[ResolutionScope,S,S], 0x02:[4,S,S,TypeDefOrRef,idx(4),idx(6)], 0x03:[idx(4)],
 0x04:[2,S,B], 0x05:[idx(6)], 0x06:[4,2,2,S,B,idx(8)], 0x07:[idx(8)], 0x08:[2,2,S], 0x09:[idx(2),TypeDefOrRef],
 0x0a:[MemberRefParent,S,B], 0x0b:[2,HasConstant,B], 0x0c:[HasCustomAttribute,CustomAttributeType,B],
 0x0d:[HasFieldMarshal,B], 0x0e:[2,HasDeclSecurity,B], 0x0f:[2,4,idx(2)], 0x10:[4,idx(4)], 0x11:[B],
 0x12:[idx(2),idx(0x14)], 0x13:[idx(0x14)], 0x14:[2,S,TypeDefOrRef], 0x15:[idx(2),idx(0x17)], 0x16:[idx(0x17)],
 0x17:[2,S,B], 0x18:[2,idx(6),HasSemantics], 0x19:[idx(2),MethodDefOrRef,MethodDefOrRef], 0x1a:[S], 0x1b:[B],
 0x1c:[2,MemberForwarded,S,idx(0x1a)], 0x1d:[4,idx(4)], 0x1e:[4,4], 0x1f:[4], 0x20:[4,2,2,2,2,4,B,S,S],
 0x21:[4], 0x22:[4,4,4], 0x23:[2,2,2,2,4,B,S,S,B], 0x24:[4,idx(0x23)], 0x25:[4,4,4,idx(0x23)],
 0x26:[4,S,B], 0x27:[4,4,S,S,Implementation], 0x28:[4,4,S,Implementation], 0x29:[idx(2),idx(2)],
 0x2a:[2,2,TypeOrMethodDef,S], 0x2b:[MethodDefOrRef,B], 0x2c:[idx(0x2a),TypeDefOrRef],
}
tables = {}
for i in range(64):
    if not rows[i]: continue
    cols = schema[i]; rs = sum(cols); lst = []
    for r in range(rows[i]):
        vals = []; o = q
        for c in cols:
            vals.append(struct.unpack_from('<H' if c == 2 else '<I', data, o)[0]); o += c
        lst.append(vals); q += rs
    tables[i] = lst
sh = streams['#Strings'][0]
def s(i):
    e = data.index(b'\0', sh+i); return data[sh+i:e].decode('utf-8','replace')
us = streams['#US'][0]
def ustr(i):
    o = us+i; b0 = data[o]
    if b0 & 0x80 == 0: n = b0; o += 1
    elif b0 & 0xc0 == 0x80: n = ((b0 & 0x3f) << 8) | data[o+1]; o += 2
    else: n = ((b0 & 0x1f) << 24) | (data[o+1] << 16) | (data[o+2] << 8) | data[o+3]; o += 4
    return data[o:o+n-1].decode('utf-16le','replace') if n else ''
# Methoden -> Typen
typedefs = tables[2]; methods = tables[6]; fields = tables.get(4, [])
mowner = {}; fowner = {}
for ti, td in enumerate(typedefs):
    name = s(td[2]) if not s(td[2]).startswith('<') else s(td[2])
    ns = s(td[2]); full = (s(td[2]) if not s(td[1]) else s(td[1]) + '.' + s(td[2]))
    full = (s(td[2]) if not s(td[2]) else full)
    fstart = td[4]; mstart = td[5]
    fend = typedefs[ti+1][4] if ti+1 < len(typedefs) else len(fields)+1
    mend = typedefs[ti+1][5] if ti+1 < len(typedefs) else len(methods)+1
    for m in range(mstart, mend): mowner[m] = s(td[2]) + ('' if not s(td[1]) else '')
    for f in range(fstart, fend): fowner[f] = s(td[2])
def tokname(tok):
    tt = tok >> 24; ri = tok & 0xffffff
    try:
        if tt == 0x06: return f"{mowner.get(ri,'?')}::{s(methods[ri-1][3])}"
        if tt == 0x0a:
            mr = tables[0x0a][ri-1]; par = mr[0]; tag = par & 7; pi = par >> 3
            pn = '?'
            if tag == 1: pn = s(tables[1][pi-1][2])
            elif tag == 0: pn = s(typedefs[pi-1][2])
            return f"{pn}::{s(mr[1])}"
        if tt == 0x04: return f"{fowner.get(ri,'?')}.{s(fields[ri-1][1])}"
        if tt == 0x2b: return f"generic#{ri}"
    except Exception as e:
        return f"tok{tok:08x}"
    return f"tok{tok:08x}"
# Opcode-Operandengroessen
one = {}
for op in range(0x100): one[op] = 0
for op in [0x0e,0x0f,0x10,0x11,0x12,0x13,0x1f,0x2b,0x2c,0x2d,0x2e,0x2f,0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0xde]: one[op] = 1
for op in [0x20,0x22,0x38,0x39,0x3a,0x3b,0x3c,0x3d,0x3e,0x3f,0x40,0x41,0x42,0x43,0x44,0xdd,0x27,0x28,0x29,0x6f,0x70,0x71,0x72,0x73,0x74,0x75,0x79,0x7b,0x7c,0x7d,0x7e,0x7f,0x80,0x81,0x8c,0x8d,0x8f,0xa3,0xa4,0xa5,0xc2,0xc6,0xd0,0xd1,0xd2]: one[op] = 4
for op in [0x21,0x23]: one[op] = 8
two = {0x06:4,0x07:4,0x09:2,0x0a:2,0x0b:2,0x0c:2,0x0d:2,0x0e:2,0x12:1,0x15:4,0x16:4,0x19:1,0x1c:4,0x1d:4}
def scan(rva):
    o = rva2off(rva); h = data[o]
    if h & 3 == 2: size = h >> 2; code = o+1
    else:
        flags_size = struct.unpack_from('<H', data, o)[0]; hsz = (flags_size >> 12) * 4
        size = struct.unpack_from('<I', data, o+4)[0]; code = o + hsz
    i = code; end = code+size; ev = []
    while i < end:
        op = data[i]; i += 1
        if op == 0xfe:
            op2 = data[i]; i += 1; i += two.get(op2, 0); continue
        if op == 0x45:
            n = struct.unpack_from('<I', data, i)[0]; i += 4 + 4*n; continue
        sz = one[op]
        if sz == 4 and op in (0x72,):
            ev.append(('S', ustr(struct.unpack_from('<I', data, i)[0] & 0xffffff)))
        elif sz == 4 and op in (0x28,0x6f,0x73):
            ev.append(('C', tokname(struct.unpack_from('<I', data, i)[0])))
        elif sz == 4 and op in (0x7b,0x7d,0x7e,0x80):
            ev.append(('F' if op in (0x7b,0x7e) else 'W', tokname(struct.unpack_from('<I', data, i)[0])))
        i += sz
    return ev
out = []
for mi, m in enumerate(methods, 1):
    if m[0] == 0: continue
    try: ev = scan(m[0])
    except Exception as e: ev = [('E', str(e))]
    out.append((f"{mowner.get(mi,'?')}::{s(m[3])}", ev))
import json
json.dump(out, open(sys.argv[2], 'w', encoding='utf-8'), ensure_ascii=False)
print(len(out), "Methoden")
