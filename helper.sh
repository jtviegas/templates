#!/usr/bin/env bash

# ===> COMMON SECTION START  ===>

# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob
# -------------------------------
this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi
parent_folder=$(dirname "$this_folder")

# -------------------------------
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

# <=== COMMON SECTION END  <===
# -------------------------------------

# =======>    MAIN SECTION    =======>

# ---------- LOCAL CONSTANTS ----------
TEST_LOCATION="/tmp/cookiecutter_templates_test"
if [ ! -d "$TEST_LOCATION" ]; then
  warn "we DON'T have test location: $TEST_LOCATION - creating it"
  mkdir "$TEST_LOCATION"
fi

# ---------- LOCAL FUNCTIONS ----------

# -------------------------------------
usage() {
  cat <<EOM
  usage:
  $(basename $0) { option }
    options:
      - build TEMPLATE_LOCATION             creates cookiecutter template
      - test TEMPLATE_LOCATION              tests the cookiecutter template unfolding and opens up vscode on it

EOM
  exit 1
}

debug "1: $1 2: $2 3: $3 4: $4 5: $5 6: $6 7: $7 8: $8 9: $9"

case "$1" in
  build)
    build_cookiecutter_template "$2"
    ;;
  test)
    test_cookiecutter_template "$2" "$TEST_LOCATION"
    ;;
  *)
    usage
    ;;
esac

debug "?: $?"