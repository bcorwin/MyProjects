#include <IRremote.h>

// To do:
// - Auto off after 30 mins
// - Button to turn display on/off -- combine with reset button (press once vs. press & hold)
// - Variable resistor to adjust auto-off time

#define led_cnt 4
#define phase_cnt 8
#define button1 1382704329
#define button2 3951113197

//unsigned long auto_off_len = 1800000;
unsigned long auto_off_len = 1280000000;
//unsigned long synodic = 2551442877;
unsigned long synodic = 64010;
unsigned long phase_len = synodic/phase_cnt;

int IRpin = 11;  // pin for the IR sensor
IRrecv irrecv(IRpin);
decode_results results;

int leds[led_cnt] = {2,3,4,6};
int phase = phase_cnt-1;

int phases[phase_cnt][led_cnt];
int add[led_cnt];

unsigned long cur_time;
unsigned long last_update = millis();
unsigned long last_light = millis();

boolean disp_on = true; 

// the setup routine runs once when you press reset:
void setup() {
  Serial.begin(9600);
  irrecv.enableIRIn(); // Start the receiver
  //Create phases matrix and initialize the led pins.
  for(int j = 0; j < led_cnt; j++) {
    add[j] = LOW;
    pinMode(leds[j], OUTPUT);
  }

  for(int i = 0; i < phase_cnt; i++) {
    for(int j = 0; j < led_cnt; j++) {
      if(i < led_cnt) {
        add[i] = HIGH;
      } else {
        add[i - led_cnt] = LOW;
      }
      phases[i][j] = add[j];
    }
  }
}

// the loop routine runs over and over again forever:
void loop() {
  cur_time = millis();
  
   irrecv.resume();
   if(results.value != 0) {
      Serial.println(results.value);
   }
  if((cur_time - last_update) > phase_len) {
    update();
  } else if(results.value == button2) {
      if(disp_on == false) {
          disp_on = true;
          last_light = cur_time;
          set_phase(phase);
      } else {
        update();
      }
    delay(500);
  }
  if((cur_time - last_light) > auto_off_len) {
    disp_on = false;
    all_off();
  }
}

void update() {
  phase = (phase + 1) % phase_cnt;
  last_update = cur_time;
  if(disp_on == true) {
    set_phase(phase);
  }
}

void set_phase(int local_phase) {
  for(int j = 0; j < led_cnt; j++) {
    digitalWrite(leds[j], phases[local_phase][j]);
  }
}

void all_off() {
  for(int j = 0; j < led_cnt; j++) {
    digitalWrite(leds[j], LOW);
  }
}
