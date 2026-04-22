import urllib.request
import json
import os

token = "figd_hVLmXX97IK2Jw99oClBBInPvlW0yQX4CzU7w-koI"
file_id = "xFUZJvB6LkKO8dEmHcH4dw"
node_ids = "1:1066,1:1358,1:1360,1:1090"

url = f"https://api.figma.com/v1/images/{file_id}?ids={node_ids}&format=svg"
req = urllib.request.Request(url, headers={"X-Figma-Token": token})

print("Fetching image URLs...")
with urllib.request.urlopen(req) as response:
    data = json.loads(response.read().decode())

images = data.get("images", {})
names = {
    "1:1066": "mail.svg",
    "1:1358": "eye_open.svg",
    "1:1360": "eye_closed.svg",
    "1:1090": "lock.svg"
}

os.makedirs("assets/icons", exist_ok=True)

for node_id, img_url in images.items():
    if img_url:
        print(f"Downloading {names[node_id]}...")
        with urllib.request.urlopen(img_url) as img_res:
            with open(f"assets/icons/{names[node_id]}", "wb") as f:
                f.write(img_res.read())
            
print("Done!")
