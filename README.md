# Cop Friendly App — Eseva
Police Complaint Management System (HTML + CSS + JS + Node.js + MySQL)

## Project Structure

```
eseva/
├── server.js       ← Express REST API (backend)
├── index.html      ← Frontend UI (open in browser)
├── package.json    ← Node dependencies
├── schema.sql      ← MySQL setup script
└── README.md
```

## Setup Steps

### 1. Set up MySQL
Open MySQL Workbench or terminal and run:
```sql
source schema.sql
```
Or copy-paste the contents of `schema.sql` into your MySQL client.

### 2. Configure DB credentials
Open `server.js` and edit lines 11–15:
```js
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'yourpassword',   // ← your MySQL password
  database: 'eseva_db'
});
```

### 3. Install Node dependencies
```bash
npm install
```

### 4. Start the server
```bash
npm start
# or for auto-reload during development:
npm run dev
```

### 5. Open the app
Open `index.html` directly in your browser, or go to:
```
http://localhost:3000
```

## API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| POST   | /api/complaints | Submit new complaint |
| GET    | /api/complaints/my | View user's complaints |
| GET    | /api/complaints/all | View all complaints |
| PATCH  | /api/complaints/:id/resolve | Mark as resolved |
| GET    | /api/complaints/pending | View pending (via SQL view) |
