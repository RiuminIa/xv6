#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void rura(int left[2]){
 // printf("3\n");
  int right[2];
  int pid;

  int prvcislo=0;
  pipe(right);
  int z;
 // printf("4\n");
    while(read(left[0],&z,4)>0){
    //  printf("6\n");
      if (prvcislo==0){
       // printf("7\n");
        printf("prime %d\n",z);
        prvcislo=z;
       // printf("8\n");
      }
      else if (z%prvcislo!=0) {
        write(right[1],&z,4);
      }
    }
    close(right[1]);
    if (prvcislo!=0){
      pid=fork();
        if(pid==0){
          rura(right);
    }
  close(right[1]);
  wait(0);
  close(0);
}
}
int
main(int argc, char *argv[])
{
  int ping[2];
  pipe(ping);
  int pid;
  for(int i=2;i<35;i++){
    write(ping[1],&i,4);
  }
  //close(ping[0]);
  close(ping[1]);
  pid=fork();
  if(pid==0){
    rura(ping); 
  }
wait(0);
//printf("2\n");
exit(0);
}
