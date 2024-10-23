{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  jinja2,
  oslo-config,
  oslo-context,
  oslo-i18n,
  oslo-utils,
  stevedore,
  webob,
  debtcollector,
  statsd,
  bcrypt,
  eventlet,
  greenlet,
  oslo-concurrency,
  oslo-log,
  pastedeploy,
  routes,
  paste,
  yappi,
  stestr,
  oslotest,
}:

buildPythonPackage rec {
  pname = "oslo-middleware";
  version = "6.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.middleware";
    inherit version;
    hash = "sha256-mZWavluqbWNycw0eZ6V7Qp+3fHN+HAPciwAMyvI5TNQ=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    jinja2
    oslo-config
    oslo-context
    oslo-i18n
    oslo-utils
    stevedore
    webob
    debtcollector
    statsd
    bcrypt
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
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_middleware" ];

  # meta = with lib; {
  #   description = "Oslo Messaging library";
  #   homepage = "https://github.com/openstack/oslo.messaging";
  #   license = licenses.asl20;
  #   maintainers = teams.openstack.members;
  # };
}
