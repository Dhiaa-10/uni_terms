import json

def extract_text_nodes(node, results, depth=0):
    """Recursively collect text nodes and their styles."""
    name = node.get("name", "")
    ntype = node.get("type", "")
    
    if ntype == "TEXT":
        chars = node.get("characters", "")
        style = node.get("style", {})
        fills = node.get("fills", [])
        color_str = ""
        for f in fills:
            if f.get("type") == "SOLID" and "color" in f:
                c = f["color"]
                color_str = f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}"
        results.append({
            "depth": depth,
            "name": name,
            "text": chars,
            "font": style.get("fontFamily"),
            "size": style.get("fontSize"),
            "weight": style.get("fontWeight"),
            "color": color_str,
        })
    
    for child in node.get("children", []):
        extract_text_nodes(child, results, depth + 1)

def extract_frames(node, results, depth=0):
    """Recursively collect FRAME/SECTION/INSTANCE nodes with fills."""
    name = node.get("name", "")
    ntype = node.get("type", "")
    fills = node.get("fills", [])
    
    fill_info = []
    for f in fills:
        if f.get("type") == "SOLID" and "color" in f:
            c = f["color"]
            fill_info.append(f"SOLID #{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}")
        elif f.get("type") == "GRADIENT_LINEAR":
            stops = []
            for s in f.get("gradientStops", []):
                c = s["color"]
                stops.append(f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}")
            fill_info.append(f"GRADIENT {' -> '.join(stops)}")
    
    if ntype in ("FRAME", "SECTION", "INSTANCE", "RECTANGLE", "COMPONENT"):
        results.append({
            "depth": depth,
            "name": name,
            "type": ntype,
            "fills": fill_info,
            "w": node.get("absoluteBoundingBox", {}).get("width"),
            "h": node.get("absoluteBoundingBox", {}).get("height"),
            "cornerRadius": node.get("cornerRadius"),
            "padding": node.get("paddingLeft"),
            "itemSpacing": node.get("itemSpacing"),
        })
    
    for child in node.get("children", []):
        extract_frames(child, results, depth + 1)

with open("onboarding_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

section = data.get("nodes", {}).get("17:4023", {}).get("document", {})

# Get a high-level tree
def tree(node, out, indent=0):
    name = node.get("name", "")
    ntype = node.get("type", "")
    chars = node.get("characters", "")
    text_bit = f' -> "{chars}"' if chars else ""
    out.write("  " * indent + f"[{ntype}] {name}{text_bit}\n")
    for child in node.get("children", []):
        tree(child, out, indent + 1)

with open("onboarding_tree.txt", "w", encoding="utf-8") as out:
    tree(section, out)

# Extract text and frame details
texts = []
extract_text_nodes(section, texts)
frames = []
extract_frames(section, frames)

with open("onboarding_texts.txt", "w", encoding="utf-8") as out:
    for t in texts:
        out.write(f"  {'  '*t['depth']}TEXT: \"{t['text']}\" | font={t['font']} size={t['size']} weight={t['weight']} color={t['color']}\n")

with open("onboarding_frames.txt", "w", encoding="utf-8") as out:
    for fr in frames:
        out.write(f"  {'  '*fr['depth']}{fr['type']}: \"{fr['name']}\" fills={fr['fills']} w={fr['w']} h={fr['h']} corner={fr['cornerRadius']} padding={fr['padding']} spacing={fr['itemSpacing']}\n")
