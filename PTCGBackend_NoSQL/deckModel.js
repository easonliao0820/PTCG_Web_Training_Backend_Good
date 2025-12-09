// 檔案: deckModel.js
const mongoose = require('mongoose');

// --- 設定選項 ---
const schemaOptions = { 
    strict: false, // 允許寫入 Schema 未定義的欄位 (保留 NoSQL 彈性)
    timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' }
};

// --- 子結構：卡片快照 ---
// 儲存當下的卡片資訊，避免官方資料更動影響舊牌組顯示
const cardSnapshotSchema = new mongoose.Schema({
    card_id: { type: String, required: true }, 
    // count: { type: Number, required: true, min: 1 }, 
    name: { type: String },
    type: { type: String },
    energy_type_ch: { type: String },
    stage: { type: String },
    hp: { type: Number },     
    rarity_en: { type: String },      
    image_url: { type: String }       
}, { 
    _id: false,   // 嵌入物件不需要獨立 ID，節省空間
    strict: false 
});

// --- 主結構：牌組 ---
const deckSchema = new mongoose.Schema({
    author_id: { type: Number, required: true, index: true },
    author_name: { type: String }, // 冗餘欄位，減少查詢 User 表

    // 作者個人的流水號 (搭配 author_id 使用)，非全域 ID
    deck_id: { type: Number, required: true }, 

    deck_name: { type: String, required: true },
    
    cards: [cardSnapshotSchema], 
}, schemaOptions);

// --- 索引優化 ---
// 複合索引：極速查詢「該作者目前最大的 deck_id」，用於生成新編號
deckSchema.index({ author_id: 1, deck_id: -1 });

module.exports = mongoose.model('Deck', deckSchema, 'ptcg_decks');