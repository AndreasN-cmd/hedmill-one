#!/usr/bin/env python3
# dotnet_il_dis.py - nur lesend. Disassembliert einzelne Methoden einer .NET-DLL (IL mit Sprungzielen, Strings, Aufrufen).
# Aufruf am Mac: python3 -I skripte/dotnet_il_dis.py <dll> <Methode> [<Methode> ...]   z. B. selectNextJob PlcVarHandler
import sys, runpy
sys.argv = [sys.argv[0], sys.argv[1], '/dev/null', *sys.argv[2:]]
g = runpy.run_path(sys.argv[0].replace('dotnet_il_dis.py', 'dotnet_il_scan.py'), run_name='lib')
data, rva2off, methods, mowner, s, ustr, tokname, struct = g['data'], g['rva2off'], g['methods'], g['mowner'], g['s'], g['ustr'], g['tokname'], g['struct']
N = {0x00:'nop',0x01:'break',0x02:'ldarg.0',0x03:'ldarg.1',0x04:'ldarg.2',0x05:'ldarg.3',0x06:'ldloc.0',0x07:'ldloc.1',0x08:'ldloc.2',0x09:'ldloc.3',0x0a:'stloc.0',0x0b:'stloc.1',0x0c:'stloc.2',0x0d:'stloc.3',0x0e:'ldarg.s',0x0f:'ldarga.s',0x10:'starg.s',0x11:'ldloc.s',0x12:'ldloca.s',0x13:'stloc.s',0x14:'ldnull',0x15:'ldc.i4.m1',0x16:'ldc.i4.0',0x17:'ldc.i4.1',0x18:'ldc.i4.2',0x19:'ldc.i4.3',0x1a:'ldc.i4.4',0x1b:'ldc.i4.5',0x1c:'ldc.i4.6',0x1d:'ldc.i4.7',0x1e:'ldc.i4.8',0x1f:'ldc.i4.s',0x20:'ldc.i4',0x21:'ldc.i8',0x22:'ldc.r4',0x23:'ldc.r8',0x25:'dup',0x26:'pop',0x28:'call',0x2a:'ret',0x2b:'br.s',0x2c:'brfalse.s',0x2d:'brtrue.s',0x2e:'beq.s',0x2f:'bge.s',0x30:'bgt.s',0x31:'ble.s',0x32:'blt.s',0x33:'bne.un.s',0x34:'bge.un.s',0x35:'bgt.un.s',0x36:'ble.un.s',0x37:'blt.un.s',0x38:'br',0x39:'brfalse',0x3a:'brtrue',0x3b:'beq',0x3c:'bge',0x3d:'bgt',0x3e:'ble',0x3f:'blt',0x40:'bne.un',0x45:'switch',0x58:'add',0x59:'sub',0x5a:'mul',0x5f:'and',0x60:'or',0x66:'not',0x6f:'callvirt',0x72:'ldstr',0x73:'newobj',0x74:'castclass',0x75:'isinst',0x79:'unbox',0x7b:'ldfld',0x7c:'ldflda',0x7d:'stfld',0x7e:'ldsfld',0x80:'stsfld',0x8c:'box',0xa5:'unbox.any',0xdd:'leave',0xde:'leave.s',0xdc:'endfinally',0x6a:'conv.i8',0x69:'conv.i4',0x8d:'newarr',0x8e:'ldlen',0xa2:'stelem.ref',0x9a:'ldelem.ref'}
N2 = {0x01:'ceq',0x02:'cgt',0x03:'cgt.un',0x04:'clt',0x05:'clt.un',0x06:'ldftn',0x15:'initobj',0x16:'constrained.',0x1a:'rethrow',0x1c:'sizeof',0x09:'ldarg',0x0c:'ldloc',0x0e:'stloc'}
one, two = g['one'], g['two']
def dis(rva):
    o = rva2off(rva); h = data[o]
    if h & 3 == 2: size = h >> 2; code = o+1
    else:
        fs = struct.unpack_from('<H', data, o)[0]; size = struct.unpack_from('<I', data, o+4)[0]; code = o + (fs >> 12)*4
    i = code; end = code + size
    while i < end:
        pc = i - code; op = data[i]; i += 1
        if op == 0xfe:
            op2 = data[i]; i += 1; sz = two.get(op2, 0); arg = data[i:i+sz]; i += sz
            print(f"  {pc:04x}: {N2.get(op2, hex(0xfe00|op2))} {arg.hex() if arg else ''}"); continue
        if op == 0x45:
            n = struct.unpack_from('<I', data, i)[0]; i += 4; tg = [struct.unpack_from('<i', data, i+4*k)[0] for k in range(n)]; i += 4*n
            print(f"  {pc:04x}: switch {[hex(i-code+t) for t in tg]}"); continue
        sz = one[op]; raw = data[i:i+sz]; i += sz
        name = N.get(op, hex(op)); a = ''
        if op in (0x2b,0x2c,0x2d,0x2e,0x2f,0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0xde):
            a = '-> %04x' % (i - code + struct.unpack('<b', raw)[0])
        elif op in (0x38,0x39,0x3a,0x3b,0x3c,0x3d,0x3e,0x3f,0x40,0xdd):
            a = '-> %04x' % (i - code + struct.unpack('<i', raw)[0])
        elif op == 0x72: a = repr(ustr(struct.unpack('<I', raw)[0] & 0xffffff))
        elif op in (0x28,0x6f,0x73,0x7b,0x7c,0x7d,0x7e,0x80,0x74,0x75,0x8c,0xa5): a = tokname(struct.unpack('<I', raw)[0])
        elif sz: a = str(struct.unpack('<b' if sz == 1 else ('<i' if sz == 4 else '<q'), raw)[0]) if sz in (1,4,8) else raw.hex()
        print(f"  {pc:04x}: {name} {a}")
for want in sys.argv[3:]:
    for mi, m in enumerate(methods, 1):
        full = f"{mowner.get(mi,'?')}::{s(m[3])}"
        if full.endswith('::' + want) and m[0]:
            print('=====', full); dis(m[0])
