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
* CF standard ontology: https://vocab.nerc.ac.uk/standard_name/ https://cfconventions.org/Data/cf-standard-names/current/build/cf-standard-name-table.html
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

The performance requirements for the software system are crucial to ensure that it meets the expectations of end-users and can handle the anticipated workload efficiently. This section outlines the key performance metrics, targets, and goals that the system must achieve.

Response Time: The time taken by the system to process a request and return a response should be within acceptable limits to provide a smooth user experience. For example, the response time for user-facing operations should be under 200 milliseconds for 95% of requests and under 500 milliseconds for 99% of requests.

Throughput: The system should be able to handle a specified number of requests per second or transactions per minute without degrading performance. This metric depends on the expected usage patterns and peak loads. For example, the system should support a throughput of at least 1000 requests per second during peak times.

Resource Utilization: The system should make efficient use of available resources such as CPU, memory, disk, and network bandwidth. Resource utilization should be monitored continuously to identify bottlenecks and optimize the system accordingly. For example, CPU utilization should remain below 75% during normal operation and below 90% during peak loads.

Latency: The system should minimize the time taken for data to travel between components, such as between the front-end and back-end, or between the application and external services. For example, internal network latency should not exceed 10 milliseconds, and external API calls should have a round-trip time of no more than 100 milliseconds.

Concurrency: The system should be able to handle multiple simultaneous user sessions and requests without any loss of performance or functionality. For example, the system should support at least 500 concurrent user sessions without any degradation in response time or throughput.

Scalability: The system should be designed to scale both horizontally and vertically to accommodate increased user loads or additional functionality. Scalability requirements may include adding new servers, increasing CPU or memory resources, or deploying additional instances of the system.

Reliability: The system should maintain consistent performance levels under normal and adverse conditions, including hardware failures, network outages, or increased traffic. For example, the system should have a target uptime of 99.9% and a mean time between failures (MTBF) of at least 10,000 hours.

By defining these performance requirements upfront, the development team can make informed design decisions and implement appropriate optimizations to ensure that the software system meets or exceeds the specified performance targets. Regular performance testing, monitoring, and profiling should be conducted throughout the development process to validate that the performance requirements are being met and to identify any potential issues or bottlenecks.


### 6.2. Performance Testing and Profiling
### 6.3. Caching Strategies
### 6.4. Load Balancing and Failover
### 6.5. Vertical and Horizontal Scaling

## 7. Deployment and Operations
### 7.1. Deployment Environments
This section provides an overview of the deployment strategy and environments that are employed to ensure the smooth operation and management of the system. The purpose of outlining these is to create a clear understanding of how the system components are deployed, configured, and maintained across various stages of development and production.

**Development Environment:**
The development environment is where developers write, test, and debug the code for the system. It is a local setup that includes all necessary tools, frameworks, and dependencies for building and running the application components. This environment is isolated from other environments to allow developers to work on new features and improvements without affecting the stability of the system in other environments.

**Testing Environment:**
The testing environment is designed to rigorously validate the functionality, performance, and security of the application components before they are deployed to production. This environment mimics the production environment as closely as possible, with the same configurations and infrastructure. The testing environment is used for various types of tests, including unit tests, integration tests, system tests, and performance tests, among others.

**Staging Environment:**
The staging environment is a pre-production environment that closely mirrors the production environment in terms of infrastructure and configurations. It is used to perform final validation of the system components and ensure that they are production-ready. This environment is crucial for identifying and resolving any potential issues that may arise during deployment or operation in the production environment.

**Production Environment:**
The production environment is where the live system operates and serves end-users. It has the most stringent security, performance, and reliability requirements. The production environment should be carefully monitored and maintained to ensure that it continues to meet the system's non-functional requirements and provide a seamless user experience.

The deployment strategy for each environment is designed to minimize the risks associated with changes and updates while ensuring that the system remains stable and secure. Key aspects of the deployment strategy include version control, automated build and deployment processes, and a clear rollback plan in case of issues. This approach enables rapid delivery of new features and improvements while maintaining the overall integrity of the system.

### 7.2. Deployment Process

Continuous integration and delivery (CI/CD) is a critical aspect of the deployment architecture, as it streamlines the process of building, testing, and deploying application components across various environments. By adopting CI/CD best practices, the system can achieve faster release cycles, improved reliability, and reduced risk associated with software updates. This section describes the CI/CD pipeline and its key components.

Version Control System:
A version control system (VCS) is used to manage and track changes to the codebase throughout the development lifecycle. It enables developers to collaborate efficiently and ensures that every change is documented and traceable. The chosen VCS should support branching and merging strategies, allowing developers to work on new features and bug fixes independently while maintaining a stable main branch.

Build Automation:
Build automation is the process of automatically compiling the source code and creating executable artifacts. It ensures that the build process is consistent and repeatable, minimizing the risk of human error. The build automation process should include the compilation of the source code, execution of unit tests, and packaging of the application components into deployable artifacts.

Automated Testing:
Automated testing is a crucial part of the CI/CD pipeline, as it validates the functionality, performance, and security of the application components before deployment. Automated tests should be executed at various stages of the pipeline, including unit tests during the build process, integration tests after component deployment, and system tests in the staging environment. Test results should be reported and monitored to identify and address any issues promptly.

Deployment Automation:
Deployment automation is the process of automatically deploying application components to the target environments, ensuring that the deployment process is consistent, repeatable, and efficient. Deployment automation should include the provisioning and configuration of the target infrastructure, deployment of the application artifacts, and execution of any necessary post-deployment tasks.

Monitoring and Feedback:
Continuous monitoring and feedback are essential to maintain the health of the system and identify any issues that may arise during the deployment or operation of the application components. Monitoring tools should be integrated into the CI/CD pipeline to track system performance, resource utilization, and application logs. Feedback from monitoring tools should be used to inform future development and deployment decisions, ensuring that the system continues to meet its non-functional requirements and provide a seamless user experience.

By implementing a robust CI/CD pipeline, the deployment architecture enables rapid delivery of new features and improvements, while ensuring the overall stability, security, and performance of the system.

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
