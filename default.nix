let
  pkgs = import <nixpkgs> {};

  easy-ps = import (import ./nix/easy-purescript-nix.nix);

  inputs = {
    inherit (easy-ps.inputs)
    purs
    psc-package-simple
    psc-package2nix;
  };

in with pkgs; stdenv.mkDerivation {
  name = "spacchetti-react-basic-starter";

  buildInputs = builtins.attrValues inputs ++
  [ nodejs-10_x
    nodePackages_10_x.bower
    nodePackages.pulp
    yarn
    # npm2nix
    # yarn2nix
# use purs docs! (haskellPackages.ghcWithPackages (ps: [ ps.fast-tags ]))
  ];
}
