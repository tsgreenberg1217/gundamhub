#!/bin/zsh
clear
cat ./ascii/lalah.txt
cat ./ascii/banner.txt

sleep 1
clear


echo "🗃🗃🗃🗃️ BUILDING CARD SERVICE  🗃🗃🗃🗃"
cd gundamhub-card-service
./gradlew build
docker build -t gundam-card-service .
cd ../aimuro
./aimuro-build.sh
cd ..
docker-compose up -d

#docker tag gundam-card-service tsgreenberg1217/todds-playground:gundam-card-service
#docker push tsgreenberg1217/todds-playground:gundam-card-service

# docker-compose up -d