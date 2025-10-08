# Use an official Node.js runtime as a parent image
FROM node:20-slim

# Set the working directory
WORKDIR /app

# Copy only the package files first (for better caching)
COPY package*.json ./

# Install dependencies (omit dev dependencies)
RUN npm ci --only=production

# Copy the rest of the source code
COPY . .

# Set environment variables (optional but recommended)
ENV NODE_ENV=production
ENV PORT=5000

# Expose backend port
EXPOSE 5000

# Start the backend
CMD ["npm", "start"]
