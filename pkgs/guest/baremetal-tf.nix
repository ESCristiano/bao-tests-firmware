{ stdenv
, fetchFromGitHub
, toolchain
, python3
, python3Packages
, rsync
, platform
, list_tests
, list_suites
, bao-tests
, tests
}:

stdenv.mkDerivation rec {
    # Derivation to build the baremetal-guest to run the bao test framework
    # MUT: baremetal-guest
    pname = "baremetal-tf";
    version = "1.0.0";

    src = ../../../../.;

    nativeBuildInputs = [ toolchain]; #build time dependencies
    buildInputs = [python3 python3Packages.numpy rsync];

    unpackPhase = ''
        mkdir -p $out
        #copy everything except tests
        rsync -r --exclude 'tests' $src/ $out 
        cp -r ${bao-tests} $out/bao-tests
        cp -r ${tests} $out/tests
        cd $out
    '';

    buildPhase = ''
        echo "Platform: ${platform}"
        echo "Suites: ${list_suites}"
        echo "Testes: ${list_tests}"
        export ARCH=aarch64
        export CROSS_COMPILE=aarch64-none-elf-
        export TESTF_TESTS_DIR=$out/tests
        export TESTF_REPO_DIR=$out/bao-tests
        chmod -R u+w bao-tests #make sure we can write to bao-tests
        cd bao-tests
        python3 ./codegen.py -d $TESTF_TESTS_DIR -o $TESTF_REPO_DIR/src/testf_entry.c
        cd ..
        make PLATFORM=${platform} BAO_TEST=1 SUITES=${list_suites} TESTS=${list_tests}
    '';
    
    installPhase = ''
        mkdir -p $out/bin
        cp ./build/${platform}/baremetal.bin $out/bin
    '';
    
}