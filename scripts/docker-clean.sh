#!/bin/bash
# Clean stopped containers and dangling images

echo "Cleaning Docker..."

# Remove stopped containers
stopped=$(docker ps -aq -f status=exited)
if [ -n "$stopped" ]; then
    echo "Removing stopped containers..."
    docker rm $stopped
fi

# Remove dangling images
dangling=$(docker images -q -f dangling=true)
if [ -n "$dangling" ]; then
    echo "Removing dangling images..."
    docker rmi $dangling
fi

# Show space recovered
echo ""
echo "Current disk usage:"
docker system df

echo ""
echo "Cleanup complete!"
