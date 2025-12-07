import requests
from bs4 import BeautifulSoup
import openpyxl
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
def get_card_detail(card_id):
    url = f"{BASE_URL}/tw/card-search/detail/{card_id}/"
    res = requests.get(url)
    soup = BeautifulSoup(res.text, "html.parser")

    h1_tag = soup.select_one("h1.pageHeader.cardDetail")
    number_tag = soup.select_one("span.collectorNumber")

    name = extract_card_name(h1_tag)
    number = extract_number(number_tag)

    return name, number


# 匯出 excel
def save_to_excel(cards, filename="cards.xlsx"):
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.append(["Name", "Number"])

    for name, number in cards:
        ws.append([name, number])

    wb.save(filename)
    print(f"✔ 已匯出：{filename}")


# ------------------ 主程式 ---------------------
if __name__ == "__main__":
    expansion = "M2a"
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
            name, number = get_card_detail(cid)
            print(expansion + " " + number, name)
            cards.append([name, expansion + " " + number])

        page += 1

    save_to_excel(cards)
