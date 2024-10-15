
## Local machine
```
chmod 400 eqw_phasenet.pem
ssh -i "eqw_phasenet.pem" ec2-user@ec2-35-91-115-99.us-west-2.compute.amazonaws.com
```

## Remote machine
```bash
sudo yum install git

sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker #enable on boot

sudo usermod -aG docker $USER
## Log out and log back in

mkdir phasenet_service
cd phasenet_service

docker build -t phasenet-server .
docker run -d -p 7860:7860 --name phasenet-server phasenet-server

```

## Troubleshooting
```bash

docker logs phasenet-server

## Remove all stopped containers
docker rm $(docker ps -a -q)  

## To remove all images that are not in use by a container
docker system prune --all


## Get inside the docker container
docker exec -it phasenet-server /bin/bash

uvicorn --app-dir eqnet app:app --reload --host 0.0.0.0 --port 7860

```

## Application
http://<your-ec2-public-ip>:7860
http://34.216.250.65:7860
http://34.216.250.65:7860/healthz
http://ec2-34-216-250-65.us-west-2.compute.amazonaws.com:7860


curl -X POST http://34.216.250.65:7860/predict -H "Content-Type: application/json" -d '{
  "id": ["station_1"],
  "timestamp": ["2024-10-14T12:00:00Z"],
  "vec": [[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]],
  "dt_s": 0.01
}'
