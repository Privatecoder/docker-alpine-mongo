FROM alpine:3.9

# Add community repository for MongoDB
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.9/community >> /etc/apk/repositories

# Install MongoDB and necessary tools
RUN apk add --no-cache mongodb=4.0.5-r0 bash

# Create MongoDB data directory
RUN mkdir -p /data/db

# Expose port 27017
EXPOSE 27017

# Copy the entrypoint script to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set environment variables
ENV MONGO_INITDB_DATABASE=admin \
    MONGO_INITDB_ROOT_USERNAME=admin \
    MONGO_INITDB_ROOT_PASSWORD=password

# Use the entrypoint script to initialize MongoDB
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run MongoDB
CMD ["mongod", "--bind_ip_all"]
