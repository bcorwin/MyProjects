from math import factorial

facts = {i:factorial(i) for i in range(10)}

def isCurious(n):
    digits = [int(i) for i in str(n)]
    val = sum([facts[i] for i in digits])
    if val == n:
        print(n)
        return(True)
    else: return(False)
    

max = 100000
ans = 0
for n in range(10,max):
    if isCurious(n): ans += n
print(ans)