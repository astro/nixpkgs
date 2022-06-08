{ config, lib, pkgs, ... }:
let
  cfg = config.services.authentik;
in
{
  options.services.authentik = with lib; {
    enable = mkEnableOption "authentik identity provider";

    secretKey = mkOption {
      type = types.str;
      description = "Secret key used for cookie signing and unique user IDs, don't change this after the first install.";
    };
    
    postgresql = {
      database = mkOption {
        type = types.str;
        default = "authentik";
      };

      user = mkOption {
        type = types.str;
        default = "authentik";
      };
    };

    redis = {
      name = mkOption {
        type = types.str;
        default = "authentik";
      };

      port = mkOption {
        type = types.int;
        default = 6379;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ cfg.postgresql.database ];
      ensureUsers = [ {
        name = cfg.postgresql.user;
        ensurePermissions."DATABASE ${cfg.postgresql.database}" = "ALL PRIVILEGES";
      } ];
    };
    services.redis.servers.${cfg.redis.name} = {
      enable = true;
      databases = 4;
      port = cfg.redis.port;
    };
    
    systemd.services =
      let
        serviceCommands = {
          server = "runserver";
          worker = "runworker";
        };
        mkService = name: {
          requires = [ "redis-${cfg.redis.name}.service" "postgresql.service" ];
          after = [ "redis-${cfg.redis.name}.service" "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];
          
          environment = {
            AUTHENTIK_POSTGRESQL__HOST = "/run/postgresql";
            AUTHENTIK_POSTGRESQL__NAME = cfg.postgresql.database;
            AUTHENTIK_POSTGRESQL__USER = cfg.postgresql.user;
            AUTHENTIK_REDIS__PORT = toString cfg.redis.port;
            AUTHENTIK_SECRET_KEY = cfg.secretKey;
          };
          serviceConfig = {
            ExecStart = "${pkgs.authentik}/bin/ak ${serviceCommands.${name}}";
            User = "authentik";
            Group = "authentik";
            DynamicUser = true;
            RuntimeDirectory = "authentik";
            RuntimeDirectoryMode = 0700;
            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          };
        };
      in {
        authentik-server = mkService "server";
        authentik-worker = mkService "worker";
      };
  };
}
