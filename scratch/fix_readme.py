import os

readme_path = r'd:\uni_term\README.md'
with open(readme_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
skip_next = False
for i in range(len(lines)):
    if i < len(lines) - 2 and '## 📱 Screenshots' in lines[i] and '## 📱 Screenshots' in lines[i+2]:
        continue # skip the first one and the empty line
    new_lines.append(lines[i])

with open(readme_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
