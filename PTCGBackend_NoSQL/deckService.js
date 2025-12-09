// 檔案: deckService.js

const DeckModel = require('./deckModel');



module.exports = {


    // 1. 建立卡組
    async createDeck(author_id, deckData) {

       
        if (!deckData.deck_id) {
            throw new Error('建立 NoSQL 卡組失敗：必須提供 deck_id');
        }

        console.log(`[系統] 正在建立 MongoDB 卡組，使用外部 ID: ${deckData.deck_id}`);

        // [存檔] 直接儲存前端傳來的 cards，不做快照處理
        const newDeck = await DeckModel.create({

            author_id: Number(author_id),

            author_name: deckData.author_name,

            // [關鍵] 改用外部傳入的 ID (通常來自 MySQL 的 Auto Increment)
            deck_id: Number(deckData.deck_id),

            deck_name: deckData.deck_name,

            cards: deckData.cards // 直接存

        });

        return newDeck;

    },



    // 2. 查詢卡組

    async getDecks(filter) {

        return await DeckModel.find(filter).sort({ deck_id: 1 });

    },



    // 3. 更新卡組

    async updateDeck(author_id, deck_id, updates) {

        const query = { 

            author_id: Number(author_id),

            deck_id: Number(deck_id)

        };



        // [更新] 直接更新內容，包含 cards 陣列

        const updatedDeck = await DeckModel.findOneAndUpdate(

            query,

            { ...updates, updated_at: new Date() },

            { new: true, runValidators: true }

        );



        if (!updatedDeck) {

            throw new Error(`找不到要更新的卡組 (author_id: ${author_id}, deck_id: ${deck_id})`);

        }



        return updatedDeck;

    },



    // 4. 刪除卡組

    async deleteDeck(author_id, deck_id) {

        const query = { 

            author_id: Number(author_id), 

            deck_id: Number(deck_id)

        };



        const result = await DeckModel.findOneAndDelete(query);



        if (!result) {

            throw new Error(`找不到要刪除的卡組 (author_id: ${author_id}, deck_id: ${deck_id})`);

        }



        return { message: '卡組刪除成功', deletedDeckId: result.deck_id };

    },

     // 5. [新增] 新增卡片到卡組 (Append cards)
    async addCardsToDeck(author_id, deck_id, cardsToAdd) {
        const query = { 
            author_id: Number(author_id), 
            deck_id: Number(deck_id) 
        };

        // 防呆：確保 cardsToAdd 是陣列，如果傳單張物件進來也轉成陣列
        const cards = Array.isArray(cardsToAdd) ? cardsToAdd : [cardsToAdd];

        const updatedDeck = await DeckModel.findOneAndUpdate(
            query,
            { 
                // $push: 將元素加入陣列
                // $each: 一次加入多個元素
                $push: { cards: { $each: cards } }, 
                updated_at: new Date() 
            },
            { new: true, runValidators: true }
        );

        if (!updatedDeck) {
            throw new Error(`找不到要新增卡片的卡組 (author_id: ${author_id}, deck_id: ${deck_id})`);
        }

        return updatedDeck;
    }

};