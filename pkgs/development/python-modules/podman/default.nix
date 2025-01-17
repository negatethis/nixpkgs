{ lib
, buildPythonPackage
, fetchFromGitHub
, fixtures
, pytestCheckHook
, pythonOlder
, pyxdg
, requests
, requests-mock
, rich
, setuptools
, tomli
, urllib3
}:

buildPythonPackage rec {
  pname = "podman";
  version = "4.8.0.post1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-d7rNXqYeeDHilzNc1jcIWq7rNcYZCvlf9ipu1m3oFfw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyxdg
    requests
    rich
    tomli
    urllib3
  ];

  nativeCheckInputs = [
    fixtures
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "podman"
  ];

  disabledTests = [
    # Integration tests require a running container setup
    "AdapterIntegrationTest"
    "ContainersIntegrationTest"
    "ImagesIntegrationTest"
    "ManifestsIntegrationTest"
    "NetworksIntegrationTest"
    "PodsIntegrationTest"
    "SecretsIntegrationTest"
    "SystemIntegrationTest"
    "VolumesIntegrationTest"
  ];

  meta = with lib; {
    description = "Python bindings for Podman's RESTful API";
    homepage = "https://github.com/containers/podman-py";
    changelog = "https://github.com/containers/podman-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "podman";
  };
}
