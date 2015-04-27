from itertools import product
from math import floor

#coin = {vals:[1,2,5,10,20,50,100,200], cnts:[0,0,0,0,0,0,0,0], sum: 0}
class Purse:
    def __init__(self, cnts = [0,0,0,0,0,0,0,0]):
        self.cnts = cnts
        self.vals = [1,2,5,10,20,50,100,200]
        self.sum  = sum([a*b for a,b in zip(self.cnts, self.vals)])
        
test = Purse([1,1,1,1,1,1,1,1])
print(test.sum)

pcnt = 0
for p1 in range(201):
    p2_max = floor((200-p1)/2)
    for p2 in range(p2_max+1):
        p3_max = floor((200-p1-2*p2)/5)
        for p3 in range(p3_max+1):
            p4_max = floor((200-p1-2*p2-5*p3)/10)
            for p4 in range(p4_max+1):
                p5_max = floor((200-p1-2*p2-5*p3-10*p4)/20)
                for p5 in range(p5_max+1):
                    p6_max = floor((200-p1-2*p2-5*p3-10*p4-20*p5)/50)
                    for p6 in range(p6_max+1):
                        p7_max = floor((200-p1-2*p2-5*p3-10*p4-20*p5-50*p6)/100)
                        for p7 in range(p7_max+1):
                            p8_max = floor((200-p1-2*p2-5*p3-10*p4-20*p5-50*p6-100*p7)/200)
                            for p8 in range(p8_max+1):
                                purse = Purse([p1,p2,p3,p4,p5,p6,p7,p8])
                                if purse.sum == 200: pcnt += 1
print("ANS:" + str(pcnt))