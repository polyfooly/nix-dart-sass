# Copyright 2020 Kyryl Vlasov
# SPDX-License-Identifier: MIT

{ pkgs ? import <nixpkgs> { }
, sha256 ? "9f4102b45fbeaaa0f24d302f85b6139c1db1871a2a31c24ec2ff79e43da007e4"
, version ? "1.24.4" }:

with pkgs;
self.stdenv.mkDerivation rec {
    name = "dart-sass-${version}";
    inherit version;
    system = "x86_64-linux";
    
    isExecutable = true;

    src = fetchurl {
        inherit sha256;
        url = builtins.concatStringsSep "/" [
            "https://github.com"
            "sass/dart-sass/releases/download"
            "${version}/dart-sass-${version}-linux-x64.tar.gz"
        ];
    };

    phases = "unpackPhase installPhase fixupPhase";

    fixupPhase = ''
        patchelf \
            --set-interpreter ${binutils.dynamicLinker} \
            $out/src/dart
    '';
    
    installPhase = ''
        mkdir -p $out/bin
        cp -r . $out
        ln -s $out/sass $out/bin/sass
    '';
}