# Use the official Python image.
# https://hub.docker.com/_/python
FROM python:3.8

# Install necessary libraries for Chrome to run properly (for selenium).
RUN apt-get update 
RUN apt-get install -y \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libfontconfig1 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libxss1 \
    fonts-liberation \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# Install Python dependencies.
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy the local code into the container.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . . 

# Run the Flask app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "main:app"]

