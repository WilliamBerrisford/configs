if status is-interactive
  alias grep="rg"
  alias ls="exa"
  alias nano="micro"
end

if status is-interactive
  SHELL=(command -s fish) keychain --eval --quiet $SSH_KEYS_TO_AUTOLOAD | source
end

fish_add_path ~/.local/bin ~/go/bin
