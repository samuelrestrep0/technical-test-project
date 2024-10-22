# Use an official lightweight Node.js image to serve the static website
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy static files to the container
COPY static-website/ .

# Expose the port NGINX is running on
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
