#!/bin/bash
set -e

# MongoDB data directory
DATA_DIR="/data/db"
LOG_DIR="/var/log/mongodb"

# Check if MongoDB was already initialized
if [ ! -f "$DATA_DIR/.mongodb_data_initialized" ]; then
    echo "Initializing MongoDB data..."

    echo "Setting logpath..."
    mongod --fork --logpath $LOG_DIR/mongodb.log --dbpath $DATA_DIR
    #mongod --logpath $LOG_DIR/mongodb.log --dbpath $DATA_DIR

    echo "Adding root user '${MONGO_INITDB_ROOT_USERNAME}'..."
    mongo admin --eval "db.createUser({user: '$MONGO_INITDB_ROOT_USERNAME', pwd: '$MONGO_INITDB_ROOT_PASSWORD', roles:[{role:'root',db:'admin'}]});"

    # Create the initial database if specified
    if [ "$MONGO_INITDB_DATABASE" != "admin" ]; then
        echo "Creating initDB database '${MONGO_INITDB_DATABASE}'..."
        mongo --username $MONGO_INITDB_ROOT_USERNAME --password $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin --eval "db.getSiblingDB('$MONGO_INITDB_DATABASE').createCollection('init_collection');"
    fi

    # Indicate that initialization has been done
    touch "$DATA_DIR/.mongodb_data_initialized"

    mongod --shutdown --dbpath $DATA_DIR

    echo "MongoDB data initialized."
else
  echo "MongoDB already initialized. Starting..."
fi

# Run MongoDB
exec mongod --logpath $LOG_DIR/mongodb.log --dbpath $DATA_DIR --auth --bind_ip_all
