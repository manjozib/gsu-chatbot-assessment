# GSU SmartAssist API Documentation

## Overview
This documentation outlines the RESTful APIs provided by the GSU SmartAssist application. Each API endpoint is organized by its functionality, detailing the HTTP method, endpoint, description, parameters, and request/response structures where applicable.

---

## Authentication API

### User Login
- **Method**: `POST`
- **Endpoint**: `/api/auth/login`
- **Description**: Logs in a user and returns an authentication token.
  
**Request Body**:
  - `LoginRequest`: Object containing:
    - **username**: User's username.
    - **password**: User's password.

```json
{
  "username": "user",
  "password": "password"
}
```
**Response**:
  - Returns an `AuthResponse`, which includes the authentication token.

---

## Chat Log API (Admin)

### Retrieve Chat Logs
- **Method**: `GET`
- **Endpoint**: `/api/admin/chat-logs`
- **Description**: Fetches paginated chat session logs.

**Parameters**:
- `page` *(optional)*: Page number to retrieve (default: `0`).
- `size` *(optional)*: Number of records per page (default: `20`).

**Response**:
- Returns a paginated list of `ChatSession` objects.

---

## Chat API

### Send Chat Message
- **Method**: `POST`
- **Endpoint**: `/api/chat`
- **Description**: Sends a chat message and returns the chat response.

**Request Body**:
- `ChatRequest`: Object containing:
  - **message**: The message to send.
  - **sessionId**: The seesion ID.

```json
{
  "message": "message",
  "sessionId": "sessiond ID"
}
```
**Response**:
- Returns a `ChatResponse` object containing the reply.
---
## FAQ Management API (Admin)

### Create a New FAQ

- **Method**: `POST`
- **Endpoint**: `/api/admin/faqs`
- **Description**: Creates a new FAQ entry.
  
**Request Body**:
- `FaqCreateRequest`: Object containing:
  - **category**: The FAQ category.
  - **answer**: The FAQ answer.
  - **question**: The FAQ question.
  - **keywords**: The FAQ keywords.
```json
{
    "category": "string",
    "question": "string",
    "answer": "string",
    "keywords": "string"
}
```
**Response**:
- Returns a `FaqResponse` object.

## Update an Existing FAQ

- **Method**: PUT
- **Endpoint**: /api/admin/faqs/{id}
- **Description**: Updates an existing FAQ based on the provided ID.
  
**Parameters**:
- `id`: ID of the FAQ to update.
  
**Request Body**:
- `FaqCreateRequest`: Object containing updated FAQ details.
  - **category**: The FAQ category.
  - **answer**: The FAQ answer.
  - **question**: The FAQ question.
  - **keywords**: The FAQ keywords.
```json
{
    "category": "string",
    "question": "string",
    "answer": "string",
    "keywords": "string"
}
```
**Response**:
- Returns a `FaqResponse` object with updated details.

### Delete an existing FAQ
- **Method**: `DELETE`
- **Endpoint**: `/api/admin/faqs/{id}`
- **Description**: Deletes an FAQ based on the provided ID.
  
**Parameters**:
- `id`: ID of the FAQ to delete.
  
**Response**:
- Returns HTTP 204 No Content on successful deletion.

## FAQ API
### List FAQs
- **Method**: `GET`
- **Endpoint**: `/api/faqs`
- **Description**: Retrieves a paginated list of public FAQs.
  
**Parameters**:
- `page` *(optional)*: Page number to retrieve (default: `0`).
- `size` *(optional)*: Number of FAQs per page (default: `20`).
  
**Response**:
- Returns a paginated list of `FaqResponse` objects.
 
### Summary
This Markdown document provides a structured overview of the APIs available in the GSU SmartAssist application, including the authentication, chat management, and FAQ functionalities.

