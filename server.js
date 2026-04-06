const express = require('express');
const mysql   = require('mysql2');
const cors    = require('cors');
const path    = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// ---- DB CONFIG — update password if needed ----
const db = mysql.createConnection({
  host: 'localhost', user: 'appuser', password: '1234', database: 'cop_friendly_app'
});
db.connect(err => {
  if (err) console.error('DB Error:', err.message);
  else     console.log('MariaDB connected.');
});

// ---- ROUTES ----

// Submit complaint
app.post('/api/complaints', (req, res) => {
  const { user_id, complaint_type, description } = req.body;
  if (!user_id || !complaint_type || !description)
    return res.status(400).json({ error: 'All fields required.' });
  db.query(
    'INSERT INTO complaints (user_id, complaint_type, description) VALUES (?,?,?)',
    [user_id, complaint_type, description],
    (err, r) => err ? res.status(500).json({ error: err.message }) : res.json({ id: r.insertId })
  );
});

// My complaints (by user_id)
app.get('/api/complaints/user/:uid', (req, res) => {
  db.query(
    'SELECT complaint_id, complaint_type, status, created_at FROM complaints WHERE user_id=?',
    [req.params.uid],
    (err, rows) => err ? res.status(500).json({ error: err.message }) : res.json(rows)
  );
});

// All complaints
app.get('/api/complaints/all', (req, res) => {
  db.query(
    'SELECT c.complaint_id, u.name, c.complaint_type, c.status, c.created_at FROM complaints c JOIN users u ON c.user_id=u.user_id',
    (err, rows) => err ? res.status(500).json({ error: err.message }) : res.json(rows)
  );
});

// Pending (via view)
app.get('/api/complaints/pending', (req, res) => {
  db.query('SELECT * FROM pending_complaints',
    (err, rows) => err ? res.status(500).json({ error: err.message }) : res.json(rows)
  );
});

// Resolve
app.patch('/api/complaints/:id/resolve', (req, res) => {
  db.query(
    "UPDATE complaints SET status='Resolved' WHERE complaint_id=?",
    [req.params.id],
    (err, r) => {
      if (err) return res.status(500).json({ error: err.message });
      if (r.affectedRows === 0) return res.status(404).json({ error: 'ID not found.' });
      res.json({ message: `Complaint #${req.params.id} resolved.` });
    }
  );
});

// Audit log
app.get('/api/audit', (req, res) => {
  db.query('SELECT * FROM audit_log ORDER BY changed_at DESC LIMIT 20',
    (err, rows) => err ? res.status(500).json({ error: err.message }) : res.json(rows)
  );
});

// EOD Batch procedure
app.post('/api/eod', (req, res) => {
  db.query('CALL eod_auto_resolve()',
    (err, rows) => err ? res.status(500).json({ error: err.message }) : res.json(rows[0][0])
  );
});

app.listen(3000, () => console.log('Eseva running → http://localhost:3000'));