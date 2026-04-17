#!/bin/bash
# 学术文献来源总表读取脚本（简化版）
# 权威数据文件：source-registry.tsv

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REGISTRY_FILE="$SCRIPT_DIR/source-registry.tsv"

usage() {
  cat <<'EOF'
用法：
  bash scripts/source-registry.sh list
  bash scripts/source-registry.sh get <source_id>
  bash scripts/source-registry.sh match-file <path>
  bash scripts/source-registry.sh validate
EOF
}

require_file() {
  local file="$1"

  [ -f "$file" ] || {
    echo "缺少文件：$file" >&2
    exit 1
  }
}

validate_registry() {
  require_file "$REGISTRY_FILE"

  awk -F '\t' '
    NR == 1 { next }
    {
      if ($1 == "" || $2 == "" || $3 == "" || $4 == "" || $5 == "" || $6 == "" || $10 == "") {
        printf("source-registry.tsv 第 %d 行存在空字段\n", NR) > "/dev/stderr"
        failed = 1
      }

      if ($3 != "core_builtin") {
        printf("source-registry.tsv 第 %d 行存在未知分类：%s\n", NR, $3) > "/dev/stderr"
        failed = 1
      }
    }
    END {
      exit failed ? 1 : 0
    }
  ' "$REGISTRY_FILE"
}

print_registry() {
  require_file "$REGISTRY_FILE"
  validate_registry
  cat "$REGISTRY_FILE"
}

get_source() {
  local source_id="$1"

  require_file "$REGISTRY_FILE"

  awk -F '\t' -v source_id="$source_id" '
    NR == 1 { next }
    $1 == source_id {
      print
      found = 1
    }
    END {
      exit found ? 0 : 1
    }
  ' "$REGISTRY_FILE"
}

match_file() {
  local path="$1"
  local lowered_path source_id source_label source_category input_mode match_rule raw_dir adapter_name dependency_name dependency_type fallback_hint

  require_file "$REGISTRY_FILE"
  lowered_path="$(printf '%s\n' "$path" | tr '[:upper:]' '[:lower:]')"

  while IFS=$'\t' read -r source_id source_label source_category input_mode match_rule raw_dir adapter_name dependency_name dependency_type fallback_hint; do
    [ "$source_id" = "source_id" ] && continue
    [ "$input_mode" = "file" ] || continue

    extension_list="${match_rule#file_ext:}"
    for extension in ${extension_list//,/ }; do
      case "$lowered_path" in
        *"$extension")
          printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$source_id" "$source_label" "$source_category" "$input_mode" "$match_rule" "$raw_dir" "$adapter_name" "$dependency_name" "$dependency_type" "$fallback_hint"
          return 0
          ;;
      esac
    done
  done < "$REGISTRY_FILE"

  return 1
}

command_name="${1:-}"

case "$command_name" in
  list)
    [ "$#" -eq 1 ] || { usage; exit 1; }
    print_registry
    ;;
  get)
    [ "$#" -eq 2 ] || { usage; exit 1; }
    get_source "$2"
    ;;
  match-file)
    [ "$#" -eq 2 ] || { usage; exit 1; }
    match_file "$2"
    ;;
  validate)
    [ "$#" -eq 1 ] || { usage; exit 1; }
    validate_registry
    ;;
  *)
    usage
    exit 1
    ;;
esac
