{ stdenv, fetchFromGitHub, rustPlatform, lm_sensors }:

rustPlatform.buildRustPackage rec {
  name = "hegemon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = name;
    rev = "1bf76a700b5f66051a0d220a179819c4262871d4";
    sha256 = "1rcd883kg7vllsiy8lvkyan19z0bk453zx1nclz69ppfg919cazv";
  };

  cargoSha256 = "1rj969822ijdbmvab2fzi7g6ja8s021v36d5mr6x3i4hnaix789p";
  buildInputs = [ lm_sensors ];

  meta = with stdenv.lib; {
    description = "A system monitor with pretty scrolling graphs for the terminal";
    homepage = "https://github.com/p-e-w/hegemon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ astro ];
  };
}
