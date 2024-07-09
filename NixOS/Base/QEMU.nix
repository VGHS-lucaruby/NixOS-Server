{ ... }:

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix";
  ];
  
  virtualisation.qemu.guestAgent.enable = true;

}