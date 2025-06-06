{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.git
          pkgs.pyenv
          pkgs.mkalias
        ];

      homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
          "logi-options+"
          "visual-studio-code"
          "whatsapp"
          "obs"
          "obsidian"
          "google-chrome"
          "dropbox"
          "cursor"
        ];
        masApps = {
          "Davinci Resolve" = 571213070;
          "Keepa - Price Tracker" = 1533805339;
          "Grammarly" = 1462114288;
          "AdGaurd" = 1440147259;
          "Microsoft OneNote" = 784801555;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/FaceTime.app"
          "/System/Applications/Music.app"
          "/System/Applications/Utilities/Terminal.app"
          "/Applications/Google Chrome.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Cursor.app"
          "/Applications/DaVinci Resolve.app"
          "/Applications/OBS.app"
          "/Applications/Obsidian.app"
          "/Applications/Microsoft OneNote.app"
        ];
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Venkateshs-MacBook-Pro
    darwinConfigurations."Venkateshs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the homebrew prefix
            user = "venkateshnaidu";
          };
        }
      ];
    };
  };
}