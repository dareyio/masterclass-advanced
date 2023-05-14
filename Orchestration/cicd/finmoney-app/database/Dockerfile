# Use the official MongoDB image as the base
FROM mongo

# Copy the MongoDB initialization script. This directory is used by MongoDB to automatically execute any JavaScript files placed in it during container startup
COPY init-mongo.js /docker-entrypoint-initdb.d/

# Expose the default MongoDB port
EXPOSE 27017

# Start MongoDB
CMD ["mongod", "--bind_ip_all"]
