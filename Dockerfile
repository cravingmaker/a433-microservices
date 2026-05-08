# =============================================================================
# Dockerfile untuk Karsajobs Backend (Go)
# Kompilasi aplikasi Go menjadi binary siap jalan di container
# =============================================================================

# Base image Go 1.15 berbasis Alpine (ringan)
FROM golang:1.15-alpine

# Direktori kerja sesuai konvensi Go module path
WORKDIR /go/src/github.com/dicodingacademy/karsajobs

# Aktifkan Go modules (default off pada Go < 1.16)
ENV GO111MODULE=on

# Port default aplikasi
ENV APP_PORT=8080

# Salin file dependency dulu — memanfaatkan layer cache Docker
# (go mod download hanya diulang jika go.mod/go.sum berubah)
COPY go.mod .
COPY go.sum .

# Unduh semua dependency
RUN go mod download

# Salin seluruh kode sumber
COPY . .

# Build semua package dan simpan binary ke /build/
RUN mkdir /build && \
    go build -o /build/ ./...

# Ekspos port aplikasi
EXPOSE 8080

# Jalankan binary 'web' hasil build
CMD ["/build/web"]
