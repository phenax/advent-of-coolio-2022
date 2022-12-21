import
"lib/prelude.ch" :: ""
"lib/strings.ch"
"lib/math.ch"

def

(ls) mapWith (fn):
  len(ls) == 0: []
  len(ls) == 1: [fn(ls[0])]
  else: [fn(ls[0])] + (ls[1::len(ls)] mapWith fn)

fori (n) do (f) to (x tuple) :
    (while unfinished do loop to 0, x)[1::arity(x) + 1]
given :
    unfinished = func(i int, x tuple) : i < n
    loop = func(i int, x tuple) : i + 1, f(i, x)

getInput:
  fori len(lines) do mapFn to []
given:
  lines = (file "../input.txt")[contents]
  mapFn = func(idx, acc):
    acc + [ [idx, int(lines[idx])] ]

cycleIdx(inc, idx, length):
  inc < 0 and idx == 0: length - 2
  inc > 0 and idx == length - 1: 1
  inc < 0: (idx + length + inc) % length
  else: (idx + inc) % length

shiftN(ls, idx, n int):
  n == 0: ls
  n < 0: next(-1)
  else: next(1)
given:
  length = len(ls)
  next = func(inc):
    shiftN(shifted(inc), cycleIdx(inc, idx, length), n - inc)
  shifted = func(inc):
    inc < 0 and idx == 0 : ls[1::len(ls) - 1] + [ls[idx], ls[len(ls) - 1]]
    inc > 0 and idx == len(ls) - 1 : [ls[0], ls[idx]] + ls[1::len(ls) - 1]
    else: ls with idx :: ls[cycleIdx(inc, idx, length)], cycleIdx(inc, idx, length) :: ls[idx]

findIndex(ls, idx):
  fori len(ls) do fn to NIL
given:
  fn = func(i, found):
    found == NIL and ls[i][0] == idx: i
    else: found

sum(ls):
  fori len(ls) do (func(i, a): a + ls[i]) to 0

mix(input):
  mixed[0]
given:
  shift = func(idx int, ls list):
    shiftN(ls, findIndex(ls, idx), input[idx][1])
  mixed = fori len(input) do shift to input

getKey(result):
  sum (indexes mapWith getValue)
given:
  getValue = func(n): result[cycleIdx(0, n + zeroIdx, len(result))]
  indexes = [1000, 2000, 3000]
  findZero = func(i, v):
    result[i] == 0: i
    else: v
  zeroIdx = fori len(result) do findZero to NIL

solve1:
  getKey(result)
given:
  input = getInput[0]
  result = mix(input) mapWith (func(x): x[1])

solve2:
  getKey(result)
given:
  key = 1
  input = getInput[0] mapWith (func(x): [x[0], x[1] * key])
  mixOut = for 10 do (func(x): mix(x)) to input
  result = mixOut mapWith (func(x): x[1])

