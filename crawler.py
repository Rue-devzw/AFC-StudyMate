import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, unquote
import re
import time

URL1 = "https://www.apostolicfaith.org/curriculum-series/search-for-teachers"
URL2 = "https://www.apostolicfaith.org/curriculum-series/search-for-students"
HEADERS = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

def clean_filename(name):
    """Removes characters that aren't allowed in filenames."""
    name = re.sub(r'[\\/*?:"<>|]', "", name)
    return name.strip().replace(" ", "_").replace("\n", "").replace("\r", "")

def download_and_rename_pdfs(source_url, sub_folder):
    print(f"📂 Processing Category: {sub_folder}")

    series_page = requests.get(source_url, headers=HEADERS)
    series_soup = BeautifulSoup(series_page.text, 'html.parser')
    
    pdf_links = series_soup.find_all('a', href=lambda href: href and href.lower().endswith('.pdf'))
    
    for pdf in pdf_links:
        pdf_url = urljoin(source_url, pdf['href'])
        link_text = pdf.get_text(strip=True)
        
        # Determine better title from siblings if needed
        parent_div = pdf.parent
        if parent_div and parent_div.name == 'div':
            grandparent = parent_div.parent
            if grandparent and grandparent.name == 'div' and grandparent.has_attr('role') and grandparent['role'] == 'listitem':
                title_link = grandparent.find('a', class_='curr-series_dd-link')
                if title_link:
                    sibling_div = title_link.find('div', class_='is-curr-series')
                    if sibling_div:
                         link_text = sibling_div.get_text(strip=True)

        if "PDF" in link_text.upper() or len(link_text) < 5:
            decoded_url = unquote(pdf_url)
            filename_from_url = decoded_url.split('/')[-1]
            if filename_from_url.lower().endswith('.pdf'):
                filename_from_url = filename_from_url[:-4]
            link_text = filename_from_url

        url_lower = pdf_url.lower()

        # ONLY KEEP SEARCH PDFS (which either say Search in the URL or the text, but not Daybreak or Discovery)
        # Looking at the output, the objectstorage URLs have "Daybreak and Discovery" and "Search PDFs", etc.
        # Actually, let's look at the filename from URL.
        decoded_url = unquote(pdf_url)
        filename_from_url = decoded_url.split('/')[-1]

        # Exclude known wrong curriculums if they are mislinked
        if "DAYBREAK" in filename_from_url.upper() or "DISCOVERY" in filename_from_url.upper():
            continue
            
        # Often the Search PDF is just named something else. Let's make sure it's valid.
        new_name = f"{clean_filename(link_text)}.pdf"
        target_dir = os.path.join("collections", "Search", sub_folder)
        
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)

        filepath = os.path.join(target_dir, new_name)

        if os.path.exists(filepath):
            print(f"   ⏩ Skipping (exists): {new_name}")
            continue

        print(f"   📥 Downloading: {new_name} from {pdf_url}")
        
        try:
            pdf_data = requests.get(pdf_url, headers=HEADERS, timeout=30)
            if pdf_data.status_code == 200:
                with open(filepath, 'wb') as f:
                    f.write(pdf_data.content)
                time.sleep(0.5) 
            else:
                 print(f"   ❌ Error with {new_name}: Status {pdf_data.status_code}")
        except Exception as e:
            print(f"   ❌ Error with {new_name}: {e}")

def main():
    download_and_rename_pdfs(URL1, "Teacher_Guides")
    download_and_rename_pdfs(URL2, "Student_Materials")
    print("\n✨ Done! Search lessons downloaded.")

if __name__ == "__main__":
    main()
