import express from "express";
import cors from "cors";
import auth from "./auth.js";
import decks from "./decks.js";
import cards from "./cards.js";
import refs from "./refs.js";
import collection from "./collection.js";


const app = express();
app.use(cors());
app.use(express.json());

// 綁定 API 路由
app.use("/auth", auth);
app.use("/decks", decks);
app.use("/cards", cards);
app.use("/refs", refs);
app.use("/collection", collection);

app.listen(3000, () => {
    console.log("Server running on http://localhost:3000");
});
