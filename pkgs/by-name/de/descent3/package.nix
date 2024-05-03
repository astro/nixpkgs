{ lib, stdenv, fetchFromGitHub
, cmake, ninja
, ncurses, SDL, SDL_image, zlib
# , pkgsi686Linux
}:

stdenv.mkDerivation {
  pname = "descent3";
  version = "unstable-2024-04-28";

  _src = /home/stephan/programs/descent3;
  src = fetchFromGitHub {
    owner = "DescentDevelopers";
    repo = "Descent3";
    rev = "7cd46b7b52b07f2d94b9b50fa1b6efdc3c2a4512";
    hash = "sha256-LieLXtk/iBEM05eijxc9q+OtDhKEXGbaHzapTytVFBg=";
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

  buildInputs = [ ncurses SDL SDL_image zlib ];

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
