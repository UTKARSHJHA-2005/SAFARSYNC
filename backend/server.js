import pinataSDK from '@pinata/sdk';
import express from 'express';
import multer from 'multer';
import fs from 'fs';
import dotenv from 'dotenv';
dotenv.config();

const app = express();
const upload = multer({ dest: 'uploads/' });

// const pinata = new pinataSDK(process.env.PINATA_API_KEY, process.env.PINATA_SECRET_API_KEY);
const pinata = new pinataSDK({
    pinataJWTKey: process.env.PINATA_JWT
});

app.post('/upload', upload.single('file'), async (req, res) => {
    try {
        console.log("Upload route hit");

        const readableStreamForFile = fs.createReadStream(req.file.path);

        const options = {
            pinataMetadata: {
                name: req.file.originalname || "profile-image",
            },
        };

        const result = await pinata.pinFileToIPFS(
            readableStreamForFile,
            options
        );

        fs.unlinkSync(req.file.path);

        console.log("Uploaded to Pinata:", result.IpfsHash);

        res.json({ cid: result.IpfsHash });

    } catch (error) {
        console.error("Backend error:", error);
        res.status(500).json({ error: error.message });
    }
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