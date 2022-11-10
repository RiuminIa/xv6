
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  
  
  
int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7de63          	bge	a5,a0,4c <main+0x4c>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
   printf("hyba");
    exit(0);
  }
  for(i=1; i<argc; i++)
   // ls(argv[i]);
    printf("%s",argv[i]);
  28:	00000997          	auipc	s3,0x0
  2c:	7e098993          	addi	s3,s3,2016 # 808 <malloc+0xf4>
  30:	608c                	ld	a1,0(s1)
  32:	854e                	mv	a0,s3
  34:	00000097          	auipc	ra,0x0
  38:	628080e7          	jalr	1576(ra) # 65c <printf>
  for(i=1; i<argc; i++)
  3c:	04a1                	addi	s1,s1,8
  3e:	ff2499e3          	bne	s1,s2,30 <main+0x30>
  exit(0);
  42:	4501                	li	a0,0
  44:	00000097          	auipc	ra,0x0
  48:	2b0080e7          	jalr	688(ra) # 2f4 <exit>
   printf("hyba");
  4c:	00000517          	auipc	a0,0x0
  50:	7b450513          	addi	a0,a0,1972 # 800 <malloc+0xec>
  54:	00000097          	auipc	ra,0x0
  58:	608080e7          	jalr	1544(ra) # 65c <printf>
    exit(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	296080e7          	jalr	662(ra) # 2f4 <exit>

0000000000000066 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	00000097          	auipc	ra,0x0
  72:	f92080e7          	jalr	-110(ra) # 0 <main>
  exit(0);
  76:	4501                	li	a0,0
  78:	00000097          	auipc	ra,0x0
  7c:	27c080e7          	jalr	636(ra) # 2f4 <exit>

0000000000000080 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  86:	87aa                	mv	a5,a0
  88:	0585                	addi	a1,a1,1
  8a:	0785                	addi	a5,a5,1
  8c:	fff5c703          	lbu	a4,-1(a1)
  90:	fee78fa3          	sb	a4,-1(a5)
  94:	fb75                	bnez	a4,88 <strcpy+0x8>
    ;
  return os;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cb91                	beqz	a5,ba <strcmp+0x1e>
  a8:	0005c703          	lbu	a4,0(a1)
  ac:	00f71763          	bne	a4,a5,ba <strcmp+0x1e>
    p++, q++;
  b0:	0505                	addi	a0,a0,1
  b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	fbe5                	bnez	a5,a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ba:	0005c503          	lbu	a0,0(a1)
}
  be:	40a7853b          	subw	a0,a5,a0
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x26>
  d4:	0505                	addi	a0,a0,1
  d6:	87aa                	mv	a5,a0
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x10>
  e2:	40a6853b          	subw	a0,a3,a0
  e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for(n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfe5                	j	e8 <strlen+0x20>

00000000000000f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f8:	ca19                	beqz	a2,10e <memset+0x1c>
  fa:	87aa                	mv	a5,a0
  fc:	1602                	slli	a2,a2,0x20
  fe:	9201                	srli	a2,a2,0x20
 100:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 104:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 108:	0785                	addi	a5,a5,1
 10a:	fee79de3          	bne	a5,a4,104 <memset+0x12>
  }
  return dst;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb99                	beqz	a5,134 <strchr+0x20>
    if(*s == c)
 120:	00f58763          	beq	a1,a5,12e <strchr+0x1a>
  for(; *s; s++)
 124:	0505                	addi	a0,a0,1
 126:	00054783          	lbu	a5,0(a0)
 12a:	fbfd                	bnez	a5,120 <strchr+0xc>
      return (char*)s;
  return 0;
 12c:	4501                	li	a0,0
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret
  return 0;
 134:	4501                	li	a0,0
 136:	bfe5                	j	12e <strchr+0x1a>

0000000000000138 <gets>:

char*
gets(char *buf, int max)
{
 138:	711d                	addi	sp,sp,-96
 13a:	ec86                	sd	ra,88(sp)
 13c:	e8a2                	sd	s0,80(sp)
 13e:	e4a6                	sd	s1,72(sp)
 140:	e0ca                	sd	s2,64(sp)
 142:	fc4e                	sd	s3,56(sp)
 144:	f852                	sd	s4,48(sp)
 146:	f456                	sd	s5,40(sp)
 148:	f05a                	sd	s6,32(sp)
 14a:	ec5e                	sd	s7,24(sp)
 14c:	1080                	addi	s0,sp,96
 14e:	8baa                	mv	s7,a0
 150:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 152:	892a                	mv	s2,a0
 154:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 156:	4aa9                	li	s5,10
 158:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15a:	89a6                	mv	s3,s1
 15c:	2485                	addiw	s1,s1,1
 15e:	0344d863          	bge	s1,s4,18e <gets+0x56>
    cc = read(0, &c, 1);
 162:	4605                	li	a2,1
 164:	faf40593          	addi	a1,s0,-81
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	1a2080e7          	jalr	418(ra) # 30c <read>
    if(cc < 1)
 172:	00a05e63          	blez	a0,18e <gets+0x56>
    buf[i++] = c;
 176:	faf44783          	lbu	a5,-81(s0)
 17a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17e:	01578763          	beq	a5,s5,18c <gets+0x54>
 182:	0905                	addi	s2,s2,1
 184:	fd679be3          	bne	a5,s6,15a <gets+0x22>
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	a011                	j	18e <gets+0x56>
 18c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18e:	99de                	add	s3,s3,s7
 190:	00098023          	sb	zero,0(s3)
  return buf;
}
 194:	855e                	mv	a0,s7
 196:	60e6                	ld	ra,88(sp)
 198:	6446                	ld	s0,80(sp)
 19a:	64a6                	ld	s1,72(sp)
 19c:	6906                	ld	s2,64(sp)
 19e:	79e2                	ld	s3,56(sp)
 1a0:	7a42                	ld	s4,48(sp)
 1a2:	7aa2                	ld	s5,40(sp)
 1a4:	7b02                	ld	s6,32(sp)
 1a6:	6be2                	ld	s7,24(sp)
 1a8:	6125                	addi	sp,sp,96
 1aa:	8082                	ret

00000000000001ac <stat>:

int
stat(const char *n, struct stat *st)
{
 1ac:	1101                	addi	sp,sp,-32
 1ae:	ec06                	sd	ra,24(sp)
 1b0:	e822                	sd	s0,16(sp)
 1b2:	e426                	sd	s1,8(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	178080e7          	jalr	376(ra) # 334 <open>
  if(fd < 0)
 1c4:	02054563          	bltz	a0,1ee <stat+0x42>
 1c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ca:	85ca                	mv	a1,s2
 1cc:	00000097          	auipc	ra,0x0
 1d0:	180080e7          	jalr	384(ra) # 34c <fstat>
 1d4:	892a                	mv	s2,a0
  close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	00000097          	auipc	ra,0x0
 1dc:	144080e7          	jalr	324(ra) # 31c <close>
  return r;
}
 1e0:	854a                	mv	a0,s2
 1e2:	60e2                	ld	ra,24(sp)
 1e4:	6442                	ld	s0,16(sp)
 1e6:	64a2                	ld	s1,8(sp)
 1e8:	6902                	ld	s2,0(sp)
 1ea:	6105                	addi	sp,sp,32
 1ec:	8082                	ret
    return -1;
 1ee:	597d                	li	s2,-1
 1f0:	bfc5                	j	1e0 <stat+0x34>

00000000000001f2 <atoi>:

int
atoi(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f8:	00054683          	lbu	a3,0(a0)
 1fc:	fd06879b          	addiw	a5,a3,-48
 200:	0ff7f793          	zext.b	a5,a5
 204:	4625                	li	a2,9
 206:	02f66863          	bltu	a2,a5,236 <atoi+0x44>
 20a:	872a                	mv	a4,a0
  n = 0;
 20c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20e:	0705                	addi	a4,a4,1
 210:	0025179b          	slliw	a5,a0,0x2
 214:	9fa9                	addw	a5,a5,a0
 216:	0017979b          	slliw	a5,a5,0x1
 21a:	9fb5                	addw	a5,a5,a3
 21c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 220:	00074683          	lbu	a3,0(a4)
 224:	fd06879b          	addiw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	fef671e3          	bgeu	a2,a5,20e <atoi+0x1c>
  return n;
}
 230:	6422                	ld	s0,8(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  n = 0;
 236:	4501                	li	a0,0
 238:	bfe5                	j	230 <atoi+0x3e>

000000000000023a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 240:	02b57463          	bgeu	a0,a1,268 <memmove+0x2e>
    while(n-- > 0)
 244:	00c05f63          	blez	a2,262 <memmove+0x28>
 248:	1602                	slli	a2,a2,0x20
 24a:	9201                	srli	a2,a2,0x20
 24c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 250:	872a                	mv	a4,a0
      *dst++ = *src++;
 252:	0585                	addi	a1,a1,1
 254:	0705                	addi	a4,a4,1
 256:	fff5c683          	lbu	a3,-1(a1)
 25a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25e:	fee79ae3          	bne	a5,a4,252 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
    dst += n;
 268:	00c50733          	add	a4,a0,a2
    src += n;
 26c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26e:	fec05ae3          	blez	a2,262 <memmove+0x28>
 272:	fff6079b          	addiw	a5,a2,-1
 276:	1782                	slli	a5,a5,0x20
 278:	9381                	srli	a5,a5,0x20
 27a:	fff7c793          	not	a5,a5
 27e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 280:	15fd                	addi	a1,a1,-1
 282:	177d                	addi	a4,a4,-1
 284:	0005c683          	lbu	a3,0(a1)
 288:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28c:	fee79ae3          	bne	a5,a4,280 <memmove+0x46>
 290:	bfc9                	j	262 <memmove+0x28>

0000000000000292 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 298:	ca05                	beqz	a2,2c8 <memcmp+0x36>
 29a:	fff6069b          	addiw	a3,a2,-1
 29e:	1682                	slli	a3,a3,0x20
 2a0:	9281                	srli	a3,a3,0x20
 2a2:	0685                	addi	a3,a3,1
 2a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	0005c703          	lbu	a4,0(a1)
 2ae:	00e79863          	bne	a5,a4,2be <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b2:	0505                	addi	a0,a0,1
    p2++;
 2b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b6:	fed518e3          	bne	a0,a3,2a6 <memcmp+0x14>
  }
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	a019                	j	2c2 <memcmp+0x30>
      return *p1 - *p2;
 2be:	40e7853b          	subw	a0,a5,a4
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  return 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <memcmp+0x30>

00000000000002cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d4:	00000097          	auipc	ra,0x0
 2d8:	f66080e7          	jalr	-154(ra) # 23a <memmove>
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <trace>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global trace
trace:
 li a7, SYS_trace
 2e4:	48d9                	li	a7,22
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <fork>:
.global fork
fork:
 li a7, SYS_fork
 2ec:	4885                	li	a7,1
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f4:	4889                	li	a7,2
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fc:	488d                	li	a7,3
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 304:	4891                	li	a7,4
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <read>:
.global read
read:
 li a7, SYS_read
 30c:	4895                	li	a7,5
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <write>:
.global write
write:
 li a7, SYS_write
 314:	48c1                	li	a7,16
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <close>:
.global close
close:
 li a7, SYS_close
 31c:	48d5                	li	a7,21
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <kill>:
.global kill
kill:
 li a7, SYS_kill
 324:	4899                	li	a7,6
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exec>:
.global exec
exec:
 li a7, SYS_exec
 32c:	489d                	li	a7,7
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <open>:
.global open
open:
 li a7, SYS_open
 334:	48bd                	li	a7,15
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33c:	48c5                	li	a7,17
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 344:	48c9                	li	a7,18
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34c:	48a1                	li	a7,8
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <link>:
.global link
link:
 li a7, SYS_link
 354:	48cd                	li	a7,19
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35c:	48d1                	li	a7,20
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 364:	48a5                	li	a7,9
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <dup>:
.global dup
dup:
 li a7, SYS_dup
 36c:	48a9                	li	a7,10
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 374:	48ad                	li	a7,11
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 37c:	48b1                	li	a7,12
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 384:	48b5                	li	a7,13
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38c:	48b9                	li	a7,14
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 394:	1101                	addi	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	1000                	addi	s0,sp,32
 39c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a0:	4605                	li	a2,1
 3a2:	fef40593          	addi	a1,s0,-17
 3a6:	00000097          	auipc	ra,0x0
 3aa:	f6e080e7          	jalr	-146(ra) # 314 <write>
}
 3ae:	60e2                	ld	ra,24(sp)
 3b0:	6442                	ld	s0,16(sp)
 3b2:	6105                	addi	sp,sp,32
 3b4:	8082                	ret

00000000000003b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b6:	7139                	addi	sp,sp,-64
 3b8:	fc06                	sd	ra,56(sp)
 3ba:	f822                	sd	s0,48(sp)
 3bc:	f426                	sd	s1,40(sp)
 3be:	f04a                	sd	s2,32(sp)
 3c0:	ec4e                	sd	s3,24(sp)
 3c2:	0080                	addi	s0,sp,64
 3c4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c6:	c299                	beqz	a3,3cc <printint+0x16>
 3c8:	0805c963          	bltz	a1,45a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3cc:	2581                	sext.w	a1,a1
  neg = 0;
 3ce:	4881                	li	a7,0
 3d0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d6:	2601                	sext.w	a2,a2
 3d8:	00000517          	auipc	a0,0x0
 3dc:	49850513          	addi	a0,a0,1176 # 870 <digits>
 3e0:	883a                	mv	a6,a4
 3e2:	2705                	addiw	a4,a4,1
 3e4:	02c5f7bb          	remuw	a5,a1,a2
 3e8:	1782                	slli	a5,a5,0x20
 3ea:	9381                	srli	a5,a5,0x20
 3ec:	97aa                	add	a5,a5,a0
 3ee:	0007c783          	lbu	a5,0(a5)
 3f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f6:	0005879b          	sext.w	a5,a1
 3fa:	02c5d5bb          	divuw	a1,a1,a2
 3fe:	0685                	addi	a3,a3,1
 400:	fec7f0e3          	bgeu	a5,a2,3e0 <printint+0x2a>
  if(neg)
 404:	00088c63          	beqz	a7,41c <printint+0x66>
    buf[i++] = '-';
 408:	fd070793          	addi	a5,a4,-48
 40c:	00878733          	add	a4,a5,s0
 410:	02d00793          	li	a5,45
 414:	fef70823          	sb	a5,-16(a4)
 418:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 41c:	02e05863          	blez	a4,44c <printint+0x96>
 420:	fc040793          	addi	a5,s0,-64
 424:	00e78933          	add	s2,a5,a4
 428:	fff78993          	addi	s3,a5,-1
 42c:	99ba                	add	s3,s3,a4
 42e:	377d                	addiw	a4,a4,-1
 430:	1702                	slli	a4,a4,0x20
 432:	9301                	srli	a4,a4,0x20
 434:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 438:	fff94583          	lbu	a1,-1(s2)
 43c:	8526                	mv	a0,s1
 43e:	00000097          	auipc	ra,0x0
 442:	f56080e7          	jalr	-170(ra) # 394 <putc>
  while(--i >= 0)
 446:	197d                	addi	s2,s2,-1
 448:	ff3918e3          	bne	s2,s3,438 <printint+0x82>
}
 44c:	70e2                	ld	ra,56(sp)
 44e:	7442                	ld	s0,48(sp)
 450:	74a2                	ld	s1,40(sp)
 452:	7902                	ld	s2,32(sp)
 454:	69e2                	ld	s3,24(sp)
 456:	6121                	addi	sp,sp,64
 458:	8082                	ret
    x = -xx;
 45a:	40b005bb          	negw	a1,a1
    neg = 1;
 45e:	4885                	li	a7,1
    x = -xx;
 460:	bf85                	j	3d0 <printint+0x1a>

0000000000000462 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 462:	715d                	addi	sp,sp,-80
 464:	e486                	sd	ra,72(sp)
 466:	e0a2                	sd	s0,64(sp)
 468:	fc26                	sd	s1,56(sp)
 46a:	f84a                	sd	s2,48(sp)
 46c:	f44e                	sd	s3,40(sp)
 46e:	f052                	sd	s4,32(sp)
 470:	ec56                	sd	s5,24(sp)
 472:	e85a                	sd	s6,16(sp)
 474:	e45e                	sd	s7,8(sp)
 476:	e062                	sd	s8,0(sp)
 478:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47a:	0005c903          	lbu	s2,0(a1)
 47e:	18090c63          	beqz	s2,616 <vprintf+0x1b4>
 482:	8aaa                	mv	s5,a0
 484:	8bb2                	mv	s7,a2
 486:	00158493          	addi	s1,a1,1
  state = 0;
 48a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48c:	02500a13          	li	s4,37
 490:	4b55                	li	s6,21
 492:	a839                	j	4b0 <vprintf+0x4e>
        putc(fd, c);
 494:	85ca                	mv	a1,s2
 496:	8556                	mv	a0,s5
 498:	00000097          	auipc	ra,0x0
 49c:	efc080e7          	jalr	-260(ra) # 394 <putc>
 4a0:	a019                	j	4a6 <vprintf+0x44>
    } else if(state == '%'){
 4a2:	01498d63          	beq	s3,s4,4bc <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4a6:	0485                	addi	s1,s1,1
 4a8:	fff4c903          	lbu	s2,-1(s1)
 4ac:	16090563          	beqz	s2,616 <vprintf+0x1b4>
    if(state == 0){
 4b0:	fe0999e3          	bnez	s3,4a2 <vprintf+0x40>
      if(c == '%'){
 4b4:	ff4910e3          	bne	s2,s4,494 <vprintf+0x32>
        state = '%';
 4b8:	89d2                	mv	s3,s4
 4ba:	b7f5                	j	4a6 <vprintf+0x44>
      if(c == 'd'){
 4bc:	13490263          	beq	s2,s4,5e0 <vprintf+0x17e>
 4c0:	f9d9079b          	addiw	a5,s2,-99
 4c4:	0ff7f793          	zext.b	a5,a5
 4c8:	12fb6563          	bltu	s6,a5,5f2 <vprintf+0x190>
 4cc:	f9d9079b          	addiw	a5,s2,-99
 4d0:	0ff7f713          	zext.b	a4,a5
 4d4:	10eb6f63          	bltu	s6,a4,5f2 <vprintf+0x190>
 4d8:	00271793          	slli	a5,a4,0x2
 4dc:	00000717          	auipc	a4,0x0
 4e0:	33c70713          	addi	a4,a4,828 # 818 <malloc+0x104>
 4e4:	97ba                	add	a5,a5,a4
 4e6:	439c                	lw	a5,0(a5)
 4e8:	97ba                	add	a5,a5,a4
 4ea:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4ec:	008b8913          	addi	s2,s7,8
 4f0:	4685                	li	a3,1
 4f2:	4629                	li	a2,10
 4f4:	000ba583          	lw	a1,0(s7)
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	ebc080e7          	jalr	-324(ra) # 3b6 <printint>
 502:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 504:	4981                	li	s3,0
 506:	b745                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 508:	008b8913          	addi	s2,s7,8
 50c:	4681                	li	a3,0
 50e:	4629                	li	a2,10
 510:	000ba583          	lw	a1,0(s7)
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	ea0080e7          	jalr	-352(ra) # 3b6 <printint>
 51e:	8bca                	mv	s7,s2
      state = 0;
 520:	4981                	li	s3,0
 522:	b751                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 524:	008b8913          	addi	s2,s7,8
 528:	4681                	li	a3,0
 52a:	4641                	li	a2,16
 52c:	000ba583          	lw	a1,0(s7)
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e84080e7          	jalr	-380(ra) # 3b6 <printint>
 53a:	8bca                	mv	s7,s2
      state = 0;
 53c:	4981                	li	s3,0
 53e:	b7a5                	j	4a6 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 540:	008b8c13          	addi	s8,s7,8
 544:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 548:	03000593          	li	a1,48
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e46080e7          	jalr	-442(ra) # 394 <putc>
  putc(fd, 'x');
 556:	07800593          	li	a1,120
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e38080e7          	jalr	-456(ra) # 394 <putc>
 564:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 566:	00000b97          	auipc	s7,0x0
 56a:	30ab8b93          	addi	s7,s7,778 # 870 <digits>
 56e:	03c9d793          	srli	a5,s3,0x3c
 572:	97de                	add	a5,a5,s7
 574:	0007c583          	lbu	a1,0(a5)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e1a080e7          	jalr	-486(ra) # 394 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 582:	0992                	slli	s3,s3,0x4
 584:	397d                	addiw	s2,s2,-1
 586:	fe0914e3          	bnez	s2,56e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 58a:	8be2                	mv	s7,s8
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf21                	j	4a6 <vprintf+0x44>
        s = va_arg(ap, char*);
 590:	008b8993          	addi	s3,s7,8
 594:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 598:	02090163          	beqz	s2,5ba <vprintf+0x158>
        while(*s != 0){
 59c:	00094583          	lbu	a1,0(s2)
 5a0:	c9a5                	beqz	a1,610 <vprintf+0x1ae>
          putc(fd, *s);
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	df0080e7          	jalr	-528(ra) # 394 <putc>
          s++;
 5ac:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ae:	00094583          	lbu	a1,0(s2)
 5b2:	f9e5                	bnez	a1,5a2 <vprintf+0x140>
        s = va_arg(ap, char*);
 5b4:	8bce                	mv	s7,s3
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b5fd                	j	4a6 <vprintf+0x44>
          s = "(null)";
 5ba:	00000917          	auipc	s2,0x0
 5be:	25690913          	addi	s2,s2,598 # 810 <malloc+0xfc>
        while(*s != 0){
 5c2:	02800593          	li	a1,40
 5c6:	bff1                	j	5a2 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	000bc583          	lbu	a1,0(s7)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	dc2080e7          	jalr	-574(ra) # 394 <putc>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b5e1                	j	4a6 <vprintf+0x44>
        putc(fd, c);
 5e0:	02500593          	li	a1,37
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	dae080e7          	jalr	-594(ra) # 394 <putc>
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bd5d                	j	4a6 <vprintf+0x44>
        putc(fd, '%');
 5f2:	02500593          	li	a1,37
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	d9c080e7          	jalr	-612(ra) # 394 <putc>
        putc(fd, c);
 600:	85ca                	mv	a1,s2
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	d90080e7          	jalr	-624(ra) # 394 <putc>
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bd61                	j	4a6 <vprintf+0x44>
        s = va_arg(ap, char*);
 610:	8bce                	mv	s7,s3
      state = 0;
 612:	4981                	li	s3,0
 614:	bd49                	j	4a6 <vprintf+0x44>
    }
  }
}
 616:	60a6                	ld	ra,72(sp)
 618:	6406                	ld	s0,64(sp)
 61a:	74e2                	ld	s1,56(sp)
 61c:	7942                	ld	s2,48(sp)
 61e:	79a2                	ld	s3,40(sp)
 620:	7a02                	ld	s4,32(sp)
 622:	6ae2                	ld	s5,24(sp)
 624:	6b42                	ld	s6,16(sp)
 626:	6ba2                	ld	s7,8(sp)
 628:	6c02                	ld	s8,0(sp)
 62a:	6161                	addi	sp,sp,80
 62c:	8082                	ret

000000000000062e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 62e:	715d                	addi	sp,sp,-80
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	e010                	sd	a2,0(s0)
 638:	e414                	sd	a3,8(s0)
 63a:	e818                	sd	a4,16(s0)
 63c:	ec1c                	sd	a5,24(s0)
 63e:	03043023          	sd	a6,32(s0)
 642:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 646:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 64a:	8622                	mv	a2,s0
 64c:	00000097          	auipc	ra,0x0
 650:	e16080e7          	jalr	-490(ra) # 462 <vprintf>
}
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6161                	addi	sp,sp,80
 65a:	8082                	ret

000000000000065c <printf>:

void
printf(const char *fmt, ...)
{
 65c:	711d                	addi	sp,sp,-96
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	1000                	addi	s0,sp,32
 664:	e40c                	sd	a1,8(s0)
 666:	e810                	sd	a2,16(s0)
 668:	ec14                	sd	a3,24(s0)
 66a:	f018                	sd	a4,32(s0)
 66c:	f41c                	sd	a5,40(s0)
 66e:	03043823          	sd	a6,48(s0)
 672:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 676:	00840613          	addi	a2,s0,8
 67a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 67e:	85aa                	mv	a1,a0
 680:	4505                	li	a0,1
 682:	00000097          	auipc	ra,0x0
 686:	de0080e7          	jalr	-544(ra) # 462 <vprintf>
}
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	6125                	addi	sp,sp,96
 690:	8082                	ret

0000000000000692 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 692:	1141                	addi	sp,sp,-16
 694:	e422                	sd	s0,8(sp)
 696:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 698:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	00001797          	auipc	a5,0x1
 6a0:	9647b783          	ld	a5,-1692(a5) # 1000 <freep>
 6a4:	a02d                	j	6ce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a6:	4618                	lw	a4,8(a2)
 6a8:	9f2d                	addw	a4,a4,a1
 6aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ae:	6398                	ld	a4,0(a5)
 6b0:	6310                	ld	a2,0(a4)
 6b2:	a83d                	j	6f0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b4:	ff852703          	lw	a4,-8(a0)
 6b8:	9f31                	addw	a4,a4,a2
 6ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6bc:	ff053683          	ld	a3,-16(a0)
 6c0:	a091                	j	704 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c2:	6398                	ld	a4,0(a5)
 6c4:	00e7e463          	bltu	a5,a4,6cc <free+0x3a>
 6c8:	00e6ea63          	bltu	a3,a4,6dc <free+0x4a>
{
 6cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	fed7fae3          	bgeu	a5,a3,6c2 <free+0x30>
 6d2:	6398                	ld	a4,0(a5)
 6d4:	00e6e463          	bltu	a3,a4,6dc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	fee7eae3          	bltu	a5,a4,6cc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6dc:	ff852583          	lw	a1,-8(a0)
 6e0:	6390                	ld	a2,0(a5)
 6e2:	02059813          	slli	a6,a1,0x20
 6e6:	01c85713          	srli	a4,a6,0x1c
 6ea:	9736                	add	a4,a4,a3
 6ec:	fae60de3          	beq	a2,a4,6a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6f4:	4790                	lw	a2,8(a5)
 6f6:	02061593          	slli	a1,a2,0x20
 6fa:	01c5d713          	srli	a4,a1,0x1c
 6fe:	973e                	add	a4,a4,a5
 700:	fae68ae3          	beq	a3,a4,6b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 704:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 706:	00001717          	auipc	a4,0x1
 70a:	8ef73d23          	sd	a5,-1798(a4) # 1000 <freep>
}
 70e:	6422                	ld	s0,8(sp)
 710:	0141                	addi	sp,sp,16
 712:	8082                	ret

0000000000000714 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 714:	7139                	addi	sp,sp,-64
 716:	fc06                	sd	ra,56(sp)
 718:	f822                	sd	s0,48(sp)
 71a:	f426                	sd	s1,40(sp)
 71c:	f04a                	sd	s2,32(sp)
 71e:	ec4e                	sd	s3,24(sp)
 720:	e852                	sd	s4,16(sp)
 722:	e456                	sd	s5,8(sp)
 724:	e05a                	sd	s6,0(sp)
 726:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 728:	02051493          	slli	s1,a0,0x20
 72c:	9081                	srli	s1,s1,0x20
 72e:	04bd                	addi	s1,s1,15
 730:	8091                	srli	s1,s1,0x4
 732:	0014899b          	addiw	s3,s1,1
 736:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 738:	00001517          	auipc	a0,0x1
 73c:	8c853503          	ld	a0,-1848(a0) # 1000 <freep>
 740:	c515                	beqz	a0,76c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 742:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 744:	4798                	lw	a4,8(a5)
 746:	02977f63          	bgeu	a4,s1,784 <malloc+0x70>
  if(nu < 4096)
 74a:	8a4e                	mv	s4,s3
 74c:	0009871b          	sext.w	a4,s3
 750:	6685                	lui	a3,0x1
 752:	00d77363          	bgeu	a4,a3,758 <malloc+0x44>
 756:	6a05                	lui	s4,0x1
 758:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 75c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 760:	00001917          	auipc	s2,0x1
 764:	8a090913          	addi	s2,s2,-1888 # 1000 <freep>
  if(p == (char*)-1)
 768:	5afd                	li	s5,-1
 76a:	a895                	j	7de <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 76c:	00001797          	auipc	a5,0x1
 770:	8a478793          	addi	a5,a5,-1884 # 1010 <base>
 774:	00001717          	auipc	a4,0x1
 778:	88f73623          	sd	a5,-1908(a4) # 1000 <freep>
 77c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 77e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 782:	b7e1                	j	74a <malloc+0x36>
      if(p->s.size == nunits)
 784:	02e48c63          	beq	s1,a4,7bc <malloc+0xa8>
        p->s.size -= nunits;
 788:	4137073b          	subw	a4,a4,s3
 78c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 78e:	02071693          	slli	a3,a4,0x20
 792:	01c6d713          	srli	a4,a3,0x1c
 796:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 798:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 79c:	00001717          	auipc	a4,0x1
 7a0:	86a73223          	sd	a0,-1948(a4) # 1000 <freep>
      return (void*)(p + 1);
 7a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a8:	70e2                	ld	ra,56(sp)
 7aa:	7442                	ld	s0,48(sp)
 7ac:	74a2                	ld	s1,40(sp)
 7ae:	7902                	ld	s2,32(sp)
 7b0:	69e2                	ld	s3,24(sp)
 7b2:	6a42                	ld	s4,16(sp)
 7b4:	6aa2                	ld	s5,8(sp)
 7b6:	6b02                	ld	s6,0(sp)
 7b8:	6121                	addi	sp,sp,64
 7ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7bc:	6398                	ld	a4,0(a5)
 7be:	e118                	sd	a4,0(a0)
 7c0:	bff1                	j	79c <malloc+0x88>
  hp->s.size = nu;
 7c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c6:	0541                	addi	a0,a0,16
 7c8:	00000097          	auipc	ra,0x0
 7cc:	eca080e7          	jalr	-310(ra) # 692 <free>
  return freep;
 7d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7d4:	d971                	beqz	a0,7a8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	fa9775e3          	bgeu	a4,s1,784 <malloc+0x70>
    if(p == freep)
 7de:	00093703          	ld	a4,0(s2)
 7e2:	853e                	mv	a0,a5
 7e4:	fef719e3          	bne	a4,a5,7d6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7e8:	8552                	mv	a0,s4
 7ea:	00000097          	auipc	ra,0x0
 7ee:	b92080e7          	jalr	-1134(ra) # 37c <sbrk>
  if(p == (char*)-1)
 7f2:	fd5518e3          	bne	a0,s5,7c2 <malloc+0xae>
        return 0;
 7f6:	4501                	li	a0,0
 7f8:	bf45                	j	7a8 <malloc+0x94>
