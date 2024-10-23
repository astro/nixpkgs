{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  eventlet,
  testscenarios,
  stestr,
  oslotest,
}:

buildPythonPackage rec {
  pname = "futurist";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "futurist";
    inherit version;
    hash = "sha256-ZCIBF5JBTDkijhFL7FSUMDqvBtzTNeT43U+Qf3ikH3k=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    eventlet
    testscenarios
  ];

  nativeCheckInputs = [
    stestr
    oslotest
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "futurist" ];

  # meta = with lib; {
  #   description = "Oslo Messaging library";
  #   homepage = "https://github.com/openstack/oslo.messaging";
  #   license = licenses.asl20;
  #   maintainers = teams.openstack.members;
  # };
}
