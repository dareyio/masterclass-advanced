# Use the official Node.js 14 image as the base
FROM node:14

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the backend code to the working directory
COPY server.js ./

# Expose the port the app will listen on
EXPOSE 3000

# Start the app
CMD [ "node", "server.js" ]
