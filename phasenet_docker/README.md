# PhaseNet: A Deep-Neural-Network-Based Seismic Arrival Time Picking Method

[![](https://github.com/AI4EPS/PhaseNet/workflows/documentation/badge.svg)](https://ai4eps.github.io/PhaseNet)


## Docker run
docker build . --platform=linux/x86_64 -t phasenettest
docker run -t phasenettest


docker build . -t test
docker run -t test1



## Run inside container
uvicorn app:app --reload --host 0.0.0.0 --port 7860
