{ lib, buildPythonPackage, fetchFromGitHub, setuptools, setuptools-scm, cython
, numpy, pandas, mlflow, filelock, redis, dill, fire, ruamel-yaml
, python-redis-lock, tqdm, pymongo, loguru, lightgbm, gym, cvxpy, joblib
, matplotlib, jupyter, nbconvert, pyarrow, pydantic-settings, pyyaml }:

buildPythonPackage rec {
  pname = "pyqlib";
  version = "0.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "qlib";
    rev = "v${version}";
    hash = "sha256-1GBAMjFp5tD/tsduOGJVu5j/cPNMN76BY1WP8aDVP5s=";
  };

  build-system = [ setuptools setuptools-scm cython numpy ];

  dependencies = [
    pyyaml
    numpy
    pandas
    mlflow
    filelock
    redis
    dill
    fire
    ruamel-yaml
    python-redis-lock
    tqdm
    pymongo
    loguru
    lightgbm
    gym
    cvxpy
    joblib
    matplotlib
    jupyter
    nbconvert
    pyarrow
    pydantic-settings
  ];

  doCheck = false;
  pythonImportsCheck =
    [ "qlib" "qlib.data._libs.rolling" "qlib.data._libs.expanding" ];

  meta = with lib; {
    description =
      "AI-oriented quant investment platform for research and production";
    homepage = "https://qlib.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
