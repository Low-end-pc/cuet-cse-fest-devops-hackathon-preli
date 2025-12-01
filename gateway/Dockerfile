# ------------------------
# Gateway Service Dockerfile
# Multi-stage: builder → production runtime
# ------------------------

# -------- Builder stage --------
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package manifests first
COPY package*.json ./
RUN npm ci --ignore-scripts

# Copy source for potential lint/tests (none here but keeps pattern)
COPY src ./src

# -------- Production stage --------
FROM node:20-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production

# Non-root user for security
RUN addgroup -S app && adduser -S app -G app

# Install only production deps
COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force;

# Copy source code
COPY --from=builder /app/src ./src

# Set default envs
ENV GATEWAY_PORT=5921 \
    BACKEND_URL=http://backend:3847

EXPOSE 5921

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD wget -qO- http://localhost:5921/health || exit 1

USER app
CMD ["node", "src/gateway.js"]
