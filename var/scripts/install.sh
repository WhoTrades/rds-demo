#!/bin/bash -e

echo "Deploying $projectName"
servers=($servers)
for server in "${servers[@]}"; do
	# Do not deploy projects like that in production!
	ssh -o "StrictHostKeyChecking=no" -o "IdentitiesOnly=yes" -i /home/deploy/.ssh/deploy deploy@${server} mkdir -p /var/pkg/$projectName-$version
	scp -r -o "StrictHostKeyChecking=no" -o "IdentitiesOnly=yes" -i /home/deploy/.ssh/deploy $projectDir/* deploy@${server}:/var/pkg/$projectName-$version/
	scp -r -o "StrictHostKeyChecking=no" -o "IdentitiesOnly=yes" -i /home/deploy/.ssh/deploy $projectDir/.env deploy@${server}:/var/pkg/$projectName-$version/.env
	ssh -o "StrictHostKeyChecking=no" -o "IdentitiesOnly=yes" -i /home/deploy/.ssh/deploy deploy@${server} chmod -R 0777 /var/pkg/$projectName-$version/var
done
echo "Done deploying $projectName"