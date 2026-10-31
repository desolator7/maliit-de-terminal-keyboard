#define _GNU_SOURCE
#include <dlfcn.h>
#include <fcntl.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
static int fakefd=-1;
int open(const char *path,int flags,...) {
 static int (*realopen)(const char*,int,...);
 if(!realopen) realopen=dlsym(RTLD_NEXT,"open");
 if(strcmp(path,"/dev/uinput")==0) { const char *log=getenv("MALIIT_TEST_UINPUT"); fakefd=realopen(log,O_WRONLY|O_CREAT|O_TRUNC,0600); return fakefd; }
 mode_t mode=0; if(flags&O_CREAT){va_list args; va_start(args,flags); mode=va_arg(args,int); va_end(args);} return realopen(path,flags,mode);
}
int ioctl(int fd,unsigned long request,...) {
 static int (*realioctl)(int,unsigned long,...); if(!realioctl) realioctl=dlsym(RTLD_NEXT,"ioctl");
 va_list args; va_start(args,request); void *arg=va_arg(args,void*); va_end(args);
 if(fd==fakefd && fakefd>=0) return 0;
 return realioctl(fd,request,arg);
}
