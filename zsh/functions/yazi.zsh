# Same as `yazi` command, but changes `cwd` on exit
# https://yazi-rs.github.io/docs/quick-start#shell-wrapper
function yazi() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  # `command` calls the original `yazi`, not this function
  command yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
