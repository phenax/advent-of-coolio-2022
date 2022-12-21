// For more information see https://aka.ms/fsharp-console-apps

let debug label x = printfn "[%s]: %A" label x

type Expr =
  | Add of string * string
  | Sub of string * string
  | Mul of string * string
  | Div of string * string
  | Num of int64
  | Noop

let getName (s: string): string = s.Substring(0, s.Length - 1)

let parseInstruction (line: string): (string * Expr) =
  match line.Split(' ') with
    | [|name; left; "+"; right|] -> (name |> getName, Expr.Add (left, right))
    | [|name; left; "-"; right|] -> (name |> getName, Expr.Sub (left, right))
    | [|name; left; "*"; right|] -> (name |> getName, Expr.Mul (left, right))
    | [|name; left; "/"; right|] -> (name |> getName, Expr.Div (left, right))
    | [|name; value|] ->
        let (_, num) = System.Int64.TryParse(value);
        (name |> getName, Expr.Num num)
    | _ -> failwith "Aaaaahhhhh!!!"

let input =
  System.IO.File.ReadLines("./input.txt")
    |> Seq.map parseInstruction
    |> Map.ofSeq

let rec solve1 (name: string) (exprs: Map<string, Expr>): int64 =
  match exprs.TryFind(name) with
  | Some(Expr.Num num) -> num
  | Some(Expr.Add (left, right)) -> solve1 left exprs + solve1 right exprs
  | Some(Expr.Mul (left, right)) -> solve1 left exprs * solve1 right exprs
  | Some(Expr.Sub (left, right)) -> solve1 left exprs - solve1 right exprs
  | Some(Expr.Div (left, right)) -> solve1 left exprs / solve1 right exprs
  | res -> 0

debug "foobar" (solve1 "root" input)

