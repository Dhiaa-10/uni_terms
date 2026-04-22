import json

with open("onboarding_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

section = data.get("nodes", {}).get("17:4023", {}).get("document", {})

def find_check_vectors(node, results):
    if node.get("name") == "CheckCircle":
        for child in node.get("children", []):
            if child.get("type") == "VECTOR":
                for f in child.get("fills", []):
                    if f.get("type") == "SOLID" and "color" in f:
                        c = f["color"]
                        results.append(f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}")
    for child in node.get("children", []):
        find_check_vectors(child, results)

results = []
find_check_vectors(section, results)
with open("check_colors.txt", "w", encoding="utf-8") as out:
    for r in results:
        out.write(r + "\n")
