# Running PhaseNet on AWS EC2 Instance
- Original Code: https://github.com/AI4EPS/PhaseNet.git 

## Connect to EC2 instance using SSH
```
chmod 400 eqw_phasenet.pem
ssh -i "eqw_phasenet.pem" ec2-user@ec2-34-221-45-133.us-west-2.compute.amazonaws.com
```


## Remote machine

```bash
sudo yum install git

sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker #enable on boot

## install docker-compose (optional)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo usermod -aG docker $USER
## Log out and log back in

git clone https://github.com/earthinversion/phasenet-docker.git
cd phasenet-docker

## Run using docker
docker build -t phasenet-server .
docker run -d -p 80:7860 --name phasenet-server phasenet-server

## Run using docker compose
docker-compose build
docker-compose up -d

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
```
http://<your-ec2-public-ip>
http://34.221.45.133
```

## Test your phasenet API
```bash
#Run example_fastapi.ipynb
python example_phasenet_run.py
```

## References
Zhu, W., and Beroza, G. C., 2018. PhaseNet: A Deep-Neural-Network-Based Seismic Arrival Time Picking Method. Geophysical Journal International. DOI: 10.1093/gji/ggy423
