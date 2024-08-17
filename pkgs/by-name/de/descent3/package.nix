{ lib, stdenv, fetchFromGitHub
, cmake, ninja
, ncurses, SDL2, SDL2_image, zlib
}:

stdenv.mkDerivation rec {
  pname = "descent3";
  version = "1.5.0";

  _src = /home/stephan/programs/descent3;
  src = fetchFromGitHub {
    owner = "DescentDevelopers";
    repo = "Descent3";
    rev = "v${version}";
    hash = "sha256-IjKtnAf0IGblZ7yd3qB0GVTQ3QZZ4lXpsCT/tl3fW4Y=";
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

  HOME = "${placeholder "out"}/share";

  cmakeFlags = [ "-DENABLE_LOGGER=ON" "-DD3_GAMEDIR=Descent3" ];
  cmakeBuildType="Debug";

  # error: boost::bad_format_string: format-string is ill-formed
  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    cp Descent3/Descent3 $out/bin/
  '';
}
