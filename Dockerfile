# Use .NET SDK image
ARG DOTNET_VERSION=8.0
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION} AS build

# Set the working directory inside the container
WORKDIR /app

# Declare arguments for NuGet API Key and project file location
ARG NUGET_API_KEY
ARG PROJ_FILE_LOCATION

# Copy the entire project directory into the container
COPY ${PROJ_FILE_LOCATION} /app

# Debugging: Print .NET version and environment variables
RUN dotnet --version
RUN printenv

# Debugging: List files in the working directory
RUN ls -la

# Restore project dependencies
RUN dotnet restore

# Build the project
RUN dotnet build --configuration Release --no-restore

# Debugging: List files after the build
RUN ls -la

# Create a NuGet package
RUN dotnet pack --configuration Release --no-build --output ./nupkg

# Debugging: List files in the output directory
RUN ls -la ./nupkg

# Push the package to NuGet
ENTRYPOINT ["dotnet", "nuget", "push", "./nupkg/*.nupkg", "--api-key", "$NUGET_API_KEY", "--source", "https://api.nuget.org/v3/index.json"]
