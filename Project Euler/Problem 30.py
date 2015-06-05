fifths = [i**5 for i in range(10)]

def is_fifth_sum(n):
	out = True if sum([fifths[int(d)] for d in str(n)]) == n else False
	return(out)
	

ans = []
for n in range(100, 1000000):
	if is_fifth_sum(n): ans.append(n)