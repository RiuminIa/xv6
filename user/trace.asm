
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[] ){
   0:	712d                	addi	sp,sp,-288
   2:	ee06                	sd	ra,280(sp)
   4:	ea22                	sd	s0,272(sp)
   6:	e626                	sd	s1,264(sp)
   8:	e24a                	sd	s2,256(sp)
   a:	1200                	addi	s0,sp,288
   c:	84ae                	mv	s1,a1
int i;
char *nargv[MAXARG];
if(argc<3 || argv[1][0]<'0' || argv[1][0]>'9'){
   e:	4789                	li	a5,2
  10:	00a7dd63          	bge	a5,a0,2a <main+0x2a>
  14:	892a                	mv	s2,a0
  16:	6588                	ld	a0,8(a1)
  18:	00054783          	lbu	a5,0(a0)
  1c:	fd07879b          	addiw	a5,a5,-48
  20:	0ff7f793          	zext.b	a5,a5
  24:	4725                	li	a4,9
  26:	02f77163          	bgeu	a4,a5,48 <main+0x48>
   fprintf(2,"Usage: %s mask command\n",argv[1]);
  2a:	6490                	ld	a2,8(s1)
  2c:	00001597          	auipc	a1,0x1
  30:	82458593          	addi	a1,a1,-2012 # 850 <malloc+0xe6>
  34:	4509                	li	a0,2
  36:	00000097          	auipc	ra,0x0
  3a:	64e080e7          	jalr	1614(ra) # 684 <fprintf>
  exit(1);
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	30a080e7          	jalr	778(ra) # 34a <exit>
  }

  if(trace(atoi(argv[1]))<0)
  48:	00000097          	auipc	ra,0x0
  4c:	200080e7          	jalr	512(ra) # 248 <atoi>
  50:	00000097          	auipc	ra,0x0
  54:	2ea080e7          	jalr	746(ra) # 33a <trace>
  58:	04054363          	bltz	a0,9e <main+0x9e>
  5c:	01048793          	addi	a5,s1,16
  60:	ee040713          	addi	a4,s0,-288
  64:	3975                	addiw	s2,s2,-3
  66:	02091693          	slli	a3,s2,0x20
  6a:	01d6d913          	srli	s2,a3,0x1d
  6e:	993e                	add	s2,s2,a5
  70:	10048493          	addi	s1,s1,256
    fprintf(2,"%s: trace failed\n",argv[1]);
    exit(1);
    }
    for(i=2;i<argc && i<MAXARG; i++)
    {
      nargv[i-2]=argv[i];
  74:	6394                	ld	a3,0(a5)
  76:	e314                	sd	a3,0(a4)
    for(i=2;i<argc && i<MAXARG; i++)
  78:	01278663          	beq	a5,s2,84 <main+0x84>
  7c:	07a1                	addi	a5,a5,8
  7e:	0721                	addi	a4,a4,8
  80:	fe979ae3          	bne	a5,s1,74 <main+0x74>
      }
    exec(nargv[0],nargv);
  84:	ee040593          	addi	a1,s0,-288
  88:	ee043503          	ld	a0,-288(s0)
  8c:	00000097          	auipc	ra,0x0
  90:	2f6080e7          	jalr	758(ra) # 382 <exec>
  exit(0);
  94:	4501                	li	a0,0
  96:	00000097          	auipc	ra,0x0
  9a:	2b4080e7          	jalr	692(ra) # 34a <exit>
    fprintf(2,"%s: trace failed\n",argv[1]);
  9e:	6490                	ld	a2,8(s1)
  a0:	00000597          	auipc	a1,0x0
  a4:	7c858593          	addi	a1,a1,1992 # 868 <malloc+0xfe>
  a8:	4509                	li	a0,2
  aa:	00000097          	auipc	ra,0x0
  ae:	5da080e7          	jalr	1498(ra) # 684 <fprintf>
    exit(1);
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	296080e7          	jalr	662(ra) # 34a <exit>

00000000000000bc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	00000097          	auipc	ra,0x0
  c8:	f3c080e7          	jalr	-196(ra) # 0 <main>
  exit(0);
  cc:	4501                	li	a0,0
  ce:	00000097          	auipc	ra,0x0
  d2:	27c080e7          	jalr	636(ra) # 34a <exit>

00000000000000d6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  dc:	87aa                	mv	a5,a0
  de:	0585                	addi	a1,a1,1
  e0:	0785                	addi	a5,a5,1
  e2:	fff5c703          	lbu	a4,-1(a1)
  e6:	fee78fa3          	sb	a4,-1(a5)
  ea:	fb75                	bnez	a4,de <strcpy+0x8>
    ;
  return os;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb91                	beqz	a5,110 <strcmp+0x1e>
  fe:	0005c703          	lbu	a4,0(a1)
 102:	00f71763          	bne	a4,a5,110 <strcmp+0x1e>
    p++, q++;
 106:	0505                	addi	a0,a0,1
 108:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbe5                	bnez	a5,fe <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 110:	0005c503          	lbu	a0,0(a1)
}
 114:	40a7853b          	subw	a0,a5,a0
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x26>
 12a:	0505                	addi	a0,a0,1
 12c:	87aa                	mv	a5,a0
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x10>
 138:	40a6853b          	subw	a0,a3,a0
 13c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for(n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strlen+0x20>

0000000000000148 <memset>:

void*
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14e:	ca19                	beqz	a2,164 <memset+0x1c>
 150:	87aa                	mv	a5,a0
 152:	1602                	slli	a2,a2,0x20
 154:	9201                	srli	a2,a2,0x20
 156:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15e:	0785                	addi	a5,a5,1
 160:	fee79de3          	bne	a5,a4,15a <memset+0x12>
  }
  return dst;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strchr>:

char*
strchr(const char *s, char c)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb99                	beqz	a5,18a <strchr+0x20>
    if(*s == c)
 176:	00f58763          	beq	a1,a5,184 <strchr+0x1a>
  for(; *s; s++)
 17a:	0505                	addi	a0,a0,1
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbfd                	bnez	a5,176 <strchr+0xc>
      return (char*)s;
  return 0;
 182:	4501                	li	a0,0
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  return 0;
 18a:	4501                	li	a0,0
 18c:	bfe5                	j	184 <strchr+0x1a>

000000000000018e <gets>:

char*
gets(char *buf, int max)
{
 18e:	711d                	addi	sp,sp,-96
 190:	ec86                	sd	ra,88(sp)
 192:	e8a2                	sd	s0,80(sp)
 194:	e4a6                	sd	s1,72(sp)
 196:	e0ca                	sd	s2,64(sp)
 198:	fc4e                	sd	s3,56(sp)
 19a:	f852                	sd	s4,48(sp)
 19c:	f456                	sd	s5,40(sp)
 19e:	f05a                	sd	s6,32(sp)
 1a0:	ec5e                	sd	s7,24(sp)
 1a2:	1080                	addi	s0,sp,96
 1a4:	8baa                	mv	s7,a0
 1a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	892a                	mv	s2,a0
 1aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ac:	4aa9                	li	s5,10
 1ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b0:	89a6                	mv	s3,s1
 1b2:	2485                	addiw	s1,s1,1
 1b4:	0344d863          	bge	s1,s4,1e4 <gets+0x56>
    cc = read(0, &c, 1);
 1b8:	4605                	li	a2,1
 1ba:	faf40593          	addi	a1,s0,-81
 1be:	4501                	li	a0,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	1a2080e7          	jalr	418(ra) # 362 <read>
    if(cc < 1)
 1c8:	00a05e63          	blez	a0,1e4 <gets+0x56>
    buf[i++] = c;
 1cc:	faf44783          	lbu	a5,-81(s0)
 1d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d4:	01578763          	beq	a5,s5,1e2 <gets+0x54>
 1d8:	0905                	addi	s2,s2,1
 1da:	fd679be3          	bne	a5,s6,1b0 <gets+0x22>
  for(i=0; i+1 < max; ){
 1de:	89a6                	mv	s3,s1
 1e0:	a011                	j	1e4 <gets+0x56>
 1e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e4:	99de                	add	s3,s3,s7
 1e6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ea:	855e                	mv	a0,s7
 1ec:	60e6                	ld	ra,88(sp)
 1ee:	6446                	ld	s0,80(sp)
 1f0:	64a6                	ld	s1,72(sp)
 1f2:	6906                	ld	s2,64(sp)
 1f4:	79e2                	ld	s3,56(sp)
 1f6:	7a42                	ld	s4,48(sp)
 1f8:	7aa2                	ld	s5,40(sp)
 1fa:	7b02                	ld	s6,32(sp)
 1fc:	6be2                	ld	s7,24(sp)
 1fe:	6125                	addi	sp,sp,96
 200:	8082                	ret

0000000000000202 <stat>:

int
stat(const char *n, struct stat *st)
{
 202:	1101                	addi	sp,sp,-32
 204:	ec06                	sd	ra,24(sp)
 206:	e822                	sd	s0,16(sp)
 208:	e426                	sd	s1,8(sp)
 20a:	e04a                	sd	s2,0(sp)
 20c:	1000                	addi	s0,sp,32
 20e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	4581                	li	a1,0
 212:	00000097          	auipc	ra,0x0
 216:	178080e7          	jalr	376(ra) # 38a <open>
  if(fd < 0)
 21a:	02054563          	bltz	a0,244 <stat+0x42>
 21e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 220:	85ca                	mv	a1,s2
 222:	00000097          	auipc	ra,0x0
 226:	180080e7          	jalr	384(ra) # 3a2 <fstat>
 22a:	892a                	mv	s2,a0
  close(fd);
 22c:	8526                	mv	a0,s1
 22e:	00000097          	auipc	ra,0x0
 232:	144080e7          	jalr	324(ra) # 372 <close>
  return r;
}
 236:	854a                	mv	a0,s2
 238:	60e2                	ld	ra,24(sp)
 23a:	6442                	ld	s0,16(sp)
 23c:	64a2                	ld	s1,8(sp)
 23e:	6902                	ld	s2,0(sp)
 240:	6105                	addi	sp,sp,32
 242:	8082                	ret
    return -1;
 244:	597d                	li	s2,-1
 246:	bfc5                	j	236 <stat+0x34>

0000000000000248 <atoi>:

int
atoi(const char *s)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24e:	00054683          	lbu	a3,0(a0)
 252:	fd06879b          	addiw	a5,a3,-48
 256:	0ff7f793          	zext.b	a5,a5
 25a:	4625                	li	a2,9
 25c:	02f66863          	bltu	a2,a5,28c <atoi+0x44>
 260:	872a                	mv	a4,a0
  n = 0;
 262:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 264:	0705                	addi	a4,a4,1
 266:	0025179b          	slliw	a5,a0,0x2
 26a:	9fa9                	addw	a5,a5,a0
 26c:	0017979b          	slliw	a5,a5,0x1
 270:	9fb5                	addw	a5,a5,a3
 272:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 276:	00074683          	lbu	a3,0(a4)
 27a:	fd06879b          	addiw	a5,a3,-48
 27e:	0ff7f793          	zext.b	a5,a5
 282:	fef671e3          	bgeu	a2,a5,264 <atoi+0x1c>
  return n;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  n = 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <atoi+0x3e>

0000000000000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 296:	02b57463          	bgeu	a0,a1,2be <memmove+0x2e>
    while(n-- > 0)
 29a:	00c05f63          	blez	a2,2b8 <memmove+0x28>
 29e:	1602                	slli	a2,a2,0x20
 2a0:	9201                	srli	a2,a2,0x20
 2a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a8:	0585                	addi	a1,a1,1
 2aa:	0705                	addi	a4,a4,1
 2ac:	fff5c683          	lbu	a3,-1(a1)
 2b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
    dst += n;
 2be:	00c50733          	add	a4,a0,a2
    src += n;
 2c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c4:	fec05ae3          	blez	a2,2b8 <memmove+0x28>
 2c8:	fff6079b          	addiw	a5,a2,-1
 2cc:	1782                	slli	a5,a5,0x20
 2ce:	9381                	srli	a5,a5,0x20
 2d0:	fff7c793          	not	a5,a5
 2d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d6:	15fd                	addi	a1,a1,-1
 2d8:	177d                	addi	a4,a4,-1
 2da:	0005c683          	lbu	a3,0(a1)
 2de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e2:	fee79ae3          	bne	a5,a4,2d6 <memmove+0x46>
 2e6:	bfc9                	j	2b8 <memmove+0x28>

00000000000002e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ee:	ca05                	beqz	a2,31e <memcmp+0x36>
 2f0:	fff6069b          	addiw	a3,a2,-1
 2f4:	1682                	slli	a3,a3,0x20
 2f6:	9281                	srli	a3,a3,0x20
 2f8:	0685                	addi	a3,a3,1
 2fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2fc:	00054783          	lbu	a5,0(a0)
 300:	0005c703          	lbu	a4,0(a1)
 304:	00e79863          	bne	a5,a4,314 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 308:	0505                	addi	a0,a0,1
    p2++;
 30a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30c:	fed518e3          	bne	a0,a3,2fc <memcmp+0x14>
  }
  return 0;
 310:	4501                	li	a0,0
 312:	a019                	j	318 <memcmp+0x30>
      return *p1 - *p2;
 314:	40e7853b          	subw	a0,a5,a4
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  return 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <memcmp+0x30>

0000000000000322 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e406                	sd	ra,8(sp)
 326:	e022                	sd	s0,0(sp)
 328:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32a:	00000097          	auipc	ra,0x0
 32e:	f66080e7          	jalr	-154(ra) # 290 <memmove>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <trace>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global trace
trace:
 li a7, SYS_trace
 33a:	48d9                	li	a7,22
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fork>:
.global fork
fork:
 li a7, SYS_fork
 342:	4885                	li	a7,1
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <exit>:
.global exit
exit:
 li a7, SYS_exit
 34a:	4889                	li	a7,2
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <wait>:
.global wait
wait:
 li a7, SYS_wait
 352:	488d                	li	a7,3
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35a:	4891                	li	a7,4
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <read>:
.global read
read:
 li a7, SYS_read
 362:	4895                	li	a7,5
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <write>:
.global write
write:
 li a7, SYS_write
 36a:	48c1                	li	a7,16
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <close>:
.global close
close:
 li a7, SYS_close
 372:	48d5                	li	a7,21
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <kill>:
.global kill
kill:
 li a7, SYS_kill
 37a:	4899                	li	a7,6
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exec>:
.global exec
exec:
 li a7, SYS_exec
 382:	489d                	li	a7,7
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <open>:
.global open
open:
 li a7, SYS_open
 38a:	48bd                	li	a7,15
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 392:	48c5                	li	a7,17
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39a:	48c9                	li	a7,18
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a2:	48a1                	li	a7,8
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <link>:
.global link
link:
 li a7, SYS_link
 3aa:	48cd                	li	a7,19
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b2:	48d1                	li	a7,20
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ba:	48a5                	li	a7,9
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c2:	48a9                	li	a7,10
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ca:	48ad                	li	a7,11
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d2:	48b1                	li	a7,12
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48b5                	li	a7,13
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e2:	48b9                	li	a7,14
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	00000097          	auipc	ra,0x0
 400:	f6e080e7          	jalr	-146(ra) # 36a <write>
}
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f426                	sd	s1,40(sp)
 414:	f04a                	sd	s2,32(sp)
 416:	ec4e                	sd	s3,24(sp)
 418:	0080                	addi	s0,sp,64
 41a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41c:	c299                	beqz	a3,422 <printint+0x16>
 41e:	0805c963          	bltz	a1,4b0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 422:	2581                	sext.w	a1,a1
  neg = 0;
 424:	4881                	li	a7,0
 426:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42c:	2601                	sext.w	a2,a2
 42e:	00000517          	auipc	a0,0x0
 432:	4b250513          	addi	a0,a0,1202 # 8e0 <digits>
 436:	883a                	mv	a6,a4
 438:	2705                	addiw	a4,a4,1
 43a:	02c5f7bb          	remuw	a5,a1,a2
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	97aa                	add	a5,a5,a0
 444:	0007c783          	lbu	a5,0(a5)
 448:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44c:	0005879b          	sext.w	a5,a1
 450:	02c5d5bb          	divuw	a1,a1,a2
 454:	0685                	addi	a3,a3,1
 456:	fec7f0e3          	bgeu	a5,a2,436 <printint+0x2a>
  if(neg)
 45a:	00088c63          	beqz	a7,472 <printint+0x66>
    buf[i++] = '-';
 45e:	fd070793          	addi	a5,a4,-48
 462:	00878733          	add	a4,a5,s0
 466:	02d00793          	li	a5,45
 46a:	fef70823          	sb	a5,-16(a4)
 46e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 472:	02e05863          	blez	a4,4a2 <printint+0x96>
 476:	fc040793          	addi	a5,s0,-64
 47a:	00e78933          	add	s2,a5,a4
 47e:	fff78993          	addi	s3,a5,-1
 482:	99ba                	add	s3,s3,a4
 484:	377d                	addiw	a4,a4,-1
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	fff94583          	lbu	a1,-1(s2)
 492:	8526                	mv	a0,s1
 494:	00000097          	auipc	ra,0x0
 498:	f56080e7          	jalr	-170(ra) # 3ea <putc>
  while(--i >= 0)
 49c:	197d                	addi	s2,s2,-1
 49e:	ff3918e3          	bne	s2,s3,48e <printint+0x82>
}
 4a2:	70e2                	ld	ra,56(sp)
 4a4:	7442                	ld	s0,48(sp)
 4a6:	74a2                	ld	s1,40(sp)
 4a8:	7902                	ld	s2,32(sp)
 4aa:	69e2                	ld	s3,24(sp)
 4ac:	6121                	addi	sp,sp,64
 4ae:	8082                	ret
    x = -xx;
 4b0:	40b005bb          	negw	a1,a1
    neg = 1;
 4b4:	4885                	li	a7,1
    x = -xx;
 4b6:	bf85                	j	426 <printint+0x1a>

00000000000004b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b8:	715d                	addi	sp,sp,-80
 4ba:	e486                	sd	ra,72(sp)
 4bc:	e0a2                	sd	s0,64(sp)
 4be:	fc26                	sd	s1,56(sp)
 4c0:	f84a                	sd	s2,48(sp)
 4c2:	f44e                	sd	s3,40(sp)
 4c4:	f052                	sd	s4,32(sp)
 4c6:	ec56                	sd	s5,24(sp)
 4c8:	e85a                	sd	s6,16(sp)
 4ca:	e45e                	sd	s7,8(sp)
 4cc:	e062                	sd	s8,0(sp)
 4ce:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d0:	0005c903          	lbu	s2,0(a1)
 4d4:	18090c63          	beqz	s2,66c <vprintf+0x1b4>
 4d8:	8aaa                	mv	s5,a0
 4da:	8bb2                	mv	s7,a2
 4dc:	00158493          	addi	s1,a1,1
  state = 0;
 4e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e2:	02500a13          	li	s4,37
 4e6:	4b55                	li	s6,21
 4e8:	a839                	j	506 <vprintf+0x4e>
        putc(fd, c);
 4ea:	85ca                	mv	a1,s2
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	efc080e7          	jalr	-260(ra) # 3ea <putc>
 4f6:	a019                	j	4fc <vprintf+0x44>
    } else if(state == '%'){
 4f8:	01498d63          	beq	s3,s4,512 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4fc:	0485                	addi	s1,s1,1
 4fe:	fff4c903          	lbu	s2,-1(s1)
 502:	16090563          	beqz	s2,66c <vprintf+0x1b4>
    if(state == 0){
 506:	fe0999e3          	bnez	s3,4f8 <vprintf+0x40>
      if(c == '%'){
 50a:	ff4910e3          	bne	s2,s4,4ea <vprintf+0x32>
        state = '%';
 50e:	89d2                	mv	s3,s4
 510:	b7f5                	j	4fc <vprintf+0x44>
      if(c == 'd'){
 512:	13490263          	beq	s2,s4,636 <vprintf+0x17e>
 516:	f9d9079b          	addiw	a5,s2,-99
 51a:	0ff7f793          	zext.b	a5,a5
 51e:	12fb6563          	bltu	s6,a5,648 <vprintf+0x190>
 522:	f9d9079b          	addiw	a5,s2,-99
 526:	0ff7f713          	zext.b	a4,a5
 52a:	10eb6f63          	bltu	s6,a4,648 <vprintf+0x190>
 52e:	00271793          	slli	a5,a4,0x2
 532:	00000717          	auipc	a4,0x0
 536:	35670713          	addi	a4,a4,854 # 888 <malloc+0x11e>
 53a:	97ba                	add	a5,a5,a4
 53c:	439c                	lw	a5,0(a5)
 53e:	97ba                	add	a5,a5,a4
 540:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 542:	008b8913          	addi	s2,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000ba583          	lw	a1,0(s7)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	ebc080e7          	jalr	-324(ra) # 40c <printint>
 558:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b745                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55e:	008b8913          	addi	s2,s7,8
 562:	4681                	li	a3,0
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ea0080e7          	jalr	-352(ra) # 40c <printint>
 574:	8bca                	mv	s7,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	b751                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 57a:	008b8913          	addi	s2,s7,8
 57e:	4681                	li	a3,0
 580:	4641                	li	a2,16
 582:	000ba583          	lw	a1,0(s7)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e84080e7          	jalr	-380(ra) # 40c <printint>
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
 594:	b7a5                	j	4fc <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 596:	008b8c13          	addi	s8,s7,8
 59a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 59e:	03000593          	li	a1,48
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e46080e7          	jalr	-442(ra) # 3ea <putc>
  putc(fd, 'x');
 5ac:	07800593          	li	a1,120
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e38080e7          	jalr	-456(ra) # 3ea <putc>
 5ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5bc:	00000b97          	auipc	s7,0x0
 5c0:	324b8b93          	addi	s7,s7,804 # 8e0 <digits>
 5c4:	03c9d793          	srli	a5,s3,0x3c
 5c8:	97de                	add	a5,a5,s7
 5ca:	0007c583          	lbu	a1,0(a5)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e1a080e7          	jalr	-486(ra) # 3ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d8:	0992                	slli	s3,s3,0x4
 5da:	397d                	addiw	s2,s2,-1
 5dc:	fe0914e3          	bnez	s2,5c4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5e0:	8be2                	mv	s7,s8
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bf21                	j	4fc <vprintf+0x44>
        s = va_arg(ap, char*);
 5e6:	008b8993          	addi	s3,s7,8
 5ea:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ee:	02090163          	beqz	s2,610 <vprintf+0x158>
        while(*s != 0){
 5f2:	00094583          	lbu	a1,0(s2)
 5f6:	c9a5                	beqz	a1,666 <vprintf+0x1ae>
          putc(fd, *s);
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	df0080e7          	jalr	-528(ra) # 3ea <putc>
          s++;
 602:	0905                	addi	s2,s2,1
        while(*s != 0){
 604:	00094583          	lbu	a1,0(s2)
 608:	f9e5                	bnez	a1,5f8 <vprintf+0x140>
        s = va_arg(ap, char*);
 60a:	8bce                	mv	s7,s3
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b5fd                	j	4fc <vprintf+0x44>
          s = "(null)";
 610:	00000917          	auipc	s2,0x0
 614:	27090913          	addi	s2,s2,624 # 880 <malloc+0x116>
        while(*s != 0){
 618:	02800593          	li	a1,40
 61c:	bff1                	j	5f8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 61e:	008b8913          	addi	s2,s7,8
 622:	000bc583          	lbu	a1,0(s7)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	dc2080e7          	jalr	-574(ra) # 3ea <putc>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b5e1                	j	4fc <vprintf+0x44>
        putc(fd, c);
 636:	02500593          	li	a1,37
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	dae080e7          	jalr	-594(ra) # 3ea <putc>
      state = 0;
 644:	4981                	li	s3,0
 646:	bd5d                	j	4fc <vprintf+0x44>
        putc(fd, '%');
 648:	02500593          	li	a1,37
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	d9c080e7          	jalr	-612(ra) # 3ea <putc>
        putc(fd, c);
 656:	85ca                	mv	a1,s2
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d90080e7          	jalr	-624(ra) # 3ea <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	bd61                	j	4fc <vprintf+0x44>
        s = va_arg(ap, char*);
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	bd49                	j	4fc <vprintf+0x44>
    }
  }
}
 66c:	60a6                	ld	ra,72(sp)
 66e:	6406                	ld	s0,64(sp)
 670:	74e2                	ld	s1,56(sp)
 672:	7942                	ld	s2,48(sp)
 674:	79a2                	ld	s3,40(sp)
 676:	7a02                	ld	s4,32(sp)
 678:	6ae2                	ld	s5,24(sp)
 67a:	6b42                	ld	s6,16(sp)
 67c:	6ba2                	ld	s7,8(sp)
 67e:	6c02                	ld	s8,0(sp)
 680:	6161                	addi	sp,sp,80
 682:	8082                	ret

0000000000000684 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 684:	715d                	addi	sp,sp,-80
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	e010                	sd	a2,0(s0)
 68e:	e414                	sd	a3,8(s0)
 690:	e818                	sd	a4,16(s0)
 692:	ec1c                	sd	a5,24(s0)
 694:	03043023          	sd	a6,32(s0)
 698:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a0:	8622                	mv	a2,s0
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e16080e7          	jalr	-490(ra) # 4b8 <vprintf>
}
 6aa:	60e2                	ld	ra,24(sp)
 6ac:	6442                	ld	s0,16(sp)
 6ae:	6161                	addi	sp,sp,80
 6b0:	8082                	ret

00000000000006b2 <printf>:

void
printf(const char *fmt, ...)
{
 6b2:	711d                	addi	sp,sp,-96
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	addi	s0,sp,32
 6ba:	e40c                	sd	a1,8(s0)
 6bc:	e810                	sd	a2,16(s0)
 6be:	ec14                	sd	a3,24(s0)
 6c0:	f018                	sd	a4,32(s0)
 6c2:	f41c                	sd	a5,40(s0)
 6c4:	03043823          	sd	a6,48(s0)
 6c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6cc:	00840613          	addi	a2,s0,8
 6d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d4:	85aa                	mv	a1,a0
 6d6:	4505                	li	a0,1
 6d8:	00000097          	auipc	ra,0x0
 6dc:	de0080e7          	jalr	-544(ra) # 4b8 <vprintf>
}
 6e0:	60e2                	ld	ra,24(sp)
 6e2:	6442                	ld	s0,16(sp)
 6e4:	6125                	addi	sp,sp,96
 6e6:	8082                	ret

00000000000006e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e8:	1141                	addi	sp,sp,-16
 6ea:	e422                	sd	s0,8(sp)
 6ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	00001797          	auipc	a5,0x1
 6f6:	90e7b783          	ld	a5,-1778(a5) # 1000 <freep>
 6fa:	a02d                	j	724 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fc:	4618                	lw	a4,8(a2)
 6fe:	9f2d                	addw	a4,a4,a1
 700:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	6398                	ld	a4,0(a5)
 706:	6310                	ld	a2,0(a4)
 708:	a83d                	j	746 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70a:	ff852703          	lw	a4,-8(a0)
 70e:	9f31                	addw	a4,a4,a2
 710:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 712:	ff053683          	ld	a3,-16(a0)
 716:	a091                	j	75a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	6398                	ld	a4,0(a5)
 71a:	00e7e463          	bltu	a5,a4,722 <free+0x3a>
 71e:	00e6ea63          	bltu	a3,a4,732 <free+0x4a>
{
 722:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	fed7fae3          	bgeu	a5,a3,718 <free+0x30>
 728:	6398                	ld	a4,0(a5)
 72a:	00e6e463          	bltu	a3,a4,732 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	fee7eae3          	bltu	a5,a4,722 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 732:	ff852583          	lw	a1,-8(a0)
 736:	6390                	ld	a2,0(a5)
 738:	02059813          	slli	a6,a1,0x20
 73c:	01c85713          	srli	a4,a6,0x1c
 740:	9736                	add	a4,a4,a3
 742:	fae60de3          	beq	a2,a4,6fc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74a:	4790                	lw	a2,8(a5)
 74c:	02061593          	slli	a1,a2,0x20
 750:	01c5d713          	srli	a4,a1,0x1c
 754:	973e                	add	a4,a4,a5
 756:	fae68ae3          	beq	a3,a4,70a <free+0x22>
    p->s.ptr = bp->s.ptr;
 75a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 75c:	00001717          	auipc	a4,0x1
 760:	8af73223          	sd	a5,-1884(a4) # 1000 <freep>
}
 764:	6422                	ld	s0,8(sp)
 766:	0141                	addi	sp,sp,16
 768:	8082                	ret

000000000000076a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76a:	7139                	addi	sp,sp,-64
 76c:	fc06                	sd	ra,56(sp)
 76e:	f822                	sd	s0,48(sp)
 770:	f426                	sd	s1,40(sp)
 772:	f04a                	sd	s2,32(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	e852                	sd	s4,16(sp)
 778:	e456                	sd	s5,8(sp)
 77a:	e05a                	sd	s6,0(sp)
 77c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	02051493          	slli	s1,a0,0x20
 782:	9081                	srli	s1,s1,0x20
 784:	04bd                	addi	s1,s1,15
 786:	8091                	srli	s1,s1,0x4
 788:	0014899b          	addiw	s3,s1,1
 78c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 78e:	00001517          	auipc	a0,0x1
 792:	87253503          	ld	a0,-1934(a0) # 1000 <freep>
 796:	c515                	beqz	a0,7c2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79a:	4798                	lw	a4,8(a5)
 79c:	02977f63          	bgeu	a4,s1,7da <malloc+0x70>
  if(nu < 4096)
 7a0:	8a4e                	mv	s4,s3
 7a2:	0009871b          	sext.w	a4,s3
 7a6:	6685                	lui	a3,0x1
 7a8:	00d77363          	bgeu	a4,a3,7ae <malloc+0x44>
 7ac:	6a05                	lui	s4,0x1
 7ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b6:	00001917          	auipc	s2,0x1
 7ba:	84a90913          	addi	s2,s2,-1974 # 1000 <freep>
  if(p == (char*)-1)
 7be:	5afd                	li	s5,-1
 7c0:	a895                	j	834 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7c2:	00001797          	auipc	a5,0x1
 7c6:	84e78793          	addi	a5,a5,-1970 # 1010 <base>
 7ca:	00001717          	auipc	a4,0x1
 7ce:	82f73b23          	sd	a5,-1994(a4) # 1000 <freep>
 7d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d8:	b7e1                	j	7a0 <malloc+0x36>
      if(p->s.size == nunits)
 7da:	02e48c63          	beq	s1,a4,812 <malloc+0xa8>
        p->s.size -= nunits;
 7de:	4137073b          	subw	a4,a4,s3
 7e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e4:	02071693          	slli	a3,a4,0x20
 7e8:	01c6d713          	srli	a4,a3,0x1c
 7ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f2:	00001717          	auipc	a4,0x1
 7f6:	80a73723          	sd	a0,-2034(a4) # 1000 <freep>
      return (void*)(p + 1);
 7fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7fe:	70e2                	ld	ra,56(sp)
 800:	7442                	ld	s0,48(sp)
 802:	74a2                	ld	s1,40(sp)
 804:	7902                	ld	s2,32(sp)
 806:	69e2                	ld	s3,24(sp)
 808:	6a42                	ld	s4,16(sp)
 80a:	6aa2                	ld	s5,8(sp)
 80c:	6b02                	ld	s6,0(sp)
 80e:	6121                	addi	sp,sp,64
 810:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 812:	6398                	ld	a4,0(a5)
 814:	e118                	sd	a4,0(a0)
 816:	bff1                	j	7f2 <malloc+0x88>
  hp->s.size = nu;
 818:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81c:	0541                	addi	a0,a0,16
 81e:	00000097          	auipc	ra,0x0
 822:	eca080e7          	jalr	-310(ra) # 6e8 <free>
  return freep;
 826:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 82a:	d971                	beqz	a0,7fe <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82e:	4798                	lw	a4,8(a5)
 830:	fa9775e3          	bgeu	a4,s1,7da <malloc+0x70>
    if(p == freep)
 834:	00093703          	ld	a4,0(s2)
 838:	853e                	mv	a0,a5
 83a:	fef719e3          	bne	a4,a5,82c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 83e:	8552                	mv	a0,s4
 840:	00000097          	auipc	ra,0x0
 844:	b92080e7          	jalr	-1134(ra) # 3d2 <sbrk>
  if(p == (char*)-1)
 848:	fd5518e3          	bne	a0,s5,818 <malloc+0xae>
        return 0;
 84c:	4501                	li	a0,0
 84e:	bf45                	j	7fe <malloc+0x94>
