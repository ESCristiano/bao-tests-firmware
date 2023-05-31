{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
    sha256 = "sha256:11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  }) {}
}:

with pkgs;

let
  packages = rec {
    # conf = callPackage ./pkgs/config/config.nix { };
    aarch64-none-elf = callPackage ./pkgs/toolchains/aarch64-none-elf-11-3.nix {};
    demos = callPackage ./pkgs/demos/demos.nix {};
    baremetal = callPackage ./pkgs/guest/baremetal-guest.nix {toolchain = aarch64-none-elf; };
    bao = callPackage ./pkgs/bao/bao.nix { toolchain = aarch64-none-elf; guest = baremetal; inherit demos;};
    u-boot = callPackage ./pkgs/u-boot/u-boot.nix { toolchain = aarch64-none-elf; };
    atf = callPackage ./pkgs/atf/atf.nix { toolchain = aarch64-none-elf; inherit u-boot; };

    inherit pkgs; # similar to `pkgs = pkgs;` This lets callers use the nixpkgs version defined in this file.
  };
in
  packages


