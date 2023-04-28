# Technical Architecture Document for E-SOH

## 1. Introduction

### 1.1. Purpose of the Document

The purpose of this Technical Design Document (TDD) is to provide a comprehensive and detailed description of the software system being developed, to serve as a reference for all stakeholders involved in the project. This document aims to:
* Define the software's architecture, components, and their relationships.
* Communicate the design decisions and rationale behind the chosen solutions.
* Provide clear specifications and guidelines for the development team to ensure consistent implementation of features and functionality.
* Establish a baseline for testing and validation, ensuring that the software meets the requirements and design goals.
* Serve as a reference for future maintenance, support, and enhancement of the software system.

The TDD is intended to be a living document, updated as necessary throughout the software development life cycle to reflect any changes or refinements made to the system design. It is essential for all stakeholders, including project managers, developers, testers, and end-users, to have a clear understanding of the software system's design to ensure effective collaboration and successful project completion.

### 1.2. Scope of the System

The vision of the EUMETNET Supplementary Observations dataHub (E-SOH) is to deliver the first component of an FEMDI, that is sustainable and meets the technical requirements and standards of international bodies, including WMO (e.g., WIS 2.0) and the European Union (e.g., HVD). The aim is to enable increased sharing of observations and to allow a gradual transition from the use of the Global Telecommunication System (GTS) to the use of the Internet for collection and distribution of information. In particular, E-SOH is selected as a demonstration project of WIS 2.0 in order to be used to illustrate, evolve, validate and/or refine its concepts, solutions, and implementation approach.


### 1.3. Definitions, Acronyms, and Abbreviations

| Abbreviation  | Meaning                                                                          |
|---------------|----------------------------------------------------------------------------------|
| ACDD          | [Attribute Convention for Data Discovery](https://wiki.esipfed.org/Attribute_Convention_for_Data_Discovery) |
| API           | [Application Programming Interface](https://en.wikipedia.org/wiki/API)                                                |
| AWS           | Automatic Weather Station                                                        |
| BUFR          | Binary Universal Form for the Representation of meteorological data              |
| CSV           | [Comma Separates Values - tabular data model](https://www.w3.org/TR/tabular-data-model/) |
| CoverageJSON  | [OGC CoverageJSON Community Standard for publishing spatiotemporal data to the Web](https://opengeospatial.github.io/ogcna-auto-review/21-069.html)|
| DCAT          | [Data Catalog Vocabulary](https://www.w3.org/TR/vocab-dcat/)                     |
| DCAT-AP       | [DCAT Application profile for data portals in Europe](https://op.europa.eu/en/web/eu-vocabularies/dcat-ap) |
| EDR           | [OGC API - Environmental Data Retrieval](https://ogcapi.ogc.org/edr/)            |
| E-SOH         | EUMETNET Supplementary Observation dataHub                                       |
| EUMETNET      | [A Network of 31 European NMHSs](https://eumetnet.eu)|
| EUMETSAT      | [European Organisation for the Exploitation of Meteorological Satellites ](https://eumetsat.int) |
| EWC           | [European Weather Cloud](https://www.europeanweather.cloud)                      |
| FEMDI         | Federated European Meteorological Data Infrastructure                            |
| GTS           | [WMO Global Telecomminications System](https://public.wmo.int/en/programmes/global-telecommunication-system) |
| JSON          | JavaScript Object Notation [ISO/IEC 21778:2017](https://www.iso.org/obp/ui/#iso:std:iso-iec:21778:ed-1:v1:en) |
| MQTT          | [lightweight publish/subscribe messaging transport protocol](https://en.wikipedia.org/wiki/MQTT)                   |
| MTBF          | mean time between failures is the average time between repairable failures       |
| MTTR          | mean time to repair is the average time it takes to repair a system              |
| NMHS          | National Meteorological & Hydrological Services                                  |
| OGC           | [Open Geospatial Consortium](https://ogc.org)                                    |
| OSCAR         | [Observing Systems Capability Analysis and Review tool](https://community.wmo.int/en/activity-areas/WIGOS/implementation-WIGOS/OSCAR)|
| SLA           | [Service-level agreement](https://en.wikipedia.org/wiki/Service-level_agreement) |
| VCS           | [Version Control System](https://en.wikipedia.org/wiki/Version_control)          |
| WIGOS         | [WMO Integrated Global Observing System](https://community.wmo.int/en/activity-areas/WIGOS)                 |
| WIS           | [WMO Information System](https://community.wmo.int/en/activity-areas/wis)        |
| WMO           | [World Meteorological Organization](https://wmo.int)                             |

### 1.4. References

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
The diagram below depicts the landscape of the E-SOH system.

![C4 landscape diagram](https://github.com/EURODEO/e-soh-c4/blob/main/02-landscape-diagram/E-SOH-C4-landscape-diagram.png)

On top is the data consumer who is interested in the real-time weather observations. The data consumer can get the data in two ways:
1. Via the WIS2 Shared services. The WIS2.0 shared services will replace the GTS. In the future the user will be able to retrieve observation data directly from the E-SOH instances (if the local instance allow this). The WIS2.0 shared services will also provide BUFR files.
2. Via the FEMDI system. The FEMDI system will be build in RODEO Work package It will contain the Data Catalogue and a central API Gateway which will forward the API queries from the user to the Central API from the federated E-SOH system.

The E-SOH federated system consists of a central E-SOH API endpoint, and one local E-SOH instance. Both will be run centrally from the European Weather Cloud. The architecture takes into account local E-SOH implementations. In the diagram only one local E-SOH implementation is depicted, but there can be more.
The Central E-SOH API endpoint connects the local E-SOH instance within the federated system and all the local E-SOH implementations.

All local E-SOH instances get data from Observation collection systems and metadata from Oscar. This also goes for the local E-SOH implementation on the right in the diagram, but the arrows are not drawn to keep the picture as simple as possible.



#### 2.1.3. Container Diagram

The container diagram below shows all the main components of the E-SOH system.  

![C4 container diagram](https://github.com/EURODEO/e-soh-c4/blob/main/03-container-diagram/c4-container-diagram.png)

On the right is the Central E-SOH API Endpoint. In the middle are all the components of an E-SOH local instance. Each local E-SOH instance consists of 7 components:
1. Ingestion. This component will take care of the ingestion of observation data both via push and pull mechanisms.  
2. Notification service. This component provides notifications to the external systems as soon as new data is ingested, so the data can be pulled by the external systems.
3. Output encoder. This component is called upon by the Access API if a user wants a specific format like BUFR.
4. Data and metadata store. The main storage component for data and metadata. It has the memory of a goldfish: it will hold the data only for 24 hours. 
5. Input decoder. This component is called upon by the Ingestion component for decoding BUFR and csv input. It will use OSCAR to retrieve missing station metadata.
6. Search and access API's. The endpoint for both the Central E-SOH API endpoint and external WIS2.0 services.
7. Logging, monitoring, alerting and reporting. This component will do the logging, monitoring and alerting for all the components within the E-SOH local instance. It will also produce reports with metrics based of the [Key Performance Indicators (KPIs)](https://github.com/EURODEO/e-soh-kpis).


### 2.2. Components and Interfaces

## 3. Detailed Design
### 3.1. Component Design

#### 3.1.1 Data and Metadata Store
​
#### Datastore alternatives
​
Several different implementation principles for the data store were considered. On top level the scenarios differ by two means:
​
* relational database vs. noSQL (here especially: document) databases
* conventional master data vs. event streaming approach (i.e. series of events stored form the source of truth)

First we talk about the different data storage​ alternatives, then we discuss the options of event sourcing or more conventional operating principles.

##### Document database approach
​
Document database approach relies entirely on noSQL database able to store JSON documents. For this purpose there are open source projects like MongoDB and Elastic. 
​
In this project Elastic (formerly Elasticsearch) is investigated and evaluated (see the PoC report). Elastic supports geo-queries and is a distributed database system (reliability and scalability). 
​
The principle of the document-based database approach is shown in the following diagram

![](https://raw.githubusercontent.com/EURODEO/e-soh-c4/main/04-component-diagrams/datastore-options/c4-container-elastic-data-store-conventional.png)
​
​
##### Relational database approach
​
Relational database with narrow tables can provide a flexible solution for numerical point data and metadata. PostGIS extension to PostgreSQL adds geospatial query capability and there's also an extension called timescaleDB to enhance time series performance in PostgreSQL environment.

The relational database approach is similar to the document database approach (See above), the only change will be the actual database itself. 
​
![](https://raw.githubusercontent.com/EURODEO/e-soh-c4/main/04-component-diagrams/datastore-options/c4-container-relational-data-store-conventional.png)
​
##### Relational database with JSON capability
​
E.g. PostgreSQL and MySQL support JSON datatype. That makes it possible to support structured and semi-structured data in relational database by adding a column for JSON data. 
​
The relational database with JSON capability will bridge the fast column lookups from the relational database with the flexibility from the document database approach. This hybrid model is built by the same components as in the relational database (See previous subsection), the only difference is the special JSON datatype column. Probably JSON-queries in pure document-based database will be faster than this hybrid model, but we still maintain the speed from the relational columns.

##### Files-based storage
​
Files-based storage was considered, but as query logic has to be implemented separately and there is requirements for structured data and queries, we do not consider it as a feasible option for implementation. There's also another downside with files which is challenge to update minor changes (e.g. incoming QC updates some minutes after the initial observation time) in the middle of the files. When using files, there are typically also some challenges with locking while writing -- in databases there are transactions to handle this// 2c
 better for multiple calls.
​
If files-based datasets, e.g. 2d/3d imaging data or similar, needs to be handled, the support can be added e.g. by integrating S3 object storage into the system and using references to file URLs from the database. Database system will then serve also as a (discovery) metadata backend for files.


#### Event sourcing architecture scenario

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


#### Conclusion
The final data store will be selected from the three options mentioned above (Relational, Document-based, and Relational with JSON-extension). This will be done after further analysis (by continuing the Proof Of Concepts work) taking into account the following criteria:

- Technical suitability to meet the requirements
- High enough performance for all relevant use cases
    - ex. (Different read/writing operation scenarios)
- Operability
    - Sufficient competence and steepness of learning curve
    - Costs
- Life cycle management
    - Wide community adoption
    - Maturity versus lifetime expectancy


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
* In order to obtain traceability, a child dataset must reference its parent dataset by the parent's metadata identification. The parent dataset's metadata identification is expected to be persistent and actionable, but the NRT dataset identification is not.
* To support interoperability, it must be possible to translate from the agreed data-following standards to other standards (e.g., DCAT, ISO19115, etc.).
* All datasets must have defined use constraints provided by a standard license or release statement ("no rights reserved").
* All datasets must have defined access constraints (in particular for fully or partly restricted datasets, although this is not currently in the scope  of E-SOH). The optional access constraints must be defined by a controlled vocabulary.

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
* We have decided that actual data can be embedded in the MQTT message (as long as it is below a certain size limit as defined in the MQTT definition). This should be done following the "properties" tag in the JSON schema, according to [section 7.1.7.7.](https://wmo-im.github.io/wis2-notification-message/standard/wis2-notification-message-DRAFT.html#_additional_properties) in the encoding specification.
* If data records are embedded in the message, also its discovery metadata must be embedded as ACDD attributes
* If data records are embedded in the message, also its use metadata following the CF conventions must be embedded 
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
OSCAR/Surface is the World Meteorological Organization's official repository of WIGOS metadata for all surface-based observing stations and platforms. Metadata on the capabilities of observing stations / platforms and their instruments and methods of observation, are routinely submitted to and maintained in OSCAR/Surface by WMO Members. The E-SOH system will retrieve metadata about the observation station from Oscar in case it is missing in provided data (i.e. BUFR or CSV-input)
Station metadata can be pulled from Oscar/Surface with a REST API is available here: 
https://oscar.wmo.int/surface/rest/api/search/station?territoryName=NLD 
(This call will get you all the dutch observation stations)
Documentation on how to use the OSCAR REST API available here: https://oscar.wmo.int/surface/#/ 

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

The OGC API Features and OGC API EDR standards support specifying limits on number of returned responses on both client and server side. Server side limiting will support this throttling functionality and could be one option to be used at the API level. Clients can also ask to limit the response and in this case the server should limit the number of responses and enable paging functionality. If responses exceed the limit the client is given a “next” link to get more responses.

Additionally API's could and should be protected on the network level for example based on IP address and/or other possible identifiers. This kind of hard limiting can be understood as rate limiting. In this case the server should respond with HTTP 429 Too Many Requests response. Note that the server in this case can be something else than the actual server providing the API ie. an external firewall or load balancer.

The FEMDI, WIS2 and E-SOH documentation does not directly mention API Rate limiting and throttling. Two E-SOH requirements, [F02](https://github.com/EURODEO/e-soh-requirements/blob/main/functional-and-non-functional-requirements/functional-and-non-functional-requirements.md#f02---247-availability) and [F28](https://github.com/EURODEO/e-soh-requirements/blob/main/functional-and-non-functional-requirements/functional-and-non-functional-requirements.md#f28---e-soh-to-scale-to-user-demands-for-data) however indirectly touch on the issue. It is assumed that the above measures will be sufficient to address these requirements.

## 5.Security and Privacy
### 5.1. Data Protection and Encryption
### 5.2. Authentication and Authorization
### 5.3. Auditing and Logging

Effective auditing and logging are essential for monitoring the software system's performance, detecting security incidents, and ensuring regulatory compliance. This section highlights key practices for implementing and managing a robust auditing and logging strategy:

  1. Comprehensive Logging: Capture detailed logs for user activities, system events, and potential security incidents to enable effective analysis and investigation.

  2. Log Format and Structure: Use a consistent and structured log format, such as JSON, to facilitate automated log processing and analysis.

  3. Log Retention and Storage: Define a log retention policy to ensure logs are stored securely and retained for a sufficient duration to meet compliance requirements and support incident response.

  4. Access Control: Limit access to logs to authorized personnel, protecting sensitive information and maintaining the integrity of the logs.

  5. Log Monitoring and Analysis: Implement real-time log monitoring and analysis using tools like SIEM solutions to detect and respond to potential security incidents and performance issues.

  6. Audit Trails: Maintain audit trails to track changes in the system, such as configuration updates, user privilege modifications, or sensitive data access, enabling accountability and traceability.

  7. Compliance: Ensure logging and auditing practices meet relevant industry standards, regulatory requirements, or internal policies, and are regularly reviewed and updated as needed.
 
  By following these practices, the development team can establish a robust and effective auditing and logging strategy, contributing to the software system's security, reliability, and compliance.

### 5.4. Secure Coding Practices

Adopting secure coding practices is essential to protect the software system from potential security vulnerabilities and threats. This section outlines the recommended practices and guidelines for the development team to follow in order to create a secure and robust software system.

  1. Input Validation: Validate all user inputs, both on the client-side and server-side, to prevent injection attacks such as SQL injection, cross-site scripting (XSS), and command injection. Use allow-lists, reject known malicious inputs, and sanitize data before processing.

  2. Output Encoding: Encode all outputs, especially those derived from user input, to protect against XSS attacks and ensure that data is displayed correctly. Use standard output encoding libraries and follow the appropriate encoding rules for different contexts, such as HTML, JavaScript, or JSON.

  3. Authentication: Implement strong authentication mechanisms using industry-standard algorithms and protocols, such as OAuth 2.0, OpenID Connect, or SAML. Use multi-factor authentication (MFA) for sensitive operations and protect user credentials with secure password storage techniques, such as hashing with a unique salt.

  4. Authorization: Apply the principle of least privilege, granting users and services access only to the resources they require. Use role-based access control (RBAC) and ensure that sensitive operations are restricted to authorized users. Regularly review and update access permissions to prevent privilege escalation.

  5. Session Management: Use secure session management techniques, including generating unique session IDs, enforcing session timeouts, and regularly invalidating sessions. Protect session cookies with the Secure and HttpOnly flags and avoid transmitting session IDs over insecure channels.

  6. Cryptography: Use strong, up-to-date cryptographic algorithms and libraries to protect sensitive data in transit and at rest. Follow best practices for key management, such as using hardware security modules (HSMs) or key management services (KMS), and securely storing and rotating encryption keys.

  7. Error Handling: Implement proper error handling and exception management to prevent information leakage and ensure that the system fails securely. Do not expose sensitive information or system details in error messages, logs, or API responses.

  8. Logging and Auditing: Implement comprehensive logging and auditing to track user activities, system events, and potential security incidents. Ensure that logs are stored securely, with access limited to authorized personnel, and regularly review logs for signs of suspicious activity.

  9. Dependency Management: Keep all dependencies, such as libraries and frameworks, up to date and regularly review them for known security vulnerabilities. Use tools like software composition analysis (SCA) to automatically detect and manage security issues in third-party components.

  10. Secure Development Lifecycle: Integrate security into every stage of the software development process, from design and coding to testing and deployment. Conduct regular security assessments, such as code reviews, penetration testing, and vulnerability scanning, to identify and remediate security risks.

By following these secure coding practices, the development team can minimize the likelihood of security vulnerabilities in the software system and help protect it from potential threats. Regular training and awareness programs should be provided to ensure that all team members are familiar with these practices and understand the importance of security in software development.

### 5.5. Vulnerability and Threat Mitigation

Mitigating vulnerabilities and threats is crucial for the software system's security and integrity. This section highlights the key practices for identifying and addressing potential risks:

  1. Security Assessments: Regularly conduct code reviews, penetration testing, and vulnerability scanning to proactively identify and address risks.

  2. Patch Management: Keep software dependencies up to date and implement a systematic process for deploying security patches.

  3. Threat Modeling: Perform threat modeling during the design phase to identify attack vectors, assess risks, and develop countermeasures.

  4. Incident Response: Establish a formal security incident response plan and train the team on roles and responsibilities.

  5. Information Sharing: Participate in industry-specific initiatives to stay informed about the latest threats, vulnerabilities, and best practices.

  6. Continuous Monitoring: Implement real-time monitoring using tools like intrusion detection systems (IDS) and security information and event management (SIEM) solutions.

  7. Secure Development Lifecycle (SDLC): Integrate security into every stage of the development process, including secure coding practices and regular security training.

  8. Zero Trust Architecture: Adopt a zero trust approach, verifying all access requests and implementing network segmentation, strong authentication, and granular authorization controls.

Implementing these strategies will help proactively address security risks and ensure the software system's resilience. Regular review and adaptation in response to the evolving threat landscape will contribute to long-term security and success.

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

To mitigate temporal outages of some instances, a orchestration software like Kubernetes should be used. Such a software can automatically restart containers or provide new instantiated ones.

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

Users should use a ticket system to alert the administration of issues regarding their experience or system/function outages. A ticket should be worked on by the next business day and should be solved by best effort. The SLA for the uptime specifies 99% for the beginning of the project and may be increased in the future.

DWD: Ticket software TBD

### 8.6 Open Source License: Apache License 2.0

The software system has been designed as an open-source project, allowing others to view, modify, and distribute the source code under the terms of the Apache License, Version 2.0. The Apache License 2.0 was selected for this project for the following reasons:

  1. Permissive Licensing: The Apache License 2.0 is a permissive open-source license that allows for free use, modification, and distribution of the software, without imposing strict copyleft requirements. This encourages widespread adoption, collaboration, and innovation within the community.

  2. Compatibility: The Apache License 2.0 is compatible with many other open-source licenses, including the GNU General Public License (GPL) version 3, which makes it easier to integrate with third-party libraries, frameworks, or components used in the system.

  3. Intellectual Property Protection: The Apache License 2.0 provides strong protection for contributors by granting a patent license to users, helping to protect against potential patent infringement claims.

  4. Community Acceptance: The Apache License 2.0 is widely used and well-accepted within the open-source community, making it a suitable choice for this project to ensure smooth collaboration with other developers and organizations.

By selecting the Apache License 2.0 for this project, the development team aims to foster an open, collaborative environment that encourages contributions and improvements from the community, while providing legal protection and flexibility for both contributors and users.

## 9. Conclusion
### 9.1. Key Takeaways
### 9.2. Future Considerations
### 9.3. Final Remarks
