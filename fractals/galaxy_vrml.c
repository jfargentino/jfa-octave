#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <math.h>

float hasard (void) { return rand()/32768.0; }

void InitHasard (void) {
  char choix ;
  struct timeval tv;
  gettimeofday (&tv, NULL);
  srand(tv.tv_usec) ;
}


int main(void) {
  int n;
  double r=0.1,v,phi,radius;
  double x=0,y=0,z=0;
  double pi=3.141592653589;

  InitHasard();

  for (n=1;n<=100;n++)
    {
      r=exp(-1.23*log(hasard()+0.12));
      v=1-2*hasard();
      phi=2*pi*hasard();
      x+=r*cos(phi)*sqrt(1-v*v);
      y+=r*sin(phi)*sqrt(1-v*v);
      z+=r*v;
      printf("  DEF ball%d Separator {\n"
             "    Translation {\n      translation %lf %lf %lf\n"
             "    }\n    Sphere {\n      radius %lf\n    }\n  }\n\n",
             n,x,y,z,radius);

    }
    return 0;
}
