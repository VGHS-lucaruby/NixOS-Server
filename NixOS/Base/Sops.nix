{ nodeHostName, nodeSecrets, config, ... }:

{
  sops = {  
    defaultSopsFile = "${nodeSecrets}/${nodeHostName}.yaml";
    validateSopsFiles = true;
    gnupg.sshKeyPaths = [];
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # This is using an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };
    # secrets = {
    #   "Passwords/rcon" = {
    #     owner = "svcminecraft";
    #   };
    # };
  };
}