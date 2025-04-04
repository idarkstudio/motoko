# This file is used by .github/workflows/release.yaml
# to create the files to be uploaded

# It imports default.nix both for linux and darwin, thus it cannot be part of
# it.
{ officialRelease ? false }:
let
  nixpkgs = import ./nix { };
  linux = import ./default.nix { system = "x86_64-linux"; inherit officialRelease; };
  linuxArm = import ./default.nix { system = "aarch64-linux"; inherit officialRelease; };
  darwin = import ./default.nix { system = "x86_64-darwin"; inherit officialRelease; };
  darwinArm = import ./default.nix { system = "aarch64-darwin"; inherit officialRelease; };

  releaseVersion = import nix/releaseVersion.nix { pkgs = nixpkgs; inherit officialRelease; };

  as_tarball = dir: derivations:
    nixpkgs.runCommandNoCC "motoko-${releaseVersion}.tar.gz" {
      allowedRequisites = [];
    } ''
      tmp=$(mktemp -d)
      ${nixpkgs.lib.concatMapStringsSep "\n" (d: "cp -v ${d}/bin/* $tmp") derivations}
      chmod 0755 $tmp/*
      tar -czf "$out" -C $tmp/ .
    '';

  as_js = name: derivation:
    nixpkgs.runCommandNoCC "${name}-${releaseVersion}.js" {
      allowedRequisites = [];
    } ''
      cp -v ${derivation}/bin/*.min.js $out
    '';

  release =
    nixpkgs.runCommandNoCC "motoko-release-${releaseVersion}" {} ''
      mkdir $out
      cp ${as_tarball "x86_64-linux" (with linux; [ mo-ide mo-doc moc ])} $out/motoko-Linux-x86_64-${releaseVersion}.tar.gz
      cp ${as_tarball "aarch64-linux" (with linuxArm; [ mo-ide mo-doc moc ])} $out/motoko-Linux-aarch64-${releaseVersion}.tar.gz
      cp ${as_tarball "x86_64-darwin" (with darwin; [ mo-ide mo-doc moc ])} $out/motoko-Darwin-x86_64-${releaseVersion}.tar.gz
      cp ${as_tarball "aarch64-darwin" (with darwinArm; [ mo-ide mo-doc moc ])} $out/motoko-Darwin-arm64-${releaseVersion}.tar.gz

      cp ${as_js "moc" linux.js.moc} $out/moc-${releaseVersion}.js
      cp ${as_js "moc-interpreter" linux.js.moc_interpreter} $out/moc-interpreter-${releaseVersion}.js
      tar --exclude=.github -C ${nixpkgs.sources.motoko-base} -czvf $out/motoko-base-library.tar.gz .
    '';
in
release
