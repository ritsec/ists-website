# Use the official python image for python3 - using Debian because idk.
FROM python:3-stretch

# Will be listening on port 8000
EXPOSE 8000

# Create working directory
WORKDIR /ists

# Install packages required to build uWSGI
RUN apt-get update -y && apt-get install -y \
    build-essential \
    python-dev

# Install pip requirements.  uWSGI is kept separate because it isn't required
# by the application, it's just a deployment requirement.
COPY requirements.txt ./requirements.txt
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    pip3 install uwsgi

# Configure uWSGI
COPY uwsgi.ini ./uwsgi.ini

# Run the application on startup
CMD uwsgi --ini uwsgi.ini

# Set flask app
ENV FLASK_APP project

# Copy over application files
COPY project ./project

# Configure application
COPY config.py ./instance/config.py

# Add website posts
COPY ./posts ./instance/posts
