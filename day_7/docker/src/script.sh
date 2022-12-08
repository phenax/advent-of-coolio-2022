#!/usr/bin/env bash

root="/example-root"
rm -rf "$root" 2>/dev/null;
rm /source/debug.log 2>/dev/null;

# :: String -> ()
change_dir() {
  mkdir -p "$1";
  cd "$1";
}

# :: String -> Int -> ()
create_file() {
  (printf "%${2}s" | tr ' ' '\x0') > "$1"
}

# :: String -> ()
interpret_line() {
  case "$1" in
    \$\ ls) ;;
    dir\ *) ;;
    \$\ cd\ /) change_dir "$root" ;;
    \$\ cd\ *) change_dir $(echo "$1" | sed 's/^\$ cd //') ;;
    *)
      local size=$(echo "$1" | awk '{print $1}');
      local name=$(echo "$1" | awk '{print $2}');
      create_file $name $size;
    ;;
  esac;
}

parse_input() {
  while read line; do
    interpret_line "$line";
  done;
}

get_directory_size() {
  local dir_name="$1";

  local total_size=$(
    find "$dir_name" -exec du -ab -d1 {} \; | while read line; do
      local path=$(echo "$line" | awk '{print $2}');
      local size=$(echo "$line" | awk '{print $1}')

      if [[ "$dir_name" != "$path" ]] && [[ -d "$path" ]]; then
        size=$(get_directory_size "$path");
      fi;

      ts=$(echo "${ts:-0} + ${size:-0}" | bc)
      echo "$ts"
    done | tail -n 1
  );

  echo "$total_size";
}

solve_1() {
  local dir_name="$1";

  echo $(
    find "$dir_name" -type d | while read path; do
      if [[ "$dir_name" != "$path" ]]; then
        echo "$path"  >> /source/debug.log
        local size=$(get_directory_size "$path");

        local tsub=$(solve_1 "$path");
        ts=$(echo "${ts:-0} + ${tsub:-0}" | bc);

        if test $size -lt 100000; then
          ts=$(echo "${ts:-0} + ${size:-0}" | bc);
        fi

        echo ":::::${size:-0}--${ts:-0}:::::::${tsub:-0}" >> /source/debug.log;

        echo "$ts";
      fi
    done | tail -n 1
  );
}

parse_input < ./input.txt

solve_1 "$root";

