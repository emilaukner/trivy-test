# Trivy + GHCR Test Container

A minimal Alpine-based container for testing [Trivy](https://trivy.dev/) vulnerability scanning with GitHub Container Registry (GHCR).

## Structure

```
.
├── Dockerfile
├── entrypoint.sh
└── .github/
    └── workflows/
        └── trivy-scan.yml
```

## Quick Start

### 1. Build locally

```bash
docker build -t test-image .
```

### 2. Scan locally with Trivy

```bash
# Install Trivy (macOS)
brew install trivy

# Install Trivy (Linux)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan the image
trivy image test-image

# Scan with specific severity levels
trivy image --severity HIGH,CRITICAL test-image

# Output as table (default)
trivy image --format table test-image

# Output as JSON
trivy image --format json --output results.json test-image
```

### 3. Push to GHCR manually

```bash
# Authenticate
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# Tag and push
docker tag test-image ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
docker push ghcr.io/YOUR_USERNAME/YOUR_REPO:latest

# Scan the remote image
trivy image ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
```

## GitHub Actions Workflow

The included workflow (`.github/workflows/trivy-scan.yml`) will:

1. **Build** the Docker image
2. **Scan** it with Trivy for `HIGH` and `CRITICAL` vulnerabilities
3. **Upload** results to the GitHub Security tab (as SARIF)
4. **Push** the image to GHCR (on `main` branch pushes)

### Required Setup

- **No manual secrets needed** — the workflow uses `GITHUB_TOKEN` automatically
- Make sure **"Read and write permissions"** is enabled for Actions in your repo settings (`Settings → Actions → General → Workflow permissions`)
- To make the GHCR package public, go to your package settings after first push

## Customization

| What to change | Where |
|---|---|
| Base image | `FROM` line in `Dockerfile` |
| Fail build on vulns | Set `exit-code: 1` in workflow |
| Severity filter | Change `severity:` in workflow |
| Scan branches | Edit `on.push.branches` in workflow |