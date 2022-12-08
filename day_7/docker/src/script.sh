#!/usr/bin/env bash

root="/example-root"
rm /source/debug.log 2>/dev/null;

debug() {
  echo "$@" >> /source/debug.log
}

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

generate_filetree() {
  rm -rf "$root" 2>/dev/null;

  while read line; do
    interpret_line "$line";
  done;
}

# :: String -> Int
get_directory_size() {
  local dir_name="$1";

  local ts=0;
  local total_size=$(
    find "$dir_name" -type f -exec du -ab -d0 {} \; | while read line; do
      local path=$(echo "$line" | awk '{print $2}');
      local size=$(echo "$line" | awk '{print $1}')

      # debug ":::${path} = ${size:-0}--${ts:-0}"

      ts=$(echo "${ts:-0} + ${size:-0}" | bc)
      echo "$ts"
    done | tail -n 1
  );

  echo "$total_size";
}

solve_1() {
  local dir_name="$1";

  local ts=0;
  echo $(
    find "$dir_name" -type d | while read path; do
      if [[ "$dir_name" != "$path" ]]; then
        local size=$(get_directory_size "$path");

        if test $size -lt 100000; then
          ts=$(echo "${ts:-0} + ${size:-0}" | bc);
        fi

        echo "$ts";
      fi
    done | tail -n 1
  );
}

debug "@start"

TOTAL_SPACE=70000000;
SPACE_NEEDED=30000000;

SIZE_OF_ROOT="$(get_directory_size "$root")"

solve_2() {
  local dir_name="$1";

  local sizes=$(find "$dir_name" -type d | while read path; do
    echo $(get_directory_size "$path");
  done | sort --numeric-sort --reverse);

  local space_needed=$(echo "$SPACE_NEEDED - $TOTAL_SPACE + $SIZE_OF_ROOT" | bc);

  IFS='
'
  last_size=0
  for size in $sizes; do
    if test "$size" -lt "$space_needed"; then
      break;
    fi
    last_size=$size
  done

  echo "$last_size"
}

generate_filetree < ./input.txt

echo "Result 1: $(solve_1 "$root")";
echo "Result 2: $(solve_2 "$root")";

# cat /source/debug.log;

