# Stage 1: Build Tailscale dan Containerboot menggunakan Go resmi
FROM --platform=$BUILDPLATFORM golang:1.24-alpine AS builder

RUN apk add --no-cache git curl

WORKDIR /app

# Mengambil versi STABLE terbaru secara otomatis dari GitHub resmi Tailscale
RUN LATEST_STABLE=$(curl -s https://api.github.com/repos/tailscale/tailscale/releases | \
    grep -oE '"tag_name": "v[0-9]+\.[0-9]*[02468]\.[0-9]+"' | \
    head -n 1 | sed 's/"tag_name": "//;s/"//') && \
    echo "Memulai build Tailscale Stable Versi: ${LATEST_STABLE}" && \
    git clone --depth 1 --branch ${LATEST_STABLE} https://github.com/tailscale/tailscale.git .

ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=5
ENV GOTOOLCHAIN=auto

# Masak tiga biner sekaligus secara statik (tailscale, tailscaled, dan containerboot)
RUN go build -ldflags="-s -w -extldflags '-static'" -o /app/tailscale ./cmd/tailscale && \
    go build -ldflags="-s -w -extldflags '-static'" -o /app/tailscaled ./cmd/tailscaled && \
    go build -ldflags="-s -w -extldflags '-static'" -o /app/containerboot ./cmd/containerboot

# Stage 2: Pakai SCRATCH (Kosong total, super aman dari eror layer MikroTik)
FROM scratch

# Set PATH lingkungan universal biar biner saling kenal
ENV PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Salin file sertifikat SSL biar bisa konek internet aman
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Salin semua biner hasil masakan ke folder bin internal
COPY --from=builder /app/tailscale /usr/local/bin/tailscale
COPY --from=builder /app/tailscaled /usr/local/bin/tailscaled
COPY --from=builder /app/containerboot /usr/local/bin/containerboot

# Jalankan containerboot sebagai otak utama pengganti shell manual
ENTRYPOINT ["/usr/local/bin/containerboot"]