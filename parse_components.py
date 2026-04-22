import urllib.request
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

token = 'figd_hVLmXX97IK2Jw99oClBBInPvlW0yQX4CzU7w-koI'
file_id = 'xFUZJvB6LkKO8dEmHcH4dw'

req = urllib.request.Request(f'https://api.figma.com/v1/files/{file_id}/nodes?ids=1:2')
req.add_header('X-Figma-Token', token)

print('Fetching Figma components page...')
try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        with open('components_raw.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            
        def walk(node, depth=0, out=None):
            indent = "  " * depth
            t = node.get("type", "")
            n = node.get("name", "")
            id = node.get("id", "")
            out.write(f"{indent}- {n} [{t}] (ID: {id})\n")
            for child in node.get("children", []):
                walk(child, depth + 1, out)

        with open('components_tree.txt', 'w', encoding='utf-8') as out:
            nodes = data.get('nodes', {})
            page = nodes.get("1:2", {}).get("document", {})
            walk(page, 0, out)
            
    print('Saved to components_tree.txt')
except Exception as e:
    print('Failed to fetch:', e)
