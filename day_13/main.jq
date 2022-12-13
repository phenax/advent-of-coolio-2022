def zip2: . | transpose;

def wrap_list: if (. | type) == "array" then . else [.] end;
def compare2(compare_packets):
  if (.[0] | type) == "array" and (.[1] | type) == "array" then
    [.[0], .[1]] | zip2 | compare_packets
  elif (.[0] | type) == "number" and (.[1] | type) == "number" then
    .[0] < .[1]
  elif .[0] == null then
    true
  elif .[1] == null then
    false
  else
    [(.[0] | wrap_list), (.[1] | wrap_list)] | zip2 | compare_packets
  end;

def compare_packets:
  { evaluating: true, list: ., i: 0, is_in_order: false }
    | until((.evaluating and .i < (.list | length) | not);
      . as $current
      | .list[.i]
      | (
        if .[0] == .[1] then
          $current
          | .i+=1
        else
          $current
          | .is_in_order=([.list[.i][0], .list[.i][1]] | compare2(compare_packets))
          | .evaluating=false
        end
      ))
    | .is_in_order
;

# Yoinked it from stackoverflow
def quicksort(cmp):
  if length < 2 then .
  else .[0] as $pivot
    | reduce .[] as $x
      ( [ [], [], [] ];
        if   $x == $pivot then    .[1] += [$x]
        else ([$x,$pivot]|cmp) as $order
          | if   $order == 0 then .[1] += [$x]
            elif ($order|type) == "number" then
              if $order < 0 then  .[0] += [$x]
              else .[2] += [$x]
              end
            else ([$pivot,$x]|cmp) as $order2
              | if $order and $order2 then   .[1] += [$x]
                elif $order then   .[0] += [$x]
                else .[2] += [$x]
                end
            end
        end )
    | (.[0] | quicksort(cmp) ) + .[1] + (.[2] | quicksort(cmp) )
  end;

def solve1:
  split("\n\n")
  | map(
    split("\n")
    | .[0:2]
    | map(fromjson)
  )
  | map(zip2 | compare_packets)
  | to_entries
  | map(.key+=1)
  | map(select(.value))
  | reduce .[] as $item (0; . + $item.key)
;

def solve2:
  split("\n")
  | map(select((. | length) > 0) | fromjson)
  | . + [[[2]], [[6]]]
  | quicksort(compare2(compare_packets))
  | to_entries
  | map(.key+=1)
  | map(select(.value == [[6]] or .value == [[2]]))
  | reduce .[] as $item (1; . * $item.key)
;

inputs | [solve1, solve2]







