# Use an official Node.js runtime as a parent image
FROM node:12-alpine

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to /app
COPY package*.json ./

# Install the dependencies
RUN npm install \
    && mkdir public

# Copy the current directory contents to /app
COPY ./app /app

# copy index.html into the public folder
COPY /app/index.html /app/public/

# Expose port 3000 for the app to listen on
EXPOSE 3000

# Define the command to run the app
CMD [ "npm", "start" ]
