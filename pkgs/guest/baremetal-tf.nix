{ stdenv
, fetchFromGitHub
, toolchain
}:

stdenv.mkDerivation rec {
    pname = "baremetal-tf";
    version = "1.0.0";
    platform = "qemu-aarch64-virt";

    src = ../../../.;

    nativeBuildInputs = [ toolchain]; #build time dependencies


    unpackPhase = ''
        mkdir -p $out
        cp -r $src/* $out
        #copy everything except bao-tests-firmware
        # rsync -r --exclude 'bao-tests-firmware' $src/ $out 
        cd $out
    '';

    buildPhase = ''
        export ARCH=aarch64
        export CROSS_COMPILE=aarch64-none-elf-
        #python3 ./codegen.py -dir ./tests -o ./bao-tests/src/bao_tests.c
        make PLATFORM=$platform BAO_TEST=1 SUITES=ABCD
    '';
    
    installPhase = ''
        mkdir -p $out/bin
        cp ./build/qemu-aarch64-virt/baremetal.bin $out/bin
    '';

}


