import jwt from "jsonwebtoken";

const JWT_SECRET = "super_secret_key_change_it";

// Token 驗證中介層

export const auth = async (req, res, next) => {
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