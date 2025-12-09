import express from "express";
import moment from "moment-timezone";
import { pool } from "./db.js";
import { auth } from "./middleware.js";

const router = express.Router();

// 建立卡組
router.post("/", auth, async (req, res) => {
    const { deck_name } = req.body;
    const user_id = req.user.user_id;

    const time = moment().tz("Asia/Taipei").format("YYYY-MM-DD HH:mm:ss");

    const conn = await pool.getConnection();

    try {
        const [result] = await conn.query(
            "INSERT INTO ptcg_deck (deck_name, user_id, number, created_at) VALUES (?, ?, ?, ?)",
            [deck_name, user_id, 0, time]
        );

        // result.insertId 就是 MySQL 自增的 deck_id
        const deck_id = result.insertId;

        res.json({ message: "卡組已建立", deck_id, created_at: time });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "建立卡組失敗" });
    } finally {
        conn.release();
    }
});


// 查詢使用者所有卡組
router.get("/", auth, async (req, res) => {
    const conn = await pool.getConnection();
    const user_id = req.user.user_id;
    const [rows] = await conn.query(
        `
            SELECT 
                deck_id,
                deck_name,
                user_id,
                number,
                DATE_FORMAT(created_at, '%Y/%m/%d') AS created_at
            FROM ptcg_deck
            WHERE user_id = ?
        `,
        [user_id]
    );
    conn.release();
    res.json(rows);
});

//刪除deck
router.delete("/:id", auth, async (req, res) => {
    const conn = await pool.getConnection();
    await conn.query(
        "DELETE FROM ptcg_deck WHERE deck_id = ? AND user_id = ?",
        [req.params.id, req.user.user_id]
    );
    conn.release();

    res.json({ message: "卡組已刪除" });
});

//卡組改名
router.put("/:id", auth, async (req, res) => {
    const { deck_name } = req.body;

    if (!deck_name) {
        return res.status(400).json({ error: "缺少 deck_name" });
    }

    const conn = await pool.getConnection();
    const [result] = await conn.query(
        "UPDATE ptcg_deck SET deck_name = ? WHERE deck_id = ? AND user_id = ?",
        [deck_name, req.params.id, req.user.user_id]
    );
    conn.release();

    if (result.affectedRows === 0) {
        return res.status(404).json({ error: "更新失敗，找不到卡組或沒有權限" });
    }

    res.json({ message: "卡組名稱已更新", deck_id: req.params.id, new_name: deck_name });
});

export default router;