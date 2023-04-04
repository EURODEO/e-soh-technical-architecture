# Technical Architecture Document for E-SOH

## 1. Introduction

### 1.1. Purpose and Scope

The purpose of this Technical Design Document (TDD) is to provide a comprehensive and detailed description of the software system being developed, to serve as a reference for all stakeholders involved in the project. This document aims to:
* Define the software's architecture, components, and their relationships.
* Communicate the design decisions and rationale behind the chosen solutions.
* Provide clear specifications and guidelines for the development team to ensure consistent implementation of features and functionality.
* Establish a baseline for testing and validation, ensuring that the software meets the requirements and design goals.
* Serve as a reference for future maintenance, support, and enhancement of the software system.

The TDD is intended to be a living document, updated as necessary throughout the software development life cycle to reflect any changes or refinements made to the system design. It is essential for all stakeholders, including project managers, developers, testers, and end-users, to have a clear understanding of the software system's design to ensure effective collaboration and successful project completion.


### 1.2. Definitions, Acronyms, and Abbreviations

| Abbreviation             | Meaning                                                               |
|--------------------------|-----------------------------------------------------------------------|
| API                      | Application Programming Interface                                     |
| AWS                      | Automatic Weather Station                                             |
| EDR                      | [OGC API - Environmental Data Retrieval](https://ogcapi.ogc.org/edr/) |
| E-SOH                    | EUMETNET Supplementary Observation dataHub                            |
| EWC                      | [European Weather Cloud](https://www.europeanweather.cloud)           |
| FEMDI                    | Federated European Meteorological Data Infrastructure                 |

### 1.3. References

* WIS 2.0 MQTT topic architecture: https://github.com/wmo-im/wis2-topic-hierarchy
* WMO Core Metadata profile 2: https://github.com/wmo-im/wcmp2
* WIS 2 Notification Message Encoding; https://github.com/wmo-im/wis2-notification-message
* EU High Value Datasets in Open Data Directive: https://eur-lex.europa.eu/eli/reg_impl/2023/138/oj
* Discovery Metadata vocabulary: https://wiki.esipfed.org/Attribute_Convention_for_Data_Discovery_1-3
* CF standard ontology: https://vocab.nerc.ac.uk/standard_name/
* OGC API - Environmental Data Retrieval Standard v1.0.1 https://docs.ogc.org/is/19-086r5/19-086r5.html


## 2. System Overview
### 2.1. Architecture
#### 2.1.1. Landscape Diagram
#### 2.1.2. Context Diagram

```mermaid
C4Context

title E-SOH Context Diagram

Person(consumers, "Data Consumer", "A data consumer can be a human (advanced, intermediate or simple users) or a machine (e.g., a mobile app or a data portal).<br>Simple and intermediate users search, inspect, and access data via an external interface (e.g., a mobile app or data portal). <br> Advanced users acess the search, visualization, and distribution services directly. <br> Open licenses and well documented data following international standards enable Interoperability and Reusability.")
SystemDb_Ext(oscar, "OSCAR", "Web resource with WIGOS metadata for all surface-based observing stations and platforms.")

Enterprise_Boundary(nhms, "National Meteorological and Hydrological Service (NMHS)"){
  Person(dataproducer, "Dataset Producer")
  System(productionhub, "Production systems", "Automated system for data production.")
  SystemDb(datastore, "Data storage", "File system for storage of timeseries.")

  System_Boundary(e-soh, "E-SOH node"){
    SystemDb(store24, "Data storage", "File system for storage of 24 hours of data.")
    SystemQueue(queue, "Notification Service", "MQTT Event Queue. WIS2 real-time data sharing by a publication/subscription (PubSub) mechanism based on the Message Queuing Protocol (MQP).")
    SystemDb(discovery24, "Catalog", "Discovery Metadata Catalog. Database that can serve APIs and landing pages.")
    System(agent, "Metadata agent", "Subscriber agent that listens for new events from the queue.")
    System(edr, "Processing", "The OGC EDR API searches for data according to user requests, lets the user define data collections (or new datasets),<br> retrieves data, and packs the data in appropriate formats to be returned to the user. Could store metadata of retrieved datasets as well.") 
    SystemDb(edr_store, "EDR Metadata store", "Possible storage of files with discovery metadata for datasets created by users with the EDR API. <br>This could also be used to get usage metrics and trace data.")
    System(search, "Data search API", "E.g, OGC Records or CSW.")
    System(access, "Data access API", "E.g., OPEnDAP.")
    System(bufr, "BUFR exporter", "Tool to create BUFR files that will be posted to GTS by WIS2.0 systems. We need to now what and when (or how often). Could possibly also generate other file based products.")
    System(website, "Website", "Website for persistent dataset landing pages.")
  }
}

System_Ext(wis2, "WIS2.0", "WIS2.0 system(s).")

Rel_U(bufr, wis2, "posts to GTS via", "https")

Rel(productionhub, queue, "posts metadata in", "MQTT")
Rel_D(agent, queue, "listens for events from", "uri")
Rel_D(agent, discovery24, "ingests metadata in", "https")
Rel(agent, store24, "stores data in", "uri")
Rel(agent, datastore, "gets data from", "uri")
Rel(discovery24, oscar, "references metadata in", "uri")
Rel(edr, search, "finds data in", "https")
Rel(edr, access, "accesses data in", "https")
Rel(access, store24, "streams data from", "https")
Rel(search, discovery24, "returns metadata from")
Rel(website, discovery24, "serves dynamical landing pages for datasets in")
Rel(website, edr_store, "serves dynamical landing pages for datasets in")
Rel_L(edr, edr_store, "stores metadata in")

Rel(consumers, search, "finds data in", "https")
Rel(consumers, access, "accesses data in", "https")
Rel(consumers, edr, "gets datasets from", "https")

Rel(dataproducer, productionhub, "sets up data production in")

Rel(productionhub, datastore, "appends data to")

UpdateElementStyle(consumers, $fontSize="36")

UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
  
```

#### 2.1.3. Container Diagram


### 2.2. Components and Interfaces

## 3. Detailed Design
### 3.1. Component Design
### 3.2. Data Models
### 3.3. Algorithms and Flows

## 4. Integration and APIs
### 4.1. External Integrations
### 4.2. API Specifications
### 4.3. API Authentication and Authorization
### 4.4. API Rate Limiting and Throttling


## 5.Security and Privacy
### 5.1. Data Protection and Encryption
### 5.2. Authentication and Authorization
### 5.3. Auditing and Logging
### 5.4. Secure Coding Practices
### 5.5. Vulnerability and Threat Mitigation

## 6. Performance and Scalability
### 6.1. Performance Requirements
### 6.2. Performance Testing and Profiling
### 6.3. Caching Strategies
### 6.4. Load Balancing and Failover
### 6.5. Vertical and Horizontal Scaling

## 7. Deployment and Operations
### 7.1. Deployment Environments
### 7.2. Deployment Process
### 7.3. Monitoring and Alerting
### 7.4. Backup and Recovery
### 7.5. Disaster Recovery and Business Continuity

## 8. Maintenance and Support
### 8.1. Code Management and Versioning
### 8.2. Bug Tracking and Issue Resolution
### 8.3. Feature Enhancements and Roadmap
### 8.4. Documentation and Training
### 8.5. Support Channels and SLAs

## 9. Conclusion
### 9.1. Key Takeaways
### 9.2. Future Considerations
### 9.3. Final Remarks
