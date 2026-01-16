#!/bin/bash
cat > ../.zshrc << "EOF"
# Enable completion
autoload -Uz compinit
compinit
# Autosuggestions
for file in /nix/store/*-zsh-autosuggestions-*/share/zsh-autosuggestions/zsh-autosuggestions.zsh(N); do
  source "$file"
  break
done
# Syntax highlighting
for file in /nix/store/*-zsh-syntax-highlighting-*/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N); do
  source "$file"
  break
done
# Aliases
alias ll="ls -l"
alias update="sudo dnf update && home-manager switch"
alias editconfig="nvim /home/user/.config/home-manager/home.nix"
# Oh My Zsh
for dir in /nix/store/*-oh-my-zsh-*/share/oh-my-zsh(N); do
  export ZSH="$dir"
  ZSH_THEME="agnoster"
  plugins=(git)
  source "$ZSH/oh-my-zsh.sh"
  break
done
# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
eval "$(zoxide init --cmd cd zsh)"
EOF
