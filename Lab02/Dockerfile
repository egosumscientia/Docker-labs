# Stage 1: Builder stage - Instala dependencias de compilación
FROM python:3.9-slim as builder

WORKDIR /app

# Install system dependencies and clean up (MANTENIDO)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Instala dependencias en un directorio aislado (NUEVO)
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime stage - Imagen final ligera (MANTENIENDO TU CONFIG ORIGINAL)
FROM python:3.9-slim

WORKDIR /app

# Copia solo las dependencias instaladas desde el builder (NUEVO)
COPY --from=builder /root/.local /root/.local

# Copia el resto de los archivos (MANTENIDO)
COPY . .

# Asegura que Python encuentre las librerías instaladas (NUEVO)
ENV PATH=/root/.local/bin:$PATH \
    PYTHONPATH=/root/.local/lib/python3.9/site-packages:$PYTHONPATH

# Puerto y comando (MANTENIDO)
EXPOSE 5000
CMD ["python", "app.py"]
