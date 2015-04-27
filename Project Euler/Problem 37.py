max = 1000000
def get_primes(max):
    a = {i:True for i in range(max+1)}
    a[0] = a[1] = False
    for i in range(2,max+1):
        if a[i]:
            for n in range(i*i, max+1, i):
                if n <= max: a[n] = False
                else: break
    return(a)
nums = get_primes(max)
primes = []
for n in nums:
    if nums[n] == True: primes.append(n)
def isTruncatable(n):
    digits = [i for i in str(n)]
    l = len(digits)
    for i in range(1,l):
        sub = int(''.join(digits[i:]))
        if not nums[sub]: return False
        sub = int(''.join(digits[:i]))
        if not nums[sub]: return False
    return True

    
cnt = 0
ans = []
for n in primes:
    if n >= 10:
        r = isTruncatable(n)
        if r:
            cnt += 1
            ans.append(n)
            if cnt >= 11: break
print(cnt)
print(sum(ans))
print(ans)