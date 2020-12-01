import os
import requests
from urllib.parse import urljoin
from bs4 import BeautifulSoup

"""
https://stackoverflow.com/questions/54616638/download-all-pdf-files-from-a-website-using-python
"""

url = "http://16720.courses.cs.cmu.edu/lec.html"

#If there is no such folder, the script will create one automatically
folder_location = r'/home/kotaru/workspace/academics/old/16720/pdfs'
if not os.path.exists(folder_location):os.mkdir(folder_location)

response = requests.get(url)
soup= BeautifulSoup(response.text, "html.parser")     
for link in soup.select("a[href$='.pdf']"):
    #Name the pdf files using the last portion of each link which are unique in this case
    filename = os.path.join(folder_location,link['href'].split('/')[-1])
    with open(filename, 'wb') as f:
        f.write(requests.get(urljoin(url,link['href'])).content)