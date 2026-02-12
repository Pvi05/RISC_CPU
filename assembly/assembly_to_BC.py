class NoImmediate(Exception):
    pass


class FormatError(Exception):
    pass


label_pos = {}
buffer = 0


def to_byte(s: str) -> str:
    value = int(s, 0)        # auto-detect (0x, 0b, décimal)
    return format(value & 0xFF, "08b")


def matchOperand(Operand, AllowImm=True, iline=-1):
    if not (Operand[0].isdigit() or Operand[0] == '-'):
        if Operand[0] == 'R':
            if int(Operand[1:]) > 14:
                raise ValueError(
                    f'Line {iline} : Architecture has only 14 general purpose registers')
            return True, to_byte(Operand[1:])
        elif Operand[0:2] == 'sp':
            return True, "00001110"
        elif Operand[0:2] == 'lr':
            return True, "00001111"
        elif Operand[0:2] == 'pc':
            return True, "00010000"
        else:  # assuming its a label
            return False, Operand
    else:
        if AllowImm:
            return False, to_byte(Operand)
        else:
            raise NoImmediate(
                f'Line {iline} : Forbidden immediate value on destination')


def decodeABDest(Dest, A, B, iline, DestImm=False):
    if (Dest is None) and (A is None) and (B is None):
        raise FormatError(
            f'Line {iline} : Not enough operand for this operation')
    line = " "
    DestR, res = matchOperand(Dest, DestImm, iline)
    line += res + ' '
    AR, res = matchOperand(A, True, iline)
    line += res + ' '
    BR, res = matchOperand(B, True, iline)
    line += res + '\n'
    Ops = ('0' if AR else '1') + ('0' if BR else '1')
    return Ops, line, DestR


def assembleLine(line, iline):
    ''' Input : string line of assembly code
        Output : string line(s) of corresponding byte code'''
    global label_pos, buffer
    Op, Dest, A, B = (tuple(line.rstrip("\n").split(' ')) + (None,) * 4)[:4]
    print(Op, Dest, A, B)
    if Op == '':
        buffer -= 1
        return ''
    match Op:

        # Standard Operations
        case 'ADD':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '000' + line_rest
            return out_line
        case 'SUB':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '001' + line_rest
            return out_line
        case 'AND':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '010' + line_rest
            return out_line
        case 'OR':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '011' + line_rest
            return out_line
        case 'XOR':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '100' + line_rest
            return out_line
        case 'NOT':
            if ((B is not None)):
                raise FormatError(
                    f'Line {iline} : Too much operands for this operation')
            _, destByte = matchOperand(Dest, False, iline)
            AR, AByte = matchOperand(A, True, iline)
            out_line = '000' + ('0' if AR else '1') + '0' + \
                '101 ' + destByte + ' ' + AByte + ' 00000000\n'
            return out_line
        case 'LSR':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '110' + line_rest
            return out_line
        case 'LSL':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '000' + Ops + '111' + line_rest
            return out_line

        # Conditionnal Jumps
        case 'JEQ':
            Ops, line_rest, DestR = decodeABDest(Dest, A, B, iline, True)
            out_line = ('1' if DestR else '0') + '01' + Ops + '000' + line_rest
            return out_line
        case 'JNE':
            Ops, line_rest, DestR = decodeABDest(Dest, A, B, iline, True)
            out_line = ('1' if DestR else '0') + '01' + Ops + '001' + line_rest
            return out_line
        case 'JGE':
            Ops, line_rest, DestR = decodeABDest(Dest, A, B, iline, True)
            out_line = ('1' if DestR else '0') + '01' + Ops + '010' + line_rest
            return out_line
        case 'JMG':
            Ops, line_rest, DestR = decodeABDest(Dest, A, B, iline, True)
            out_line = ('1' if DestR else '0') + '01' + Ops + '011' + line_rest
            return out_line
        case 'JLE':
            Ops, line_rest, DestR = decodeABDest(Dest, A, B, iline, True)
            out_line = ('1' if DestR else '0') + '01' + Ops + '100' + line_rest
            return out_line
        case 'JML':
            Ops, line_rest, DestR = decodeABDest(Dest, A, B, iline, True)
            out_line = ('1' if DestR else '0') + '01' + Ops + '101' + line_rest
            return out_line
        case 'J':
            if ((A is not None) and (B is not None)):
                raise FormatError(
                    f'Line {iline} : Too much operands for this operation')
            DestR, line_rest = matchOperand(Dest, True, iline)
            out_line = ('1' if DestR else '0') + '0100110 ' + \
                line_rest + ' 00000000 00000000\n'
            return out_line
        case 'INOP':
            if ((A is not None) and (B is not None) and (Dest is not None)):
                raise FormatError(
                    f'Line {iline} : Too much operands for this operation')
            out_line = '00100111 00000000 00000000 00000000\n'
            return out_line

        # RAM interaction
        case 'LOAD':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '010' + Ops + '000' + line_rest
            return out_line
        case 'STORE':
            Ops, line_rest, _ = decodeABDest(Dest, A, B, iline)
            out_line = '011' + Ops + '000' + line_rest
            return out_line

        # Stack Interaction
        case 'PUSH':
            if ((A is not None) and (B is not None)):
                raise FormatError(
                    f'Line {iline} : Too much operands for this operation')
            _, line_rest = matchOperand(Dest, False, iline)
            out_line = '11101000 ' + line_rest + ' 00001110 ' + '00000000\n'
            return out_line
        case 'POP':
            if ((A is not None) and (B is not None)):
                raise FormatError(
                    f'Line {iline} : Too much operands for this operation')
            _, line_rest = matchOperand(Dest, False, iline)
            out_line = '11001000 ' + line_rest + ' 00001110 ' + '00000001\n'
            return out_line

        # Functions
        case 'CALL':
            out_lines = assembleLine('PUSH pc', iline) + \
                assembleLine(f'J {Dest}', iline)
            buffer += 1  # BC has now 1 more line than assembly
            return out_lines
        case 'RET':
            out_lines = assembleLine('POP lr', iline) + \
                assembleLine('J lr', iline)
            buffer += 1  # BC has now 1 more line than assembly
            return out_lines
        case 'LABEL':
            if Dest not in label_pos:
                label_pos[Dest] = iline + buffer - 1
                buffer -= 1
            else:
                raise FormatError(f'Line {iline} : LABEL already used')
            return ''

        # else
        case _:
            raise ValueError(f'Line {iline} : Unknown operation')


def apply_labels(fileout):
    text = fileout.read()
    print(label_pos)
    for label, pos in label_pos.items():
        label = ' ' + label + ' '
        text = text.replace(label, ' ' + format((pos * 4) & 0xFF, "08b") + ' ')
    return text


def assembler(filein, fileout):
    lines = filein.readlines()
    cpt = 1
    for line in lines:
        fileout.write(assembleLine(line, cpt))
        cpt += 1
    return


with open('Assembly_in.txt', 'r') as filein:
    with open('ByteCode.txt', 'w') as fileout:
        assembler(filein, fileout)
    with open('ByteCode.txt', 'r') as ByteCode:
        BC_labelled = apply_labels(ByteCode)
        print(BC_labelled)
    with open('ByteCode.txt', 'w') as fileout:
        fileout.write(BC_labelled)
