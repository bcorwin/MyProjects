from math import sqrt

pcnt = 4
max = 100000
min = 100
nums = {i:True for i in range(max)}

for i in range(max):
    if i not in [0,1]:
        max_k = int(max/i)
        for k in range(2,max_k+1):
            nums[k*i] = False
    else: nums[i] = False
print("here1")
primes = []
for n in nums:
    if nums[n] == True: primes.append(n)
print("here2")
cnts = {i:0 for i in range(min,max)}
for n in range(min,max):
    max_d = int(sqrt(n))
    for d in primes:
        x = float(n)/float(d)
        if x == int(x): cnts[n] += 1
    if cnts[n] == pcnt:
        chk = True
        for k in range(1,pcnt):
            chk = (cnts[n] == cnts[n-k]) and chk
        if chk == True:
            print(n-pcnt+1)
            break
print("Done!")