{ lib, stdenv, fetchurl, python311Packages, openssl, openssh }:

let
  pythonPackages = python311Packages;

in
pythonPackages.buildPythonApplication rec {
  name = "nova-${version}";
  version = "30.0.0";
  namePrefix = "";

  PBR_VERSION = "${version}";

  src = fetchurl {
    url = "https://github.com/openstack/nova/archive/${version}.tar.gz";
    sha256 = "175n1znvmy8f5vqvabc2fa4qy8y17685z4gzpq8984mdsdnpv21w";
  };

  # otherwise migrate.cfg is not installed
  patchPhase = ''
    echo "graft nova" >> MANIFEST.in

    # remove transient error test, see http://hydra.nixos.org/build/40203534
    rm nova/tests/unit/compute/test_{shelve,compute_utils}.py
  '';

  # https://github.com/openstack/nova/blob/stable/liberty/requirements.txt
  propagatedBuildInputs = with pythonPackages; [
    pbr sqlalchemy decorator eventlet jinja2 lxml routes cryptography
    webob greenlet PasteDeploy paste prettytable netaddr
    netifaces paramiko Babel iso8601 jsonschema requests six
    stevedore websockify rfc3986 alembic psycopg2 pymysql

    # oslo components
    oslo-utils oslo-i18n oslo-config oslo-context
    oslo-log oslo-serialization oslo-db
    oslo-concurrency oslo-messaging

    # # clients
    # cinderclient neutronclient glanceclient
  ];

  buildInputs = with pythonPackages; [
    coverage fixtures mock subunit requests-mock pillow
    oslotest testrepository testresources testtools bandit
    pep8 openssl openssh
  ];

  postInstall = ''
    cp -prvd etc $out/etc

    # check all binaries don't crash
    for i in $out/bin/*; do
      case "$i" in
      *nova-dhcpbridge*)
         :
         ;;
      *nova-rootwrap*)
         :
         ;;
      *)
         $i --help
         ;;
      esac
    done
  '';

  meta = with lib; {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
