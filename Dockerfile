# Use .NET SDK 8.0 image as the base
FROM mcr.microsoft.com/dotnet/sdk:8.0

# Set working directory inside the container
WORKDIR /app

# Install Git to clone the user's repository (if needed)
RUN apt-get update && apt-get install -y git

# Copy the repository into the container (GitHub Actions will check out the user's repo into /github/workspace)
RUN dotnet restore **/*.csproj

# Restore dependencies (restore all projects in the repository)
RUN dotnet restore

# Build and pack all .NET projects into .nupkg files
RUN dotnet build --configuration Release
RUN dotnet pack --configuration Release -o /output

# Push the .nupkg files to NuGet
CMD ["sh", "-c", "dotnet nuget push /output/*.nupkg --api-key $INPUT_NUGET_API_KEY --source $INPUT_NUGET_SOURCE --skip-duplicate"]
