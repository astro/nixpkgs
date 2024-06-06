{ lib, stdenv, fetchFromGitHub
, cmake, ninja
, ncurses, SDL2, SDL2_image, zlib
# , pkgsi686Linux
}:

stdenv.mkDerivation {
  pname = "descent3";
  version = "unstable-2024-04-28";

  _src = /home/stephan/programs/descent3;
  src = fetchFromGitHub {
    owner = "DescentDevelopers";
    repo = "Descent3";
    rev = "fd615490803d08f46a407ce697e741f697519125";
    hash = "sha256-6tjWfsJE/L+wS9/JBUnGNZ7vyITyEr9IvZbVtjkT6yc=";
  };

  _postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn -Wno-address-of-temporary ""
    substituteInPlace scripts/CMakeLists.txt \
      --replace-warn "IF(UNIX AND NOT APPLE)" "IF(NOT UNIX AND NOT APPLE)"
  '';

  nativeBuildInputs = [
    cmake ninja
  ];

  buildInputs = [ ncurses SDL2 SDL2_image zlib ];

  # LD_LIBRARY_PATH = lib.concatMapStringsSep ":" (lib: "${lib}/lib") (
  #   with pkgsi686Linux.xorg; [
  #     libX11.out libXext.out
  #   ]);

  HOME = "${placeholder "out"}/share";

  cmakeFlags = [ "-DD3_GAMEDIR=Descent3" ];
  #cmakeBuildType="Debug";
  # ninjaFlags = [ "Descent3" ];

  # error: boost::bad_format_string: format-string is ill-formed
  hardeningDisable = [ "format" ];

  # preBuild = ''
  #   pwd
  #   ls -la ../scripts/hogutils
  #   ${pkgsi686Linux.glibc.bin}/bin/ldd ../scripts/hogutils/hogUtils-i686
  #   ../scripts/hogutils/hogUtils-i686 --help
  # '';
  installPhase = ''
    mkdir -p $out/bin
    cp Descent3/Descent3 $out/bin/
  '';
}
