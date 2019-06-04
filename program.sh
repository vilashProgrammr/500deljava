#!/usr/bin/env bash
set -x

pid=0

# SIGUSR1 -handler
my_handler() {
  echo "my_handler123"
}

# SIGTERM -handler
term_handler() {
  echo "time to push branch"
  if [ "$TYPE" = "web" ];
  then
	  echo "nothing to do"
  else	
	  cd /home/project/WeatherForecast
	  git add . 
	  git commit -m "FINISH TEST"
	  git push -u origin $invite 
  fi

  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM

# run application

#get the public ip of the container
mkdir /home/ubuntu
wget -q -O - http://checkip.amazonaws.com > /home/ubuntu/myip.txt


#mkdir /home/project/WeatherForecast
cd /home/project/WeatherForecast
#push the master code onto testrepo for first time

if [ "$TYPE" = "web" ];
then
	git init
	git remote add origin https://github.com/vilashProgrammr/$TESTID
	git remote set-url origin https://github.com/vilashProgrammr/$TESTID
	git pull origin $invite --allow-unrelated-histories
else	
	git init
	git remote add origin $GITURL
	git remote set-url origin $GITURL
	git checkout master
	git reset --hard origin/master
	git pull origin master --allow-unrelated-histories
	git remote add origin git@github.com:vilashProgrammr/$TESTID.git
	git remote set-url origin git@github.com:vilashProgrammr/$TESTID.git
	git config user.name vilashProgrammr
	git config user.email vilash@programmr.com
	git add . 
	git commit -m "master changes"
	git push -u origin master

	git init
	git remote add origin https://github.com/vilashProgrammr/$TESTID
	git remote set-url origin https://github.com/vilashProgrammr/$TESTID
	git pull origin master --allow-unrelated-histories

	git remote add origin git@github.com:vilashProgrammr/$TESTID.git
	git remote set-url origin git@github.com:vilashProgrammr/$TESTID.git
	git config user.name candidate
	git config user.email candidate@programmr.com
	echo "chckout branch="
	echo $invite
	git checkout -b $invite
fi

cd /home/theia
node program &
pid="$!"

node /home/theia/src-gen/backend/main.js  /home/project --hostname=0.0.0.0 &

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
