# Cookfluencer Search Server

This module provides a simple search server implemented with Spring Boot and Apache Lucene. It can be used to replace cloud search services such as Algolia by running your own server.

## Building

Install JDK 17 and Maven. Then run:

```bash
mvn package
```

## Running

After building, launch the server with:

```bash
java -jar target/search-server-0.0.1-SNAPSHOT.jar
```

The server listens on port `8080` by default.

## API

- `POST /api/documents` – Add a document to the index. JSON body fields: `id`, `title`, `content`.
- `GET /api/search?query=...` – Search documents by query string. Returns a JSON array of matching documents.

This example uses an in-memory index for simplicity. To persist data, integrate a database or file-based Lucene directory.
