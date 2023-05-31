{ stdenv
}:

stdenv.mkDerivation rec {
    pname = "demos";
    version = "1.0.0";
    src = ../../demos;

    installPhase = ''
        mkdir -p $out
        cp -r $src/* $out
    '';

    dontUnpack = true;
    dontBuild = true;
}


