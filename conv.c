#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int score = 0;

void enable_nonblocking_input() {
    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);
}
char read_input() {
  char c;
  ssize_t n = read(STDIN_FILENO, &c, 1);
  if (n == 1) return c;
  return 0; // No input
}

struct termios orig_termios;

void disable_raw_mode() {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

void enable_raw_mode() {
    tcgetattr(STDIN_FILENO, &orig_termios);
    atexit(disable_raw_mode); // Restore on exit

    struct termios raw = orig_termios;
    raw.c_lflag &= ~(ECHO | ICANON); // No echo, no canonical mode
    raw.c_cc[VMIN] = 0; // No minimum bytes
    raw.c_cc[VTIME] = 0; // No timeout
    
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}


unsigned long long milEp(){
  struct timeval tv;

  gettimeofday(&tv, NULL);

  unsigned long long millisecondsSinceEpoch =
    (unsigned long long)(tv.tv_sec) * 1000 +
    (unsigned long long)(tv.tv_usec) / 1000;

    return millisecondsSinceEpoch;
}
void count_bits(u_int8_t value, int8_t arr[8], int height) {
  for (int i = 0; i < 8; i++) {
      if (value & (1 << i)) {
        arr[i] += 1;
        if(((int)arr[i]) * 100 > height){
          arr[i] = -2;
          score++;
        }
      }
  }
}

u_int8_t rando(u_int8_t r)
{
  return r + 3 ^ (r>>1) * 7;
}

int main(int argc, char **argv) {
   enable_raw_mode();
   enable_nonblocking_input();
   int row, col, width, height, bitspp, bytespp;
   unsigned int *data;
   int8_t waves[8] = {1,1,1,1,1,1,1,1}; 
   u_int8_t seed = 124;
   int speed = 700;
   unsigned long long la = milEp();

   // Open the framebuffer device
   int fd = open("/dev/fb0", O_RDWR);

   // Get screen information
   struct fb_var_screeninfo screeninfo;
   struct fb_fix_screeninfo fixinfo;
   ioctl(fd, FBIOGET_VSCREENINFO, &screeninfo);
   ioctl(fd, FBIOGET_FSCREENINFO, &fixinfo);

   bitspp = screeninfo.bits_per_pixel;
   if(bitspp != 32) {
     printf("Color depth = %i bits per pixel\n", bitspp);
     printf("Please change color depth to 32bpp\n");
     close(fd);
     return 1;
   }

   width  = screeninfo.xres;
   height = screeninfo.yres;
   bytespp = bitspp / 8;
   int screensize = fixinfo.line_length * height;

   data = (unsigned int*) mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

   char c = 'g';
   int py = 1;
   int px = 1;
   do {
    c = read_input();
    if(c == 'd' || c == 'D') px+=1;
    if(c == 'a' || c == 'A') px-=1;
    if(px > 7) px--;
    if(px < 0) px++;

    int mv = height % 100;
    height = height - mv;
    mv = width % 100;
    width = width-mv;

    if(milEp()-la > speed){
      count_bits(seed = rando(seed), waves, height);
      la = milEp();
      speed = speed * 100 / 101;
    }
    
    for(row = 0; row < height; row++) {
      for(col = 0; col < width; col++) {
        unsigned int *pixel = (unsigned int *)((char *)data + row * fixinfo.line_length + col * bytespp);
        *pixel = 0xFF2E70F3;
        if(row > height-100 && row < height && col > px*100 && col < px*100+100){
          *pixel = 0xFFF31B6B;
          continue;
        }
        for(int i=0;i<8;i++){
          if(waves[i]*100 == height-100 && i == px){
            munmap(data, screensize);
            close(fd);
            disable_raw_mode();
            printf("Score: %d\n", score);
            return 0;
          }
          if(row > waves[i]*100 && row < waves[i]*100+100 && col > i*100 && col < (i+1)*100){
            *pixel = 0xFFFFFFFF;
            continue;
          }
        }
      }
    }
   }
   while (c != 't');
   
   munmap(data, screensize);
   close(fd);
   return 0;
}

