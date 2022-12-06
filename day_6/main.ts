import { Input } from './input'

type char = string

type Take<Str extends string, N extends number, Result extends char[] = []> =
  Str extends '' ? Result
  : N extends Result['length'] ? Result
  : Str extends `${infer C extends char}${infer rest extends string}`
  ? Take<rest, N, [...Result, C]>
  : never

type IsUnique<Str extends char[]> =
  Str extends [] ? true
  : Str extends [infer C extends char, ...(infer rest extends char[])]
    ? C extends rest[number] ? false : IsUnique<rest>
  : never

type Generate0s<N extends number, Output extends 0[] = []> =
  Output['length'] extends N ? Output
  : Generate0s<N, [...Output, 0]>

type GetMarker<Inp extends string, Count extends number, Index extends 0[] = []> =
  Inp extends '' ? never
  : Inp extends `${char}${infer rest extends string}`
  ? IsUnique<Take<Inp, Count>> extends true
    ? [...Index, ...Generate0s<Count>]['length']
    : GetMarker<rest, Count, [...Index, 0]>
  : never

type GetPacketMarker<Inp extends string> = GetMarker<Inp, 4>

// type GetMessageMarker<Inp extends string> = GetMarker<Inp, 14>

export type result1 = GetPacketMarker<Input>

// export type result2 = GetMessageMarker<Input>

