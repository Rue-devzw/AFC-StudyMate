import os
import json
import fitz  # PyMuPDF
import re

def clean_text(text):
    text = re.sub(r'DOWNLOAD OUR MOBILE APP\s*//\s*\d+', '', text)
    text = re.sub(r'\d+\s*//\s*VISIT US @ W W W\. APOSTOLICFAITH\.ORG', '', text)
    text = re.sub(r'\d+\s*//\s*', '', text)
    return text.strip()

def extract_pdf_text(filepath):
    text = ""
    try:
        doc = fitz.open(filepath)
        for page in doc:
            text += page.get_text() + "\n"
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
    return text

def parse_discovery_guides():
    # Discovery Teacher Guides use a different format... let's just dump the raw text per unit for now
    # Actually, if we just want to show the guide, maybe parsing it entirely into structured JSON is overkill
    # Let's extract raw text and split by Lesson
    pass

def parse_guides(directory, track_prefix, output_file):
    all_lessons = []
    
    files = sorted([f for f in os.listdir(directory) if f.endswith('.pdf')])
    
    for f in files:
        filepath = os.path.join(directory, f)
        print(f"Processing {filepath}")
        full_text = extract_pdf_text(filepath)
        
        # Split by Lesson headers
        # Common pattern: "LESSON \d+"
        blocks = re.split(r'\n(?=LESSON\s+\d+)', full_text, flags=re.IGNORECASE)
        
        for block in blocks:
            match = re.search(r'LESSON\s+(\d+)', block, re.IGNORECASE)
            if not match:
                continue
                
            lesson_num = match.group(1)
            content = clean_text(block).strip()
            
            # Remove giant empty gaps
            content = re.sub(r'\n{3,}', '\n\n', content)
            
            all_lessons.append({
                "lesson_id": f"{track_prefix}_{lesson_num}",
                "content": content,
                "pdf_path": f"{directory}/{f}"
            })
            
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_lessons, f, indent=2, ensure_ascii=False)
    
    print(f"Saved {len(all_lessons)} guides to {output_file}")


print("Parsing Primary Pals Teacher Guides...")
parse_guides("assets/pdfs/primary_pals_teachers", "primary_pals", "assets/data/primary_pals_teacher_guides.json")

print("\nParsing Answer/Search Teacher Guides...")
parse_guides("assets/pdfs/answer_teachers", "answer", "assets/data/answer_teacher_guides.json")

print("\nParsing Discovery Teacher Guides...")
parse_guides("assets/pdfs/discovery_teachers", "discovery", "assets/data/discovery_teacher_guides.json")

