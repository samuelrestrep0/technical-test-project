# Dockerfile para construir la imagen de la app
# Usar la imagen base de Node.js
FROM node:16

# Establecer el directorio de trabajo
WORKDIR /usr/src/app

# Copiar los archivos de package.json y package-lock.json
COPY app/package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto del código de la aplicación
COPY app/ ./

# Exponer el puerto en el que se ejecutará la aplicación
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["npm", "start"]
