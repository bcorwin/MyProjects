coeffs_list = [(a,b) for a in range(-999,1000) for b in range(-999,1000)]
sqs = [i**2 for i in range(1000)]

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

def p_cnt(coeffs):
	cnt = 0
	for n in range(1000**2):
		ans = sqs[n] + coeffs[0]*n + coeffs[1]
		if ans < 0: break
		elif ans > 1000**2: raise("Need more primes")
		elif nums[ans] == True: cnt += 1
		else: break
	return(cnt)

maxv = 0
ans = (0,0)
for coeffs in coeffs_list:
	chk = p_cnt(coeffs)
	if chk > maxv:
		maxv = chk
		ans = coeffs
print(ans)
print(maxv)
print(ans[0]*ans[1])