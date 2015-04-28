def gcd(a, b):
    while b:
        a, b = b, a%b
    return a
    
p = [0 for i in range(1001)]
sqs = [i**2 for i in range(22)]

for m in range(1,21+1):
    for n in range(1,m):
        if gcd(m,n) > 1: break
        d = 2*(sqs[m] + m*n)
        max_k = int(1000/d)
        for k in range(1,max_k+1):
            p[k*d]+= 1

print(p.index(max(p)))