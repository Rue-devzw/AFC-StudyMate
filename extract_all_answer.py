import os
import re
import json
from pypdf import PdfReader

PDF_DIR = "collections/Answer/Students_Materials"
OUTPUT_FILE = "assets/data/the_answer_lessons.json"

def clean_text(text):
    text = re.sub(r'DOWNLOAD OUR MOBILE APP\s*//\s*\d+', '', text)
    text = re.sub(r'\d+\s*//\s*VISIT US @ W W W\. APOSTOLICFAITH\.ORG', '', text)
    text = re.sub(r'\d+\s*//\s*', '', text)
    return text.strip()

def process_pdf(filepath, unit_num):
    print(f"Processing Unit {unit_num}...")
    reader = PdfReader(filepath)
    lessons = []
    
    current_lesson = None
    
    # We will read through all pages and partition by "LESSON X"
    for page_num in range(len(reader.pages)):
        text = reader.pages[page_num].extract_text()
        if not text:
            continue
            
        text = clean_text(text)
        
        # Look for a lesson header: e.g. "LESSON 1 → Genesis 1:1-25"
        # The title is usually right above it, but this is a rough block parse.
        # Handling the raw struct requires finding 'LESSON \d+ \u2192' (right arrow)
        matches = re.finditer(r'(.*?)\nLESSON\s+(\d+)\s*[→\->]\s*(.+?)\n', text, re.DOTALL)
        
        # To avoid overly complex state machines, a regex-based block splitting per page 
        # is hard because a lesson spans multiple pages.
        
        # Let's try combining all text for a PDF first, then splitting by "LESSON \d+ →" 
        pass

def extract_all():
    global_text = ""
    all_lessons = []
    
    # Collect all PDF files in order
    files = sorted([f for f in os.listdir(PDF_DIR) if f.endswith('.pdf')])
    
    lesson_counter = 1
    
    for f in files:
        filepath = os.path.join(PDF_DIR, f)
        reader = PdfReader(filepath)
        
        full_text = ""
        for page in reader.pages:
            t = page.extract_text()
            if t:
                full_text += clean_text(t) + "\n"
                
        # Split by "LESSON \d+ → " or similar arrows
        blocks = re.split(r'\n(?=(?:[A-Z\s\?\!\']+)?\n?LESSON\s+\d+\s*[→\->])', full_text)
        
        for block in blocks:
            if not block or block.strip() == "":
                continue
                
            # Use search to find the Lesson Header
            header_match = re.search(r'LESSON\s+(\d+)\s*[→\->]\s*(.+?)\n', block)
            if not header_match:
                continue
            
            raw_title_area = block[:header_match.start()]
            lines = [x.strip() for x in raw_title_area.split('\n') if x.strip()]
            
            # The title is usually right before "LESSON X"
            title = lines[-1] if lines else f"Lesson {header_match.group(1)}"
            
            # In some PDFs, the title is broken into multiple lines or has leading garbage.
            # Clean up title if it grabbed garbage
            title = ' '.join(title.split('\n')[-2:]).strip() 
            
            bible_ref = header_match.group(2).strip()
            
            # Simple heuristic for story vs key verse
            story_raw = block[header_match.end():]
            
            key_verse_match = re.search(r'KEY VERSE\n(.+?)\n(.+?)\nKEY VERSE', story_raw, re.DOTALL)
            key_verse = None
            if key_verse_match:
                key_verse = {
                    "title": key_verse_match.group(1).strip(),
                    "text": key_verse_match.group(2).strip()
                }
                # Remove key verse block from story
                story_raw = story_raw[:key_verse_match.start()] + story_raw[key_verse_match.end():]
                
            # Activities heuristic: Look for "Lesson \d+ Activity"
            activity_split = re.split(r'Lesson\s+\d+\s+Activity', story_raw)
            story_text = activity_split[0]
            
            activities = []
            if len(activity_split) > 1:
                activities.append({
                    "type": "Activity",
                    "title": "Lesson Activity",
                    "instructions": activity_split[1][:200].strip().replace('\n', ' ')
                })
            
            paragraphs = [p.strip().replace('\n', ' ') for p in story_text.split('\n\n') if p.strip()]
            
            # Use the actual lesson number from the PDF
            lesson_num = int(header_match.group(1))
            
            lesson_obj = {
                "lesson_id": f"answer_{lesson_num}",
                "track": "answer",
                "title": title,
                "bible_text": bible_ref,
                "story": [p for p in paragraphs if len(p) > 20],
                "activities": activities
            }
            if key_verse:
                lesson_obj["key_verse"] = key_verse
                
            all_lessons.append(lesson_obj)
            print(f"Extracted Lesson {lesson_num}: {title} | {bible_ref}")

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(all_lessons, f, indent=2, ensure_ascii=False)
    
    print(f"Extraction complete. {len(all_lessons)} lessons saved.")

if __name__ == "__main__":
    extract_all()
