#!/bin/bash -e

if [[  -d $projectDir ]]; then
	echo "Build directory clean-up";
	rm -rf $projectDir
fi;

# install symfony command (actually we don't have to do this for every build)
if [[ ! -f /usr/local/bin/symfony ]]; then
	echo "Installing Symfony binary";
	curl -sS https://get.symfony.com/cli/installer | bash
	mv -fv /root/.symfony/bin/symfony /usr/local/bin/symfony
	chmod +x /usr/local/bin/symfony
fi;

echo "Installing app to $projectDir"
/usr/local/bin/symfony new --demo --no-git --dir="$projectDir"

exit $?