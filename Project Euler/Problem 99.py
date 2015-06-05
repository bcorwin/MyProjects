import csv
import urllib2
from math import log
from time import time

url = "https://projecteuler.net/project/resources/p099_base_exp.txt"
response = urllib2.urlopen(url)
cr = csv.reader(response)

start = time()

data = [ int(b)*log(int(a)) for a,b in cr]
print(data.index(max(data)))

print(time() - start)