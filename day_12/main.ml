
let maybe_input_line stdin =
  try Some (input_line stdin) with
    End_of_file -> None;;

let chars (str: string): char list =
  List.init (String.length str) (String.get str)

let input_lines stdin =
  let rec input lines =
    match maybe_input_line stdin with
      Some line -> input ((chars line) :: lines)
    | None -> List.rev lines
  in
  input [];;

let grid =
  let file_channel = open_in("./input.txt") in
  let all_lines = input_lines file_channel in
    List.mapi (fun rowi -> List.mapi (fun coli c -> ((rowi, coli), c))) all_lines
;;

let get_start_index (ls: ((int * int) * char) list list): (int * int) =
  List.find_map (fun row -> Some(List.find (fun (pos, c) -> c == 'S') row)) ls
    |> Option.map fst
    |> Option.get
;;

let is_between min max n = n >= min && n <= max

module Grid = struct
  type t = ((int * int) * char) list list
  let get i j (grid: t) = List.nth (List.nth grid i) j
  let to_char (i, j) (grid: t) = get i j grid |> snd
  let to_level p (grid: t) =
    let c = to_char p grid in
    Char.code (match c with
    | 'S' -> 'a'
    | 'E' -> 'z'
    | a -> a)
  let is_start (i, j) (grid: t) = to_char (i, j) grid == 'S'
  let is_end (i, j) (grid: t) = to_char (i, j) grid == 'E'

  let select_neighbors ((row, col): int * int) (grid: t) =
    [ (row, col - 1); (row, col + 1); (row - 1, col); (row + 1, col) ]
      |> List.filter (fun (i, j) ->
        i >= 0 && j >= 0 &&
        i < List.length grid && j < List.length (List.nth grid 0) &&
        not (is_start (i, j) grid) &&
        not (is_end (row, col) grid) &&
        (
          is_between 0 1 (to_level (i, j) grid - to_level (row, col) grid)
        )
      )
  ;;
end

module VisitedSet = Set.Make(struct
  type t = int * int
  let compare = compare
end)

let (>>>) f g x = x |> f |> g;;
let flip f x y = f y x;;

let debug_point (i, j) = Printf.printf "(%d, %d) " i j ;;
let debug_point_list = List.iter debug_point >>> print_newline ;;

let main =
  let init = get_start_index grid in
  let rec walk point (visited, path, finished_paths) =
    if Grid.is_end point grid then
      (VisitedSet.add point visited, path, path::finished_paths)
    else
      let neighbors = Grid.select_neighbors point grid in
      if List.length neighbors > 0 then
        let finished_paths = neighbors
          |> List.filter (flip VisitedSet.mem visited >>> not)
          |> List.fold_left
            (fun finished_paths point ->
              let (_, _, fps) = walk point (VisitedSet.add point visited, point::path, finished_paths)
              in fps
            )
            []
        in (VisitedSet.add point visited, path, finished_paths)
      else
        (VisitedSet.add point visited, path, finished_paths)
  in
    let (_, _, fps) = walk init (VisitedSet.empty, [init], []) in
    List.iter (debug_point_list >>> print_newline) fps;
    List.iter (List.length >>> print_int >>> print_newline) fps;
    (* let union = List.fold_left VisitedSet.union VisitedSet.empty fps in *)
    (* let ls = VisitedSet.map (fun (ps) -> debug_point ps; ps) union in *)
    (* print_newline (); *)
    (* List.length (VisitedSet.elements ls) |> print_int *)
;;

