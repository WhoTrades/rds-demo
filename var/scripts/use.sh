#!/bin/bash -e

echo "Activating $projectName"
servers=($servers)
for server in "${servers[@]}"; do
	# Do not activate projects like that in production!
	ssh -o "StrictHostKeyChecking=no" -o "IdentitiesOnly=yes" -i /home/deploy/.ssh/deploy deploy@${server} ln -sfnv /var/pkg/$projectName-$version /var/pkg/demo-application
done
echo "Done activating $projectName"