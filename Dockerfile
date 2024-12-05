# Use .NET SDK 8.0 image as the base
FROM mcr.microsoft.com/dotnet/sdk:8.0

# Set working directory inside the container
WORKDIR /app

# Install Git (needed for cloning repositories)
RUN apt-get update && apt-get install -y git

# Clone the user's repository into the container (replace with actual repository URL)
ARG REPO_URL
RUN git clone ${REPO_URL} /app/repo

# Set working directory to the cloned repo
WORKDIR /app/repo

# Restore dependencies for all .csproj files in the cloned repo
RUN dotnet restore **/*.csproj

# Build and pack all .NET projects into .nupkg files
RUN dotnet build --configuration Release **/*.csproj
RUN dotnet pack --configuration Release **/*.csproj -o /output

# Push the .nupkg files to NuGet
CMD ["sh", "-c", "dotnet nuget push /output/*.nupkg --api-key $INPUT_NUGET_API_KEY --source $INPUT_NUGET_SOURCE --skip-duplicate"]
