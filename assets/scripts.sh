# 1. Install Docker & Git
sudo dnf install -y docker git
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user

# 2. Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 3. Create the docker-compose.yml file
# Run this, PASTE your clipboard content, then press Ctrl+D.
cat > docker-compose.yml

# 4. Create the .env file
# You MUST replace 'photoshare-assets-xxxx' with your actual bucket name.
cat <<EOF > .env
S3_BUCKET=photoshare-assets-xxxx
AWS_SECRET_NAME=photoshare/db/credentials
EOF

# 5. Run the application
sudo docker-compose up -d