{ nodeHostName, nodeSecrets, config, ... }:

{
  sops = {  
    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
    defaultSopsFile = "${nodeSecrets}/secrets.yaml";
    validateSopsFiles = true;
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_ed25519_${nodeHostName}" ];
      # This is using an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };

    secrets."SSHKeys/Host" = {
      owner = "root";
      path = "/etc/ssh/id_ed25519_${nodeHostName}";
    };
  };
}