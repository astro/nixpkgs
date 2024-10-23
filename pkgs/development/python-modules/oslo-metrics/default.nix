{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  oslo-utils,
  oslo-log,
  oslo-config,
  prometheus-client,
  stestr,
  oslotest,
}:

buildPythonPackage rec {
  pname = "oslo-metrics";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.metrics";
    inherit version;
    hash = "sha256-DIgYdXya0zqTwe2x4UKW+b9Ghr/h4OaEEydpQa/uoKU=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    oslo-utils
    oslo-log
    oslo-config
    prometheus-client
  ];

  nativeCheckInputs = [
    stestr
    oslotest
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_metrics" ];

  # meta = with lib; {
  #   description = "Oslo Messaging library";
  #   homepage = "https://github.com/openstack/oslo.messaging";
  #   license = licenses.asl20;
  #   maintainers = teams.openstack.members;
  # };
}
