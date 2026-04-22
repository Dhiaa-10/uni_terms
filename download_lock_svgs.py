import requests
import json
import os

token = "figd_hVLmXX97IK2Jw99oClBBInPvlW0yQX4CzU7w-koI"
file_id = "xFUZJvB6LkKO8dEmHcH4dw"
node_ids = "1:1090,1:1088"

url = f"https://api.figma.com/v1/images/{file_id}?ids={node_ids}&format=svg"
headers = {"X-Figma-Token": token}

print("Fetching image URLs...")
response = requests.get(url, headers=headers)
data = response.json()

images = data.get("images", {})
names = {
    "1:1088": "lock_on.svg",
    "1:1090": "lock_off.svg"
}

os.makedirs("assets/icons", exist_ok=True)

for node_id, img_url in images.items():
    if img_url:
        print(f"Downloading {names[node_id]}...")
        img_res = requests.get(img_url)
        with open(f"assets/icons/{names[node_id]}", "wb") as f:
            f.write(img_res.content)
            
print("Done!")
