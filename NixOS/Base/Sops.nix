{ nodename, config, nodename, ... }:

let
  secretspath = builtins.toString mysecrets;
in
{
  sops = {
    defaultSopsFile = "${secretspath}/${nodename}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/id_ed25519_${nodename}" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey=true;
    };

    secrets = {
      "SSHKeys/GitHub" = {
        path = "/etc/ssh/id_ed25519_ServerSecrets";
      };
      "$SSHKeys/Host" = {
        path = "/etc/ssh/id_ed25519_${nodename}";
      };
    };
  };
}