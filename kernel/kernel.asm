
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b2013103          	ld	sp,-1248(sp) # 80008b20 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1c1050ef          	jal	ra,800059d6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	9b078793          	addi	a5,a5,-1616 # 800229e0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	b2090913          	addi	s2,s2,-1248 # 80008b70 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3e0080e7          	jalr	992(ra) # 8000643a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	480080e7          	jalr	1152(ra) # 800064ee <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ea2080e7          	jalr	-350(ra) # 80005f2c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	a8250513          	addi	a0,a0,-1406 # 80008b70 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	2b4080e7          	jalr	692(ra) # 800063aa <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00023517          	auipc	a0,0x23
    80000106:	8de50513          	addi	a0,a0,-1826 # 800229e0 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	a4c48493          	addi	s1,s1,-1460 # 80008b70 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	30c080e7          	jalr	780(ra) # 8000643a <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	a3450513          	addi	a0,a0,-1484 # 80008b70 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3a8080e7          	jalr	936(ra) # 800064ee <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	a0850513          	addi	a0,a0,-1528 # 80008b70 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	37e080e7          	jalr	894(ra) # 800064ee <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdc621>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	addi	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addiw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	addi	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	addi	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	c86080e7          	jalr	-890(ra) # 80000fac <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00009717          	auipc	a4,0x9
    80000332:	81270713          	addi	a4,a4,-2030 # 80008b40 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	c6a080e7          	jalr	-918(ra) # 80000fac <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	c2a080e7          	jalr	-982(ra) # 80005f7e <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	9d6080e7          	jalr	-1578(ra) # 80001d3a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	024080e7          	jalr	36(ra) # 80005390 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	21e080e7          	jalr	542(ra) # 80001592 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	a1a080e7          	jalr	-1510(ra) # 80005d96 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b02080e7          	jalr	-1278(ra) # 80005e86 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	bea080e7          	jalr	-1046(ra) # 80005f7e <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	bda080e7          	jalr	-1062(ra) # 80005f7e <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	bca080e7          	jalr	-1078(ra) # 80005f7e <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	b24080e7          	jalr	-1244(ra) # 80000ef8 <procinit>
    trapinit();      // trap vectors
    800003dc:	00002097          	auipc	ra,0x2
    800003e0:	936080e7          	jalr	-1738(ra) # 80001d12 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	956080e7          	jalr	-1706(ra) # 80001d3a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	f8e080e7          	jalr	-114(ra) # 8000537a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f9c080e7          	jalr	-100(ra) # 80005390 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	186080e7          	jalr	390(ra) # 80002582 <binit>
    iinit();         // inode table
    80000404:	00003097          	auipc	ra,0x3
    80000408:	824080e7          	jalr	-2012(ra) # 80002c28 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	79a080e7          	jalr	1946(ra) # 80003ba6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	084080e7          	jalr	132(ra) # 80005498 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	f50080e7          	jalr	-176(ra) # 8000136c <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	70f72b23          	sw	a5,1814(a4) # 80008b40 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	70a7b783          	ld	a5,1802(a5) # 80008b48 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	aa2080e7          	jalr	-1374(ra) # 80005f2c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdc617>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srli	a5,a5,0xa
    8000053a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	777d                	lui	a4,0xfffff
    80000562:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000566:	fff58993          	addi	s3,a1,-1
    8000056a:	99b2                	add	s3,s3,a2
    8000056c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000570:	893e                	mv	s2,a5
    80000572:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00006097          	auipc	ra,0x6
    800005b4:	97c080e7          	jalr	-1668(ra) # 80005f2c <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	96c080e7          	jalr	-1684(ra) # 80005f2c <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00006097          	auipc	ra,0x6
    80000610:	920080e7          	jalr	-1760(ra) # 80005f2c <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	afa080e7          	jalr	-1286(ra) # 8000011a <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4c080e7          	jalr	-1204(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	78e080e7          	jalr	1934(ra) # 80000e62 <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	44a7b723          	sd	a0,1102(a5) # 80008b48 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	7d4080e7          	jalr	2004(ra) # 80005f2c <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	7c4080e7          	jalr	1988(ra) # 80005f2c <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	7b4080e7          	jalr	1972(ra) # 80005f2c <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	7a4080e7          	jalr	1956(ra) # 80005f2c <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	6c6080e7          	jalr	1734(ra) # 80005f2c <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	slli	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	addi	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	andi	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	addi	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	57a080e7          	jalr	1402(ra) # 80005f2c <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	addi	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <vmprint>:
void vmprint(pagetable_t pagetable, int count){
    800009d4:	7119                	addi	sp,sp,-128
    800009d6:	fc86                	sd	ra,120(sp)
    800009d8:	f8a2                	sd	s0,112(sp)
    800009da:	f4a6                	sd	s1,104(sp)
    800009dc:	f0ca                	sd	s2,96(sp)
    800009de:	ecce                	sd	s3,88(sp)
    800009e0:	e8d2                	sd	s4,80(sp)
    800009e2:	e4d6                	sd	s5,72(sp)
    800009e4:	e0da                	sd	s6,64(sp)
    800009e6:	fc5e                	sd	s7,56(sp)
    800009e8:	f862                	sd	s8,48(sp)
    800009ea:	f466                	sd	s9,40(sp)
    800009ec:	f06a                	sd	s10,32(sp)
    800009ee:	ec6e                	sd	s11,24(sp)
    800009f0:	0100                	addi	s0,sp,128
    800009f2:	84aa                	mv	s1,a0
    800009f4:	8a2e                	mv	s4,a1
  if(count==0){
    800009f6:	c19d                	beqz	a1,80000a1c <vmprint+0x48>
    printf("pag table %p\n",pagetable);
  }
  int arg_tmp=count+1;
  if(count!=3){
    800009f8:	478d                	li	a5,3
    800009fa:	04f59f63          	bne	a1,a5,80000a58 <vmprint+0x84>
    continue;
  }
  }
  }
  return;
}
    800009fe:	70e6                	ld	ra,120(sp)
    80000a00:	7446                	ld	s0,112(sp)
    80000a02:	74a6                	ld	s1,104(sp)
    80000a04:	7906                	ld	s2,96(sp)
    80000a06:	69e6                	ld	s3,88(sp)
    80000a08:	6a46                	ld	s4,80(sp)
    80000a0a:	6aa6                	ld	s5,72(sp)
    80000a0c:	6b06                	ld	s6,64(sp)
    80000a0e:	7be2                	ld	s7,56(sp)
    80000a10:	7c42                	ld	s8,48(sp)
    80000a12:	7ca2                	ld	s9,40(sp)
    80000a14:	7d02                	ld	s10,32(sp)
    80000a16:	6de2                	ld	s11,24(sp)
    80000a18:	6109                	addi	sp,sp,128
    80000a1a:	8082                	ret
    printf("pag table %p\n",pagetable);
    80000a1c:	85aa                	mv	a1,a0
    80000a1e:	00007517          	auipc	a0,0x7
    80000a22:	6ea50513          	addi	a0,a0,1770 # 80008108 <etext+0x108>
    80000a26:	00005097          	auipc	ra,0x5
    80000a2a:	558080e7          	jalr	1368(ra) # 80005f7e <printf>
  int arg_tmp=count+1;
    80000a2e:	4785                	li	a5,1
    80000a30:	f8f43423          	sd	a5,-120(s0)
     for(int i = 0; i < 512; i++){
    80000a34:	4901                	li	s2,0
    else if(count==1){
    80000a36:	4b05                	li	s6,1
    else if(count==2){
    80000a38:	4b89                	li	s7,2
      printf(".. .. ..");
    80000a3a:	00007d17          	auipc	s10,0x7
    80000a3e:	6eed0d13          	addi	s10,s10,1774 # 80008128 <etext+0x128>
      printf(".. ..");
    80000a42:	00007c97          	auipc	s9,0x7
    80000a46:	6dec8c93          	addi	s9,s9,1758 # 80008120 <etext+0x120>
      printf("..");
    80000a4a:	00007c17          	auipc	s8,0x7
    80000a4e:	6cec0c13          	addi	s8,s8,1742 # 80008118 <etext+0x118>
     for(int i = 0; i < 512; i++){
    80000a52:	20000a93          	li	s5,512
    80000a56:	a825                	j	80000a8e <vmprint+0xba>
  int arg_tmp=count+1;
    80000a58:	0015879b          	addiw	a5,a1,1
    80000a5c:	f8f43423          	sd	a5,-120(s0)
    80000a60:	bfd1                	j	80000a34 <vmprint+0x60>
      printf("..");
    80000a62:	8562                	mv	a0,s8
    80000a64:	00005097          	auipc	ra,0x5
    80000a68:	51a080e7          	jalr	1306(ra) # 80005f7e <printf>
    80000a6c:	a825                	j	80000aa4 <vmprint+0xd0>
      printf(".. ..");
    80000a6e:	8566                	mv	a0,s9
    80000a70:	00005097          	auipc	ra,0x5
    80000a74:	50e080e7          	jalr	1294(ra) # 80005f7e <printf>
    80000a78:	a035                	j	80000aa4 <vmprint+0xd0>
      printf(".. .. ..");
    80000a7a:	856a                	mv	a0,s10
    80000a7c:	00005097          	auipc	ra,0x5
    80000a80:	502080e7          	jalr	1282(ra) # 80005f7e <printf>
    80000a84:	a005                	j	80000aa4 <vmprint+0xd0>
     for(int i = 0; i < 512; i++){
    80000a86:	2905                	addiw	s2,s2,1 # 1001 <_entry-0x7fffefff>
    80000a88:	04a1                	addi	s1,s1,8
    80000a8a:	f7590ae3          	beq	s2,s5,800009fe <vmprint+0x2a>
     pte_t pte = pagetable[i];
    80000a8e:	0004b983          	ld	s3,0(s1)
     if(pte & PTE_V){
    80000a92:	0019f793          	andi	a5,s3,1
    80000a96:	dbe5                	beqz	a5,80000a86 <vmprint+0xb2>
    if (count==0){
    80000a98:	fc0a05e3          	beqz	s4,80000a62 <vmprint+0x8e>
    else if(count==1){
    80000a9c:	fd6a09e3          	beq	s4,s6,80000a6e <vmprint+0x9a>
    else if(count==2){
    80000aa0:	fd7a0de3          	beq	s4,s7,80000a7a <vmprint+0xa6>
      uint64 child = PTE2PA(pte);
    80000aa4:	00a9dd93          	srli	s11,s3,0xa
    80000aa8:	0db2                	slli	s11,s11,0xc
    printf("%d: pte %p pa %p\n",i,pte,child);
    80000aaa:	86ee                	mv	a3,s11
    80000aac:	864e                	mv	a2,s3
    80000aae:	85ca                	mv	a1,s2
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	68850513          	addi	a0,a0,1672 # 80008138 <etext+0x138>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	4c6080e7          	jalr	1222(ra) # 80005f7e <printf>
    vmprint((pagetable_t)child,arg_tmp);
    80000ac0:	f8843583          	ld	a1,-120(s0)
    80000ac4:	856e                	mv	a0,s11
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f0e080e7          	jalr	-242(ra) # 800009d4 <vmprint>
    80000ace:	bf65                	j	80000a86 <vmprint+0xb2>

0000000080000ad0 <uvmfree>:
// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ad0:	1101                	addi	sp,sp,-32
    80000ad2:	ec06                	sd	ra,24(sp)
    80000ad4:	e822                	sd	s0,16(sp)
    80000ad6:	e426                	sd	s1,8(sp)
    80000ad8:	1000                	addi	s0,sp,32
    80000ada:	84aa                	mv	s1,a0
  if(sz > 0)
    80000adc:	e999                	bnez	a1,80000af2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ade:	8526                	mv	a0,s1
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	e88080e7          	jalr	-376(ra) # 80000968 <freewalk>
}
    80000ae8:	60e2                	ld	ra,24(sp)
    80000aea:	6442                	ld	s0,16(sp)
    80000aec:	64a2                	ld	s1,8(sp)
    80000aee:	6105                	addi	sp,sp,32
    80000af0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000af2:	6785                	lui	a5,0x1
    80000af4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000af6:	95be                	add	a1,a1,a5
    80000af8:	4685                	li	a3,1
    80000afa:	00c5d613          	srli	a2,a1,0xc
    80000afe:	4581                	li	a1,0
    80000b00:	00000097          	auipc	ra,0x0
    80000b04:	c0a080e7          	jalr	-1014(ra) # 8000070a <uvmunmap>
    80000b08:	bfd9                	j	80000ade <uvmfree+0xe>

0000000080000b0a <uvmcopy>:
  pte_t *pte;
uint64  i, pa;
 uint flags;
 // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b0a:	c64d                	beqz	a2,80000bb4 <uvmcopy+0xaa>
{
    80000b0c:	7179                	addi	sp,sp,-48
    80000b0e:	f406                	sd	ra,40(sp)
    80000b10:	f022                	sd	s0,32(sp)
    80000b12:	ec26                	sd	s1,24(sp)
    80000b14:	e84a                	sd	s2,16(sp)
    80000b16:	e44e                	sd	s3,8(sp)
    80000b18:	e052                	sd	s4,0(sp)
    80000b1a:	1800                	addi	s0,sp,48
    80000b1c:	8a2a                	mv	s4,a0
    80000b1e:	89ae                	mv	s3,a1
    80000b20:	8932                	mv	s2,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b22:	4481                	li	s1,0
    80000b24:	a82d                	j	80000b5e <uvmcopy+0x54>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000b26:	00007517          	auipc	a0,0x7
    80000b2a:	62a50513          	addi	a0,a0,1578 # 80008150 <etext+0x150>
    80000b2e:	00005097          	auipc	ra,0x5
    80000b32:	3fe080e7          	jalr	1022(ra) # 80005f2c <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000b36:	00007517          	auipc	a0,0x7
    80000b3a:	63a50513          	addi	a0,a0,1594 # 80008170 <etext+0x170>
    80000b3e:	00005097          	auipc	ra,0x5
    80000b42:	3ee080e7          	jalr	1006(ra) # 80005f2c <panic>
    }
   // flags = PTE_FLAGS(*pte);
    /*  if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);*/
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000b46:	6605                	lui	a2,0x1
    80000b48:	85a6                	mv	a1,s1
    80000b4a:	854e                	mv	a0,s3
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	9f8080e7          	jalr	-1544(ra) # 80000544 <mappages>
    80000b54:	ed15                	bnez	a0,80000b90 <uvmcopy+0x86>
  for(i = 0; i < sz; i += PGSIZE){
    80000b56:	6785                	lui	a5,0x1
    80000b58:	94be                	add	s1,s1,a5
    80000b5a:	0524f563          	bgeu	s1,s2,80000ba4 <uvmcopy+0x9a>
    if((pte = walk(old, i, 0)) == 0)
    80000b5e:	4601                	li	a2,0
    80000b60:	85a6                	mv	a1,s1
    80000b62:	8552                	mv	a0,s4
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	8f8080e7          	jalr	-1800(ra) # 8000045c <walk>
    80000b6c:	dd4d                	beqz	a0,80000b26 <uvmcopy+0x1c>
    if((*pte & PTE_V) == 0)
    80000b6e:	611c                	ld	a5,0(a0)
    80000b70:	0017f713          	andi	a4,a5,1
    80000b74:	d369                	beqz	a4,80000b36 <uvmcopy+0x2c>
     pa = PTE2PA(*pte);
    80000b76:	00a7d693          	srli	a3,a5,0xa
    80000b7a:	06b2                	slli	a3,a3,0xc
     flags = PTE_FLAGS(*pte);
    80000b7c:	3ff7f713          	andi	a4,a5,1023
    if(*pte & PTE_W){
    80000b80:	0047f613          	andi	a2,a5,4
    80000b84:	d269                	beqz	a2,80000b46 <uvmcopy+0x3c>
      *pte&=~PTE_W;
    80000b86:	9bed                	andi	a5,a5,-5
      *pte|=PTE_C;
    80000b88:	1007e793          	ori	a5,a5,256
    80000b8c:	e11c                	sd	a5,0(a0)
    80000b8e:	bf65                	j	80000b46 <uvmcopy+0x3c>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b90:	4685                	li	a3,1
    80000b92:	00c4d613          	srli	a2,s1,0xc
    80000b96:	4581                	li	a1,0
    80000b98:	854e                	mv	a0,s3
    80000b9a:	00000097          	auipc	ra,0x0
    80000b9e:	b70080e7          	jalr	-1168(ra) # 8000070a <uvmunmap>
  return -1;
    80000ba2:	557d                	li	a0,-1

}
    80000ba4:	70a2                	ld	ra,40(sp)
    80000ba6:	7402                	ld	s0,32(sp)
    80000ba8:	64e2                	ld	s1,24(sp)
    80000baa:	6942                	ld	s2,16(sp)
    80000bac:	69a2                	ld	s3,8(sp)
    80000bae:	6a02                	ld	s4,0(sp)
    80000bb0:	6145                	addi	sp,sp,48
    80000bb2:	8082                	ret
  return 0;
    80000bb4:	4501                	li	a0,0
}
    80000bb6:	8082                	ret

0000000080000bb8 <uvmcow>:
int
uvmcow (pagetable_t pt, uint64 addr){
    80000bb8:	7139                	addi	sp,sp,-64
    80000bba:	fc06                	sd	ra,56(sp)
    80000bbc:	f822                	sd	s0,48(sp)
    80000bbe:	f426                	sd	s1,40(sp)
    80000bc0:	f04a                	sd	s2,32(sp)
    80000bc2:	ec4e                	sd	s3,24(sp)
    80000bc4:	e852                	sd	s4,16(sp)
    80000bc6:	e456                	sd	s5,8(sp)
    80000bc8:	0080                	addi	s0,sp,64
    80000bca:	8a2a                	mv	s4,a0
    80000bcc:	8aae                	mv	s5,a1
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;
 if((pte = walk(pt, addr, 0)) == 0)
    80000bce:	4601                	li	a2,0
    80000bd0:	00000097          	auipc	ra,0x0
    80000bd4:	88c080e7          	jalr	-1908(ra) # 8000045c <walk>
    80000bd8:	c149                	beqz	a0,80000c5a <uvmcow+0xa2>
    80000bda:	84aa                	mv	s1,a0
    return -1;
 if((*pte & PTE_V) == 0)
    return -1;
 if((*pte & PTE_C) == 0)
    80000bdc:	611c                	ld	a5,0(a0)
    80000bde:	1017f793          	andi	a5,a5,257
    80000be2:	10100713          	li	a4,257
    80000be6:	06e79c63          	bne	a5,a4,80000c5e <uvmcow+0xa6>
    return -1;
  if((mem = kalloc()) == 0)
    80000bea:	fffff097          	auipc	ra,0xfffff
    80000bee:	530080e7          	jalr	1328(ra) # 8000011a <kalloc>
    80000bf2:	892a                	mv	s2,a0
    80000bf4:	c53d                	beqz	a0,80000c62 <uvmcow+0xaa>
    return -1;
  flags = PTE_FLAGS(*pte);
    80000bf6:	0004b983          	ld	s3,0(s1)
  flags |= PTE_W;
  flags &= ~PTE_C;  
  pa = PTE2PA(*pte);
    80000bfa:	00a9d593          	srli	a1,s3,0xa
  memmove(mem, (char*)pa, PGSIZE);
    80000bfe:	6605                	lui	a2,0x1
    80000c00:	05b2                	slli	a1,a1,0xc
    80000c02:	fffff097          	auipc	ra,0xfffff
    80000c06:	5d4080e7          	jalr	1492(ra) # 800001d6 <memmove>
  uvmunmap(pt,PGROUNDDOWN(addr),1,0); 
    80000c0a:	77fd                	lui	a5,0xfffff
    80000c0c:	00fafab3          	and	s5,s5,a5
    80000c10:	4681                	li	a3,0
    80000c12:	4605                	li	a2,1
    80000c14:	85d6                	mv	a1,s5
    80000c16:	8552                	mv	a0,s4
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	af2080e7          	jalr	-1294(ra) # 8000070a <uvmunmap>
  flags &= ~PTE_C;  
    80000c20:	2ff9f713          	andi	a4,s3,767
 if(mappages(pt,PGROUNDDOWN(addr), PGSIZE, (uint64)mem, flags) != 0){
    80000c24:	00476713          	ori	a4,a4,4
    80000c28:	86ca                	mv	a3,s2
    80000c2a:	6605                	lui	a2,0x1
    80000c2c:	85d6                	mv	a1,s5
    80000c2e:	8552                	mv	a0,s4
    80000c30:	00000097          	auipc	ra,0x0
    80000c34:	914080e7          	jalr	-1772(ra) # 80000544 <mappages>
    80000c38:	e911                	bnez	a0,80000c4c <uvmcow+0x94>
      kfree(mem);
    return -1;   
 }
  return 0;
}
    80000c3a:	70e2                	ld	ra,56(sp)
    80000c3c:	7442                	ld	s0,48(sp)
    80000c3e:	74a2                	ld	s1,40(sp)
    80000c40:	7902                	ld	s2,32(sp)
    80000c42:	69e2                	ld	s3,24(sp)
    80000c44:	6a42                	ld	s4,16(sp)
    80000c46:	6aa2                	ld	s5,8(sp)
    80000c48:	6121                	addi	sp,sp,64
    80000c4a:	8082                	ret
      kfree(mem);
    80000c4c:	854a                	mv	a0,s2
    80000c4e:	fffff097          	auipc	ra,0xfffff
    80000c52:	3ce080e7          	jalr	974(ra) # 8000001c <kfree>
    return -1;   
    80000c56:	557d                	li	a0,-1
    80000c58:	b7cd                	j	80000c3a <uvmcow+0x82>
    return -1;
    80000c5a:	557d                	li	a0,-1
    80000c5c:	bff9                	j	80000c3a <uvmcow+0x82>
    return -1;
    80000c5e:	557d                	li	a0,-1
    80000c60:	bfe9                	j	80000c3a <uvmcow+0x82>
    return -1;
    80000c62:	557d                	li	a0,-1
    80000c64:	bfd9                	j	80000c3a <uvmcow+0x82>

0000000080000c66 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c66:	1141                	addi	sp,sp,-16
    80000c68:	e406                	sd	ra,8(sp)
    80000c6a:	e022                	sd	s0,0(sp)
    80000c6c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c6e:	4601                	li	a2,0
    80000c70:	fffff097          	auipc	ra,0xfffff
    80000c74:	7ec080e7          	jalr	2028(ra) # 8000045c <walk>
  if(pte == 0)
    80000c78:	c901                	beqz	a0,80000c88 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c7a:	611c                	ld	a5,0(a0)
    80000c7c:	9bbd                	andi	a5,a5,-17
    80000c7e:	e11c                	sd	a5,0(a0)
}
    80000c80:	60a2                	ld	ra,8(sp)
    80000c82:	6402                	ld	s0,0(sp)
    80000c84:	0141                	addi	sp,sp,16
    80000c86:	8082                	ret
    panic("uvmclear");
    80000c88:	00007517          	auipc	a0,0x7
    80000c8c:	50850513          	addi	a0,a0,1288 # 80008190 <etext+0x190>
    80000c90:	00005097          	auipc	ra,0x5
    80000c94:	29c080e7          	jalr	668(ra) # 80005f2c <panic>

0000000080000c98 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c98:	c6bd                	beqz	a3,80000d06 <copyout+0x6e>
{
    80000c9a:	715d                	addi	sp,sp,-80
    80000c9c:	e486                	sd	ra,72(sp)
    80000c9e:	e0a2                	sd	s0,64(sp)
    80000ca0:	fc26                	sd	s1,56(sp)
    80000ca2:	f84a                	sd	s2,48(sp)
    80000ca4:	f44e                	sd	s3,40(sp)
    80000ca6:	f052                	sd	s4,32(sp)
    80000ca8:	ec56                	sd	s5,24(sp)
    80000caa:	e85a                	sd	s6,16(sp)
    80000cac:	e45e                	sd	s7,8(sp)
    80000cae:	e062                	sd	s8,0(sp)
    80000cb0:	0880                	addi	s0,sp,80
    80000cb2:	8b2a                	mv	s6,a0
    80000cb4:	8c2e                	mv	s8,a1
    80000cb6:	8a32                	mv	s4,a2
    80000cb8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000cba:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000cbc:	6a85                	lui	s5,0x1
    80000cbe:	a015                	j	80000ce2 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cc0:	9562                	add	a0,a0,s8
    80000cc2:	0004861b          	sext.w	a2,s1
    80000cc6:	85d2                	mv	a1,s4
    80000cc8:	41250533          	sub	a0,a0,s2
    80000ccc:	fffff097          	auipc	ra,0xfffff
    80000cd0:	50a080e7          	jalr	1290(ra) # 800001d6 <memmove>

    len -= n;
    80000cd4:	409989b3          	sub	s3,s3,s1
    src += n;
    80000cd8:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000cda:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cde:	02098263          	beqz	s3,80000d02 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000ce2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ce6:	85ca                	mv	a1,s2
    80000ce8:	855a                	mv	a0,s6
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	818080e7          	jalr	-2024(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000cf2:	cd01                	beqz	a0,80000d0a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000cf4:	418904b3          	sub	s1,s2,s8
    80000cf8:	94d6                	add	s1,s1,s5
    80000cfa:	fc99f3e3          	bgeu	s3,s1,80000cc0 <copyout+0x28>
    80000cfe:	84ce                	mv	s1,s3
    80000d00:	b7c1                	j	80000cc0 <copyout+0x28>
  }
  return 0;
    80000d02:	4501                	li	a0,0
    80000d04:	a021                	j	80000d0c <copyout+0x74>
    80000d06:	4501                	li	a0,0
}
    80000d08:	8082                	ret
      return -1;
    80000d0a:	557d                	li	a0,-1
}
    80000d0c:	60a6                	ld	ra,72(sp)
    80000d0e:	6406                	ld	s0,64(sp)
    80000d10:	74e2                	ld	s1,56(sp)
    80000d12:	7942                	ld	s2,48(sp)
    80000d14:	79a2                	ld	s3,40(sp)
    80000d16:	7a02                	ld	s4,32(sp)
    80000d18:	6ae2                	ld	s5,24(sp)
    80000d1a:	6b42                	ld	s6,16(sp)
    80000d1c:	6ba2                	ld	s7,8(sp)
    80000d1e:	6c02                	ld	s8,0(sp)
    80000d20:	6161                	addi	sp,sp,80
    80000d22:	8082                	ret

0000000080000d24 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d24:	caa5                	beqz	a3,80000d94 <copyin+0x70>
{
    80000d26:	715d                	addi	sp,sp,-80
    80000d28:	e486                	sd	ra,72(sp)
    80000d2a:	e0a2                	sd	s0,64(sp)
    80000d2c:	fc26                	sd	s1,56(sp)
    80000d2e:	f84a                	sd	s2,48(sp)
    80000d30:	f44e                	sd	s3,40(sp)
    80000d32:	f052                	sd	s4,32(sp)
    80000d34:	ec56                	sd	s5,24(sp)
    80000d36:	e85a                	sd	s6,16(sp)
    80000d38:	e45e                	sd	s7,8(sp)
    80000d3a:	e062                	sd	s8,0(sp)
    80000d3c:	0880                	addi	s0,sp,80
    80000d3e:	8b2a                	mv	s6,a0
    80000d40:	8a2e                	mv	s4,a1
    80000d42:	8c32                	mv	s8,a2
    80000d44:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d46:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d48:	6a85                	lui	s5,0x1
    80000d4a:	a01d                	j	80000d70 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d4c:	018505b3          	add	a1,a0,s8
    80000d50:	0004861b          	sext.w	a2,s1
    80000d54:	412585b3          	sub	a1,a1,s2
    80000d58:	8552                	mv	a0,s4
    80000d5a:	fffff097          	auipc	ra,0xfffff
    80000d5e:	47c080e7          	jalr	1148(ra) # 800001d6 <memmove>

    len -= n;
    80000d62:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d66:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d68:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d6c:	02098263          	beqz	s3,80000d90 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d70:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d74:	85ca                	mv	a1,s2
    80000d76:	855a                	mv	a0,s6
    80000d78:	fffff097          	auipc	ra,0xfffff
    80000d7c:	78a080e7          	jalr	1930(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000d80:	cd01                	beqz	a0,80000d98 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d82:	418904b3          	sub	s1,s2,s8
    80000d86:	94d6                	add	s1,s1,s5
    80000d88:	fc99f2e3          	bgeu	s3,s1,80000d4c <copyin+0x28>
    80000d8c:	84ce                	mv	s1,s3
    80000d8e:	bf7d                	j	80000d4c <copyin+0x28>
  }
  return 0;
    80000d90:	4501                	li	a0,0
    80000d92:	a021                	j	80000d9a <copyin+0x76>
    80000d94:	4501                	li	a0,0
}
    80000d96:	8082                	ret
      return -1;
    80000d98:	557d                	li	a0,-1
}
    80000d9a:	60a6                	ld	ra,72(sp)
    80000d9c:	6406                	ld	s0,64(sp)
    80000d9e:	74e2                	ld	s1,56(sp)
    80000da0:	7942                	ld	s2,48(sp)
    80000da2:	79a2                	ld	s3,40(sp)
    80000da4:	7a02                	ld	s4,32(sp)
    80000da6:	6ae2                	ld	s5,24(sp)
    80000da8:	6b42                	ld	s6,16(sp)
    80000daa:	6ba2                	ld	s7,8(sp)
    80000dac:	6c02                	ld	s8,0(sp)
    80000dae:	6161                	addi	sp,sp,80
    80000db0:	8082                	ret

0000000080000db2 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000db2:	c2dd                	beqz	a3,80000e58 <copyinstr+0xa6>
{
    80000db4:	715d                	addi	sp,sp,-80
    80000db6:	e486                	sd	ra,72(sp)
    80000db8:	e0a2                	sd	s0,64(sp)
    80000dba:	fc26                	sd	s1,56(sp)
    80000dbc:	f84a                	sd	s2,48(sp)
    80000dbe:	f44e                	sd	s3,40(sp)
    80000dc0:	f052                	sd	s4,32(sp)
    80000dc2:	ec56                	sd	s5,24(sp)
    80000dc4:	e85a                	sd	s6,16(sp)
    80000dc6:	e45e                	sd	s7,8(sp)
    80000dc8:	0880                	addi	s0,sp,80
    80000dca:	8a2a                	mv	s4,a0
    80000dcc:	8b2e                	mv	s6,a1
    80000dce:	8bb2                	mv	s7,a2
    80000dd0:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dd2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dd4:	6985                	lui	s3,0x1
    80000dd6:	a02d                	j	80000e00 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dd8:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc620>
    80000ddc:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000dde:	37fd                	addiw	a5,a5,-1
    80000de0:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000de4:	60a6                	ld	ra,72(sp)
    80000de6:	6406                	ld	s0,64(sp)
    80000de8:	74e2                	ld	s1,56(sp)
    80000dea:	7942                	ld	s2,48(sp)
    80000dec:	79a2                	ld	s3,40(sp)
    80000dee:	7a02                	ld	s4,32(sp)
    80000df0:	6ae2                	ld	s5,24(sp)
    80000df2:	6b42                	ld	s6,16(sp)
    80000df4:	6ba2                	ld	s7,8(sp)
    80000df6:	6161                	addi	sp,sp,80
    80000df8:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dfa:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dfe:	c8a9                	beqz	s1,80000e50 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000e00:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e04:	85ca                	mv	a1,s2
    80000e06:	8552                	mv	a0,s4
    80000e08:	fffff097          	auipc	ra,0xfffff
    80000e0c:	6fa080e7          	jalr	1786(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000e10:	c131                	beqz	a0,80000e54 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000e12:	417906b3          	sub	a3,s2,s7
    80000e16:	96ce                	add	a3,a3,s3
    80000e18:	00d4f363          	bgeu	s1,a3,80000e1e <copyinstr+0x6c>
    80000e1c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e1e:	955e                	add	a0,a0,s7
    80000e20:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e24:	daf9                	beqz	a3,80000dfa <copyinstr+0x48>
    80000e26:	87da                	mv	a5,s6
    80000e28:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000e2a:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000e2e:	96da                	add	a3,a3,s6
    80000e30:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000e32:	00f60733          	add	a4,a2,a5
    80000e36:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdc620>
    80000e3a:	df59                	beqz	a4,80000dd8 <copyinstr+0x26>
        *dst = *p;
    80000e3c:	00e78023          	sb	a4,0(a5)
      dst++;
    80000e40:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e42:	fed797e3          	bne	a5,a3,80000e30 <copyinstr+0x7e>
    80000e46:	14fd                	addi	s1,s1,-1
    80000e48:	94c2                	add	s1,s1,a6
      --max;
    80000e4a:	8c8d                	sub	s1,s1,a1
      dst++;
    80000e4c:	8b3e                	mv	s6,a5
    80000e4e:	b775                	j	80000dfa <copyinstr+0x48>
    80000e50:	4781                	li	a5,0
    80000e52:	b771                	j	80000dde <copyinstr+0x2c>
      return -1;
    80000e54:	557d                	li	a0,-1
    80000e56:	b779                	j	80000de4 <copyinstr+0x32>
  int got_null = 0;
    80000e58:	4781                	li	a5,0
  if(got_null){
    80000e5a:	37fd                	addiw	a5,a5,-1
    80000e5c:	0007851b          	sext.w	a0,a5
}
    80000e60:	8082                	ret

0000000080000e62 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e62:	7139                	addi	sp,sp,-64
    80000e64:	fc06                	sd	ra,56(sp)
    80000e66:	f822                	sd	s0,48(sp)
    80000e68:	f426                	sd	s1,40(sp)
    80000e6a:	f04a                	sd	s2,32(sp)
    80000e6c:	ec4e                	sd	s3,24(sp)
    80000e6e:	e852                	sd	s4,16(sp)
    80000e70:	e456                	sd	s5,8(sp)
    80000e72:	e05a                	sd	s6,0(sp)
    80000e74:	0080                	addi	s0,sp,64
    80000e76:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e78:	00008497          	auipc	s1,0x8
    80000e7c:	14848493          	addi	s1,s1,328 # 80008fc0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e80:	8b26                	mv	s6,s1
    80000e82:	00007a97          	auipc	s5,0x7
    80000e86:	17ea8a93          	addi	s5,s5,382 # 80008000 <etext>
    80000e8a:	04000937          	lui	s2,0x4000
    80000e8e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e90:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e92:	0000ea17          	auipc	s4,0xe
    80000e96:	52ea0a13          	addi	s4,s4,1326 # 8000f3c0 <tickslock>
    char *pa = kalloc();
    80000e9a:	fffff097          	auipc	ra,0xfffff
    80000e9e:	280080e7          	jalr	640(ra) # 8000011a <kalloc>
    80000ea2:	862a                	mv	a2,a0
    if(pa == 0)
    80000ea4:	c131                	beqz	a0,80000ee8 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ea6:	416485b3          	sub	a1,s1,s6
    80000eaa:	8591                	srai	a1,a1,0x4
    80000eac:	000ab783          	ld	a5,0(s5)
    80000eb0:	02f585b3          	mul	a1,a1,a5
    80000eb4:	2585                	addiw	a1,a1,1
    80000eb6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eba:	4719                	li	a4,6
    80000ebc:	6685                	lui	a3,0x1
    80000ebe:	40b905b3          	sub	a1,s2,a1
    80000ec2:	854e                	mv	a0,s3
    80000ec4:	fffff097          	auipc	ra,0xfffff
    80000ec8:	720080e7          	jalr	1824(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ecc:	19048493          	addi	s1,s1,400
    80000ed0:	fd4495e3          	bne	s1,s4,80000e9a <proc_mapstacks+0x38>
  }
}
    80000ed4:	70e2                	ld	ra,56(sp)
    80000ed6:	7442                	ld	s0,48(sp)
    80000ed8:	74a2                	ld	s1,40(sp)
    80000eda:	7902                	ld	s2,32(sp)
    80000edc:	69e2                	ld	s3,24(sp)
    80000ede:	6a42                	ld	s4,16(sp)
    80000ee0:	6aa2                	ld	s5,8(sp)
    80000ee2:	6b02                	ld	s6,0(sp)
    80000ee4:	6121                	addi	sp,sp,64
    80000ee6:	8082                	ret
      panic("kalloc");
    80000ee8:	00007517          	auipc	a0,0x7
    80000eec:	2b850513          	addi	a0,a0,696 # 800081a0 <etext+0x1a0>
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	03c080e7          	jalr	60(ra) # 80005f2c <panic>

0000000080000ef8 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000ef8:	7139                	addi	sp,sp,-64
    80000efa:	fc06                	sd	ra,56(sp)
    80000efc:	f822                	sd	s0,48(sp)
    80000efe:	f426                	sd	s1,40(sp)
    80000f00:	f04a                	sd	s2,32(sp)
    80000f02:	ec4e                	sd	s3,24(sp)
    80000f04:	e852                	sd	s4,16(sp)
    80000f06:	e456                	sd	s5,8(sp)
    80000f08:	e05a                	sd	s6,0(sp)
    80000f0a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f0c:	00007597          	auipc	a1,0x7
    80000f10:	29c58593          	addi	a1,a1,668 # 800081a8 <etext+0x1a8>
    80000f14:	00008517          	auipc	a0,0x8
    80000f18:	c7c50513          	addi	a0,a0,-900 # 80008b90 <pid_lock>
    80000f1c:	00005097          	auipc	ra,0x5
    80000f20:	48e080e7          	jalr	1166(ra) # 800063aa <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f24:	00007597          	auipc	a1,0x7
    80000f28:	28c58593          	addi	a1,a1,652 # 800081b0 <etext+0x1b0>
    80000f2c:	00008517          	auipc	a0,0x8
    80000f30:	c7c50513          	addi	a0,a0,-900 # 80008ba8 <wait_lock>
    80000f34:	00005097          	auipc	ra,0x5
    80000f38:	476080e7          	jalr	1142(ra) # 800063aa <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f3c:	00008497          	auipc	s1,0x8
    80000f40:	08448493          	addi	s1,s1,132 # 80008fc0 <proc>
      initlock(&p->lock, "proc");
    80000f44:	00007b17          	auipc	s6,0x7
    80000f48:	27cb0b13          	addi	s6,s6,636 # 800081c0 <etext+0x1c0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f4c:	8aa6                	mv	s5,s1
    80000f4e:	00007a17          	auipc	s4,0x7
    80000f52:	0b2a0a13          	addi	s4,s4,178 # 80008000 <etext>
    80000f56:	04000937          	lui	s2,0x4000
    80000f5a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f5c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5e:	0000e997          	auipc	s3,0xe
    80000f62:	46298993          	addi	s3,s3,1122 # 8000f3c0 <tickslock>
      initlock(&p->lock, "proc");
    80000f66:	85da                	mv	a1,s6
    80000f68:	8526                	mv	a0,s1
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	440080e7          	jalr	1088(ra) # 800063aa <initlock>
      p->state = UNUSED;
    80000f72:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f76:	415487b3          	sub	a5,s1,s5
    80000f7a:	8791                	srai	a5,a5,0x4
    80000f7c:	000a3703          	ld	a4,0(s4)
    80000f80:	02e787b3          	mul	a5,a5,a4
    80000f84:	2785                	addiw	a5,a5,1
    80000f86:	00d7979b          	slliw	a5,a5,0xd
    80000f8a:	40f907b3          	sub	a5,s2,a5
    80000f8e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f90:	19048493          	addi	s1,s1,400
    80000f94:	fd3499e3          	bne	s1,s3,80000f66 <procinit+0x6e>
  }
}
    80000f98:	70e2                	ld	ra,56(sp)
    80000f9a:	7442                	ld	s0,48(sp)
    80000f9c:	74a2                	ld	s1,40(sp)
    80000f9e:	7902                	ld	s2,32(sp)
    80000fa0:	69e2                	ld	s3,24(sp)
    80000fa2:	6a42                	ld	s4,16(sp)
    80000fa4:	6aa2                	ld	s5,8(sp)
    80000fa6:	6b02                	ld	s6,0(sp)
    80000fa8:	6121                	addi	sp,sp,64
    80000faa:	8082                	ret

0000000080000fac <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e422                	sd	s0,8(sp)
    80000fb0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fb2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fb4:	2501                	sext.w	a0,a0
    80000fb6:	6422                	ld	s0,8(sp)
    80000fb8:	0141                	addi	sp,sp,16
    80000fba:	8082                	ret

0000000080000fbc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000fbc:	1141                	addi	sp,sp,-16
    80000fbe:	e422                	sd	s0,8(sp)
    80000fc0:	0800                	addi	s0,sp,16
    80000fc2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fc4:	2781                	sext.w	a5,a5
    80000fc6:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fc8:	00008517          	auipc	a0,0x8
    80000fcc:	bf850513          	addi	a0,a0,-1032 # 80008bc0 <cpus>
    80000fd0:	953e                	add	a0,a0,a5
    80000fd2:	6422                	ld	s0,8(sp)
    80000fd4:	0141                	addi	sp,sp,16
    80000fd6:	8082                	ret

0000000080000fd8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000fd8:	1101                	addi	sp,sp,-32
    80000fda:	ec06                	sd	ra,24(sp)
    80000fdc:	e822                	sd	s0,16(sp)
    80000fde:	e426                	sd	s1,8(sp)
    80000fe0:	1000                	addi	s0,sp,32
  push_off();
    80000fe2:	00005097          	auipc	ra,0x5
    80000fe6:	40c080e7          	jalr	1036(ra) # 800063ee <push_off>
    80000fea:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fec:	2781                	sext.w	a5,a5
    80000fee:	079e                	slli	a5,a5,0x7
    80000ff0:	00008717          	auipc	a4,0x8
    80000ff4:	ba070713          	addi	a4,a4,-1120 # 80008b90 <pid_lock>
    80000ff8:	97ba                	add	a5,a5,a4
    80000ffa:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ffc:	00005097          	auipc	ra,0x5
    80001000:	492080e7          	jalr	1170(ra) # 8000648e <pop_off>
  return p;
}
    80001004:	8526                	mv	a0,s1
    80001006:	60e2                	ld	ra,24(sp)
    80001008:	6442                	ld	s0,16(sp)
    8000100a:	64a2                	ld	s1,8(sp)
    8000100c:	6105                	addi	sp,sp,32
    8000100e:	8082                	ret

0000000080001010 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001010:	1141                	addi	sp,sp,-16
    80001012:	e406                	sd	ra,8(sp)
    80001014:	e022                	sd	s0,0(sp)
    80001016:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	fc0080e7          	jalr	-64(ra) # 80000fd8 <myproc>
    80001020:	00005097          	auipc	ra,0x5
    80001024:	4ce080e7          	jalr	1230(ra) # 800064ee <release>

  if (first) {
    80001028:	00008797          	auipc	a5,0x8
    8000102c:	aa87a783          	lw	a5,-1368(a5) # 80008ad0 <first.1>
    80001030:	eb89                	bnez	a5,80001042 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001032:	00001097          	auipc	ra,0x1
    80001036:	d20080e7          	jalr	-736(ra) # 80001d52 <usertrapret>
}
    8000103a:	60a2                	ld	ra,8(sp)
    8000103c:	6402                	ld	s0,0(sp)
    8000103e:	0141                	addi	sp,sp,16
    80001040:	8082                	ret
    first = 0;
    80001042:	00008797          	auipc	a5,0x8
    80001046:	a807a723          	sw	zero,-1394(a5) # 80008ad0 <first.1>
    fsinit(ROOTDEV);
    8000104a:	4505                	li	a0,1
    8000104c:	00002097          	auipc	ra,0x2
    80001050:	b5c080e7          	jalr	-1188(ra) # 80002ba8 <fsinit>
    80001054:	bff9                	j	80001032 <forkret+0x22>

0000000080001056 <allocpid>:
{
    80001056:	1101                	addi	sp,sp,-32
    80001058:	ec06                	sd	ra,24(sp)
    8000105a:	e822                	sd	s0,16(sp)
    8000105c:	e426                	sd	s1,8(sp)
    8000105e:	e04a                	sd	s2,0(sp)
    80001060:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001062:	00008917          	auipc	s2,0x8
    80001066:	b2e90913          	addi	s2,s2,-1234 # 80008b90 <pid_lock>
    8000106a:	854a                	mv	a0,s2
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	3ce080e7          	jalr	974(ra) # 8000643a <acquire>
  pid = nextpid;
    80001074:	00008797          	auipc	a5,0x8
    80001078:	a6078793          	addi	a5,a5,-1440 # 80008ad4 <nextpid>
    8000107c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000107e:	0014871b          	addiw	a4,s1,1
    80001082:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001084:	854a                	mv	a0,s2
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	468080e7          	jalr	1128(ra) # 800064ee <release>
}
    8000108e:	8526                	mv	a0,s1
    80001090:	60e2                	ld	ra,24(sp)
    80001092:	6442                	ld	s0,16(sp)
    80001094:	64a2                	ld	s1,8(sp)
    80001096:	6902                	ld	s2,0(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <proc_pagetable>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
    800010a8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	724080e7          	jalr	1828(ra) # 800007ce <uvmcreate>
    800010b2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010b4:	cd39                	beqz	a0,80001112 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010b6:	4729                	li	a4,10
    800010b8:	00006697          	auipc	a3,0x6
    800010bc:	f4868693          	addi	a3,a3,-184 # 80007000 <_trampoline>
    800010c0:	6605                	lui	a2,0x1
    800010c2:	040005b7          	lui	a1,0x4000
    800010c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c8:	05b2                	slli	a1,a1,0xc
    800010ca:	fffff097          	auipc	ra,0xfffff
    800010ce:	47a080e7          	jalr	1146(ra) # 80000544 <mappages>
    800010d2:	04054763          	bltz	a0,80001120 <proc_pagetable+0x84>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    800010d6:	4749                	li	a4,18
    800010d8:	17093683          	ld	a3,368(s2)
    800010dc:	6605                	lui	a2,0x1
    800010de:	040005b7          	lui	a1,0x4000
    800010e2:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800010e4:	05b2                	slli	a1,a1,0xc
    800010e6:	8526                	mv	a0,s1
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	45c080e7          	jalr	1116(ra) # 80000544 <mappages>
    800010f0:	04054063          	bltz	a0,80001130 <proc_pagetable+0x94>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010f4:	4719                	li	a4,6
    800010f6:	05893683          	ld	a3,88(s2)
    800010fa:	6605                	lui	a2,0x1
    800010fc:	020005b7          	lui	a1,0x2000
    80001100:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001102:	05b6                	slli	a1,a1,0xd
    80001104:	8526                	mv	a0,s1
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	43e080e7          	jalr	1086(ra) # 80000544 <mappages>
    8000110e:	04054f63          	bltz	a0,8000116c <proc_pagetable+0xd0>
}
    80001112:	8526                	mv	a0,s1
    80001114:	60e2                	ld	ra,24(sp)
    80001116:	6442                	ld	s0,16(sp)
    80001118:	64a2                	ld	s1,8(sp)
    8000111a:	6902                	ld	s2,0(sp)
    8000111c:	6105                	addi	sp,sp,32
    8000111e:	8082                	ret
    uvmfree(pagetable, 0);
    80001120:	4581                	li	a1,0
    80001122:	8526                	mv	a0,s1
    80001124:	00000097          	auipc	ra,0x0
    80001128:	9ac080e7          	jalr	-1620(ra) # 80000ad0 <uvmfree>
    return 0;
    8000112c:	4481                	li	s1,0
    8000112e:	b7d5                	j	80001112 <proc_pagetable+0x76>
      uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001130:	4681                	li	a3,0
    80001132:	4605                	li	a2,1
    80001134:	040005b7          	lui	a1,0x4000
    80001138:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000113a:	05b2                	slli	a1,a1,0xc
    8000113c:	8526                	mv	a0,s1
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	5cc080e7          	jalr	1484(ra) # 8000070a <uvmunmap>
      uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001146:	4681                	li	a3,0
    80001148:	4605                	li	a2,1
    8000114a:	020005b7          	lui	a1,0x2000
    8000114e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001150:	05b6                	slli	a1,a1,0xd
    80001152:	8526                	mv	a0,s1
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	5b6080e7          	jalr	1462(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    8000115c:	4581                	li	a1,0
    8000115e:	8526                	mv	a0,s1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	970080e7          	jalr	-1680(ra) # 80000ad0 <uvmfree>
    return 0;
    80001168:	4481                	li	s1,0
    8000116a:	b765                	j	80001112 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000116c:	4681                	li	a3,0
    8000116e:	4605                	li	a2,1
    80001170:	040005b7          	lui	a1,0x4000
    80001174:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001176:	05b2                	slli	a1,a1,0xc
    80001178:	8526                	mv	a0,s1
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	590080e7          	jalr	1424(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80001182:	4581                	li	a1,0
    80001184:	8526                	mv	a0,s1
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	94a080e7          	jalr	-1718(ra) # 80000ad0 <uvmfree>
    return 0;
    8000118e:	4481                	li	s1,0
    80001190:	b749                	j	80001112 <proc_pagetable+0x76>

0000000080001192 <proc_freepagetable>:
{
    80001192:	7179                	addi	sp,sp,-48
    80001194:	f406                	sd	ra,40(sp)
    80001196:	f022                	sd	s0,32(sp)
    80001198:	ec26                	sd	s1,24(sp)
    8000119a:	e84a                	sd	s2,16(sp)
    8000119c:	e44e                	sd	s3,8(sp)
    8000119e:	1800                	addi	s0,sp,48
    800011a0:	84aa                	mv	s1,a0
    800011a2:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011a4:	4681                	li	a3,0
    800011a6:	4605                	li	a2,1
    800011a8:	04000937          	lui	s2,0x4000
    800011ac:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800011b0:	05b2                	slli	a1,a1,0xc
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	558080e7          	jalr	1368(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011ba:	4681                	li	a3,0
    800011bc:	4605                	li	a2,1
    800011be:	020005b7          	lui	a1,0x2000
    800011c2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011c4:	05b6                	slli	a1,a1,0xd
    800011c6:	8526                	mv	a0,s1
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	542080e7          	jalr	1346(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800011d0:	4681                	li	a3,0
    800011d2:	4605                	li	a2,1
    800011d4:	1975                	addi	s2,s2,-3
    800011d6:	00c91593          	slli	a1,s2,0xc
    800011da:	8526                	mv	a0,s1
    800011dc:	fffff097          	auipc	ra,0xfffff
    800011e0:	52e080e7          	jalr	1326(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    800011e4:	85ce                	mv	a1,s3
    800011e6:	8526                	mv	a0,s1
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	8e8080e7          	jalr	-1816(ra) # 80000ad0 <uvmfree>
}
    800011f0:	70a2                	ld	ra,40(sp)
    800011f2:	7402                	ld	s0,32(sp)
    800011f4:	64e2                	ld	s1,24(sp)
    800011f6:	6942                	ld	s2,16(sp)
    800011f8:	69a2                	ld	s3,8(sp)
    800011fa:	6145                	addi	sp,sp,48
    800011fc:	8082                	ret

00000000800011fe <freeproc>:
{
    800011fe:	1101                	addi	sp,sp,-32
    80001200:	ec06                	sd	ra,24(sp)
    80001202:	e822                	sd	s0,16(sp)
    80001204:	e426                	sd	s1,8(sp)
    80001206:	1000                	addi	s0,sp,32
    80001208:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000120a:	6d28                	ld	a0,88(a0)
    8000120c:	c509                	beqz	a0,80001216 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	e0e080e7          	jalr	-498(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001216:	0404bc23          	sd	zero,88(s1)
  if(p->usyspage){
    8000121a:	1704b503          	ld	a0,368(s1)
    8000121e:	c519                	beqz	a0,8000122c <freeproc+0x2e>
    kfree((void*)p->usyspage);
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	dfc080e7          	jalr	-516(ra) # 8000001c <kfree>
  p->usyspage = 0;
    80001228:	1604b823          	sd	zero,368(s1)
  if(p->pagetable)
    8000122c:	68a8                	ld	a0,80(s1)
    8000122e:	c511                	beqz	a0,8000123a <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    80001230:	64ac                	ld	a1,72(s1)
    80001232:	00000097          	auipc	ra,0x0
    80001236:	f60080e7          	jalr	-160(ra) # 80001192 <proc_freepagetable>
  p->pagetable = 0;
    8000123a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000123e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001242:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001246:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000124a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000124e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001252:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001256:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000125a:	0004ac23          	sw	zero,24(s1)
}
    8000125e:	60e2                	ld	ra,24(sp)
    80001260:	6442                	ld	s0,16(sp)
    80001262:	64a2                	ld	s1,8(sp)
    80001264:	6105                	addi	sp,sp,32
    80001266:	8082                	ret

0000000080001268 <allocproc>:
{
    80001268:	1101                	addi	sp,sp,-32
    8000126a:	ec06                	sd	ra,24(sp)
    8000126c:	e822                	sd	s0,16(sp)
    8000126e:	e426                	sd	s1,8(sp)
    80001270:	e04a                	sd	s2,0(sp)
    80001272:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001274:	00008497          	auipc	s1,0x8
    80001278:	d4c48493          	addi	s1,s1,-692 # 80008fc0 <proc>
    8000127c:	0000e917          	auipc	s2,0xe
    80001280:	14490913          	addi	s2,s2,324 # 8000f3c0 <tickslock>
    acquire(&p->lock);
    80001284:	8526                	mv	a0,s1
    80001286:	00005097          	auipc	ra,0x5
    8000128a:	1b4080e7          	jalr	436(ra) # 8000643a <acquire>
    if(p->state == UNUSED) {
    8000128e:	4c9c                	lw	a5,24(s1)
    80001290:	cf81                	beqz	a5,800012a8 <allocproc+0x40>
      release(&p->lock);
    80001292:	8526                	mv	a0,s1
    80001294:	00005097          	auipc	ra,0x5
    80001298:	25a080e7          	jalr	602(ra) # 800064ee <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000129c:	19048493          	addi	s1,s1,400
    800012a0:	ff2492e3          	bne	s1,s2,80001284 <allocproc+0x1c>
  return 0;
    800012a4:	4481                	li	s1,0
    800012a6:	a885                	j	80001316 <allocproc+0xae>
  p->pid = allocpid();
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	dae080e7          	jalr	-594(ra) # 80001056 <allocpid>
    800012b0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012b2:	4785                	li	a5,1
    800012b4:	cc9c                	sw	a5,24(s1)
  p->tick_counter=0;
    800012b6:	1804a423          	sw	zero,392(s1)
  p->alarm_handler = -1;
    800012ba:	57fd                	li	a5,-1
    800012bc:	18f4b023          	sd	a5,384(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	e5a080e7          	jalr	-422(ra) # 8000011a <kalloc>
    800012c8:	892a                	mv	s2,a0
    800012ca:	eca8                	sd	a0,88(s1)
    800012cc:	cd21                	beqz	a0,80001324 <allocproc+0xbc>
  if((p->usyspage = (struct usyscall *)kalloc()) == 0){
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	e4c080e7          	jalr	-436(ra) # 8000011a <kalloc>
    800012d6:	892a                	mv	s2,a0
    800012d8:	16a4b823          	sd	a0,368(s1)
    800012dc:	c125                	beqz	a0,8000133c <allocproc+0xd4>
  p->usyspage->pid=p->pid;
    800012de:	589c                	lw	a5,48(s1)
    800012e0:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    800012e2:	8526                	mv	a0,s1
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	db8080e7          	jalr	-584(ra) # 8000109c <proc_pagetable>
    800012ec:	892a                	mv	s2,a0
    800012ee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012f0:	c135                	beqz	a0,80001354 <allocproc+0xec>
  memset(&p->context, 0, sizeof(p->context));
    800012f2:	07000613          	li	a2,112
    800012f6:	4581                	li	a1,0
    800012f8:	06048513          	addi	a0,s1,96
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	e7e080e7          	jalr	-386(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001304:	00000797          	auipc	a5,0x0
    80001308:	d0c78793          	addi	a5,a5,-756 # 80001010 <forkret>
    8000130c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000130e:	60bc                	ld	a5,64(s1)
    80001310:	6705                	lui	a4,0x1
    80001312:	97ba                	add	a5,a5,a4
    80001314:	f4bc                	sd	a5,104(s1)
}
    80001316:	8526                	mv	a0,s1
    80001318:	60e2                	ld	ra,24(sp)
    8000131a:	6442                	ld	s0,16(sp)
    8000131c:	64a2                	ld	s1,8(sp)
    8000131e:	6902                	ld	s2,0(sp)
    80001320:	6105                	addi	sp,sp,32
    80001322:	8082                	ret
    freeproc(p);
    80001324:	8526                	mv	a0,s1
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	ed8080e7          	jalr	-296(ra) # 800011fe <freeproc>
    release(&p->lock);
    8000132e:	8526                	mv	a0,s1
    80001330:	00005097          	auipc	ra,0x5
    80001334:	1be080e7          	jalr	446(ra) # 800064ee <release>
    return 0;
    80001338:	84ca                	mv	s1,s2
    8000133a:	bff1                	j	80001316 <allocproc+0xae>
    freeproc(p);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00000097          	auipc	ra,0x0
    80001342:	ec0080e7          	jalr	-320(ra) # 800011fe <freeproc>
    release(&p->lock);
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	1a6080e7          	jalr	422(ra) # 800064ee <release>
    return 0;
    80001350:	84ca                	mv	s1,s2
    80001352:	b7d1                	j	80001316 <allocproc+0xae>
    freeproc(p);
    80001354:	8526                	mv	a0,s1
    80001356:	00000097          	auipc	ra,0x0
    8000135a:	ea8080e7          	jalr	-344(ra) # 800011fe <freeproc>
    release(&p->lock);
    8000135e:	8526                	mv	a0,s1
    80001360:	00005097          	auipc	ra,0x5
    80001364:	18e080e7          	jalr	398(ra) # 800064ee <release>
    return 0;
    80001368:	84ca                	mv	s1,s2
    8000136a:	b775                	j	80001316 <allocproc+0xae>

000000008000136c <userinit>:
{
    8000136c:	1101                	addi	sp,sp,-32
    8000136e:	ec06                	sd	ra,24(sp)
    80001370:	e822                	sd	s0,16(sp)
    80001372:	e426                	sd	s1,8(sp)
    80001374:	1000                	addi	s0,sp,32
  p = allocproc();
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	ef2080e7          	jalr	-270(ra) # 80001268 <allocproc>
    8000137e:	84aa                	mv	s1,a0
  initproc = p;
    80001380:	00007797          	auipc	a5,0x7
    80001384:	7ca7b823          	sd	a0,2000(a5) # 80008b50 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001388:	03400613          	li	a2,52
    8000138c:	00007597          	auipc	a1,0x7
    80001390:	75458593          	addi	a1,a1,1876 # 80008ae0 <initcode>
    80001394:	6928                	ld	a0,80(a0)
    80001396:	fffff097          	auipc	ra,0xfffff
    8000139a:	466080e7          	jalr	1126(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000139e:	6785                	lui	a5,0x1
    800013a0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013a2:	6cb8                	ld	a4,88(s1)
    800013a4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013a8:	6cb8                	ld	a4,88(s1)
    800013aa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013ac:	4641                	li	a2,16
    800013ae:	00007597          	auipc	a1,0x7
    800013b2:	e1a58593          	addi	a1,a1,-486 # 800081c8 <etext+0x1c8>
    800013b6:	15848513          	addi	a0,s1,344
    800013ba:	fffff097          	auipc	ra,0xfffff
    800013be:	f08080e7          	jalr	-248(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800013c2:	00007517          	auipc	a0,0x7
    800013c6:	e1650513          	addi	a0,a0,-490 # 800081d8 <etext+0x1d8>
    800013ca:	00002097          	auipc	ra,0x2
    800013ce:	1fc080e7          	jalr	508(ra) # 800035c6 <namei>
    800013d2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013d6:	478d                	li	a5,3
    800013d8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013da:	8526                	mv	a0,s1
    800013dc:	00005097          	auipc	ra,0x5
    800013e0:	112080e7          	jalr	274(ra) # 800064ee <release>
}
    800013e4:	60e2                	ld	ra,24(sp)
    800013e6:	6442                	ld	s0,16(sp)
    800013e8:	64a2                	ld	s1,8(sp)
    800013ea:	6105                	addi	sp,sp,32
    800013ec:	8082                	ret

00000000800013ee <growproc>:
{
    800013ee:	1101                	addi	sp,sp,-32
    800013f0:	ec06                	sd	ra,24(sp)
    800013f2:	e822                	sd	s0,16(sp)
    800013f4:	e426                	sd	s1,8(sp)
    800013f6:	e04a                	sd	s2,0(sp)
    800013f8:	1000                	addi	s0,sp,32
    800013fa:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	bdc080e7          	jalr	-1060(ra) # 80000fd8 <myproc>
    80001404:	84aa                	mv	s1,a0
  sz = p->sz;
    80001406:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001408:	01204c63          	bgtz	s2,80001420 <growproc+0x32>
  } else if(n < 0){
    8000140c:	02094663          	bltz	s2,80001438 <growproc+0x4a>
  p->sz = sz;
    80001410:	e4ac                	sd	a1,72(s1)
  return 0;
    80001412:	4501                	li	a0,0
}
    80001414:	60e2                	ld	ra,24(sp)
    80001416:	6442                	ld	s0,16(sp)
    80001418:	64a2                	ld	s1,8(sp)
    8000141a:	6902                	ld	s2,0(sp)
    8000141c:	6105                	addi	sp,sp,32
    8000141e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001420:	4691                	li	a3,4
    80001422:	00b90633          	add	a2,s2,a1
    80001426:	6928                	ld	a0,80(a0)
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	48e080e7          	jalr	1166(ra) # 800008b6 <uvmalloc>
    80001430:	85aa                	mv	a1,a0
    80001432:	fd79                	bnez	a0,80001410 <growproc+0x22>
      return -1;
    80001434:	557d                	li	a0,-1
    80001436:	bff9                	j	80001414 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001438:	00b90633          	add	a2,s2,a1
    8000143c:	6928                	ld	a0,80(a0)
    8000143e:	fffff097          	auipc	ra,0xfffff
    80001442:	430080e7          	jalr	1072(ra) # 8000086e <uvmdealloc>
    80001446:	85aa                	mv	a1,a0
    80001448:	b7e1                	j	80001410 <growproc+0x22>

000000008000144a <fork>:
{
    8000144a:	7139                	addi	sp,sp,-64
    8000144c:	fc06                	sd	ra,56(sp)
    8000144e:	f822                	sd	s0,48(sp)
    80001450:	f426                	sd	s1,40(sp)
    80001452:	f04a                	sd	s2,32(sp)
    80001454:	ec4e                	sd	s3,24(sp)
    80001456:	e852                	sd	s4,16(sp)
    80001458:	e456                	sd	s5,8(sp)
    8000145a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	b7c080e7          	jalr	-1156(ra) # 80000fd8 <myproc>
    80001464:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	e02080e7          	jalr	-510(ra) # 80001268 <allocproc>
    8000146e:	12050063          	beqz	a0,8000158e <fork+0x144>
    80001472:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001474:	048ab603          	ld	a2,72(s5)
    80001478:	692c                	ld	a1,80(a0)
    8000147a:	050ab503          	ld	a0,80(s5)
    8000147e:	fffff097          	auipc	ra,0xfffff
    80001482:	68c080e7          	jalr	1676(ra) # 80000b0a <uvmcopy>
    80001486:	04054c63          	bltz	a0,800014de <fork+0x94>
  np->sz = p->sz;
    8000148a:	048ab783          	ld	a5,72(s5)
    8000148e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001492:	058ab683          	ld	a3,88(s5)
    80001496:	87b6                	mv	a5,a3
    80001498:	0589b703          	ld	a4,88(s3)
    8000149c:	12068693          	addi	a3,a3,288
    800014a0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014a4:	6788                	ld	a0,8(a5)
    800014a6:	6b8c                	ld	a1,16(a5)
    800014a8:	6f90                	ld	a2,24(a5)
    800014aa:	01073023          	sd	a6,0(a4)
    800014ae:	e708                	sd	a0,8(a4)
    800014b0:	eb0c                	sd	a1,16(a4)
    800014b2:	ef10                	sd	a2,24(a4)
    800014b4:	02078793          	addi	a5,a5,32
    800014b8:	02070713          	addi	a4,a4,32
    800014bc:	fed792e3          	bne	a5,a3,800014a0 <fork+0x56>
  np->trace_mask=p->trace_mask;
    800014c0:	168aa783          	lw	a5,360(s5)
    800014c4:	16f9a423          	sw	a5,360(s3)
  np->trapframe->a0 = 0;
    800014c8:	0589b783          	ld	a5,88(s3)
    800014cc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014d0:	0d0a8493          	addi	s1,s5,208
    800014d4:	0d098913          	addi	s2,s3,208
    800014d8:	150a8a13          	addi	s4,s5,336
    800014dc:	a00d                	j	800014fe <fork+0xb4>
    freeproc(np);
    800014de:	854e                	mv	a0,s3
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	d1e080e7          	jalr	-738(ra) # 800011fe <freeproc>
    release(&np->lock);
    800014e8:	854e                	mv	a0,s3
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	004080e7          	jalr	4(ra) # 800064ee <release>
    return -1;
    800014f2:	597d                	li	s2,-1
    800014f4:	a059                	j	8000157a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800014f6:	04a1                	addi	s1,s1,8
    800014f8:	0921                	addi	s2,s2,8
    800014fa:	01448b63          	beq	s1,s4,80001510 <fork+0xc6>
    if(p->ofile[i])
    800014fe:	6088                	ld	a0,0(s1)
    80001500:	d97d                	beqz	a0,800014f6 <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001502:	00002097          	auipc	ra,0x2
    80001506:	736080e7          	jalr	1846(ra) # 80003c38 <filedup>
    8000150a:	00a93023          	sd	a0,0(s2)
    8000150e:	b7e5                	j	800014f6 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001510:	150ab503          	ld	a0,336(s5)
    80001514:	00002097          	auipc	ra,0x2
    80001518:	8ce080e7          	jalr	-1842(ra) # 80002de2 <idup>
    8000151c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001520:	4641                	li	a2,16
    80001522:	158a8593          	addi	a1,s5,344
    80001526:	15898513          	addi	a0,s3,344
    8000152a:	fffff097          	auipc	ra,0xfffff
    8000152e:	d98080e7          	jalr	-616(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001532:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001536:	854e                	mv	a0,s3
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	fb6080e7          	jalr	-74(ra) # 800064ee <release>
  acquire(&wait_lock);
    80001540:	00007497          	auipc	s1,0x7
    80001544:	66848493          	addi	s1,s1,1640 # 80008ba8 <wait_lock>
    80001548:	8526                	mv	a0,s1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	ef0080e7          	jalr	-272(ra) # 8000643a <acquire>
  np->parent = p;
    80001552:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001556:	8526                	mv	a0,s1
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	f96080e7          	jalr	-106(ra) # 800064ee <release>
  acquire(&np->lock);
    80001560:	854e                	mv	a0,s3
    80001562:	00005097          	auipc	ra,0x5
    80001566:	ed8080e7          	jalr	-296(ra) # 8000643a <acquire>
  np->state = RUNNABLE;
    8000156a:	478d                	li	a5,3
    8000156c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001570:	854e                	mv	a0,s3
    80001572:	00005097          	auipc	ra,0x5
    80001576:	f7c080e7          	jalr	-132(ra) # 800064ee <release>
}
    8000157a:	854a                	mv	a0,s2
    8000157c:	70e2                	ld	ra,56(sp)
    8000157e:	7442                	ld	s0,48(sp)
    80001580:	74a2                	ld	s1,40(sp)
    80001582:	7902                	ld	s2,32(sp)
    80001584:	69e2                	ld	s3,24(sp)
    80001586:	6a42                	ld	s4,16(sp)
    80001588:	6aa2                	ld	s5,8(sp)
    8000158a:	6121                	addi	sp,sp,64
    8000158c:	8082                	ret
    return -1;
    8000158e:	597d                	li	s2,-1
    80001590:	b7ed                	j	8000157a <fork+0x130>

0000000080001592 <scheduler>:
{
    80001592:	7139                	addi	sp,sp,-64
    80001594:	fc06                	sd	ra,56(sp)
    80001596:	f822                	sd	s0,48(sp)
    80001598:	f426                	sd	s1,40(sp)
    8000159a:	f04a                	sd	s2,32(sp)
    8000159c:	ec4e                	sd	s3,24(sp)
    8000159e:	e852                	sd	s4,16(sp)
    800015a0:	e456                	sd	s5,8(sp)
    800015a2:	e05a                	sd	s6,0(sp)
    800015a4:	0080                	addi	s0,sp,64
    800015a6:	8792                	mv	a5,tp
  int id = r_tp();
    800015a8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015aa:	00779a93          	slli	s5,a5,0x7
    800015ae:	00007717          	auipc	a4,0x7
    800015b2:	5e270713          	addi	a4,a4,1506 # 80008b90 <pid_lock>
    800015b6:	9756                	add	a4,a4,s5
    800015b8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015bc:	00007717          	auipc	a4,0x7
    800015c0:	60c70713          	addi	a4,a4,1548 # 80008bc8 <cpus+0x8>
    800015c4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015c6:	498d                	li	s3,3
        p->state = RUNNING;
    800015c8:	4b11                	li	s6,4
        c->proc = p;
    800015ca:	079e                	slli	a5,a5,0x7
    800015cc:	00007a17          	auipc	s4,0x7
    800015d0:	5c4a0a13          	addi	s4,s4,1476 # 80008b90 <pid_lock>
    800015d4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015d6:	0000e917          	auipc	s2,0xe
    800015da:	dea90913          	addi	s2,s2,-534 # 8000f3c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015e6:	10079073          	csrw	sstatus,a5
    800015ea:	00008497          	auipc	s1,0x8
    800015ee:	9d648493          	addi	s1,s1,-1578 # 80008fc0 <proc>
    800015f2:	a811                	j	80001606 <scheduler+0x74>
      release(&p->lock);
    800015f4:	8526                	mv	a0,s1
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	ef8080e7          	jalr	-264(ra) # 800064ee <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015fe:	19048493          	addi	s1,s1,400
    80001602:	fd248ee3          	beq	s1,s2,800015de <scheduler+0x4c>
      acquire(&p->lock);
    80001606:	8526                	mv	a0,s1
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	e32080e7          	jalr	-462(ra) # 8000643a <acquire>
      if(p->state == RUNNABLE) {
    80001610:	4c9c                	lw	a5,24(s1)
    80001612:	ff3791e3          	bne	a5,s3,800015f4 <scheduler+0x62>
        p->state = RUNNING;
    80001616:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000161a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000161e:	06048593          	addi	a1,s1,96
    80001622:	8556                	mv	a0,s5
    80001624:	00000097          	auipc	ra,0x0
    80001628:	684080e7          	jalr	1668(ra) # 80001ca8 <swtch>
        c->proc = 0;
    8000162c:	020a3823          	sd	zero,48(s4)
    80001630:	b7d1                	j	800015f4 <scheduler+0x62>

0000000080001632 <sched>:
{
    80001632:	7179                	addi	sp,sp,-48
    80001634:	f406                	sd	ra,40(sp)
    80001636:	f022                	sd	s0,32(sp)
    80001638:	ec26                	sd	s1,24(sp)
    8000163a:	e84a                	sd	s2,16(sp)
    8000163c:	e44e                	sd	s3,8(sp)
    8000163e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	998080e7          	jalr	-1640(ra) # 80000fd8 <myproc>
    80001648:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	d76080e7          	jalr	-650(ra) # 800063c0 <holding>
    80001652:	c93d                	beqz	a0,800016c8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001654:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001656:	2781                	sext.w	a5,a5
    80001658:	079e                	slli	a5,a5,0x7
    8000165a:	00007717          	auipc	a4,0x7
    8000165e:	53670713          	addi	a4,a4,1334 # 80008b90 <pid_lock>
    80001662:	97ba                	add	a5,a5,a4
    80001664:	0a87a703          	lw	a4,168(a5)
    80001668:	4785                	li	a5,1
    8000166a:	06f71763          	bne	a4,a5,800016d8 <sched+0xa6>
  if(p->state == RUNNING)
    8000166e:	4c98                	lw	a4,24(s1)
    80001670:	4791                	li	a5,4
    80001672:	06f70b63          	beq	a4,a5,800016e8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001676:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000167a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000167c:	efb5                	bnez	a5,800016f8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000167e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001680:	00007917          	auipc	s2,0x7
    80001684:	51090913          	addi	s2,s2,1296 # 80008b90 <pid_lock>
    80001688:	2781                	sext.w	a5,a5
    8000168a:	079e                	slli	a5,a5,0x7
    8000168c:	97ca                	add	a5,a5,s2
    8000168e:	0ac7a983          	lw	s3,172(a5)
    80001692:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001694:	2781                	sext.w	a5,a5
    80001696:	079e                	slli	a5,a5,0x7
    80001698:	00007597          	auipc	a1,0x7
    8000169c:	53058593          	addi	a1,a1,1328 # 80008bc8 <cpus+0x8>
    800016a0:	95be                	add	a1,a1,a5
    800016a2:	06048513          	addi	a0,s1,96
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	602080e7          	jalr	1538(ra) # 80001ca8 <swtch>
    800016ae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016b0:	2781                	sext.w	a5,a5
    800016b2:	079e                	slli	a5,a5,0x7
    800016b4:	993e                	add	s2,s2,a5
    800016b6:	0b392623          	sw	s3,172(s2)
}
    800016ba:	70a2                	ld	ra,40(sp)
    800016bc:	7402                	ld	s0,32(sp)
    800016be:	64e2                	ld	s1,24(sp)
    800016c0:	6942                	ld	s2,16(sp)
    800016c2:	69a2                	ld	s3,8(sp)
    800016c4:	6145                	addi	sp,sp,48
    800016c6:	8082                	ret
    panic("sched p->lock");
    800016c8:	00007517          	auipc	a0,0x7
    800016cc:	b1850513          	addi	a0,a0,-1256 # 800081e0 <etext+0x1e0>
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	85c080e7          	jalr	-1956(ra) # 80005f2c <panic>
    panic("sched locks");
    800016d8:	00007517          	auipc	a0,0x7
    800016dc:	b1850513          	addi	a0,a0,-1256 # 800081f0 <etext+0x1f0>
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	84c080e7          	jalr	-1972(ra) # 80005f2c <panic>
    panic("sched running");
    800016e8:	00007517          	auipc	a0,0x7
    800016ec:	b1850513          	addi	a0,a0,-1256 # 80008200 <etext+0x200>
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	83c080e7          	jalr	-1988(ra) # 80005f2c <panic>
    panic("sched interruptible");
    800016f8:	00007517          	auipc	a0,0x7
    800016fc:	b1850513          	addi	a0,a0,-1256 # 80008210 <etext+0x210>
    80001700:	00005097          	auipc	ra,0x5
    80001704:	82c080e7          	jalr	-2004(ra) # 80005f2c <panic>

0000000080001708 <yield>:
{
    80001708:	1101                	addi	sp,sp,-32
    8000170a:	ec06                	sd	ra,24(sp)
    8000170c:	e822                	sd	s0,16(sp)
    8000170e:	e426                	sd	s1,8(sp)
    80001710:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001712:	00000097          	auipc	ra,0x0
    80001716:	8c6080e7          	jalr	-1850(ra) # 80000fd8 <myproc>
    8000171a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	d1e080e7          	jalr	-738(ra) # 8000643a <acquire>
  p->state = RUNNABLE;
    80001724:	478d                	li	a5,3
    80001726:	cc9c                	sw	a5,24(s1)
  sched();
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	f0a080e7          	jalr	-246(ra) # 80001632 <sched>
  release(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	dbc080e7          	jalr	-580(ra) # 800064ee <release>
}
    8000173a:	60e2                	ld	ra,24(sp)
    8000173c:	6442                	ld	s0,16(sp)
    8000173e:	64a2                	ld	s1,8(sp)
    80001740:	6105                	addi	sp,sp,32
    80001742:	8082                	ret

0000000080001744 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001744:	7179                	addi	sp,sp,-48
    80001746:	f406                	sd	ra,40(sp)
    80001748:	f022                	sd	s0,32(sp)
    8000174a:	ec26                	sd	s1,24(sp)
    8000174c:	e84a                	sd	s2,16(sp)
    8000174e:	e44e                	sd	s3,8(sp)
    80001750:	1800                	addi	s0,sp,48
    80001752:	89aa                	mv	s3,a0
    80001754:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001756:	00000097          	auipc	ra,0x0
    8000175a:	882080e7          	jalr	-1918(ra) # 80000fd8 <myproc>
    8000175e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001760:	00005097          	auipc	ra,0x5
    80001764:	cda080e7          	jalr	-806(ra) # 8000643a <acquire>
  release(lk);
    80001768:	854a                	mv	a0,s2
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	d84080e7          	jalr	-636(ra) # 800064ee <release>

  // Go to sleep.
  p->chan = chan;
    80001772:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001776:	4789                	li	a5,2
    80001778:	cc9c                	sw	a5,24(s1)

  sched();
    8000177a:	00000097          	auipc	ra,0x0
    8000177e:	eb8080e7          	jalr	-328(ra) # 80001632 <sched>

  // Tidy up.
  p->chan = 0;
    80001782:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	d66080e7          	jalr	-666(ra) # 800064ee <release>
  acquire(lk);
    80001790:	854a                	mv	a0,s2
    80001792:	00005097          	auipc	ra,0x5
    80001796:	ca8080e7          	jalr	-856(ra) # 8000643a <acquire>
}
    8000179a:	70a2                	ld	ra,40(sp)
    8000179c:	7402                	ld	s0,32(sp)
    8000179e:	64e2                	ld	s1,24(sp)
    800017a0:	6942                	ld	s2,16(sp)
    800017a2:	69a2                	ld	s3,8(sp)
    800017a4:	6145                	addi	sp,sp,48
    800017a6:	8082                	ret

00000000800017a8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017a8:	7139                	addi	sp,sp,-64
    800017aa:	fc06                	sd	ra,56(sp)
    800017ac:	f822                	sd	s0,48(sp)
    800017ae:	f426                	sd	s1,40(sp)
    800017b0:	f04a                	sd	s2,32(sp)
    800017b2:	ec4e                	sd	s3,24(sp)
    800017b4:	e852                	sd	s4,16(sp)
    800017b6:	e456                	sd	s5,8(sp)
    800017b8:	0080                	addi	s0,sp,64
    800017ba:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017bc:	00008497          	auipc	s1,0x8
    800017c0:	80448493          	addi	s1,s1,-2044 # 80008fc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017c4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017c6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c8:	0000e917          	auipc	s2,0xe
    800017cc:	bf890913          	addi	s2,s2,-1032 # 8000f3c0 <tickslock>
    800017d0:	a811                	j	800017e4 <wakeup+0x3c>
      }
      release(&p->lock);
    800017d2:	8526                	mv	a0,s1
    800017d4:	00005097          	auipc	ra,0x5
    800017d8:	d1a080e7          	jalr	-742(ra) # 800064ee <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017dc:	19048493          	addi	s1,s1,400
    800017e0:	03248663          	beq	s1,s2,8000180c <wakeup+0x64>
    if(p != myproc()){
    800017e4:	fffff097          	auipc	ra,0xfffff
    800017e8:	7f4080e7          	jalr	2036(ra) # 80000fd8 <myproc>
    800017ec:	fea488e3          	beq	s1,a0,800017dc <wakeup+0x34>
      acquire(&p->lock);
    800017f0:	8526                	mv	a0,s1
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	c48080e7          	jalr	-952(ra) # 8000643a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017fa:	4c9c                	lw	a5,24(s1)
    800017fc:	fd379be3          	bne	a5,s3,800017d2 <wakeup+0x2a>
    80001800:	709c                	ld	a5,32(s1)
    80001802:	fd4798e3          	bne	a5,s4,800017d2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001806:	0154ac23          	sw	s5,24(s1)
    8000180a:	b7e1                	j	800017d2 <wakeup+0x2a>
    }
  }
}
    8000180c:	70e2                	ld	ra,56(sp)
    8000180e:	7442                	ld	s0,48(sp)
    80001810:	74a2                	ld	s1,40(sp)
    80001812:	7902                	ld	s2,32(sp)
    80001814:	69e2                	ld	s3,24(sp)
    80001816:	6a42                	ld	s4,16(sp)
    80001818:	6aa2                	ld	s5,8(sp)
    8000181a:	6121                	addi	sp,sp,64
    8000181c:	8082                	ret

000000008000181e <reparent>:
{
    8000181e:	7179                	addi	sp,sp,-48
    80001820:	f406                	sd	ra,40(sp)
    80001822:	f022                	sd	s0,32(sp)
    80001824:	ec26                	sd	s1,24(sp)
    80001826:	e84a                	sd	s2,16(sp)
    80001828:	e44e                	sd	s3,8(sp)
    8000182a:	e052                	sd	s4,0(sp)
    8000182c:	1800                	addi	s0,sp,48
    8000182e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001830:	00007497          	auipc	s1,0x7
    80001834:	79048493          	addi	s1,s1,1936 # 80008fc0 <proc>
      pp->parent = initproc;
    80001838:	00007a17          	auipc	s4,0x7
    8000183c:	318a0a13          	addi	s4,s4,792 # 80008b50 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001840:	0000e997          	auipc	s3,0xe
    80001844:	b8098993          	addi	s3,s3,-1152 # 8000f3c0 <tickslock>
    80001848:	a029                	j	80001852 <reparent+0x34>
    8000184a:	19048493          	addi	s1,s1,400
    8000184e:	01348d63          	beq	s1,s3,80001868 <reparent+0x4a>
    if(pp->parent == p){
    80001852:	7c9c                	ld	a5,56(s1)
    80001854:	ff279be3          	bne	a5,s2,8000184a <reparent+0x2c>
      pp->parent = initproc;
    80001858:	000a3503          	ld	a0,0(s4)
    8000185c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	f4a080e7          	jalr	-182(ra) # 800017a8 <wakeup>
    80001866:	b7d5                	j	8000184a <reparent+0x2c>
}
    80001868:	70a2                	ld	ra,40(sp)
    8000186a:	7402                	ld	s0,32(sp)
    8000186c:	64e2                	ld	s1,24(sp)
    8000186e:	6942                	ld	s2,16(sp)
    80001870:	69a2                	ld	s3,8(sp)
    80001872:	6a02                	ld	s4,0(sp)
    80001874:	6145                	addi	sp,sp,48
    80001876:	8082                	ret

0000000080001878 <exit>:
{
    80001878:	7179                	addi	sp,sp,-48
    8000187a:	f406                	sd	ra,40(sp)
    8000187c:	f022                	sd	s0,32(sp)
    8000187e:	ec26                	sd	s1,24(sp)
    80001880:	e84a                	sd	s2,16(sp)
    80001882:	e44e                	sd	s3,8(sp)
    80001884:	e052                	sd	s4,0(sp)
    80001886:	1800                	addi	s0,sp,48
    80001888:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	74e080e7          	jalr	1870(ra) # 80000fd8 <myproc>
    80001892:	89aa                	mv	s3,a0
  if(p == initproc)
    80001894:	00007797          	auipc	a5,0x7
    80001898:	2bc7b783          	ld	a5,700(a5) # 80008b50 <initproc>
    8000189c:	0d050493          	addi	s1,a0,208
    800018a0:	15050913          	addi	s2,a0,336
    800018a4:	02a79363          	bne	a5,a0,800018ca <exit+0x52>
    panic("init exiting");
    800018a8:	00007517          	auipc	a0,0x7
    800018ac:	98050513          	addi	a0,a0,-1664 # 80008228 <etext+0x228>
    800018b0:	00004097          	auipc	ra,0x4
    800018b4:	67c080e7          	jalr	1660(ra) # 80005f2c <panic>
      fileclose(f);
    800018b8:	00002097          	auipc	ra,0x2
    800018bc:	3d2080e7          	jalr	978(ra) # 80003c8a <fileclose>
      p->ofile[fd] = 0;
    800018c0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018c4:	04a1                	addi	s1,s1,8
    800018c6:	01248563          	beq	s1,s2,800018d0 <exit+0x58>
    if(p->ofile[fd]){
    800018ca:	6088                	ld	a0,0(s1)
    800018cc:	f575                	bnez	a0,800018b8 <exit+0x40>
    800018ce:	bfdd                	j	800018c4 <exit+0x4c>
  begin_op();
    800018d0:	00002097          	auipc	ra,0x2
    800018d4:	ef6080e7          	jalr	-266(ra) # 800037c6 <begin_op>
  iput(p->cwd);
    800018d8:	1509b503          	ld	a0,336(s3)
    800018dc:	00001097          	auipc	ra,0x1
    800018e0:	6fe080e7          	jalr	1790(ra) # 80002fda <iput>
  end_op();
    800018e4:	00002097          	auipc	ra,0x2
    800018e8:	f5c080e7          	jalr	-164(ra) # 80003840 <end_op>
  p->cwd = 0;
    800018ec:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018f0:	00007497          	auipc	s1,0x7
    800018f4:	2b848493          	addi	s1,s1,696 # 80008ba8 <wait_lock>
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	b40080e7          	jalr	-1216(ra) # 8000643a <acquire>
  reparent(p);
    80001902:	854e                	mv	a0,s3
    80001904:	00000097          	auipc	ra,0x0
    80001908:	f1a080e7          	jalr	-230(ra) # 8000181e <reparent>
  wakeup(p->parent);
    8000190c:	0389b503          	ld	a0,56(s3)
    80001910:	00000097          	auipc	ra,0x0
    80001914:	e98080e7          	jalr	-360(ra) # 800017a8 <wakeup>
  acquire(&p->lock);
    80001918:	854e                	mv	a0,s3
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	b20080e7          	jalr	-1248(ra) # 8000643a <acquire>
  p->xstate = status;
    80001922:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001926:	4795                	li	a5,5
    80001928:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	bc0080e7          	jalr	-1088(ra) # 800064ee <release>
  sched();
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	cfc080e7          	jalr	-772(ra) # 80001632 <sched>
  panic("zombie exit");
    8000193e:	00007517          	auipc	a0,0x7
    80001942:	8fa50513          	addi	a0,a0,-1798 # 80008238 <etext+0x238>
    80001946:	00004097          	auipc	ra,0x4
    8000194a:	5e6080e7          	jalr	1510(ra) # 80005f2c <panic>

000000008000194e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000194e:	7179                	addi	sp,sp,-48
    80001950:	f406                	sd	ra,40(sp)
    80001952:	f022                	sd	s0,32(sp)
    80001954:	ec26                	sd	s1,24(sp)
    80001956:	e84a                	sd	s2,16(sp)
    80001958:	e44e                	sd	s3,8(sp)
    8000195a:	1800                	addi	s0,sp,48
    8000195c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000195e:	00007497          	auipc	s1,0x7
    80001962:	66248493          	addi	s1,s1,1634 # 80008fc0 <proc>
    80001966:	0000e997          	auipc	s3,0xe
    8000196a:	a5a98993          	addi	s3,s3,-1446 # 8000f3c0 <tickslock>
    acquire(&p->lock);
    8000196e:	8526                	mv	a0,s1
    80001970:	00005097          	auipc	ra,0x5
    80001974:	aca080e7          	jalr	-1334(ra) # 8000643a <acquire>
    if(p->pid == pid){
    80001978:	589c                	lw	a5,48(s1)
    8000197a:	01278d63          	beq	a5,s2,80001994 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000197e:	8526                	mv	a0,s1
    80001980:	00005097          	auipc	ra,0x5
    80001984:	b6e080e7          	jalr	-1170(ra) # 800064ee <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001988:	19048493          	addi	s1,s1,400
    8000198c:	ff3491e3          	bne	s1,s3,8000196e <kill+0x20>
  }
  return -1;
    80001990:	557d                	li	a0,-1
    80001992:	a829                	j	800019ac <kill+0x5e>
      p->killed = 1;
    80001994:	4785                	li	a5,1
    80001996:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001998:	4c98                	lw	a4,24(s1)
    8000199a:	4789                	li	a5,2
    8000199c:	00f70f63          	beq	a4,a5,800019ba <kill+0x6c>
      release(&p->lock);
    800019a0:	8526                	mv	a0,s1
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	b4c080e7          	jalr	-1204(ra) # 800064ee <release>
      return 0;
    800019aa:	4501                	li	a0,0
}
    800019ac:	70a2                	ld	ra,40(sp)
    800019ae:	7402                	ld	s0,32(sp)
    800019b0:	64e2                	ld	s1,24(sp)
    800019b2:	6942                	ld	s2,16(sp)
    800019b4:	69a2                	ld	s3,8(sp)
    800019b6:	6145                	addi	sp,sp,48
    800019b8:	8082                	ret
        p->state = RUNNABLE;
    800019ba:	478d                	li	a5,3
    800019bc:	cc9c                	sw	a5,24(s1)
    800019be:	b7cd                	j	800019a0 <kill+0x52>

00000000800019c0 <setkilled>:

void
setkilled(struct proc *p)
{
    800019c0:	1101                	addi	sp,sp,-32
    800019c2:	ec06                	sd	ra,24(sp)
    800019c4:	e822                	sd	s0,16(sp)
    800019c6:	e426                	sd	s1,8(sp)
    800019c8:	1000                	addi	s0,sp,32
    800019ca:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019cc:	00005097          	auipc	ra,0x5
    800019d0:	a6e080e7          	jalr	-1426(ra) # 8000643a <acquire>
  p->killed = 1;
    800019d4:	4785                	li	a5,1
    800019d6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019d8:	8526                	mv	a0,s1
    800019da:	00005097          	auipc	ra,0x5
    800019de:	b14080e7          	jalr	-1260(ra) # 800064ee <release>
}
    800019e2:	60e2                	ld	ra,24(sp)
    800019e4:	6442                	ld	s0,16(sp)
    800019e6:	64a2                	ld	s1,8(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret

00000000800019ec <killed>:

int
killed(struct proc *p)
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	e426                	sd	s1,8(sp)
    800019f4:	e04a                	sd	s2,0(sp)
    800019f6:	1000                	addi	s0,sp,32
    800019f8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019fa:	00005097          	auipc	ra,0x5
    800019fe:	a40080e7          	jalr	-1472(ra) # 8000643a <acquire>
  k = p->killed;
    80001a02:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a06:	8526                	mv	a0,s1
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	ae6080e7          	jalr	-1306(ra) # 800064ee <release>
  return k;
}
    80001a10:	854a                	mv	a0,s2
    80001a12:	60e2                	ld	ra,24(sp)
    80001a14:	6442                	ld	s0,16(sp)
    80001a16:	64a2                	ld	s1,8(sp)
    80001a18:	6902                	ld	s2,0(sp)
    80001a1a:	6105                	addi	sp,sp,32
    80001a1c:	8082                	ret

0000000080001a1e <wait>:
{
    80001a1e:	715d                	addi	sp,sp,-80
    80001a20:	e486                	sd	ra,72(sp)
    80001a22:	e0a2                	sd	s0,64(sp)
    80001a24:	fc26                	sd	s1,56(sp)
    80001a26:	f84a                	sd	s2,48(sp)
    80001a28:	f44e                	sd	s3,40(sp)
    80001a2a:	f052                	sd	s4,32(sp)
    80001a2c:	ec56                	sd	s5,24(sp)
    80001a2e:	e85a                	sd	s6,16(sp)
    80001a30:	e45e                	sd	s7,8(sp)
    80001a32:	e062                	sd	s8,0(sp)
    80001a34:	0880                	addi	s0,sp,80
    80001a36:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	5a0080e7          	jalr	1440(ra) # 80000fd8 <myproc>
    80001a40:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a42:	00007517          	auipc	a0,0x7
    80001a46:	16650513          	addi	a0,a0,358 # 80008ba8 <wait_lock>
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	9f0080e7          	jalr	-1552(ra) # 8000643a <acquire>
    havekids = 0;
    80001a52:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a54:	4a15                	li	s4,5
        havekids = 1;
    80001a56:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a58:	0000e997          	auipc	s3,0xe
    80001a5c:	96898993          	addi	s3,s3,-1688 # 8000f3c0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a60:	00007c17          	auipc	s8,0x7
    80001a64:	148c0c13          	addi	s8,s8,328 # 80008ba8 <wait_lock>
    80001a68:	a0d1                	j	80001b2c <wait+0x10e>
          pid = pp->pid;
    80001a6a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a6e:	000b0e63          	beqz	s6,80001a8a <wait+0x6c>
    80001a72:	4691                	li	a3,4
    80001a74:	02c48613          	addi	a2,s1,44
    80001a78:	85da                	mv	a1,s6
    80001a7a:	05093503          	ld	a0,80(s2)
    80001a7e:	fffff097          	auipc	ra,0xfffff
    80001a82:	21a080e7          	jalr	538(ra) # 80000c98 <copyout>
    80001a86:	04054163          	bltz	a0,80001ac8 <wait+0xaa>
          freeproc(pp);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	772080e7          	jalr	1906(ra) # 800011fe <freeproc>
          release(&pp->lock);
    80001a94:	8526                	mv	a0,s1
    80001a96:	00005097          	auipc	ra,0x5
    80001a9a:	a58080e7          	jalr	-1448(ra) # 800064ee <release>
          release(&wait_lock);
    80001a9e:	00007517          	auipc	a0,0x7
    80001aa2:	10a50513          	addi	a0,a0,266 # 80008ba8 <wait_lock>
    80001aa6:	00005097          	auipc	ra,0x5
    80001aaa:	a48080e7          	jalr	-1464(ra) # 800064ee <release>
}
    80001aae:	854e                	mv	a0,s3
    80001ab0:	60a6                	ld	ra,72(sp)
    80001ab2:	6406                	ld	s0,64(sp)
    80001ab4:	74e2                	ld	s1,56(sp)
    80001ab6:	7942                	ld	s2,48(sp)
    80001ab8:	79a2                	ld	s3,40(sp)
    80001aba:	7a02                	ld	s4,32(sp)
    80001abc:	6ae2                	ld	s5,24(sp)
    80001abe:	6b42                	ld	s6,16(sp)
    80001ac0:	6ba2                	ld	s7,8(sp)
    80001ac2:	6c02                	ld	s8,0(sp)
    80001ac4:	6161                	addi	sp,sp,80
    80001ac6:	8082                	ret
            release(&pp->lock);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	00005097          	auipc	ra,0x5
    80001ace:	a24080e7          	jalr	-1500(ra) # 800064ee <release>
            release(&wait_lock);
    80001ad2:	00007517          	auipc	a0,0x7
    80001ad6:	0d650513          	addi	a0,a0,214 # 80008ba8 <wait_lock>
    80001ada:	00005097          	auipc	ra,0x5
    80001ade:	a14080e7          	jalr	-1516(ra) # 800064ee <release>
            return -1;
    80001ae2:	59fd                	li	s3,-1
    80001ae4:	b7e9                	j	80001aae <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ae6:	19048493          	addi	s1,s1,400
    80001aea:	03348463          	beq	s1,s3,80001b12 <wait+0xf4>
      if(pp->parent == p){
    80001aee:	7c9c                	ld	a5,56(s1)
    80001af0:	ff279be3          	bne	a5,s2,80001ae6 <wait+0xc8>
        acquire(&pp->lock);
    80001af4:	8526                	mv	a0,s1
    80001af6:	00005097          	auipc	ra,0x5
    80001afa:	944080e7          	jalr	-1724(ra) # 8000643a <acquire>
        if(pp->state == ZOMBIE){
    80001afe:	4c9c                	lw	a5,24(s1)
    80001b00:	f74785e3          	beq	a5,s4,80001a6a <wait+0x4c>
        release(&pp->lock);
    80001b04:	8526                	mv	a0,s1
    80001b06:	00005097          	auipc	ra,0x5
    80001b0a:	9e8080e7          	jalr	-1560(ra) # 800064ee <release>
        havekids = 1;
    80001b0e:	8756                	mv	a4,s5
    80001b10:	bfd9                	j	80001ae6 <wait+0xc8>
    if(!havekids || killed(p)){
    80001b12:	c31d                	beqz	a4,80001b38 <wait+0x11a>
    80001b14:	854a                	mv	a0,s2
    80001b16:	00000097          	auipc	ra,0x0
    80001b1a:	ed6080e7          	jalr	-298(ra) # 800019ec <killed>
    80001b1e:	ed09                	bnez	a0,80001b38 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b20:	85e2                	mv	a1,s8
    80001b22:	854a                	mv	a0,s2
    80001b24:	00000097          	auipc	ra,0x0
    80001b28:	c20080e7          	jalr	-992(ra) # 80001744 <sleep>
    havekids = 0;
    80001b2c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b2e:	00007497          	auipc	s1,0x7
    80001b32:	49248493          	addi	s1,s1,1170 # 80008fc0 <proc>
    80001b36:	bf65                	j	80001aee <wait+0xd0>
      release(&wait_lock);
    80001b38:	00007517          	auipc	a0,0x7
    80001b3c:	07050513          	addi	a0,a0,112 # 80008ba8 <wait_lock>
    80001b40:	00005097          	auipc	ra,0x5
    80001b44:	9ae080e7          	jalr	-1618(ra) # 800064ee <release>
      return -1;
    80001b48:	59fd                	li	s3,-1
    80001b4a:	b795                	j	80001aae <wait+0x90>

0000000080001b4c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b4c:	7179                	addi	sp,sp,-48
    80001b4e:	f406                	sd	ra,40(sp)
    80001b50:	f022                	sd	s0,32(sp)
    80001b52:	ec26                	sd	s1,24(sp)
    80001b54:	e84a                	sd	s2,16(sp)
    80001b56:	e44e                	sd	s3,8(sp)
    80001b58:	e052                	sd	s4,0(sp)
    80001b5a:	1800                	addi	s0,sp,48
    80001b5c:	84aa                	mv	s1,a0
    80001b5e:	892e                	mv	s2,a1
    80001b60:	89b2                	mv	s3,a2
    80001b62:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	474080e7          	jalr	1140(ra) # 80000fd8 <myproc>
  if(user_dst){
    80001b6c:	c08d                	beqz	s1,80001b8e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b6e:	86d2                	mv	a3,s4
    80001b70:	864e                	mv	a2,s3
    80001b72:	85ca                	mv	a1,s2
    80001b74:	6928                	ld	a0,80(a0)
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	122080e7          	jalr	290(ra) # 80000c98 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b7e:	70a2                	ld	ra,40(sp)
    80001b80:	7402                	ld	s0,32(sp)
    80001b82:	64e2                	ld	s1,24(sp)
    80001b84:	6942                	ld	s2,16(sp)
    80001b86:	69a2                	ld	s3,8(sp)
    80001b88:	6a02                	ld	s4,0(sp)
    80001b8a:	6145                	addi	sp,sp,48
    80001b8c:	8082                	ret
    memmove((char *)dst, src, len);
    80001b8e:	000a061b          	sext.w	a2,s4
    80001b92:	85ce                	mv	a1,s3
    80001b94:	854a                	mv	a0,s2
    80001b96:	ffffe097          	auipc	ra,0xffffe
    80001b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>
    return 0;
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	bff9                	j	80001b7e <either_copyout+0x32>

0000000080001ba2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ba2:	7179                	addi	sp,sp,-48
    80001ba4:	f406                	sd	ra,40(sp)
    80001ba6:	f022                	sd	s0,32(sp)
    80001ba8:	ec26                	sd	s1,24(sp)
    80001baa:	e84a                	sd	s2,16(sp)
    80001bac:	e44e                	sd	s3,8(sp)
    80001bae:	e052                	sd	s4,0(sp)
    80001bb0:	1800                	addi	s0,sp,48
    80001bb2:	892a                	mv	s2,a0
    80001bb4:	84ae                	mv	s1,a1
    80001bb6:	89b2                	mv	s3,a2
    80001bb8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	41e080e7          	jalr	1054(ra) # 80000fd8 <myproc>
  if(user_src){
    80001bc2:	c08d                	beqz	s1,80001be4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bc4:	86d2                	mv	a3,s4
    80001bc6:	864e                	mv	a2,s3
    80001bc8:	85ca                	mv	a1,s2
    80001bca:	6928                	ld	a0,80(a0)
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	158080e7          	jalr	344(ra) # 80000d24 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bd4:	70a2                	ld	ra,40(sp)
    80001bd6:	7402                	ld	s0,32(sp)
    80001bd8:	64e2                	ld	s1,24(sp)
    80001bda:	6942                	ld	s2,16(sp)
    80001bdc:	69a2                	ld	s3,8(sp)
    80001bde:	6a02                	ld	s4,0(sp)
    80001be0:	6145                	addi	sp,sp,48
    80001be2:	8082                	ret
    memmove(dst, (char*)src, len);
    80001be4:	000a061b          	sext.w	a2,s4
    80001be8:	85ce                	mv	a1,s3
    80001bea:	854a                	mv	a0,s2
    80001bec:	ffffe097          	auipc	ra,0xffffe
    80001bf0:	5ea080e7          	jalr	1514(ra) # 800001d6 <memmove>
    return 0;
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	bff9                	j	80001bd4 <either_copyin+0x32>

0000000080001bf8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bf8:	715d                	addi	sp,sp,-80
    80001bfa:	e486                	sd	ra,72(sp)
    80001bfc:	e0a2                	sd	s0,64(sp)
    80001bfe:	fc26                	sd	s1,56(sp)
    80001c00:	f84a                	sd	s2,48(sp)
    80001c02:	f44e                	sd	s3,40(sp)
    80001c04:	f052                	sd	s4,32(sp)
    80001c06:	ec56                	sd	s5,24(sp)
    80001c08:	e85a                	sd	s6,16(sp)
    80001c0a:	e45e                	sd	s7,8(sp)
    80001c0c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c0e:	00006517          	auipc	a0,0x6
    80001c12:	43a50513          	addi	a0,a0,1082 # 80008048 <etext+0x48>
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	368080e7          	jalr	872(ra) # 80005f7e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c1e:	00007497          	auipc	s1,0x7
    80001c22:	4fa48493          	addi	s1,s1,1274 # 80009118 <proc+0x158>
    80001c26:	0000e917          	auipc	s2,0xe
    80001c2a:	8f290913          	addi	s2,s2,-1806 # 8000f518 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c2e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c30:	00006997          	auipc	s3,0x6
    80001c34:	61898993          	addi	s3,s3,1560 # 80008248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    80001c38:	00006a97          	auipc	s5,0x6
    80001c3c:	618a8a93          	addi	s5,s5,1560 # 80008250 <etext+0x250>
    printf("\n");
    80001c40:	00006a17          	auipc	s4,0x6
    80001c44:	408a0a13          	addi	s4,s4,1032 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c48:	00006b97          	auipc	s7,0x6
    80001c4c:	648b8b93          	addi	s7,s7,1608 # 80008290 <states.0>
    80001c50:	a00d                	j	80001c72 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c52:	ed86a583          	lw	a1,-296(a3)
    80001c56:	8556                	mv	a0,s5
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	326080e7          	jalr	806(ra) # 80005f7e <printf>
    printf("\n");
    80001c60:	8552                	mv	a0,s4
    80001c62:	00004097          	auipc	ra,0x4
    80001c66:	31c080e7          	jalr	796(ra) # 80005f7e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c6a:	19048493          	addi	s1,s1,400
    80001c6e:	03248263          	beq	s1,s2,80001c92 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c72:	86a6                	mv	a3,s1
    80001c74:	ec04a783          	lw	a5,-320(s1)
    80001c78:	dbed                	beqz	a5,80001c6a <procdump+0x72>
      state = "???";
    80001c7a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c7c:	fcfb6be3          	bltu	s6,a5,80001c52 <procdump+0x5a>
    80001c80:	02079713          	slli	a4,a5,0x20
    80001c84:	01d75793          	srli	a5,a4,0x1d
    80001c88:	97de                	add	a5,a5,s7
    80001c8a:	6390                	ld	a2,0(a5)
    80001c8c:	f279                	bnez	a2,80001c52 <procdump+0x5a>
      state = "???";
    80001c8e:	864e                	mv	a2,s3
    80001c90:	b7c9                	j	80001c52 <procdump+0x5a>
  }
}
    80001c92:	60a6                	ld	ra,72(sp)
    80001c94:	6406                	ld	s0,64(sp)
    80001c96:	74e2                	ld	s1,56(sp)
    80001c98:	7942                	ld	s2,48(sp)
    80001c9a:	79a2                	ld	s3,40(sp)
    80001c9c:	7a02                	ld	s4,32(sp)
    80001c9e:	6ae2                	ld	s5,24(sp)
    80001ca0:	6b42                	ld	s6,16(sp)
    80001ca2:	6ba2                	ld	s7,8(sp)
    80001ca4:	6161                	addi	sp,sp,80
    80001ca6:	8082                	ret

0000000080001ca8 <swtch>:
    80001ca8:	00153023          	sd	ra,0(a0)
    80001cac:	00253423          	sd	sp,8(a0)
    80001cb0:	e900                	sd	s0,16(a0)
    80001cb2:	ed04                	sd	s1,24(a0)
    80001cb4:	03253023          	sd	s2,32(a0)
    80001cb8:	03353423          	sd	s3,40(a0)
    80001cbc:	03453823          	sd	s4,48(a0)
    80001cc0:	03553c23          	sd	s5,56(a0)
    80001cc4:	05653023          	sd	s6,64(a0)
    80001cc8:	05753423          	sd	s7,72(a0)
    80001ccc:	05853823          	sd	s8,80(a0)
    80001cd0:	05953c23          	sd	s9,88(a0)
    80001cd4:	07a53023          	sd	s10,96(a0)
    80001cd8:	07b53423          	sd	s11,104(a0)
    80001cdc:	0005b083          	ld	ra,0(a1)
    80001ce0:	0085b103          	ld	sp,8(a1)
    80001ce4:	6980                	ld	s0,16(a1)
    80001ce6:	6d84                	ld	s1,24(a1)
    80001ce8:	0205b903          	ld	s2,32(a1)
    80001cec:	0285b983          	ld	s3,40(a1)
    80001cf0:	0305ba03          	ld	s4,48(a1)
    80001cf4:	0385ba83          	ld	s5,56(a1)
    80001cf8:	0405bb03          	ld	s6,64(a1)
    80001cfc:	0485bb83          	ld	s7,72(a1)
    80001d00:	0505bc03          	ld	s8,80(a1)
    80001d04:	0585bc83          	ld	s9,88(a1)
    80001d08:	0605bd03          	ld	s10,96(a1)
    80001d0c:	0685bd83          	ld	s11,104(a1)
    80001d10:	8082                	ret

0000000080001d12 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d12:	1141                	addi	sp,sp,-16
    80001d14:	e406                	sd	ra,8(sp)
    80001d16:	e022                	sd	s0,0(sp)
    80001d18:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d1a:	00006597          	auipc	a1,0x6
    80001d1e:	5a658593          	addi	a1,a1,1446 # 800082c0 <states.0+0x30>
    80001d22:	0000d517          	auipc	a0,0xd
    80001d26:	69e50513          	addi	a0,a0,1694 # 8000f3c0 <tickslock>
    80001d2a:	00004097          	auipc	ra,0x4
    80001d2e:	680080e7          	jalr	1664(ra) # 800063aa <initlock>
}
    80001d32:	60a2                	ld	ra,8(sp)
    80001d34:	6402                	ld	s0,0(sp)
    80001d36:	0141                	addi	sp,sp,16
    80001d38:	8082                	ret

0000000080001d3a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d3a:	1141                	addi	sp,sp,-16
    80001d3c:	e422                	sd	s0,8(sp)
    80001d3e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d40:	00003797          	auipc	a5,0x3
    80001d44:	58078793          	addi	a5,a5,1408 # 800052c0 <kernelvec>
    80001d48:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d4c:	6422                	ld	s0,8(sp)
    80001d4e:	0141                	addi	sp,sp,16
    80001d50:	8082                	ret

0000000080001d52 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d52:	1141                	addi	sp,sp,-16
    80001d54:	e406                	sd	ra,8(sp)
    80001d56:	e022                	sd	s0,0(sp)
    80001d58:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	27e080e7          	jalr	638(ra) # 80000fd8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d68:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d6c:	00005697          	auipc	a3,0x5
    80001d70:	29468693          	addi	a3,a3,660 # 80007000 <_trampoline>
    80001d74:	00005717          	auipc	a4,0x5
    80001d78:	28c70713          	addi	a4,a4,652 # 80007000 <_trampoline>
    80001d7c:	8f15                	sub	a4,a4,a3
    80001d7e:	040007b7          	lui	a5,0x4000
    80001d82:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d84:	07b2                	slli	a5,a5,0xc
    80001d86:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d88:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d8c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d8e:	18002673          	csrr	a2,satp
    80001d92:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d94:	6d30                	ld	a2,88(a0)
    80001d96:	6138                	ld	a4,64(a0)
    80001d98:	6585                	lui	a1,0x1
    80001d9a:	972e                	add	a4,a4,a1
    80001d9c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d9e:	6d38                	ld	a4,88(a0)
    80001da0:	00000617          	auipc	a2,0x0
    80001da4:	13460613          	addi	a2,a2,308 # 80001ed4 <usertrap>
    80001da8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001daa:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dac:	8612                	mv	a2,tp
    80001dae:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001db4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001db8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dbc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001dc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dc2:	6f18                	ld	a4,24(a4)
    80001dc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dc8:	6928                	ld	a0,80(a0)
    80001dca:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001dcc:	00005717          	auipc	a4,0x5
    80001dd0:	2d070713          	addi	a4,a4,720 # 8000709c <userret>
    80001dd4:	8f15                	sub	a4,a4,a3
    80001dd6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001dd8:	577d                	li	a4,-1
    80001dda:	177e                	slli	a4,a4,0x3f
    80001ddc:	8d59                	or	a0,a0,a4
    80001dde:	9782                	jalr	a5
}
    80001de0:	60a2                	ld	ra,8(sp)
    80001de2:	6402                	ld	s0,0(sp)
    80001de4:	0141                	addi	sp,sp,16
    80001de6:	8082                	ret

0000000080001de8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001de8:	1101                	addi	sp,sp,-32
    80001dea:	ec06                	sd	ra,24(sp)
    80001dec:	e822                	sd	s0,16(sp)
    80001dee:	e426                	sd	s1,8(sp)
    80001df0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001df2:	0000d497          	auipc	s1,0xd
    80001df6:	5ce48493          	addi	s1,s1,1486 # 8000f3c0 <tickslock>
    80001dfa:	8526                	mv	a0,s1
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	63e080e7          	jalr	1598(ra) # 8000643a <acquire>
  ticks++;
    80001e04:	00007517          	auipc	a0,0x7
    80001e08:	d5450513          	addi	a0,a0,-684 # 80008b58 <ticks>
    80001e0c:	411c                	lw	a5,0(a0)
    80001e0e:	2785                	addiw	a5,a5,1
    80001e10:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e12:	00000097          	auipc	ra,0x0
    80001e16:	996080e7          	jalr	-1642(ra) # 800017a8 <wakeup>
  release(&tickslock);
    80001e1a:	8526                	mv	a0,s1
    80001e1c:	00004097          	auipc	ra,0x4
    80001e20:	6d2080e7          	jalr	1746(ra) # 800064ee <release>
}
    80001e24:	60e2                	ld	ra,24(sp)
    80001e26:	6442                	ld	s0,16(sp)
    80001e28:	64a2                	ld	s1,8(sp)
    80001e2a:	6105                	addi	sp,sp,32
    80001e2c:	8082                	ret

0000000080001e2e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e32:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e34:	0807df63          	bgez	a5,80001ed2 <devintr+0xa4>
{
    80001e38:	1101                	addi	sp,sp,-32
    80001e3a:	ec06                	sd	ra,24(sp)
    80001e3c:	e822                	sd	s0,16(sp)
    80001e3e:	e426                	sd	s1,8(sp)
    80001e40:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e42:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e46:	46a5                	li	a3,9
    80001e48:	00d70d63          	beq	a4,a3,80001e62 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001e4c:	577d                	li	a4,-1
    80001e4e:	177e                	slli	a4,a4,0x3f
    80001e50:	0705                	addi	a4,a4,1
    return 0;
    80001e52:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e54:	04e78e63          	beq	a5,a4,80001eb0 <devintr+0x82>
  }
}
    80001e58:	60e2                	ld	ra,24(sp)
    80001e5a:	6442                	ld	s0,16(sp)
    80001e5c:	64a2                	ld	s1,8(sp)
    80001e5e:	6105                	addi	sp,sp,32
    80001e60:	8082                	ret
    int irq = plic_claim();
    80001e62:	00003097          	auipc	ra,0x3
    80001e66:	566080e7          	jalr	1382(ra) # 800053c8 <plic_claim>
    80001e6a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e6c:	47a9                	li	a5,10
    80001e6e:	02f50763          	beq	a0,a5,80001e9c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001e72:	4785                	li	a5,1
    80001e74:	02f50963          	beq	a0,a5,80001ea6 <devintr+0x78>
    return 1;
    80001e78:	4505                	li	a0,1
    } else if(irq){
    80001e7a:	dcf9                	beqz	s1,80001e58 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e7c:	85a6                	mv	a1,s1
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	44a50513          	addi	a0,a0,1098 # 800082c8 <states.0+0x38>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	0f8080e7          	jalr	248(ra) # 80005f7e <printf>
      plic_complete(irq);
    80001e8e:	8526                	mv	a0,s1
    80001e90:	00003097          	auipc	ra,0x3
    80001e94:	55c080e7          	jalr	1372(ra) # 800053ec <plic_complete>
    return 1;
    80001e98:	4505                	li	a0,1
    80001e9a:	bf7d                	j	80001e58 <devintr+0x2a>
      uartintr();
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	4be080e7          	jalr	1214(ra) # 8000635a <uartintr>
    if(irq)
    80001ea4:	b7ed                	j	80001e8e <devintr+0x60>
      virtio_disk_intr();
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	a0c080e7          	jalr	-1524(ra) # 800058b2 <virtio_disk_intr>
    if(irq)
    80001eae:	b7c5                	j	80001e8e <devintr+0x60>
    if(cpuid() == 0){
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	0fc080e7          	jalr	252(ra) # 80000fac <cpuid>
    80001eb8:	c901                	beqz	a0,80001ec8 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001eba:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ebe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ec0:	14479073          	csrw	sip,a5
    return 2;
    80001ec4:	4509                	li	a0,2
    80001ec6:	bf49                	j	80001e58 <devintr+0x2a>
      clockintr();
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	f20080e7          	jalr	-224(ra) # 80001de8 <clockintr>
    80001ed0:	b7ed                	j	80001eba <devintr+0x8c>
}
    80001ed2:	8082                	ret

0000000080001ed4 <usertrap>:
{
    80001ed4:	1101                	addi	sp,sp,-32
    80001ed6:	ec06                	sd	ra,24(sp)
    80001ed8:	e822                	sd	s0,16(sp)
    80001eda:	e426                	sd	s1,8(sp)
    80001edc:	e04a                	sd	s2,0(sp)
    80001ede:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ee4:	1007f793          	andi	a5,a5,256
    80001ee8:	e7b9                	bnez	a5,80001f36 <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001eea:	00003797          	auipc	a5,0x3
    80001eee:	3d678793          	addi	a5,a5,982 # 800052c0 <kernelvec>
    80001ef2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	0e2080e7          	jalr	226(ra) # 80000fd8 <myproc>
    80001efe:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f00:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f02:	14102773          	csrr	a4,sepc
    80001f06:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f08:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f0c:	47a1                	li	a5,8
    80001f0e:	02f70c63          	beq	a4,a5,80001f46 <usertrap+0x72>
    80001f12:	14202773          	csrr	a4,scause
  else if(r_scause()==15 ){
    80001f16:	47bd                	li	a5,15
    80001f18:	08f70063          	beq	a4,a5,80001f98 <usertrap+0xc4>
  else if((which_dev = devintr()) != 0){
    80001f1c:	00000097          	auipc	ra,0x0
    80001f20:	f12080e7          	jalr	-238(ra) # 80001e2e <devintr>
    80001f24:	892a                	mv	s2,a0
    80001f26:	c551                	beqz	a0,80001fb2 <usertrap+0xde>
  if(killed(p))
    80001f28:	8526                	mv	a0,s1
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	ac2080e7          	jalr	-1342(ra) # 800019ec <killed>
    80001f32:	c179                	beqz	a0,80001ff8 <usertrap+0x124>
    80001f34:	a86d                	j	80001fee <usertrap+0x11a>
    panic("usertrap: not from user mode");
    80001f36:	00006517          	auipc	a0,0x6
    80001f3a:	3b250513          	addi	a0,a0,946 # 800082e8 <states.0+0x58>
    80001f3e:	00004097          	auipc	ra,0x4
    80001f42:	fee080e7          	jalr	-18(ra) # 80005f2c <panic>
    if(killed(p))
    80001f46:	00000097          	auipc	ra,0x0
    80001f4a:	aa6080e7          	jalr	-1370(ra) # 800019ec <killed>
    80001f4e:	ed1d                	bnez	a0,80001f8c <usertrap+0xb8>
    p->trapframe->epc += 4;
    80001f50:	6cb8                	ld	a4,88(s1)
    80001f52:	6f1c                	ld	a5,24(a4)
    80001f54:	0791                	addi	a5,a5,4
    80001f56:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f5c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f60:	10079073          	csrw	sstatus,a5
    syscall();
    80001f64:	00000097          	auipc	ra,0x0
    80001f68:	312080e7          	jalr	786(ra) # 80002276 <syscall>
  if(killed(p))
    80001f6c:	8526                	mv	a0,s1
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	a7e080e7          	jalr	-1410(ra) # 800019ec <killed>
    80001f76:	e93d                	bnez	a0,80001fec <usertrap+0x118>
  usertrapret();
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	dda080e7          	jalr	-550(ra) # 80001d52 <usertrapret>
}
    80001f80:	60e2                	ld	ra,24(sp)
    80001f82:	6442                	ld	s0,16(sp)
    80001f84:	64a2                	ld	s1,8(sp)
    80001f86:	6902                	ld	s2,0(sp)
    80001f88:	6105                	addi	sp,sp,32
    80001f8a:	8082                	ret
      exit(-1);
    80001f8c:	557d                	li	a0,-1
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	8ea080e7          	jalr	-1814(ra) # 80001878 <exit>
    80001f96:	bf6d                	j	80001f50 <usertrap+0x7c>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f98:	143025f3          	csrr	a1,stval
    if(uvmcow(p->pagetable,r_stval()!=0)){
    80001f9c:	00b035b3          	snez	a1,a1
    80001fa0:	6928                	ld	a0,80(a0)
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	c16080e7          	jalr	-1002(ra) # 80000bb8 <uvmcow>
    80001faa:	d169                	beqz	a0,80001f6c <usertrap+0x98>
     p->killed=1;
    80001fac:	4785                	li	a5,1
    80001fae:	d49c                	sw	a5,40(s1)
    80001fb0:	bf75                	j	80001f6c <usertrap+0x98>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fb2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fb6:	5890                	lw	a2,48(s1)
    80001fb8:	00006517          	auipc	a0,0x6
    80001fbc:	35050513          	addi	a0,a0,848 # 80008308 <states.0+0x78>
    80001fc0:	00004097          	auipc	ra,0x4
    80001fc4:	fbe080e7          	jalr	-66(ra) # 80005f7e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fc8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fcc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fd0:	00006517          	auipc	a0,0x6
    80001fd4:	36850513          	addi	a0,a0,872 # 80008338 <states.0+0xa8>
    80001fd8:	00004097          	auipc	ra,0x4
    80001fdc:	fa6080e7          	jalr	-90(ra) # 80005f7e <printf>
    setkilled(p);
    80001fe0:	8526                	mv	a0,s1
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	9de080e7          	jalr	-1570(ra) # 800019c0 <setkilled>
    80001fea:	b749                	j	80001f6c <usertrap+0x98>
  if(killed(p))
    80001fec:	4901                	li	s2,0
    exit(-1);
    80001fee:	557d                	li	a0,-1
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	888080e7          	jalr	-1912(ra) # 80001878 <exit>
  if(which_dev == 2){
    80001ff8:	4789                	li	a5,2
    80001ffa:	f6f91fe3          	bne	s2,a5,80001f78 <usertrap+0xa4>
      if(p->alarm_handler!=-1){
    80001ffe:	1804b703          	ld	a4,384(s1)
    80002002:	57fd                	li	a5,-1
    80002004:	00f70f63          	beq	a4,a5,80002022 <usertrap+0x14e>
        p->tick_counter++;
    80002008:	1884a783          	lw	a5,392(s1)
    8000200c:	2785                	addiw	a5,a5,1
    8000200e:	0007869b          	sext.w	a3,a5
    80002012:	18f4a423          	sw	a5,392(s1)
      if(p->tick_counter>=p->alarm_interval){
    80002016:	1784a783          	lw	a5,376(s1)
    8000201a:	00f6c463          	blt	a3,a5,80002022 <usertrap+0x14e>
        p->trapframe->epc=p->alarm_handler;  
    8000201e:	6cbc                	ld	a5,88(s1)
    80002020:	ef98                	sd	a4,24(a5)
    yield();
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	6e6080e7          	jalr	1766(ra) # 80001708 <yield>
    8000202a:	b7b9                	j	80001f78 <usertrap+0xa4>

000000008000202c <kerneltrap>:
{
    8000202c:	7179                	addi	sp,sp,-48
    8000202e:	f406                	sd	ra,40(sp)
    80002030:	f022                	sd	s0,32(sp)
    80002032:	ec26                	sd	s1,24(sp)
    80002034:	e84a                	sd	s2,16(sp)
    80002036:	e44e                	sd	s3,8(sp)
    80002038:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000203a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000203e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002042:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002046:	1004f793          	andi	a5,s1,256
    8000204a:	cb85                	beqz	a5,8000207a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000204c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002050:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002052:	ef85                	bnez	a5,8000208a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002054:	00000097          	auipc	ra,0x0
    80002058:	dda080e7          	jalr	-550(ra) # 80001e2e <devintr>
    8000205c:	cd1d                	beqz	a0,8000209a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000205e:	4789                	li	a5,2
    80002060:	06f50a63          	beq	a0,a5,800020d4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002064:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002068:	10049073          	csrw	sstatus,s1
}
    8000206c:	70a2                	ld	ra,40(sp)
    8000206e:	7402                	ld	s0,32(sp)
    80002070:	64e2                	ld	s1,24(sp)
    80002072:	6942                	ld	s2,16(sp)
    80002074:	69a2                	ld	s3,8(sp)
    80002076:	6145                	addi	sp,sp,48
    80002078:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	2de50513          	addi	a0,a0,734 # 80008358 <states.0+0xc8>
    80002082:	00004097          	auipc	ra,0x4
    80002086:	eaa080e7          	jalr	-342(ra) # 80005f2c <panic>
    panic("kerneltrap: interrupts enabled");
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	2f650513          	addi	a0,a0,758 # 80008380 <states.0+0xf0>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	e9a080e7          	jalr	-358(ra) # 80005f2c <panic>
    printf("scause %p\n", scause);
    8000209a:	85ce                	mv	a1,s3
    8000209c:	00006517          	auipc	a0,0x6
    800020a0:	30450513          	addi	a0,a0,772 # 800083a0 <states.0+0x110>
    800020a4:	00004097          	auipc	ra,0x4
    800020a8:	eda080e7          	jalr	-294(ra) # 80005f7e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020ac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020b0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020b4:	00006517          	auipc	a0,0x6
    800020b8:	2fc50513          	addi	a0,a0,764 # 800083b0 <states.0+0x120>
    800020bc:	00004097          	auipc	ra,0x4
    800020c0:	ec2080e7          	jalr	-318(ra) # 80005f7e <printf>
    panic("kerneltrap");
    800020c4:	00006517          	auipc	a0,0x6
    800020c8:	30450513          	addi	a0,a0,772 # 800083c8 <states.0+0x138>
    800020cc:	00004097          	auipc	ra,0x4
    800020d0:	e60080e7          	jalr	-416(ra) # 80005f2c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	f04080e7          	jalr	-252(ra) # 80000fd8 <myproc>
    800020dc:	d541                	beqz	a0,80002064 <kerneltrap+0x38>
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	efa080e7          	jalr	-262(ra) # 80000fd8 <myproc>
    800020e6:	4d18                	lw	a4,24(a0)
    800020e8:	4791                	li	a5,4
    800020ea:	f6f71de3          	bne	a4,a5,80002064 <kerneltrap+0x38>
    yield();
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	61a080e7          	jalr	1562(ra) # 80001708 <yield>
    800020f6:	b7bd                	j	80002064 <kerneltrap+0x38>

00000000800020f8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	e426                	sd	s1,8(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	ed4080e7          	jalr	-300(ra) # 80000fd8 <myproc>
  switch (n) {
    8000210c:	4795                	li	a5,5
    8000210e:	0497e163          	bltu	a5,s1,80002150 <argraw+0x58>
    80002112:	048a                	slli	s1,s1,0x2
    80002114:	00006717          	auipc	a4,0x6
    80002118:	45c70713          	addi	a4,a4,1116 # 80008570 <states.0+0x2e0>
    8000211c:	94ba                	add	s1,s1,a4
    8000211e:	409c                	lw	a5,0(s1)
    80002120:	97ba                	add	a5,a5,a4
    80002122:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002124:	6d3c                	ld	a5,88(a0)
    80002126:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	64a2                	ld	s1,8(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret
    return p->trapframe->a1;
    80002132:	6d3c                	ld	a5,88(a0)
    80002134:	7fa8                	ld	a0,120(a5)
    80002136:	bfcd                	j	80002128 <argraw+0x30>
    return p->trapframe->a2;
    80002138:	6d3c                	ld	a5,88(a0)
    8000213a:	63c8                	ld	a0,128(a5)
    8000213c:	b7f5                	j	80002128 <argraw+0x30>
    return p->trapframe->a3;
    8000213e:	6d3c                	ld	a5,88(a0)
    80002140:	67c8                	ld	a0,136(a5)
    80002142:	b7dd                	j	80002128 <argraw+0x30>
    return p->trapframe->a4;
    80002144:	6d3c                	ld	a5,88(a0)
    80002146:	6bc8                	ld	a0,144(a5)
    80002148:	b7c5                	j	80002128 <argraw+0x30>
    return p->trapframe->a5;
    8000214a:	6d3c                	ld	a5,88(a0)
    8000214c:	6fc8                	ld	a0,152(a5)
    8000214e:	bfe9                	j	80002128 <argraw+0x30>
  panic("argraw");
    80002150:	00006517          	auipc	a0,0x6
    80002154:	28850513          	addi	a0,a0,648 # 800083d8 <states.0+0x148>
    80002158:	00004097          	auipc	ra,0x4
    8000215c:	dd4080e7          	jalr	-556(ra) # 80005f2c <panic>

0000000080002160 <fetchaddr>:
{
    80002160:	1101                	addi	sp,sp,-32
    80002162:	ec06                	sd	ra,24(sp)
    80002164:	e822                	sd	s0,16(sp)
    80002166:	e426                	sd	s1,8(sp)
    80002168:	e04a                	sd	s2,0(sp)
    8000216a:	1000                	addi	s0,sp,32
    8000216c:	84aa                	mv	s1,a0
    8000216e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	e68080e7          	jalr	-408(ra) # 80000fd8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002178:	653c                	ld	a5,72(a0)
    8000217a:	02f4f863          	bgeu	s1,a5,800021aa <fetchaddr+0x4a>
    8000217e:	00848713          	addi	a4,s1,8
    80002182:	02e7e663          	bltu	a5,a4,800021ae <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002186:	46a1                	li	a3,8
    80002188:	8626                	mv	a2,s1
    8000218a:	85ca                	mv	a1,s2
    8000218c:	6928                	ld	a0,80(a0)
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	b96080e7          	jalr	-1130(ra) # 80000d24 <copyin>
    80002196:	00a03533          	snez	a0,a0
    8000219a:	40a00533          	neg	a0,a0
}
    8000219e:	60e2                	ld	ra,24(sp)
    800021a0:	6442                	ld	s0,16(sp)
    800021a2:	64a2                	ld	s1,8(sp)
    800021a4:	6902                	ld	s2,0(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret
    return -1;
    800021aa:	557d                	li	a0,-1
    800021ac:	bfcd                	j	8000219e <fetchaddr+0x3e>
    800021ae:	557d                	li	a0,-1
    800021b0:	b7fd                	j	8000219e <fetchaddr+0x3e>

00000000800021b2 <fetchstr>:
{
    800021b2:	7179                	addi	sp,sp,-48
    800021b4:	f406                	sd	ra,40(sp)
    800021b6:	f022                	sd	s0,32(sp)
    800021b8:	ec26                	sd	s1,24(sp)
    800021ba:	e84a                	sd	s2,16(sp)
    800021bc:	e44e                	sd	s3,8(sp)
    800021be:	1800                	addi	s0,sp,48
    800021c0:	892a                	mv	s2,a0
    800021c2:	84ae                	mv	s1,a1
    800021c4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	e12080e7          	jalr	-494(ra) # 80000fd8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800021ce:	86ce                	mv	a3,s3
    800021d0:	864a                	mv	a2,s2
    800021d2:	85a6                	mv	a1,s1
    800021d4:	6928                	ld	a0,80(a0)
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	bdc080e7          	jalr	-1060(ra) # 80000db2 <copyinstr>
    800021de:	00054e63          	bltz	a0,800021fa <fetchstr+0x48>
  return strlen(buf);
    800021e2:	8526                	mv	a0,s1
    800021e4:	ffffe097          	auipc	ra,0xffffe
    800021e8:	110080e7          	jalr	272(ra) # 800002f4 <strlen>
}
    800021ec:	70a2                	ld	ra,40(sp)
    800021ee:	7402                	ld	s0,32(sp)
    800021f0:	64e2                	ld	s1,24(sp)
    800021f2:	6942                	ld	s2,16(sp)
    800021f4:	69a2                	ld	s3,8(sp)
    800021f6:	6145                	addi	sp,sp,48
    800021f8:	8082                	ret
    return -1;
    800021fa:	557d                	li	a0,-1
    800021fc:	bfc5                	j	800021ec <fetchstr+0x3a>

00000000800021fe <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021fe:	1101                	addi	sp,sp,-32
    80002200:	ec06                	sd	ra,24(sp)
    80002202:	e822                	sd	s0,16(sp)
    80002204:	e426                	sd	s1,8(sp)
    80002206:	1000                	addi	s0,sp,32
    80002208:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	eee080e7          	jalr	-274(ra) # 800020f8 <argraw>
    80002212:	c088                	sw	a0,0(s1)
}
    80002214:	60e2                	ld	ra,24(sp)
    80002216:	6442                	ld	s0,16(sp)
    80002218:	64a2                	ld	s1,8(sp)
    8000221a:	6105                	addi	sp,sp,32
    8000221c:	8082                	ret

000000008000221e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000221e:	1101                	addi	sp,sp,-32
    80002220:	ec06                	sd	ra,24(sp)
    80002222:	e822                	sd	s0,16(sp)
    80002224:	e426                	sd	s1,8(sp)
    80002226:	1000                	addi	s0,sp,32
    80002228:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	ece080e7          	jalr	-306(ra) # 800020f8 <argraw>
    80002232:	e088                	sd	a0,0(s1)
}
    80002234:	60e2                	ld	ra,24(sp)
    80002236:	6442                	ld	s0,16(sp)
    80002238:	64a2                	ld	s1,8(sp)
    8000223a:	6105                	addi	sp,sp,32
    8000223c:	8082                	ret

000000008000223e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000223e:	7179                	addi	sp,sp,-48
    80002240:	f406                	sd	ra,40(sp)
    80002242:	f022                	sd	s0,32(sp)
    80002244:	ec26                	sd	s1,24(sp)
    80002246:	e84a                	sd	s2,16(sp)
    80002248:	1800                	addi	s0,sp,48
    8000224a:	84ae                	mv	s1,a1
    8000224c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000224e:	fd840593          	addi	a1,s0,-40
    80002252:	00000097          	auipc	ra,0x0
    80002256:	fcc080e7          	jalr	-52(ra) # 8000221e <argaddr>
  return fetchstr(addr, buf, max);
    8000225a:	864a                	mv	a2,s2
    8000225c:	85a6                	mv	a1,s1
    8000225e:	fd843503          	ld	a0,-40(s0)
    80002262:	00000097          	auipc	ra,0x0
    80002266:	f50080e7          	jalr	-176(ra) # 800021b2 <fetchstr>
}
    8000226a:	70a2                	ld	ra,40(sp)
    8000226c:	7402                	ld	s0,32(sp)
    8000226e:	64e2                	ld	s1,24(sp)
    80002270:	6942                	ld	s2,16(sp)
    80002272:	6145                	addi	sp,sp,48
    80002274:	8082                	ret

0000000080002276 <syscall>:
  };
  

void
syscall(void)
{
    80002276:	7179                	addi	sp,sp,-48
    80002278:	f406                	sd	ra,40(sp)
    8000227a:	f022                	sd	s0,32(sp)
    8000227c:	ec26                	sd	s1,24(sp)
    8000227e:	e84a                	sd	s2,16(sp)
    80002280:	e44e                	sd	s3,8(sp)
    80002282:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	d54080e7          	jalr	-684(ra) # 80000fd8 <myproc>
    8000228c:	84aa                	mv	s1,a0

  num =p->trapframe->a7;
    8000228e:	05853903          	ld	s2,88(a0)
    80002292:	0a893783          	ld	a5,168(s2)
    80002296:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000229a:	37fd                	addiw	a5,a5,-1
    8000229c:	4755                	li	a4,21
    8000229e:	04f76763          	bltu	a4,a5,800022ec <syscall+0x76>
    800022a2:	00399713          	slli	a4,s3,0x3
    800022a6:	00006797          	auipc	a5,0x6
    800022aa:	2e278793          	addi	a5,a5,738 # 80008588 <syscalls>
    800022ae:	97ba                	add	a5,a5,a4
    800022b0:	639c                	ld	a5,0(a5)
    800022b2:	cf8d                	beqz	a5,800022ec <syscall+0x76>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800022b4:	9782                	jalr	a5
    800022b6:	06a93823          	sd	a0,112(s2)
    if(1 << num & p->trace_mask){
    800022ba:	1684a783          	lw	a5,360(s1)
    800022be:	4137d7bb          	sraw	a5,a5,s3
    800022c2:	8b85                	andi	a5,a5,1
    800022c4:	c3b9                	beqz	a5,8000230a <syscall+0x94>
      printf("%d: syscall %s -> %d\n",
    800022c6:	6cb8                	ld	a4,88(s1)
    800022c8:	098e                	slli	s3,s3,0x3
    800022ca:	00006797          	auipc	a5,0x6
    800022ce:	2be78793          	addi	a5,a5,702 # 80008588 <syscalls>
    800022d2:	97ce                	add	a5,a5,s3
    800022d4:	7b34                	ld	a3,112(a4)
    800022d6:	7fd0                	ld	a2,184(a5)
    800022d8:	588c                	lw	a1,48(s1)
    800022da:	00006517          	auipc	a0,0x6
    800022de:	10650513          	addi	a0,a0,262 # 800083e0 <states.0+0x150>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	c9c080e7          	jalr	-868(ra) # 80005f7e <printf>
    800022ea:	a005                	j	8000230a <syscall+0x94>
            p->pid,syscall_names[num],p->trapframe->a0);
    } 
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022ec:	86ce                	mv	a3,s3
    800022ee:	15848613          	addi	a2,s1,344
    800022f2:	588c                	lw	a1,48(s1)
    800022f4:	00006517          	auipc	a0,0x6
    800022f8:	10450513          	addi	a0,a0,260 # 800083f8 <states.0+0x168>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	c82080e7          	jalr	-894(ra) # 80005f7e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002304:	6cbc                	ld	a5,88(s1)
    80002306:	577d                	li	a4,-1
    80002308:	fbb8                	sd	a4,112(a5)
  }
}
    8000230a:	70a2                	ld	ra,40(sp)
    8000230c:	7402                	ld	s0,32(sp)
    8000230e:	64e2                	ld	s1,24(sp)
    80002310:	6942                	ld	s2,16(sp)
    80002312:	69a2                	ld	s3,8(sp)
    80002314:	6145                	addi	sp,sp,48
    80002316:	8082                	ret

0000000080002318 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002318:	1101                	addi	sp,sp,-32
    8000231a:	ec06                	sd	ra,24(sp)
    8000231c:	e822                	sd	s0,16(sp)
    8000231e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002320:	fec40593          	addi	a1,s0,-20
    80002324:	4501                	li	a0,0
    80002326:	00000097          	auipc	ra,0x0
    8000232a:	ed8080e7          	jalr	-296(ra) # 800021fe <argint>
  exit(n);
    8000232e:	fec42503          	lw	a0,-20(s0)
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	546080e7          	jalr	1350(ra) # 80001878 <exit>
  return 0;  // not reached
}
    8000233a:	4501                	li	a0,0
    8000233c:	60e2                	ld	ra,24(sp)
    8000233e:	6442                	ld	s0,16(sp)
    80002340:	6105                	addi	sp,sp,32
    80002342:	8082                	ret

0000000080002344 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002344:	1141                	addi	sp,sp,-16
    80002346:	e406                	sd	ra,8(sp)
    80002348:	e022                	sd	s0,0(sp)
    8000234a:	0800                	addi	s0,sp,16
  return myproc()->usyspage->pid;
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	c8c080e7          	jalr	-884(ra) # 80000fd8 <myproc>
    80002354:	17053783          	ld	a5,368(a0)
}
    80002358:	4388                	lw	a0,0(a5)
    8000235a:	60a2                	ld	ra,8(sp)
    8000235c:	6402                	ld	s0,0(sp)
    8000235e:	0141                	addi	sp,sp,16
    80002360:	8082                	ret

0000000080002362 <sys_fork>:

uint64
sys_fork(void)
{
    80002362:	1141                	addi	sp,sp,-16
    80002364:	e406                	sd	ra,8(sp)
    80002366:	e022                	sd	s0,0(sp)
    80002368:	0800                	addi	s0,sp,16
  return fork();
    8000236a:	fffff097          	auipc	ra,0xfffff
    8000236e:	0e0080e7          	jalr	224(ra) # 8000144a <fork>
}
    80002372:	60a2                	ld	ra,8(sp)
    80002374:	6402                	ld	s0,0(sp)
    80002376:	0141                	addi	sp,sp,16
    80002378:	8082                	ret

000000008000237a <sys_wait>:

uint64
sys_wait(void)
{
    8000237a:	1101                	addi	sp,sp,-32
    8000237c:	ec06                	sd	ra,24(sp)
    8000237e:	e822                	sd	s0,16(sp)
    80002380:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002382:	fe840593          	addi	a1,s0,-24
    80002386:	4501                	li	a0,0
    80002388:	00000097          	auipc	ra,0x0
    8000238c:	e96080e7          	jalr	-362(ra) # 8000221e <argaddr>
  return wait(p);
    80002390:	fe843503          	ld	a0,-24(s0)
    80002394:	fffff097          	auipc	ra,0xfffff
    80002398:	68a080e7          	jalr	1674(ra) # 80001a1e <wait>
}
    8000239c:	60e2                	ld	ra,24(sp)
    8000239e:	6442                	ld	s0,16(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret

00000000800023a4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023a4:	7179                	addi	sp,sp,-48
    800023a6:	f406                	sd	ra,40(sp)
    800023a8:	f022                	sd	s0,32(sp)
    800023aa:	ec26                	sd	s1,24(sp)
    800023ac:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800023ae:	fdc40593          	addi	a1,s0,-36
    800023b2:	4501                	li	a0,0
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	e4a080e7          	jalr	-438(ra) # 800021fe <argint>
  addr = myproc()->sz;
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	c1c080e7          	jalr	-996(ra) # 80000fd8 <myproc>
    800023c4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800023c6:	fdc42503          	lw	a0,-36(s0)
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	024080e7          	jalr	36(ra) # 800013ee <growproc>
    800023d2:	00054863          	bltz	a0,800023e2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800023d6:	8526                	mv	a0,s1
    800023d8:	70a2                	ld	ra,40(sp)
    800023da:	7402                	ld	s0,32(sp)
    800023dc:	64e2                	ld	s1,24(sp)
    800023de:	6145                	addi	sp,sp,48
    800023e0:	8082                	ret
    return -1;
    800023e2:	54fd                	li	s1,-1
    800023e4:	bfcd                	j	800023d6 <sys_sbrk+0x32>

00000000800023e6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800023e6:	7139                	addi	sp,sp,-64
    800023e8:	fc06                	sd	ra,56(sp)
    800023ea:	f822                	sd	s0,48(sp)
    800023ec:	f426                	sd	s1,40(sp)
    800023ee:	f04a                	sd	s2,32(sp)
    800023f0:	ec4e                	sd	s3,24(sp)
    800023f2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  argint(0, &n);
    800023f4:	fcc40593          	addi	a1,s0,-52
    800023f8:	4501                	li	a0,0
    800023fa:	00000097          	auipc	ra,0x0
    800023fe:	e04080e7          	jalr	-508(ra) # 800021fe <argint>
  acquire(&tickslock);
    80002402:	0000d517          	auipc	a0,0xd
    80002406:	fbe50513          	addi	a0,a0,-66 # 8000f3c0 <tickslock>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	030080e7          	jalr	48(ra) # 8000643a <acquire>
  ticks0 = ticks;
    80002412:	00006917          	auipc	s2,0x6
    80002416:	74692903          	lw	s2,1862(s2) # 80008b58 <ticks>
  while(ticks - ticks0 < n){
    8000241a:	fcc42783          	lw	a5,-52(s0)
    8000241e:	cf9d                	beqz	a5,8000245c <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002420:	0000d997          	auipc	s3,0xd
    80002424:	fa098993          	addi	s3,s3,-96 # 8000f3c0 <tickslock>
    80002428:	00006497          	auipc	s1,0x6
    8000242c:	73048493          	addi	s1,s1,1840 # 80008b58 <ticks>
    if(killed(myproc())){
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	ba8080e7          	jalr	-1112(ra) # 80000fd8 <myproc>
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	5b4080e7          	jalr	1460(ra) # 800019ec <killed>
    80002440:	e131                	bnez	a0,80002484 <sys_sleep+0x9e>
    sleep(&ticks, &tickslock);
    80002442:	85ce                	mv	a1,s3
    80002444:	8526                	mv	a0,s1
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	2fe080e7          	jalr	766(ra) # 80001744 <sleep>
  while(ticks - ticks0 < n){
    8000244e:	409c                	lw	a5,0(s1)
    80002450:	412787bb          	subw	a5,a5,s2
    80002454:	fcc42703          	lw	a4,-52(s0)
    80002458:	fce7ece3          	bltu	a5,a4,80002430 <sys_sleep+0x4a>
  }
  backtrace();
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	a5c080e7          	jalr	-1444(ra) # 80005eb8 <backtrace>
  release(&tickslock);
    80002464:	0000d517          	auipc	a0,0xd
    80002468:	f5c50513          	addi	a0,a0,-164 # 8000f3c0 <tickslock>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	082080e7          	jalr	130(ra) # 800064ee <release>
  return 0;
    80002474:	4501                	li	a0,0
}
    80002476:	70e2                	ld	ra,56(sp)
    80002478:	7442                	ld	s0,48(sp)
    8000247a:	74a2                	ld	s1,40(sp)
    8000247c:	7902                	ld	s2,32(sp)
    8000247e:	69e2                	ld	s3,24(sp)
    80002480:	6121                	addi	sp,sp,64
    80002482:	8082                	ret
      release(&tickslock);
    80002484:	0000d517          	auipc	a0,0xd
    80002488:	f3c50513          	addi	a0,a0,-196 # 8000f3c0 <tickslock>
    8000248c:	00004097          	auipc	ra,0x4
    80002490:	062080e7          	jalr	98(ra) # 800064ee <release>
      return -1;
    80002494:	557d                	li	a0,-1
    80002496:	b7c5                	j	80002476 <sys_sleep+0x90>

0000000080002498 <sys_kill>:

uint64
sys_kill(void) 
{
    80002498:	1101                	addi	sp,sp,-32
    8000249a:	ec06                	sd	ra,24(sp)
    8000249c:	e822                	sd	s0,16(sp)
    8000249e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800024a0:	fec40593          	addi	a1,s0,-20
    800024a4:	4501                	li	a0,0
    800024a6:	00000097          	auipc	ra,0x0
    800024aa:	d58080e7          	jalr	-680(ra) # 800021fe <argint>
  return kill(pid);
    800024ae:	fec42503          	lw	a0,-20(s0)
    800024b2:	fffff097          	auipc	ra,0xfffff
    800024b6:	49c080e7          	jalr	1180(ra) # 8000194e <kill>
}
    800024ba:	60e2                	ld	ra,24(sp)
    800024bc:	6442                	ld	s0,16(sp)
    800024be:	6105                	addi	sp,sp,32
    800024c0:	8082                	ret

00000000800024c2 <sys_trace>:

uint64
sys_trace(void)
{
    800024c2:	1101                	addi	sp,sp,-32
    800024c4:	ec06                	sd	ra,24(sp)
    800024c6:	e822                	sd	s0,16(sp)
    800024c8:	1000                	addi	s0,sp,32
  int mask;

 argint(0, &mask);
    800024ca:	fec40593          	addi	a1,s0,-20
    800024ce:	4501                	li	a0,0
    800024d0:	00000097          	auipc	ra,0x0
    800024d4:	d2e080e7          	jalr	-722(ra) # 800021fe <argint>
 
  myproc()->trace_mask=mask;
    800024d8:	fffff097          	auipc	ra,0xfffff
    800024dc:	b00080e7          	jalr	-1280(ra) # 80000fd8 <myproc>
    800024e0:	fec42783          	lw	a5,-20(s0)
    800024e4:	16f52423          	sw	a5,360(a0)
  return 0;
}
    800024e8:	4501                	li	a0,0
    800024ea:	60e2                	ld	ra,24(sp)
    800024ec:	6442                	ld	s0,16(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret

00000000800024f2 <sys_sigalarm>:
uint64 
sys_sigalarm(void){
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;
  argint(0, &interval);
    800024fa:	fec40593          	addi	a1,s0,-20
    800024fe:	4501                	li	a0,0
    80002500:	00000097          	auipc	ra,0x0
    80002504:	cfe080e7          	jalr	-770(ra) # 800021fe <argint>
  argaddr(0,&handler);
    80002508:	fe040593          	addi	a1,s0,-32
    8000250c:	4501                	li	a0,0
    8000250e:	00000097          	auipc	ra,0x0
    80002512:	d10080e7          	jalr	-752(ra) # 8000221e <argaddr>
  myproc()->alarm_interval=interval;
    80002516:	fffff097          	auipc	ra,0xfffff
    8000251a:	ac2080e7          	jalr	-1342(ra) # 80000fd8 <myproc>
    8000251e:	fec42783          	lw	a5,-20(s0)
    80002522:	16f52c23          	sw	a5,376(a0)
  myproc()->alarm_handler=handler;
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	ab2080e7          	jalr	-1358(ra) # 80000fd8 <myproc>
    8000252e:	fe043783          	ld	a5,-32(s0)
    80002532:	18f53023          	sd	a5,384(a0)
  return 0;

}
    80002536:	4501                	li	a0,0
    80002538:	60e2                	ld	ra,24(sp)
    8000253a:	6442                	ld	s0,16(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret

0000000080002540 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000254a:	0000d517          	auipc	a0,0xd
    8000254e:	e7650513          	addi	a0,a0,-394 # 8000f3c0 <tickslock>
    80002552:	00004097          	auipc	ra,0x4
    80002556:	ee8080e7          	jalr	-280(ra) # 8000643a <acquire>
  xticks = ticks;
    8000255a:	00006497          	auipc	s1,0x6
    8000255e:	5fe4a483          	lw	s1,1534(s1) # 80008b58 <ticks>
  release(&tickslock);
    80002562:	0000d517          	auipc	a0,0xd
    80002566:	e5e50513          	addi	a0,a0,-418 # 8000f3c0 <tickslock>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	f84080e7          	jalr	-124(ra) # 800064ee <release>
  return xticks;
}
    80002572:	02049513          	slli	a0,s1,0x20
    80002576:	9101                	srli	a0,a0,0x20
    80002578:	60e2                	ld	ra,24(sp)
    8000257a:	6442                	ld	s0,16(sp)
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	6105                	addi	sp,sp,32
    80002580:	8082                	ret

0000000080002582 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002582:	7179                	addi	sp,sp,-48
    80002584:	f406                	sd	ra,40(sp)
    80002586:	f022                	sd	s0,32(sp)
    80002588:	ec26                	sd	s1,24(sp)
    8000258a:	e84a                	sd	s2,16(sp)
    8000258c:	e44e                	sd	s3,8(sp)
    8000258e:	e052                	sd	s4,0(sp)
    80002590:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002592:	00006597          	auipc	a1,0x6
    80002596:	16658593          	addi	a1,a1,358 # 800086f8 <syscall_names+0xb8>
    8000259a:	0000d517          	auipc	a0,0xd
    8000259e:	e3e50513          	addi	a0,a0,-450 # 8000f3d8 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	e08080e7          	jalr	-504(ra) # 800063aa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025aa:	00015797          	auipc	a5,0x15
    800025ae:	e2e78793          	addi	a5,a5,-466 # 800173d8 <bcache+0x8000>
    800025b2:	00015717          	auipc	a4,0x15
    800025b6:	08e70713          	addi	a4,a4,142 # 80017640 <bcache+0x8268>
    800025ba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025be:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025c2:	0000d497          	auipc	s1,0xd
    800025c6:	e2e48493          	addi	s1,s1,-466 # 8000f3f0 <bcache+0x18>
    b->next = bcache.head.next;
    800025ca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025cc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025ce:	00006a17          	auipc	s4,0x6
    800025d2:	132a0a13          	addi	s4,s4,306 # 80008700 <syscall_names+0xc0>
    b->next = bcache.head.next;
    800025d6:	2b893783          	ld	a5,696(s2)
    800025da:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025dc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025e0:	85d2                	mv	a1,s4
    800025e2:	01048513          	addi	a0,s1,16
    800025e6:	00001097          	auipc	ra,0x1
    800025ea:	496080e7          	jalr	1174(ra) # 80003a7c <initsleeplock>
    bcache.head.next->prev = b;
    800025ee:	2b893783          	ld	a5,696(s2)
    800025f2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025f4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025f8:	45848493          	addi	s1,s1,1112
    800025fc:	fd349de3          	bne	s1,s3,800025d6 <binit+0x54>
  }
}
    80002600:	70a2                	ld	ra,40(sp)
    80002602:	7402                	ld	s0,32(sp)
    80002604:	64e2                	ld	s1,24(sp)
    80002606:	6942                	ld	s2,16(sp)
    80002608:	69a2                	ld	s3,8(sp)
    8000260a:	6a02                	ld	s4,0(sp)
    8000260c:	6145                	addi	sp,sp,48
    8000260e:	8082                	ret

0000000080002610 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002610:	7179                	addi	sp,sp,-48
    80002612:	f406                	sd	ra,40(sp)
    80002614:	f022                	sd	s0,32(sp)
    80002616:	ec26                	sd	s1,24(sp)
    80002618:	e84a                	sd	s2,16(sp)
    8000261a:	e44e                	sd	s3,8(sp)
    8000261c:	1800                	addi	s0,sp,48
    8000261e:	892a                	mv	s2,a0
    80002620:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002622:	0000d517          	auipc	a0,0xd
    80002626:	db650513          	addi	a0,a0,-586 # 8000f3d8 <bcache>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	e10080e7          	jalr	-496(ra) # 8000643a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002632:	00015497          	auipc	s1,0x15
    80002636:	05e4b483          	ld	s1,94(s1) # 80017690 <bcache+0x82b8>
    8000263a:	00015797          	auipc	a5,0x15
    8000263e:	00678793          	addi	a5,a5,6 # 80017640 <bcache+0x8268>
    80002642:	02f48f63          	beq	s1,a5,80002680 <bread+0x70>
    80002646:	873e                	mv	a4,a5
    80002648:	a021                	j	80002650 <bread+0x40>
    8000264a:	68a4                	ld	s1,80(s1)
    8000264c:	02e48a63          	beq	s1,a4,80002680 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002650:	449c                	lw	a5,8(s1)
    80002652:	ff279ce3          	bne	a5,s2,8000264a <bread+0x3a>
    80002656:	44dc                	lw	a5,12(s1)
    80002658:	ff3799e3          	bne	a5,s3,8000264a <bread+0x3a>
      b->refcnt++;
    8000265c:	40bc                	lw	a5,64(s1)
    8000265e:	2785                	addiw	a5,a5,1
    80002660:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002662:	0000d517          	auipc	a0,0xd
    80002666:	d7650513          	addi	a0,a0,-650 # 8000f3d8 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	e84080e7          	jalr	-380(ra) # 800064ee <release>
      acquiresleep(&b->lock);
    80002672:	01048513          	addi	a0,s1,16
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	440080e7          	jalr	1088(ra) # 80003ab6 <acquiresleep>
      return b;
    8000267e:	a8b9                	j	800026dc <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002680:	00015497          	auipc	s1,0x15
    80002684:	0084b483          	ld	s1,8(s1) # 80017688 <bcache+0x82b0>
    80002688:	00015797          	auipc	a5,0x15
    8000268c:	fb878793          	addi	a5,a5,-72 # 80017640 <bcache+0x8268>
    80002690:	00f48863          	beq	s1,a5,800026a0 <bread+0x90>
    80002694:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002696:	40bc                	lw	a5,64(s1)
    80002698:	cf81                	beqz	a5,800026b0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000269a:	64a4                	ld	s1,72(s1)
    8000269c:	fee49de3          	bne	s1,a4,80002696 <bread+0x86>
  panic("bget: no buffers");
    800026a0:	00006517          	auipc	a0,0x6
    800026a4:	06850513          	addi	a0,a0,104 # 80008708 <syscall_names+0xc8>
    800026a8:	00004097          	auipc	ra,0x4
    800026ac:	884080e7          	jalr	-1916(ra) # 80005f2c <panic>
      b->dev = dev;
    800026b0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026b4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026b8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026bc:	4785                	li	a5,1
    800026be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026c0:	0000d517          	auipc	a0,0xd
    800026c4:	d1850513          	addi	a0,a0,-744 # 8000f3d8 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	e26080e7          	jalr	-474(ra) # 800064ee <release>
      acquiresleep(&b->lock);
    800026d0:	01048513          	addi	a0,s1,16
    800026d4:	00001097          	auipc	ra,0x1
    800026d8:	3e2080e7          	jalr	994(ra) # 80003ab6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026dc:	409c                	lw	a5,0(s1)
    800026de:	cb89                	beqz	a5,800026f0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026e0:	8526                	mv	a0,s1
    800026e2:	70a2                	ld	ra,40(sp)
    800026e4:	7402                	ld	s0,32(sp)
    800026e6:	64e2                	ld	s1,24(sp)
    800026e8:	6942                	ld	s2,16(sp)
    800026ea:	69a2                	ld	s3,8(sp)
    800026ec:	6145                	addi	sp,sp,48
    800026ee:	8082                	ret
    virtio_disk_rw(b, 0);
    800026f0:	4581                	li	a1,0
    800026f2:	8526                	mv	a0,s1
    800026f4:	00003097          	auipc	ra,0x3
    800026f8:	f8e080e7          	jalr	-114(ra) # 80005682 <virtio_disk_rw>
    b->valid = 1;
    800026fc:	4785                	li	a5,1
    800026fe:	c09c                	sw	a5,0(s1)
  return b;
    80002700:	b7c5                	j	800026e0 <bread+0xd0>

0000000080002702 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002702:	1101                	addi	sp,sp,-32
    80002704:	ec06                	sd	ra,24(sp)
    80002706:	e822                	sd	s0,16(sp)
    80002708:	e426                	sd	s1,8(sp)
    8000270a:	1000                	addi	s0,sp,32
    8000270c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000270e:	0541                	addi	a0,a0,16
    80002710:	00001097          	auipc	ra,0x1
    80002714:	440080e7          	jalr	1088(ra) # 80003b50 <holdingsleep>
    80002718:	cd01                	beqz	a0,80002730 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000271a:	4585                	li	a1,1
    8000271c:	8526                	mv	a0,s1
    8000271e:	00003097          	auipc	ra,0x3
    80002722:	f64080e7          	jalr	-156(ra) # 80005682 <virtio_disk_rw>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6105                	addi	sp,sp,32
    8000272e:	8082                	ret
    panic("bwrite");
    80002730:	00006517          	auipc	a0,0x6
    80002734:	ff050513          	addi	a0,a0,-16 # 80008720 <syscall_names+0xe0>
    80002738:	00003097          	auipc	ra,0x3
    8000273c:	7f4080e7          	jalr	2036(ra) # 80005f2c <panic>

0000000080002740 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002740:	1101                	addi	sp,sp,-32
    80002742:	ec06                	sd	ra,24(sp)
    80002744:	e822                	sd	s0,16(sp)
    80002746:	e426                	sd	s1,8(sp)
    80002748:	e04a                	sd	s2,0(sp)
    8000274a:	1000                	addi	s0,sp,32
    8000274c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000274e:	01050913          	addi	s2,a0,16
    80002752:	854a                	mv	a0,s2
    80002754:	00001097          	auipc	ra,0x1
    80002758:	3fc080e7          	jalr	1020(ra) # 80003b50 <holdingsleep>
    8000275c:	c925                	beqz	a0,800027cc <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000275e:	854a                	mv	a0,s2
    80002760:	00001097          	auipc	ra,0x1
    80002764:	3ac080e7          	jalr	940(ra) # 80003b0c <releasesleep>

  acquire(&bcache.lock);
    80002768:	0000d517          	auipc	a0,0xd
    8000276c:	c7050513          	addi	a0,a0,-912 # 8000f3d8 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	cca080e7          	jalr	-822(ra) # 8000643a <acquire>
  b->refcnt--;
    80002778:	40bc                	lw	a5,64(s1)
    8000277a:	37fd                	addiw	a5,a5,-1
    8000277c:	0007871b          	sext.w	a4,a5
    80002780:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002782:	e71d                	bnez	a4,800027b0 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002784:	68b8                	ld	a4,80(s1)
    80002786:	64bc                	ld	a5,72(s1)
    80002788:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000278a:	68b8                	ld	a4,80(s1)
    8000278c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000278e:	00015797          	auipc	a5,0x15
    80002792:	c4a78793          	addi	a5,a5,-950 # 800173d8 <bcache+0x8000>
    80002796:	2b87b703          	ld	a4,696(a5)
    8000279a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000279c:	00015717          	auipc	a4,0x15
    800027a0:	ea470713          	addi	a4,a4,-348 # 80017640 <bcache+0x8268>
    800027a4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027a6:	2b87b703          	ld	a4,696(a5)
    800027aa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027ac:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027b0:	0000d517          	auipc	a0,0xd
    800027b4:	c2850513          	addi	a0,a0,-984 # 8000f3d8 <bcache>
    800027b8:	00004097          	auipc	ra,0x4
    800027bc:	d36080e7          	jalr	-714(ra) # 800064ee <release>
}
    800027c0:	60e2                	ld	ra,24(sp)
    800027c2:	6442                	ld	s0,16(sp)
    800027c4:	64a2                	ld	s1,8(sp)
    800027c6:	6902                	ld	s2,0(sp)
    800027c8:	6105                	addi	sp,sp,32
    800027ca:	8082                	ret
    panic("brelse");
    800027cc:	00006517          	auipc	a0,0x6
    800027d0:	f5c50513          	addi	a0,a0,-164 # 80008728 <syscall_names+0xe8>
    800027d4:	00003097          	auipc	ra,0x3
    800027d8:	758080e7          	jalr	1880(ra) # 80005f2c <panic>

00000000800027dc <bpin>:

void
bpin(struct buf *b) {
    800027dc:	1101                	addi	sp,sp,-32
    800027de:	ec06                	sd	ra,24(sp)
    800027e0:	e822                	sd	s0,16(sp)
    800027e2:	e426                	sd	s1,8(sp)
    800027e4:	1000                	addi	s0,sp,32
    800027e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027e8:	0000d517          	auipc	a0,0xd
    800027ec:	bf050513          	addi	a0,a0,-1040 # 8000f3d8 <bcache>
    800027f0:	00004097          	auipc	ra,0x4
    800027f4:	c4a080e7          	jalr	-950(ra) # 8000643a <acquire>
  b->refcnt++;
    800027f8:	40bc                	lw	a5,64(s1)
    800027fa:	2785                	addiw	a5,a5,1
    800027fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027fe:	0000d517          	auipc	a0,0xd
    80002802:	bda50513          	addi	a0,a0,-1062 # 8000f3d8 <bcache>
    80002806:	00004097          	auipc	ra,0x4
    8000280a:	ce8080e7          	jalr	-792(ra) # 800064ee <release>
}
    8000280e:	60e2                	ld	ra,24(sp)
    80002810:	6442                	ld	s0,16(sp)
    80002812:	64a2                	ld	s1,8(sp)
    80002814:	6105                	addi	sp,sp,32
    80002816:	8082                	ret

0000000080002818 <bunpin>:

void
bunpin(struct buf *b) {
    80002818:	1101                	addi	sp,sp,-32
    8000281a:	ec06                	sd	ra,24(sp)
    8000281c:	e822                	sd	s0,16(sp)
    8000281e:	e426                	sd	s1,8(sp)
    80002820:	1000                	addi	s0,sp,32
    80002822:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002824:	0000d517          	auipc	a0,0xd
    80002828:	bb450513          	addi	a0,a0,-1100 # 8000f3d8 <bcache>
    8000282c:	00004097          	auipc	ra,0x4
    80002830:	c0e080e7          	jalr	-1010(ra) # 8000643a <acquire>
  b->refcnt--;
    80002834:	40bc                	lw	a5,64(s1)
    80002836:	37fd                	addiw	a5,a5,-1
    80002838:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000283a:	0000d517          	auipc	a0,0xd
    8000283e:	b9e50513          	addi	a0,a0,-1122 # 8000f3d8 <bcache>
    80002842:	00004097          	auipc	ra,0x4
    80002846:	cac080e7          	jalr	-852(ra) # 800064ee <release>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret

0000000080002854 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002854:	1101                	addi	sp,sp,-32
    80002856:	ec06                	sd	ra,24(sp)
    80002858:	e822                	sd	s0,16(sp)
    8000285a:	e426                	sd	s1,8(sp)
    8000285c:	e04a                	sd	s2,0(sp)
    8000285e:	1000                	addi	s0,sp,32
    80002860:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002862:	00d5d59b          	srliw	a1,a1,0xd
    80002866:	00015797          	auipc	a5,0x15
    8000286a:	24e7a783          	lw	a5,590(a5) # 80017ab4 <sb+0x1c>
    8000286e:	9dbd                	addw	a1,a1,a5
    80002870:	00000097          	auipc	ra,0x0
    80002874:	da0080e7          	jalr	-608(ra) # 80002610 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002878:	0074f713          	andi	a4,s1,7
    8000287c:	4785                	li	a5,1
    8000287e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002882:	14ce                	slli	s1,s1,0x33
    80002884:	90d9                	srli	s1,s1,0x36
    80002886:	00950733          	add	a4,a0,s1
    8000288a:	05874703          	lbu	a4,88(a4)
    8000288e:	00e7f6b3          	and	a3,a5,a4
    80002892:	c69d                	beqz	a3,800028c0 <bfree+0x6c>
    80002894:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002896:	94aa                	add	s1,s1,a0
    80002898:	fff7c793          	not	a5,a5
    8000289c:	8f7d                	and	a4,a4,a5
    8000289e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	0f6080e7          	jalr	246(ra) # 80003998 <log_write>
  brelse(bp);
    800028aa:	854a                	mv	a0,s2
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	e94080e7          	jalr	-364(ra) # 80002740 <brelse>
}
    800028b4:	60e2                	ld	ra,24(sp)
    800028b6:	6442                	ld	s0,16(sp)
    800028b8:	64a2                	ld	s1,8(sp)
    800028ba:	6902                	ld	s2,0(sp)
    800028bc:	6105                	addi	sp,sp,32
    800028be:	8082                	ret
    panic("freeing free block");
    800028c0:	00006517          	auipc	a0,0x6
    800028c4:	e7050513          	addi	a0,a0,-400 # 80008730 <syscall_names+0xf0>
    800028c8:	00003097          	auipc	ra,0x3
    800028cc:	664080e7          	jalr	1636(ra) # 80005f2c <panic>

00000000800028d0 <balloc>:
{
    800028d0:	711d                	addi	sp,sp,-96
    800028d2:	ec86                	sd	ra,88(sp)
    800028d4:	e8a2                	sd	s0,80(sp)
    800028d6:	e4a6                	sd	s1,72(sp)
    800028d8:	e0ca                	sd	s2,64(sp)
    800028da:	fc4e                	sd	s3,56(sp)
    800028dc:	f852                	sd	s4,48(sp)
    800028de:	f456                	sd	s5,40(sp)
    800028e0:	f05a                	sd	s6,32(sp)
    800028e2:	ec5e                	sd	s7,24(sp)
    800028e4:	e862                	sd	s8,16(sp)
    800028e6:	e466                	sd	s9,8(sp)
    800028e8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028ea:	00015797          	auipc	a5,0x15
    800028ee:	1b27a783          	lw	a5,434(a5) # 80017a9c <sb+0x4>
    800028f2:	cff5                	beqz	a5,800029ee <balloc+0x11e>
    800028f4:	8baa                	mv	s7,a0
    800028f6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028f8:	00015b17          	auipc	s6,0x15
    800028fc:	1a0b0b13          	addi	s6,s6,416 # 80017a98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002900:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002902:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002904:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002906:	6c89                	lui	s9,0x2
    80002908:	a061                	j	80002990 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000290a:	97ca                	add	a5,a5,s2
    8000290c:	8e55                	or	a2,a2,a3
    8000290e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002912:	854a                	mv	a0,s2
    80002914:	00001097          	auipc	ra,0x1
    80002918:	084080e7          	jalr	132(ra) # 80003998 <log_write>
        brelse(bp);
    8000291c:	854a                	mv	a0,s2
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	e22080e7          	jalr	-478(ra) # 80002740 <brelse>
  bp = bread(dev, bno);
    80002926:	85a6                	mv	a1,s1
    80002928:	855e                	mv	a0,s7
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	ce6080e7          	jalr	-794(ra) # 80002610 <bread>
    80002932:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002934:	40000613          	li	a2,1024
    80002938:	4581                	li	a1,0
    8000293a:	05850513          	addi	a0,a0,88
    8000293e:	ffffe097          	auipc	ra,0xffffe
    80002942:	83c080e7          	jalr	-1988(ra) # 8000017a <memset>
  log_write(bp);
    80002946:	854a                	mv	a0,s2
    80002948:	00001097          	auipc	ra,0x1
    8000294c:	050080e7          	jalr	80(ra) # 80003998 <log_write>
  brelse(bp);
    80002950:	854a                	mv	a0,s2
    80002952:	00000097          	auipc	ra,0x0
    80002956:	dee080e7          	jalr	-530(ra) # 80002740 <brelse>
}
    8000295a:	8526                	mv	a0,s1
    8000295c:	60e6                	ld	ra,88(sp)
    8000295e:	6446                	ld	s0,80(sp)
    80002960:	64a6                	ld	s1,72(sp)
    80002962:	6906                	ld	s2,64(sp)
    80002964:	79e2                	ld	s3,56(sp)
    80002966:	7a42                	ld	s4,48(sp)
    80002968:	7aa2                	ld	s5,40(sp)
    8000296a:	7b02                	ld	s6,32(sp)
    8000296c:	6be2                	ld	s7,24(sp)
    8000296e:	6c42                	ld	s8,16(sp)
    80002970:	6ca2                	ld	s9,8(sp)
    80002972:	6125                	addi	sp,sp,96
    80002974:	8082                	ret
    brelse(bp);
    80002976:	854a                	mv	a0,s2
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	dc8080e7          	jalr	-568(ra) # 80002740 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002980:	015c87bb          	addw	a5,s9,s5
    80002984:	00078a9b          	sext.w	s5,a5
    80002988:	004b2703          	lw	a4,4(s6)
    8000298c:	06eaf163          	bgeu	s5,a4,800029ee <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002990:	41fad79b          	sraiw	a5,s5,0x1f
    80002994:	0137d79b          	srliw	a5,a5,0x13
    80002998:	015787bb          	addw	a5,a5,s5
    8000299c:	40d7d79b          	sraiw	a5,a5,0xd
    800029a0:	01cb2583          	lw	a1,28(s6)
    800029a4:	9dbd                	addw	a1,a1,a5
    800029a6:	855e                	mv	a0,s7
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	c68080e7          	jalr	-920(ra) # 80002610 <bread>
    800029b0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029b2:	004b2503          	lw	a0,4(s6)
    800029b6:	000a849b          	sext.w	s1,s5
    800029ba:	8762                	mv	a4,s8
    800029bc:	faa4fde3          	bgeu	s1,a0,80002976 <balloc+0xa6>
      m = 1 << (bi % 8);
    800029c0:	00777693          	andi	a3,a4,7
    800029c4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029c8:	41f7579b          	sraiw	a5,a4,0x1f
    800029cc:	01d7d79b          	srliw	a5,a5,0x1d
    800029d0:	9fb9                	addw	a5,a5,a4
    800029d2:	4037d79b          	sraiw	a5,a5,0x3
    800029d6:	00f90633          	add	a2,s2,a5
    800029da:	05864603          	lbu	a2,88(a2)
    800029de:	00c6f5b3          	and	a1,a3,a2
    800029e2:	d585                	beqz	a1,8000290a <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029e4:	2705                	addiw	a4,a4,1
    800029e6:	2485                	addiw	s1,s1,1
    800029e8:	fd471ae3          	bne	a4,s4,800029bc <balloc+0xec>
    800029ec:	b769                	j	80002976 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800029ee:	00006517          	auipc	a0,0x6
    800029f2:	d5a50513          	addi	a0,a0,-678 # 80008748 <syscall_names+0x108>
    800029f6:	00003097          	auipc	ra,0x3
    800029fa:	588080e7          	jalr	1416(ra) # 80005f7e <printf>
  return 0;
    800029fe:	4481                	li	s1,0
    80002a00:	bfa9                	j	8000295a <balloc+0x8a>

0000000080002a02 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a02:	7179                	addi	sp,sp,-48
    80002a04:	f406                	sd	ra,40(sp)
    80002a06:	f022                	sd	s0,32(sp)
    80002a08:	ec26                	sd	s1,24(sp)
    80002a0a:	e84a                	sd	s2,16(sp)
    80002a0c:	e44e                	sd	s3,8(sp)
    80002a0e:	e052                	sd	s4,0(sp)
    80002a10:	1800                	addi	s0,sp,48
    80002a12:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a14:	47ad                	li	a5,11
    80002a16:	02b7e863          	bltu	a5,a1,80002a46 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002a1a:	02059793          	slli	a5,a1,0x20
    80002a1e:	01e7d593          	srli	a1,a5,0x1e
    80002a22:	00b504b3          	add	s1,a0,a1
    80002a26:	0504a903          	lw	s2,80(s1)
    80002a2a:	06091e63          	bnez	s2,80002aa6 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002a2e:	4108                	lw	a0,0(a0)
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	ea0080e7          	jalr	-352(ra) # 800028d0 <balloc>
    80002a38:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a3c:	06090563          	beqz	s2,80002aa6 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002a40:	0524a823          	sw	s2,80(s1)
    80002a44:	a08d                	j	80002aa6 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a46:	ff45849b          	addiw	s1,a1,-12
    80002a4a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a4e:	0ff00793          	li	a5,255
    80002a52:	08e7e563          	bltu	a5,a4,80002adc <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a56:	08052903          	lw	s2,128(a0)
    80002a5a:	00091d63          	bnez	s2,80002a74 <bmap+0x72>
      addr = balloc(ip->dev);
    80002a5e:	4108                	lw	a0,0(a0)
    80002a60:	00000097          	auipc	ra,0x0
    80002a64:	e70080e7          	jalr	-400(ra) # 800028d0 <balloc>
    80002a68:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a6c:	02090d63          	beqz	s2,80002aa6 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a70:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002a74:	85ca                	mv	a1,s2
    80002a76:	0009a503          	lw	a0,0(s3)
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	b96080e7          	jalr	-1130(ra) # 80002610 <bread>
    80002a82:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a84:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a88:	02049713          	slli	a4,s1,0x20
    80002a8c:	01e75593          	srli	a1,a4,0x1e
    80002a90:	00b784b3          	add	s1,a5,a1
    80002a94:	0004a903          	lw	s2,0(s1)
    80002a98:	02090063          	beqz	s2,80002ab8 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a9c:	8552                	mv	a0,s4
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	ca2080e7          	jalr	-862(ra) # 80002740 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002aa6:	854a                	mv	a0,s2
    80002aa8:	70a2                	ld	ra,40(sp)
    80002aaa:	7402                	ld	s0,32(sp)
    80002aac:	64e2                	ld	s1,24(sp)
    80002aae:	6942                	ld	s2,16(sp)
    80002ab0:	69a2                	ld	s3,8(sp)
    80002ab2:	6a02                	ld	s4,0(sp)
    80002ab4:	6145                	addi	sp,sp,48
    80002ab6:	8082                	ret
      addr = balloc(ip->dev);
    80002ab8:	0009a503          	lw	a0,0(s3)
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	e14080e7          	jalr	-492(ra) # 800028d0 <balloc>
    80002ac4:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ac8:	fc090ae3          	beqz	s2,80002a9c <bmap+0x9a>
        a[bn] = addr;
    80002acc:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ad0:	8552                	mv	a0,s4
    80002ad2:	00001097          	auipc	ra,0x1
    80002ad6:	ec6080e7          	jalr	-314(ra) # 80003998 <log_write>
    80002ada:	b7c9                	j	80002a9c <bmap+0x9a>
  panic("bmap: out of range");
    80002adc:	00006517          	auipc	a0,0x6
    80002ae0:	c8450513          	addi	a0,a0,-892 # 80008760 <syscall_names+0x120>
    80002ae4:	00003097          	auipc	ra,0x3
    80002ae8:	448080e7          	jalr	1096(ra) # 80005f2c <panic>

0000000080002aec <iget>:
{
    80002aec:	7179                	addi	sp,sp,-48
    80002aee:	f406                	sd	ra,40(sp)
    80002af0:	f022                	sd	s0,32(sp)
    80002af2:	ec26                	sd	s1,24(sp)
    80002af4:	e84a                	sd	s2,16(sp)
    80002af6:	e44e                	sd	s3,8(sp)
    80002af8:	e052                	sd	s4,0(sp)
    80002afa:	1800                	addi	s0,sp,48
    80002afc:	89aa                	mv	s3,a0
    80002afe:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b00:	00015517          	auipc	a0,0x15
    80002b04:	fb850513          	addi	a0,a0,-72 # 80017ab8 <itable>
    80002b08:	00004097          	auipc	ra,0x4
    80002b0c:	932080e7          	jalr	-1742(ra) # 8000643a <acquire>
  empty = 0;
    80002b10:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b12:	00015497          	auipc	s1,0x15
    80002b16:	fbe48493          	addi	s1,s1,-66 # 80017ad0 <itable+0x18>
    80002b1a:	00017697          	auipc	a3,0x17
    80002b1e:	a4668693          	addi	a3,a3,-1466 # 80019560 <log>
    80002b22:	a039                	j	80002b30 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b24:	02090b63          	beqz	s2,80002b5a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b28:	08848493          	addi	s1,s1,136
    80002b2c:	02d48a63          	beq	s1,a3,80002b60 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b30:	449c                	lw	a5,8(s1)
    80002b32:	fef059e3          	blez	a5,80002b24 <iget+0x38>
    80002b36:	4098                	lw	a4,0(s1)
    80002b38:	ff3716e3          	bne	a4,s3,80002b24 <iget+0x38>
    80002b3c:	40d8                	lw	a4,4(s1)
    80002b3e:	ff4713e3          	bne	a4,s4,80002b24 <iget+0x38>
      ip->ref++;
    80002b42:	2785                	addiw	a5,a5,1
    80002b44:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b46:	00015517          	auipc	a0,0x15
    80002b4a:	f7250513          	addi	a0,a0,-142 # 80017ab8 <itable>
    80002b4e:	00004097          	auipc	ra,0x4
    80002b52:	9a0080e7          	jalr	-1632(ra) # 800064ee <release>
      return ip;
    80002b56:	8926                	mv	s2,s1
    80002b58:	a03d                	j	80002b86 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b5a:	f7f9                	bnez	a5,80002b28 <iget+0x3c>
    80002b5c:	8926                	mv	s2,s1
    80002b5e:	b7e9                	j	80002b28 <iget+0x3c>
  if(empty == 0)
    80002b60:	02090c63          	beqz	s2,80002b98 <iget+0xac>
  ip->dev = dev;
    80002b64:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b68:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b6c:	4785                	li	a5,1
    80002b6e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b72:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b76:	00015517          	auipc	a0,0x15
    80002b7a:	f4250513          	addi	a0,a0,-190 # 80017ab8 <itable>
    80002b7e:	00004097          	auipc	ra,0x4
    80002b82:	970080e7          	jalr	-1680(ra) # 800064ee <release>
}
    80002b86:	854a                	mv	a0,s2
    80002b88:	70a2                	ld	ra,40(sp)
    80002b8a:	7402                	ld	s0,32(sp)
    80002b8c:	64e2                	ld	s1,24(sp)
    80002b8e:	6942                	ld	s2,16(sp)
    80002b90:	69a2                	ld	s3,8(sp)
    80002b92:	6a02                	ld	s4,0(sp)
    80002b94:	6145                	addi	sp,sp,48
    80002b96:	8082                	ret
    panic("iget: no inodes");
    80002b98:	00006517          	auipc	a0,0x6
    80002b9c:	be050513          	addi	a0,a0,-1056 # 80008778 <syscall_names+0x138>
    80002ba0:	00003097          	auipc	ra,0x3
    80002ba4:	38c080e7          	jalr	908(ra) # 80005f2c <panic>

0000000080002ba8 <fsinit>:
fsinit(int dev) {
    80002ba8:	7179                	addi	sp,sp,-48
    80002baa:	f406                	sd	ra,40(sp)
    80002bac:	f022                	sd	s0,32(sp)
    80002bae:	ec26                	sd	s1,24(sp)
    80002bb0:	e84a                	sd	s2,16(sp)
    80002bb2:	e44e                	sd	s3,8(sp)
    80002bb4:	1800                	addi	s0,sp,48
    80002bb6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bb8:	4585                	li	a1,1
    80002bba:	00000097          	auipc	ra,0x0
    80002bbe:	a56080e7          	jalr	-1450(ra) # 80002610 <bread>
    80002bc2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bc4:	00015997          	auipc	s3,0x15
    80002bc8:	ed498993          	addi	s3,s3,-300 # 80017a98 <sb>
    80002bcc:	02000613          	li	a2,32
    80002bd0:	05850593          	addi	a1,a0,88
    80002bd4:	854e                	mv	a0,s3
    80002bd6:	ffffd097          	auipc	ra,0xffffd
    80002bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>
  brelse(bp);
    80002bde:	8526                	mv	a0,s1
    80002be0:	00000097          	auipc	ra,0x0
    80002be4:	b60080e7          	jalr	-1184(ra) # 80002740 <brelse>
  if(sb.magic != FSMAGIC)
    80002be8:	0009a703          	lw	a4,0(s3)
    80002bec:	102037b7          	lui	a5,0x10203
    80002bf0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bf4:	02f71263          	bne	a4,a5,80002c18 <fsinit+0x70>
  initlog(dev, &sb);
    80002bf8:	00015597          	auipc	a1,0x15
    80002bfc:	ea058593          	addi	a1,a1,-352 # 80017a98 <sb>
    80002c00:	854a                	mv	a0,s2
    80002c02:	00001097          	auipc	ra,0x1
    80002c06:	b2c080e7          	jalr	-1236(ra) # 8000372e <initlog>
}
    80002c0a:	70a2                	ld	ra,40(sp)
    80002c0c:	7402                	ld	s0,32(sp)
    80002c0e:	64e2                	ld	s1,24(sp)
    80002c10:	6942                	ld	s2,16(sp)
    80002c12:	69a2                	ld	s3,8(sp)
    80002c14:	6145                	addi	sp,sp,48
    80002c16:	8082                	ret
    panic("invalid file system");
    80002c18:	00006517          	auipc	a0,0x6
    80002c1c:	b7050513          	addi	a0,a0,-1168 # 80008788 <syscall_names+0x148>
    80002c20:	00003097          	auipc	ra,0x3
    80002c24:	30c080e7          	jalr	780(ra) # 80005f2c <panic>

0000000080002c28 <iinit>:
{
    80002c28:	7179                	addi	sp,sp,-48
    80002c2a:	f406                	sd	ra,40(sp)
    80002c2c:	f022                	sd	s0,32(sp)
    80002c2e:	ec26                	sd	s1,24(sp)
    80002c30:	e84a                	sd	s2,16(sp)
    80002c32:	e44e                	sd	s3,8(sp)
    80002c34:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c36:	00006597          	auipc	a1,0x6
    80002c3a:	b6a58593          	addi	a1,a1,-1174 # 800087a0 <syscall_names+0x160>
    80002c3e:	00015517          	auipc	a0,0x15
    80002c42:	e7a50513          	addi	a0,a0,-390 # 80017ab8 <itable>
    80002c46:	00003097          	auipc	ra,0x3
    80002c4a:	764080e7          	jalr	1892(ra) # 800063aa <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c4e:	00015497          	auipc	s1,0x15
    80002c52:	e9248493          	addi	s1,s1,-366 # 80017ae0 <itable+0x28>
    80002c56:	00017997          	auipc	s3,0x17
    80002c5a:	91a98993          	addi	s3,s3,-1766 # 80019570 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c5e:	00006917          	auipc	s2,0x6
    80002c62:	b4a90913          	addi	s2,s2,-1206 # 800087a8 <syscall_names+0x168>
    80002c66:	85ca                	mv	a1,s2
    80002c68:	8526                	mv	a0,s1
    80002c6a:	00001097          	auipc	ra,0x1
    80002c6e:	e12080e7          	jalr	-494(ra) # 80003a7c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c72:	08848493          	addi	s1,s1,136
    80002c76:	ff3498e3          	bne	s1,s3,80002c66 <iinit+0x3e>
}
    80002c7a:	70a2                	ld	ra,40(sp)
    80002c7c:	7402                	ld	s0,32(sp)
    80002c7e:	64e2                	ld	s1,24(sp)
    80002c80:	6942                	ld	s2,16(sp)
    80002c82:	69a2                	ld	s3,8(sp)
    80002c84:	6145                	addi	sp,sp,48
    80002c86:	8082                	ret

0000000080002c88 <ialloc>:
{
    80002c88:	7139                	addi	sp,sp,-64
    80002c8a:	fc06                	sd	ra,56(sp)
    80002c8c:	f822                	sd	s0,48(sp)
    80002c8e:	f426                	sd	s1,40(sp)
    80002c90:	f04a                	sd	s2,32(sp)
    80002c92:	ec4e                	sd	s3,24(sp)
    80002c94:	e852                	sd	s4,16(sp)
    80002c96:	e456                	sd	s5,8(sp)
    80002c98:	e05a                	sd	s6,0(sp)
    80002c9a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c9c:	00015717          	auipc	a4,0x15
    80002ca0:	e0872703          	lw	a4,-504(a4) # 80017aa4 <sb+0xc>
    80002ca4:	4785                	li	a5,1
    80002ca6:	04e7f863          	bgeu	a5,a4,80002cf6 <ialloc+0x6e>
    80002caa:	8aaa                	mv	s5,a0
    80002cac:	8b2e                	mv	s6,a1
    80002cae:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cb0:	00015a17          	auipc	s4,0x15
    80002cb4:	de8a0a13          	addi	s4,s4,-536 # 80017a98 <sb>
    80002cb8:	00495593          	srli	a1,s2,0x4
    80002cbc:	018a2783          	lw	a5,24(s4)
    80002cc0:	9dbd                	addw	a1,a1,a5
    80002cc2:	8556                	mv	a0,s5
    80002cc4:	00000097          	auipc	ra,0x0
    80002cc8:	94c080e7          	jalr	-1716(ra) # 80002610 <bread>
    80002ccc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cce:	05850993          	addi	s3,a0,88
    80002cd2:	00f97793          	andi	a5,s2,15
    80002cd6:	079a                	slli	a5,a5,0x6
    80002cd8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cda:	00099783          	lh	a5,0(s3)
    80002cde:	cf9d                	beqz	a5,80002d1c <ialloc+0x94>
    brelse(bp);
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	a60080e7          	jalr	-1440(ra) # 80002740 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ce8:	0905                	addi	s2,s2,1
    80002cea:	00ca2703          	lw	a4,12(s4)
    80002cee:	0009079b          	sext.w	a5,s2
    80002cf2:	fce7e3e3          	bltu	a5,a4,80002cb8 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002cf6:	00006517          	auipc	a0,0x6
    80002cfa:	aba50513          	addi	a0,a0,-1350 # 800087b0 <syscall_names+0x170>
    80002cfe:	00003097          	auipc	ra,0x3
    80002d02:	280080e7          	jalr	640(ra) # 80005f7e <printf>
  return 0;
    80002d06:	4501                	li	a0,0
}
    80002d08:	70e2                	ld	ra,56(sp)
    80002d0a:	7442                	ld	s0,48(sp)
    80002d0c:	74a2                	ld	s1,40(sp)
    80002d0e:	7902                	ld	s2,32(sp)
    80002d10:	69e2                	ld	s3,24(sp)
    80002d12:	6a42                	ld	s4,16(sp)
    80002d14:	6aa2                	ld	s5,8(sp)
    80002d16:	6b02                	ld	s6,0(sp)
    80002d18:	6121                	addi	sp,sp,64
    80002d1a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d1c:	04000613          	li	a2,64
    80002d20:	4581                	li	a1,0
    80002d22:	854e                	mv	a0,s3
    80002d24:	ffffd097          	auipc	ra,0xffffd
    80002d28:	456080e7          	jalr	1110(ra) # 8000017a <memset>
      dip->type = type;
    80002d2c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d30:	8526                	mv	a0,s1
    80002d32:	00001097          	auipc	ra,0x1
    80002d36:	c66080e7          	jalr	-922(ra) # 80003998 <log_write>
      brelse(bp);
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	a04080e7          	jalr	-1532(ra) # 80002740 <brelse>
      return iget(dev, inum);
    80002d44:	0009059b          	sext.w	a1,s2
    80002d48:	8556                	mv	a0,s5
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	da2080e7          	jalr	-606(ra) # 80002aec <iget>
    80002d52:	bf5d                	j	80002d08 <ialloc+0x80>

0000000080002d54 <iupdate>:
{
    80002d54:	1101                	addi	sp,sp,-32
    80002d56:	ec06                	sd	ra,24(sp)
    80002d58:	e822                	sd	s0,16(sp)
    80002d5a:	e426                	sd	s1,8(sp)
    80002d5c:	e04a                	sd	s2,0(sp)
    80002d5e:	1000                	addi	s0,sp,32
    80002d60:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d62:	415c                	lw	a5,4(a0)
    80002d64:	0047d79b          	srliw	a5,a5,0x4
    80002d68:	00015597          	auipc	a1,0x15
    80002d6c:	d485a583          	lw	a1,-696(a1) # 80017ab0 <sb+0x18>
    80002d70:	9dbd                	addw	a1,a1,a5
    80002d72:	4108                	lw	a0,0(a0)
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	89c080e7          	jalr	-1892(ra) # 80002610 <bread>
    80002d7c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d7e:	05850793          	addi	a5,a0,88
    80002d82:	40d8                	lw	a4,4(s1)
    80002d84:	8b3d                	andi	a4,a4,15
    80002d86:	071a                	slli	a4,a4,0x6
    80002d88:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d8a:	04449703          	lh	a4,68(s1)
    80002d8e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d92:	04649703          	lh	a4,70(s1)
    80002d96:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d9a:	04849703          	lh	a4,72(s1)
    80002d9e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002da2:	04a49703          	lh	a4,74(s1)
    80002da6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002daa:	44f8                	lw	a4,76(s1)
    80002dac:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dae:	03400613          	li	a2,52
    80002db2:	05048593          	addi	a1,s1,80
    80002db6:	00c78513          	addi	a0,a5,12
    80002dba:	ffffd097          	auipc	ra,0xffffd
    80002dbe:	41c080e7          	jalr	1052(ra) # 800001d6 <memmove>
  log_write(bp);
    80002dc2:	854a                	mv	a0,s2
    80002dc4:	00001097          	auipc	ra,0x1
    80002dc8:	bd4080e7          	jalr	-1068(ra) # 80003998 <log_write>
  brelse(bp);
    80002dcc:	854a                	mv	a0,s2
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	972080e7          	jalr	-1678(ra) # 80002740 <brelse>
}
    80002dd6:	60e2                	ld	ra,24(sp)
    80002dd8:	6442                	ld	s0,16(sp)
    80002dda:	64a2                	ld	s1,8(sp)
    80002ddc:	6902                	ld	s2,0(sp)
    80002dde:	6105                	addi	sp,sp,32
    80002de0:	8082                	ret

0000000080002de2 <idup>:
{
    80002de2:	1101                	addi	sp,sp,-32
    80002de4:	ec06                	sd	ra,24(sp)
    80002de6:	e822                	sd	s0,16(sp)
    80002de8:	e426                	sd	s1,8(sp)
    80002dea:	1000                	addi	s0,sp,32
    80002dec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dee:	00015517          	auipc	a0,0x15
    80002df2:	cca50513          	addi	a0,a0,-822 # 80017ab8 <itable>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	644080e7          	jalr	1604(ra) # 8000643a <acquire>
  ip->ref++;
    80002dfe:	449c                	lw	a5,8(s1)
    80002e00:	2785                	addiw	a5,a5,1
    80002e02:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e04:	00015517          	auipc	a0,0x15
    80002e08:	cb450513          	addi	a0,a0,-844 # 80017ab8 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	6e2080e7          	jalr	1762(ra) # 800064ee <release>
}
    80002e14:	8526                	mv	a0,s1
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6105                	addi	sp,sp,32
    80002e1e:	8082                	ret

0000000080002e20 <ilock>:
{
    80002e20:	1101                	addi	sp,sp,-32
    80002e22:	ec06                	sd	ra,24(sp)
    80002e24:	e822                	sd	s0,16(sp)
    80002e26:	e426                	sd	s1,8(sp)
    80002e28:	e04a                	sd	s2,0(sp)
    80002e2a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e2c:	c115                	beqz	a0,80002e50 <ilock+0x30>
    80002e2e:	84aa                	mv	s1,a0
    80002e30:	451c                	lw	a5,8(a0)
    80002e32:	00f05f63          	blez	a5,80002e50 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e36:	0541                	addi	a0,a0,16
    80002e38:	00001097          	auipc	ra,0x1
    80002e3c:	c7e080e7          	jalr	-898(ra) # 80003ab6 <acquiresleep>
  if(ip->valid == 0){
    80002e40:	40bc                	lw	a5,64(s1)
    80002e42:	cf99                	beqz	a5,80002e60 <ilock+0x40>
}
    80002e44:	60e2                	ld	ra,24(sp)
    80002e46:	6442                	ld	s0,16(sp)
    80002e48:	64a2                	ld	s1,8(sp)
    80002e4a:	6902                	ld	s2,0(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret
    panic("ilock");
    80002e50:	00006517          	auipc	a0,0x6
    80002e54:	97850513          	addi	a0,a0,-1672 # 800087c8 <syscall_names+0x188>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	0d4080e7          	jalr	212(ra) # 80005f2c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e60:	40dc                	lw	a5,4(s1)
    80002e62:	0047d79b          	srliw	a5,a5,0x4
    80002e66:	00015597          	auipc	a1,0x15
    80002e6a:	c4a5a583          	lw	a1,-950(a1) # 80017ab0 <sb+0x18>
    80002e6e:	9dbd                	addw	a1,a1,a5
    80002e70:	4088                	lw	a0,0(s1)
    80002e72:	fffff097          	auipc	ra,0xfffff
    80002e76:	79e080e7          	jalr	1950(ra) # 80002610 <bread>
    80002e7a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e7c:	05850593          	addi	a1,a0,88
    80002e80:	40dc                	lw	a5,4(s1)
    80002e82:	8bbd                	andi	a5,a5,15
    80002e84:	079a                	slli	a5,a5,0x6
    80002e86:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e88:	00059783          	lh	a5,0(a1)
    80002e8c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e90:	00259783          	lh	a5,2(a1)
    80002e94:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e98:	00459783          	lh	a5,4(a1)
    80002e9c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ea0:	00659783          	lh	a5,6(a1)
    80002ea4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ea8:	459c                	lw	a5,8(a1)
    80002eaa:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002eac:	03400613          	li	a2,52
    80002eb0:	05b1                	addi	a1,a1,12
    80002eb2:	05048513          	addi	a0,s1,80
    80002eb6:	ffffd097          	auipc	ra,0xffffd
    80002eba:	320080e7          	jalr	800(ra) # 800001d6 <memmove>
    brelse(bp);
    80002ebe:	854a                	mv	a0,s2
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	880080e7          	jalr	-1920(ra) # 80002740 <brelse>
    ip->valid = 1;
    80002ec8:	4785                	li	a5,1
    80002eca:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ecc:	04449783          	lh	a5,68(s1)
    80002ed0:	fbb5                	bnez	a5,80002e44 <ilock+0x24>
      panic("ilock: no type");
    80002ed2:	00006517          	auipc	a0,0x6
    80002ed6:	8fe50513          	addi	a0,a0,-1794 # 800087d0 <syscall_names+0x190>
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	052080e7          	jalr	82(ra) # 80005f2c <panic>

0000000080002ee2 <iunlock>:
{
    80002ee2:	1101                	addi	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	e04a                	sd	s2,0(sp)
    80002eec:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002eee:	c905                	beqz	a0,80002f1e <iunlock+0x3c>
    80002ef0:	84aa                	mv	s1,a0
    80002ef2:	01050913          	addi	s2,a0,16
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	00001097          	auipc	ra,0x1
    80002efc:	c58080e7          	jalr	-936(ra) # 80003b50 <holdingsleep>
    80002f00:	cd19                	beqz	a0,80002f1e <iunlock+0x3c>
    80002f02:	449c                	lw	a5,8(s1)
    80002f04:	00f05d63          	blez	a5,80002f1e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f08:	854a                	mv	a0,s2
    80002f0a:	00001097          	auipc	ra,0x1
    80002f0e:	c02080e7          	jalr	-1022(ra) # 80003b0c <releasesleep>
}
    80002f12:	60e2                	ld	ra,24(sp)
    80002f14:	6442                	ld	s0,16(sp)
    80002f16:	64a2                	ld	s1,8(sp)
    80002f18:	6902                	ld	s2,0(sp)
    80002f1a:	6105                	addi	sp,sp,32
    80002f1c:	8082                	ret
    panic("iunlock");
    80002f1e:	00006517          	auipc	a0,0x6
    80002f22:	8c250513          	addi	a0,a0,-1854 # 800087e0 <syscall_names+0x1a0>
    80002f26:	00003097          	auipc	ra,0x3
    80002f2a:	006080e7          	jalr	6(ra) # 80005f2c <panic>

0000000080002f2e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f2e:	7179                	addi	sp,sp,-48
    80002f30:	f406                	sd	ra,40(sp)
    80002f32:	f022                	sd	s0,32(sp)
    80002f34:	ec26                	sd	s1,24(sp)
    80002f36:	e84a                	sd	s2,16(sp)
    80002f38:	e44e                	sd	s3,8(sp)
    80002f3a:	e052                	sd	s4,0(sp)
    80002f3c:	1800                	addi	s0,sp,48
    80002f3e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f40:	05050493          	addi	s1,a0,80
    80002f44:	08050913          	addi	s2,a0,128
    80002f48:	a021                	j	80002f50 <itrunc+0x22>
    80002f4a:	0491                	addi	s1,s1,4
    80002f4c:	01248d63          	beq	s1,s2,80002f66 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f50:	408c                	lw	a1,0(s1)
    80002f52:	dde5                	beqz	a1,80002f4a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f54:	0009a503          	lw	a0,0(s3)
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	8fc080e7          	jalr	-1796(ra) # 80002854 <bfree>
      ip->addrs[i] = 0;
    80002f60:	0004a023          	sw	zero,0(s1)
    80002f64:	b7dd                	j	80002f4a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f66:	0809a583          	lw	a1,128(s3)
    80002f6a:	e185                	bnez	a1,80002f8a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f6c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f70:	854e                	mv	a0,s3
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	de2080e7          	jalr	-542(ra) # 80002d54 <iupdate>
}
    80002f7a:	70a2                	ld	ra,40(sp)
    80002f7c:	7402                	ld	s0,32(sp)
    80002f7e:	64e2                	ld	s1,24(sp)
    80002f80:	6942                	ld	s2,16(sp)
    80002f82:	69a2                	ld	s3,8(sp)
    80002f84:	6a02                	ld	s4,0(sp)
    80002f86:	6145                	addi	sp,sp,48
    80002f88:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f8a:	0009a503          	lw	a0,0(s3)
    80002f8e:	fffff097          	auipc	ra,0xfffff
    80002f92:	682080e7          	jalr	1666(ra) # 80002610 <bread>
    80002f96:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f98:	05850493          	addi	s1,a0,88
    80002f9c:	45850913          	addi	s2,a0,1112
    80002fa0:	a021                	j	80002fa8 <itrunc+0x7a>
    80002fa2:	0491                	addi	s1,s1,4
    80002fa4:	01248b63          	beq	s1,s2,80002fba <itrunc+0x8c>
      if(a[j])
    80002fa8:	408c                	lw	a1,0(s1)
    80002faa:	dde5                	beqz	a1,80002fa2 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002fac:	0009a503          	lw	a0,0(s3)
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	8a4080e7          	jalr	-1884(ra) # 80002854 <bfree>
    80002fb8:	b7ed                	j	80002fa2 <itrunc+0x74>
    brelse(bp);
    80002fba:	8552                	mv	a0,s4
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	784080e7          	jalr	1924(ra) # 80002740 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fc4:	0809a583          	lw	a1,128(s3)
    80002fc8:	0009a503          	lw	a0,0(s3)
    80002fcc:	00000097          	auipc	ra,0x0
    80002fd0:	888080e7          	jalr	-1912(ra) # 80002854 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fd4:	0809a023          	sw	zero,128(s3)
    80002fd8:	bf51                	j	80002f6c <itrunc+0x3e>

0000000080002fda <iput>:
{
    80002fda:	1101                	addi	sp,sp,-32
    80002fdc:	ec06                	sd	ra,24(sp)
    80002fde:	e822                	sd	s0,16(sp)
    80002fe0:	e426                	sd	s1,8(sp)
    80002fe2:	e04a                	sd	s2,0(sp)
    80002fe4:	1000                	addi	s0,sp,32
    80002fe6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fe8:	00015517          	auipc	a0,0x15
    80002fec:	ad050513          	addi	a0,a0,-1328 # 80017ab8 <itable>
    80002ff0:	00003097          	auipc	ra,0x3
    80002ff4:	44a080e7          	jalr	1098(ra) # 8000643a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ff8:	4498                	lw	a4,8(s1)
    80002ffa:	4785                	li	a5,1
    80002ffc:	02f70363          	beq	a4,a5,80003022 <iput+0x48>
  ip->ref--;
    80003000:	449c                	lw	a5,8(s1)
    80003002:	37fd                	addiw	a5,a5,-1
    80003004:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003006:	00015517          	auipc	a0,0x15
    8000300a:	ab250513          	addi	a0,a0,-1358 # 80017ab8 <itable>
    8000300e:	00003097          	auipc	ra,0x3
    80003012:	4e0080e7          	jalr	1248(ra) # 800064ee <release>
}
    80003016:	60e2                	ld	ra,24(sp)
    80003018:	6442                	ld	s0,16(sp)
    8000301a:	64a2                	ld	s1,8(sp)
    8000301c:	6902                	ld	s2,0(sp)
    8000301e:	6105                	addi	sp,sp,32
    80003020:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003022:	40bc                	lw	a5,64(s1)
    80003024:	dff1                	beqz	a5,80003000 <iput+0x26>
    80003026:	04a49783          	lh	a5,74(s1)
    8000302a:	fbf9                	bnez	a5,80003000 <iput+0x26>
    acquiresleep(&ip->lock);
    8000302c:	01048913          	addi	s2,s1,16
    80003030:	854a                	mv	a0,s2
    80003032:	00001097          	auipc	ra,0x1
    80003036:	a84080e7          	jalr	-1404(ra) # 80003ab6 <acquiresleep>
    release(&itable.lock);
    8000303a:	00015517          	auipc	a0,0x15
    8000303e:	a7e50513          	addi	a0,a0,-1410 # 80017ab8 <itable>
    80003042:	00003097          	auipc	ra,0x3
    80003046:	4ac080e7          	jalr	1196(ra) # 800064ee <release>
    itrunc(ip);
    8000304a:	8526                	mv	a0,s1
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	ee2080e7          	jalr	-286(ra) # 80002f2e <itrunc>
    ip->type = 0;
    80003054:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003058:	8526                	mv	a0,s1
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	cfa080e7          	jalr	-774(ra) # 80002d54 <iupdate>
    ip->valid = 0;
    80003062:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003066:	854a                	mv	a0,s2
    80003068:	00001097          	auipc	ra,0x1
    8000306c:	aa4080e7          	jalr	-1372(ra) # 80003b0c <releasesleep>
    acquire(&itable.lock);
    80003070:	00015517          	auipc	a0,0x15
    80003074:	a4850513          	addi	a0,a0,-1464 # 80017ab8 <itable>
    80003078:	00003097          	auipc	ra,0x3
    8000307c:	3c2080e7          	jalr	962(ra) # 8000643a <acquire>
    80003080:	b741                	j	80003000 <iput+0x26>

0000000080003082 <iunlockput>:
{
    80003082:	1101                	addi	sp,sp,-32
    80003084:	ec06                	sd	ra,24(sp)
    80003086:	e822                	sd	s0,16(sp)
    80003088:	e426                	sd	s1,8(sp)
    8000308a:	1000                	addi	s0,sp,32
    8000308c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000308e:	00000097          	auipc	ra,0x0
    80003092:	e54080e7          	jalr	-428(ra) # 80002ee2 <iunlock>
  iput(ip);
    80003096:	8526                	mv	a0,s1
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	f42080e7          	jalr	-190(ra) # 80002fda <iput>
}
    800030a0:	60e2                	ld	ra,24(sp)
    800030a2:	6442                	ld	s0,16(sp)
    800030a4:	64a2                	ld	s1,8(sp)
    800030a6:	6105                	addi	sp,sp,32
    800030a8:	8082                	ret

00000000800030aa <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030aa:	1141                	addi	sp,sp,-16
    800030ac:	e422                	sd	s0,8(sp)
    800030ae:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030b0:	411c                	lw	a5,0(a0)
    800030b2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030b4:	415c                	lw	a5,4(a0)
    800030b6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030b8:	04451783          	lh	a5,68(a0)
    800030bc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030c0:	04a51783          	lh	a5,74(a0)
    800030c4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030c8:	04c56783          	lwu	a5,76(a0)
    800030cc:	e99c                	sd	a5,16(a1)
}
    800030ce:	6422                	ld	s0,8(sp)
    800030d0:	0141                	addi	sp,sp,16
    800030d2:	8082                	ret

00000000800030d4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030d4:	457c                	lw	a5,76(a0)
    800030d6:	0ed7e963          	bltu	a5,a3,800031c8 <readi+0xf4>
{
    800030da:	7159                	addi	sp,sp,-112
    800030dc:	f486                	sd	ra,104(sp)
    800030de:	f0a2                	sd	s0,96(sp)
    800030e0:	eca6                	sd	s1,88(sp)
    800030e2:	e8ca                	sd	s2,80(sp)
    800030e4:	e4ce                	sd	s3,72(sp)
    800030e6:	e0d2                	sd	s4,64(sp)
    800030e8:	fc56                	sd	s5,56(sp)
    800030ea:	f85a                	sd	s6,48(sp)
    800030ec:	f45e                	sd	s7,40(sp)
    800030ee:	f062                	sd	s8,32(sp)
    800030f0:	ec66                	sd	s9,24(sp)
    800030f2:	e86a                	sd	s10,16(sp)
    800030f4:	e46e                	sd	s11,8(sp)
    800030f6:	1880                	addi	s0,sp,112
    800030f8:	8b2a                	mv	s6,a0
    800030fa:	8bae                	mv	s7,a1
    800030fc:	8a32                	mv	s4,a2
    800030fe:	84b6                	mv	s1,a3
    80003100:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003102:	9f35                	addw	a4,a4,a3
    return 0;
    80003104:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003106:	0ad76063          	bltu	a4,a3,800031a6 <readi+0xd2>
  if(off + n > ip->size)
    8000310a:	00e7f463          	bgeu	a5,a4,80003112 <readi+0x3e>
    n = ip->size - off;
    8000310e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003112:	0a0a8963          	beqz	s5,800031c4 <readi+0xf0>
    80003116:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003118:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000311c:	5c7d                	li	s8,-1
    8000311e:	a82d                	j	80003158 <readi+0x84>
    80003120:	020d1d93          	slli	s11,s10,0x20
    80003124:	020ddd93          	srli	s11,s11,0x20
    80003128:	05890613          	addi	a2,s2,88
    8000312c:	86ee                	mv	a3,s11
    8000312e:	963a                	add	a2,a2,a4
    80003130:	85d2                	mv	a1,s4
    80003132:	855e                	mv	a0,s7
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	a18080e7          	jalr	-1512(ra) # 80001b4c <either_copyout>
    8000313c:	05850d63          	beq	a0,s8,80003196 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003140:	854a                	mv	a0,s2
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	5fe080e7          	jalr	1534(ra) # 80002740 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000314a:	013d09bb          	addw	s3,s10,s3
    8000314e:	009d04bb          	addw	s1,s10,s1
    80003152:	9a6e                	add	s4,s4,s11
    80003154:	0559f763          	bgeu	s3,s5,800031a2 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003158:	00a4d59b          	srliw	a1,s1,0xa
    8000315c:	855a                	mv	a0,s6
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	8a4080e7          	jalr	-1884(ra) # 80002a02 <bmap>
    80003166:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000316a:	cd85                	beqz	a1,800031a2 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000316c:	000b2503          	lw	a0,0(s6)
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	4a0080e7          	jalr	1184(ra) # 80002610 <bread>
    80003178:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000317a:	3ff4f713          	andi	a4,s1,1023
    8000317e:	40ec87bb          	subw	a5,s9,a4
    80003182:	413a86bb          	subw	a3,s5,s3
    80003186:	8d3e                	mv	s10,a5
    80003188:	2781                	sext.w	a5,a5
    8000318a:	0006861b          	sext.w	a2,a3
    8000318e:	f8f679e3          	bgeu	a2,a5,80003120 <readi+0x4c>
    80003192:	8d36                	mv	s10,a3
    80003194:	b771                	j	80003120 <readi+0x4c>
      brelse(bp);
    80003196:	854a                	mv	a0,s2
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	5a8080e7          	jalr	1448(ra) # 80002740 <brelse>
      tot = -1;
    800031a0:	59fd                	li	s3,-1
  }
  return tot;
    800031a2:	0009851b          	sext.w	a0,s3
}
    800031a6:	70a6                	ld	ra,104(sp)
    800031a8:	7406                	ld	s0,96(sp)
    800031aa:	64e6                	ld	s1,88(sp)
    800031ac:	6946                	ld	s2,80(sp)
    800031ae:	69a6                	ld	s3,72(sp)
    800031b0:	6a06                	ld	s4,64(sp)
    800031b2:	7ae2                	ld	s5,56(sp)
    800031b4:	7b42                	ld	s6,48(sp)
    800031b6:	7ba2                	ld	s7,40(sp)
    800031b8:	7c02                	ld	s8,32(sp)
    800031ba:	6ce2                	ld	s9,24(sp)
    800031bc:	6d42                	ld	s10,16(sp)
    800031be:	6da2                	ld	s11,8(sp)
    800031c0:	6165                	addi	sp,sp,112
    800031c2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031c4:	89d6                	mv	s3,s5
    800031c6:	bff1                	j	800031a2 <readi+0xce>
    return 0;
    800031c8:	4501                	li	a0,0
}
    800031ca:	8082                	ret

00000000800031cc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031cc:	457c                	lw	a5,76(a0)
    800031ce:	10d7e863          	bltu	a5,a3,800032de <writei+0x112>
{
    800031d2:	7159                	addi	sp,sp,-112
    800031d4:	f486                	sd	ra,104(sp)
    800031d6:	f0a2                	sd	s0,96(sp)
    800031d8:	eca6                	sd	s1,88(sp)
    800031da:	e8ca                	sd	s2,80(sp)
    800031dc:	e4ce                	sd	s3,72(sp)
    800031de:	e0d2                	sd	s4,64(sp)
    800031e0:	fc56                	sd	s5,56(sp)
    800031e2:	f85a                	sd	s6,48(sp)
    800031e4:	f45e                	sd	s7,40(sp)
    800031e6:	f062                	sd	s8,32(sp)
    800031e8:	ec66                	sd	s9,24(sp)
    800031ea:	e86a                	sd	s10,16(sp)
    800031ec:	e46e                	sd	s11,8(sp)
    800031ee:	1880                	addi	s0,sp,112
    800031f0:	8aaa                	mv	s5,a0
    800031f2:	8bae                	mv	s7,a1
    800031f4:	8a32                	mv	s4,a2
    800031f6:	8936                	mv	s2,a3
    800031f8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800031fa:	00e687bb          	addw	a5,a3,a4
    800031fe:	0ed7e263          	bltu	a5,a3,800032e2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003202:	00043737          	lui	a4,0x43
    80003206:	0ef76063          	bltu	a4,a5,800032e6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000320a:	0c0b0863          	beqz	s6,800032da <writei+0x10e>
    8000320e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003210:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003214:	5c7d                	li	s8,-1
    80003216:	a091                	j	8000325a <writei+0x8e>
    80003218:	020d1d93          	slli	s11,s10,0x20
    8000321c:	020ddd93          	srli	s11,s11,0x20
    80003220:	05848513          	addi	a0,s1,88
    80003224:	86ee                	mv	a3,s11
    80003226:	8652                	mv	a2,s4
    80003228:	85de                	mv	a1,s7
    8000322a:	953a                	add	a0,a0,a4
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	976080e7          	jalr	-1674(ra) # 80001ba2 <either_copyin>
    80003234:	07850263          	beq	a0,s8,80003298 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003238:	8526                	mv	a0,s1
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	75e080e7          	jalr	1886(ra) # 80003998 <log_write>
    brelse(bp);
    80003242:	8526                	mv	a0,s1
    80003244:	fffff097          	auipc	ra,0xfffff
    80003248:	4fc080e7          	jalr	1276(ra) # 80002740 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000324c:	013d09bb          	addw	s3,s10,s3
    80003250:	012d093b          	addw	s2,s10,s2
    80003254:	9a6e                	add	s4,s4,s11
    80003256:	0569f663          	bgeu	s3,s6,800032a2 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000325a:	00a9559b          	srliw	a1,s2,0xa
    8000325e:	8556                	mv	a0,s5
    80003260:	fffff097          	auipc	ra,0xfffff
    80003264:	7a2080e7          	jalr	1954(ra) # 80002a02 <bmap>
    80003268:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000326c:	c99d                	beqz	a1,800032a2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000326e:	000aa503          	lw	a0,0(s5)
    80003272:	fffff097          	auipc	ra,0xfffff
    80003276:	39e080e7          	jalr	926(ra) # 80002610 <bread>
    8000327a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000327c:	3ff97713          	andi	a4,s2,1023
    80003280:	40ec87bb          	subw	a5,s9,a4
    80003284:	413b06bb          	subw	a3,s6,s3
    80003288:	8d3e                	mv	s10,a5
    8000328a:	2781                	sext.w	a5,a5
    8000328c:	0006861b          	sext.w	a2,a3
    80003290:	f8f674e3          	bgeu	a2,a5,80003218 <writei+0x4c>
    80003294:	8d36                	mv	s10,a3
    80003296:	b749                	j	80003218 <writei+0x4c>
      brelse(bp);
    80003298:	8526                	mv	a0,s1
    8000329a:	fffff097          	auipc	ra,0xfffff
    8000329e:	4a6080e7          	jalr	1190(ra) # 80002740 <brelse>
  }

  if(off > ip->size)
    800032a2:	04caa783          	lw	a5,76(s5)
    800032a6:	0127f463          	bgeu	a5,s2,800032ae <writei+0xe2>
    ip->size = off;
    800032aa:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032ae:	8556                	mv	a0,s5
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	aa4080e7          	jalr	-1372(ra) # 80002d54 <iupdate>

  return tot;
    800032b8:	0009851b          	sext.w	a0,s3
}
    800032bc:	70a6                	ld	ra,104(sp)
    800032be:	7406                	ld	s0,96(sp)
    800032c0:	64e6                	ld	s1,88(sp)
    800032c2:	6946                	ld	s2,80(sp)
    800032c4:	69a6                	ld	s3,72(sp)
    800032c6:	6a06                	ld	s4,64(sp)
    800032c8:	7ae2                	ld	s5,56(sp)
    800032ca:	7b42                	ld	s6,48(sp)
    800032cc:	7ba2                	ld	s7,40(sp)
    800032ce:	7c02                	ld	s8,32(sp)
    800032d0:	6ce2                	ld	s9,24(sp)
    800032d2:	6d42                	ld	s10,16(sp)
    800032d4:	6da2                	ld	s11,8(sp)
    800032d6:	6165                	addi	sp,sp,112
    800032d8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032da:	89da                	mv	s3,s6
    800032dc:	bfc9                	j	800032ae <writei+0xe2>
    return -1;
    800032de:	557d                	li	a0,-1
}
    800032e0:	8082                	ret
    return -1;
    800032e2:	557d                	li	a0,-1
    800032e4:	bfe1                	j	800032bc <writei+0xf0>
    return -1;
    800032e6:	557d                	li	a0,-1
    800032e8:	bfd1                	j	800032bc <writei+0xf0>

00000000800032ea <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032ea:	1141                	addi	sp,sp,-16
    800032ec:	e406                	sd	ra,8(sp)
    800032ee:	e022                	sd	s0,0(sp)
    800032f0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032f2:	4639                	li	a2,14
    800032f4:	ffffd097          	auipc	ra,0xffffd
    800032f8:	f56080e7          	jalr	-170(ra) # 8000024a <strncmp>
}
    800032fc:	60a2                	ld	ra,8(sp)
    800032fe:	6402                	ld	s0,0(sp)
    80003300:	0141                	addi	sp,sp,16
    80003302:	8082                	ret

0000000080003304 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003304:	7139                	addi	sp,sp,-64
    80003306:	fc06                	sd	ra,56(sp)
    80003308:	f822                	sd	s0,48(sp)
    8000330a:	f426                	sd	s1,40(sp)
    8000330c:	f04a                	sd	s2,32(sp)
    8000330e:	ec4e                	sd	s3,24(sp)
    80003310:	e852                	sd	s4,16(sp)
    80003312:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003314:	04451703          	lh	a4,68(a0)
    80003318:	4785                	li	a5,1
    8000331a:	00f71a63          	bne	a4,a5,8000332e <dirlookup+0x2a>
    8000331e:	892a                	mv	s2,a0
    80003320:	89ae                	mv	s3,a1
    80003322:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003324:	457c                	lw	a5,76(a0)
    80003326:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003328:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000332a:	e79d                	bnez	a5,80003358 <dirlookup+0x54>
    8000332c:	a8a5                	j	800033a4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000332e:	00005517          	auipc	a0,0x5
    80003332:	4ba50513          	addi	a0,a0,1210 # 800087e8 <syscall_names+0x1a8>
    80003336:	00003097          	auipc	ra,0x3
    8000333a:	bf6080e7          	jalr	-1034(ra) # 80005f2c <panic>
      panic("dirlookup read");
    8000333e:	00005517          	auipc	a0,0x5
    80003342:	4c250513          	addi	a0,a0,1218 # 80008800 <syscall_names+0x1c0>
    80003346:	00003097          	auipc	ra,0x3
    8000334a:	be6080e7          	jalr	-1050(ra) # 80005f2c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000334e:	24c1                	addiw	s1,s1,16
    80003350:	04c92783          	lw	a5,76(s2)
    80003354:	04f4f763          	bgeu	s1,a5,800033a2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003358:	4741                	li	a4,16
    8000335a:	86a6                	mv	a3,s1
    8000335c:	fc040613          	addi	a2,s0,-64
    80003360:	4581                	li	a1,0
    80003362:	854a                	mv	a0,s2
    80003364:	00000097          	auipc	ra,0x0
    80003368:	d70080e7          	jalr	-656(ra) # 800030d4 <readi>
    8000336c:	47c1                	li	a5,16
    8000336e:	fcf518e3          	bne	a0,a5,8000333e <dirlookup+0x3a>
    if(de.inum == 0)
    80003372:	fc045783          	lhu	a5,-64(s0)
    80003376:	dfe1                	beqz	a5,8000334e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003378:	fc240593          	addi	a1,s0,-62
    8000337c:	854e                	mv	a0,s3
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	f6c080e7          	jalr	-148(ra) # 800032ea <namecmp>
    80003386:	f561                	bnez	a0,8000334e <dirlookup+0x4a>
      if(poff)
    80003388:	000a0463          	beqz	s4,80003390 <dirlookup+0x8c>
        *poff = off;
    8000338c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003390:	fc045583          	lhu	a1,-64(s0)
    80003394:	00092503          	lw	a0,0(s2)
    80003398:	fffff097          	auipc	ra,0xfffff
    8000339c:	754080e7          	jalr	1876(ra) # 80002aec <iget>
    800033a0:	a011                	j	800033a4 <dirlookup+0xa0>
  return 0;
    800033a2:	4501                	li	a0,0
}
    800033a4:	70e2                	ld	ra,56(sp)
    800033a6:	7442                	ld	s0,48(sp)
    800033a8:	74a2                	ld	s1,40(sp)
    800033aa:	7902                	ld	s2,32(sp)
    800033ac:	69e2                	ld	s3,24(sp)
    800033ae:	6a42                	ld	s4,16(sp)
    800033b0:	6121                	addi	sp,sp,64
    800033b2:	8082                	ret

00000000800033b4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033b4:	711d                	addi	sp,sp,-96
    800033b6:	ec86                	sd	ra,88(sp)
    800033b8:	e8a2                	sd	s0,80(sp)
    800033ba:	e4a6                	sd	s1,72(sp)
    800033bc:	e0ca                	sd	s2,64(sp)
    800033be:	fc4e                	sd	s3,56(sp)
    800033c0:	f852                	sd	s4,48(sp)
    800033c2:	f456                	sd	s5,40(sp)
    800033c4:	f05a                	sd	s6,32(sp)
    800033c6:	ec5e                	sd	s7,24(sp)
    800033c8:	e862                	sd	s8,16(sp)
    800033ca:	e466                	sd	s9,8(sp)
    800033cc:	1080                	addi	s0,sp,96
    800033ce:	84aa                	mv	s1,a0
    800033d0:	8b2e                	mv	s6,a1
    800033d2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033d4:	00054703          	lbu	a4,0(a0)
    800033d8:	02f00793          	li	a5,47
    800033dc:	02f70263          	beq	a4,a5,80003400 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033e0:	ffffe097          	auipc	ra,0xffffe
    800033e4:	bf8080e7          	jalr	-1032(ra) # 80000fd8 <myproc>
    800033e8:	15053503          	ld	a0,336(a0)
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	9f6080e7          	jalr	-1546(ra) # 80002de2 <idup>
    800033f4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800033f6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800033fa:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033fc:	4b85                	li	s7,1
    800033fe:	a875                	j	800034ba <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003400:	4585                	li	a1,1
    80003402:	4505                	li	a0,1
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	6e8080e7          	jalr	1768(ra) # 80002aec <iget>
    8000340c:	8a2a                	mv	s4,a0
    8000340e:	b7e5                	j	800033f6 <namex+0x42>
      iunlockput(ip);
    80003410:	8552                	mv	a0,s4
    80003412:	00000097          	auipc	ra,0x0
    80003416:	c70080e7          	jalr	-912(ra) # 80003082 <iunlockput>
      return 0;
    8000341a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000341c:	8552                	mv	a0,s4
    8000341e:	60e6                	ld	ra,88(sp)
    80003420:	6446                	ld	s0,80(sp)
    80003422:	64a6                	ld	s1,72(sp)
    80003424:	6906                	ld	s2,64(sp)
    80003426:	79e2                	ld	s3,56(sp)
    80003428:	7a42                	ld	s4,48(sp)
    8000342a:	7aa2                	ld	s5,40(sp)
    8000342c:	7b02                	ld	s6,32(sp)
    8000342e:	6be2                	ld	s7,24(sp)
    80003430:	6c42                	ld	s8,16(sp)
    80003432:	6ca2                	ld	s9,8(sp)
    80003434:	6125                	addi	sp,sp,96
    80003436:	8082                	ret
      iunlock(ip);
    80003438:	8552                	mv	a0,s4
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	aa8080e7          	jalr	-1368(ra) # 80002ee2 <iunlock>
      return ip;
    80003442:	bfe9                	j	8000341c <namex+0x68>
      iunlockput(ip);
    80003444:	8552                	mv	a0,s4
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	c3c080e7          	jalr	-964(ra) # 80003082 <iunlockput>
      return 0;
    8000344e:	8a4e                	mv	s4,s3
    80003450:	b7f1                	j	8000341c <namex+0x68>
  len = path - s;
    80003452:	40998633          	sub	a2,s3,s1
    80003456:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000345a:	099c5863          	bge	s8,s9,800034ea <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000345e:	4639                	li	a2,14
    80003460:	85a6                	mv	a1,s1
    80003462:	8556                	mv	a0,s5
    80003464:	ffffd097          	auipc	ra,0xffffd
    80003468:	d72080e7          	jalr	-654(ra) # 800001d6 <memmove>
    8000346c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000346e:	0004c783          	lbu	a5,0(s1)
    80003472:	01279763          	bne	a5,s2,80003480 <namex+0xcc>
    path++;
    80003476:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003478:	0004c783          	lbu	a5,0(s1)
    8000347c:	ff278de3          	beq	a5,s2,80003476 <namex+0xc2>
    ilock(ip);
    80003480:	8552                	mv	a0,s4
    80003482:	00000097          	auipc	ra,0x0
    80003486:	99e080e7          	jalr	-1634(ra) # 80002e20 <ilock>
    if(ip->type != T_DIR){
    8000348a:	044a1783          	lh	a5,68(s4)
    8000348e:	f97791e3          	bne	a5,s7,80003410 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003492:	000b0563          	beqz	s6,8000349c <namex+0xe8>
    80003496:	0004c783          	lbu	a5,0(s1)
    8000349a:	dfd9                	beqz	a5,80003438 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000349c:	4601                	li	a2,0
    8000349e:	85d6                	mv	a1,s5
    800034a0:	8552                	mv	a0,s4
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	e62080e7          	jalr	-414(ra) # 80003304 <dirlookup>
    800034aa:	89aa                	mv	s3,a0
    800034ac:	dd41                	beqz	a0,80003444 <namex+0x90>
    iunlockput(ip);
    800034ae:	8552                	mv	a0,s4
    800034b0:	00000097          	auipc	ra,0x0
    800034b4:	bd2080e7          	jalr	-1070(ra) # 80003082 <iunlockput>
    ip = next;
    800034b8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034ba:	0004c783          	lbu	a5,0(s1)
    800034be:	01279763          	bne	a5,s2,800034cc <namex+0x118>
    path++;
    800034c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034c4:	0004c783          	lbu	a5,0(s1)
    800034c8:	ff278de3          	beq	a5,s2,800034c2 <namex+0x10e>
  if(*path == 0)
    800034cc:	cb9d                	beqz	a5,80003502 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800034ce:	0004c783          	lbu	a5,0(s1)
    800034d2:	89a6                	mv	s3,s1
  len = path - s;
    800034d4:	4c81                	li	s9,0
    800034d6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800034d8:	01278963          	beq	a5,s2,800034ea <namex+0x136>
    800034dc:	dbbd                	beqz	a5,80003452 <namex+0x9e>
    path++;
    800034de:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800034e0:	0009c783          	lbu	a5,0(s3)
    800034e4:	ff279ce3          	bne	a5,s2,800034dc <namex+0x128>
    800034e8:	b7ad                	j	80003452 <namex+0x9e>
    memmove(name, s, len);
    800034ea:	2601                	sext.w	a2,a2
    800034ec:	85a6                	mv	a1,s1
    800034ee:	8556                	mv	a0,s5
    800034f0:	ffffd097          	auipc	ra,0xffffd
    800034f4:	ce6080e7          	jalr	-794(ra) # 800001d6 <memmove>
    name[len] = 0;
    800034f8:	9cd6                	add	s9,s9,s5
    800034fa:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800034fe:	84ce                	mv	s1,s3
    80003500:	b7bd                	j	8000346e <namex+0xba>
  if(nameiparent){
    80003502:	f00b0de3          	beqz	s6,8000341c <namex+0x68>
    iput(ip);
    80003506:	8552                	mv	a0,s4
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	ad2080e7          	jalr	-1326(ra) # 80002fda <iput>
    return 0;
    80003510:	4a01                	li	s4,0
    80003512:	b729                	j	8000341c <namex+0x68>

0000000080003514 <dirlink>:
{
    80003514:	7139                	addi	sp,sp,-64
    80003516:	fc06                	sd	ra,56(sp)
    80003518:	f822                	sd	s0,48(sp)
    8000351a:	f426                	sd	s1,40(sp)
    8000351c:	f04a                	sd	s2,32(sp)
    8000351e:	ec4e                	sd	s3,24(sp)
    80003520:	e852                	sd	s4,16(sp)
    80003522:	0080                	addi	s0,sp,64
    80003524:	892a                	mv	s2,a0
    80003526:	8a2e                	mv	s4,a1
    80003528:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000352a:	4601                	li	a2,0
    8000352c:	00000097          	auipc	ra,0x0
    80003530:	dd8080e7          	jalr	-552(ra) # 80003304 <dirlookup>
    80003534:	e93d                	bnez	a0,800035aa <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003536:	04c92483          	lw	s1,76(s2)
    8000353a:	c49d                	beqz	s1,80003568 <dirlink+0x54>
    8000353c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000353e:	4741                	li	a4,16
    80003540:	86a6                	mv	a3,s1
    80003542:	fc040613          	addi	a2,s0,-64
    80003546:	4581                	li	a1,0
    80003548:	854a                	mv	a0,s2
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	b8a080e7          	jalr	-1142(ra) # 800030d4 <readi>
    80003552:	47c1                	li	a5,16
    80003554:	06f51163          	bne	a0,a5,800035b6 <dirlink+0xa2>
    if(de.inum == 0)
    80003558:	fc045783          	lhu	a5,-64(s0)
    8000355c:	c791                	beqz	a5,80003568 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000355e:	24c1                	addiw	s1,s1,16
    80003560:	04c92783          	lw	a5,76(s2)
    80003564:	fcf4ede3          	bltu	s1,a5,8000353e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003568:	4639                	li	a2,14
    8000356a:	85d2                	mv	a1,s4
    8000356c:	fc240513          	addi	a0,s0,-62
    80003570:	ffffd097          	auipc	ra,0xffffd
    80003574:	d16080e7          	jalr	-746(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003578:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000357c:	4741                	li	a4,16
    8000357e:	86a6                	mv	a3,s1
    80003580:	fc040613          	addi	a2,s0,-64
    80003584:	4581                	li	a1,0
    80003586:	854a                	mv	a0,s2
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	c44080e7          	jalr	-956(ra) # 800031cc <writei>
    80003590:	1541                	addi	a0,a0,-16
    80003592:	00a03533          	snez	a0,a0
    80003596:	40a00533          	neg	a0,a0
}
    8000359a:	70e2                	ld	ra,56(sp)
    8000359c:	7442                	ld	s0,48(sp)
    8000359e:	74a2                	ld	s1,40(sp)
    800035a0:	7902                	ld	s2,32(sp)
    800035a2:	69e2                	ld	s3,24(sp)
    800035a4:	6a42                	ld	s4,16(sp)
    800035a6:	6121                	addi	sp,sp,64
    800035a8:	8082                	ret
    iput(ip);
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	a30080e7          	jalr	-1488(ra) # 80002fda <iput>
    return -1;
    800035b2:	557d                	li	a0,-1
    800035b4:	b7dd                	j	8000359a <dirlink+0x86>
      panic("dirlink read");
    800035b6:	00005517          	auipc	a0,0x5
    800035ba:	25a50513          	addi	a0,a0,602 # 80008810 <syscall_names+0x1d0>
    800035be:	00003097          	auipc	ra,0x3
    800035c2:	96e080e7          	jalr	-1682(ra) # 80005f2c <panic>

00000000800035c6 <namei>:

struct inode*
namei(char *path)
{
    800035c6:	1101                	addi	sp,sp,-32
    800035c8:	ec06                	sd	ra,24(sp)
    800035ca:	e822                	sd	s0,16(sp)
    800035cc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035ce:	fe040613          	addi	a2,s0,-32
    800035d2:	4581                	li	a1,0
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	de0080e7          	jalr	-544(ra) # 800033b4 <namex>
}
    800035dc:	60e2                	ld	ra,24(sp)
    800035de:	6442                	ld	s0,16(sp)
    800035e0:	6105                	addi	sp,sp,32
    800035e2:	8082                	ret

00000000800035e4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035e4:	1141                	addi	sp,sp,-16
    800035e6:	e406                	sd	ra,8(sp)
    800035e8:	e022                	sd	s0,0(sp)
    800035ea:	0800                	addi	s0,sp,16
    800035ec:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035ee:	4585                	li	a1,1
    800035f0:	00000097          	auipc	ra,0x0
    800035f4:	dc4080e7          	jalr	-572(ra) # 800033b4 <namex>
}
    800035f8:	60a2                	ld	ra,8(sp)
    800035fa:	6402                	ld	s0,0(sp)
    800035fc:	0141                	addi	sp,sp,16
    800035fe:	8082                	ret

0000000080003600 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003600:	1101                	addi	sp,sp,-32
    80003602:	ec06                	sd	ra,24(sp)
    80003604:	e822                	sd	s0,16(sp)
    80003606:	e426                	sd	s1,8(sp)
    80003608:	e04a                	sd	s2,0(sp)
    8000360a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000360c:	00016917          	auipc	s2,0x16
    80003610:	f5490913          	addi	s2,s2,-172 # 80019560 <log>
    80003614:	01892583          	lw	a1,24(s2)
    80003618:	02892503          	lw	a0,40(s2)
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	ff4080e7          	jalr	-12(ra) # 80002610 <bread>
    80003624:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003626:	02c92603          	lw	a2,44(s2)
    8000362a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000362c:	00c05f63          	blez	a2,8000364a <write_head+0x4a>
    80003630:	00016717          	auipc	a4,0x16
    80003634:	f6070713          	addi	a4,a4,-160 # 80019590 <log+0x30>
    80003638:	87aa                	mv	a5,a0
    8000363a:	060a                	slli	a2,a2,0x2
    8000363c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000363e:	4314                	lw	a3,0(a4)
    80003640:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003642:	0711                	addi	a4,a4,4
    80003644:	0791                	addi	a5,a5,4
    80003646:	fec79ce3          	bne	a5,a2,8000363e <write_head+0x3e>
  }
  bwrite(buf);
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	0b6080e7          	jalr	182(ra) # 80002702 <bwrite>
  brelse(buf);
    80003654:	8526                	mv	a0,s1
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	0ea080e7          	jalr	234(ra) # 80002740 <brelse>
}
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	64a2                	ld	s1,8(sp)
    80003664:	6902                	ld	s2,0(sp)
    80003666:	6105                	addi	sp,sp,32
    80003668:	8082                	ret

000000008000366a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000366a:	00016797          	auipc	a5,0x16
    8000366e:	f227a783          	lw	a5,-222(a5) # 8001958c <log+0x2c>
    80003672:	0af05d63          	blez	a5,8000372c <install_trans+0xc2>
{
    80003676:	7139                	addi	sp,sp,-64
    80003678:	fc06                	sd	ra,56(sp)
    8000367a:	f822                	sd	s0,48(sp)
    8000367c:	f426                	sd	s1,40(sp)
    8000367e:	f04a                	sd	s2,32(sp)
    80003680:	ec4e                	sd	s3,24(sp)
    80003682:	e852                	sd	s4,16(sp)
    80003684:	e456                	sd	s5,8(sp)
    80003686:	e05a                	sd	s6,0(sp)
    80003688:	0080                	addi	s0,sp,64
    8000368a:	8b2a                	mv	s6,a0
    8000368c:	00016a97          	auipc	s5,0x16
    80003690:	f04a8a93          	addi	s5,s5,-252 # 80019590 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003694:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003696:	00016997          	auipc	s3,0x16
    8000369a:	eca98993          	addi	s3,s3,-310 # 80019560 <log>
    8000369e:	a00d                	j	800036c0 <install_trans+0x56>
    brelse(lbuf);
    800036a0:	854a                	mv	a0,s2
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	09e080e7          	jalr	158(ra) # 80002740 <brelse>
    brelse(dbuf);
    800036aa:	8526                	mv	a0,s1
    800036ac:	fffff097          	auipc	ra,0xfffff
    800036b0:	094080e7          	jalr	148(ra) # 80002740 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b4:	2a05                	addiw	s4,s4,1
    800036b6:	0a91                	addi	s5,s5,4
    800036b8:	02c9a783          	lw	a5,44(s3)
    800036bc:	04fa5e63          	bge	s4,a5,80003718 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036c0:	0189a583          	lw	a1,24(s3)
    800036c4:	014585bb          	addw	a1,a1,s4
    800036c8:	2585                	addiw	a1,a1,1
    800036ca:	0289a503          	lw	a0,40(s3)
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	f42080e7          	jalr	-190(ra) # 80002610 <bread>
    800036d6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036d8:	000aa583          	lw	a1,0(s5)
    800036dc:	0289a503          	lw	a0,40(s3)
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	f30080e7          	jalr	-208(ra) # 80002610 <bread>
    800036e8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036ea:	40000613          	li	a2,1024
    800036ee:	05890593          	addi	a1,s2,88
    800036f2:	05850513          	addi	a0,a0,88
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	ae0080e7          	jalr	-1312(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036fe:	8526                	mv	a0,s1
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	002080e7          	jalr	2(ra) # 80002702 <bwrite>
    if(recovering == 0)
    80003708:	f80b1ce3          	bnez	s6,800036a0 <install_trans+0x36>
      bunpin(dbuf);
    8000370c:	8526                	mv	a0,s1
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	10a080e7          	jalr	266(ra) # 80002818 <bunpin>
    80003716:	b769                	j	800036a0 <install_trans+0x36>
}
    80003718:	70e2                	ld	ra,56(sp)
    8000371a:	7442                	ld	s0,48(sp)
    8000371c:	74a2                	ld	s1,40(sp)
    8000371e:	7902                	ld	s2,32(sp)
    80003720:	69e2                	ld	s3,24(sp)
    80003722:	6a42                	ld	s4,16(sp)
    80003724:	6aa2                	ld	s5,8(sp)
    80003726:	6b02                	ld	s6,0(sp)
    80003728:	6121                	addi	sp,sp,64
    8000372a:	8082                	ret
    8000372c:	8082                	ret

000000008000372e <initlog>:
{
    8000372e:	7179                	addi	sp,sp,-48
    80003730:	f406                	sd	ra,40(sp)
    80003732:	f022                	sd	s0,32(sp)
    80003734:	ec26                	sd	s1,24(sp)
    80003736:	e84a                	sd	s2,16(sp)
    80003738:	e44e                	sd	s3,8(sp)
    8000373a:	1800                	addi	s0,sp,48
    8000373c:	892a                	mv	s2,a0
    8000373e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003740:	00016497          	auipc	s1,0x16
    80003744:	e2048493          	addi	s1,s1,-480 # 80019560 <log>
    80003748:	00005597          	auipc	a1,0x5
    8000374c:	0d858593          	addi	a1,a1,216 # 80008820 <syscall_names+0x1e0>
    80003750:	8526                	mv	a0,s1
    80003752:	00003097          	auipc	ra,0x3
    80003756:	c58080e7          	jalr	-936(ra) # 800063aa <initlock>
  log.start = sb->logstart;
    8000375a:	0149a583          	lw	a1,20(s3)
    8000375e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003760:	0109a783          	lw	a5,16(s3)
    80003764:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003766:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000376a:	854a                	mv	a0,s2
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	ea4080e7          	jalr	-348(ra) # 80002610 <bread>
  log.lh.n = lh->n;
    80003774:	4d30                	lw	a2,88(a0)
    80003776:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003778:	00c05f63          	blez	a2,80003796 <initlog+0x68>
    8000377c:	87aa                	mv	a5,a0
    8000377e:	00016717          	auipc	a4,0x16
    80003782:	e1270713          	addi	a4,a4,-494 # 80019590 <log+0x30>
    80003786:	060a                	slli	a2,a2,0x2
    80003788:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000378a:	4ff4                	lw	a3,92(a5)
    8000378c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000378e:	0791                	addi	a5,a5,4
    80003790:	0711                	addi	a4,a4,4
    80003792:	fec79ce3          	bne	a5,a2,8000378a <initlog+0x5c>
  brelse(buf);
    80003796:	fffff097          	auipc	ra,0xfffff
    8000379a:	faa080e7          	jalr	-86(ra) # 80002740 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000379e:	4505                	li	a0,1
    800037a0:	00000097          	auipc	ra,0x0
    800037a4:	eca080e7          	jalr	-310(ra) # 8000366a <install_trans>
  log.lh.n = 0;
    800037a8:	00016797          	auipc	a5,0x16
    800037ac:	de07a223          	sw	zero,-540(a5) # 8001958c <log+0x2c>
  write_head(); // clear the log
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	e50080e7          	jalr	-432(ra) # 80003600 <write_head>
}
    800037b8:	70a2                	ld	ra,40(sp)
    800037ba:	7402                	ld	s0,32(sp)
    800037bc:	64e2                	ld	s1,24(sp)
    800037be:	6942                	ld	s2,16(sp)
    800037c0:	69a2                	ld	s3,8(sp)
    800037c2:	6145                	addi	sp,sp,48
    800037c4:	8082                	ret

00000000800037c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037c6:	1101                	addi	sp,sp,-32
    800037c8:	ec06                	sd	ra,24(sp)
    800037ca:	e822                	sd	s0,16(sp)
    800037cc:	e426                	sd	s1,8(sp)
    800037ce:	e04a                	sd	s2,0(sp)
    800037d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037d2:	00016517          	auipc	a0,0x16
    800037d6:	d8e50513          	addi	a0,a0,-626 # 80019560 <log>
    800037da:	00003097          	auipc	ra,0x3
    800037de:	c60080e7          	jalr	-928(ra) # 8000643a <acquire>
  while(1){
    if(log.committing){
    800037e2:	00016497          	auipc	s1,0x16
    800037e6:	d7e48493          	addi	s1,s1,-642 # 80019560 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037ea:	4979                	li	s2,30
    800037ec:	a039                	j	800037fa <begin_op+0x34>
      sleep(&log, &log.lock);
    800037ee:	85a6                	mv	a1,s1
    800037f0:	8526                	mv	a0,s1
    800037f2:	ffffe097          	auipc	ra,0xffffe
    800037f6:	f52080e7          	jalr	-174(ra) # 80001744 <sleep>
    if(log.committing){
    800037fa:	50dc                	lw	a5,36(s1)
    800037fc:	fbed                	bnez	a5,800037ee <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037fe:	5098                	lw	a4,32(s1)
    80003800:	2705                	addiw	a4,a4,1
    80003802:	0027179b          	slliw	a5,a4,0x2
    80003806:	9fb9                	addw	a5,a5,a4
    80003808:	0017979b          	slliw	a5,a5,0x1
    8000380c:	54d4                	lw	a3,44(s1)
    8000380e:	9fb5                	addw	a5,a5,a3
    80003810:	00f95963          	bge	s2,a5,80003822 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003814:	85a6                	mv	a1,s1
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	f2c080e7          	jalr	-212(ra) # 80001744 <sleep>
    80003820:	bfe9                	j	800037fa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003822:	00016517          	auipc	a0,0x16
    80003826:	d3e50513          	addi	a0,a0,-706 # 80019560 <log>
    8000382a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	cc2080e7          	jalr	-830(ra) # 800064ee <release>
      break;
    }
  }
}
    80003834:	60e2                	ld	ra,24(sp)
    80003836:	6442                	ld	s0,16(sp)
    80003838:	64a2                	ld	s1,8(sp)
    8000383a:	6902                	ld	s2,0(sp)
    8000383c:	6105                	addi	sp,sp,32
    8000383e:	8082                	ret

0000000080003840 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003840:	7139                	addi	sp,sp,-64
    80003842:	fc06                	sd	ra,56(sp)
    80003844:	f822                	sd	s0,48(sp)
    80003846:	f426                	sd	s1,40(sp)
    80003848:	f04a                	sd	s2,32(sp)
    8000384a:	ec4e                	sd	s3,24(sp)
    8000384c:	e852                	sd	s4,16(sp)
    8000384e:	e456                	sd	s5,8(sp)
    80003850:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003852:	00016497          	auipc	s1,0x16
    80003856:	d0e48493          	addi	s1,s1,-754 # 80019560 <log>
    8000385a:	8526                	mv	a0,s1
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	bde080e7          	jalr	-1058(ra) # 8000643a <acquire>
  log.outstanding -= 1;
    80003864:	509c                	lw	a5,32(s1)
    80003866:	37fd                	addiw	a5,a5,-1
    80003868:	0007891b          	sext.w	s2,a5
    8000386c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000386e:	50dc                	lw	a5,36(s1)
    80003870:	e7b9                	bnez	a5,800038be <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003872:	04091e63          	bnez	s2,800038ce <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003876:	00016497          	auipc	s1,0x16
    8000387a:	cea48493          	addi	s1,s1,-790 # 80019560 <log>
    8000387e:	4785                	li	a5,1
    80003880:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003882:	8526                	mv	a0,s1
    80003884:	00003097          	auipc	ra,0x3
    80003888:	c6a080e7          	jalr	-918(ra) # 800064ee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000388c:	54dc                	lw	a5,44(s1)
    8000388e:	06f04763          	bgtz	a5,800038fc <end_op+0xbc>
    acquire(&log.lock);
    80003892:	00016497          	auipc	s1,0x16
    80003896:	cce48493          	addi	s1,s1,-818 # 80019560 <log>
    8000389a:	8526                	mv	a0,s1
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	b9e080e7          	jalr	-1122(ra) # 8000643a <acquire>
    log.committing = 0;
    800038a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038a8:	8526                	mv	a0,s1
    800038aa:	ffffe097          	auipc	ra,0xffffe
    800038ae:	efe080e7          	jalr	-258(ra) # 800017a8 <wakeup>
    release(&log.lock);
    800038b2:	8526                	mv	a0,s1
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	c3a080e7          	jalr	-966(ra) # 800064ee <release>
}
    800038bc:	a03d                	j	800038ea <end_op+0xaa>
    panic("log.committing");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	f6a50513          	addi	a0,a0,-150 # 80008828 <syscall_names+0x1e8>
    800038c6:	00002097          	auipc	ra,0x2
    800038ca:	666080e7          	jalr	1638(ra) # 80005f2c <panic>
    wakeup(&log);
    800038ce:	00016497          	auipc	s1,0x16
    800038d2:	c9248493          	addi	s1,s1,-878 # 80019560 <log>
    800038d6:	8526                	mv	a0,s1
    800038d8:	ffffe097          	auipc	ra,0xffffe
    800038dc:	ed0080e7          	jalr	-304(ra) # 800017a8 <wakeup>
  release(&log.lock);
    800038e0:	8526                	mv	a0,s1
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	c0c080e7          	jalr	-1012(ra) # 800064ee <release>
}
    800038ea:	70e2                	ld	ra,56(sp)
    800038ec:	7442                	ld	s0,48(sp)
    800038ee:	74a2                	ld	s1,40(sp)
    800038f0:	7902                	ld	s2,32(sp)
    800038f2:	69e2                	ld	s3,24(sp)
    800038f4:	6a42                	ld	s4,16(sp)
    800038f6:	6aa2                	ld	s5,8(sp)
    800038f8:	6121                	addi	sp,sp,64
    800038fa:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800038fc:	00016a97          	auipc	s5,0x16
    80003900:	c94a8a93          	addi	s5,s5,-876 # 80019590 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003904:	00016a17          	auipc	s4,0x16
    80003908:	c5ca0a13          	addi	s4,s4,-932 # 80019560 <log>
    8000390c:	018a2583          	lw	a1,24(s4)
    80003910:	012585bb          	addw	a1,a1,s2
    80003914:	2585                	addiw	a1,a1,1
    80003916:	028a2503          	lw	a0,40(s4)
    8000391a:	fffff097          	auipc	ra,0xfffff
    8000391e:	cf6080e7          	jalr	-778(ra) # 80002610 <bread>
    80003922:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003924:	000aa583          	lw	a1,0(s5)
    80003928:	028a2503          	lw	a0,40(s4)
    8000392c:	fffff097          	auipc	ra,0xfffff
    80003930:	ce4080e7          	jalr	-796(ra) # 80002610 <bread>
    80003934:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003936:	40000613          	li	a2,1024
    8000393a:	05850593          	addi	a1,a0,88
    8000393e:	05848513          	addi	a0,s1,88
    80003942:	ffffd097          	auipc	ra,0xffffd
    80003946:	894080e7          	jalr	-1900(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000394a:	8526                	mv	a0,s1
    8000394c:	fffff097          	auipc	ra,0xfffff
    80003950:	db6080e7          	jalr	-586(ra) # 80002702 <bwrite>
    brelse(from);
    80003954:	854e                	mv	a0,s3
    80003956:	fffff097          	auipc	ra,0xfffff
    8000395a:	dea080e7          	jalr	-534(ra) # 80002740 <brelse>
    brelse(to);
    8000395e:	8526                	mv	a0,s1
    80003960:	fffff097          	auipc	ra,0xfffff
    80003964:	de0080e7          	jalr	-544(ra) # 80002740 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003968:	2905                	addiw	s2,s2,1
    8000396a:	0a91                	addi	s5,s5,4
    8000396c:	02ca2783          	lw	a5,44(s4)
    80003970:	f8f94ee3          	blt	s2,a5,8000390c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003974:	00000097          	auipc	ra,0x0
    80003978:	c8c080e7          	jalr	-884(ra) # 80003600 <write_head>
    install_trans(0); // Now install writes to home locations
    8000397c:	4501                	li	a0,0
    8000397e:	00000097          	auipc	ra,0x0
    80003982:	cec080e7          	jalr	-788(ra) # 8000366a <install_trans>
    log.lh.n = 0;
    80003986:	00016797          	auipc	a5,0x16
    8000398a:	c007a323          	sw	zero,-1018(a5) # 8001958c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000398e:	00000097          	auipc	ra,0x0
    80003992:	c72080e7          	jalr	-910(ra) # 80003600 <write_head>
    80003996:	bdf5                	j	80003892 <end_op+0x52>

0000000080003998 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003998:	1101                	addi	sp,sp,-32
    8000399a:	ec06                	sd	ra,24(sp)
    8000399c:	e822                	sd	s0,16(sp)
    8000399e:	e426                	sd	s1,8(sp)
    800039a0:	e04a                	sd	s2,0(sp)
    800039a2:	1000                	addi	s0,sp,32
    800039a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039a6:	00016917          	auipc	s2,0x16
    800039aa:	bba90913          	addi	s2,s2,-1094 # 80019560 <log>
    800039ae:	854a                	mv	a0,s2
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	a8a080e7          	jalr	-1398(ra) # 8000643a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039b8:	02c92603          	lw	a2,44(s2)
    800039bc:	47f5                	li	a5,29
    800039be:	06c7c563          	blt	a5,a2,80003a28 <log_write+0x90>
    800039c2:	00016797          	auipc	a5,0x16
    800039c6:	bba7a783          	lw	a5,-1094(a5) # 8001957c <log+0x1c>
    800039ca:	37fd                	addiw	a5,a5,-1
    800039cc:	04f65e63          	bge	a2,a5,80003a28 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039d0:	00016797          	auipc	a5,0x16
    800039d4:	bb07a783          	lw	a5,-1104(a5) # 80019580 <log+0x20>
    800039d8:	06f05063          	blez	a5,80003a38 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039dc:	4781                	li	a5,0
    800039de:	06c05563          	blez	a2,80003a48 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039e2:	44cc                	lw	a1,12(s1)
    800039e4:	00016717          	auipc	a4,0x16
    800039e8:	bac70713          	addi	a4,a4,-1108 # 80019590 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ee:	4314                	lw	a3,0(a4)
    800039f0:	04b68c63          	beq	a3,a1,80003a48 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039f4:	2785                	addiw	a5,a5,1
    800039f6:	0711                	addi	a4,a4,4
    800039f8:	fef61be3          	bne	a2,a5,800039ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039fc:	0621                	addi	a2,a2,8
    800039fe:	060a                	slli	a2,a2,0x2
    80003a00:	00016797          	auipc	a5,0x16
    80003a04:	b6078793          	addi	a5,a5,-1184 # 80019560 <log>
    80003a08:	97b2                	add	a5,a5,a2
    80003a0a:	44d8                	lw	a4,12(s1)
    80003a0c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a0e:	8526                	mv	a0,s1
    80003a10:	fffff097          	auipc	ra,0xfffff
    80003a14:	dcc080e7          	jalr	-564(ra) # 800027dc <bpin>
    log.lh.n++;
    80003a18:	00016717          	auipc	a4,0x16
    80003a1c:	b4870713          	addi	a4,a4,-1208 # 80019560 <log>
    80003a20:	575c                	lw	a5,44(a4)
    80003a22:	2785                	addiw	a5,a5,1
    80003a24:	d75c                	sw	a5,44(a4)
    80003a26:	a82d                	j	80003a60 <log_write+0xc8>
    panic("too big a transaction");
    80003a28:	00005517          	auipc	a0,0x5
    80003a2c:	e1050513          	addi	a0,a0,-496 # 80008838 <syscall_names+0x1f8>
    80003a30:	00002097          	auipc	ra,0x2
    80003a34:	4fc080e7          	jalr	1276(ra) # 80005f2c <panic>
    panic("log_write outside of trans");
    80003a38:	00005517          	auipc	a0,0x5
    80003a3c:	e1850513          	addi	a0,a0,-488 # 80008850 <syscall_names+0x210>
    80003a40:	00002097          	auipc	ra,0x2
    80003a44:	4ec080e7          	jalr	1260(ra) # 80005f2c <panic>
  log.lh.block[i] = b->blockno;
    80003a48:	00878693          	addi	a3,a5,8
    80003a4c:	068a                	slli	a3,a3,0x2
    80003a4e:	00016717          	auipc	a4,0x16
    80003a52:	b1270713          	addi	a4,a4,-1262 # 80019560 <log>
    80003a56:	9736                	add	a4,a4,a3
    80003a58:	44d4                	lw	a3,12(s1)
    80003a5a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a5c:	faf609e3          	beq	a2,a5,80003a0e <log_write+0x76>
  }
  release(&log.lock);
    80003a60:	00016517          	auipc	a0,0x16
    80003a64:	b0050513          	addi	a0,a0,-1280 # 80019560 <log>
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	a86080e7          	jalr	-1402(ra) # 800064ee <release>
}
    80003a70:	60e2                	ld	ra,24(sp)
    80003a72:	6442                	ld	s0,16(sp)
    80003a74:	64a2                	ld	s1,8(sp)
    80003a76:	6902                	ld	s2,0(sp)
    80003a78:	6105                	addi	sp,sp,32
    80003a7a:	8082                	ret

0000000080003a7c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a7c:	1101                	addi	sp,sp,-32
    80003a7e:	ec06                	sd	ra,24(sp)
    80003a80:	e822                	sd	s0,16(sp)
    80003a82:	e426                	sd	s1,8(sp)
    80003a84:	e04a                	sd	s2,0(sp)
    80003a86:	1000                	addi	s0,sp,32
    80003a88:	84aa                	mv	s1,a0
    80003a8a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a8c:	00005597          	auipc	a1,0x5
    80003a90:	de458593          	addi	a1,a1,-540 # 80008870 <syscall_names+0x230>
    80003a94:	0521                	addi	a0,a0,8
    80003a96:	00003097          	auipc	ra,0x3
    80003a9a:	914080e7          	jalr	-1772(ra) # 800063aa <initlock>
  lk->name = name;
    80003a9e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003aa2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa6:	0204a423          	sw	zero,40(s1)
}
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6902                	ld	s2,0(sp)
    80003ab2:	6105                	addi	sp,sp,32
    80003ab4:	8082                	ret

0000000080003ab6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ab6:	1101                	addi	sp,sp,-32
    80003ab8:	ec06                	sd	ra,24(sp)
    80003aba:	e822                	sd	s0,16(sp)
    80003abc:	e426                	sd	s1,8(sp)
    80003abe:	e04a                	sd	s2,0(sp)
    80003ac0:	1000                	addi	s0,sp,32
    80003ac2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ac4:	00850913          	addi	s2,a0,8
    80003ac8:	854a                	mv	a0,s2
    80003aca:	00003097          	auipc	ra,0x3
    80003ace:	970080e7          	jalr	-1680(ra) # 8000643a <acquire>
  while (lk->locked) {
    80003ad2:	409c                	lw	a5,0(s1)
    80003ad4:	cb89                	beqz	a5,80003ae6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ad6:	85ca                	mv	a1,s2
    80003ad8:	8526                	mv	a0,s1
    80003ada:	ffffe097          	auipc	ra,0xffffe
    80003ade:	c6a080e7          	jalr	-918(ra) # 80001744 <sleep>
  while (lk->locked) {
    80003ae2:	409c                	lw	a5,0(s1)
    80003ae4:	fbed                	bnez	a5,80003ad6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ae6:	4785                	li	a5,1
    80003ae8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003aea:	ffffd097          	auipc	ra,0xffffd
    80003aee:	4ee080e7          	jalr	1262(ra) # 80000fd8 <myproc>
    80003af2:	591c                	lw	a5,48(a0)
    80003af4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003af6:	854a                	mv	a0,s2
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	9f6080e7          	jalr	-1546(ra) # 800064ee <release>
}
    80003b00:	60e2                	ld	ra,24(sp)
    80003b02:	6442                	ld	s0,16(sp)
    80003b04:	64a2                	ld	s1,8(sp)
    80003b06:	6902                	ld	s2,0(sp)
    80003b08:	6105                	addi	sp,sp,32
    80003b0a:	8082                	ret

0000000080003b0c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b0c:	1101                	addi	sp,sp,-32
    80003b0e:	ec06                	sd	ra,24(sp)
    80003b10:	e822                	sd	s0,16(sp)
    80003b12:	e426                	sd	s1,8(sp)
    80003b14:	e04a                	sd	s2,0(sp)
    80003b16:	1000                	addi	s0,sp,32
    80003b18:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b1a:	00850913          	addi	s2,a0,8
    80003b1e:	854a                	mv	a0,s2
    80003b20:	00003097          	auipc	ra,0x3
    80003b24:	91a080e7          	jalr	-1766(ra) # 8000643a <acquire>
  lk->locked = 0;
    80003b28:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b2c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b30:	8526                	mv	a0,s1
    80003b32:	ffffe097          	auipc	ra,0xffffe
    80003b36:	c76080e7          	jalr	-906(ra) # 800017a8 <wakeup>
  release(&lk->lk);
    80003b3a:	854a                	mv	a0,s2
    80003b3c:	00003097          	auipc	ra,0x3
    80003b40:	9b2080e7          	jalr	-1614(ra) # 800064ee <release>
}
    80003b44:	60e2                	ld	ra,24(sp)
    80003b46:	6442                	ld	s0,16(sp)
    80003b48:	64a2                	ld	s1,8(sp)
    80003b4a:	6902                	ld	s2,0(sp)
    80003b4c:	6105                	addi	sp,sp,32
    80003b4e:	8082                	ret

0000000080003b50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b50:	7179                	addi	sp,sp,-48
    80003b52:	f406                	sd	ra,40(sp)
    80003b54:	f022                	sd	s0,32(sp)
    80003b56:	ec26                	sd	s1,24(sp)
    80003b58:	e84a                	sd	s2,16(sp)
    80003b5a:	e44e                	sd	s3,8(sp)
    80003b5c:	1800                	addi	s0,sp,48
    80003b5e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b60:	00850913          	addi	s2,a0,8
    80003b64:	854a                	mv	a0,s2
    80003b66:	00003097          	auipc	ra,0x3
    80003b6a:	8d4080e7          	jalr	-1836(ra) # 8000643a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b6e:	409c                	lw	a5,0(s1)
    80003b70:	ef99                	bnez	a5,80003b8e <holdingsleep+0x3e>
    80003b72:	4481                	li	s1,0
  release(&lk->lk);
    80003b74:	854a                	mv	a0,s2
    80003b76:	00003097          	auipc	ra,0x3
    80003b7a:	978080e7          	jalr	-1672(ra) # 800064ee <release>
  return r;
}
    80003b7e:	8526                	mv	a0,s1
    80003b80:	70a2                	ld	ra,40(sp)
    80003b82:	7402                	ld	s0,32(sp)
    80003b84:	64e2                	ld	s1,24(sp)
    80003b86:	6942                	ld	s2,16(sp)
    80003b88:	69a2                	ld	s3,8(sp)
    80003b8a:	6145                	addi	sp,sp,48
    80003b8c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b8e:	0284a983          	lw	s3,40(s1)
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	446080e7          	jalr	1094(ra) # 80000fd8 <myproc>
    80003b9a:	5904                	lw	s1,48(a0)
    80003b9c:	413484b3          	sub	s1,s1,s3
    80003ba0:	0014b493          	seqz	s1,s1
    80003ba4:	bfc1                	j	80003b74 <holdingsleep+0x24>

0000000080003ba6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ba6:	1141                	addi	sp,sp,-16
    80003ba8:	e406                	sd	ra,8(sp)
    80003baa:	e022                	sd	s0,0(sp)
    80003bac:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bae:	00005597          	auipc	a1,0x5
    80003bb2:	cd258593          	addi	a1,a1,-814 # 80008880 <syscall_names+0x240>
    80003bb6:	00016517          	auipc	a0,0x16
    80003bba:	af250513          	addi	a0,a0,-1294 # 800196a8 <ftable>
    80003bbe:	00002097          	auipc	ra,0x2
    80003bc2:	7ec080e7          	jalr	2028(ra) # 800063aa <initlock>
}
    80003bc6:	60a2                	ld	ra,8(sp)
    80003bc8:	6402                	ld	s0,0(sp)
    80003bca:	0141                	addi	sp,sp,16
    80003bcc:	8082                	ret

0000000080003bce <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bce:	1101                	addi	sp,sp,-32
    80003bd0:	ec06                	sd	ra,24(sp)
    80003bd2:	e822                	sd	s0,16(sp)
    80003bd4:	e426                	sd	s1,8(sp)
    80003bd6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bd8:	00016517          	auipc	a0,0x16
    80003bdc:	ad050513          	addi	a0,a0,-1328 # 800196a8 <ftable>
    80003be0:	00003097          	auipc	ra,0x3
    80003be4:	85a080e7          	jalr	-1958(ra) # 8000643a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003be8:	00016497          	auipc	s1,0x16
    80003bec:	ad848493          	addi	s1,s1,-1320 # 800196c0 <ftable+0x18>
    80003bf0:	00017717          	auipc	a4,0x17
    80003bf4:	a7070713          	addi	a4,a4,-1424 # 8001a660 <disk>
    if(f->ref == 0){
    80003bf8:	40dc                	lw	a5,4(s1)
    80003bfa:	cf99                	beqz	a5,80003c18 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bfc:	02848493          	addi	s1,s1,40
    80003c00:	fee49ce3          	bne	s1,a4,80003bf8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c04:	00016517          	auipc	a0,0x16
    80003c08:	aa450513          	addi	a0,a0,-1372 # 800196a8 <ftable>
    80003c0c:	00003097          	auipc	ra,0x3
    80003c10:	8e2080e7          	jalr	-1822(ra) # 800064ee <release>
  return 0;
    80003c14:	4481                	li	s1,0
    80003c16:	a819                	j	80003c2c <filealloc+0x5e>
      f->ref = 1;
    80003c18:	4785                	li	a5,1
    80003c1a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c1c:	00016517          	auipc	a0,0x16
    80003c20:	a8c50513          	addi	a0,a0,-1396 # 800196a8 <ftable>
    80003c24:	00003097          	auipc	ra,0x3
    80003c28:	8ca080e7          	jalr	-1846(ra) # 800064ee <release>
}
    80003c2c:	8526                	mv	a0,s1
    80003c2e:	60e2                	ld	ra,24(sp)
    80003c30:	6442                	ld	s0,16(sp)
    80003c32:	64a2                	ld	s1,8(sp)
    80003c34:	6105                	addi	sp,sp,32
    80003c36:	8082                	ret

0000000080003c38 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c38:	1101                	addi	sp,sp,-32
    80003c3a:	ec06                	sd	ra,24(sp)
    80003c3c:	e822                	sd	s0,16(sp)
    80003c3e:	e426                	sd	s1,8(sp)
    80003c40:	1000                	addi	s0,sp,32
    80003c42:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c44:	00016517          	auipc	a0,0x16
    80003c48:	a6450513          	addi	a0,a0,-1436 # 800196a8 <ftable>
    80003c4c:	00002097          	auipc	ra,0x2
    80003c50:	7ee080e7          	jalr	2030(ra) # 8000643a <acquire>
  if(f->ref < 1)
    80003c54:	40dc                	lw	a5,4(s1)
    80003c56:	02f05263          	blez	a5,80003c7a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c5a:	2785                	addiw	a5,a5,1
    80003c5c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c5e:	00016517          	auipc	a0,0x16
    80003c62:	a4a50513          	addi	a0,a0,-1462 # 800196a8 <ftable>
    80003c66:	00003097          	auipc	ra,0x3
    80003c6a:	888080e7          	jalr	-1912(ra) # 800064ee <release>
  return f;
}
    80003c6e:	8526                	mv	a0,s1
    80003c70:	60e2                	ld	ra,24(sp)
    80003c72:	6442                	ld	s0,16(sp)
    80003c74:	64a2                	ld	s1,8(sp)
    80003c76:	6105                	addi	sp,sp,32
    80003c78:	8082                	ret
    panic("filedup");
    80003c7a:	00005517          	auipc	a0,0x5
    80003c7e:	c0e50513          	addi	a0,a0,-1010 # 80008888 <syscall_names+0x248>
    80003c82:	00002097          	auipc	ra,0x2
    80003c86:	2aa080e7          	jalr	682(ra) # 80005f2c <panic>

0000000080003c8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c8a:	7139                	addi	sp,sp,-64
    80003c8c:	fc06                	sd	ra,56(sp)
    80003c8e:	f822                	sd	s0,48(sp)
    80003c90:	f426                	sd	s1,40(sp)
    80003c92:	f04a                	sd	s2,32(sp)
    80003c94:	ec4e                	sd	s3,24(sp)
    80003c96:	e852                	sd	s4,16(sp)
    80003c98:	e456                	sd	s5,8(sp)
    80003c9a:	0080                	addi	s0,sp,64
    80003c9c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c9e:	00016517          	auipc	a0,0x16
    80003ca2:	a0a50513          	addi	a0,a0,-1526 # 800196a8 <ftable>
    80003ca6:	00002097          	auipc	ra,0x2
    80003caa:	794080e7          	jalr	1940(ra) # 8000643a <acquire>
  if(f->ref < 1)
    80003cae:	40dc                	lw	a5,4(s1)
    80003cb0:	06f05163          	blez	a5,80003d12 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cb4:	37fd                	addiw	a5,a5,-1
    80003cb6:	0007871b          	sext.w	a4,a5
    80003cba:	c0dc                	sw	a5,4(s1)
    80003cbc:	06e04363          	bgtz	a4,80003d22 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cc0:	0004a903          	lw	s2,0(s1)
    80003cc4:	0094ca83          	lbu	s5,9(s1)
    80003cc8:	0104ba03          	ld	s4,16(s1)
    80003ccc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cd0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cd4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cd8:	00016517          	auipc	a0,0x16
    80003cdc:	9d050513          	addi	a0,a0,-1584 # 800196a8 <ftable>
    80003ce0:	00003097          	auipc	ra,0x3
    80003ce4:	80e080e7          	jalr	-2034(ra) # 800064ee <release>

  if(ff.type == FD_PIPE){
    80003ce8:	4785                	li	a5,1
    80003cea:	04f90d63          	beq	s2,a5,80003d44 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cee:	3979                	addiw	s2,s2,-2
    80003cf0:	4785                	li	a5,1
    80003cf2:	0527e063          	bltu	a5,s2,80003d32 <fileclose+0xa8>
    begin_op();
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	ad0080e7          	jalr	-1328(ra) # 800037c6 <begin_op>
    iput(ff.ip);
    80003cfe:	854e                	mv	a0,s3
    80003d00:	fffff097          	auipc	ra,0xfffff
    80003d04:	2da080e7          	jalr	730(ra) # 80002fda <iput>
    end_op();
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	b38080e7          	jalr	-1224(ra) # 80003840 <end_op>
    80003d10:	a00d                	j	80003d32 <fileclose+0xa8>
    panic("fileclose");
    80003d12:	00005517          	auipc	a0,0x5
    80003d16:	b7e50513          	addi	a0,a0,-1154 # 80008890 <syscall_names+0x250>
    80003d1a:	00002097          	auipc	ra,0x2
    80003d1e:	212080e7          	jalr	530(ra) # 80005f2c <panic>
    release(&ftable.lock);
    80003d22:	00016517          	auipc	a0,0x16
    80003d26:	98650513          	addi	a0,a0,-1658 # 800196a8 <ftable>
    80003d2a:	00002097          	auipc	ra,0x2
    80003d2e:	7c4080e7          	jalr	1988(ra) # 800064ee <release>
  }
}
    80003d32:	70e2                	ld	ra,56(sp)
    80003d34:	7442                	ld	s0,48(sp)
    80003d36:	74a2                	ld	s1,40(sp)
    80003d38:	7902                	ld	s2,32(sp)
    80003d3a:	69e2                	ld	s3,24(sp)
    80003d3c:	6a42                	ld	s4,16(sp)
    80003d3e:	6aa2                	ld	s5,8(sp)
    80003d40:	6121                	addi	sp,sp,64
    80003d42:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d44:	85d6                	mv	a1,s5
    80003d46:	8552                	mv	a0,s4
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	348080e7          	jalr	840(ra) # 80004090 <pipeclose>
    80003d50:	b7cd                	j	80003d32 <fileclose+0xa8>

0000000080003d52 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d52:	715d                	addi	sp,sp,-80
    80003d54:	e486                	sd	ra,72(sp)
    80003d56:	e0a2                	sd	s0,64(sp)
    80003d58:	fc26                	sd	s1,56(sp)
    80003d5a:	f84a                	sd	s2,48(sp)
    80003d5c:	f44e                	sd	s3,40(sp)
    80003d5e:	0880                	addi	s0,sp,80
    80003d60:	84aa                	mv	s1,a0
    80003d62:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d64:	ffffd097          	auipc	ra,0xffffd
    80003d68:	274080e7          	jalr	628(ra) # 80000fd8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d6c:	409c                	lw	a5,0(s1)
    80003d6e:	37f9                	addiw	a5,a5,-2
    80003d70:	4705                	li	a4,1
    80003d72:	04f76763          	bltu	a4,a5,80003dc0 <filestat+0x6e>
    80003d76:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d78:	6c88                	ld	a0,24(s1)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	0a6080e7          	jalr	166(ra) # 80002e20 <ilock>
    stati(f->ip, &st);
    80003d82:	fb840593          	addi	a1,s0,-72
    80003d86:	6c88                	ld	a0,24(s1)
    80003d88:	fffff097          	auipc	ra,0xfffff
    80003d8c:	322080e7          	jalr	802(ra) # 800030aa <stati>
    iunlock(f->ip);
    80003d90:	6c88                	ld	a0,24(s1)
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	150080e7          	jalr	336(ra) # 80002ee2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d9a:	46e1                	li	a3,24
    80003d9c:	fb840613          	addi	a2,s0,-72
    80003da0:	85ce                	mv	a1,s3
    80003da2:	05093503          	ld	a0,80(s2)
    80003da6:	ffffd097          	auipc	ra,0xffffd
    80003daa:	ef2080e7          	jalr	-270(ra) # 80000c98 <copyout>
    80003dae:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003db2:	60a6                	ld	ra,72(sp)
    80003db4:	6406                	ld	s0,64(sp)
    80003db6:	74e2                	ld	s1,56(sp)
    80003db8:	7942                	ld	s2,48(sp)
    80003dba:	79a2                	ld	s3,40(sp)
    80003dbc:	6161                	addi	sp,sp,80
    80003dbe:	8082                	ret
  return -1;
    80003dc0:	557d                	li	a0,-1
    80003dc2:	bfc5                	j	80003db2 <filestat+0x60>

0000000080003dc4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dc4:	7179                	addi	sp,sp,-48
    80003dc6:	f406                	sd	ra,40(sp)
    80003dc8:	f022                	sd	s0,32(sp)
    80003dca:	ec26                	sd	s1,24(sp)
    80003dcc:	e84a                	sd	s2,16(sp)
    80003dce:	e44e                	sd	s3,8(sp)
    80003dd0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dd2:	00854783          	lbu	a5,8(a0)
    80003dd6:	c3d5                	beqz	a5,80003e7a <fileread+0xb6>
    80003dd8:	84aa                	mv	s1,a0
    80003dda:	89ae                	mv	s3,a1
    80003ddc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dde:	411c                	lw	a5,0(a0)
    80003de0:	4705                	li	a4,1
    80003de2:	04e78963          	beq	a5,a4,80003e34 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003de6:	470d                	li	a4,3
    80003de8:	04e78d63          	beq	a5,a4,80003e42 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dec:	4709                	li	a4,2
    80003dee:	06e79e63          	bne	a5,a4,80003e6a <fileread+0xa6>
    ilock(f->ip);
    80003df2:	6d08                	ld	a0,24(a0)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	02c080e7          	jalr	44(ra) # 80002e20 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dfc:	874a                	mv	a4,s2
    80003dfe:	5094                	lw	a3,32(s1)
    80003e00:	864e                	mv	a2,s3
    80003e02:	4585                	li	a1,1
    80003e04:	6c88                	ld	a0,24(s1)
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	2ce080e7          	jalr	718(ra) # 800030d4 <readi>
    80003e0e:	892a                	mv	s2,a0
    80003e10:	00a05563          	blez	a0,80003e1a <fileread+0x56>
      f->off += r;
    80003e14:	509c                	lw	a5,32(s1)
    80003e16:	9fa9                	addw	a5,a5,a0
    80003e18:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e1a:	6c88                	ld	a0,24(s1)
    80003e1c:	fffff097          	auipc	ra,0xfffff
    80003e20:	0c6080e7          	jalr	198(ra) # 80002ee2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e24:	854a                	mv	a0,s2
    80003e26:	70a2                	ld	ra,40(sp)
    80003e28:	7402                	ld	s0,32(sp)
    80003e2a:	64e2                	ld	s1,24(sp)
    80003e2c:	6942                	ld	s2,16(sp)
    80003e2e:	69a2                	ld	s3,8(sp)
    80003e30:	6145                	addi	sp,sp,48
    80003e32:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e34:	6908                	ld	a0,16(a0)
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	3c2080e7          	jalr	962(ra) # 800041f8 <piperead>
    80003e3e:	892a                	mv	s2,a0
    80003e40:	b7d5                	j	80003e24 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e42:	02451783          	lh	a5,36(a0)
    80003e46:	03079693          	slli	a3,a5,0x30
    80003e4a:	92c1                	srli	a3,a3,0x30
    80003e4c:	4725                	li	a4,9
    80003e4e:	02d76863          	bltu	a4,a3,80003e7e <fileread+0xba>
    80003e52:	0792                	slli	a5,a5,0x4
    80003e54:	00015717          	auipc	a4,0x15
    80003e58:	7b470713          	addi	a4,a4,1972 # 80019608 <devsw>
    80003e5c:	97ba                	add	a5,a5,a4
    80003e5e:	639c                	ld	a5,0(a5)
    80003e60:	c38d                	beqz	a5,80003e82 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e62:	4505                	li	a0,1
    80003e64:	9782                	jalr	a5
    80003e66:	892a                	mv	s2,a0
    80003e68:	bf75                	j	80003e24 <fileread+0x60>
    panic("fileread");
    80003e6a:	00005517          	auipc	a0,0x5
    80003e6e:	a3650513          	addi	a0,a0,-1482 # 800088a0 <syscall_names+0x260>
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	0ba080e7          	jalr	186(ra) # 80005f2c <panic>
    return -1;
    80003e7a:	597d                	li	s2,-1
    80003e7c:	b765                	j	80003e24 <fileread+0x60>
      return -1;
    80003e7e:	597d                	li	s2,-1
    80003e80:	b755                	j	80003e24 <fileread+0x60>
    80003e82:	597d                	li	s2,-1
    80003e84:	b745                	j	80003e24 <fileread+0x60>

0000000080003e86 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e86:	00954783          	lbu	a5,9(a0)
    80003e8a:	10078e63          	beqz	a5,80003fa6 <filewrite+0x120>
{
    80003e8e:	715d                	addi	sp,sp,-80
    80003e90:	e486                	sd	ra,72(sp)
    80003e92:	e0a2                	sd	s0,64(sp)
    80003e94:	fc26                	sd	s1,56(sp)
    80003e96:	f84a                	sd	s2,48(sp)
    80003e98:	f44e                	sd	s3,40(sp)
    80003e9a:	f052                	sd	s4,32(sp)
    80003e9c:	ec56                	sd	s5,24(sp)
    80003e9e:	e85a                	sd	s6,16(sp)
    80003ea0:	e45e                	sd	s7,8(sp)
    80003ea2:	e062                	sd	s8,0(sp)
    80003ea4:	0880                	addi	s0,sp,80
    80003ea6:	892a                	mv	s2,a0
    80003ea8:	8b2e                	mv	s6,a1
    80003eaa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eac:	411c                	lw	a5,0(a0)
    80003eae:	4705                	li	a4,1
    80003eb0:	02e78263          	beq	a5,a4,80003ed4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eb4:	470d                	li	a4,3
    80003eb6:	02e78563          	beq	a5,a4,80003ee0 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eba:	4709                	li	a4,2
    80003ebc:	0ce79d63          	bne	a5,a4,80003f96 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ec0:	0ac05b63          	blez	a2,80003f76 <filewrite+0xf0>
    int i = 0;
    80003ec4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003ec6:	6b85                	lui	s7,0x1
    80003ec8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ecc:	6c05                	lui	s8,0x1
    80003ece:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ed2:	a851                	j	80003f66 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003ed4:	6908                	ld	a0,16(a0)
    80003ed6:	00000097          	auipc	ra,0x0
    80003eda:	22a080e7          	jalr	554(ra) # 80004100 <pipewrite>
    80003ede:	a045                	j	80003f7e <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ee0:	02451783          	lh	a5,36(a0)
    80003ee4:	03079693          	slli	a3,a5,0x30
    80003ee8:	92c1                	srli	a3,a3,0x30
    80003eea:	4725                	li	a4,9
    80003eec:	0ad76f63          	bltu	a4,a3,80003faa <filewrite+0x124>
    80003ef0:	0792                	slli	a5,a5,0x4
    80003ef2:	00015717          	auipc	a4,0x15
    80003ef6:	71670713          	addi	a4,a4,1814 # 80019608 <devsw>
    80003efa:	97ba                	add	a5,a5,a4
    80003efc:	679c                	ld	a5,8(a5)
    80003efe:	cbc5                	beqz	a5,80003fae <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003f00:	4505                	li	a0,1
    80003f02:	9782                	jalr	a5
    80003f04:	a8ad                	j	80003f7e <filewrite+0xf8>
      if(n1 > max)
    80003f06:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	8bc080e7          	jalr	-1860(ra) # 800037c6 <begin_op>
      ilock(f->ip);
    80003f12:	01893503          	ld	a0,24(s2)
    80003f16:	fffff097          	auipc	ra,0xfffff
    80003f1a:	f0a080e7          	jalr	-246(ra) # 80002e20 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f1e:	8756                	mv	a4,s5
    80003f20:	02092683          	lw	a3,32(s2)
    80003f24:	01698633          	add	a2,s3,s6
    80003f28:	4585                	li	a1,1
    80003f2a:	01893503          	ld	a0,24(s2)
    80003f2e:	fffff097          	auipc	ra,0xfffff
    80003f32:	29e080e7          	jalr	670(ra) # 800031cc <writei>
    80003f36:	84aa                	mv	s1,a0
    80003f38:	00a05763          	blez	a0,80003f46 <filewrite+0xc0>
        f->off += r;
    80003f3c:	02092783          	lw	a5,32(s2)
    80003f40:	9fa9                	addw	a5,a5,a0
    80003f42:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f46:	01893503          	ld	a0,24(s2)
    80003f4a:	fffff097          	auipc	ra,0xfffff
    80003f4e:	f98080e7          	jalr	-104(ra) # 80002ee2 <iunlock>
      end_op();
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	8ee080e7          	jalr	-1810(ra) # 80003840 <end_op>

      if(r != n1){
    80003f5a:	009a9f63          	bne	s5,s1,80003f78 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003f5e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f62:	0149db63          	bge	s3,s4,80003f78 <filewrite+0xf2>
      int n1 = n - i;
    80003f66:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f6a:	0004879b          	sext.w	a5,s1
    80003f6e:	f8fbdce3          	bge	s7,a5,80003f06 <filewrite+0x80>
    80003f72:	84e2                	mv	s1,s8
    80003f74:	bf49                	j	80003f06 <filewrite+0x80>
    int i = 0;
    80003f76:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f78:	033a1d63          	bne	s4,s3,80003fb2 <filewrite+0x12c>
    80003f7c:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f7e:	60a6                	ld	ra,72(sp)
    80003f80:	6406                	ld	s0,64(sp)
    80003f82:	74e2                	ld	s1,56(sp)
    80003f84:	7942                	ld	s2,48(sp)
    80003f86:	79a2                	ld	s3,40(sp)
    80003f88:	7a02                	ld	s4,32(sp)
    80003f8a:	6ae2                	ld	s5,24(sp)
    80003f8c:	6b42                	ld	s6,16(sp)
    80003f8e:	6ba2                	ld	s7,8(sp)
    80003f90:	6c02                	ld	s8,0(sp)
    80003f92:	6161                	addi	sp,sp,80
    80003f94:	8082                	ret
    panic("filewrite");
    80003f96:	00005517          	auipc	a0,0x5
    80003f9a:	91a50513          	addi	a0,a0,-1766 # 800088b0 <syscall_names+0x270>
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	f8e080e7          	jalr	-114(ra) # 80005f2c <panic>
    return -1;
    80003fa6:	557d                	li	a0,-1
}
    80003fa8:	8082                	ret
      return -1;
    80003faa:	557d                	li	a0,-1
    80003fac:	bfc9                	j	80003f7e <filewrite+0xf8>
    80003fae:	557d                	li	a0,-1
    80003fb0:	b7f9                	j	80003f7e <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003fb2:	557d                	li	a0,-1
    80003fb4:	b7e9                	j	80003f7e <filewrite+0xf8>

0000000080003fb6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fb6:	7179                	addi	sp,sp,-48
    80003fb8:	f406                	sd	ra,40(sp)
    80003fba:	f022                	sd	s0,32(sp)
    80003fbc:	ec26                	sd	s1,24(sp)
    80003fbe:	e84a                	sd	s2,16(sp)
    80003fc0:	e44e                	sd	s3,8(sp)
    80003fc2:	e052                	sd	s4,0(sp)
    80003fc4:	1800                	addi	s0,sp,48
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fca:	0005b023          	sd	zero,0(a1)
    80003fce:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	bfc080e7          	jalr	-1028(ra) # 80003bce <filealloc>
    80003fda:	e088                	sd	a0,0(s1)
    80003fdc:	c551                	beqz	a0,80004068 <pipealloc+0xb2>
    80003fde:	00000097          	auipc	ra,0x0
    80003fe2:	bf0080e7          	jalr	-1040(ra) # 80003bce <filealloc>
    80003fe6:	00aa3023          	sd	a0,0(s4)
    80003fea:	c92d                	beqz	a0,8000405c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fec:	ffffc097          	auipc	ra,0xffffc
    80003ff0:	12e080e7          	jalr	302(ra) # 8000011a <kalloc>
    80003ff4:	892a                	mv	s2,a0
    80003ff6:	c125                	beqz	a0,80004056 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ff8:	4985                	li	s3,1
    80003ffa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ffe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004002:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004006:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000400a:	00005597          	auipc	a1,0x5
    8000400e:	8b658593          	addi	a1,a1,-1866 # 800088c0 <syscall_names+0x280>
    80004012:	00002097          	auipc	ra,0x2
    80004016:	398080e7          	jalr	920(ra) # 800063aa <initlock>
  (*f0)->type = FD_PIPE;
    8000401a:	609c                	ld	a5,0(s1)
    8000401c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004020:	609c                	ld	a5,0(s1)
    80004022:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004026:	609c                	ld	a5,0(s1)
    80004028:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000402c:	609c                	ld	a5,0(s1)
    8000402e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004032:	000a3783          	ld	a5,0(s4)
    80004036:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000403a:	000a3783          	ld	a5,0(s4)
    8000403e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004042:	000a3783          	ld	a5,0(s4)
    80004046:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000404a:	000a3783          	ld	a5,0(s4)
    8000404e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004052:	4501                	li	a0,0
    80004054:	a025                	j	8000407c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004056:	6088                	ld	a0,0(s1)
    80004058:	e501                	bnez	a0,80004060 <pipealloc+0xaa>
    8000405a:	a039                	j	80004068 <pipealloc+0xb2>
    8000405c:	6088                	ld	a0,0(s1)
    8000405e:	c51d                	beqz	a0,8000408c <pipealloc+0xd6>
    fileclose(*f0);
    80004060:	00000097          	auipc	ra,0x0
    80004064:	c2a080e7          	jalr	-982(ra) # 80003c8a <fileclose>
  if(*f1)
    80004068:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000406c:	557d                	li	a0,-1
  if(*f1)
    8000406e:	c799                	beqz	a5,8000407c <pipealloc+0xc6>
    fileclose(*f1);
    80004070:	853e                	mv	a0,a5
    80004072:	00000097          	auipc	ra,0x0
    80004076:	c18080e7          	jalr	-1000(ra) # 80003c8a <fileclose>
  return -1;
    8000407a:	557d                	li	a0,-1
}
    8000407c:	70a2                	ld	ra,40(sp)
    8000407e:	7402                	ld	s0,32(sp)
    80004080:	64e2                	ld	s1,24(sp)
    80004082:	6942                	ld	s2,16(sp)
    80004084:	69a2                	ld	s3,8(sp)
    80004086:	6a02                	ld	s4,0(sp)
    80004088:	6145                	addi	sp,sp,48
    8000408a:	8082                	ret
  return -1;
    8000408c:	557d                	li	a0,-1
    8000408e:	b7fd                	j	8000407c <pipealloc+0xc6>

0000000080004090 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004090:	1101                	addi	sp,sp,-32
    80004092:	ec06                	sd	ra,24(sp)
    80004094:	e822                	sd	s0,16(sp)
    80004096:	e426                	sd	s1,8(sp)
    80004098:	e04a                	sd	s2,0(sp)
    8000409a:	1000                	addi	s0,sp,32
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040a0:	00002097          	auipc	ra,0x2
    800040a4:	39a080e7          	jalr	922(ra) # 8000643a <acquire>
  if(writable){
    800040a8:	02090d63          	beqz	s2,800040e2 <pipeclose+0x52>
    pi->writeopen = 0;
    800040ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040b0:	21848513          	addi	a0,s1,536
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	6f4080e7          	jalr	1780(ra) # 800017a8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040bc:	2204b783          	ld	a5,544(s1)
    800040c0:	eb95                	bnez	a5,800040f4 <pipeclose+0x64>
    release(&pi->lock);
    800040c2:	8526                	mv	a0,s1
    800040c4:	00002097          	auipc	ra,0x2
    800040c8:	42a080e7          	jalr	1066(ra) # 800064ee <release>
    kfree((char*)pi);
    800040cc:	8526                	mv	a0,s1
    800040ce:	ffffc097          	auipc	ra,0xffffc
    800040d2:	f4e080e7          	jalr	-178(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040d6:	60e2                	ld	ra,24(sp)
    800040d8:	6442                	ld	s0,16(sp)
    800040da:	64a2                	ld	s1,8(sp)
    800040dc:	6902                	ld	s2,0(sp)
    800040de:	6105                	addi	sp,sp,32
    800040e0:	8082                	ret
    pi->readopen = 0;
    800040e2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040e6:	21c48513          	addi	a0,s1,540
    800040ea:	ffffd097          	auipc	ra,0xffffd
    800040ee:	6be080e7          	jalr	1726(ra) # 800017a8 <wakeup>
    800040f2:	b7e9                	j	800040bc <pipeclose+0x2c>
    release(&pi->lock);
    800040f4:	8526                	mv	a0,s1
    800040f6:	00002097          	auipc	ra,0x2
    800040fa:	3f8080e7          	jalr	1016(ra) # 800064ee <release>
}
    800040fe:	bfe1                	j	800040d6 <pipeclose+0x46>

0000000080004100 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004100:	711d                	addi	sp,sp,-96
    80004102:	ec86                	sd	ra,88(sp)
    80004104:	e8a2                	sd	s0,80(sp)
    80004106:	e4a6                	sd	s1,72(sp)
    80004108:	e0ca                	sd	s2,64(sp)
    8000410a:	fc4e                	sd	s3,56(sp)
    8000410c:	f852                	sd	s4,48(sp)
    8000410e:	f456                	sd	s5,40(sp)
    80004110:	f05a                	sd	s6,32(sp)
    80004112:	ec5e                	sd	s7,24(sp)
    80004114:	e862                	sd	s8,16(sp)
    80004116:	1080                	addi	s0,sp,96
    80004118:	84aa                	mv	s1,a0
    8000411a:	8aae                	mv	s5,a1
    8000411c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000411e:	ffffd097          	auipc	ra,0xffffd
    80004122:	eba080e7          	jalr	-326(ra) # 80000fd8 <myproc>
    80004126:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004128:	8526                	mv	a0,s1
    8000412a:	00002097          	auipc	ra,0x2
    8000412e:	310080e7          	jalr	784(ra) # 8000643a <acquire>
  while(i < n){
    80004132:	0b405663          	blez	s4,800041de <pipewrite+0xde>
  int i = 0;
    80004136:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004138:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000413a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000413e:	21c48b93          	addi	s7,s1,540
    80004142:	a089                	j	80004184 <pipewrite+0x84>
      release(&pi->lock);
    80004144:	8526                	mv	a0,s1
    80004146:	00002097          	auipc	ra,0x2
    8000414a:	3a8080e7          	jalr	936(ra) # 800064ee <release>
      return -1;
    8000414e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004150:	854a                	mv	a0,s2
    80004152:	60e6                	ld	ra,88(sp)
    80004154:	6446                	ld	s0,80(sp)
    80004156:	64a6                	ld	s1,72(sp)
    80004158:	6906                	ld	s2,64(sp)
    8000415a:	79e2                	ld	s3,56(sp)
    8000415c:	7a42                	ld	s4,48(sp)
    8000415e:	7aa2                	ld	s5,40(sp)
    80004160:	7b02                	ld	s6,32(sp)
    80004162:	6be2                	ld	s7,24(sp)
    80004164:	6c42                	ld	s8,16(sp)
    80004166:	6125                	addi	sp,sp,96
    80004168:	8082                	ret
      wakeup(&pi->nread);
    8000416a:	8562                	mv	a0,s8
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	63c080e7          	jalr	1596(ra) # 800017a8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004174:	85a6                	mv	a1,s1
    80004176:	855e                	mv	a0,s7
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	5cc080e7          	jalr	1484(ra) # 80001744 <sleep>
  while(i < n){
    80004180:	07495063          	bge	s2,s4,800041e0 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004184:	2204a783          	lw	a5,544(s1)
    80004188:	dfd5                	beqz	a5,80004144 <pipewrite+0x44>
    8000418a:	854e                	mv	a0,s3
    8000418c:	ffffe097          	auipc	ra,0xffffe
    80004190:	860080e7          	jalr	-1952(ra) # 800019ec <killed>
    80004194:	f945                	bnez	a0,80004144 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004196:	2184a783          	lw	a5,536(s1)
    8000419a:	21c4a703          	lw	a4,540(s1)
    8000419e:	2007879b          	addiw	a5,a5,512
    800041a2:	fcf704e3          	beq	a4,a5,8000416a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041a6:	4685                	li	a3,1
    800041a8:	01590633          	add	a2,s2,s5
    800041ac:	faf40593          	addi	a1,s0,-81
    800041b0:	0509b503          	ld	a0,80(s3)
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	b70080e7          	jalr	-1168(ra) # 80000d24 <copyin>
    800041bc:	03650263          	beq	a0,s6,800041e0 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041c0:	21c4a783          	lw	a5,540(s1)
    800041c4:	0017871b          	addiw	a4,a5,1
    800041c8:	20e4ae23          	sw	a4,540(s1)
    800041cc:	1ff7f793          	andi	a5,a5,511
    800041d0:	97a6                	add	a5,a5,s1
    800041d2:	faf44703          	lbu	a4,-81(s0)
    800041d6:	00e78c23          	sb	a4,24(a5)
      i++;
    800041da:	2905                	addiw	s2,s2,1
    800041dc:	b755                	j	80004180 <pipewrite+0x80>
  int i = 0;
    800041de:	4901                	li	s2,0
  wakeup(&pi->nread);
    800041e0:	21848513          	addi	a0,s1,536
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	5c4080e7          	jalr	1476(ra) # 800017a8 <wakeup>
  release(&pi->lock);
    800041ec:	8526                	mv	a0,s1
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	300080e7          	jalr	768(ra) # 800064ee <release>
  return i;
    800041f6:	bfa9                	j	80004150 <pipewrite+0x50>

00000000800041f8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041f8:	715d                	addi	sp,sp,-80
    800041fa:	e486                	sd	ra,72(sp)
    800041fc:	e0a2                	sd	s0,64(sp)
    800041fe:	fc26                	sd	s1,56(sp)
    80004200:	f84a                	sd	s2,48(sp)
    80004202:	f44e                	sd	s3,40(sp)
    80004204:	f052                	sd	s4,32(sp)
    80004206:	ec56                	sd	s5,24(sp)
    80004208:	e85a                	sd	s6,16(sp)
    8000420a:	0880                	addi	s0,sp,80
    8000420c:	84aa                	mv	s1,a0
    8000420e:	892e                	mv	s2,a1
    80004210:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	dc6080e7          	jalr	-570(ra) # 80000fd8 <myproc>
    8000421a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000421c:	8526                	mv	a0,s1
    8000421e:	00002097          	auipc	ra,0x2
    80004222:	21c080e7          	jalr	540(ra) # 8000643a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004226:	2184a703          	lw	a4,536(s1)
    8000422a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000422e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004232:	02f71763          	bne	a4,a5,80004260 <piperead+0x68>
    80004236:	2244a783          	lw	a5,548(s1)
    8000423a:	c39d                	beqz	a5,80004260 <piperead+0x68>
    if(killed(pr)){
    8000423c:	8552                	mv	a0,s4
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	7ae080e7          	jalr	1966(ra) # 800019ec <killed>
    80004246:	e949                	bnez	a0,800042d8 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004248:	85a6                	mv	a1,s1
    8000424a:	854e                	mv	a0,s3
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	4f8080e7          	jalr	1272(ra) # 80001744 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004254:	2184a703          	lw	a4,536(s1)
    80004258:	21c4a783          	lw	a5,540(s1)
    8000425c:	fcf70de3          	beq	a4,a5,80004236 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004260:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004262:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004264:	05505463          	blez	s5,800042ac <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004268:	2184a783          	lw	a5,536(s1)
    8000426c:	21c4a703          	lw	a4,540(s1)
    80004270:	02f70e63          	beq	a4,a5,800042ac <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004274:	0017871b          	addiw	a4,a5,1
    80004278:	20e4ac23          	sw	a4,536(s1)
    8000427c:	1ff7f793          	andi	a5,a5,511
    80004280:	97a6                	add	a5,a5,s1
    80004282:	0187c783          	lbu	a5,24(a5)
    80004286:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000428a:	4685                	li	a3,1
    8000428c:	fbf40613          	addi	a2,s0,-65
    80004290:	85ca                	mv	a1,s2
    80004292:	050a3503          	ld	a0,80(s4)
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	a02080e7          	jalr	-1534(ra) # 80000c98 <copyout>
    8000429e:	01650763          	beq	a0,s6,800042ac <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a2:	2985                	addiw	s3,s3,1
    800042a4:	0905                	addi	s2,s2,1
    800042a6:	fd3a91e3          	bne	s5,s3,80004268 <piperead+0x70>
    800042aa:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042ac:	21c48513          	addi	a0,s1,540
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	4f8080e7          	jalr	1272(ra) # 800017a8 <wakeup>
  release(&pi->lock);
    800042b8:	8526                	mv	a0,s1
    800042ba:	00002097          	auipc	ra,0x2
    800042be:	234080e7          	jalr	564(ra) # 800064ee <release>
  return i;
}
    800042c2:	854e                	mv	a0,s3
    800042c4:	60a6                	ld	ra,72(sp)
    800042c6:	6406                	ld	s0,64(sp)
    800042c8:	74e2                	ld	s1,56(sp)
    800042ca:	7942                	ld	s2,48(sp)
    800042cc:	79a2                	ld	s3,40(sp)
    800042ce:	7a02                	ld	s4,32(sp)
    800042d0:	6ae2                	ld	s5,24(sp)
    800042d2:	6b42                	ld	s6,16(sp)
    800042d4:	6161                	addi	sp,sp,80
    800042d6:	8082                	ret
      release(&pi->lock);
    800042d8:	8526                	mv	a0,s1
    800042da:	00002097          	auipc	ra,0x2
    800042de:	214080e7          	jalr	532(ra) # 800064ee <release>
      return -1;
    800042e2:	59fd                	li	s3,-1
    800042e4:	bff9                	j	800042c2 <piperead+0xca>

00000000800042e6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800042e6:	1141                	addi	sp,sp,-16
    800042e8:	e422                	sd	s0,8(sp)
    800042ea:	0800                	addi	s0,sp,16
    800042ec:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800042ee:	8905                	andi	a0,a0,1
    800042f0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800042f2:	8b89                	andi	a5,a5,2
    800042f4:	c399                	beqz	a5,800042fa <flags2perm+0x14>
      perm |= PTE_W;
    800042f6:	00456513          	ori	a0,a0,4
    return perm;
}
    800042fa:	6422                	ld	s0,8(sp)
    800042fc:	0141                	addi	sp,sp,16
    800042fe:	8082                	ret

0000000080004300 <exec>:

int
exec(char *path, char **argv)
{
    80004300:	df010113          	addi	sp,sp,-528
    80004304:	20113423          	sd	ra,520(sp)
    80004308:	20813023          	sd	s0,512(sp)
    8000430c:	ffa6                	sd	s1,504(sp)
    8000430e:	fbca                	sd	s2,496(sp)
    80004310:	f7ce                	sd	s3,488(sp)
    80004312:	f3d2                	sd	s4,480(sp)
    80004314:	efd6                	sd	s5,472(sp)
    80004316:	ebda                	sd	s6,464(sp)
    80004318:	e7de                	sd	s7,456(sp)
    8000431a:	e3e2                	sd	s8,448(sp)
    8000431c:	ff66                	sd	s9,440(sp)
    8000431e:	fb6a                	sd	s10,432(sp)
    80004320:	f76e                	sd	s11,424(sp)
    80004322:	0c00                	addi	s0,sp,528
    80004324:	892a                	mv	s2,a0
    80004326:	dea43c23          	sd	a0,-520(s0)
    8000432a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	caa080e7          	jalr	-854(ra) # 80000fd8 <myproc>
    80004336:	84aa                	mv	s1,a0

  begin_op();
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	48e080e7          	jalr	1166(ra) # 800037c6 <begin_op>

  if((ip = namei(path)) == 0){
    80004340:	854a                	mv	a0,s2
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	284080e7          	jalr	644(ra) # 800035c6 <namei>
    8000434a:	c92d                	beqz	a0,800043bc <exec+0xbc>
    8000434c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000434e:	fffff097          	auipc	ra,0xfffff
    80004352:	ad2080e7          	jalr	-1326(ra) # 80002e20 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004356:	04000713          	li	a4,64
    8000435a:	4681                	li	a3,0
    8000435c:	e5040613          	addi	a2,s0,-432
    80004360:	4581                	li	a1,0
    80004362:	8552                	mv	a0,s4
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	d70080e7          	jalr	-656(ra) # 800030d4 <readi>
    8000436c:	04000793          	li	a5,64
    80004370:	00f51a63          	bne	a0,a5,80004384 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004374:	e5042703          	lw	a4,-432(s0)
    80004378:	464c47b7          	lui	a5,0x464c4
    8000437c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004380:	04f70463          	beq	a4,a5,800043c8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004384:	8552                	mv	a0,s4
    80004386:	fffff097          	auipc	ra,0xfffff
    8000438a:	cfc080e7          	jalr	-772(ra) # 80003082 <iunlockput>
    end_op();
    8000438e:	fffff097          	auipc	ra,0xfffff
    80004392:	4b2080e7          	jalr	1202(ra) # 80003840 <end_op>
  }
  return -1;
    80004396:	557d                	li	a0,-1
}
    80004398:	20813083          	ld	ra,520(sp)
    8000439c:	20013403          	ld	s0,512(sp)
    800043a0:	74fe                	ld	s1,504(sp)
    800043a2:	795e                	ld	s2,496(sp)
    800043a4:	79be                	ld	s3,488(sp)
    800043a6:	7a1e                	ld	s4,480(sp)
    800043a8:	6afe                	ld	s5,472(sp)
    800043aa:	6b5e                	ld	s6,464(sp)
    800043ac:	6bbe                	ld	s7,456(sp)
    800043ae:	6c1e                	ld	s8,448(sp)
    800043b0:	7cfa                	ld	s9,440(sp)
    800043b2:	7d5a                	ld	s10,432(sp)
    800043b4:	7dba                	ld	s11,424(sp)
    800043b6:	21010113          	addi	sp,sp,528
    800043ba:	8082                	ret
    end_op();
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	484080e7          	jalr	1156(ra) # 80003840 <end_op>
    return -1;
    800043c4:	557d                	li	a0,-1
    800043c6:	bfc9                	j	80004398 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800043c8:	8526                	mv	a0,s1
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	cd2080e7          	jalr	-814(ra) # 8000109c <proc_pagetable>
    800043d2:	8b2a                	mv	s6,a0
    800043d4:	d945                	beqz	a0,80004384 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d6:	e7042d03          	lw	s10,-400(s0)
    800043da:	e8845783          	lhu	a5,-376(s0)
    800043de:	10078463          	beqz	a5,800044e6 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043e2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800043e6:	6c85                	lui	s9,0x1
    800043e8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043ec:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043f0:	6a85                	lui	s5,0x1
    800043f2:	a0b5                	j	8000445e <exec+0x15e>
      panic("loadseg: address should exist");
    800043f4:	00004517          	auipc	a0,0x4
    800043f8:	4d450513          	addi	a0,a0,1236 # 800088c8 <syscall_names+0x288>
    800043fc:	00002097          	auipc	ra,0x2
    80004400:	b30080e7          	jalr	-1232(ra) # 80005f2c <panic>
    if(sz - i < PGSIZE)
    80004404:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004406:	8726                	mv	a4,s1
    80004408:	012c06bb          	addw	a3,s8,s2
    8000440c:	4581                	li	a1,0
    8000440e:	8552                	mv	a0,s4
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	cc4080e7          	jalr	-828(ra) # 800030d4 <readi>
    80004418:	2501                	sext.w	a0,a0
    8000441a:	24a49f63          	bne	s1,a0,80004678 <exec+0x378>
  for(i = 0; i < sz; i += PGSIZE){
    8000441e:	012a893b          	addw	s2,s5,s2
    80004422:	03397563          	bgeu	s2,s3,8000444c <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004426:	02091593          	slli	a1,s2,0x20
    8000442a:	9181                	srli	a1,a1,0x20
    8000442c:	95de                	add	a1,a1,s7
    8000442e:	855a                	mv	a0,s6
    80004430:	ffffc097          	auipc	ra,0xffffc
    80004434:	0d2080e7          	jalr	210(ra) # 80000502 <walkaddr>
    80004438:	862a                	mv	a2,a0
    if(pa == 0)
    8000443a:	dd4d                	beqz	a0,800043f4 <exec+0xf4>
    if(sz - i < PGSIZE)
    8000443c:	412984bb          	subw	s1,s3,s2
    80004440:	0004879b          	sext.w	a5,s1
    80004444:	fcfcf0e3          	bgeu	s9,a5,80004404 <exec+0x104>
    80004448:	84d6                	mv	s1,s5
    8000444a:	bf6d                	j	80004404 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000444c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004450:	2d85                	addiw	s11,s11,1
    80004452:	038d0d1b          	addiw	s10,s10,56
    80004456:	e8845783          	lhu	a5,-376(s0)
    8000445a:	08fdd763          	bge	s11,a5,800044e8 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000445e:	2d01                	sext.w	s10,s10
    80004460:	03800713          	li	a4,56
    80004464:	86ea                	mv	a3,s10
    80004466:	e1840613          	addi	a2,s0,-488
    8000446a:	4581                	li	a1,0
    8000446c:	8552                	mv	a0,s4
    8000446e:	fffff097          	auipc	ra,0xfffff
    80004472:	c66080e7          	jalr	-922(ra) # 800030d4 <readi>
    80004476:	03800793          	li	a5,56
    8000447a:	1ef51d63          	bne	a0,a5,80004674 <exec+0x374>
    if(ph.type != ELF_PROG_LOAD)
    8000447e:	e1842783          	lw	a5,-488(s0)
    80004482:	4705                	li	a4,1
    80004484:	fce796e3          	bne	a5,a4,80004450 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004488:	e4043483          	ld	s1,-448(s0)
    8000448c:	e3843783          	ld	a5,-456(s0)
    80004490:	1ef4ef63          	bltu	s1,a5,8000468e <exec+0x38e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004494:	e2843783          	ld	a5,-472(s0)
    80004498:	94be                	add	s1,s1,a5
    8000449a:	1ef4ed63          	bltu	s1,a5,80004694 <exec+0x394>
    if(ph.vaddr % PGSIZE != 0)
    8000449e:	df043703          	ld	a4,-528(s0)
    800044a2:	8ff9                	and	a5,a5,a4
    800044a4:	1e079b63          	bnez	a5,8000469a <exec+0x39a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044a8:	e1c42503          	lw	a0,-484(s0)
    800044ac:	00000097          	auipc	ra,0x0
    800044b0:	e3a080e7          	jalr	-454(ra) # 800042e6 <flags2perm>
    800044b4:	86aa                	mv	a3,a0
    800044b6:	8626                	mv	a2,s1
    800044b8:	85ca                	mv	a1,s2
    800044ba:	855a                	mv	a0,s6
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	3fa080e7          	jalr	1018(ra) # 800008b6 <uvmalloc>
    800044c4:	e0a43423          	sd	a0,-504(s0)
    800044c8:	1c050c63          	beqz	a0,800046a0 <exec+0x3a0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044cc:	e2843b83          	ld	s7,-472(s0)
    800044d0:	e2042c03          	lw	s8,-480(s0)
    800044d4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044d8:	00098463          	beqz	s3,800044e0 <exec+0x1e0>
    800044dc:	4901                	li	s2,0
    800044de:	b7a1                	j	80004426 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044e0:	e0843903          	ld	s2,-504(s0)
    800044e4:	b7b5                	j	80004450 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044e6:	4901                	li	s2,0
  iunlockput(ip);
    800044e8:	8552                	mv	a0,s4
    800044ea:	fffff097          	auipc	ra,0xfffff
    800044ee:	b98080e7          	jalr	-1128(ra) # 80003082 <iunlockput>
  end_op();
    800044f2:	fffff097          	auipc	ra,0xfffff
    800044f6:	34e080e7          	jalr	846(ra) # 80003840 <end_op>
  p = myproc();
    800044fa:	ffffd097          	auipc	ra,0xffffd
    800044fe:	ade080e7          	jalr	-1314(ra) # 80000fd8 <myproc>
    80004502:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004504:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004508:	6985                	lui	s3,0x1
    8000450a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000450c:	99ca                	add	s3,s3,s2
    8000450e:	77fd                	lui	a5,0xfffff
    80004510:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004514:	4691                	li	a3,4
    80004516:	6609                	lui	a2,0x2
    80004518:	964e                	add	a2,a2,s3
    8000451a:	85ce                	mv	a1,s3
    8000451c:	855a                	mv	a0,s6
    8000451e:	ffffc097          	auipc	ra,0xffffc
    80004522:	398080e7          	jalr	920(ra) # 800008b6 <uvmalloc>
    80004526:	892a                	mv	s2,a0
    80004528:	e0a43423          	sd	a0,-504(s0)
    8000452c:	e509                	bnez	a0,80004536 <exec+0x236>
  if(pagetable)
    8000452e:	e1343423          	sd	s3,-504(s0)
    80004532:	4a01                	li	s4,0
    80004534:	a291                	j	80004678 <exec+0x378>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004536:	75f9                	lui	a1,0xffffe
    80004538:	95aa                	add	a1,a1,a0
    8000453a:	855a                	mv	a0,s6
    8000453c:	ffffc097          	auipc	ra,0xffffc
    80004540:	72a080e7          	jalr	1834(ra) # 80000c66 <uvmclear>
  stackbase = sp - PGSIZE;
    80004544:	7bfd                	lui	s7,0xfffff
    80004546:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004548:	e0043783          	ld	a5,-512(s0)
    8000454c:	6388                	ld	a0,0(a5)
    8000454e:	c52d                	beqz	a0,800045b8 <exec+0x2b8>
    80004550:	e9040993          	addi	s3,s0,-368
    80004554:	f9040c13          	addi	s8,s0,-112
    80004558:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000455a:	ffffc097          	auipc	ra,0xffffc
    8000455e:	d9a080e7          	jalr	-614(ra) # 800002f4 <strlen>
    80004562:	0015079b          	addiw	a5,a0,1
    80004566:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000456a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000456e:	13796c63          	bltu	s2,s7,800046a6 <exec+0x3a6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004572:	e0043d03          	ld	s10,-512(s0)
    80004576:	000d3a03          	ld	s4,0(s10)
    8000457a:	8552                	mv	a0,s4
    8000457c:	ffffc097          	auipc	ra,0xffffc
    80004580:	d78080e7          	jalr	-648(ra) # 800002f4 <strlen>
    80004584:	0015069b          	addiw	a3,a0,1
    80004588:	8652                	mv	a2,s4
    8000458a:	85ca                	mv	a1,s2
    8000458c:	855a                	mv	a0,s6
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	70a080e7          	jalr	1802(ra) # 80000c98 <copyout>
    80004596:	10054a63          	bltz	a0,800046aa <exec+0x3aa>
    ustack[argc] = sp;
    8000459a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000459e:	0485                	addi	s1,s1,1
    800045a0:	008d0793          	addi	a5,s10,8
    800045a4:	e0f43023          	sd	a5,-512(s0)
    800045a8:	008d3503          	ld	a0,8(s10)
    800045ac:	c909                	beqz	a0,800045be <exec+0x2be>
    if(argc >= MAXARG)
    800045ae:	09a1                	addi	s3,s3,8
    800045b0:	fb8995e3          	bne	s3,s8,8000455a <exec+0x25a>
  ip = 0;
    800045b4:	4a01                	li	s4,0
    800045b6:	a0c9                	j	80004678 <exec+0x378>
  sp = sz;
    800045b8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800045bc:	4481                	li	s1,0
  ustack[argc] = 0;
    800045be:	00349793          	slli	a5,s1,0x3
    800045c2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdc5b0>
    800045c6:	97a2                	add	a5,a5,s0
    800045c8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045cc:	00148693          	addi	a3,s1,1
    800045d0:	068e                	slli	a3,a3,0x3
    800045d2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045d6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800045da:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800045de:	f57968e3          	bltu	s2,s7,8000452e <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045e2:	e9040613          	addi	a2,s0,-368
    800045e6:	85ca                	mv	a1,s2
    800045e8:	855a                	mv	a0,s6
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	6ae080e7          	jalr	1710(ra) # 80000c98 <copyout>
    800045f2:	0a054e63          	bltz	a0,800046ae <exec+0x3ae>
  p->trapframe->a1 = sp;
    800045f6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800045fa:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045fe:	df843783          	ld	a5,-520(s0)
    80004602:	0007c703          	lbu	a4,0(a5)
    80004606:	cf11                	beqz	a4,80004622 <exec+0x322>
    80004608:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000460a:	02f00693          	li	a3,47
    8000460e:	a039                	j	8000461c <exec+0x31c>
      last = s+1;
    80004610:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004614:	0785                	addi	a5,a5,1
    80004616:	fff7c703          	lbu	a4,-1(a5)
    8000461a:	c701                	beqz	a4,80004622 <exec+0x322>
    if(*s == '/')
    8000461c:	fed71ce3          	bne	a4,a3,80004614 <exec+0x314>
    80004620:	bfc5                	j	80004610 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004622:	4641                	li	a2,16
    80004624:	df843583          	ld	a1,-520(s0)
    80004628:	158a8513          	addi	a0,s5,344
    8000462c:	ffffc097          	auipc	ra,0xffffc
    80004630:	c96080e7          	jalr	-874(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004634:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004638:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000463c:	e0843783          	ld	a5,-504(s0)
    80004640:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004644:	058ab783          	ld	a5,88(s5)
    80004648:	e6843703          	ld	a4,-408(s0)
    8000464c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000464e:	058ab783          	ld	a5,88(s5)
    80004652:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004656:	85e6                	mv	a1,s9
    80004658:	ffffd097          	auipc	ra,0xffffd
    8000465c:	b3a080e7          	jalr	-1222(ra) # 80001192 <proc_freepagetable>
  vmprint(p->pagetable,0);
    80004660:	4581                	li	a1,0
    80004662:	050ab503          	ld	a0,80(s5)
    80004666:	ffffc097          	auipc	ra,0xffffc
    8000466a:	36e080e7          	jalr	878(ra) # 800009d4 <vmprint>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000466e:	0004851b          	sext.w	a0,s1
    80004672:	b31d                	j	80004398 <exec+0x98>
    80004674:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004678:	e0843583          	ld	a1,-504(s0)
    8000467c:	855a                	mv	a0,s6
    8000467e:	ffffd097          	auipc	ra,0xffffd
    80004682:	b14080e7          	jalr	-1260(ra) # 80001192 <proc_freepagetable>
  return -1;
    80004686:	557d                	li	a0,-1
  if(ip){
    80004688:	d00a08e3          	beqz	s4,80004398 <exec+0x98>
    8000468c:	b9e5                	j	80004384 <exec+0x84>
    8000468e:	e1243423          	sd	s2,-504(s0)
    80004692:	b7dd                	j	80004678 <exec+0x378>
    80004694:	e1243423          	sd	s2,-504(s0)
    80004698:	b7c5                	j	80004678 <exec+0x378>
    8000469a:	e1243423          	sd	s2,-504(s0)
    8000469e:	bfe9                	j	80004678 <exec+0x378>
    800046a0:	e1243423          	sd	s2,-504(s0)
    800046a4:	bfd1                	j	80004678 <exec+0x378>
  ip = 0;
    800046a6:	4a01                	li	s4,0
    800046a8:	bfc1                	j	80004678 <exec+0x378>
    800046aa:	4a01                	li	s4,0
  if(pagetable)
    800046ac:	b7f1                	j	80004678 <exec+0x378>
  sz = sz1;
    800046ae:	e0843983          	ld	s3,-504(s0)
    800046b2:	bdb5                	j	8000452e <exec+0x22e>

00000000800046b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046b4:	7179                	addi	sp,sp,-48
    800046b6:	f406                	sd	ra,40(sp)
    800046b8:	f022                	sd	s0,32(sp)
    800046ba:	ec26                	sd	s1,24(sp)
    800046bc:	e84a                	sd	s2,16(sp)
    800046be:	1800                	addi	s0,sp,48
    800046c0:	892e                	mv	s2,a1
    800046c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800046c4:	fdc40593          	addi	a1,s0,-36
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	b36080e7          	jalr	-1226(ra) # 800021fe <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046d0:	fdc42703          	lw	a4,-36(s0)
    800046d4:	47bd                	li	a5,15
    800046d6:	02e7eb63          	bltu	a5,a4,8000470c <argfd+0x58>
    800046da:	ffffd097          	auipc	ra,0xffffd
    800046de:	8fe080e7          	jalr	-1794(ra) # 80000fd8 <myproc>
    800046e2:	fdc42703          	lw	a4,-36(s0)
    800046e6:	01a70793          	addi	a5,a4,26
    800046ea:	078e                	slli	a5,a5,0x3
    800046ec:	953e                	add	a0,a0,a5
    800046ee:	611c                	ld	a5,0(a0)
    800046f0:	c385                	beqz	a5,80004710 <argfd+0x5c>
    return -1;
  if(pfd)
    800046f2:	00090463          	beqz	s2,800046fa <argfd+0x46>
    *pfd = fd;
    800046f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046fa:	4501                	li	a0,0
  if(pf)
    800046fc:	c091                	beqz	s1,80004700 <argfd+0x4c>
    *pf = f;
    800046fe:	e09c                	sd	a5,0(s1)
}
    80004700:	70a2                	ld	ra,40(sp)
    80004702:	7402                	ld	s0,32(sp)
    80004704:	64e2                	ld	s1,24(sp)
    80004706:	6942                	ld	s2,16(sp)
    80004708:	6145                	addi	sp,sp,48
    8000470a:	8082                	ret
    return -1;
    8000470c:	557d                	li	a0,-1
    8000470e:	bfcd                	j	80004700 <argfd+0x4c>
    80004710:	557d                	li	a0,-1
    80004712:	b7fd                	j	80004700 <argfd+0x4c>

0000000080004714 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004714:	1101                	addi	sp,sp,-32
    80004716:	ec06                	sd	ra,24(sp)
    80004718:	e822                	sd	s0,16(sp)
    8000471a:	e426                	sd	s1,8(sp)
    8000471c:	1000                	addi	s0,sp,32
    8000471e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004720:	ffffd097          	auipc	ra,0xffffd
    80004724:	8b8080e7          	jalr	-1864(ra) # 80000fd8 <myproc>
    80004728:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000472a:	0d050793          	addi	a5,a0,208
    8000472e:	4501                	li	a0,0
    80004730:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004732:	6398                	ld	a4,0(a5)
    80004734:	cb19                	beqz	a4,8000474a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004736:	2505                	addiw	a0,a0,1
    80004738:	07a1                	addi	a5,a5,8
    8000473a:	fed51ce3          	bne	a0,a3,80004732 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000473e:	557d                	li	a0,-1
}
    80004740:	60e2                	ld	ra,24(sp)
    80004742:	6442                	ld	s0,16(sp)
    80004744:	64a2                	ld	s1,8(sp)
    80004746:	6105                	addi	sp,sp,32
    80004748:	8082                	ret
      p->ofile[fd] = f;
    8000474a:	01a50793          	addi	a5,a0,26
    8000474e:	078e                	slli	a5,a5,0x3
    80004750:	963e                	add	a2,a2,a5
    80004752:	e204                	sd	s1,0(a2)
      return fd;
    80004754:	b7f5                	j	80004740 <fdalloc+0x2c>

0000000080004756 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004756:	715d                	addi	sp,sp,-80
    80004758:	e486                	sd	ra,72(sp)
    8000475a:	e0a2                	sd	s0,64(sp)
    8000475c:	fc26                	sd	s1,56(sp)
    8000475e:	f84a                	sd	s2,48(sp)
    80004760:	f44e                	sd	s3,40(sp)
    80004762:	f052                	sd	s4,32(sp)
    80004764:	ec56                	sd	s5,24(sp)
    80004766:	e85a                	sd	s6,16(sp)
    80004768:	0880                	addi	s0,sp,80
    8000476a:	8b2e                	mv	s6,a1
    8000476c:	89b2                	mv	s3,a2
    8000476e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004770:	fb040593          	addi	a1,s0,-80
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	e70080e7          	jalr	-400(ra) # 800035e4 <nameiparent>
    8000477c:	84aa                	mv	s1,a0
    8000477e:	14050b63          	beqz	a0,800048d4 <create+0x17e>
    return 0;

  ilock(dp);
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	69e080e7          	jalr	1694(ra) # 80002e20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000478a:	4601                	li	a2,0
    8000478c:	fb040593          	addi	a1,s0,-80
    80004790:	8526                	mv	a0,s1
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	b72080e7          	jalr	-1166(ra) # 80003304 <dirlookup>
    8000479a:	8aaa                	mv	s5,a0
    8000479c:	c921                	beqz	a0,800047ec <create+0x96>
    iunlockput(dp);
    8000479e:	8526                	mv	a0,s1
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	8e2080e7          	jalr	-1822(ra) # 80003082 <iunlockput>
    ilock(ip);
    800047a8:	8556                	mv	a0,s5
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	676080e7          	jalr	1654(ra) # 80002e20 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047b2:	4789                	li	a5,2
    800047b4:	02fb1563          	bne	s6,a5,800047de <create+0x88>
    800047b8:	044ad783          	lhu	a5,68(s5)
    800047bc:	37f9                	addiw	a5,a5,-2
    800047be:	17c2                	slli	a5,a5,0x30
    800047c0:	93c1                	srli	a5,a5,0x30
    800047c2:	4705                	li	a4,1
    800047c4:	00f76d63          	bltu	a4,a5,800047de <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800047c8:	8556                	mv	a0,s5
    800047ca:	60a6                	ld	ra,72(sp)
    800047cc:	6406                	ld	s0,64(sp)
    800047ce:	74e2                	ld	s1,56(sp)
    800047d0:	7942                	ld	s2,48(sp)
    800047d2:	79a2                	ld	s3,40(sp)
    800047d4:	7a02                	ld	s4,32(sp)
    800047d6:	6ae2                	ld	s5,24(sp)
    800047d8:	6b42                	ld	s6,16(sp)
    800047da:	6161                	addi	sp,sp,80
    800047dc:	8082                	ret
    iunlockput(ip);
    800047de:	8556                	mv	a0,s5
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	8a2080e7          	jalr	-1886(ra) # 80003082 <iunlockput>
    return 0;
    800047e8:	4a81                	li	s5,0
    800047ea:	bff9                	j	800047c8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800047ec:	85da                	mv	a1,s6
    800047ee:	4088                	lw	a0,0(s1)
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	498080e7          	jalr	1176(ra) # 80002c88 <ialloc>
    800047f8:	8a2a                	mv	s4,a0
    800047fa:	c529                	beqz	a0,80004844 <create+0xee>
  ilock(ip);
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	624080e7          	jalr	1572(ra) # 80002e20 <ilock>
  ip->major = major;
    80004804:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004808:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000480c:	4905                	li	s2,1
    8000480e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004812:	8552                	mv	a0,s4
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	540080e7          	jalr	1344(ra) # 80002d54 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000481c:	032b0b63          	beq	s6,s2,80004852 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004820:	004a2603          	lw	a2,4(s4)
    80004824:	fb040593          	addi	a1,s0,-80
    80004828:	8526                	mv	a0,s1
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	cea080e7          	jalr	-790(ra) # 80003514 <dirlink>
    80004832:	06054f63          	bltz	a0,800048b0 <create+0x15a>
  iunlockput(dp);
    80004836:	8526                	mv	a0,s1
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	84a080e7          	jalr	-1974(ra) # 80003082 <iunlockput>
  return ip;
    80004840:	8ad2                	mv	s5,s4
    80004842:	b759                	j	800047c8 <create+0x72>
    iunlockput(dp);
    80004844:	8526                	mv	a0,s1
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	83c080e7          	jalr	-1988(ra) # 80003082 <iunlockput>
    return 0;
    8000484e:	8ad2                	mv	s5,s4
    80004850:	bfa5                	j	800047c8 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004852:	004a2603          	lw	a2,4(s4)
    80004856:	00004597          	auipc	a1,0x4
    8000485a:	09258593          	addi	a1,a1,146 # 800088e8 <syscall_names+0x2a8>
    8000485e:	8552                	mv	a0,s4
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	cb4080e7          	jalr	-844(ra) # 80003514 <dirlink>
    80004868:	04054463          	bltz	a0,800048b0 <create+0x15a>
    8000486c:	40d0                	lw	a2,4(s1)
    8000486e:	00004597          	auipc	a1,0x4
    80004872:	8aa58593          	addi	a1,a1,-1878 # 80008118 <etext+0x118>
    80004876:	8552                	mv	a0,s4
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	c9c080e7          	jalr	-868(ra) # 80003514 <dirlink>
    80004880:	02054863          	bltz	a0,800048b0 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004884:	004a2603          	lw	a2,4(s4)
    80004888:	fb040593          	addi	a1,s0,-80
    8000488c:	8526                	mv	a0,s1
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	c86080e7          	jalr	-890(ra) # 80003514 <dirlink>
    80004896:	00054d63          	bltz	a0,800048b0 <create+0x15a>
    dp->nlink++;  // for ".."
    8000489a:	04a4d783          	lhu	a5,74(s1)
    8000489e:	2785                	addiw	a5,a5,1
    800048a0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800048a4:	8526                	mv	a0,s1
    800048a6:	ffffe097          	auipc	ra,0xffffe
    800048aa:	4ae080e7          	jalr	1198(ra) # 80002d54 <iupdate>
    800048ae:	b761                	j	80004836 <create+0xe0>
  ip->nlink = 0;
    800048b0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800048b4:	8552                	mv	a0,s4
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	49e080e7          	jalr	1182(ra) # 80002d54 <iupdate>
  iunlockput(ip);
    800048be:	8552                	mv	a0,s4
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	7c2080e7          	jalr	1986(ra) # 80003082 <iunlockput>
  iunlockput(dp);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	7b8080e7          	jalr	1976(ra) # 80003082 <iunlockput>
  return 0;
    800048d2:	bddd                	j	800047c8 <create+0x72>
    return 0;
    800048d4:	8aaa                	mv	s5,a0
    800048d6:	bdcd                	j	800047c8 <create+0x72>

00000000800048d8 <sys_dup>:
{
    800048d8:	7179                	addi	sp,sp,-48
    800048da:	f406                	sd	ra,40(sp)
    800048dc:	f022                	sd	s0,32(sp)
    800048de:	ec26                	sd	s1,24(sp)
    800048e0:	e84a                	sd	s2,16(sp)
    800048e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048e4:	fd840613          	addi	a2,s0,-40
    800048e8:	4581                	li	a1,0
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	dc8080e7          	jalr	-568(ra) # 800046b4 <argfd>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048f6:	02054363          	bltz	a0,8000491c <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800048fa:	fd843903          	ld	s2,-40(s0)
    800048fe:	854a                	mv	a0,s2
    80004900:	00000097          	auipc	ra,0x0
    80004904:	e14080e7          	jalr	-492(ra) # 80004714 <fdalloc>
    80004908:	84aa                	mv	s1,a0
    return -1;
    8000490a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000490c:	00054863          	bltz	a0,8000491c <sys_dup+0x44>
  filedup(f);
    80004910:	854a                	mv	a0,s2
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	326080e7          	jalr	806(ra) # 80003c38 <filedup>
  return fd;
    8000491a:	87a6                	mv	a5,s1
}
    8000491c:	853e                	mv	a0,a5
    8000491e:	70a2                	ld	ra,40(sp)
    80004920:	7402                	ld	s0,32(sp)
    80004922:	64e2                	ld	s1,24(sp)
    80004924:	6942                	ld	s2,16(sp)
    80004926:	6145                	addi	sp,sp,48
    80004928:	8082                	ret

000000008000492a <sys_read>:
{
    8000492a:	7179                	addi	sp,sp,-48
    8000492c:	f406                	sd	ra,40(sp)
    8000492e:	f022                	sd	s0,32(sp)
    80004930:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004932:	fd840593          	addi	a1,s0,-40
    80004936:	4505                	li	a0,1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	8e6080e7          	jalr	-1818(ra) # 8000221e <argaddr>
  argint(2, &n);
    80004940:	fe440593          	addi	a1,s0,-28
    80004944:	4509                	li	a0,2
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	8b8080e7          	jalr	-1864(ra) # 800021fe <argint>
  if(argfd(0, 0, &f) < 0)
    8000494e:	fe840613          	addi	a2,s0,-24
    80004952:	4581                	li	a1,0
    80004954:	4501                	li	a0,0
    80004956:	00000097          	auipc	ra,0x0
    8000495a:	d5e080e7          	jalr	-674(ra) # 800046b4 <argfd>
    8000495e:	87aa                	mv	a5,a0
    return -1;
    80004960:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004962:	0007cc63          	bltz	a5,8000497a <sys_read+0x50>
  return fileread(f, p, n);
    80004966:	fe442603          	lw	a2,-28(s0)
    8000496a:	fd843583          	ld	a1,-40(s0)
    8000496e:	fe843503          	ld	a0,-24(s0)
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	452080e7          	jalr	1106(ra) # 80003dc4 <fileread>
}
    8000497a:	70a2                	ld	ra,40(sp)
    8000497c:	7402                	ld	s0,32(sp)
    8000497e:	6145                	addi	sp,sp,48
    80004980:	8082                	ret

0000000080004982 <sys_write>:
{
    80004982:	7179                	addi	sp,sp,-48
    80004984:	f406                	sd	ra,40(sp)
    80004986:	f022                	sd	s0,32(sp)
    80004988:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000498a:	fd840593          	addi	a1,s0,-40
    8000498e:	4505                	li	a0,1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	88e080e7          	jalr	-1906(ra) # 8000221e <argaddr>
  argint(2, &n);
    80004998:	fe440593          	addi	a1,s0,-28
    8000499c:	4509                	li	a0,2
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	860080e7          	jalr	-1952(ra) # 800021fe <argint>
  if(argfd(0, 0, &f) < 0)
    800049a6:	fe840613          	addi	a2,s0,-24
    800049aa:	4581                	li	a1,0
    800049ac:	4501                	li	a0,0
    800049ae:	00000097          	auipc	ra,0x0
    800049b2:	d06080e7          	jalr	-762(ra) # 800046b4 <argfd>
    800049b6:	87aa                	mv	a5,a0
    return -1;
    800049b8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049ba:	0007cc63          	bltz	a5,800049d2 <sys_write+0x50>
  return filewrite(f, p, n);
    800049be:	fe442603          	lw	a2,-28(s0)
    800049c2:	fd843583          	ld	a1,-40(s0)
    800049c6:	fe843503          	ld	a0,-24(s0)
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	4bc080e7          	jalr	1212(ra) # 80003e86 <filewrite>
}
    800049d2:	70a2                	ld	ra,40(sp)
    800049d4:	7402                	ld	s0,32(sp)
    800049d6:	6145                	addi	sp,sp,48
    800049d8:	8082                	ret

00000000800049da <sys_close>:
{
    800049da:	1101                	addi	sp,sp,-32
    800049dc:	ec06                	sd	ra,24(sp)
    800049de:	e822                	sd	s0,16(sp)
    800049e0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049e2:	fe040613          	addi	a2,s0,-32
    800049e6:	fec40593          	addi	a1,s0,-20
    800049ea:	4501                	li	a0,0
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	cc8080e7          	jalr	-824(ra) # 800046b4 <argfd>
    return -1;
    800049f4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049f6:	02054463          	bltz	a0,80004a1e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	5de080e7          	jalr	1502(ra) # 80000fd8 <myproc>
    80004a02:	fec42783          	lw	a5,-20(s0)
    80004a06:	07e9                	addi	a5,a5,26
    80004a08:	078e                	slli	a5,a5,0x3
    80004a0a:	953e                	add	a0,a0,a5
    80004a0c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a10:	fe043503          	ld	a0,-32(s0)
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	276080e7          	jalr	630(ra) # 80003c8a <fileclose>
  return 0;
    80004a1c:	4781                	li	a5,0
}
    80004a1e:	853e                	mv	a0,a5
    80004a20:	60e2                	ld	ra,24(sp)
    80004a22:	6442                	ld	s0,16(sp)
    80004a24:	6105                	addi	sp,sp,32
    80004a26:	8082                	ret

0000000080004a28 <sys_fstat>:
{
    80004a28:	1101                	addi	sp,sp,-32
    80004a2a:	ec06                	sd	ra,24(sp)
    80004a2c:	e822                	sd	s0,16(sp)
    80004a2e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004a30:	fe040593          	addi	a1,s0,-32
    80004a34:	4505                	li	a0,1
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	7e8080e7          	jalr	2024(ra) # 8000221e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a3e:	fe840613          	addi	a2,s0,-24
    80004a42:	4581                	li	a1,0
    80004a44:	4501                	li	a0,0
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	c6e080e7          	jalr	-914(ra) # 800046b4 <argfd>
    80004a4e:	87aa                	mv	a5,a0
    return -1;
    80004a50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a52:	0007ca63          	bltz	a5,80004a66 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a56:	fe043583          	ld	a1,-32(s0)
    80004a5a:	fe843503          	ld	a0,-24(s0)
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	2f4080e7          	jalr	756(ra) # 80003d52 <filestat>
}
    80004a66:	60e2                	ld	ra,24(sp)
    80004a68:	6442                	ld	s0,16(sp)
    80004a6a:	6105                	addi	sp,sp,32
    80004a6c:	8082                	ret

0000000080004a6e <sys_link>:
{
    80004a6e:	7169                	addi	sp,sp,-304
    80004a70:	f606                	sd	ra,296(sp)
    80004a72:	f222                	sd	s0,288(sp)
    80004a74:	ee26                	sd	s1,280(sp)
    80004a76:	ea4a                	sd	s2,272(sp)
    80004a78:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a7a:	08000613          	li	a2,128
    80004a7e:	ed040593          	addi	a1,s0,-304
    80004a82:	4501                	li	a0,0
    80004a84:	ffffd097          	auipc	ra,0xffffd
    80004a88:	7ba080e7          	jalr	1978(ra) # 8000223e <argstr>
    return -1;
    80004a8c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a8e:	10054e63          	bltz	a0,80004baa <sys_link+0x13c>
    80004a92:	08000613          	li	a2,128
    80004a96:	f5040593          	addi	a1,s0,-176
    80004a9a:	4505                	li	a0,1
    80004a9c:	ffffd097          	auipc	ra,0xffffd
    80004aa0:	7a2080e7          	jalr	1954(ra) # 8000223e <argstr>
    return -1;
    80004aa4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aa6:	10054263          	bltz	a0,80004baa <sys_link+0x13c>
  begin_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	d1c080e7          	jalr	-740(ra) # 800037c6 <begin_op>
  if((ip = namei(old)) == 0){
    80004ab2:	ed040513          	addi	a0,s0,-304
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	b10080e7          	jalr	-1264(ra) # 800035c6 <namei>
    80004abe:	84aa                	mv	s1,a0
    80004ac0:	c551                	beqz	a0,80004b4c <sys_link+0xde>
  ilock(ip);
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	35e080e7          	jalr	862(ra) # 80002e20 <ilock>
  if(ip->type == T_DIR){
    80004aca:	04449703          	lh	a4,68(s1)
    80004ace:	4785                	li	a5,1
    80004ad0:	08f70463          	beq	a4,a5,80004b58 <sys_link+0xea>
  ip->nlink++;
    80004ad4:	04a4d783          	lhu	a5,74(s1)
    80004ad8:	2785                	addiw	a5,a5,1
    80004ada:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ade:	8526                	mv	a0,s1
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	274080e7          	jalr	628(ra) # 80002d54 <iupdate>
  iunlock(ip);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	3f8080e7          	jalr	1016(ra) # 80002ee2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004af2:	fd040593          	addi	a1,s0,-48
    80004af6:	f5040513          	addi	a0,s0,-176
    80004afa:	fffff097          	auipc	ra,0xfffff
    80004afe:	aea080e7          	jalr	-1302(ra) # 800035e4 <nameiparent>
    80004b02:	892a                	mv	s2,a0
    80004b04:	c935                	beqz	a0,80004b78 <sys_link+0x10a>
  ilock(dp);
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	31a080e7          	jalr	794(ra) # 80002e20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b0e:	00092703          	lw	a4,0(s2)
    80004b12:	409c                	lw	a5,0(s1)
    80004b14:	04f71d63          	bne	a4,a5,80004b6e <sys_link+0x100>
    80004b18:	40d0                	lw	a2,4(s1)
    80004b1a:	fd040593          	addi	a1,s0,-48
    80004b1e:	854a                	mv	a0,s2
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	9f4080e7          	jalr	-1548(ra) # 80003514 <dirlink>
    80004b28:	04054363          	bltz	a0,80004b6e <sys_link+0x100>
  iunlockput(dp);
    80004b2c:	854a                	mv	a0,s2
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	554080e7          	jalr	1364(ra) # 80003082 <iunlockput>
  iput(ip);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	4a2080e7          	jalr	1186(ra) # 80002fda <iput>
  end_op();
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	d00080e7          	jalr	-768(ra) # 80003840 <end_op>
  return 0;
    80004b48:	4781                	li	a5,0
    80004b4a:	a085                	j	80004baa <sys_link+0x13c>
    end_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	cf4080e7          	jalr	-780(ra) # 80003840 <end_op>
    return -1;
    80004b54:	57fd                	li	a5,-1
    80004b56:	a891                	j	80004baa <sys_link+0x13c>
    iunlockput(ip);
    80004b58:	8526                	mv	a0,s1
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	528080e7          	jalr	1320(ra) # 80003082 <iunlockput>
    end_op();
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	cde080e7          	jalr	-802(ra) # 80003840 <end_op>
    return -1;
    80004b6a:	57fd                	li	a5,-1
    80004b6c:	a83d                	j	80004baa <sys_link+0x13c>
    iunlockput(dp);
    80004b6e:	854a                	mv	a0,s2
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	512080e7          	jalr	1298(ra) # 80003082 <iunlockput>
  ilock(ip);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	2a6080e7          	jalr	678(ra) # 80002e20 <ilock>
  ip->nlink--;
    80004b82:	04a4d783          	lhu	a5,74(s1)
    80004b86:	37fd                	addiw	a5,a5,-1
    80004b88:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	1c6080e7          	jalr	454(ra) # 80002d54 <iupdate>
  iunlockput(ip);
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	4ea080e7          	jalr	1258(ra) # 80003082 <iunlockput>
  end_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	ca0080e7          	jalr	-864(ra) # 80003840 <end_op>
  return -1;
    80004ba8:	57fd                	li	a5,-1
}
    80004baa:	853e                	mv	a0,a5
    80004bac:	70b2                	ld	ra,296(sp)
    80004bae:	7412                	ld	s0,288(sp)
    80004bb0:	64f2                	ld	s1,280(sp)
    80004bb2:	6952                	ld	s2,272(sp)
    80004bb4:	6155                	addi	sp,sp,304
    80004bb6:	8082                	ret

0000000080004bb8 <sys_unlink>:
{
    80004bb8:	7151                	addi	sp,sp,-240
    80004bba:	f586                	sd	ra,232(sp)
    80004bbc:	f1a2                	sd	s0,224(sp)
    80004bbe:	eda6                	sd	s1,216(sp)
    80004bc0:	e9ca                	sd	s2,208(sp)
    80004bc2:	e5ce                	sd	s3,200(sp)
    80004bc4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bc6:	08000613          	li	a2,128
    80004bca:	f3040593          	addi	a1,s0,-208
    80004bce:	4501                	li	a0,0
    80004bd0:	ffffd097          	auipc	ra,0xffffd
    80004bd4:	66e080e7          	jalr	1646(ra) # 8000223e <argstr>
    80004bd8:	18054163          	bltz	a0,80004d5a <sys_unlink+0x1a2>
  begin_op();
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	bea080e7          	jalr	-1046(ra) # 800037c6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004be4:	fb040593          	addi	a1,s0,-80
    80004be8:	f3040513          	addi	a0,s0,-208
    80004bec:	fffff097          	auipc	ra,0xfffff
    80004bf0:	9f8080e7          	jalr	-1544(ra) # 800035e4 <nameiparent>
    80004bf4:	84aa                	mv	s1,a0
    80004bf6:	c979                	beqz	a0,80004ccc <sys_unlink+0x114>
  ilock(dp);
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	228080e7          	jalr	552(ra) # 80002e20 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c00:	00004597          	auipc	a1,0x4
    80004c04:	ce858593          	addi	a1,a1,-792 # 800088e8 <syscall_names+0x2a8>
    80004c08:	fb040513          	addi	a0,s0,-80
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	6de080e7          	jalr	1758(ra) # 800032ea <namecmp>
    80004c14:	14050a63          	beqz	a0,80004d68 <sys_unlink+0x1b0>
    80004c18:	00003597          	auipc	a1,0x3
    80004c1c:	50058593          	addi	a1,a1,1280 # 80008118 <etext+0x118>
    80004c20:	fb040513          	addi	a0,s0,-80
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	6c6080e7          	jalr	1734(ra) # 800032ea <namecmp>
    80004c2c:	12050e63          	beqz	a0,80004d68 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c30:	f2c40613          	addi	a2,s0,-212
    80004c34:	fb040593          	addi	a1,s0,-80
    80004c38:	8526                	mv	a0,s1
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	6ca080e7          	jalr	1738(ra) # 80003304 <dirlookup>
    80004c42:	892a                	mv	s2,a0
    80004c44:	12050263          	beqz	a0,80004d68 <sys_unlink+0x1b0>
  ilock(ip);
    80004c48:	ffffe097          	auipc	ra,0xffffe
    80004c4c:	1d8080e7          	jalr	472(ra) # 80002e20 <ilock>
  if(ip->nlink < 1)
    80004c50:	04a91783          	lh	a5,74(s2)
    80004c54:	08f05263          	blez	a5,80004cd8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c58:	04491703          	lh	a4,68(s2)
    80004c5c:	4785                	li	a5,1
    80004c5e:	08f70563          	beq	a4,a5,80004ce8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c62:	4641                	li	a2,16
    80004c64:	4581                	li	a1,0
    80004c66:	fc040513          	addi	a0,s0,-64
    80004c6a:	ffffb097          	auipc	ra,0xffffb
    80004c6e:	510080e7          	jalr	1296(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c72:	4741                	li	a4,16
    80004c74:	f2c42683          	lw	a3,-212(s0)
    80004c78:	fc040613          	addi	a2,s0,-64
    80004c7c:	4581                	li	a1,0
    80004c7e:	8526                	mv	a0,s1
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	54c080e7          	jalr	1356(ra) # 800031cc <writei>
    80004c88:	47c1                	li	a5,16
    80004c8a:	0af51563          	bne	a0,a5,80004d34 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c8e:	04491703          	lh	a4,68(s2)
    80004c92:	4785                	li	a5,1
    80004c94:	0af70863          	beq	a4,a5,80004d44 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c98:	8526                	mv	a0,s1
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	3e8080e7          	jalr	1000(ra) # 80003082 <iunlockput>
  ip->nlink--;
    80004ca2:	04a95783          	lhu	a5,74(s2)
    80004ca6:	37fd                	addiw	a5,a5,-1
    80004ca8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	0a6080e7          	jalr	166(ra) # 80002d54 <iupdate>
  iunlockput(ip);
    80004cb6:	854a                	mv	a0,s2
    80004cb8:	ffffe097          	auipc	ra,0xffffe
    80004cbc:	3ca080e7          	jalr	970(ra) # 80003082 <iunlockput>
  end_op();
    80004cc0:	fffff097          	auipc	ra,0xfffff
    80004cc4:	b80080e7          	jalr	-1152(ra) # 80003840 <end_op>
  return 0;
    80004cc8:	4501                	li	a0,0
    80004cca:	a84d                	j	80004d7c <sys_unlink+0x1c4>
    end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	b74080e7          	jalr	-1164(ra) # 80003840 <end_op>
    return -1;
    80004cd4:	557d                	li	a0,-1
    80004cd6:	a05d                	j	80004d7c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004cd8:	00004517          	auipc	a0,0x4
    80004cdc:	c1850513          	addi	a0,a0,-1000 # 800088f0 <syscall_names+0x2b0>
    80004ce0:	00001097          	auipc	ra,0x1
    80004ce4:	24c080e7          	jalr	588(ra) # 80005f2c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce8:	04c92703          	lw	a4,76(s2)
    80004cec:	02000793          	li	a5,32
    80004cf0:	f6e7f9e3          	bgeu	a5,a4,80004c62 <sys_unlink+0xaa>
    80004cf4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cf8:	4741                	li	a4,16
    80004cfa:	86ce                	mv	a3,s3
    80004cfc:	f1840613          	addi	a2,s0,-232
    80004d00:	4581                	li	a1,0
    80004d02:	854a                	mv	a0,s2
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	3d0080e7          	jalr	976(ra) # 800030d4 <readi>
    80004d0c:	47c1                	li	a5,16
    80004d0e:	00f51b63          	bne	a0,a5,80004d24 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d12:	f1845783          	lhu	a5,-232(s0)
    80004d16:	e7a1                	bnez	a5,80004d5e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d18:	29c1                	addiw	s3,s3,16
    80004d1a:	04c92783          	lw	a5,76(s2)
    80004d1e:	fcf9ede3          	bltu	s3,a5,80004cf8 <sys_unlink+0x140>
    80004d22:	b781                	j	80004c62 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d24:	00004517          	auipc	a0,0x4
    80004d28:	be450513          	addi	a0,a0,-1052 # 80008908 <syscall_names+0x2c8>
    80004d2c:	00001097          	auipc	ra,0x1
    80004d30:	200080e7          	jalr	512(ra) # 80005f2c <panic>
    panic("unlink: writei");
    80004d34:	00004517          	auipc	a0,0x4
    80004d38:	bec50513          	addi	a0,a0,-1044 # 80008920 <syscall_names+0x2e0>
    80004d3c:	00001097          	auipc	ra,0x1
    80004d40:	1f0080e7          	jalr	496(ra) # 80005f2c <panic>
    dp->nlink--;
    80004d44:	04a4d783          	lhu	a5,74(s1)
    80004d48:	37fd                	addiw	a5,a5,-1
    80004d4a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	004080e7          	jalr	4(ra) # 80002d54 <iupdate>
    80004d58:	b781                	j	80004c98 <sys_unlink+0xe0>
    return -1;
    80004d5a:	557d                	li	a0,-1
    80004d5c:	a005                	j	80004d7c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d5e:	854a                	mv	a0,s2
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	322080e7          	jalr	802(ra) # 80003082 <iunlockput>
  iunlockput(dp);
    80004d68:	8526                	mv	a0,s1
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	318080e7          	jalr	792(ra) # 80003082 <iunlockput>
  end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	ace080e7          	jalr	-1330(ra) # 80003840 <end_op>
  return -1;
    80004d7a:	557d                	li	a0,-1
}
    80004d7c:	70ae                	ld	ra,232(sp)
    80004d7e:	740e                	ld	s0,224(sp)
    80004d80:	64ee                	ld	s1,216(sp)
    80004d82:	694e                	ld	s2,208(sp)
    80004d84:	69ae                	ld	s3,200(sp)
    80004d86:	616d                	addi	sp,sp,240
    80004d88:	8082                	ret

0000000080004d8a <sys_open>:

uint64
sys_open(void)
{
    80004d8a:	7131                	addi	sp,sp,-192
    80004d8c:	fd06                	sd	ra,184(sp)
    80004d8e:	f922                	sd	s0,176(sp)
    80004d90:	f526                	sd	s1,168(sp)
    80004d92:	f14a                	sd	s2,160(sp)
    80004d94:	ed4e                	sd	s3,152(sp)
    80004d96:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d98:	f4c40593          	addi	a1,s0,-180
    80004d9c:	4505                	li	a0,1
    80004d9e:	ffffd097          	auipc	ra,0xffffd
    80004da2:	460080e7          	jalr	1120(ra) # 800021fe <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004da6:	08000613          	li	a2,128
    80004daa:	f5040593          	addi	a1,s0,-176
    80004dae:	4501                	li	a0,0
    80004db0:	ffffd097          	auipc	ra,0xffffd
    80004db4:	48e080e7          	jalr	1166(ra) # 8000223e <argstr>
    80004db8:	87aa                	mv	a5,a0
    return -1;
    80004dba:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dbc:	0a07c863          	bltz	a5,80004e6c <sys_open+0xe2>

  begin_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	a06080e7          	jalr	-1530(ra) # 800037c6 <begin_op>

  if(omode & O_CREATE){
    80004dc8:	f4c42783          	lw	a5,-180(s0)
    80004dcc:	2007f793          	andi	a5,a5,512
    80004dd0:	cbdd                	beqz	a5,80004e86 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004dd2:	4681                	li	a3,0
    80004dd4:	4601                	li	a2,0
    80004dd6:	4589                	li	a1,2
    80004dd8:	f5040513          	addi	a0,s0,-176
    80004ddc:	00000097          	auipc	ra,0x0
    80004de0:	97a080e7          	jalr	-1670(ra) # 80004756 <create>
    80004de4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004de6:	c951                	beqz	a0,80004e7a <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004de8:	04449703          	lh	a4,68(s1)
    80004dec:	478d                	li	a5,3
    80004dee:	00f71763          	bne	a4,a5,80004dfc <sys_open+0x72>
    80004df2:	0464d703          	lhu	a4,70(s1)
    80004df6:	47a5                	li	a5,9
    80004df8:	0ce7ec63          	bltu	a5,a4,80004ed0 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	dd2080e7          	jalr	-558(ra) # 80003bce <filealloc>
    80004e04:	892a                	mv	s2,a0
    80004e06:	c56d                	beqz	a0,80004ef0 <sys_open+0x166>
    80004e08:	00000097          	auipc	ra,0x0
    80004e0c:	90c080e7          	jalr	-1780(ra) # 80004714 <fdalloc>
    80004e10:	89aa                	mv	s3,a0
    80004e12:	0c054a63          	bltz	a0,80004ee6 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e16:	04449703          	lh	a4,68(s1)
    80004e1a:	478d                	li	a5,3
    80004e1c:	0ef70563          	beq	a4,a5,80004f06 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e20:	4789                	li	a5,2
    80004e22:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e26:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e2a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e2e:	f4c42783          	lw	a5,-180(s0)
    80004e32:	0017c713          	xori	a4,a5,1
    80004e36:	8b05                	andi	a4,a4,1
    80004e38:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e3c:	0037f713          	andi	a4,a5,3
    80004e40:	00e03733          	snez	a4,a4
    80004e44:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e48:	4007f793          	andi	a5,a5,1024
    80004e4c:	c791                	beqz	a5,80004e58 <sys_open+0xce>
    80004e4e:	04449703          	lh	a4,68(s1)
    80004e52:	4789                	li	a5,2
    80004e54:	0cf70063          	beq	a4,a5,80004f14 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	088080e7          	jalr	136(ra) # 80002ee2 <iunlock>
  end_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	9de080e7          	jalr	-1570(ra) # 80003840 <end_op>

  return fd;
    80004e6a:	854e                	mv	a0,s3
}
    80004e6c:	70ea                	ld	ra,184(sp)
    80004e6e:	744a                	ld	s0,176(sp)
    80004e70:	74aa                	ld	s1,168(sp)
    80004e72:	790a                	ld	s2,160(sp)
    80004e74:	69ea                	ld	s3,152(sp)
    80004e76:	6129                	addi	sp,sp,192
    80004e78:	8082                	ret
      end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	9c6080e7          	jalr	-1594(ra) # 80003840 <end_op>
      return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	b7e5                	j	80004e6c <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004e86:	f5040513          	addi	a0,s0,-176
    80004e8a:	ffffe097          	auipc	ra,0xffffe
    80004e8e:	73c080e7          	jalr	1852(ra) # 800035c6 <namei>
    80004e92:	84aa                	mv	s1,a0
    80004e94:	c905                	beqz	a0,80004ec4 <sys_open+0x13a>
    ilock(ip);
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	f8a080e7          	jalr	-118(ra) # 80002e20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e9e:	04449703          	lh	a4,68(s1)
    80004ea2:	4785                	li	a5,1
    80004ea4:	f4f712e3          	bne	a4,a5,80004de8 <sys_open+0x5e>
    80004ea8:	f4c42783          	lw	a5,-180(s0)
    80004eac:	dba1                	beqz	a5,80004dfc <sys_open+0x72>
      iunlockput(ip);
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	1d2080e7          	jalr	466(ra) # 80003082 <iunlockput>
      end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	988080e7          	jalr	-1656(ra) # 80003840 <end_op>
      return -1;
    80004ec0:	557d                	li	a0,-1
    80004ec2:	b76d                	j	80004e6c <sys_open+0xe2>
      end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	97c080e7          	jalr	-1668(ra) # 80003840 <end_op>
      return -1;
    80004ecc:	557d                	li	a0,-1
    80004ece:	bf79                	j	80004e6c <sys_open+0xe2>
    iunlockput(ip);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	ffffe097          	auipc	ra,0xffffe
    80004ed6:	1b0080e7          	jalr	432(ra) # 80003082 <iunlockput>
    end_op();
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	966080e7          	jalr	-1690(ra) # 80003840 <end_op>
    return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	b761                	j	80004e6c <sys_open+0xe2>
      fileclose(f);
    80004ee6:	854a                	mv	a0,s2
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	da2080e7          	jalr	-606(ra) # 80003c8a <fileclose>
    iunlockput(ip);
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	ffffe097          	auipc	ra,0xffffe
    80004ef6:	190080e7          	jalr	400(ra) # 80003082 <iunlockput>
    end_op();
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	946080e7          	jalr	-1722(ra) # 80003840 <end_op>
    return -1;
    80004f02:	557d                	li	a0,-1
    80004f04:	b7a5                	j	80004e6c <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004f06:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004f0a:	04649783          	lh	a5,70(s1)
    80004f0e:	02f91223          	sh	a5,36(s2)
    80004f12:	bf21                	j	80004e2a <sys_open+0xa0>
    itrunc(ip);
    80004f14:	8526                	mv	a0,s1
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	018080e7          	jalr	24(ra) # 80002f2e <itrunc>
    80004f1e:	bf2d                	j	80004e58 <sys_open+0xce>

0000000080004f20 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f20:	7175                	addi	sp,sp,-144
    80004f22:	e506                	sd	ra,136(sp)
    80004f24:	e122                	sd	s0,128(sp)
    80004f26:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	89e080e7          	jalr	-1890(ra) # 800037c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f30:	08000613          	li	a2,128
    80004f34:	f7040593          	addi	a1,s0,-144
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	304080e7          	jalr	772(ra) # 8000223e <argstr>
    80004f42:	02054963          	bltz	a0,80004f74 <sys_mkdir+0x54>
    80004f46:	4681                	li	a3,0
    80004f48:	4601                	li	a2,0
    80004f4a:	4585                	li	a1,1
    80004f4c:	f7040513          	addi	a0,s0,-144
    80004f50:	00000097          	auipc	ra,0x0
    80004f54:	806080e7          	jalr	-2042(ra) # 80004756 <create>
    80004f58:	cd11                	beqz	a0,80004f74 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	128080e7          	jalr	296(ra) # 80003082 <iunlockput>
  end_op();
    80004f62:	fffff097          	auipc	ra,0xfffff
    80004f66:	8de080e7          	jalr	-1826(ra) # 80003840 <end_op>
  return 0;
    80004f6a:	4501                	li	a0,0
}
    80004f6c:	60aa                	ld	ra,136(sp)
    80004f6e:	640a                	ld	s0,128(sp)
    80004f70:	6149                	addi	sp,sp,144
    80004f72:	8082                	ret
    end_op();
    80004f74:	fffff097          	auipc	ra,0xfffff
    80004f78:	8cc080e7          	jalr	-1844(ra) # 80003840 <end_op>
    return -1;
    80004f7c:	557d                	li	a0,-1
    80004f7e:	b7fd                	j	80004f6c <sys_mkdir+0x4c>

0000000080004f80 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f80:	7135                	addi	sp,sp,-160
    80004f82:	ed06                	sd	ra,152(sp)
    80004f84:	e922                	sd	s0,144(sp)
    80004f86:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	83e080e7          	jalr	-1986(ra) # 800037c6 <begin_op>
  argint(1, &major);
    80004f90:	f6c40593          	addi	a1,s0,-148
    80004f94:	4505                	li	a0,1
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	268080e7          	jalr	616(ra) # 800021fe <argint>
  argint(2, &minor);
    80004f9e:	f6840593          	addi	a1,s0,-152
    80004fa2:	4509                	li	a0,2
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	25a080e7          	jalr	602(ra) # 800021fe <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fac:	08000613          	li	a2,128
    80004fb0:	f7040593          	addi	a1,s0,-144
    80004fb4:	4501                	li	a0,0
    80004fb6:	ffffd097          	auipc	ra,0xffffd
    80004fba:	288080e7          	jalr	648(ra) # 8000223e <argstr>
    80004fbe:	02054b63          	bltz	a0,80004ff4 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fc2:	f6841683          	lh	a3,-152(s0)
    80004fc6:	f6c41603          	lh	a2,-148(s0)
    80004fca:	458d                	li	a1,3
    80004fcc:	f7040513          	addi	a0,s0,-144
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	786080e7          	jalr	1926(ra) # 80004756 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fd8:	cd11                	beqz	a0,80004ff4 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	0a8080e7          	jalr	168(ra) # 80003082 <iunlockput>
  end_op();
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	85e080e7          	jalr	-1954(ra) # 80003840 <end_op>
  return 0;
    80004fea:	4501                	li	a0,0
}
    80004fec:	60ea                	ld	ra,152(sp)
    80004fee:	644a                	ld	s0,144(sp)
    80004ff0:	610d                	addi	sp,sp,160
    80004ff2:	8082                	ret
    end_op();
    80004ff4:	fffff097          	auipc	ra,0xfffff
    80004ff8:	84c080e7          	jalr	-1972(ra) # 80003840 <end_op>
    return -1;
    80004ffc:	557d                	li	a0,-1
    80004ffe:	b7fd                	j	80004fec <sys_mknod+0x6c>

0000000080005000 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005000:	7135                	addi	sp,sp,-160
    80005002:	ed06                	sd	ra,152(sp)
    80005004:	e922                	sd	s0,144(sp)
    80005006:	e526                	sd	s1,136(sp)
    80005008:	e14a                	sd	s2,128(sp)
    8000500a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000500c:	ffffc097          	auipc	ra,0xffffc
    80005010:	fcc080e7          	jalr	-52(ra) # 80000fd8 <myproc>
    80005014:	892a                	mv	s2,a0
  
  begin_op();
    80005016:	ffffe097          	auipc	ra,0xffffe
    8000501a:	7b0080e7          	jalr	1968(ra) # 800037c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000501e:	08000613          	li	a2,128
    80005022:	f6040593          	addi	a1,s0,-160
    80005026:	4501                	li	a0,0
    80005028:	ffffd097          	auipc	ra,0xffffd
    8000502c:	216080e7          	jalr	534(ra) # 8000223e <argstr>
    80005030:	04054b63          	bltz	a0,80005086 <sys_chdir+0x86>
    80005034:	f6040513          	addi	a0,s0,-160
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	58e080e7          	jalr	1422(ra) # 800035c6 <namei>
    80005040:	84aa                	mv	s1,a0
    80005042:	c131                	beqz	a0,80005086 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	ddc080e7          	jalr	-548(ra) # 80002e20 <ilock>
  if(ip->type != T_DIR){
    8000504c:	04449703          	lh	a4,68(s1)
    80005050:	4785                	li	a5,1
    80005052:	04f71063          	bne	a4,a5,80005092 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005056:	8526                	mv	a0,s1
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	e8a080e7          	jalr	-374(ra) # 80002ee2 <iunlock>
  iput(p->cwd);
    80005060:	15093503          	ld	a0,336(s2)
    80005064:	ffffe097          	auipc	ra,0xffffe
    80005068:	f76080e7          	jalr	-138(ra) # 80002fda <iput>
  end_op();
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	7d4080e7          	jalr	2004(ra) # 80003840 <end_op>
  p->cwd = ip;
    80005074:	14993823          	sd	s1,336(s2)
  return 0;
    80005078:	4501                	li	a0,0
}
    8000507a:	60ea                	ld	ra,152(sp)
    8000507c:	644a                	ld	s0,144(sp)
    8000507e:	64aa                	ld	s1,136(sp)
    80005080:	690a                	ld	s2,128(sp)
    80005082:	610d                	addi	sp,sp,160
    80005084:	8082                	ret
    end_op();
    80005086:	ffffe097          	auipc	ra,0xffffe
    8000508a:	7ba080e7          	jalr	1978(ra) # 80003840 <end_op>
    return -1;
    8000508e:	557d                	li	a0,-1
    80005090:	b7ed                	j	8000507a <sys_chdir+0x7a>
    iunlockput(ip);
    80005092:	8526                	mv	a0,s1
    80005094:	ffffe097          	auipc	ra,0xffffe
    80005098:	fee080e7          	jalr	-18(ra) # 80003082 <iunlockput>
    end_op();
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	7a4080e7          	jalr	1956(ra) # 80003840 <end_op>
    return -1;
    800050a4:	557d                	li	a0,-1
    800050a6:	bfd1                	j	8000507a <sys_chdir+0x7a>

00000000800050a8 <sys_exec>:

uint64
sys_exec(void)
{
    800050a8:	7121                	addi	sp,sp,-448
    800050aa:	ff06                	sd	ra,440(sp)
    800050ac:	fb22                	sd	s0,432(sp)
    800050ae:	f726                	sd	s1,424(sp)
    800050b0:	f34a                	sd	s2,416(sp)
    800050b2:	ef4e                	sd	s3,408(sp)
    800050b4:	eb52                	sd	s4,400(sp)
    800050b6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050b8:	e4840593          	addi	a1,s0,-440
    800050bc:	4505                	li	a0,1
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	160080e7          	jalr	352(ra) # 8000221e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800050c6:	08000613          	li	a2,128
    800050ca:	f5040593          	addi	a1,s0,-176
    800050ce:	4501                	li	a0,0
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	16e080e7          	jalr	366(ra) # 8000223e <argstr>
    800050d8:	87aa                	mv	a5,a0
    return -1;
    800050da:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800050dc:	0c07c263          	bltz	a5,800051a0 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800050e0:	10000613          	li	a2,256
    800050e4:	4581                	li	a1,0
    800050e6:	e5040513          	addi	a0,s0,-432
    800050ea:	ffffb097          	auipc	ra,0xffffb
    800050ee:	090080e7          	jalr	144(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050f2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050f6:	89a6                	mv	s3,s1
    800050f8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050fa:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050fe:	00391513          	slli	a0,s2,0x3
    80005102:	e4040593          	addi	a1,s0,-448
    80005106:	e4843783          	ld	a5,-440(s0)
    8000510a:	953e                	add	a0,a0,a5
    8000510c:	ffffd097          	auipc	ra,0xffffd
    80005110:	054080e7          	jalr	84(ra) # 80002160 <fetchaddr>
    80005114:	02054a63          	bltz	a0,80005148 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005118:	e4043783          	ld	a5,-448(s0)
    8000511c:	c3b9                	beqz	a5,80005162 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000511e:	ffffb097          	auipc	ra,0xffffb
    80005122:	ffc080e7          	jalr	-4(ra) # 8000011a <kalloc>
    80005126:	85aa                	mv	a1,a0
    80005128:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000512c:	cd11                	beqz	a0,80005148 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000512e:	6605                	lui	a2,0x1
    80005130:	e4043503          	ld	a0,-448(s0)
    80005134:	ffffd097          	auipc	ra,0xffffd
    80005138:	07e080e7          	jalr	126(ra) # 800021b2 <fetchstr>
    8000513c:	00054663          	bltz	a0,80005148 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005140:	0905                	addi	s2,s2,1
    80005142:	09a1                	addi	s3,s3,8
    80005144:	fb491de3          	bne	s2,s4,800050fe <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005148:	f5040913          	addi	s2,s0,-176
    8000514c:	6088                	ld	a0,0(s1)
    8000514e:	c921                	beqz	a0,8000519e <sys_exec+0xf6>
    kfree(argv[i]);
    80005150:	ffffb097          	auipc	ra,0xffffb
    80005154:	ecc080e7          	jalr	-308(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005158:	04a1                	addi	s1,s1,8
    8000515a:	ff2499e3          	bne	s1,s2,8000514c <sys_exec+0xa4>
  return -1;
    8000515e:	557d                	li	a0,-1
    80005160:	a081                	j	800051a0 <sys_exec+0xf8>
      argv[i] = 0;
    80005162:	0009079b          	sext.w	a5,s2
    80005166:	078e                	slli	a5,a5,0x3
    80005168:	fd078793          	addi	a5,a5,-48
    8000516c:	97a2                	add	a5,a5,s0
    8000516e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005172:	e5040593          	addi	a1,s0,-432
    80005176:	f5040513          	addi	a0,s0,-176
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	186080e7          	jalr	390(ra) # 80004300 <exec>
    80005182:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005184:	f5040993          	addi	s3,s0,-176
    80005188:	6088                	ld	a0,0(s1)
    8000518a:	c901                	beqz	a0,8000519a <sys_exec+0xf2>
    kfree(argv[i]);
    8000518c:	ffffb097          	auipc	ra,0xffffb
    80005190:	e90080e7          	jalr	-368(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005194:	04a1                	addi	s1,s1,8
    80005196:	ff3499e3          	bne	s1,s3,80005188 <sys_exec+0xe0>
  return ret;
    8000519a:	854a                	mv	a0,s2
    8000519c:	a011                	j	800051a0 <sys_exec+0xf8>
  return -1;
    8000519e:	557d                	li	a0,-1
}
    800051a0:	70fa                	ld	ra,440(sp)
    800051a2:	745a                	ld	s0,432(sp)
    800051a4:	74ba                	ld	s1,424(sp)
    800051a6:	791a                	ld	s2,416(sp)
    800051a8:	69fa                	ld	s3,408(sp)
    800051aa:	6a5a                	ld	s4,400(sp)
    800051ac:	6139                	addi	sp,sp,448
    800051ae:	8082                	ret

00000000800051b0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051b0:	7139                	addi	sp,sp,-64
    800051b2:	fc06                	sd	ra,56(sp)
    800051b4:	f822                	sd	s0,48(sp)
    800051b6:	f426                	sd	s1,40(sp)
    800051b8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051ba:	ffffc097          	auipc	ra,0xffffc
    800051be:	e1e080e7          	jalr	-482(ra) # 80000fd8 <myproc>
    800051c2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051c4:	fd840593          	addi	a1,s0,-40
    800051c8:	4501                	li	a0,0
    800051ca:	ffffd097          	auipc	ra,0xffffd
    800051ce:	054080e7          	jalr	84(ra) # 8000221e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800051d2:	fc840593          	addi	a1,s0,-56
    800051d6:	fd040513          	addi	a0,s0,-48
    800051da:	fffff097          	auipc	ra,0xfffff
    800051de:	ddc080e7          	jalr	-548(ra) # 80003fb6 <pipealloc>
    return -1;
    800051e2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051e4:	0c054463          	bltz	a0,800052ac <sys_pipe+0xfc>
  fd0 = -1;
    800051e8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051ec:	fd043503          	ld	a0,-48(s0)
    800051f0:	fffff097          	auipc	ra,0xfffff
    800051f4:	524080e7          	jalr	1316(ra) # 80004714 <fdalloc>
    800051f8:	fca42223          	sw	a0,-60(s0)
    800051fc:	08054b63          	bltz	a0,80005292 <sys_pipe+0xe2>
    80005200:	fc843503          	ld	a0,-56(s0)
    80005204:	fffff097          	auipc	ra,0xfffff
    80005208:	510080e7          	jalr	1296(ra) # 80004714 <fdalloc>
    8000520c:	fca42023          	sw	a0,-64(s0)
    80005210:	06054863          	bltz	a0,80005280 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005214:	4691                	li	a3,4
    80005216:	fc440613          	addi	a2,s0,-60
    8000521a:	fd843583          	ld	a1,-40(s0)
    8000521e:	68a8                	ld	a0,80(s1)
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	a78080e7          	jalr	-1416(ra) # 80000c98 <copyout>
    80005228:	02054063          	bltz	a0,80005248 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000522c:	4691                	li	a3,4
    8000522e:	fc040613          	addi	a2,s0,-64
    80005232:	fd843583          	ld	a1,-40(s0)
    80005236:	0591                	addi	a1,a1,4
    80005238:	68a8                	ld	a0,80(s1)
    8000523a:	ffffc097          	auipc	ra,0xffffc
    8000523e:	a5e080e7          	jalr	-1442(ra) # 80000c98 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005242:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005244:	06055463          	bgez	a0,800052ac <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005248:	fc442783          	lw	a5,-60(s0)
    8000524c:	07e9                	addi	a5,a5,26
    8000524e:	078e                	slli	a5,a5,0x3
    80005250:	97a6                	add	a5,a5,s1
    80005252:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005256:	fc042783          	lw	a5,-64(s0)
    8000525a:	07e9                	addi	a5,a5,26
    8000525c:	078e                	slli	a5,a5,0x3
    8000525e:	94be                	add	s1,s1,a5
    80005260:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005264:	fd043503          	ld	a0,-48(s0)
    80005268:	fffff097          	auipc	ra,0xfffff
    8000526c:	a22080e7          	jalr	-1502(ra) # 80003c8a <fileclose>
    fileclose(wf);
    80005270:	fc843503          	ld	a0,-56(s0)
    80005274:	fffff097          	auipc	ra,0xfffff
    80005278:	a16080e7          	jalr	-1514(ra) # 80003c8a <fileclose>
    return -1;
    8000527c:	57fd                	li	a5,-1
    8000527e:	a03d                	j	800052ac <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005280:	fc442783          	lw	a5,-60(s0)
    80005284:	0007c763          	bltz	a5,80005292 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005288:	07e9                	addi	a5,a5,26
    8000528a:	078e                	slli	a5,a5,0x3
    8000528c:	97a6                	add	a5,a5,s1
    8000528e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005292:	fd043503          	ld	a0,-48(s0)
    80005296:	fffff097          	auipc	ra,0xfffff
    8000529a:	9f4080e7          	jalr	-1548(ra) # 80003c8a <fileclose>
    fileclose(wf);
    8000529e:	fc843503          	ld	a0,-56(s0)
    800052a2:	fffff097          	auipc	ra,0xfffff
    800052a6:	9e8080e7          	jalr	-1560(ra) # 80003c8a <fileclose>
    return -1;
    800052aa:	57fd                	li	a5,-1
}
    800052ac:	853e                	mv	a0,a5
    800052ae:	70e2                	ld	ra,56(sp)
    800052b0:	7442                	ld	s0,48(sp)
    800052b2:	74a2                	ld	s1,40(sp)
    800052b4:	6121                	addi	sp,sp,64
    800052b6:	8082                	ret
	...

00000000800052c0 <kernelvec>:
    800052c0:	7111                	addi	sp,sp,-256
    800052c2:	e006                	sd	ra,0(sp)
    800052c4:	e40a                	sd	sp,8(sp)
    800052c6:	e80e                	sd	gp,16(sp)
    800052c8:	ec12                	sd	tp,24(sp)
    800052ca:	f016                	sd	t0,32(sp)
    800052cc:	f41a                	sd	t1,40(sp)
    800052ce:	f81e                	sd	t2,48(sp)
    800052d0:	fc22                	sd	s0,56(sp)
    800052d2:	e0a6                	sd	s1,64(sp)
    800052d4:	e4aa                	sd	a0,72(sp)
    800052d6:	e8ae                	sd	a1,80(sp)
    800052d8:	ecb2                	sd	a2,88(sp)
    800052da:	f0b6                	sd	a3,96(sp)
    800052dc:	f4ba                	sd	a4,104(sp)
    800052de:	f8be                	sd	a5,112(sp)
    800052e0:	fcc2                	sd	a6,120(sp)
    800052e2:	e146                	sd	a7,128(sp)
    800052e4:	e54a                	sd	s2,136(sp)
    800052e6:	e94e                	sd	s3,144(sp)
    800052e8:	ed52                	sd	s4,152(sp)
    800052ea:	f156                	sd	s5,160(sp)
    800052ec:	f55a                	sd	s6,168(sp)
    800052ee:	f95e                	sd	s7,176(sp)
    800052f0:	fd62                	sd	s8,184(sp)
    800052f2:	e1e6                	sd	s9,192(sp)
    800052f4:	e5ea                	sd	s10,200(sp)
    800052f6:	e9ee                	sd	s11,208(sp)
    800052f8:	edf2                	sd	t3,216(sp)
    800052fa:	f1f6                	sd	t4,224(sp)
    800052fc:	f5fa                	sd	t5,232(sp)
    800052fe:	f9fe                	sd	t6,240(sp)
    80005300:	d2dfc0ef          	jal	ra,8000202c <kerneltrap>
    80005304:	6082                	ld	ra,0(sp)
    80005306:	6122                	ld	sp,8(sp)
    80005308:	61c2                	ld	gp,16(sp)
    8000530a:	7282                	ld	t0,32(sp)
    8000530c:	7322                	ld	t1,40(sp)
    8000530e:	73c2                	ld	t2,48(sp)
    80005310:	7462                	ld	s0,56(sp)
    80005312:	6486                	ld	s1,64(sp)
    80005314:	6526                	ld	a0,72(sp)
    80005316:	65c6                	ld	a1,80(sp)
    80005318:	6666                	ld	a2,88(sp)
    8000531a:	7686                	ld	a3,96(sp)
    8000531c:	7726                	ld	a4,104(sp)
    8000531e:	77c6                	ld	a5,112(sp)
    80005320:	7866                	ld	a6,120(sp)
    80005322:	688a                	ld	a7,128(sp)
    80005324:	692a                	ld	s2,136(sp)
    80005326:	69ca                	ld	s3,144(sp)
    80005328:	6a6a                	ld	s4,152(sp)
    8000532a:	7a8a                	ld	s5,160(sp)
    8000532c:	7b2a                	ld	s6,168(sp)
    8000532e:	7bca                	ld	s7,176(sp)
    80005330:	7c6a                	ld	s8,184(sp)
    80005332:	6c8e                	ld	s9,192(sp)
    80005334:	6d2e                	ld	s10,200(sp)
    80005336:	6dce                	ld	s11,208(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	addi	sp,sp,256
    80005342:	10200073          	sret
    80005346:	00000013          	nop
    8000534a:	00000013          	nop
    8000534e:	0001                	nop

0000000080005350 <timervec>:
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	e10c                	sd	a1,0(a0)
    80005356:	e510                	sd	a2,8(a0)
    80005358:	e914                	sd	a3,16(a0)
    8000535a:	6d0c                	ld	a1,24(a0)
    8000535c:	7110                	ld	a2,32(a0)
    8000535e:	6194                	ld	a3,0(a1)
    80005360:	96b2                	add	a3,a3,a2
    80005362:	e194                	sd	a3,0(a1)
    80005364:	4589                	li	a1,2
    80005366:	14459073          	csrw	sip,a1
    8000536a:	6914                	ld	a3,16(a0)
    8000536c:	6510                	ld	a2,8(a0)
    8000536e:	610c                	ld	a1,0(a0)
    80005370:	34051573          	csrrw	a0,mscratch,a0
    80005374:	30200073          	mret
	...

000000008000537a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000537a:	1141                	addi	sp,sp,-16
    8000537c:	e422                	sd	s0,8(sp)
    8000537e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005380:	0c0007b7          	lui	a5,0xc000
    80005384:	4705                	li	a4,1
    80005386:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005388:	c3d8                	sw	a4,4(a5)
}
    8000538a:	6422                	ld	s0,8(sp)
    8000538c:	0141                	addi	sp,sp,16
    8000538e:	8082                	ret

0000000080005390 <plicinithart>:

void
plicinithart(void)
{
    80005390:	1141                	addi	sp,sp,-16
    80005392:	e406                	sd	ra,8(sp)
    80005394:	e022                	sd	s0,0(sp)
    80005396:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	c14080e7          	jalr	-1004(ra) # 80000fac <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053a0:	0085171b          	slliw	a4,a0,0x8
    800053a4:	0c0027b7          	lui	a5,0xc002
    800053a8:	97ba                	add	a5,a5,a4
    800053aa:	40200713          	li	a4,1026
    800053ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053b2:	00d5151b          	slliw	a0,a0,0xd
    800053b6:	0c2017b7          	lui	a5,0xc201
    800053ba:	97aa                	add	a5,a5,a0
    800053bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053c0:	60a2                	ld	ra,8(sp)
    800053c2:	6402                	ld	s0,0(sp)
    800053c4:	0141                	addi	sp,sp,16
    800053c6:	8082                	ret

00000000800053c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053c8:	1141                	addi	sp,sp,-16
    800053ca:	e406                	sd	ra,8(sp)
    800053cc:	e022                	sd	s0,0(sp)
    800053ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	bdc080e7          	jalr	-1060(ra) # 80000fac <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053d8:	00d5151b          	slliw	a0,a0,0xd
    800053dc:	0c2017b7          	lui	a5,0xc201
    800053e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053e2:	43c8                	lw	a0,4(a5)
    800053e4:	60a2                	ld	ra,8(sp)
    800053e6:	6402                	ld	s0,0(sp)
    800053e8:	0141                	addi	sp,sp,16
    800053ea:	8082                	ret

00000000800053ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053ec:	1101                	addi	sp,sp,-32
    800053ee:	ec06                	sd	ra,24(sp)
    800053f0:	e822                	sd	s0,16(sp)
    800053f2:	e426                	sd	s1,8(sp)
    800053f4:	1000                	addi	s0,sp,32
    800053f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	bb4080e7          	jalr	-1100(ra) # 80000fac <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005400:	00d5151b          	slliw	a0,a0,0xd
    80005404:	0c2017b7          	lui	a5,0xc201
    80005408:	97aa                	add	a5,a5,a0
    8000540a:	c3c4                	sw	s1,4(a5)
}
    8000540c:	60e2                	ld	ra,24(sp)
    8000540e:	6442                	ld	s0,16(sp)
    80005410:	64a2                	ld	s1,8(sp)
    80005412:	6105                	addi	sp,sp,32
    80005414:	8082                	ret

0000000080005416 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005416:	1141                	addi	sp,sp,-16
    80005418:	e406                	sd	ra,8(sp)
    8000541a:	e022                	sd	s0,0(sp)
    8000541c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000541e:	479d                	li	a5,7
    80005420:	04a7cc63          	blt	a5,a0,80005478 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005424:	00015797          	auipc	a5,0x15
    80005428:	23c78793          	addi	a5,a5,572 # 8001a660 <disk>
    8000542c:	97aa                	add	a5,a5,a0
    8000542e:	0187c783          	lbu	a5,24(a5)
    80005432:	ebb9                	bnez	a5,80005488 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005434:	00451693          	slli	a3,a0,0x4
    80005438:	00015797          	auipc	a5,0x15
    8000543c:	22878793          	addi	a5,a5,552 # 8001a660 <disk>
    80005440:	6398                	ld	a4,0(a5)
    80005442:	9736                	add	a4,a4,a3
    80005444:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005448:	6398                	ld	a4,0(a5)
    8000544a:	9736                	add	a4,a4,a3
    8000544c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005450:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005454:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005458:	97aa                	add	a5,a5,a0
    8000545a:	4705                	li	a4,1
    8000545c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005460:	00015517          	auipc	a0,0x15
    80005464:	21850513          	addi	a0,a0,536 # 8001a678 <disk+0x18>
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	340080e7          	jalr	832(ra) # 800017a8 <wakeup>
}
    80005470:	60a2                	ld	ra,8(sp)
    80005472:	6402                	ld	s0,0(sp)
    80005474:	0141                	addi	sp,sp,16
    80005476:	8082                	ret
    panic("free_desc 1");
    80005478:	00003517          	auipc	a0,0x3
    8000547c:	4b850513          	addi	a0,a0,1208 # 80008930 <syscall_names+0x2f0>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	aac080e7          	jalr	-1364(ra) # 80005f2c <panic>
    panic("free_desc 2");
    80005488:	00003517          	auipc	a0,0x3
    8000548c:	4b850513          	addi	a0,a0,1208 # 80008940 <syscall_names+0x300>
    80005490:	00001097          	auipc	ra,0x1
    80005494:	a9c080e7          	jalr	-1380(ra) # 80005f2c <panic>

0000000080005498 <virtio_disk_init>:
{
    80005498:	1101                	addi	sp,sp,-32
    8000549a:	ec06                	sd	ra,24(sp)
    8000549c:	e822                	sd	s0,16(sp)
    8000549e:	e426                	sd	s1,8(sp)
    800054a0:	e04a                	sd	s2,0(sp)
    800054a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054a4:	00003597          	auipc	a1,0x3
    800054a8:	4ac58593          	addi	a1,a1,1196 # 80008950 <syscall_names+0x310>
    800054ac:	00015517          	auipc	a0,0x15
    800054b0:	2dc50513          	addi	a0,a0,732 # 8001a788 <disk+0x128>
    800054b4:	00001097          	auipc	ra,0x1
    800054b8:	ef6080e7          	jalr	-266(ra) # 800063aa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054bc:	100017b7          	lui	a5,0x10001
    800054c0:	4398                	lw	a4,0(a5)
    800054c2:	2701                	sext.w	a4,a4
    800054c4:	747277b7          	lui	a5,0x74727
    800054c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054cc:	14f71b63          	bne	a4,a5,80005622 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054d0:	100017b7          	lui	a5,0x10001
    800054d4:	43dc                	lw	a5,4(a5)
    800054d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d8:	4709                	li	a4,2
    800054da:	14e79463          	bne	a5,a4,80005622 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054de:	100017b7          	lui	a5,0x10001
    800054e2:	479c                	lw	a5,8(a5)
    800054e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054e6:	12e79e63          	bne	a5,a4,80005622 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054ea:	100017b7          	lui	a5,0x10001
    800054ee:	47d8                	lw	a4,12(a5)
    800054f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f2:	554d47b7          	lui	a5,0x554d4
    800054f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054fa:	12f71463          	bne	a4,a5,80005622 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fe:	100017b7          	lui	a5,0x10001
    80005502:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005506:	4705                	li	a4,1
    80005508:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000550a:	470d                	li	a4,3
    8000550c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000550e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005510:	c7ffe6b7          	lui	a3,0xc7ffe
    80005514:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbd7f>
    80005518:	8f75                	and	a4,a4,a3
    8000551a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551c:	472d                	li	a4,11
    8000551e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005520:	5bbc                	lw	a5,112(a5)
    80005522:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005526:	8ba1                	andi	a5,a5,8
    80005528:	10078563          	beqz	a5,80005632 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000552c:	100017b7          	lui	a5,0x10001
    80005530:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005534:	43fc                	lw	a5,68(a5)
    80005536:	2781                	sext.w	a5,a5
    80005538:	10079563          	bnez	a5,80005642 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000553c:	100017b7          	lui	a5,0x10001
    80005540:	5bdc                	lw	a5,52(a5)
    80005542:	2781                	sext.w	a5,a5
  if(max == 0)
    80005544:	10078763          	beqz	a5,80005652 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005548:	471d                	li	a4,7
    8000554a:	10f77c63          	bgeu	a4,a5,80005662 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000554e:	ffffb097          	auipc	ra,0xffffb
    80005552:	bcc080e7          	jalr	-1076(ra) # 8000011a <kalloc>
    80005556:	00015497          	auipc	s1,0x15
    8000555a:	10a48493          	addi	s1,s1,266 # 8001a660 <disk>
    8000555e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005560:	ffffb097          	auipc	ra,0xffffb
    80005564:	bba080e7          	jalr	-1094(ra) # 8000011a <kalloc>
    80005568:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000556a:	ffffb097          	auipc	ra,0xffffb
    8000556e:	bb0080e7          	jalr	-1104(ra) # 8000011a <kalloc>
    80005572:	87aa                	mv	a5,a0
    80005574:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005576:	6088                	ld	a0,0(s1)
    80005578:	cd6d                	beqz	a0,80005672 <virtio_disk_init+0x1da>
    8000557a:	00015717          	auipc	a4,0x15
    8000557e:	0ee73703          	ld	a4,238(a4) # 8001a668 <disk+0x8>
    80005582:	cb65                	beqz	a4,80005672 <virtio_disk_init+0x1da>
    80005584:	c7fd                	beqz	a5,80005672 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005586:	6605                	lui	a2,0x1
    80005588:	4581                	li	a1,0
    8000558a:	ffffb097          	auipc	ra,0xffffb
    8000558e:	bf0080e7          	jalr	-1040(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005592:	00015497          	auipc	s1,0x15
    80005596:	0ce48493          	addi	s1,s1,206 # 8001a660 <disk>
    8000559a:	6605                	lui	a2,0x1
    8000559c:	4581                	li	a1,0
    8000559e:	6488                	ld	a0,8(s1)
    800055a0:	ffffb097          	auipc	ra,0xffffb
    800055a4:	bda080e7          	jalr	-1062(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800055a8:	6605                	lui	a2,0x1
    800055aa:	4581                	li	a1,0
    800055ac:	6888                	ld	a0,16(s1)
    800055ae:	ffffb097          	auipc	ra,0xffffb
    800055b2:	bcc080e7          	jalr	-1076(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	4721                	li	a4,8
    800055bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055be:	4098                	lw	a4,0(s1)
    800055c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055c4:	40d8                	lw	a4,4(s1)
    800055c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055ca:	6498                	ld	a4,8(s1)
    800055cc:	0007069b          	sext.w	a3,a4
    800055d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055d4:	9701                	srai	a4,a4,0x20
    800055d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055da:	6898                	ld	a4,16(s1)
    800055dc:	0007069b          	sext.w	a3,a4
    800055e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055e4:	9701                	srai	a4,a4,0x20
    800055e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055ea:	4705                	li	a4,1
    800055ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055ee:	00e48c23          	sb	a4,24(s1)
    800055f2:	00e48ca3          	sb	a4,25(s1)
    800055f6:	00e48d23          	sb	a4,26(s1)
    800055fa:	00e48da3          	sb	a4,27(s1)
    800055fe:	00e48e23          	sb	a4,28(s1)
    80005602:	00e48ea3          	sb	a4,29(s1)
    80005606:	00e48f23          	sb	a4,30(s1)
    8000560a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000560e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005612:	0727a823          	sw	s2,112(a5)
}
    80005616:	60e2                	ld	ra,24(sp)
    80005618:	6442                	ld	s0,16(sp)
    8000561a:	64a2                	ld	s1,8(sp)
    8000561c:	6902                	ld	s2,0(sp)
    8000561e:	6105                	addi	sp,sp,32
    80005620:	8082                	ret
    panic("could not find virtio disk");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	33e50513          	addi	a0,a0,830 # 80008960 <syscall_names+0x320>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	902080e7          	jalr	-1790(ra) # 80005f2c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	34e50513          	addi	a0,a0,846 # 80008980 <syscall_names+0x340>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	8f2080e7          	jalr	-1806(ra) # 80005f2c <panic>
    panic("virtio disk should not be ready");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	35e50513          	addi	a0,a0,862 # 800089a0 <syscall_names+0x360>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	8e2080e7          	jalr	-1822(ra) # 80005f2c <panic>
    panic("virtio disk has no queue 0");
    80005652:	00003517          	auipc	a0,0x3
    80005656:	36e50513          	addi	a0,a0,878 # 800089c0 <syscall_names+0x380>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	8d2080e7          	jalr	-1838(ra) # 80005f2c <panic>
    panic("virtio disk max queue too short");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	37e50513          	addi	a0,a0,894 # 800089e0 <syscall_names+0x3a0>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	8c2080e7          	jalr	-1854(ra) # 80005f2c <panic>
    panic("virtio disk kalloc");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	38e50513          	addi	a0,a0,910 # 80008a00 <syscall_names+0x3c0>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	8b2080e7          	jalr	-1870(ra) # 80005f2c <panic>

0000000080005682 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005682:	7159                	addi	sp,sp,-112
    80005684:	f486                	sd	ra,104(sp)
    80005686:	f0a2                	sd	s0,96(sp)
    80005688:	eca6                	sd	s1,88(sp)
    8000568a:	e8ca                	sd	s2,80(sp)
    8000568c:	e4ce                	sd	s3,72(sp)
    8000568e:	e0d2                	sd	s4,64(sp)
    80005690:	fc56                	sd	s5,56(sp)
    80005692:	f85a                	sd	s6,48(sp)
    80005694:	f45e                	sd	s7,40(sp)
    80005696:	f062                	sd	s8,32(sp)
    80005698:	ec66                	sd	s9,24(sp)
    8000569a:	e86a                	sd	s10,16(sp)
    8000569c:	1880                	addi	s0,sp,112
    8000569e:	8a2a                	mv	s4,a0
    800056a0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056a2:	00c52c83          	lw	s9,12(a0)
    800056a6:	001c9c9b          	slliw	s9,s9,0x1
    800056aa:	1c82                	slli	s9,s9,0x20
    800056ac:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056b0:	00015517          	auipc	a0,0x15
    800056b4:	0d850513          	addi	a0,a0,216 # 8001a788 <disk+0x128>
    800056b8:	00001097          	auipc	ra,0x1
    800056bc:	d82080e7          	jalr	-638(ra) # 8000643a <acquire>
  for(int i = 0; i < 3; i++){
    800056c0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800056c2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056c4:	00015b17          	auipc	s6,0x15
    800056c8:	f9cb0b13          	addi	s6,s6,-100 # 8001a660 <disk>
  for(int i = 0; i < 3; i++){
    800056cc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056ce:	00015c17          	auipc	s8,0x15
    800056d2:	0bac0c13          	addi	s8,s8,186 # 8001a788 <disk+0x128>
    800056d6:	a095                	j	8000573a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800056d8:	00fb0733          	add	a4,s6,a5
    800056dc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056e0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800056e2:	0207c563          	bltz	a5,8000570c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800056e6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800056e8:	0591                	addi	a1,a1,4
    800056ea:	05560d63          	beq	a2,s5,80005744 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800056ee:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800056f0:	00015717          	auipc	a4,0x15
    800056f4:	f7070713          	addi	a4,a4,-144 # 8001a660 <disk>
    800056f8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800056fa:	01874683          	lbu	a3,24(a4)
    800056fe:	fee9                	bnez	a3,800056d8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005700:	2785                	addiw	a5,a5,1
    80005702:	0705                	addi	a4,a4,1
    80005704:	fe979be3          	bne	a5,s1,800056fa <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005708:	57fd                	li	a5,-1
    8000570a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000570c:	00c05e63          	blez	a2,80005728 <virtio_disk_rw+0xa6>
    80005710:	060a                	slli	a2,a2,0x2
    80005712:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005716:	0009a503          	lw	a0,0(s3)
    8000571a:	00000097          	auipc	ra,0x0
    8000571e:	cfc080e7          	jalr	-772(ra) # 80005416 <free_desc>
      for(int j = 0; j < i; j++)
    80005722:	0991                	addi	s3,s3,4
    80005724:	ffa999e3          	bne	s3,s10,80005716 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005728:	85e2                	mv	a1,s8
    8000572a:	00015517          	auipc	a0,0x15
    8000572e:	f4e50513          	addi	a0,a0,-178 # 8001a678 <disk+0x18>
    80005732:	ffffc097          	auipc	ra,0xffffc
    80005736:	012080e7          	jalr	18(ra) # 80001744 <sleep>
  for(int i = 0; i < 3; i++){
    8000573a:	f9040993          	addi	s3,s0,-112
{
    8000573e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005740:	864a                	mv	a2,s2
    80005742:	b775                	j	800056ee <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005744:	f9042503          	lw	a0,-112(s0)
    80005748:	00a50713          	addi	a4,a0,10
    8000574c:	0712                	slli	a4,a4,0x4

  if(write)
    8000574e:	00015797          	auipc	a5,0x15
    80005752:	f1278793          	addi	a5,a5,-238 # 8001a660 <disk>
    80005756:	00e786b3          	add	a3,a5,a4
    8000575a:	01703633          	snez	a2,s7
    8000575e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005760:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005764:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005768:	f6070613          	addi	a2,a4,-160
    8000576c:	6394                	ld	a3,0(a5)
    8000576e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005770:	00870593          	addi	a1,a4,8
    80005774:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005776:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005778:	0007b803          	ld	a6,0(a5)
    8000577c:	9642                	add	a2,a2,a6
    8000577e:	46c1                	li	a3,16
    80005780:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005782:	4585                	li	a1,1
    80005784:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005788:	f9442683          	lw	a3,-108(s0)
    8000578c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005790:	0692                	slli	a3,a3,0x4
    80005792:	9836                	add	a6,a6,a3
    80005794:	058a0613          	addi	a2,s4,88
    80005798:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000579c:	0007b803          	ld	a6,0(a5)
    800057a0:	96c2                	add	a3,a3,a6
    800057a2:	40000613          	li	a2,1024
    800057a6:	c690                	sw	a2,8(a3)
  if(write)
    800057a8:	001bb613          	seqz	a2,s7
    800057ac:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057b0:	00166613          	ori	a2,a2,1
    800057b4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800057b8:	f9842603          	lw	a2,-104(s0)
    800057bc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057c0:	00250693          	addi	a3,a0,2
    800057c4:	0692                	slli	a3,a3,0x4
    800057c6:	96be                	add	a3,a3,a5
    800057c8:	58fd                	li	a7,-1
    800057ca:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057ce:	0612                	slli	a2,a2,0x4
    800057d0:	9832                	add	a6,a6,a2
    800057d2:	f9070713          	addi	a4,a4,-112
    800057d6:	973e                	add	a4,a4,a5
    800057d8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800057dc:	6398                	ld	a4,0(a5)
    800057de:	9732                	add	a4,a4,a2
    800057e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057e2:	4609                	li	a2,2
    800057e4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800057e8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057ec:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800057f0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057f4:	6794                	ld	a3,8(a5)
    800057f6:	0026d703          	lhu	a4,2(a3)
    800057fa:	8b1d                	andi	a4,a4,7
    800057fc:	0706                	slli	a4,a4,0x1
    800057fe:	96ba                	add	a3,a3,a4
    80005800:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005804:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005808:	6798                	ld	a4,8(a5)
    8000580a:	00275783          	lhu	a5,2(a4)
    8000580e:	2785                	addiw	a5,a5,1
    80005810:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005814:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005818:	100017b7          	lui	a5,0x10001
    8000581c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005820:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005824:	00015917          	auipc	s2,0x15
    80005828:	f6490913          	addi	s2,s2,-156 # 8001a788 <disk+0x128>
  while(b->disk == 1) {
    8000582c:	4485                	li	s1,1
    8000582e:	00b79c63          	bne	a5,a1,80005846 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005832:	85ca                	mv	a1,s2
    80005834:	8552                	mv	a0,s4
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	f0e080e7          	jalr	-242(ra) # 80001744 <sleep>
  while(b->disk == 1) {
    8000583e:	004a2783          	lw	a5,4(s4)
    80005842:	fe9788e3          	beq	a5,s1,80005832 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005846:	f9042903          	lw	s2,-112(s0)
    8000584a:	00290713          	addi	a4,s2,2
    8000584e:	0712                	slli	a4,a4,0x4
    80005850:	00015797          	auipc	a5,0x15
    80005854:	e1078793          	addi	a5,a5,-496 # 8001a660 <disk>
    80005858:	97ba                	add	a5,a5,a4
    8000585a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000585e:	00015997          	auipc	s3,0x15
    80005862:	e0298993          	addi	s3,s3,-510 # 8001a660 <disk>
    80005866:	00491713          	slli	a4,s2,0x4
    8000586a:	0009b783          	ld	a5,0(s3)
    8000586e:	97ba                	add	a5,a5,a4
    80005870:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005874:	854a                	mv	a0,s2
    80005876:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	b9c080e7          	jalr	-1124(ra) # 80005416 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005882:	8885                	andi	s1,s1,1
    80005884:	f0ed                	bnez	s1,80005866 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005886:	00015517          	auipc	a0,0x15
    8000588a:	f0250513          	addi	a0,a0,-254 # 8001a788 <disk+0x128>
    8000588e:	00001097          	auipc	ra,0x1
    80005892:	c60080e7          	jalr	-928(ra) # 800064ee <release>
}
    80005896:	70a6                	ld	ra,104(sp)
    80005898:	7406                	ld	s0,96(sp)
    8000589a:	64e6                	ld	s1,88(sp)
    8000589c:	6946                	ld	s2,80(sp)
    8000589e:	69a6                	ld	s3,72(sp)
    800058a0:	6a06                	ld	s4,64(sp)
    800058a2:	7ae2                	ld	s5,56(sp)
    800058a4:	7b42                	ld	s6,48(sp)
    800058a6:	7ba2                	ld	s7,40(sp)
    800058a8:	7c02                	ld	s8,32(sp)
    800058aa:	6ce2                	ld	s9,24(sp)
    800058ac:	6d42                	ld	s10,16(sp)
    800058ae:	6165                	addi	sp,sp,112
    800058b0:	8082                	ret

00000000800058b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058b2:	1101                	addi	sp,sp,-32
    800058b4:	ec06                	sd	ra,24(sp)
    800058b6:	e822                	sd	s0,16(sp)
    800058b8:	e426                	sd	s1,8(sp)
    800058ba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058bc:	00015497          	auipc	s1,0x15
    800058c0:	da448493          	addi	s1,s1,-604 # 8001a660 <disk>
    800058c4:	00015517          	auipc	a0,0x15
    800058c8:	ec450513          	addi	a0,a0,-316 # 8001a788 <disk+0x128>
    800058cc:	00001097          	auipc	ra,0x1
    800058d0:	b6e080e7          	jalr	-1170(ra) # 8000643a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058d4:	10001737          	lui	a4,0x10001
    800058d8:	533c                	lw	a5,96(a4)
    800058da:	8b8d                	andi	a5,a5,3
    800058dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058e2:	689c                	ld	a5,16(s1)
    800058e4:	0204d703          	lhu	a4,32(s1)
    800058e8:	0027d783          	lhu	a5,2(a5)
    800058ec:	04f70863          	beq	a4,a5,8000593c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058f0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f4:	6898                	ld	a4,16(s1)
    800058f6:	0204d783          	lhu	a5,32(s1)
    800058fa:	8b9d                	andi	a5,a5,7
    800058fc:	078e                	slli	a5,a5,0x3
    800058fe:	97ba                	add	a5,a5,a4
    80005900:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005902:	00278713          	addi	a4,a5,2
    80005906:	0712                	slli	a4,a4,0x4
    80005908:	9726                	add	a4,a4,s1
    8000590a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000590e:	e721                	bnez	a4,80005956 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005910:	0789                	addi	a5,a5,2
    80005912:	0792                	slli	a5,a5,0x4
    80005914:	97a6                	add	a5,a5,s1
    80005916:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005918:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000591c:	ffffc097          	auipc	ra,0xffffc
    80005920:	e8c080e7          	jalr	-372(ra) # 800017a8 <wakeup>

    disk.used_idx += 1;
    80005924:	0204d783          	lhu	a5,32(s1)
    80005928:	2785                	addiw	a5,a5,1
    8000592a:	17c2                	slli	a5,a5,0x30
    8000592c:	93c1                	srli	a5,a5,0x30
    8000592e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005932:	6898                	ld	a4,16(s1)
    80005934:	00275703          	lhu	a4,2(a4)
    80005938:	faf71ce3          	bne	a4,a5,800058f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000593c:	00015517          	auipc	a0,0x15
    80005940:	e4c50513          	addi	a0,a0,-436 # 8001a788 <disk+0x128>
    80005944:	00001097          	auipc	ra,0x1
    80005948:	baa080e7          	jalr	-1110(ra) # 800064ee <release>
}
    8000594c:	60e2                	ld	ra,24(sp)
    8000594e:	6442                	ld	s0,16(sp)
    80005950:	64a2                	ld	s1,8(sp)
    80005952:	6105                	addi	sp,sp,32
    80005954:	8082                	ret
      panic("virtio_disk_intr status");
    80005956:	00003517          	auipc	a0,0x3
    8000595a:	0c250513          	addi	a0,a0,194 # 80008a18 <syscall_names+0x3d8>
    8000595e:	00000097          	auipc	ra,0x0
    80005962:	5ce080e7          	jalr	1486(ra) # 80005f2c <panic>

0000000080005966 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005966:	1141                	addi	sp,sp,-16
    80005968:	e422                	sd	s0,8(sp)
    8000596a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000596c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005970:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005974:	0037979b          	slliw	a5,a5,0x3
    80005978:	02004737          	lui	a4,0x2004
    8000597c:	97ba                	add	a5,a5,a4
    8000597e:	0200c737          	lui	a4,0x200c
    80005982:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005986:	000f4637          	lui	a2,0xf4
    8000598a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000598e:	9732                	add	a4,a4,a2
    80005990:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005992:	00259693          	slli	a3,a1,0x2
    80005996:	96ae                	add	a3,a3,a1
    80005998:	068e                	slli	a3,a3,0x3
    8000599a:	00015717          	auipc	a4,0x15
    8000599e:	e0670713          	addi	a4,a4,-506 # 8001a7a0 <timer_scratch>
    800059a2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059a4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059a6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059a8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059ac:	00000797          	auipc	a5,0x0
    800059b0:	9a478793          	addi	a5,a5,-1628 # 80005350 <timervec>
    800059b4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059b8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059bc:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059c0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059c4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059c8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059cc:	30479073          	csrw	mie,a5
}
    800059d0:	6422                	ld	s0,8(sp)
    800059d2:	0141                	addi	sp,sp,16
    800059d4:	8082                	ret

00000000800059d6 <start>:
{
    800059d6:	1141                	addi	sp,sp,-16
    800059d8:	e406                	sd	ra,8(sp)
    800059da:	e022                	sd	s0,0(sp)
    800059dc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059de:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059e2:	7779                	lui	a4,0xffffe
    800059e4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbe1f>
    800059e8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059ea:	6705                	lui	a4,0x1
    800059ec:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059f2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059f6:	ffffb797          	auipc	a5,0xffffb
    800059fa:	92878793          	addi	a5,a5,-1752 # 8000031e <main>
    800059fe:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a02:	4781                	li	a5,0
    80005a04:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a08:	67c1                	lui	a5,0x10
    80005a0a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a0c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a10:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a14:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a18:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a1c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a20:	57fd                	li	a5,-1
    80005a22:	83a9                	srli	a5,a5,0xa
    80005a24:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a28:	47bd                	li	a5,15
    80005a2a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a2e:	00000097          	auipc	ra,0x0
    80005a32:	f38080e7          	jalr	-200(ra) # 80005966 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a36:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a3a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a3c:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a3e:	30200073          	mret
}
    80005a42:	60a2                	ld	ra,8(sp)
    80005a44:	6402                	ld	s0,0(sp)
    80005a46:	0141                	addi	sp,sp,16
    80005a48:	8082                	ret

0000000080005a4a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a4a:	715d                	addi	sp,sp,-80
    80005a4c:	e486                	sd	ra,72(sp)
    80005a4e:	e0a2                	sd	s0,64(sp)
    80005a50:	fc26                	sd	s1,56(sp)
    80005a52:	f84a                	sd	s2,48(sp)
    80005a54:	f44e                	sd	s3,40(sp)
    80005a56:	f052                	sd	s4,32(sp)
    80005a58:	ec56                	sd	s5,24(sp)
    80005a5a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a5c:	04c05763          	blez	a2,80005aaa <consolewrite+0x60>
    80005a60:	8a2a                	mv	s4,a0
    80005a62:	84ae                	mv	s1,a1
    80005a64:	89b2                	mv	s3,a2
    80005a66:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a68:	5afd                	li	s5,-1
    80005a6a:	4685                	li	a3,1
    80005a6c:	8626                	mv	a2,s1
    80005a6e:	85d2                	mv	a1,s4
    80005a70:	fbf40513          	addi	a0,s0,-65
    80005a74:	ffffc097          	auipc	ra,0xffffc
    80005a78:	12e080e7          	jalr	302(ra) # 80001ba2 <either_copyin>
    80005a7c:	01550d63          	beq	a0,s5,80005a96 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005a80:	fbf44503          	lbu	a0,-65(s0)
    80005a84:	00000097          	auipc	ra,0x0
    80005a88:	7fc080e7          	jalr	2044(ra) # 80006280 <uartputc>
  for(i = 0; i < n; i++){
    80005a8c:	2905                	addiw	s2,s2,1
    80005a8e:	0485                	addi	s1,s1,1
    80005a90:	fd299de3          	bne	s3,s2,80005a6a <consolewrite+0x20>
    80005a94:	894e                	mv	s2,s3
  }

  return i;
}
    80005a96:	854a                	mv	a0,s2
    80005a98:	60a6                	ld	ra,72(sp)
    80005a9a:	6406                	ld	s0,64(sp)
    80005a9c:	74e2                	ld	s1,56(sp)
    80005a9e:	7942                	ld	s2,48(sp)
    80005aa0:	79a2                	ld	s3,40(sp)
    80005aa2:	7a02                	ld	s4,32(sp)
    80005aa4:	6ae2                	ld	s5,24(sp)
    80005aa6:	6161                	addi	sp,sp,80
    80005aa8:	8082                	ret
  for(i = 0; i < n; i++){
    80005aaa:	4901                	li	s2,0
    80005aac:	b7ed                	j	80005a96 <consolewrite+0x4c>

0000000080005aae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aae:	711d                	addi	sp,sp,-96
    80005ab0:	ec86                	sd	ra,88(sp)
    80005ab2:	e8a2                	sd	s0,80(sp)
    80005ab4:	e4a6                	sd	s1,72(sp)
    80005ab6:	e0ca                	sd	s2,64(sp)
    80005ab8:	fc4e                	sd	s3,56(sp)
    80005aba:	f852                	sd	s4,48(sp)
    80005abc:	f456                	sd	s5,40(sp)
    80005abe:	f05a                	sd	s6,32(sp)
    80005ac0:	ec5e                	sd	s7,24(sp)
    80005ac2:	1080                	addi	s0,sp,96
    80005ac4:	8aaa                	mv	s5,a0
    80005ac6:	8a2e                	mv	s4,a1
    80005ac8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005ace:	0001d517          	auipc	a0,0x1d
    80005ad2:	e1250513          	addi	a0,a0,-494 # 800228e0 <cons>
    80005ad6:	00001097          	auipc	ra,0x1
    80005ada:	964080e7          	jalr	-1692(ra) # 8000643a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ade:	0001d497          	auipc	s1,0x1d
    80005ae2:	e0248493          	addi	s1,s1,-510 # 800228e0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ae6:	0001d917          	auipc	s2,0x1d
    80005aea:	e9290913          	addi	s2,s2,-366 # 80022978 <cons+0x98>
  while(n > 0){
    80005aee:	09305263          	blez	s3,80005b72 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005af2:	0984a783          	lw	a5,152(s1)
    80005af6:	09c4a703          	lw	a4,156(s1)
    80005afa:	02f71763          	bne	a4,a5,80005b28 <consoleread+0x7a>
      if(killed(myproc())){
    80005afe:	ffffb097          	auipc	ra,0xffffb
    80005b02:	4da080e7          	jalr	1242(ra) # 80000fd8 <myproc>
    80005b06:	ffffc097          	auipc	ra,0xffffc
    80005b0a:	ee6080e7          	jalr	-282(ra) # 800019ec <killed>
    80005b0e:	ed2d                	bnez	a0,80005b88 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005b10:	85a6                	mv	a1,s1
    80005b12:	854a                	mv	a0,s2
    80005b14:	ffffc097          	auipc	ra,0xffffc
    80005b18:	c30080e7          	jalr	-976(ra) # 80001744 <sleep>
    while(cons.r == cons.w){
    80005b1c:	0984a783          	lw	a5,152(s1)
    80005b20:	09c4a703          	lw	a4,156(s1)
    80005b24:	fcf70de3          	beq	a4,a5,80005afe <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b28:	0001d717          	auipc	a4,0x1d
    80005b2c:	db870713          	addi	a4,a4,-584 # 800228e0 <cons>
    80005b30:	0017869b          	addiw	a3,a5,1
    80005b34:	08d72c23          	sw	a3,152(a4)
    80005b38:	07f7f693          	andi	a3,a5,127
    80005b3c:	9736                	add	a4,a4,a3
    80005b3e:	01874703          	lbu	a4,24(a4)
    80005b42:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b46:	4691                	li	a3,4
    80005b48:	06db8463          	beq	s7,a3,80005bb0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b4c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b50:	4685                	li	a3,1
    80005b52:	faf40613          	addi	a2,s0,-81
    80005b56:	85d2                	mv	a1,s4
    80005b58:	8556                	mv	a0,s5
    80005b5a:	ffffc097          	auipc	ra,0xffffc
    80005b5e:	ff2080e7          	jalr	-14(ra) # 80001b4c <either_copyout>
    80005b62:	57fd                	li	a5,-1
    80005b64:	00f50763          	beq	a0,a5,80005b72 <consoleread+0xc4>
      break;

    dst++;
    80005b68:	0a05                	addi	s4,s4,1
    --n;
    80005b6a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005b6c:	47a9                	li	a5,10
    80005b6e:	f8fb90e3          	bne	s7,a5,80005aee <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b72:	0001d517          	auipc	a0,0x1d
    80005b76:	d6e50513          	addi	a0,a0,-658 # 800228e0 <cons>
    80005b7a:	00001097          	auipc	ra,0x1
    80005b7e:	974080e7          	jalr	-1676(ra) # 800064ee <release>

  return target - n;
    80005b82:	413b053b          	subw	a0,s6,s3
    80005b86:	a811                	j	80005b9a <consoleread+0xec>
        release(&cons.lock);
    80005b88:	0001d517          	auipc	a0,0x1d
    80005b8c:	d5850513          	addi	a0,a0,-680 # 800228e0 <cons>
    80005b90:	00001097          	auipc	ra,0x1
    80005b94:	95e080e7          	jalr	-1698(ra) # 800064ee <release>
        return -1;
    80005b98:	557d                	li	a0,-1
}
    80005b9a:	60e6                	ld	ra,88(sp)
    80005b9c:	6446                	ld	s0,80(sp)
    80005b9e:	64a6                	ld	s1,72(sp)
    80005ba0:	6906                	ld	s2,64(sp)
    80005ba2:	79e2                	ld	s3,56(sp)
    80005ba4:	7a42                	ld	s4,48(sp)
    80005ba6:	7aa2                	ld	s5,40(sp)
    80005ba8:	7b02                	ld	s6,32(sp)
    80005baa:	6be2                	ld	s7,24(sp)
    80005bac:	6125                	addi	sp,sp,96
    80005bae:	8082                	ret
      if(n < target){
    80005bb0:	0009871b          	sext.w	a4,s3
    80005bb4:	fb677fe3          	bgeu	a4,s6,80005b72 <consoleread+0xc4>
        cons.r--;
    80005bb8:	0001d717          	auipc	a4,0x1d
    80005bbc:	dcf72023          	sw	a5,-576(a4) # 80022978 <cons+0x98>
    80005bc0:	bf4d                	j	80005b72 <consoleread+0xc4>

0000000080005bc2 <consputc>:
{
    80005bc2:	1141                	addi	sp,sp,-16
    80005bc4:	e406                	sd	ra,8(sp)
    80005bc6:	e022                	sd	s0,0(sp)
    80005bc8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bca:	10000793          	li	a5,256
    80005bce:	00f50a63          	beq	a0,a5,80005be2 <consputc+0x20>
    uartputc_sync(c);
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	5dc080e7          	jalr	1500(ra) # 800061ae <uartputc_sync>
}
    80005bda:	60a2                	ld	ra,8(sp)
    80005bdc:	6402                	ld	s0,0(sp)
    80005bde:	0141                	addi	sp,sp,16
    80005be0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be2:	4521                	li	a0,8
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	5ca080e7          	jalr	1482(ra) # 800061ae <uartputc_sync>
    80005bec:	02000513          	li	a0,32
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	5be080e7          	jalr	1470(ra) # 800061ae <uartputc_sync>
    80005bf8:	4521                	li	a0,8
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	5b4080e7          	jalr	1460(ra) # 800061ae <uartputc_sync>
    80005c02:	bfe1                	j	80005bda <consputc+0x18>

0000000080005c04 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c04:	1101                	addi	sp,sp,-32
    80005c06:	ec06                	sd	ra,24(sp)
    80005c08:	e822                	sd	s0,16(sp)
    80005c0a:	e426                	sd	s1,8(sp)
    80005c0c:	e04a                	sd	s2,0(sp)
    80005c0e:	1000                	addi	s0,sp,32
    80005c10:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c12:	0001d517          	auipc	a0,0x1d
    80005c16:	cce50513          	addi	a0,a0,-818 # 800228e0 <cons>
    80005c1a:	00001097          	auipc	ra,0x1
    80005c1e:	820080e7          	jalr	-2016(ra) # 8000643a <acquire>

  switch(c){
    80005c22:	47d5                	li	a5,21
    80005c24:	0af48663          	beq	s1,a5,80005cd0 <consoleintr+0xcc>
    80005c28:	0297ca63          	blt	a5,s1,80005c5c <consoleintr+0x58>
    80005c2c:	47a1                	li	a5,8
    80005c2e:	0ef48763          	beq	s1,a5,80005d1c <consoleintr+0x118>
    80005c32:	47c1                	li	a5,16
    80005c34:	10f49a63          	bne	s1,a5,80005d48 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c38:	ffffc097          	auipc	ra,0xffffc
    80005c3c:	fc0080e7          	jalr	-64(ra) # 80001bf8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c40:	0001d517          	auipc	a0,0x1d
    80005c44:	ca050513          	addi	a0,a0,-864 # 800228e0 <cons>
    80005c48:	00001097          	auipc	ra,0x1
    80005c4c:	8a6080e7          	jalr	-1882(ra) # 800064ee <release>
}
    80005c50:	60e2                	ld	ra,24(sp)
    80005c52:	6442                	ld	s0,16(sp)
    80005c54:	64a2                	ld	s1,8(sp)
    80005c56:	6902                	ld	s2,0(sp)
    80005c58:	6105                	addi	sp,sp,32
    80005c5a:	8082                	ret
  switch(c){
    80005c5c:	07f00793          	li	a5,127
    80005c60:	0af48e63          	beq	s1,a5,80005d1c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c64:	0001d717          	auipc	a4,0x1d
    80005c68:	c7c70713          	addi	a4,a4,-900 # 800228e0 <cons>
    80005c6c:	0a072783          	lw	a5,160(a4)
    80005c70:	09872703          	lw	a4,152(a4)
    80005c74:	9f99                	subw	a5,a5,a4
    80005c76:	07f00713          	li	a4,127
    80005c7a:	fcf763e3          	bltu	a4,a5,80005c40 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c7e:	47b5                	li	a5,13
    80005c80:	0cf48763          	beq	s1,a5,80005d4e <consoleintr+0x14a>
      consputc(c);
    80005c84:	8526                	mv	a0,s1
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	f3c080e7          	jalr	-196(ra) # 80005bc2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c8e:	0001d797          	auipc	a5,0x1d
    80005c92:	c5278793          	addi	a5,a5,-942 # 800228e0 <cons>
    80005c96:	0a07a683          	lw	a3,160(a5)
    80005c9a:	0016871b          	addiw	a4,a3,1
    80005c9e:	0007061b          	sext.w	a2,a4
    80005ca2:	0ae7a023          	sw	a4,160(a5)
    80005ca6:	07f6f693          	andi	a3,a3,127
    80005caa:	97b6                	add	a5,a5,a3
    80005cac:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cb0:	47a9                	li	a5,10
    80005cb2:	0cf48563          	beq	s1,a5,80005d7c <consoleintr+0x178>
    80005cb6:	4791                	li	a5,4
    80005cb8:	0cf48263          	beq	s1,a5,80005d7c <consoleintr+0x178>
    80005cbc:	0001d797          	auipc	a5,0x1d
    80005cc0:	cbc7a783          	lw	a5,-836(a5) # 80022978 <cons+0x98>
    80005cc4:	9f1d                	subw	a4,a4,a5
    80005cc6:	08000793          	li	a5,128
    80005cca:	f6f71be3          	bne	a4,a5,80005c40 <consoleintr+0x3c>
    80005cce:	a07d                	j	80005d7c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cd0:	0001d717          	auipc	a4,0x1d
    80005cd4:	c1070713          	addi	a4,a4,-1008 # 800228e0 <cons>
    80005cd8:	0a072783          	lw	a5,160(a4)
    80005cdc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ce0:	0001d497          	auipc	s1,0x1d
    80005ce4:	c0048493          	addi	s1,s1,-1024 # 800228e0 <cons>
    while(cons.e != cons.w &&
    80005ce8:	4929                	li	s2,10
    80005cea:	f4f70be3          	beq	a4,a5,80005c40 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cee:	37fd                	addiw	a5,a5,-1
    80005cf0:	07f7f713          	andi	a4,a5,127
    80005cf4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cf6:	01874703          	lbu	a4,24(a4)
    80005cfa:	f52703e3          	beq	a4,s2,80005c40 <consoleintr+0x3c>
      cons.e--;
    80005cfe:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d02:	10000513          	li	a0,256
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	ebc080e7          	jalr	-324(ra) # 80005bc2 <consputc>
    while(cons.e != cons.w &&
    80005d0e:	0a04a783          	lw	a5,160(s1)
    80005d12:	09c4a703          	lw	a4,156(s1)
    80005d16:	fcf71ce3          	bne	a4,a5,80005cee <consoleintr+0xea>
    80005d1a:	b71d                	j	80005c40 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d1c:	0001d717          	auipc	a4,0x1d
    80005d20:	bc470713          	addi	a4,a4,-1084 # 800228e0 <cons>
    80005d24:	0a072783          	lw	a5,160(a4)
    80005d28:	09c72703          	lw	a4,156(a4)
    80005d2c:	f0f70ae3          	beq	a4,a5,80005c40 <consoleintr+0x3c>
      cons.e--;
    80005d30:	37fd                	addiw	a5,a5,-1
    80005d32:	0001d717          	auipc	a4,0x1d
    80005d36:	c4f72723          	sw	a5,-946(a4) # 80022980 <cons+0xa0>
      consputc(BACKSPACE);
    80005d3a:	10000513          	li	a0,256
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	e84080e7          	jalr	-380(ra) # 80005bc2 <consputc>
    80005d46:	bded                	j	80005c40 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d48:	ee048ce3          	beqz	s1,80005c40 <consoleintr+0x3c>
    80005d4c:	bf21                	j	80005c64 <consoleintr+0x60>
      consputc(c);
    80005d4e:	4529                	li	a0,10
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	e72080e7          	jalr	-398(ra) # 80005bc2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d58:	0001d797          	auipc	a5,0x1d
    80005d5c:	b8878793          	addi	a5,a5,-1144 # 800228e0 <cons>
    80005d60:	0a07a703          	lw	a4,160(a5)
    80005d64:	0017069b          	addiw	a3,a4,1
    80005d68:	0006861b          	sext.w	a2,a3
    80005d6c:	0ad7a023          	sw	a3,160(a5)
    80005d70:	07f77713          	andi	a4,a4,127
    80005d74:	97ba                	add	a5,a5,a4
    80005d76:	4729                	li	a4,10
    80005d78:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d7c:	0001d797          	auipc	a5,0x1d
    80005d80:	c0c7a023          	sw	a2,-1024(a5) # 8002297c <cons+0x9c>
        wakeup(&cons.r);
    80005d84:	0001d517          	auipc	a0,0x1d
    80005d88:	bf450513          	addi	a0,a0,-1036 # 80022978 <cons+0x98>
    80005d8c:	ffffc097          	auipc	ra,0xffffc
    80005d90:	a1c080e7          	jalr	-1508(ra) # 800017a8 <wakeup>
    80005d94:	b575                	j	80005c40 <consoleintr+0x3c>

0000000080005d96 <consoleinit>:

void
consoleinit(void)
{
    80005d96:	1141                	addi	sp,sp,-16
    80005d98:	e406                	sd	ra,8(sp)
    80005d9a:	e022                	sd	s0,0(sp)
    80005d9c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d9e:	00003597          	auipc	a1,0x3
    80005da2:	c9258593          	addi	a1,a1,-878 # 80008a30 <syscall_names+0x3f0>
    80005da6:	0001d517          	auipc	a0,0x1d
    80005daa:	b3a50513          	addi	a0,a0,-1222 # 800228e0 <cons>
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	5fc080e7          	jalr	1532(ra) # 800063aa <initlock>

  uartinit();
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	3a8080e7          	jalr	936(ra) # 8000615e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dbe:	00014797          	auipc	a5,0x14
    80005dc2:	84a78793          	addi	a5,a5,-1974 # 80019608 <devsw>
    80005dc6:	00000717          	auipc	a4,0x0
    80005dca:	ce870713          	addi	a4,a4,-792 # 80005aae <consoleread>
    80005dce:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dd0:	00000717          	auipc	a4,0x0
    80005dd4:	c7a70713          	addi	a4,a4,-902 # 80005a4a <consolewrite>
    80005dd8:	ef98                	sd	a4,24(a5)
}
    80005dda:	60a2                	ld	ra,8(sp)
    80005ddc:	6402                	ld	s0,0(sp)
    80005dde:	0141                	addi	sp,sp,16
    80005de0:	8082                	ret

0000000080005de2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005de2:	7179                	addi	sp,sp,-48
    80005de4:	f406                	sd	ra,40(sp)
    80005de6:	f022                	sd	s0,32(sp)
    80005de8:	ec26                	sd	s1,24(sp)
    80005dea:	e84a                	sd	s2,16(sp)
    80005dec:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dee:	c219                	beqz	a2,80005df4 <printint+0x12>
    80005df0:	08054763          	bltz	a0,80005e7e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005df4:	2501                	sext.w	a0,a0
    80005df6:	4881                	li	a7,0
    80005df8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dfc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dfe:	2581                	sext.w	a1,a1
    80005e00:	00003617          	auipc	a2,0x3
    80005e04:	c7860613          	addi	a2,a2,-904 # 80008a78 <digits>
    80005e08:	883a                	mv	a6,a4
    80005e0a:	2705                	addiw	a4,a4,1
    80005e0c:	02b577bb          	remuw	a5,a0,a1
    80005e10:	1782                	slli	a5,a5,0x20
    80005e12:	9381                	srli	a5,a5,0x20
    80005e14:	97b2                	add	a5,a5,a2
    80005e16:	0007c783          	lbu	a5,0(a5)
    80005e1a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e1e:	0005079b          	sext.w	a5,a0
    80005e22:	02b5553b          	divuw	a0,a0,a1
    80005e26:	0685                	addi	a3,a3,1
    80005e28:	feb7f0e3          	bgeu	a5,a1,80005e08 <printint+0x26>

  if(sign)
    80005e2c:	00088c63          	beqz	a7,80005e44 <printint+0x62>
    buf[i++] = '-';
    80005e30:	fe070793          	addi	a5,a4,-32
    80005e34:	00878733          	add	a4,a5,s0
    80005e38:	02d00793          	li	a5,45
    80005e3c:	fef70823          	sb	a5,-16(a4)
    80005e40:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e44:	02e05763          	blez	a4,80005e72 <printint+0x90>
    80005e48:	fd040793          	addi	a5,s0,-48
    80005e4c:	00e784b3          	add	s1,a5,a4
    80005e50:	fff78913          	addi	s2,a5,-1
    80005e54:	993a                	add	s2,s2,a4
    80005e56:	377d                	addiw	a4,a4,-1
    80005e58:	1702                	slli	a4,a4,0x20
    80005e5a:	9301                	srli	a4,a4,0x20
    80005e5c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e60:	fff4c503          	lbu	a0,-1(s1)
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	d5e080e7          	jalr	-674(ra) # 80005bc2 <consputc>
  while(--i >= 0)
    80005e6c:	14fd                	addi	s1,s1,-1
    80005e6e:	ff2499e3          	bne	s1,s2,80005e60 <printint+0x7e>
}
    80005e72:	70a2                	ld	ra,40(sp)
    80005e74:	7402                	ld	s0,32(sp)
    80005e76:	64e2                	ld	s1,24(sp)
    80005e78:	6942                	ld	s2,16(sp)
    80005e7a:	6145                	addi	sp,sp,48
    80005e7c:	8082                	ret
    x = -xx;
    80005e7e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e82:	4885                	li	a7,1
    x = -xx;
    80005e84:	bf95                	j	80005df8 <printint+0x16>

0000000080005e86 <printfinit>:
  for(;;)
    ;
}
void
printfinit(void)
{
    80005e86:	1101                	addi	sp,sp,-32
    80005e88:	ec06                	sd	ra,24(sp)
    80005e8a:	e822                	sd	s0,16(sp)
    80005e8c:	e426                	sd	s1,8(sp)
    80005e8e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e90:	0001d497          	auipc	s1,0x1d
    80005e94:	af848493          	addi	s1,s1,-1288 # 80022988 <pr>
    80005e98:	00003597          	auipc	a1,0x3
    80005e9c:	ba058593          	addi	a1,a1,-1120 # 80008a38 <syscall_names+0x3f8>
    80005ea0:	8526                	mv	a0,s1
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	508080e7          	jalr	1288(ra) # 800063aa <initlock>
  pr.locking = 1;
    80005eaa:	4785                	li	a5,1
    80005eac:	cc9c                	sw	a5,24(s1)
}
    80005eae:	60e2                	ld	ra,24(sp)
    80005eb0:	6442                	ld	s0,16(sp)
    80005eb2:	64a2                	ld	s1,8(sp)
    80005eb4:	6105                	addi	sp,sp,32
    80005eb6:	8082                	ret

0000000080005eb8 <backtrace>:
void 
backtrace(){
    80005eb8:	7179                	addi	sp,sp,-48
    80005eba:	f406                	sd	ra,40(sp)
    80005ebc:	f022                	sd	s0,32(sp)
    80005ebe:	ec26                	sd	s1,24(sp)
    80005ec0:	e84a                	sd	s2,16(sp)
    80005ec2:	e44e                	sd	s3,8(sp)
    80005ec4:	e052                	sd	s4,0(sp)
    80005ec6:	1800                	addi	s0,sp,48
  asm volatile ("mv %0, s0" : "=r" (x));
    80005ec8:	84a2                	mv	s1,s0
  uint64 fp=r_fp();
  printf("backtrace:\n");
    80005eca:	00003517          	auipc	a0,0x3
    80005ece:	b7650513          	addi	a0,a0,-1162 # 80008a40 <syscall_names+0x400>
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	0ac080e7          	jalr	172(ra) # 80005f7e <printf>
  while(PGROUNDDOWN(fp) < PGROUNDUP(fp)){
    80005eda:	777d                	lui	a4,0xfffff
    80005edc:	00e4f6b3          	and	a3,s1,a4
    80005ee0:	6785                	lui	a5,0x1
    80005ee2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005ee4:	97a6                	add	a5,a5,s1
    80005ee6:	8ff9                	and	a5,a5,a4
    80005ee8:	02f6fa63          	bgeu	a3,a5,80005f1c <backtrace+0x64>
    printf("%p\n",*(uint64*)(fp-8));
    80005eec:	00003a17          	auipc	s4,0x3
    80005ef0:	b64a0a13          	addi	s4,s4,-1180 # 80008a50 <syscall_names+0x410>
  while(PGROUNDDOWN(fp) < PGROUNDUP(fp)){
    80005ef4:	797d                	lui	s2,0xfffff
    80005ef6:	6985                	lui	s3,0x1
    80005ef8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    printf("%p\n",*(uint64*)(fp-8));
    80005efa:	ff84b583          	ld	a1,-8(s1)
    80005efe:	8552                	mv	a0,s4
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	07e080e7          	jalr	126(ra) # 80005f7e <printf>
    fp=*(uint64*)(fp-16);
    80005f08:	ff04b483          	ld	s1,-16(s1)
  while(PGROUNDDOWN(fp) < PGROUNDUP(fp)){
    80005f0c:	0124f733          	and	a4,s1,s2
    80005f10:	013487b3          	add	a5,s1,s3
    80005f14:	0127f7b3          	and	a5,a5,s2
    80005f18:	fef761e3          	bltu	a4,a5,80005efa <backtrace+0x42>
  }
}
    80005f1c:	70a2                	ld	ra,40(sp)
    80005f1e:	7402                	ld	s0,32(sp)
    80005f20:	64e2                	ld	s1,24(sp)
    80005f22:	6942                	ld	s2,16(sp)
    80005f24:	69a2                	ld	s3,8(sp)
    80005f26:	6a02                	ld	s4,0(sp)
    80005f28:	6145                	addi	sp,sp,48
    80005f2a:	8082                	ret

0000000080005f2c <panic>:
{
    80005f2c:	1101                	addi	sp,sp,-32
    80005f2e:	ec06                	sd	ra,24(sp)
    80005f30:	e822                	sd	s0,16(sp)
    80005f32:	e426                	sd	s1,8(sp)
    80005f34:	1000                	addi	s0,sp,32
    80005f36:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f38:	0001d797          	auipc	a5,0x1d
    80005f3c:	a607a423          	sw	zero,-1432(a5) # 800229a0 <pr+0x18>
  printf("panic: ");
    80005f40:	00003517          	auipc	a0,0x3
    80005f44:	b1850513          	addi	a0,a0,-1256 # 80008a58 <syscall_names+0x418>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	036080e7          	jalr	54(ra) # 80005f7e <printf>
  printf(s);
    80005f50:	8526                	mv	a0,s1
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	02c080e7          	jalr	44(ra) # 80005f7e <printf>
  printf("\n");
    80005f5a:	00002517          	auipc	a0,0x2
    80005f5e:	0ee50513          	addi	a0,a0,238 # 80008048 <etext+0x48>
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	01c080e7          	jalr	28(ra) # 80005f7e <printf>
  backtrace();
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	f4e080e7          	jalr	-178(ra) # 80005eb8 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005f72:	4785                	li	a5,1
    80005f74:	00003717          	auipc	a4,0x3
    80005f78:	bef72423          	sw	a5,-1048(a4) # 80008b5c <panicked>
  for(;;)
    80005f7c:	a001                	j	80005f7c <panic+0x50>

0000000080005f7e <printf>:
{
    80005f7e:	7131                	addi	sp,sp,-192
    80005f80:	fc86                	sd	ra,120(sp)
    80005f82:	f8a2                	sd	s0,112(sp)
    80005f84:	f4a6                	sd	s1,104(sp)
    80005f86:	f0ca                	sd	s2,96(sp)
    80005f88:	ecce                	sd	s3,88(sp)
    80005f8a:	e8d2                	sd	s4,80(sp)
    80005f8c:	e4d6                	sd	s5,72(sp)
    80005f8e:	e0da                	sd	s6,64(sp)
    80005f90:	fc5e                	sd	s7,56(sp)
    80005f92:	f862                	sd	s8,48(sp)
    80005f94:	f466                	sd	s9,40(sp)
    80005f96:	f06a                	sd	s10,32(sp)
    80005f98:	ec6e                	sd	s11,24(sp)
    80005f9a:	0100                	addi	s0,sp,128
    80005f9c:	8a2a                	mv	s4,a0
    80005f9e:	e40c                	sd	a1,8(s0)
    80005fa0:	e810                	sd	a2,16(s0)
    80005fa2:	ec14                	sd	a3,24(s0)
    80005fa4:	f018                	sd	a4,32(s0)
    80005fa6:	f41c                	sd	a5,40(s0)
    80005fa8:	03043823          	sd	a6,48(s0)
    80005fac:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005fb0:	0001dd97          	auipc	s11,0x1d
    80005fb4:	9f0dad83          	lw	s11,-1552(s11) # 800229a0 <pr+0x18>
  if(locking)
    80005fb8:	020d9b63          	bnez	s11,80005fee <printf+0x70>
  if (fmt == 0)
    80005fbc:	040a0263          	beqz	s4,80006000 <printf+0x82>
  va_start(ap, fmt);
    80005fc0:	00840793          	addi	a5,s0,8
    80005fc4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fc8:	000a4503          	lbu	a0,0(s4)
    80005fcc:	14050f63          	beqz	a0,8000612a <printf+0x1ac>
    80005fd0:	4981                	li	s3,0
    if(c != '%'){
    80005fd2:	02500a93          	li	s5,37
    switch(c){
    80005fd6:	07000b93          	li	s7,112
  consputc('x');
    80005fda:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fdc:	00003b17          	auipc	s6,0x3
    80005fe0:	a9cb0b13          	addi	s6,s6,-1380 # 80008a78 <digits>
    switch(c){
    80005fe4:	07300c93          	li	s9,115
    80005fe8:	06400c13          	li	s8,100
    80005fec:	a82d                	j	80006026 <printf+0xa8>
    acquire(&pr.lock);
    80005fee:	0001d517          	auipc	a0,0x1d
    80005ff2:	99a50513          	addi	a0,a0,-1638 # 80022988 <pr>
    80005ff6:	00000097          	auipc	ra,0x0
    80005ffa:	444080e7          	jalr	1092(ra) # 8000643a <acquire>
    80005ffe:	bf7d                	j	80005fbc <printf+0x3e>
    panic("null fmt");
    80006000:	00003517          	auipc	a0,0x3
    80006004:	a6850513          	addi	a0,a0,-1432 # 80008a68 <syscall_names+0x428>
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	f24080e7          	jalr	-220(ra) # 80005f2c <panic>
      consputc(c);
    80006010:	00000097          	auipc	ra,0x0
    80006014:	bb2080e7          	jalr	-1102(ra) # 80005bc2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006018:	2985                	addiw	s3,s3,1
    8000601a:	013a07b3          	add	a5,s4,s3
    8000601e:	0007c503          	lbu	a0,0(a5)
    80006022:	10050463          	beqz	a0,8000612a <printf+0x1ac>
    if(c != '%'){
    80006026:	ff5515e3          	bne	a0,s5,80006010 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000602a:	2985                	addiw	s3,s3,1
    8000602c:	013a07b3          	add	a5,s4,s3
    80006030:	0007c783          	lbu	a5,0(a5)
    80006034:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006038:	cbed                	beqz	a5,8000612a <printf+0x1ac>
    switch(c){
    8000603a:	05778a63          	beq	a5,s7,8000608e <printf+0x110>
    8000603e:	02fbf663          	bgeu	s7,a5,8000606a <printf+0xec>
    80006042:	09978863          	beq	a5,s9,800060d2 <printf+0x154>
    80006046:	07800713          	li	a4,120
    8000604a:	0ce79563          	bne	a5,a4,80006114 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000604e:	f8843783          	ld	a5,-120(s0)
    80006052:	00878713          	addi	a4,a5,8
    80006056:	f8e43423          	sd	a4,-120(s0)
    8000605a:	4605                	li	a2,1
    8000605c:	85ea                	mv	a1,s10
    8000605e:	4388                	lw	a0,0(a5)
    80006060:	00000097          	auipc	ra,0x0
    80006064:	d82080e7          	jalr	-638(ra) # 80005de2 <printint>
      break;
    80006068:	bf45                	j	80006018 <printf+0x9a>
    switch(c){
    8000606a:	09578f63          	beq	a5,s5,80006108 <printf+0x18a>
    8000606e:	0b879363          	bne	a5,s8,80006114 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006072:	f8843783          	ld	a5,-120(s0)
    80006076:	00878713          	addi	a4,a5,8
    8000607a:	f8e43423          	sd	a4,-120(s0)
    8000607e:	4605                	li	a2,1
    80006080:	45a9                	li	a1,10
    80006082:	4388                	lw	a0,0(a5)
    80006084:	00000097          	auipc	ra,0x0
    80006088:	d5e080e7          	jalr	-674(ra) # 80005de2 <printint>
      break;
    8000608c:	b771                	j	80006018 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000608e:	f8843783          	ld	a5,-120(s0)
    80006092:	00878713          	addi	a4,a5,8
    80006096:	f8e43423          	sd	a4,-120(s0)
    8000609a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000609e:	03000513          	li	a0,48
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	b20080e7          	jalr	-1248(ra) # 80005bc2 <consputc>
  consputc('x');
    800060aa:	07800513          	li	a0,120
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	b14080e7          	jalr	-1260(ra) # 80005bc2 <consputc>
    800060b6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060b8:	03c95793          	srli	a5,s2,0x3c
    800060bc:	97da                	add	a5,a5,s6
    800060be:	0007c503          	lbu	a0,0(a5)
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	b00080e7          	jalr	-1280(ra) # 80005bc2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060ca:	0912                	slli	s2,s2,0x4
    800060cc:	34fd                	addiw	s1,s1,-1
    800060ce:	f4ed                	bnez	s1,800060b8 <printf+0x13a>
    800060d0:	b7a1                	j	80006018 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800060d2:	f8843783          	ld	a5,-120(s0)
    800060d6:	00878713          	addi	a4,a5,8
    800060da:	f8e43423          	sd	a4,-120(s0)
    800060de:	6384                	ld	s1,0(a5)
    800060e0:	cc89                	beqz	s1,800060fa <printf+0x17c>
      for(; *s; s++)
    800060e2:	0004c503          	lbu	a0,0(s1)
    800060e6:	d90d                	beqz	a0,80006018 <printf+0x9a>
        consputc(*s);
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	ada080e7          	jalr	-1318(ra) # 80005bc2 <consputc>
      for(; *s; s++)
    800060f0:	0485                	addi	s1,s1,1
    800060f2:	0004c503          	lbu	a0,0(s1)
    800060f6:	f96d                	bnez	a0,800060e8 <printf+0x16a>
    800060f8:	b705                	j	80006018 <printf+0x9a>
        s = "(null)";
    800060fa:	00003497          	auipc	s1,0x3
    800060fe:	96648493          	addi	s1,s1,-1690 # 80008a60 <syscall_names+0x420>
      for(; *s; s++)
    80006102:	02800513          	li	a0,40
    80006106:	b7cd                	j	800060e8 <printf+0x16a>
      consputc('%');
    80006108:	8556                	mv	a0,s5
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	ab8080e7          	jalr	-1352(ra) # 80005bc2 <consputc>
      break;
    80006112:	b719                	j	80006018 <printf+0x9a>
      consputc('%');
    80006114:	8556                	mv	a0,s5
    80006116:	00000097          	auipc	ra,0x0
    8000611a:	aac080e7          	jalr	-1364(ra) # 80005bc2 <consputc>
      consputc(c);
    8000611e:	8526                	mv	a0,s1
    80006120:	00000097          	auipc	ra,0x0
    80006124:	aa2080e7          	jalr	-1374(ra) # 80005bc2 <consputc>
      break;
    80006128:	bdc5                	j	80006018 <printf+0x9a>
  if(locking)
    8000612a:	020d9163          	bnez	s11,8000614c <printf+0x1ce>
}
    8000612e:	70e6                	ld	ra,120(sp)
    80006130:	7446                	ld	s0,112(sp)
    80006132:	74a6                	ld	s1,104(sp)
    80006134:	7906                	ld	s2,96(sp)
    80006136:	69e6                	ld	s3,88(sp)
    80006138:	6a46                	ld	s4,80(sp)
    8000613a:	6aa6                	ld	s5,72(sp)
    8000613c:	6b06                	ld	s6,64(sp)
    8000613e:	7be2                	ld	s7,56(sp)
    80006140:	7c42                	ld	s8,48(sp)
    80006142:	7ca2                	ld	s9,40(sp)
    80006144:	7d02                	ld	s10,32(sp)
    80006146:	6de2                	ld	s11,24(sp)
    80006148:	6129                	addi	sp,sp,192
    8000614a:	8082                	ret
    release(&pr.lock);
    8000614c:	0001d517          	auipc	a0,0x1d
    80006150:	83c50513          	addi	a0,a0,-1988 # 80022988 <pr>
    80006154:	00000097          	auipc	ra,0x0
    80006158:	39a080e7          	jalr	922(ra) # 800064ee <release>
}
    8000615c:	bfc9                	j	8000612e <printf+0x1b0>

000000008000615e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000615e:	1141                	addi	sp,sp,-16
    80006160:	e406                	sd	ra,8(sp)
    80006162:	e022                	sd	s0,0(sp)
    80006164:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006166:	100007b7          	lui	a5,0x10000
    8000616a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000616e:	f8000713          	li	a4,-128
    80006172:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006176:	470d                	li	a4,3
    80006178:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000617c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006180:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006184:	469d                	li	a3,7
    80006186:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000618a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000618e:	00003597          	auipc	a1,0x3
    80006192:	90258593          	addi	a1,a1,-1790 # 80008a90 <digits+0x18>
    80006196:	0001d517          	auipc	a0,0x1d
    8000619a:	81250513          	addi	a0,a0,-2030 # 800229a8 <uart_tx_lock>
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	20c080e7          	jalr	524(ra) # 800063aa <initlock>
}
    800061a6:	60a2                	ld	ra,8(sp)
    800061a8:	6402                	ld	s0,0(sp)
    800061aa:	0141                	addi	sp,sp,16
    800061ac:	8082                	ret

00000000800061ae <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061ae:	1101                	addi	sp,sp,-32
    800061b0:	ec06                	sd	ra,24(sp)
    800061b2:	e822                	sd	s0,16(sp)
    800061b4:	e426                	sd	s1,8(sp)
    800061b6:	1000                	addi	s0,sp,32
    800061b8:	84aa                	mv	s1,a0
  push_off();
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	234080e7          	jalr	564(ra) # 800063ee <push_off>

  if(panicked){
    800061c2:	00003797          	auipc	a5,0x3
    800061c6:	99a7a783          	lw	a5,-1638(a5) # 80008b5c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061ca:	10000737          	lui	a4,0x10000
  if(panicked){
    800061ce:	c391                	beqz	a5,800061d2 <uartputc_sync+0x24>
    for(;;)
    800061d0:	a001                	j	800061d0 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061d2:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800061d6:	0207f793          	andi	a5,a5,32
    800061da:	dfe5                	beqz	a5,800061d2 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061dc:	0ff4f513          	zext.b	a0,s1
    800061e0:	100007b7          	lui	a5,0x10000
    800061e4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	2a6080e7          	jalr	678(ra) # 8000648e <pop_off>
}
    800061f0:	60e2                	ld	ra,24(sp)
    800061f2:	6442                	ld	s0,16(sp)
    800061f4:	64a2                	ld	s1,8(sp)
    800061f6:	6105                	addi	sp,sp,32
    800061f8:	8082                	ret

00000000800061fa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061fa:	00003797          	auipc	a5,0x3
    800061fe:	9667b783          	ld	a5,-1690(a5) # 80008b60 <uart_tx_r>
    80006202:	00003717          	auipc	a4,0x3
    80006206:	96673703          	ld	a4,-1690(a4) # 80008b68 <uart_tx_w>
    8000620a:	06f70a63          	beq	a4,a5,8000627e <uartstart+0x84>
{
    8000620e:	7139                	addi	sp,sp,-64
    80006210:	fc06                	sd	ra,56(sp)
    80006212:	f822                	sd	s0,48(sp)
    80006214:	f426                	sd	s1,40(sp)
    80006216:	f04a                	sd	s2,32(sp)
    80006218:	ec4e                	sd	s3,24(sp)
    8000621a:	e852                	sd	s4,16(sp)
    8000621c:	e456                	sd	s5,8(sp)
    8000621e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006220:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006224:	0001ca17          	auipc	s4,0x1c
    80006228:	784a0a13          	addi	s4,s4,1924 # 800229a8 <uart_tx_lock>
    uart_tx_r += 1;
    8000622c:	00003497          	auipc	s1,0x3
    80006230:	93448493          	addi	s1,s1,-1740 # 80008b60 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006234:	00003997          	auipc	s3,0x3
    80006238:	93498993          	addi	s3,s3,-1740 # 80008b68 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000623c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006240:	02077713          	andi	a4,a4,32
    80006244:	c705                	beqz	a4,8000626c <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006246:	01f7f713          	andi	a4,a5,31
    8000624a:	9752                	add	a4,a4,s4
    8000624c:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006250:	0785                	addi	a5,a5,1
    80006252:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006254:	8526                	mv	a0,s1
    80006256:	ffffb097          	auipc	ra,0xffffb
    8000625a:	552080e7          	jalr	1362(ra) # 800017a8 <wakeup>
    
    WriteReg(THR, c);
    8000625e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006262:	609c                	ld	a5,0(s1)
    80006264:	0009b703          	ld	a4,0(s3)
    80006268:	fcf71ae3          	bne	a4,a5,8000623c <uartstart+0x42>
  }
}
    8000626c:	70e2                	ld	ra,56(sp)
    8000626e:	7442                	ld	s0,48(sp)
    80006270:	74a2                	ld	s1,40(sp)
    80006272:	7902                	ld	s2,32(sp)
    80006274:	69e2                	ld	s3,24(sp)
    80006276:	6a42                	ld	s4,16(sp)
    80006278:	6aa2                	ld	s5,8(sp)
    8000627a:	6121                	addi	sp,sp,64
    8000627c:	8082                	ret
    8000627e:	8082                	ret

0000000080006280 <uartputc>:
{
    80006280:	7179                	addi	sp,sp,-48
    80006282:	f406                	sd	ra,40(sp)
    80006284:	f022                	sd	s0,32(sp)
    80006286:	ec26                	sd	s1,24(sp)
    80006288:	e84a                	sd	s2,16(sp)
    8000628a:	e44e                	sd	s3,8(sp)
    8000628c:	e052                	sd	s4,0(sp)
    8000628e:	1800                	addi	s0,sp,48
    80006290:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006292:	0001c517          	auipc	a0,0x1c
    80006296:	71650513          	addi	a0,a0,1814 # 800229a8 <uart_tx_lock>
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	1a0080e7          	jalr	416(ra) # 8000643a <acquire>
  if(panicked){
    800062a2:	00003797          	auipc	a5,0x3
    800062a6:	8ba7a783          	lw	a5,-1862(a5) # 80008b5c <panicked>
    800062aa:	e7c9                	bnez	a5,80006334 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062ac:	00003717          	auipc	a4,0x3
    800062b0:	8bc73703          	ld	a4,-1860(a4) # 80008b68 <uart_tx_w>
    800062b4:	00003797          	auipc	a5,0x3
    800062b8:	8ac7b783          	ld	a5,-1876(a5) # 80008b60 <uart_tx_r>
    800062bc:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800062c0:	0001c997          	auipc	s3,0x1c
    800062c4:	6e898993          	addi	s3,s3,1768 # 800229a8 <uart_tx_lock>
    800062c8:	00003497          	auipc	s1,0x3
    800062cc:	89848493          	addi	s1,s1,-1896 # 80008b60 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062d0:	00003917          	auipc	s2,0x3
    800062d4:	89890913          	addi	s2,s2,-1896 # 80008b68 <uart_tx_w>
    800062d8:	00e79f63          	bne	a5,a4,800062f6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800062dc:	85ce                	mv	a1,s3
    800062de:	8526                	mv	a0,s1
    800062e0:	ffffb097          	auipc	ra,0xffffb
    800062e4:	464080e7          	jalr	1124(ra) # 80001744 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062e8:	00093703          	ld	a4,0(s2)
    800062ec:	609c                	ld	a5,0(s1)
    800062ee:	02078793          	addi	a5,a5,32
    800062f2:	fee785e3          	beq	a5,a4,800062dc <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062f6:	0001c497          	auipc	s1,0x1c
    800062fa:	6b248493          	addi	s1,s1,1714 # 800229a8 <uart_tx_lock>
    800062fe:	01f77793          	andi	a5,a4,31
    80006302:	97a6                	add	a5,a5,s1
    80006304:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006308:	0705                	addi	a4,a4,1
    8000630a:	00003797          	auipc	a5,0x3
    8000630e:	84e7bf23          	sd	a4,-1954(a5) # 80008b68 <uart_tx_w>
  uartstart();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	ee8080e7          	jalr	-280(ra) # 800061fa <uartstart>
  release(&uart_tx_lock);
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	1d2080e7          	jalr	466(ra) # 800064ee <release>
}
    80006324:	70a2                	ld	ra,40(sp)
    80006326:	7402                	ld	s0,32(sp)
    80006328:	64e2                	ld	s1,24(sp)
    8000632a:	6942                	ld	s2,16(sp)
    8000632c:	69a2                	ld	s3,8(sp)
    8000632e:	6a02                	ld	s4,0(sp)
    80006330:	6145                	addi	sp,sp,48
    80006332:	8082                	ret
    for(;;)
    80006334:	a001                	j	80006334 <uartputc+0xb4>

0000000080006336 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006336:	1141                	addi	sp,sp,-16
    80006338:	e422                	sd	s0,8(sp)
    8000633a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000633c:	100007b7          	lui	a5,0x10000
    80006340:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006344:	8b85                	andi	a5,a5,1
    80006346:	cb81                	beqz	a5,80006356 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006348:	100007b7          	lui	a5,0x10000
    8000634c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006350:	6422                	ld	s0,8(sp)
    80006352:	0141                	addi	sp,sp,16
    80006354:	8082                	ret
    return -1;
    80006356:	557d                	li	a0,-1
    80006358:	bfe5                	j	80006350 <uartgetc+0x1a>

000000008000635a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000635a:	1101                	addi	sp,sp,-32
    8000635c:	ec06                	sd	ra,24(sp)
    8000635e:	e822                	sd	s0,16(sp)
    80006360:	e426                	sd	s1,8(sp)
    80006362:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006364:	54fd                	li	s1,-1
    80006366:	a029                	j	80006370 <uartintr+0x16>
      break;
    consoleintr(c);
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	89c080e7          	jalr	-1892(ra) # 80005c04 <consoleintr>
    int c = uartgetc();
    80006370:	00000097          	auipc	ra,0x0
    80006374:	fc6080e7          	jalr	-58(ra) # 80006336 <uartgetc>
    if(c == -1)
    80006378:	fe9518e3          	bne	a0,s1,80006368 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000637c:	0001c497          	auipc	s1,0x1c
    80006380:	62c48493          	addi	s1,s1,1580 # 800229a8 <uart_tx_lock>
    80006384:	8526                	mv	a0,s1
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	0b4080e7          	jalr	180(ra) # 8000643a <acquire>
  uartstart();
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	e6c080e7          	jalr	-404(ra) # 800061fa <uartstart>
  release(&uart_tx_lock);
    80006396:	8526                	mv	a0,s1
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	156080e7          	jalr	342(ra) # 800064ee <release>
}
    800063a0:	60e2                	ld	ra,24(sp)
    800063a2:	6442                	ld	s0,16(sp)
    800063a4:	64a2                	ld	s1,8(sp)
    800063a6:	6105                	addi	sp,sp,32
    800063a8:	8082                	ret

00000000800063aa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063aa:	1141                	addi	sp,sp,-16
    800063ac:	e422                	sd	s0,8(sp)
    800063ae:	0800                	addi	s0,sp,16
  lk->name = name;
    800063b0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063b2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063b6:	00053823          	sd	zero,16(a0)
}
    800063ba:	6422                	ld	s0,8(sp)
    800063bc:	0141                	addi	sp,sp,16
    800063be:	8082                	ret

00000000800063c0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063c0:	411c                	lw	a5,0(a0)
    800063c2:	e399                	bnez	a5,800063c8 <holding+0x8>
    800063c4:	4501                	li	a0,0
  return r;
}
    800063c6:	8082                	ret
{
    800063c8:	1101                	addi	sp,sp,-32
    800063ca:	ec06                	sd	ra,24(sp)
    800063cc:	e822                	sd	s0,16(sp)
    800063ce:	e426                	sd	s1,8(sp)
    800063d0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063d2:	6904                	ld	s1,16(a0)
    800063d4:	ffffb097          	auipc	ra,0xffffb
    800063d8:	be8080e7          	jalr	-1048(ra) # 80000fbc <mycpu>
    800063dc:	40a48533          	sub	a0,s1,a0
    800063e0:	00153513          	seqz	a0,a0
}
    800063e4:	60e2                	ld	ra,24(sp)
    800063e6:	6442                	ld	s0,16(sp)
    800063e8:	64a2                	ld	s1,8(sp)
    800063ea:	6105                	addi	sp,sp,32
    800063ec:	8082                	ret

00000000800063ee <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063ee:	1101                	addi	sp,sp,-32
    800063f0:	ec06                	sd	ra,24(sp)
    800063f2:	e822                	sd	s0,16(sp)
    800063f4:	e426                	sd	s1,8(sp)
    800063f6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f8:	100024f3          	csrr	s1,sstatus
    800063fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006400:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006402:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006406:	ffffb097          	auipc	ra,0xffffb
    8000640a:	bb6080e7          	jalr	-1098(ra) # 80000fbc <mycpu>
    8000640e:	5d3c                	lw	a5,120(a0)
    80006410:	cf89                	beqz	a5,8000642a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006412:	ffffb097          	auipc	ra,0xffffb
    80006416:	baa080e7          	jalr	-1110(ra) # 80000fbc <mycpu>
    8000641a:	5d3c                	lw	a5,120(a0)
    8000641c:	2785                	addiw	a5,a5,1
    8000641e:	dd3c                	sw	a5,120(a0)
}
    80006420:	60e2                	ld	ra,24(sp)
    80006422:	6442                	ld	s0,16(sp)
    80006424:	64a2                	ld	s1,8(sp)
    80006426:	6105                	addi	sp,sp,32
    80006428:	8082                	ret
    mycpu()->intena = old;
    8000642a:	ffffb097          	auipc	ra,0xffffb
    8000642e:	b92080e7          	jalr	-1134(ra) # 80000fbc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006432:	8085                	srli	s1,s1,0x1
    80006434:	8885                	andi	s1,s1,1
    80006436:	dd64                	sw	s1,124(a0)
    80006438:	bfe9                	j	80006412 <push_off+0x24>

000000008000643a <acquire>:
{
    8000643a:	1101                	addi	sp,sp,-32
    8000643c:	ec06                	sd	ra,24(sp)
    8000643e:	e822                	sd	s0,16(sp)
    80006440:	e426                	sd	s1,8(sp)
    80006442:	1000                	addi	s0,sp,32
    80006444:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006446:	00000097          	auipc	ra,0x0
    8000644a:	fa8080e7          	jalr	-88(ra) # 800063ee <push_off>
  if(holding(lk))
    8000644e:	8526                	mv	a0,s1
    80006450:	00000097          	auipc	ra,0x0
    80006454:	f70080e7          	jalr	-144(ra) # 800063c0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006458:	4705                	li	a4,1
  if(holding(lk))
    8000645a:	e115                	bnez	a0,8000647e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000645c:	87ba                	mv	a5,a4
    8000645e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006462:	2781                	sext.w	a5,a5
    80006464:	ffe5                	bnez	a5,8000645c <acquire+0x22>
  __sync_synchronize();
    80006466:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000646a:	ffffb097          	auipc	ra,0xffffb
    8000646e:	b52080e7          	jalr	-1198(ra) # 80000fbc <mycpu>
    80006472:	e888                	sd	a0,16(s1)
}
    80006474:	60e2                	ld	ra,24(sp)
    80006476:	6442                	ld	s0,16(sp)
    80006478:	64a2                	ld	s1,8(sp)
    8000647a:	6105                	addi	sp,sp,32
    8000647c:	8082                	ret
    panic("acquire");
    8000647e:	00002517          	auipc	a0,0x2
    80006482:	61a50513          	addi	a0,a0,1562 # 80008a98 <digits+0x20>
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	aa6080e7          	jalr	-1370(ra) # 80005f2c <panic>

000000008000648e <pop_off>:

void
pop_off(void)
{
    8000648e:	1141                	addi	sp,sp,-16
    80006490:	e406                	sd	ra,8(sp)
    80006492:	e022                	sd	s0,0(sp)
    80006494:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006496:	ffffb097          	auipc	ra,0xffffb
    8000649a:	b26080e7          	jalr	-1242(ra) # 80000fbc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000649e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064a2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064a4:	e78d                	bnez	a5,800064ce <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064a6:	5d3c                	lw	a5,120(a0)
    800064a8:	02f05b63          	blez	a5,800064de <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064ac:	37fd                	addiw	a5,a5,-1
    800064ae:	0007871b          	sext.w	a4,a5
    800064b2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064b4:	eb09                	bnez	a4,800064c6 <pop_off+0x38>
    800064b6:	5d7c                	lw	a5,124(a0)
    800064b8:	c799                	beqz	a5,800064c6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064be:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064c2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064c6:	60a2                	ld	ra,8(sp)
    800064c8:	6402                	ld	s0,0(sp)
    800064ca:	0141                	addi	sp,sp,16
    800064cc:	8082                	ret
    panic("pop_off - interruptible");
    800064ce:	00002517          	auipc	a0,0x2
    800064d2:	5d250513          	addi	a0,a0,1490 # 80008aa0 <digits+0x28>
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	a56080e7          	jalr	-1450(ra) # 80005f2c <panic>
    panic("pop_off");
    800064de:	00002517          	auipc	a0,0x2
    800064e2:	5da50513          	addi	a0,a0,1498 # 80008ab8 <digits+0x40>
    800064e6:	00000097          	auipc	ra,0x0
    800064ea:	a46080e7          	jalr	-1466(ra) # 80005f2c <panic>

00000000800064ee <release>:
{
    800064ee:	1101                	addi	sp,sp,-32
    800064f0:	ec06                	sd	ra,24(sp)
    800064f2:	e822                	sd	s0,16(sp)
    800064f4:	e426                	sd	s1,8(sp)
    800064f6:	1000                	addi	s0,sp,32
    800064f8:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064fa:	00000097          	auipc	ra,0x0
    800064fe:	ec6080e7          	jalr	-314(ra) # 800063c0 <holding>
    80006502:	c115                	beqz	a0,80006526 <release+0x38>
  lk->cpu = 0;
    80006504:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006508:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000650c:	0f50000f          	fence	iorw,ow
    80006510:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006514:	00000097          	auipc	ra,0x0
    80006518:	f7a080e7          	jalr	-134(ra) # 8000648e <pop_off>
}
    8000651c:	60e2                	ld	ra,24(sp)
    8000651e:	6442                	ld	s0,16(sp)
    80006520:	64a2                	ld	s1,8(sp)
    80006522:	6105                	addi	sp,sp,32
    80006524:	8082                	ret
    panic("release");
    80006526:	00002517          	auipc	a0,0x2
    8000652a:	59a50513          	addi	a0,a0,1434 # 80008ac0 <digits+0x48>
    8000652e:	00000097          	auipc	ra,0x0
    80006532:	9fe080e7          	jalr	-1538(ra) # 80005f2c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
