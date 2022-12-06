export type Size = 3

export type StackInput = `
    [D]    
[N] [C]    
[Z] [M] [P]`

export type InstructionsInput = `move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2`

// type PushToStack<Stacks extends StacksType, Index extends number, Item extends string, IsAdded extends boolean = false, RetStacks extends StacksType = []> =
//   Stacks extends [] ? IsAdded extends true ? RetStacks : [...RetStacks, [Index, [Item]]]
//   : Stacks extends [[Index, infer Value extends Array<string>], ...(infer Tail extends StacksType)]
//     ? (
//       PushToStack<Tail, Index, Item, true, [...RetStacks, [Index, [...Value, Item]]]>
//     )
//   : Stacks extends [infer Head extends StackItem, ...(infer Tail extends StacksType)]
//     ? PushToStack<Tail, Index, Item, false, [...RetStacks, Head]>
//   : never

