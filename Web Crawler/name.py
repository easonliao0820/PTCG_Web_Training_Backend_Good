import requests
from bs4 import BeautifulSoup
import json
import os
import re

BASE_URL = "https://asia.pokemon-card.com"

# ---- 格式化卡名：拆出 <阿響的>凱羅斯 -> 阿響的凱羅斯 ----
def extract_card_name(h1_tag):
    if h1_tag is None:
        return ""

    # 把 evolveMarker 移除
    em = h1_tag.find("span", class_="evolveMarker")
    if em:
        em.extract()

    raw = "".join(h1_tag.stripped_strings)

    # 修正 HTML 符號 like "&lt;阿響的&gt;" -> "<阿響的>"
    raw = raw.replace("&lt;", "<").replace("&gt;", ">")

    # 把 <阿響的>凱羅斯 -> 阿響的凱羅斯
    raw = re.sub(r"<(.*?)>", r"\1", raw)

    return raw.strip()


# ---- 格式化編號：001/193 -> 001 ----
def extract_number(num_tag):
    if num_tag is None:
        return ""

    txt = num_tag.text.strip()
    match = re.match(r"(\d+)", txt)
    return match.group(1).zfill(3) if match else ""

# ---- 抓出血量 ----
def extract_hp(hp_tag):
    if hp_tag is None:
        return ""
    
    txt = hp_tag.text.strip()
    return txt

# ---- 抓出階段 ----
def extract_stage(stage_tag):
    if stage_tag is None:
        return ""
    
    txt = stage_tag.text.strip()
    return txt

# ---- 抓出卡牌描述 ----
def extract_info(info_tag):
    if info_tag is None:
        return ""
    
    txt = info_tag.text.strip()
    return txt

# ---- 從屬性圖示URL取出能量屬性 ----
def extract_energy(energy_tag):
    if energy_tag is None:
        return ""

    src = energy_tag.get("src", "")
    filename = src.split("/")[-1]  

    energy_name = filename.split(".")[0]  

    return energy_name

# ---- 抓卡圖的url ----
def get_local_image_url(expansion, number):
    folder = "pokemon_images"
    filename = f"{expansion} {number}.jpg"
    path = os.path.join(folder, filename)

    if os.path.exists(path):
        return path.replace("\\", "/")

    return ""

# 抓列表頁所有卡 ID
def get_card_ids(list_url):
    res = requests.get(list_url)
    soup = BeautifulSoup(res.text, "html.parser")
    links = soup.select("a[href*='/card-search/detail/']")
    ids = []

    for link in links:
        href = link["href"]
        card_id = href.split("/")[-2]
        ids.append(card_id)

    return ids


# 抓詳細頁資料
def get_card_detail(card_id, expansion):
    url = f"{BASE_URL}/tw/card-search/detail/{card_id}/"
    res = requests.get(url)
    soup = BeautifulSoup(res.text, "html.parser")

    h1_tag = soup.select_one("h1.pageHeader.cardDetail")
    number_tag = soup.select_one("span.collectorNumber")
    hp_tag = soup.select_one("span.number")
    energy_tag = soup.select_one("p.mainInfomation img")
    stage_tag = soup.select_one("span.evolveMarker")
    info_tag = soup.select_one("p.discription")

    name = extract_card_name(h1_tag)
    number = extract_number(number_tag)
    hp = extract_hp(hp_tag)
    energy = extract_energy(energy_tag)
    stage = extract_stage(stage_tag)
    info = extract_info(info_tag)
    image_url = get_local_image_url(expansion, number)

    return {
        "card_id": f"{expansion}_{number}",
        "name": name,
        "hp": hp,
        "stage": stage,
        "image_url": f"/assets/cards/{expansion} {number}.png",
        "info": info,
        "energy_en": energy,
        "collection_code": expansion,
        "specal_card_type": "",
        "rarity_id": ""
    }


#儲存成 JSON
def save_to_json(cards, filename="cards.json"):
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(cards, f, ensure_ascii=False, indent=4)

    print(f"已輸出JSON檔：{filename}")


# ------------------ 主程式 ---------------------
if __name__ == "__main__":
    expansion = "M2"
    page = 1
    cards = []

    while True:
        list_url = f"https://asia.pokemon-card.com/tw/card-search/list/?pageNo={page}&expansionCodes={expansion}"
        print(f"\n📄 抓取列表頁 page {page}")

        ids = get_card_ids(list_url)
        if not ids:
            print("⚠ 沒有更多卡牌，停止")
            break

        for cid in ids:
            detail = get_card_detail(cid, expansion)

            print(
                detail["card_id"], 
                detail["name"], 
                detail["hp"], 
                detail["stage"],
                detail["image_url"],
                detail["info"], 
                detail["energy_en"],
                detail["collection_code"],
                detail["specal_card_type"],
                detail["rarity_id"]
            )

            cards.append(detail)

        page += 1

    save_to_json(cards)