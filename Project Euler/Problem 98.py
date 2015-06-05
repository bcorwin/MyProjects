import csv
import urllib2
from itertools import permutations

url = "https://projecteuler.net/project/resources/p098_words.txt"
response = urllib2.urlopen(url)

words = list(csv.reader(response, delimiter = ","))[0]
sorts = ["".join(sorted(list(w))) for w in words]
sorts_unique = {s:0 for s in list(set(sorts))}

sqs = [i**2 for i in range(31623)]

anas = {}
for s in sorts_unique:
    indices = [i for i, x in enumerate(sorts) if x == s]
    if len(indices) > 1:
        anas[s] = [words[i] for i in indices]

keys = sorted(anas, key=lambda key: -len(key))
print(anas)

def is_digit_unique(n):
    cnts = {}
    for s in str(n):
        if cnts.has_key(s): return(False)
        else: cnts[s] = 1
    return(True)

perms = [i for i in range(987654321)]

for a in anas:
    words = anas[a]
    print "Attempting for", words
    letters = list(set(a))
    for p in reversed(perms):
        wlen = len(words)
        cnt = 0
        vals = [0 for i in range(wlen)]
        issq = [False for i in range(wlen)]
        for wnum in range(wlen):
            w = words[wnum]
            nums = [str(p[letters.index(l)]) for l in w]
            val = int(''.join(map(str,nums)))
            
            vals[wnum] = val
            if p[letters.index(w[0])] !=0 and val in sqs:
                cnt += 1
                issq[wnum] = True
        if cnt >= 2:
            print "    Solution found:", vals, issq
            break
print("Done.")
# Be sure to exclude repeated letters when assigning numbers to letters      
# Be sure to compare all pairs (i.e. if there's more than 2 anas check all pairs)