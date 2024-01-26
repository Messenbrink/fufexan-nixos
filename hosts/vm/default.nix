{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda/";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "io";

  networking.
}
