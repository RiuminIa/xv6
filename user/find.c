#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
int
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
   // ls(".");
   printf("hyba");
    exit(0);
  }
  for(i=1; i<argc; i++)
   // ls(argv[i]);
    printf("%s",argv[i]);
  exit(0);
}
