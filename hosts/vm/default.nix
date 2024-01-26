{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda/";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "io";

  networking.
}
