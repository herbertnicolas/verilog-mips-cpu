# verilog-mips-cpu
Processador MIPS multi-ciclo em Verilog.

## Setup

Será preciso instalar duas ferramentas de linha de comando:
 * Icarus Verilog (compilador)
 * GTKWave (waveforms)

Ambas podem ser facilmente instaladas no Ubuntu com o apt:
```
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
gtkwave CPU.vcd
```