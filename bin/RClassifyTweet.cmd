REM Stop
docker stop RTapTweet

REM Remove previuos container 
docker container rm RTapTweet

docker build ..\R\ --tag tap:RTweet
docker run --network tap -e R_ACTION=tapclassifier -e TWEET="%*" -e MODEL="svm.rds" --name RTapTweet -it tap:RTweet