# Yantra backend: tiny Node HTTP server (no npm dependencies).
FROM node:22-alpine

WORKDIR /app

COPY package.json server.js ./
RUN node --check server.js

# The frontend ships in its own image. To serve pages from this server too,
# mount them here (e.g. -v /path/to/Yantra_Frontend:/app/public:ro).
ENV HOST=0.0.0.0 \
    PORT=5500 \
    STATIC_ROOT=/app/public \
    NODE_ENV=production

EXPOSE 5500

# Run as the unprivileged "node" user that ships with the image.
USER node

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:5500/healthz || exit 1

CMD ["node", "server.js"]
