# GPT Memory API

A simple REST API for GPT responses using embeddings backed by a Redis database.

1. [Overview](#overview)
2. [Features](#features)
3. [Getting Started](#getting-started)
   1. [Prerequisites](#prerequisites)
   2. [Installation](#installation)
4. [Usage](#usage)
   1. [API Endpoints](#api-endpoints)
   2. [Example Requests](#example-requests)
5. [Configuration](#configuration)
6. [Licence](#licence)

## Overview

The GPT Memory API allows you to ingest text data to generate embeddings stored in Redis and query
a GPT model using the embeddings for enhanced context.

## Features

- **Text Ingestion**: Generate embeddings from text and store them in Redis.
- **Contextual Responses**: Query a GPT model with conversation history, using embeddings to
  improve context relevance.
- **Unix Socket Communication**: Optimised Redis communication using Unix sockets.
- **Dockerised**: Simple setup and deployment with Docker and Docker Compose.
- **Persistent Data**: Data consistency via Redis append-only file (AOF) persistence.

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/engine/install/)
- [OpenAI API key](https://platform.openai.com/docs/quickstart)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/tcpipuk/gpt-memory-api.git
   cd gpt-memory-api
   ```

2. Set up environment variables:

   ```bash
   echo "OPENAI_API_KEY=your_openai_api_key" > .env
   ```

3. Build and run the services:

   ```bash
   docker-compose up -d
   ```

## Usage

### API Endpoints

- **Ingest Text Data**
  - **POST** `/ingest`
  - Request Body:

    ```json
    {
      "text": "Your text data here."
    }
    ```

- **Answer a Query**
  - **POST** `/query`
  - Request Body:

    ```json
    {
      "conversation": [
        {"role": "system", "content": "Context message."},
        {"role": "user", "content": "User's message or query."}
      ]
    }
    ```

- **Health Check**
  - **GET** `/health`
  - Response:

    ```json
    {
      "status": "healthy"
    }
    ```

### Example Requests

- Ingest text data:

  ```bash
  curl -X POST http://localhost:8080/ingest \
       -H 'Content-Type: application/json' \
       -d '{"text": "Your text data here."}'
  ```

- Query the API:

  ```bash
  curl -X POST http://localhost:8080/query \
       -H 'Content-Type: application/json' \
       -d '{
             "conversation": [
               {"role": "system", "content": "You answer questions about the 2024 Olympics."},
               {"role": "user", "content": "Who won a gold medal for curling?"}
             ]
           }'
  ```

- Health check:

  ```bash
  curl http://localhost:8080/health
  ```

## Configuration

- **Environment Variables**
  - `OPENAI_API_KEY`: Your OpenAI API key.
  - `REDIS_SOCKET_PATH`: Path to Redis Unix socket (default: `/socket/redis.sock`).

- **Redis Configuration**
  - Redis uses AOF persistence and Unix socket communication.
  - Persistent data is stored in the `./data` directory.

## Licence

Licensed under the GNU General Public Licence v3.0. See the [LICENSE](./LICENSE) file.
