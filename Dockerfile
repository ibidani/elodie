FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install system dependencies and specific ExifTool version
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        locales \
        wget \
        perl \
        make && \
    # Install specific ExifTool version (matching CircleCI)\
    wget https://jmathai.s3.us-east-1.amazonaws.com/github/elodie/Image-ExifTool-13.19.tar.gz && \
    gzip -dc Image-ExifTool-13.19.tar.gz | tar -xf - && \
    cd Image-ExifTool-13.19 && \
    perl Makefile.PL && \
    make install && \
    cd .. && \
    rm -rf Image-ExifTool-13.19* && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# Create app directory
WORKDIR /opt/elodie

# Copy requirements files first for better caching
COPY requirements.txt ./
COPY docs/requirements.txt ./docs/
COPY elodie/tests/requirements.txt ./elodie/tests/
COPY elodie/plugins/googlephotos/requirements.txt ./elodie/plugins/googlephotos/

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r docs/requirements.txt && \
    pip install --no-cache-dir -r elodie/tests/requirements.txt && \
    pip install --no-cache-dir -r elodie/plugins/googlephotos/requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN useradd -m -u 1000 elodie && \
    chown -R elodie:elodie /opt/elodie

USER elodie

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python elodie.py --help || exit 1

ENTRYPOINT ["python", "elodie.py"]
CMD ["--help"]
