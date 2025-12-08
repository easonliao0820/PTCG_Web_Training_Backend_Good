import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import time

base_url = 'https://asia.pokemon-card.com/tw/card-search/list/'
output_folder = 'pokemon_images'
os.makedirs(output_folder, exist_ok=True)

headers = {"User-Agent": "Mozilla/5.0"}

max_pages = 10
expansion_code = "M2"
counter = 1

for page in range(1, max_pages + 1):
    params = {
        'pageNo': page,
        'expansionCodes': expansion_code
    }
    print(f'開始抓第 {page} 頁...')
    response = requests.get(base_url, headers=headers, params=params)
    if response.status_code != 200:
        print(f'第 {page} 頁請求失敗，停止。')
        break

    soup = BeautifulSoup(response.text, 'html.parser')
    img_tags = soup.find_all('img', class_='lazy')
    if not img_tags:
        print(f'第 {page} 頁沒找到圖片，停止。')
        break

    for img in img_tags:
        img_url = img.get('data-original') or img.get('src')
        if img_url:
            img_url = urljoin(base_url, img_url)
            filename = f"{expansion_code} {counter:03d}.png"
            filepath = os.path.join(output_folder, filename)

            try:
                img_data = requests.get(img_url, headers=headers).content
                with open(filepath, 'wb') as f:
                    f.write(img_data)
                print(f'下載圖片: {filename}')
                
                counter += 1  # 下一張往上加
            except Exception as e:
                print(f'下載失敗 {filename}: {e}')

    time.sleep(1)
