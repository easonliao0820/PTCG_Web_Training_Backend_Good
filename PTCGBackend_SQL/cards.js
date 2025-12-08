import express from "express";
import { pool } from "./db.js";

const router = express.Router();

router.get("/", async (req, res) => {
    const { energy, rarity, specal, collection, stage, hp, q, order } = req.query;

    const where = [];
    const params = [];

    if (energy)      { where.push("p.energy_type = ?"); params.push(energy); }
    if (rarity)      { where.push("p.rarity_id = ?"); params.push(rarity); }
    if (specal)      { where.push("p.specal_card_type = ?"); params.push(specal); }
    if (collection)  { where.push("p.collection_id = ?"); params.push(collection); }
    if (stage)       { where.push("p.stage = ?"); params.push(stage); }
    if (hp)          { where.push("p.hp = ?"); params.push(hp); }

    if (q) {
        where.push("(p.name LIKE ? OR p.card_id LIKE ?)");
        params.push(`%${q}%`, `%${q}%`);
    }

    const whereSQL = where.length ? `WHERE ${where.join(" AND ")}` : "";
    const orderSQL = order ? `ORDER BY p.card_id ${order}` : "";

    const sql = `
        SELECT p.*, 
               e.energy_ch, 
               r.rarity_ch, 
               s.speca_type_ch, 
               c.name_ch AS collection_ch
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

router.get("/:id", async (req, res) => {
    try {
        const { id } = req.params;
        const conn = await pool.getConnection();

        const sql = `
            SELECT 
                c.card_id,
                c.name,
                c.hp,
                c.stage,
                c.image_url,
                c.info,
                co.name_ch AS name_ch,
                c.specal_card_type,
                r.rarity_en AS rarity_en,
                e.energy_ch AS energy_type_ch
            FROM ptcg_pokemon_cards c
            LEFT JOIN energy_attributes e 
                ON c.energy_type = e.energy_id
            LEFT JOIN rarity r
                ON c.rarity_id = r.rarity_id
            LEFT JOIN ptcg_collections co
                ON c.collection_id = co.collections_id
            WHERE c.card_id = ?
        `;

        const [rows] = await conn.query(sql, [id]);
        conn.release();

        if (rows.length === 0) {
            return res.status(404).json({ error: "找不到該卡牌" });
        }

        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "資料庫錯誤" });
    }
});

// POST /cards 新增卡牌
router.post("/", async (req, res) => {
    try {
        const cards = req.body; // <- 變成接收 array

        if (!Array.isArray(cards) || cards.length === 0) {
            return res.status(400).json({ error: "請傳入至少 1 筆卡牌資料（array）" });
        }

        const conn = await pool.getConnection();

        const results = [];

        for (const card of cards) {
            const {
                card_id,
                name,
                hp,
                stage,
                image_url,
                info,
                energy_en,
                collection_code,
                specal_card_type,
                rarity_id
            } = card;

            // 必填欄位檢查
            if (!card_id || !name || !collection_code) {
                results.push({
                    card_id,
                    success: false,
                    error: "card_id, name, collection_code 為必填欄位"
                });
                continue;
            }

            // 查 collection_id
            let collection_id = null;
            const [colRows] = await conn.query(
                `SELECT collections_id FROM ptcg_collections WHERE code = ?`,
                [collection_code]
            );

            if (colRows.length === 0) {
                results.push({
                    card_id,
                    success: false,
                    error: `找不到 collection_code: ${collection_code}`
                });
                continue;
            }
            collection_id = colRows[0].collections_id;

            // 查 energy_id
            let energy_id = null;
            if (energy_en) {
                const [energyRows] = await conn.query(
                    `SELECT energy_id FROM energy_attributes WHERE energy_en = ?`,
                    [energy_en]
                );

                if (energyRows.length === 0) {
                    results.push({
                        card_id,
                        success: false,
                        error: `找不到 energy_en: ${energy_en}`
                    });
                    continue;
                }

                energy_id = energyRows[0].energy_id;
            }

            // 插入資料
            const sql = `
                INSERT INTO ptcg_pokemon_cards 
                (card_id, name, hp, stage, image_url, info, energy_type, collection_id, specal_card_type, rarity_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;

            try {
                await conn.query(sql, [
                    card_id,
                    name,
                    hp || null,
                    stage || null,
                    image_url || null,
                    info || null,
                    energy_id,
                    collection_id,
                    specal_card_type || null,
                    rarity_id || null
                ]);

                results.push({
                    card_id,
                    success: true,
                    message: "新增成功",
                    energy_id,
                    collection_id
                });
            } catch (err) {
                if (err.code === "ER_DUP_ENTRY") {
                    results.push({
                        card_id,
                        success: false,
                        error: "card_id 已存在"
                    });
                } else {
                    results.push({
                        card_id,
                        success: false,
                        error: "資料庫錯誤",
                        detail: err.message
                    });
                }
            }
        }

        conn.release();

        return res.json({
            total: cards.length,
            success: results.filter(r => r.success).length,
            fail: results.filter(r => !r.success).length,
            results
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: "伺服器錯誤" });
    }
});


export default router;
