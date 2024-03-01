# Use Alpine 3.9 as base image
FROM alpine:3.9

# Add community repository for MongoDB
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.9/community >> /etc/apk/repositories

# Install MongoDB and Bash
RUN apk add --no-cache mongodb=4.0.5-r0 bash

# Create MongoDB data directory
RUN mkdir -p /data/db
RUN mkdir -p /var/log/mongodb

# Set ownership
RUN chown -R mongodb:mongodb /data/db /var/log/mongodb

# Copy the entrypoint script to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable and set ownership
RUN chmod +x /entrypoint.sh && chown mongodb:mongodb /entrypoint.sh

# Set environment variables
ENV MONGO_INITDB_DATABASE=admin \
    MONGO_INITDB_ROOT_USERNAME=root \
    MONGO_INITDB_ROOT_PASSWORD=password

# Expose MongoDB default port
EXPOSE 27017

# Switch to the mongodb user
USER mongodb

# Use the entrypoint script to initialize MongoDB
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run MongoDB
CMD ["mongod", "--bind_ip_all", "--auth"]