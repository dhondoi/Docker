```dockerfile
# ==========================================
# STAGE 1: Build & Dependencies
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Salin manifes dependensi terlebih dahulu demi caching
COPY package*.json ./

# Install dependensi lengkap untuk build
RUN npm ci

# Salin sisa source code
COPY . .

# Jalankan proses kompilasi/build
RUN npm run build

# ==========================================
# STAGE 2: Production Runtime
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

# Set environment variable ke produksi
ENV NODE_ENV=production

# Buat non-root user demi keamanan
RUN addgroup -S nodejs && adduser -S nextjs -G nodejs

# Hanya salin artefak yang dibutuhkan dari stage builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Beralih ke non-root user
USER nextjs

# Dokumentasi Port & Healthcheck
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1

# Jalankan aplikasi
CMD ["node", "server.js"]
```
