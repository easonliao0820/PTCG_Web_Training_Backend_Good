const express = require("express");
const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const cors = require("cors");
const moment = require("moment-timezone");

const app = express();
app.use(express.json());
app.use(cors());


// MySQL 連線設定

const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "0820",
    database: "ptcg_db",
    connectionLimit: 10,
    dateStrings: true
});

const JWT_SECRET = "super_secret_key_change_it";


// Token 驗證中介層

const auth = async (req, res, next) => {
    const header = req.headers.authorization;
    if (!header) return res.status(401).json({ error: "No token provided" });

    const token = header.split(" ")[1];
    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        next();
    } catch (err) {
        return res.status(401).json({ error: "Invalid token" });
    }
};


// 使用者註冊

app.post("/auth/register", async (req, res) => {
    const { username, password, email } = req.body;

    if (!username || !password || !email)
        return res.status(400).json({ error: "缺少欄位" });

    const conn = await pool.getConnection();
    try {
        const hash = await bcrypt.hash(password, 10);

        const sql = `
            INSERT INTO user (username, password, role, email)
            VALUES (?, ?, 0, ?)
        `;

        await conn.query(sql, [username, hash, email]);
        conn.release();
        res.json({ message: "註冊成功" });
    } catch (err) {
        conn.release();
        if (err.code === "ER_DUP_ENTRY") {
            return res.status(400).json({ error: "帳號或 Email 已存在" });
        }
        res.status(500).json({ error: "資料庫錯誤" });
    }
});


// 使用者登入

app.post("/auth/login", async (req, res) => {
    const { username, password } = req.body;

    const conn = await pool.getConnection();
    const [rows] = await conn.query(
        "SELECT * FROM user WHERE username = ?",
        [username]
    );
    conn.release();

    if (!rows.length) return res.status(400).json({ error: "帳號不存在" });

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(400).json({ error: "密碼錯誤" });

    // 產生 JWT
    const token = jwt.sign(
        {
            user_id: user.user_id,
            username: user.username,
            role: user.role
        },
        JWT_SECRET,
        { expiresIn: "7d" }
    );

    // 回傳 token + username
    res.json({
        message: "登入成功",
        token,
        username: user.username // 加上 username
    });
});

//查詢屬性、稀有度、特殊卡、系列、關鍵字

app.get("/cards", async (req, res) => {
    const { energy, rarity, specal, collection, q } = req.query;

    const where = [];
    const params = [];

    if (energy) {
        where.push("p.energy_type = ?");
        params.push(energy);
    }

    if (rarity) {
        where.push("p.rarity_id = ?");
        params.push(rarity);
    }

    if (specal) {
        where.push("p.specal_card_type = ?");
        params.push(specal);
    }

    if (collection) {
        where.push("p.collection_id = ?");
        params.push(collection);
    }

    if (q) {
        where.push("p.name LIKE ?");
        params.push(`%${q}%`);
    }

    const whereSQL = where.length ? `WHERE ${where.join(" AND ")}` : "";

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
    `;

    const conn = await pool.getConnection();
    const [rows] = await conn.query(sql, params);
    conn.release();

    res.json(rows);
});

//下拉式選單屬性、稀有度、特殊卡牌

app.get("/refs", async (req, res) => {
    const conn = await pool.getConnection();

    const [energy] = await conn.query("SELECT * FROM energy_attributes");
    const [rarity] = await conn.query("SELECT * FROM rarity");
    const [specal] = await conn.query("SELECT * FROM specal_card_type");
    const [collections] = await conn.query("SELECT * FROM ptcg_collections");

    conn.release();

    res.json({ energy, rarity, specal, collections });
});
//下拉式collection
app.get("/refs/collection", async (req,res) => {
    const conn = await pool.getConnection();
    const [collectionsType] = await conn.query("SELECT * FROM collection_type");

    conn.release();

    res.json({ collectionsType });
});

app.post("/collections", async (req, res) => {
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


// 建立卡組

app.post("/decks", auth, async (req, res) => {
    const user_id = req.user.user_id;
    const { deck_name } = req.body;

    const taiwanTime = moment().tz("Asia/Taipei").format("YYYY-MM-DD HH:mm:ss");
    const number = 0;

    const conn = await pool.getConnection();
    await conn.query(
        "INSERT INTO ptcg_deck (user_id, deck_name, number, created_at) VALUES (?, ?, ?, ?)",
        [user_id, deck_name, number, taiwanTime]
    );
    conn.release();

    res.json({ message: "卡組已建立", created_at: taiwanTime });
});

// 查詢使用者所有卡組

app.get("/decks", auth, async (req, res) => {
    const conn = await pool.getConnection();
    const [rows] = await conn.query(
        "SELECT * FROM ptcg_deck WHERE user_id = ?",
        [req.user.user_id]
    );
    conn.release();
    res.json(rows);
});

//卡組改名

app.put("/decks/:deck_id", auth, async (req, res) => {
    const user_id = req.user.user_id;
    const deck_id = req.params.deck_id;
    const { deck_name } = req.body;

    if (!deck_name || deck_name.trim() === "") {
        return res.status(400).json({ error: "缺少 deck_name" });
    }

    const conn = await pool.getConnection();

    const [deckRows] = await conn.query(
        "SELECT * FROM ptcg_deck WHERE deck_id = ? AND user_id = ?",
        [deck_id, user_id]
    );

    if (!deckRows.length) {
        conn.release();
        return res.status(404).json({ error: "找不到卡組或你沒有權限修改" });
    }

    await conn.query(
        "UPDATE ptcg_deck SET deck_name = ? WHERE deck_id = ? AND user_id = ?",
        [deck_name, deck_id, user_id]
    );

    conn.release();

    res.json({
        message: "卡組名稱更新成功",
        deck_id,
        new_name: deck_name
    });
});

// 刪除 Deck

app.delete("/decks/:deck_id", auth, async (req, res) => {
    const user_id = req.user.user_id;
    const deck_id = req.params.deck_id;

    const conn = await pool.getConnection();

    const [rows] = await conn.query(
        "SELECT * FROM ptcg_deck WHERE deck_id = ? AND user_id = ?",
        [deck_id, user_id]
    );

    if (!rows.length) {
        conn.release();
        return res.status(404).json({ error: "找不到卡組或你沒有權限刪除" });
    }

    await conn.query(
        "DELETE FROM ptcg_deck WHERE deck_id = ? AND user_id = ?",
        [deck_id, user_id]
    );

    conn.release();
    res.json({ message: "卡組已成功刪除", deck_id });
});

//啟動時轉換未加密密碼

async function autoConvertPlainPasswords() {
    const conn = await pool.getConnection();

    const [users] = await conn.query(`
        SELECT user_id, password 
        FROM user 
        WHERE password NOT LIKE '$2a%' 
          AND password NOT LIKE '$2b%' 
          AND password NOT LIKE '$2y%'
    `);

    if (users.length === 0) {
        console.log("所有密碼已加密，無需轉換");
        conn.release();
        return;
    }

    console.log(`發現 ${users.length} 筆未加密密碼，開始轉換...`);

    for (const u of users) {
        const hashed = await bcrypt.hash(u.password, 10);

        await conn.query(`
            UPDATE user
            SET password = ?
            WHERE user_id = ?
        `, [hashed, u.user_id]);

        console.log(`已轉換 user_id=${u.user_id}`);
    }

    conn.release();
    console.log("密碼轉換完成！");
}


// 啟動後端

app.listen(3000, async () => {
    await autoConvertPlainPasswords();
    try {
        const conn = await pool.getConnection();
        await conn.ping();
        console.log("MySQL 連線成功");
        conn.release();
    } catch (err) {
        console.log("MySQL 連線失敗", err);
    }
    console.log("Server running at http://localhost:3000");
});
