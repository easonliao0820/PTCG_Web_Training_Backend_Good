


-----

### 🧪 MongoDB 卡牌組系統 Postman CRUD 測試流程

如果測試前準備已經完成可跳到 Create (建立)

#### ⚠️ 測試前準備
沒問題！我們來一次**最完整、最乾淨**的流程。

針對你的需求，這次我們採用 **「雙終端機策略」**：一個視窗專門跑資料庫（手動模式），另一個視窗跑你的後端程式。

請依照以下順序，一步一步執行：

-----

### 🛠️ 階段一：專案環境建置 (Terminal A)

請開啟第一個終端機 (VS Code 的終端機即可)，確認路徑在 `...\PTCGBackend_NoSQL>`。

1.  **建立身分證 (初始化)**
    這步是為了讓 npm 知道這裡是一個獨立專案。

    ```powershell
    npm init -y
    ```

2.  **安裝必要套件**
    一次把所有需要的工具裝好。

    ```powershell
    npm install express mysql2 bcryptjs jsonwebtoken cors moment-timezone mongoose
    ```

-----

### 📂 階段二：準備資料庫檔案夾

因為我們要用「手動模式」，必須先幫 MongoDB 準備一個家。

1.  開啟檔案總管。
2.  進入 `D:` 槽。
3.  按右鍵 -\> 新增資料夾，命名為 **`mongodb-data`**。
      * 確認路徑為：`D:\mongodb-data`

-----

### 🚀 階段三：手動啟動 MongoDB (Terminal B)

**⚠️ 這是最關鍵的一步！** 請**另外開啟**一個新的終端機視窗 (PowerShell 或 CMD)，不要用剛剛那個。這個視窗開啟後**全程不能關閉**。

1.  **輸入啟動指令**
    請複製以下指令貼上執行（假設你安裝的是 MongoDB 7.0 版本，預設路徑如下）：

    ```powershell
    "C:\Program Files\MongoDB\Server\7.0\bin\mongod.exe" --dbpath="D:\mongodb-data"
    ```

      * **如果報錯找不到檔案**：請去 `C:\Program Files\MongoDB\Server\` 檢查你的版本資料夾是 `6.0`、`7.0` 還是其他數字，修改指令中的數字即可。

2.  **確認啟動成功**
    當你看到類似這行字時，代表資料庫活過來了：

    > `Waiting for connections on port 27017`

    **👉 注意：請將此視窗縮小，千萬不要關閉它！**

-----

### 💻 階段四：啟動後端伺服器 (回到 Terminal A)

回到一開始的那個 VS Code 終端機 (`...\PTCGBackend_NoSQL>`)。

1.  **啟動 Node.js**

    ```powershell
    node server.js
    ```

2.  **驗證連線**
    你應該要看到兩行成功的訊息：

    > `Server running at http://localhost:3001`
    > `✅ MongoDB 連線成功`

-----

### 🧹 階段五：清空舊資料 (強烈建議)

為了讓你的測試 ID (1, 2, 3...) 準確，建議先清空。

1.  開啟 **MongoDB Compass**。
2.  連線至 `mongodb://localhost:27017` (直接按 Connect)。
3.  在左側列表找到 `ptcg_deckbuilder` 資料庫 (如果是第一次跑，可能還沒出現，要等 POST 第一筆資料才會出現，那就不用清空)。
4.  如果有的話，點擊 `decks`，然後點擊垃圾桶圖示 **Drop Collection**。

-----

### ✅ 準備完成！

現在你的狀態是：

1.  **Terminal B** 正在努力維護資料庫 (存放在 D 槽)。
2.  **Terminal A** 正在跑後端 API。
3.  資料庫是乾淨的。

**👉 現在你可以去 Postman 開始第一步：Create (建立) 了！**
-----

### 1\. Create (建立) - 測試作者 ID 隔離與流水號



**測試 A：建立作者 55 的第一副牌**

  * **Method**: `POST`
  * **URL**: `http://localhost:3000/mongo/decks`
  * **Body (JSON)**:
    ```json
    {
        "author_id": 55,
        "deck_id":1,
        "author_name": "小智",
        "deck_name": "噴火龍快攻",
        "format": "Standard",
        "cards": [
            {"card_id": "sv8_123", "count": 2},
            {"card_id": "custom_001", "name": "自製皮卡丘", "count": 4}
        ]
    }
    ```


**測試 B：建立作者 55 的第二副牌 **

  * **Method**: `POST`
  * **URL**: `http://localhost:3000/mongo/decks`
  * **Body (JSON)**:
    ```json
    {
        "author_id": 55,
        "deck_id":2,
        "author_name": "小智",
        "deck_name": "洛奇亞VSTAR",
        "cards": [{"card_id": "sv8_124", "count": 1}]
    }
    ```
 

**測試 C：建立作者 101 的第一副牌**

  * **Method**: `POST`
  * **URL**: `http://localhost:3000/mongo/decks`
  * **Body (JSON)**:
    ```json
    {
        "author_id": 101,
        "deck_id": 1,
        "author_name": "火箭隊",
        "deck_name": "喵喵金幣牌組",
        "cards": [{"card_id": "sv8_999", "count": 1}]
    }
    ```


-----

### 2\. Read (查詢) - 測試多重篩選

根據程式碼，`GET /mongo/decks` 支援 `author_id` 和 `deck_id` 兩個參數。


**測試 A：精準查詢特定牌組 (作者 55 的第 2 副牌)**

  * **Method**: `GET`
  * **URL**: `http://localhost:3000/mongo/decks?author_id=55&deck_id=2`
  * **✅ 預期結果**:
      * 只收到 **1 筆** 資料。
      * 資料內容應為 "洛奇亞VSTAR"。

-----

### 3\. Update (更新) - 修改牌組資訊

程式碼路徑為 `PUT /mongo/decks`，需要同時提供 `author_id` 與 `deck_id` 來鎖定目標。

**測試：修改作者 55 的第 1 號牌組名稱**

  * **Method**: `PUT`
  * **URL**: `http://localhost:3000/mongo/decks`
  * **Body (JSON)**:
    ```json
    {
        "author_id": 55,
        "deck_id": 1,
        "deck_name": "【已修改】噴火龍進化版",
        "description": "測試 PUT 功能是否成功"
    }
    ```
  * **✅ 預期結果**:
      * Status 200 OK。
      * 回傳的 JSON 中，`deck_name` 已變更為 "【已修改】噴火龍進化版"。

-----

### 4\. Add Cards (新增卡片) - [此為程式碼中新增的 API]

這是你程式碼中 `app.post('/mongo/decks/add-cards', ...)` 的專屬測試。

**測試：幫作者 55 的第 1 號牌組增加新卡片**

  * **Method**: `POST`
  * **URL**: `http://localhost:3000/mongo/decks/add-cards`
  * **Body (JSON)**:
    ```json
    {
        "author_id": 55,
        "deck_id": 1,
        "cards": [
            { "card_id": "new_card_001", "name": "新加入的卡", "count": 2 }
        ]
    }
    ```
  * **✅ 預期結果**:
      * Status 200 OK。
      * 回傳的資料中，`cards` 陣列應該變長了，並且包含剛剛加入的 "new\_card\_001"。

-----

### 5\. Delete (刪除) - 移除牌組

程式碼路徑為 `DELETE /mongo/decks`，同樣透過 Body 傳遞 ID。

**測試：刪除作者 101 的第 1 號牌組**

  * **Method**: `DELETE`
  * **URL**: `http://localhost:3000/mongo/decks`
  * **Body (JSON)**:
    ```json
    {
        "author_id": 101,
        "deck_id": 1
    }
    ```
  * **✅ 預期結果**:
      * Status 200 OK。
      * 回傳訊息表示刪除成功。
      * **驗證**：再次用 GET 查詢 `author_id=101`，應該回傳空陣列 `[]`。

-----

### ❓ 常見錯誤排除 (Troubleshooting)

1.  **404 Not Found (URL 錯誤)**

      * **原因**：你可能用了舊的 `/decks` 而不是 `/mongo/decks`。
      * **解法**：請確認 URL 中包含 `/mongo` 前綴。

2.  **400 Bad Request (缺少欄位)**

      * **原因**：Body 中缺少 `author_id` 或 `deck_id`。
      * **解法**：除了 Create (POST) 只需要 `author_id`，其他操作 (PUT, DELETE, Add-Cards) 通常都需要同時提供 `author_id` **和** `deck_id`。

3.  **連線被拒 (Connection Refused)**

      * **原因**：MongoDB 沒開，或是 Node.js 伺服器沒跑起來。
      * **解法**：確認 MongoDB Compass/Service 是綠燈，並確認終端機沒有報錯 crash。

