docker build -f ./containers/IMAPP24/run_Dockerfile -t run_container ./containers/IMAPP24/
docker run -v ./containers/IMAPP24/:/mnt/ run_container
