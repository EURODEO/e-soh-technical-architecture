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
#### 2.1.1. Context Diagram
In this diagram the context of the E-SOH system is depicted.
![Top level C4 context diagram](https://github.com/EURODEO/e-soh-c4/blob/main/01-context-diagram-toplevel/E-SOH-C4-toplevel-context-diagram.png)
On the left are the data producers (mainly NMHS's) who produce the Observation data and related metadata.
On the right hand side are the data consumers who use the data via data consuming systems (f.i. the FEMDI Data catalogue and API)
#### 2.1.2. Landscape Diagram

![C4 landscape diagram](https://github.com/EURODEO/e-soh-c4/blob/main/02-landscape-diagram/E-SOH-C4-landscape-diagram.png)

#### 2.1.3. Container Diagram

![C4 container diagram](https://github.com/EURODEO/e-soh-c4/blob/main/03-container-diagram/c4-container-diagram.png)

### 2.2. Components and Interfaces

## 3. Detailed Design
### 3.1. Component Design

### 3.2. Data Models

A dataset is defined as a collection of data records and their associated information content (e.g., use, discovery, provenance metadata). In the E-SOH context, we consider the (Near-) Real-Time (NRT) data as extracts of externally available datasets like, e.g., climate timeseries. We refer to these datasets as "parent" datasets, whereas the extracts are referred to as "child" datasets.

*NetCDF and CF-NetCDF*

[NetCDF] is a binary, platform-independent, domain-neutral data format for multidimensional data. Essentially, a NetCDF file is a collection of multidimensional arrays, plus metadata provided as key-value pairs. Metadata conventions are required to specialise NetCDF for particular communities. The Climate and Forecast conventions are the pre-eminent conventions for geospatial NetCDF data. NetCDF files that conform to these conventions are known as "CF-NetCDF files". Note that there are different varieties of the NetCDF format and data model. Here we are concerned with the "classic" NetCDF data model.

*CoverageJSON*
The overall concepts of CoverageJSON are close to those of the [ISO19123] standard and the OGC standard Coverage Implementation Schema ([OGC-CIS]), which specialises ISO19123.
https://www.iso.org/standard/40121.html

The overall structure of CoverageJSON is quite close to that of [NetCDF], consisting essentially of a set of orthogonal domain axes that can be combined in different ways. One major difference is that in CoverageJSON, there is an explicit Domain object, whereas in NetCDF the domain is specified implicitly by linking data variables with coordinate variables. One consequence of this is that NetCDF files can contain several domains and hence several Coverages. A NetCDF file could therefore be converted to a single Coverage or a Coverage Collection in CoverageJSON.

#### 3.2.1 Metadata specification

The following principles shall be followed:

* A minimum set of (required and recommended) metadata must follow the data, i.e., as part of the data files output from E-SOH APIs and the event queue.
* Input datasets must be enriched by required metadata upon ingestion, if it is not already provided.
* In order to obtain traceability, a child dataset must reference its parent dataset by the parent's metadata identification. The parent dataset's identification is expected to be actionable, but the NRT dataset identification is not.
* To support interoperability, it must be possible to translate from the agreed data-following standards to other standards (e.g., DCAT, ISO19115, etc.).
* All datasets must have defined use constraints provided by a standard license or release statement ("no rights reserved").
* All datasets must have defined access constraints (in particular for fully or partly restricted datasets). The optional access constraints must be defined by a controlled vocabulary.

The [Attribute Convention for Data Discovery](https://wiki.esipfed.org/Attribute_Convention_for_Data_Discovery_1-3) describes attributes recommended for describing a NetCDF dataset to data discovery systems. It should be possible to use the ACDD vocabulary in, e.g., GeoJSON or CoverageJSON as well.

The [CF metadata conventions](https://cfconventions.org/) define (use) metadata that provide a definitive description of what the data in each variable of a NetCDF file represents, as well as its spatial and temporal properties. This enables users to understand and reuse the data. The CF metadata conventions were created for the NetCDF format, but there are ongoing efforts to also use it for the definition of a standard JSON format for the exchange of weather and climate data; [CF-JSON](http://cf-json.org/).

Recommendations:
* The ACDD vocabulary should be used to make datasets Findable, with extensions where necessary to promote Interoperability with existing standards (e.g., DCAT, ISO19115 and profiles of these)
* The CF conventions should be followed to enable Reuse
* Use a standard license, e.g., [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/), provided by the URL in the form similar to "<URL> (<Identifier>)" using elements from the [SPDX license list](https://spdx.org/licenses/).



* BUFR
* CSV
* GeoJSON

#### 3.2.x MQTT message payload

The (draft) [WMO WIS2 Notification Message Encoding](https://wmo-im.github.io/wis2-notification-message/standard/wis2-notification-message-DRAFT.html) defines the content, structure, and encoding for the WIS2 Notification Message Encoding. The standard is an extension of the [OGC API - Features standard](https://wmo-im.github.io/wis2-notification-message/standard/wis2-notification-message-DRAFT.html#_footnotedef_3).

Requirements:
* The MQTT notification messages shall follow the (draft) [WMO WIS2 Notification Message Encoding](https://wmo-im.github.io/wis2-notification-message/standard/wis2-notification-message-DRAFT.html)

Options for the MQTT message payload:
* We have decided that actual data can be embedded in the MQTT message (as long as it below a certain size limit as defined in the MQTT definition). This should be done following the "properties" tag in the JSON schema, according to [section 7.1.7.7.](https://wmo-im.github.io/wis2-notification-message/standard/wis2-notification-message-DRAFT.html#_additional_properties) in the encoding specification.
* If data records are embedded in the message, also its discovery metadata must be embedded as ACDD attributes
* If data records are embedded in the message, also its use metadata following CF convention must be embedded 
* In this context, it must be defined how these messages relate to BUFR files or if separate messages should be submitted for the BUFR files, etc.

## 4. Integration and APIs
### 4.1. External Integrations
#### GTS

Data going in GTS network needs WMO-title “TTAAii”, which tells: the type of the data and where did it come from. WMO-title should be given in the beginning of the data. List of the TTAA  can be found in: WMO-No. 386 Document (Manual on the Global Telecommunication System, PART II, chapter 5, Attachment II-5 Data Designators T1T2A1A2ii in abbreviated headings). “ii”-part is used to separate same kind of data from another.

WIGOS identifiers can be included in some BUFR templates:
* 3 07 024: Ground-based GNSS data – slant total delay
* 3 07 092: BUFR template for surface observations from n-minute period
* 3 07 103: Snow observation, snow density, snow water equivalent
* 3 08 018: Sequence for reporting of basic ship AWS observations
* 3 09 056: Sequence for representation of radiosonde descent data
* 3 09 057: Sequence for representation of TEMP, TEMP SHIP and TEMP MOBIL observation type data with higher precision of pressure and geopotential height
* 3 11 012: BUFR template for aircraft ascent/descent profile with latitude and longitude given for each level
* 3 15 011: Met-ocean observations from autonomous surface vehicles
* 3 15 013: Sequence for reporting trajectory profile data from marine animal tags

If we are using WIS2, which has a gateway to GTS, do we need to concern about GTS anymore?

#### OSCAR

### 4.2. API Specifications
  **OGC API - Environmental Data Retrieval**
  WIS 2.0 recommendation is to use OpenAPI 3 compatible api, more specifically OGC EDR if possible. Design choise for E-SOH was to use OGC EDR API to implement api based access to data.

  Environmental Data Retrieval API (EDR) is standard by Open Gespactial Consortium

  The Environmental Data Retrieval (EDR) Application Programming Interface (API) provides a family of lightweight query interfaces to access spatio-temporal data resources by requesting data at a Position, within an Area, along a Trajectory or through a Corridor. A spatio-temporal data resource is a collection of spatio-temporal data that can be sampled using the EDR query pattern geometries. These patterns are described in the section describing the Core Requirements Class.

  The goals of the EDR API are to make it easier to access a wide range of data through a uniform, well-defined simple Web interface, and to achieve data reduction to just the data needed by the user or client while hiding much of the data storage complexity. A major use case for the EDR API is to retrieve small subsets from large collections of environmental data, such as weather observations. The important aspect is that the data can be unambiguously specified by spatio-temporal coordinates.

  Full description of EDR API can be found on OGC website https://docs.ogc.org/is/19-086r5/19-086r5.html

  **OGC API Records**
  For metadata and catalogue WMO WIS 2.0 is using OGC API - Records (draft) standard. E-SOH will use this API to provide relevant metadata to users and to WMO WIS 2.0.

  A Record makes a resource discoverable by providing summary information (metadata) about the resource. In this context, resources are things that would be useful to a user or developer, such as features.

  OGC API - Records provides a way to browse or search a curated collection of records known as a catalogue. This specification envisions deploying a catalogue as:
  * a collection of static files,
  * a collection of records accessed via an API.

  A catalogue can be deployed as a static collection of records stored in web-accessible files and typically co-located with the resources each record is describing. Such a deployment is amenable to browsing using a web browser or being crawled by a search engine crawler.

  A catalogue can also be deployed as an API with well known endpoints for retrieving information about the catalogue, retrieving records from the catalogue and searching the catalogue for sub-sets of records that satisfy user-defined search criteria.

  Full OGC API Records specification can be found on OGC webiste https://ogcapi.ogc.org/records/

### 4.3. API Authentication and Authorization
  
  For API Authentication and Authorization E-SOH will be relying on FEMDI implementation. FEMDI will implement these techniques on later iterations.

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

DWD Comments:

- Origin of the following numbers unclear?

Response Time: The time taken by the system to process a request and return a response should be within acceptable limits to provide a smooth user experience. For example, the response time for user-facing operations (time between search request, via the Search API and search result) should be under 200 milliseconds for 95% of requests and under 500 milliseconds for 99% of requests.

Throughput: The system should be able to handle a specified number of requests per second or transactions per minute without degrading performance. This metric depends on the expected usage patterns and peak loads. For example, the system should support a throughput of at least 1000 requests per second during peak times.

Resource Utilization: The system should make efficient use of available resources such as CPU, memory, disk, and network bandwidth. Resource utilization should be monitored continuously to identify bottlenecks and optimize the system accordingly. For example, CPU utilization should remain below 75% during normal operation and below 90% during peak loads.

Latency: The system should minimize the time taken for data to travel between components, such as between the front-end and back-end, or between the application and external services. For example, internal network latency should not exceed 10 milliseconds, and external API calls should have a round-trip time of no more than 100 milliseconds.

Concurrency: The system should be able to handle multiple simultaneous user sessions and requests without any loss of performance or functionality. For example, the system should support at least 500 concurrent user sessions without any degradation in response time or throughput.

Scalability: The system should be designed to scale both horizontally and vertically to accommodate increased user loads or additional functionality. Scalability requirements may include adding new servers, increasing CPU or memory resources, or deploying additional instances of the system. Depending on the cloud this may need to be done manually, especially in the EWC.

Reliability: The system should maintain consistent performance levels under normal and adverse conditions, including hardware failures, network outages, or increased traffic. For example, the system should have a target uptime of 99% and a mean time between failures (MTBF) of at least 10,000 hours.

By defining these performance requirements upfront, the development team can make informed design decisions and implement appropriate optimizations to ensure that the software system meets or exceeds the specified performance targets.

### 6.2. Performance Testing and Profiling

Regular performance testing and profiling should be conducted throughout the development process to validate that the performance requirements are being met and to identify any potential issues or bottlenecks.

These tests should include but are not limited to:

* Profiling of response and round-trip time of requests and between software procedures inside the stack
* Profiling of network and system resources and in the case of a high number of simultaneous user requests
* Testing the performance in relation to scaling horizontally and vertically
* Behavior in error- and worst-cases like hardware failures, network outages, or increased traffic

### 6.3. Caching Strategies
### 6.4. Load Balancing and Failover
### 6.5. Vertical and Horizontal Scaling

## 7. Deployment and Operations

All environments run in the EWC.

### 7.1. Deployment Environments

This section provides an overview of the deployment strategy and environments that are employed to ensure the smooth operation and management of the system. The purpose of outlining these is to create a clear understanding of how the system components are deployed, configured, and maintained across various stages of development and production.

**Development Environment:**
The development environment is where developers write, test, and debug the code for the system. It is a local setup that includes all necessary tools, frameworks, and dependencies for building and running the application components. This environment is isolated from other environments to allow developers to work on new features and improvements without affecting the stability of the system in other environments.

**Staging / Acceptance Environment:**
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

By implementing a robust CI/CD pipeline, the deployment architecture enables rapid delivery of new features and improvements, while ensuring the overall stability, security, and performance of the system. We will be using Github as a VCS and CI/CD platform, it provides a functionality for all parts of the deployment process.

### 7.3. Monitoring and Alerting

All systems and services should be monitored to identify potential issues and service downtime, validate the set performance thresholds and alert on any abnormal activities or exceeded thresholds.

The Morpheus Dashboard in the EWC can be used to monitor the created instances and VMs. It is possible to check for a machine status, if it is running and for log output which is configurable depending on the operating system.

The most important aspect is the monitoring onboard of the system. A monitoring program will be used to check continuously all relevant system parameters and send those information's to the monitoring server. The following parameters should be monitored:

* Resource Utilization (CPU, memory, disk space, network usage)
* Service availability, check if...
  * the processes are running
  * interfaces usable/reachable
  * requests and throughput are in a normal range
* Private network connections between VMs are established

To detect security attacks and possible breaches it is also important to check for changes in the file system and monitor SSH login attempts. Examples for these applications are intrusion detection systems and log monitoring tools like IDA and Fail2Ban.

Monitoring request times and functionality from an external point of view, from outside of the EWC network, could be beneficial to get a good perspective of the end user experience.

Based on all figures mentioned above, important metrics can be derived and calculated. The sum of all system functionalities build up the important _the mean time to recovery_ (MTTR) and _mean time between failure_ (MTBF) values, as well as the total uptime of the whole E-SOH system.

### 7.4. Backup and Recovery

Backup and recovery system should be implemented and tested for full functionality, either via the EWC backup functionality or some open source backup tool.

DWD: A decision is to be made, which software is suitable for this case. TDB: Where to store the backup data with geo redundancy?

### 7.5. Disaster Recovery and Business Continuity

In the event of a worst case situation, if only the source code still remains, there should be a disaster recovery procedure. This procedure includes plans for a recreation of the whole system starting from the bare source code of the E-SOH project and contains compilation of the project artifacts and creating a new and clean virtual machine setup at the EWC. To guarantee business continuity a emergency procedure plan is needed with a list of personnel who are responsible for failure recovery.

To mitigate a disaster or total loss of data a geo and service redundancy should be established at least for the project source code (e.g. automated mirroring/pulling of the public repository). Backup systems may also be created inside the EUMETSAT cloud to create further redundancy.

## 8. Maintenance and Support

### 8.1. Code Management and Versioning

The Version Control System, in this case Github, will provide code management and versioning of everything E-SOH related.

### 8.2. Bug Tracking and Issue Resolution

The Version Control System, in this case Github, will also provide bug tracking and issue resolution of everything E-SOH related.

### 8.3. Feature Enhancements and Roadmap

The Version Control System, in this case Github, will also provide feature and enhancement tracking and milestones of everything E-SOH related.

### 8.4. Documentation and Training
Initially the version control system, in this case Github, will also contain all E-SOH documentation. As soon as the system is working in a beta version user documentation and training material will be developped. This material will be made available on the platform which will be chosen in RODEO Work Package 7.
### 8.5. Support Channels and SLAs

Users should use a ticket system to alert the administration of issues regarding their experience or system/function outages. A ticket should be solved by the next business day. The SLA for the uptime specifies 99% for the beginning of the project and may be increased in the future.

DWD: Ticket software TBD, ticket solved or replied to on NBD?

## 9. Conclusion
### 9.1. Key Takeaways
### 9.2. Future Considerations
### 9.3. Final Remarks
