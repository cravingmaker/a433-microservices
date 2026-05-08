#!/bin/bash

GITHUB_USERNAME="cravingmaker"
IMAGE_NAME="karsajobs"
IMAGE_TAG="latest"
REGISTRY="ghcr.io"

# -----------------------------------------------------------------------------
# 1. Build Docker image dari Dockerfile yang ada di direktori saat ini.
# -----------------------------------------------------------------------------
echo ">>> [1/5] Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG} ..."
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

# -----------------------------------------------------------------------------
# 2. Tampilkan daftar image di lokal, verifikasi image berhasil dibuat.
# -----------------------------------------------------------------------------
echo ""
echo ">>> [2/5] Daftar image di lokal:"
docker images

# -----------------------------------------------------------------------------
# 3. Ubah nama (tag) image agar sesuai dengan format GitHub Container Registry:
#    ghcr.io/<username>/<image-name>:<tag>
# -----------------------------------------------------------------------------
FULL_IMAGE="${REGISTRY}/${GITHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo ">>> [3/5] Memberi tag ulang image menjadi: ${FULL_IMAGE}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${FULL_IMAGE}"

# -----------------------------------------------------------------------------
# 4. Login ke GitHub Container Registry (ghcr.io) menggunakan Personal Access
#    Token (PAT) yang disimpan di env variable GITHUB_TOKEN sebelum menjalankan ini.
#    Menggunakan --password-stdin agar token tidak muncul di history shell.
# -----------------------------------------------------------------------------
echo ""
echo ">>> [4/5] Login ke GitHub Container Registry (${REGISTRY}) ..."
echo "${GITHUB_TOKEN}" | docker login "${REGISTRY}" -u "${GITHUB_USERNAME}" --password-stdin

# -----------------------------------------------------------------------------
# 5. Unggah (push) image ke GitHub Container Registry agar dapat digunakan
#    oleh server atau environment lain yang menarik image dari registry.
# -----------------------------------------------------------------------------
echo ""
echo ">>> [5/5] Mengunggah image ke ${REGISTRY} ..."
docker push "${FULL_IMAGE}"

# -----------------------------------------------------------------------------
# 6. Tampilkan pesan bahwa proses build dan push telah selesai.
# -----------------------------------------------------------------------------
echo ""
echo "=== Build & Push selesai! Image tersedia di: ${FULL_IMAGE} ==="
