{ lib, stdenv, fetchFromGitHub
, cmake, ninja
, ncurses, SDL, SDL_image
# , pkgsi686Linux
}:

stdenv.mkDerivation {
  pname = "descent3";
  version = "unstable-2024-04-19";

  src = /home/stephan/programs/descent3;
  _src = fetchFromGitHub {
    owner = "kevinbentley";
    repo = "Descent3";
    rev = "99f86c5c1fb76da0a19ce6e9a0870fbc78dfe3fb";
    hash = "sha256-kPmuCb/In9LUvf0UAoELrLTZiemcWEaCHe5OTfiGV8w=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn -Wno-address-of-temporary ""
    substituteInPlace scripts/CMakeLists.txt \
      --replace-warn "IF(UNIX AND NOT APPLE)" "IF(NOT UNIX AND NOT APPLE)"
  '';

  nativeBuildInputs = [
    cmake ninja
  ];

  buildInputs = [ ncurses SDL SDL_image ];

  # LD_LIBRARY_PATH = lib.concatMapStringsSep ":" (lib: "${lib}/lib") (
  #   with pkgsi686Linux.xorg; [
  #     libX11.out libXext.out
  #   ]);

  HOME = "${placeholder "out"}/share";

  cmakeFlags = [ "-DD3_GAMEDIR=Descent3" ];
  cmakeBuildType="Debug";
  # ninjaFlags = [ "Descent3" ];

  # error: boost::bad_format_string: format-string is ill-formed
  hardeningDisable = [ "format" ];

  # preBuild = ''
  #   pwd
  #   ls -la ../scripts/hogutils
  #   ${pkgsi686Linux.glibc.bin}/bin/ldd ../scripts/hogutils/hogUtils-i686
  #   ../scripts/hogutils/hogUtils-i686 --help
  # '';
}
