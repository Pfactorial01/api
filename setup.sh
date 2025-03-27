#!/bin/bash

# Update package list and install dependencies
echo "Updating package list and installing dependencies..."
apt-get update && apt-get install -y \
  curl ffmpeg gcc git libsdl2-2.0-0 make meson ninja-build pkg-config \
  libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev libsdl2-dev \
  libswresample-dev libusb-1.0-0 libusb-1.0-0-dev wget && \
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get install -y nodejs xvfb && \
  rm -rf /var/lib/apt/lists/*

# Install pm2 globally
echo "Installing pm2 globally..."
npm install -g pm2

# Clone and install scrcpy
echo "Cloning and installing scrcpy..."
git clone https://github.com/Genymobile/scrcpy && \
cd scrcpy && \
sed -i 's/sudo //g' install_release.sh && \
./install_release.sh && \
cd .. && \
rm -rf scrcpy

# Create .env file with the specified values
echo "Creating .env file..."
cat <<EOL > .env
PORT=3005
MONGO_URI=mongodb://100.77.145.14:27017
JWT_SECRET=secret
JWT_EXPIRATION=60d
EOL

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install --force

# Build the application
echo "Building the application..."
npm run build

# Start the application using pm2
echo "Starting the application with pm2..."
pm2 start dist/main.js --name "adb_api"

echo "Setup complete!"
