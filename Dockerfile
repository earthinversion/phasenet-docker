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
    && rm -rf /var/lib/apt/lists/*

# Create a new user and switch to that user
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:$PATH"

# Set the working directory
WORKDIR /app

# Copy the requirements file and install Python dependencies
COPY --chown=user ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Download the model, extract it, and clean up
RUN wget https://github.com/AI4EPS/models/releases/download/PhaseNet-2018/model.tar && tar -xvf model.tar && rm model.tar

# Copy the application code into the container
COPY --chown=user . /app

# Set the entry point for running the application
ENTRYPOINT ["uvicorn", "--app-dir", "phasenet", "app:app", "--reload","--host", "0.0.0.0",  "--port", "7860"]
