import mysql from "mysql2/promise";

// MySQL 連線設定
export const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "",
    database: "ptcg_db",
    connectionLimit: 10,
    dateStrings: true
});