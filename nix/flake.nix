{
  description = "Sandbox global dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_22
          zig
          rustc
          cargo
          rustfmt
          clippy
          rust-analyzer
          pkg-config
          zoxide
          git
          neovim
          tmux
          ripgrep
          fd
          bat
          eza
          fzf
          jq
          yq
          python3
          pipx
        ];

        shellHook = ''
          export PATH="$HOME/.local/bin:$PATH"

          # zoxide init
          if command -v zoxide >/dev/null; then
          eval "$(zoxide init bash)"
          fi
        '';
      };
    };
}
