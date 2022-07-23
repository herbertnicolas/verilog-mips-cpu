# verilog-mips-cpu
Processador MIPS multi-ciclo em Verilog.

## Tabela de instruções

### Instruções do tipo R

|        Assembly        | Opcode | rs | rt | rd | shamt |  funct |     Comportamento    | Responsável |
|:----------------------:|:------:|:--:|:--:|:--:|:-----:|:------:|:--------------------:|:-----------:|
|     add rd, rs, rt     |  0x0   | rs | rt | rd |       | 0x20   |     rd ← rs + rt     | Gustavo     |
|     sub rd, rs, rt     |  0x0   | rs | rt | rd |       | 0x22   |     rd ← rs – rt     | Gustavo     |
|     and rd, rs, rt     |  0x0   | rs | rt | rd |       | 0x24   |     rd ← rs & rt     | Gustavo     |
|         push rt        |  0x0   |    | rt |    |       | 0x5    | sp ← sp - 4, Mem[sp] ← rt | Gustavo |
|         pop rt         |  0x0   |    | rt |    |       | 0x6    | rt ← Mem[sp], sp ← sp + 4 | Gustavo |
|       div rs, rt       |  0x0   | rs | rt |    |       | 0x1a   |        rs / rt       | Matheus     |
|       mult rs, rt      |  0x0   | rs | rt |    |       | 0x18   |        rs x rt       | Matheus     |
|         mfhi rd        |  0x0   |    |    | rd |       | 0x10   |        rd ← hi       | Matheus     |
|         mflo rd        |  0x0   |    |    | rd |       | 0x12   |        rd ← lo       | Matheus     |
|    sll rd, rt, shamt   |  0x0   |    | rt | rd | shamt | 0x0    |   rd ← rt << shamt   | Marvin      |
|    srl rd, rt, shamt   |  0x0   |    | rt | rd | shamt | 0x2    |   rd ← rt >> shamt   | Marvin      |
|    sra rd, rt, shamt   |  0x0   |    | rt | rd | shamt | 0x3    |   rd ← rt >> shamt*  | Marvin      |
|     sllv rd, rs, rt    |  0x0   | rs | rt | rd |       | 0x4    |     rd ← rs << rt    | Marvin      |
|     srav rd, rs, rt    |  0x0   | rs | rt | rd |       | 0x7    |    rd ← rs >> rt*    | Marvin      |
|          break         |  0x0   |    |    |    |       | 0xd    |      PC ← PC - 4     | Marcus      |
|           Rte          |  0x0   |    |    |    |       | 0x13   |       PC ← EPC       | Marcus      |
|          jr rs         |  0x0   | rs |    |    |       | 0x8    |        PC ← rs       | Marcus      |
|     slt rd, rs, rt     |  0x0   | rs | rt | rd |       | 0x2a   | rd ← (rs < rt) ?1 :0 | Marcus      |

### Instruções do tipo I

|        Assembly        | Opcode | rs | rt | Imediato |          Comportamento         | Responsável |
|:----------------------:|:------:|:--:|:--:|:--------:|:------------------------------:|:-----------:|
|  addi rt, rs, imediato | 0x8    | rs | rt | imediato |      rt ← rs + imediato**      | Gustavo     |
| addiu rt, rs, imediato | 0x9    | rs | rt | imediato |      rt ← rs + imediato**      | Gustavo     |
|  slti rt, rs, imediato | 0xa    | rs | rt | imediato |   rt ← (rs < imediato) ?1 :0   | Marcus      |
|    lui rt, imediato    | 0xf    |    | rt | imediato |       rt ← imediato << 16      | Marcus      |
|    lb rt, offset(rs)   | 0x20   | rs | rt |  offset  |   rt ← byte(Mem[offset + rs])  | Herbert     |
|    lh rt, offset(rs)   | 0x21   | rs | rt |  offset  | rt ← halfword(Mem[offset + rs])| Herbert     |
|    lw rt, offset(rs)   | 0x23   | rs | rt |  offset  |      rt ← Mem[offset + rs]     | Herbert     |
|    sb rt, offset(rs)   | 0x28   | rs | rt |  offset  |   Mem[offset + rs] ← byte(rt)  | Herbert     |
|    sh rt, offset(rs)   | 0x29   | rs | rt |  offset  | Mem[offset + rs] ← halfword(rt)| Herbert     |
|    sw rt, offset(rs)   | 0x2b   | rs | rt |  offset  |      Mem[offset + rs] ← rt     | Herbert     |
|    beq rs,rt, offset   | 0x4    | rs | rt |  offset  |       Desvia se rs == rt       | Douglas     |
|    bne rs,rt, offset   | 0x4    | rs | rt |  offset  |       Desvia se rs != rt       | Douglas     |
|    ble rs,rt,offset    | 0x6    | rs | rt |  offset  |       Desvia se rs <= rt       | Douglas     |
|    bgt rs,rt,offset    | 0x7    | rs | rt |  offset  |        Desvia se rs > rt       | Douglas     |

### Instruções do tipo J

|  Assembly  | Opcode | Offset |     Comportamento     | Responsável |
|:----------:|:------:|:------:|:---------------------:|:-----------:|
|  j offset  | 0x2    | offset |  Desvio incondicional | Douglas     |
| jal offset | 0x3    | offset | ra ← PC e desvia      | Douglas     |

> \* instruções devem estender o sinal (deslocamento aritmético)

> ** o valor de ‘imediato’ deve ser estendido para 32 bits, estendendo seu sinal (bit mais significativo da constante).

## Setup

Será preciso instalar duas ferramentas de linha de comando:
 * Icarus Verilog (compilador)
 * GTKWave (waveforms)

Ambas podem ser facilmente instaladas no Ubuntu com o apt:
```console
sudo apt install iverilog gtkwave
```

## Simulação

Na pasta do repositório, tente primeiro compilar o código em Verilog. O arquivo CPU.v é o principal, e importa todos os demais.
```console
cd verilog-mips-cpu
iverilog -o CPU.out CPUTestBench.v
```

Se os arquivos Verilog compilarem sem erros, defina no arquivo `instructions.asm` a série de instruções que será simulada, em Assembly MIPS. Em seguida, execute o script `assembler.py` para traduzir as instruções Assembly em "código de máquina". O resultado é o arquivo `mem_init_data.hex` contendo os 256 bytes em hexadecimal que inicializarão a memória.

```console
python assembler.py
```

Para simular, primeiro gere o dumpfile `CPU.vcd`, e depois visualize os resultados em waveforms com o GTKWave.
```console
vvp CPU.out
gtkwave CPU.vcd --script="signals.tcl"
```