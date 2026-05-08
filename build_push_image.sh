#!/bin/bash

GITHUB_USERNAME="cravingmaker"
IMAGE_NAME="item-app"
IMAGE_TAG="v1"
REGISTRY="ghcr.io"

echo ">>> [1/5] Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG} ..."
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

echo ""
echo ">>> [2/5] Daftar image di lokal:"
docker images

FULL_IMAGE="${REGISTRY}/${GITHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo ">>> [3/5] Memberi tag ulang image menjadi: ${FULL_IMAGE}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${FULL_IMAGE}"

echo ""
echo ">>> [4/5] Login ke GitHub Container Registry (${REGISTRY}) ..."
echo "${CR_PAT}" | docker login "${REGISTRY}" -u "${GITHUB_USERNAME}" --password-stdin

echo ""
echo ">>> [5/5] Mengunggah image ke ${REGISTRY} ..."
docker push "${FULL_IMAGE}"

echo ""
echo "=== Build & Push selesai! Image tersedia di: ${FULL_IMAGE} ==="
