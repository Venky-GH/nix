# Nix
This repo contains the main flake app which I use to configure my MacBook.

## Apply/Install nix packages
```
darwin-rebuild switch --flake ~/.config/nix
```

## Main flake file path
```
~/.config/nix/flake.nix
```

## Search any package on nixpkgs repo
```
nix search nixpkgs {package-name}
```
#### Website - https://search.nixos.org/packages

## Install packages via nix
```
update "environment.systemPackages" array
```

## Install packages via brew
```
update "brews" array
```

## Install GUI applications via brew
```
update the "casks" array
```

## Install applications from App Store
```
update "masApps" dictionary
```

## Update packages installed by nix
```
cd /etc/nix-darwin
nix flake update
darwin-rebuild switch
```

## Change macOS settings
```
update "system.defaults"
```
#### https://daiderd.com/nix-darwin/manual/index.html

## Main References
#### Installing Nix and Nix Darwin: https://davi.sh/til/nix/nix-macos-setup/
#### Configuring nix: https://www.youtube.com/watch?v=Z8BL8mdzWHI
#### Others: https://mynixos.com

## Errors encountered and their fixes

### Error 1
```
Error: invalid option: --no-lock
```

### Fix 1
Run the following command (where flake.nix/flake.lock is present, i.e., ~/.config/nix). This updates flake.
```
nix flake update
```

### Error 2
```
error:
Failed assertions:
- The option definition 'services.nix-daemon.enable' in '<unknown-file>' no longer has any effect; please remove it.
nix-darwin now manages nix-daemon unconditionally when
'nix.enable' is on.
```

### Fix 2
Fix for this was to remove the following line from flake.nix

```
services.nix-daemon.enable = true;
```

## Cleanup commands

```
sudo nix-collect-garbage -d
brew cleanup
```