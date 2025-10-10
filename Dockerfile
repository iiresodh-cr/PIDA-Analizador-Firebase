# Usar una imagen base de Python 3.12 oficial y ligera
FROM python:3.12-slim

# Variables de entorno para optimizar Python en contenedores
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Establecer el directorio de trabajo
WORKDIR /app

# --- LA LÍNEA MÁS IMPORTANTE DE TODAS ---
# Le decimos a Python que el directorio /app es donde vive nuestro código.
# Cualquier importación comenzará a buscar desde aquí.
ENV PYTHONPATH /app

# Crear un usuario no-root por seguridad
RUN addgroup --system app && adduser --system --group app

# Actualizar pip
RUN pip install --upgrade pip

# Copiar e instalar las dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código de tu proyecto al contenedor
COPY . .

# Darle la propiedad de los archivos al usuario no-root
RUN chown -R app:app /app

# Cambiar al usuario no-root
USER app

# Exponer el puerto que usa Cloud Run
EXPOSE 8080

# El comando para iniciar la aplicación. No lo cambies.
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
