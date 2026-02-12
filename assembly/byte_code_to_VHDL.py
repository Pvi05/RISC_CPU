def BC_to_VHDL(filein, fileout):
    lines = filein.readlines()
    cpt = 0
    for line in lines:
        line = line.strip()
        parsed = line.split(' ')
        for code in parsed:
            fileout.write(f"                Data_Rom({cpt}) <= \"{code}\"; \n")
            cpt += 1
            if cpt == 256:
                print("WARNING : code length exceding ROM memory size")
    return


with open('ByteCode.txt', 'r') as filein:
    with open('VHDL.txt', 'w') as fileout:
        BC_to_VHDL(filein, fileout)
