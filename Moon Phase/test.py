from time import time
import msvcrt

#synodic__sec = 29.530588853 * 24 * 60 * 60
synodic__sec = 40
phases = [0,1,2,3,4,5,6,7]
num_phases = 8
phase_len = synodic__sec/num_phases

cur_phase = phases[7]
next_time = time()
try:
    while True:
        cur_time = time()    
        if cur_time >= next_time:
            cur_phase = phases[(cur_phase + 1) % num_phases]
            next_time = cur_time + phase_len
            print("Current phase: ", str(cur_phase))
        elif msvcrt.kbhit() == 1:
            if msvcrt.getch().decode().upper() == "A":
                cur_phase = phases[(cur_phase + 1) % num_phases]
                next_time = cur_time + phase_len
                print("Resetting to: ", str(cur_phase))
except KeyboardInterrupt:
    print("End.")
    