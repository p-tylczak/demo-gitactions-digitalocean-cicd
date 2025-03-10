# Stage 1: Build the React App
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . ./app

# Build the React application
RUN npm run build

#
# =======================================================
#
# Stage 2: Serve with Nginx
FROM nginx:stable-alpine3.20

# Copy the build output to Nginx static directory
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom Nginx configuration if needed
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

# Expose port
EXPOSE 3000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
