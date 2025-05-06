# Init pre-commit
# git config --global --add safe.directory /workspaces/NextGenSafety

# Install test and dev dependency groups on top of main (which is always included)
# poetry sync --with test,dev
# poetry run pre-commit install --install-hooks

# update bash helper script include file
chmod +x ./helper.sh
./helper.sh update

# Install certifi certificates to ensure Copilot works. Notice you might need to reload the window.
sudo update-ca-certificates

