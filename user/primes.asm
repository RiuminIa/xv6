
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <rura>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void rura(int left[2]){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
   e:	892a                	mv	s2,a0
 // printf("3\n");
  int right[2];
  int pid;

  int prvcislo=0;
  pipe(right);
  10:	fc840513          	addi	a0,s0,-56
  14:	00000097          	auipc	ra,0x0
  18:	3cc080e7          	jalr	972(ra) # 3e0 <pipe>
  int prvcislo=0;
  1c:	4481                	li	s1,0
 // printf("4\n");
    while(read(left[0],&z,4)>0){
    //  printf("6\n");
      if (prvcislo==0){
       // printf("7\n");
        printf("prime %d\n",z);
  1e:	00001997          	auipc	s3,0x1
  22:	8c298993          	addi	s3,s3,-1854 # 8e0 <malloc+0xf0>
    while(read(left[0],&z,4)>0){
  26:	a811                	j	3a <rura+0x3a>
        printf("prime %d\n",z);
  28:	fc442583          	lw	a1,-60(s0)
  2c:	854e                	mv	a0,s3
  2e:	00000097          	auipc	ra,0x0
  32:	70a080e7          	jalr	1802(ra) # 738 <printf>
        prvcislo=z;
  36:	fc442483          	lw	s1,-60(s0)
    while(read(left[0],&z,4)>0){
  3a:	4611                	li	a2,4
  3c:	fc440593          	addi	a1,s0,-60
  40:	00092503          	lw	a0,0(s2)
  44:	00000097          	auipc	ra,0x0
  48:	3a4080e7          	jalr	932(ra) # 3e8 <read>
  4c:	02a05263          	blez	a0,70 <rura+0x70>
      if (prvcislo==0){
  50:	dce1                	beqz	s1,28 <rura+0x28>
       // printf("8\n");
      }
      else if (z%prvcislo!=0) {
  52:	fc442783          	lw	a5,-60(s0)
  56:	0297e7bb          	remw	a5,a5,s1
  5a:	d3e5                	beqz	a5,3a <rura+0x3a>
        write(right[1],&z,4);
  5c:	4611                	li	a2,4
  5e:	fc440593          	addi	a1,s0,-60
  62:	fcc42503          	lw	a0,-52(s0)
  66:	00000097          	auipc	ra,0x0
  6a:	38a080e7          	jalr	906(ra) # 3f0 <write>
  6e:	b7f1                	j	3a <rura+0x3a>
      }
    }
    close(right[1]);
  70:	fcc42503          	lw	a0,-52(s0)
  74:	00000097          	auipc	ra,0x0
  78:	384080e7          	jalr	900(ra) # 3f8 <close>
    if (prvcislo!=0){
  7c:	e881                	bnez	s1,8c <rura+0x8c>
    }
  close(right[1]);
  wait(0);
  close(0);
}
}
  7e:	70e2                	ld	ra,56(sp)
  80:	7442                	ld	s0,48(sp)
  82:	74a2                	ld	s1,40(sp)
  84:	7902                	ld	s2,32(sp)
  86:	69e2                	ld	s3,24(sp)
  88:	6121                	addi	sp,sp,64
  8a:	8082                	ret
      pid=fork();
  8c:	00000097          	auipc	ra,0x0
  90:	33c080e7          	jalr	828(ra) # 3c8 <fork>
        if(pid==0){
  94:	c115                	beqz	a0,b8 <rura+0xb8>
  close(right[1]);
  96:	fcc42503          	lw	a0,-52(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	35e080e7          	jalr	862(ra) # 3f8 <close>
  wait(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	334080e7          	jalr	820(ra) # 3d8 <wait>
  close(0);
  ac:	4501                	li	a0,0
  ae:	00000097          	auipc	ra,0x0
  b2:	34a080e7          	jalr	842(ra) # 3f8 <close>
}
  b6:	b7e1                	j	7e <rura+0x7e>
          rura(right);
  b8:	fc840513          	addi	a0,s0,-56
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <rura>
  c4:	bfc9                	j	96 <rura+0x96>

00000000000000c6 <main>:
int
main(int argc, char *argv[])
{
  c6:	7179                	addi	sp,sp,-48
  c8:	f406                	sd	ra,40(sp)
  ca:	f022                	sd	s0,32(sp)
  cc:	ec26                	sd	s1,24(sp)
  ce:	1800                	addi	s0,sp,48
  int ping[2];
  pipe(ping);
  d0:	fd840513          	addi	a0,s0,-40
  d4:	00000097          	auipc	ra,0x0
  d8:	30c080e7          	jalr	780(ra) # 3e0 <pipe>
  int pid;
  for(int i=2;i<35;i++){
  dc:	4789                	li	a5,2
  de:	fcf42a23          	sw	a5,-44(s0)
  e2:	02200493          	li	s1,34
    write(ping[1],&i,4);
  e6:	4611                	li	a2,4
  e8:	fd440593          	addi	a1,s0,-44
  ec:	fdc42503          	lw	a0,-36(s0)
  f0:	00000097          	auipc	ra,0x0
  f4:	300080e7          	jalr	768(ra) # 3f0 <write>
  for(int i=2;i<35;i++){
  f8:	fd442783          	lw	a5,-44(s0)
  fc:	2785                	addiw	a5,a5,1
  fe:	0007871b          	sext.w	a4,a5
 102:	fcf42a23          	sw	a5,-44(s0)
 106:	fee4d0e3          	bge	s1,a4,e6 <main+0x20>
  }
  //close(ping[0]);
  close(ping[1]);
 10a:	fdc42503          	lw	a0,-36(s0)
 10e:	00000097          	auipc	ra,0x0
 112:	2ea080e7          	jalr	746(ra) # 3f8 <close>
  pid=fork();
 116:	00000097          	auipc	ra,0x0
 11a:	2b2080e7          	jalr	690(ra) # 3c8 <fork>
  if(pid==0){
 11e:	c919                	beqz	a0,134 <main+0x6e>
    rura(ping); 
  }
wait(0);
 120:	4501                	li	a0,0
 122:	00000097          	auipc	ra,0x0
 126:	2b6080e7          	jalr	694(ra) # 3d8 <wait>
//printf("2\n");
exit(0);
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	2a4080e7          	jalr	676(ra) # 3d0 <exit>
    rura(ping); 
 134:	fd840513          	addi	a0,s0,-40
 138:	00000097          	auipc	ra,0x0
 13c:	ec8080e7          	jalr	-312(ra) # 0 <rura>
 140:	b7c5                	j	120 <main+0x5a>

0000000000000142 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 142:	1141                	addi	sp,sp,-16
 144:	e406                	sd	ra,8(sp)
 146:	e022                	sd	s0,0(sp)
 148:	0800                	addi	s0,sp,16
  extern int main();
  main();
 14a:	00000097          	auipc	ra,0x0
 14e:	f7c080e7          	jalr	-132(ra) # c6 <main>
  exit(0);
 152:	4501                	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	27c080e7          	jalr	636(ra) # 3d0 <exit>

000000000000015c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 162:	87aa                	mv	a5,a0
 164:	0585                	addi	a1,a1,1
 166:	0785                	addi	a5,a5,1
 168:	fff5c703          	lbu	a4,-1(a1)
 16c:	fee78fa3          	sb	a4,-1(a5)
 170:	fb75                	bnez	a4,164 <strcpy+0x8>
    ;
  return os;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb91                	beqz	a5,196 <strcmp+0x1e>
 184:	0005c703          	lbu	a4,0(a1)
 188:	00f71763          	bne	a4,a5,196 <strcmp+0x1e>
    p++, q++;
 18c:	0505                	addi	a0,a0,1
 18e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	fbe5                	bnez	a5,184 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 196:	0005c503          	lbu	a0,0(a1)
}
 19a:	40a7853b          	subw	a0,a5,a0
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strlen>:

uint
strlen(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf91                	beqz	a5,1ca <strlen+0x26>
 1b0:	0505                	addi	a0,a0,1
 1b2:	87aa                	mv	a5,a0
 1b4:	86be                	mv	a3,a5
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff7c703          	lbu	a4,-1(a5)
 1bc:	ff65                	bnez	a4,1b4 <strlen+0x10>
 1be:	40a6853b          	subw	a0,a3,a0
 1c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  for(n = 0; s[n]; n++)
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strlen+0x20>

00000000000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d4:	ca19                	beqz	a2,1ea <memset+0x1c>
 1d6:	87aa                	mv	a5,a0
 1d8:	1602                	slli	a2,a2,0x20
 1da:	9201                	srli	a2,a2,0x20
 1dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e4:	0785                	addi	a5,a5,1
 1e6:	fee79de3          	bne	a5,a4,1e0 <memset+0x12>
  }
  return dst;
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cb99                	beqz	a5,210 <strchr+0x20>
    if(*s == c)
 1fc:	00f58763          	beq	a1,a5,20a <strchr+0x1a>
  for(; *s; s++)
 200:	0505                	addi	a0,a0,1
 202:	00054783          	lbu	a5,0(a0)
 206:	fbfd                	bnez	a5,1fc <strchr+0xc>
      return (char*)s;
  return 0;
 208:	4501                	li	a0,0
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  return 0;
 210:	4501                	li	a0,0
 212:	bfe5                	j	20a <strchr+0x1a>

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	711d                	addi	sp,sp,-96
 216:	ec86                	sd	ra,88(sp)
 218:	e8a2                	sd	s0,80(sp)
 21a:	e4a6                	sd	s1,72(sp)
 21c:	e0ca                	sd	s2,64(sp)
 21e:	fc4e                	sd	s3,56(sp)
 220:	f852                	sd	s4,48(sp)
 222:	f456                	sd	s5,40(sp)
 224:	f05a                	sd	s6,32(sp)
 226:	ec5e                	sd	s7,24(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 232:	4aa9                	li	s5,10
 234:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 236:	89a6                	mv	s3,s1
 238:	2485                	addiw	s1,s1,1
 23a:	0344d863          	bge	s1,s4,26a <gets+0x56>
    cc = read(0, &c, 1);
 23e:	4605                	li	a2,1
 240:	faf40593          	addi	a1,s0,-81
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	1a2080e7          	jalr	418(ra) # 3e8 <read>
    if(cc < 1)
 24e:	00a05e63          	blez	a0,26a <gets+0x56>
    buf[i++] = c;
 252:	faf44783          	lbu	a5,-81(s0)
 256:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25a:	01578763          	beq	a5,s5,268 <gets+0x54>
 25e:	0905                	addi	s2,s2,1
 260:	fd679be3          	bne	a5,s6,236 <gets+0x22>
  for(i=0; i+1 < max; ){
 264:	89a6                	mv	s3,s1
 266:	a011                	j	26a <gets+0x56>
 268:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26a:	99de                	add	s3,s3,s7
 26c:	00098023          	sb	zero,0(s3)
  return buf;
}
 270:	855e                	mv	a0,s7
 272:	60e6                	ld	ra,88(sp)
 274:	6446                	ld	s0,80(sp)
 276:	64a6                	ld	s1,72(sp)
 278:	6906                	ld	s2,64(sp)
 27a:	79e2                	ld	s3,56(sp)
 27c:	7a42                	ld	s4,48(sp)
 27e:	7aa2                	ld	s5,40(sp)
 280:	7b02                	ld	s6,32(sp)
 282:	6be2                	ld	s7,24(sp)
 284:	6125                	addi	sp,sp,96
 286:	8082                	ret

0000000000000288 <stat>:

int
stat(const char *n, struct stat *st)
{
 288:	1101                	addi	sp,sp,-32
 28a:	ec06                	sd	ra,24(sp)
 28c:	e822                	sd	s0,16(sp)
 28e:	e426                	sd	s1,8(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
 294:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	4581                	li	a1,0
 298:	00000097          	auipc	ra,0x0
 29c:	178080e7          	jalr	376(ra) # 410 <open>
  if(fd < 0)
 2a0:	02054563          	bltz	a0,2ca <stat+0x42>
 2a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a6:	85ca                	mv	a1,s2
 2a8:	00000097          	auipc	ra,0x0
 2ac:	180080e7          	jalr	384(ra) # 428 <fstat>
 2b0:	892a                	mv	s2,a0
  close(fd);
 2b2:	8526                	mv	a0,s1
 2b4:	00000097          	auipc	ra,0x0
 2b8:	144080e7          	jalr	324(ra) # 3f8 <close>
  return r;
}
 2bc:	854a                	mv	a0,s2
 2be:	60e2                	ld	ra,24(sp)
 2c0:	6442                	ld	s0,16(sp)
 2c2:	64a2                	ld	s1,8(sp)
 2c4:	6902                	ld	s2,0(sp)
 2c6:	6105                	addi	sp,sp,32
 2c8:	8082                	ret
    return -1;
 2ca:	597d                	li	s2,-1
 2cc:	bfc5                	j	2bc <stat+0x34>

00000000000002ce <atoi>:

int
atoi(const char *s)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d4:	00054683          	lbu	a3,0(a0)
 2d8:	fd06879b          	addiw	a5,a3,-48
 2dc:	0ff7f793          	zext.b	a5,a5
 2e0:	4625                	li	a2,9
 2e2:	02f66863          	bltu	a2,a5,312 <atoi+0x44>
 2e6:	872a                	mv	a4,a0
  n = 0;
 2e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ea:	0705                	addi	a4,a4,1
 2ec:	0025179b          	slliw	a5,a0,0x2
 2f0:	9fa9                	addw	a5,a5,a0
 2f2:	0017979b          	slliw	a5,a5,0x1
 2f6:	9fb5                	addw	a5,a5,a3
 2f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fc:	00074683          	lbu	a3,0(a4)
 300:	fd06879b          	addiw	a5,a3,-48
 304:	0ff7f793          	zext.b	a5,a5
 308:	fef671e3          	bgeu	a2,a5,2ea <atoi+0x1c>
  return n;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
  n = 0;
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <atoi+0x3e>

0000000000000316 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31c:	02b57463          	bgeu	a0,a1,344 <memmove+0x2e>
    while(n-- > 0)
 320:	00c05f63          	blez	a2,33e <memmove+0x28>
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32c:	872a                	mv	a4,a0
      *dst++ = *src++;
 32e:	0585                	addi	a1,a1,1
 330:	0705                	addi	a4,a4,1
 332:	fff5c683          	lbu	a3,-1(a1)
 336:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33a:	fee79ae3          	bne	a5,a4,32e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
    dst += n;
 344:	00c50733          	add	a4,a0,a2
    src += n;
 348:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34a:	fec05ae3          	blez	a2,33e <memmove+0x28>
 34e:	fff6079b          	addiw	a5,a2,-1
 352:	1782                	slli	a5,a5,0x20
 354:	9381                	srli	a5,a5,0x20
 356:	fff7c793          	not	a5,a5
 35a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35c:	15fd                	addi	a1,a1,-1
 35e:	177d                	addi	a4,a4,-1
 360:	0005c683          	lbu	a3,0(a1)
 364:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 368:	fee79ae3          	bne	a5,a4,35c <memmove+0x46>
 36c:	bfc9                	j	33e <memmove+0x28>

000000000000036e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 374:	ca05                	beqz	a2,3a4 <memcmp+0x36>
 376:	fff6069b          	addiw	a3,a2,-1
 37a:	1682                	slli	a3,a3,0x20
 37c:	9281                	srli	a3,a3,0x20
 37e:	0685                	addi	a3,a3,1
 380:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 382:	00054783          	lbu	a5,0(a0)
 386:	0005c703          	lbu	a4,0(a1)
 38a:	00e79863          	bne	a5,a4,39a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 38e:	0505                	addi	a0,a0,1
    p2++;
 390:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 392:	fed518e3          	bne	a0,a3,382 <memcmp+0x14>
  }
  return 0;
 396:	4501                	li	a0,0
 398:	a019                	j	39e <memcmp+0x30>
      return *p1 - *p2;
 39a:	40e7853b          	subw	a0,a5,a4
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	bfe5                	j	39e <memcmp+0x30>

00000000000003a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e406                	sd	ra,8(sp)
 3ac:	e022                	sd	s0,0(sp)
 3ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b0:	00000097          	auipc	ra,0x0
 3b4:	f66080e7          	jalr	-154(ra) # 316 <memmove>
}
 3b8:	60a2                	ld	ra,8(sp)
 3ba:	6402                	ld	s0,0(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <trace>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global trace
trace:
 li a7, SYS_trace
 3c0:	48d9                	li	a7,22
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <fork>:
.global fork
fork:
 li a7, SYS_fork
 3c8:	4885                	li	a7,1
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d0:	4889                	li	a7,2
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d8:	488d                	li	a7,3
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e0:	4891                	li	a7,4
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <read>:
.global read
read:
 li a7, SYS_read
 3e8:	4895                	li	a7,5
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <write>:
.global write
write:
 li a7, SYS_write
 3f0:	48c1                	li	a7,16
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <close>:
.global close
close:
 li a7, SYS_close
 3f8:	48d5                	li	a7,21
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <kill>:
.global kill
kill:
 li a7, SYS_kill
 400:	4899                	li	a7,6
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <exec>:
.global exec
exec:
 li a7, SYS_exec
 408:	489d                	li	a7,7
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <open>:
.global open
open:
 li a7, SYS_open
 410:	48bd                	li	a7,15
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 418:	48c5                	li	a7,17
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 420:	48c9                	li	a7,18
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 428:	48a1                	li	a7,8
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <link>:
.global link
link:
 li a7, SYS_link
 430:	48cd                	li	a7,19
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 438:	48d1                	li	a7,20
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 440:	48a5                	li	a7,9
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <dup>:
.global dup
dup:
 li a7, SYS_dup
 448:	48a9                	li	a7,10
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 450:	48ad                	li	a7,11
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 458:	48b1                	li	a7,12
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 460:	48b5                	li	a7,13
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 468:	48b9                	li	a7,14
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	1000                	addi	s0,sp,32
 478:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47c:	4605                	li	a2,1
 47e:	fef40593          	addi	a1,s0,-17
 482:	00000097          	auipc	ra,0x0
 486:	f6e080e7          	jalr	-146(ra) # 3f0 <write>
}
 48a:	60e2                	ld	ra,24(sp)
 48c:	6442                	ld	s0,16(sp)
 48e:	6105                	addi	sp,sp,32
 490:	8082                	ret

0000000000000492 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 492:	7139                	addi	sp,sp,-64
 494:	fc06                	sd	ra,56(sp)
 496:	f822                	sd	s0,48(sp)
 498:	f426                	sd	s1,40(sp)
 49a:	f04a                	sd	s2,32(sp)
 49c:	ec4e                	sd	s3,24(sp)
 49e:	0080                	addi	s0,sp,64
 4a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a2:	c299                	beqz	a3,4a8 <printint+0x16>
 4a4:	0805c963          	bltz	a1,536 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a8:	2581                	sext.w	a1,a1
  neg = 0;
 4aa:	4881                	li	a7,0
 4ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b2:	2601                	sext.w	a2,a2
 4b4:	00000517          	auipc	a0,0x0
 4b8:	49c50513          	addi	a0,a0,1180 # 950 <digits>
 4bc:	883a                	mv	a6,a4
 4be:	2705                	addiw	a4,a4,1
 4c0:	02c5f7bb          	remuw	a5,a1,a2
 4c4:	1782                	slli	a5,a5,0x20
 4c6:	9381                	srli	a5,a5,0x20
 4c8:	97aa                	add	a5,a5,a0
 4ca:	0007c783          	lbu	a5,0(a5)
 4ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d2:	0005879b          	sext.w	a5,a1
 4d6:	02c5d5bb          	divuw	a1,a1,a2
 4da:	0685                	addi	a3,a3,1
 4dc:	fec7f0e3          	bgeu	a5,a2,4bc <printint+0x2a>
  if(neg)
 4e0:	00088c63          	beqz	a7,4f8 <printint+0x66>
    buf[i++] = '-';
 4e4:	fd070793          	addi	a5,a4,-48
 4e8:	00878733          	add	a4,a5,s0
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05863          	blez	a4,528 <printint+0x96>
 4fc:	fc040793          	addi	a5,s0,-64
 500:	00e78933          	add	s2,a5,a4
 504:	fff78993          	addi	s3,a5,-1
 508:	99ba                	add	s3,s3,a4
 50a:	377d                	addiw	a4,a4,-1
 50c:	1702                	slli	a4,a4,0x20
 50e:	9301                	srli	a4,a4,0x20
 510:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 514:	fff94583          	lbu	a1,-1(s2)
 518:	8526                	mv	a0,s1
 51a:	00000097          	auipc	ra,0x0
 51e:	f56080e7          	jalr	-170(ra) # 470 <putc>
  while(--i >= 0)
 522:	197d                	addi	s2,s2,-1
 524:	ff3918e3          	bne	s2,s3,514 <printint+0x82>
}
 528:	70e2                	ld	ra,56(sp)
 52a:	7442                	ld	s0,48(sp)
 52c:	74a2                	ld	s1,40(sp)
 52e:	7902                	ld	s2,32(sp)
 530:	69e2                	ld	s3,24(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret
    x = -xx;
 536:	40b005bb          	negw	a1,a1
    neg = 1;
 53a:	4885                	li	a7,1
    x = -xx;
 53c:	bf85                	j	4ac <printint+0x1a>

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	715d                	addi	sp,sp,-80
 540:	e486                	sd	ra,72(sp)
 542:	e0a2                	sd	s0,64(sp)
 544:	fc26                	sd	s1,56(sp)
 546:	f84a                	sd	s2,48(sp)
 548:	f44e                	sd	s3,40(sp)
 54a:	f052                	sd	s4,32(sp)
 54c:	ec56                	sd	s5,24(sp)
 54e:	e85a                	sd	s6,16(sp)
 550:	e45e                	sd	s7,8(sp)
 552:	e062                	sd	s8,0(sp)
 554:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 556:	0005c903          	lbu	s2,0(a1)
 55a:	18090c63          	beqz	s2,6f2 <vprintf+0x1b4>
 55e:	8aaa                	mv	s5,a0
 560:	8bb2                	mv	s7,a2
 562:	00158493          	addi	s1,a1,1
  state = 0;
 566:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 568:	02500a13          	li	s4,37
 56c:	4b55                	li	s6,21
 56e:	a839                	j	58c <vprintf+0x4e>
        putc(fd, c);
 570:	85ca                	mv	a1,s2
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	efc080e7          	jalr	-260(ra) # 470 <putc>
 57c:	a019                	j	582 <vprintf+0x44>
    } else if(state == '%'){
 57e:	01498d63          	beq	s3,s4,598 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 582:	0485                	addi	s1,s1,1
 584:	fff4c903          	lbu	s2,-1(s1)
 588:	16090563          	beqz	s2,6f2 <vprintf+0x1b4>
    if(state == 0){
 58c:	fe0999e3          	bnez	s3,57e <vprintf+0x40>
      if(c == '%'){
 590:	ff4910e3          	bne	s2,s4,570 <vprintf+0x32>
        state = '%';
 594:	89d2                	mv	s3,s4
 596:	b7f5                	j	582 <vprintf+0x44>
      if(c == 'd'){
 598:	13490263          	beq	s2,s4,6bc <vprintf+0x17e>
 59c:	f9d9079b          	addiw	a5,s2,-99
 5a0:	0ff7f793          	zext.b	a5,a5
 5a4:	12fb6563          	bltu	s6,a5,6ce <vprintf+0x190>
 5a8:	f9d9079b          	addiw	a5,s2,-99
 5ac:	0ff7f713          	zext.b	a4,a5
 5b0:	10eb6f63          	bltu	s6,a4,6ce <vprintf+0x190>
 5b4:	00271793          	slli	a5,a4,0x2
 5b8:	00000717          	auipc	a4,0x0
 5bc:	34070713          	addi	a4,a4,832 # 8f8 <malloc+0x108>
 5c0:	97ba                	add	a5,a5,a4
 5c2:	439c                	lw	a5,0(a5)
 5c4:	97ba                	add	a5,a5,a4
 5c6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ebc080e7          	jalr	-324(ra) # 492 <printint>
 5de:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b745                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	ea0080e7          	jalr	-352(ra) # 492 <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b751                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 600:	008b8913          	addi	s2,s7,8
 604:	4681                	li	a3,0
 606:	4641                	li	a2,16
 608:	000ba583          	lw	a1,0(s7)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e84080e7          	jalr	-380(ra) # 492 <printint>
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	b7a5                	j	582 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 61c:	008b8c13          	addi	s8,s7,8
 620:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 624:	03000593          	li	a1,48
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e46080e7          	jalr	-442(ra) # 470 <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e38080e7          	jalr	-456(ra) # 470 <putc>
 640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	30eb8b93          	addi	s7,s7,782 # 950 <digits>
 64a:	03c9d793          	srli	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e1a080e7          	jalr	-486(ra) # 470 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65e:	0992                	slli	s3,s3,0x4
 660:	397d                	addiw	s2,s2,-1
 662:	fe0914e3          	bnez	s2,64a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 666:	8be2                	mv	s7,s8
      state = 0;
 668:	4981                	li	s3,0
 66a:	bf21                	j	582 <vprintf+0x44>
        s = va_arg(ap, char*);
 66c:	008b8993          	addi	s3,s7,8
 670:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 674:	02090163          	beqz	s2,696 <vprintf+0x158>
        while(*s != 0){
 678:	00094583          	lbu	a1,0(s2)
 67c:	c9a5                	beqz	a1,6ec <vprintf+0x1ae>
          putc(fd, *s);
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	df0080e7          	jalr	-528(ra) # 470 <putc>
          s++;
 688:	0905                	addi	s2,s2,1
        while(*s != 0){
 68a:	00094583          	lbu	a1,0(s2)
 68e:	f9e5                	bnez	a1,67e <vprintf+0x140>
        s = va_arg(ap, char*);
 690:	8bce                	mv	s7,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	b5fd                	j	582 <vprintf+0x44>
          s = "(null)";
 696:	00000917          	auipc	s2,0x0
 69a:	25a90913          	addi	s2,s2,602 # 8f0 <malloc+0x100>
        while(*s != 0){
 69e:	02800593          	li	a1,40
 6a2:	bff1                	j	67e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	000bc583          	lbu	a1,0(s7)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dc2080e7          	jalr	-574(ra) # 470 <putc>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b5e1                	j	582 <vprintf+0x44>
        putc(fd, c);
 6bc:	02500593          	li	a1,37
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dae080e7          	jalr	-594(ra) # 470 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd5d                	j	582 <vprintf+0x44>
        putc(fd, '%');
 6ce:	02500593          	li	a1,37
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	d9c080e7          	jalr	-612(ra) # 470 <putc>
        putc(fd, c);
 6dc:	85ca                	mv	a1,s2
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	d90080e7          	jalr	-624(ra) # 470 <putc>
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd61                	j	582 <vprintf+0x44>
        s = va_arg(ap, char*);
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bd49                	j	582 <vprintf+0x44>
    }
  }
}
 6f2:	60a6                	ld	ra,72(sp)
 6f4:	6406                	ld	s0,64(sp)
 6f6:	74e2                	ld	s1,56(sp)
 6f8:	7942                	ld	s2,48(sp)
 6fa:	79a2                	ld	s3,40(sp)
 6fc:	7a02                	ld	s4,32(sp)
 6fe:	6ae2                	ld	s5,24(sp)
 700:	6b42                	ld	s6,16(sp)
 702:	6ba2                	ld	s7,8(sp)
 704:	6c02                	ld	s8,0(sp)
 706:	6161                	addi	sp,sp,80
 708:	8082                	ret

000000000000070a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70a:	715d                	addi	sp,sp,-80
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e010                	sd	a2,0(s0)
 714:	e414                	sd	a3,8(s0)
 716:	e818                	sd	a4,16(s0)
 718:	ec1c                	sd	a5,24(s0)
 71a:	03043023          	sd	a6,32(s0)
 71e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 726:	8622                	mv	a2,s0
 728:	00000097          	auipc	ra,0x0
 72c:	e16080e7          	jalr	-490(ra) # 53e <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	00000097          	auipc	ra,0x0
 762:	de0080e7          	jalr	-544(ra) # 53e <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e422                	sd	s0,8(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00001797          	auipc	a5,0x1
 77c:	8887b783          	ld	a5,-1912(a5) # 1000 <freep>
 780:	a02d                	j	7aa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9f2d                	addw	a4,a4,a1
 786:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6310                	ld	a2,0(a4)
 78e:	a83d                	j	7cc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 790:	ff852703          	lw	a4,-8(a0)
 794:	9f31                	addw	a4,a4,a2
 796:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 798:	ff053683          	ld	a3,-16(a0)
 79c:	a091                	j	7e0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x3a>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x4a>
{
 7a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x30>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	slli	a6,a1,0x20
 7c2:	01c85713          	srli	a4,a6,0x1c
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60de3          	beq	a2,a4,782 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	slli	a1,a2,0x20
 7d6:	01c5d713          	srli	a4,a1,0x1c
 7da:	973e                	add	a4,a4,a5
 7dc:	fae68ae3          	beq	a3,a4,790 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80f73f23          	sd	a5,-2018(a4) # 1000 <freep>
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051493          	slli	s1,a0,0x20
 808:	9081                	srli	s1,s1,0x20
 80a:	04bd                	addi	s1,s1,15
 80c:	8091                	srli	s1,s1,0x4
 80e:	0014899b          	addiw	s3,s1,1
 812:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 814:	00000517          	auipc	a0,0x0
 818:	7ec53503          	ld	a0,2028(a0) # 1000 <freep>
 81c:	c515                	beqz	a0,848 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	02977f63          	bgeu	a4,s1,860 <malloc+0x70>
  if(nu < 4096)
 826:	8a4e                	mv	s4,s3
 828:	0009871b          	sext.w	a4,s3
 82c:	6685                	lui	a3,0x1
 82e:	00d77363          	bgeu	a4,a3,834 <malloc+0x44>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000917          	auipc	s2,0x0
 840:	7c490913          	addi	s2,s2,1988 # 1000 <freep>
  if(p == (char*)-1)
 844:	5afd                	li	s5,-1
 846:	a895                	j	8ba <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	7c878793          	addi	a5,a5,1992 # 1010 <base>
 850:	00000717          	auipc	a4,0x0
 854:	7af73823          	sd	a5,1968(a4) # 1000 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85e:	b7e1                	j	826 <malloc+0x36>
      if(p->s.size == nunits)
 860:	02e48c63          	beq	s1,a4,898 <malloc+0xa8>
        p->s.size -= nunits;
 864:	4137073b          	subw	a4,a4,s3
 868:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86a:	02071693          	slli	a3,a4,0x20
 86e:	01c6d713          	srli	a4,a3,0x1c
 872:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 874:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 878:	00000717          	auipc	a4,0x0
 87c:	78a73423          	sd	a0,1928(a4) # 1000 <freep>
      return (void*)(p + 1);
 880:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 884:	70e2                	ld	ra,56(sp)
 886:	7442                	ld	s0,48(sp)
 888:	74a2                	ld	s1,40(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	6121                	addi	sp,sp,64
 896:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	bff1                	j	878 <malloc+0x88>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	00000097          	auipc	ra,0x0
 8a8:	eca080e7          	jalr	-310(ra) # 76e <free>
  return freep;
 8ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b0:	d971                	beqz	a0,884 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	fa9775e3          	bgeu	a4,s1,860 <malloc+0x70>
    if(p == freep)
 8ba:	00093703          	ld	a4,0(s2)
 8be:	853e                	mv	a0,a5
 8c0:	fef719e3          	bne	a4,a5,8b2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	00000097          	auipc	ra,0x0
 8ca:	b92080e7          	jalr	-1134(ra) # 458 <sbrk>
  if(p == (char*)-1)
 8ce:	fd5518e3          	bne	a0,s5,89e <malloc+0xae>
        return 0;
 8d2:	4501                	li	a0,0
 8d4:	bf45                	j	884 <malloc+0x94>
