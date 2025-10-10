# Usar una imagen base de Python 3.12 oficial
FROM python:3.12-slim

# Establecer el directorio de trabajo base
WORKDIR /app

# Crear un usuario y grupo no-root por seguridad
RUN addgroup --system app && adduser --system --group app

# Actualizar pip
RUN pip install --upgrade pip

# Copiar el archivo de requerimientos e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar la aplicación y las fuentes
COPY ./src ./src
COPY ./fonts ./fonts

# --- CAMBIO CLAVE: Establecer el directorio de trabajo dentro de src ---
WORKDIR /app/src

# Cambiar la propiedad de toda la app al usuario no-root
# Nota: Ejecutamos chown desde /app para afectar a /app/src y /app/fonts
RUN chown -R app:app /app

# Cambiar al usuario no-root
USER app

# Exponer el puerto
EXPOSE 8080

# --- CAMBIO CLAVE: Comando simplificado para iniciar la aplicación ---
# Ahora uvicorn se ejecuta desde /app/src, por lo que encuentra 'main' directamente
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
