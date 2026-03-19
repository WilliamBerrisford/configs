if status is-interactive
  alias grep="rg"
  alias ls="exa"
  alias nano="micro"
end

if status is-login
  and status is-interactive
  keychain --eval $SSH_KEYS_TO_AUTOLOAD | source
end

fish_add_path $HOME/go/bin
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
