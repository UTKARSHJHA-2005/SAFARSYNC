import pinataSDK from '@pinata/sdk';
import express from 'express';
import multer from 'multer';
import fs from 'fs';

const app = express();
const upload = multer({ dest: 'uploads/' });

const pinata = new pinataSDK(process.env.PINATA_API_KEY, process.env.PINATA_SECRET_API_KEY);

app.post('/upload', upload.single('file'), async (req, res) => {
    const readableStreamForFile = fs.createReadStream(req.file.path);

    const result = await pinata.pinFileToIPFS(readableStreamForFile);

    fs.unlinkSync(req.file.path);

    res.json({ cid: result.IpfsHash });
});

app.listen(3000, () => console.log("Server running on port 3000"));
// app.use(cors());
// app.use(express.json());

// const pool = new Pool({
//     user: "postgres",
//     host: "localhost",
//     database: "myapp",
//     password: "password",
//     port: 5432,
// });

// app.get("/users", async (req, res) => {
//     const result = await pool.query("SELECT * FROM users");
//     res.json(result.rows);
// });

// app.post("/users", async (req, res) => {
//     const { name, email } = req.body;
//     const result = await pool.query(
//         "INSERT INTO users(name, email) VALUES($1, $2) RETURNING *",
//         [name, email]
//     );
//     res.json(result.rows[0]);
// });

// app.listen(3000, () => console.log("Server running on port 3000"));