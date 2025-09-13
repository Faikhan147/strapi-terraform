# -----------------------------
# Stage 1: Build
# -----------------------------
FROM node:14-bullseye AS builder

# Install system dependencies for Sharp & Strapi
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    build-essential \
    git \
    curl \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies (Sharp compatible)
RUN npm install --legacy-peer-deps

# Force install Sharp to avoid build errors
RUN npm install sharp@0.29.3 --force --legacy-peer-deps

# Copy source code
COPY . .

# Build Strapi admin (optional but recommended for prod)
RUN npm run build

# -----------------------------
# Stage 2: Run
# -----------------------------
FROM node:14-bullseye

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libvips42 \
    libjpeg62-turbo \
    libpng16-16 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy node_modules and app from builder
COPY --from=builder /app /app

# Expose Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "start"]
