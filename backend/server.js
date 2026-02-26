const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "myapp",
    password: "password",
    port: 5432,
});

app.get("/users", async (req, res) => {
    const result = await pool.query("SELECT * FROM users");
    res.json(result.rows);
});

app.post("/users", async (req, res) => {
    const { name, email } = req.body;
    const result = await pool.query(
        "INSERT INTO users(name, email) VALUES($1, $2) RETURNING *",
        [name, email]
    );
    res.json(result.rows[0]);
});

app.listen(3000, () => console.log("Server running on port 3000"));