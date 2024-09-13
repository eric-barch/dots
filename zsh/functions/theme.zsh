# Updates $BASE16_THEME environment variable
function theme() {
  DEFAULT_UPDATE=false

  while getopts "d" opt; do
    case $opt in
      d)
        DEFAULT_UPDATE=true
        ;;
      \?)
        echo "Usage: $0 [-d] <theme-name>"
        exit 1 
        ;;
    esac
  done

  shift $((OPTIND-1))

  if [ -z "$1" ]; then
    echo "Usage: $0 [-d] <theme-name>"
    exit 1
  fi

  SCHEME_SLUG=$1
  export BASE16_THEME="$SCHEME_SLUG"

  THEME_CONFIG_PATH="$XDG_CONFIG_HOME/theme"
  SCHEME_PATH="$THEME_CONFIG_PATH/schemes/base16/${SCHEME_SLUG}.yaml"
  TEMPLATE_PATH="$THEME_CONFIG_PATH/templates/shell.mustache"
  BUILDER_PATH="$THEME_CONFIG_PATH/builder.lua"

  if [ ! -f "$SCHEME_PATH" ]; then
    echo "Error: Theme file '$SCHEME_PATH' not found."
    exit 1
  fi

  THEME_SCRIPT=$(mktemp)

  cat "$SCHEME_PATH" | lua "$BUILDER_PATH" -t "$TEMPLATE_PATH" > "$THEME_SCRIPT"

  if [ $? -ne 0 ]; then
    echo "Error generating theme script."
    rm -f "$THEME_SCRIPT"
    exit 1
  fi

  . "$THEME_SCRIPT"
  rm -f "$THEME_SCRIPT"

  if [ "$DEFAULT_UPDATE" = true ]; then
    ZSH_ENV_PATH=$(readlink -f "$XDG_CONFIG_HOME/zsh/env.zsh" || echo "$XDG_CONFIG_HOME/zsh/env.zsh")
    sed -i "" "/export BASE16_THEME/s|.*|export BASE16_THEME=\"${SCHEME_SLUG}\"|" "$ZSH_ENV_PATH"
    echo "Default theme updated to '${SCHEME_SLUG}'."
  fi
}
