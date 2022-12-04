import { input } from './input'

type Parse<Input extends string, Acc extends Array<[number, number, number, number]> = []> =
  Input extends '' ? Acc
  : Input extends `${infer a1 extends number}-${infer a2 extends number},${infer b1 extends number}-${infer b2 extends number}\n${infer rest extends string}`
  ? Parse<rest, [...Acc, [a1, a2, b1, b2]]>
  : Input extends `${infer a1 extends number}-${infer a2 extends number},${infer b1 extends number}-${infer b2 extends number}`
  ? [...Acc, [a1, a2, b1, b2]]
  : never

type GenerateRange<
  N extends number,
  Inclusive extends boolean = true,
  PrevLength extends number = 0,
  Ls extends number[] = []
> =
  (Inclusive extends true ? PrevLength : Ls['length']) extends N
  ? (Ls extends Array<infer T> ? T : never)
  : GenerateRange<N, Inclusive, Ls['length'], [...Ls, Ls['length']]>

type Range2<A extends number, B extends number> = Exclude<GenerateRange<B, true>, GenerateRange<A, false>>

type RangeContains<A1 extends number, A2 extends number, B1 extends number, B2 extends number>
  = Range2<A1, A2> extends Range2<B1, B2> ? true : Range2<B1, B2> extends Range2<A1, A2> ? true : false

type RangeOverlaps<A1 extends number, A2 extends number, B1 extends number, B2 extends number> =
  Extract<Range2<A1, A2>, Range2<B1, B2>> extends never ? false : true

type InputItem = [number, number, number, number]

type Solve1<Inp extends Array<InputItem>, Overlaps extends 0[] = []> =
  Inp extends [] ? Overlaps['length']
  : Inp extends [infer H extends InputItem, ...infer Tail extends InputItem[]]
  ? Solve1<Tail, RangeContains<H[0], H[1], H[2], H[3]> extends true ? [...Overlaps, 0] : Overlaps>
  : never

type Solve2<Inp extends Array<InputItem>, Overlaps extends 0[] = []> =
  Inp extends [] ? Overlaps['length']
  : Inp extends [infer H extends InputItem, ...infer Tail extends InputItem[]]
  ? Solve2<Tail, RangeOverlaps<H[0], H[1], H[2], H[3]> extends true ? [...Overlaps, 0] : Overlaps>
  : never

type ParsedInput = Parse<input>

export type result1 = Solve1<ParsedInput>
export type result2 = Solve2<ParsedInput>

