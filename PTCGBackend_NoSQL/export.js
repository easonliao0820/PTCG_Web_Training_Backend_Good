// 檔案: export.js
const mongoose = require('mongoose');
const fs = require('fs');

// 使用您 server.js 中的設定
const MONGO_URI = 'mongodb://127.0.0.1:27017/ptcg_deckbuilder';
const COLLECTION_NAME = 'ptcg_decks';

async function exportData() {
    try {
        // 1. 連線資料庫
        await mongoose.connect(MONGO_URI);
        console.log('✅ MongoDB 連線成功');

        // 2. 直接讀取 Collection (不需要 Model 定義也能抓原始資料)
        const collection = mongoose.connection.db.collection(COLLECTION_NAME);
        const data = await collection.find({}).toArray();

        // 3. 寫入 JSON 檔案
        // JSON.stringify 參數說明: null 代表不過濾欄位, 2 代表縮排兩格
        fs.writeFileSync('decks_backup_script.json', JSON.stringify(data, null, 2), 'utf-8');
        
        console.log(`🎉 匯出成功！共 ${data.length} 筆資料`);
        console.log('檔案已儲存為: decks_backup_script.json');

    } catch (error) {
        console.error('❌ 匯出失敗:', error);
    } finally {
        // 4. 斷開連線
        await mongoose.disconnect();
    }
}

exportData();