import sys
import re



print("********** PRE GENERATION HOOK *************")


def validate_project_name(value):
    if not re.match(r"[a-zA-Z]+", value):
      print(
          "ERROR: The project_name must contain only alphanumeric characters (no spaces, dashes or special characters allowed)."
      )
      sys.exit(1)

def validate_project_namespace(value):
    if not re.match(r"[a-zA-Z]+", value):
      print(
          "ERROR: The project_namespace must contain only alphanumeric characters (no spaces, dashes or special characters allowed)."
      )
      sys.exit(1)

def validate_do_git_init(value):
    if value not in ['true', 'false']:
      print(
          "ERROR: The `do_git_init` value must be 'true' or 'false'"
      )
      sys.exit(1)

def validate_percentage(value):
    try:
        percentage = int(value)
        if not(0 <= percentage <= 100):
            print("ERROR: The value must be a valid integer lower than or equal to 100.")
            sys.exit(1)
    except ValueError:
        print("ERROR: The value must be a valid integer lower than or equal to 100.")
        sys.exit(1)


# ------- main section -------


def main():
    validate_project_namespace('{{ cookiecutter.project_namespace }}')
    validate_project_name('{{ cookiecutter.project_name }}')
    validate_do_git_init('{{ cookiecutter.do_git_init }}')
    validate_percentage('{{ cookiecutter.unit_test_coverage }}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
