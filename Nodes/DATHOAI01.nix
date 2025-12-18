{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.102";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  imports = [ ../NixOS/AI ];

  # Configure Modules
  modGraphics.enable = true;
  modRestic.enable = false;

  # Set VRAM to 20GB
  boot.kernelParams = [ 
    "amdgpu.gttsize=20480"
    "amdttm.pages_limit=5242880" 
    "amdttm.pagpage_pool_size=5242880"
  ];
}
