#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int ping[2];
  int pong[2];
  char buf;
  pipe(ping);
  pipe(pong);
  int pid=fork();
  if(pid==0){
      read(ping[0],&buf,1);
      printf("%d: received ping\n",getpid());
      buf='\0';
      write(pong[1],"b",1);
      wait(0);
  }
  else if(pid>0){
      write(ping[1],"a",1);
      read(pong[0],&buf,1);
      printf("%d: received pong\n",getpid());

      
  }
  else{
      fprintf(2,"Alarm");
      exit(1);
  }
  exit(0);
}
  
  
  
  
  
