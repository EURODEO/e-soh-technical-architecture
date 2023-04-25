## Event sourcing architecture scenario

WIS 2.0 is required to have Replay functionality, where the user can request missed notification messages
for a certain period. This means that E-SOH must also have this Replay functionality.
Thus, all notifications have to be stored in some way.

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

An example C4 diagram using Elastissearch as event store is given below.

![](https://github.com/EURODEO/e-soh-c4/blob/main/03-container-diagram/c4-container-elastic-data-store-event.png) 

[//]: # (![]&#40;c4-container-data-store.png&#41; )
