import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, unquote
import re
import time

BASE_URL = "https://www.apostolicfaith.org/library/curriculum"
HEADERS = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

def clean_filename(name):
    """Removes characters that aren't allowed in filenames."""
    name = re.sub(r'[\\/*?:"<>|]', "", name) # Remove illegal chars
    return name.strip().replace(" ", "_") # Space to underscore for better compatibility

def download_and_rename_pdfs():
    response = requests.get(BASE_URL, headers=HEADERS)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    series_links = [urljoin(BASE_URL, a['href']) for a in soup.select('a[href*="/curriculum-series/"]')]
    series_links = list(set(series_links)) 

    for series_url in series_links:
        series_slug = series_url.split('/')[-1]
        category_name = clean_filename(series_slug.replace('-for-students', '').replace('-for-teachers', '').title())
        
        print(f"📂 Processing Category: {category_name}")

        series_page = requests.get(series_url, headers=HEADERS)
        series_soup = BeautifulSoup(series_page.text, 'html.parser')
        
        # Target PDF links
        pdf_links = series_soup.find_all('a', href=lambda href: href and href.lower().endswith('.pdf'))
        
        for pdf in pdf_links:
            pdf_url = urljoin(series_url, pdf['href'])
            
            # Default to text from the <a> tag
            link_text = pdf.get_text(strip=True)
            
            # Try to infer a better title based on the DOM structure we investigated
            # PDF link is usually inside a <div> that has a sibling <a> tag with class 'curr-series_dd-link'
            parent_div = pdf.parent
            if parent_div and parent_div.name == 'div':
                grandparent = parent_div.parent
                if grandparent and grandparent.name == 'div' and grandparent.has_attr('role') and grandparent['role'] == 'listitem':
                    # Look for the sibling that contains the real title
                    title_link = grandparent.find('a', class_='curr-series_dd-link')
                    if title_link:
                        sibling_div = title_link.find('div', class_='is-curr-series')
                        if sibling_div:
                             link_text = sibling_div.get_text(strip=True)

            # If the acquired title is just "UNIT PDF" or very short, fallback to the filename from the URL
            if link_text.upper() == "UNIT PDF" or len(link_text) < 5:
                # Oracle Cloud URLs sometimes encode slashes as %2F, so we unquote first.
                decoded_url = unquote(pdf_url)
                # Then split by '/' and take the last part
                filename_from_url = decoded_url.split('/')[-1]
                # Remove the .pdf extension to keep the logic below consistent
                if filename_from_url.lower().endswith('.pdf'):
                    filename_from_url = filename_from_url[:-4]
                link_text = filename_from_url

            url_lower = pdf_url.lower()
            text_lower = link_text.lower()

            # 1. Determine sub-folder
            if "teacher" in url_lower or "teacher" in text_lower:
                sub_folder = "Teacher_Guides"
                suffix = "_Teacher"
            elif any(x in url_lower or x in text_lower for x in ["student", "pupil", "pals"]):
                sub_folder = "Student_Materials"
                suffix = "_Student"
            else:
                sub_folder = "General_Resources"
                suffix = ""

            # 2. Create the Readable Filename
            # Example: "Unit 1 - The Early Church" + "_Teacher" + ".pdf"
            new_name = f"{clean_filename(link_text)}{suffix}.pdf"
            
            target_dir = os.path.join(category_name, sub_folder)
            if not os.path.exists(target_dir):
                os.makedirs(target_dir)

            filepath = os.path.join(target_dir, new_name)

            if os.path.exists(filepath):
                print(f"   ⏩ Skipping (exists): {new_name}")
                continue

            print(f"   📥 Downloading: {new_name}")
            
            try:
                pdf_data = requests.get(pdf_url, headers=HEADERS, timeout=15)
                with open(filepath, 'wb') as f:
                    f.write(pdf_data.content)
                time.sleep(0.7) # Slightly longer delay to be extra safe
            except Exception as e:
                print(f"   ❌ Error with {new_name}: {e}")

    print("\n✨ Done! Your readable library is ready.")

if __name__ == "__main__":
    download_and_rename_pdfs()