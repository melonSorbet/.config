{ pkgs, ... }:
let
  unfreepkgs = import <nixpkgs> {
    system = builtins.currentSystem;
    config = {
      allowUnfree = true;
    };
  };
  nixgl =
    import (builtins.fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz")
      { };
in
{
  home.stateVersion = "25.05";
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
  ];
  # Install zoxide and other tools
  home.packages =
    with pkgs;
    [
      fzf
      zoxide
      zsh-autocomplete
      kubectl
      minikube
      alacritty
      ripgrep
      tmux
      # Compiler
      nixgl.auto.nixGLDefault
      nodejs_24
      gcc
      cargo

      # Neovim
      wl-clipboard
      neovim
      fastfetch

      # Fonts
      nerd-fonts.jetbrains-mono
      font-awesome
      # hyprland
      hyprshot
      hyprcursor
      hyprpaper
      waybar
      hyprsunset
      hyprland-qtutils
      hyprlock
      hyprcursor
      swaynotificationcenter
      # tools
      inotify-tools

      pywal
      pywalfox-native
      pipes

      protonvpn-gui

      # Language Servers
      nixd
      nixfmt
    ]
    ++ (with unfreepkgs; [
      obsidian
    ]);

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = [ "--cmd cd" ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo dnf update && home-manager switch";
      editconfig = "nvim /home/user/.config/home-manager/home.nix";
      nvim = "${pkgs.neovim-unwrapped}/bin/nvim";
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" ];
    };

    history.size = 10000;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "~/.cache/wal/colors-alacritty-mine.toml"
      ];

      scrolling.history = 10000; # increase buffer
      window.opacity = 0.992;
      window.blur = false;
      font.normal = {
        family = "JetbrainsMono NerdFont";
        style = "Normal";
      };
      font.bold = {
        family = "JetbrainsMono NerdFont";
      };
      font.italic = {
        family = "JetbrainsMono NerdFont";

      };
      font.size = 16;
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "--login" ];
      };

      env = {
        WINIT_UNIX_BACKEND = "wayland";
      };
      colors.transparent_background_colors = true;
      colors.cursor.text = "0x1f1f28";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;

    extraConfig = ''
      # Keybindings
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Pane navigation
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # General settings
      set -s escape-time 0

      setw -g pane-base-index 1
      set-option -g renumber-windows on
      set -g mouse on
      set-option -g allow-rename off
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Copy mode
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"

      # Terminal colors
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      setw -g clock-mode-colour default
      set -g @kanagawa-ignore-window-colors true

      # Make panes transparent



      set -g window-style 'bg=default'
      set -g window-active-style 'bg=default'

      # Keep Kanagawa bar (assumes plugin is loaded)
      set -g status on
      set -g status-style 'bg=colour234 fg=colour223'

      # Or pure default bar colors (but still Kanagawa-like)
      # set -g status-style 'bg=default fg=default'
    '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-dir '~/.local/share/tmux/resurrect'
          set -g @resurrect-hook-post-save-all 'sed -i "s|/nix/store/[a-z0-9]*-[^/]*/bin/||g" ~/.local/share/tmux/resurrect/last'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      yank
      kanagawa
      prefix-highlight
    ];
  };

  xdg.dataFile = {
    "applications/proton.desktop".text = ''
      [Desktop Entry]
      Version=1.1
      Name=ProtonVPN
      Comment=ProtonVPN GUI (using nixGL)
      Exec=/bin/sh -c "nixGL protonvpn-app"
      Terminal=false
      Type=Application
      StartupNotify=true
      NoDisplay=false
    '';

    "applications/alacritty.desktop".text = ''
      [Desktop Entry]
      Version=1.1
      Name=Alacritty
      Comment=Alacritty Terminal Emulator (nixGL)
      Exec=/bin/sh -c "nixGL alacritty"
      Icon=Alacritty
      Terminal=false
      Type=Application
      Categories=Utility;TerminalEmulator;
      StartupNotify=true
      NoDisplay=false
    '';

    "applications/obsidian.desktop".text = ''
      [Desktop Entry]
      Version=1.1
      Name=Obsidian
      Comment=Alacritty Terminal Emulator (nixGL)
      Exec=/bin/sh -c "nixGL obsidian"
      Icon=Obsidian
      Terminal=false
      Type=Application
      StartupNotify=true
      NoDisplay=false
    '';
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "melonSorbet";
        email = "kilicyunusemre678@gmail.com";
      };
    };
  };
  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
