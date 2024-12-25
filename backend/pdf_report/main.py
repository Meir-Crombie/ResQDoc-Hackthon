import pdfkit
from jinja2 import Environment, FileSystemLoader
import os
import json

# Function to create HTML from JSON data
def create_html(data):
    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template('template.html')
    return template.render(data=data)

# Function to generate PDF from HTML
def generate_pdf(data, output_pdf):
    html_content = create_html(data)
    with open('report.html', 'w', encoding='utf-8') as file:
        file.write(html_content)

    pdf_options = {
        'page-size': 'A4',
        'margin-top': '0cm',
        'margin-right': '1cm',
        'margin-bottom': '0cm',
        'margin-left': '1cm',
        'encoding': "UTF-8",
        'enable-local-file-access': None
    }

    pdfkit.from_file('report.html', output_pdf, options=pdf_options)
    print("PDF נוצר בהצלחה!")

# Example usage
if __name__ == "__main__":
    with open('storage/emulated/0/Documents/file.json', 'r', encoding='utf-8') as file:
        json_data = json.load(file)
    generate_pdf(json_data, 'report2.pdf')
