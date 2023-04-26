# Data and Metadata Store
​
## Datastore alternatives
​
Several different implementation principles for the data store were considered. On top level the scenarios differ by two means:
​
* relational database vs. noSQL (here especially: document) databases
* conventional master data vs. event streaming approach (i.e. series of events stored form the source of truth)

First we talk about the different data storage​ alternatives, then we discuss the options of event sourcing or more conventional operating principles.

### Document database approach
​
Document database approach relies entirely on noSQL database able to store JSON documents. For this purpose there are open source projects like MongoDB and Elastic. 
​
In this project Elastic (formerly Elasticsearch) is investigated and evaluated (see the PoC report). Elastic supports geo-queries and is a distributed database system (reliability and scalability). 
​
The principle of the document-based database approach is shown in the following diagram

![](https://raw.githubusercontent.com/EURODEO/e-soh-c4/main/04-component-diagrams/datastore-options/c4-container-elastic-data-store-conventional.png)
​
​
### Relational database approach
​
Relational database with narrow tables can provide a flexible solution for numerical point data and metadata. PostGIS extension to PostgreSQL adds geospatial query capability and there's also an extension called timescaleDB to enhance time series performance in PostgreSQL environment.

The relational database approach is similar to the document database approach (See above), the only change will be the actual database itself. 
​
![](https://raw.githubusercontent.com/EURODEO/e-soh-c4/main/04-component-diagrams/datastore-options/c4-container-relational-data-store-conventional.png)
​
### Relational database with JSON capability
​
E.g. PostgreSQL and MySQL support JSON datatype. That makes it possible to support structured and semi-structured data in relational database by adding a column for JSON data. 
​
The relational database with JSON capability will bridge the fast column lookups from the relational database with the flexibility from the document database approach. This hybrid model is built by the same components as in the relational database (See previous subsection), the only difference is the special JSON datatype column. Probably JSON-queries in pure document-based database will be faster than this hybrid model, but we still maintain the speed from the relational columns.

### Files-based storage
​
Files-based storage was considered, but as query logic has to be implemented separately and there is requirements for structured data and queries, we do not consider it as a feasible option for implementation. There's also another downside with files which is challenge to update minor changes (e.g. incoming QC updates some minutes after the initial observation time) in the middle of the files. When using files, there are typically also some challenges with locking while writing -- in databases there are transactions to handle this// 2c
 better for multiple calls.
​
If files-based datasets, e.g. 2d/3d imaging data or similar, needs to be handled, the support can be added e.g. by integrating S3 object storage into the system and using references to file URLs from the database. Database system will then serve also as a (discovery) metadata backend for files.


### Elasticsearch

During the E-SOH design phase, we looked at how Elasticsearch is used in wis2box,
and experimented with that setup. We also looked at Elastiscsearch documentation.

As is shown by the OGC Feature API in wis2box, Elasticsearch can be used a storage backend.
This works well in the case where the API returns a collection of documents 
(potentially with some information filtered out) which can be stored in Elasticsearch.
This is the case for the Feature API and also the wis2box Replay feature.
In this setup, Elasticsearch is used as a document store with very efficient querying.

For an EDR API that return CoverageJSON, this is less efficient, as the CoverageJSON response
is not just a simple collection of documents, but should contain arrays of data.

### Geo queries
Elasticsearch has [good](https://www.elastic.co/guide/en/elasticsearch/reference/current/geo-queries.html) 
support for  geo queries. 
It supports bounding box, distance from a point, and polygon queries (among others).
Elasticsearch does not allow on-the-fly CRS transformations. So specifying a bounding box in one CRS,
while the data is stored in another CRS, is not possible.
During the E-SOH design phase, we looked at how Elasticsearch is used in wis2box,
and experimented with that setup. We also looked at Elastiscsearch documentation.

As is shown by the OGC Feature API in wis2box, Elasticsearch can be used a storage backend.
This works well in the case where the API returns a collection of documents 
(potentially with some information filtered out) which can be stored in Elasticsearch.
This is the case for the Feature API and also the wis2box Replay feature.
In this setup, Elasticsearch is used as a document store with very efficient querying.

For an EDR API that return CoverageJSON, this is less efficient, as the CoverageJSON response
is not just a simple collection of documents, but should contain arrays of data.

## Event sourcing architecture scenario

The specification included a requirement for the Replay functionality, which means that a  user can request missed notification messages for a certain period. Thus we looked into an architecture which needed to have all notifications stored in some way

If we assume that the notification messages also have the actual data (and metadata),
an [event sourcing](https://www.martinfowler.com/eaaDev/EventSourcing.html) architecture might be appropriate:

- All incoming data is processed and translated into the notification event format, probably some kind of data.
- All these events are stored in an event store. This is the source of truth.
- The Replay API is built on top of the event store, and simply returns all notifications in a specific time range.
- The events are also ingested into the "view" database, which is designed to allow efficient EDR queries.
- The "view" database can be rebuilt from scratch using the event stream (through the Replay API).

wis2box uses Elasticsearch for storing the events for the Replay API, basically using Elasticsearch
as a document store. This choice makes sense for wis2box, as Elastischsearch is alreay in the stack to
support OGC Feature queries. An alternative is to use PostgreSQL as an event store.

An example C4 diagram using Elasticsearch as event store is given below.

![](https://raw.githubusercontent.com/EURODEO/e-soh-c4/main/04-component-diagrams/datastore-options/c4-container-elastic-data-store-event.png)

Based on further architecture discussions it was decided 25th of April 2023 at the Helsinki workshop, that the Replay-functionality will not be implemented.
Because of this we deem the event sourcing architecture not to be relevant anymore.

## Selection criteria for the datastore solution

- Purchase / licensing cost
- Maintenance cost
    - Sufficient team competence
    - Wide community adoption
    - Existing knowledge
- Steepness of learning curve
- Performance of relevant use cases 
    - ex. (Different read/writing operation scenarios)

