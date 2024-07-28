{ nodeHostName, nodeSecrets, config, ... }:

{
  sops = {  
    defaultSopsFile = "${nodeSecrets}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/id_ed25519_${nodeHostName}" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey=true;
    };

    secrets = {
      "SSHKeys/GitHub" = {
        path = "/etc/ssh/id_ed25519_ServerSecrets";
      };
      "$SSHKeys/Host" = {
        path = "/etc/ssh/id_ed25519_${nodeHostName}";
      };
    };
  };
}