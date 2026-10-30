FROM node:20-bookworm

# Update package manager
RUN apt-get update && apt-get upgrade -y

# Install FFmpeg with full codec support
RUN apt-get install -y \
    ffmpeg \
    fonts-dejavu-core \
    fontconfig \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Verify FFmpeg installation with codec check
RUN ffmpeg -version && \
    ffprobe -version && \
    echo "✓ FFmpeg installed at: $(which ffmpeg)" && \
    ffmpeg -codecs 2>/dev/null | grep -E "libx264|libvpx|libopus|aac" && \
    echo "✓ All required codecs available"

WORKDIR /app

# Install Node dependencies (npm install, NOT npm ci — no lock file needed)
COPY package*.json ./
RUN npm install --omit=dev

# Copy application code
COPY . .

# Create required directories with proper permissions
RUN mkdir -p uploads output temp && \
    chmod 777 uploads output temp

# Render can use /health as its service health check. This container check also
# respects Render's PORT when one is supplied, while keeping 8080 as a local default.
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD node -e "const http=require('http'); const port=process.env.PORT||8080; http.get('http://127.0.0.1:'+port+'/health', (r)=>{if(r.statusCode!==200) process.exit(1)}).on('error',()=>process.exit(1))"

EXPOSE 8080

CMD ["node", "index.js"]
