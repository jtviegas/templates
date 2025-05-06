# project templates

## requirements

- docker
- bash
- vscode
  - be sure to configure `code` in your PATH:
    - Open Visual Studio Code .
    - Open the Command Palette : Press Shift + Command + P (or go to the menu View > Command Palette ).
    - Type and select : Type Shell Command: Install 'code' command in PATH and select it. This action installs the code command in your shell's PATH.

## developing a template

- to build the template: `./helper.sh build <TEMPLATE_FOLDER>`
- to test the template (deploying it with default values and opening in VSCode): `./helper.sh test <TEMPLATE_FOLDER>`

## templates

### dev_env

sets up a linux (debian:bookworm) development environment with:
- python
- java 17
- helper.sh script
- zscaler root certificate authorities
- azure cli
- databricks cli
- databricks host env var
