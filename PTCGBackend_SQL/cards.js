import express from "express";
import { pool } from "./db.js";

const router = express.Router();

router.get("/", async (req, res) => {
    const { energy, rarity, specal, collection, q, order } = req.query;

    const where = [];
    const params = [];

    if (energy) { where.push("p.energy_type = ?"); params.push(energy); }
    if (rarity) { where.push("p.rarity_id = ?"); params.push(rarity); }
    if (specal) { where.push("p.specal_card_type = ?"); params.push(specal); }
    if (collection) { where.push("p.collection_id = ?"); params.push(collection); }
    if (q) { where.push("p.name LIKE ?"); params.push(`%${q}%`); }

    const whereSQL = where.length ? `WHERE ${where.join(" AND ")}` : "";
    const orderSQL = order ? `ORDER BY p.card_id ${order}` : "";

    const sql = `
        SELECT p.*, e.energy_ch, r.rarity_ch, s.speca_type_ch, c.name_ch AS collection_ch
        FROM ptcg_pokemon_cards p
        JOIN energy_attributes e ON p.energy_type = e.energy_id
        JOIN rarity r ON p.rarity_id = r.rarity_id
        JOIN specal_card_type s ON p.specal_card_type = s.specal_id
        JOIN ptcg_collections c ON p.collection_id = c.collections_id
        ${whereSQL}
        ${orderSQL}
    `;

    const conn = await pool.getConnection();
    const [rows] = await conn.query(sql, params);
    conn.release();

    res.json(rows);
});

export default router;
