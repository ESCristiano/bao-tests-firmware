{ stdenv
, fetchFromGitHub
, toolchain
, bison
, flex
, openssl
}:

stdenv.mkDerivation rec {
    pname = "u-boot";
    version = "2022.10";

    src = fetchFromGitHub {
        owner = "u-boot";
        repo = "u-boot";
        rev = "v${version}"; 
        sha256 = "sha256-L6AXbJEDx+KoMvqBuJYyIyK2Xn2zyF21NH5mMNvygmM=";
    };

    nativeBuildInputs = [ toolchain bison flex openssl ];
    
    buildPhase = ''
        export CROSS_COMPILE=aarch64-none-elf-
        make qemu_arm64_defconfig
        echo "CONFIG_TFABOOT=y" >> .config
        echo "CONFIG_SYS_TEXT_BASE=0x60000000" >> .config
        make
    '';
    
    installPhase = ''
        mkdir -p $out/bin
        cp ./u-boot.bin $out/bin/
    '';

}


