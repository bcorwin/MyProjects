from random import randint, sample

class game():
    def __init__(self):
        self.sqs = {i:0 for i in range(40)}
        self.cur_sq = 0
        
        self.cc_cards = sample(range(16), 16)
        self.cur_cc = 0
        
        self.ch_cards = sample(range(16), 16)
        self.cur_ch = 0
        
    def get_nearest_r(self, loc):
        RRs = [5,15,25,35]
        Dist = [(i-loc)%39 for i in RRs]
        return(RRs[Dist.index(min(Dist))])
    
    def get_nearest_u(self, loc):
        Us = [12,28]
        Dist = [(i-loc)%39 for i in Us]
        return(Us[Dist.index(min(Dist))])

    def draw_cc(self, loc):        
        out = loc
        card = self.cc_cards[self.cur_cc]
        if card == 0: out = 0
        elif card == 1: out = 10
        elif card == 2: out = 11
        elif card == 3: out = 24
        elif card == 4: out = 39
        elif card == 5: out = 5
        elif card in [6,7]: out = self.get_nearest_r(loc)
        elif card == 8: out = self.get_nearest_u(loc)        
        elif card == 9: out = (loc - 3) % 39
        
        self.cur_cc = (self.cur_cc + 1) % 16
        return(out)
    
    def draw_ch(self, loc):
        out = loc
        card = self.ch_cards[self.cur_ch]
        if card == 0: out = 0
        elif card == 1: out = 10
            
        self.cur_ch = (self.cur_ch + 1) % 16
        return(out)
    
    def roll(self):
        die1 = randint(1,6)
        die2 = randint(1,6)
        double = True if die1 == die2 else False
        return (die1 + die2, double)
    
    def play(self, turns):
        doubles = 0
        for t in range(turns): 
            cur_roll = self.roll()
            
            if cur_roll[1] == True: doubles += 1
            else: doubles = 0
            
            if doubles == 3: self.cur_sq = 10
            else:
                val = (self.cur_sq + cur_roll[0]) % 39
                if val in [2, 17, 33]: self.cur_sq = self.draw_cc(val)
                elif val in [7,22,36]: self.cur_sq = self.draw_ch(val)
                else: self.cur_sq = val
            
            if self.cur_sq == 30: self.cur_sq = 10
                
            self.sqs[self.cur_sq] += 1
    def print_game(self):
        sorted(self.sqs, key = lambda key: key)
        total = float(sum([self.sqs[i] for i in self.sqs]))
        for i in self.sqs:
            val = self.sqs[i]
            print i, ":", val,  100*val/total
    def get_top(self, n=3):
        total = float(sum([self.sqs[i] for i in self.sqs]))
        for i in sorted(self.sqs, key=lambda key: -self.sqs[key])[:n]:
            val = self.sqs[i]
            print i, ":", val,  100*val/total
cur_game = game()
cur_game.play(100000000)
cur_game.get_top(5)