if status is-interactive
  alias grep="rg"
  alias ls="exa"
  alias nano="micro"
end

if status is-interactive
  SHELL=(command -s fish) keychain --eval --quiet $SSH_KEYS_TO_AUTOLOAD | source
end

fish_add_path $HOME/go/bin
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
