#!/usr/bin/env bash

# ===> HEADER SECTION START  ===>

# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob
# -------------------------------
this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi
parent_folder=$(dirname "$this_folder")

# -------------------------------
# --- required functions
debug(){
    local __msg="$1"
    echo " [DEBUG] `date` ... $__msg "
}

info(){
    local __msg="$1"
    echo " [INFO]  `date` ->>> $__msg "
}

warn(){
    local __msg="$1"
    echo " [WARN]  `date` *** $__msg "
}

err(){
    local __msg="$1"
    echo " [ERR]   `date` !!! $__msg "
}

file_age_days() {
  local file="$1"
  local file_time
  local current_time

  if [[ "$OSTYPE" == "darwin"* ]]; then
      file_time=$(stat -f %m "$file")
  else
      file_time=$(stat -c %Y "$file")
  fi

  current_time=$(date +%s)
  echo $(( (current_time - file_time) / 86400 ))
}

# ---------- CONSTANTS ----------
export FILE_VARIABLES=${FILE_VARIABLES:-".variables"}
export FILE_LOCAL_VARIABLES=${FILE_LOCAL_VARIABLES:-".local_variables"}
export FILE_SECRETS=${FILE_SECRETS:-".secrets"}
export INCLUDE_FILE=".bashutils"

# -------------------------------
# --- source variables files
if [ ! -f "$this_folder/$FILE_VARIABLES" ]; then
  warn "we DON'T have a $FILE_VARIABLES variables file - creating it"
  touch "$this_folder/$FILE_VARIABLES"
else
  . "$this_folder/$FILE_VARIABLES"
fi

if [ ! -f "$this_folder/$FILE_LOCAL_VARIABLES" ]; then
  warn "we DON'T have a $FILE_LOCAL_VARIABLES variables file - creating it"
  touch "$this_folder/$FILE_LOCAL_VARIABLES"
else
  . "$this_folder/$FILE_LOCAL_VARIABLES"
fi

if [ ! -f "$this_folder/$FILE_SECRETS" ]; then
  warn "we DON'T have a $FILE_SECRETS secrets file - creating it"
  touch "$this_folder/$FILE_SECRETS"
else
  . "$this_folder/$FILE_SECRETS"
fi

# ---------- include bashutils ----------
# --- refresh file if older than 1 day
bashutils="$this_folder/$INCLUDE_FILE"
[ $(file_age_days "$bashutils") -gt 1 ] && \
  curl -sf https://raw.githubusercontent.com/jtviegas/bashutils/master/.bashutils -o "${bashutils}.tmp" && \
  mv "${bashutils}.tmp" "$bashutils"
# --- source it
. $bashutils

# <=== HEADER SECTION END  <===


# ===> MAIN SECTION    ===>

install_qa_libs(){
  info "[install_qa_libs|in]"
  _pwd=`pwd`
  cd "$this_folder"

  pip install bandit==1.8.3 safety==3.5.1 "typer<0.17.0"
  local result="$?"
  if [ ! "$result" -eq "0" ] ; then err "[install_qa_libs] could not install dependencies"; fi

  cd "$_pwd"
  local msg="[install_qa_libs|out] => ${result}"
  [[ ! "$result" -eq "0" ]] && info "$msg" && exit 1
  info "$msg"
}

uninstall_qa_libs(){
  info "[uninstall_qa_libs|in]"
  _pwd=`pwd`
  cd "$this_folder"

  pip uninstall -y bandit safety typer
  local result="$?"
  if [ ! "$result" -eq "0" ] ; then err "[uninstall_qa_libs] could not install dependencies"; fi

  cd "$_pwd"
  local msg="[uninstall_qa_libs|out] => ${result}"
  [[ ! "$result" -eq "0" ]] && info "$msg" && exit 1
  info "$msg"
}

# <=== MAIN SECTION END  <===


# ===> FOOTER SECTION START  ===>

usage() {
  cat <<EOM
  usage:
  $(basename $0) { option }
    options:
      - install_qa_libs                  installs QA requirements (bandit, safety)
      - uninstall_qa_libs                uninstalls QA requirements (bandit, safety)
      - reqs                              installs development requirements
      - linter_check                      runs code lint and format check
      - sast_check                        runs static application security tests (SAST) check
      - sca_check                         runs software component analysis (SCA) check
      - test [<test_folder>]              runs unit tests
      - test_coverage                     prints test coverage report
      - test_coverage_check <threshold>   checks coverage against a threshold
      - build                             builds the package
      - publish                           publishes the package
      - tag <VERSION> <COMMIT_HASH>       tags a specific commit with the version and pushes it to the remote
      - get_latest_tag
EOM
  exit 1
}


case "$1" in
  install_qa_libs)
    install_qa_libs
    ;;
  uninstall_qa_libs)
    uninstall_qa_libs
    ;;
  reqs)
    poetry_reqs
    ;;
  linter_check)
    lint_check_ruff
    ;;
  sast_check)
    sast_check_bandit "$this_folder/src"
    ;;
  sca_check)
    sca_check_safety "$SAFETY_KEY"
    ;;
  test)
    FOLDER="$this_folder/tests"
    [[ ! -z $2 ]] && FOLDER="$2"
    poetry_pytest_unit "$FOLDER" "$this_folder/src"
    ;;
  test_coverage)
    python_poetry_print_coverage
    ;;
  test_coverage_check)
    python_poetry_check_coverage "$2"
    ;;
  build)
    poetry_build
    ;;
  publish)
    poetry_publish_pip "$PYPI_USER" "$PYPI_API_TOKEN"
    ;;
  tag)
    git_tag_and_push "$2" "$3"
    ;;
  get_latest_tag)
    get_latest_tag
    ;;
  *)
    usage
    ;;
esac

# <=== FOOTER SECTION END  <===