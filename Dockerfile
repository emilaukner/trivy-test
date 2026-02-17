FROM alpine:3.19

LABEL org.opencontainers.image.source="https://github.com/emilaukner/trivy-test"
LABEL org.opencontainers.image.description="Basic test container for Trivy scanning"
LABEL org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache \
    curl \
    ca-certificates

WORKDIR /app

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

ENTRYPOINT ["./entrypoint.sh"]