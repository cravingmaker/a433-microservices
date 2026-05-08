# =============================================================================
# Stage 1: Builder — Install dependency dan build aplikasi Vue.js
# =============================================================================
FROM node:14.21-alpine AS builder

# Direktori kerja di dalam container
WORKDIR /app

# Salin file manifest dependency terlebih dahulu untuk memanfaatkan layer cache
# (layer npm install hanya diulang jika package.json/package-lock.json berubah)
COPY package*.json ./

# Install semua dependency
RUN npm install

# Salin seluruh kode sumber
COPY . .

# Build untuk production — output ke /app/dist
RUN npm run build

# =============================================================================
# Stage 2: Production — Sajikan file statis dengan Nginx
# =============================================================================
FROM nginx:1.25-alpine

# Salin hasil build dari stage sebelumnya ke direktori root Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Ekspos port default Nginx
EXPOSE 80

# Jalankan Nginx di foreground
CMD ["nginx", "-g", "daemon off;"]
