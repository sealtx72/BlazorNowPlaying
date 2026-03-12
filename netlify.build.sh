#!/usr/bin/env bash
set -euo pipefail

# Path to the project file (repo root)
PROJECT_PATH="./BlazorNowPlaying.csproj"

# Publish to ./release so dotnet publish will create ./release/wwwroot
OUTPUT_DIR="./release"

# Where we'll install the runtime/sdk
INSTALL_DIR="$HOME/.dotnet"

# Download + install dotnet in a known location
pushd /tmp >/dev/null
wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh

# Install .NET 10 SDK (use --version to pin an exact SDK if desired)
./dotnet-install.sh --channel 10.0 --install-dir "$INSTALL_DIR"
popd >/dev/null

# Use the installed dotnet binary explicitly (most robust on CI)
DOTNET_BIN="$INSTALL_DIR/dotnet"

# Ensure the installed dotnet is visible to subprocesses (optional)
export DOTNET_ROOT="$INSTALL_DIR"
export PATH="$INSTALL_DIR:$PATH"

# Debug output - helps verify which dotnet is used in Netlify logs
echo "DOTNET_BIN=$DOTNET_BIN"
"$DOTNET_BIN" --info

# Ensure output dir exists (dotnet will create the wwwroot inside this)
mkdir -p "$OUTPUT_DIR"

# Restore and publish using the explicit dotnet binary
"$DOTNET_BIN" restore "$PROJECT_PATH"
"$DOTNET_BIN" publish "$PROJECT_PATH" -c Release -o "$OUTPUT_DIR" --no-restore