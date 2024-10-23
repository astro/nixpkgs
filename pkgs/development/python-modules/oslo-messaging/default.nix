{
  lib,
  buildPythonPackage,
  fetchPypi,
  alembic,
  oslo-i18n,
  oslotest,
  pbr,
  psycopg2,
  setuptools,
  sqlalchemy,
  stevedore,
  stestr,
  testresources,
  testscenarios,
  futurist,
  oslo-config,
  oslo-context,
  oslo-log,
  oslo-utils,
  oslo-serialization,
  oslo-service,
  debtcollector,
  cachetools,
  webob,
  pyyaml,
  amqp,
  kombu,
  oslo-middleware,
  oslo-metrics,
  pifpaf,
}:

buildPythonPackage rec {
  pname = "oslo-messaging";
  version = "14.9.0";
  # pyproject = true;
  format = "pyproject";

  src = fetchPypi {
    pname = "oslo.messaging";
    inherit version;
    hash = "sha256-PDF8ODWtwWDjSLjyGIUUUgX2/SggD1pML5bXKAMCdOQ=";
  };

  # postPatch = ''
  #   cat >pyproject.toml <<EOF
  #   [build-system]
  #   requires = ["setuptools", "wheel"]
  #   build-backend = "setuptools.build_meta"
  #   EOF
  # '';

  build-system = [ setuptools ];
  nativeBuildInputs = [ setuptools ];

  dependencies = [
    debtcollector
    pbr
    futurist
    oslo-config
    oslo-context
    oslo-log
    oslo-utils
    oslo-serialization
    oslo-service
    stevedore
    debtcollector
    cachetools
    webob
    pyyaml
    amqp
    kombu
    oslo-middleware
    oslo-metrics
    pifpaf
    setuptools
  ];

  nativeCheckInputs = [
    # oslo-context
    oslotest
    stestr
    # psycopg2
    # testresources
    # testscenarios
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_messaging" ];

  meta = with lib; {
    description = "Oslo Messaging library";
    homepage = "https://github.com/openstack/oslo.messaging";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
