import json

with open("splash_design_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

section = data.get("nodes", {}).get("17:3978", {}).get("document", {})
for child in section.get("children", []):
    if child.get("name") == "Splash" and child.get("type") == "FRAME":
        print("Splash Frame Details:")
        print("Fills:", json.dumps(child.get("fills", []), indent=2))
        print("Styles:", json.dumps(child.get("styles", []), indent=2))
