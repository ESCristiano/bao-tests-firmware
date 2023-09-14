{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
    pname = "bao-tests";
    version = "1.0.0";

    # src = fetchFromGitHub {
    #     owner = "bao-project";
    #     repo = "bao-tests";
    #     rev = "a88f836452a0c586f2449df0be4df7ff82263677"; # branch: master
    #     sha256 = "sha256-SxiDN0ouIZm5gCI4AoA2xPPHO+t/NHcgIbHBn7rrIek=";
    # };

    src = fetchFromGitHub {
        owner = "bao-project";
        repo = "bao-tests";
        rev = "eeb3aab17ee00bd19828f2f3a6c20d443353ea90"; # branch: fix template
        sha256 = "sha256-gX/d2dIHqRNvV9PriG9ZnDoezxXVgpx6nlE3odPwLAg=";
    };

    dontBuild = true;
    
    installPhase = ''
        mkdir -p $out
        cp -r $src/* $out
    '';

}


