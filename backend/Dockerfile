# ------------------------
# Backend Service Dockerfile
# Multi-stage: builder → production runtime
# ------------------------

# ---------- Builder stage ----------
FROM node:20-alpine AS builder

# Create app directory
WORKDIR /app

# Copy only package manifests first for layer caching
COPY package*.json ./
# Install all deps (including dev) needed to build
RUN npm ci --ignore-scripts

# Copy source
COPY tsconfig.json ./
COPY src ./src

# Build TypeScript → dist
RUN npm run build

# ---------- Production stage ----------
FROM node:20-alpine AS prod

ENV NODE_ENV=production
WORKDIR /app

# Create non-root app user
RUN addgroup -S app && adduser -S app -G app

# Install only production deps
COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force;

# Copy compiled output from builder
COPY --from=builder /app/dist ./dist

# Copy any runtime assets if present (e.g., views/public etc.)
# COPY --from=builder /app/public ./public

# Environment variables expected at runtime
ENV BACKEND_PORT=3847

# Expose internal port (will stay internal to network)
EXPOSE 3847

# Healthcheck: ping health endpoint
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD wget -qO- http://localhost:3847/api/health || exit 1

# Run as non-root
USER app

CMD ["node", "dist/index.js"]
