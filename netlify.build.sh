#!/usr/bin/env bash
set -euo pipefail

# Where we'll install the runtime/sdk
INSTALL_DIR="$HOME/.dotnet"

pushd /tmp >/dev/null
wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh

# Install .NET 8 (modify channel if needed in the future)
./dotnet-install.sh --channel 10.0 --install-dir "$INSTALL_DIR"
popd >/dev/null

# Now we can publish (since we've installed .NET in this environment)
dotnet publish -c Release -o release

