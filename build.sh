docker build -f ./containers/IMAPP24/build_Dockerfile -t build_container ./containers/IMAPP24/
docker run -v ./containers/IMAPP24/:/mnt/ build_container
