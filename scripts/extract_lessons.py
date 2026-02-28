import os
import json
import re
import glob

try:
    import pypdf
except ImportError:
    os.system("python3 -m pip install pypdf")
    import pypdf

def extract_discovery(file_path):
    lessons = []
    reader = pypdf.PdfReader(file_path)
    text = ""
    for page in reader.pages:
        page_text = page.extract_text()
        if page_text:
            text += page_text + "\n"
    
    # Split text by "DISCOVERY" which usually starts a new lesson
    parts = re.split(r'\n?DISCOVERY\s*\n', text)
    
    for part in parts:
        if not part.strip() or "Outline" in part[:100] or "Timeline" in part[:100]:
            continue
            
        lesson = {}
        lines = part.strip().split('\n')
        if len(lines) < 4:
            continue
            
        # Title is usually the first line
        lesson['title'] = lines[0].strip()
        
        # Try to find SOURCE FOR QUESTIONS
        source_match = re.search(r'SOURCE FOR QUESTIONS\s*\n(.*?)\n', part)
        if source_match:
            lesson['bibleReference'] = [{'verse': source_match.group(1).strip()}]
        
        # KEY VERSE FOR MEMORIZATION
        key_verse_match = re.search(r'KEY VERSE FOR MEMORIZATION\s*\n(.*?)\n([A-Z])', part, re.DOTALL)
        if key_verse_match:
            lesson['keyVerse'] = key_verse_match.group(1).strip().replace('\n', ' ')
            
        # BACKGROUND
        bg_match = re.search(r'BACKGROUND\s*\n(.*?)(\nQUESTIONS|\nCONCLUSION|$)', part, re.DOTALL)
        if bg_match:
            lesson['background'] = bg_match.group(1).strip().replace('\n', ' ')
            
        # QUESTIONS
        q_match = re.search(r'QUESTIONS\s*\n(.*?)(\nCONCLUSION|\nNOTES|$)', part, re.DOTALL)
        questions = []
        if q_match:
            q_text = q_match.group(1)
            # Find numbers followed by dot e.g. "1. "
            q_parts = re.split(r'\n\d+\.\s*', '\n' + q_text)
            for qp in q_parts:
                qp = qp.strip()
                if qp:
                    questions.append(qp.replace('\n', ' '))
        lesson['questions'] = questions
        
        # CONCLUSION
        conc_match = re.search(r'CONCLUSION\s*\n(.*?)(\nNOTES|$)', part, re.DOTALL)
        if conc_match:
            lesson['conclusion'] = conc_match.group(1).strip().replace('\n', ' ')
            
        lessons.append(lesson)
        
    return lessons

def extract_daybreak(file_path):
    devotions = []
    reader = pypdf.PdfReader(file_path)
    text = ""
    for page in reader.pages:
        page_text = page.extract_text()
        if page_text:
            text += page_text + "\n"
            
    # Split text by "DAYBREAK"
    parts = re.split(r'\n?DAYBREAK\s*\n', text)
    
    for part in parts:
        if not part.strip() or "Outline" in part[:100]:
            continue
            
        devotion = {}
        lines = part.strip().split('\n')
        if len(lines) < 2:
            continue
            
        devotion['bibleReference'] = [{'verse': lines[0].strip()}]
        
        df_match = re.search(r'DEVOTIONAL FOCUS\s*\n(.*?)\nBACKGROUND', part, re.DOTALL)
        if df_match:
            devotion['devotion'] = df_match.group(1).strip().replace('\n', ' ')
            
        bg_match = re.search(r'BACKGROUND\s*\n(.*?)(\nAMPLIFIED OUTLINE|$)', part, re.DOTALL)
        if bg_match:
            devotion['background'] = bg_match.group(1).strip().replace('\n', ' ')
            
        ao_match = re.search(r'AMPLIFIED OUTLINE.*?\n(.*?)(\nA CLOSER LOOK|$)', part, re.DOTALL)
        if ao_match:
            devotion['amplifiedOutline'] = ao_match.group(1).strip().replace('\n', ' ')
            
        acl_match = re.search(r'A CLOSER LOOK\s*\n(.*?)(\nCONCLUSION|$)', part, re.DOTALL)
        if acl_match:
            acl_text = acl_match.group(1)
            qs = re.split(r'\n\d+\.\s*', '\n' + acl_text)
            questions = []
            for qp in qs:
                qp = qp.strip()
                if qp:
                    questions.append(qp.replace('\n', ' '))
            devotion['aCloserLook'] = questions
            
        conc_match = re.search(r'CONCLUSION\s*\n(.*?)(\nNOTES|$)', part, re.DOTALL)
        if conc_match:
            devotion['conclusion'] = conc_match.group(1).strip().replace('\n', ' ')
            
        devotions.append(devotion)
        
    return devotions

def process_all():
    collections_dir = "/Users/Strive/Projects/AFC-StudyMate/collections"
    
    all_discovery = []
    discovery_files = sorted(glob.glob(f"{collections_dir}/Discovery/*.pdf"))
    for df in discovery_files:
        print(f"Processing {os.path.basename(df)}")
        lessons = extract_discovery(df)
        # add weekIndex incrementally
        for l in lessons:
            l['id'] = f"discovery_{len(all_discovery)}"
            l['weekIndex'] = len(all_discovery)
            l['track'] = 'discovery'
            all_discovery.append(l)
            
    all_daybreak = []
    daybreak_files = sorted(glob.glob(f"{collections_dir}/Daybreak/*.pdf"))
    for df in daybreak_files:
        print(f"Processing {os.path.basename(df)}")
        devs = extract_daybreak(df)
        for d in devs:
            d['id'] = f"daybreak_{len(all_daybreak)}"
            d['dayIndex'] = len(all_daybreak)
            d['track'] = 'daybreak'
            all_daybreak.append(d)
            
    out_dir = "/Users/Strive/Projects/AFC-StudyMate/assets/data"
    
    with open(f"{out_dir}/discovery_lessons.json", "w") as f:
        json.dump(all_discovery, f, indent=2)
        
    with open(f"{out_dir}/daybreak_lessons.json", "w") as f:
        json.dump(all_daybreak, f, indent=2)
        
    print(f"Extracted {len(all_discovery)} Discovery lessons and {len(all_daybreak)} Daybreak devotions.")

if __name__ == "__main__":
    process_all()
