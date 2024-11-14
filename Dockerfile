# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:8.0

# Set up the working directory
WORKDIR /app

# Copy the publish.sh script to the Docker image
COPY publish.sh /publish.sh
RUN chmod +x /publish.sh

# Set the default command to run the publish script
ENTRYPOINT ["/publish.sh"]
