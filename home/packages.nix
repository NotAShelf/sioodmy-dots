{pkgs, ...}: {
  nixpkgs.config.allowUnfree = false;
  home.packages = with pkgs; [
    (symlinkJoin {
      inherit (ledger-live-desktop) name;
      paths = [ledger-live-desktop];
      buildInputs = [makeWrapper];
      postBuild = "wrapProgram $out/bin/ledger-live-desktop --add-flags --use-gl=desktop";
    })
    anytype
    brave
    cargo-tauri
    mullvad
    gping
    dogdns
    ledger_agent
    caprine-bin
    pulseaudio
    onefetch
    thunderbird
    pfetch-rs
    qrcp
    nheko
    socat
    transmission-gtk
    wget
    python3
    catimg
    cached-nix-shell
    prismlauncher
    todo
    yt-dlp
    tdesktop
    hyperfine
    glow
    nmap
    unzip
    rsync
    gamemode
    ffmpeg
    gimp
    inkscape
    imagemagick
    bc
    bandwhich
    grex
    fd
    xh
    jq
    lm_sensors
    keepassxc
    dconf
  ];
}