ARG DOTNET_VERSION=8.0
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION} AS build

WORKDIR /app

COPY . .

ARG NUGET_API_KEY

# Debugging: Print .NET version and environment variables
RUN dotnet --version
RUN printenv

# Debugging: List files in the working directory
RUN ls -la

RUN dotnet restore
RUN dotnet build --configuration Release --no-restore

# Debugging: List files after build
RUN ls -la

RUN dotnet pack --configuration Release --no-build --output ./nupkg

# Debugging: List files in the output directory
RUN ls -la ./nupkg

ENTRYPOINT ["dotnet", "nuget", "push", "./nupkg/*.nupkg", "--api-key", "$NUGET_API_KEY", "--source", "https://api.nuget.org/v3/index.json"]