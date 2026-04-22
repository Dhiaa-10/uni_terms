import json

def traverse(node, indent=0, out_file=None):
    name = node.get("name", "Unknown")
    node_type = node.get("type", "Unknown")
    colors = []
    
    if "fills" in node:
        for fill in node["fills"]:
            if fill.get("type") == "SOLID" and "color" in fill:
                c = fill["color"]
                rgba = f"rgba({int(c['r']*255)}, {int(c['g']*255)}, {int(c['b']*255)}, {c.get('a', 1)})"
                colors.append(rgba)
                
    text_content = ""
    if "characters" in node:
        text_content = f" | text: '{node['characters']}'"
        style = node.get("style", {})
        if style:
            text_content += f" | font: {style.get('fontFamily')}, size: {style.get('fontSize')}, weight: {style.get('fontWeight')}"
            
    color_str = f" | colors: {', '.join(colors)}" if colors else ""
            
    try:
        out_file.write(" " * indent + f"- {name} [{node_type}]{text_content}{color_str}\n")
    except UnicodeEncodeError:
        out_file.write(" " * indent + f"- (Unicode Name) [{node_type}]{text_content}{color_str}\n")
    
    for child in node.get("children", []):
        traverse(child, indent + 2, out_file)

with open("splash_design_raw.json", "r", encoding="utf-16") as f:
    data = json.load(f)

nodes = data.get("nodes", {})
if "17:3978" in nodes:
    with open("splash_tree_utf8.txt", "w", encoding="utf-8") as out_f:
        traverse(nodes["17:3978"].get("document", {}), out_file=out_f)
