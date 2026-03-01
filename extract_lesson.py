import sys
from pypdf import PdfReader

reader = PdfReader("collections/Answer/Students_Materials/Sunday School_Answer PDFs_A-Unit-01.pdf")
text = ""
for i in range(2, 7):
    text += f"\n--- PAGE {i} ---\n"
    text += reader.pages[i].extract_text() + "\n"

with open("lesson1_sample.txt", "w", encoding="utf-8") as f:
    f.write(text)
