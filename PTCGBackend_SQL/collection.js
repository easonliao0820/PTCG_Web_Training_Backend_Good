import express from "express";
import { pool } from "./db.js";

const router = express.Router();

router.post("/", async (req, res) => {
    try {
        const { year, keyword, collection_type } = req.body; // 從 body 拿資料
        const conn = await pool.getConnection();

        let sql = "SELECT * FROM ptcg_collections WHERE 1";
        const params = [];

        if (year) {
            sql += " AND YEAR(release_date) = ?";
            params.push(year);
        }

        if (keyword) {
            sql += " AND (name_ch LIKE ? OR code LIKE ?)";
            params.push(`%${keyword}%`, `%${keyword}%`);
        }

        if (collection_type && collection_type != "4") { // 4 = 全部
            sql += " AND collection_type = ?";
            params.push(collection_type);
        }

        const [rows] = await conn.query(sql, params);
        conn.release();

        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "資料庫錯誤" });
    }
});

//計算卡包有幾張牌
router.get("/count", async (req, res) => {
    try {
        const conn = await pool.getConnection();

        const sql = `
            SELECT 
                c.collections_id AS collection_id,
                c.code AS collection_code,
                c.name_ch AS collection_name,
                c.release_date,
                COUNT(cards.card_id) AS card_count
            FROM ptcg_collections c
            LEFT JOIN ptcg_pokemon_cards cards ON c.collections_id = cards.collection_id
            GROUP BY c.collections_id, c.code, c.name_ch, c.release_date
            ORDER BY c.collections_id
        `;

        const [rows] = await conn.query(sql);
        conn.release();

        res.json(rows); // 回傳 JSON 給前端
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "資料庫錯誤" });
    }
});

export default router;