ts = [int(n*(n+1)/2) for n in range(1,100000)]
ps = [int(n*(3*n-1)/2) for n in range(1,100000)]
hs = [int(n*(2*n-1)) for n in range(1,100000)]

for t in ts:
	if t in ps and t in hs:
		print(t)