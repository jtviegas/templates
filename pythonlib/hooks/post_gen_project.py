import sys
import os
import logging
import subprocess


print("********** POST GENERATION HOOK *************")

PYTHON_BINARY=os.getenv("PYTHON_3_11")
PYTHON_VERSION="3.11"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def link_git_repo(git_url):
    logger.info(f"[link_git_repo|in] ({git_url})")
    result = 0
    result += os.system("git init")
    result += os.system(f"git remote add origin {git_url}")
    result += os.system("git remote -v")
    logger.info(f"[link_git_repo|out] => {result}")
    return result

# def create_python_env(python_bin):
#   logger.info(f"[create_python_env|in] ({python_bin})")
#   result = subprocess.run(f"{python_bin} -m venv .venv && source .venv/bin/activate", shell=True, capture_output=True, text=True)
#   logger.info(f"[create_python_env|out] => {result}")
#   return result

def install_poetry():
  logger.info("[install_poetry|in]")
  result = subprocess.run("curl -sSL https://install.python-poetry.org | python3 -", shell=True, capture_output=True, text=True)
  logger.info(f"[install_poetry|out] => {result}")
  
  return int(result.returncode)

def load_virtual_env():
  logger.info("[load_virtual_env|in]")
  logger.info(f"[load_virtual_env] => {os.getcwd()}")
  #result = subprocess.run(f"poetry env use python{PYTHON_VERSION}", shell=True, capture_output=True, text=True).returncode
  result = subprocess.run("poetry config virtualenvs.in-project true", shell=True, capture_output=True, text=True).returncode
  result += subprocess.run("poetry install", shell=True, capture_output=True, text=True).returncode
  logger.info(f"[load_virtual_env|out] => {result}")
  return int(result)

def install_git_hooks():
  logger.info("[install_git_hooks|in]")
  logger.info(f"[install_git_hooks] => {os.getcwd()}")
  result = subprocess.run("curl -sSL https://install.python-pre-commit.org | python3 -", shell=True, capture_output=True, text=True)
  logger.info(f"[install_git_hooks|out] => {result}")
  return int(result.returncode)

# ------- main section -------

def main():
    result = 0
    _git_url = '{{ cookiecutter.git_url_parent }}' + "/" + '{{ cookiecutter.project_repo }}'
    _do_git_init = '{{ cookiecutter.do_git_init }}'
    if ('true' == _do_git_init):     
       result += link_git_repo(_git_url)
    result += install_git_hooks()
    result += install_poetry()
    logger.info("DON'T FORGET TO RUN 'poetry install' to create the virtual environment")
    return result

if __name__ == '__main__':
    sys.exit(main())
