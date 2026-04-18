#!/bin/zsh
clear
cat ./ascii/lalah.txt
cat ./ascii/banner.txt

sleep 1
clear


cd gundamhub-card-service/
./build-card-service.sh
cd ../aimuro/
./aimuro-build.sh
cd ..
docker-compose up -d