# Use the official .NET SDK 8.0 image
FROM mcr.microsoft.com/dotnet/sdk:8.0

# Set up the working directory
WORKDIR /app

# Copy entrypoint script
COPY publish.sh /publish.sh
RUN chmod +x /publish.sh

# Set the default command to run the entrypoint script
ENTRYPOINT ["/publish.sh"]
