import json

with open("figma_depth2.json", "r", encoding="utf-8-sig") as f:
    data = json.load(f)

# Find the App page (id: 0:1)
app_page = next((p for p in data.get("document", {}).get("children", []) if p["id"] == "0:1"), None)

if app_page:
    with open("figma_frames.txt", "w", encoding="utf-8") as out:
        for child in app_page.get("children", []):
            out.write(f"ID: {child['id']} | Name: {child['name']}\n")
