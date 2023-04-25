
## Elasticsearch

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
