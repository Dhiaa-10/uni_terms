import json

with open("onboarding_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

section = data.get("nodes", {}).get("17:4023", {}).get("document", {})

def find_check_details(node, results, parent_is_check=False):
    if node.get("name") == "CheckCircle":
        for child in node.get("children", []):
            find_check_details(child, results, True)
        return
    if parent_is_check and node.get("type") == "VECTOR":
        for f in node.get("fills", []):
            if f.get("type") == "SOLID" and "color" in f:
                c = f["color"]
                hex_c = f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}"
                results.append(f"  {node['name']}: {hex_c}")
    for child in node.get("children", []):
        find_check_details(child, results, parent_is_check)

# Only check the first onboarding frame
first_frame = section.get("children", [])[-1]  # onbording_01
results = []
find_check_details(first_frame, results)
with open("check_detail_colors.txt", "w", encoding="utf-8") as out:
    for r in results:
        out.write(r + "\n")
