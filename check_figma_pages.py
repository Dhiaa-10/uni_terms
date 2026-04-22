import urllib.request
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

token = 'figd_hVLmXX97IK2Jw99oClBBInPvlW0yQX4CzU7w-koI'
file_id = 'xFUZJvB6LkKO8dEmHcH4dw'

req = urllib.request.Request(f'https://api.figma.com/v1/files/{file_id}?depth=2')
req.add_header('X-Figma-Token', token)

print('Fetching Figma file depth=2...')
try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        doc = data.get('document', {})
        print(f"Document Name: {data.get('name')}")
        for page in doc.get('children', []):
            print(f"\nPage: {page['name']} (ID: {page['id']})")
            for frame in page.get('children', []):
                print(f"  - {frame['name']} (Type: {frame['type']}, ID: {frame['id']})")
except Exception as e:
    print('Failed to fetch:', e)
