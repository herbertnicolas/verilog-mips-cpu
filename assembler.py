import pyparsing as pp
import json
from bitstring import BitArray

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

def r_format(rs, rt, rd, shamt, funct):
    opcode = BitArray(uint=0, length=6)
    rs = BitArray(uint=rs, length=5)
    rt = BitArray(uint=rt, length=5)
    rd = BitArray(uint=rd, length=5)
    shamt = BitArray(uint=shamt, length=5)
    funct = BitArray(uint=int(funct_dict[funct], 0), length=6)
    return opcode + rs + rt + rd + shamt + funct

instruction_name_r_rd_rs_rt = pp.oneOf('add and sllv slt srav sub')
instruction_r_rd_rs_rt = instruction_name_r_rd_rs_rt + register + pp.Char(',') + register + pp.Char(',') + register
instruction_r_rd_rs_rt.setParseAction(lambda tk: r_format(tk[3], tk[5], tk[1], 0, tk[0]) )

instruction_name_r_div_mult = pp.oneOf('div mult')
instruction_r_div_mult = instruction_name_r_div_mult + register + pp.Char(',') + register
instruction_r_div_mult.setParseAction(lambda tk: r_format(tk[1], tk[3], 0, 0, tk[0]) )

instruction_name_hi_lo = pp.oneOf('mfhi mflo')
instruction_r_hi_lo = instruction_name_hi_lo + register
instruction_r_hi_lo.setParseAction(lambda tk: r_format(0, 0, tk[1], 0, tk[0]) )

instruction_name_r_jr = pp.Literal('jr')
instruction_r_jr = instruction_name_r_jr + register
instruction_r_jr.setParseAction(lambda tk: r_format(tk[1], 0, 0, 0, tk[0]) )

instruction_name_r_shift = pp.oneOf('sll sra srl')
instruction_r_shift = instruction_name_r_shift + register + pp.Char(',') + register + pp.Char(',') + pp.pyparsing_common.integer
instruction_r_shift.setParseAction(lambda tk: r_format(0, tk[3], tk[1], tk[5], tk[0]) )

instruction_r_op = pp.oneOf('break rte invalid')
instruction_r_op.setParseAction(lambda tk: r_format(0, 0, 0, 0, tk[0]) )

instruction_name_r_sp = pp.oneOf('push pop')
instruction_r_sp = instruction_name_r_sp + register
instruction_r_sp.setParseAction(lambda tk: r_format(0, tk[1], 0, 0, tk[0]))

instruction_r = instruction_r_rd_rs_rt | instruction_r_div_mult | instruction_r_hi_lo | instruction_r_jr | instruction_r_shift | instruction_r_op | instruction_r_sp

with open('opcode.json') as file:
    global opcode_dict
    opcode_dict = json.load(file)

def i_format(opcode, rs, rt, offset_immediate):
    opcode = BitArray(uint=int(opcode_dict[opcode], 0), length=6)
    rs = BitArray(uint=rs, length=5)
    rt = BitArray(uint=rt, length=5)
    offset_immediate = BitArray(int=offset_immediate, length=16)
    return opcode + rs + rt + offset_immediate

instruction_name_i_immediate = pp.oneOf('addi addiu slti')
instruction_i_immediate = instruction_name_i_immediate + register + pp.Char(',') + register + pp.Char(',') + pp.pyparsing_common.signed_integer
instruction_i_immediate.setParseAction(lambda tk: i_format(tk[0], tk[3], tk[1], tk[5]))

instruction_name_i_branch = pp.oneOf('beq bne ble bgt')
instruction_i_branch = instruction_name_i_branch + register + pp.Char(',') + register + pp.Char(',') + pp.pyparsing_common.signed_integer
instruction_i_branch.setParseAction(lambda tk: i_format(tk[0], tk[1], tk[3], tk[5]))

instruction_name_i_memory = pp.oneOf('lb lh lw sb sh sw')
instruction_i_memory = instruction_name_i_memory + register + pp.Char(',') + pp.pyparsing_common.signed_integer + pp.Char('(') + register + pp.Char(')')
instruction_i_memory.setParseAction(lambda tk: i_format(tk[0], tk[5], tk[1], tk[3]))

instruction_name_i_lui = pp.Literal('lui')
instruction_i_lui = instruction_name_i_lui + register + pp.Char(',') + pp.pyparsing_common.signed_integer
instruction_i_lui.setParseAction(lambda tk: i_format(tk[0], 0, tk[1], tk[3]))

instruction_i = instruction_i_immediate | instruction_i_branch | instruction_i_memory | instruction_i_lui

def j_format(opcode, offset):
    opcode = BitArray(uint=int(opcode_dict[opcode], 0), length=6)
    offset = BitArray(int=offset, length=26)
    return opcode + offset

instruction_name_j = pp.oneOf('j jal')
instruction_j = instruction_name_j + pp.pyparsing_common.signed_integer
instruction_j.setParseAction(lambda tk: j_format(tk[0], tk[1]))

instruction = instruction_r | instruction_i | instruction_j

mem = ['00']*256

for address, byte in zip(range(228, 232), instruction_r_op.parse_string('rte')[0].cut(8)):
    mem[address] = byte.hex

# o endereço das rotinas de tratamento das exceções
for i in range(253, 256):
    mem[i] = BitArray(uint=228, length=8).hex

with open('instructions.asm') as file:
    address = 0
    for line in file.readlines():
        word = instruction.parse_string(line)[0]
        for byte in word.cut(8):
            mem[address] = byte.hex
            address += 1

with open('mem_init_data.hex', 'w') as file:
    for i in range(0, 256, 4):
        for j in range(i, i + 4):
            # format string 02x quer dizer hexadecimal
            # e padding de 2 zeros à esquerda
            file.write(mem[j] + ' ')
        # n coloca o newline automaticamente igual ao print
        file.write('\n')