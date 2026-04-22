import urllib.request
import json
import os

token = "figd_hVLmXX97IK2Jw99oClBBInPvlW0yQX4CzU7w-koI"
file_id = "xFUZJvB6LkKO8dEmHcH4dw"
node_ids = "359:2653,358:973,358:979,358:985,358:996,1:1288,1:1160,1:1535,356:1197,356:1199,356:1198,356:1200"

url = f"https://api.figma.com/v1/images/{file_id}?ids={node_ids}&format=svg"
req = urllib.request.Request(url)
req.add_header("X-Figma-Token", token)

print("Fetching SVG image URLs...")
try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        images = data.get("images", {})
        names = {
            "359:2653": "icon_logo",
            "358:973": "house",
            "358:979": "heart_straight",
            "358:985": "brain",
            "358:996": "gear_six",
            "1:1288": "curved_search",
            "1:1160": "curved_trending_up",
            "1:1535": "curved_clock",
            "356:1197": "icon_medicine",
            "356:1199": "icon_engineering",
            "356:1198": "icon_computer",
            "356:1200": "icon_management",
        }

        os.makedirs("assets/icons", exist_ok=True)

        for node_id, img_url in images.items():
            if img_url:
                print(f"Downloading {names[node_id]}.svg...")
                img_res = urllib.request.urlopen(img_url)
                with open(f"assets/icons/{names[node_id]}.svg", "wb") as f:
                    f.write(img_res.read())
                    
        print("Done extracting SVGs!")
except Exception as e:
    print("Failed: ", e)
