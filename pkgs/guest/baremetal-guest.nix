{ stdenv
, fetchFromGitHub
, toolchain
}:

stdenv.mkDerivation rec {
    pname = "baremetal-guest";
    version = "1.0.0";
    platform = "qemu-aarch64-virt";

    src = fetchFromGitHub {
        owner = "bao-project";
        repo = "bao-baremetal-guest";
        rev = "4010db4ba5f71bae72d4ceaf4efa3219812c6b12"; # branch demo
        sha256 = "sha256-aiKraDtjv+n/cXtdYdNDKlbzOiBxYTDrMT8bdG9B9vU=";
    };

    nativeBuildInputs = [ toolchain]; #build time dependencies

    buildPhase = ''
        export ARCH=aarch64
        export CROSS_COMPILE=aarch64-none-elf-
        make PLATFORM=$platform
    '';
    
    installPhase = ''
        mkdir -p $out/bin
        cp ./build/qemu-aarch64-virt/baremetal.bin $out/bin
    '';

}


