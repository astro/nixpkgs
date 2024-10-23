{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  stestr,
  webob,
  debtcollector,
  eventlet,
  greenlet,
  oslo-utils,
  oslo-concurrency,
  oslo-config,
  oslo-log,
  oslo-i18n,
  pastedeploy,
  routes,
  paste,
  yappi,
  oslotest,
  procps,
}:

buildPythonPackage rec {
  pname = "oslo-service";
  version = "3.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.service";
    inherit version;
    hash = "sha256-e0i6TfBDpMWKMANe45Z4FlGLBrTOsWwjxrJ2c7E30Jo=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    webob
    debtcollector
    eventlet
    greenlet
    oslo-utils
    oslo-concurrency
    oslo-config
    oslo-log
    oslo-i18n
    pastedeploy
    routes
    paste
    yappi
  ];

  nativeCheckInputs = [
    stestr
    oslotest
    procps
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_service" ];

  # meta = with lib; {
  #   description = "Oslo Messaging library";
  #   homepage = "https://github.com/openstack/oslo.messaging";
  #   license = licenses.asl20;
  #   maintainers = teams.openstack.members;
  # };
}
