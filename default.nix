{
	fontconfig,
	pkgs,
}:
let
	bin = pkgs.runCommand "detected_fonts" {} ''
mkdir -p $out/bin

export FONTCONFIG_FILE=${fontconfig}

cat << EOF > $out/bin/svg-to-png
export FONTCONFIG_FILE=${fontconfig}
export PATH="${
	pkgs.lib.makeBinPath [
		pkgs.fontconfig
		pkgs.coreutils
	]
}"

: "\''${TMPDIR:=/tmp}"

${pkgs.landrun}/bin/landrun \
--env FONTCONFIG_FILE \
--env PATH --env TMPDIR --rox /nix --rwx \$TMPDIR --rwx /dev/random \
${pkgs.resvg}/bin/resvg \
--font-family "$(${pkgs.fontconfig}/bin/fc-match --format "%{family}" "")" \
--serif-family "$(${pkgs.fontconfig}/bin/fc-match --format "%{family}" "serif")" \
--sans-serif-family "$(${pkgs.fontconfig}/bin/fc-match --format "%{family}" "sans-serif")" \
--cursive-family "$(${pkgs.fontconfig}/bin/fc-match --format "%{family}" "cursive")" \
--fantasy-family "$(${pkgs.fontconfig}/bin/fc-match --format "%{family}" "fantasy")" \
--monospace-family "$(${pkgs.fontconfig}/bin/fc-match --format "%{family}" "monospace")" \
- -c \
"\$@"

EOF

chmod +x $out/bin/svg-to-png
		'';
in
	bin

