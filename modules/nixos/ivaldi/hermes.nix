{ inputs, ... }:

{
  config.nixos.ivaldi = {
    containers.hermes = {
      autoStart = true;
      privateNetwork = true;
      privateUsers = "pick";
      macvlans = [ "enp1s0" ];

      config =
        { lib, ... }:
        {
          imports = [ inputs.hermes-agent.nixosModules.default ];

          system.stateVersion = "26.05";

          networking.useHostResolvConf = lib.mkForce false;
          networking.interfaces.mv-enp1s0.useDHCP = true;
          networking.firewall.interfaces.mv-enp1s0.allowedTCPPorts = [ 9120 ];

          services.hermes-agent = {
            enable = true;
            addToSystemPackages = true;
            environmentFiles = [ "/var/lib/hermes-secrets/env" ];
            settings.webapp = {
              enabled = true;
              host = "0.0.0.0";
              port = 9120;
            };
          };
        };
    };

    systemd.services."container@hermes".serviceConfig.MemoryMax = "4G";
  };
}
