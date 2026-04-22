import json

with open("onboarding_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

section = data.get("nodes", {}).get("17:4023", {}).get("document", {})

def find_ellipses(node, results):
    if node.get("type") == "ELLIPSE":
        fills = []
        for f in node.get("fills", []):
            if f.get("type") == "SOLID" and "color" in f:
                c = f["color"]
                fills.append(f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x} a={c.get('a',1)}")
        bb = node.get("absoluteBoundingBox", {})
        results.append(f"  {node['name']} fills={fills} w={bb.get('width')} h={bb.get('height')}")
    for child in node.get("children", []):
        find_ellipses(child, results)

def find_buttons(node, results):
    if node.get("name", "").startswith("Component_botton_onbording"):
        fills = []
        for f in node.get("fills", []):
            if f.get("type") == "SOLID" and "color" in f:
                c = f["color"]
                fills.append(f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}")
        strokes = []
        for s in node.get("strokes", []):
            if s.get("type") == "SOLID" and "color" in s:
                c = s["color"]
                strokes.append(f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}")
        bb = node.get("absoluteBoundingBox", {})
        results.append(f"  BTN: fills={fills} strokes={strokes} corner={node.get('cornerRadius')} w={bb.get('width')} h={bb.get('height')}")
    for child in node.get("children", []):
        find_buttons(child, results)

ellipses = []
find_ellipses(section, ellipses)
buttons = []
find_buttons(section, buttons)

with open("onboarding_details.txt", "w", encoding="utf-8") as out:
    out.write("=== ELLIPSES (dot indicators) ===\n")
    for e in ellipses:
        out.write(e + "\n")
    out.write("\n=== BUTTONS ===\n")
    for b in buttons:
        out.write(b + "\n")
