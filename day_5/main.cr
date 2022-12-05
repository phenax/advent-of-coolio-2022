def get_input()
  content = File.read("./input.txt")
  stack_map_input, instructions_input = content.split("\n\n")
  stacks = stack_map_input.split("\n")[..-2]
  stack_map = stacks.map { |l|
    indents = 0
    l.split(" ").reduce([] of String) { |acc, item|
      if item == ""
        indents += 1
        if indents % 4 == 0
          acc.push("")
        end
      else
        indents = 0
        acc.push(item)
      end
      acc
    }
  }
  stack_map = stack_map.transpose.map { |l| l.reverse.select { |x| x != "" } }

  instructions = instructions_input.split("\n", remove_empty: true).map { |instruction|
    if match_data = instruction.match(/move (\d+) from (\d+) to (\d+)/)
      _, count, from, to = match_data.to_a
      [count, from, to].map { |x|
        x.try &.to_i32
      }
    end
  }

  return {stack_map, instructions}
end

def solve_1(stack_map, instructions)
  instructions.map { |val|
    if val
      count, from, to = val
      if from && to && count
        from_stack = stack_map[from - 1]
        to_stack = stack_map[to - 1]
        popped = from_stack.pop(count)
        popped.reverse.map { |c| to_stack.push(c) }
        stack_map[from - 1] = from_stack
        stack_map[to - 1] = to_stack
      end
    end
  }

  stack_map.map { |s|
    if s.empty?
      ""
    else
      s.last
    end
  }
end

def solve_2(stack_map, instructions)
  instructions.map { |val|
    if val
      count, from, to = val
      if from && to && count
        from_stack = stack_map[from - 1]
        to_stack = stack_map[to - 1]
        popped = from_stack.pop(count)
        popped.map { |c| to_stack.push(c) }
        stack_map[from - 1] = from_stack
        stack_map[to - 1] = to_stack
      end
    end
  }

  stack_map.map { |s|
    if s.empty?
      ""
    else
      s.last
    end
  }
end

stack_map, instructions = get_input()

def format_stackmap(stack_map)
  stack_map.map { |stack|
    stack.map { |item|
      print(item)
    }
    puts("\n")
  }
end

result1 = solve_1(stack_map, instructions)
result2 = solve_2(stack_map, instructions)

p! result1
puts("----------------------")
p! result2

