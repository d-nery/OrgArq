from random import randint, choice
from ctypes import c_uint

size = 255

operators = ['ULA_ADD', 'ULA_SUB', 'ULA_SUBNE', 'ULA_AND', 'ULA_OR', 'ULA_SLT']

op1 = [c_uint(randint(0, 0xFFFFFFFF)) for i in range(size)]
op2 = [c_uint(randint(0, 0xFFFFFFFF)) for i in range(size)]
ope = [choice(operators) for i in range(size)]

results = []

for i in range(len(op1)):
    if ope[i] == 'ULA_ADD':
        res = c_uint(op1[i].value + op2[i].value)
        results.append(res)
    if ope[i] == 'ULA_SUB':
        res = c_uint(op1[i].value - op2[i].value)
        results.append(res)
    if ope[i] == 'ULA_SUBNE':
        res = c_uint(op1[i].value - op2[i].value)
        results.append(res)
    if ope[i] == 'ULA_AND':
        res = c_uint(op1[i].value & op2[i].value)
        results.append(res)
    if ope[i] == 'ULA_OR':
        res = c_uint(op1[i].value | op2[i].value)
        results.append(res)
    if ope[i] == 'ULA_SLT':
        res = c_uint(op1[i].value < op2[i].value)
        results.append(res)

print("Operandos 1:")
for i, op in enumerate(op1):
    print('x"{:08X}", '.format(op.value), end='')
    if (i + 1) % 15 == 0:
        print()

print("Operandos 2:")
for i, op in enumerate(op2):
    print('x"{:08X}", '.format(op.value), end='')
    if (i + 1) % 15 == 0:
        print()

print("Operações:")
for i, op in enumerate(ope):
    print('{}, '.format(op), end='')
    if (i + 1) % 15 == 0:
        print()

print("Resultados:")
for i, op in enumerate(results):
    print('x"{:08X}", '.format(op.value), end='')
    if (i + 1) % 15 == 0:
        print()
