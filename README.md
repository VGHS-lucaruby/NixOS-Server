# NixOS-Server Dots (WIP)

## Creating Nodes
- Todo

## Secrets
- Todo

## Building Proxmox Images
Run the following build command in a location you would like the Proxmox VMA file to be placed:<br>
```nix build [Path To Cloned Repo]#[NodeName]```

***Ensure keys have been placed in the keyfile for each node.***

## Manual Update
Run the following command on the server you would like to update.<br>
```sudo nixos-rebuild switch -L --refresh --flake github:VGHS-lucaruby/NixOS-Server#$(hostname)```

## Deploying Proxmox Images
- Todo

## Credits
- **NixOS <3**
- **Minecraft Server Tool** [Nix-Minecraft](https://github.com/Infinidoge/nix-minecraft)
- **Server Image Creation** [astr0n8t nixos-gitops](https://github.com/astr0n8t/nixos-gitops) & [JustinLex's Comment](https://github.com/nix-community/nixos-generators/issues/193#issuecomment-1937095713)