let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };

	fontconfig = (import ./tests/default-fontconfig.nix {inherit pkgs;});

	svg_to_png = (import ./default.nix {inherit pkgs fontconfig;});

	test1 = pkgs.runCommand "test1.png" {} ''
mkdir -p $out

cat ${./tests/test1.svg} | ${svg_to_png}/bin/svg-to-png > $out/test1.png
	'';

	test1_white_background = pkgs.runCommand "test1_white_background" {} ''
mkdir -p $out

cat ${./tests/test1.svg} | ${svg_to_png}/bin/svg-to-png --background white > $out/test1_white_background.png
	'';

	test1_zoomed = pkgs.runCommand "test1_zoomed" {} ''
mkdir -p $out

cat ${./tests/test1.svg} | ${svg_to_png}/bin/svg-to-png --background white --zoom 2 > $out/test1_zoomed.png
	'';

in
	pkgs.symlinkJoin {
		name = "test";
		paths = [
			test1
			test1_white_background
			test1_zoomed
		];
	}

