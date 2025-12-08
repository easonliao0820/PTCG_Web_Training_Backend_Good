import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { pool } from "./db.js";

const router = express.Router();
const JWT_SECRET = "super_secret_key_change_it";

// 使用者註冊
router.post("/register", async (req, res) => {
    const { username, password, email } = req.body;

    if (!username || !password || !email) {
        return res.status(400).json({ error: "缺少必要欄位" });
    }

    try {
        const conn = await pool.getConnection();

        // 檢查帳號是否已存在
        const [exists] = await conn.query(
            "SELECT * FROM user WHERE username = ?",
            [username]
        );
        if (exists.length) {
            conn.release();
            return res.status(400).json({ error: "帳號已存在" });
        }

        const hash = await bcrypt.hash(password, 10);

        await conn.query(
            "INSERT INTO user (username, password, role, email) VALUES (?, ?, ?, ?)",
            [username, hash, 0, email] 
        );

        conn.release();

        res.json({ message: "註冊成功" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "註冊失敗，請稍後再試" });
    }
});

// 使用者登入
router.post("/login", async (req, res) => {
    const { username, password } = req.body;

    const conn = await pool.getConnection();
    const [rows] = await conn.query("SELECT * FROM user WHERE username = ?", [username]);
    conn.release();

    if (!rows.length) return res.status(400).json({ error: "帳號不存在" });

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(400).json({ error: "密碼錯誤" });

    const token = jwt.sign(
        {
            user_id: user.user_id,
            username: user.username,
            role: user.role
        },
        JWT_SECRET,
        { expiresIn: "7d" }
    );

    res.json({ message: "登入成功", token });
});

export default router;