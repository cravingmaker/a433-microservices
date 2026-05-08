# 1. Gunakan base image Node.js versi 14 (LTS)
FROM node:14

# 2. Tentukan working directory di dalam container menjadi /app.
#    Semua perintah berikutnya akan dieksekusi relatif terhadap direktori ini.
WORKDIR /app

# 3. Salin seluruh source code dari host ke working directory (/app) di container.
#    Tanda titik pertama = sumber (direktori saat ini di host),
#    tanda titik kedua   = tujuan (working directory /app di container).
COPY . .

# 4. Tetapkan environment variables:
#    - NODE_ENV=production  → aplikasi berjalan dalam mode produksi
#    - DB_HOST=item-db      → hostname database mengarah ke service item-db
#                             (nama service yang didefinisikan di docker-compose.yml)
ENV NODE_ENV=production DB_HOST=item-db

# 5. Instal hanya dependensi produksi (--production) lalu build aset statis
#    aplikasi menggunakan npm run build.
#    Flag --unsafe-perm diperlukan agar skrip npm dapat berjalan sebagai root
#    di dalam container.
RUN npm install --production --unsafe-perm && npm run build

# 6. Ekspos port 8080 — port yang didengarkan oleh server aplikasi.
#    Ini bersifat dokumentasi; port mapping aktual dilakukan di docker-compose.yml.
EXPOSE 8080

# 7. Perintah default saat container diluncurkan: menjalankan server Node.js melalui npm start
CMD ["npm", "start"]
