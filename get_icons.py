import json

with open("components_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

def find_nodes(node):
    name = node.get("name", "")
    if name in ["curved / mail", "curved / eye-closed", "curved / eye-open", "curved / lock", "curved / lock-on", "curved / lock-off"]:
        print(f"{name}: {node.get('id')}")
    for child in node.get("children", []):
        find_nodes(child)

section = data.get("nodes", {}).get("1:2", {}).get("document", {})
find_nodes(section)
