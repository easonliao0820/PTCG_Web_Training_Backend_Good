import os
import requests
from bs4 import BeautifulSoup
import pandas as pd


url = "https://asia.pokemon-card.com/tw/card-search/"
headers = {"User-Agent": "Mozilla/5.0"}

response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, "html.parser")

items = soup.select("a.expansionLink")

expansion_list = []
type_map = {}  # type 去重


# 建立圖片資料夾
if not os.path.exists("images"):
    os.mkdir("images")


for item in items:

    # === 代碼 ===
    href = item.get("href")
    code = href.split("=")[-1] if "expansionCodes=" in href else None

    # === 圖片 ===
    img_tag = item.select_one(".imageContainer img")
    img_url = img_tag["src"] if img_tag else None

    # === title 拆類型 + 名稱 ===
    title = item.select_one(".expansionTitle").get_text(strip=True)
    exp_type, name = None, None

    if "「" in title and "」" in title:
        exp_type = title.split("「")[0]  # 擴充類型
        name = title.split("「")[1].replace("」", "")  # 名稱

    # === 日期 ===
    time_tag = item.select_one("time.relaseDate")
    release_date = time_tag.get("datetime") if time_tag else None

    if release_date:
        mm, dd, yyyy = release_date.split("-")
        release_date = f"{yyyy}-{mm}-{dd}"

    # === 下載圖片 ===
    image_path = None
    if img_url:
        img_data = requests.get(img_url, headers=headers).content
        image_path = f"images/{code}.png"
        with open(image_path, "wb") as f:
            f.write(img_data)

    # === 編進 list ===
    expansion_list.append({
        "code": code,
        "release_date": release_date,
        "type_name": exp_type,
        "name": name,
        "image_url": img_url,
        "image_path": image_path
    })

    # === type map ===
    if exp_type and exp_type not in type_map:
        type_map[exp_type] = len(type_map) + 1


# === 轉 DataFrame ===
df_expansions = pd.DataFrame(expansion_list)
df_types = pd.DataFrame(
    [{"id": v, "type_name": k} for k, v in type_map.items()]
)

# === 寫 Excel (multi sheet) ===
with pd.ExcelWriter("expansions.xlsx", engine="openpyxl") as writer:
    df_expansions.to_excel(writer, sheet_name="expansions", index=False)
    df_types.to_excel(writer, sheet_name="collection_types", index=False)

print("Excel 已產生：expansions.xlsx & 圖片已下載到 images 資料夾")
