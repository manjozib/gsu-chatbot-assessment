# 🏫 GSU SmartAssist – Intelligent University Chatbot System

_A modern, full‑stack chatbot & knowledge base system built for Gwanda State University (GSU) to improve student support, streamline information access, and empower administrators._

## 📘 1. Overview of the Solution
GSU SmartAssist is a full-stack solution consisting of:

A Spring Boot backend for authentication, chatbot logic, knowledge base management, chat logs, and rate limiting.
A Flutter frontend (GetX) providing a modern, responsive UI for both students and administrators.
A PostgreSQL database to securely store FAQs, users, and chat interactions.

The system is designed to:

Assist students with common queries
Provide instant answers through a chat interface
Allow administrators to manage the knowledge base
Offer a secure login system for staff
Ensure responsive & mobile‑friendly user experience

This project meets all requirements of the GSU ICTS Software Engineer Practical Assessment.

## 🧱 2. Architecture Explanation
### 🔹 High‑Level System Structure
Flutter UI  ⇄  REST API  ⇄  Spring Boot Backend  ⇄  PostgreSQL DB

### 🔹 Backend Architecture
Controller → Service → Repository → Entities → Database
 
### 🔹 Flutter (GetX) Architecture
View → Controller → Provider → API Service → Models

### 🔹 Key Components
Component | Description
----------|------------
Chat Engine|Retrieves KB responses and logs chats
Knowledge Base Module|CRUD for FAQs
Auth Module|JWT‑secured admin login
Rate Limiter|Protects /api/chat
Flutter UI|Chat, Admin Dashboard, Login, FAQ viewer

## 🛠 3. Technology Stack
### Backend

Java 17
- Spring Boot 3
- Spring Security (JWT)
- Spring Web MVC
- Spring Data JPA
- Flyway (DB Migrations)
- PostgreSQL
- Swagger / OpenAPI
- Docker + Docker Compose

### Frontend

- Flutter SDK >=3.0.2 <4.0.0
- GetX (state management + routing)
- Material 3 UI
- HTTP Client
- Shared Preferences

## ⚙️ 4. Setup Instructions
### Backend Setup
1️⃣ Clone the repository
```bash
git clone https://github.com/manjozib/gsu-chatbot-assessment.git
cd gsu-chatbot-assessment/backend
```

2️⃣ Install and run
```bash
mvn clean spring-boot:run
```
Backend available at:
```bash
http://<IP_ADDRESS>:8080
```

3️⃣ Open API docs
```bash
http://<IP_ADDRESS>:8080/swagger-ui/index.html
```

![End points](/screenshots/Endpoints.jpeg)

### Frontend (Flutter) Setup
1️⃣ Navigate to Flutter project
```bash
cd frontend
```
2️⃣ Install dependencies
```bash
flutter pub get
```
3️⃣ Run app
```bash
flutter run
```
4️⃣ API Base URL

Configure Server configuration by clicking this

![Chat Page](/screenshots/Chat%20Page.jpeg)

Then input backend server ip address and port number to their respective fields and then click save

![Server Config Page](/screenshots/Server%20Config%20Page.jpeg)

## 🗄 5. Database Setup
1️⃣ Create database
```bash
CREATE DATABASE gsu_smartassist;
CREATE USER gsu_user WITH ENCRYPTED PASSWORD 'gsu_pass';
GRANT ALL PRIVILEGES ON DATABASE gsu_smartassist TO gsu_user;
```
2️⃣ Flyway automatic migrations
Tables created:
- users
- knowledge_base
- chat_sessions
  
3️⃣ Auto‑generated admin
```bash
email: admin@gsu.ac.zw
password: Admin@12345
```

## 🌐 6. API Documentation Summary
Full API docs:

👉 http://<IP_ADDRESS>:8080/swagger-ui/index.html

Auth APIs
Method | Endpoint | Description
-------|----------|------------
POST| /api/auth/login | Admin login, returns JWT

Public APIs
Method | Endpoint | Description
-------|----------|------------
GET| /api/faqs| Get FAQs
POST| /api/chat| Chatbot request


Admin (Protected)
Method | Endpoint | Description
-------|----------|------------
GET| /api/admin/faqs| List all KB entries
POST| /api/admin/faqs| Create new FAQ
PUT| /api/admin/faqs/{id}| Update FAQ
DELETE| /api/admin/faqs/{id}| Delete FAQ
GET| /api/admin/chat-logs| View chat logs


## ⚠️ 7. Challenges Faced
### 🔸 JWT Key Requirements
Spring requires HS256 keys ≥ 32 bytes.
Solution: Proper Base64 or long ASCII secrets.
### 🔸 Missing Swagger Authorize Button
Solved by adding @SecurityScheme config.
### 🔸 403 Forbidden Errors
Caused by missing security requirements and token mismatch.
Fixed using @SecurityRequirement(name = "bearerAuth").
### 🔸 CORS & Networking Issues in Flutter
Solved with custom CorsFilter and using 10.0.2.2 for emulator.
### 🔸 Clean State Management
Used GetX for modular controllers and dependency injection.

## 🚀 8. Future Improvements

- 📜 Implement a log file for future debugging
- ❓ Add an FAQ category
- 📅 Allow chat logs to be filtered by date
- ⚠️ Handle HTTP status error codes effectively
- 🧠 Integrate real AI (OpenAI, LLaMA, or Rasa)
- 🌍 Add multi-language support (English, Shona, Ndebele)
- 📊 Build an analytics dashboard for admin
- 🔐 Add Multi-Factor Authentication (MFA) and refresh tokens
- ✨ Introduce animations and advanced UI
- 🌐 Deploy backend to cloud (Azure/AWS/Render)
- 📱 Add push notifications for key events
- 🧠 Improve context-aware AI chat memory



