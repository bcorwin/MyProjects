def get_primes(max):
	a = {i:True for i in range(max+1)}
	a[0] = a[1] = False
	for i in range(2,max+1):
		if a[i]:
			for n in range(i*i, max+1, i):
				if n <= max: a[n] = False
				else: break
	return(a)
nums = get_primes(1000**2)

primes = []
for n in nums:
	if nums[n] == True: primes.append(n)

pcnt = 4
min = 10000
max = 100000
cnts = {i:0 for i in range(min,max)}
for n in range(min,max):
	for d in primes:
		if d >= n: break
		x = float(n)/float(d)
		if x == int(x): cnts[n] += 1
	if cnts[n] == pcnt:
		chk = True
		for k in range(1,pcnt):
			try: chk = (cnts[n] == cnts[n-k]) and chk
			except: chk = False
		if chk == True:
			print(n-pcnt+1)
			break
print("Done!")
