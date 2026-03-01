import sys
from pypdf import PdfReader
reader = PdfReader("collections/Answer/Students_Materials/Sunday School_Answer PDFs_A-Unit-01.pdf")
print("Total pages:", len(reader.pages))
text = ""
for i, page in enumerate(reader.pages[:4]):
    extracted = page.extract_text()
    print(f"Page {i} length: {len(extracted)}")
    text += extracted + "\n---PAGE BREAK---\n"
print("Extracted text snippet:")
print(text[:1000])
