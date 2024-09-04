# NixOS-Server Dots

## Creating Nodes
Copy ```NodeTemplate.nix``` inside the ```Nodes``` folder, renaming it the the name of the new Node.
Enter in the static IP address that the server will be using.
Add modules that will be run under this server and toggle any modules that are not required.

### Building Proxmox Images
On a device that has master access to the sercrets archive and is running NixOS, in an empty folder run the following:<br>
```nix build --show-trace ~/.BuildFiles/NixOS-Server#[NodeName]```<br>

Once completed, there will now be a ```result``` folder inside the previously blank folder.<br>
Inside this you will find a file called ```vzdump-qemu-[NodeName].vma.zst``` this, is your backup image that you can now deploy to your Proxmox server.

### Deploying Proxmox Images
Using SSH access to Proxmox copy the newly created backup image to ```/var/lib/vz/dump/``` Example command:<br>
```scp [Path to result folder]/vzdump-qemu-[nodename].vma.zst [username]@[Server Ip]:/var/lib/vz/dump/vzdump-qemu-[nodename].vma.zst```<br>
***File name must not be changed.***<br>

While the file has copies SSH into the Proxmox server and cd to ```/var/lib/vz/dump/```<br>
Once the copy has completed, run the following command to restore the backup image:<br>
```qmrestore /var/lib/vz/dump/vzdump-qemu-[NodeName].vma.zst [VM Id] --unique true```

Once this is completed, you should now see the VM in the Proxmox Web UI. You can now set CPU cores, memory, and resize the disk. 


### Post Deployment Node Configuration
- todo

## Secrets
Secrets are managed using Sops-Nix, they are stored in a secondary private repo and which is accessed using the hosts SSH key.

Each node has its own secrets file as well as an encryption key derived from the hosts SSH key

Secrets are imported into the flake.nix
```
...
mysecrets = {
  url = "git+ssh://git@github.com/VGHS-lucaruby/NixOS-Server-Secrets.git?shallow=1";
  flake = false;
};
...
```
It is then passed to the node using ```nodeSecrets = "${mysecrets}/Nodes";``` as a special argument. <br>
This is then referenced in ```sops.nix``` using the node name variable to select the node file to decrypt:<br>
```defaultSopsFile = "${nodeSecrets}/${nodeHostName}.yaml";```<br>
The SSH Key for decryption is all defined here with each node having the same naming.<br>(Note the SSH key is automatically genereated on first boot of the node)

Example file structure of the private sops repo:
```
Nodes:
- Node1.yaml
- Node2.yaml
.sops.yaml
```

***Once a secret has been updated in the private repo remember to update flake.lock, else the new secrets will not work!***

## Building Proxmox Images
Run the following build command in a location you would like the Proxmox VMA file to be placed:<br>
```nix build [Path To Cloned Repo]#[NodeName]```

***Ensure keys have been placed in the keyfile for each node.***

## Manual Update
Run the following command on the server you would like to update.<br>
```sudo nixos-rebuild switch -L --refresh --flake github:VGHS-lucaruby/NixOS-Server#$(hostname)```

## Credits
- **NixOS <3**
- **Minecraft Server Tool** [Nix-Minecraft](https://github.com/Infinidoge/nix-minecraft)
- **Server Image Creation** [astr0n8t nixos-gitops](https://github.com/astr0n8t/nixos-gitops) & [JustinLex's Comment](https://github.com/nix-community/nixos-generators/issues/193#issuecomment-1937095713)
- **Secrets Management** [Sops-Nix](https://github.com/Mic92/sops-nix)
- **Backups** [Restic](https://restic.net) & [Backblaze B2](https://www.backblaze.com/cloud-storage)