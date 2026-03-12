#!/usr/bin/env bash
set -e

# Path to the project file (repo root)
PROJECT_PATH="./BlazorNowPlaying.csproj"
OUTPUT_DIR="./release/wwwroot"

# Change into a temporary directory so we can download + install .NET
pushd /tmp

# Download Microsoft install script
wget https://dot.net/v1/dotnet-install.sh

# Make the script executable
chmod +x ./dotnet-install.sh

# Install .NET 10 (modify channel if needed in the future)
./dotnet-install.sh --channel 10.0

# Return to project directory
popd

# Ensure output dir exists
mkdir -p "$OUTPUT_DIR"

# Restore and publish the specific project
dotnet restore "$PROJECT_PATH"
dotnet publish "$PROJECT_PATH" -c Release -o "$OUTPUT_DIR" --no-restore