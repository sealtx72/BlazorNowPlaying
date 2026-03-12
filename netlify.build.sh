#!/usr/bin/env bash
set -e

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

# Install .NET 10 SDK (specify --version if you want an exact version)
./dotnet-install.sh --channel 10.0 --install-dir "$INSTALL_DIR"
popd >/dev/null

# Use the installed dotnet binary explicitly to avoid picking up a different system/global SDK
DOTNET_BIN="$INSTALL_DIR/dotnet"

# Show info for debugging in Netlify logs 
"$DOTNET_BIN" --info

# Ensure output dir exists (dotnet will create the wwwroot inside this).
mkdir -p "$OUTPUT_DIR"

# Restore and publish the specific project using the installed dotnet
"$DOTNET_BIN" restore "$PROJECT_PATH"
"$DOTNET_BIN" publish "$PROJECT_PATH" -c Release -o "$OUTPUT_DIR" --no-restore