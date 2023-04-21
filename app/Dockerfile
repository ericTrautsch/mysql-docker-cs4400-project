# Use an official Python runtime as an image
FROM python:3.6

# The EXPOSE instruction indicates the ports on which a container
EXPOSE 5000

ARG a_host=dbdev.cs.uiowa.edu
ARG a_password
ARG a_user=root
ARG a_database=db_etrautsch

ENV HOST=$a_host
ENV DB_PASSWORD=$a_password
ENV DB_USER=$a_user
ENV DATABASE=$a_database

# Sets the working directory for following COPY and CMD instructions
# Notice we haven’t created a directory by this name - this instruction
# creates a directory with this name if it doesn’t exist
WORKDIR /app

COPY requirements.txt /app
RUN python -m pip install --upgrade pip
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org --no-cache-dir -r requirements.txt

# Run app.py when the container launches
COPY . /app
CMD python app.py