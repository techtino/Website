{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    hugo
  ];
  shellHook = ''
    git submodule update --init --recursive
  '';
}
