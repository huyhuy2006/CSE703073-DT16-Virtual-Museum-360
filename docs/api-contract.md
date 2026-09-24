# DT-16 Virtual Museum 360
# API Contract v0.1

## 1. Overview

Project: DT-16. Virtual Museum and 360 Degree Tour on Web

Backend:
- PHP 8.3
- Laravel 11
- REST API

Database:
- MySQL 8.0
- Database: virtual_museum_360

Frontend:
- Vue 3
- Vite

Python service:
- Python 3.12
- FastAPI
- pandas
- scikit-learn

---

## 2. API Base URL

Development:

/api

Production:

/api

All API responses use JSON.

---

## 3. Authentication

### POST /api/auth/login

Purpose:
Authenticate a user.

Request:

{
  "email": "user@example.com",
  "password": "password"
}

Response 200:

{
  "message": "Login successful",
  "user": {
    "id": 1,
    "name": "Demo User",
    "email": "user@example.com"
  },
  "token": "..."
}

Possible status codes:

- 200 OK
- 401 Unauthorized
- 422 Unprocessable Entity

---

### POST /api/auth/logout

Purpose:
Logout the current user.

Authentication:
Required.

Response 200:

{
  "message": "Logout successful"
}

Possible status codes:

- 200 OK
- 401 Unauthorized

---

## 4. Museum Spaces

### GET /api/spaces

Purpose:
Return available museum spaces.

Response 200:

{
  "data": [
    {
      "id": 1,
      "name": "Main Exhibition Hall",
      "description": "..."
    }
  ]
}

Possible status codes:

- 200 OK
- 500 Internal Server Error

---

### GET /api/spaces/{id}

Purpose:
Return detail of a museum space.

Path parameter:

- id: integer

Response 200:

{
  "data": {
    "id": 1,
    "name": "Main Exhibition Hall",
    "description": "...",
    "panorama": {},
    "hotspots": [],
    "transitions": []
  }
}

Possible status codes:

- 200 OK
- 404 Not Found

---

### POST /api/spaces

Purpose:
Create a museum space.

Authentication:
Admin required.

Request:

{
  "name": "New Exhibition Hall",
  "description": "..."
}

Possible status codes:

- 201 Created
- 401 Unauthorized
- 403 Forbidden
- 422 Unprocessable Entity

---

### PUT /api/spaces/{id}

Purpose:
Update a museum space.

Authentication:
Admin required.

Possible status codes:

- 200 OK
- 401 Unauthorized
- 403 Forbidden
- 404 Not Found
- 422 Unprocessable Entity

---

### DELETE /api/spaces/{id}

Purpose:
Delete a museum space.

Authentication:
Admin required.

Possible status codes:

- 204 No Content
- 401 Unauthorized
- 403 Forbidden
- 404 Not Found

---

## 5. Panoramas

### GET /api/spaces/{spaceId}/panorama

Purpose:
Return the 360 degree panorama of a museum space.

Response 200:

{
  "data": {
    "id": 1,
    "space_id": 1,
    "image_url": "...",
    "tile_url": "..."
  }
}

Possible status codes:

- 200 OK
- 404 Not Found

---

## 6. Artifacts

### GET /api/artifacts

Purpose:
Return museum artifacts.

Query parameters:

- search
- space_id
- language_id

Example:

/api/artifacts?search=history&space_id=1

Response 200:

{
  "data": [
    {
      "id": 1,
      "name": "Artifact Name",
      "description": "...",
      "space_id": 1
    }
  ]
}

Possible status codes:

- 200 OK
- 422 Unprocessable Entity

---

### GET /api/artifacts/{id}

Purpose:
Return artifact detail.

Response 200:

{
  "data": {
    "id": 1,
    "name": "Artifact Name",
    "description": "...",
    "hotspots": [],
    "audio_narrations": []
  }
}

Possible status codes:

- 200 OK
- 404 Not Found

---

## 7. Hotspots

### GET /api/spaces/{spaceId}/hotspots

Purpose:
Return all hotspots in a panorama.

Response 200:

{
  "data": [
    {
      "id": 1,
      "artifact_id": 1,
      "yaw": 120.5,
      "pitch": -10.2
    }
  ]
}

Possible status codes:

- 200 OK
- 404 Not Found

---

### POST /api/hotspots

Purpose:
Create an artifact hotspot.

Authentication:
Admin required.

Request:

{
  "artifact_id": 1,
  "space_id": 1,
  "yaw": 120.5,
  "pitch": -10.2
}

Possible status codes:

- 201 Created
- 401 Unauthorized
- 403 Forbidden
- 422 Unprocessable Entity

---

## 8. Space Transitions

### GET /api/spaces/{spaceId}/transitions

Purpose:
Return possible transitions from a museum space.

Response 200:

{
  "data": [
    {
      "id": 1,
      "from_space_id": 1,
      "to_space_id": 2
    }
  ]
}

Possible status codes:

- 200 OK
- 404 Not Found

---

## 9. Tours

### GET /api/tours

Purpose:
Return available themed tours.

Response 200:

{
  "data": [
    {
      "id": 1,
      "name": "Historical Tour",
      "description": "...",
      "stops": []
    }
  ]
}

Possible status codes:

- 200 OK

---

### GET /api/tours/{id}

Purpose:
Return a themed tour with ordered stops.

Response 200:

{
  "data": {
    "id": 1,
    "name": "Historical Tour",
    "stops": [
      {
        "order": 1,
        "space_id": 1
      },
      {
        "order": 2,
        "space_id": 2
      }
    ]
  }
}

Possible status codes:

- 200 OK
- 404 Not Found

---

## 10. Audio Narration

### GET /api/artifacts/{artifactId}/audio

Purpose:
Return multilingual audio narration for an artifact.

Query parameter:

- language

Example:

/api/artifacts/1/audio?language=en

Response 200:

{
  "data": [
    {
      "language": "en",
      "audio_url": "..."
    }
  ]
}

Possible status codes:

- 200 OK
- 404 Not Found

---

## 11. Guestbook

### GET /api/guestbook

Purpose:
Return guestbook entries.

Response 200:

{
  "data": [
    {
      "id": 1,
      "user_name": "Visitor",
      "content": "Great virtual museum!"
    }
  ]
}

---

### POST /api/guestbook

Purpose:
Create a guestbook entry.

Request:

{
  "content": "Great virtual museum!"
}

Possible status codes:

- 201 Created
- 422 Unprocessable Entity

---

## 12. Personal Collection

### GET /api/collections

Purpose:
Return the authenticated user's personal collection.

Authentication:
Required.

Response 200:

{
  "data": [
    {
      "id": 1,
      "artifact_id": 1
    }
  ]
}

Possible status codes:

- 200 OK
- 401 Unauthorized

---

### POST /api/collections

Purpose:
Add an artifact to the personal collection.

Authentication:
Required.

Request:

{
  "artifact_id": 1
}

Possible status codes:

- 201 Created
- 401 Unauthorized
- 422 Unprocessable Entity

---

### DELETE /api/collections/{id}

Purpose:
Remove an artifact from the personal collection.

Authentication:
Required.

Possible status codes:

- 204 No Content
- 401 Unauthorized
- 404 Not Found

---

## 13. Visitor Behavior

### POST /api/behavior-events

Purpose:
Record visitor behavior.

Request:

{
  "event_type": "view_panorama",
  "space_id": 1,
  "artifact_id": 1,
  "metadata": {}
}

Possible status codes:

- 201 Created
- 422 Unprocessable Entity

---

## 14. Analytics

### GET /api/analytics/visitor-behavior

Purpose:
Return visitor behavior statistics.

Authentication:
Admin required.

Response 200:

{
  "data": {
    "total_visitors": 0,
    "popular_spaces": [],
    "popular_artifacts": [],
    "popular_tours": []
  }
}

Possible status codes:

- 200 OK
- 401 Unauthorized
- 403 Forbidden

---

## 15. Python Analytics Service

### POST /analytics/process

Purpose:
Process visitor behavior data.

Service:

Python 3.12 + FastAPI

Request:

{
  "events": []
}

Response 200:

{
  "status": "success",
  "analytics": {}
}

Possible status codes:

- 200 OK
- 422 Unprocessable Entity
- 500 Internal Server Error

---

## 16. Common HTTP Status Codes

| Code | Meaning |
|---|---|
| 200 | OK |
| 201 | Created |
| 204 | No Content |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Unprocessable Entity |
| 500 | Internal Server Error |

---

## 17. API Design Principles

1. REST API architecture.
2. JSON request and response format.
3. Authentication is required for protected resources.
4. Authorization is checked on the backend.
5. Admin operations require appropriate permissions.
6. Input validation is performed on the server.
7. Database access uses Laravel Eloquent ORM.
8. API endpoints must remain consistent with the MySQL data model.
9. Visitor behavior events are stored for analytics.
10. Python analytics is separated from the Laravel application layer.

---

## 18. Version

API Contract Version: 0.1

Project: DT-16 Virtual Museum 360

Course: CSE703073

Status: Draft
