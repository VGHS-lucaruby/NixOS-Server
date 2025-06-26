{ nodeHostName, config, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
    # Only generate Ed2559 key
    # Todo: Split key for git and sops into seperate keys. 
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
  programs.ssh = {
    extraConfig = "
    Host github.com
      IdentitiesOnly Yes
      IdentityFile /etc/ssh/ssh_host_ed25519_key
    ";
    knownHosts = {
      "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };
}
