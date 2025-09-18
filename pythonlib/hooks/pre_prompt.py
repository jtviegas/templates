import sys
import subprocess


print("********** PRE PROMPT HOOK *************")
    
def is_vscode_installed() -> bool:
    try:
        subprocess.run(["code", "-v"], capture_output=True, check=True)
        return True
    except Exception:
        return False

# ------- main section -------

def main():
    if not is_vscode_installed():
        print("ERROR: Visual Studio Code is not installed. Please install VS Code.")
        #return 1
    return 0

if __name__ == "__main__":
    sys.exit(main())
