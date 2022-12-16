module utils

pub struct instruction
  sensor: (int, int)
  beacon: (int, int)

pub fun to-instruction(s: list<int>): exn instruction {
  match s
    [sx, sy, bx, by] -> Instruction(sensor = (sx, sy), beacon = (bx, by))
    _ -> throw("aaaaaa")
}

pub fun (==)(a: (int, int), b: (int, int)): bool {
  a.fst == b.fst && a.snd == b.snd
}

pub fun show(m: (int, int)): string {
    "(" ++ m.fst.show ++ ", " ++ m.snd.show ++ ")"
}

pub fun show(m: instruction): string {
  "Instruction = "
    ++ "sensor" ++ m.sensor.show ++ " | "
    ++ "beacon(" ++ m.beacon.show ++ ")"
}

pub fun show(m: maybe<string>): string {
  match m
    Just(a) -> "Just(" ++ a.show ++ ")"
    Nothing -> "Nothing"
}

pub fun alt(m: maybe<a>, n: maybe<a>): maybe<a> {
  match m
    Just(_) -> m
    Nothing -> n
}

pub fun parse-instructions(ins: string): exn list<instruction> {
  ins
    .lines
    .filter(is-notempty)
    .map(fn(s) s
      .split(" ")
      .filter-map(fn(a)
        a.starts-with("x=")
          .alt(a.starts-with("y="))
          .map(fn(o) o.string
            .replace-all(",", "")
            .replace-all(":", "")
            .parse-int-default(0))
      ))
      .map(to-instruction)
}

pub fun manhattan-distance(a: (int, int), b: (int, int)): int {
  (a.fst - b.fst).abs + (a.snd - b.snd).abs
}

pub fun manhattan-distance(inst: instruction): int {
  inst.sensor.manhattan-distance(inst.beacon)
}

