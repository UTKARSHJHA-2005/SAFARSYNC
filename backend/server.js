import pinataSDK from '@pinata/sdk';
import express from 'express';
import multer from 'multer';
import fs from 'fs';
import dotenv from 'dotenv';
import { ethers } from 'ethers';
dotenv.config();

const app = express();
app.use(express.json());
const upload = multer({ dest: 'uploads/' });

// const pinata = new pinataSDK(process.env.PINATA_API_KEY, process.env.PINATA_SECRET_API_KEY);
const pinata = new pinataSDK({
    pinataJWTKey: process.env.PINATA_JWT_KEY,
});

function hashPhone(phone) {
    return ethers.keccak256(
        ethers.toUtf8Bytes(phone)
    );
}

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

app.post('/upload-json', async (req, res) => {
    try {
        const result = await pinata.pinJSONToIPFS(req.body);

        res.json({ cid: result.IpfsHash });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "JSON upload failed" });
    }
});
const provider = new ethers.JsonRpcProvider(process.env.INFURA_URL);

// Wallet (backend signer)
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const contractABI = [
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "internalType": "string",
                "name": "phoneHash",
                "type": "string"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "newCID",
                "type": "string"
            }
        ],
        "name": "ProfileUpdated",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "internalType": "string",
                "name": "phoneHash",
                "type": "string"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "profileCID",
                "type": "string"
            }
        ],
        "name": "UserRegistered",
        "type": "event"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_phoneHash",
                "type": "string"
            }
        ],
        "name": "getProfileCID",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_phoneHash",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "_profileCID",
                "type": "string"
            }
        ],
        "name": "registerUser",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_phoneHash",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "_newCID",
                "type": "string"
            }
        ],
        "name": "updateProfile",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_phoneHash",
                "type": "string"
            }
        ],
        "name": "verifyPhone",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    }
]
const contract = new ethers.Contract(
    process.env.CONTRACT_ADDRESS,
    contractABI,
    wallet
);
app.post("/register-user", async (req, res) => {
    try {
        const { phone, profileCID } = req.body;
        const phoneHash = hashPhone(phone);
        const tx = await contract.registerUser(phoneHash, profileCID);
        await tx.wait();
        console.log("User registered on blockchain:", tx.hash);
        res.json({ success: true, txHash: tx.hash });
    } catch (error) {
        console.error("Blockchain error:", error);
        res.status(500).json({ error: error.message });
    }
});

app.post("/get-profile-by-phone", async (req, res) => {
    try {
        const { phone } = req.body;
        if (!phone) return res.status(400).json({ error: "phone is required" });

        const phoneHash = hashPhone(phone);
        const cid = await contract.getProfileCID(phoneHash);

        res.json({ cid });
    } catch (error) {
        console.error("get-profile-by-phone error:", error);
        res.status(500).json({ error: "CID fetch failed" });
    }
});

// ── Get profile CID by pre-hashed phone (legacy) ───────────────────────────
app.get("/get-profile/:phoneHash", async (req, res) => {
    try {
        const phoneHash = req.params.phoneHash;
        const cid = await contract.getProfileCID(phoneHash);
        res.json({ cid });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "CID fetch failed" });
    }
});

// ── Update profile CID on blockchain ─────────────────────────────────────
app.post("/update-profile", async (req, res) => {
    try {
        const { phone, newCID } = req.body;
        if (!phone || !newCID) {
            return res.status(400).json({ error: "phone and newCID are required" });
        }

        const phoneHash = hashPhone(phone);
        const tx = await contract.updateProfile(phoneHash, newCID);
        await tx.wait();
        console.log("Profile updated on blockchain:", tx.hash);
        res.json({ success: true, txHash: tx.hash });
    } catch (error) {
        console.error("update-profile error:", error);
        res.status(500).json({ error: error.message });
    }
});
app.listen(3000, () => console.log("Server running on port 3000"));