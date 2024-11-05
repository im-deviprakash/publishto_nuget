#!/bin/bash

set -e

# Ensure required variables are set
if [ -z "$NUGET_API_KEY" ]; then
  echo "Error: NUGET_API_KEY is not set."
  exit 1
fi

# Set project path (default to current directory if not provided)
PROJECT_PATH=${PROJECT_PATH:-"./"}

# Check if VERSION is provided, else extract it from the .csproj file
if [ -z "$VERSION" ]; then
  VERSION=$(grep -oPm1 "(?<=<Version>)[^<]+" "$PROJECT_PATH")
  if [ -z "$VERSION" ]; then
    echo "Error: No version specified and could not find a <Version> tag in the .csproj file."
    exit 1
  else
    echo "Using version from .csproj: $VERSION"
  fi
else
  echo "Using provided version: $VERSION"
fi

# Restore, build, and pack the project
dotnet restore "$PROJECT_PATH"
dotnet build "$PROJECT_PATH" --configuration Release
dotnet pack "$PROJECT_PATH" --configuration Release -p:PackageVersion=$VERSION -o /app/output

# Publish the package to NuGet
dotnet nuget push /app/output/*.nupkg -k "$NUGET_API_KEY" -s https://api.nuget.org/v3/index.json
