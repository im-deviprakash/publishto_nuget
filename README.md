# .NET NuGet Publisher Action with Docker

A GitHub Action for building, packaging, and publishing a .NET library to NuGet, all within a Docker environment. This action automates your .NET package release process directly from GitHub workflows.

## Features

- **Builds** your .NET project using Docker for consistent builds.
- **Packages** the project as a NuGet package, ready for distribution.
- **Publishes** the package to NuGet with a specified version or the version defined in your `.csproj` file.

## Inputs

| Input           | Required | Description                                                                                               | Default       |
|-----------------|----------|-----------------------------------------------------------------------------------------------------------|---------------|
| `NUGET_API_KEY` | Yes      | The NuGet API key used to publish the package. Use GitHub Secrets for security.                           | N/A           |
| `PROJECT_PATH`  | No       | Path to the `.csproj` file of the .NET project. If omitted, it defaults to the root directory.            | `./`          |
| `VERSION`       | No       | Version number for the package. If not provided, the version from the `.csproj` file is used.             | Version in `.csproj` |

## Example Usage

To set up the action in your workflow, use the following configuration. This example triggers the action on any push to the `main` branch.

```yaml
name: Publish .NET Package

on:
  push:
    branches:
      - main

jobs:
  publish:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Publish to NuGet
        uses: YourUsername/dotnet-nuget-publisher-action@v1
        with:
          NUGET_API_KEY: ${{ secrets.NUGET_API_KEY }}
          PROJECT_PATH: "./src/MyProject/MyProject.csproj" # optional
          VERSION: "1.0.0" # optional, omit to use version in .csproj
