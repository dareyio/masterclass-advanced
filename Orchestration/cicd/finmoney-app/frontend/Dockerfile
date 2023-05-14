# Use the official Node.js image as the base
FROM node:14

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the frontend source code to the working directory
COPY ./src ./src
COPY ./public ./public

# Build the frontend
RUN npm run build

# Expose port 3000 for the application
EXPOSE 3000

# Set the command to run the frontend server
CMD ["npm", "start"]
