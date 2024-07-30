{ nodeHostName, nodeSecrets, config, ... }:

{
  sops = {  
    defaultSopsFile = "${nodeSecrets}/${nodeHostName}.yaml";
    validateSopsFiles = true;
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}