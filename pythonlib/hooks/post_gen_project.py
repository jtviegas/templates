import sys
import os
import logging
import subprocess


print("********** POST GENERATION HOOK *************")

PYTHON_BINARY=os.getenv("PYTHON_3_12")
PYTHON_VERSION="3.12"

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

def install_uv():
  logger.info("[install_uv|in]")
  result = subprocess.run("curl -LsSf https://astral.sh/uv/install.sh | sh", shell=True, capture_output=True, text=True)
  logger.info(f"[install_uv|out] => {result}")
  return int(result.returncode)


def install_git_hooks():
  logger.info("[install_git_hooks|in]")
  result = subprocess.run("uv run pre-commit install --install-hooks", shell=True, capture_output=True, text=True)
  logger.info(f"[install_git_hooks|out] => {result}")
  return int(result.returncode)

def install_git_niceties():
  logger.info("[install_git_niceties|in]")
  result = subprocess.run("git config --global core.autocrlf false && git config core.autocrlf false", shell=True, capture_output=True, text=True)
  logger.info(f"[install_git_niceties|out] => {result}")
  return int(result.returncode)

def uv_sync():
  logger.info("[uv_sync|in]")
  result = subprocess.run("uv sync --group dev", shell=True, capture_output=True, text=True)
  logger.info(f"[uv_sync|out] => {result}")
  return int(result.returncode)


# ------- main section -------

def main():
    result = 0
    _do_git_init = '{{ cookiecutter.do_git_init }}'
    result += install_uv()
    if ('true' == _do_git_init):   
      _git_url = '{{ cookiecutter.git_url_parent }}' + "/" + '{{ cookiecutter.project_repo }}'  
      result += link_git_repo(_git_url)
      result += install_git_hooks()
      result += install_git_niceties()
    result += uv_sync()
    return result

if __name__ == '__main__':
    sys.exit(main())
