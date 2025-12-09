// server.js
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const deckService = require('./deckService');

const app = express();

app.use(express.json());

// 🔹 啟用 CORS，允許 Vite 前端請求
app.use(cors({
    origin: "http://localhost:5173", // 前端 URL
    credentials: true
}));

app.set('json spaces', 2); // 方便開發用

const PORT = 3001;
const MONGO_URI = 'mongodb://127.0.0.1:27017/ptcg_deckbuilder';

// 🔹 MongoDB 連線
mongoose.connect(MONGO_URI)
    .then(() => console.log('✅ MongoDB 連線成功'))
    .catch(err => console.error('❌ MongoDB 連線失敗:', err));

/**
 * [POST] 建立新卡組
 * URL: /mongo/decks
 */
app.post('/mongo/decks', async (req, res) => {
    try {
        const author_id = req.body.author_id;
        const newDeck = await deckService.createDeck(author_id, req.body);
        res.status(201).json(newDeck);
    } catch (error) {
        console.error('建立卡組失敗:', error.message);
        res.status(500).json({ error: '伺服器錯誤' });
    }
});

/*
 * [GET] 查詢卡組
 */
app.get('/mongo/decks', async (req, res) => {
    try {
        const { author_id, deck_id } = req.query;
        const filter = {};
        if (author_id) filter.author_id = Number(author_id);
        if (deck_id) filter.deck_id = Number(deck_id);

        const decks = await deckService.getDecks(filter);
        res.json(decks);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: '無法取得卡組' });
    }
});

/**
 * [PUT] 更新卡組
 */
app.put('/mongo/decks', async (req, res) => {
    try {
        const { author_id, deck_id, ...updates } = req.body;
        if (!author_id || !deck_id)
            return res.status(400).json({ error: '更新時需要 author_id 和 deck_id' });

        const updatedDeck = await deckService.updateDeck(author_id, deck_id, updates);
        res.json(updatedDeck);
    } catch (error) {
        if (error.message.includes('找不到')) return res.status(404).json({ error: error.message });
        res.status(500).json({ error: '更新失敗: ' + error.message });
    }
});

/**
 * [DELETE] 刪除卡組
 */
app.delete('/mongo/decks', async (req, res) => {
    try {
        const { author_id, deck_id } = req.body;
        if (!author_id || !deck_id)
            return res.status(400).json({ error: '刪除時需要 author_id 和 deck_id' });

        const result = await deckService.deleteDeck(author_id, deck_id);
        res.json(result);
    } catch (error) {
        if (error.message.includes('找不到')) return res.status(404).json({ error: error.message });
        res.status(500).json({ error: '刪除失敗: ' + error.message });
    }
});

/**
 * [POST] 新增卡片到卡組 (MongoDB) [新增 API]
 * URL: /mongo/decks/add-cards
 * Body: { "author_id": 1, "deck_id": 105, "cards": [{...}, {...}] }
 */
app.post('/mongo/decks/add-cards', async (req, res) => {
    try {
        const { author_id, deck_id, cards } = req.body;

        if (!author_id || !deck_id || !cards) {
            return res.status(400).json({ error: '需要 author_id, deck_id 與 cards 資料' });
        }

        // 呼叫 Service 新增卡片
        const updatedDeck = await deckService.addCardsToDeck(author_id, deck_id, cards);

        // 回傳完整的更新後卡組 (包含 deck_id)
        res.json(updatedDeck);
    } catch (error) {
        if (error.message.includes('找不到')) {
            return res.status(404).json({ error: error.message });
        }
        res.status(500).json({ error: '新增卡片失敗: ' + error.message });
    }
});

// 🔹 啟動監聽
app.listen(PORT, () => {
    console.log(`🚀 MongoDB 伺服器運行中: http://localhost:${PORT}`);
});
