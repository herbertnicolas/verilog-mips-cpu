# verilog-mips-cpu
Implementação de um processador MIPS multi-ciclo em Verilog

# Comandos

## Setup

```
sudo apt install iverilog gtkwave
```

## Compilando o arquivo Verilog

```
iverilog -o CPU.out CPU.v
```

## Obtendo o dumpfile

```
vvp CPU.out
```

## Visualização em waveform

```
gtkwave CPU.vcd
```

# Instruções