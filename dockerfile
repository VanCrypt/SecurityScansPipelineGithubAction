# ========================
# STAGE 1 — BUILD
# ========================
FROM python:3.11-slim AS builder

# No annoying interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install system stuff needed to build Python deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# This is where the app lives during the build
WORKDIR /app

# Copy requirements first so Docker caching actually works
COPY requirements.txt .

# Build Python wheels so the final image stays clean and tiny
RUN pip install --upgrade pip \
    && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt


# ========================
# STAGE 2 — RUNTIME
# ========================
FROM python:3.11-slim

# Create a non-root user because running apps as root is... yeah, not great
RUN useradd -m appuser

# App directory for real this time
WORKDIR /app

# Grab the wheels from the build stage
COPY --from=builder /wheels /wheels

# Install deps without pulling in random cache junk
RUN pip install --no-cache /wheels/*

# Copy the actual project files
COPY . .

# Make sure our non-root user owns the place
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Simple health check: just ping Python to see if it's alive 
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python3 -c "print('ok')" || exit 1


# What the container actually runs when it starts
CMD ["python3", "main.py"]
