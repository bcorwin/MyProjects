from random import sample

class Card:
    def __init__(self, value, suit):
        if value not in [2,3,4,5,6,7,8,9,10,"J", "Q", "K", "A"]:
            raise ValueError("value must be 2-10, J, Q, K, or A")
        if suit not in ["♦","♣", "♥", "♠"]:
            raise ValueError("suit must be ♦, ♣, ♥, or ♠")
        self.value = str(value)
        self.suit = suit
    def __str__(self):
        return self.value + self.suit
        
class Deck:
    def __init__(self):
        deck = []
        for s in ["♦","♣", "♥", "♠"]:
            for v in [2,3,4,5,6,7,8,9,10,"J", "Q", "K", "A"]:
                deck.append(Card(v,s))
        self.deck = sample(deck, 52)
    def __str__(self):
        out = [str(c) for c in self.deck]
        return ' '.join(out)