{
  pkgs,
  inputs,
  ...
}:
# TODO
{
  services.nginx = {
    enable = true;
    # package = pkgs.nginx.override {openssl = pkgs.libressl;};
    package = pkgs.angieQuic.override {openssl = pkgs.libressl;};

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedZstdSettings = true;

    # lets be more picky on our ciphers and protocols
    sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
    sslProtocols = "TLSv1.3 TLSv1.2";

        commonHttpConfig = ''
      #real_ip_header CF-Connecting-IP;
      add_header 'Referrer-Policy' 'origin-when-cross-origin';
      add_header X-Frame-Options DENY;
      add_header X-Content-Type-Options nosniff;
    '';

    virtualHosts = {
      "sioodmy.dev" = {
        root = inputs.website;
        enableACME = true;
        locations."/" = {
        tryFiles = "$uri $uri.html $uri/ =404";
        extraConfig = ''
          if ($request_uri ~ ^/(.*)\.html$) {
            return 302 /$1;
          }
        '';
        };
        
        forceSSL = true;
      };
      "search.sioodmy.dev" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
        quic = true;
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "hello@sioodmy.dev";
  };

  networking.firewall = {
    allowedTCPPorts = [80 443];
  };
}
