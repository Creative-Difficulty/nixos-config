#!/usr/bin/env bash
# Claude Code status line: dir · model · effort · context used · 5h remaining
input=$(cat)

dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
ctx_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
ctx_tok=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
five_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# Abbreviate $HOME to ~
if [ -n "$dir" ]; then
  case "$dir" in
    "$HOME") dir="~" ;;
    "$HOME"/*) dir="~${dir#"$HOME"}" ;;
  esac
fi

fmt_tok() {
  awk -v n="$1" 'BEGIN{ if (n>=1000000) printf "%.1fM", n/1000000; else if (n>=1000) printf "%.0fk", n/1000; else printf "%d", n }'
}

DIM=$'\033[2m'; CYAN=$'\033[36m'; BLUE=$'\033[34m'; MAG=$'\033[35m'; YEL=$'\033[33m'; GRN=$'\033[32m'; RST=$'\033[0m'
SEP="${DIM} · ${RST}"
out=""
add() { if [ -z "$out" ]; then out="$1"; else out="$out$SEP$1"; fi; }

[ -n "$dir" ] && add "${CYAN}${dir}${RST}"
[ -n "$model" ] && add "${BLUE}${model}${RST}"
[ -n "$effort" ] && add "${MAG}${effort}${RST}"

if [ -n "$ctx_pct" ]; then
  seg=$(printf 'ctx %.0f%%' "$ctx_pct")
  if [ -n "$ctx_tok" ] && [ -n "$ctx_size" ]; then
    seg="$seg ($(fmt_tok "$ctx_tok")/$(fmt_tok "$ctx_size"))"
  fi
  add "${YEL}${seg}${RST}"
fi

if [ -n "$five_pct" ]; then
  seg=$(awk -v u="$five_pct" 'BEGIN{ r=100-u; if (r<0) r=0; printf "5h %.0f%% left", r }')
  if [ -n "$five_reset" ]; then
    t=$(date -d "@$five_reset" +%H:%M 2>/dev/null)
    left=$(( ${five_reset%.*} - $(date +%s) ))
    [ "$left" -lt 0 ] && left=0
    if [ "$left" -ge 3600 ]; then
      rel=$(printf '%dh%02dm' $((left / 3600)) $((left % 3600 / 60)))
    else
      rel=$(printf '%dm' $((left / 60)))
    fi
    [ -n "$t" ] && seg="$seg (resets $t, in $rel)"
  fi
  add "${GRN}${seg}${RST}"
fi

printf '%s' "$out"
