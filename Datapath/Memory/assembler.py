import pyparsing as pp
import json

register = '$' + (pp.oneOf('zero at gp sp fp ra') | pp.Regex(r'v[0-1]') | pp.Regex(r'a[0-3]') | pp.Regex(r't[0-9]') | pp.Regex(r's[0-7]') | pp.Regex(r'k[0-1]'))

def register_id(reg):
    x = ord(reg[1]) - ord('0')
    if reg == 'zero':
        return 0
    elif reg == 'at':
        return 1
    elif reg == 'gp':
        return 28
    elif reg == 'sp':
        return 29
    elif reg == 'fp':
        return 30
    elif reg == 'ra':
        return 31
    elif reg[0] == 'v':
        return 2 + x
    elif reg[0] == 'a':
        return 4 + x
    elif reg[0] == 's':
        return 16 + x
    elif reg[0] == 'k':
        return 26 + x
    elif reg[1] >= '8':
        return 16 + x
    else:
        return 8 + x

register.setParseAction(lambda tk: register_id(tk[1]))

with open('funct.json') as file:
    global funct_dict
    funct_dict = json.load(file)

with open('opcode.json') as file:
    global opcode_dict
    opcode_dict = json.load(file)

# def funct(r_format):
#     match r_format:
#         case 'add':
#             return int('0x20', 0)
#         case 'and':
#             return int('0x24', 0)
#         case 'div':
#             return int('0x1a', 0)
#         case 'mult':
#             return int('0x18', 0)
#         case 'jr':
#             return int('0x8', 0)
#         case 'mfhi':
#             return int('0x10', 0)
#         case 'mflo':
#             return int('0x12', 0)
#         case 'sll':
#             return int('0x0', 0)
#         case 'sllv':
#             return int('0x4', 0)
#         case 'slt':
#             return int('0x2a', 0)
#         case 'sra':
#             return int('0x3', 0)
#         case 'srav':
#             return int('0x7', 0)
#         case 'srl':
#             return int('0x2', 0)
#         case 'sub':
#             return int('0x22', 0)
#         case 'break':
#             return int('0xd', 0)
#         case 'rte':
#             return int('0x13', 0)
#         case 'addm':
#             return int('0x5', 0)

#register.setParseAction(pp.tokenMap(parseRegister))
#print(register.matches('$t0'))
#print(pp.pyparsing_common.integer.parseString('1000000000000000000000000007000000000000'))
#pp.pyparsing_common.signed_integer
def r_format(rs, rt, rd, shamt, funct):
    if shamt >= 32:
        raise Exception('shamt out of bounds')
    return (rs << 21) ^ (rt << 16) ^ (rd << 11) ^ (shamt << 6) ^ funct

instruction_name_r_rd_rs_rt = pp.oneOf('add and sllv slt srav sub addm')
# = pp.Literal('add') | pp.Literal('and') | pp.Literal('sllv') | pp.Literal('slt') | pp.Literal('srav') | pp.Literal('sub') | pp.Literal('addm')
instruction_r_rd_rs_rt = instruction_name_r_rd_rs_rt + register + pp.Char(',') + register + pp.Char(',') + register
instruction_r_rd_rs_rt.setParseAction(lambda tk: r_format(tk[3], tk[5], tk[1], 0, int(funct_dict[tk[0]], 0) ))

instruction_name_r_rs_rt = pp.oneOf('div mult')
# pp.Literal('div') | pp.Literal('mult')
instruction_r_rs_rt = instruction_name_r_rs_rt + register + pp.Char(',') + register
instruction_r_rs_rt.setParseAction(lambda tk: r_format(tk[1], tk[3], 0, 0, int(funct_dict[tk[0]], 0) ))

instruction_name_r_rs = pp.Literal('jr')
instruction_r_rs = instruction_name_r_rs + register
instruction_r_rs.setParseAction(lambda tk: r_format(tk[1], 0, 0, 0, int(funct_dict[tk[0]], 0) ))

instruction_name_r_rd = pp.oneOf('mfhi mflo')
# pp.Literal('mfhi') | pp.Literal('mflo')
instruction_r_rd = instruction_name_r_rd + register
instruction_r_rd.setParseAction(lambda tk: r_format(0, 0, tk[1], 0, int(funct_dict[tk[0]], 0) ))

instruction_name_r_rd_rt_shamt = pp.oneOf('sll sra srl')
# pp.Literal('sll') | pp.Literal('sra') | pp.Literal('srl')
instruction_r_rd_rt_shamt = instruction_name_r_rd_rt_shamt + register + pp.Char(',') + register + pp.Char(',') + pp.pyparsing_common.integer
instruction_r_rd_rt_shamt.setParseAction(lambda tk: r_format(0, tk[3], tk[1], tk[5], int(funct_dict[tk[0]], 0) ))

instruction_r_ = pp.oneOf('break rte')
# pp.Literal('break') | pp.Literal('rte')
instruction_r_.setParseAction(lambda tk: r_format(0, 0, 0, 0, int(funct_dict[tk[0]], 0) ))

cap = lambda n: (1 << n) - 1

def r_format_to_assembly(bitmask):
    return {
        'funct': hex(bitmask & cap(6)),
        'shamt': (bitmask & cap(11)) >> 6,
        'rd': (bitmask & cap(16)) >> 11,
        'rt': (bitmask & cap(21)) >> 16,
        'rs': (bitmask & cap(26)) >> 21
    }

# bitmask = instruction_r_rd_rs_rt.parse_file('instructions.asm')
# print(f'{bitmask[0]:032b}')
# print(f'{bitmask[0]:08X}')
# print(r_format_to_assembly(bitmask[0]))
# print(register.parse_string('$s0'))
instruction_r = instruction_r_rd_rs_rt | instruction_r_rs_rt | instruction_r_rs | instruction_r_rd | instruction_r_rd_rt_shamt | instruction_r_
mem = [0]*256

with open('instructions.asm') as file:
    address = 0
    for line in file.readlines():
        bitmask = instruction_r.parse_string(line)[0]
        for i in range(4):
            mem[address + 3 - i] = (bitmask >> (i << 3)) & 255;
        address += 4

with open('mem_init.hex', 'w') as file:
    for i in range(0, 256, 4):
        for j in range(i, i + 4):
            # format string 02x quer dizer hexadecimal
            # e padding de 2 zeros à esquerda
            file.write(f'{mem[j]:02X} ')
        # n coloca o newline automaticamente igual ao print
        file.write('\n')
# print(r_format_to_assembly(instruction_r_rd_rs_rt.parse_string('add $t2, $t1, $t0')[0]) )