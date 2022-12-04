type input = `2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8`

type OptionalNewline = '' | '\n'

type Parse<Input extends string, Acc extends Array<[number, number, number, number]> = []> =
  Input extends '' ? Acc
  : Input extends `${infer a1 extends number}-${infer a2 extends number},${infer b1 extends number}-${infer b2 extends number}\n${infer rest extends string}`
  ? Parse<rest, [...Acc, [a1, a2, b1, b2]]>
  : Input extends `${infer a1 extends number}-${infer a2 extends number},${infer b1 extends number}-${infer b2 extends number}`
  ? [...Acc, [a1, a2, b1, b2]]
  : never


type _x = Parse<input>

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

// type Equals<A, B> = [A] extends [B] ? [B] extends [A] ? true : false : false

type RangeContains<A1 extends number, A2 extends number, B1 extends number, B2 extends number>
  = Range2<A1, A2> extends Range2<B1, B2> ? true : Range2<B1, B2> extends Range2<A1, A2> ? true : false

type __ = RangeContains<3, 5, 2, 8>

