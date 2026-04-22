import json

def tree(node, out, indent=0):
    name = node.get("name", "")
    ntype = node.get("type", "")
    chars = node.get("characters", "")
    text_bit = f' -> "{chars}"' if chars else ""
    fills_info = ""
    for f in node.get("fills", []):
        if f.get("type") == "SOLID" and "color" in f:
            c = f["color"]
            fills_info += f" fill=#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}"
        elif f.get("type") == "GRADIENT_LINEAR":
            stops = []
            for s in f.get("gradientStops", []):
                c = s["color"]
                stops.append(f"#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}")
            fills_info += f" gradient={'->'.join(stops)}"
    strokes_info = ""
    for s in node.get("strokes", []):
        if s.get("type") == "SOLID" and "color" in s:
            c = s["color"]
            strokes_info += f" stroke=#{int(c['r']*255):02x}{int(c['g']*255):02x}{int(c['b']*255):02x}"
    style_info = ""
    if "style" in node:
        st = node["style"]
        style_info = f" font={st.get('fontFamily')} sz={st.get('fontSize')} w={st.get('fontWeight')}"
    bb = node.get("absoluteBoundingBox", {})
    size_info = f" [{bb.get('width','?')}x{bb.get('height','?')}]" if bb else ""
    corner = f" r={node.get('cornerRadius')}" if node.get('cornerRadius') else ""
    
    out.write("  " * indent + f"[{ntype}] {name}{text_bit}{fills_info}{strokes_info}{style_info}{size_info}{corner}\n")
    for child in node.get("children", []):
        tree(child, out, indent + 1)

# Parse Sign In
with open("signin_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)
section = data.get("nodes", {}).get("66:6298", {}).get("document", {})
with open("signin_tree.txt", "w", encoding="utf-8") as out:
    tree(section, out)

# Parse Components
with open("components_raw.json", "r", encoding="utf-16") as f:
    data2 = json.load(f)
comp_section = data2.get("nodes", {}).get("1:2", {}).get("document", {})
with open("components_tree.txt", "w", encoding="utf-8") as out:
    tree(comp_section, out)
