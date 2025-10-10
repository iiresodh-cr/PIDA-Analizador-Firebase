# Usa una imagen base de Python 3.12 oficial y ligera
FROM python:3.12-slim

# Variables de entorno para optimizar Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Establece el directorio de trabajo
WORKDIR /app

# Crea un usuario no-root por seguridad
RUN addgroup --system app && adduser --system --group app

# Copia e instala las dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo el código
COPY . .

# Dale la propiedad al usuario no-root
RUN chown -R app:app /app

# Cambia al usuario no-root
USER app

# --- COMANDO TEMPORAL DE DEPURACIÓN ---
# Este comando listará el contenido del directorio de trabajo,
# mostrará la ruta de búsqueda de Python y luego intentará
# importar el módulo problemático de forma explícita.
CMD ["/bin/sh", "-c", "ls -R && python -c 'import sys; print(sys.path)' && python -c 'from src.core import security'"]
