# Gunakan Node.js 14 Alpine sebagai base image (ringan dan cepat)
FROM node:14.21-alpine
# Tetapkan direktori kerja di dalam container
WORKDIR /app
# Salin file package.json dan package-lock.json untuk instalasi dependensi
COPY package*.json ./
# Instal dependensi aplikasi
RUN npm install --production
# Salin seluruh source code aplikasi ke dalam container
COPY . .
# Ekspos port 3000 agar container dapat menerima request HTTP
EXPOSE 3000
# Jalankan aplikasi saat container dimulai
CMD ["npm", "start"]
