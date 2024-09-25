# Stage 1: Builder
FROM python:3.12-alpine AS builder

# Install build dependencies
RUN apk update && apk add --no-cache build-base libffi-dev openssl-dev cargo

# Install pip and uv
RUN python -m ensurepip
RUN pip install --no-cache-dir uv

# Copy requirements.txt
COPY requirements.txt /tmp/requirements.txt

# Install dependencies into a directory using uv pip
RUN uv pip install --prefix=/install -r /tmp/requirements.txt

# Stage 2: Final Image
FROM python:3.12-alpine

# Install runtime dependencies
RUN apk add --no-cache libstdc++ libffi openssl curl

# Copy installed packages from the builder stage
COPY --from=builder /install /usr/local

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/usr/local/lib/python3.12/site-packages"

# Copy the application code
COPY . /app

WORKDIR /app

# Expose port
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD curl -f http://localhost:8080/healthcheck || exit 1

# Run the application
CMD ["python", "server.py"]
