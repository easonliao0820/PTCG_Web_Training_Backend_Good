import express from "express";
import { pool } from "./db.js";

const router = express.Router();

// 取得所有參考資料（屬性、稀有度、特殊卡、系列）
router.get("/", async (req, res) => {
    const conn = await pool.getConnection();

    const [energy] = await conn.query("SELECT * FROM energy_attributes");
    const [rarity] = await conn.query("SELECT * FROM rarity");
    const [specal] = await conn.query("SELECT * FROM specal_card_type");
    const [collections] = await conn.query("SELECT * FROM ptcg_collections");

    conn.release();

    res.json({ energy, rarity, specal, collections });
});

// 取得卡包類型下拉選單（collection_type）
router.get("/collection", async (req, res) => {
    const conn = await pool.getConnection();
    const [collectionsType] = await conn.query("SELECT * FROM collection_type");

    conn.release();

    res.json({ collectionsType });
});

export default router;
