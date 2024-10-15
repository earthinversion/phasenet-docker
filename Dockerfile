# Use a base image that supports the required Python version
FROM python:3.9-slim-bullseye

# Install the required system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libhdf5-dev \
    python3-dev \
    gfortran \
    libatlas-base-dev \
    pkg-config \
    wget \
    git \  
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch and torchvision
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Create a new user and switch to that user
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:$PATH"

# Set the working directory
WORKDIR /app

# Clone the EQNet repository from GitHub
RUN git clone https://github.com/AI4EPS/PhaseNet.git /app/EQNet

# Change the working directory to the cloned repository
WORKDIR /app/EQNet

# Install the Python dependencies listed in the requirements file
COPY --chown=user ./requirements.txt /app/EQNet/requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Download the model, extract it, and clean up
RUN wget https://github.com/AI4EPS/models/releases/download/PhaseNet-2018/model.tar && tar -xvf model.tar && rm model.tar

# Set the entry point to run the application using Uvicorn
ENTRYPOINT ["uvicorn", "--app-dir", "phasenet", "app:app", "--reload", "--host", "0.0.0.0", "--port", "7860"]
