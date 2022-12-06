import { StackInput, InstructionsInput, Size } from './input-example'

type ParseInstructions<Inp extends string, Output extends [number, number, number][] = []> =
  Inp extends '' ? Output
  : Inp extends `move ${infer Count extends number} from ${infer From extends number} to ${infer To extends number}${infer rest extends string}`
    ? rest extends `\n${infer rest extends string}`
      ? ParseInstructions<rest, [...Output, [Count, From, To]]>
      : ParseInstructions<rest, [...Output, [Count, From, To]]>
  : never

type StacksType = Record<number, string[]>

type PushToStack<
  Stacks extends StacksType,
  Index extends number,
  Item extends string,
> = Omit<Stacks, Index> & { [key in Index]: [Item, ...(Stacks[Index] extends string[] ? Stacks[Index] : [])] }

type PopFromStack<
  Stacks extends StacksType,
  Index extends number,
> = Omit<Stacks, Index> & { [key in Index]: Stacks[Index] extends [any, ...(infer rest extends string[])] ? rest : Stacks[Index] }

type PrependToStack<
  Stacks extends StacksType,
  Index extends number,
  Item extends string,
> = Omit<Stacks, Index> & { [key in Index]: [...(Stacks[Index] extends string[] ? Stacks[Index] : []), Item] }

type ParseStack<Inp extends string, Level extends 0[] = [], Output extends StacksType = {}> =
  Inp extends '' ? Output
    : Inp extends `[${infer Item extends string}]${infer rest extends string}`
      ? ParseStack<
        rest extends ` ${infer rest extends string}` ? rest : rest,
        [...Level, 0],
        PrependToStack<Output, ([...Level, 0])['length'] extends infer L extends number ? L : -1, Item>
      >
    : Inp extends `   ${infer rest extends string}`
      ? ParseStack<rest extends ` ${infer rest extends string}` ? rest : rest, [...Level, 0], Output>
    : Inp extends `\n${infer rest extends string}` ? ParseStack<rest, [], Output>
    : never

type Generate0ToN<N extends number, Result extends number[] = []> =
  Result['length'] extends N ? Result
    : Generate0ToN<N, [...Result, ([...Result, 0])['length'] extends infer L extends number ? L : 0]>

type TopOfStack<Stacks extends StacksType, Iter extends number[] = Generate0ToN<Size>, Result extends string[] = []>
  = Iter extends [] ? Result
    : Iter extends [infer Index extends number, ...(infer rest extends number[])]
      ? TopOfStack<Stacks, rest, [...Result, Stacks[Index][0]]>
    : never

type InstructionSet = ParseInstructions<InstructionsInput>

type Stacks = ParseStack<StackInput>

type MoveNFromStack<Stacks extends StacksType, Count extends number, From extends number, To extends number, Index extends 0[] = []>
  = Index['length'] extends Count ? Stacks
    : MoveNFromStack<PushToStack<PopFromStack<Stacks, From>, To, Stacks[From][0]>, Count, From, To, [...Index, 0]>

type Solve1<Instrs extends [number, number, number][], Stacks extends StacksType>
  = Instrs extends [] ? Stacks
    : Instrs extends [
      [infer Count extends number, infer From extends number, infer To extends number],
      ...(infer rest extends [number, number, number][])
    ]
      ? Solve1<rest, MoveNFromStack<Stacks, Count, From, To>>
    : never

type Equals<A, B> = [A] extends [B] ? [B] extends [A] ? true : false : false
type Assert<A extends true> = A

export type TestCases = [
  Assert<Equals<TopOfStack<Solve1<InstructionSet, Stacks>>, ['C', 'M', 'Z']>>
]

