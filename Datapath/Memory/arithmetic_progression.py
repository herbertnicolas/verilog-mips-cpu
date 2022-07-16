with open('mem_init.txt', 'w') as file:
    for i in range(0, 256, 4):
        for j in range(i, i + 4):
            # format string 02x quer dizer hexadecimal
            # e padding de 2 zeros à esquerda
            file.write(f'{j:02X} ')
        # n coloca o newline automaticamente igual ao print
        file.write('\n')