#include <stdio.h>
#include <signal.h>

void handler(int signo) {
  fprintf(stderr,"Caught signal %d\n", signo);
}


int main(int argc, char **argv) {

  int iteration = 0;

  signal(SIGINT, handler);
  signal(SIGTERM, handler);

  fprintf(stderr,"SIGINT and SIGTERM won't kill it, gotta us SIGKILL\n");

  while (1) {
    printf("hardToKill %d\n", ++iteration);
    sleep(1);
  }
}
