# Dockerfile for running 8‑bit BASIC programs with PC‑BASIC
# ---------------------------------------------------------
# Base image: minimal Python environment
FROM python:3.11-slim

# Install the PC‑BASIC interpreter (compatible with GW‑BASIC / MS‑BASIC)
RUN pip install --no-cache-dir pcbasic

# Set working directory inside the container
WORKDIR /app

# Copy all BASIC source files into the image
COPY *.bas ./

# Add the wrapper script that forwards arguments to PC‑BASIC
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# Default entrypoint – invoke the wrapper
ENTRYPOINT ["/usr/local/bin/run.sh"]