# Usar una imagen base de Python 3.12 oficial
FROM python:3.12-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Crear un usuario y grupo no-root para la aplicación por seguridad
RUN addgroup --system app && adduser --system --group app

# Actualizar pip
RUN pip install --upgrade pip

# Copiar el archivo de requerimientos e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el directorio de las fuentes
COPY ./fonts ./fonts

# Copiar el resto del código de la aplicación
COPY ./src ./src

# Cambiar la propiedad de los archivos al usuario de la aplicación
RUN chown -R app:app /app

# Cambiar al usuario no-root
USER app

# Exponer el puerto
EXPOSE 8080

# Comando para iniciar la aplicación
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]