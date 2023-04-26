# Aircraft Parts Distribution Center 

CS:4400 Database Systems 
Group 2 
Yiqi Liu, Daniel Dagle, Eric Trautsch 

See our [project report](https://github.com/ericTrautsch/mysql-docker-cs4400-project/blob/main/docs/ProjectReport.md)


This project is defined in a few folders:

```
-- db/ 

    -- init.sql : This is the initialization script for a mySQL database

-- app/ 

    -- Dockerfile : This is the file that defines the Container specifications for running Flask app as a container
    
    -- app.py : Main runner of the flask application
    
    
-- docs/ : Contains all documentation and reports associated with this project
    
    
-- docker-compose.yml : This file defines a docker-compose script that creates a mySQL database and connects the flask server in app/ to it.
```
