import express from "express";
import { pool } from "./db.js";

const router = express.Router();

/* ===== 搜尋卡包 + 計算卡片數量 ===== */
router.post("/", async (req, res) => {
    try {
        const { year, keyword, collection_type } = req.body;
        const conn = await pool.getConnection();

        let sql = `
            SELECT 
                c.collections_id AS collection_id,
                c.code AS collection_code,
                c.name_ch AS collection_name,
                c.release_date,
                c.symbol_url,            -- 改成 symbol_url
                c.collection_type,       -- 保留 collection_type
                COUNT(cards.card_id) AS card_count
            FROM ptcg_collections c
            LEFT JOIN ptcg_pokemon_cards cards ON c.collections_id = cards.collection_id
            WHERE 1
        `;
        const params = [];

        if (year) {
            sql += " AND YEAR(c.release_date) = ?";
            params.push(year);
        }

        if (keyword) {
            sql += " AND (c.name_ch LIKE ? OR c.code LIKE ?)";
            params.push(`%${keyword}%`, `%${keyword}%`);
        }

        if (collection_type && collection_type != "4") { // 4 = 全部
            sql += " AND c.collection_type = ?";
            params.push(collection_type);
        }

        sql += `
            GROUP BY c.collections_id, c.code, c.name_ch, c.release_date, c.symbol_url, c.collection_type
            ORDER BY c.collections_id
        `;

        const [rows] = await conn.query(sql, params);
        conn.release();

        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "搜尋卡包失敗" });
    }
});



export default router;