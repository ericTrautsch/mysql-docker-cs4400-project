## MySQL-Docker 

This project is a flask-app integrated with a MySQL database. This is for the implementation portion of CS:4400 Database Systems completed by Eric Trautsch in Spring 2023.

The project runs with docker-compose which hosts a local web-app at port 5000 which connects to the MySQL database. The database is initialized with sample data, and the web-portion is to provide simple views of the database and verify their connections.




```mermaid
erDiagram
    entity "Customer" as customer {
        <<PK>> cid
        name
        address
        phone
    }
    entity "Supplier" as supplier {
        <<PK>> supplier_id
        name
        address
        phone
    }
    entity "Employee" as employee {
        <<PK>> eid
        fname
        lname
        office_num
    }
    entity "Part" as part {
        <<PK>> pid
        description
        size_multiplier
    }
    entity "StorageArea" as storage {
        <<PK>> sid
        area
        capacity
    }
    entity "Inventory" as inventory {
        <<FK>> pid
        <<FK>> sid
        cpu
        quantity
    }
    entity "Outgoing" as outgoing {
        <<FK>> cid
        <<FK>> eid
        <<FK>> sid
        <<FK>> pid
        completed_on
        placed_on
        quantity
        cpu
        spu
        outgoing_location
    }
    entity "Incoming" as incoming {
        <<PK>> iid
        <<FK>> pid
        <<FK>> eid
        <<FK>> supplier_id
        <<FK>> sid
        date
        cpu
        quantity
        ordered_on
        recieved_on
    }
    customer ||--|{ outgoing : "places"
    outgoing }|--|| storage : "in"
    incoming }|--|| storage : "stored in"
    inventory }|--|| storage : "stored in"
    inventory }|--|| part : "contains"
    incoming }|--|| supplier : "supplies"
    outgoing }|--|| employee : "managed by"
```