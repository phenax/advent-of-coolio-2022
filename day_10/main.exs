
defmodule Main do
  defp first(tupl) do
    {val, _} = tupl
    val
  end

  defp parse_instr(inst) do
    case inst |> String.split(" ") |> Enum.filter(fn s -> s != "" end) do
      ["addx", n] -> {:addx, Integer.parse(n) |> first}
      ["noop"] -> {:noop}
      _ -> {:noop}
    end
  end

  def read_input() do
    {:ok, contents} = File.read("./input.txt")
    contents |> String.split("\n") |> Enum.map(&parse_instr/1)
  end

  def solve_1() do
    instructions = read_input()
    init_state = { 0, 1, 0, 0 }
    instructions |> List.foldl(init_state, fn inst, {cycle, x_register, sum, index} ->
      {new_cycle, new_x_register} = case inst do
        {:noop} -> { cycle + 1, x_register }
        {:addx, n} -> { cycle + 2, x_register + n }
      end

      cycles = [ 20, 60, 100, 140, 180, 220 ]
      cycle_step = Enum.find(cycles, fn x -> x > cycle && x <= new_cycle end)
      new_sum = if cycle_step != nil do
        val = if cycle_step > new_cycle do
          new_x_register
        else
          x_register
        end

        sum + cycle_step * val
      else
        sum
      end

      { new_cycle, new_x_register, new_sum, index + 1 }
    end)
  end
end


IO.inspect(Main.solve_1())

