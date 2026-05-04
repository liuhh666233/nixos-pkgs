{ lib, buildPythonPackage, fetchPypi, makeWrapper, pythonRelaxDepsHook,

# build-system
setuptools,

# dependencies
aiohttp, alembic, cachetools, click, cloudpickle, cryptography, databricks-sdk
, docker, fastapi, flask, flask-cors, gitpython, graphene, gunicorn, huey
, importlib-metadata, jinja2, markdown, matplotlib, numpy, opentelemetry-api
, opentelemetry-proto, opentelemetry-sdk, packaging, pandas, protobuf, pyarrow
, pydantic, python-dotenv, pyyaml, requests, scikit-learn, scipy, shap, skops
, sqlalchemy, sqlparse, uvicorn,

# tests
azure-core, azure-storage-blob, azure-storage-file, boto3, botocore, catboost
, datasets, google-cloud-storage, httpx, jwt, keras, langchain, librosa, moto
, opentelemetry-exporter-otlp, optuna, pyspark, pytestCheckHook
, pytorch-lightning, sentence-transformers, starlette, statsmodels, tensorflow
, torch, transformers, xgboost, }:

buildPythonPackage rec {
  pname = "mlflow";
  version = "3.11.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hOVMS+kbWyoZA5omc/5oix1zB87drMCK9R+N8FsZ7lY=";
  };

  nativeBuildInputs = [ makeWrapper pythonRelaxDepsHook ];

  pythonRemoveDeps = [ "mlflow-skinny" "mlflow-tracing" ];

  pythonRelaxDeps = [
    "cryptography"
    "gunicorn"
    "huey"
    "importlib_metadata"
    "packaging"
    "protobuf"
    "pytz"
    "pyarrow"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    alembic
    cachetools
    click
    cloudpickle
    cryptography
    databricks-sdk
    docker
    fastapi
    flask
    flask-cors
    gitpython
    graphene
    gunicorn
    huey
    importlib-metadata
    jinja2
    markdown
    matplotlib
    numpy
    opentelemetry-api
    opentelemetry-proto
    opentelemetry-sdk
    packaging
    pandas
    protobuf
    pyarrow
    pydantic
    python-dotenv
    pyyaml
    requests
    scikit-learn
    scipy
    shap
    skops
    sqlalchemy
    sqlparse
    uvicorn
  ];

  postInstall = ''
    wrapProgram $out/bin/mlflow --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  pythonImportsCheck = [ "mlflow" ];

  nativeCheckInputs = [
    aiohttp
    azure-core
    azure-storage-blob
    azure-storage-file
    boto3
    botocore
    catboost
    datasets
    google-cloud-storage
    httpx
    jwt
    keras
    langchain
    librosa
    moto
    opentelemetry-exporter-otlp
    optuna
    pydantic
    pyspark
    pytestCheckHook
    pytorch-lightning
    sentence-transformers
    shap
    starlette
    statsmodels
    tensorflow
    torch
    transformers
    xgboost
  ];

  disabledTestPaths = [
    "tests/autogen/test_autogen_autolog.py"
    "tests/diviner/test_diviner_model_export.py"
    "examples/sktime/test_sktime_model_export.py"
    "tests/fastai/test_fastai_autolog.py"
    "tests/fastai/test_fastai_model_export.py"
    "tests/spacy/test_spacy_model_export.py"
    "tests/gateway/providers/test_ai21labs.py"
    "tests/tensorflow/test_keras_model_export.py"
    "tests/tensorflow/test_keras_pyfunc_model_works_with_all_input_types.py"
    "tests/tensorflow/test_mlflow_callback.py"
  ];

  doCheck = false;

  meta = {
    description = "Open source platform for the machine learning lifecycle";
    mainProgram = "mlflow";
    homepage = "https://github.com/mlflow/mlflow";
    changelog =
      "https://github.com/mlflow/mlflow/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
