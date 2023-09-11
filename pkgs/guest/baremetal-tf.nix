{ stdenv
, fetchFromGitHub
, toolchain
, python3
, python3Packages
, rsync
, plat
, list_tests
, list_suites
}:

stdenv.mkDerivation rec {
    pname = "baremetal-tf";
    version = "1.0.0";

    src = ../../../.;

    nativeBuildInputs = [ toolchain]; #build time dependencies
    buildInputs = [python3 python3Packages.numpy rsync];

    unpackPhase = ''
        mkdir -p $out
        #copy everything except bao-tests-firmware
        rsync -r --exclude 'bao-tests-firmware' $src/ $out 
        cd $out
    '';

    buildPhase = ''
        echo "Platform: ${plat}"
        echo "Suites: ${list_suites}"
        echo "Testes: ${list_tests}"
        export ARCH=aarch64
        export CROSS_COMPILE=aarch64-none-elf-
        export TESTF_TESTS_DIR=$out/tests
        export TESTF_REPO_DIR=$out/bao-tests
        chmod -R u+w bao-tests #make sure we can write to bao-tests
        python3 codegen.py -dir $TESTF_TESTS_DIR -o $TESTF_REPO_DIR/src/testf_entry.c
        make PLATFORM=${plat} BAO_TEST=1 SUITES=${list_suites} TESTS=${list_tests}
    '';
    
    installPhase = ''
        mkdir -p $out/bin
        cp ./build/qemu-aarch64-virt/baremetal.bin $out/bin
    '';
    
}