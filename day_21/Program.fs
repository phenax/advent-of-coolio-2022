let debug label x = printfn "[%s]: %A" label x

let (.==) a b = System.String.Equals (a, b)

type Expr =
  | Add of string * string
  | Sub of string * string
  | Mul of string * string
  | Div of string * string
  | Eql of string * string
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

let parseInstructionTheBetterWay (line: string): (string * Expr) =
  match line.Split(' ') with
    | arr when Array.head arr .== "humn:" -> ("___", Expr.Noop)
    | [|"root:"; left; op; right|] -> ("root", Expr.Eql (left, right))
    | [|name; left; "+"; right|] -> (name |> getName, Expr.Add (left, right))
    | [|name; left; "-"; right|] -> (name |> getName, Expr.Sub (left, right))
    | [|name; left; "*"; right|] -> (name |> getName, Expr.Mul (left, right))
    | [|name; left; "/"; right|] -> (name |> getName, Expr.Div (left, right))
    | [|name; value|] ->
        let (_, num) = System.Int64.TryParse(value);
        (name |> getName, Expr.Num num)
    | _ -> failwith "Aaaaahhhhh!!!"

let rec resolveExpr (name: string) (exprs: Map<string, Expr>): int64 =
  match exprs.TryFind(name) with
  | Some(Expr.Num num) -> num
  | Some(Expr.Eql (left, right)) -> 0
  | Some(Expr.Add (left, right)) -> resolveExpr left exprs + resolveExpr right exprs
  | Some(Expr.Mul (left, right)) -> resolveExpr left exprs * resolveExpr right exprs
  | Some(Expr.Sub (left, right)) -> resolveExpr left exprs - resolveExpr right exprs
  | Some(Expr.Div (left, right)) -> resolveExpr left exprs / resolveExpr right exprs
  | res -> failwith name

let rec inverseExpr (name: string) (exprs: Map<string, Expr>): int64 =
  match exprs.TryFind(name) with
  | Some(Expr.Num num) -> num
  | res ->
    let getInvertedForm key expr =
      match expr with
      | Expr.Eql (left, right)
      | Expr.Add (left, right)
      | Expr.Mul (left, right)
      | Expr.Sub (left, right)
      | Expr.Div (left, right) when left .== name || right .== name ->
        let node = if left .== name then right else left
        Some (key, left .== name, node, expr)
      | _ -> None

    let res = exprs |> Map.tryPick getInvertedForm
    match res with
    | Some(key, _, node, Expr.Add _) -> inverseExpr key exprs - resolveExpr node exprs
    | Some(key, _, node, Expr.Mul _) -> inverseExpr key exprs / resolveExpr node exprs
    | Some(key, true, node, Expr.Sub _) -> inverseExpr key exprs + resolveExpr node exprs
    | Some(key, false, node, Expr.Sub _) -> resolveExpr node exprs - inverseExpr key exprs
    | Some(key, true, node, Expr.Div _) -> inverseExpr key exprs * resolveExpr node exprs
    | Some(key, false, node, Expr.Div _) -> resolveExpr node exprs / inverseExpr key exprs
    | Some(key, _, node, Expr.Eql _) -> resolveExpr node exprs
    | expr -> failwith "wiow"

System.IO.File.ReadLines("./input.txt")
  |> Seq.map parseInstruction
  |> Map.ofSeq
  |> resolveExpr "root"
  |> debug "Result 1"

System.IO.File.ReadLines("./input.txt")
  |> Seq.map parseInstructionTheBetterWay
  |> Map.ofSeq
  |> inverseExpr "humn"
  |> debug "Result 2"

