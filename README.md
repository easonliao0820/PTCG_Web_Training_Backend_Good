# PTCG卡牌查詢系統
**寶可夢卡牌組構築後端系統**

本專案為寶可夢卡牌構築平台後端，提供完整的卡片查詢、卡組管理、使用者系統與 NoSQL/MongoDB 卡組儲存。
支援**前台玩家操作**與**後台開發管理介面**。
#
## 專案簡介
此後端主要負責以下任務：

● 提供 卡牌查詢 API
● 提供 MySQL 卡組系統
● 提供 MongoDB 卡組系統（含 snapshot）
● 提供 使用者登入、註冊、JWT 驗證
● 統一管理卡片屬性、稀有度、卡包資訊
● SQL 全量資料初始化（能量屬性、稀有度、卡包、卡牌）

專案可搭配任意前端（React / Vue / Vite）。
#
## 核心功能
會員系統（User System）

● 使用者註冊：使用者登入、JWT Token 身分驗證、密碼加密（bcrypt）、檢查 Email 是否重複

● 卡牌資料管理：查詢全部卡牌、多條件查詢、所有卡牌資料皆以 MySQL 儲存

● MySQL 卡組系統：新增卡組、編輯卡組、刪除卡組、依使用者查詢所有卡組、卡組建立時間 created_at（自動產生）、JWT 驗證使用者權

● MongoDB 卡組系統：新增卡組、更新卡組（名稱、卡牌陣列）、刪除卡組、自動維護 created_at / updated_at

● 參考資料 API：能量屬性、卡包資訊、稀有度、特殊卡種類
#
## 系統架構
### 後端
● Node.js + Express

● MySQL（主卡牌資料、使用者、卡組）

● MongoDB（NoSQL 卡組）

● JWT 驗證

● bcrypt 密碼加密

● CORS 支援前端請求
### 資料庫
MySQL

- user
* ptcg_pokemon_cards
* energy_attributes
* rarity
* specal_card_type
* ptcg_collections
+ ptcg_deck

MongoDB

Database: ptcg_deckbuilder
Collection: ptcg_decks

結構包含：
author_id
deck_id
deck_name
cards Snapshot 陣列
created_at / updated_at
#
## 建置後端
### 1.下載專案
git clone https://github.com/easonliao0820/PTCG_Web_Training_Backend_Good.git
cd PTCG_Web_Training_Backend_Good

### 2.下載專案
安裝後端依賴

### 3.匯入MySQL Schema
https://github.com/easonliao0820/PTCG_Web_Training_Backend_Good/blob/main/sql/schema.sql

### 4.MongoDB建置
使用MongoDB Compass建立：

Database: ptcg_deckbuilder
Collection: ptcg_decks

### 5.啟動NoSQL後端
開啟一個Terminal
cd PTCGBackend_NoSQL
node server.js

### 6.修改連進MySQL的密碼
打開PTCGBackend_SQL，進入dp.js
將password改成改成自己設定的密碼

### 7.啟動SQL後端
開啟另一個Terminal
cd PTCGBackend_SQL
node node.js
#
## 專案結構
<div style="border: 2px solid #444; padding: 12px; border-radius: 8px;">
<pre>
PTCG_Web_Training_Backend_Good
│
├─ PTCGBackend_SQL/                # 放有SQL組料庫API的模組
├─ PTCGBackend_NoSQL/              # MongoDB + Node.js 後端 API
├─ Web Crawler/                    # 放有Python卡圖與卡牌資料的爬蟲
├─ DB/                             # 放有僅放有schema
├─ sql/                            # 放有schema和sample_queries
├─ nosql/                          # 放有mongo_queries
├─ README.md                       # 本說明文件
</pre>
</div>
