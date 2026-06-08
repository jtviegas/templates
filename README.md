# templates

custom project templates


## requirements

- bash
- python's pipx
- vscode
  - be sure to configure `code` in your PATH (if not there yet):
    - Open Visual Studio Code .
    - Open the Command Palette : Press Shift + Command + P (or go to the menu View > Command Palette ).
    - Type and select : Type Shell Command: Install 'code' command in PATH and select it. This action installs the code command in your shell's PATH.

## developing a template

- to build a template: `./helper.sh build <TEMPLATE_FOLDER>`
- to test a template (deploying it with default values and opening in VSCode): `./helper.sh test <TEMPLATE_FOLDER>`

## templates

### pythonlib

A python package library with github actions pipeline with QA, test, build and publish steps

usage: 
- download the specific cookiecutter.zip file
- `pipx run cookiecutter cookiecutter.zip`
- `code ./<PROJECT_NAME_YOU_PROVIDED>`
