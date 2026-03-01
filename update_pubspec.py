import yaml

with open('pubspec.yaml', 'r') as f:
    data = yaml.safe_load(f)

assets = data['flutter']['assets']

new_assets = [
    'assets/data/primary_pals_teacher_guides.json',
    'assets/data/answer_teacher_guides.json',
    'assets/data/discovery_teacher_guides.json',
    'assets/pdfs/primary_pals_teachers/',
    'assets/pdfs/answer_teachers/',
    'assets/pdfs/discovery_teachers/'
]

for a in new_assets:
    if a not in assets:
        assets.append(a)

with open('pubspec.yaml', 'w') as f:
    yaml.dump(data, f, sort_keys=False, default_flow_style=False)

