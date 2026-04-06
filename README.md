# User Management App

A full-stack CRUD application for user profile management.

### Tech Stack
-   **Frontend:** HTML, CSS, JavaScript
-   **Backend:** Node.js, Express
-   **Database:** MySQL

### Key Features
-   Create, Read, Update, Delete (CRUD) user profiles.
-   Search users by ID.

### Setup

1.  **Installation:** Run `npm install`.
2.  **Database:** Execute `schema.sql` on your MySQL server.
3.  **Configuration:** Update the database credentials in `server.js`.
4.  **Run:** Run `npm start` and access `http://localhost:3000`.

### API Endpoints
-   `GET /getUsers` - Retrieve all users.
-   `POST /searchUser` - Search for a user.
-   `POST /addUser` - Add a new user.
-   `PUT /updateUser` - Update user details.
-   `DELETE /deleteUser` - Delete a user.
