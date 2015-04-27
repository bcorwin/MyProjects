from math import floor, log

reg_nums = []
max = 1000
max_i = floor(log(max)/log(2))
for i in range(max_i + 1):
    max_j = floor(log(max/2**i)/log(5))
    for j in range(max_j + 1):
        reg_nums.append(2**i * 5**j)
reg_nums.sort()

def get_decimal_info(n):
    t = None
    s = None
    if n in reg_nums: pass
    elif n % 2 != 0 and n % 5 != 0:
        s = 0
        for t in range(1,n):
            if 10**t % n == 1: break
    else:
        vals = []
        for st in range(n):
            val = 10**st % n
            if val in vals:
                s = vals.index(val)
                t = st - s
                break
            else: vals.append(val)
    return((1/n,s,t))

max_t = 0
max_d = 0
for d in range(1,1000):
    val, s, t = get_decimal_info(d)
    if t != None and t > max_t:
        max_t = t
        max_d = d
print(max_d)
print(max_t)
