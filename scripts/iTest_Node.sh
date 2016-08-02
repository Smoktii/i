#!/bin/bash

#Setting-up variables
export LANG=en_US.UTF-8
#This will cause the shell to exit immediately if a simple command exits with a nonzero exit value.
set -e

while [[ $# > 1 ]]
do
	sKey="$1"
	case $sKey in
		--version)
			sVersion="$2"
			shift
			;;
		--project)
			sProject="$2"
			shift
			;;
		--skip-deploy)
			bSkipDeploy="$2"
			shift
			;;
		--skip-build)
			bSkipBuild="$2"
			shift
			;;
		--skip-test)
			bSkipTest="$2"
			shift
			;;
		--skip-doc)
			bSkipDoc="$2"
			shift
			;;
		--deploy-timeout)
			nSecondsWait="$2"
			shift
			;;
		--compile)
			IFS=',' read -r -a saCompile <<< "$2"
			shift
			;;
		--jenkins-user)
			sJenkinsUser="$2"
			shift
			;;
		--jenkins-api)
			sJenkinsAPI="$2"
			shift
			;;
		--docker)
			bDocker="$2"
			shift
			;;
		--dockerOnly)
			bDockerOnly="$2"
			shift
			;;
		--gitCommit)
			sGitCommit="$2"
			shift
			;;
		--dockerOnly)
			bDockerOnly="$2"
			shift
			;;
		--gitCommit)
			sGitCommit="$2"
			shift
			;;
		*)
			echo "bad option"
			exit 1
			;;
	esac
shift
done

unset IFS
sDate=`date "+%Y.%m.%d-%H.%M.%S"`

build_central-js ()
{
	if [ "$bSkipBuild" == "true" ]; then
		echo "Deploy to host: $sHost"
		cd central-js
		rsync -az --delete -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' dist/ sybase@$sHost:/sybase/.upload/central-js/
		return
	fi
	if [ "$bSkipDeploy" == "true" ]; then
		cd central-js
		npm cache clean
		npm install
		bower install
		npm install grunt-contrib-imagemin
		grunt test server
		cd dist
		npm install --production
		cd ..
		rm -rf /tmp/$sProject
		return
	else
		cd central-js
		npm cache clean
		npm install
		bower install
		npm install grunt-contrib-imagemin
		grunt test server
		cd dist
		npm install --production
		cd ..
		rm -rf /tmp/$sProject
		rsync -az --delete -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' dist/ sybase@$sHost:/sybase/.upload/central-js/
		cd ..
	fi
}
