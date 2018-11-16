with builtins.fromJSON (builtins.readFile ./easy-purescript-nix.git.json);
builtins.fetchGit { inherit url rev; }
