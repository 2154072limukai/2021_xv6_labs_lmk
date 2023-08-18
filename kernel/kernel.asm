
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8b013103          	ld	sp,-1872(sp) # 800088b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	103050ef          	jal	ra,80005918 <start>

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
    80000030:	000b2797          	auipc	a5,0xb2
    80000034:	21078793          	addi	a5,a5,528 # 800b2240 <end>
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
    8000004c:	198080e7          	jalr	408(ra) # 800001e0 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2b8080e7          	jalr	696(ra) # 80006312 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	358080e7          	jalr	856(ra) # 800063c6 <release>
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
    8000008e:	d3e080e7          	jalr	-706(ra) # 80005dc8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7139                	addi	sp,sp,-64
    80000094:	fc06                	sd	ra,56(sp)
    80000096:	f822                	sd	s0,48(sp)
    80000098:	f426                	sd	s1,40(sp)
    8000009a:	f04a                	sd	s2,32(sp)
    8000009c:	ec4e                	sd	s3,24(sp)
    8000009e:	e852                	sd	s4,16(sp)
    800000a0:	e456                	sd	s5,8(sp)
    800000a2:	e05a                	sd	s6,0(sp)
    800000a4:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a6:	6785                	lui	a5,0x1
    800000a8:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000ac:	9526                	add	a0,a0,s1
    800000ae:	74fd                	lui	s1,0xfffff
    800000b0:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b2:	97a6                	add	a5,a5,s1
    800000b4:	04f5e663          	bltu	a1,a5,80000100 <freerange+0x6e>
    800000b8:	89ae                	mv	s3,a1
    acquire(&reflock);
    800000ba:	00009917          	auipc	s2,0x9
    800000be:	f9690913          	addi	s2,s2,-106 # 80009050 <reflock>
    referencecount[(uint64)p / PGSIZE] = 0;
    800000c2:	00009b17          	auipc	s6,0x9
    800000c6:	fa6b0b13          	addi	s6,s6,-90 # 80009068 <referencecount>
    800000ca:	6a85                	lui	s5,0x1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000cc:	6a09                	lui	s4,0x2
    acquire(&reflock);
    800000ce:	854a                	mv	a0,s2
    800000d0:	00006097          	auipc	ra,0x6
    800000d4:	242080e7          	jalr	578(ra) # 80006312 <acquire>
    referencecount[(uint64)p / PGSIZE] = 0;
    800000d8:	00c4d793          	srli	a5,s1,0xc
    800000dc:	97da                	add	a5,a5,s6
    800000de:	00078023          	sb	zero,0(a5)
    release(&reflock);
    800000e2:	854a                	mv	a0,s2
    800000e4:	00006097          	auipc	ra,0x6
    800000e8:	2e2080e7          	jalr	738(ra) # 800063c6 <release>
    kfree(p);
    800000ec:	8526                	mv	a0,s1
    800000ee:	00000097          	auipc	ra,0x0
    800000f2:	f2e080e7          	jalr	-210(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f6:	87a6                	mv	a5,s1
    800000f8:	94d6                	add	s1,s1,s5
    800000fa:	97d2                	add	a5,a5,s4
    800000fc:	fcf9f9e3          	bgeu	s3,a5,800000ce <freerange+0x3c>
}
    80000100:	70e2                	ld	ra,56(sp)
    80000102:	7442                	ld	s0,48(sp)
    80000104:	74a2                	ld	s1,40(sp)
    80000106:	7902                	ld	s2,32(sp)
    80000108:	69e2                	ld	s3,24(sp)
    8000010a:	6a42                	ld	s4,16(sp)
    8000010c:	6aa2                	ld	s5,8(sp)
    8000010e:	6b02                	ld	s6,0(sp)
    80000110:	6121                	addi	sp,sp,64
    80000112:	8082                	ret

0000000080000114 <kinit>:
{
    80000114:	1141                	addi	sp,sp,-16
    80000116:	e406                	sd	ra,8(sp)
    80000118:	e022                	sd	s0,0(sp)
    8000011a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000011c:	00008597          	auipc	a1,0x8
    80000120:	efc58593          	addi	a1,a1,-260 # 80008018 <etext+0x18>
    80000124:	00009517          	auipc	a0,0x9
    80000128:	f0c50513          	addi	a0,a0,-244 # 80009030 <kmem>
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	156080e7          	jalr	342(ra) # 80006282 <initlock>
  initlock(&reflock, "ref");
    80000134:	00008597          	auipc	a1,0x8
    80000138:	eec58593          	addi	a1,a1,-276 # 80008020 <etext+0x20>
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	f1450513          	addi	a0,a0,-236 # 80009050 <reflock>
    80000144:	00006097          	auipc	ra,0x6
    80000148:	13e080e7          	jalr	318(ra) # 80006282 <initlock>
  freerange(end, (void*)PHYSTOP);
    8000014c:	45c5                	li	a1,17
    8000014e:	05ee                	slli	a1,a1,0x1b
    80000150:	000b2517          	auipc	a0,0xb2
    80000154:	0f050513          	addi	a0,a0,240 # 800b2240 <end>
    80000158:	00000097          	auipc	ra,0x0
    8000015c:	f3a080e7          	jalr	-198(ra) # 80000092 <freerange>
}
    80000160:	60a2                	ld	ra,8(sp)
    80000162:	6402                	ld	s0,0(sp)
    80000164:	0141                	addi	sp,sp,16
    80000166:	8082                	ret

0000000080000168 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000168:	1101                	addi	sp,sp,-32
    8000016a:	ec06                	sd	ra,24(sp)
    8000016c:	e822                	sd	s0,16(sp)
    8000016e:	e426                	sd	s1,8(sp)
    80000170:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000172:	00009497          	auipc	s1,0x9
    80000176:	ebe48493          	addi	s1,s1,-322 # 80009030 <kmem>
    8000017a:	8526                	mv	a0,s1
    8000017c:	00006097          	auipc	ra,0x6
    80000180:	196080e7          	jalr	406(ra) # 80006312 <acquire>
  r = kmem.freelist;
    80000184:	6c84                	ld	s1,24(s1)
  if(r)
    80000186:	c4a1                	beqz	s1,800001ce <kalloc+0x66>
    kmem.freelist = r->next;
    80000188:	609c                	ld	a5,0(s1)
    8000018a:	00009517          	auipc	a0,0x9
    8000018e:	ea650513          	addi	a0,a0,-346 # 80009030 <kmem>
    80000192:	ed1c                	sd	a5,24(a0)
  if(r)
    referencecount[PGROUNDUP((uint64)r)/PGSIZE] = 1; 
    80000194:	6785                	lui	a5,0x1
    80000196:	17fd                	addi	a5,a5,-1
    80000198:	97a6                	add	a5,a5,s1
    8000019a:	83b1                	srli	a5,a5,0xc
    8000019c:	00009717          	auipc	a4,0x9
    800001a0:	ecc70713          	addi	a4,a4,-308 # 80009068 <referencecount>
    800001a4:	97ba                	add	a5,a5,a4
    800001a6:	4705                	li	a4,1
    800001a8:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
  
  release(&kmem.lock);
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	21a080e7          	jalr	538(ra) # 800063c6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001b4:	6605                	lui	a2,0x1
    800001b6:	4595                	li	a1,5
    800001b8:	8526                	mv	a0,s1
    800001ba:	00000097          	auipc	ra,0x0
    800001be:	026080e7          	jalr	38(ra) # 800001e0 <memset>
  return (void*)r;
}
    800001c2:	8526                	mv	a0,s1
    800001c4:	60e2                	ld	ra,24(sp)
    800001c6:	6442                	ld	s0,16(sp)
    800001c8:	64a2                	ld	s1,8(sp)
    800001ca:	6105                	addi	sp,sp,32
    800001cc:	8082                	ret
  release(&kmem.lock);
    800001ce:	00009517          	auipc	a0,0x9
    800001d2:	e6250513          	addi	a0,a0,-414 # 80009030 <kmem>
    800001d6:	00006097          	auipc	ra,0x6
    800001da:	1f0080e7          	jalr	496(ra) # 800063c6 <release>
  if(r)
    800001de:	b7d5                	j	800001c2 <kalloc+0x5a>

00000000800001e0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001e0:	1141                	addi	sp,sp,-16
    800001e2:	e422                	sd	s0,8(sp)
    800001e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001e6:	ce09                	beqz	a2,80000200 <memset+0x20>
    800001e8:	87aa                	mv	a5,a0
    800001ea:	fff6071b          	addiw	a4,a2,-1
    800001ee:	1702                	slli	a4,a4,0x20
    800001f0:	9301                	srli	a4,a4,0x20
    800001f2:	0705                	addi	a4,a4,1
    800001f4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	fee79de3          	bne	a5,a4,800001f6 <memset+0x16>
  }
  return dst;
}
    80000200:	6422                	ld	s0,8(sp)
    80000202:	0141                	addi	sp,sp,16
    80000204:	8082                	ret

0000000080000206 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e422                	sd	s0,8(sp)
    8000020a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000020c:	ca05                	beqz	a2,8000023c <memcmp+0x36>
    8000020e:	fff6069b          	addiw	a3,a2,-1
    80000212:	1682                	slli	a3,a3,0x20
    80000214:	9281                	srli	a3,a3,0x20
    80000216:	0685                	addi	a3,a3,1
    80000218:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000021a:	00054783          	lbu	a5,0(a0)
    8000021e:	0005c703          	lbu	a4,0(a1)
    80000222:	00e79863          	bne	a5,a4,80000232 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000226:	0505                	addi	a0,a0,1
    80000228:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000022a:	fed518e3          	bne	a0,a3,8000021a <memcmp+0x14>
  }

  return 0;
    8000022e:	4501                	li	a0,0
    80000230:	a019                	j	80000236 <memcmp+0x30>
      return *s1 - *s2;
    80000232:	40e7853b          	subw	a0,a5,a4
}
    80000236:	6422                	ld	s0,8(sp)
    80000238:	0141                	addi	sp,sp,16
    8000023a:	8082                	ret
  return 0;
    8000023c:	4501                	li	a0,0
    8000023e:	bfe5                	j	80000236 <memcmp+0x30>

0000000080000240 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e422                	sd	s0,8(sp)
    80000244:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000246:	ca0d                	beqz	a2,80000278 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000248:	00a5f963          	bgeu	a1,a0,8000025a <memmove+0x1a>
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	02e56463          	bltu	a0,a4,8000027e <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000025a:	fff6079b          	addiw	a5,a2,-1
    8000025e:	1782                	slli	a5,a5,0x20
    80000260:	9381                	srli	a5,a5,0x20
    80000262:	0785                	addi	a5,a5,1
    80000264:	97ae                	add	a5,a5,a1
    80000266:	872a                	mv	a4,a0
      *d++ = *s++;
    80000268:	0585                	addi	a1,a1,1
    8000026a:	0705                	addi	a4,a4,1
    8000026c:	fff5c683          	lbu	a3,-1(a1)
    80000270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000274:	fef59ae3          	bne	a1,a5,80000268 <memmove+0x28>

  return dst;
}
    80000278:	6422                	ld	s0,8(sp)
    8000027a:	0141                	addi	sp,sp,16
    8000027c:	8082                	ret
    d += n;
    8000027e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000280:	fff6079b          	addiw	a5,a2,-1
    80000284:	1782                	slli	a5,a5,0x20
    80000286:	9381                	srli	a5,a5,0x20
    80000288:	fff7c793          	not	a5,a5
    8000028c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000028e:	177d                	addi	a4,a4,-1
    80000290:	16fd                	addi	a3,a3,-1
    80000292:	00074603          	lbu	a2,0(a4)
    80000296:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000029a:	fef71ae3          	bne	a4,a5,8000028e <memmove+0x4e>
    8000029e:	bfe9                	j	80000278 <memmove+0x38>

00000000800002a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	f98080e7          	jalr	-104(ra) # 80000240 <memmove>
}
    800002b0:	60a2                	ld	ra,8(sp)
    800002b2:	6402                	ld	s0,0(sp)
    800002b4:	0141                	addi	sp,sp,16
    800002b6:	8082                	ret

00000000800002b8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002b8:	1141                	addi	sp,sp,-16
    800002ba:	e422                	sd	s0,8(sp)
    800002bc:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002be:	ce11                	beqz	a2,800002da <strncmp+0x22>
    800002c0:	00054783          	lbu	a5,0(a0)
    800002c4:	cf89                	beqz	a5,800002de <strncmp+0x26>
    800002c6:	0005c703          	lbu	a4,0(a1)
    800002ca:	00f71a63          	bne	a4,a5,800002de <strncmp+0x26>
    n--, p++, q++;
    800002ce:	367d                	addiw	a2,a2,-1
    800002d0:	0505                	addi	a0,a0,1
    800002d2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002d4:	f675                	bnez	a2,800002c0 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002d6:	4501                	li	a0,0
    800002d8:	a809                	j	800002ea <strncmp+0x32>
    800002da:	4501                	li	a0,0
    800002dc:	a039                	j	800002ea <strncmp+0x32>
  if(n == 0)
    800002de:	ca09                	beqz	a2,800002f0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002e0:	00054503          	lbu	a0,0(a0)
    800002e4:	0005c783          	lbu	a5,0(a1)
    800002e8:	9d1d                	subw	a0,a0,a5
}
    800002ea:	6422                	ld	s0,8(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret
    return 0;
    800002f0:	4501                	li	a0,0
    800002f2:	bfe5                	j	800002ea <strncmp+0x32>

00000000800002f4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002fa:	872a                	mv	a4,a0
    800002fc:	8832                	mv	a6,a2
    800002fe:	367d                	addiw	a2,a2,-1
    80000300:	01005963          	blez	a6,80000312 <strncpy+0x1e>
    80000304:	0705                	addi	a4,a4,1
    80000306:	0005c783          	lbu	a5,0(a1)
    8000030a:	fef70fa3          	sb	a5,-1(a4)
    8000030e:	0585                	addi	a1,a1,1
    80000310:	f7f5                	bnez	a5,800002fc <strncpy+0x8>
    ;
  while(n-- > 0)
    80000312:	00c05d63          	blez	a2,8000032c <strncpy+0x38>
    80000316:	86ba                	mv	a3,a4
    *s++ = 0;
    80000318:	0685                	addi	a3,a3,1
    8000031a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000031e:	fff6c793          	not	a5,a3
    80000322:	9fb9                	addw	a5,a5,a4
    80000324:	010787bb          	addw	a5,a5,a6
    80000328:	fef048e3          	bgtz	a5,80000318 <strncpy+0x24>
  return os;
}
    8000032c:	6422                	ld	s0,8(sp)
    8000032e:	0141                	addi	sp,sp,16
    80000330:	8082                	ret

0000000080000332 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000332:	1141                	addi	sp,sp,-16
    80000334:	e422                	sd	s0,8(sp)
    80000336:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000338:	02c05363          	blez	a2,8000035e <safestrcpy+0x2c>
    8000033c:	fff6069b          	addiw	a3,a2,-1
    80000340:	1682                	slli	a3,a3,0x20
    80000342:	9281                	srli	a3,a3,0x20
    80000344:	96ae                	add	a3,a3,a1
    80000346:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000348:	00d58963          	beq	a1,a3,8000035a <safestrcpy+0x28>
    8000034c:	0585                	addi	a1,a1,1
    8000034e:	0785                	addi	a5,a5,1
    80000350:	fff5c703          	lbu	a4,-1(a1)
    80000354:	fee78fa3          	sb	a4,-1(a5)
    80000358:	fb65                	bnez	a4,80000348 <safestrcpy+0x16>
    ;
  *s = 0;
    8000035a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000035e:	6422                	ld	s0,8(sp)
    80000360:	0141                	addi	sp,sp,16
    80000362:	8082                	ret

0000000080000364 <strlen>:

int
strlen(const char *s)
{
    80000364:	1141                	addi	sp,sp,-16
    80000366:	e422                	sd	s0,8(sp)
    80000368:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000036a:	00054783          	lbu	a5,0(a0)
    8000036e:	cf91                	beqz	a5,8000038a <strlen+0x26>
    80000370:	0505                	addi	a0,a0,1
    80000372:	87aa                	mv	a5,a0
    80000374:	4685                	li	a3,1
    80000376:	9e89                	subw	a3,a3,a0
    80000378:	00f6853b          	addw	a0,a3,a5
    8000037c:	0785                	addi	a5,a5,1
    8000037e:	fff7c703          	lbu	a4,-1(a5)
    80000382:	fb7d                	bnez	a4,80000378 <strlen+0x14>
    ;
  return n;
}
    80000384:	6422                	ld	s0,8(sp)
    80000386:	0141                	addi	sp,sp,16
    80000388:	8082                	ret
  for(n = 0; s[n]; n++)
    8000038a:	4501                	li	a0,0
    8000038c:	bfe5                	j	80000384 <strlen+0x20>

000000008000038e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000038e:	1141                	addi	sp,sp,-16
    80000390:	e406                	sd	ra,8(sp)
    80000392:	e022                	sd	s0,0(sp)
    80000394:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000396:	00001097          	auipc	ra,0x1
    8000039a:	c1c080e7          	jalr	-996(ra) # 80000fb2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000039e:	00009717          	auipc	a4,0x9
    800003a2:	c6270713          	addi	a4,a4,-926 # 80009000 <started>
  if(cpuid() == 0){
    800003a6:	c139                	beqz	a0,800003ec <main+0x5e>
    while(started == 0)
    800003a8:	431c                	lw	a5,0(a4)
    800003aa:	2781                	sext.w	a5,a5
    800003ac:	dff5                	beqz	a5,800003a8 <main+0x1a>
      ;
    __sync_synchronize();
    800003ae:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003b2:	00001097          	auipc	ra,0x1
    800003b6:	c00080e7          	jalr	-1024(ra) # 80000fb2 <cpuid>
    800003ba:	85aa                	mv	a1,a0
    800003bc:	00008517          	auipc	a0,0x8
    800003c0:	c8450513          	addi	a0,a0,-892 # 80008040 <etext+0x40>
    800003c4:	00006097          	auipc	ra,0x6
    800003c8:	a4e080e7          	jalr	-1458(ra) # 80005e12 <printf>
    kvminithart();    // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	0d8080e7          	jalr	216(ra) # 800004a4 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003d4:	00002097          	auipc	ra,0x2
    800003d8:	864080e7          	jalr	-1948(ra) # 80001c38 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003dc:	00005097          	auipc	ra,0x5
    800003e0:	ec4080e7          	jalr	-316(ra) # 800052a0 <plicinithart>
  }

  scheduler();        
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	112080e7          	jalr	274(ra) # 800014f6 <scheduler>
    consoleinit();
    800003ec:	00006097          	auipc	ra,0x6
    800003f0:	8ee080e7          	jalr	-1810(ra) # 80005cda <consoleinit>
    printfinit();
    800003f4:	00006097          	auipc	ra,0x6
    800003f8:	c04080e7          	jalr	-1020(ra) # 80005ff8 <printfinit>
    printf("\n");
    800003fc:	00008517          	auipc	a0,0x8
    80000400:	c5450513          	addi	a0,a0,-940 # 80008050 <etext+0x50>
    80000404:	00006097          	auipc	ra,0x6
    80000408:	a0e080e7          	jalr	-1522(ra) # 80005e12 <printf>
    printf("xv6 kernel is booting\n");
    8000040c:	00008517          	auipc	a0,0x8
    80000410:	c1c50513          	addi	a0,a0,-996 # 80008028 <etext+0x28>
    80000414:	00006097          	auipc	ra,0x6
    80000418:	9fe080e7          	jalr	-1538(ra) # 80005e12 <printf>
    printf("\n");
    8000041c:	00008517          	auipc	a0,0x8
    80000420:	c3450513          	addi	a0,a0,-972 # 80008050 <etext+0x50>
    80000424:	00006097          	auipc	ra,0x6
    80000428:	9ee080e7          	jalr	-1554(ra) # 80005e12 <printf>
    kinit();         // physical page allocator
    8000042c:	00000097          	auipc	ra,0x0
    80000430:	ce8080e7          	jalr	-792(ra) # 80000114 <kinit>
    kvminit();       // create kernel page table
    80000434:	00000097          	auipc	ra,0x0
    80000438:	322080e7          	jalr	802(ra) # 80000756 <kvminit>
    kvminithart();   // turn on paging
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	068080e7          	jalr	104(ra) # 800004a4 <kvminithart>
    procinit();      // process table
    80000444:	00001097          	auipc	ra,0x1
    80000448:	abe080e7          	jalr	-1346(ra) # 80000f02 <procinit>
    trapinit();      // trap vectors
    8000044c:	00001097          	auipc	ra,0x1
    80000450:	7c4080e7          	jalr	1988(ra) # 80001c10 <trapinit>
    trapinithart();  // install kernel trap vector
    80000454:	00001097          	auipc	ra,0x1
    80000458:	7e4080e7          	jalr	2020(ra) # 80001c38 <trapinithart>
    plicinit();      // set up interrupt controller
    8000045c:	00005097          	auipc	ra,0x5
    80000460:	e2e080e7          	jalr	-466(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000464:	00005097          	auipc	ra,0x5
    80000468:	e3c080e7          	jalr	-452(ra) # 800052a0 <plicinithart>
    binit();         // buffer cache
    8000046c:	00002097          	auipc	ra,0x2
    80000470:	022080e7          	jalr	34(ra) # 8000248e <binit>
    iinit();         // inode table
    80000474:	00002097          	auipc	ra,0x2
    80000478:	6b2080e7          	jalr	1714(ra) # 80002b26 <iinit>
    fileinit();      // file table
    8000047c:	00003097          	auipc	ra,0x3
    80000480:	65c080e7          	jalr	1628(ra) # 80003ad8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000484:	00005097          	auipc	ra,0x5
    80000488:	f3e080e7          	jalr	-194(ra) # 800053c2 <virtio_disk_init>
    userinit();      // first user process
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	e38080e7          	jalr	-456(ra) # 800012c4 <userinit>
    __sync_synchronize();
    80000494:	0ff0000f          	fence
    started = 1;
    80000498:	4785                	li	a5,1
    8000049a:	00009717          	auipc	a4,0x9
    8000049e:	b6f72323          	sw	a5,-1178(a4) # 80009000 <started>
    800004a2:	b789                	j	800003e4 <main+0x56>

00000000800004a4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800004a4:	1141                	addi	sp,sp,-16
    800004a6:	e422                	sd	s0,8(sp)
    800004a8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800004aa:	00009797          	auipc	a5,0x9
    800004ae:	b5e7b783          	ld	a5,-1186(a5) # 80009008 <kernel_pagetable>
    800004b2:	83b1                	srli	a5,a5,0xc
    800004b4:	577d                	li	a4,-1
    800004b6:	177e                	slli	a4,a4,0x3f
    800004b8:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800004ba:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004be:	12000073          	sfence.vma
  sfence_vma();
}
    800004c2:	6422                	ld	s0,8(sp)
    800004c4:	0141                	addi	sp,sp,16
    800004c6:	8082                	ret

00000000800004c8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004c8:	7139                	addi	sp,sp,-64
    800004ca:	fc06                	sd	ra,56(sp)
    800004cc:	f822                	sd	s0,48(sp)
    800004ce:	f426                	sd	s1,40(sp)
    800004d0:	f04a                	sd	s2,32(sp)
    800004d2:	ec4e                	sd	s3,24(sp)
    800004d4:	e852                	sd	s4,16(sp)
    800004d6:	e456                	sd	s5,8(sp)
    800004d8:	e05a                	sd	s6,0(sp)
    800004da:	0080                	addi	s0,sp,64
    800004dc:	84aa                	mv	s1,a0
    800004de:	89ae                	mv	s3,a1
    800004e0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004e2:	57fd                	li	a5,-1
    800004e4:	83e9                	srli	a5,a5,0x1a
    800004e6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004e8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004ea:	04b7f263          	bgeu	a5,a1,8000052e <walk+0x66>
    panic("walk");
    800004ee:	00008517          	auipc	a0,0x8
    800004f2:	b6a50513          	addi	a0,a0,-1174 # 80008058 <etext+0x58>
    800004f6:	00006097          	auipc	ra,0x6
    800004fa:	8d2080e7          	jalr	-1838(ra) # 80005dc8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004fe:	060a8663          	beqz	s5,8000056a <walk+0xa2>
    80000502:	00000097          	auipc	ra,0x0
    80000506:	c66080e7          	jalr	-922(ra) # 80000168 <kalloc>
    8000050a:	84aa                	mv	s1,a0
    8000050c:	c529                	beqz	a0,80000556 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000050e:	6605                	lui	a2,0x1
    80000510:	4581                	li	a1,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	cce080e7          	jalr	-818(ra) # 800001e0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000051a:	00c4d793          	srli	a5,s1,0xc
    8000051e:	07aa                	slli	a5,a5,0xa
    80000520:	0017e793          	ori	a5,a5,1
    80000524:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000528:	3a5d                	addiw	s4,s4,-9
    8000052a:	036a0063          	beq	s4,s6,8000054a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000052e:	0149d933          	srl	s2,s3,s4
    80000532:	1ff97913          	andi	s2,s2,511
    80000536:	090e                	slli	s2,s2,0x3
    80000538:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000053a:	00093483          	ld	s1,0(s2)
    8000053e:	0014f793          	andi	a5,s1,1
    80000542:	dfd5                	beqz	a5,800004fe <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000544:	80a9                	srli	s1,s1,0xa
    80000546:	04b2                	slli	s1,s1,0xc
    80000548:	b7c5                	j	80000528 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000054a:	00c9d513          	srli	a0,s3,0xc
    8000054e:	1ff57513          	andi	a0,a0,511
    80000552:	050e                	slli	a0,a0,0x3
    80000554:	9526                	add	a0,a0,s1
}
    80000556:	70e2                	ld	ra,56(sp)
    80000558:	7442                	ld	s0,48(sp)
    8000055a:	74a2                	ld	s1,40(sp)
    8000055c:	7902                	ld	s2,32(sp)
    8000055e:	69e2                	ld	s3,24(sp)
    80000560:	6a42                	ld	s4,16(sp)
    80000562:	6aa2                	ld	s5,8(sp)
    80000564:	6b02                	ld	s6,0(sp)
    80000566:	6121                	addi	sp,sp,64
    80000568:	8082                	ret
        return 0;
    8000056a:	4501                	li	a0,0
    8000056c:	b7ed                	j	80000556 <walk+0x8e>

000000008000056e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000056e:	57fd                	li	a5,-1
    80000570:	83e9                	srli	a5,a5,0x1a
    80000572:	00b7f463          	bgeu	a5,a1,8000057a <walkaddr+0xc>
    return 0;
    80000576:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000578:	8082                	ret
{
    8000057a:	1141                	addi	sp,sp,-16
    8000057c:	e406                	sd	ra,8(sp)
    8000057e:	e022                	sd	s0,0(sp)
    80000580:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000582:	4601                	li	a2,0
    80000584:	00000097          	auipc	ra,0x0
    80000588:	f44080e7          	jalr	-188(ra) # 800004c8 <walk>
  if(pte == 0)
    8000058c:	c105                	beqz	a0,800005ac <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000058e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000590:	0117f693          	andi	a3,a5,17
    80000594:	4745                	li	a4,17
    return 0;
    80000596:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000598:	00e68663          	beq	a3,a4,800005a4 <walkaddr+0x36>
}
    8000059c:	60a2                	ld	ra,8(sp)
    8000059e:	6402                	ld	s0,0(sp)
    800005a0:	0141                	addi	sp,sp,16
    800005a2:	8082                	ret
  pa = PTE2PA(*pte);
    800005a4:	00a7d513          	srli	a0,a5,0xa
    800005a8:	0532                	slli	a0,a0,0xc
  return pa;
    800005aa:	bfcd                	j	8000059c <walkaddr+0x2e>
    return 0;
    800005ac:	4501                	li	a0,0
    800005ae:	b7fd                	j	8000059c <walkaddr+0x2e>

00000000800005b0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005b0:	715d                	addi	sp,sp,-80
    800005b2:	e486                	sd	ra,72(sp)
    800005b4:	e0a2                	sd	s0,64(sp)
    800005b6:	fc26                	sd	s1,56(sp)
    800005b8:	f84a                	sd	s2,48(sp)
    800005ba:	f44e                	sd	s3,40(sp)
    800005bc:	f052                	sd	s4,32(sp)
    800005be:	ec56                	sd	s5,24(sp)
    800005c0:	e85a                	sd	s6,16(sp)
    800005c2:	e45e                	sd	s7,8(sp)
    800005c4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005c6:	c205                	beqz	a2,800005e6 <mappages+0x36>
    800005c8:	8aaa                	mv	s5,a0
    800005ca:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005cc:	77fd                	lui	a5,0xfffff
    800005ce:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005d2:	15fd                	addi	a1,a1,-1
    800005d4:	00c589b3          	add	s3,a1,a2
    800005d8:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005dc:	8952                	mv	s2,s4
    800005de:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005e2:	6b85                	lui	s7,0x1
    800005e4:	a015                	j	80000608 <mappages+0x58>
    panic("mappages: size");
    800005e6:	00008517          	auipc	a0,0x8
    800005ea:	a7a50513          	addi	a0,a0,-1414 # 80008060 <etext+0x60>
    800005ee:	00005097          	auipc	ra,0x5
    800005f2:	7da080e7          	jalr	2010(ra) # 80005dc8 <panic>
      panic("mappages: remap");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a7a50513          	addi	a0,a0,-1414 # 80008070 <etext+0x70>
    800005fe:	00005097          	auipc	ra,0x5
    80000602:	7ca080e7          	jalr	1994(ra) # 80005dc8 <panic>
    a += PGSIZE;
    80000606:	995e                	add	s2,s2,s7
  for(;;){
    80000608:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000060c:	4605                	li	a2,1
    8000060e:	85ca                	mv	a1,s2
    80000610:	8556                	mv	a0,s5
    80000612:	00000097          	auipc	ra,0x0
    80000616:	eb6080e7          	jalr	-330(ra) # 800004c8 <walk>
    8000061a:	cd19                	beqz	a0,80000638 <mappages+0x88>
    if(*pte & PTE_V)
    8000061c:	611c                	ld	a5,0(a0)
    8000061e:	8b85                	andi	a5,a5,1
    80000620:	fbf9                	bnez	a5,800005f6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000622:	80b1                	srli	s1,s1,0xc
    80000624:	04aa                	slli	s1,s1,0xa
    80000626:	0164e4b3          	or	s1,s1,s6
    8000062a:	0014e493          	ori	s1,s1,1
    8000062e:	e104                	sd	s1,0(a0)
    if(a == last)
    80000630:	fd391be3          	bne	s2,s3,80000606 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000634:	4501                	li	a0,0
    80000636:	a011                	j	8000063a <mappages+0x8a>
      return -1;
    80000638:	557d                	li	a0,-1
}
    8000063a:	60a6                	ld	ra,72(sp)
    8000063c:	6406                	ld	s0,64(sp)
    8000063e:	74e2                	ld	s1,56(sp)
    80000640:	7942                	ld	s2,48(sp)
    80000642:	79a2                	ld	s3,40(sp)
    80000644:	7a02                	ld	s4,32(sp)
    80000646:	6ae2                	ld	s5,24(sp)
    80000648:	6b42                	ld	s6,16(sp)
    8000064a:	6ba2                	ld	s7,8(sp)
    8000064c:	6161                	addi	sp,sp,80
    8000064e:	8082                	ret

0000000080000650 <kvmmap>:
{
    80000650:	1141                	addi	sp,sp,-16
    80000652:	e406                	sd	ra,8(sp)
    80000654:	e022                	sd	s0,0(sp)
    80000656:	0800                	addi	s0,sp,16
    80000658:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000065a:	86b2                	mv	a3,a2
    8000065c:	863e                	mv	a2,a5
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f52080e7          	jalr	-174(ra) # 800005b0 <mappages>
    80000666:	e509                	bnez	a0,80000670 <kvmmap+0x20>
}
    80000668:	60a2                	ld	ra,8(sp)
    8000066a:	6402                	ld	s0,0(sp)
    8000066c:	0141                	addi	sp,sp,16
    8000066e:	8082                	ret
    panic("kvmmap");
    80000670:	00008517          	auipc	a0,0x8
    80000674:	a1050513          	addi	a0,a0,-1520 # 80008080 <etext+0x80>
    80000678:	00005097          	auipc	ra,0x5
    8000067c:	750080e7          	jalr	1872(ra) # 80005dc8 <panic>

0000000080000680 <kvmmake>:
{
    80000680:	1101                	addi	sp,sp,-32
    80000682:	ec06                	sd	ra,24(sp)
    80000684:	e822                	sd	s0,16(sp)
    80000686:	e426                	sd	s1,8(sp)
    80000688:	e04a                	sd	s2,0(sp)
    8000068a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	adc080e7          	jalr	-1316(ra) # 80000168 <kalloc>
    80000694:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000696:	6605                	lui	a2,0x1
    80000698:	4581                	li	a1,0
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	b46080e7          	jalr	-1210(ra) # 800001e0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	6685                	lui	a3,0x1
    800006a6:	10000637          	lui	a2,0x10000
    800006aa:	100005b7          	lui	a1,0x10000
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	fa0080e7          	jalr	-96(ra) # 80000650 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006b8:	4719                	li	a4,6
    800006ba:	6685                	lui	a3,0x1
    800006bc:	10001637          	lui	a2,0x10001
    800006c0:	100015b7          	lui	a1,0x10001
    800006c4:	8526                	mv	a0,s1
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f8a080e7          	jalr	-118(ra) # 80000650 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ce:	4719                	li	a4,6
    800006d0:	004006b7          	lui	a3,0x400
    800006d4:	0c000637          	lui	a2,0xc000
    800006d8:	0c0005b7          	lui	a1,0xc000
    800006dc:	8526                	mv	a0,s1
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	f72080e7          	jalr	-142(ra) # 80000650 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006e6:	00008917          	auipc	s2,0x8
    800006ea:	91a90913          	addi	s2,s2,-1766 # 80008000 <etext>
    800006ee:	4729                	li	a4,10
    800006f0:	80008697          	auipc	a3,0x80008
    800006f4:	91068693          	addi	a3,a3,-1776 # 8000 <_entry-0x7fff8000>
    800006f8:	4605                	li	a2,1
    800006fa:	067e                	slli	a2,a2,0x1f
    800006fc:	85b2                	mv	a1,a2
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	f50080e7          	jalr	-176(ra) # 80000650 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000708:	4719                	li	a4,6
    8000070a:	46c5                	li	a3,17
    8000070c:	06ee                	slli	a3,a3,0x1b
    8000070e:	412686b3          	sub	a3,a3,s2
    80000712:	864a                	mv	a2,s2
    80000714:	85ca                	mv	a1,s2
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f38080e7          	jalr	-200(ra) # 80000650 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000720:	4729                	li	a4,10
    80000722:	6685                	lui	a3,0x1
    80000724:	00007617          	auipc	a2,0x7
    80000728:	8dc60613          	addi	a2,a2,-1828 # 80007000 <_trampoline>
    8000072c:	040005b7          	lui	a1,0x4000
    80000730:	15fd                	addi	a1,a1,-1
    80000732:	05b2                	slli	a1,a1,0xc
    80000734:	8526                	mv	a0,s1
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	f1a080e7          	jalr	-230(ra) # 80000650 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000073e:	8526                	mv	a0,s1
    80000740:	00000097          	auipc	ra,0x0
    80000744:	72c080e7          	jalr	1836(ra) # 80000e6c <proc_mapstacks>
}
    80000748:	8526                	mv	a0,s1
    8000074a:	60e2                	ld	ra,24(sp)
    8000074c:	6442                	ld	s0,16(sp)
    8000074e:	64a2                	ld	s1,8(sp)
    80000750:	6902                	ld	s2,0(sp)
    80000752:	6105                	addi	sp,sp,32
    80000754:	8082                	ret

0000000080000756 <kvminit>:
{
    80000756:	1141                	addi	sp,sp,-16
    80000758:	e406                	sd	ra,8(sp)
    8000075a:	e022                	sd	s0,0(sp)
    8000075c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	f22080e7          	jalr	-222(ra) # 80000680 <kvmmake>
    80000766:	00009797          	auipc	a5,0x9
    8000076a:	8aa7b123          	sd	a0,-1886(a5) # 80009008 <kernel_pagetable>
}
    8000076e:	60a2                	ld	ra,8(sp)
    80000770:	6402                	ld	s0,0(sp)
    80000772:	0141                	addi	sp,sp,16
    80000774:	8082                	ret

0000000080000776 <uvmunmap>:
// Optionally free the physical memory.
extern struct spinlock reflock;
extern uint8 referencecount[PHYSTOP/PGSIZE];
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000776:	711d                	addi	sp,sp,-96
    80000778:	ec86                	sd	ra,88(sp)
    8000077a:	e8a2                	sd	s0,80(sp)
    8000077c:	e4a6                	sd	s1,72(sp)
    8000077e:	e0ca                	sd	s2,64(sp)
    80000780:	fc4e                	sd	s3,56(sp)
    80000782:	f852                	sd	s4,48(sp)
    80000784:	f456                	sd	s5,40(sp)
    80000786:	f05a                	sd	s6,32(sp)
    80000788:	ec5e                	sd	s7,24(sp)
    8000078a:	e862                	sd	s8,16(sp)
    8000078c:	e466                	sd	s9,8(sp)
    8000078e:	e06a                	sd	s10,0(sp)
    80000790:	1080                	addi	s0,sp,96
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000792:	03459793          	slli	a5,a1,0x34
    80000796:	e795                	bnez	a5,800007c2 <uvmunmap+0x4c>
    80000798:	8baa                	mv	s7,a0
    8000079a:	892e                	mv	s2,a1
    8000079c:	8c36                	mv	s8,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000079e:	0632                	slli	a2,a2,0xc
    800007a0:	00b60b33          	add	s6,a2,a1
    800007a4:	0d65fb63          	bgeu	a1,s6,8000087a <uvmunmap+0x104>
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a8:	4d05                	li	s10,1
      panic("uvmunmap: not a leaf");
    acquire(&reflock);
    800007aa:	00009997          	auipc	s3,0x9
    800007ae:	8a698993          	addi	s3,s3,-1882 # 80009050 <reflock>
    referencecount[PGROUNDUP((PTE2PA(*pte)))/PGSIZE]--;
    800007b2:	6c85                	lui	s9,0x1
    800007b4:	fffc8a93          	addi	s5,s9,-1 # fff <_entry-0x7ffff001>
    800007b8:	00009a17          	auipc	s4,0x9
    800007bc:	8b0a0a13          	addi	s4,s4,-1872 # 80009068 <referencecount>
    800007c0:	a8b9                	j	8000081e <uvmunmap+0xa8>
    panic("uvmunmap: not aligned");
    800007c2:	00008517          	auipc	a0,0x8
    800007c6:	8c650513          	addi	a0,a0,-1850 # 80008088 <etext+0x88>
    800007ca:	00005097          	auipc	ra,0x5
    800007ce:	5fe080e7          	jalr	1534(ra) # 80005dc8 <panic>
      panic("uvmunmap: walk");
    800007d2:	00008517          	auipc	a0,0x8
    800007d6:	8ce50513          	addi	a0,a0,-1842 # 800080a0 <etext+0xa0>
    800007da:	00005097          	auipc	ra,0x5
    800007de:	5ee080e7          	jalr	1518(ra) # 80005dc8 <panic>
      panic("uvmunmap: not mapped");
    800007e2:	00008517          	auipc	a0,0x8
    800007e6:	8ce50513          	addi	a0,a0,-1842 # 800080b0 <etext+0xb0>
    800007ea:	00005097          	auipc	ra,0x5
    800007ee:	5de080e7          	jalr	1502(ra) # 80005dc8 <panic>
      panic("uvmunmap: not a leaf");
    800007f2:	00008517          	auipc	a0,0x8
    800007f6:	8d650513          	addi	a0,a0,-1834 # 800080c8 <etext+0xc8>
    800007fa:	00005097          	auipc	ra,0x5
    800007fe:	5ce080e7          	jalr	1486(ra) # 80005dc8 <panic>
    if(do_free && referencecount[PGROUNDUP((PTE2PA(*pte)))/PGSIZE] < 1){
    // if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    80000802:	00000097          	auipc	ra,0x0
    80000806:	81a080e7          	jalr	-2022(ra) # 8000001c <kfree>
    }
    release(&reflock);
    8000080a:	854e                	mv	a0,s3
    8000080c:	00006097          	auipc	ra,0x6
    80000810:	bba080e7          	jalr	-1094(ra) # 800063c6 <release>
    *pte = 0;
    80000814:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000818:	9966                	add	s2,s2,s9
    8000081a:	07697063          	bgeu	s2,s6,8000087a <uvmunmap+0x104>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000081e:	4601                	li	a2,0
    80000820:	85ca                	mv	a1,s2
    80000822:	855e                	mv	a0,s7
    80000824:	00000097          	auipc	ra,0x0
    80000828:	ca4080e7          	jalr	-860(ra) # 800004c8 <walk>
    8000082c:	84aa                	mv	s1,a0
    8000082e:	d155                	beqz	a0,800007d2 <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)
    80000830:	611c                	ld	a5,0(a0)
    80000832:	0017f713          	andi	a4,a5,1
    80000836:	d755                	beqz	a4,800007e2 <uvmunmap+0x6c>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000838:	3ff7f793          	andi	a5,a5,1023
    8000083c:	fba78be3          	beq	a5,s10,800007f2 <uvmunmap+0x7c>
    acquire(&reflock);
    80000840:	854e                	mv	a0,s3
    80000842:	00006097          	auipc	ra,0x6
    80000846:	ad0080e7          	jalr	-1328(ra) # 80006312 <acquire>
    referencecount[PGROUNDUP((PTE2PA(*pte)))/PGSIZE]--;
    8000084a:	609c                	ld	a5,0(s1)
    8000084c:	83a9                	srli	a5,a5,0xa
    8000084e:	07b2                	slli	a5,a5,0xc
    80000850:	97d6                	add	a5,a5,s5
    80000852:	83b1                	srli	a5,a5,0xc
    80000854:	97d2                	add	a5,a5,s4
    80000856:	0007c703          	lbu	a4,0(a5)
    8000085a:	377d                	addiw	a4,a4,-1
    8000085c:	00e78023          	sb	a4,0(a5)
    if(do_free && referencecount[PGROUNDUP((PTE2PA(*pte)))/PGSIZE] < 1){
    80000860:	fa0c05e3          	beqz	s8,8000080a <uvmunmap+0x94>
    80000864:	6088                	ld	a0,0(s1)
    80000866:	8129                	srli	a0,a0,0xa
    80000868:	0532                	slli	a0,a0,0xc
    8000086a:	015507b3          	add	a5,a0,s5
    8000086e:	83b1                	srli	a5,a5,0xc
    80000870:	97d2                	add	a5,a5,s4
    80000872:	0007c783          	lbu	a5,0(a5)
    80000876:	fbd1                	bnez	a5,8000080a <uvmunmap+0x94>
    80000878:	b769                	j	80000802 <uvmunmap+0x8c>
  }
}
    8000087a:	60e6                	ld	ra,88(sp)
    8000087c:	6446                	ld	s0,80(sp)
    8000087e:	64a6                	ld	s1,72(sp)
    80000880:	6906                	ld	s2,64(sp)
    80000882:	79e2                	ld	s3,56(sp)
    80000884:	7a42                	ld	s4,48(sp)
    80000886:	7aa2                	ld	s5,40(sp)
    80000888:	7b02                	ld	s6,32(sp)
    8000088a:	6be2                	ld	s7,24(sp)
    8000088c:	6c42                	ld	s8,16(sp)
    8000088e:	6ca2                	ld	s9,8(sp)
    80000890:	6d02                	ld	s10,0(sp)
    80000892:	6125                	addi	sp,sp,96
    80000894:	8082                	ret

0000000080000896 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000896:	1101                	addi	sp,sp,-32
    80000898:	ec06                	sd	ra,24(sp)
    8000089a:	e822                	sd	s0,16(sp)
    8000089c:	e426                	sd	s1,8(sp)
    8000089e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	8c8080e7          	jalr	-1848(ra) # 80000168 <kalloc>
    800008a8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008aa:	c519                	beqz	a0,800008b8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008ac:	6605                	lui	a2,0x1
    800008ae:	4581                	li	a1,0
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	930080e7          	jalr	-1744(ra) # 800001e0 <memset>
  return pagetable;
}
    800008b8:	8526                	mv	a0,s1
    800008ba:	60e2                	ld	ra,24(sp)
    800008bc:	6442                	ld	s0,16(sp)
    800008be:	64a2                	ld	s1,8(sp)
    800008c0:	6105                	addi	sp,sp,32
    800008c2:	8082                	ret

00000000800008c4 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008c4:	7179                	addi	sp,sp,-48
    800008c6:	f406                	sd	ra,40(sp)
    800008c8:	f022                	sd	s0,32(sp)
    800008ca:	ec26                	sd	s1,24(sp)
    800008cc:	e84a                	sd	s2,16(sp)
    800008ce:	e44e                	sd	s3,8(sp)
    800008d0:	e052                	sd	s4,0(sp)
    800008d2:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800008d4:	6785                	lui	a5,0x1
    800008d6:	04f67863          	bgeu	a2,a5,80000926 <uvminit+0x62>
    800008da:	8a2a                	mv	s4,a0
    800008dc:	89ae                	mv	s3,a1
    800008de:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	888080e7          	jalr	-1912(ra) # 80000168 <kalloc>
    800008e8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	8f2080e7          	jalr	-1806(ra) # 800001e0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008f6:	4779                	li	a4,30
    800008f8:	86ca                	mv	a3,s2
    800008fa:	6605                	lui	a2,0x1
    800008fc:	4581                	li	a1,0
    800008fe:	8552                	mv	a0,s4
    80000900:	00000097          	auipc	ra,0x0
    80000904:	cb0080e7          	jalr	-848(ra) # 800005b0 <mappages>
  memmove(mem, src, sz);
    80000908:	8626                	mv	a2,s1
    8000090a:	85ce                	mv	a1,s3
    8000090c:	854a                	mv	a0,s2
    8000090e:	00000097          	auipc	ra,0x0
    80000912:	932080e7          	jalr	-1742(ra) # 80000240 <memmove>
}
    80000916:	70a2                	ld	ra,40(sp)
    80000918:	7402                	ld	s0,32(sp)
    8000091a:	64e2                	ld	s1,24(sp)
    8000091c:	6942                	ld	s2,16(sp)
    8000091e:	69a2                	ld	s3,8(sp)
    80000920:	6a02                	ld	s4,0(sp)
    80000922:	6145                	addi	sp,sp,48
    80000924:	8082                	ret
    panic("inituvm: more than a page");
    80000926:	00007517          	auipc	a0,0x7
    8000092a:	7ba50513          	addi	a0,a0,1978 # 800080e0 <etext+0xe0>
    8000092e:	00005097          	auipc	ra,0x5
    80000932:	49a080e7          	jalr	1178(ra) # 80005dc8 <panic>

0000000080000936 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000936:	1101                	addi	sp,sp,-32
    80000938:	ec06                	sd	ra,24(sp)
    8000093a:	e822                	sd	s0,16(sp)
    8000093c:	e426                	sd	s1,8(sp)
    8000093e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000940:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000942:	00b67d63          	bgeu	a2,a1,8000095c <uvmdealloc+0x26>
    80000946:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000948:	6785                	lui	a5,0x1
    8000094a:	17fd                	addi	a5,a5,-1
    8000094c:	00f60733          	add	a4,a2,a5
    80000950:	767d                	lui	a2,0xfffff
    80000952:	8f71                	and	a4,a4,a2
    80000954:	97ae                	add	a5,a5,a1
    80000956:	8ff1                	and	a5,a5,a2
    80000958:	00f76863          	bltu	a4,a5,80000968 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000095c:	8526                	mv	a0,s1
    8000095e:	60e2                	ld	ra,24(sp)
    80000960:	6442                	ld	s0,16(sp)
    80000962:	64a2                	ld	s1,8(sp)
    80000964:	6105                	addi	sp,sp,32
    80000966:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000968:	8f99                	sub	a5,a5,a4
    8000096a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000096c:	4685                	li	a3,1
    8000096e:	0007861b          	sext.w	a2,a5
    80000972:	85ba                	mv	a1,a4
    80000974:	00000097          	auipc	ra,0x0
    80000978:	e02080e7          	jalr	-510(ra) # 80000776 <uvmunmap>
    8000097c:	b7c5                	j	8000095c <uvmdealloc+0x26>

000000008000097e <uvmalloc>:
  if(newsz < oldsz)
    8000097e:	0ab66163          	bltu	a2,a1,80000a20 <uvmalloc+0xa2>
{
    80000982:	7139                	addi	sp,sp,-64
    80000984:	fc06                	sd	ra,56(sp)
    80000986:	f822                	sd	s0,48(sp)
    80000988:	f426                	sd	s1,40(sp)
    8000098a:	f04a                	sd	s2,32(sp)
    8000098c:	ec4e                	sd	s3,24(sp)
    8000098e:	e852                	sd	s4,16(sp)
    80000990:	e456                	sd	s5,8(sp)
    80000992:	0080                	addi	s0,sp,64
    80000994:	8aaa                	mv	s5,a0
    80000996:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000998:	6985                	lui	s3,0x1
    8000099a:	19fd                	addi	s3,s3,-1
    8000099c:	95ce                	add	a1,a1,s3
    8000099e:	79fd                	lui	s3,0xfffff
    800009a0:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009a4:	08c9f063          	bgeu	s3,a2,80000a24 <uvmalloc+0xa6>
    800009a8:	894e                	mv	s2,s3
    mem = kalloc();
    800009aa:	fffff097          	auipc	ra,0xfffff
    800009ae:	7be080e7          	jalr	1982(ra) # 80000168 <kalloc>
    800009b2:	84aa                	mv	s1,a0
    if(mem == 0){
    800009b4:	c51d                	beqz	a0,800009e2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009b6:	6605                	lui	a2,0x1
    800009b8:	4581                	li	a1,0
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	826080e7          	jalr	-2010(ra) # 800001e0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009c2:	4779                	li	a4,30
    800009c4:	86a6                	mv	a3,s1
    800009c6:	6605                	lui	a2,0x1
    800009c8:	85ca                	mv	a1,s2
    800009ca:	8556                	mv	a0,s5
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	be4080e7          	jalr	-1052(ra) # 800005b0 <mappages>
    800009d4:	e905                	bnez	a0,80000a04 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009d6:	6785                	lui	a5,0x1
    800009d8:	993e                	add	s2,s2,a5
    800009da:	fd4968e3          	bltu	s2,s4,800009aa <uvmalloc+0x2c>
  return newsz;
    800009de:	8552                	mv	a0,s4
    800009e0:	a809                	j	800009f2 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800009e2:	864e                	mv	a2,s3
    800009e4:	85ca                	mv	a1,s2
    800009e6:	8556                	mv	a0,s5
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	f4e080e7          	jalr	-178(ra) # 80000936 <uvmdealloc>
      return 0;
    800009f0:	4501                	li	a0,0
}
    800009f2:	70e2                	ld	ra,56(sp)
    800009f4:	7442                	ld	s0,48(sp)
    800009f6:	74a2                	ld	s1,40(sp)
    800009f8:	7902                	ld	s2,32(sp)
    800009fa:	69e2                	ld	s3,24(sp)
    800009fc:	6a42                	ld	s4,16(sp)
    800009fe:	6aa2                	ld	s5,8(sp)
    80000a00:	6121                	addi	sp,sp,64
    80000a02:	8082                	ret
      kfree(mem);
    80000a04:	8526                	mv	a0,s1
    80000a06:	fffff097          	auipc	ra,0xfffff
    80000a0a:	616080e7          	jalr	1558(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a0e:	864e                	mv	a2,s3
    80000a10:	85ca                	mv	a1,s2
    80000a12:	8556                	mv	a0,s5
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	f22080e7          	jalr	-222(ra) # 80000936 <uvmdealloc>
      return 0;
    80000a1c:	4501                	li	a0,0
    80000a1e:	bfd1                	j	800009f2 <uvmalloc+0x74>
    return oldsz;
    80000a20:	852e                	mv	a0,a1
}
    80000a22:	8082                	ret
  return newsz;
    80000a24:	8532                	mv	a0,a2
    80000a26:	b7f1                	j	800009f2 <uvmalloc+0x74>

0000000080000a28 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a28:	7179                	addi	sp,sp,-48
    80000a2a:	f406                	sd	ra,40(sp)
    80000a2c:	f022                	sd	s0,32(sp)
    80000a2e:	ec26                	sd	s1,24(sp)
    80000a30:	e84a                	sd	s2,16(sp)
    80000a32:	e44e                	sd	s3,8(sp)
    80000a34:	e052                	sd	s4,0(sp)
    80000a36:	1800                	addi	s0,sp,48
    80000a38:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a3a:	84aa                	mv	s1,a0
    80000a3c:	6905                	lui	s2,0x1
    80000a3e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a40:	4985                	li	s3,1
    80000a42:	a821                	j	80000a5a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a44:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a46:	0532                	slli	a0,a0,0xc
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	fe0080e7          	jalr	-32(ra) # 80000a28 <freewalk>
      pagetable[i] = 0;
    80000a50:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a54:	04a1                	addi	s1,s1,8
    80000a56:	03248163          	beq	s1,s2,80000a78 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a5a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a5c:	00f57793          	andi	a5,a0,15
    80000a60:	ff3782e3          	beq	a5,s3,80000a44 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a64:	8905                	andi	a0,a0,1
    80000a66:	d57d                	beqz	a0,80000a54 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a68:	00007517          	auipc	a0,0x7
    80000a6c:	69850513          	addi	a0,a0,1688 # 80008100 <etext+0x100>
    80000a70:	00005097          	auipc	ra,0x5
    80000a74:	358080e7          	jalr	856(ra) # 80005dc8 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a78:	8552                	mv	a0,s4
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	5a2080e7          	jalr	1442(ra) # 8000001c <kfree>
}
    80000a82:	70a2                	ld	ra,40(sp)
    80000a84:	7402                	ld	s0,32(sp)
    80000a86:	64e2                	ld	s1,24(sp)
    80000a88:	6942                	ld	s2,16(sp)
    80000a8a:	69a2                	ld	s3,8(sp)
    80000a8c:	6a02                	ld	s4,0(sp)
    80000a8e:	6145                	addi	sp,sp,48
    80000a90:	8082                	ret

0000000080000a92 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a92:	1101                	addi	sp,sp,-32
    80000a94:	ec06                	sd	ra,24(sp)
    80000a96:	e822                	sd	s0,16(sp)
    80000a98:	e426                	sd	s1,8(sp)
    80000a9a:	1000                	addi	s0,sp,32
    80000a9c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a9e:	e999                	bnez	a1,80000ab4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000aa0:	8526                	mv	a0,s1
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	f86080e7          	jalr	-122(ra) # 80000a28 <freewalk>
}
    80000aaa:	60e2                	ld	ra,24(sp)
    80000aac:	6442                	ld	s0,16(sp)
    80000aae:	64a2                	ld	s1,8(sp)
    80000ab0:	6105                	addi	sp,sp,32
    80000ab2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ab4:	6605                	lui	a2,0x1
    80000ab6:	167d                	addi	a2,a2,-1
    80000ab8:	962e                	add	a2,a2,a1
    80000aba:	4685                	li	a3,1
    80000abc:	8231                	srli	a2,a2,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	cb6080e7          	jalr	-842(ra) # 80000776 <uvmunmap>
    80000ac8:	bfe1                	j	80000aa0 <uvmfree+0xe>

0000000080000aca <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000aca:	711d                	addi	sp,sp,-96
    80000acc:	ec86                	sd	ra,88(sp)
    80000ace:	e8a2                	sd	s0,80(sp)
    80000ad0:	e4a6                	sd	s1,72(sp)
    80000ad2:	e0ca                	sd	s2,64(sp)
    80000ad4:	fc4e                	sd	s3,56(sp)
    80000ad6:	f852                	sd	s4,48(sp)
    80000ad8:	f456                	sd	s5,40(sp)
    80000ada:	f05a                	sd	s6,32(sp)
    80000adc:	ec5e                	sd	s7,24(sp)
    80000ade:	e862                	sd	s8,16(sp)
    80000ae0:	e466                	sd	s9,8(sp)
    80000ae2:	e06a                	sd	s10,0(sp)
    80000ae4:	1080                	addi	s0,sp,96
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000ae6:	ce71                	beqz	a2,80000bc2 <uvmcopy+0xf8>
    80000ae8:	8c2a                	mv	s8,a0
    80000aea:	8bae                	mv	s7,a1
    80000aec:	8b32                	mv	s6,a2
    80000aee:	4901                	li	s2,0
    // memmove(mem, (char*)pa, PGSIZE);
    // if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    //   kfree(mem);
    //   goto err;
    // }
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000af0:	6a05                	lui	s4,0x1
      goto err;
    }
    // printf("uvmcopy: lazy copying va=%p pa=%p\n",i,pa);
    acquire(&reflock);
    80000af2:	00008a97          	auipc	s5,0x8
    80000af6:	55ea8a93          	addi	s5,s5,1374 # 80009050 <reflock>
    referencecount[PGROUNDUP((uint64)pa)/PGSIZE]++;
    80000afa:	fffa0d13          	addi	s10,s4,-1 # fff <_entry-0x7ffff001>
    80000afe:	00008c97          	auipc	s9,0x8
    80000b02:	56ac8c93          	addi	s9,s9,1386 # 80009068 <referencecount>
    if((pte = walk(old, i, 0)) == 0)
    80000b06:	4601                	li	a2,0
    80000b08:	85ca                	mv	a1,s2
    80000b0a:	8562                	mv	a0,s8
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	9bc080e7          	jalr	-1604(ra) # 800004c8 <walk>
    80000b14:	cd31                	beqz	a0,80000b70 <uvmcopy+0xa6>
    if((*pte & PTE_V) == 0)
    80000b16:	6118                	ld	a4,0(a0)
    80000b18:	00177793          	andi	a5,a4,1
    80000b1c:	c3b5                	beqz	a5,80000b80 <uvmcopy+0xb6>
    *pte &= ~(PTE_W);
    80000b1e:	9b6d                	andi	a4,a4,-5
    *pte |= PTE_COW;
    80000b20:	10076713          	ori	a4,a4,256
    80000b24:	e118                	sd	a4,0(a0)
    pa = PTE2PA(*pte);
    80000b26:	00a75493          	srli	s1,a4,0xa
    80000b2a:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000b2c:	3fb77713          	andi	a4,a4,1019
    80000b30:	86a6                	mv	a3,s1
    80000b32:	8652                	mv	a2,s4
    80000b34:	85ca                	mv	a1,s2
    80000b36:	855e                	mv	a0,s7
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	a78080e7          	jalr	-1416(ra) # 800005b0 <mappages>
    80000b40:	89aa                	mv	s3,a0
    80000b42:	e539                	bnez	a0,80000b90 <uvmcopy+0xc6>
    acquire(&reflock);
    80000b44:	8556                	mv	a0,s5
    80000b46:	00005097          	auipc	ra,0x5
    80000b4a:	7cc080e7          	jalr	1996(ra) # 80006312 <acquire>
    referencecount[PGROUNDUP((uint64)pa)/PGSIZE]++;
    80000b4e:	94ea                	add	s1,s1,s10
    80000b50:	80b1                	srli	s1,s1,0xc
    80000b52:	94e6                	add	s1,s1,s9
    80000b54:	0004c783          	lbu	a5,0(s1)
    80000b58:	2785                	addiw	a5,a5,1
    80000b5a:	00f48023          	sb	a5,0(s1)
    release(&reflock);
    80000b5e:	8556                	mv	a0,s5
    80000b60:	00006097          	auipc	ra,0x6
    80000b64:	866080e7          	jalr	-1946(ra) # 800063c6 <release>
  for(i = 0; i < sz; i += PGSIZE){
    80000b68:	9952                	add	s2,s2,s4
    80000b6a:	f9696ee3          	bltu	s2,s6,80000b06 <uvmcopy+0x3c>
    80000b6e:	a81d                	j	80000ba4 <uvmcopy+0xda>
      panic("uvmcopy: pte should exist");
    80000b70:	00007517          	auipc	a0,0x7
    80000b74:	5a050513          	addi	a0,a0,1440 # 80008110 <etext+0x110>
    80000b78:	00005097          	auipc	ra,0x5
    80000b7c:	250080e7          	jalr	592(ra) # 80005dc8 <panic>
      panic("uvmcopy: page not present");
    80000b80:	00007517          	auipc	a0,0x7
    80000b84:	5b050513          	addi	a0,a0,1456 # 80008130 <etext+0x130>
    80000b88:	00005097          	auipc	ra,0x5
    80000b8c:	240080e7          	jalr	576(ra) # 80005dc8 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b90:	4685                	li	a3,1
    80000b92:	00c95613          	srli	a2,s2,0xc
    80000b96:	4581                	li	a1,0
    80000b98:	855e                	mv	a0,s7
    80000b9a:	00000097          	auipc	ra,0x0
    80000b9e:	bdc080e7          	jalr	-1060(ra) # 80000776 <uvmunmap>
  return -1;
    80000ba2:	59fd                	li	s3,-1
}
    80000ba4:	854e                	mv	a0,s3
    80000ba6:	60e6                	ld	ra,88(sp)
    80000ba8:	6446                	ld	s0,80(sp)
    80000baa:	64a6                	ld	s1,72(sp)
    80000bac:	6906                	ld	s2,64(sp)
    80000bae:	79e2                	ld	s3,56(sp)
    80000bb0:	7a42                	ld	s4,48(sp)
    80000bb2:	7aa2                	ld	s5,40(sp)
    80000bb4:	7b02                	ld	s6,32(sp)
    80000bb6:	6be2                	ld	s7,24(sp)
    80000bb8:	6c42                	ld	s8,16(sp)
    80000bba:	6ca2                	ld	s9,8(sp)
    80000bbc:	6d02                	ld	s10,0(sp)
    80000bbe:	6125                	addi	sp,sp,96
    80000bc0:	8082                	ret
  return 0;
    80000bc2:	4981                	li	s3,0
    80000bc4:	b7c5                	j	80000ba4 <uvmcopy+0xda>

0000000080000bc6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bc6:	1141                	addi	sp,sp,-16
    80000bc8:	e406                	sd	ra,8(sp)
    80000bca:	e022                	sd	s0,0(sp)
    80000bcc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bce:	4601                	li	a2,0
    80000bd0:	00000097          	auipc	ra,0x0
    80000bd4:	8f8080e7          	jalr	-1800(ra) # 800004c8 <walk>
  if(pte == 0)
    80000bd8:	c901                	beqz	a0,80000be8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bda:	611c                	ld	a5,0(a0)
    80000bdc:	9bbd                	andi	a5,a5,-17
    80000bde:	e11c                	sd	a5,0(a0)
}
    80000be0:	60a2                	ld	ra,8(sp)
    80000be2:	6402                	ld	s0,0(sp)
    80000be4:	0141                	addi	sp,sp,16
    80000be6:	8082                	ret
    panic("uvmclear");
    80000be8:	00007517          	auipc	a0,0x7
    80000bec:	56850513          	addi	a0,a0,1384 # 80008150 <etext+0x150>
    80000bf0:	00005097          	auipc	ra,0x5
    80000bf4:	1d8080e7          	jalr	472(ra) # 80005dc8 <panic>

0000000080000bf8 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;
  while(len > 0){
    80000bf8:	10068463          	beqz	a3,80000d00 <copyout+0x108>
{
    80000bfc:	7119                	addi	sp,sp,-128
    80000bfe:	fc86                	sd	ra,120(sp)
    80000c00:	f8a2                	sd	s0,112(sp)
    80000c02:	f4a6                	sd	s1,104(sp)
    80000c04:	f0ca                	sd	s2,96(sp)
    80000c06:	ecce                	sd	s3,88(sp)
    80000c08:	e8d2                	sd	s4,80(sp)
    80000c0a:	e4d6                	sd	s5,72(sp)
    80000c0c:	e0da                	sd	s6,64(sp)
    80000c0e:	fc5e                	sd	s7,56(sp)
    80000c10:	f862                	sd	s8,48(sp)
    80000c12:	f466                	sd	s9,40(sp)
    80000c14:	f06a                	sd	s10,32(sp)
    80000c16:	ec6e                	sd	s11,24(sp)
    80000c18:	0100                	addi	s0,sp,128
    80000c1a:	8b2a                	mv	s6,a0
    80000c1c:	89ae                	mv	s3,a1
    80000c1e:	8bb2                	mv	s7,a2
    80000c20:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000c22:	7dfd                	lui	s11,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(dstva >= MAXVA)
    80000c24:	5d7d                	li	s10,-1
    80000c26:	01ad5d13          	srli	s10,s10,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c2a:	6c05                	lui	s8,0x1
    80000c2c:	a805                	j	80000c5c <copyout+0x64>
      {
        kfree(mem);
        panic("copyout: mappages failed");
      }
    }
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85a6                	mv	a1,s1
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	93c080e7          	jalr	-1732(ra) # 8000056e <walkaddr>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c3a:	409989b3          	sub	s3,s3,s1
    80000c3e:	0009061b          	sext.w	a2,s2
    80000c42:	85de                	mv	a1,s7
    80000c44:	954e                	add	a0,a0,s3
    80000c46:	fffff097          	auipc	ra,0xfffff
    80000c4a:	5fa080e7          	jalr	1530(ra) # 80000240 <memmove>

    len -= n;
    80000c4e:	412a0a33          	sub	s4,s4,s2
    src += n;
    80000c52:	9bca                	add	s7,s7,s2
    dstva = va0 + PGSIZE;
    80000c54:	018489b3          	add	s3,s1,s8
  while(len > 0){
    80000c58:	0a0a0263          	beqz	s4,80000cfc <copyout+0x104>
    va0 = PGROUNDDOWN(dstva);
    80000c5c:	01b9f4b3          	and	s1,s3,s11
    pa0 = walkaddr(pagetable, va0);
    80000c60:	85a6                	mv	a1,s1
    80000c62:	855a                	mv	a0,s6
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	90a080e7          	jalr	-1782(ra) # 8000056e <walkaddr>
    80000c6c:	8aaa                	mv	s5,a0
    if(dstva >= MAXVA)
    80000c6e:	093d6b63          	bltu	s10,s3,80000d04 <copyout+0x10c>
    pte = walk(pagetable, va0, 0);
    80000c72:	4601                	li	a2,0
    80000c74:	85a6                	mv	a1,s1
    80000c76:	855a                	mv	a0,s6
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	850080e7          	jalr	-1968(ra) # 800004c8 <walk>
    if(pa0 == 0)
    80000c80:	0a0a8263          	beqz	s5,80000d24 <copyout+0x12c>
    n = PGSIZE - (dstva - va0);
    80000c84:	41348933          	sub	s2,s1,s3
    80000c88:	9962                	add	s2,s2,s8
    if(n > len)
    80000c8a:	012a7363          	bgeu	s4,s2,80000c90 <copyout+0x98>
    80000c8e:	8952                	mv	s2,s4
    if (*pte & PTE_COW)
    80000c90:	611c                	ld	a5,0(a0)
    80000c92:	1007f713          	andi	a4,a5,256
    80000c96:	df41                	beqz	a4,80000c2e <copyout+0x36>
      flags &= ~(PTE_COW);
    80000c98:	2fb7f793          	andi	a5,a5,763
    80000c9c:	0047e793          	ori	a5,a5,4
    80000ca0:	f8f43423          	sd	a5,-120(s0)
      if((mem = kalloc()) == 0)
    80000ca4:	fffff097          	auipc	ra,0xfffff
    80000ca8:	4c4080e7          	jalr	1220(ra) # 80000168 <kalloc>
    80000cac:	8caa                	mv	s9,a0
    80000cae:	cd2d                	beqz	a0,80000d28 <copyout+0x130>
      memmove(mem, (char*)pa0, PGSIZE);
    80000cb0:	8662                	mv	a2,s8
    80000cb2:	85d6                	mv	a1,s5
    80000cb4:	fffff097          	auipc	ra,0xfffff
    80000cb8:	58c080e7          	jalr	1420(ra) # 80000240 <memmove>
      uvmunmap(pagetable, va0, 1, 1);
    80000cbc:	4685                	li	a3,1
    80000cbe:	4605                	li	a2,1
    80000cc0:	85a6                	mv	a1,s1
    80000cc2:	855a                	mv	a0,s6
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	ab2080e7          	jalr	-1358(ra) # 80000776 <uvmunmap>
      if(mappages(pagetable, va0, PGSIZE, (uint64)mem, flags) != 0)
    80000ccc:	f8843703          	ld	a4,-120(s0)
    80000cd0:	86e6                	mv	a3,s9
    80000cd2:	8662                	mv	a2,s8
    80000cd4:	85a6                	mv	a1,s1
    80000cd6:	855a                	mv	a0,s6
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	8d8080e7          	jalr	-1832(ra) # 800005b0 <mappages>
    80000ce0:	d539                	beqz	a0,80000c2e <copyout+0x36>
        kfree(mem);
    80000ce2:	8566                	mv	a0,s9
    80000ce4:	fffff097          	auipc	ra,0xfffff
    80000ce8:	338080e7          	jalr	824(ra) # 8000001c <kfree>
        panic("copyout: mappages failed");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	47450513          	addi	a0,a0,1140 # 80008160 <etext+0x160>
    80000cf4:	00005097          	auipc	ra,0x5
    80000cf8:	0d4080e7          	jalr	212(ra) # 80005dc8 <panic>
  }
  return 0;
    80000cfc:	4501                	li	a0,0
    80000cfe:	a021                	j	80000d06 <copyout+0x10e>
    80000d00:	4501                	li	a0,0
}
    80000d02:	8082                	ret
      return -1;
    80000d04:	557d                	li	a0,-1
}
    80000d06:	70e6                	ld	ra,120(sp)
    80000d08:	7446                	ld	s0,112(sp)
    80000d0a:	74a6                	ld	s1,104(sp)
    80000d0c:	7906                	ld	s2,96(sp)
    80000d0e:	69e6                	ld	s3,88(sp)
    80000d10:	6a46                	ld	s4,80(sp)
    80000d12:	6aa6                	ld	s5,72(sp)
    80000d14:	6b06                	ld	s6,64(sp)
    80000d16:	7be2                	ld	s7,56(sp)
    80000d18:	7c42                	ld	s8,48(sp)
    80000d1a:	7ca2                	ld	s9,40(sp)
    80000d1c:	7d02                	ld	s10,32(sp)
    80000d1e:	6de2                	ld	s11,24(sp)
    80000d20:	6109                	addi	sp,sp,128
    80000d22:	8082                	ret
      return -1;
    80000d24:	557d                	li	a0,-1
    80000d26:	b7c5                	j	80000d06 <copyout+0x10e>
        return -1;
    80000d28:	557d                	li	a0,-1
    80000d2a:	bff1                	j	80000d06 <copyout+0x10e>

0000000080000d2c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d2c:	c6bd                	beqz	a3,80000d9a <copyin+0x6e>
{
    80000d2e:	715d                	addi	sp,sp,-80
    80000d30:	e486                	sd	ra,72(sp)
    80000d32:	e0a2                	sd	s0,64(sp)
    80000d34:	fc26                	sd	s1,56(sp)
    80000d36:	f84a                	sd	s2,48(sp)
    80000d38:	f44e                	sd	s3,40(sp)
    80000d3a:	f052                	sd	s4,32(sp)
    80000d3c:	ec56                	sd	s5,24(sp)
    80000d3e:	e85a                	sd	s6,16(sp)
    80000d40:	e45e                	sd	s7,8(sp)
    80000d42:	e062                	sd	s8,0(sp)
    80000d44:	0880                	addi	s0,sp,80
    80000d46:	8b2a                	mv	s6,a0
    80000d48:	8a2e                	mv	s4,a1
    80000d4a:	8c32                	mv	s8,a2
    80000d4c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d4e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d50:	6a85                	lui	s5,0x1
    80000d52:	a015                	j	80000d76 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d54:	9562                	add	a0,a0,s8
    80000d56:	0004861b          	sext.w	a2,s1
    80000d5a:	412505b3          	sub	a1,a0,s2
    80000d5e:	8552                	mv	a0,s4
    80000d60:	fffff097          	auipc	ra,0xfffff
    80000d64:	4e0080e7          	jalr	1248(ra) # 80000240 <memmove>

    len -= n;
    80000d68:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d6c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d6e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d72:	02098263          	beqz	s3,80000d96 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d7a:	85ca                	mv	a1,s2
    80000d7c:	855a                	mv	a0,s6
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	7f0080e7          	jalr	2032(ra) # 8000056e <walkaddr>
    if(pa0 == 0)
    80000d86:	cd01                	beqz	a0,80000d9e <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d88:	418904b3          	sub	s1,s2,s8
    80000d8c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d8e:	fc99f3e3          	bgeu	s3,s1,80000d54 <copyin+0x28>
    80000d92:	84ce                	mv	s1,s3
    80000d94:	b7c1                	j	80000d54 <copyin+0x28>
  }
  return 0;
    80000d96:	4501                	li	a0,0
    80000d98:	a021                	j	80000da0 <copyin+0x74>
    80000d9a:	4501                	li	a0,0
}
    80000d9c:	8082                	ret
      return -1;
    80000d9e:	557d                	li	a0,-1
}
    80000da0:	60a6                	ld	ra,72(sp)
    80000da2:	6406                	ld	s0,64(sp)
    80000da4:	74e2                	ld	s1,56(sp)
    80000da6:	7942                	ld	s2,48(sp)
    80000da8:	79a2                	ld	s3,40(sp)
    80000daa:	7a02                	ld	s4,32(sp)
    80000dac:	6ae2                	ld	s5,24(sp)
    80000dae:	6b42                	ld	s6,16(sp)
    80000db0:	6ba2                	ld	s7,8(sp)
    80000db2:	6c02                	ld	s8,0(sp)
    80000db4:	6161                	addi	sp,sp,80
    80000db6:	8082                	ret

0000000080000db8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000db8:	c6c5                	beqz	a3,80000e60 <copyinstr+0xa8>
{
    80000dba:	715d                	addi	sp,sp,-80
    80000dbc:	e486                	sd	ra,72(sp)
    80000dbe:	e0a2                	sd	s0,64(sp)
    80000dc0:	fc26                	sd	s1,56(sp)
    80000dc2:	f84a                	sd	s2,48(sp)
    80000dc4:	f44e                	sd	s3,40(sp)
    80000dc6:	f052                	sd	s4,32(sp)
    80000dc8:	ec56                	sd	s5,24(sp)
    80000dca:	e85a                	sd	s6,16(sp)
    80000dcc:	e45e                	sd	s7,8(sp)
    80000dce:	0880                	addi	s0,sp,80
    80000dd0:	8a2a                	mv	s4,a0
    80000dd2:	8b2e                	mv	s6,a1
    80000dd4:	8bb2                	mv	s7,a2
    80000dd6:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dd8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dda:	6985                	lui	s3,0x1
    80000ddc:	a035                	j	80000e08 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dde:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000de2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000de4:	0017b793          	seqz	a5,a5
    80000de8:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000dec:	60a6                	ld	ra,72(sp)
    80000dee:	6406                	ld	s0,64(sp)
    80000df0:	74e2                	ld	s1,56(sp)
    80000df2:	7942                	ld	s2,48(sp)
    80000df4:	79a2                	ld	s3,40(sp)
    80000df6:	7a02                	ld	s4,32(sp)
    80000df8:	6ae2                	ld	s5,24(sp)
    80000dfa:	6b42                	ld	s6,16(sp)
    80000dfc:	6ba2                	ld	s7,8(sp)
    80000dfe:	6161                	addi	sp,sp,80
    80000e00:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e02:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e06:	c8a9                	beqz	s1,80000e58 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000e08:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e0c:	85ca                	mv	a1,s2
    80000e0e:	8552                	mv	a0,s4
    80000e10:	fffff097          	auipc	ra,0xfffff
    80000e14:	75e080e7          	jalr	1886(ra) # 8000056e <walkaddr>
    if(pa0 == 0)
    80000e18:	c131                	beqz	a0,80000e5c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000e1a:	41790833          	sub	a6,s2,s7
    80000e1e:	984e                	add	a6,a6,s3
    if(n > max)
    80000e20:	0104f363          	bgeu	s1,a6,80000e26 <copyinstr+0x6e>
    80000e24:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e26:	955e                	add	a0,a0,s7
    80000e28:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e2c:	fc080be3          	beqz	a6,80000e02 <copyinstr+0x4a>
    80000e30:	985a                	add	a6,a6,s6
    80000e32:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e34:	41650633          	sub	a2,a0,s6
    80000e38:	14fd                	addi	s1,s1,-1
    80000e3a:	9b26                	add	s6,s6,s1
    80000e3c:	00f60733          	add	a4,a2,a5
    80000e40:	00074703          	lbu	a4,0(a4)
    80000e44:	df49                	beqz	a4,80000dde <copyinstr+0x26>
        *dst = *p;
    80000e46:	00e78023          	sb	a4,0(a5)
      --max;
    80000e4a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e4e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e50:	ff0796e3          	bne	a5,a6,80000e3c <copyinstr+0x84>
      dst++;
    80000e54:	8b42                	mv	s6,a6
    80000e56:	b775                	j	80000e02 <copyinstr+0x4a>
    80000e58:	4781                	li	a5,0
    80000e5a:	b769                	j	80000de4 <copyinstr+0x2c>
      return -1;
    80000e5c:	557d                	li	a0,-1
    80000e5e:	b779                	j	80000dec <copyinstr+0x34>
  int got_null = 0;
    80000e60:	4781                	li	a5,0
  if(got_null){
    80000e62:	0017b793          	seqz	a5,a5
    80000e66:	40f00533          	neg	a0,a5
}
    80000e6a:	8082                	ret

0000000080000e6c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e6c:	7139                	addi	sp,sp,-64
    80000e6e:	fc06                	sd	ra,56(sp)
    80000e70:	f822                	sd	s0,48(sp)
    80000e72:	f426                	sd	s1,40(sp)
    80000e74:	f04a                	sd	s2,32(sp)
    80000e76:	ec4e                	sd	s3,24(sp)
    80000e78:	e852                	sd	s4,16(sp)
    80000e7a:	e456                	sd	s5,8(sp)
    80000e7c:	e05a                	sd	s6,0(sp)
    80000e7e:	0080                	addi	s0,sp,64
    80000e80:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e82:	00090497          	auipc	s1,0x90
    80000e86:	61648493          	addi	s1,s1,1558 # 80091498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e8a:	8b26                	mv	s6,s1
    80000e8c:	00007a97          	auipc	s5,0x7
    80000e90:	174a8a93          	addi	s5,s5,372 # 80008000 <etext>
    80000e94:	04000937          	lui	s2,0x4000
    80000e98:	197d                	addi	s2,s2,-1
    80000e9a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9c:	0009ba17          	auipc	s4,0x9b
    80000ea0:	dfca0a13          	addi	s4,s4,-516 # 8009bc98 <tickslock>
    char *pa = kalloc();
    80000ea4:	fffff097          	auipc	ra,0xfffff
    80000ea8:	2c4080e7          	jalr	708(ra) # 80000168 <kalloc>
    80000eac:	862a                	mv	a2,a0
    if(pa == 0)
    80000eae:	c131                	beqz	a0,80000ef2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000eb0:	416485b3          	sub	a1,s1,s6
    80000eb4:	8595                	srai	a1,a1,0x5
    80000eb6:	000ab783          	ld	a5,0(s5)
    80000eba:	02f585b3          	mul	a1,a1,a5
    80000ebe:	2585                	addiw	a1,a1,1
    80000ec0:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ec4:	4719                	li	a4,6
    80000ec6:	6685                	lui	a3,0x1
    80000ec8:	40b905b3          	sub	a1,s2,a1
    80000ecc:	854e                	mv	a0,s3
    80000ece:	fffff097          	auipc	ra,0xfffff
    80000ed2:	782080e7          	jalr	1922(ra) # 80000650 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed6:	2a048493          	addi	s1,s1,672
    80000eda:	fd4495e3          	bne	s1,s4,80000ea4 <proc_mapstacks+0x38>
  }
}
    80000ede:	70e2                	ld	ra,56(sp)
    80000ee0:	7442                	ld	s0,48(sp)
    80000ee2:	74a2                	ld	s1,40(sp)
    80000ee4:	7902                	ld	s2,32(sp)
    80000ee6:	69e2                	ld	s3,24(sp)
    80000ee8:	6a42                	ld	s4,16(sp)
    80000eea:	6aa2                	ld	s5,8(sp)
    80000eec:	6b02                	ld	s6,0(sp)
    80000eee:	6121                	addi	sp,sp,64
    80000ef0:	8082                	ret
      panic("kalloc");
    80000ef2:	00007517          	auipc	a0,0x7
    80000ef6:	28e50513          	addi	a0,a0,654 # 80008180 <etext+0x180>
    80000efa:	00005097          	auipc	ra,0x5
    80000efe:	ece080e7          	jalr	-306(ra) # 80005dc8 <panic>

0000000080000f02 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f02:	7139                	addi	sp,sp,-64
    80000f04:	fc06                	sd	ra,56(sp)
    80000f06:	f822                	sd	s0,48(sp)
    80000f08:	f426                	sd	s1,40(sp)
    80000f0a:	f04a                	sd	s2,32(sp)
    80000f0c:	ec4e                	sd	s3,24(sp)
    80000f0e:	e852                	sd	s4,16(sp)
    80000f10:	e456                	sd	s5,8(sp)
    80000f12:	e05a                	sd	s6,0(sp)
    80000f14:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f16:	00007597          	auipc	a1,0x7
    80000f1a:	27258593          	addi	a1,a1,626 # 80008188 <etext+0x188>
    80000f1e:	00090517          	auipc	a0,0x90
    80000f22:	14a50513          	addi	a0,a0,330 # 80091068 <pid_lock>
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	35c080e7          	jalr	860(ra) # 80006282 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f2e:	00007597          	auipc	a1,0x7
    80000f32:	26258593          	addi	a1,a1,610 # 80008190 <etext+0x190>
    80000f36:	00090517          	auipc	a0,0x90
    80000f3a:	14a50513          	addi	a0,a0,330 # 80091080 <wait_lock>
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	344080e7          	jalr	836(ra) # 80006282 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f46:	00090497          	auipc	s1,0x90
    80000f4a:	55248493          	addi	s1,s1,1362 # 80091498 <proc>
      initlock(&p->lock, "proc");
    80000f4e:	00007b17          	auipc	s6,0x7
    80000f52:	252b0b13          	addi	s6,s6,594 # 800081a0 <etext+0x1a0>
      p->kstack = KSTACK((int) (p - proc));
    80000f56:	8aa6                	mv	s5,s1
    80000f58:	00007a17          	auipc	s4,0x7
    80000f5c:	0a8a0a13          	addi	s4,s4,168 # 80008000 <etext>
    80000f60:	04000937          	lui	s2,0x4000
    80000f64:	197d                	addi	s2,s2,-1
    80000f66:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f68:	0009b997          	auipc	s3,0x9b
    80000f6c:	d3098993          	addi	s3,s3,-720 # 8009bc98 <tickslock>
      initlock(&p->lock, "proc");
    80000f70:	85da                	mv	a1,s6
    80000f72:	8526                	mv	a0,s1
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	30e080e7          	jalr	782(ra) # 80006282 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f7c:	415487b3          	sub	a5,s1,s5
    80000f80:	8795                	srai	a5,a5,0x5
    80000f82:	000a3703          	ld	a4,0(s4)
    80000f86:	02e787b3          	mul	a5,a5,a4
    80000f8a:	2785                	addiw	a5,a5,1
    80000f8c:	00d7979b          	slliw	a5,a5,0xd
    80000f90:	40f907b3          	sub	a5,s2,a5
    80000f94:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f96:	2a048493          	addi	s1,s1,672
    80000f9a:	fd349be3          	bne	s1,s3,80000f70 <procinit+0x6e>
  }
}
    80000f9e:	70e2                	ld	ra,56(sp)
    80000fa0:	7442                	ld	s0,48(sp)
    80000fa2:	74a2                	ld	s1,40(sp)
    80000fa4:	7902                	ld	s2,32(sp)
    80000fa6:	69e2                	ld	s3,24(sp)
    80000fa8:	6a42                	ld	s4,16(sp)
    80000faa:	6aa2                	ld	s5,8(sp)
    80000fac:	6b02                	ld	s6,0(sp)
    80000fae:	6121                	addi	sp,sp,64
    80000fb0:	8082                	ret

0000000080000fb2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fb2:	1141                	addi	sp,sp,-16
    80000fb4:	e422                	sd	s0,8(sp)
    80000fb6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fb8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fba:	2501                	sext.w	a0,a0
    80000fbc:	6422                	ld	s0,8(sp)
    80000fbe:	0141                	addi	sp,sp,16
    80000fc0:	8082                	ret

0000000080000fc2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fc2:	1141                	addi	sp,sp,-16
    80000fc4:	e422                	sd	s0,8(sp)
    80000fc6:	0800                	addi	s0,sp,16
    80000fc8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fca:	2781                	sext.w	a5,a5
    80000fcc:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fce:	00090517          	auipc	a0,0x90
    80000fd2:	0ca50513          	addi	a0,a0,202 # 80091098 <cpus>
    80000fd6:	953e                	add	a0,a0,a5
    80000fd8:	6422                	ld	s0,8(sp)
    80000fda:	0141                	addi	sp,sp,16
    80000fdc:	8082                	ret

0000000080000fde <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fde:	1101                	addi	sp,sp,-32
    80000fe0:	ec06                	sd	ra,24(sp)
    80000fe2:	e822                	sd	s0,16(sp)
    80000fe4:	e426                	sd	s1,8(sp)
    80000fe6:	1000                	addi	s0,sp,32
  push_off();
    80000fe8:	00005097          	auipc	ra,0x5
    80000fec:	2de080e7          	jalr	734(ra) # 800062c6 <push_off>
    80000ff0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ff2:	2781                	sext.w	a5,a5
    80000ff4:	079e                	slli	a5,a5,0x7
    80000ff6:	00090717          	auipc	a4,0x90
    80000ffa:	07270713          	addi	a4,a4,114 # 80091068 <pid_lock>
    80000ffe:	97ba                	add	a5,a5,a4
    80001000:	7b84                	ld	s1,48(a5)
  pop_off();
    80001002:	00005097          	auipc	ra,0x5
    80001006:	364080e7          	jalr	868(ra) # 80006366 <pop_off>
  return p;
}
    8000100a:	8526                	mv	a0,s1
    8000100c:	60e2                	ld	ra,24(sp)
    8000100e:	6442                	ld	s0,16(sp)
    80001010:	64a2                	ld	s1,8(sp)
    80001012:	6105                	addi	sp,sp,32
    80001014:	8082                	ret

0000000080001016 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001016:	1141                	addi	sp,sp,-16
    80001018:	e406                	sd	ra,8(sp)
    8000101a:	e022                	sd	s0,0(sp)
    8000101c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000101e:	00000097          	auipc	ra,0x0
    80001022:	fc0080e7          	jalr	-64(ra) # 80000fde <myproc>
    80001026:	00005097          	auipc	ra,0x5
    8000102a:	3a0080e7          	jalr	928(ra) # 800063c6 <release>

  if (first) {
    8000102e:	00008797          	auipc	a5,0x8
    80001032:	8327a783          	lw	a5,-1998(a5) # 80008860 <first.1681>
    80001036:	eb89                	bnez	a5,80001048 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001038:	00001097          	auipc	ra,0x1
    8000103c:	c18080e7          	jalr	-1000(ra) # 80001c50 <usertrapret>
}
    80001040:	60a2                	ld	ra,8(sp)
    80001042:	6402                	ld	s0,0(sp)
    80001044:	0141                	addi	sp,sp,16
    80001046:	8082                	ret
    first = 0;
    80001048:	00008797          	auipc	a5,0x8
    8000104c:	8007ac23          	sw	zero,-2024(a5) # 80008860 <first.1681>
    fsinit(ROOTDEV);
    80001050:	4505                	li	a0,1
    80001052:	00002097          	auipc	ra,0x2
    80001056:	a54080e7          	jalr	-1452(ra) # 80002aa6 <fsinit>
    8000105a:	bff9                	j	80001038 <forkret+0x22>

000000008000105c <allocpid>:
allocpid() {
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001068:	00090917          	auipc	s2,0x90
    8000106c:	00090913          	mv	s2,s2
    80001070:	854a                	mv	a0,s2
    80001072:	00005097          	auipc	ra,0x5
    80001076:	2a0080e7          	jalr	672(ra) # 80006312 <acquire>
  pid = nextpid;
    8000107a:	00007797          	auipc	a5,0x7
    8000107e:	7ea78793          	addi	a5,a5,2026 # 80008864 <nextpid>
    80001082:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001084:	0014871b          	addiw	a4,s1,1
    80001088:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000108a:	854a                	mv	a0,s2
    8000108c:	00005097          	auipc	ra,0x5
    80001090:	33a080e7          	jalr	826(ra) # 800063c6 <release>
}
    80001094:	8526                	mv	a0,s1
    80001096:	60e2                	ld	ra,24(sp)
    80001098:	6442                	ld	s0,16(sp)
    8000109a:	64a2                	ld	s1,8(sp)
    8000109c:	6902                	ld	s2,0(sp)
    8000109e:	6105                	addi	sp,sp,32
    800010a0:	8082                	ret

00000000800010a2 <proc_pagetable>:
{
    800010a2:	1101                	addi	sp,sp,-32
    800010a4:	ec06                	sd	ra,24(sp)
    800010a6:	e822                	sd	s0,16(sp)
    800010a8:	e426                	sd	s1,8(sp)
    800010aa:	e04a                	sd	s2,0(sp)
    800010ac:	1000                	addi	s0,sp,32
    800010ae:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	7e6080e7          	jalr	2022(ra) # 80000896 <uvmcreate>
    800010b8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010ba:	c121                	beqz	a0,800010fa <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010bc:	4729                	li	a4,10
    800010be:	00006697          	auipc	a3,0x6
    800010c2:	f4268693          	addi	a3,a3,-190 # 80007000 <_trampoline>
    800010c6:	6605                	lui	a2,0x1
    800010c8:	040005b7          	lui	a1,0x4000
    800010cc:	15fd                	addi	a1,a1,-1
    800010ce:	05b2                	slli	a1,a1,0xc
    800010d0:	fffff097          	auipc	ra,0xfffff
    800010d4:	4e0080e7          	jalr	1248(ra) # 800005b0 <mappages>
    800010d8:	02054863          	bltz	a0,80001108 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010dc:	4719                	li	a4,6
    800010de:	05893683          	ld	a3,88(s2) # 800910c0 <cpus+0x28>
    800010e2:	6605                	lui	a2,0x1
    800010e4:	020005b7          	lui	a1,0x2000
    800010e8:	15fd                	addi	a1,a1,-1
    800010ea:	05b6                	slli	a1,a1,0xd
    800010ec:	8526                	mv	a0,s1
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	4c2080e7          	jalr	1218(ra) # 800005b0 <mappages>
    800010f6:	02054163          	bltz	a0,80001118 <proc_pagetable+0x76>
}
    800010fa:	8526                	mv	a0,s1
    800010fc:	60e2                	ld	ra,24(sp)
    800010fe:	6442                	ld	s0,16(sp)
    80001100:	64a2                	ld	s1,8(sp)
    80001102:	6902                	ld	s2,0(sp)
    80001104:	6105                	addi	sp,sp,32
    80001106:	8082                	ret
    uvmfree(pagetable, 0);
    80001108:	4581                	li	a1,0
    8000110a:	8526                	mv	a0,s1
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	986080e7          	jalr	-1658(ra) # 80000a92 <uvmfree>
    return 0;
    80001114:	4481                	li	s1,0
    80001116:	b7d5                	j	800010fa <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001118:	4681                	li	a3,0
    8000111a:	4605                	li	a2,1
    8000111c:	040005b7          	lui	a1,0x4000
    80001120:	15fd                	addi	a1,a1,-1
    80001122:	05b2                	slli	a1,a1,0xc
    80001124:	8526                	mv	a0,s1
    80001126:	fffff097          	auipc	ra,0xfffff
    8000112a:	650080e7          	jalr	1616(ra) # 80000776 <uvmunmap>
    uvmfree(pagetable, 0);
    8000112e:	4581                	li	a1,0
    80001130:	8526                	mv	a0,s1
    80001132:	00000097          	auipc	ra,0x0
    80001136:	960080e7          	jalr	-1696(ra) # 80000a92 <uvmfree>
    return 0;
    8000113a:	4481                	li	s1,0
    8000113c:	bf7d                	j	800010fa <proc_pagetable+0x58>

000000008000113e <proc_freepagetable>:
{
    8000113e:	1101                	addi	sp,sp,-32
    80001140:	ec06                	sd	ra,24(sp)
    80001142:	e822                	sd	s0,16(sp)
    80001144:	e426                	sd	s1,8(sp)
    80001146:	e04a                	sd	s2,0(sp)
    80001148:	1000                	addi	s0,sp,32
    8000114a:	84aa                	mv	s1,a0
    8000114c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000114e:	4681                	li	a3,0
    80001150:	4605                	li	a2,1
    80001152:	040005b7          	lui	a1,0x4000
    80001156:	15fd                	addi	a1,a1,-1
    80001158:	05b2                	slli	a1,a1,0xc
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	61c080e7          	jalr	1564(ra) # 80000776 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001162:	4681                	li	a3,0
    80001164:	4605                	li	a2,1
    80001166:	020005b7          	lui	a1,0x2000
    8000116a:	15fd                	addi	a1,a1,-1
    8000116c:	05b6                	slli	a1,a1,0xd
    8000116e:	8526                	mv	a0,s1
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	606080e7          	jalr	1542(ra) # 80000776 <uvmunmap>
  uvmfree(pagetable, sz);
    80001178:	85ca                	mv	a1,s2
    8000117a:	8526                	mv	a0,s1
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	916080e7          	jalr	-1770(ra) # 80000a92 <uvmfree>
}
    80001184:	60e2                	ld	ra,24(sp)
    80001186:	6442                	ld	s0,16(sp)
    80001188:	64a2                	ld	s1,8(sp)
    8000118a:	6902                	ld	s2,0(sp)
    8000118c:	6105                	addi	sp,sp,32
    8000118e:	8082                	ret

0000000080001190 <freeproc>:
{
    80001190:	1101                	addi	sp,sp,-32
    80001192:	ec06                	sd	ra,24(sp)
    80001194:	e822                	sd	s0,16(sp)
    80001196:	e426                	sd	s1,8(sp)
    80001198:	1000                	addi	s0,sp,32
    8000119a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000119c:	6d28                	ld	a0,88(a0)
    8000119e:	c509                	beqz	a0,800011a8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	e7c080e7          	jalr	-388(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011a8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011ac:	68a8                	ld	a0,80(s1)
    800011ae:	c511                	beqz	a0,800011ba <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011b0:	64ac                	ld	a1,72(s1)
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	f8c080e7          	jalr	-116(ra) # 8000113e <proc_freepagetable>
  p->pagetable = 0;
    800011ba:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011be:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011c6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011ca:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011ce:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011d6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011da:	0004ac23          	sw	zero,24(s1)
}
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret

00000000800011e8 <allocproc>:
{
    800011e8:	1101                	addi	sp,sp,-32
    800011ea:	ec06                	sd	ra,24(sp)
    800011ec:	e822                	sd	s0,16(sp)
    800011ee:	e426                	sd	s1,8(sp)
    800011f0:	e04a                	sd	s2,0(sp)
    800011f2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f4:	00090497          	auipc	s1,0x90
    800011f8:	2a448493          	addi	s1,s1,676 # 80091498 <proc>
    800011fc:	0009b917          	auipc	s2,0x9b
    80001200:	a9c90913          	addi	s2,s2,-1380 # 8009bc98 <tickslock>
    acquire(&p->lock);
    80001204:	8526                	mv	a0,s1
    80001206:	00005097          	auipc	ra,0x5
    8000120a:	10c080e7          	jalr	268(ra) # 80006312 <acquire>
    if(p->state == UNUSED) {
    8000120e:	4c9c                	lw	a5,24(s1)
    80001210:	cf81                	beqz	a5,80001228 <allocproc+0x40>
      release(&p->lock);
    80001212:	8526                	mv	a0,s1
    80001214:	00005097          	auipc	ra,0x5
    80001218:	1b2080e7          	jalr	434(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121c:	2a048493          	addi	s1,s1,672
    80001220:	ff2492e3          	bne	s1,s2,80001204 <allocproc+0x1c>
  return 0;
    80001224:	4481                	li	s1,0
    80001226:	a085                	j	80001286 <allocproc+0x9e>
  p->pid = allocpid();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	e34080e7          	jalr	-460(ra) # 8000105c <allocpid>
    80001230:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001232:	4785                	li	a5,1
    80001234:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	f32080e7          	jalr	-206(ra) # 80000168 <kalloc>
    8000123e:	892a                	mv	s2,a0
    80001240:	eca8                	sd	a0,88(s1)
    80001242:	c929                	beqz	a0,80001294 <allocproc+0xac>
  p->pagetable = proc_pagetable(p);
    80001244:	8526                	mv	a0,s1
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	e5c080e7          	jalr	-420(ra) # 800010a2 <proc_pagetable>
    8000124e:	892a                	mv	s2,a0
    80001250:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001252:	cd29                	beqz	a0,800012ac <allocproc+0xc4>
  memset(&p->context, 0, sizeof(p->context));
    80001254:	07000613          	li	a2,112
    80001258:	4581                	li	a1,0
    8000125a:	06048513          	addi	a0,s1,96
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	f82080e7          	jalr	-126(ra) # 800001e0 <memset>
  p->context.ra = (uint64)forkret;
    80001266:	00000797          	auipc	a5,0x0
    8000126a:	db078793          	addi	a5,a5,-592 # 80001016 <forkret>
    8000126e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001270:	60bc                	ld	a5,64(s1)
    80001272:	6705                	lui	a4,0x1
    80001274:	97ba                	add	a5,a5,a4
    80001276:	f4bc                	sd	a5,104(s1)
  p->alarmticks = 0;
    80001278:	1604a623          	sw	zero,364(s1)
  p->alarminterval = 0;
    8000127c:	1604a423          	sw	zero,360(s1)
  p->sigreturned = 1;
    80001280:	4785                	li	a5,1
    80001282:	28f4ac23          	sw	a5,664(s1)
}
    80001286:	8526                	mv	a0,s1
    80001288:	60e2                	ld	ra,24(sp)
    8000128a:	6442                	ld	s0,16(sp)
    8000128c:	64a2                	ld	s1,8(sp)
    8000128e:	6902                	ld	s2,0(sp)
    80001290:	6105                	addi	sp,sp,32
    80001292:	8082                	ret
    freeproc(p);
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	efa080e7          	jalr	-262(ra) # 80001190 <freeproc>
    release(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	126080e7          	jalr	294(ra) # 800063c6 <release>
    return 0;
    800012a8:	84ca                	mv	s1,s2
    800012aa:	bff1                	j	80001286 <allocproc+0x9e>
    freeproc(p);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	ee2080e7          	jalr	-286(ra) # 80001190 <freeproc>
    release(&p->lock);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	10e080e7          	jalr	270(ra) # 800063c6 <release>
    return 0;
    800012c0:	84ca                	mv	s1,s2
    800012c2:	b7d1                	j	80001286 <allocproc+0x9e>

00000000800012c4 <userinit>:
{
    800012c4:	1101                	addi	sp,sp,-32
    800012c6:	ec06                	sd	ra,24(sp)
    800012c8:	e822                	sd	s0,16(sp)
    800012ca:	e426                	sd	s1,8(sp)
    800012cc:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	f1a080e7          	jalr	-230(ra) # 800011e8 <allocproc>
    800012d6:	84aa                	mv	s1,a0
  initproc = p;
    800012d8:	00008797          	auipc	a5,0x8
    800012dc:	d2a7bc23          	sd	a0,-712(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012e0:	03400613          	li	a2,52
    800012e4:	00007597          	auipc	a1,0x7
    800012e8:	58c58593          	addi	a1,a1,1420 # 80008870 <initcode>
    800012ec:	6928                	ld	a0,80(a0)
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	5d6080e7          	jalr	1494(ra) # 800008c4 <uvminit>
  p->sz = PGSIZE;
    800012f6:	6785                	lui	a5,0x1
    800012f8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012fa:	6cb8                	ld	a4,88(s1)
    800012fc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001300:	6cb8                	ld	a4,88(s1)
    80001302:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001304:	4641                	li	a2,16
    80001306:	00007597          	auipc	a1,0x7
    8000130a:	ea258593          	addi	a1,a1,-350 # 800081a8 <etext+0x1a8>
    8000130e:	15848513          	addi	a0,s1,344
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	020080e7          	jalr	32(ra) # 80000332 <safestrcpy>
  p->cwd = namei("/");
    8000131a:	00007517          	auipc	a0,0x7
    8000131e:	e9e50513          	addi	a0,a0,-354 # 800081b8 <etext+0x1b8>
    80001322:	00002097          	auipc	ra,0x2
    80001326:	1b2080e7          	jalr	434(ra) # 800034d4 <namei>
    8000132a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001332:	8526                	mv	a0,s1
    80001334:	00005097          	auipc	ra,0x5
    80001338:	092080e7          	jalr	146(ra) # 800063c6 <release>
}
    8000133c:	60e2                	ld	ra,24(sp)
    8000133e:	6442                	ld	s0,16(sp)
    80001340:	64a2                	ld	s1,8(sp)
    80001342:	6105                	addi	sp,sp,32
    80001344:	8082                	ret

0000000080001346 <growproc>:
{
    80001346:	1101                	addi	sp,sp,-32
    80001348:	ec06                	sd	ra,24(sp)
    8000134a:	e822                	sd	s0,16(sp)
    8000134c:	e426                	sd	s1,8(sp)
    8000134e:	e04a                	sd	s2,0(sp)
    80001350:	1000                	addi	s0,sp,32
    80001352:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001354:	00000097          	auipc	ra,0x0
    80001358:	c8a080e7          	jalr	-886(ra) # 80000fde <myproc>
    8000135c:	892a                	mv	s2,a0
  sz = p->sz;
    8000135e:	652c                	ld	a1,72(a0)
    80001360:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001364:	00904f63          	bgtz	s1,80001382 <growproc+0x3c>
  } else if(n < 0){
    80001368:	0204cc63          	bltz	s1,800013a0 <growproc+0x5a>
  p->sz = sz;
    8000136c:	1602                	slli	a2,a2,0x20
    8000136e:	9201                	srli	a2,a2,0x20
    80001370:	04c93423          	sd	a2,72(s2)
  return 0;
    80001374:	4501                	li	a0,0
}
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	64a2                	ld	s1,8(sp)
    8000137c:	6902                	ld	s2,0(sp)
    8000137e:	6105                	addi	sp,sp,32
    80001380:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001382:	9e25                	addw	a2,a2,s1
    80001384:	1602                	slli	a2,a2,0x20
    80001386:	9201                	srli	a2,a2,0x20
    80001388:	1582                	slli	a1,a1,0x20
    8000138a:	9181                	srli	a1,a1,0x20
    8000138c:	6928                	ld	a0,80(a0)
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	5f0080e7          	jalr	1520(ra) # 8000097e <uvmalloc>
    80001396:	0005061b          	sext.w	a2,a0
    8000139a:	fa69                	bnez	a2,8000136c <growproc+0x26>
      return -1;
    8000139c:	557d                	li	a0,-1
    8000139e:	bfe1                	j	80001376 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013a0:	9e25                	addw	a2,a2,s1
    800013a2:	1602                	slli	a2,a2,0x20
    800013a4:	9201                	srli	a2,a2,0x20
    800013a6:	1582                	slli	a1,a1,0x20
    800013a8:	9181                	srli	a1,a1,0x20
    800013aa:	6928                	ld	a0,80(a0)
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	58a080e7          	jalr	1418(ra) # 80000936 <uvmdealloc>
    800013b4:	0005061b          	sext.w	a2,a0
    800013b8:	bf55                	j	8000136c <growproc+0x26>

00000000800013ba <fork>:
{
    800013ba:	7179                	addi	sp,sp,-48
    800013bc:	f406                	sd	ra,40(sp)
    800013be:	f022                	sd	s0,32(sp)
    800013c0:	ec26                	sd	s1,24(sp)
    800013c2:	e84a                	sd	s2,16(sp)
    800013c4:	e44e                	sd	s3,8(sp)
    800013c6:	e052                	sd	s4,0(sp)
    800013c8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	c14080e7          	jalr	-1004(ra) # 80000fde <myproc>
    800013d2:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013d4:	00000097          	auipc	ra,0x0
    800013d8:	e14080e7          	jalr	-492(ra) # 800011e8 <allocproc>
    800013dc:	10050b63          	beqz	a0,800014f2 <fork+0x138>
    800013e0:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013e2:	04893603          	ld	a2,72(s2)
    800013e6:	692c                	ld	a1,80(a0)
    800013e8:	05093503          	ld	a0,80(s2)
    800013ec:	fffff097          	auipc	ra,0xfffff
    800013f0:	6de080e7          	jalr	1758(ra) # 80000aca <uvmcopy>
    800013f4:	04054663          	bltz	a0,80001440 <fork+0x86>
  np->sz = p->sz;
    800013f8:	04893783          	ld	a5,72(s2)
    800013fc:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001400:	05893683          	ld	a3,88(s2)
    80001404:	87b6                	mv	a5,a3
    80001406:	0589b703          	ld	a4,88(s3)
    8000140a:	12068693          	addi	a3,a3,288
    8000140e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001412:	6788                	ld	a0,8(a5)
    80001414:	6b8c                	ld	a1,16(a5)
    80001416:	6f90                	ld	a2,24(a5)
    80001418:	01073023          	sd	a6,0(a4)
    8000141c:	e708                	sd	a0,8(a4)
    8000141e:	eb0c                	sd	a1,16(a4)
    80001420:	ef10                	sd	a2,24(a4)
    80001422:	02078793          	addi	a5,a5,32
    80001426:	02070713          	addi	a4,a4,32
    8000142a:	fed792e3          	bne	a5,a3,8000140e <fork+0x54>
  np->trapframe->a0 = 0;
    8000142e:	0589b783          	ld	a5,88(s3)
    80001432:	0607b823          	sd	zero,112(a5)
    80001436:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000143a:	15000a13          	li	s4,336
    8000143e:	a03d                	j	8000146c <fork+0xb2>
    freeproc(np);
    80001440:	854e                	mv	a0,s3
    80001442:	00000097          	auipc	ra,0x0
    80001446:	d4e080e7          	jalr	-690(ra) # 80001190 <freeproc>
    release(&np->lock);
    8000144a:	854e                	mv	a0,s3
    8000144c:	00005097          	auipc	ra,0x5
    80001450:	f7a080e7          	jalr	-134(ra) # 800063c6 <release>
    return -1;
    80001454:	5a7d                	li	s4,-1
    80001456:	a069                	j	800014e0 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001458:	00002097          	auipc	ra,0x2
    8000145c:	712080e7          	jalr	1810(ra) # 80003b6a <filedup>
    80001460:	009987b3          	add	a5,s3,s1
    80001464:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001466:	04a1                	addi	s1,s1,8
    80001468:	01448763          	beq	s1,s4,80001476 <fork+0xbc>
    if(p->ofile[i])
    8000146c:	009907b3          	add	a5,s2,s1
    80001470:	6388                	ld	a0,0(a5)
    80001472:	f17d                	bnez	a0,80001458 <fork+0x9e>
    80001474:	bfcd                	j	80001466 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001476:	15093503          	ld	a0,336(s2)
    8000147a:	00002097          	auipc	ra,0x2
    8000147e:	866080e7          	jalr	-1946(ra) # 80002ce0 <idup>
    80001482:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001486:	4641                	li	a2,16
    80001488:	15890593          	addi	a1,s2,344
    8000148c:	15898513          	addi	a0,s3,344
    80001490:	fffff097          	auipc	ra,0xfffff
    80001494:	ea2080e7          	jalr	-350(ra) # 80000332 <safestrcpy>
  pid = np->pid;
    80001498:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000149c:	854e                	mv	a0,s3
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	f28080e7          	jalr	-216(ra) # 800063c6 <release>
  acquire(&wait_lock);
    800014a6:	00090497          	auipc	s1,0x90
    800014aa:	bda48493          	addi	s1,s1,-1062 # 80091080 <wait_lock>
    800014ae:	8526                	mv	a0,s1
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	e62080e7          	jalr	-414(ra) # 80006312 <acquire>
  np->parent = p;
    800014b8:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014bc:	8526                	mv	a0,s1
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	f08080e7          	jalr	-248(ra) # 800063c6 <release>
  acquire(&np->lock);
    800014c6:	854e                	mv	a0,s3
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	e4a080e7          	jalr	-438(ra) # 80006312 <acquire>
  np->state = RUNNABLE;
    800014d0:	478d                	li	a5,3
    800014d2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014d6:	854e                	mv	a0,s3
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	eee080e7          	jalr	-274(ra) # 800063c6 <release>
}
    800014e0:	8552                	mv	a0,s4
    800014e2:	70a2                	ld	ra,40(sp)
    800014e4:	7402                	ld	s0,32(sp)
    800014e6:	64e2                	ld	s1,24(sp)
    800014e8:	6942                	ld	s2,16(sp)
    800014ea:	69a2                	ld	s3,8(sp)
    800014ec:	6a02                	ld	s4,0(sp)
    800014ee:	6145                	addi	sp,sp,48
    800014f0:	8082                	ret
    return -1;
    800014f2:	5a7d                	li	s4,-1
    800014f4:	b7f5                	j	800014e0 <fork+0x126>

00000000800014f6 <scheduler>:
{
    800014f6:	7139                	addi	sp,sp,-64
    800014f8:	fc06                	sd	ra,56(sp)
    800014fa:	f822                	sd	s0,48(sp)
    800014fc:	f426                	sd	s1,40(sp)
    800014fe:	f04a                	sd	s2,32(sp)
    80001500:	ec4e                	sd	s3,24(sp)
    80001502:	e852                	sd	s4,16(sp)
    80001504:	e456                	sd	s5,8(sp)
    80001506:	e05a                	sd	s6,0(sp)
    80001508:	0080                	addi	s0,sp,64
    8000150a:	8792                	mv	a5,tp
  int id = r_tp();
    8000150c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000150e:	00779a93          	slli	s5,a5,0x7
    80001512:	00090717          	auipc	a4,0x90
    80001516:	b5670713          	addi	a4,a4,-1194 # 80091068 <pid_lock>
    8000151a:	9756                	add	a4,a4,s5
    8000151c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001520:	00090717          	auipc	a4,0x90
    80001524:	b8070713          	addi	a4,a4,-1152 # 800910a0 <cpus+0x8>
    80001528:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000152a:	498d                	li	s3,3
        p->state = RUNNING;
    8000152c:	4b11                	li	s6,4
        c->proc = p;
    8000152e:	079e                	slli	a5,a5,0x7
    80001530:	00090a17          	auipc	s4,0x90
    80001534:	b38a0a13          	addi	s4,s4,-1224 # 80091068 <pid_lock>
    80001538:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000153a:	0009a917          	auipc	s2,0x9a
    8000153e:	75e90913          	addi	s2,s2,1886 # 8009bc98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001542:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001546:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000154a:	10079073          	csrw	sstatus,a5
    8000154e:	00090497          	auipc	s1,0x90
    80001552:	f4a48493          	addi	s1,s1,-182 # 80091498 <proc>
    80001556:	a03d                	j	80001584 <scheduler+0x8e>
        p->state = RUNNING;
    80001558:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000155c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001560:	06048593          	addi	a1,s1,96
    80001564:	8556                	mv	a0,s5
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	640080e7          	jalr	1600(ra) # 80001ba6 <swtch>
        c->proc = 0;
    8000156e:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001572:	8526                	mv	a0,s1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	e52080e7          	jalr	-430(ra) # 800063c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000157c:	2a048493          	addi	s1,s1,672
    80001580:	fd2481e3          	beq	s1,s2,80001542 <scheduler+0x4c>
      acquire(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	d8c080e7          	jalr	-628(ra) # 80006312 <acquire>
      if(p->state == RUNNABLE) {
    8000158e:	4c9c                	lw	a5,24(s1)
    80001590:	ff3791e3          	bne	a5,s3,80001572 <scheduler+0x7c>
    80001594:	b7d1                	j	80001558 <scheduler+0x62>

0000000080001596 <sched>:
{
    80001596:	7179                	addi	sp,sp,-48
    80001598:	f406                	sd	ra,40(sp)
    8000159a:	f022                	sd	s0,32(sp)
    8000159c:	ec26                	sd	s1,24(sp)
    8000159e:	e84a                	sd	s2,16(sp)
    800015a0:	e44e                	sd	s3,8(sp)
    800015a2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	a3a080e7          	jalr	-1478(ra) # 80000fde <myproc>
    800015ac:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	cea080e7          	jalr	-790(ra) # 80006298 <holding>
    800015b6:	c93d                	beqz	a0,8000162c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015b8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015ba:	2781                	sext.w	a5,a5
    800015bc:	079e                	slli	a5,a5,0x7
    800015be:	00090717          	auipc	a4,0x90
    800015c2:	aaa70713          	addi	a4,a4,-1366 # 80091068 <pid_lock>
    800015c6:	97ba                	add	a5,a5,a4
    800015c8:	0a87a703          	lw	a4,168(a5)
    800015cc:	4785                	li	a5,1
    800015ce:	06f71763          	bne	a4,a5,8000163c <sched+0xa6>
  if(p->state == RUNNING)
    800015d2:	4c98                	lw	a4,24(s1)
    800015d4:	4791                	li	a5,4
    800015d6:	06f70b63          	beq	a4,a5,8000164c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015de:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e0:	efb5                	bnez	a5,8000165c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015e4:	00090917          	auipc	s2,0x90
    800015e8:	a8490913          	addi	s2,s2,-1404 # 80091068 <pid_lock>
    800015ec:	2781                	sext.w	a5,a5
    800015ee:	079e                	slli	a5,a5,0x7
    800015f0:	97ca                	add	a5,a5,s2
    800015f2:	0ac7a983          	lw	s3,172(a5)
    800015f6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015f8:	2781                	sext.w	a5,a5
    800015fa:	079e                	slli	a5,a5,0x7
    800015fc:	00090597          	auipc	a1,0x90
    80001600:	aa458593          	addi	a1,a1,-1372 # 800910a0 <cpus+0x8>
    80001604:	95be                	add	a1,a1,a5
    80001606:	06048513          	addi	a0,s1,96
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	59c080e7          	jalr	1436(ra) # 80001ba6 <swtch>
    80001612:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	97ca                	add	a5,a5,s2
    8000161a:	0b37a623          	sw	s3,172(a5)
}
    8000161e:	70a2                	ld	ra,40(sp)
    80001620:	7402                	ld	s0,32(sp)
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6942                	ld	s2,16(sp)
    80001626:	69a2                	ld	s3,8(sp)
    80001628:	6145                	addi	sp,sp,48
    8000162a:	8082                	ret
    panic("sched p->lock");
    8000162c:	00007517          	auipc	a0,0x7
    80001630:	b9450513          	addi	a0,a0,-1132 # 800081c0 <etext+0x1c0>
    80001634:	00004097          	auipc	ra,0x4
    80001638:	794080e7          	jalr	1940(ra) # 80005dc8 <panic>
    panic("sched locks");
    8000163c:	00007517          	auipc	a0,0x7
    80001640:	b9450513          	addi	a0,a0,-1132 # 800081d0 <etext+0x1d0>
    80001644:	00004097          	auipc	ra,0x4
    80001648:	784080e7          	jalr	1924(ra) # 80005dc8 <panic>
    panic("sched running");
    8000164c:	00007517          	auipc	a0,0x7
    80001650:	b9450513          	addi	a0,a0,-1132 # 800081e0 <etext+0x1e0>
    80001654:	00004097          	auipc	ra,0x4
    80001658:	774080e7          	jalr	1908(ra) # 80005dc8 <panic>
    panic("sched interruptible");
    8000165c:	00007517          	auipc	a0,0x7
    80001660:	b9450513          	addi	a0,a0,-1132 # 800081f0 <etext+0x1f0>
    80001664:	00004097          	auipc	ra,0x4
    80001668:	764080e7          	jalr	1892(ra) # 80005dc8 <panic>

000000008000166c <yield>:
{
    8000166c:	1101                	addi	sp,sp,-32
    8000166e:	ec06                	sd	ra,24(sp)
    80001670:	e822                	sd	s0,16(sp)
    80001672:	e426                	sd	s1,8(sp)
    80001674:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	968080e7          	jalr	-1688(ra) # 80000fde <myproc>
    8000167e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001680:	00005097          	auipc	ra,0x5
    80001684:	c92080e7          	jalr	-878(ra) # 80006312 <acquire>
  p->state = RUNNABLE;
    80001688:	478d                	li	a5,3
    8000168a:	cc9c                	sw	a5,24(s1)
  sched();
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	f0a080e7          	jalr	-246(ra) # 80001596 <sched>
  release(&p->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	d30080e7          	jalr	-720(ra) # 800063c6 <release>
}
    8000169e:	60e2                	ld	ra,24(sp)
    800016a0:	6442                	ld	s0,16(sp)
    800016a2:	64a2                	ld	s1,8(sp)
    800016a4:	6105                	addi	sp,sp,32
    800016a6:	8082                	ret

00000000800016a8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016a8:	7179                	addi	sp,sp,-48
    800016aa:	f406                	sd	ra,40(sp)
    800016ac:	f022                	sd	s0,32(sp)
    800016ae:	ec26                	sd	s1,24(sp)
    800016b0:	e84a                	sd	s2,16(sp)
    800016b2:	e44e                	sd	s3,8(sp)
    800016b4:	1800                	addi	s0,sp,48
    800016b6:	89aa                	mv	s3,a0
    800016b8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	924080e7          	jalr	-1756(ra) # 80000fde <myproc>
    800016c2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	c4e080e7          	jalr	-946(ra) # 80006312 <acquire>
  release(lk);
    800016cc:	854a                	mv	a0,s2
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	cf8080e7          	jalr	-776(ra) # 800063c6 <release>

  // Go to sleep.
  p->chan = chan;
    800016d6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016da:	4789                	li	a5,2
    800016dc:	cc9c                	sw	a5,24(s1)

  sched();
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	eb8080e7          	jalr	-328(ra) # 80001596 <sched>

  // Tidy up.
  p->chan = 0;
    800016e6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	cda080e7          	jalr	-806(ra) # 800063c6 <release>
  acquire(lk);
    800016f4:	854a                	mv	a0,s2
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	c1c080e7          	jalr	-996(ra) # 80006312 <acquire>
}
    800016fe:	70a2                	ld	ra,40(sp)
    80001700:	7402                	ld	s0,32(sp)
    80001702:	64e2                	ld	s1,24(sp)
    80001704:	6942                	ld	s2,16(sp)
    80001706:	69a2                	ld	s3,8(sp)
    80001708:	6145                	addi	sp,sp,48
    8000170a:	8082                	ret

000000008000170c <wait>:
{
    8000170c:	715d                	addi	sp,sp,-80
    8000170e:	e486                	sd	ra,72(sp)
    80001710:	e0a2                	sd	s0,64(sp)
    80001712:	fc26                	sd	s1,56(sp)
    80001714:	f84a                	sd	s2,48(sp)
    80001716:	f44e                	sd	s3,40(sp)
    80001718:	f052                	sd	s4,32(sp)
    8000171a:	ec56                	sd	s5,24(sp)
    8000171c:	e85a                	sd	s6,16(sp)
    8000171e:	e45e                	sd	s7,8(sp)
    80001720:	e062                	sd	s8,0(sp)
    80001722:	0880                	addi	s0,sp,80
    80001724:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	8b8080e7          	jalr	-1864(ra) # 80000fde <myproc>
    8000172e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001730:	00090517          	auipc	a0,0x90
    80001734:	95050513          	addi	a0,a0,-1712 # 80091080 <wait_lock>
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	bda080e7          	jalr	-1062(ra) # 80006312 <acquire>
    havekids = 0;
    80001740:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001742:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001744:	0009a997          	auipc	s3,0x9a
    80001748:	55498993          	addi	s3,s3,1364 # 8009bc98 <tickslock>
        havekids = 1;
    8000174c:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000174e:	00090c17          	auipc	s8,0x90
    80001752:	932c0c13          	addi	s8,s8,-1742 # 80091080 <wait_lock>
    havekids = 0;
    80001756:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001758:	00090497          	auipc	s1,0x90
    8000175c:	d4048493          	addi	s1,s1,-704 # 80091498 <proc>
    80001760:	a0bd                	j	800017ce <wait+0xc2>
          pid = np->pid;
    80001762:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001766:	000b0e63          	beqz	s6,80001782 <wait+0x76>
    8000176a:	4691                	li	a3,4
    8000176c:	02c48613          	addi	a2,s1,44
    80001770:	85da                	mv	a1,s6
    80001772:	05093503          	ld	a0,80(s2)
    80001776:	fffff097          	auipc	ra,0xfffff
    8000177a:	482080e7          	jalr	1154(ra) # 80000bf8 <copyout>
    8000177e:	02054563          	bltz	a0,800017a8 <wait+0x9c>
          freeproc(np);
    80001782:	8526                	mv	a0,s1
    80001784:	00000097          	auipc	ra,0x0
    80001788:	a0c080e7          	jalr	-1524(ra) # 80001190 <freeproc>
          release(&np->lock);
    8000178c:	8526                	mv	a0,s1
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	c38080e7          	jalr	-968(ra) # 800063c6 <release>
          release(&wait_lock);
    80001796:	00090517          	auipc	a0,0x90
    8000179a:	8ea50513          	addi	a0,a0,-1814 # 80091080 <wait_lock>
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	c28080e7          	jalr	-984(ra) # 800063c6 <release>
          return pid;
    800017a6:	a09d                	j	8000180c <wait+0x100>
            release(&np->lock);
    800017a8:	8526                	mv	a0,s1
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	c1c080e7          	jalr	-996(ra) # 800063c6 <release>
            release(&wait_lock);
    800017b2:	00090517          	auipc	a0,0x90
    800017b6:	8ce50513          	addi	a0,a0,-1842 # 80091080 <wait_lock>
    800017ba:	00005097          	auipc	ra,0x5
    800017be:	c0c080e7          	jalr	-1012(ra) # 800063c6 <release>
            return -1;
    800017c2:	59fd                	li	s3,-1
    800017c4:	a0a1                	j	8000180c <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017c6:	2a048493          	addi	s1,s1,672
    800017ca:	03348463          	beq	s1,s3,800017f2 <wait+0xe6>
      if(np->parent == p){
    800017ce:	7c9c                	ld	a5,56(s1)
    800017d0:	ff279be3          	bne	a5,s2,800017c6 <wait+0xba>
        acquire(&np->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	b3c080e7          	jalr	-1220(ra) # 80006312 <acquire>
        if(np->state == ZOMBIE){
    800017de:	4c9c                	lw	a5,24(s1)
    800017e0:	f94781e3          	beq	a5,s4,80001762 <wait+0x56>
        release(&np->lock);
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	be0080e7          	jalr	-1056(ra) # 800063c6 <release>
        havekids = 1;
    800017ee:	8756                	mv	a4,s5
    800017f0:	bfd9                	j	800017c6 <wait+0xba>
    if(!havekids || p->killed){
    800017f2:	c701                	beqz	a4,800017fa <wait+0xee>
    800017f4:	02892783          	lw	a5,40(s2)
    800017f8:	c79d                	beqz	a5,80001826 <wait+0x11a>
      release(&wait_lock);
    800017fa:	00090517          	auipc	a0,0x90
    800017fe:	88650513          	addi	a0,a0,-1914 # 80091080 <wait_lock>
    80001802:	00005097          	auipc	ra,0x5
    80001806:	bc4080e7          	jalr	-1084(ra) # 800063c6 <release>
      return -1;
    8000180a:	59fd                	li	s3,-1
}
    8000180c:	854e                	mv	a0,s3
    8000180e:	60a6                	ld	ra,72(sp)
    80001810:	6406                	ld	s0,64(sp)
    80001812:	74e2                	ld	s1,56(sp)
    80001814:	7942                	ld	s2,48(sp)
    80001816:	79a2                	ld	s3,40(sp)
    80001818:	7a02                	ld	s4,32(sp)
    8000181a:	6ae2                	ld	s5,24(sp)
    8000181c:	6b42                	ld	s6,16(sp)
    8000181e:	6ba2                	ld	s7,8(sp)
    80001820:	6c02                	ld	s8,0(sp)
    80001822:	6161                	addi	sp,sp,80
    80001824:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001826:	85e2                	mv	a1,s8
    80001828:	854a                	mv	a0,s2
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	e7e080e7          	jalr	-386(ra) # 800016a8 <sleep>
    havekids = 0;
    80001832:	b715                	j	80001756 <wait+0x4a>

0000000080001834 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001834:	7139                	addi	sp,sp,-64
    80001836:	fc06                	sd	ra,56(sp)
    80001838:	f822                	sd	s0,48(sp)
    8000183a:	f426                	sd	s1,40(sp)
    8000183c:	f04a                	sd	s2,32(sp)
    8000183e:	ec4e                	sd	s3,24(sp)
    80001840:	e852                	sd	s4,16(sp)
    80001842:	e456                	sd	s5,8(sp)
    80001844:	0080                	addi	s0,sp,64
    80001846:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001848:	00090497          	auipc	s1,0x90
    8000184c:	c5048493          	addi	s1,s1,-944 # 80091498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001850:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001852:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001854:	0009a917          	auipc	s2,0x9a
    80001858:	44490913          	addi	s2,s2,1092 # 8009bc98 <tickslock>
    8000185c:	a821                	j	80001874 <wakeup+0x40>
        p->state = RUNNABLE;
    8000185e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	b62080e7          	jalr	-1182(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	2a048493          	addi	s1,s1,672
    80001870:	03248463          	beq	s1,s2,80001898 <wakeup+0x64>
    if(p != myproc()){
    80001874:	fffff097          	auipc	ra,0xfffff
    80001878:	76a080e7          	jalr	1898(ra) # 80000fde <myproc>
    8000187c:	fea488e3          	beq	s1,a0,8000186c <wakeup+0x38>
      acquire(&p->lock);
    80001880:	8526                	mv	a0,s1
    80001882:	00005097          	auipc	ra,0x5
    80001886:	a90080e7          	jalr	-1392(ra) # 80006312 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000188a:	4c9c                	lw	a5,24(s1)
    8000188c:	fd379be3          	bne	a5,s3,80001862 <wakeup+0x2e>
    80001890:	709c                	ld	a5,32(s1)
    80001892:	fd4798e3          	bne	a5,s4,80001862 <wakeup+0x2e>
    80001896:	b7e1                	j	8000185e <wakeup+0x2a>
    }
  }
}
    80001898:	70e2                	ld	ra,56(sp)
    8000189a:	7442                	ld	s0,48(sp)
    8000189c:	74a2                	ld	s1,40(sp)
    8000189e:	7902                	ld	s2,32(sp)
    800018a0:	69e2                	ld	s3,24(sp)
    800018a2:	6a42                	ld	s4,16(sp)
    800018a4:	6aa2                	ld	s5,8(sp)
    800018a6:	6121                	addi	sp,sp,64
    800018a8:	8082                	ret

00000000800018aa <reparent>:
{
    800018aa:	7179                	addi	sp,sp,-48
    800018ac:	f406                	sd	ra,40(sp)
    800018ae:	f022                	sd	s0,32(sp)
    800018b0:	ec26                	sd	s1,24(sp)
    800018b2:	e84a                	sd	s2,16(sp)
    800018b4:	e44e                	sd	s3,8(sp)
    800018b6:	e052                	sd	s4,0(sp)
    800018b8:	1800                	addi	s0,sp,48
    800018ba:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018bc:	00090497          	auipc	s1,0x90
    800018c0:	bdc48493          	addi	s1,s1,-1060 # 80091498 <proc>
      pp->parent = initproc;
    800018c4:	00007a17          	auipc	s4,0x7
    800018c8:	74ca0a13          	addi	s4,s4,1868 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018cc:	0009a997          	auipc	s3,0x9a
    800018d0:	3cc98993          	addi	s3,s3,972 # 8009bc98 <tickslock>
    800018d4:	a029                	j	800018de <reparent+0x34>
    800018d6:	2a048493          	addi	s1,s1,672
    800018da:	01348d63          	beq	s1,s3,800018f4 <reparent+0x4a>
    if(pp->parent == p){
    800018de:	7c9c                	ld	a5,56(s1)
    800018e0:	ff279be3          	bne	a5,s2,800018d6 <reparent+0x2c>
      pp->parent = initproc;
    800018e4:	000a3503          	ld	a0,0(s4)
    800018e8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018ea:	00000097          	auipc	ra,0x0
    800018ee:	f4a080e7          	jalr	-182(ra) # 80001834 <wakeup>
    800018f2:	b7d5                	j	800018d6 <reparent+0x2c>
}
    800018f4:	70a2                	ld	ra,40(sp)
    800018f6:	7402                	ld	s0,32(sp)
    800018f8:	64e2                	ld	s1,24(sp)
    800018fa:	6942                	ld	s2,16(sp)
    800018fc:	69a2                	ld	s3,8(sp)
    800018fe:	6a02                	ld	s4,0(sp)
    80001900:	6145                	addi	sp,sp,48
    80001902:	8082                	ret

0000000080001904 <exit>:
{
    80001904:	7179                	addi	sp,sp,-48
    80001906:	f406                	sd	ra,40(sp)
    80001908:	f022                	sd	s0,32(sp)
    8000190a:	ec26                	sd	s1,24(sp)
    8000190c:	e84a                	sd	s2,16(sp)
    8000190e:	e44e                	sd	s3,8(sp)
    80001910:	e052                	sd	s4,0(sp)
    80001912:	1800                	addi	s0,sp,48
    80001914:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	6c8080e7          	jalr	1736(ra) # 80000fde <myproc>
    8000191e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001920:	00007797          	auipc	a5,0x7
    80001924:	6f07b783          	ld	a5,1776(a5) # 80009010 <initproc>
    80001928:	0d050493          	addi	s1,a0,208
    8000192c:	15050913          	addi	s2,a0,336
    80001930:	02a79363          	bne	a5,a0,80001956 <exit+0x52>
    panic("init exiting");
    80001934:	00007517          	auipc	a0,0x7
    80001938:	8d450513          	addi	a0,a0,-1836 # 80008208 <etext+0x208>
    8000193c:	00004097          	auipc	ra,0x4
    80001940:	48c080e7          	jalr	1164(ra) # 80005dc8 <panic>
      fileclose(f);
    80001944:	00002097          	auipc	ra,0x2
    80001948:	278080e7          	jalr	632(ra) # 80003bbc <fileclose>
      p->ofile[fd] = 0;
    8000194c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001950:	04a1                	addi	s1,s1,8
    80001952:	01248563          	beq	s1,s2,8000195c <exit+0x58>
    if(p->ofile[fd]){
    80001956:	6088                	ld	a0,0(s1)
    80001958:	f575                	bnez	a0,80001944 <exit+0x40>
    8000195a:	bfdd                	j	80001950 <exit+0x4c>
  begin_op();
    8000195c:	00002097          	auipc	ra,0x2
    80001960:	d94080e7          	jalr	-620(ra) # 800036f0 <begin_op>
  iput(p->cwd);
    80001964:	1509b503          	ld	a0,336(s3)
    80001968:	00001097          	auipc	ra,0x1
    8000196c:	570080e7          	jalr	1392(ra) # 80002ed8 <iput>
  end_op();
    80001970:	00002097          	auipc	ra,0x2
    80001974:	e00080e7          	jalr	-512(ra) # 80003770 <end_op>
  p->cwd = 0;
    80001978:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000197c:	0008f497          	auipc	s1,0x8f
    80001980:	70448493          	addi	s1,s1,1796 # 80091080 <wait_lock>
    80001984:	8526                	mv	a0,s1
    80001986:	00005097          	auipc	ra,0x5
    8000198a:	98c080e7          	jalr	-1652(ra) # 80006312 <acquire>
  reparent(p);
    8000198e:	854e                	mv	a0,s3
    80001990:	00000097          	auipc	ra,0x0
    80001994:	f1a080e7          	jalr	-230(ra) # 800018aa <reparent>
  wakeup(p->parent);
    80001998:	0389b503          	ld	a0,56(s3)
    8000199c:	00000097          	auipc	ra,0x0
    800019a0:	e98080e7          	jalr	-360(ra) # 80001834 <wakeup>
  acquire(&p->lock);
    800019a4:	854e                	mv	a0,s3
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	96c080e7          	jalr	-1684(ra) # 80006312 <acquire>
  p->xstate = status;
    800019ae:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019b2:	4795                	li	a5,5
    800019b4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019b8:	8526                	mv	a0,s1
    800019ba:	00005097          	auipc	ra,0x5
    800019be:	a0c080e7          	jalr	-1524(ra) # 800063c6 <release>
  sched();
    800019c2:	00000097          	auipc	ra,0x0
    800019c6:	bd4080e7          	jalr	-1068(ra) # 80001596 <sched>
  panic("zombie exit");
    800019ca:	00007517          	auipc	a0,0x7
    800019ce:	84e50513          	addi	a0,a0,-1970 # 80008218 <etext+0x218>
    800019d2:	00004097          	auipc	ra,0x4
    800019d6:	3f6080e7          	jalr	1014(ra) # 80005dc8 <panic>

00000000800019da <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019da:	7179                	addi	sp,sp,-48
    800019dc:	f406                	sd	ra,40(sp)
    800019de:	f022                	sd	s0,32(sp)
    800019e0:	ec26                	sd	s1,24(sp)
    800019e2:	e84a                	sd	s2,16(sp)
    800019e4:	e44e                	sd	s3,8(sp)
    800019e6:	1800                	addi	s0,sp,48
    800019e8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019ea:	00090497          	auipc	s1,0x90
    800019ee:	aae48493          	addi	s1,s1,-1362 # 80091498 <proc>
    800019f2:	0009a997          	auipc	s3,0x9a
    800019f6:	2a698993          	addi	s3,s3,678 # 8009bc98 <tickslock>
    acquire(&p->lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	00005097          	auipc	ra,0x5
    80001a00:	916080e7          	jalr	-1770(ra) # 80006312 <acquire>
    if(p->pid == pid){
    80001a04:	589c                	lw	a5,48(s1)
    80001a06:	01278d63          	beq	a5,s2,80001a20 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	00005097          	auipc	ra,0x5
    80001a10:	9ba080e7          	jalr	-1606(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a14:	2a048493          	addi	s1,s1,672
    80001a18:	ff3491e3          	bne	s1,s3,800019fa <kill+0x20>
  }
  return -1;
    80001a1c:	557d                	li	a0,-1
    80001a1e:	a829                	j	80001a38 <kill+0x5e>
      p->killed = 1;
    80001a20:	4785                	li	a5,1
    80001a22:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a24:	4c98                	lw	a4,24(s1)
    80001a26:	4789                	li	a5,2
    80001a28:	00f70f63          	beq	a4,a5,80001a46 <kill+0x6c>
      release(&p->lock);
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	00005097          	auipc	ra,0x5
    80001a32:	998080e7          	jalr	-1640(ra) # 800063c6 <release>
      return 0;
    80001a36:	4501                	li	a0,0
}
    80001a38:	70a2                	ld	ra,40(sp)
    80001a3a:	7402                	ld	s0,32(sp)
    80001a3c:	64e2                	ld	s1,24(sp)
    80001a3e:	6942                	ld	s2,16(sp)
    80001a40:	69a2                	ld	s3,8(sp)
    80001a42:	6145                	addi	sp,sp,48
    80001a44:	8082                	ret
        p->state = RUNNABLE;
    80001a46:	478d                	li	a5,3
    80001a48:	cc9c                	sw	a5,24(s1)
    80001a4a:	b7cd                	j	80001a2c <kill+0x52>

0000000080001a4c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a4c:	7179                	addi	sp,sp,-48
    80001a4e:	f406                	sd	ra,40(sp)
    80001a50:	f022                	sd	s0,32(sp)
    80001a52:	ec26                	sd	s1,24(sp)
    80001a54:	e84a                	sd	s2,16(sp)
    80001a56:	e44e                	sd	s3,8(sp)
    80001a58:	e052                	sd	s4,0(sp)
    80001a5a:	1800                	addi	s0,sp,48
    80001a5c:	84aa                	mv	s1,a0
    80001a5e:	892e                	mv	s2,a1
    80001a60:	89b2                	mv	s3,a2
    80001a62:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	57a080e7          	jalr	1402(ra) # 80000fde <myproc>
  if(user_dst){
    80001a6c:	c08d                	beqz	s1,80001a8e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a6e:	86d2                	mv	a3,s4
    80001a70:	864e                	mv	a2,s3
    80001a72:	85ca                	mv	a1,s2
    80001a74:	6928                	ld	a0,80(a0)
    80001a76:	fffff097          	auipc	ra,0xfffff
    80001a7a:	182080e7          	jalr	386(ra) # 80000bf8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a7e:	70a2                	ld	ra,40(sp)
    80001a80:	7402                	ld	s0,32(sp)
    80001a82:	64e2                	ld	s1,24(sp)
    80001a84:	6942                	ld	s2,16(sp)
    80001a86:	69a2                	ld	s3,8(sp)
    80001a88:	6a02                	ld	s4,0(sp)
    80001a8a:	6145                	addi	sp,sp,48
    80001a8c:	8082                	ret
    memmove((char *)dst, src, len);
    80001a8e:	000a061b          	sext.w	a2,s4
    80001a92:	85ce                	mv	a1,s3
    80001a94:	854a                	mv	a0,s2
    80001a96:	ffffe097          	auipc	ra,0xffffe
    80001a9a:	7aa080e7          	jalr	1962(ra) # 80000240 <memmove>
    return 0;
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	bff9                	j	80001a7e <either_copyout+0x32>

0000000080001aa2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aa2:	7179                	addi	sp,sp,-48
    80001aa4:	f406                	sd	ra,40(sp)
    80001aa6:	f022                	sd	s0,32(sp)
    80001aa8:	ec26                	sd	s1,24(sp)
    80001aaa:	e84a                	sd	s2,16(sp)
    80001aac:	e44e                	sd	s3,8(sp)
    80001aae:	e052                	sd	s4,0(sp)
    80001ab0:	1800                	addi	s0,sp,48
    80001ab2:	892a                	mv	s2,a0
    80001ab4:	84ae                	mv	s1,a1
    80001ab6:	89b2                	mv	s3,a2
    80001ab8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	524080e7          	jalr	1316(ra) # 80000fde <myproc>
  if(user_src){
    80001ac2:	c08d                	beqz	s1,80001ae4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ac4:	86d2                	mv	a3,s4
    80001ac6:	864e                	mv	a2,s3
    80001ac8:	85ca                	mv	a1,s2
    80001aca:	6928                	ld	a0,80(a0)
    80001acc:	fffff097          	auipc	ra,0xfffff
    80001ad0:	260080e7          	jalr	608(ra) # 80000d2c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ad4:	70a2                	ld	ra,40(sp)
    80001ad6:	7402                	ld	s0,32(sp)
    80001ad8:	64e2                	ld	s1,24(sp)
    80001ada:	6942                	ld	s2,16(sp)
    80001adc:	69a2                	ld	s3,8(sp)
    80001ade:	6a02                	ld	s4,0(sp)
    80001ae0:	6145                	addi	sp,sp,48
    80001ae2:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ae4:	000a061b          	sext.w	a2,s4
    80001ae8:	85ce                	mv	a1,s3
    80001aea:	854a                	mv	a0,s2
    80001aec:	ffffe097          	auipc	ra,0xffffe
    80001af0:	754080e7          	jalr	1876(ra) # 80000240 <memmove>
    return 0;
    80001af4:	8526                	mv	a0,s1
    80001af6:	bff9                	j	80001ad4 <either_copyin+0x32>

0000000080001af8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001af8:	715d                	addi	sp,sp,-80
    80001afa:	e486                	sd	ra,72(sp)
    80001afc:	e0a2                	sd	s0,64(sp)
    80001afe:	fc26                	sd	s1,56(sp)
    80001b00:	f84a                	sd	s2,48(sp)
    80001b02:	f44e                	sd	s3,40(sp)
    80001b04:	f052                	sd	s4,32(sp)
    80001b06:	ec56                	sd	s5,24(sp)
    80001b08:	e85a                	sd	s6,16(sp)
    80001b0a:	e45e                	sd	s7,8(sp)
    80001b0c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b0e:	00006517          	auipc	a0,0x6
    80001b12:	54250513          	addi	a0,a0,1346 # 80008050 <etext+0x50>
    80001b16:	00004097          	auipc	ra,0x4
    80001b1a:	2fc080e7          	jalr	764(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b1e:	00090497          	auipc	s1,0x90
    80001b22:	ad248493          	addi	s1,s1,-1326 # 800915f0 <proc+0x158>
    80001b26:	0009a917          	auipc	s2,0x9a
    80001b2a:	2ca90913          	addi	s2,s2,714 # 8009bdf0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b2e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b30:	00006997          	auipc	s3,0x6
    80001b34:	6f898993          	addi	s3,s3,1784 # 80008228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80001b38:	00006a97          	auipc	s5,0x6
    80001b3c:	6f8a8a93          	addi	s5,s5,1784 # 80008230 <etext+0x230>
    printf("\n");
    80001b40:	00006a17          	auipc	s4,0x6
    80001b44:	510a0a13          	addi	s4,s4,1296 # 80008050 <etext+0x50>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b48:	00006b97          	auipc	s7,0x6
    80001b4c:	720b8b93          	addi	s7,s7,1824 # 80008268 <states.1718>
    80001b50:	a00d                	j	80001b72 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b52:	ed86a583          	lw	a1,-296(a3)
    80001b56:	8556                	mv	a0,s5
    80001b58:	00004097          	auipc	ra,0x4
    80001b5c:	2ba080e7          	jalr	698(ra) # 80005e12 <printf>
    printf("\n");
    80001b60:	8552                	mv	a0,s4
    80001b62:	00004097          	auipc	ra,0x4
    80001b66:	2b0080e7          	jalr	688(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b6a:	2a048493          	addi	s1,s1,672
    80001b6e:	03248163          	beq	s1,s2,80001b90 <procdump+0x98>
    if(p->state == UNUSED)
    80001b72:	86a6                	mv	a3,s1
    80001b74:	ec04a783          	lw	a5,-320(s1)
    80001b78:	dbed                	beqz	a5,80001b6a <procdump+0x72>
      state = "???";
    80001b7a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b7c:	fcfb6be3          	bltu	s6,a5,80001b52 <procdump+0x5a>
    80001b80:	1782                	slli	a5,a5,0x20
    80001b82:	9381                	srli	a5,a5,0x20
    80001b84:	078e                	slli	a5,a5,0x3
    80001b86:	97de                	add	a5,a5,s7
    80001b88:	6390                	ld	a2,0(a5)
    80001b8a:	f661                	bnez	a2,80001b52 <procdump+0x5a>
      state = "???";
    80001b8c:	864e                	mv	a2,s3
    80001b8e:	b7d1                	j	80001b52 <procdump+0x5a>
  }
}
    80001b90:	60a6                	ld	ra,72(sp)
    80001b92:	6406                	ld	s0,64(sp)
    80001b94:	74e2                	ld	s1,56(sp)
    80001b96:	7942                	ld	s2,48(sp)
    80001b98:	79a2                	ld	s3,40(sp)
    80001b9a:	7a02                	ld	s4,32(sp)
    80001b9c:	6ae2                	ld	s5,24(sp)
    80001b9e:	6b42                	ld	s6,16(sp)
    80001ba0:	6ba2                	ld	s7,8(sp)
    80001ba2:	6161                	addi	sp,sp,80
    80001ba4:	8082                	ret

0000000080001ba6 <swtch>:
    80001ba6:	00153023          	sd	ra,0(a0)
    80001baa:	00253423          	sd	sp,8(a0)
    80001bae:	e900                	sd	s0,16(a0)
    80001bb0:	ed04                	sd	s1,24(a0)
    80001bb2:	03253023          	sd	s2,32(a0)
    80001bb6:	03353423          	sd	s3,40(a0)
    80001bba:	03453823          	sd	s4,48(a0)
    80001bbe:	03553c23          	sd	s5,56(a0)
    80001bc2:	05653023          	sd	s6,64(a0)
    80001bc6:	05753423          	sd	s7,72(a0)
    80001bca:	05853823          	sd	s8,80(a0)
    80001bce:	05953c23          	sd	s9,88(a0)
    80001bd2:	07a53023          	sd	s10,96(a0)
    80001bd6:	07b53423          	sd	s11,104(a0)
    80001bda:	0005b083          	ld	ra,0(a1)
    80001bde:	0085b103          	ld	sp,8(a1)
    80001be2:	6980                	ld	s0,16(a1)
    80001be4:	6d84                	ld	s1,24(a1)
    80001be6:	0205b903          	ld	s2,32(a1)
    80001bea:	0285b983          	ld	s3,40(a1)
    80001bee:	0305ba03          	ld	s4,48(a1)
    80001bf2:	0385ba83          	ld	s5,56(a1)
    80001bf6:	0405bb03          	ld	s6,64(a1)
    80001bfa:	0485bb83          	ld	s7,72(a1)
    80001bfe:	0505bc03          	ld	s8,80(a1)
    80001c02:	0585bc83          	ld	s9,88(a1)
    80001c06:	0605bd03          	ld	s10,96(a1)
    80001c0a:	0685bd83          	ld	s11,104(a1)
    80001c0e:	8082                	ret

0000000080001c10 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c10:	1141                	addi	sp,sp,-16
    80001c12:	e406                	sd	ra,8(sp)
    80001c14:	e022                	sd	s0,0(sp)
    80001c16:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c18:	00006597          	auipc	a1,0x6
    80001c1c:	68058593          	addi	a1,a1,1664 # 80008298 <states.1718+0x30>
    80001c20:	0009a517          	auipc	a0,0x9a
    80001c24:	07850513          	addi	a0,a0,120 # 8009bc98 <tickslock>
    80001c28:	00004097          	auipc	ra,0x4
    80001c2c:	65a080e7          	jalr	1626(ra) # 80006282 <initlock>
}
    80001c30:	60a2                	ld	ra,8(sp)
    80001c32:	6402                	ld	s0,0(sp)
    80001c34:	0141                	addi	sp,sp,16
    80001c36:	8082                	ret

0000000080001c38 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c38:	1141                	addi	sp,sp,-16
    80001c3a:	e422                	sd	s0,8(sp)
    80001c3c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c3e:	00003797          	auipc	a5,0x3
    80001c42:	59278793          	addi	a5,a5,1426 # 800051d0 <kernelvec>
    80001c46:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c4a:	6422                	ld	s0,8(sp)
    80001c4c:	0141                	addi	sp,sp,16
    80001c4e:	8082                	ret

0000000080001c50 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c50:	1141                	addi	sp,sp,-16
    80001c52:	e406                	sd	ra,8(sp)
    80001c54:	e022                	sd	s0,0(sp)
    80001c56:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c58:	fffff097          	auipc	ra,0xfffff
    80001c5c:	386080e7          	jalr	902(ra) # 80000fde <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c64:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c66:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c6a:	00005617          	auipc	a2,0x5
    80001c6e:	39660613          	addi	a2,a2,918 # 80007000 <_trampoline>
    80001c72:	00005697          	auipc	a3,0x5
    80001c76:	38e68693          	addi	a3,a3,910 # 80007000 <_trampoline>
    80001c7a:	8e91                	sub	a3,a3,a2
    80001c7c:	040007b7          	lui	a5,0x4000
    80001c80:	17fd                	addi	a5,a5,-1
    80001c82:	07b2                	slli	a5,a5,0xc
    80001c84:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c86:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c8a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c8c:	180026f3          	csrr	a3,satp
    80001c90:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c92:	6d38                	ld	a4,88(a0)
    80001c94:	6134                	ld	a3,64(a0)
    80001c96:	6585                	lui	a1,0x1
    80001c98:	96ae                	add	a3,a3,a1
    80001c9a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c9c:	6d38                	ld	a4,88(a0)
    80001c9e:	00000697          	auipc	a3,0x0
    80001ca2:	13868693          	addi	a3,a3,312 # 80001dd6 <usertrap>
    80001ca6:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ca8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001caa:	8692                	mv	a3,tp
    80001cac:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cae:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cb2:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cb6:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cba:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cbe:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cc0:	6f18                	ld	a4,24(a4)
    80001cc2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cc6:	692c                	ld	a1,80(a0)
    80001cc8:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cca:	00005717          	auipc	a4,0x5
    80001cce:	3c670713          	addi	a4,a4,966 # 80007090 <userret>
    80001cd2:	8f11                	sub	a4,a4,a2
    80001cd4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cd6:	577d                	li	a4,-1
    80001cd8:	177e                	slli	a4,a4,0x3f
    80001cda:	8dd9                	or	a1,a1,a4
    80001cdc:	02000537          	lui	a0,0x2000
    80001ce0:	157d                	addi	a0,a0,-1
    80001ce2:	0536                	slli	a0,a0,0xd
    80001ce4:	9782                	jalr	a5
}
    80001ce6:	60a2                	ld	ra,8(sp)
    80001ce8:	6402                	ld	s0,0(sp)
    80001cea:	0141                	addi	sp,sp,16
    80001cec:	8082                	ret

0000000080001cee <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cee:	1101                	addi	sp,sp,-32
    80001cf0:	ec06                	sd	ra,24(sp)
    80001cf2:	e822                	sd	s0,16(sp)
    80001cf4:	e426                	sd	s1,8(sp)
    80001cf6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cf8:	0009a497          	auipc	s1,0x9a
    80001cfc:	fa048493          	addi	s1,s1,-96 # 8009bc98 <tickslock>
    80001d00:	8526                	mv	a0,s1
    80001d02:	00004097          	auipc	ra,0x4
    80001d06:	610080e7          	jalr	1552(ra) # 80006312 <acquire>
  ticks++;
    80001d0a:	00007517          	auipc	a0,0x7
    80001d0e:	30e50513          	addi	a0,a0,782 # 80009018 <ticks>
    80001d12:	411c                	lw	a5,0(a0)
    80001d14:	2785                	addiw	a5,a5,1
    80001d16:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	b1c080e7          	jalr	-1252(ra) # 80001834 <wakeup>
  release(&tickslock);
    80001d20:	8526                	mv	a0,s1
    80001d22:	00004097          	auipc	ra,0x4
    80001d26:	6a4080e7          	jalr	1700(ra) # 800063c6 <release>
}
    80001d2a:	60e2                	ld	ra,24(sp)
    80001d2c:	6442                	ld	s0,16(sp)
    80001d2e:	64a2                	ld	s1,8(sp)
    80001d30:	6105                	addi	sp,sp,32
    80001d32:	8082                	ret

0000000080001d34 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d34:	1101                	addi	sp,sp,-32
    80001d36:	ec06                	sd	ra,24(sp)
    80001d38:	e822                	sd	s0,16(sp)
    80001d3a:	e426                	sd	s1,8(sp)
    80001d3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d42:	00074d63          	bltz	a4,80001d5c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d46:	57fd                	li	a5,-1
    80001d48:	17fe                	slli	a5,a5,0x3f
    80001d4a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d4c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d4e:	06f70363          	beq	a4,a5,80001db4 <devintr+0x80>
  }
}
    80001d52:	60e2                	ld	ra,24(sp)
    80001d54:	6442                	ld	s0,16(sp)
    80001d56:	64a2                	ld	s1,8(sp)
    80001d58:	6105                	addi	sp,sp,32
    80001d5a:	8082                	ret
     (scause & 0xff) == 9){
    80001d5c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d60:	46a5                	li	a3,9
    80001d62:	fed792e3          	bne	a5,a3,80001d46 <devintr+0x12>
    int irq = plic_claim();
    80001d66:	00003097          	auipc	ra,0x3
    80001d6a:	572080e7          	jalr	1394(ra) # 800052d8 <plic_claim>
    80001d6e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d70:	47a9                	li	a5,10
    80001d72:	02f50763          	beq	a0,a5,80001da0 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d76:	4785                	li	a5,1
    80001d78:	02f50963          	beq	a0,a5,80001daa <devintr+0x76>
    return 1;
    80001d7c:	4505                	li	a0,1
    } else if(irq){
    80001d7e:	d8f1                	beqz	s1,80001d52 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d80:	85a6                	mv	a1,s1
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	51e50513          	addi	a0,a0,1310 # 800082a0 <states.1718+0x38>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	088080e7          	jalr	136(ra) # 80005e12 <printf>
      plic_complete(irq);
    80001d92:	8526                	mv	a0,s1
    80001d94:	00003097          	auipc	ra,0x3
    80001d98:	568080e7          	jalr	1384(ra) # 800052fc <plic_complete>
    return 1;
    80001d9c:	4505                	li	a0,1
    80001d9e:	bf55                	j	80001d52 <devintr+0x1e>
      uartintr();
    80001da0:	00004097          	auipc	ra,0x4
    80001da4:	492080e7          	jalr	1170(ra) # 80006232 <uartintr>
    80001da8:	b7ed                	j	80001d92 <devintr+0x5e>
      virtio_disk_intr();
    80001daa:	00004097          	auipc	ra,0x4
    80001dae:	a32080e7          	jalr	-1486(ra) # 800057dc <virtio_disk_intr>
    80001db2:	b7c5                	j	80001d92 <devintr+0x5e>
    if(cpuid() == 0){
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	1fe080e7          	jalr	510(ra) # 80000fb2 <cpuid>
    80001dbc:	c901                	beqz	a0,80001dcc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dbe:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dc2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dc4:	14479073          	csrw	sip,a5
    return 2;
    80001dc8:	4509                	li	a0,2
    80001dca:	b761                	j	80001d52 <devintr+0x1e>
      clockintr();
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	f22080e7          	jalr	-222(ra) # 80001cee <clockintr>
    80001dd4:	b7ed                	j	80001dbe <devintr+0x8a>

0000000080001dd6 <usertrap>:
{
    80001dd6:	7139                	addi	sp,sp,-64
    80001dd8:	fc06                	sd	ra,56(sp)
    80001dda:	f822                	sd	s0,48(sp)
    80001ddc:	f426                	sd	s1,40(sp)
    80001dde:	f04a                	sd	s2,32(sp)
    80001de0:	ec4e                	sd	s3,24(sp)
    80001de2:	e852                	sd	s4,16(sp)
    80001de4:	e456                	sd	s5,8(sp)
    80001de6:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dec:	1007f793          	andi	a5,a5,256
    80001df0:	e7ad                	bnez	a5,80001e5a <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001df2:	00003797          	auipc	a5,0x3
    80001df6:	3de78793          	addi	a5,a5,990 # 800051d0 <kernelvec>
    80001dfa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	1e0080e7          	jalr	480(ra) # 80000fde <myproc>
    80001e06:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e08:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0a:	14102773          	csrr	a4,sepc
    80001e0e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e10:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e14:	47a1                	li	a5,8
    80001e16:	06f71063          	bne	a4,a5,80001e76 <usertrap+0xa0>
    if(p->killed)
    80001e1a:	551c                	lw	a5,40(a0)
    80001e1c:	e7b9                	bnez	a5,80001e6a <usertrap+0x94>
    p->trapframe->epc += 4;
    80001e1e:	6cb8                	ld	a4,88(s1)
    80001e20:	6f1c                	ld	a5,24(a4)
    80001e22:	0791                	addi	a5,a5,4
    80001e24:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10079073          	csrw	sstatus,a5
    syscall();
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	3ee080e7          	jalr	1006(ra) # 80002220 <syscall>
  if(p->killed)
    80001e3a:	549c                	lw	a5,40(s1)
    80001e3c:	18079363          	bnez	a5,80001fc2 <usertrap+0x1ec>
  usertrapret();
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	e10080e7          	jalr	-496(ra) # 80001c50 <usertrapret>
}
    80001e48:	70e2                	ld	ra,56(sp)
    80001e4a:	7442                	ld	s0,48(sp)
    80001e4c:	74a2                	ld	s1,40(sp)
    80001e4e:	7902                	ld	s2,32(sp)
    80001e50:	69e2                	ld	s3,24(sp)
    80001e52:	6a42                	ld	s4,16(sp)
    80001e54:	6aa2                	ld	s5,8(sp)
    80001e56:	6121                	addi	sp,sp,64
    80001e58:	8082                	ret
    panic("usertrap: not from user mode");
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	46650513          	addi	a0,a0,1126 # 800082c0 <states.1718+0x58>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	f66080e7          	jalr	-154(ra) # 80005dc8 <panic>
      exit(-1);
    80001e6a:	557d                	li	a0,-1
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	a98080e7          	jalr	-1384(ra) # 80001904 <exit>
    80001e74:	b76d                	j	80001e1e <usertrap+0x48>
  } else if((which_dev = devintr()) != 0){
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	ebe080e7          	jalr	-322(ra) # 80001d34 <devintr>
    80001e7e:	892a                	mv	s2,a0
    80001e80:	12051e63          	bnez	a0,80001fbc <usertrap+0x1e6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e84:	14202773          	csrr	a4,scause
  } else if (r_scause() == 12 || r_scause() == 15){
    80001e88:	47b1                	li	a5,12
    80001e8a:	00f70763          	beq	a4,a5,80001e98 <usertrap+0xc2>
    80001e8e:	14202773          	csrr	a4,scause
    80001e92:	47bd                	li	a5,15
    80001e94:	0ef71a63          	bne	a4,a5,80001f88 <usertrap+0x1b2>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e98:	14302973          	csrr	s2,stval
    if(va >= MAXVA)
    80001e9c:	57fd                	li	a5,-1
    80001e9e:	83e9                	srli	a5,a5,0x1a
    80001ea0:	0927ec63          	bltu	a5,s2,80001f38 <usertrap+0x162>
    if((pte = walk(p->pagetable, va, 0)) == 0)
    80001ea4:	4601                	li	a2,0
    80001ea6:	85ca                	mv	a1,s2
    80001ea8:	68a8                	ld	a0,80(s1)
    80001eaa:	ffffe097          	auipc	ra,0xffffe
    80001eae:	61e080e7          	jalr	1566(ra) # 800004c8 <walk>
    80001eb2:	89aa                	mv	s3,a0
    80001eb4:	c951                	beqz	a0,80001f48 <usertrap+0x172>
    if((*pte & PTE_V) == 0)
    80001eb6:	0009b783          	ld	a5,0(s3)
    80001eba:	8b85                	andi	a5,a5,1
    80001ebc:	cfd1                	beqz	a5,80001f58 <usertrap+0x182>
    if((*pte & PTE_COW) == 0)
    80001ebe:	0009b783          	ld	a5,0(s3)
    80001ec2:	1007f793          	andi	a5,a5,256
    80001ec6:	c3cd                	beqz	a5,80001f68 <usertrap+0x192>
    pa = PTE2PA(*pte);
    80001ec8:	0009b703          	ld	a4,0(s3)
    80001ecc:	00a75a93          	srli	s5,a4,0xa
    80001ed0:	0ab2                	slli	s5,s5,0xc
    flags &= ~(PTE_COW);
    80001ed2:	2fb77713          	andi	a4,a4,763
    80001ed6:	00476993          	ori	s3,a4,4
    if((mem = kalloc()) == 0)
    80001eda:	ffffe097          	auipc	ra,0xffffe
    80001ede:	28e080e7          	jalr	654(ra) # 80000168 <kalloc>
    80001ee2:	8a2a                	mv	s4,a0
    80001ee4:	c951                	beqz	a0,80001f78 <usertrap+0x1a2>
    memmove(mem, (char*)pa, PGSIZE);
    80001ee6:	6605                	lui	a2,0x1
    80001ee8:	85d6                	mv	a1,s5
    80001eea:	8552                	mv	a0,s4
    80001eec:	ffffe097          	auipc	ra,0xffffe
    80001ef0:	354080e7          	jalr	852(ra) # 80000240 <memmove>
    uvmunmap(p->pagetable, PGROUNDDOWN(va), 1, 1);
    80001ef4:	77fd                	lui	a5,0xfffff
    80001ef6:	00f97933          	and	s2,s2,a5
    80001efa:	4685                	li	a3,1
    80001efc:	4605                	li	a2,1
    80001efe:	85ca                	mv	a1,s2
    80001f00:	68a8                	ld	a0,80(s1)
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	874080e7          	jalr	-1932(ra) # 80000776 <uvmunmap>
    if(mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, flags) != 0){
    80001f0a:	874e                	mv	a4,s3
    80001f0c:	86d2                	mv	a3,s4
    80001f0e:	6605                	lui	a2,0x1
    80001f10:	85ca                	mv	a1,s2
    80001f12:	68a8                	ld	a0,80(s1)
    80001f14:	ffffe097          	auipc	ra,0xffffe
    80001f18:	69c080e7          	jalr	1692(ra) # 800005b0 <mappages>
    80001f1c:	dd19                	beqz	a0,80001e3a <usertrap+0x64>
      kfree(mem);
    80001f1e:	8552                	mv	a0,s4
    80001f20:	ffffe097          	auipc	ra,0xffffe
    80001f24:	0fc080e7          	jalr	252(ra) # 8000001c <kfree>
      panic("cowhandler: mappages failed");
    80001f28:	00006517          	auipc	a0,0x6
    80001f2c:	3b850513          	addi	a0,a0,952 # 800082e0 <states.1718+0x78>
    80001f30:	00004097          	auipc	ra,0x4
    80001f34:	e98080e7          	jalr	-360(ra) # 80005dc8 <panic>
      p->killed = 1;
    80001f38:	4785                	li	a5,1
    80001f3a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f3c:	557d                	li	a0,-1
    80001f3e:	00000097          	auipc	ra,0x0
    80001f42:	9c6080e7          	jalr	-1594(ra) # 80001904 <exit>
    80001f46:	bfb9                	j	80001ea4 <usertrap+0xce>
      p->killed = 1;
    80001f48:	4785                	li	a5,1
    80001f4a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f4c:	557d                	li	a0,-1
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	9b6080e7          	jalr	-1610(ra) # 80001904 <exit>
    80001f56:	b785                	j	80001eb6 <usertrap+0xe0>
      p->killed = 1;
    80001f58:	4785                	li	a5,1
    80001f5a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f5c:	557d                	li	a0,-1
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	9a6080e7          	jalr	-1626(ra) # 80001904 <exit>
    80001f66:	bfa1                	j	80001ebe <usertrap+0xe8>
      p->killed = 1;
    80001f68:	4785                	li	a5,1
    80001f6a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f6c:	557d                	li	a0,-1
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	996080e7          	jalr	-1642(ra) # 80001904 <exit>
    80001f76:	bf89                	j	80001ec8 <usertrap+0xf2>
      p->killed = 1;
    80001f78:	4785                	li	a5,1
    80001f7a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f7c:	557d                	li	a0,-1
    80001f7e:	00000097          	auipc	ra,0x0
    80001f82:	986080e7          	jalr	-1658(ra) # 80001904 <exit>
    80001f86:	b785                	j	80001ee6 <usertrap+0x110>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f88:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f8c:	5890                	lw	a2,48(s1)
    80001f8e:	00006517          	auipc	a0,0x6
    80001f92:	37250513          	addi	a0,a0,882 # 80008300 <states.1718+0x98>
    80001f96:	00004097          	auipc	ra,0x4
    80001f9a:	e7c080e7          	jalr	-388(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f9e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fa2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fa6:	00006517          	auipc	a0,0x6
    80001faa:	38a50513          	addi	a0,a0,906 # 80008330 <states.1718+0xc8>
    80001fae:	00004097          	auipc	ra,0x4
    80001fb2:	e64080e7          	jalr	-412(ra) # 80005e12 <printf>
    p->killed = 1;
    80001fb6:	4785                	li	a5,1
    80001fb8:	d49c                	sw	a5,40(s1)
  if(p->killed)
    80001fba:	a029                	j	80001fc4 <usertrap+0x1ee>
    80001fbc:	549c                	lw	a5,40(s1)
    80001fbe:	cb81                	beqz	a5,80001fce <usertrap+0x1f8>
    80001fc0:	a011                	j	80001fc4 <usertrap+0x1ee>
    80001fc2:	4901                	li	s2,0
    exit(-1);
    80001fc4:	557d                	li	a0,-1
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	93e080e7          	jalr	-1730(ra) # 80001904 <exit>
  if(which_dev == 2)
    80001fce:	4789                	li	a5,2
    80001fd0:	e6f918e3          	bne	s2,a5,80001e40 <usertrap+0x6a>
    yield();
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	698080e7          	jalr	1688(ra) # 8000166c <yield>
    80001fdc:	b595                	j	80001e40 <usertrap+0x6a>

0000000080001fde <kerneltrap>:
{
    80001fde:	7179                	addi	sp,sp,-48
    80001fe0:	f406                	sd	ra,40(sp)
    80001fe2:	f022                	sd	s0,32(sp)
    80001fe4:	ec26                	sd	s1,24(sp)
    80001fe6:	e84a                	sd	s2,16(sp)
    80001fe8:	e44e                	sd	s3,8(sp)
    80001fea:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fec:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ff4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ff8:	1004f793          	andi	a5,s1,256
    80001ffc:	cb85                	beqz	a5,8000202c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ffe:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002002:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002004:	ef85                	bnez	a5,8000203c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002006:	00000097          	auipc	ra,0x0
    8000200a:	d2e080e7          	jalr	-722(ra) # 80001d34 <devintr>
    8000200e:	cd1d                	beqz	a0,8000204c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002010:	4789                	li	a5,2
    80002012:	06f50a63          	beq	a0,a5,80002086 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002016:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000201a:	10049073          	csrw	sstatus,s1
}
    8000201e:	70a2                	ld	ra,40(sp)
    80002020:	7402                	ld	s0,32(sp)
    80002022:	64e2                	ld	s1,24(sp)
    80002024:	6942                	ld	s2,16(sp)
    80002026:	69a2                	ld	s3,8(sp)
    80002028:	6145                	addi	sp,sp,48
    8000202a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000202c:	00006517          	auipc	a0,0x6
    80002030:	32450513          	addi	a0,a0,804 # 80008350 <states.1718+0xe8>
    80002034:	00004097          	auipc	ra,0x4
    80002038:	d94080e7          	jalr	-620(ra) # 80005dc8 <panic>
    panic("kerneltrap: interrupts enabled");
    8000203c:	00006517          	auipc	a0,0x6
    80002040:	33c50513          	addi	a0,a0,828 # 80008378 <states.1718+0x110>
    80002044:	00004097          	auipc	ra,0x4
    80002048:	d84080e7          	jalr	-636(ra) # 80005dc8 <panic>
    printf("scause %p\n", scause);
    8000204c:	85ce                	mv	a1,s3
    8000204e:	00006517          	auipc	a0,0x6
    80002052:	34a50513          	addi	a0,a0,842 # 80008398 <states.1718+0x130>
    80002056:	00004097          	auipc	ra,0x4
    8000205a:	dbc080e7          	jalr	-580(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000205e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002062:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	34250513          	addi	a0,a0,834 # 800083a8 <states.1718+0x140>
    8000206e:	00004097          	auipc	ra,0x4
    80002072:	da4080e7          	jalr	-604(ra) # 80005e12 <printf>
    panic("kerneltrap");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	34a50513          	addi	a0,a0,842 # 800083c0 <states.1718+0x158>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	d4a080e7          	jalr	-694(ra) # 80005dc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	f58080e7          	jalr	-168(ra) # 80000fde <myproc>
    8000208e:	d541                	beqz	a0,80002016 <kerneltrap+0x38>
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	f4e080e7          	jalr	-178(ra) # 80000fde <myproc>
    80002098:	4d18                	lw	a4,24(a0)
    8000209a:	4791                	li	a5,4
    8000209c:	f6f71de3          	bne	a4,a5,80002016 <kerneltrap+0x38>
    yield();
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	5cc080e7          	jalr	1484(ra) # 8000166c <yield>
    800020a8:	b7bd                	j	80002016 <kerneltrap+0x38>

00000000800020aa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020aa:	1101                	addi	sp,sp,-32
    800020ac:	ec06                	sd	ra,24(sp)
    800020ae:	e822                	sd	s0,16(sp)
    800020b0:	e426                	sd	s1,8(sp)
    800020b2:	1000                	addi	s0,sp,32
    800020b4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	f28080e7          	jalr	-216(ra) # 80000fde <myproc>
  switch (n) {
    800020be:	4795                	li	a5,5
    800020c0:	0497e163          	bltu	a5,s1,80002102 <argraw+0x58>
    800020c4:	048a                	slli	s1,s1,0x2
    800020c6:	00006717          	auipc	a4,0x6
    800020ca:	33270713          	addi	a4,a4,818 # 800083f8 <states.1718+0x190>
    800020ce:	94ba                	add	s1,s1,a4
    800020d0:	409c                	lw	a5,0(s1)
    800020d2:	97ba                	add	a5,a5,a4
    800020d4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020d6:	6d3c                	ld	a5,88(a0)
    800020d8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	64a2                	ld	s1,8(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret
    return p->trapframe->a1;
    800020e4:	6d3c                	ld	a5,88(a0)
    800020e6:	7fa8                	ld	a0,120(a5)
    800020e8:	bfcd                	j	800020da <argraw+0x30>
    return p->trapframe->a2;
    800020ea:	6d3c                	ld	a5,88(a0)
    800020ec:	63c8                	ld	a0,128(a5)
    800020ee:	b7f5                	j	800020da <argraw+0x30>
    return p->trapframe->a3;
    800020f0:	6d3c                	ld	a5,88(a0)
    800020f2:	67c8                	ld	a0,136(a5)
    800020f4:	b7dd                	j	800020da <argraw+0x30>
    return p->trapframe->a4;
    800020f6:	6d3c                	ld	a5,88(a0)
    800020f8:	6bc8                	ld	a0,144(a5)
    800020fa:	b7c5                	j	800020da <argraw+0x30>
    return p->trapframe->a5;
    800020fc:	6d3c                	ld	a5,88(a0)
    800020fe:	6fc8                	ld	a0,152(a5)
    80002100:	bfe9                	j	800020da <argraw+0x30>
  panic("argraw");
    80002102:	00006517          	auipc	a0,0x6
    80002106:	2ce50513          	addi	a0,a0,718 # 800083d0 <states.1718+0x168>
    8000210a:	00004097          	auipc	ra,0x4
    8000210e:	cbe080e7          	jalr	-834(ra) # 80005dc8 <panic>

0000000080002112 <fetchaddr>:
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	e426                	sd	s1,8(sp)
    8000211a:	e04a                	sd	s2,0(sp)
    8000211c:	1000                	addi	s0,sp,32
    8000211e:	84aa                	mv	s1,a0
    80002120:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	ebc080e7          	jalr	-324(ra) # 80000fde <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000212a:	653c                	ld	a5,72(a0)
    8000212c:	02f4f863          	bgeu	s1,a5,8000215c <fetchaddr+0x4a>
    80002130:	00848713          	addi	a4,s1,8
    80002134:	02e7e663          	bltu	a5,a4,80002160 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002138:	46a1                	li	a3,8
    8000213a:	8626                	mv	a2,s1
    8000213c:	85ca                	mv	a1,s2
    8000213e:	6928                	ld	a0,80(a0)
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	bec080e7          	jalr	-1044(ra) # 80000d2c <copyin>
    80002148:	00a03533          	snez	a0,a0
    8000214c:	40a00533          	neg	a0,a0
}
    80002150:	60e2                	ld	ra,24(sp)
    80002152:	6442                	ld	s0,16(sp)
    80002154:	64a2                	ld	s1,8(sp)
    80002156:	6902                	ld	s2,0(sp)
    80002158:	6105                	addi	sp,sp,32
    8000215a:	8082                	ret
    return -1;
    8000215c:	557d                	li	a0,-1
    8000215e:	bfcd                	j	80002150 <fetchaddr+0x3e>
    80002160:	557d                	li	a0,-1
    80002162:	b7fd                	j	80002150 <fetchaddr+0x3e>

0000000080002164 <fetchstr>:
{
    80002164:	7179                	addi	sp,sp,-48
    80002166:	f406                	sd	ra,40(sp)
    80002168:	f022                	sd	s0,32(sp)
    8000216a:	ec26                	sd	s1,24(sp)
    8000216c:	e84a                	sd	s2,16(sp)
    8000216e:	e44e                	sd	s3,8(sp)
    80002170:	1800                	addi	s0,sp,48
    80002172:	892a                	mv	s2,a0
    80002174:	84ae                	mv	s1,a1
    80002176:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	e66080e7          	jalr	-410(ra) # 80000fde <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002180:	86ce                	mv	a3,s3
    80002182:	864a                	mv	a2,s2
    80002184:	85a6                	mv	a1,s1
    80002186:	6928                	ld	a0,80(a0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	c30080e7          	jalr	-976(ra) # 80000db8 <copyinstr>
  if(err < 0)
    80002190:	00054763          	bltz	a0,8000219e <fetchstr+0x3a>
  return strlen(buf);
    80002194:	8526                	mv	a0,s1
    80002196:	ffffe097          	auipc	ra,0xffffe
    8000219a:	1ce080e7          	jalr	462(ra) # 80000364 <strlen>
}
    8000219e:	70a2                	ld	ra,40(sp)
    800021a0:	7402                	ld	s0,32(sp)
    800021a2:	64e2                	ld	s1,24(sp)
    800021a4:	6942                	ld	s2,16(sp)
    800021a6:	69a2                	ld	s3,8(sp)
    800021a8:	6145                	addi	sp,sp,48
    800021aa:	8082                	ret

00000000800021ac <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	e426                	sd	s1,8(sp)
    800021b4:	1000                	addi	s0,sp,32
    800021b6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	ef2080e7          	jalr	-270(ra) # 800020aa <argraw>
    800021c0:	c088                	sw	a0,0(s1)
  return 0;
}
    800021c2:	4501                	li	a0,0
    800021c4:	60e2                	ld	ra,24(sp)
    800021c6:	6442                	ld	s0,16(sp)
    800021c8:	64a2                	ld	s1,8(sp)
    800021ca:	6105                	addi	sp,sp,32
    800021cc:	8082                	ret

00000000800021ce <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800021ce:	1101                	addi	sp,sp,-32
    800021d0:	ec06                	sd	ra,24(sp)
    800021d2:	e822                	sd	s0,16(sp)
    800021d4:	e426                	sd	s1,8(sp)
    800021d6:	1000                	addi	s0,sp,32
    800021d8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021da:	00000097          	auipc	ra,0x0
    800021de:	ed0080e7          	jalr	-304(ra) # 800020aa <argraw>
    800021e2:	e088                	sd	a0,0(s1)
  return 0;
}
    800021e4:	4501                	li	a0,0
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6105                	addi	sp,sp,32
    800021ee:	8082                	ret

00000000800021f0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	e426                	sd	s1,8(sp)
    800021f8:	e04a                	sd	s2,0(sp)
    800021fa:	1000                	addi	s0,sp,32
    800021fc:	84ae                	mv	s1,a1
    800021fe:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002200:	00000097          	auipc	ra,0x0
    80002204:	eaa080e7          	jalr	-342(ra) # 800020aa <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002208:	864a                	mv	a2,s2
    8000220a:	85a6                	mv	a1,s1
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	f58080e7          	jalr	-168(ra) # 80002164 <fetchstr>
}
    80002214:	60e2                	ld	ra,24(sp)
    80002216:	6442                	ld	s0,16(sp)
    80002218:	64a2                	ld	s1,8(sp)
    8000221a:	6902                	ld	s2,0(sp)
    8000221c:	6105                	addi	sp,sp,32
    8000221e:	8082                	ret

0000000080002220 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002220:	1101                	addi	sp,sp,-32
    80002222:	ec06                	sd	ra,24(sp)
    80002224:	e822                	sd	s0,16(sp)
    80002226:	e426                	sd	s1,8(sp)
    80002228:	e04a                	sd	s2,0(sp)
    8000222a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	db2080e7          	jalr	-590(ra) # 80000fde <myproc>
    80002234:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002236:	05853903          	ld	s2,88(a0)
    8000223a:	0a893783          	ld	a5,168(s2)
    8000223e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002242:	37fd                	addiw	a5,a5,-1
    80002244:	4751                	li	a4,20
    80002246:	00f76f63          	bltu	a4,a5,80002264 <syscall+0x44>
    8000224a:	00369713          	slli	a4,a3,0x3
    8000224e:	00006797          	auipc	a5,0x6
    80002252:	1c278793          	addi	a5,a5,450 # 80008410 <syscalls>
    80002256:	97ba                	add	a5,a5,a4
    80002258:	639c                	ld	a5,0(a5)
    8000225a:	c789                	beqz	a5,80002264 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000225c:	9782                	jalr	a5
    8000225e:	06a93823          	sd	a0,112(s2)
    80002262:	a839                	j	80002280 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002264:	15848613          	addi	a2,s1,344
    80002268:	588c                	lw	a1,48(s1)
    8000226a:	00006517          	auipc	a0,0x6
    8000226e:	16e50513          	addi	a0,a0,366 # 800083d8 <states.1718+0x170>
    80002272:	00004097          	auipc	ra,0x4
    80002276:	ba0080e7          	jalr	-1120(ra) # 80005e12 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000227a:	6cbc                	ld	a5,88(s1)
    8000227c:	577d                	li	a4,-1
    8000227e:	fbb8                	sd	a4,112(a5)
  }
}
    80002280:	60e2                	ld	ra,24(sp)
    80002282:	6442                	ld	s0,16(sp)
    80002284:	64a2                	ld	s1,8(sp)
    80002286:	6902                	ld	s2,0(sp)
    80002288:	6105                	addi	sp,sp,32
    8000228a:	8082                	ret

000000008000228c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000228c:	1101                	addi	sp,sp,-32
    8000228e:	ec06                	sd	ra,24(sp)
    80002290:	e822                	sd	s0,16(sp)
    80002292:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002294:	fec40593          	addi	a1,s0,-20
    80002298:	4501                	li	a0,0
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	f12080e7          	jalr	-238(ra) # 800021ac <argint>
    return -1;
    800022a2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022a4:	00054963          	bltz	a0,800022b6 <sys_exit+0x2a>
  exit(n);
    800022a8:	fec42503          	lw	a0,-20(s0)
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	658080e7          	jalr	1624(ra) # 80001904 <exit>
  return 0;  // not reached
    800022b4:	4781                	li	a5,0
}
    800022b6:	853e                	mv	a0,a5
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	6105                	addi	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022c0:	1141                	addi	sp,sp,-16
    800022c2:	e406                	sd	ra,8(sp)
    800022c4:	e022                	sd	s0,0(sp)
    800022c6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	d16080e7          	jalr	-746(ra) # 80000fde <myproc>
}
    800022d0:	5908                	lw	a0,48(a0)
    800022d2:	60a2                	ld	ra,8(sp)
    800022d4:	6402                	ld	s0,0(sp)
    800022d6:	0141                	addi	sp,sp,16
    800022d8:	8082                	ret

00000000800022da <sys_fork>:

uint64
sys_fork(void)
{
    800022da:	1141                	addi	sp,sp,-16
    800022dc:	e406                	sd	ra,8(sp)
    800022de:	e022                	sd	s0,0(sp)
    800022e0:	0800                	addi	s0,sp,16
  return fork();
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	0d8080e7          	jalr	216(ra) # 800013ba <fork>
}
    800022ea:	60a2                	ld	ra,8(sp)
    800022ec:	6402                	ld	s0,0(sp)
    800022ee:	0141                	addi	sp,sp,16
    800022f0:	8082                	ret

00000000800022f2 <sys_wait>:

uint64
sys_wait(void)
{
    800022f2:	1101                	addi	sp,sp,-32
    800022f4:	ec06                	sd	ra,24(sp)
    800022f6:	e822                	sd	s0,16(sp)
    800022f8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022fa:	fe840593          	addi	a1,s0,-24
    800022fe:	4501                	li	a0,0
    80002300:	00000097          	auipc	ra,0x0
    80002304:	ece080e7          	jalr	-306(ra) # 800021ce <argaddr>
    80002308:	87aa                	mv	a5,a0
    return -1;
    8000230a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000230c:	0007c863          	bltz	a5,8000231c <sys_wait+0x2a>
  return wait(p);
    80002310:	fe843503          	ld	a0,-24(s0)
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	3f8080e7          	jalr	1016(ra) # 8000170c <wait>
}
    8000231c:	60e2                	ld	ra,24(sp)
    8000231e:	6442                	ld	s0,16(sp)
    80002320:	6105                	addi	sp,sp,32
    80002322:	8082                	ret

0000000080002324 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002324:	7179                	addi	sp,sp,-48
    80002326:	f406                	sd	ra,40(sp)
    80002328:	f022                	sd	s0,32(sp)
    8000232a:	ec26                	sd	s1,24(sp)
    8000232c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000232e:	fdc40593          	addi	a1,s0,-36
    80002332:	4501                	li	a0,0
    80002334:	00000097          	auipc	ra,0x0
    80002338:	e78080e7          	jalr	-392(ra) # 800021ac <argint>
    8000233c:	87aa                	mv	a5,a0
    return -1;
    8000233e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002340:	0207c063          	bltz	a5,80002360 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	c9a080e7          	jalr	-870(ra) # 80000fde <myproc>
    8000234c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000234e:	fdc42503          	lw	a0,-36(s0)
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	ff4080e7          	jalr	-12(ra) # 80001346 <growproc>
    8000235a:	00054863          	bltz	a0,8000236a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000235e:	8526                	mv	a0,s1
}
    80002360:	70a2                	ld	ra,40(sp)
    80002362:	7402                	ld	s0,32(sp)
    80002364:	64e2                	ld	s1,24(sp)
    80002366:	6145                	addi	sp,sp,48
    80002368:	8082                	ret
    return -1;
    8000236a:	557d                	li	a0,-1
    8000236c:	bfd5                	j	80002360 <sys_sbrk+0x3c>

000000008000236e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000236e:	7139                	addi	sp,sp,-64
    80002370:	fc06                	sd	ra,56(sp)
    80002372:	f822                	sd	s0,48(sp)
    80002374:	f426                	sd	s1,40(sp)
    80002376:	f04a                	sd	s2,32(sp)
    80002378:	ec4e                	sd	s3,24(sp)
    8000237a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000237c:	fcc40593          	addi	a1,s0,-52
    80002380:	4501                	li	a0,0
    80002382:	00000097          	auipc	ra,0x0
    80002386:	e2a080e7          	jalr	-470(ra) # 800021ac <argint>
    return -1;
    8000238a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000238c:	06054563          	bltz	a0,800023f6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002390:	0009a517          	auipc	a0,0x9a
    80002394:	90850513          	addi	a0,a0,-1784 # 8009bc98 <tickslock>
    80002398:	00004097          	auipc	ra,0x4
    8000239c:	f7a080e7          	jalr	-134(ra) # 80006312 <acquire>
  ticks0 = ticks;
    800023a0:	00007917          	auipc	s2,0x7
    800023a4:	c7892903          	lw	s2,-904(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800023a8:	fcc42783          	lw	a5,-52(s0)
    800023ac:	cf85                	beqz	a5,800023e4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023ae:	0009a997          	auipc	s3,0x9a
    800023b2:	8ea98993          	addi	s3,s3,-1814 # 8009bc98 <tickslock>
    800023b6:	00007497          	auipc	s1,0x7
    800023ba:	c6248493          	addi	s1,s1,-926 # 80009018 <ticks>
    if(myproc()->killed){
    800023be:	fffff097          	auipc	ra,0xfffff
    800023c2:	c20080e7          	jalr	-992(ra) # 80000fde <myproc>
    800023c6:	551c                	lw	a5,40(a0)
    800023c8:	ef9d                	bnez	a5,80002406 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800023ca:	85ce                	mv	a1,s3
    800023cc:	8526                	mv	a0,s1
    800023ce:	fffff097          	auipc	ra,0xfffff
    800023d2:	2da080e7          	jalr	730(ra) # 800016a8 <sleep>
  while(ticks - ticks0 < n){
    800023d6:	409c                	lw	a5,0(s1)
    800023d8:	412787bb          	subw	a5,a5,s2
    800023dc:	fcc42703          	lw	a4,-52(s0)
    800023e0:	fce7efe3          	bltu	a5,a4,800023be <sys_sleep+0x50>
  }
  release(&tickslock);
    800023e4:	0009a517          	auipc	a0,0x9a
    800023e8:	8b450513          	addi	a0,a0,-1868 # 8009bc98 <tickslock>
    800023ec:	00004097          	auipc	ra,0x4
    800023f0:	fda080e7          	jalr	-38(ra) # 800063c6 <release>
  return 0;
    800023f4:	4781                	li	a5,0
}
    800023f6:	853e                	mv	a0,a5
    800023f8:	70e2                	ld	ra,56(sp)
    800023fa:	7442                	ld	s0,48(sp)
    800023fc:	74a2                	ld	s1,40(sp)
    800023fe:	7902                	ld	s2,32(sp)
    80002400:	69e2                	ld	s3,24(sp)
    80002402:	6121                	addi	sp,sp,64
    80002404:	8082                	ret
      release(&tickslock);
    80002406:	0009a517          	auipc	a0,0x9a
    8000240a:	89250513          	addi	a0,a0,-1902 # 8009bc98 <tickslock>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	fb8080e7          	jalr	-72(ra) # 800063c6 <release>
      return -1;
    80002416:	57fd                	li	a5,-1
    80002418:	bff9                	j	800023f6 <sys_sleep+0x88>

000000008000241a <sys_kill>:

uint64
sys_kill(void)
{
    8000241a:	1101                	addi	sp,sp,-32
    8000241c:	ec06                	sd	ra,24(sp)
    8000241e:	e822                	sd	s0,16(sp)
    80002420:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002422:	fec40593          	addi	a1,s0,-20
    80002426:	4501                	li	a0,0
    80002428:	00000097          	auipc	ra,0x0
    8000242c:	d84080e7          	jalr	-636(ra) # 800021ac <argint>
    80002430:	87aa                	mv	a5,a0
    return -1;
    80002432:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002434:	0007c863          	bltz	a5,80002444 <sys_kill+0x2a>
  return kill(pid);
    80002438:	fec42503          	lw	a0,-20(s0)
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	59e080e7          	jalr	1438(ra) # 800019da <kill>
}
    80002444:	60e2                	ld	ra,24(sp)
    80002446:	6442                	ld	s0,16(sp)
    80002448:	6105                	addi	sp,sp,32
    8000244a:	8082                	ret

000000008000244c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000244c:	1101                	addi	sp,sp,-32
    8000244e:	ec06                	sd	ra,24(sp)
    80002450:	e822                	sd	s0,16(sp)
    80002452:	e426                	sd	s1,8(sp)
    80002454:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002456:	0009a517          	auipc	a0,0x9a
    8000245a:	84250513          	addi	a0,a0,-1982 # 8009bc98 <tickslock>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	eb4080e7          	jalr	-332(ra) # 80006312 <acquire>
  xticks = ticks;
    80002466:	00007497          	auipc	s1,0x7
    8000246a:	bb24a483          	lw	s1,-1102(s1) # 80009018 <ticks>
  release(&tickslock);
    8000246e:	0009a517          	auipc	a0,0x9a
    80002472:	82a50513          	addi	a0,a0,-2006 # 8009bc98 <tickslock>
    80002476:	00004097          	auipc	ra,0x4
    8000247a:	f50080e7          	jalr	-176(ra) # 800063c6 <release>
  return xticks;
}
    8000247e:	02049513          	slli	a0,s1,0x20
    80002482:	9101                	srli	a0,a0,0x20
    80002484:	60e2                	ld	ra,24(sp)
    80002486:	6442                	ld	s0,16(sp)
    80002488:	64a2                	ld	s1,8(sp)
    8000248a:	6105                	addi	sp,sp,32
    8000248c:	8082                	ret

000000008000248e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000248e:	7179                	addi	sp,sp,-48
    80002490:	f406                	sd	ra,40(sp)
    80002492:	f022                	sd	s0,32(sp)
    80002494:	ec26                	sd	s1,24(sp)
    80002496:	e84a                	sd	s2,16(sp)
    80002498:	e44e                	sd	s3,8(sp)
    8000249a:	e052                	sd	s4,0(sp)
    8000249c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000249e:	00006597          	auipc	a1,0x6
    800024a2:	02258593          	addi	a1,a1,34 # 800084c0 <syscalls+0xb0>
    800024a6:	0009a517          	auipc	a0,0x9a
    800024aa:	80a50513          	addi	a0,a0,-2038 # 8009bcb0 <bcache>
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	dd4080e7          	jalr	-556(ra) # 80006282 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024b6:	000a1797          	auipc	a5,0xa1
    800024ba:	7fa78793          	addi	a5,a5,2042 # 800a3cb0 <bcache+0x8000>
    800024be:	000a2717          	auipc	a4,0xa2
    800024c2:	a5a70713          	addi	a4,a4,-1446 # 800a3f18 <bcache+0x8268>
    800024c6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024ca:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ce:	00099497          	auipc	s1,0x99
    800024d2:	7fa48493          	addi	s1,s1,2042 # 8009bcc8 <bcache+0x18>
    b->next = bcache.head.next;
    800024d6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024d8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024da:	00006a17          	auipc	s4,0x6
    800024de:	feea0a13          	addi	s4,s4,-18 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800024e2:	2b893783          	ld	a5,696(s2)
    800024e6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024e8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024ec:	85d2                	mv	a1,s4
    800024ee:	01048513          	addi	a0,s1,16
    800024f2:	00001097          	auipc	ra,0x1
    800024f6:	4bc080e7          	jalr	1212(ra) # 800039ae <initsleeplock>
    bcache.head.next->prev = b;
    800024fa:	2b893783          	ld	a5,696(s2)
    800024fe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002500:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002504:	45848493          	addi	s1,s1,1112
    80002508:	fd349de3          	bne	s1,s3,800024e2 <binit+0x54>
  }
}
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6a02                	ld	s4,0(sp)
    80002518:	6145                	addi	sp,sp,48
    8000251a:	8082                	ret

000000008000251c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000251c:	7179                	addi	sp,sp,-48
    8000251e:	f406                	sd	ra,40(sp)
    80002520:	f022                	sd	s0,32(sp)
    80002522:	ec26                	sd	s1,24(sp)
    80002524:	e84a                	sd	s2,16(sp)
    80002526:	e44e                	sd	s3,8(sp)
    80002528:	1800                	addi	s0,sp,48
    8000252a:	89aa                	mv	s3,a0
    8000252c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000252e:	00099517          	auipc	a0,0x99
    80002532:	78250513          	addi	a0,a0,1922 # 8009bcb0 <bcache>
    80002536:	00004097          	auipc	ra,0x4
    8000253a:	ddc080e7          	jalr	-548(ra) # 80006312 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000253e:	000a2497          	auipc	s1,0xa2
    80002542:	a2a4b483          	ld	s1,-1494(s1) # 800a3f68 <bcache+0x82b8>
    80002546:	000a2797          	auipc	a5,0xa2
    8000254a:	9d278793          	addi	a5,a5,-1582 # 800a3f18 <bcache+0x8268>
    8000254e:	02f48f63          	beq	s1,a5,8000258c <bread+0x70>
    80002552:	873e                	mv	a4,a5
    80002554:	a021                	j	8000255c <bread+0x40>
    80002556:	68a4                	ld	s1,80(s1)
    80002558:	02e48a63          	beq	s1,a4,8000258c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000255c:	449c                	lw	a5,8(s1)
    8000255e:	ff379ce3          	bne	a5,s3,80002556 <bread+0x3a>
    80002562:	44dc                	lw	a5,12(s1)
    80002564:	ff2799e3          	bne	a5,s2,80002556 <bread+0x3a>
      b->refcnt++;
    80002568:	40bc                	lw	a5,64(s1)
    8000256a:	2785                	addiw	a5,a5,1
    8000256c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000256e:	00099517          	auipc	a0,0x99
    80002572:	74250513          	addi	a0,a0,1858 # 8009bcb0 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	e50080e7          	jalr	-432(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    8000257e:	01048513          	addi	a0,s1,16
    80002582:	00001097          	auipc	ra,0x1
    80002586:	466080e7          	jalr	1126(ra) # 800039e8 <acquiresleep>
      return b;
    8000258a:	a8b9                	j	800025e8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000258c:	000a2497          	auipc	s1,0xa2
    80002590:	9d44b483          	ld	s1,-1580(s1) # 800a3f60 <bcache+0x82b0>
    80002594:	000a2797          	auipc	a5,0xa2
    80002598:	98478793          	addi	a5,a5,-1660 # 800a3f18 <bcache+0x8268>
    8000259c:	00f48863          	beq	s1,a5,800025ac <bread+0x90>
    800025a0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025a2:	40bc                	lw	a5,64(s1)
    800025a4:	cf81                	beqz	a5,800025bc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025a6:	64a4                	ld	s1,72(s1)
    800025a8:	fee49de3          	bne	s1,a4,800025a2 <bread+0x86>
  panic("bget: no buffers");
    800025ac:	00006517          	auipc	a0,0x6
    800025b0:	f2450513          	addi	a0,a0,-220 # 800084d0 <syscalls+0xc0>
    800025b4:	00004097          	auipc	ra,0x4
    800025b8:	814080e7          	jalr	-2028(ra) # 80005dc8 <panic>
      b->dev = dev;
    800025bc:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025c0:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025c4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025c8:	4785                	li	a5,1
    800025ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025cc:	00099517          	auipc	a0,0x99
    800025d0:	6e450513          	addi	a0,a0,1764 # 8009bcb0 <bcache>
    800025d4:	00004097          	auipc	ra,0x4
    800025d8:	df2080e7          	jalr	-526(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    800025dc:	01048513          	addi	a0,s1,16
    800025e0:	00001097          	auipc	ra,0x1
    800025e4:	408080e7          	jalr	1032(ra) # 800039e8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025e8:	409c                	lw	a5,0(s1)
    800025ea:	cb89                	beqz	a5,800025fc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025ec:	8526                	mv	a0,s1
    800025ee:	70a2                	ld	ra,40(sp)
    800025f0:	7402                	ld	s0,32(sp)
    800025f2:	64e2                	ld	s1,24(sp)
    800025f4:	6942                	ld	s2,16(sp)
    800025f6:	69a2                	ld	s3,8(sp)
    800025f8:	6145                	addi	sp,sp,48
    800025fa:	8082                	ret
    virtio_disk_rw(b, 0);
    800025fc:	4581                	li	a1,0
    800025fe:	8526                	mv	a0,s1
    80002600:	00003097          	auipc	ra,0x3
    80002604:	f06080e7          	jalr	-250(ra) # 80005506 <virtio_disk_rw>
    b->valid = 1;
    80002608:	4785                	li	a5,1
    8000260a:	c09c                	sw	a5,0(s1)
  return b;
    8000260c:	b7c5                	j	800025ec <bread+0xd0>

000000008000260e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000260e:	1101                	addi	sp,sp,-32
    80002610:	ec06                	sd	ra,24(sp)
    80002612:	e822                	sd	s0,16(sp)
    80002614:	e426                	sd	s1,8(sp)
    80002616:	1000                	addi	s0,sp,32
    80002618:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000261a:	0541                	addi	a0,a0,16
    8000261c:	00001097          	auipc	ra,0x1
    80002620:	466080e7          	jalr	1126(ra) # 80003a82 <holdingsleep>
    80002624:	cd01                	beqz	a0,8000263c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002626:	4585                	li	a1,1
    80002628:	8526                	mv	a0,s1
    8000262a:	00003097          	auipc	ra,0x3
    8000262e:	edc080e7          	jalr	-292(ra) # 80005506 <virtio_disk_rw>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret
    panic("bwrite");
    8000263c:	00006517          	auipc	a0,0x6
    80002640:	eac50513          	addi	a0,a0,-340 # 800084e8 <syscalls+0xd8>
    80002644:	00003097          	auipc	ra,0x3
    80002648:	784080e7          	jalr	1924(ra) # 80005dc8 <panic>

000000008000264c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000264c:	1101                	addi	sp,sp,-32
    8000264e:	ec06                	sd	ra,24(sp)
    80002650:	e822                	sd	s0,16(sp)
    80002652:	e426                	sd	s1,8(sp)
    80002654:	e04a                	sd	s2,0(sp)
    80002656:	1000                	addi	s0,sp,32
    80002658:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000265a:	01050913          	addi	s2,a0,16
    8000265e:	854a                	mv	a0,s2
    80002660:	00001097          	auipc	ra,0x1
    80002664:	422080e7          	jalr	1058(ra) # 80003a82 <holdingsleep>
    80002668:	c92d                	beqz	a0,800026da <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000266a:	854a                	mv	a0,s2
    8000266c:	00001097          	auipc	ra,0x1
    80002670:	3d2080e7          	jalr	978(ra) # 80003a3e <releasesleep>

  acquire(&bcache.lock);
    80002674:	00099517          	auipc	a0,0x99
    80002678:	63c50513          	addi	a0,a0,1596 # 8009bcb0 <bcache>
    8000267c:	00004097          	auipc	ra,0x4
    80002680:	c96080e7          	jalr	-874(ra) # 80006312 <acquire>
  b->refcnt--;
    80002684:	40bc                	lw	a5,64(s1)
    80002686:	37fd                	addiw	a5,a5,-1
    80002688:	0007871b          	sext.w	a4,a5
    8000268c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000268e:	eb05                	bnez	a4,800026be <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002690:	68bc                	ld	a5,80(s1)
    80002692:	64b8                	ld	a4,72(s1)
    80002694:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002696:	64bc                	ld	a5,72(s1)
    80002698:	68b8                	ld	a4,80(s1)
    8000269a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000269c:	000a1797          	auipc	a5,0xa1
    800026a0:	61478793          	addi	a5,a5,1556 # 800a3cb0 <bcache+0x8000>
    800026a4:	2b87b703          	ld	a4,696(a5)
    800026a8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026aa:	000a2717          	auipc	a4,0xa2
    800026ae:	86e70713          	addi	a4,a4,-1938 # 800a3f18 <bcache+0x8268>
    800026b2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026b4:	2b87b703          	ld	a4,696(a5)
    800026b8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026ba:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026be:	00099517          	auipc	a0,0x99
    800026c2:	5f250513          	addi	a0,a0,1522 # 8009bcb0 <bcache>
    800026c6:	00004097          	auipc	ra,0x4
    800026ca:	d00080e7          	jalr	-768(ra) # 800063c6 <release>
}
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	64a2                	ld	s1,8(sp)
    800026d4:	6902                	ld	s2,0(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret
    panic("brelse");
    800026da:	00006517          	auipc	a0,0x6
    800026de:	e1650513          	addi	a0,a0,-490 # 800084f0 <syscalls+0xe0>
    800026e2:	00003097          	auipc	ra,0x3
    800026e6:	6e6080e7          	jalr	1766(ra) # 80005dc8 <panic>

00000000800026ea <bpin>:

void
bpin(struct buf *b) {
    800026ea:	1101                	addi	sp,sp,-32
    800026ec:	ec06                	sd	ra,24(sp)
    800026ee:	e822                	sd	s0,16(sp)
    800026f0:	e426                	sd	s1,8(sp)
    800026f2:	1000                	addi	s0,sp,32
    800026f4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026f6:	00099517          	auipc	a0,0x99
    800026fa:	5ba50513          	addi	a0,a0,1466 # 8009bcb0 <bcache>
    800026fe:	00004097          	auipc	ra,0x4
    80002702:	c14080e7          	jalr	-1004(ra) # 80006312 <acquire>
  b->refcnt++;
    80002706:	40bc                	lw	a5,64(s1)
    80002708:	2785                	addiw	a5,a5,1
    8000270a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000270c:	00099517          	auipc	a0,0x99
    80002710:	5a450513          	addi	a0,a0,1444 # 8009bcb0 <bcache>
    80002714:	00004097          	auipc	ra,0x4
    80002718:	cb2080e7          	jalr	-846(ra) # 800063c6 <release>
}
    8000271c:	60e2                	ld	ra,24(sp)
    8000271e:	6442                	ld	s0,16(sp)
    80002720:	64a2                	ld	s1,8(sp)
    80002722:	6105                	addi	sp,sp,32
    80002724:	8082                	ret

0000000080002726 <bunpin>:

void
bunpin(struct buf *b) {
    80002726:	1101                	addi	sp,sp,-32
    80002728:	ec06                	sd	ra,24(sp)
    8000272a:	e822                	sd	s0,16(sp)
    8000272c:	e426                	sd	s1,8(sp)
    8000272e:	1000                	addi	s0,sp,32
    80002730:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002732:	00099517          	auipc	a0,0x99
    80002736:	57e50513          	addi	a0,a0,1406 # 8009bcb0 <bcache>
    8000273a:	00004097          	auipc	ra,0x4
    8000273e:	bd8080e7          	jalr	-1064(ra) # 80006312 <acquire>
  b->refcnt--;
    80002742:	40bc                	lw	a5,64(s1)
    80002744:	37fd                	addiw	a5,a5,-1
    80002746:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002748:	00099517          	auipc	a0,0x99
    8000274c:	56850513          	addi	a0,a0,1384 # 8009bcb0 <bcache>
    80002750:	00004097          	auipc	ra,0x4
    80002754:	c76080e7          	jalr	-906(ra) # 800063c6 <release>
}
    80002758:	60e2                	ld	ra,24(sp)
    8000275a:	6442                	ld	s0,16(sp)
    8000275c:	64a2                	ld	s1,8(sp)
    8000275e:	6105                	addi	sp,sp,32
    80002760:	8082                	ret

0000000080002762 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	e04a                	sd	s2,0(sp)
    8000276c:	1000                	addi	s0,sp,32
    8000276e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002770:	00d5d59b          	srliw	a1,a1,0xd
    80002774:	000a2797          	auipc	a5,0xa2
    80002778:	c187a783          	lw	a5,-1000(a5) # 800a438c <sb+0x1c>
    8000277c:	9dbd                	addw	a1,a1,a5
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	d9e080e7          	jalr	-610(ra) # 8000251c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002786:	0074f713          	andi	a4,s1,7
    8000278a:	4785                	li	a5,1
    8000278c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002790:	14ce                	slli	s1,s1,0x33
    80002792:	90d9                	srli	s1,s1,0x36
    80002794:	00950733          	add	a4,a0,s1
    80002798:	05874703          	lbu	a4,88(a4)
    8000279c:	00e7f6b3          	and	a3,a5,a4
    800027a0:	c69d                	beqz	a3,800027ce <bfree+0x6c>
    800027a2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027a4:	94aa                	add	s1,s1,a0
    800027a6:	fff7c793          	not	a5,a5
    800027aa:	8ff9                	and	a5,a5,a4
    800027ac:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027b0:	00001097          	auipc	ra,0x1
    800027b4:	118080e7          	jalr	280(ra) # 800038c8 <log_write>
  brelse(bp);
    800027b8:	854a                	mv	a0,s2
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	e92080e7          	jalr	-366(ra) # 8000264c <brelse>
}
    800027c2:	60e2                	ld	ra,24(sp)
    800027c4:	6442                	ld	s0,16(sp)
    800027c6:	64a2                	ld	s1,8(sp)
    800027c8:	6902                	ld	s2,0(sp)
    800027ca:	6105                	addi	sp,sp,32
    800027cc:	8082                	ret
    panic("freeing free block");
    800027ce:	00006517          	auipc	a0,0x6
    800027d2:	d2a50513          	addi	a0,a0,-726 # 800084f8 <syscalls+0xe8>
    800027d6:	00003097          	auipc	ra,0x3
    800027da:	5f2080e7          	jalr	1522(ra) # 80005dc8 <panic>

00000000800027de <balloc>:
{
    800027de:	711d                	addi	sp,sp,-96
    800027e0:	ec86                	sd	ra,88(sp)
    800027e2:	e8a2                	sd	s0,80(sp)
    800027e4:	e4a6                	sd	s1,72(sp)
    800027e6:	e0ca                	sd	s2,64(sp)
    800027e8:	fc4e                	sd	s3,56(sp)
    800027ea:	f852                	sd	s4,48(sp)
    800027ec:	f456                	sd	s5,40(sp)
    800027ee:	f05a                	sd	s6,32(sp)
    800027f0:	ec5e                	sd	s7,24(sp)
    800027f2:	e862                	sd	s8,16(sp)
    800027f4:	e466                	sd	s9,8(sp)
    800027f6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027f8:	000a2797          	auipc	a5,0xa2
    800027fc:	b7c7a783          	lw	a5,-1156(a5) # 800a4374 <sb+0x4>
    80002800:	cbd1                	beqz	a5,80002894 <balloc+0xb6>
    80002802:	8baa                	mv	s7,a0
    80002804:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002806:	000a2b17          	auipc	s6,0xa2
    8000280a:	b6ab0b13          	addi	s6,s6,-1174 # 800a4370 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002810:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002812:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002814:	6c89                	lui	s9,0x2
    80002816:	a831                	j	80002832 <balloc+0x54>
    brelse(bp);
    80002818:	854a                	mv	a0,s2
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	e32080e7          	jalr	-462(ra) # 8000264c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002822:	015c87bb          	addw	a5,s9,s5
    80002826:	00078a9b          	sext.w	s5,a5
    8000282a:	004b2703          	lw	a4,4(s6)
    8000282e:	06eaf363          	bgeu	s5,a4,80002894 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002832:	41fad79b          	sraiw	a5,s5,0x1f
    80002836:	0137d79b          	srliw	a5,a5,0x13
    8000283a:	015787bb          	addw	a5,a5,s5
    8000283e:	40d7d79b          	sraiw	a5,a5,0xd
    80002842:	01cb2583          	lw	a1,28(s6)
    80002846:	9dbd                	addw	a1,a1,a5
    80002848:	855e                	mv	a0,s7
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	cd2080e7          	jalr	-814(ra) # 8000251c <bread>
    80002852:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002854:	004b2503          	lw	a0,4(s6)
    80002858:	000a849b          	sext.w	s1,s5
    8000285c:	8662                	mv	a2,s8
    8000285e:	faa4fde3          	bgeu	s1,a0,80002818 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002862:	41f6579b          	sraiw	a5,a2,0x1f
    80002866:	01d7d69b          	srliw	a3,a5,0x1d
    8000286a:	00c6873b          	addw	a4,a3,a2
    8000286e:	00777793          	andi	a5,a4,7
    80002872:	9f95                	subw	a5,a5,a3
    80002874:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002878:	4037571b          	sraiw	a4,a4,0x3
    8000287c:	00e906b3          	add	a3,s2,a4
    80002880:	0586c683          	lbu	a3,88(a3)
    80002884:	00d7f5b3          	and	a1,a5,a3
    80002888:	cd91                	beqz	a1,800028a4 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000288a:	2605                	addiw	a2,a2,1
    8000288c:	2485                	addiw	s1,s1,1
    8000288e:	fd4618e3          	bne	a2,s4,8000285e <balloc+0x80>
    80002892:	b759                	j	80002818 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002894:	00006517          	auipc	a0,0x6
    80002898:	c7c50513          	addi	a0,a0,-900 # 80008510 <syscalls+0x100>
    8000289c:	00003097          	auipc	ra,0x3
    800028a0:	52c080e7          	jalr	1324(ra) # 80005dc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028a4:	974a                	add	a4,a4,s2
    800028a6:	8fd5                	or	a5,a5,a3
    800028a8:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028ac:	854a                	mv	a0,s2
    800028ae:	00001097          	auipc	ra,0x1
    800028b2:	01a080e7          	jalr	26(ra) # 800038c8 <log_write>
        brelse(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	d94080e7          	jalr	-620(ra) # 8000264c <brelse>
  bp = bread(dev, bno);
    800028c0:	85a6                	mv	a1,s1
    800028c2:	855e                	mv	a0,s7
    800028c4:	00000097          	auipc	ra,0x0
    800028c8:	c58080e7          	jalr	-936(ra) # 8000251c <bread>
    800028cc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028ce:	40000613          	li	a2,1024
    800028d2:	4581                	li	a1,0
    800028d4:	05850513          	addi	a0,a0,88
    800028d8:	ffffe097          	auipc	ra,0xffffe
    800028dc:	908080e7          	jalr	-1784(ra) # 800001e0 <memset>
  log_write(bp);
    800028e0:	854a                	mv	a0,s2
    800028e2:	00001097          	auipc	ra,0x1
    800028e6:	fe6080e7          	jalr	-26(ra) # 800038c8 <log_write>
  brelse(bp);
    800028ea:	854a                	mv	a0,s2
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	d60080e7          	jalr	-672(ra) # 8000264c <brelse>
}
    800028f4:	8526                	mv	a0,s1
    800028f6:	60e6                	ld	ra,88(sp)
    800028f8:	6446                	ld	s0,80(sp)
    800028fa:	64a6                	ld	s1,72(sp)
    800028fc:	6906                	ld	s2,64(sp)
    800028fe:	79e2                	ld	s3,56(sp)
    80002900:	7a42                	ld	s4,48(sp)
    80002902:	7aa2                	ld	s5,40(sp)
    80002904:	7b02                	ld	s6,32(sp)
    80002906:	6be2                	ld	s7,24(sp)
    80002908:	6c42                	ld	s8,16(sp)
    8000290a:	6ca2                	ld	s9,8(sp)
    8000290c:	6125                	addi	sp,sp,96
    8000290e:	8082                	ret

0000000080002910 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002910:	7179                	addi	sp,sp,-48
    80002912:	f406                	sd	ra,40(sp)
    80002914:	f022                	sd	s0,32(sp)
    80002916:	ec26                	sd	s1,24(sp)
    80002918:	e84a                	sd	s2,16(sp)
    8000291a:	e44e                	sd	s3,8(sp)
    8000291c:	e052                	sd	s4,0(sp)
    8000291e:	1800                	addi	s0,sp,48
    80002920:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002922:	47ad                	li	a5,11
    80002924:	04b7fe63          	bgeu	a5,a1,80002980 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002928:	ff45849b          	addiw	s1,a1,-12
    8000292c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002930:	0ff00793          	li	a5,255
    80002934:	0ae7e363          	bltu	a5,a4,800029da <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002938:	08052583          	lw	a1,128(a0)
    8000293c:	c5ad                	beqz	a1,800029a6 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000293e:	00092503          	lw	a0,0(s2)
    80002942:	00000097          	auipc	ra,0x0
    80002946:	bda080e7          	jalr	-1062(ra) # 8000251c <bread>
    8000294a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000294c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002950:	02049593          	slli	a1,s1,0x20
    80002954:	9181                	srli	a1,a1,0x20
    80002956:	058a                	slli	a1,a1,0x2
    80002958:	00b784b3          	add	s1,a5,a1
    8000295c:	0004a983          	lw	s3,0(s1)
    80002960:	04098d63          	beqz	s3,800029ba <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002964:	8552                	mv	a0,s4
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	ce6080e7          	jalr	-794(ra) # 8000264c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000296e:	854e                	mv	a0,s3
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	69a2                	ld	s3,8(sp)
    8000297a:	6a02                	ld	s4,0(sp)
    8000297c:	6145                	addi	sp,sp,48
    8000297e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002980:	02059493          	slli	s1,a1,0x20
    80002984:	9081                	srli	s1,s1,0x20
    80002986:	048a                	slli	s1,s1,0x2
    80002988:	94aa                	add	s1,s1,a0
    8000298a:	0504a983          	lw	s3,80(s1)
    8000298e:	fe0990e3          	bnez	s3,8000296e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002992:	4108                	lw	a0,0(a0)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e4a080e7          	jalr	-438(ra) # 800027de <balloc>
    8000299c:	0005099b          	sext.w	s3,a0
    800029a0:	0534a823          	sw	s3,80(s1)
    800029a4:	b7e9                	j	8000296e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029a6:	4108                	lw	a0,0(a0)
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	e36080e7          	jalr	-458(ra) # 800027de <balloc>
    800029b0:	0005059b          	sext.w	a1,a0
    800029b4:	08b92023          	sw	a1,128(s2)
    800029b8:	b759                	j	8000293e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029ba:	00092503          	lw	a0,0(s2)
    800029be:	00000097          	auipc	ra,0x0
    800029c2:	e20080e7          	jalr	-480(ra) # 800027de <balloc>
    800029c6:	0005099b          	sext.w	s3,a0
    800029ca:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ce:	8552                	mv	a0,s4
    800029d0:	00001097          	auipc	ra,0x1
    800029d4:	ef8080e7          	jalr	-264(ra) # 800038c8 <log_write>
    800029d8:	b771                	j	80002964 <bmap+0x54>
  panic("bmap: out of range");
    800029da:	00006517          	auipc	a0,0x6
    800029de:	b4e50513          	addi	a0,a0,-1202 # 80008528 <syscalls+0x118>
    800029e2:	00003097          	auipc	ra,0x3
    800029e6:	3e6080e7          	jalr	998(ra) # 80005dc8 <panic>

00000000800029ea <iget>:
{
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	e84a                	sd	s2,16(sp)
    800029f4:	e44e                	sd	s3,8(sp)
    800029f6:	e052                	sd	s4,0(sp)
    800029f8:	1800                	addi	s0,sp,48
    800029fa:	89aa                	mv	s3,a0
    800029fc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029fe:	000a2517          	auipc	a0,0xa2
    80002a02:	99250513          	addi	a0,a0,-1646 # 800a4390 <itable>
    80002a06:	00004097          	auipc	ra,0x4
    80002a0a:	90c080e7          	jalr	-1780(ra) # 80006312 <acquire>
  empty = 0;
    80002a0e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a10:	000a2497          	auipc	s1,0xa2
    80002a14:	99848493          	addi	s1,s1,-1640 # 800a43a8 <itable+0x18>
    80002a18:	000a3697          	auipc	a3,0xa3
    80002a1c:	42068693          	addi	a3,a3,1056 # 800a5e38 <log>
    80002a20:	a039                	j	80002a2e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a22:	02090b63          	beqz	s2,80002a58 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a26:	08848493          	addi	s1,s1,136
    80002a2a:	02d48a63          	beq	s1,a3,80002a5e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a2e:	449c                	lw	a5,8(s1)
    80002a30:	fef059e3          	blez	a5,80002a22 <iget+0x38>
    80002a34:	4098                	lw	a4,0(s1)
    80002a36:	ff3716e3          	bne	a4,s3,80002a22 <iget+0x38>
    80002a3a:	40d8                	lw	a4,4(s1)
    80002a3c:	ff4713e3          	bne	a4,s4,80002a22 <iget+0x38>
      ip->ref++;
    80002a40:	2785                	addiw	a5,a5,1
    80002a42:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a44:	000a2517          	auipc	a0,0xa2
    80002a48:	94c50513          	addi	a0,a0,-1716 # 800a4390 <itable>
    80002a4c:	00004097          	auipc	ra,0x4
    80002a50:	97a080e7          	jalr	-1670(ra) # 800063c6 <release>
      return ip;
    80002a54:	8926                	mv	s2,s1
    80002a56:	a03d                	j	80002a84 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a58:	f7f9                	bnez	a5,80002a26 <iget+0x3c>
    80002a5a:	8926                	mv	s2,s1
    80002a5c:	b7e9                	j	80002a26 <iget+0x3c>
  if(empty == 0)
    80002a5e:	02090c63          	beqz	s2,80002a96 <iget+0xac>
  ip->dev = dev;
    80002a62:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a66:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a6a:	4785                	li	a5,1
    80002a6c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a70:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a74:	000a2517          	auipc	a0,0xa2
    80002a78:	91c50513          	addi	a0,a0,-1764 # 800a4390 <itable>
    80002a7c:	00004097          	auipc	ra,0x4
    80002a80:	94a080e7          	jalr	-1718(ra) # 800063c6 <release>
}
    80002a84:	854a                	mv	a0,s2
    80002a86:	70a2                	ld	ra,40(sp)
    80002a88:	7402                	ld	s0,32(sp)
    80002a8a:	64e2                	ld	s1,24(sp)
    80002a8c:	6942                	ld	s2,16(sp)
    80002a8e:	69a2                	ld	s3,8(sp)
    80002a90:	6a02                	ld	s4,0(sp)
    80002a92:	6145                	addi	sp,sp,48
    80002a94:	8082                	ret
    panic("iget: no inodes");
    80002a96:	00006517          	auipc	a0,0x6
    80002a9a:	aaa50513          	addi	a0,a0,-1366 # 80008540 <syscalls+0x130>
    80002a9e:	00003097          	auipc	ra,0x3
    80002aa2:	32a080e7          	jalr	810(ra) # 80005dc8 <panic>

0000000080002aa6 <fsinit>:
fsinit(int dev) {
    80002aa6:	7179                	addi	sp,sp,-48
    80002aa8:	f406                	sd	ra,40(sp)
    80002aaa:	f022                	sd	s0,32(sp)
    80002aac:	ec26                	sd	s1,24(sp)
    80002aae:	e84a                	sd	s2,16(sp)
    80002ab0:	e44e                	sd	s3,8(sp)
    80002ab2:	1800                	addi	s0,sp,48
    80002ab4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ab6:	4585                	li	a1,1
    80002ab8:	00000097          	auipc	ra,0x0
    80002abc:	a64080e7          	jalr	-1436(ra) # 8000251c <bread>
    80002ac0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ac2:	000a2997          	auipc	s3,0xa2
    80002ac6:	8ae98993          	addi	s3,s3,-1874 # 800a4370 <sb>
    80002aca:	02000613          	li	a2,32
    80002ace:	05850593          	addi	a1,a0,88
    80002ad2:	854e                	mv	a0,s3
    80002ad4:	ffffd097          	auipc	ra,0xffffd
    80002ad8:	76c080e7          	jalr	1900(ra) # 80000240 <memmove>
  brelse(bp);
    80002adc:	8526                	mv	a0,s1
    80002ade:	00000097          	auipc	ra,0x0
    80002ae2:	b6e080e7          	jalr	-1170(ra) # 8000264c <brelse>
  if(sb.magic != FSMAGIC)
    80002ae6:	0009a703          	lw	a4,0(s3)
    80002aea:	102037b7          	lui	a5,0x10203
    80002aee:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002af2:	02f71263          	bne	a4,a5,80002b16 <fsinit+0x70>
  initlog(dev, &sb);
    80002af6:	000a2597          	auipc	a1,0xa2
    80002afa:	87a58593          	addi	a1,a1,-1926 # 800a4370 <sb>
    80002afe:	854a                	mv	a0,s2
    80002b00:	00001097          	auipc	ra,0x1
    80002b04:	b4c080e7          	jalr	-1204(ra) # 8000364c <initlog>
}
    80002b08:	70a2                	ld	ra,40(sp)
    80002b0a:	7402                	ld	s0,32(sp)
    80002b0c:	64e2                	ld	s1,24(sp)
    80002b0e:	6942                	ld	s2,16(sp)
    80002b10:	69a2                	ld	s3,8(sp)
    80002b12:	6145                	addi	sp,sp,48
    80002b14:	8082                	ret
    panic("invalid file system");
    80002b16:	00006517          	auipc	a0,0x6
    80002b1a:	a3a50513          	addi	a0,a0,-1478 # 80008550 <syscalls+0x140>
    80002b1e:	00003097          	auipc	ra,0x3
    80002b22:	2aa080e7          	jalr	682(ra) # 80005dc8 <panic>

0000000080002b26 <iinit>:
{
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	ec26                	sd	s1,24(sp)
    80002b2e:	e84a                	sd	s2,16(sp)
    80002b30:	e44e                	sd	s3,8(sp)
    80002b32:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b34:	00006597          	auipc	a1,0x6
    80002b38:	a3458593          	addi	a1,a1,-1484 # 80008568 <syscalls+0x158>
    80002b3c:	000a2517          	auipc	a0,0xa2
    80002b40:	85450513          	addi	a0,a0,-1964 # 800a4390 <itable>
    80002b44:	00003097          	auipc	ra,0x3
    80002b48:	73e080e7          	jalr	1854(ra) # 80006282 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b4c:	000a2497          	auipc	s1,0xa2
    80002b50:	86c48493          	addi	s1,s1,-1940 # 800a43b8 <itable+0x28>
    80002b54:	000a3997          	auipc	s3,0xa3
    80002b58:	2f498993          	addi	s3,s3,756 # 800a5e48 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b5c:	00006917          	auipc	s2,0x6
    80002b60:	a1490913          	addi	s2,s2,-1516 # 80008570 <syscalls+0x160>
    80002b64:	85ca                	mv	a1,s2
    80002b66:	8526                	mv	a0,s1
    80002b68:	00001097          	auipc	ra,0x1
    80002b6c:	e46080e7          	jalr	-442(ra) # 800039ae <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b70:	08848493          	addi	s1,s1,136
    80002b74:	ff3498e3          	bne	s1,s3,80002b64 <iinit+0x3e>
}
    80002b78:	70a2                	ld	ra,40(sp)
    80002b7a:	7402                	ld	s0,32(sp)
    80002b7c:	64e2                	ld	s1,24(sp)
    80002b7e:	6942                	ld	s2,16(sp)
    80002b80:	69a2                	ld	s3,8(sp)
    80002b82:	6145                	addi	sp,sp,48
    80002b84:	8082                	ret

0000000080002b86 <ialloc>:
{
    80002b86:	715d                	addi	sp,sp,-80
    80002b88:	e486                	sd	ra,72(sp)
    80002b8a:	e0a2                	sd	s0,64(sp)
    80002b8c:	fc26                	sd	s1,56(sp)
    80002b8e:	f84a                	sd	s2,48(sp)
    80002b90:	f44e                	sd	s3,40(sp)
    80002b92:	f052                	sd	s4,32(sp)
    80002b94:	ec56                	sd	s5,24(sp)
    80002b96:	e85a                	sd	s6,16(sp)
    80002b98:	e45e                	sd	s7,8(sp)
    80002b9a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b9c:	000a1717          	auipc	a4,0xa1
    80002ba0:	7e072703          	lw	a4,2016(a4) # 800a437c <sb+0xc>
    80002ba4:	4785                	li	a5,1
    80002ba6:	04e7fa63          	bgeu	a5,a4,80002bfa <ialloc+0x74>
    80002baa:	8aaa                	mv	s5,a0
    80002bac:	8bae                	mv	s7,a1
    80002bae:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bb0:	000a1a17          	auipc	s4,0xa1
    80002bb4:	7c0a0a13          	addi	s4,s4,1984 # 800a4370 <sb>
    80002bb8:	00048b1b          	sext.w	s6,s1
    80002bbc:	0044d593          	srli	a1,s1,0x4
    80002bc0:	018a2783          	lw	a5,24(s4)
    80002bc4:	9dbd                	addw	a1,a1,a5
    80002bc6:	8556                	mv	a0,s5
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	954080e7          	jalr	-1708(ra) # 8000251c <bread>
    80002bd0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bd2:	05850993          	addi	s3,a0,88
    80002bd6:	00f4f793          	andi	a5,s1,15
    80002bda:	079a                	slli	a5,a5,0x6
    80002bdc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bde:	00099783          	lh	a5,0(s3)
    80002be2:	c785                	beqz	a5,80002c0a <ialloc+0x84>
    brelse(bp);
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	a68080e7          	jalr	-1432(ra) # 8000264c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bec:	0485                	addi	s1,s1,1
    80002bee:	00ca2703          	lw	a4,12(s4)
    80002bf2:	0004879b          	sext.w	a5,s1
    80002bf6:	fce7e1e3          	bltu	a5,a4,80002bb8 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bfa:	00006517          	auipc	a0,0x6
    80002bfe:	97e50513          	addi	a0,a0,-1666 # 80008578 <syscalls+0x168>
    80002c02:	00003097          	auipc	ra,0x3
    80002c06:	1c6080e7          	jalr	454(ra) # 80005dc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c0a:	04000613          	li	a2,64
    80002c0e:	4581                	li	a1,0
    80002c10:	854e                	mv	a0,s3
    80002c12:	ffffd097          	auipc	ra,0xffffd
    80002c16:	5ce080e7          	jalr	1486(ra) # 800001e0 <memset>
      dip->type = type;
    80002c1a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c1e:	854a                	mv	a0,s2
    80002c20:	00001097          	auipc	ra,0x1
    80002c24:	ca8080e7          	jalr	-856(ra) # 800038c8 <log_write>
      brelse(bp);
    80002c28:	854a                	mv	a0,s2
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	a22080e7          	jalr	-1502(ra) # 8000264c <brelse>
      return iget(dev, inum);
    80002c32:	85da                	mv	a1,s6
    80002c34:	8556                	mv	a0,s5
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	db4080e7          	jalr	-588(ra) # 800029ea <iget>
}
    80002c3e:	60a6                	ld	ra,72(sp)
    80002c40:	6406                	ld	s0,64(sp)
    80002c42:	74e2                	ld	s1,56(sp)
    80002c44:	7942                	ld	s2,48(sp)
    80002c46:	79a2                	ld	s3,40(sp)
    80002c48:	7a02                	ld	s4,32(sp)
    80002c4a:	6ae2                	ld	s5,24(sp)
    80002c4c:	6b42                	ld	s6,16(sp)
    80002c4e:	6ba2                	ld	s7,8(sp)
    80002c50:	6161                	addi	sp,sp,80
    80002c52:	8082                	ret

0000000080002c54 <iupdate>:
{
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	e04a                	sd	s2,0(sp)
    80002c5e:	1000                	addi	s0,sp,32
    80002c60:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c62:	415c                	lw	a5,4(a0)
    80002c64:	0047d79b          	srliw	a5,a5,0x4
    80002c68:	000a1597          	auipc	a1,0xa1
    80002c6c:	7205a583          	lw	a1,1824(a1) # 800a4388 <sb+0x18>
    80002c70:	9dbd                	addw	a1,a1,a5
    80002c72:	4108                	lw	a0,0(a0)
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	8a8080e7          	jalr	-1880(ra) # 8000251c <bread>
    80002c7c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c7e:	05850793          	addi	a5,a0,88
    80002c82:	40c8                	lw	a0,4(s1)
    80002c84:	893d                	andi	a0,a0,15
    80002c86:	051a                	slli	a0,a0,0x6
    80002c88:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c8a:	04449703          	lh	a4,68(s1)
    80002c8e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c92:	04649703          	lh	a4,70(s1)
    80002c96:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c9a:	04849703          	lh	a4,72(s1)
    80002c9e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ca2:	04a49703          	lh	a4,74(s1)
    80002ca6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002caa:	44f8                	lw	a4,76(s1)
    80002cac:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cae:	03400613          	li	a2,52
    80002cb2:	05048593          	addi	a1,s1,80
    80002cb6:	0531                	addi	a0,a0,12
    80002cb8:	ffffd097          	auipc	ra,0xffffd
    80002cbc:	588080e7          	jalr	1416(ra) # 80000240 <memmove>
  log_write(bp);
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	00001097          	auipc	ra,0x1
    80002cc6:	c06080e7          	jalr	-1018(ra) # 800038c8 <log_write>
  brelse(bp);
    80002cca:	854a                	mv	a0,s2
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	980080e7          	jalr	-1664(ra) # 8000264c <brelse>
}
    80002cd4:	60e2                	ld	ra,24(sp)
    80002cd6:	6442                	ld	s0,16(sp)
    80002cd8:	64a2                	ld	s1,8(sp)
    80002cda:	6902                	ld	s2,0(sp)
    80002cdc:	6105                	addi	sp,sp,32
    80002cde:	8082                	ret

0000000080002ce0 <idup>:
{
    80002ce0:	1101                	addi	sp,sp,-32
    80002ce2:	ec06                	sd	ra,24(sp)
    80002ce4:	e822                	sd	s0,16(sp)
    80002ce6:	e426                	sd	s1,8(sp)
    80002ce8:	1000                	addi	s0,sp,32
    80002cea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cec:	000a1517          	auipc	a0,0xa1
    80002cf0:	6a450513          	addi	a0,a0,1700 # 800a4390 <itable>
    80002cf4:	00003097          	auipc	ra,0x3
    80002cf8:	61e080e7          	jalr	1566(ra) # 80006312 <acquire>
  ip->ref++;
    80002cfc:	449c                	lw	a5,8(s1)
    80002cfe:	2785                	addiw	a5,a5,1
    80002d00:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d02:	000a1517          	auipc	a0,0xa1
    80002d06:	68e50513          	addi	a0,a0,1678 # 800a4390 <itable>
    80002d0a:	00003097          	auipc	ra,0x3
    80002d0e:	6bc080e7          	jalr	1724(ra) # 800063c6 <release>
}
    80002d12:	8526                	mv	a0,s1
    80002d14:	60e2                	ld	ra,24(sp)
    80002d16:	6442                	ld	s0,16(sp)
    80002d18:	64a2                	ld	s1,8(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret

0000000080002d1e <ilock>:
{
    80002d1e:	1101                	addi	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	e426                	sd	s1,8(sp)
    80002d26:	e04a                	sd	s2,0(sp)
    80002d28:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d2a:	c115                	beqz	a0,80002d4e <ilock+0x30>
    80002d2c:	84aa                	mv	s1,a0
    80002d2e:	451c                	lw	a5,8(a0)
    80002d30:	00f05f63          	blez	a5,80002d4e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d34:	0541                	addi	a0,a0,16
    80002d36:	00001097          	auipc	ra,0x1
    80002d3a:	cb2080e7          	jalr	-846(ra) # 800039e8 <acquiresleep>
  if(ip->valid == 0){
    80002d3e:	40bc                	lw	a5,64(s1)
    80002d40:	cf99                	beqz	a5,80002d5e <ilock+0x40>
}
    80002d42:	60e2                	ld	ra,24(sp)
    80002d44:	6442                	ld	s0,16(sp)
    80002d46:	64a2                	ld	s1,8(sp)
    80002d48:	6902                	ld	s2,0(sp)
    80002d4a:	6105                	addi	sp,sp,32
    80002d4c:	8082                	ret
    panic("ilock");
    80002d4e:	00006517          	auipc	a0,0x6
    80002d52:	84250513          	addi	a0,a0,-1982 # 80008590 <syscalls+0x180>
    80002d56:	00003097          	auipc	ra,0x3
    80002d5a:	072080e7          	jalr	114(ra) # 80005dc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d5e:	40dc                	lw	a5,4(s1)
    80002d60:	0047d79b          	srliw	a5,a5,0x4
    80002d64:	000a1597          	auipc	a1,0xa1
    80002d68:	6245a583          	lw	a1,1572(a1) # 800a4388 <sb+0x18>
    80002d6c:	9dbd                	addw	a1,a1,a5
    80002d6e:	4088                	lw	a0,0(s1)
    80002d70:	fffff097          	auipc	ra,0xfffff
    80002d74:	7ac080e7          	jalr	1964(ra) # 8000251c <bread>
    80002d78:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d7a:	05850593          	addi	a1,a0,88
    80002d7e:	40dc                	lw	a5,4(s1)
    80002d80:	8bbd                	andi	a5,a5,15
    80002d82:	079a                	slli	a5,a5,0x6
    80002d84:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d86:	00059783          	lh	a5,0(a1)
    80002d8a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d8e:	00259783          	lh	a5,2(a1)
    80002d92:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d96:	00459783          	lh	a5,4(a1)
    80002d9a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d9e:	00659783          	lh	a5,6(a1)
    80002da2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002da6:	459c                	lw	a5,8(a1)
    80002da8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002daa:	03400613          	li	a2,52
    80002dae:	05b1                	addi	a1,a1,12
    80002db0:	05048513          	addi	a0,s1,80
    80002db4:	ffffd097          	auipc	ra,0xffffd
    80002db8:	48c080e7          	jalr	1164(ra) # 80000240 <memmove>
    brelse(bp);
    80002dbc:	854a                	mv	a0,s2
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	88e080e7          	jalr	-1906(ra) # 8000264c <brelse>
    ip->valid = 1;
    80002dc6:	4785                	li	a5,1
    80002dc8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dca:	04449783          	lh	a5,68(s1)
    80002dce:	fbb5                	bnez	a5,80002d42 <ilock+0x24>
      panic("ilock: no type");
    80002dd0:	00005517          	auipc	a0,0x5
    80002dd4:	7c850513          	addi	a0,a0,1992 # 80008598 <syscalls+0x188>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	ff0080e7          	jalr	-16(ra) # 80005dc8 <panic>

0000000080002de0 <iunlock>:
{
    80002de0:	1101                	addi	sp,sp,-32
    80002de2:	ec06                	sd	ra,24(sp)
    80002de4:	e822                	sd	s0,16(sp)
    80002de6:	e426                	sd	s1,8(sp)
    80002de8:	e04a                	sd	s2,0(sp)
    80002dea:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dec:	c905                	beqz	a0,80002e1c <iunlock+0x3c>
    80002dee:	84aa                	mv	s1,a0
    80002df0:	01050913          	addi	s2,a0,16
    80002df4:	854a                	mv	a0,s2
    80002df6:	00001097          	auipc	ra,0x1
    80002dfa:	c8c080e7          	jalr	-884(ra) # 80003a82 <holdingsleep>
    80002dfe:	cd19                	beqz	a0,80002e1c <iunlock+0x3c>
    80002e00:	449c                	lw	a5,8(s1)
    80002e02:	00f05d63          	blez	a5,80002e1c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e06:	854a                	mv	a0,s2
    80002e08:	00001097          	auipc	ra,0x1
    80002e0c:	c36080e7          	jalr	-970(ra) # 80003a3e <releasesleep>
}
    80002e10:	60e2                	ld	ra,24(sp)
    80002e12:	6442                	ld	s0,16(sp)
    80002e14:	64a2                	ld	s1,8(sp)
    80002e16:	6902                	ld	s2,0(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret
    panic("iunlock");
    80002e1c:	00005517          	auipc	a0,0x5
    80002e20:	78c50513          	addi	a0,a0,1932 # 800085a8 <syscalls+0x198>
    80002e24:	00003097          	auipc	ra,0x3
    80002e28:	fa4080e7          	jalr	-92(ra) # 80005dc8 <panic>

0000000080002e2c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e2c:	7179                	addi	sp,sp,-48
    80002e2e:	f406                	sd	ra,40(sp)
    80002e30:	f022                	sd	s0,32(sp)
    80002e32:	ec26                	sd	s1,24(sp)
    80002e34:	e84a                	sd	s2,16(sp)
    80002e36:	e44e                	sd	s3,8(sp)
    80002e38:	e052                	sd	s4,0(sp)
    80002e3a:	1800                	addi	s0,sp,48
    80002e3c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e3e:	05050493          	addi	s1,a0,80
    80002e42:	08050913          	addi	s2,a0,128
    80002e46:	a021                	j	80002e4e <itrunc+0x22>
    80002e48:	0491                	addi	s1,s1,4
    80002e4a:	01248d63          	beq	s1,s2,80002e64 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e4e:	408c                	lw	a1,0(s1)
    80002e50:	dde5                	beqz	a1,80002e48 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e52:	0009a503          	lw	a0,0(s3)
    80002e56:	00000097          	auipc	ra,0x0
    80002e5a:	90c080e7          	jalr	-1780(ra) # 80002762 <bfree>
      ip->addrs[i] = 0;
    80002e5e:	0004a023          	sw	zero,0(s1)
    80002e62:	b7dd                	j	80002e48 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e64:	0809a583          	lw	a1,128(s3)
    80002e68:	e185                	bnez	a1,80002e88 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e6a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e6e:	854e                	mv	a0,s3
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	de4080e7          	jalr	-540(ra) # 80002c54 <iupdate>
}
    80002e78:	70a2                	ld	ra,40(sp)
    80002e7a:	7402                	ld	s0,32(sp)
    80002e7c:	64e2                	ld	s1,24(sp)
    80002e7e:	6942                	ld	s2,16(sp)
    80002e80:	69a2                	ld	s3,8(sp)
    80002e82:	6a02                	ld	s4,0(sp)
    80002e84:	6145                	addi	sp,sp,48
    80002e86:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e88:	0009a503          	lw	a0,0(s3)
    80002e8c:	fffff097          	auipc	ra,0xfffff
    80002e90:	690080e7          	jalr	1680(ra) # 8000251c <bread>
    80002e94:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e96:	05850493          	addi	s1,a0,88
    80002e9a:	45850913          	addi	s2,a0,1112
    80002e9e:	a811                	j	80002eb2 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ea0:	0009a503          	lw	a0,0(s3)
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	8be080e7          	jalr	-1858(ra) # 80002762 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002eac:	0491                	addi	s1,s1,4
    80002eae:	01248563          	beq	s1,s2,80002eb8 <itrunc+0x8c>
      if(a[j])
    80002eb2:	408c                	lw	a1,0(s1)
    80002eb4:	dde5                	beqz	a1,80002eac <itrunc+0x80>
    80002eb6:	b7ed                	j	80002ea0 <itrunc+0x74>
    brelse(bp);
    80002eb8:	8552                	mv	a0,s4
    80002eba:	fffff097          	auipc	ra,0xfffff
    80002ebe:	792080e7          	jalr	1938(ra) # 8000264c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ec2:	0809a583          	lw	a1,128(s3)
    80002ec6:	0009a503          	lw	a0,0(s3)
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	898080e7          	jalr	-1896(ra) # 80002762 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ed2:	0809a023          	sw	zero,128(s3)
    80002ed6:	bf51                	j	80002e6a <itrunc+0x3e>

0000000080002ed8 <iput>:
{
    80002ed8:	1101                	addi	sp,sp,-32
    80002eda:	ec06                	sd	ra,24(sp)
    80002edc:	e822                	sd	s0,16(sp)
    80002ede:	e426                	sd	s1,8(sp)
    80002ee0:	e04a                	sd	s2,0(sp)
    80002ee2:	1000                	addi	s0,sp,32
    80002ee4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ee6:	000a1517          	auipc	a0,0xa1
    80002eea:	4aa50513          	addi	a0,a0,1194 # 800a4390 <itable>
    80002eee:	00003097          	auipc	ra,0x3
    80002ef2:	424080e7          	jalr	1060(ra) # 80006312 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ef6:	4498                	lw	a4,8(s1)
    80002ef8:	4785                	li	a5,1
    80002efa:	02f70363          	beq	a4,a5,80002f20 <iput+0x48>
  ip->ref--;
    80002efe:	449c                	lw	a5,8(s1)
    80002f00:	37fd                	addiw	a5,a5,-1
    80002f02:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f04:	000a1517          	auipc	a0,0xa1
    80002f08:	48c50513          	addi	a0,a0,1164 # 800a4390 <itable>
    80002f0c:	00003097          	auipc	ra,0x3
    80002f10:	4ba080e7          	jalr	1210(ra) # 800063c6 <release>
}
    80002f14:	60e2                	ld	ra,24(sp)
    80002f16:	6442                	ld	s0,16(sp)
    80002f18:	64a2                	ld	s1,8(sp)
    80002f1a:	6902                	ld	s2,0(sp)
    80002f1c:	6105                	addi	sp,sp,32
    80002f1e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f20:	40bc                	lw	a5,64(s1)
    80002f22:	dff1                	beqz	a5,80002efe <iput+0x26>
    80002f24:	04a49783          	lh	a5,74(s1)
    80002f28:	fbf9                	bnez	a5,80002efe <iput+0x26>
    acquiresleep(&ip->lock);
    80002f2a:	01048913          	addi	s2,s1,16
    80002f2e:	854a                	mv	a0,s2
    80002f30:	00001097          	auipc	ra,0x1
    80002f34:	ab8080e7          	jalr	-1352(ra) # 800039e8 <acquiresleep>
    release(&itable.lock);
    80002f38:	000a1517          	auipc	a0,0xa1
    80002f3c:	45850513          	addi	a0,a0,1112 # 800a4390 <itable>
    80002f40:	00003097          	auipc	ra,0x3
    80002f44:	486080e7          	jalr	1158(ra) # 800063c6 <release>
    itrunc(ip);
    80002f48:	8526                	mv	a0,s1
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	ee2080e7          	jalr	-286(ra) # 80002e2c <itrunc>
    ip->type = 0;
    80002f52:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f56:	8526                	mv	a0,s1
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	cfc080e7          	jalr	-772(ra) # 80002c54 <iupdate>
    ip->valid = 0;
    80002f60:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f64:	854a                	mv	a0,s2
    80002f66:	00001097          	auipc	ra,0x1
    80002f6a:	ad8080e7          	jalr	-1320(ra) # 80003a3e <releasesleep>
    acquire(&itable.lock);
    80002f6e:	000a1517          	auipc	a0,0xa1
    80002f72:	42250513          	addi	a0,a0,1058 # 800a4390 <itable>
    80002f76:	00003097          	auipc	ra,0x3
    80002f7a:	39c080e7          	jalr	924(ra) # 80006312 <acquire>
    80002f7e:	b741                	j	80002efe <iput+0x26>

0000000080002f80 <iunlockput>:
{
    80002f80:	1101                	addi	sp,sp,-32
    80002f82:	ec06                	sd	ra,24(sp)
    80002f84:	e822                	sd	s0,16(sp)
    80002f86:	e426                	sd	s1,8(sp)
    80002f88:	1000                	addi	s0,sp,32
    80002f8a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f8c:	00000097          	auipc	ra,0x0
    80002f90:	e54080e7          	jalr	-428(ra) # 80002de0 <iunlock>
  iput(ip);
    80002f94:	8526                	mv	a0,s1
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	f42080e7          	jalr	-190(ra) # 80002ed8 <iput>
}
    80002f9e:	60e2                	ld	ra,24(sp)
    80002fa0:	6442                	ld	s0,16(sp)
    80002fa2:	64a2                	ld	s1,8(sp)
    80002fa4:	6105                	addi	sp,sp,32
    80002fa6:	8082                	ret

0000000080002fa8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fa8:	1141                	addi	sp,sp,-16
    80002faa:	e422                	sd	s0,8(sp)
    80002fac:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fae:	411c                	lw	a5,0(a0)
    80002fb0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fb2:	415c                	lw	a5,4(a0)
    80002fb4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fb6:	04451783          	lh	a5,68(a0)
    80002fba:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fbe:	04a51783          	lh	a5,74(a0)
    80002fc2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fc6:	04c56783          	lwu	a5,76(a0)
    80002fca:	e99c                	sd	a5,16(a1)
}
    80002fcc:	6422                	ld	s0,8(sp)
    80002fce:	0141                	addi	sp,sp,16
    80002fd0:	8082                	ret

0000000080002fd2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fd2:	457c                	lw	a5,76(a0)
    80002fd4:	0ed7e963          	bltu	a5,a3,800030c6 <readi+0xf4>
{
    80002fd8:	7159                	addi	sp,sp,-112
    80002fda:	f486                	sd	ra,104(sp)
    80002fdc:	f0a2                	sd	s0,96(sp)
    80002fde:	eca6                	sd	s1,88(sp)
    80002fe0:	e8ca                	sd	s2,80(sp)
    80002fe2:	e4ce                	sd	s3,72(sp)
    80002fe4:	e0d2                	sd	s4,64(sp)
    80002fe6:	fc56                	sd	s5,56(sp)
    80002fe8:	f85a                	sd	s6,48(sp)
    80002fea:	f45e                	sd	s7,40(sp)
    80002fec:	f062                	sd	s8,32(sp)
    80002fee:	ec66                	sd	s9,24(sp)
    80002ff0:	e86a                	sd	s10,16(sp)
    80002ff2:	e46e                	sd	s11,8(sp)
    80002ff4:	1880                	addi	s0,sp,112
    80002ff6:	8baa                	mv	s7,a0
    80002ff8:	8c2e                	mv	s8,a1
    80002ffa:	8ab2                	mv	s5,a2
    80002ffc:	84b6                	mv	s1,a3
    80002ffe:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003000:	9f35                	addw	a4,a4,a3
    return 0;
    80003002:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003004:	0ad76063          	bltu	a4,a3,800030a4 <readi+0xd2>
  if(off + n > ip->size)
    80003008:	00e7f463          	bgeu	a5,a4,80003010 <readi+0x3e>
    n = ip->size - off;
    8000300c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003010:	0a0b0963          	beqz	s6,800030c2 <readi+0xf0>
    80003014:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003016:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000301a:	5cfd                	li	s9,-1
    8000301c:	a82d                	j	80003056 <readi+0x84>
    8000301e:	020a1d93          	slli	s11,s4,0x20
    80003022:	020ddd93          	srli	s11,s11,0x20
    80003026:	05890613          	addi	a2,s2,88
    8000302a:	86ee                	mv	a3,s11
    8000302c:	963a                	add	a2,a2,a4
    8000302e:	85d6                	mv	a1,s5
    80003030:	8562                	mv	a0,s8
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	a1a080e7          	jalr	-1510(ra) # 80001a4c <either_copyout>
    8000303a:	05950d63          	beq	a0,s9,80003094 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000303e:	854a                	mv	a0,s2
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	60c080e7          	jalr	1548(ra) # 8000264c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003048:	013a09bb          	addw	s3,s4,s3
    8000304c:	009a04bb          	addw	s1,s4,s1
    80003050:	9aee                	add	s5,s5,s11
    80003052:	0569f763          	bgeu	s3,s6,800030a0 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003056:	000ba903          	lw	s2,0(s7)
    8000305a:	00a4d59b          	srliw	a1,s1,0xa
    8000305e:	855e                	mv	a0,s7
    80003060:	00000097          	auipc	ra,0x0
    80003064:	8b0080e7          	jalr	-1872(ra) # 80002910 <bmap>
    80003068:	0005059b          	sext.w	a1,a0
    8000306c:	854a                	mv	a0,s2
    8000306e:	fffff097          	auipc	ra,0xfffff
    80003072:	4ae080e7          	jalr	1198(ra) # 8000251c <bread>
    80003076:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003078:	3ff4f713          	andi	a4,s1,1023
    8000307c:	40ed07bb          	subw	a5,s10,a4
    80003080:	413b06bb          	subw	a3,s6,s3
    80003084:	8a3e                	mv	s4,a5
    80003086:	2781                	sext.w	a5,a5
    80003088:	0006861b          	sext.w	a2,a3
    8000308c:	f8f679e3          	bgeu	a2,a5,8000301e <readi+0x4c>
    80003090:	8a36                	mv	s4,a3
    80003092:	b771                	j	8000301e <readi+0x4c>
      brelse(bp);
    80003094:	854a                	mv	a0,s2
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	5b6080e7          	jalr	1462(ra) # 8000264c <brelse>
      tot = -1;
    8000309e:	59fd                	li	s3,-1
  }
  return tot;
    800030a0:	0009851b          	sext.w	a0,s3
}
    800030a4:	70a6                	ld	ra,104(sp)
    800030a6:	7406                	ld	s0,96(sp)
    800030a8:	64e6                	ld	s1,88(sp)
    800030aa:	6946                	ld	s2,80(sp)
    800030ac:	69a6                	ld	s3,72(sp)
    800030ae:	6a06                	ld	s4,64(sp)
    800030b0:	7ae2                	ld	s5,56(sp)
    800030b2:	7b42                	ld	s6,48(sp)
    800030b4:	7ba2                	ld	s7,40(sp)
    800030b6:	7c02                	ld	s8,32(sp)
    800030b8:	6ce2                	ld	s9,24(sp)
    800030ba:	6d42                	ld	s10,16(sp)
    800030bc:	6da2                	ld	s11,8(sp)
    800030be:	6165                	addi	sp,sp,112
    800030c0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030c2:	89da                	mv	s3,s6
    800030c4:	bff1                	j	800030a0 <readi+0xce>
    return 0;
    800030c6:	4501                	li	a0,0
}
    800030c8:	8082                	ret

00000000800030ca <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030ca:	457c                	lw	a5,76(a0)
    800030cc:	10d7e863          	bltu	a5,a3,800031dc <writei+0x112>
{
    800030d0:	7159                	addi	sp,sp,-112
    800030d2:	f486                	sd	ra,104(sp)
    800030d4:	f0a2                	sd	s0,96(sp)
    800030d6:	eca6                	sd	s1,88(sp)
    800030d8:	e8ca                	sd	s2,80(sp)
    800030da:	e4ce                	sd	s3,72(sp)
    800030dc:	e0d2                	sd	s4,64(sp)
    800030de:	fc56                	sd	s5,56(sp)
    800030e0:	f85a                	sd	s6,48(sp)
    800030e2:	f45e                	sd	s7,40(sp)
    800030e4:	f062                	sd	s8,32(sp)
    800030e6:	ec66                	sd	s9,24(sp)
    800030e8:	e86a                	sd	s10,16(sp)
    800030ea:	e46e                	sd	s11,8(sp)
    800030ec:	1880                	addi	s0,sp,112
    800030ee:	8b2a                	mv	s6,a0
    800030f0:	8c2e                	mv	s8,a1
    800030f2:	8ab2                	mv	s5,a2
    800030f4:	8936                	mv	s2,a3
    800030f6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030f8:	00e687bb          	addw	a5,a3,a4
    800030fc:	0ed7e263          	bltu	a5,a3,800031e0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003100:	00043737          	lui	a4,0x43
    80003104:	0ef76063          	bltu	a4,a5,800031e4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003108:	0c0b8863          	beqz	s7,800031d8 <writei+0x10e>
    8000310c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000310e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003112:	5cfd                	li	s9,-1
    80003114:	a091                	j	80003158 <writei+0x8e>
    80003116:	02099d93          	slli	s11,s3,0x20
    8000311a:	020ddd93          	srli	s11,s11,0x20
    8000311e:	05848513          	addi	a0,s1,88
    80003122:	86ee                	mv	a3,s11
    80003124:	8656                	mv	a2,s5
    80003126:	85e2                	mv	a1,s8
    80003128:	953a                	add	a0,a0,a4
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	978080e7          	jalr	-1672(ra) # 80001aa2 <either_copyin>
    80003132:	07950263          	beq	a0,s9,80003196 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003136:	8526                	mv	a0,s1
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	790080e7          	jalr	1936(ra) # 800038c8 <log_write>
    brelse(bp);
    80003140:	8526                	mv	a0,s1
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	50a080e7          	jalr	1290(ra) # 8000264c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000314a:	01498a3b          	addw	s4,s3,s4
    8000314e:	0129893b          	addw	s2,s3,s2
    80003152:	9aee                	add	s5,s5,s11
    80003154:	057a7663          	bgeu	s4,s7,800031a0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003158:	000b2483          	lw	s1,0(s6)
    8000315c:	00a9559b          	srliw	a1,s2,0xa
    80003160:	855a                	mv	a0,s6
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	7ae080e7          	jalr	1966(ra) # 80002910 <bmap>
    8000316a:	0005059b          	sext.w	a1,a0
    8000316e:	8526                	mv	a0,s1
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	3ac080e7          	jalr	940(ra) # 8000251c <bread>
    80003178:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000317a:	3ff97713          	andi	a4,s2,1023
    8000317e:	40ed07bb          	subw	a5,s10,a4
    80003182:	414b86bb          	subw	a3,s7,s4
    80003186:	89be                	mv	s3,a5
    80003188:	2781                	sext.w	a5,a5
    8000318a:	0006861b          	sext.w	a2,a3
    8000318e:	f8f674e3          	bgeu	a2,a5,80003116 <writei+0x4c>
    80003192:	89b6                	mv	s3,a3
    80003194:	b749                	j	80003116 <writei+0x4c>
      brelse(bp);
    80003196:	8526                	mv	a0,s1
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	4b4080e7          	jalr	1204(ra) # 8000264c <brelse>
  }

  if(off > ip->size)
    800031a0:	04cb2783          	lw	a5,76(s6)
    800031a4:	0127f463          	bgeu	a5,s2,800031ac <writei+0xe2>
    ip->size = off;
    800031a8:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ac:	855a                	mv	a0,s6
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	aa6080e7          	jalr	-1370(ra) # 80002c54 <iupdate>

  return tot;
    800031b6:	000a051b          	sext.w	a0,s4
}
    800031ba:	70a6                	ld	ra,104(sp)
    800031bc:	7406                	ld	s0,96(sp)
    800031be:	64e6                	ld	s1,88(sp)
    800031c0:	6946                	ld	s2,80(sp)
    800031c2:	69a6                	ld	s3,72(sp)
    800031c4:	6a06                	ld	s4,64(sp)
    800031c6:	7ae2                	ld	s5,56(sp)
    800031c8:	7b42                	ld	s6,48(sp)
    800031ca:	7ba2                	ld	s7,40(sp)
    800031cc:	7c02                	ld	s8,32(sp)
    800031ce:	6ce2                	ld	s9,24(sp)
    800031d0:	6d42                	ld	s10,16(sp)
    800031d2:	6da2                	ld	s11,8(sp)
    800031d4:	6165                	addi	sp,sp,112
    800031d6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d8:	8a5e                	mv	s4,s7
    800031da:	bfc9                	j	800031ac <writei+0xe2>
    return -1;
    800031dc:	557d                	li	a0,-1
}
    800031de:	8082                	ret
    return -1;
    800031e0:	557d                	li	a0,-1
    800031e2:	bfe1                	j	800031ba <writei+0xf0>
    return -1;
    800031e4:	557d                	li	a0,-1
    800031e6:	bfd1                	j	800031ba <writei+0xf0>

00000000800031e8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031e8:	1141                	addi	sp,sp,-16
    800031ea:	e406                	sd	ra,8(sp)
    800031ec:	e022                	sd	s0,0(sp)
    800031ee:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031f0:	4639                	li	a2,14
    800031f2:	ffffd097          	auipc	ra,0xffffd
    800031f6:	0c6080e7          	jalr	198(ra) # 800002b8 <strncmp>
}
    800031fa:	60a2                	ld	ra,8(sp)
    800031fc:	6402                	ld	s0,0(sp)
    800031fe:	0141                	addi	sp,sp,16
    80003200:	8082                	ret

0000000080003202 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003202:	7139                	addi	sp,sp,-64
    80003204:	fc06                	sd	ra,56(sp)
    80003206:	f822                	sd	s0,48(sp)
    80003208:	f426                	sd	s1,40(sp)
    8000320a:	f04a                	sd	s2,32(sp)
    8000320c:	ec4e                	sd	s3,24(sp)
    8000320e:	e852                	sd	s4,16(sp)
    80003210:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003212:	04451703          	lh	a4,68(a0)
    80003216:	4785                	li	a5,1
    80003218:	00f71a63          	bne	a4,a5,8000322c <dirlookup+0x2a>
    8000321c:	892a                	mv	s2,a0
    8000321e:	89ae                	mv	s3,a1
    80003220:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003222:	457c                	lw	a5,76(a0)
    80003224:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003226:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003228:	e79d                	bnez	a5,80003256 <dirlookup+0x54>
    8000322a:	a8a5                	j	800032a2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000322c:	00005517          	auipc	a0,0x5
    80003230:	38450513          	addi	a0,a0,900 # 800085b0 <syscalls+0x1a0>
    80003234:	00003097          	auipc	ra,0x3
    80003238:	b94080e7          	jalr	-1132(ra) # 80005dc8 <panic>
      panic("dirlookup read");
    8000323c:	00005517          	auipc	a0,0x5
    80003240:	38c50513          	addi	a0,a0,908 # 800085c8 <syscalls+0x1b8>
    80003244:	00003097          	auipc	ra,0x3
    80003248:	b84080e7          	jalr	-1148(ra) # 80005dc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000324c:	24c1                	addiw	s1,s1,16
    8000324e:	04c92783          	lw	a5,76(s2)
    80003252:	04f4f763          	bgeu	s1,a5,800032a0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003256:	4741                	li	a4,16
    80003258:	86a6                	mv	a3,s1
    8000325a:	fc040613          	addi	a2,s0,-64
    8000325e:	4581                	li	a1,0
    80003260:	854a                	mv	a0,s2
    80003262:	00000097          	auipc	ra,0x0
    80003266:	d70080e7          	jalr	-656(ra) # 80002fd2 <readi>
    8000326a:	47c1                	li	a5,16
    8000326c:	fcf518e3          	bne	a0,a5,8000323c <dirlookup+0x3a>
    if(de.inum == 0)
    80003270:	fc045783          	lhu	a5,-64(s0)
    80003274:	dfe1                	beqz	a5,8000324c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003276:	fc240593          	addi	a1,s0,-62
    8000327a:	854e                	mv	a0,s3
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	f6c080e7          	jalr	-148(ra) # 800031e8 <namecmp>
    80003284:	f561                	bnez	a0,8000324c <dirlookup+0x4a>
      if(poff)
    80003286:	000a0463          	beqz	s4,8000328e <dirlookup+0x8c>
        *poff = off;
    8000328a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000328e:	fc045583          	lhu	a1,-64(s0)
    80003292:	00092503          	lw	a0,0(s2)
    80003296:	fffff097          	auipc	ra,0xfffff
    8000329a:	754080e7          	jalr	1876(ra) # 800029ea <iget>
    8000329e:	a011                	j	800032a2 <dirlookup+0xa0>
  return 0;
    800032a0:	4501                	li	a0,0
}
    800032a2:	70e2                	ld	ra,56(sp)
    800032a4:	7442                	ld	s0,48(sp)
    800032a6:	74a2                	ld	s1,40(sp)
    800032a8:	7902                	ld	s2,32(sp)
    800032aa:	69e2                	ld	s3,24(sp)
    800032ac:	6a42                	ld	s4,16(sp)
    800032ae:	6121                	addi	sp,sp,64
    800032b0:	8082                	ret

00000000800032b2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032b2:	711d                	addi	sp,sp,-96
    800032b4:	ec86                	sd	ra,88(sp)
    800032b6:	e8a2                	sd	s0,80(sp)
    800032b8:	e4a6                	sd	s1,72(sp)
    800032ba:	e0ca                	sd	s2,64(sp)
    800032bc:	fc4e                	sd	s3,56(sp)
    800032be:	f852                	sd	s4,48(sp)
    800032c0:	f456                	sd	s5,40(sp)
    800032c2:	f05a                	sd	s6,32(sp)
    800032c4:	ec5e                	sd	s7,24(sp)
    800032c6:	e862                	sd	s8,16(sp)
    800032c8:	e466                	sd	s9,8(sp)
    800032ca:	1080                	addi	s0,sp,96
    800032cc:	84aa                	mv	s1,a0
    800032ce:	8b2e                	mv	s6,a1
    800032d0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032d2:	00054703          	lbu	a4,0(a0)
    800032d6:	02f00793          	li	a5,47
    800032da:	02f70363          	beq	a4,a5,80003300 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032de:	ffffe097          	auipc	ra,0xffffe
    800032e2:	d00080e7          	jalr	-768(ra) # 80000fde <myproc>
    800032e6:	15053503          	ld	a0,336(a0)
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	9f6080e7          	jalr	-1546(ra) # 80002ce0 <idup>
    800032f2:	89aa                	mv	s3,a0
  while(*path == '/')
    800032f4:	02f00913          	li	s2,47
  len = path - s;
    800032f8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032fa:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032fc:	4c05                	li	s8,1
    800032fe:	a865                	j	800033b6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003300:	4585                	li	a1,1
    80003302:	4505                	li	a0,1
    80003304:	fffff097          	auipc	ra,0xfffff
    80003308:	6e6080e7          	jalr	1766(ra) # 800029ea <iget>
    8000330c:	89aa                	mv	s3,a0
    8000330e:	b7dd                	j	800032f4 <namex+0x42>
      iunlockput(ip);
    80003310:	854e                	mv	a0,s3
    80003312:	00000097          	auipc	ra,0x0
    80003316:	c6e080e7          	jalr	-914(ra) # 80002f80 <iunlockput>
      return 0;
    8000331a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000331c:	854e                	mv	a0,s3
    8000331e:	60e6                	ld	ra,88(sp)
    80003320:	6446                	ld	s0,80(sp)
    80003322:	64a6                	ld	s1,72(sp)
    80003324:	6906                	ld	s2,64(sp)
    80003326:	79e2                	ld	s3,56(sp)
    80003328:	7a42                	ld	s4,48(sp)
    8000332a:	7aa2                	ld	s5,40(sp)
    8000332c:	7b02                	ld	s6,32(sp)
    8000332e:	6be2                	ld	s7,24(sp)
    80003330:	6c42                	ld	s8,16(sp)
    80003332:	6ca2                	ld	s9,8(sp)
    80003334:	6125                	addi	sp,sp,96
    80003336:	8082                	ret
      iunlock(ip);
    80003338:	854e                	mv	a0,s3
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	aa6080e7          	jalr	-1370(ra) # 80002de0 <iunlock>
      return ip;
    80003342:	bfe9                	j	8000331c <namex+0x6a>
      iunlockput(ip);
    80003344:	854e                	mv	a0,s3
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	c3a080e7          	jalr	-966(ra) # 80002f80 <iunlockput>
      return 0;
    8000334e:	89d2                	mv	s3,s4
    80003350:	b7f1                	j	8000331c <namex+0x6a>
  len = path - s;
    80003352:	40b48633          	sub	a2,s1,a1
    80003356:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000335a:	094cd463          	bge	s9,s4,800033e2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000335e:	4639                	li	a2,14
    80003360:	8556                	mv	a0,s5
    80003362:	ffffd097          	auipc	ra,0xffffd
    80003366:	ede080e7          	jalr	-290(ra) # 80000240 <memmove>
  while(*path == '/')
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	01279763          	bne	a5,s2,8000337c <namex+0xca>
    path++;
    80003372:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003374:	0004c783          	lbu	a5,0(s1)
    80003378:	ff278de3          	beq	a5,s2,80003372 <namex+0xc0>
    ilock(ip);
    8000337c:	854e                	mv	a0,s3
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	9a0080e7          	jalr	-1632(ra) # 80002d1e <ilock>
    if(ip->type != T_DIR){
    80003386:	04499783          	lh	a5,68(s3)
    8000338a:	f98793e3          	bne	a5,s8,80003310 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000338e:	000b0563          	beqz	s6,80003398 <namex+0xe6>
    80003392:	0004c783          	lbu	a5,0(s1)
    80003396:	d3cd                	beqz	a5,80003338 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003398:	865e                	mv	a2,s7
    8000339a:	85d6                	mv	a1,s5
    8000339c:	854e                	mv	a0,s3
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	e64080e7          	jalr	-412(ra) # 80003202 <dirlookup>
    800033a6:	8a2a                	mv	s4,a0
    800033a8:	dd51                	beqz	a0,80003344 <namex+0x92>
    iunlockput(ip);
    800033aa:	854e                	mv	a0,s3
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	bd4080e7          	jalr	-1068(ra) # 80002f80 <iunlockput>
    ip = next;
    800033b4:	89d2                	mv	s3,s4
  while(*path == '/')
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	05279763          	bne	a5,s2,80003408 <namex+0x156>
    path++;
    800033be:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c0:	0004c783          	lbu	a5,0(s1)
    800033c4:	ff278de3          	beq	a5,s2,800033be <namex+0x10c>
  if(*path == 0)
    800033c8:	c79d                	beqz	a5,800033f6 <namex+0x144>
    path++;
    800033ca:	85a6                	mv	a1,s1
  len = path - s;
    800033cc:	8a5e                	mv	s4,s7
    800033ce:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033d0:	01278963          	beq	a5,s2,800033e2 <namex+0x130>
    800033d4:	dfbd                	beqz	a5,80003352 <namex+0xa0>
    path++;
    800033d6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033d8:	0004c783          	lbu	a5,0(s1)
    800033dc:	ff279ce3          	bne	a5,s2,800033d4 <namex+0x122>
    800033e0:	bf8d                	j	80003352 <namex+0xa0>
    memmove(name, s, len);
    800033e2:	2601                	sext.w	a2,a2
    800033e4:	8556                	mv	a0,s5
    800033e6:	ffffd097          	auipc	ra,0xffffd
    800033ea:	e5a080e7          	jalr	-422(ra) # 80000240 <memmove>
    name[len] = 0;
    800033ee:	9a56                	add	s4,s4,s5
    800033f0:	000a0023          	sb	zero,0(s4)
    800033f4:	bf9d                	j	8000336a <namex+0xb8>
  if(nameiparent){
    800033f6:	f20b03e3          	beqz	s6,8000331c <namex+0x6a>
    iput(ip);
    800033fa:	854e                	mv	a0,s3
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	adc080e7          	jalr	-1316(ra) # 80002ed8 <iput>
    return 0;
    80003404:	4981                	li	s3,0
    80003406:	bf19                	j	8000331c <namex+0x6a>
  if(*path == 0)
    80003408:	d7fd                	beqz	a5,800033f6 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000340a:	0004c783          	lbu	a5,0(s1)
    8000340e:	85a6                	mv	a1,s1
    80003410:	b7d1                	j	800033d4 <namex+0x122>

0000000080003412 <dirlink>:
{
    80003412:	7139                	addi	sp,sp,-64
    80003414:	fc06                	sd	ra,56(sp)
    80003416:	f822                	sd	s0,48(sp)
    80003418:	f426                	sd	s1,40(sp)
    8000341a:	f04a                	sd	s2,32(sp)
    8000341c:	ec4e                	sd	s3,24(sp)
    8000341e:	e852                	sd	s4,16(sp)
    80003420:	0080                	addi	s0,sp,64
    80003422:	892a                	mv	s2,a0
    80003424:	8a2e                	mv	s4,a1
    80003426:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003428:	4601                	li	a2,0
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	dd8080e7          	jalr	-552(ra) # 80003202 <dirlookup>
    80003432:	e93d                	bnez	a0,800034a8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003434:	04c92483          	lw	s1,76(s2)
    80003438:	c49d                	beqz	s1,80003466 <dirlink+0x54>
    8000343a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000343c:	4741                	li	a4,16
    8000343e:	86a6                	mv	a3,s1
    80003440:	fc040613          	addi	a2,s0,-64
    80003444:	4581                	li	a1,0
    80003446:	854a                	mv	a0,s2
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	b8a080e7          	jalr	-1142(ra) # 80002fd2 <readi>
    80003450:	47c1                	li	a5,16
    80003452:	06f51163          	bne	a0,a5,800034b4 <dirlink+0xa2>
    if(de.inum == 0)
    80003456:	fc045783          	lhu	a5,-64(s0)
    8000345a:	c791                	beqz	a5,80003466 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000345c:	24c1                	addiw	s1,s1,16
    8000345e:	04c92783          	lw	a5,76(s2)
    80003462:	fcf4ede3          	bltu	s1,a5,8000343c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003466:	4639                	li	a2,14
    80003468:	85d2                	mv	a1,s4
    8000346a:	fc240513          	addi	a0,s0,-62
    8000346e:	ffffd097          	auipc	ra,0xffffd
    80003472:	e86080e7          	jalr	-378(ra) # 800002f4 <strncpy>
  de.inum = inum;
    80003476:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000347a:	4741                	li	a4,16
    8000347c:	86a6                	mv	a3,s1
    8000347e:	fc040613          	addi	a2,s0,-64
    80003482:	4581                	li	a1,0
    80003484:	854a                	mv	a0,s2
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	c44080e7          	jalr	-956(ra) # 800030ca <writei>
    8000348e:	872a                	mv	a4,a0
    80003490:	47c1                	li	a5,16
  return 0;
    80003492:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003494:	02f71863          	bne	a4,a5,800034c4 <dirlink+0xb2>
}
    80003498:	70e2                	ld	ra,56(sp)
    8000349a:	7442                	ld	s0,48(sp)
    8000349c:	74a2                	ld	s1,40(sp)
    8000349e:	7902                	ld	s2,32(sp)
    800034a0:	69e2                	ld	s3,24(sp)
    800034a2:	6a42                	ld	s4,16(sp)
    800034a4:	6121                	addi	sp,sp,64
    800034a6:	8082                	ret
    iput(ip);
    800034a8:	00000097          	auipc	ra,0x0
    800034ac:	a30080e7          	jalr	-1488(ra) # 80002ed8 <iput>
    return -1;
    800034b0:	557d                	li	a0,-1
    800034b2:	b7dd                	j	80003498 <dirlink+0x86>
      panic("dirlink read");
    800034b4:	00005517          	auipc	a0,0x5
    800034b8:	12450513          	addi	a0,a0,292 # 800085d8 <syscalls+0x1c8>
    800034bc:	00003097          	auipc	ra,0x3
    800034c0:	90c080e7          	jalr	-1780(ra) # 80005dc8 <panic>
    panic("dirlink");
    800034c4:	00005517          	auipc	a0,0x5
    800034c8:	22450513          	addi	a0,a0,548 # 800086e8 <syscalls+0x2d8>
    800034cc:	00003097          	auipc	ra,0x3
    800034d0:	8fc080e7          	jalr	-1796(ra) # 80005dc8 <panic>

00000000800034d4 <namei>:

struct inode*
namei(char *path)
{
    800034d4:	1101                	addi	sp,sp,-32
    800034d6:	ec06                	sd	ra,24(sp)
    800034d8:	e822                	sd	s0,16(sp)
    800034da:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034dc:	fe040613          	addi	a2,s0,-32
    800034e0:	4581                	li	a1,0
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	dd0080e7          	jalr	-560(ra) # 800032b2 <namex>
}
    800034ea:	60e2                	ld	ra,24(sp)
    800034ec:	6442                	ld	s0,16(sp)
    800034ee:	6105                	addi	sp,sp,32
    800034f0:	8082                	ret

00000000800034f2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034f2:	1141                	addi	sp,sp,-16
    800034f4:	e406                	sd	ra,8(sp)
    800034f6:	e022                	sd	s0,0(sp)
    800034f8:	0800                	addi	s0,sp,16
    800034fa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034fc:	4585                	li	a1,1
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	db4080e7          	jalr	-588(ra) # 800032b2 <namex>
}
    80003506:	60a2                	ld	ra,8(sp)
    80003508:	6402                	ld	s0,0(sp)
    8000350a:	0141                	addi	sp,sp,16
    8000350c:	8082                	ret

000000008000350e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000350e:	1101                	addi	sp,sp,-32
    80003510:	ec06                	sd	ra,24(sp)
    80003512:	e822                	sd	s0,16(sp)
    80003514:	e426                	sd	s1,8(sp)
    80003516:	e04a                	sd	s2,0(sp)
    80003518:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000351a:	000a3917          	auipc	s2,0xa3
    8000351e:	91e90913          	addi	s2,s2,-1762 # 800a5e38 <log>
    80003522:	01892583          	lw	a1,24(s2)
    80003526:	02892503          	lw	a0,40(s2)
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	ff2080e7          	jalr	-14(ra) # 8000251c <bread>
    80003532:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003534:	02c92683          	lw	a3,44(s2)
    80003538:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000353a:	02d05763          	blez	a3,80003568 <write_head+0x5a>
    8000353e:	000a3797          	auipc	a5,0xa3
    80003542:	92a78793          	addi	a5,a5,-1750 # 800a5e68 <log+0x30>
    80003546:	05c50713          	addi	a4,a0,92
    8000354a:	36fd                	addiw	a3,a3,-1
    8000354c:	1682                	slli	a3,a3,0x20
    8000354e:	9281                	srli	a3,a3,0x20
    80003550:	068a                	slli	a3,a3,0x2
    80003552:	000a3617          	auipc	a2,0xa3
    80003556:	91a60613          	addi	a2,a2,-1766 # 800a5e6c <log+0x34>
    8000355a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000355c:	4390                	lw	a2,0(a5)
    8000355e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003560:	0791                	addi	a5,a5,4
    80003562:	0711                	addi	a4,a4,4
    80003564:	fed79ce3          	bne	a5,a3,8000355c <write_head+0x4e>
  }
  bwrite(buf);
    80003568:	8526                	mv	a0,s1
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	0a4080e7          	jalr	164(ra) # 8000260e <bwrite>
  brelse(buf);
    80003572:	8526                	mv	a0,s1
    80003574:	fffff097          	auipc	ra,0xfffff
    80003578:	0d8080e7          	jalr	216(ra) # 8000264c <brelse>
}
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6902                	ld	s2,0(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret

0000000080003588 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003588:	000a3797          	auipc	a5,0xa3
    8000358c:	8dc7a783          	lw	a5,-1828(a5) # 800a5e64 <log+0x2c>
    80003590:	0af05d63          	blez	a5,8000364a <install_trans+0xc2>
{
    80003594:	7139                	addi	sp,sp,-64
    80003596:	fc06                	sd	ra,56(sp)
    80003598:	f822                	sd	s0,48(sp)
    8000359a:	f426                	sd	s1,40(sp)
    8000359c:	f04a                	sd	s2,32(sp)
    8000359e:	ec4e                	sd	s3,24(sp)
    800035a0:	e852                	sd	s4,16(sp)
    800035a2:	e456                	sd	s5,8(sp)
    800035a4:	e05a                	sd	s6,0(sp)
    800035a6:	0080                	addi	s0,sp,64
    800035a8:	8b2a                	mv	s6,a0
    800035aa:	000a3a97          	auipc	s5,0xa3
    800035ae:	8bea8a93          	addi	s5,s5,-1858 # 800a5e68 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035b4:	000a3997          	auipc	s3,0xa3
    800035b8:	88498993          	addi	s3,s3,-1916 # 800a5e38 <log>
    800035bc:	a035                	j	800035e8 <install_trans+0x60>
      bunpin(dbuf);
    800035be:	8526                	mv	a0,s1
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	166080e7          	jalr	358(ra) # 80002726 <bunpin>
    brelse(lbuf);
    800035c8:	854a                	mv	a0,s2
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	082080e7          	jalr	130(ra) # 8000264c <brelse>
    brelse(dbuf);
    800035d2:	8526                	mv	a0,s1
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	078080e7          	jalr	120(ra) # 8000264c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035dc:	2a05                	addiw	s4,s4,1
    800035de:	0a91                	addi	s5,s5,4
    800035e0:	02c9a783          	lw	a5,44(s3)
    800035e4:	04fa5963          	bge	s4,a5,80003636 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035e8:	0189a583          	lw	a1,24(s3)
    800035ec:	014585bb          	addw	a1,a1,s4
    800035f0:	2585                	addiw	a1,a1,1
    800035f2:	0289a503          	lw	a0,40(s3)
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	f26080e7          	jalr	-218(ra) # 8000251c <bread>
    800035fe:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003600:	000aa583          	lw	a1,0(s5)
    80003604:	0289a503          	lw	a0,40(s3)
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	f14080e7          	jalr	-236(ra) # 8000251c <bread>
    80003610:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003612:	40000613          	li	a2,1024
    80003616:	05890593          	addi	a1,s2,88
    8000361a:	05850513          	addi	a0,a0,88
    8000361e:	ffffd097          	auipc	ra,0xffffd
    80003622:	c22080e7          	jalr	-990(ra) # 80000240 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003626:	8526                	mv	a0,s1
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	fe6080e7          	jalr	-26(ra) # 8000260e <bwrite>
    if(recovering == 0)
    80003630:	f80b1ce3          	bnez	s6,800035c8 <install_trans+0x40>
    80003634:	b769                	j	800035be <install_trans+0x36>
}
    80003636:	70e2                	ld	ra,56(sp)
    80003638:	7442                	ld	s0,48(sp)
    8000363a:	74a2                	ld	s1,40(sp)
    8000363c:	7902                	ld	s2,32(sp)
    8000363e:	69e2                	ld	s3,24(sp)
    80003640:	6a42                	ld	s4,16(sp)
    80003642:	6aa2                	ld	s5,8(sp)
    80003644:	6b02                	ld	s6,0(sp)
    80003646:	6121                	addi	sp,sp,64
    80003648:	8082                	ret
    8000364a:	8082                	ret

000000008000364c <initlog>:
{
    8000364c:	7179                	addi	sp,sp,-48
    8000364e:	f406                	sd	ra,40(sp)
    80003650:	f022                	sd	s0,32(sp)
    80003652:	ec26                	sd	s1,24(sp)
    80003654:	e84a                	sd	s2,16(sp)
    80003656:	e44e                	sd	s3,8(sp)
    80003658:	1800                	addi	s0,sp,48
    8000365a:	892a                	mv	s2,a0
    8000365c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000365e:	000a2497          	auipc	s1,0xa2
    80003662:	7da48493          	addi	s1,s1,2010 # 800a5e38 <log>
    80003666:	00005597          	auipc	a1,0x5
    8000366a:	f8258593          	addi	a1,a1,-126 # 800085e8 <syscalls+0x1d8>
    8000366e:	8526                	mv	a0,s1
    80003670:	00003097          	auipc	ra,0x3
    80003674:	c12080e7          	jalr	-1006(ra) # 80006282 <initlock>
  log.start = sb->logstart;
    80003678:	0149a583          	lw	a1,20(s3)
    8000367c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000367e:	0109a783          	lw	a5,16(s3)
    80003682:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003684:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003688:	854a                	mv	a0,s2
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	e92080e7          	jalr	-366(ra) # 8000251c <bread>
  log.lh.n = lh->n;
    80003692:	4d3c                	lw	a5,88(a0)
    80003694:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003696:	02f05563          	blez	a5,800036c0 <initlog+0x74>
    8000369a:	05c50713          	addi	a4,a0,92
    8000369e:	000a2697          	auipc	a3,0xa2
    800036a2:	7ca68693          	addi	a3,a3,1994 # 800a5e68 <log+0x30>
    800036a6:	37fd                	addiw	a5,a5,-1
    800036a8:	1782                	slli	a5,a5,0x20
    800036aa:	9381                	srli	a5,a5,0x20
    800036ac:	078a                	slli	a5,a5,0x2
    800036ae:	06050613          	addi	a2,a0,96
    800036b2:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036b4:	4310                	lw	a2,0(a4)
    800036b6:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036b8:	0711                	addi	a4,a4,4
    800036ba:	0691                	addi	a3,a3,4
    800036bc:	fef71ce3          	bne	a4,a5,800036b4 <initlog+0x68>
  brelse(buf);
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	f8c080e7          	jalr	-116(ra) # 8000264c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036c8:	4505                	li	a0,1
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	ebe080e7          	jalr	-322(ra) # 80003588 <install_trans>
  log.lh.n = 0;
    800036d2:	000a2797          	auipc	a5,0xa2
    800036d6:	7807a923          	sw	zero,1938(a5) # 800a5e64 <log+0x2c>
  write_head(); // clear the log
    800036da:	00000097          	auipc	ra,0x0
    800036de:	e34080e7          	jalr	-460(ra) # 8000350e <write_head>
}
    800036e2:	70a2                	ld	ra,40(sp)
    800036e4:	7402                	ld	s0,32(sp)
    800036e6:	64e2                	ld	s1,24(sp)
    800036e8:	6942                	ld	s2,16(sp)
    800036ea:	69a2                	ld	s3,8(sp)
    800036ec:	6145                	addi	sp,sp,48
    800036ee:	8082                	ret

00000000800036f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036f0:	1101                	addi	sp,sp,-32
    800036f2:	ec06                	sd	ra,24(sp)
    800036f4:	e822                	sd	s0,16(sp)
    800036f6:	e426                	sd	s1,8(sp)
    800036f8:	e04a                	sd	s2,0(sp)
    800036fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036fc:	000a2517          	auipc	a0,0xa2
    80003700:	73c50513          	addi	a0,a0,1852 # 800a5e38 <log>
    80003704:	00003097          	auipc	ra,0x3
    80003708:	c0e080e7          	jalr	-1010(ra) # 80006312 <acquire>
  while(1){
    if(log.committing){
    8000370c:	000a2497          	auipc	s1,0xa2
    80003710:	72c48493          	addi	s1,s1,1836 # 800a5e38 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003714:	4979                	li	s2,30
    80003716:	a039                	j	80003724 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003718:	85a6                	mv	a1,s1
    8000371a:	8526                	mv	a0,s1
    8000371c:	ffffe097          	auipc	ra,0xffffe
    80003720:	f8c080e7          	jalr	-116(ra) # 800016a8 <sleep>
    if(log.committing){
    80003724:	50dc                	lw	a5,36(s1)
    80003726:	fbed                	bnez	a5,80003718 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003728:	509c                	lw	a5,32(s1)
    8000372a:	0017871b          	addiw	a4,a5,1
    8000372e:	0007069b          	sext.w	a3,a4
    80003732:	0027179b          	slliw	a5,a4,0x2
    80003736:	9fb9                	addw	a5,a5,a4
    80003738:	0017979b          	slliw	a5,a5,0x1
    8000373c:	54d8                	lw	a4,44(s1)
    8000373e:	9fb9                	addw	a5,a5,a4
    80003740:	00f95963          	bge	s2,a5,80003752 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003744:	85a6                	mv	a1,s1
    80003746:	8526                	mv	a0,s1
    80003748:	ffffe097          	auipc	ra,0xffffe
    8000374c:	f60080e7          	jalr	-160(ra) # 800016a8 <sleep>
    80003750:	bfd1                	j	80003724 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003752:	000a2517          	auipc	a0,0xa2
    80003756:	6e650513          	addi	a0,a0,1766 # 800a5e38 <log>
    8000375a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	c6a080e7          	jalr	-918(ra) # 800063c6 <release>
      break;
    }
  }
}
    80003764:	60e2                	ld	ra,24(sp)
    80003766:	6442                	ld	s0,16(sp)
    80003768:	64a2                	ld	s1,8(sp)
    8000376a:	6902                	ld	s2,0(sp)
    8000376c:	6105                	addi	sp,sp,32
    8000376e:	8082                	ret

0000000080003770 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003770:	7139                	addi	sp,sp,-64
    80003772:	fc06                	sd	ra,56(sp)
    80003774:	f822                	sd	s0,48(sp)
    80003776:	f426                	sd	s1,40(sp)
    80003778:	f04a                	sd	s2,32(sp)
    8000377a:	ec4e                	sd	s3,24(sp)
    8000377c:	e852                	sd	s4,16(sp)
    8000377e:	e456                	sd	s5,8(sp)
    80003780:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003782:	000a2497          	auipc	s1,0xa2
    80003786:	6b648493          	addi	s1,s1,1718 # 800a5e38 <log>
    8000378a:	8526                	mv	a0,s1
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	b86080e7          	jalr	-1146(ra) # 80006312 <acquire>
  log.outstanding -= 1;
    80003794:	509c                	lw	a5,32(s1)
    80003796:	37fd                	addiw	a5,a5,-1
    80003798:	0007891b          	sext.w	s2,a5
    8000379c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000379e:	50dc                	lw	a5,36(s1)
    800037a0:	efb9                	bnez	a5,800037fe <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037a2:	06091663          	bnez	s2,8000380e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037a6:	000a2497          	auipc	s1,0xa2
    800037aa:	69248493          	addi	s1,s1,1682 # 800a5e38 <log>
    800037ae:	4785                	li	a5,1
    800037b0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037b2:	8526                	mv	a0,s1
    800037b4:	00003097          	auipc	ra,0x3
    800037b8:	c12080e7          	jalr	-1006(ra) # 800063c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037bc:	54dc                	lw	a5,44(s1)
    800037be:	06f04763          	bgtz	a5,8000382c <end_op+0xbc>
    acquire(&log.lock);
    800037c2:	000a2497          	auipc	s1,0xa2
    800037c6:	67648493          	addi	s1,s1,1654 # 800a5e38 <log>
    800037ca:	8526                	mv	a0,s1
    800037cc:	00003097          	auipc	ra,0x3
    800037d0:	b46080e7          	jalr	-1210(ra) # 80006312 <acquire>
    log.committing = 0;
    800037d4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037d8:	8526                	mv	a0,s1
    800037da:	ffffe097          	auipc	ra,0xffffe
    800037de:	05a080e7          	jalr	90(ra) # 80001834 <wakeup>
    release(&log.lock);
    800037e2:	8526                	mv	a0,s1
    800037e4:	00003097          	auipc	ra,0x3
    800037e8:	be2080e7          	jalr	-1054(ra) # 800063c6 <release>
}
    800037ec:	70e2                	ld	ra,56(sp)
    800037ee:	7442                	ld	s0,48(sp)
    800037f0:	74a2                	ld	s1,40(sp)
    800037f2:	7902                	ld	s2,32(sp)
    800037f4:	69e2                	ld	s3,24(sp)
    800037f6:	6a42                	ld	s4,16(sp)
    800037f8:	6aa2                	ld	s5,8(sp)
    800037fa:	6121                	addi	sp,sp,64
    800037fc:	8082                	ret
    panic("log.committing");
    800037fe:	00005517          	auipc	a0,0x5
    80003802:	df250513          	addi	a0,a0,-526 # 800085f0 <syscalls+0x1e0>
    80003806:	00002097          	auipc	ra,0x2
    8000380a:	5c2080e7          	jalr	1474(ra) # 80005dc8 <panic>
    wakeup(&log);
    8000380e:	000a2497          	auipc	s1,0xa2
    80003812:	62a48493          	addi	s1,s1,1578 # 800a5e38 <log>
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	01c080e7          	jalr	28(ra) # 80001834 <wakeup>
  release(&log.lock);
    80003820:	8526                	mv	a0,s1
    80003822:	00003097          	auipc	ra,0x3
    80003826:	ba4080e7          	jalr	-1116(ra) # 800063c6 <release>
  if(do_commit){
    8000382a:	b7c9                	j	800037ec <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000382c:	000a2a97          	auipc	s5,0xa2
    80003830:	63ca8a93          	addi	s5,s5,1596 # 800a5e68 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003834:	000a2a17          	auipc	s4,0xa2
    80003838:	604a0a13          	addi	s4,s4,1540 # 800a5e38 <log>
    8000383c:	018a2583          	lw	a1,24(s4)
    80003840:	012585bb          	addw	a1,a1,s2
    80003844:	2585                	addiw	a1,a1,1
    80003846:	028a2503          	lw	a0,40(s4)
    8000384a:	fffff097          	auipc	ra,0xfffff
    8000384e:	cd2080e7          	jalr	-814(ra) # 8000251c <bread>
    80003852:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003854:	000aa583          	lw	a1,0(s5)
    80003858:	028a2503          	lw	a0,40(s4)
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	cc0080e7          	jalr	-832(ra) # 8000251c <bread>
    80003864:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003866:	40000613          	li	a2,1024
    8000386a:	05850593          	addi	a1,a0,88
    8000386e:	05848513          	addi	a0,s1,88
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	9ce080e7          	jalr	-1586(ra) # 80000240 <memmove>
    bwrite(to);  // write the log
    8000387a:	8526                	mv	a0,s1
    8000387c:	fffff097          	auipc	ra,0xfffff
    80003880:	d92080e7          	jalr	-622(ra) # 8000260e <bwrite>
    brelse(from);
    80003884:	854e                	mv	a0,s3
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	dc6080e7          	jalr	-570(ra) # 8000264c <brelse>
    brelse(to);
    8000388e:	8526                	mv	a0,s1
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	dbc080e7          	jalr	-580(ra) # 8000264c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003898:	2905                	addiw	s2,s2,1
    8000389a:	0a91                	addi	s5,s5,4
    8000389c:	02ca2783          	lw	a5,44(s4)
    800038a0:	f8f94ee3          	blt	s2,a5,8000383c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	c6a080e7          	jalr	-918(ra) # 8000350e <write_head>
    install_trans(0); // Now install writes to home locations
    800038ac:	4501                	li	a0,0
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	cda080e7          	jalr	-806(ra) # 80003588 <install_trans>
    log.lh.n = 0;
    800038b6:	000a2797          	auipc	a5,0xa2
    800038ba:	5a07a723          	sw	zero,1454(a5) # 800a5e64 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038be:	00000097          	auipc	ra,0x0
    800038c2:	c50080e7          	jalr	-944(ra) # 8000350e <write_head>
    800038c6:	bdf5                	j	800037c2 <end_op+0x52>

00000000800038c8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	e426                	sd	s1,8(sp)
    800038d0:	e04a                	sd	s2,0(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038d6:	000a2917          	auipc	s2,0xa2
    800038da:	56290913          	addi	s2,s2,1378 # 800a5e38 <log>
    800038de:	854a                	mv	a0,s2
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	a32080e7          	jalr	-1486(ra) # 80006312 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038e8:	02c92603          	lw	a2,44(s2)
    800038ec:	47f5                	li	a5,29
    800038ee:	06c7c563          	blt	a5,a2,80003958 <log_write+0x90>
    800038f2:	000a2797          	auipc	a5,0xa2
    800038f6:	5627a783          	lw	a5,1378(a5) # 800a5e54 <log+0x1c>
    800038fa:	37fd                	addiw	a5,a5,-1
    800038fc:	04f65e63          	bge	a2,a5,80003958 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003900:	000a2797          	auipc	a5,0xa2
    80003904:	5587a783          	lw	a5,1368(a5) # 800a5e58 <log+0x20>
    80003908:	06f05063          	blez	a5,80003968 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000390c:	4781                	li	a5,0
    8000390e:	06c05563          	blez	a2,80003978 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003912:	44cc                	lw	a1,12(s1)
    80003914:	000a2717          	auipc	a4,0xa2
    80003918:	55470713          	addi	a4,a4,1364 # 800a5e68 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000391c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000391e:	4314                	lw	a3,0(a4)
    80003920:	04b68c63          	beq	a3,a1,80003978 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003924:	2785                	addiw	a5,a5,1
    80003926:	0711                	addi	a4,a4,4
    80003928:	fef61be3          	bne	a2,a5,8000391e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000392c:	0621                	addi	a2,a2,8
    8000392e:	060a                	slli	a2,a2,0x2
    80003930:	000a2797          	auipc	a5,0xa2
    80003934:	50878793          	addi	a5,a5,1288 # 800a5e38 <log>
    80003938:	963e                	add	a2,a2,a5
    8000393a:	44dc                	lw	a5,12(s1)
    8000393c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000393e:	8526                	mv	a0,s1
    80003940:	fffff097          	auipc	ra,0xfffff
    80003944:	daa080e7          	jalr	-598(ra) # 800026ea <bpin>
    log.lh.n++;
    80003948:	000a2717          	auipc	a4,0xa2
    8000394c:	4f070713          	addi	a4,a4,1264 # 800a5e38 <log>
    80003950:	575c                	lw	a5,44(a4)
    80003952:	2785                	addiw	a5,a5,1
    80003954:	d75c                	sw	a5,44(a4)
    80003956:	a835                	j	80003992 <log_write+0xca>
    panic("too big a transaction");
    80003958:	00005517          	auipc	a0,0x5
    8000395c:	ca850513          	addi	a0,a0,-856 # 80008600 <syscalls+0x1f0>
    80003960:	00002097          	auipc	ra,0x2
    80003964:	468080e7          	jalr	1128(ra) # 80005dc8 <panic>
    panic("log_write outside of trans");
    80003968:	00005517          	auipc	a0,0x5
    8000396c:	cb050513          	addi	a0,a0,-848 # 80008618 <syscalls+0x208>
    80003970:	00002097          	auipc	ra,0x2
    80003974:	458080e7          	jalr	1112(ra) # 80005dc8 <panic>
  log.lh.block[i] = b->blockno;
    80003978:	00878713          	addi	a4,a5,8
    8000397c:	00271693          	slli	a3,a4,0x2
    80003980:	000a2717          	auipc	a4,0xa2
    80003984:	4b870713          	addi	a4,a4,1208 # 800a5e38 <log>
    80003988:	9736                	add	a4,a4,a3
    8000398a:	44d4                	lw	a3,12(s1)
    8000398c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000398e:	faf608e3          	beq	a2,a5,8000393e <log_write+0x76>
  }
  release(&log.lock);
    80003992:	000a2517          	auipc	a0,0xa2
    80003996:	4a650513          	addi	a0,a0,1190 # 800a5e38 <log>
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	a2c080e7          	jalr	-1492(ra) # 800063c6 <release>
}
    800039a2:	60e2                	ld	ra,24(sp)
    800039a4:	6442                	ld	s0,16(sp)
    800039a6:	64a2                	ld	s1,8(sp)
    800039a8:	6902                	ld	s2,0(sp)
    800039aa:	6105                	addi	sp,sp,32
    800039ac:	8082                	ret

00000000800039ae <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039ae:	1101                	addi	sp,sp,-32
    800039b0:	ec06                	sd	ra,24(sp)
    800039b2:	e822                	sd	s0,16(sp)
    800039b4:	e426                	sd	s1,8(sp)
    800039b6:	e04a                	sd	s2,0(sp)
    800039b8:	1000                	addi	s0,sp,32
    800039ba:	84aa                	mv	s1,a0
    800039bc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039be:	00005597          	auipc	a1,0x5
    800039c2:	c7a58593          	addi	a1,a1,-902 # 80008638 <syscalls+0x228>
    800039c6:	0521                	addi	a0,a0,8
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	8ba080e7          	jalr	-1862(ra) # 80006282 <initlock>
  lk->name = name;
    800039d0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039d8:	0204a423          	sw	zero,40(s1)
}
    800039dc:	60e2                	ld	ra,24(sp)
    800039de:	6442                	ld	s0,16(sp)
    800039e0:	64a2                	ld	s1,8(sp)
    800039e2:	6902                	ld	s2,0(sp)
    800039e4:	6105                	addi	sp,sp,32
    800039e6:	8082                	ret

00000000800039e8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039e8:	1101                	addi	sp,sp,-32
    800039ea:	ec06                	sd	ra,24(sp)
    800039ec:	e822                	sd	s0,16(sp)
    800039ee:	e426                	sd	s1,8(sp)
    800039f0:	e04a                	sd	s2,0(sp)
    800039f2:	1000                	addi	s0,sp,32
    800039f4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039f6:	00850913          	addi	s2,a0,8
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	916080e7          	jalr	-1770(ra) # 80006312 <acquire>
  while (lk->locked) {
    80003a04:	409c                	lw	a5,0(s1)
    80003a06:	cb89                	beqz	a5,80003a18 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a08:	85ca                	mv	a1,s2
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	ffffe097          	auipc	ra,0xffffe
    80003a10:	c9c080e7          	jalr	-868(ra) # 800016a8 <sleep>
  while (lk->locked) {
    80003a14:	409c                	lw	a5,0(s1)
    80003a16:	fbed                	bnez	a5,80003a08 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a18:	4785                	li	a5,1
    80003a1a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a1c:	ffffd097          	auipc	ra,0xffffd
    80003a20:	5c2080e7          	jalr	1474(ra) # 80000fde <myproc>
    80003a24:	591c                	lw	a5,48(a0)
    80003a26:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a28:	854a                	mv	a0,s2
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	99c080e7          	jalr	-1636(ra) # 800063c6 <release>
}
    80003a32:	60e2                	ld	ra,24(sp)
    80003a34:	6442                	ld	s0,16(sp)
    80003a36:	64a2                	ld	s1,8(sp)
    80003a38:	6902                	ld	s2,0(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	e04a                	sd	s2,0(sp)
    80003a48:	1000                	addi	s0,sp,32
    80003a4a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a4c:	00850913          	addi	s2,a0,8
    80003a50:	854a                	mv	a0,s2
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	8c0080e7          	jalr	-1856(ra) # 80006312 <acquire>
  lk->locked = 0;
    80003a5a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a5e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a62:	8526                	mv	a0,s1
    80003a64:	ffffe097          	auipc	ra,0xffffe
    80003a68:	dd0080e7          	jalr	-560(ra) # 80001834 <wakeup>
  release(&lk->lk);
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	958080e7          	jalr	-1704(ra) # 800063c6 <release>
}
    80003a76:	60e2                	ld	ra,24(sp)
    80003a78:	6442                	ld	s0,16(sp)
    80003a7a:	64a2                	ld	s1,8(sp)
    80003a7c:	6902                	ld	s2,0(sp)
    80003a7e:	6105                	addi	sp,sp,32
    80003a80:	8082                	ret

0000000080003a82 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a82:	7179                	addi	sp,sp,-48
    80003a84:	f406                	sd	ra,40(sp)
    80003a86:	f022                	sd	s0,32(sp)
    80003a88:	ec26                	sd	s1,24(sp)
    80003a8a:	e84a                	sd	s2,16(sp)
    80003a8c:	e44e                	sd	s3,8(sp)
    80003a8e:	1800                	addi	s0,sp,48
    80003a90:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a92:	00850913          	addi	s2,a0,8
    80003a96:	854a                	mv	a0,s2
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	87a080e7          	jalr	-1926(ra) # 80006312 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa0:	409c                	lw	a5,0(s1)
    80003aa2:	ef99                	bnez	a5,80003ac0 <holdingsleep+0x3e>
    80003aa4:	4481                	li	s1,0
  release(&lk->lk);
    80003aa6:	854a                	mv	a0,s2
    80003aa8:	00003097          	auipc	ra,0x3
    80003aac:	91e080e7          	jalr	-1762(ra) # 800063c6 <release>
  return r;
}
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	70a2                	ld	ra,40(sp)
    80003ab4:	7402                	ld	s0,32(sp)
    80003ab6:	64e2                	ld	s1,24(sp)
    80003ab8:	6942                	ld	s2,16(sp)
    80003aba:	69a2                	ld	s3,8(sp)
    80003abc:	6145                	addi	sp,sp,48
    80003abe:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ac0:	0284a983          	lw	s3,40(s1)
    80003ac4:	ffffd097          	auipc	ra,0xffffd
    80003ac8:	51a080e7          	jalr	1306(ra) # 80000fde <myproc>
    80003acc:	5904                	lw	s1,48(a0)
    80003ace:	413484b3          	sub	s1,s1,s3
    80003ad2:	0014b493          	seqz	s1,s1
    80003ad6:	bfc1                	j	80003aa6 <holdingsleep+0x24>

0000000080003ad8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ad8:	1141                	addi	sp,sp,-16
    80003ada:	e406                	sd	ra,8(sp)
    80003adc:	e022                	sd	s0,0(sp)
    80003ade:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ae0:	00005597          	auipc	a1,0x5
    80003ae4:	b6858593          	addi	a1,a1,-1176 # 80008648 <syscalls+0x238>
    80003ae8:	000a2517          	auipc	a0,0xa2
    80003aec:	49850513          	addi	a0,a0,1176 # 800a5f80 <ftable>
    80003af0:	00002097          	auipc	ra,0x2
    80003af4:	792080e7          	jalr	1938(ra) # 80006282 <initlock>
}
    80003af8:	60a2                	ld	ra,8(sp)
    80003afa:	6402                	ld	s0,0(sp)
    80003afc:	0141                	addi	sp,sp,16
    80003afe:	8082                	ret

0000000080003b00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b00:	1101                	addi	sp,sp,-32
    80003b02:	ec06                	sd	ra,24(sp)
    80003b04:	e822                	sd	s0,16(sp)
    80003b06:	e426                	sd	s1,8(sp)
    80003b08:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b0a:	000a2517          	auipc	a0,0xa2
    80003b0e:	47650513          	addi	a0,a0,1142 # 800a5f80 <ftable>
    80003b12:	00003097          	auipc	ra,0x3
    80003b16:	800080e7          	jalr	-2048(ra) # 80006312 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b1a:	000a2497          	auipc	s1,0xa2
    80003b1e:	47e48493          	addi	s1,s1,1150 # 800a5f98 <ftable+0x18>
    80003b22:	000a3717          	auipc	a4,0xa3
    80003b26:	41670713          	addi	a4,a4,1046 # 800a6f38 <ftable+0xfb8>
    if(f->ref == 0){
    80003b2a:	40dc                	lw	a5,4(s1)
    80003b2c:	cf99                	beqz	a5,80003b4a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b2e:	02848493          	addi	s1,s1,40
    80003b32:	fee49ce3          	bne	s1,a4,80003b2a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b36:	000a2517          	auipc	a0,0xa2
    80003b3a:	44a50513          	addi	a0,a0,1098 # 800a5f80 <ftable>
    80003b3e:	00003097          	auipc	ra,0x3
    80003b42:	888080e7          	jalr	-1912(ra) # 800063c6 <release>
  return 0;
    80003b46:	4481                	li	s1,0
    80003b48:	a819                	j	80003b5e <filealloc+0x5e>
      f->ref = 1;
    80003b4a:	4785                	li	a5,1
    80003b4c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b4e:	000a2517          	auipc	a0,0xa2
    80003b52:	43250513          	addi	a0,a0,1074 # 800a5f80 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	870080e7          	jalr	-1936(ra) # 800063c6 <release>
}
    80003b5e:	8526                	mv	a0,s1
    80003b60:	60e2                	ld	ra,24(sp)
    80003b62:	6442                	ld	s0,16(sp)
    80003b64:	64a2                	ld	s1,8(sp)
    80003b66:	6105                	addi	sp,sp,32
    80003b68:	8082                	ret

0000000080003b6a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b6a:	1101                	addi	sp,sp,-32
    80003b6c:	ec06                	sd	ra,24(sp)
    80003b6e:	e822                	sd	s0,16(sp)
    80003b70:	e426                	sd	s1,8(sp)
    80003b72:	1000                	addi	s0,sp,32
    80003b74:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b76:	000a2517          	auipc	a0,0xa2
    80003b7a:	40a50513          	addi	a0,a0,1034 # 800a5f80 <ftable>
    80003b7e:	00002097          	auipc	ra,0x2
    80003b82:	794080e7          	jalr	1940(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003b86:	40dc                	lw	a5,4(s1)
    80003b88:	02f05263          	blez	a5,80003bac <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b8c:	2785                	addiw	a5,a5,1
    80003b8e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b90:	000a2517          	auipc	a0,0xa2
    80003b94:	3f050513          	addi	a0,a0,1008 # 800a5f80 <ftable>
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	82e080e7          	jalr	-2002(ra) # 800063c6 <release>
  return f;
}
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	60e2                	ld	ra,24(sp)
    80003ba4:	6442                	ld	s0,16(sp)
    80003ba6:	64a2                	ld	s1,8(sp)
    80003ba8:	6105                	addi	sp,sp,32
    80003baa:	8082                	ret
    panic("filedup");
    80003bac:	00005517          	auipc	a0,0x5
    80003bb0:	aa450513          	addi	a0,a0,-1372 # 80008650 <syscalls+0x240>
    80003bb4:	00002097          	auipc	ra,0x2
    80003bb8:	214080e7          	jalr	532(ra) # 80005dc8 <panic>

0000000080003bbc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bbc:	7139                	addi	sp,sp,-64
    80003bbe:	fc06                	sd	ra,56(sp)
    80003bc0:	f822                	sd	s0,48(sp)
    80003bc2:	f426                	sd	s1,40(sp)
    80003bc4:	f04a                	sd	s2,32(sp)
    80003bc6:	ec4e                	sd	s3,24(sp)
    80003bc8:	e852                	sd	s4,16(sp)
    80003bca:	e456                	sd	s5,8(sp)
    80003bcc:	0080                	addi	s0,sp,64
    80003bce:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bd0:	000a2517          	auipc	a0,0xa2
    80003bd4:	3b050513          	addi	a0,a0,944 # 800a5f80 <ftable>
    80003bd8:	00002097          	auipc	ra,0x2
    80003bdc:	73a080e7          	jalr	1850(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003be0:	40dc                	lw	a5,4(s1)
    80003be2:	06f05163          	blez	a5,80003c44 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003be6:	37fd                	addiw	a5,a5,-1
    80003be8:	0007871b          	sext.w	a4,a5
    80003bec:	c0dc                	sw	a5,4(s1)
    80003bee:	06e04363          	bgtz	a4,80003c54 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bf2:	0004a903          	lw	s2,0(s1)
    80003bf6:	0094ca83          	lbu	s5,9(s1)
    80003bfa:	0104ba03          	ld	s4,16(s1)
    80003bfe:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c02:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c06:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c0a:	000a2517          	auipc	a0,0xa2
    80003c0e:	37650513          	addi	a0,a0,886 # 800a5f80 <ftable>
    80003c12:	00002097          	auipc	ra,0x2
    80003c16:	7b4080e7          	jalr	1972(ra) # 800063c6 <release>

  if(ff.type == FD_PIPE){
    80003c1a:	4785                	li	a5,1
    80003c1c:	04f90d63          	beq	s2,a5,80003c76 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c20:	3979                	addiw	s2,s2,-2
    80003c22:	4785                	li	a5,1
    80003c24:	0527e063          	bltu	a5,s2,80003c64 <fileclose+0xa8>
    begin_op();
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	ac8080e7          	jalr	-1336(ra) # 800036f0 <begin_op>
    iput(ff.ip);
    80003c30:	854e                	mv	a0,s3
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	2a6080e7          	jalr	678(ra) # 80002ed8 <iput>
    end_op();
    80003c3a:	00000097          	auipc	ra,0x0
    80003c3e:	b36080e7          	jalr	-1226(ra) # 80003770 <end_op>
    80003c42:	a00d                	j	80003c64 <fileclose+0xa8>
    panic("fileclose");
    80003c44:	00005517          	auipc	a0,0x5
    80003c48:	a1450513          	addi	a0,a0,-1516 # 80008658 <syscalls+0x248>
    80003c4c:	00002097          	auipc	ra,0x2
    80003c50:	17c080e7          	jalr	380(ra) # 80005dc8 <panic>
    release(&ftable.lock);
    80003c54:	000a2517          	auipc	a0,0xa2
    80003c58:	32c50513          	addi	a0,a0,812 # 800a5f80 <ftable>
    80003c5c:	00002097          	auipc	ra,0x2
    80003c60:	76a080e7          	jalr	1898(ra) # 800063c6 <release>
  }
}
    80003c64:	70e2                	ld	ra,56(sp)
    80003c66:	7442                	ld	s0,48(sp)
    80003c68:	74a2                	ld	s1,40(sp)
    80003c6a:	7902                	ld	s2,32(sp)
    80003c6c:	69e2                	ld	s3,24(sp)
    80003c6e:	6a42                	ld	s4,16(sp)
    80003c70:	6aa2                	ld	s5,8(sp)
    80003c72:	6121                	addi	sp,sp,64
    80003c74:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c76:	85d6                	mv	a1,s5
    80003c78:	8552                	mv	a0,s4
    80003c7a:	00000097          	auipc	ra,0x0
    80003c7e:	34c080e7          	jalr	844(ra) # 80003fc6 <pipeclose>
    80003c82:	b7cd                	j	80003c64 <fileclose+0xa8>

0000000080003c84 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c84:	715d                	addi	sp,sp,-80
    80003c86:	e486                	sd	ra,72(sp)
    80003c88:	e0a2                	sd	s0,64(sp)
    80003c8a:	fc26                	sd	s1,56(sp)
    80003c8c:	f84a                	sd	s2,48(sp)
    80003c8e:	f44e                	sd	s3,40(sp)
    80003c90:	0880                	addi	s0,sp,80
    80003c92:	84aa                	mv	s1,a0
    80003c94:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c96:	ffffd097          	auipc	ra,0xffffd
    80003c9a:	348080e7          	jalr	840(ra) # 80000fde <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c9e:	409c                	lw	a5,0(s1)
    80003ca0:	37f9                	addiw	a5,a5,-2
    80003ca2:	4705                	li	a4,1
    80003ca4:	04f76763          	bltu	a4,a5,80003cf2 <filestat+0x6e>
    80003ca8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003caa:	6c88                	ld	a0,24(s1)
    80003cac:	fffff097          	auipc	ra,0xfffff
    80003cb0:	072080e7          	jalr	114(ra) # 80002d1e <ilock>
    stati(f->ip, &st);
    80003cb4:	fb840593          	addi	a1,s0,-72
    80003cb8:	6c88                	ld	a0,24(s1)
    80003cba:	fffff097          	auipc	ra,0xfffff
    80003cbe:	2ee080e7          	jalr	750(ra) # 80002fa8 <stati>
    iunlock(f->ip);
    80003cc2:	6c88                	ld	a0,24(s1)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	11c080e7          	jalr	284(ra) # 80002de0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ccc:	46e1                	li	a3,24
    80003cce:	fb840613          	addi	a2,s0,-72
    80003cd2:	85ce                	mv	a1,s3
    80003cd4:	05093503          	ld	a0,80(s2)
    80003cd8:	ffffd097          	auipc	ra,0xffffd
    80003cdc:	f20080e7          	jalr	-224(ra) # 80000bf8 <copyout>
    80003ce0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ce4:	60a6                	ld	ra,72(sp)
    80003ce6:	6406                	ld	s0,64(sp)
    80003ce8:	74e2                	ld	s1,56(sp)
    80003cea:	7942                	ld	s2,48(sp)
    80003cec:	79a2                	ld	s3,40(sp)
    80003cee:	6161                	addi	sp,sp,80
    80003cf0:	8082                	ret
  return -1;
    80003cf2:	557d                	li	a0,-1
    80003cf4:	bfc5                	j	80003ce4 <filestat+0x60>

0000000080003cf6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cf6:	7179                	addi	sp,sp,-48
    80003cf8:	f406                	sd	ra,40(sp)
    80003cfa:	f022                	sd	s0,32(sp)
    80003cfc:	ec26                	sd	s1,24(sp)
    80003cfe:	e84a                	sd	s2,16(sp)
    80003d00:	e44e                	sd	s3,8(sp)
    80003d02:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d04:	00854783          	lbu	a5,8(a0)
    80003d08:	c3d5                	beqz	a5,80003dac <fileread+0xb6>
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	89ae                	mv	s3,a1
    80003d0e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d10:	411c                	lw	a5,0(a0)
    80003d12:	4705                	li	a4,1
    80003d14:	04e78963          	beq	a5,a4,80003d66 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d18:	470d                	li	a4,3
    80003d1a:	04e78d63          	beq	a5,a4,80003d74 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d1e:	4709                	li	a4,2
    80003d20:	06e79e63          	bne	a5,a4,80003d9c <fileread+0xa6>
    ilock(f->ip);
    80003d24:	6d08                	ld	a0,24(a0)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	ff8080e7          	jalr	-8(ra) # 80002d1e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d2e:	874a                	mv	a4,s2
    80003d30:	5094                	lw	a3,32(s1)
    80003d32:	864e                	mv	a2,s3
    80003d34:	4585                	li	a1,1
    80003d36:	6c88                	ld	a0,24(s1)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	29a080e7          	jalr	666(ra) # 80002fd2 <readi>
    80003d40:	892a                	mv	s2,a0
    80003d42:	00a05563          	blez	a0,80003d4c <fileread+0x56>
      f->off += r;
    80003d46:	509c                	lw	a5,32(s1)
    80003d48:	9fa9                	addw	a5,a5,a0
    80003d4a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d4c:	6c88                	ld	a0,24(s1)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	092080e7          	jalr	146(ra) # 80002de0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d56:	854a                	mv	a0,s2
    80003d58:	70a2                	ld	ra,40(sp)
    80003d5a:	7402                	ld	s0,32(sp)
    80003d5c:	64e2                	ld	s1,24(sp)
    80003d5e:	6942                	ld	s2,16(sp)
    80003d60:	69a2                	ld	s3,8(sp)
    80003d62:	6145                	addi	sp,sp,48
    80003d64:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d66:	6908                	ld	a0,16(a0)
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	3c8080e7          	jalr	968(ra) # 80004130 <piperead>
    80003d70:	892a                	mv	s2,a0
    80003d72:	b7d5                	j	80003d56 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d74:	02451783          	lh	a5,36(a0)
    80003d78:	03079693          	slli	a3,a5,0x30
    80003d7c:	92c1                	srli	a3,a3,0x30
    80003d7e:	4725                	li	a4,9
    80003d80:	02d76863          	bltu	a4,a3,80003db0 <fileread+0xba>
    80003d84:	0792                	slli	a5,a5,0x4
    80003d86:	000a2717          	auipc	a4,0xa2
    80003d8a:	15a70713          	addi	a4,a4,346 # 800a5ee0 <devsw>
    80003d8e:	97ba                	add	a5,a5,a4
    80003d90:	639c                	ld	a5,0(a5)
    80003d92:	c38d                	beqz	a5,80003db4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d94:	4505                	li	a0,1
    80003d96:	9782                	jalr	a5
    80003d98:	892a                	mv	s2,a0
    80003d9a:	bf75                	j	80003d56 <fileread+0x60>
    panic("fileread");
    80003d9c:	00005517          	auipc	a0,0x5
    80003da0:	8cc50513          	addi	a0,a0,-1844 # 80008668 <syscalls+0x258>
    80003da4:	00002097          	auipc	ra,0x2
    80003da8:	024080e7          	jalr	36(ra) # 80005dc8 <panic>
    return -1;
    80003dac:	597d                	li	s2,-1
    80003dae:	b765                	j	80003d56 <fileread+0x60>
      return -1;
    80003db0:	597d                	li	s2,-1
    80003db2:	b755                	j	80003d56 <fileread+0x60>
    80003db4:	597d                	li	s2,-1
    80003db6:	b745                	j	80003d56 <fileread+0x60>

0000000080003db8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003db8:	715d                	addi	sp,sp,-80
    80003dba:	e486                	sd	ra,72(sp)
    80003dbc:	e0a2                	sd	s0,64(sp)
    80003dbe:	fc26                	sd	s1,56(sp)
    80003dc0:	f84a                	sd	s2,48(sp)
    80003dc2:	f44e                	sd	s3,40(sp)
    80003dc4:	f052                	sd	s4,32(sp)
    80003dc6:	ec56                	sd	s5,24(sp)
    80003dc8:	e85a                	sd	s6,16(sp)
    80003dca:	e45e                	sd	s7,8(sp)
    80003dcc:	e062                	sd	s8,0(sp)
    80003dce:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dd0:	00954783          	lbu	a5,9(a0)
    80003dd4:	10078663          	beqz	a5,80003ee0 <filewrite+0x128>
    80003dd8:	892a                	mv	s2,a0
    80003dda:	8aae                	mv	s5,a1
    80003ddc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dde:	411c                	lw	a5,0(a0)
    80003de0:	4705                	li	a4,1
    80003de2:	02e78263          	beq	a5,a4,80003e06 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003de6:	470d                	li	a4,3
    80003de8:	02e78663          	beq	a5,a4,80003e14 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dec:	4709                	li	a4,2
    80003dee:	0ee79163          	bne	a5,a4,80003ed0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003df2:	0ac05d63          	blez	a2,80003eac <filewrite+0xf4>
    int i = 0;
    80003df6:	4981                	li	s3,0
    80003df8:	6b05                	lui	s6,0x1
    80003dfa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dfe:	6b85                	lui	s7,0x1
    80003e00:	c00b8b9b          	addiw	s7,s7,-1024
    80003e04:	a861                	j	80003e9c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e06:	6908                	ld	a0,16(a0)
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	22e080e7          	jalr	558(ra) # 80004036 <pipewrite>
    80003e10:	8a2a                	mv	s4,a0
    80003e12:	a045                	j	80003eb2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e14:	02451783          	lh	a5,36(a0)
    80003e18:	03079693          	slli	a3,a5,0x30
    80003e1c:	92c1                	srli	a3,a3,0x30
    80003e1e:	4725                	li	a4,9
    80003e20:	0cd76263          	bltu	a4,a3,80003ee4 <filewrite+0x12c>
    80003e24:	0792                	slli	a5,a5,0x4
    80003e26:	000a2717          	auipc	a4,0xa2
    80003e2a:	0ba70713          	addi	a4,a4,186 # 800a5ee0 <devsw>
    80003e2e:	97ba                	add	a5,a5,a4
    80003e30:	679c                	ld	a5,8(a5)
    80003e32:	cbdd                	beqz	a5,80003ee8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e34:	4505                	li	a0,1
    80003e36:	9782                	jalr	a5
    80003e38:	8a2a                	mv	s4,a0
    80003e3a:	a8a5                	j	80003eb2 <filewrite+0xfa>
    80003e3c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	8b0080e7          	jalr	-1872(ra) # 800036f0 <begin_op>
      ilock(f->ip);
    80003e48:	01893503          	ld	a0,24(s2)
    80003e4c:	fffff097          	auipc	ra,0xfffff
    80003e50:	ed2080e7          	jalr	-302(ra) # 80002d1e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e54:	8762                	mv	a4,s8
    80003e56:	02092683          	lw	a3,32(s2)
    80003e5a:	01598633          	add	a2,s3,s5
    80003e5e:	4585                	li	a1,1
    80003e60:	01893503          	ld	a0,24(s2)
    80003e64:	fffff097          	auipc	ra,0xfffff
    80003e68:	266080e7          	jalr	614(ra) # 800030ca <writei>
    80003e6c:	84aa                	mv	s1,a0
    80003e6e:	00a05763          	blez	a0,80003e7c <filewrite+0xc4>
        f->off += r;
    80003e72:	02092783          	lw	a5,32(s2)
    80003e76:	9fa9                	addw	a5,a5,a0
    80003e78:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e7c:	01893503          	ld	a0,24(s2)
    80003e80:	fffff097          	auipc	ra,0xfffff
    80003e84:	f60080e7          	jalr	-160(ra) # 80002de0 <iunlock>
      end_op();
    80003e88:	00000097          	auipc	ra,0x0
    80003e8c:	8e8080e7          	jalr	-1816(ra) # 80003770 <end_op>

      if(r != n1){
    80003e90:	009c1f63          	bne	s8,s1,80003eae <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e94:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e98:	0149db63          	bge	s3,s4,80003eae <filewrite+0xf6>
      int n1 = n - i;
    80003e9c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ea0:	84be                	mv	s1,a5
    80003ea2:	2781                	sext.w	a5,a5
    80003ea4:	f8fb5ce3          	bge	s6,a5,80003e3c <filewrite+0x84>
    80003ea8:	84de                	mv	s1,s7
    80003eaa:	bf49                	j	80003e3c <filewrite+0x84>
    int i = 0;
    80003eac:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003eae:	013a1f63          	bne	s4,s3,80003ecc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eb2:	8552                	mv	a0,s4
    80003eb4:	60a6                	ld	ra,72(sp)
    80003eb6:	6406                	ld	s0,64(sp)
    80003eb8:	74e2                	ld	s1,56(sp)
    80003eba:	7942                	ld	s2,48(sp)
    80003ebc:	79a2                	ld	s3,40(sp)
    80003ebe:	7a02                	ld	s4,32(sp)
    80003ec0:	6ae2                	ld	s5,24(sp)
    80003ec2:	6b42                	ld	s6,16(sp)
    80003ec4:	6ba2                	ld	s7,8(sp)
    80003ec6:	6c02                	ld	s8,0(sp)
    80003ec8:	6161                	addi	sp,sp,80
    80003eca:	8082                	ret
    ret = (i == n ? n : -1);
    80003ecc:	5a7d                	li	s4,-1
    80003ece:	b7d5                	j	80003eb2 <filewrite+0xfa>
    panic("filewrite");
    80003ed0:	00004517          	auipc	a0,0x4
    80003ed4:	7a850513          	addi	a0,a0,1960 # 80008678 <syscalls+0x268>
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	ef0080e7          	jalr	-272(ra) # 80005dc8 <panic>
    return -1;
    80003ee0:	5a7d                	li	s4,-1
    80003ee2:	bfc1                	j	80003eb2 <filewrite+0xfa>
      return -1;
    80003ee4:	5a7d                	li	s4,-1
    80003ee6:	b7f1                	j	80003eb2 <filewrite+0xfa>
    80003ee8:	5a7d                	li	s4,-1
    80003eea:	b7e1                	j	80003eb2 <filewrite+0xfa>

0000000080003eec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003eec:	7179                	addi	sp,sp,-48
    80003eee:	f406                	sd	ra,40(sp)
    80003ef0:	f022                	sd	s0,32(sp)
    80003ef2:	ec26                	sd	s1,24(sp)
    80003ef4:	e84a                	sd	s2,16(sp)
    80003ef6:	e44e                	sd	s3,8(sp)
    80003ef8:	e052                	sd	s4,0(sp)
    80003efa:	1800                	addi	s0,sp,48
    80003efc:	84aa                	mv	s1,a0
    80003efe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f00:	0005b023          	sd	zero,0(a1)
    80003f04:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	bf8080e7          	jalr	-1032(ra) # 80003b00 <filealloc>
    80003f10:	e088                	sd	a0,0(s1)
    80003f12:	c551                	beqz	a0,80003f9e <pipealloc+0xb2>
    80003f14:	00000097          	auipc	ra,0x0
    80003f18:	bec080e7          	jalr	-1044(ra) # 80003b00 <filealloc>
    80003f1c:	00aa3023          	sd	a0,0(s4)
    80003f20:	c92d                	beqz	a0,80003f92 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f22:	ffffc097          	auipc	ra,0xffffc
    80003f26:	246080e7          	jalr	582(ra) # 80000168 <kalloc>
    80003f2a:	892a                	mv	s2,a0
    80003f2c:	c125                	beqz	a0,80003f8c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f2e:	4985                	li	s3,1
    80003f30:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f34:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f38:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f3c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f40:	00004597          	auipc	a1,0x4
    80003f44:	74858593          	addi	a1,a1,1864 # 80008688 <syscalls+0x278>
    80003f48:	00002097          	auipc	ra,0x2
    80003f4c:	33a080e7          	jalr	826(ra) # 80006282 <initlock>
  (*f0)->type = FD_PIPE;
    80003f50:	609c                	ld	a5,0(s1)
    80003f52:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f56:	609c                	ld	a5,0(s1)
    80003f58:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f5c:	609c                	ld	a5,0(s1)
    80003f5e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f62:	609c                	ld	a5,0(s1)
    80003f64:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f68:	000a3783          	ld	a5,0(s4)
    80003f6c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f70:	000a3783          	ld	a5,0(s4)
    80003f74:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f78:	000a3783          	ld	a5,0(s4)
    80003f7c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f80:	000a3783          	ld	a5,0(s4)
    80003f84:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f88:	4501                	li	a0,0
    80003f8a:	a025                	j	80003fb2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f8c:	6088                	ld	a0,0(s1)
    80003f8e:	e501                	bnez	a0,80003f96 <pipealloc+0xaa>
    80003f90:	a039                	j	80003f9e <pipealloc+0xb2>
    80003f92:	6088                	ld	a0,0(s1)
    80003f94:	c51d                	beqz	a0,80003fc2 <pipealloc+0xd6>
    fileclose(*f0);
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	c26080e7          	jalr	-986(ra) # 80003bbc <fileclose>
  if(*f1)
    80003f9e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fa2:	557d                	li	a0,-1
  if(*f1)
    80003fa4:	c799                	beqz	a5,80003fb2 <pipealloc+0xc6>
    fileclose(*f1);
    80003fa6:	853e                	mv	a0,a5
    80003fa8:	00000097          	auipc	ra,0x0
    80003fac:	c14080e7          	jalr	-1004(ra) # 80003bbc <fileclose>
  return -1;
    80003fb0:	557d                	li	a0,-1
}
    80003fb2:	70a2                	ld	ra,40(sp)
    80003fb4:	7402                	ld	s0,32(sp)
    80003fb6:	64e2                	ld	s1,24(sp)
    80003fb8:	6942                	ld	s2,16(sp)
    80003fba:	69a2                	ld	s3,8(sp)
    80003fbc:	6a02                	ld	s4,0(sp)
    80003fbe:	6145                	addi	sp,sp,48
    80003fc0:	8082                	ret
  return -1;
    80003fc2:	557d                	li	a0,-1
    80003fc4:	b7fd                	j	80003fb2 <pipealloc+0xc6>

0000000080003fc6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fc6:	1101                	addi	sp,sp,-32
    80003fc8:	ec06                	sd	ra,24(sp)
    80003fca:	e822                	sd	s0,16(sp)
    80003fcc:	e426                	sd	s1,8(sp)
    80003fce:	e04a                	sd	s2,0(sp)
    80003fd0:	1000                	addi	s0,sp,32
    80003fd2:	84aa                	mv	s1,a0
    80003fd4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fd6:	00002097          	auipc	ra,0x2
    80003fda:	33c080e7          	jalr	828(ra) # 80006312 <acquire>
  if(writable){
    80003fde:	02090d63          	beqz	s2,80004018 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fe2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fe6:	21848513          	addi	a0,s1,536
    80003fea:	ffffe097          	auipc	ra,0xffffe
    80003fee:	84a080e7          	jalr	-1974(ra) # 80001834 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ff2:	2204b783          	ld	a5,544(s1)
    80003ff6:	eb95                	bnez	a5,8000402a <pipeclose+0x64>
    release(&pi->lock);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	00002097          	auipc	ra,0x2
    80003ffe:	3cc080e7          	jalr	972(ra) # 800063c6 <release>
    kfree((char*)pi);
    80004002:	8526                	mv	a0,s1
    80004004:	ffffc097          	auipc	ra,0xffffc
    80004008:	018080e7          	jalr	24(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000400c:	60e2                	ld	ra,24(sp)
    8000400e:	6442                	ld	s0,16(sp)
    80004010:	64a2                	ld	s1,8(sp)
    80004012:	6902                	ld	s2,0(sp)
    80004014:	6105                	addi	sp,sp,32
    80004016:	8082                	ret
    pi->readopen = 0;
    80004018:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000401c:	21c48513          	addi	a0,s1,540
    80004020:	ffffe097          	auipc	ra,0xffffe
    80004024:	814080e7          	jalr	-2028(ra) # 80001834 <wakeup>
    80004028:	b7e9                	j	80003ff2 <pipeclose+0x2c>
    release(&pi->lock);
    8000402a:	8526                	mv	a0,s1
    8000402c:	00002097          	auipc	ra,0x2
    80004030:	39a080e7          	jalr	922(ra) # 800063c6 <release>
}
    80004034:	bfe1                	j	8000400c <pipeclose+0x46>

0000000080004036 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004036:	7159                	addi	sp,sp,-112
    80004038:	f486                	sd	ra,104(sp)
    8000403a:	f0a2                	sd	s0,96(sp)
    8000403c:	eca6                	sd	s1,88(sp)
    8000403e:	e8ca                	sd	s2,80(sp)
    80004040:	e4ce                	sd	s3,72(sp)
    80004042:	e0d2                	sd	s4,64(sp)
    80004044:	fc56                	sd	s5,56(sp)
    80004046:	f85a                	sd	s6,48(sp)
    80004048:	f45e                	sd	s7,40(sp)
    8000404a:	f062                	sd	s8,32(sp)
    8000404c:	ec66                	sd	s9,24(sp)
    8000404e:	1880                	addi	s0,sp,112
    80004050:	84aa                	mv	s1,a0
    80004052:	8aae                	mv	s5,a1
    80004054:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	f88080e7          	jalr	-120(ra) # 80000fde <myproc>
    8000405e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004060:	8526                	mv	a0,s1
    80004062:	00002097          	auipc	ra,0x2
    80004066:	2b0080e7          	jalr	688(ra) # 80006312 <acquire>
  while(i < n){
    8000406a:	0d405163          	blez	s4,8000412c <pipewrite+0xf6>
    8000406e:	8ba6                	mv	s7,s1
  int i = 0;
    80004070:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004072:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004074:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004078:	21c48c13          	addi	s8,s1,540
    8000407c:	a08d                	j	800040de <pipewrite+0xa8>
      release(&pi->lock);
    8000407e:	8526                	mv	a0,s1
    80004080:	00002097          	auipc	ra,0x2
    80004084:	346080e7          	jalr	838(ra) # 800063c6 <release>
      return -1;
    80004088:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000408a:	854a                	mv	a0,s2
    8000408c:	70a6                	ld	ra,104(sp)
    8000408e:	7406                	ld	s0,96(sp)
    80004090:	64e6                	ld	s1,88(sp)
    80004092:	6946                	ld	s2,80(sp)
    80004094:	69a6                	ld	s3,72(sp)
    80004096:	6a06                	ld	s4,64(sp)
    80004098:	7ae2                	ld	s5,56(sp)
    8000409a:	7b42                	ld	s6,48(sp)
    8000409c:	7ba2                	ld	s7,40(sp)
    8000409e:	7c02                	ld	s8,32(sp)
    800040a0:	6ce2                	ld	s9,24(sp)
    800040a2:	6165                	addi	sp,sp,112
    800040a4:	8082                	ret
      wakeup(&pi->nread);
    800040a6:	8566                	mv	a0,s9
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	78c080e7          	jalr	1932(ra) # 80001834 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040b0:	85de                	mv	a1,s7
    800040b2:	8562                	mv	a0,s8
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	5f4080e7          	jalr	1524(ra) # 800016a8 <sleep>
    800040bc:	a839                	j	800040da <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040be:	21c4a783          	lw	a5,540(s1)
    800040c2:	0017871b          	addiw	a4,a5,1
    800040c6:	20e4ae23          	sw	a4,540(s1)
    800040ca:	1ff7f793          	andi	a5,a5,511
    800040ce:	97a6                	add	a5,a5,s1
    800040d0:	f9f44703          	lbu	a4,-97(s0)
    800040d4:	00e78c23          	sb	a4,24(a5)
      i++;
    800040d8:	2905                	addiw	s2,s2,1
  while(i < n){
    800040da:	03495d63          	bge	s2,s4,80004114 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040de:	2204a783          	lw	a5,544(s1)
    800040e2:	dfd1                	beqz	a5,8000407e <pipewrite+0x48>
    800040e4:	0289a783          	lw	a5,40(s3)
    800040e8:	fbd9                	bnez	a5,8000407e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040ea:	2184a783          	lw	a5,536(s1)
    800040ee:	21c4a703          	lw	a4,540(s1)
    800040f2:	2007879b          	addiw	a5,a5,512
    800040f6:	faf708e3          	beq	a4,a5,800040a6 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040fa:	4685                	li	a3,1
    800040fc:	01590633          	add	a2,s2,s5
    80004100:	f9f40593          	addi	a1,s0,-97
    80004104:	0509b503          	ld	a0,80(s3)
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	c24080e7          	jalr	-988(ra) # 80000d2c <copyin>
    80004110:	fb6517e3          	bne	a0,s6,800040be <pipewrite+0x88>
  wakeup(&pi->nread);
    80004114:	21848513          	addi	a0,s1,536
    80004118:	ffffd097          	auipc	ra,0xffffd
    8000411c:	71c080e7          	jalr	1820(ra) # 80001834 <wakeup>
  release(&pi->lock);
    80004120:	8526                	mv	a0,s1
    80004122:	00002097          	auipc	ra,0x2
    80004126:	2a4080e7          	jalr	676(ra) # 800063c6 <release>
  return i;
    8000412a:	b785                	j	8000408a <pipewrite+0x54>
  int i = 0;
    8000412c:	4901                	li	s2,0
    8000412e:	b7dd                	j	80004114 <pipewrite+0xde>

0000000080004130 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004130:	715d                	addi	sp,sp,-80
    80004132:	e486                	sd	ra,72(sp)
    80004134:	e0a2                	sd	s0,64(sp)
    80004136:	fc26                	sd	s1,56(sp)
    80004138:	f84a                	sd	s2,48(sp)
    8000413a:	f44e                	sd	s3,40(sp)
    8000413c:	f052                	sd	s4,32(sp)
    8000413e:	ec56                	sd	s5,24(sp)
    80004140:	e85a                	sd	s6,16(sp)
    80004142:	0880                	addi	s0,sp,80
    80004144:	84aa                	mv	s1,a0
    80004146:	892e                	mv	s2,a1
    80004148:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	e94080e7          	jalr	-364(ra) # 80000fde <myproc>
    80004152:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004154:	8b26                	mv	s6,s1
    80004156:	8526                	mv	a0,s1
    80004158:	00002097          	auipc	ra,0x2
    8000415c:	1ba080e7          	jalr	442(ra) # 80006312 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004160:	2184a703          	lw	a4,536(s1)
    80004164:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004168:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416c:	02f71463          	bne	a4,a5,80004194 <piperead+0x64>
    80004170:	2244a783          	lw	a5,548(s1)
    80004174:	c385                	beqz	a5,80004194 <piperead+0x64>
    if(pr->killed){
    80004176:	028a2783          	lw	a5,40(s4)
    8000417a:	ebc1                	bnez	a5,8000420a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000417c:	85da                	mv	a1,s6
    8000417e:	854e                	mv	a0,s3
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	528080e7          	jalr	1320(ra) # 800016a8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004188:	2184a703          	lw	a4,536(s1)
    8000418c:	21c4a783          	lw	a5,540(s1)
    80004190:	fef700e3          	beq	a4,a5,80004170 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004194:	09505263          	blez	s5,80004218 <piperead+0xe8>
    80004198:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000419a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000419c:	2184a783          	lw	a5,536(s1)
    800041a0:	21c4a703          	lw	a4,540(s1)
    800041a4:	02f70d63          	beq	a4,a5,800041de <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041a8:	0017871b          	addiw	a4,a5,1
    800041ac:	20e4ac23          	sw	a4,536(s1)
    800041b0:	1ff7f793          	andi	a5,a5,511
    800041b4:	97a6                	add	a5,a5,s1
    800041b6:	0187c783          	lbu	a5,24(a5)
    800041ba:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041be:	4685                	li	a3,1
    800041c0:	fbf40613          	addi	a2,s0,-65
    800041c4:	85ca                	mv	a1,s2
    800041c6:	050a3503          	ld	a0,80(s4)
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	a2e080e7          	jalr	-1490(ra) # 80000bf8 <copyout>
    800041d2:	01650663          	beq	a0,s6,800041de <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041d6:	2985                	addiw	s3,s3,1
    800041d8:	0905                	addi	s2,s2,1
    800041da:	fd3a91e3          	bne	s5,s3,8000419c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041de:	21c48513          	addi	a0,s1,540
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	652080e7          	jalr	1618(ra) # 80001834 <wakeup>
  release(&pi->lock);
    800041ea:	8526                	mv	a0,s1
    800041ec:	00002097          	auipc	ra,0x2
    800041f0:	1da080e7          	jalr	474(ra) # 800063c6 <release>
  return i;
}
    800041f4:	854e                	mv	a0,s3
    800041f6:	60a6                	ld	ra,72(sp)
    800041f8:	6406                	ld	s0,64(sp)
    800041fa:	74e2                	ld	s1,56(sp)
    800041fc:	7942                	ld	s2,48(sp)
    800041fe:	79a2                	ld	s3,40(sp)
    80004200:	7a02                	ld	s4,32(sp)
    80004202:	6ae2                	ld	s5,24(sp)
    80004204:	6b42                	ld	s6,16(sp)
    80004206:	6161                	addi	sp,sp,80
    80004208:	8082                	ret
      release(&pi->lock);
    8000420a:	8526                	mv	a0,s1
    8000420c:	00002097          	auipc	ra,0x2
    80004210:	1ba080e7          	jalr	442(ra) # 800063c6 <release>
      return -1;
    80004214:	59fd                	li	s3,-1
    80004216:	bff9                	j	800041f4 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004218:	4981                	li	s3,0
    8000421a:	b7d1                	j	800041de <piperead+0xae>

000000008000421c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000421c:	df010113          	addi	sp,sp,-528
    80004220:	20113423          	sd	ra,520(sp)
    80004224:	20813023          	sd	s0,512(sp)
    80004228:	ffa6                	sd	s1,504(sp)
    8000422a:	fbca                	sd	s2,496(sp)
    8000422c:	f7ce                	sd	s3,488(sp)
    8000422e:	f3d2                	sd	s4,480(sp)
    80004230:	efd6                	sd	s5,472(sp)
    80004232:	ebda                	sd	s6,464(sp)
    80004234:	e7de                	sd	s7,456(sp)
    80004236:	e3e2                	sd	s8,448(sp)
    80004238:	ff66                	sd	s9,440(sp)
    8000423a:	fb6a                	sd	s10,432(sp)
    8000423c:	f76e                	sd	s11,424(sp)
    8000423e:	0c00                	addi	s0,sp,528
    80004240:	84aa                	mv	s1,a0
    80004242:	dea43c23          	sd	a0,-520(s0)
    80004246:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	d94080e7          	jalr	-620(ra) # 80000fde <myproc>
    80004252:	892a                	mv	s2,a0

  begin_op();
    80004254:	fffff097          	auipc	ra,0xfffff
    80004258:	49c080e7          	jalr	1180(ra) # 800036f0 <begin_op>

  if((ip = namei(path)) == 0){
    8000425c:	8526                	mv	a0,s1
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	276080e7          	jalr	630(ra) # 800034d4 <namei>
    80004266:	c92d                	beqz	a0,800042d8 <exec+0xbc>
    80004268:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	ab4080e7          	jalr	-1356(ra) # 80002d1e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004272:	04000713          	li	a4,64
    80004276:	4681                	li	a3,0
    80004278:	e5040613          	addi	a2,s0,-432
    8000427c:	4581                	li	a1,0
    8000427e:	8526                	mv	a0,s1
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	d52080e7          	jalr	-686(ra) # 80002fd2 <readi>
    80004288:	04000793          	li	a5,64
    8000428c:	00f51a63          	bne	a0,a5,800042a0 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004290:	e5042703          	lw	a4,-432(s0)
    80004294:	464c47b7          	lui	a5,0x464c4
    80004298:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000429c:	04f70463          	beq	a4,a5,800042e4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042a0:	8526                	mv	a0,s1
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	cde080e7          	jalr	-802(ra) # 80002f80 <iunlockput>
    end_op();
    800042aa:	fffff097          	auipc	ra,0xfffff
    800042ae:	4c6080e7          	jalr	1222(ra) # 80003770 <end_op>
  }
  return -1;
    800042b2:	557d                	li	a0,-1
}
    800042b4:	20813083          	ld	ra,520(sp)
    800042b8:	20013403          	ld	s0,512(sp)
    800042bc:	74fe                	ld	s1,504(sp)
    800042be:	795e                	ld	s2,496(sp)
    800042c0:	79be                	ld	s3,488(sp)
    800042c2:	7a1e                	ld	s4,480(sp)
    800042c4:	6afe                	ld	s5,472(sp)
    800042c6:	6b5e                	ld	s6,464(sp)
    800042c8:	6bbe                	ld	s7,456(sp)
    800042ca:	6c1e                	ld	s8,448(sp)
    800042cc:	7cfa                	ld	s9,440(sp)
    800042ce:	7d5a                	ld	s10,432(sp)
    800042d0:	7dba                	ld	s11,424(sp)
    800042d2:	21010113          	addi	sp,sp,528
    800042d6:	8082                	ret
    end_op();
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	498080e7          	jalr	1176(ra) # 80003770 <end_op>
    return -1;
    800042e0:	557d                	li	a0,-1
    800042e2:	bfc9                	j	800042b4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042e4:	854a                	mv	a0,s2
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	dbc080e7          	jalr	-580(ra) # 800010a2 <proc_pagetable>
    800042ee:	8baa                	mv	s7,a0
    800042f0:	d945                	beqz	a0,800042a0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042f2:	e7042983          	lw	s3,-400(s0)
    800042f6:	e8845783          	lhu	a5,-376(s0)
    800042fa:	c7ad                	beqz	a5,80004364 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042fc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042fe:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004300:	6c85                	lui	s9,0x1
    80004302:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004306:	def43823          	sd	a5,-528(s0)
    8000430a:	a42d                	j	80004534 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000430c:	00004517          	auipc	a0,0x4
    80004310:	38450513          	addi	a0,a0,900 # 80008690 <syscalls+0x280>
    80004314:	00002097          	auipc	ra,0x2
    80004318:	ab4080e7          	jalr	-1356(ra) # 80005dc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000431c:	8756                	mv	a4,s5
    8000431e:	012d86bb          	addw	a3,s11,s2
    80004322:	4581                	li	a1,0
    80004324:	8526                	mv	a0,s1
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	cac080e7          	jalr	-852(ra) # 80002fd2 <readi>
    8000432e:	2501                	sext.w	a0,a0
    80004330:	1aaa9963          	bne	s5,a0,800044e2 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004334:	6785                	lui	a5,0x1
    80004336:	0127893b          	addw	s2,a5,s2
    8000433a:	77fd                	lui	a5,0xfffff
    8000433c:	01478a3b          	addw	s4,a5,s4
    80004340:	1f897163          	bgeu	s2,s8,80004522 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004344:	02091593          	slli	a1,s2,0x20
    80004348:	9181                	srli	a1,a1,0x20
    8000434a:	95ea                	add	a1,a1,s10
    8000434c:	855e                	mv	a0,s7
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	220080e7          	jalr	544(ra) # 8000056e <walkaddr>
    80004356:	862a                	mv	a2,a0
    if(pa == 0)
    80004358:	d955                	beqz	a0,8000430c <exec+0xf0>
      n = PGSIZE;
    8000435a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000435c:	fd9a70e3          	bgeu	s4,s9,8000431c <exec+0x100>
      n = sz - i;
    80004360:	8ad2                	mv	s5,s4
    80004362:	bf6d                	j	8000431c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004364:	4901                	li	s2,0
  iunlockput(ip);
    80004366:	8526                	mv	a0,s1
    80004368:	fffff097          	auipc	ra,0xfffff
    8000436c:	c18080e7          	jalr	-1000(ra) # 80002f80 <iunlockput>
  end_op();
    80004370:	fffff097          	auipc	ra,0xfffff
    80004374:	400080e7          	jalr	1024(ra) # 80003770 <end_op>
  p = myproc();
    80004378:	ffffd097          	auipc	ra,0xffffd
    8000437c:	c66080e7          	jalr	-922(ra) # 80000fde <myproc>
    80004380:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004382:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004386:	6785                	lui	a5,0x1
    80004388:	17fd                	addi	a5,a5,-1
    8000438a:	993e                	add	s2,s2,a5
    8000438c:	757d                	lui	a0,0xfffff
    8000438e:	00a977b3          	and	a5,s2,a0
    80004392:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004396:	6609                	lui	a2,0x2
    80004398:	963e                	add	a2,a2,a5
    8000439a:	85be                	mv	a1,a5
    8000439c:	855e                	mv	a0,s7
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	5e0080e7          	jalr	1504(ra) # 8000097e <uvmalloc>
    800043a6:	8b2a                	mv	s6,a0
  ip = 0;
    800043a8:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043aa:	12050c63          	beqz	a0,800044e2 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043ae:	75f9                	lui	a1,0xffffe
    800043b0:	95aa                	add	a1,a1,a0
    800043b2:	855e                	mv	a0,s7
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	812080e7          	jalr	-2030(ra) # 80000bc6 <uvmclear>
  stackbase = sp - PGSIZE;
    800043bc:	7c7d                	lui	s8,0xfffff
    800043be:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043c0:	e0043783          	ld	a5,-512(s0)
    800043c4:	6388                	ld	a0,0(a5)
    800043c6:	c535                	beqz	a0,80004432 <exec+0x216>
    800043c8:	e9040993          	addi	s3,s0,-368
    800043cc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043d0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	f92080e7          	jalr	-110(ra) # 80000364 <strlen>
    800043da:	2505                	addiw	a0,a0,1
    800043dc:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043e0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043e4:	13896363          	bltu	s2,s8,8000450a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043e8:	e0043d83          	ld	s11,-512(s0)
    800043ec:	000dba03          	ld	s4,0(s11) # fffffffffffff000 <end+0xffffffff7ff4cdc0>
    800043f0:	8552                	mv	a0,s4
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	f72080e7          	jalr	-142(ra) # 80000364 <strlen>
    800043fa:	0015069b          	addiw	a3,a0,1
    800043fe:	8652                	mv	a2,s4
    80004400:	85ca                	mv	a1,s2
    80004402:	855e                	mv	a0,s7
    80004404:	ffffc097          	auipc	ra,0xffffc
    80004408:	7f4080e7          	jalr	2036(ra) # 80000bf8 <copyout>
    8000440c:	10054363          	bltz	a0,80004512 <exec+0x2f6>
    ustack[argc] = sp;
    80004410:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004414:	0485                	addi	s1,s1,1
    80004416:	008d8793          	addi	a5,s11,8
    8000441a:	e0f43023          	sd	a5,-512(s0)
    8000441e:	008db503          	ld	a0,8(s11)
    80004422:	c911                	beqz	a0,80004436 <exec+0x21a>
    if(argc >= MAXARG)
    80004424:	09a1                	addi	s3,s3,8
    80004426:	fb3c96e3          	bne	s9,s3,800043d2 <exec+0x1b6>
  sz = sz1;
    8000442a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000442e:	4481                	li	s1,0
    80004430:	a84d                	j	800044e2 <exec+0x2c6>
  sp = sz;
    80004432:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004434:	4481                	li	s1,0
  ustack[argc] = 0;
    80004436:	00349793          	slli	a5,s1,0x3
    8000443a:	f9040713          	addi	a4,s0,-112
    8000443e:	97ba                	add	a5,a5,a4
    80004440:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004444:	00148693          	addi	a3,s1,1
    80004448:	068e                	slli	a3,a3,0x3
    8000444a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000444e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004452:	01897663          	bgeu	s2,s8,8000445e <exec+0x242>
  sz = sz1;
    80004456:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000445a:	4481                	li	s1,0
    8000445c:	a059                	j	800044e2 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000445e:	e9040613          	addi	a2,s0,-368
    80004462:	85ca                	mv	a1,s2
    80004464:	855e                	mv	a0,s7
    80004466:	ffffc097          	auipc	ra,0xffffc
    8000446a:	792080e7          	jalr	1938(ra) # 80000bf8 <copyout>
    8000446e:	0a054663          	bltz	a0,8000451a <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004472:	058ab783          	ld	a5,88(s5)
    80004476:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000447a:	df843783          	ld	a5,-520(s0)
    8000447e:	0007c703          	lbu	a4,0(a5)
    80004482:	cf11                	beqz	a4,8000449e <exec+0x282>
    80004484:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004486:	02f00693          	li	a3,47
    8000448a:	a039                	j	80004498 <exec+0x27c>
      last = s+1;
    8000448c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004490:	0785                	addi	a5,a5,1
    80004492:	fff7c703          	lbu	a4,-1(a5)
    80004496:	c701                	beqz	a4,8000449e <exec+0x282>
    if(*s == '/')
    80004498:	fed71ce3          	bne	a4,a3,80004490 <exec+0x274>
    8000449c:	bfc5                	j	8000448c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000449e:	4641                	li	a2,16
    800044a0:	df843583          	ld	a1,-520(s0)
    800044a4:	158a8513          	addi	a0,s5,344
    800044a8:	ffffc097          	auipc	ra,0xffffc
    800044ac:	e8a080e7          	jalr	-374(ra) # 80000332 <safestrcpy>
  oldpagetable = p->pagetable;
    800044b0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044b4:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044b8:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044bc:	058ab783          	ld	a5,88(s5)
    800044c0:	e6843703          	ld	a4,-408(s0)
    800044c4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044c6:	058ab783          	ld	a5,88(s5)
    800044ca:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ce:	85ea                	mv	a1,s10
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	c6e080e7          	jalr	-914(ra) # 8000113e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044d8:	0004851b          	sext.w	a0,s1
    800044dc:	bbe1                	j	800042b4 <exec+0x98>
    800044de:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044e2:	e0843583          	ld	a1,-504(s0)
    800044e6:	855e                	mv	a0,s7
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	c56080e7          	jalr	-938(ra) # 8000113e <proc_freepagetable>
  if(ip){
    800044f0:	da0498e3          	bnez	s1,800042a0 <exec+0x84>
  return -1;
    800044f4:	557d                	li	a0,-1
    800044f6:	bb7d                	j	800042b4 <exec+0x98>
    800044f8:	e1243423          	sd	s2,-504(s0)
    800044fc:	b7dd                	j	800044e2 <exec+0x2c6>
    800044fe:	e1243423          	sd	s2,-504(s0)
    80004502:	b7c5                	j	800044e2 <exec+0x2c6>
    80004504:	e1243423          	sd	s2,-504(s0)
    80004508:	bfe9                	j	800044e2 <exec+0x2c6>
  sz = sz1;
    8000450a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000450e:	4481                	li	s1,0
    80004510:	bfc9                	j	800044e2 <exec+0x2c6>
  sz = sz1;
    80004512:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004516:	4481                	li	s1,0
    80004518:	b7e9                	j	800044e2 <exec+0x2c6>
  sz = sz1;
    8000451a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000451e:	4481                	li	s1,0
    80004520:	b7c9                	j	800044e2 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004522:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004526:	2b05                	addiw	s6,s6,1
    80004528:	0389899b          	addiw	s3,s3,56
    8000452c:	e8845783          	lhu	a5,-376(s0)
    80004530:	e2fb5be3          	bge	s6,a5,80004366 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004534:	2981                	sext.w	s3,s3
    80004536:	03800713          	li	a4,56
    8000453a:	86ce                	mv	a3,s3
    8000453c:	e1840613          	addi	a2,s0,-488
    80004540:	4581                	li	a1,0
    80004542:	8526                	mv	a0,s1
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	a8e080e7          	jalr	-1394(ra) # 80002fd2 <readi>
    8000454c:	03800793          	li	a5,56
    80004550:	f8f517e3          	bne	a0,a5,800044de <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004554:	e1842783          	lw	a5,-488(s0)
    80004558:	4705                	li	a4,1
    8000455a:	fce796e3          	bne	a5,a4,80004526 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000455e:	e4043603          	ld	a2,-448(s0)
    80004562:	e3843783          	ld	a5,-456(s0)
    80004566:	f8f669e3          	bltu	a2,a5,800044f8 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000456a:	e2843783          	ld	a5,-472(s0)
    8000456e:	963e                	add	a2,a2,a5
    80004570:	f8f667e3          	bltu	a2,a5,800044fe <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004574:	85ca                	mv	a1,s2
    80004576:	855e                	mv	a0,s7
    80004578:	ffffc097          	auipc	ra,0xffffc
    8000457c:	406080e7          	jalr	1030(ra) # 8000097e <uvmalloc>
    80004580:	e0a43423          	sd	a0,-504(s0)
    80004584:	d141                	beqz	a0,80004504 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004586:	e2843d03          	ld	s10,-472(s0)
    8000458a:	df043783          	ld	a5,-528(s0)
    8000458e:	00fd77b3          	and	a5,s10,a5
    80004592:	fba1                	bnez	a5,800044e2 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004594:	e2042d83          	lw	s11,-480(s0)
    80004598:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000459c:	f80c03e3          	beqz	s8,80004522 <exec+0x306>
    800045a0:	8a62                	mv	s4,s8
    800045a2:	4901                	li	s2,0
    800045a4:	b345                	j	80004344 <exec+0x128>

00000000800045a6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045a6:	7179                	addi	sp,sp,-48
    800045a8:	f406                	sd	ra,40(sp)
    800045aa:	f022                	sd	s0,32(sp)
    800045ac:	ec26                	sd	s1,24(sp)
    800045ae:	e84a                	sd	s2,16(sp)
    800045b0:	1800                	addi	s0,sp,48
    800045b2:	892e                	mv	s2,a1
    800045b4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045b6:	fdc40593          	addi	a1,s0,-36
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	bf2080e7          	jalr	-1038(ra) # 800021ac <argint>
    800045c2:	04054063          	bltz	a0,80004602 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045c6:	fdc42703          	lw	a4,-36(s0)
    800045ca:	47bd                	li	a5,15
    800045cc:	02e7ed63          	bltu	a5,a4,80004606 <argfd+0x60>
    800045d0:	ffffd097          	auipc	ra,0xffffd
    800045d4:	a0e080e7          	jalr	-1522(ra) # 80000fde <myproc>
    800045d8:	fdc42703          	lw	a4,-36(s0)
    800045dc:	01a70793          	addi	a5,a4,26
    800045e0:	078e                	slli	a5,a5,0x3
    800045e2:	953e                	add	a0,a0,a5
    800045e4:	611c                	ld	a5,0(a0)
    800045e6:	c395                	beqz	a5,8000460a <argfd+0x64>
    return -1;
  if(pfd)
    800045e8:	00090463          	beqz	s2,800045f0 <argfd+0x4a>
    *pfd = fd;
    800045ec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045f0:	4501                	li	a0,0
  if(pf)
    800045f2:	c091                	beqz	s1,800045f6 <argfd+0x50>
    *pf = f;
    800045f4:	e09c                	sd	a5,0(s1)
}
    800045f6:	70a2                	ld	ra,40(sp)
    800045f8:	7402                	ld	s0,32(sp)
    800045fa:	64e2                	ld	s1,24(sp)
    800045fc:	6942                	ld	s2,16(sp)
    800045fe:	6145                	addi	sp,sp,48
    80004600:	8082                	ret
    return -1;
    80004602:	557d                	li	a0,-1
    80004604:	bfcd                	j	800045f6 <argfd+0x50>
    return -1;
    80004606:	557d                	li	a0,-1
    80004608:	b7fd                	j	800045f6 <argfd+0x50>
    8000460a:	557d                	li	a0,-1
    8000460c:	b7ed                	j	800045f6 <argfd+0x50>

000000008000460e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000460e:	1101                	addi	sp,sp,-32
    80004610:	ec06                	sd	ra,24(sp)
    80004612:	e822                	sd	s0,16(sp)
    80004614:	e426                	sd	s1,8(sp)
    80004616:	1000                	addi	s0,sp,32
    80004618:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000461a:	ffffd097          	auipc	ra,0xffffd
    8000461e:	9c4080e7          	jalr	-1596(ra) # 80000fde <myproc>
    80004622:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004624:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ff4ce90>
    80004628:	4501                	li	a0,0
    8000462a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000462c:	6398                	ld	a4,0(a5)
    8000462e:	cb19                	beqz	a4,80004644 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004630:	2505                	addiw	a0,a0,1
    80004632:	07a1                	addi	a5,a5,8
    80004634:	fed51ce3          	bne	a0,a3,8000462c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004638:	557d                	li	a0,-1
}
    8000463a:	60e2                	ld	ra,24(sp)
    8000463c:	6442                	ld	s0,16(sp)
    8000463e:	64a2                	ld	s1,8(sp)
    80004640:	6105                	addi	sp,sp,32
    80004642:	8082                	ret
      p->ofile[fd] = f;
    80004644:	01a50793          	addi	a5,a0,26
    80004648:	078e                	slli	a5,a5,0x3
    8000464a:	963e                	add	a2,a2,a5
    8000464c:	e204                	sd	s1,0(a2)
      return fd;
    8000464e:	b7f5                	j	8000463a <fdalloc+0x2c>

0000000080004650 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004650:	715d                	addi	sp,sp,-80
    80004652:	e486                	sd	ra,72(sp)
    80004654:	e0a2                	sd	s0,64(sp)
    80004656:	fc26                	sd	s1,56(sp)
    80004658:	f84a                	sd	s2,48(sp)
    8000465a:	f44e                	sd	s3,40(sp)
    8000465c:	f052                	sd	s4,32(sp)
    8000465e:	ec56                	sd	s5,24(sp)
    80004660:	0880                	addi	s0,sp,80
    80004662:	89ae                	mv	s3,a1
    80004664:	8ab2                	mv	s5,a2
    80004666:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004668:	fb040593          	addi	a1,s0,-80
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	e86080e7          	jalr	-378(ra) # 800034f2 <nameiparent>
    80004674:	892a                	mv	s2,a0
    80004676:	12050f63          	beqz	a0,800047b4 <create+0x164>
    return 0;

  ilock(dp);
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	6a4080e7          	jalr	1700(ra) # 80002d1e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004682:	4601                	li	a2,0
    80004684:	fb040593          	addi	a1,s0,-80
    80004688:	854a                	mv	a0,s2
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	b78080e7          	jalr	-1160(ra) # 80003202 <dirlookup>
    80004692:	84aa                	mv	s1,a0
    80004694:	c921                	beqz	a0,800046e4 <create+0x94>
    iunlockput(dp);
    80004696:	854a                	mv	a0,s2
    80004698:	fffff097          	auipc	ra,0xfffff
    8000469c:	8e8080e7          	jalr	-1816(ra) # 80002f80 <iunlockput>
    ilock(ip);
    800046a0:	8526                	mv	a0,s1
    800046a2:	ffffe097          	auipc	ra,0xffffe
    800046a6:	67c080e7          	jalr	1660(ra) # 80002d1e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046aa:	2981                	sext.w	s3,s3
    800046ac:	4789                	li	a5,2
    800046ae:	02f99463          	bne	s3,a5,800046d6 <create+0x86>
    800046b2:	0444d783          	lhu	a5,68(s1)
    800046b6:	37f9                	addiw	a5,a5,-2
    800046b8:	17c2                	slli	a5,a5,0x30
    800046ba:	93c1                	srli	a5,a5,0x30
    800046bc:	4705                	li	a4,1
    800046be:	00f76c63          	bltu	a4,a5,800046d6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046c2:	8526                	mv	a0,s1
    800046c4:	60a6                	ld	ra,72(sp)
    800046c6:	6406                	ld	s0,64(sp)
    800046c8:	74e2                	ld	s1,56(sp)
    800046ca:	7942                	ld	s2,48(sp)
    800046cc:	79a2                	ld	s3,40(sp)
    800046ce:	7a02                	ld	s4,32(sp)
    800046d0:	6ae2                	ld	s5,24(sp)
    800046d2:	6161                	addi	sp,sp,80
    800046d4:	8082                	ret
    iunlockput(ip);
    800046d6:	8526                	mv	a0,s1
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	8a8080e7          	jalr	-1880(ra) # 80002f80 <iunlockput>
    return 0;
    800046e0:	4481                	li	s1,0
    800046e2:	b7c5                	j	800046c2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046e4:	85ce                	mv	a1,s3
    800046e6:	00092503          	lw	a0,0(s2)
    800046ea:	ffffe097          	auipc	ra,0xffffe
    800046ee:	49c080e7          	jalr	1180(ra) # 80002b86 <ialloc>
    800046f2:	84aa                	mv	s1,a0
    800046f4:	c529                	beqz	a0,8000473e <create+0xee>
  ilock(ip);
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	628080e7          	jalr	1576(ra) # 80002d1e <ilock>
  ip->major = major;
    800046fe:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004702:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004706:	4785                	li	a5,1
    80004708:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000470c:	8526                	mv	a0,s1
    8000470e:	ffffe097          	auipc	ra,0xffffe
    80004712:	546080e7          	jalr	1350(ra) # 80002c54 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004716:	2981                	sext.w	s3,s3
    80004718:	4785                	li	a5,1
    8000471a:	02f98a63          	beq	s3,a5,8000474e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000471e:	40d0                	lw	a2,4(s1)
    80004720:	fb040593          	addi	a1,s0,-80
    80004724:	854a                	mv	a0,s2
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	cec080e7          	jalr	-788(ra) # 80003412 <dirlink>
    8000472e:	06054b63          	bltz	a0,800047a4 <create+0x154>
  iunlockput(dp);
    80004732:	854a                	mv	a0,s2
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	84c080e7          	jalr	-1972(ra) # 80002f80 <iunlockput>
  return ip;
    8000473c:	b759                	j	800046c2 <create+0x72>
    panic("create: ialloc");
    8000473e:	00004517          	auipc	a0,0x4
    80004742:	f7250513          	addi	a0,a0,-142 # 800086b0 <syscalls+0x2a0>
    80004746:	00001097          	auipc	ra,0x1
    8000474a:	682080e7          	jalr	1666(ra) # 80005dc8 <panic>
    dp->nlink++;  // for ".."
    8000474e:	04a95783          	lhu	a5,74(s2)
    80004752:	2785                	addiw	a5,a5,1
    80004754:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004758:	854a                	mv	a0,s2
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	4fa080e7          	jalr	1274(ra) # 80002c54 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004762:	40d0                	lw	a2,4(s1)
    80004764:	00004597          	auipc	a1,0x4
    80004768:	f5c58593          	addi	a1,a1,-164 # 800086c0 <syscalls+0x2b0>
    8000476c:	8526                	mv	a0,s1
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	ca4080e7          	jalr	-860(ra) # 80003412 <dirlink>
    80004776:	00054f63          	bltz	a0,80004794 <create+0x144>
    8000477a:	00492603          	lw	a2,4(s2)
    8000477e:	00004597          	auipc	a1,0x4
    80004782:	f4a58593          	addi	a1,a1,-182 # 800086c8 <syscalls+0x2b8>
    80004786:	8526                	mv	a0,s1
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	c8a080e7          	jalr	-886(ra) # 80003412 <dirlink>
    80004790:	f80557e3          	bgez	a0,8000471e <create+0xce>
      panic("create dots");
    80004794:	00004517          	auipc	a0,0x4
    80004798:	f3c50513          	addi	a0,a0,-196 # 800086d0 <syscalls+0x2c0>
    8000479c:	00001097          	auipc	ra,0x1
    800047a0:	62c080e7          	jalr	1580(ra) # 80005dc8 <panic>
    panic("create: dirlink");
    800047a4:	00004517          	auipc	a0,0x4
    800047a8:	f3c50513          	addi	a0,a0,-196 # 800086e0 <syscalls+0x2d0>
    800047ac:	00001097          	auipc	ra,0x1
    800047b0:	61c080e7          	jalr	1564(ra) # 80005dc8 <panic>
    return 0;
    800047b4:	84aa                	mv	s1,a0
    800047b6:	b731                	j	800046c2 <create+0x72>

00000000800047b8 <sys_dup>:
{
    800047b8:	7179                	addi	sp,sp,-48
    800047ba:	f406                	sd	ra,40(sp)
    800047bc:	f022                	sd	s0,32(sp)
    800047be:	ec26                	sd	s1,24(sp)
    800047c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047c2:	fd840613          	addi	a2,s0,-40
    800047c6:	4581                	li	a1,0
    800047c8:	4501                	li	a0,0
    800047ca:	00000097          	auipc	ra,0x0
    800047ce:	ddc080e7          	jalr	-548(ra) # 800045a6 <argfd>
    return -1;
    800047d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047d4:	02054363          	bltz	a0,800047fa <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047d8:	fd843503          	ld	a0,-40(s0)
    800047dc:	00000097          	auipc	ra,0x0
    800047e0:	e32080e7          	jalr	-462(ra) # 8000460e <fdalloc>
    800047e4:	84aa                	mv	s1,a0
    return -1;
    800047e6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047e8:	00054963          	bltz	a0,800047fa <sys_dup+0x42>
  filedup(f);
    800047ec:	fd843503          	ld	a0,-40(s0)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	37a080e7          	jalr	890(ra) # 80003b6a <filedup>
  return fd;
    800047f8:	87a6                	mv	a5,s1
}
    800047fa:	853e                	mv	a0,a5
    800047fc:	70a2                	ld	ra,40(sp)
    800047fe:	7402                	ld	s0,32(sp)
    80004800:	64e2                	ld	s1,24(sp)
    80004802:	6145                	addi	sp,sp,48
    80004804:	8082                	ret

0000000080004806 <sys_read>:
{
    80004806:	7179                	addi	sp,sp,-48
    80004808:	f406                	sd	ra,40(sp)
    8000480a:	f022                	sd	s0,32(sp)
    8000480c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480e:	fe840613          	addi	a2,s0,-24
    80004812:	4581                	li	a1,0
    80004814:	4501                	li	a0,0
    80004816:	00000097          	auipc	ra,0x0
    8000481a:	d90080e7          	jalr	-624(ra) # 800045a6 <argfd>
    return -1;
    8000481e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004820:	04054163          	bltz	a0,80004862 <sys_read+0x5c>
    80004824:	fe440593          	addi	a1,s0,-28
    80004828:	4509                	li	a0,2
    8000482a:	ffffe097          	auipc	ra,0xffffe
    8000482e:	982080e7          	jalr	-1662(ra) # 800021ac <argint>
    return -1;
    80004832:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004834:	02054763          	bltz	a0,80004862 <sys_read+0x5c>
    80004838:	fd840593          	addi	a1,s0,-40
    8000483c:	4505                	li	a0,1
    8000483e:	ffffe097          	auipc	ra,0xffffe
    80004842:	990080e7          	jalr	-1648(ra) # 800021ce <argaddr>
    return -1;
    80004846:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004848:	00054d63          	bltz	a0,80004862 <sys_read+0x5c>
  return fileread(f, p, n);
    8000484c:	fe442603          	lw	a2,-28(s0)
    80004850:	fd843583          	ld	a1,-40(s0)
    80004854:	fe843503          	ld	a0,-24(s0)
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	49e080e7          	jalr	1182(ra) # 80003cf6 <fileread>
    80004860:	87aa                	mv	a5,a0
}
    80004862:	853e                	mv	a0,a5
    80004864:	70a2                	ld	ra,40(sp)
    80004866:	7402                	ld	s0,32(sp)
    80004868:	6145                	addi	sp,sp,48
    8000486a:	8082                	ret

000000008000486c <sys_write>:
{
    8000486c:	7179                	addi	sp,sp,-48
    8000486e:	f406                	sd	ra,40(sp)
    80004870:	f022                	sd	s0,32(sp)
    80004872:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004874:	fe840613          	addi	a2,s0,-24
    80004878:	4581                	li	a1,0
    8000487a:	4501                	li	a0,0
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	d2a080e7          	jalr	-726(ra) # 800045a6 <argfd>
    return -1;
    80004884:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004886:	04054163          	bltz	a0,800048c8 <sys_write+0x5c>
    8000488a:	fe440593          	addi	a1,s0,-28
    8000488e:	4509                	li	a0,2
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	91c080e7          	jalr	-1764(ra) # 800021ac <argint>
    return -1;
    80004898:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000489a:	02054763          	bltz	a0,800048c8 <sys_write+0x5c>
    8000489e:	fd840593          	addi	a1,s0,-40
    800048a2:	4505                	li	a0,1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	92a080e7          	jalr	-1750(ra) # 800021ce <argaddr>
    return -1;
    800048ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ae:	00054d63          	bltz	a0,800048c8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048b2:	fe442603          	lw	a2,-28(s0)
    800048b6:	fd843583          	ld	a1,-40(s0)
    800048ba:	fe843503          	ld	a0,-24(s0)
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	4fa080e7          	jalr	1274(ra) # 80003db8 <filewrite>
    800048c6:	87aa                	mv	a5,a0
}
    800048c8:	853e                	mv	a0,a5
    800048ca:	70a2                	ld	ra,40(sp)
    800048cc:	7402                	ld	s0,32(sp)
    800048ce:	6145                	addi	sp,sp,48
    800048d0:	8082                	ret

00000000800048d2 <sys_close>:
{
    800048d2:	1101                	addi	sp,sp,-32
    800048d4:	ec06                	sd	ra,24(sp)
    800048d6:	e822                	sd	s0,16(sp)
    800048d8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048da:	fe040613          	addi	a2,s0,-32
    800048de:	fec40593          	addi	a1,s0,-20
    800048e2:	4501                	li	a0,0
    800048e4:	00000097          	auipc	ra,0x0
    800048e8:	cc2080e7          	jalr	-830(ra) # 800045a6 <argfd>
    return -1;
    800048ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048ee:	02054463          	bltz	a0,80004916 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048f2:	ffffc097          	auipc	ra,0xffffc
    800048f6:	6ec080e7          	jalr	1772(ra) # 80000fde <myproc>
    800048fa:	fec42783          	lw	a5,-20(s0)
    800048fe:	07e9                	addi	a5,a5,26
    80004900:	078e                	slli	a5,a5,0x3
    80004902:	97aa                	add	a5,a5,a0
    80004904:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004908:	fe043503          	ld	a0,-32(s0)
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	2b0080e7          	jalr	688(ra) # 80003bbc <fileclose>
  return 0;
    80004914:	4781                	li	a5,0
}
    80004916:	853e                	mv	a0,a5
    80004918:	60e2                	ld	ra,24(sp)
    8000491a:	6442                	ld	s0,16(sp)
    8000491c:	6105                	addi	sp,sp,32
    8000491e:	8082                	ret

0000000080004920 <sys_fstat>:
{
    80004920:	1101                	addi	sp,sp,-32
    80004922:	ec06                	sd	ra,24(sp)
    80004924:	e822                	sd	s0,16(sp)
    80004926:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004928:	fe840613          	addi	a2,s0,-24
    8000492c:	4581                	li	a1,0
    8000492e:	4501                	li	a0,0
    80004930:	00000097          	auipc	ra,0x0
    80004934:	c76080e7          	jalr	-906(ra) # 800045a6 <argfd>
    return -1;
    80004938:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000493a:	02054563          	bltz	a0,80004964 <sys_fstat+0x44>
    8000493e:	fe040593          	addi	a1,s0,-32
    80004942:	4505                	li	a0,1
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	88a080e7          	jalr	-1910(ra) # 800021ce <argaddr>
    return -1;
    8000494c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000494e:	00054b63          	bltz	a0,80004964 <sys_fstat+0x44>
  return filestat(f, st);
    80004952:	fe043583          	ld	a1,-32(s0)
    80004956:	fe843503          	ld	a0,-24(s0)
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	32a080e7          	jalr	810(ra) # 80003c84 <filestat>
    80004962:	87aa                	mv	a5,a0
}
    80004964:	853e                	mv	a0,a5
    80004966:	60e2                	ld	ra,24(sp)
    80004968:	6442                	ld	s0,16(sp)
    8000496a:	6105                	addi	sp,sp,32
    8000496c:	8082                	ret

000000008000496e <sys_link>:
{
    8000496e:	7169                	addi	sp,sp,-304
    80004970:	f606                	sd	ra,296(sp)
    80004972:	f222                	sd	s0,288(sp)
    80004974:	ee26                	sd	s1,280(sp)
    80004976:	ea4a                	sd	s2,272(sp)
    80004978:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000497a:	08000613          	li	a2,128
    8000497e:	ed040593          	addi	a1,s0,-304
    80004982:	4501                	li	a0,0
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	86c080e7          	jalr	-1940(ra) # 800021f0 <argstr>
    return -1;
    8000498c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000498e:	10054e63          	bltz	a0,80004aaa <sys_link+0x13c>
    80004992:	08000613          	li	a2,128
    80004996:	f5040593          	addi	a1,s0,-176
    8000499a:	4505                	li	a0,1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	854080e7          	jalr	-1964(ra) # 800021f0 <argstr>
    return -1;
    800049a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049a6:	10054263          	bltz	a0,80004aaa <sys_link+0x13c>
  begin_op();
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	d46080e7          	jalr	-698(ra) # 800036f0 <begin_op>
  if((ip = namei(old)) == 0){
    800049b2:	ed040513          	addi	a0,s0,-304
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	b1e080e7          	jalr	-1250(ra) # 800034d4 <namei>
    800049be:	84aa                	mv	s1,a0
    800049c0:	c551                	beqz	a0,80004a4c <sys_link+0xde>
  ilock(ip);
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	35c080e7          	jalr	860(ra) # 80002d1e <ilock>
  if(ip->type == T_DIR){
    800049ca:	04449703          	lh	a4,68(s1)
    800049ce:	4785                	li	a5,1
    800049d0:	08f70463          	beq	a4,a5,80004a58 <sys_link+0xea>
  ip->nlink++;
    800049d4:	04a4d783          	lhu	a5,74(s1)
    800049d8:	2785                	addiw	a5,a5,1
    800049da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	274080e7          	jalr	628(ra) # 80002c54 <iupdate>
  iunlock(ip);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	3f6080e7          	jalr	1014(ra) # 80002de0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049f2:	fd040593          	addi	a1,s0,-48
    800049f6:	f5040513          	addi	a0,s0,-176
    800049fa:	fffff097          	auipc	ra,0xfffff
    800049fe:	af8080e7          	jalr	-1288(ra) # 800034f2 <nameiparent>
    80004a02:	892a                	mv	s2,a0
    80004a04:	c935                	beqz	a0,80004a78 <sys_link+0x10a>
  ilock(dp);
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	318080e7          	jalr	792(ra) # 80002d1e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a0e:	00092703          	lw	a4,0(s2)
    80004a12:	409c                	lw	a5,0(s1)
    80004a14:	04f71d63          	bne	a4,a5,80004a6e <sys_link+0x100>
    80004a18:	40d0                	lw	a2,4(s1)
    80004a1a:	fd040593          	addi	a1,s0,-48
    80004a1e:	854a                	mv	a0,s2
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	9f2080e7          	jalr	-1550(ra) # 80003412 <dirlink>
    80004a28:	04054363          	bltz	a0,80004a6e <sys_link+0x100>
  iunlockput(dp);
    80004a2c:	854a                	mv	a0,s2
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	552080e7          	jalr	1362(ra) # 80002f80 <iunlockput>
  iput(ip);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	4a0080e7          	jalr	1184(ra) # 80002ed8 <iput>
  end_op();
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	d30080e7          	jalr	-720(ra) # 80003770 <end_op>
  return 0;
    80004a48:	4781                	li	a5,0
    80004a4a:	a085                	j	80004aaa <sys_link+0x13c>
    end_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	d24080e7          	jalr	-732(ra) # 80003770 <end_op>
    return -1;
    80004a54:	57fd                	li	a5,-1
    80004a56:	a891                	j	80004aaa <sys_link+0x13c>
    iunlockput(ip);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	526080e7          	jalr	1318(ra) # 80002f80 <iunlockput>
    end_op();
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	d0e080e7          	jalr	-754(ra) # 80003770 <end_op>
    return -1;
    80004a6a:	57fd                	li	a5,-1
    80004a6c:	a83d                	j	80004aaa <sys_link+0x13c>
    iunlockput(dp);
    80004a6e:	854a                	mv	a0,s2
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	510080e7          	jalr	1296(ra) # 80002f80 <iunlockput>
  ilock(ip);
    80004a78:	8526                	mv	a0,s1
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	2a4080e7          	jalr	676(ra) # 80002d1e <ilock>
  ip->nlink--;
    80004a82:	04a4d783          	lhu	a5,74(s1)
    80004a86:	37fd                	addiw	a5,a5,-1
    80004a88:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	1c6080e7          	jalr	454(ra) # 80002c54 <iupdate>
  iunlockput(ip);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	4e8080e7          	jalr	1256(ra) # 80002f80 <iunlockput>
  end_op();
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	cd0080e7          	jalr	-816(ra) # 80003770 <end_op>
  return -1;
    80004aa8:	57fd                	li	a5,-1
}
    80004aaa:	853e                	mv	a0,a5
    80004aac:	70b2                	ld	ra,296(sp)
    80004aae:	7412                	ld	s0,288(sp)
    80004ab0:	64f2                	ld	s1,280(sp)
    80004ab2:	6952                	ld	s2,272(sp)
    80004ab4:	6155                	addi	sp,sp,304
    80004ab6:	8082                	ret

0000000080004ab8 <sys_unlink>:
{
    80004ab8:	7151                	addi	sp,sp,-240
    80004aba:	f586                	sd	ra,232(sp)
    80004abc:	f1a2                	sd	s0,224(sp)
    80004abe:	eda6                	sd	s1,216(sp)
    80004ac0:	e9ca                	sd	s2,208(sp)
    80004ac2:	e5ce                	sd	s3,200(sp)
    80004ac4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ac6:	08000613          	li	a2,128
    80004aca:	f3040593          	addi	a1,s0,-208
    80004ace:	4501                	li	a0,0
    80004ad0:	ffffd097          	auipc	ra,0xffffd
    80004ad4:	720080e7          	jalr	1824(ra) # 800021f0 <argstr>
    80004ad8:	18054163          	bltz	a0,80004c5a <sys_unlink+0x1a2>
  begin_op();
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	c14080e7          	jalr	-1004(ra) # 800036f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ae4:	fb040593          	addi	a1,s0,-80
    80004ae8:	f3040513          	addi	a0,s0,-208
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	a06080e7          	jalr	-1530(ra) # 800034f2 <nameiparent>
    80004af4:	84aa                	mv	s1,a0
    80004af6:	c979                	beqz	a0,80004bcc <sys_unlink+0x114>
  ilock(dp);
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	226080e7          	jalr	550(ra) # 80002d1e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b00:	00004597          	auipc	a1,0x4
    80004b04:	bc058593          	addi	a1,a1,-1088 # 800086c0 <syscalls+0x2b0>
    80004b08:	fb040513          	addi	a0,s0,-80
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	6dc080e7          	jalr	1756(ra) # 800031e8 <namecmp>
    80004b14:	14050a63          	beqz	a0,80004c68 <sys_unlink+0x1b0>
    80004b18:	00004597          	auipc	a1,0x4
    80004b1c:	bb058593          	addi	a1,a1,-1104 # 800086c8 <syscalls+0x2b8>
    80004b20:	fb040513          	addi	a0,s0,-80
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	6c4080e7          	jalr	1732(ra) # 800031e8 <namecmp>
    80004b2c:	12050e63          	beqz	a0,80004c68 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b30:	f2c40613          	addi	a2,s0,-212
    80004b34:	fb040593          	addi	a1,s0,-80
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	6c8080e7          	jalr	1736(ra) # 80003202 <dirlookup>
    80004b42:	892a                	mv	s2,a0
    80004b44:	12050263          	beqz	a0,80004c68 <sys_unlink+0x1b0>
  ilock(ip);
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	1d6080e7          	jalr	470(ra) # 80002d1e <ilock>
  if(ip->nlink < 1)
    80004b50:	04a91783          	lh	a5,74(s2)
    80004b54:	08f05263          	blez	a5,80004bd8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b58:	04491703          	lh	a4,68(s2)
    80004b5c:	4785                	li	a5,1
    80004b5e:	08f70563          	beq	a4,a5,80004be8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b62:	4641                	li	a2,16
    80004b64:	4581                	li	a1,0
    80004b66:	fc040513          	addi	a0,s0,-64
    80004b6a:	ffffb097          	auipc	ra,0xffffb
    80004b6e:	676080e7          	jalr	1654(ra) # 800001e0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b72:	4741                	li	a4,16
    80004b74:	f2c42683          	lw	a3,-212(s0)
    80004b78:	fc040613          	addi	a2,s0,-64
    80004b7c:	4581                	li	a1,0
    80004b7e:	8526                	mv	a0,s1
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	54a080e7          	jalr	1354(ra) # 800030ca <writei>
    80004b88:	47c1                	li	a5,16
    80004b8a:	0af51563          	bne	a0,a5,80004c34 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b8e:	04491703          	lh	a4,68(s2)
    80004b92:	4785                	li	a5,1
    80004b94:	0af70863          	beq	a4,a5,80004c44 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	3e6080e7          	jalr	998(ra) # 80002f80 <iunlockput>
  ip->nlink--;
    80004ba2:	04a95783          	lhu	a5,74(s2)
    80004ba6:	37fd                	addiw	a5,a5,-1
    80004ba8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	0a6080e7          	jalr	166(ra) # 80002c54 <iupdate>
  iunlockput(ip);
    80004bb6:	854a                	mv	a0,s2
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	3c8080e7          	jalr	968(ra) # 80002f80 <iunlockput>
  end_op();
    80004bc0:	fffff097          	auipc	ra,0xfffff
    80004bc4:	bb0080e7          	jalr	-1104(ra) # 80003770 <end_op>
  return 0;
    80004bc8:	4501                	li	a0,0
    80004bca:	a84d                	j	80004c7c <sys_unlink+0x1c4>
    end_op();
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	ba4080e7          	jalr	-1116(ra) # 80003770 <end_op>
    return -1;
    80004bd4:	557d                	li	a0,-1
    80004bd6:	a05d                	j	80004c7c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bd8:	00004517          	auipc	a0,0x4
    80004bdc:	b1850513          	addi	a0,a0,-1256 # 800086f0 <syscalls+0x2e0>
    80004be0:	00001097          	auipc	ra,0x1
    80004be4:	1e8080e7          	jalr	488(ra) # 80005dc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004be8:	04c92703          	lw	a4,76(s2)
    80004bec:	02000793          	li	a5,32
    80004bf0:	f6e7f9e3          	bgeu	a5,a4,80004b62 <sys_unlink+0xaa>
    80004bf4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bf8:	4741                	li	a4,16
    80004bfa:	86ce                	mv	a3,s3
    80004bfc:	f1840613          	addi	a2,s0,-232
    80004c00:	4581                	li	a1,0
    80004c02:	854a                	mv	a0,s2
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	3ce080e7          	jalr	974(ra) # 80002fd2 <readi>
    80004c0c:	47c1                	li	a5,16
    80004c0e:	00f51b63          	bne	a0,a5,80004c24 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c12:	f1845783          	lhu	a5,-232(s0)
    80004c16:	e7a1                	bnez	a5,80004c5e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c18:	29c1                	addiw	s3,s3,16
    80004c1a:	04c92783          	lw	a5,76(s2)
    80004c1e:	fcf9ede3          	bltu	s3,a5,80004bf8 <sys_unlink+0x140>
    80004c22:	b781                	j	80004b62 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c24:	00004517          	auipc	a0,0x4
    80004c28:	ae450513          	addi	a0,a0,-1308 # 80008708 <syscalls+0x2f8>
    80004c2c:	00001097          	auipc	ra,0x1
    80004c30:	19c080e7          	jalr	412(ra) # 80005dc8 <panic>
    panic("unlink: writei");
    80004c34:	00004517          	auipc	a0,0x4
    80004c38:	aec50513          	addi	a0,a0,-1300 # 80008720 <syscalls+0x310>
    80004c3c:	00001097          	auipc	ra,0x1
    80004c40:	18c080e7          	jalr	396(ra) # 80005dc8 <panic>
    dp->nlink--;
    80004c44:	04a4d783          	lhu	a5,74(s1)
    80004c48:	37fd                	addiw	a5,a5,-1
    80004c4a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	004080e7          	jalr	4(ra) # 80002c54 <iupdate>
    80004c58:	b781                	j	80004b98 <sys_unlink+0xe0>
    return -1;
    80004c5a:	557d                	li	a0,-1
    80004c5c:	a005                	j	80004c7c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c5e:	854a                	mv	a0,s2
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	320080e7          	jalr	800(ra) # 80002f80 <iunlockput>
  iunlockput(dp);
    80004c68:	8526                	mv	a0,s1
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	316080e7          	jalr	790(ra) # 80002f80 <iunlockput>
  end_op();
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	afe080e7          	jalr	-1282(ra) # 80003770 <end_op>
  return -1;
    80004c7a:	557d                	li	a0,-1
}
    80004c7c:	70ae                	ld	ra,232(sp)
    80004c7e:	740e                	ld	s0,224(sp)
    80004c80:	64ee                	ld	s1,216(sp)
    80004c82:	694e                	ld	s2,208(sp)
    80004c84:	69ae                	ld	s3,200(sp)
    80004c86:	616d                	addi	sp,sp,240
    80004c88:	8082                	ret

0000000080004c8a <sys_open>:

uint64
sys_open(void)
{
    80004c8a:	7131                	addi	sp,sp,-192
    80004c8c:	fd06                	sd	ra,184(sp)
    80004c8e:	f922                	sd	s0,176(sp)
    80004c90:	f526                	sd	s1,168(sp)
    80004c92:	f14a                	sd	s2,160(sp)
    80004c94:	ed4e                	sd	s3,152(sp)
    80004c96:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c98:	08000613          	li	a2,128
    80004c9c:	f5040593          	addi	a1,s0,-176
    80004ca0:	4501                	li	a0,0
    80004ca2:	ffffd097          	auipc	ra,0xffffd
    80004ca6:	54e080e7          	jalr	1358(ra) # 800021f0 <argstr>
    return -1;
    80004caa:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cac:	0c054163          	bltz	a0,80004d6e <sys_open+0xe4>
    80004cb0:	f4c40593          	addi	a1,s0,-180
    80004cb4:	4505                	li	a0,1
    80004cb6:	ffffd097          	auipc	ra,0xffffd
    80004cba:	4f6080e7          	jalr	1270(ra) # 800021ac <argint>
    80004cbe:	0a054863          	bltz	a0,80004d6e <sys_open+0xe4>

  begin_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	a2e080e7          	jalr	-1490(ra) # 800036f0 <begin_op>

  if(omode & O_CREATE){
    80004cca:	f4c42783          	lw	a5,-180(s0)
    80004cce:	2007f793          	andi	a5,a5,512
    80004cd2:	cbdd                	beqz	a5,80004d88 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cd4:	4681                	li	a3,0
    80004cd6:	4601                	li	a2,0
    80004cd8:	4589                	li	a1,2
    80004cda:	f5040513          	addi	a0,s0,-176
    80004cde:	00000097          	auipc	ra,0x0
    80004ce2:	972080e7          	jalr	-1678(ra) # 80004650 <create>
    80004ce6:	892a                	mv	s2,a0
    if(ip == 0){
    80004ce8:	c959                	beqz	a0,80004d7e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cea:	04491703          	lh	a4,68(s2)
    80004cee:	478d                	li	a5,3
    80004cf0:	00f71763          	bne	a4,a5,80004cfe <sys_open+0x74>
    80004cf4:	04695703          	lhu	a4,70(s2)
    80004cf8:	47a5                	li	a5,9
    80004cfa:	0ce7ec63          	bltu	a5,a4,80004dd2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	e02080e7          	jalr	-510(ra) # 80003b00 <filealloc>
    80004d06:	89aa                	mv	s3,a0
    80004d08:	10050263          	beqz	a0,80004e0c <sys_open+0x182>
    80004d0c:	00000097          	auipc	ra,0x0
    80004d10:	902080e7          	jalr	-1790(ra) # 8000460e <fdalloc>
    80004d14:	84aa                	mv	s1,a0
    80004d16:	0e054663          	bltz	a0,80004e02 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d1a:	04491703          	lh	a4,68(s2)
    80004d1e:	478d                	li	a5,3
    80004d20:	0cf70463          	beq	a4,a5,80004de8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d24:	4789                	li	a5,2
    80004d26:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d2a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d2e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d32:	f4c42783          	lw	a5,-180(s0)
    80004d36:	0017c713          	xori	a4,a5,1
    80004d3a:	8b05                	andi	a4,a4,1
    80004d3c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d40:	0037f713          	andi	a4,a5,3
    80004d44:	00e03733          	snez	a4,a4
    80004d48:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d4c:	4007f793          	andi	a5,a5,1024
    80004d50:	c791                	beqz	a5,80004d5c <sys_open+0xd2>
    80004d52:	04491703          	lh	a4,68(s2)
    80004d56:	4789                	li	a5,2
    80004d58:	08f70f63          	beq	a4,a5,80004df6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d5c:	854a                	mv	a0,s2
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	082080e7          	jalr	130(ra) # 80002de0 <iunlock>
  end_op();
    80004d66:	fffff097          	auipc	ra,0xfffff
    80004d6a:	a0a080e7          	jalr	-1526(ra) # 80003770 <end_op>

  return fd;
}
    80004d6e:	8526                	mv	a0,s1
    80004d70:	70ea                	ld	ra,184(sp)
    80004d72:	744a                	ld	s0,176(sp)
    80004d74:	74aa                	ld	s1,168(sp)
    80004d76:	790a                	ld	s2,160(sp)
    80004d78:	69ea                	ld	s3,152(sp)
    80004d7a:	6129                	addi	sp,sp,192
    80004d7c:	8082                	ret
      end_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	9f2080e7          	jalr	-1550(ra) # 80003770 <end_op>
      return -1;
    80004d86:	b7e5                	j	80004d6e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d88:	f5040513          	addi	a0,s0,-176
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	748080e7          	jalr	1864(ra) # 800034d4 <namei>
    80004d94:	892a                	mv	s2,a0
    80004d96:	c905                	beqz	a0,80004dc6 <sys_open+0x13c>
    ilock(ip);
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	f86080e7          	jalr	-122(ra) # 80002d1e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004da0:	04491703          	lh	a4,68(s2)
    80004da4:	4785                	li	a5,1
    80004da6:	f4f712e3          	bne	a4,a5,80004cea <sys_open+0x60>
    80004daa:	f4c42783          	lw	a5,-180(s0)
    80004dae:	dba1                	beqz	a5,80004cfe <sys_open+0x74>
      iunlockput(ip);
    80004db0:	854a                	mv	a0,s2
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	1ce080e7          	jalr	462(ra) # 80002f80 <iunlockput>
      end_op();
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	9b6080e7          	jalr	-1610(ra) # 80003770 <end_op>
      return -1;
    80004dc2:	54fd                	li	s1,-1
    80004dc4:	b76d                	j	80004d6e <sys_open+0xe4>
      end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	9aa080e7          	jalr	-1622(ra) # 80003770 <end_op>
      return -1;
    80004dce:	54fd                	li	s1,-1
    80004dd0:	bf79                	j	80004d6e <sys_open+0xe4>
    iunlockput(ip);
    80004dd2:	854a                	mv	a0,s2
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	1ac080e7          	jalr	428(ra) # 80002f80 <iunlockput>
    end_op();
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	994080e7          	jalr	-1644(ra) # 80003770 <end_op>
    return -1;
    80004de4:	54fd                	li	s1,-1
    80004de6:	b761                	j	80004d6e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004de8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dec:	04691783          	lh	a5,70(s2)
    80004df0:	02f99223          	sh	a5,36(s3)
    80004df4:	bf2d                	j	80004d2e <sys_open+0xa4>
    itrunc(ip);
    80004df6:	854a                	mv	a0,s2
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	034080e7          	jalr	52(ra) # 80002e2c <itrunc>
    80004e00:	bfb1                	j	80004d5c <sys_open+0xd2>
      fileclose(f);
    80004e02:	854e                	mv	a0,s3
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	db8080e7          	jalr	-584(ra) # 80003bbc <fileclose>
    iunlockput(ip);
    80004e0c:	854a                	mv	a0,s2
    80004e0e:	ffffe097          	auipc	ra,0xffffe
    80004e12:	172080e7          	jalr	370(ra) # 80002f80 <iunlockput>
    end_op();
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	95a080e7          	jalr	-1702(ra) # 80003770 <end_op>
    return -1;
    80004e1e:	54fd                	li	s1,-1
    80004e20:	b7b9                	j	80004d6e <sys_open+0xe4>

0000000080004e22 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e22:	7175                	addi	sp,sp,-144
    80004e24:	e506                	sd	ra,136(sp)
    80004e26:	e122                	sd	s0,128(sp)
    80004e28:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	8c6080e7          	jalr	-1850(ra) # 800036f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e32:	08000613          	li	a2,128
    80004e36:	f7040593          	addi	a1,s0,-144
    80004e3a:	4501                	li	a0,0
    80004e3c:	ffffd097          	auipc	ra,0xffffd
    80004e40:	3b4080e7          	jalr	948(ra) # 800021f0 <argstr>
    80004e44:	02054963          	bltz	a0,80004e76 <sys_mkdir+0x54>
    80004e48:	4681                	li	a3,0
    80004e4a:	4601                	li	a2,0
    80004e4c:	4585                	li	a1,1
    80004e4e:	f7040513          	addi	a0,s0,-144
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	7fe080e7          	jalr	2046(ra) # 80004650 <create>
    80004e5a:	cd11                	beqz	a0,80004e76 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	124080e7          	jalr	292(ra) # 80002f80 <iunlockput>
  end_op();
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	90c080e7          	jalr	-1780(ra) # 80003770 <end_op>
  return 0;
    80004e6c:	4501                	li	a0,0
}
    80004e6e:	60aa                	ld	ra,136(sp)
    80004e70:	640a                	ld	s0,128(sp)
    80004e72:	6149                	addi	sp,sp,144
    80004e74:	8082                	ret
    end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	8fa080e7          	jalr	-1798(ra) # 80003770 <end_op>
    return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	b7fd                	j	80004e6e <sys_mkdir+0x4c>

0000000080004e82 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e82:	7135                	addi	sp,sp,-160
    80004e84:	ed06                	sd	ra,152(sp)
    80004e86:	e922                	sd	s0,144(sp)
    80004e88:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	866080e7          	jalr	-1946(ra) # 800036f0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e92:	08000613          	li	a2,128
    80004e96:	f7040593          	addi	a1,s0,-144
    80004e9a:	4501                	li	a0,0
    80004e9c:	ffffd097          	auipc	ra,0xffffd
    80004ea0:	354080e7          	jalr	852(ra) # 800021f0 <argstr>
    80004ea4:	04054a63          	bltz	a0,80004ef8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ea8:	f6c40593          	addi	a1,s0,-148
    80004eac:	4505                	li	a0,1
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	2fe080e7          	jalr	766(ra) # 800021ac <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eb6:	04054163          	bltz	a0,80004ef8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eba:	f6840593          	addi	a1,s0,-152
    80004ebe:	4509                	li	a0,2
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	2ec080e7          	jalr	748(ra) # 800021ac <argint>
     argint(1, &major) < 0 ||
    80004ec8:	02054863          	bltz	a0,80004ef8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ecc:	f6841683          	lh	a3,-152(s0)
    80004ed0:	f6c41603          	lh	a2,-148(s0)
    80004ed4:	458d                	li	a1,3
    80004ed6:	f7040513          	addi	a0,s0,-144
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	776080e7          	jalr	1910(ra) # 80004650 <create>
     argint(2, &minor) < 0 ||
    80004ee2:	c919                	beqz	a0,80004ef8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	09c080e7          	jalr	156(ra) # 80002f80 <iunlockput>
  end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	884080e7          	jalr	-1916(ra) # 80003770 <end_op>
  return 0;
    80004ef4:	4501                	li	a0,0
    80004ef6:	a031                	j	80004f02 <sys_mknod+0x80>
    end_op();
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	878080e7          	jalr	-1928(ra) # 80003770 <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
}
    80004f02:	60ea                	ld	ra,152(sp)
    80004f04:	644a                	ld	s0,144(sp)
    80004f06:	610d                	addi	sp,sp,160
    80004f08:	8082                	ret

0000000080004f0a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f0a:	7135                	addi	sp,sp,-160
    80004f0c:	ed06                	sd	ra,152(sp)
    80004f0e:	e922                	sd	s0,144(sp)
    80004f10:	e526                	sd	s1,136(sp)
    80004f12:	e14a                	sd	s2,128(sp)
    80004f14:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f16:	ffffc097          	auipc	ra,0xffffc
    80004f1a:	0c8080e7          	jalr	200(ra) # 80000fde <myproc>
    80004f1e:	892a                	mv	s2,a0
  
  begin_op();
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	7d0080e7          	jalr	2000(ra) # 800036f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f28:	08000613          	li	a2,128
    80004f2c:	f6040593          	addi	a1,s0,-160
    80004f30:	4501                	li	a0,0
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	2be080e7          	jalr	702(ra) # 800021f0 <argstr>
    80004f3a:	04054b63          	bltz	a0,80004f90 <sys_chdir+0x86>
    80004f3e:	f6040513          	addi	a0,s0,-160
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	592080e7          	jalr	1426(ra) # 800034d4 <namei>
    80004f4a:	84aa                	mv	s1,a0
    80004f4c:	c131                	beqz	a0,80004f90 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	dd0080e7          	jalr	-560(ra) # 80002d1e <ilock>
  if(ip->type != T_DIR){
    80004f56:	04449703          	lh	a4,68(s1)
    80004f5a:	4785                	li	a5,1
    80004f5c:	04f71063          	bne	a4,a5,80004f9c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f60:	8526                	mv	a0,s1
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	e7e080e7          	jalr	-386(ra) # 80002de0 <iunlock>
  iput(p->cwd);
    80004f6a:	15093503          	ld	a0,336(s2)
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	f6a080e7          	jalr	-150(ra) # 80002ed8 <iput>
  end_op();
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	7fa080e7          	jalr	2042(ra) # 80003770 <end_op>
  p->cwd = ip;
    80004f7e:	14993823          	sd	s1,336(s2)
  return 0;
    80004f82:	4501                	li	a0,0
}
    80004f84:	60ea                	ld	ra,152(sp)
    80004f86:	644a                	ld	s0,144(sp)
    80004f88:	64aa                	ld	s1,136(sp)
    80004f8a:	690a                	ld	s2,128(sp)
    80004f8c:	610d                	addi	sp,sp,160
    80004f8e:	8082                	ret
    end_op();
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	7e0080e7          	jalr	2016(ra) # 80003770 <end_op>
    return -1;
    80004f98:	557d                	li	a0,-1
    80004f9a:	b7ed                	j	80004f84 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f9c:	8526                	mv	a0,s1
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	fe2080e7          	jalr	-30(ra) # 80002f80 <iunlockput>
    end_op();
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	7ca080e7          	jalr	1994(ra) # 80003770 <end_op>
    return -1;
    80004fae:	557d                	li	a0,-1
    80004fb0:	bfd1                	j	80004f84 <sys_chdir+0x7a>

0000000080004fb2 <sys_exec>:

uint64
sys_exec(void)
{
    80004fb2:	7145                	addi	sp,sp,-464
    80004fb4:	e786                	sd	ra,456(sp)
    80004fb6:	e3a2                	sd	s0,448(sp)
    80004fb8:	ff26                	sd	s1,440(sp)
    80004fba:	fb4a                	sd	s2,432(sp)
    80004fbc:	f74e                	sd	s3,424(sp)
    80004fbe:	f352                	sd	s4,416(sp)
    80004fc0:	ef56                	sd	s5,408(sp)
    80004fc2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fc4:	08000613          	li	a2,128
    80004fc8:	f4040593          	addi	a1,s0,-192
    80004fcc:	4501                	li	a0,0
    80004fce:	ffffd097          	auipc	ra,0xffffd
    80004fd2:	222080e7          	jalr	546(ra) # 800021f0 <argstr>
    return -1;
    80004fd6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fd8:	0c054a63          	bltz	a0,800050ac <sys_exec+0xfa>
    80004fdc:	e3840593          	addi	a1,s0,-456
    80004fe0:	4505                	li	a0,1
    80004fe2:	ffffd097          	auipc	ra,0xffffd
    80004fe6:	1ec080e7          	jalr	492(ra) # 800021ce <argaddr>
    80004fea:	0c054163          	bltz	a0,800050ac <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fee:	10000613          	li	a2,256
    80004ff2:	4581                	li	a1,0
    80004ff4:	e4040513          	addi	a0,s0,-448
    80004ff8:	ffffb097          	auipc	ra,0xffffb
    80004ffc:	1e8080e7          	jalr	488(ra) # 800001e0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005000:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005004:	89a6                	mv	s3,s1
    80005006:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005008:	02000a13          	li	s4,32
    8000500c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005010:	00391513          	slli	a0,s2,0x3
    80005014:	e3040593          	addi	a1,s0,-464
    80005018:	e3843783          	ld	a5,-456(s0)
    8000501c:	953e                	add	a0,a0,a5
    8000501e:	ffffd097          	auipc	ra,0xffffd
    80005022:	0f4080e7          	jalr	244(ra) # 80002112 <fetchaddr>
    80005026:	02054a63          	bltz	a0,8000505a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000502a:	e3043783          	ld	a5,-464(s0)
    8000502e:	c3b9                	beqz	a5,80005074 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005030:	ffffb097          	auipc	ra,0xffffb
    80005034:	138080e7          	jalr	312(ra) # 80000168 <kalloc>
    80005038:	85aa                	mv	a1,a0
    8000503a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000503e:	cd11                	beqz	a0,8000505a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005040:	6605                	lui	a2,0x1
    80005042:	e3043503          	ld	a0,-464(s0)
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	11e080e7          	jalr	286(ra) # 80002164 <fetchstr>
    8000504e:	00054663          	bltz	a0,8000505a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005052:	0905                	addi	s2,s2,1
    80005054:	09a1                	addi	s3,s3,8
    80005056:	fb491be3          	bne	s2,s4,8000500c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505a:	10048913          	addi	s2,s1,256
    8000505e:	6088                	ld	a0,0(s1)
    80005060:	c529                	beqz	a0,800050aa <sys_exec+0xf8>
    kfree(argv[i]);
    80005062:	ffffb097          	auipc	ra,0xffffb
    80005066:	fba080e7          	jalr	-70(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506a:	04a1                	addi	s1,s1,8
    8000506c:	ff2499e3          	bne	s1,s2,8000505e <sys_exec+0xac>
  return -1;
    80005070:	597d                	li	s2,-1
    80005072:	a82d                	j	800050ac <sys_exec+0xfa>
      argv[i] = 0;
    80005074:	0a8e                	slli	s5,s5,0x3
    80005076:	fc040793          	addi	a5,s0,-64
    8000507a:	9abe                	add	s5,s5,a5
    8000507c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005080:	e4040593          	addi	a1,s0,-448
    80005084:	f4040513          	addi	a0,s0,-192
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	194080e7          	jalr	404(ra) # 8000421c <exec>
    80005090:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005092:	10048993          	addi	s3,s1,256
    80005096:	6088                	ld	a0,0(s1)
    80005098:	c911                	beqz	a0,800050ac <sys_exec+0xfa>
    kfree(argv[i]);
    8000509a:	ffffb097          	auipc	ra,0xffffb
    8000509e:	f82080e7          	jalr	-126(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a2:	04a1                	addi	s1,s1,8
    800050a4:	ff3499e3          	bne	s1,s3,80005096 <sys_exec+0xe4>
    800050a8:	a011                	j	800050ac <sys_exec+0xfa>
  return -1;
    800050aa:	597d                	li	s2,-1
}
    800050ac:	854a                	mv	a0,s2
    800050ae:	60be                	ld	ra,456(sp)
    800050b0:	641e                	ld	s0,448(sp)
    800050b2:	74fa                	ld	s1,440(sp)
    800050b4:	795a                	ld	s2,432(sp)
    800050b6:	79ba                	ld	s3,424(sp)
    800050b8:	7a1a                	ld	s4,416(sp)
    800050ba:	6afa                	ld	s5,408(sp)
    800050bc:	6179                	addi	sp,sp,464
    800050be:	8082                	ret

00000000800050c0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050c0:	7139                	addi	sp,sp,-64
    800050c2:	fc06                	sd	ra,56(sp)
    800050c4:	f822                	sd	s0,48(sp)
    800050c6:	f426                	sd	s1,40(sp)
    800050c8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050ca:	ffffc097          	auipc	ra,0xffffc
    800050ce:	f14080e7          	jalr	-236(ra) # 80000fde <myproc>
    800050d2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050d4:	fd840593          	addi	a1,s0,-40
    800050d8:	4501                	li	a0,0
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	0f4080e7          	jalr	244(ra) # 800021ce <argaddr>
    return -1;
    800050e2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050e4:	0e054063          	bltz	a0,800051c4 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050e8:	fc840593          	addi	a1,s0,-56
    800050ec:	fd040513          	addi	a0,s0,-48
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	dfc080e7          	jalr	-516(ra) # 80003eec <pipealloc>
    return -1;
    800050f8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050fa:	0c054563          	bltz	a0,800051c4 <sys_pipe+0x104>
  fd0 = -1;
    800050fe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005102:	fd043503          	ld	a0,-48(s0)
    80005106:	fffff097          	auipc	ra,0xfffff
    8000510a:	508080e7          	jalr	1288(ra) # 8000460e <fdalloc>
    8000510e:	fca42223          	sw	a0,-60(s0)
    80005112:	08054c63          	bltz	a0,800051aa <sys_pipe+0xea>
    80005116:	fc843503          	ld	a0,-56(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	4f4080e7          	jalr	1268(ra) # 8000460e <fdalloc>
    80005122:	fca42023          	sw	a0,-64(s0)
    80005126:	06054863          	bltz	a0,80005196 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000512a:	4691                	li	a3,4
    8000512c:	fc440613          	addi	a2,s0,-60
    80005130:	fd843583          	ld	a1,-40(s0)
    80005134:	68a8                	ld	a0,80(s1)
    80005136:	ffffc097          	auipc	ra,0xffffc
    8000513a:	ac2080e7          	jalr	-1342(ra) # 80000bf8 <copyout>
    8000513e:	02054063          	bltz	a0,8000515e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005142:	4691                	li	a3,4
    80005144:	fc040613          	addi	a2,s0,-64
    80005148:	fd843583          	ld	a1,-40(s0)
    8000514c:	0591                	addi	a1,a1,4
    8000514e:	68a8                	ld	a0,80(s1)
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	aa8080e7          	jalr	-1368(ra) # 80000bf8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005158:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000515a:	06055563          	bgez	a0,800051c4 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000515e:	fc442783          	lw	a5,-60(s0)
    80005162:	07e9                	addi	a5,a5,26
    80005164:	078e                	slli	a5,a5,0x3
    80005166:	97a6                	add	a5,a5,s1
    80005168:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000516c:	fc042503          	lw	a0,-64(s0)
    80005170:	0569                	addi	a0,a0,26
    80005172:	050e                	slli	a0,a0,0x3
    80005174:	9526                	add	a0,a0,s1
    80005176:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000517a:	fd043503          	ld	a0,-48(s0)
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	a3e080e7          	jalr	-1474(ra) # 80003bbc <fileclose>
    fileclose(wf);
    80005186:	fc843503          	ld	a0,-56(s0)
    8000518a:	fffff097          	auipc	ra,0xfffff
    8000518e:	a32080e7          	jalr	-1486(ra) # 80003bbc <fileclose>
    return -1;
    80005192:	57fd                	li	a5,-1
    80005194:	a805                	j	800051c4 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005196:	fc442783          	lw	a5,-60(s0)
    8000519a:	0007c863          	bltz	a5,800051aa <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000519e:	01a78513          	addi	a0,a5,26
    800051a2:	050e                	slli	a0,a0,0x3
    800051a4:	9526                	add	a0,a0,s1
    800051a6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051aa:	fd043503          	ld	a0,-48(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	a0e080e7          	jalr	-1522(ra) # 80003bbc <fileclose>
    fileclose(wf);
    800051b6:	fc843503          	ld	a0,-56(s0)
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	a02080e7          	jalr	-1534(ra) # 80003bbc <fileclose>
    return -1;
    800051c2:	57fd                	li	a5,-1
}
    800051c4:	853e                	mv	a0,a5
    800051c6:	70e2                	ld	ra,56(sp)
    800051c8:	7442                	ld	s0,48(sp)
    800051ca:	74a2                	ld	s1,40(sp)
    800051cc:	6121                	addi	sp,sp,64
    800051ce:	8082                	ret

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	dcffc0ef          	jal	ra,80001fde <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	c3d8                	sw	a4,4(a5)
}
    8000529a:	6422                	ld	s0,8(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plicinithart>:

void
plicinithart(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	d0a080e7          	jalr	-758(ra) # 80000fb2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	slliw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	slliw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	953e                	add	a0,a0,a5
    800052cc:	00052023          	sw	zero,0(a0)
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	cd2080e7          	jalr	-814(ra) # 80000fb2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e8:	00d5179b          	slliw	a5,a0,0xd
    800052ec:	0c201537          	lui	a0,0xc201
    800052f0:	953e                	add	a0,a0,a5
  return irq;
}
    800052f2:	4148                	lw	a0,4(a0)
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052fc:	1101                	addi	sp,sp,-32
    800052fe:	ec06                	sd	ra,24(sp)
    80005300:	e822                	sd	s0,16(sp)
    80005302:	e426                	sd	s1,8(sp)
    80005304:	1000                	addi	s0,sp,32
    80005306:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	caa080e7          	jalr	-854(ra) # 80000fb2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005310:	00d5151b          	slliw	a0,a0,0xd
    80005314:	0c2017b7          	lui	a5,0xc201
    80005318:	97aa                	add	a5,a5,a0
    8000531a:	c3c4                	sw	s1,4(a5)
}
    8000531c:	60e2                	ld	ra,24(sp)
    8000531e:	6442                	ld	s0,16(sp)
    80005320:	64a2                	ld	s1,8(sp)
    80005322:	6105                	addi	sp,sp,32
    80005324:	8082                	ret

0000000080005326 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005326:	1141                	addi	sp,sp,-16
    80005328:	e406                	sd	ra,8(sp)
    8000532a:	e022                	sd	s0,0(sp)
    8000532c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000532e:	479d                	li	a5,7
    80005330:	06a7c963          	blt	a5,a0,800053a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005334:	000a2797          	auipc	a5,0xa2
    80005338:	ccc78793          	addi	a5,a5,-820 # 800a7000 <disk>
    8000533c:	00a78733          	add	a4,a5,a0
    80005340:	6789                	lui	a5,0x2
    80005342:	97ba                	add	a5,a5,a4
    80005344:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005348:	e7ad                	bnez	a5,800053b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000534a:	00451793          	slli	a5,a0,0x4
    8000534e:	000a4717          	auipc	a4,0xa4
    80005352:	cb270713          	addi	a4,a4,-846 # 800a9000 <disk+0x2000>
    80005356:	6314                	ld	a3,0(a4)
    80005358:	96be                	add	a3,a3,a5
    8000535a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000535e:	6314                	ld	a3,0(a4)
    80005360:	96be                	add	a3,a3,a5
    80005362:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005366:	6314                	ld	a3,0(a4)
    80005368:	96be                	add	a3,a3,a5
    8000536a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000536e:	6318                	ld	a4,0(a4)
    80005370:	97ba                	add	a5,a5,a4
    80005372:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005376:	000a2797          	auipc	a5,0xa2
    8000537a:	c8a78793          	addi	a5,a5,-886 # 800a7000 <disk>
    8000537e:	97aa                	add	a5,a5,a0
    80005380:	6509                	lui	a0,0x2
    80005382:	953e                	add	a0,a0,a5
    80005384:	4785                	li	a5,1
    80005386:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000538a:	000a4517          	auipc	a0,0xa4
    8000538e:	c8e50513          	addi	a0,a0,-882 # 800a9018 <disk+0x2018>
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	4a2080e7          	jalr	1186(ra) # 80001834 <wakeup>
}
    8000539a:	60a2                	ld	ra,8(sp)
    8000539c:	6402                	ld	s0,0(sp)
    8000539e:	0141                	addi	sp,sp,16
    800053a0:	8082                	ret
    panic("free_desc 1");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	38e50513          	addi	a0,a0,910 # 80008730 <syscalls+0x320>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	a1e080e7          	jalr	-1506(ra) # 80005dc8 <panic>
    panic("free_desc 2");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	38e50513          	addi	a0,a0,910 # 80008740 <syscalls+0x330>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	a0e080e7          	jalr	-1522(ra) # 80005dc8 <panic>

00000000800053c2 <virtio_disk_init>:
{
    800053c2:	1101                	addi	sp,sp,-32
    800053c4:	ec06                	sd	ra,24(sp)
    800053c6:	e822                	sd	s0,16(sp)
    800053c8:	e426                	sd	s1,8(sp)
    800053ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053cc:	00003597          	auipc	a1,0x3
    800053d0:	38458593          	addi	a1,a1,900 # 80008750 <syscalls+0x340>
    800053d4:	000a4517          	auipc	a0,0xa4
    800053d8:	d5450513          	addi	a0,a0,-684 # 800a9128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	ea6080e7          	jalr	-346(ra) # 80006282 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	0ef71163          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	43dc                	lw	a5,4(a5)
    800053fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	4705                	li	a4,1
    80005402:	0ce79a63          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	479c                	lw	a5,8(a5)
    8000540c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000540e:	4709                	li	a4,2
    80005410:	0ce79363          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	47d8                	lw	a4,12(a5)
    8000541a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541c:	554d47b7          	lui	a5,0x554d4
    80005420:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005424:	0af71963          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	4705                	li	a4,1
    8000542e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005430:	470d                	li	a4,3
    80005432:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005434:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005436:	c7ffe737          	lui	a4,0xc7ffe
    8000543a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f4c51f>
    8000543e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005440:	2701                	sext.w	a4,a4
    80005442:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005444:	472d                	li	a4,11
    80005446:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005448:	473d                	li	a4,15
    8000544a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000544c:	6705                	lui	a4,0x1
    8000544e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005450:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005454:	5bdc                	lw	a5,52(a5)
    80005456:	2781                	sext.w	a5,a5
  if(max == 0)
    80005458:	c7d9                	beqz	a5,800054e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000545a:	471d                	li	a4,7
    8000545c:	08f77d63          	bgeu	a4,a5,800054f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005460:	100014b7          	lui	s1,0x10001
    80005464:	47a1                	li	a5,8
    80005466:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005468:	6609                	lui	a2,0x2
    8000546a:	4581                	li	a1,0
    8000546c:	000a2517          	auipc	a0,0xa2
    80005470:	b9450513          	addi	a0,a0,-1132 # 800a7000 <disk>
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d6c080e7          	jalr	-660(ra) # 800001e0 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000547c:	000a2717          	auipc	a4,0xa2
    80005480:	b8470713          	addi	a4,a4,-1148 # 800a7000 <disk>
    80005484:	00c75793          	srli	a5,a4,0xc
    80005488:	2781                	sext.w	a5,a5
    8000548a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000548c:	000a4797          	auipc	a5,0xa4
    80005490:	b7478793          	addi	a5,a5,-1164 # 800a9000 <disk+0x2000>
    80005494:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005496:	000a2717          	auipc	a4,0xa2
    8000549a:	bea70713          	addi	a4,a4,-1046 # 800a7080 <disk+0x80>
    8000549e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054a0:	000a3717          	auipc	a4,0xa3
    800054a4:	b6070713          	addi	a4,a4,-1184 # 800a8000 <disk+0x1000>
    800054a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054aa:	4705                	li	a4,1
    800054ac:	00e78c23          	sb	a4,24(a5)
    800054b0:	00e78ca3          	sb	a4,25(a5)
    800054b4:	00e78d23          	sb	a4,26(a5)
    800054b8:	00e78da3          	sb	a4,27(a5)
    800054bc:	00e78e23          	sb	a4,28(a5)
    800054c0:	00e78ea3          	sb	a4,29(a5)
    800054c4:	00e78f23          	sb	a4,30(a5)
    800054c8:	00e78fa3          	sb	a4,31(a5)
}
    800054cc:	60e2                	ld	ra,24(sp)
    800054ce:	6442                	ld	s0,16(sp)
    800054d0:	64a2                	ld	s1,8(sp)
    800054d2:	6105                	addi	sp,sp,32
    800054d4:	8082                	ret
    panic("could not find virtio disk");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	28a50513          	addi	a0,a0,650 # 80008760 <syscalls+0x350>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8ea080e7          	jalr	-1814(ra) # 80005dc8 <panic>
    panic("virtio disk has no queue 0");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	29a50513          	addi	a0,a0,666 # 80008780 <syscalls+0x370>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8da080e7          	jalr	-1830(ra) # 80005dc8 <panic>
    panic("virtio disk max queue too short");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	2aa50513          	addi	a0,a0,682 # 800087a0 <syscalls+0x390>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	8ca080e7          	jalr	-1846(ra) # 80005dc8 <panic>

0000000080005506 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005506:	7159                	addi	sp,sp,-112
    80005508:	f486                	sd	ra,104(sp)
    8000550a:	f0a2                	sd	s0,96(sp)
    8000550c:	eca6                	sd	s1,88(sp)
    8000550e:	e8ca                	sd	s2,80(sp)
    80005510:	e4ce                	sd	s3,72(sp)
    80005512:	e0d2                	sd	s4,64(sp)
    80005514:	fc56                	sd	s5,56(sp)
    80005516:	f85a                	sd	s6,48(sp)
    80005518:	f45e                	sd	s7,40(sp)
    8000551a:	f062                	sd	s8,32(sp)
    8000551c:	ec66                	sd	s9,24(sp)
    8000551e:	e86a                	sd	s10,16(sp)
    80005520:	1880                	addi	s0,sp,112
    80005522:	892a                	mv	s2,a0
    80005524:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005526:	00c52c83          	lw	s9,12(a0)
    8000552a:	001c9c9b          	slliw	s9,s9,0x1
    8000552e:	1c82                	slli	s9,s9,0x20
    80005530:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005534:	000a4517          	auipc	a0,0xa4
    80005538:	bf450513          	addi	a0,a0,-1036 # 800a9128 <disk+0x2128>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	dd6080e7          	jalr	-554(ra) # 80006312 <acquire>
  for(int i = 0; i < 3; i++){
    80005544:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005546:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005548:	000a2b97          	auipc	s7,0xa2
    8000554c:	ab8b8b93          	addi	s7,s7,-1352 # 800a7000 <disk>
    80005550:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005552:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005554:	8a4e                	mv	s4,s3
    80005556:	a051                	j	800055da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005558:	00fb86b3          	add	a3,s7,a5
    8000555c:	96da                	add	a3,a3,s6
    8000555e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005562:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005564:	0207c563          	bltz	a5,8000558e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005568:	2485                	addiw	s1,s1,1
    8000556a:	0711                	addi	a4,a4,4
    8000556c:	25548063          	beq	s1,s5,800057ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005570:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005572:	000a4697          	auipc	a3,0xa4
    80005576:	aa668693          	addi	a3,a3,-1370 # 800a9018 <disk+0x2018>
    8000557a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000557c:	0006c583          	lbu	a1,0(a3)
    80005580:	fde1                	bnez	a1,80005558 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005582:	2785                	addiw	a5,a5,1
    80005584:	0685                	addi	a3,a3,1
    80005586:	ff879be3          	bne	a5,s8,8000557c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000558a:	57fd                	li	a5,-1
    8000558c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000558e:	02905a63          	blez	s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005592:	f9042503          	lw	a0,-112(s0)
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	d90080e7          	jalr	-624(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    8000559e:	4785                	li	a5,1
    800055a0:	0297d163          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a4:	f9442503          	lw	a0,-108(s0)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	d7e080e7          	jalr	-642(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    800055b0:	4789                	li	a5,2
    800055b2:	0097d863          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055b6:	f9842503          	lw	a0,-104(s0)
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	d6c080e7          	jalr	-660(ra) # 80005326 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c2:	000a4597          	auipc	a1,0xa4
    800055c6:	b6658593          	addi	a1,a1,-1178 # 800a9128 <disk+0x2128>
    800055ca:	000a4517          	auipc	a0,0xa4
    800055ce:	a4e50513          	addi	a0,a0,-1458 # 800a9018 <disk+0x2018>
    800055d2:	ffffc097          	auipc	ra,0xffffc
    800055d6:	0d6080e7          	jalr	214(ra) # 800016a8 <sleep>
  for(int i = 0; i < 3; i++){
    800055da:	f9040713          	addi	a4,s0,-112
    800055de:	84ce                	mv	s1,s3
    800055e0:	bf41                	j	80005570 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055e2:	20058713          	addi	a4,a1,512
    800055e6:	00471693          	slli	a3,a4,0x4
    800055ea:	000a2717          	auipc	a4,0xa2
    800055ee:	a1670713          	addi	a4,a4,-1514 # 800a7000 <disk>
    800055f2:	9736                	add	a4,a4,a3
    800055f4:	4685                	li	a3,1
    800055f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055fa:	20058713          	addi	a4,a1,512
    800055fe:	00471693          	slli	a3,a4,0x4
    80005602:	000a2717          	auipc	a4,0xa2
    80005606:	9fe70713          	addi	a4,a4,-1538 # 800a7000 <disk>
    8000560a:	9736                	add	a4,a4,a3
    8000560c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005610:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005614:	7679                	lui	a2,0xffffe
    80005616:	963e                	add	a2,a2,a5
    80005618:	000a4697          	auipc	a3,0xa4
    8000561c:	9e868693          	addi	a3,a3,-1560 # 800a9000 <disk+0x2000>
    80005620:	6298                	ld	a4,0(a3)
    80005622:	9732                	add	a4,a4,a2
    80005624:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005626:	6298                	ld	a4,0(a3)
    80005628:	9732                	add	a4,a4,a2
    8000562a:	4541                	li	a0,16
    8000562c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	4505                	li	a0,1
    80005634:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442703          	lw	a4,-108(s0)
    8000563c:	6288                	ld	a0,0(a3)
    8000563e:	962a                	add	a2,a2,a0
    80005640:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff4bdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005644:	0712                	slli	a4,a4,0x4
    80005646:	6290                	ld	a2,0(a3)
    80005648:	963a                	add	a2,a2,a4
    8000564a:	05890513          	addi	a0,s2,88
    8000564e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005650:	6294                	ld	a3,0(a3)
    80005652:	96ba                	add	a3,a3,a4
    80005654:	40000613          	li	a2,1024
    80005658:	c690                	sw	a2,8(a3)
  if(write)
    8000565a:	140d0063          	beqz	s10,8000579a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000565e:	000a4697          	auipc	a3,0xa4
    80005662:	9a26b683          	ld	a3,-1630(a3) # 800a9000 <disk+0x2000>
    80005666:	96ba                	add	a3,a3,a4
    80005668:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000566c:	000a2817          	auipc	a6,0xa2
    80005670:	99480813          	addi	a6,a6,-1644 # 800a7000 <disk>
    80005674:	000a4517          	auipc	a0,0xa4
    80005678:	98c50513          	addi	a0,a0,-1652 # 800a9000 <disk+0x2000>
    8000567c:	6114                	ld	a3,0(a0)
    8000567e:	96ba                	add	a3,a3,a4
    80005680:	00c6d603          	lhu	a2,12(a3)
    80005684:	00166613          	ori	a2,a2,1
    80005688:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000568c:	f9842683          	lw	a3,-104(s0)
    80005690:	6110                	ld	a2,0(a0)
    80005692:	9732                	add	a4,a4,a2
    80005694:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005698:	20058613          	addi	a2,a1,512
    8000569c:	0612                	slli	a2,a2,0x4
    8000569e:	9642                	add	a2,a2,a6
    800056a0:	577d                	li	a4,-1
    800056a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056a6:	00469713          	slli	a4,a3,0x4
    800056aa:	6114                	ld	a3,0(a0)
    800056ac:	96ba                	add	a3,a3,a4
    800056ae:	03078793          	addi	a5,a5,48
    800056b2:	97c2                	add	a5,a5,a6
    800056b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056b6:	611c                	ld	a5,0(a0)
    800056b8:	97ba                	add	a5,a5,a4
    800056ba:	4685                	li	a3,1
    800056bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056be:	611c                	ld	a5,0(a0)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	4809                	li	a6,2
    800056c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056c8:	611c                	ld	a5,0(a0)
    800056ca:	973e                	add	a4,a4,a5
    800056cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056d8:	6518                	ld	a4,8(a0)
    800056da:	00275783          	lhu	a5,2(a4)
    800056de:	8b9d                	andi	a5,a5,7
    800056e0:	0786                	slli	a5,a5,0x1
    800056e2:	97ba                	add	a5,a5,a4
    800056e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ec:	6518                	ld	a4,8(a0)
    800056ee:	00275783          	lhu	a5,2(a4)
    800056f2:	2785                	addiw	a5,a5,1
    800056f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005704:	00492703          	lw	a4,4(s2)
    80005708:	4785                	li	a5,1
    8000570a:	02f71163          	bne	a4,a5,8000572c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000570e:	000a4997          	auipc	s3,0xa4
    80005712:	a1a98993          	addi	s3,s3,-1510 # 800a9128 <disk+0x2128>
  while(b->disk == 1) {
    80005716:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005718:	85ce                	mv	a1,s3
    8000571a:	854a                	mv	a0,s2
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	f8c080e7          	jalr	-116(ra) # 800016a8 <sleep>
  while(b->disk == 1) {
    80005724:	00492783          	lw	a5,4(s2)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	20090793          	addi	a5,s2,512
    80005734:	00479713          	slli	a4,a5,0x4
    80005738:	000a2797          	auipc	a5,0xa2
    8000573c:	8c878793          	addi	a5,a5,-1848 # 800a7000 <disk>
    80005740:	97ba                	add	a5,a5,a4
    80005742:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005746:	000a4997          	auipc	s3,0xa4
    8000574a:	8ba98993          	addi	s3,s3,-1862 # 800a9000 <disk+0x2000>
    8000574e:	00491713          	slli	a4,s2,0x4
    80005752:	0009b783          	ld	a5,0(s3)
    80005756:	97ba                	add	a5,a5,a4
    80005758:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575c:	854a                	mv	a0,s2
    8000575e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005762:	00000097          	auipc	ra,0x0
    80005766:	bc4080e7          	jalr	-1084(ra) # 80005326 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576a:	8885                	andi	s1,s1,1
    8000576c:	f0ed                	bnez	s1,8000574e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576e:	000a4517          	auipc	a0,0xa4
    80005772:	9ba50513          	addi	a0,a0,-1606 # 800a9128 <disk+0x2128>
    80005776:	00001097          	auipc	ra,0x1
    8000577a:	c50080e7          	jalr	-944(ra) # 800063c6 <release>
}
    8000577e:	70a6                	ld	ra,104(sp)
    80005780:	7406                	ld	s0,96(sp)
    80005782:	64e6                	ld	s1,88(sp)
    80005784:	6946                	ld	s2,80(sp)
    80005786:	69a6                	ld	s3,72(sp)
    80005788:	6a06                	ld	s4,64(sp)
    8000578a:	7ae2                	ld	s5,56(sp)
    8000578c:	7b42                	ld	s6,48(sp)
    8000578e:	7ba2                	ld	s7,40(sp)
    80005790:	7c02                	ld	s8,32(sp)
    80005792:	6ce2                	ld	s9,24(sp)
    80005794:	6d42                	ld	s10,16(sp)
    80005796:	6165                	addi	sp,sp,112
    80005798:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579a:	000a4697          	auipc	a3,0xa4
    8000579e:	8666b683          	ld	a3,-1946(a3) # 800a9000 <disk+0x2000>
    800057a2:	96ba                	add	a3,a3,a4
    800057a4:	4609                	li	a2,2
    800057a6:	00c69623          	sh	a2,12(a3)
    800057aa:	b5c9                	j	8000566c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ac:	f9042583          	lw	a1,-112(s0)
    800057b0:	20058793          	addi	a5,a1,512
    800057b4:	0792                	slli	a5,a5,0x4
    800057b6:	000a2517          	auipc	a0,0xa2
    800057ba:	8f250513          	addi	a0,a0,-1806 # 800a70a8 <disk+0xa8>
    800057be:	953e                	add	a0,a0,a5
  if(write)
    800057c0:	e20d11e3          	bnez	s10,800055e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057c4:	20058713          	addi	a4,a1,512
    800057c8:	00471693          	slli	a3,a4,0x4
    800057cc:	000a2717          	auipc	a4,0xa2
    800057d0:	83470713          	addi	a4,a4,-1996 # 800a7000 <disk>
    800057d4:	9736                	add	a4,a4,a3
    800057d6:	0a072423          	sw	zero,168(a4)
    800057da:	b505                	j	800055fa <virtio_disk_rw+0xf4>

00000000800057dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057dc:	1101                	addi	sp,sp,-32
    800057de:	ec06                	sd	ra,24(sp)
    800057e0:	e822                	sd	s0,16(sp)
    800057e2:	e426                	sd	s1,8(sp)
    800057e4:	e04a                	sd	s2,0(sp)
    800057e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e8:	000a4517          	auipc	a0,0xa4
    800057ec:	94050513          	addi	a0,a0,-1728 # 800a9128 <disk+0x2128>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	b22080e7          	jalr	-1246(ra) # 80006312 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f8:	10001737          	lui	a4,0x10001
    800057fc:	533c                	lw	a5,96(a4)
    800057fe:	8b8d                	andi	a5,a5,3
    80005800:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005802:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005806:	000a3797          	auipc	a5,0xa3
    8000580a:	7fa78793          	addi	a5,a5,2042 # 800a9000 <disk+0x2000>
    8000580e:	6b94                	ld	a3,16(a5)
    80005810:	0207d703          	lhu	a4,32(a5)
    80005814:	0026d783          	lhu	a5,2(a3)
    80005818:	06f70163          	beq	a4,a5,8000587a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000581c:	000a1917          	auipc	s2,0xa1
    80005820:	7e490913          	addi	s2,s2,2020 # 800a7000 <disk>
    80005824:	000a3497          	auipc	s1,0xa3
    80005828:	7dc48493          	addi	s1,s1,2012 # 800a9000 <disk+0x2000>
    __sync_synchronize();
    8000582c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005830:	6898                	ld	a4,16(s1)
    80005832:	0204d783          	lhu	a5,32(s1)
    80005836:	8b9d                	andi	a5,a5,7
    80005838:	078e                	slli	a5,a5,0x3
    8000583a:	97ba                	add	a5,a5,a4
    8000583c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583e:	20078713          	addi	a4,a5,512
    80005842:	0712                	slli	a4,a4,0x4
    80005844:	974a                	add	a4,a4,s2
    80005846:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000584a:	e731                	bnez	a4,80005896 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000584c:	20078793          	addi	a5,a5,512
    80005850:	0792                	slli	a5,a5,0x4
    80005852:	97ca                	add	a5,a5,s2
    80005854:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005856:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000585a:	ffffc097          	auipc	ra,0xffffc
    8000585e:	fda080e7          	jalr	-38(ra) # 80001834 <wakeup>

    disk.used_idx += 1;
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	2785                	addiw	a5,a5,1
    80005868:	17c2                	slli	a5,a5,0x30
    8000586a:	93c1                	srli	a5,a5,0x30
    8000586c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005870:	6898                	ld	a4,16(s1)
    80005872:	00275703          	lhu	a4,2(a4)
    80005876:	faf71be3          	bne	a4,a5,8000582c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000587a:	000a4517          	auipc	a0,0xa4
    8000587e:	8ae50513          	addi	a0,a0,-1874 # 800a9128 <disk+0x2128>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	b44080e7          	jalr	-1212(ra) # 800063c6 <release>
}
    8000588a:	60e2                	ld	ra,24(sp)
    8000588c:	6442                	ld	s0,16(sp)
    8000588e:	64a2                	ld	s1,8(sp)
    80005890:	6902                	ld	s2,0(sp)
    80005892:	6105                	addi	sp,sp,32
    80005894:	8082                	ret
      panic("virtio_disk_intr status");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	f2a50513          	addi	a0,a0,-214 # 800087c0 <syscalls+0x3b0>
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	52a080e7          	jalr	1322(ra) # 80005dc8 <panic>

00000000800058a6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a6:	1141                	addi	sp,sp,-16
    800058a8:	e422                	sd	s0,8(sp)
    800058aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058b0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b4:	0037979b          	slliw	a5,a5,0x3
    800058b8:	02004737          	lui	a4,0x2004
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	0200c737          	lui	a4,0x200c
    800058c2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c6:	000f4637          	lui	a2,0xf4
    800058ca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ce:	95b2                	add	a1,a1,a2
    800058d0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058d2:	00269713          	slli	a4,a3,0x2
    800058d6:	9736                	add	a4,a4,a3
    800058d8:	00371693          	slli	a3,a4,0x3
    800058dc:	000a4717          	auipc	a4,0xa4
    800058e0:	72470713          	addi	a4,a4,1828 # 800aa000 <timer_scratch>
    800058e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ee:	00000797          	auipc	a5,0x0
    800058f2:	97278793          	addi	a5,a5,-1678 # 80005260 <timervec>
    800058f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005902:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005906:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000590a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000590e:	30479073          	csrw	mie,a5
}
    80005912:	6422                	ld	s0,8(sp)
    80005914:	0141                	addi	sp,sp,16
    80005916:	8082                	ret

0000000080005918 <start>:
{
    80005918:	1141                	addi	sp,sp,-16
    8000591a:	e406                	sd	ra,8(sp)
    8000591c:	e022                	sd	s0,0(sp)
    8000591e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005920:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005924:	7779                	lui	a4,0xffffe
    80005926:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff4c5bf>
    8000592a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000592c:	6705                	lui	a4,0x1
    8000592e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005932:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005934:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005938:	ffffb797          	auipc	a5,0xffffb
    8000593c:	a5678793          	addi	a5,a5,-1450 # 8000038e <main>
    80005940:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005944:	4781                	li	a5,0
    80005946:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000594a:	67c1                	lui	a5,0x10
    8000594c:	17fd                	addi	a5,a5,-1
    8000594e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005952:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005956:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000595a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000595e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005962:	57fd                	li	a5,-1
    80005964:	83a9                	srli	a5,a5,0xa
    80005966:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000596a:	47bd                	li	a5,15
    8000596c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005970:	00000097          	auipc	ra,0x0
    80005974:	f36080e7          	jalr	-202(ra) # 800058a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005978:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000597c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000597e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005980:	30200073          	mret
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret

000000008000598c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000598c:	715d                	addi	sp,sp,-80
    8000598e:	e486                	sd	ra,72(sp)
    80005990:	e0a2                	sd	s0,64(sp)
    80005992:	fc26                	sd	s1,56(sp)
    80005994:	f84a                	sd	s2,48(sp)
    80005996:	f44e                	sd	s3,40(sp)
    80005998:	f052                	sd	s4,32(sp)
    8000599a:	ec56                	sd	s5,24(sp)
    8000599c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000599e:	04c05663          	blez	a2,800059ea <consolewrite+0x5e>
    800059a2:	8a2a                	mv	s4,a0
    800059a4:	84ae                	mv	s1,a1
    800059a6:	89b2                	mv	s3,a2
    800059a8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059aa:	5afd                	li	s5,-1
    800059ac:	4685                	li	a3,1
    800059ae:	8626                	mv	a2,s1
    800059b0:	85d2                	mv	a1,s4
    800059b2:	fbf40513          	addi	a0,s0,-65
    800059b6:	ffffc097          	auipc	ra,0xffffc
    800059ba:	0ec080e7          	jalr	236(ra) # 80001aa2 <either_copyin>
    800059be:	01550c63          	beq	a0,s5,800059d6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059c2:	fbf44503          	lbu	a0,-65(s0)
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	78e080e7          	jalr	1934(ra) # 80006154 <uartputc>
  for(i = 0; i < n; i++){
    800059ce:	2905                	addiw	s2,s2,1
    800059d0:	0485                	addi	s1,s1,1
    800059d2:	fd299de3          	bne	s3,s2,800059ac <consolewrite+0x20>
  }

  return i;
}
    800059d6:	854a                	mv	a0,s2
    800059d8:	60a6                	ld	ra,72(sp)
    800059da:	6406                	ld	s0,64(sp)
    800059dc:	74e2                	ld	s1,56(sp)
    800059de:	7942                	ld	s2,48(sp)
    800059e0:	79a2                	ld	s3,40(sp)
    800059e2:	7a02                	ld	s4,32(sp)
    800059e4:	6ae2                	ld	s5,24(sp)
    800059e6:	6161                	addi	sp,sp,80
    800059e8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ea:	4901                	li	s2,0
    800059ec:	b7ed                	j	800059d6 <consolewrite+0x4a>

00000000800059ee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ee:	7119                	addi	sp,sp,-128
    800059f0:	fc86                	sd	ra,120(sp)
    800059f2:	f8a2                	sd	s0,112(sp)
    800059f4:	f4a6                	sd	s1,104(sp)
    800059f6:	f0ca                	sd	s2,96(sp)
    800059f8:	ecce                	sd	s3,88(sp)
    800059fa:	e8d2                	sd	s4,80(sp)
    800059fc:	e4d6                	sd	s5,72(sp)
    800059fe:	e0da                	sd	s6,64(sp)
    80005a00:	fc5e                	sd	s7,56(sp)
    80005a02:	f862                	sd	s8,48(sp)
    80005a04:	f466                	sd	s9,40(sp)
    80005a06:	f06a                	sd	s10,32(sp)
    80005a08:	ec6e                	sd	s11,24(sp)
    80005a0a:	0100                	addi	s0,sp,128
    80005a0c:	8b2a                	mv	s6,a0
    80005a0e:	8aae                	mv	s5,a1
    80005a10:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a12:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a16:	000ac517          	auipc	a0,0xac
    80005a1a:	72a50513          	addi	a0,a0,1834 # 800b2140 <cons>
    80005a1e:	00001097          	auipc	ra,0x1
    80005a22:	8f4080e7          	jalr	-1804(ra) # 80006312 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a26:	000ac497          	auipc	s1,0xac
    80005a2a:	71a48493          	addi	s1,s1,1818 # 800b2140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a2e:	89a6                	mv	s3,s1
    80005a30:	000ac917          	auipc	s2,0xac
    80005a34:	7a890913          	addi	s2,s2,1960 # 800b21d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a38:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a3c:	4da9                	li	s11,10
  while(n > 0){
    80005a3e:	07405863          	blez	s4,80005aae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a42:	0984a783          	lw	a5,152(s1)
    80005a46:	09c4a703          	lw	a4,156(s1)
    80005a4a:	02f71463          	bne	a4,a5,80005a72 <consoleread+0x84>
      if(myproc()->killed){
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	590080e7          	jalr	1424(ra) # 80000fde <myproc>
    80005a56:	551c                	lw	a5,40(a0)
    80005a58:	e7b5                	bnez	a5,80005ac4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a5a:	85ce                	mv	a1,s3
    80005a5c:	854a                	mv	a0,s2
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	c4a080e7          	jalr	-950(ra) # 800016a8 <sleep>
    while(cons.r == cons.w){
    80005a66:	0984a783          	lw	a5,152(s1)
    80005a6a:	09c4a703          	lw	a4,156(s1)
    80005a6e:	fef700e3          	beq	a4,a5,80005a4e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a72:	0017871b          	addiw	a4,a5,1
    80005a76:	08e4ac23          	sw	a4,152(s1)
    80005a7a:	07f7f713          	andi	a4,a5,127
    80005a7e:	9726                	add	a4,a4,s1
    80005a80:	01874703          	lbu	a4,24(a4)
    80005a84:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a88:	079c0663          	beq	s8,s9,80005af4 <consoleread+0x106>
    cbuf = c;
    80005a8c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a90:	4685                	li	a3,1
    80005a92:	f8f40613          	addi	a2,s0,-113
    80005a96:	85d6                	mv	a1,s5
    80005a98:	855a                	mv	a0,s6
    80005a9a:	ffffc097          	auipc	ra,0xffffc
    80005a9e:	fb2080e7          	jalr	-78(ra) # 80001a4c <either_copyout>
    80005aa2:	01a50663          	beq	a0,s10,80005aae <consoleread+0xc0>
    dst++;
    80005aa6:	0a85                	addi	s5,s5,1
    --n;
    80005aa8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005aaa:	f9bc1ae3          	bne	s8,s11,80005a3e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aae:	000ac517          	auipc	a0,0xac
    80005ab2:	69250513          	addi	a0,a0,1682 # 800b2140 <cons>
    80005ab6:	00001097          	auipc	ra,0x1
    80005aba:	910080e7          	jalr	-1776(ra) # 800063c6 <release>

  return target - n;
    80005abe:	414b853b          	subw	a0,s7,s4
    80005ac2:	a811                	j	80005ad6 <consoleread+0xe8>
        release(&cons.lock);
    80005ac4:	000ac517          	auipc	a0,0xac
    80005ac8:	67c50513          	addi	a0,a0,1660 # 800b2140 <cons>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	8fa080e7          	jalr	-1798(ra) # 800063c6 <release>
        return -1;
    80005ad4:	557d                	li	a0,-1
}
    80005ad6:	70e6                	ld	ra,120(sp)
    80005ad8:	7446                	ld	s0,112(sp)
    80005ada:	74a6                	ld	s1,104(sp)
    80005adc:	7906                	ld	s2,96(sp)
    80005ade:	69e6                	ld	s3,88(sp)
    80005ae0:	6a46                	ld	s4,80(sp)
    80005ae2:	6aa6                	ld	s5,72(sp)
    80005ae4:	6b06                	ld	s6,64(sp)
    80005ae6:	7be2                	ld	s7,56(sp)
    80005ae8:	7c42                	ld	s8,48(sp)
    80005aea:	7ca2                	ld	s9,40(sp)
    80005aec:	7d02                	ld	s10,32(sp)
    80005aee:	6de2                	ld	s11,24(sp)
    80005af0:	6109                	addi	sp,sp,128
    80005af2:	8082                	ret
      if(n < target){
    80005af4:	000a071b          	sext.w	a4,s4
    80005af8:	fb777be3          	bgeu	a4,s7,80005aae <consoleread+0xc0>
        cons.r--;
    80005afc:	000ac717          	auipc	a4,0xac
    80005b00:	6cf72e23          	sw	a5,1756(a4) # 800b21d8 <cons+0x98>
    80005b04:	b76d                	j	80005aae <consoleread+0xc0>

0000000080005b06 <consputc>:
{
    80005b06:	1141                	addi	sp,sp,-16
    80005b08:	e406                	sd	ra,8(sp)
    80005b0a:	e022                	sd	s0,0(sp)
    80005b0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b0e:	10000793          	li	a5,256
    80005b12:	00f50a63          	beq	a0,a5,80005b26 <consputc+0x20>
    uartputc_sync(c);
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	564080e7          	jalr	1380(ra) # 8000607a <uartputc_sync>
}
    80005b1e:	60a2                	ld	ra,8(sp)
    80005b20:	6402                	ld	s0,0(sp)
    80005b22:	0141                	addi	sp,sp,16
    80005b24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b26:	4521                	li	a0,8
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	552080e7          	jalr	1362(ra) # 8000607a <uartputc_sync>
    80005b30:	02000513          	li	a0,32
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	546080e7          	jalr	1350(ra) # 8000607a <uartputc_sync>
    80005b3c:	4521                	li	a0,8
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	53c080e7          	jalr	1340(ra) # 8000607a <uartputc_sync>
    80005b46:	bfe1                	j	80005b1e <consputc+0x18>

0000000080005b48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b48:	1101                	addi	sp,sp,-32
    80005b4a:	ec06                	sd	ra,24(sp)
    80005b4c:	e822                	sd	s0,16(sp)
    80005b4e:	e426                	sd	s1,8(sp)
    80005b50:	e04a                	sd	s2,0(sp)
    80005b52:	1000                	addi	s0,sp,32
    80005b54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b56:	000ac517          	auipc	a0,0xac
    80005b5a:	5ea50513          	addi	a0,a0,1514 # 800b2140 <cons>
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	7b4080e7          	jalr	1972(ra) # 80006312 <acquire>

  switch(c){
    80005b66:	47d5                	li	a5,21
    80005b68:	0af48663          	beq	s1,a5,80005c14 <consoleintr+0xcc>
    80005b6c:	0297ca63          	blt	a5,s1,80005ba0 <consoleintr+0x58>
    80005b70:	47a1                	li	a5,8
    80005b72:	0ef48763          	beq	s1,a5,80005c60 <consoleintr+0x118>
    80005b76:	47c1                	li	a5,16
    80005b78:	10f49a63          	bne	s1,a5,80005c8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	f7c080e7          	jalr	-132(ra) # 80001af8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b84:	000ac517          	auipc	a0,0xac
    80005b88:	5bc50513          	addi	a0,a0,1468 # 800b2140 <cons>
    80005b8c:	00001097          	auipc	ra,0x1
    80005b90:	83a080e7          	jalr	-1990(ra) # 800063c6 <release>
}
    80005b94:	60e2                	ld	ra,24(sp)
    80005b96:	6442                	ld	s0,16(sp)
    80005b98:	64a2                	ld	s1,8(sp)
    80005b9a:	6902                	ld	s2,0(sp)
    80005b9c:	6105                	addi	sp,sp,32
    80005b9e:	8082                	ret
  switch(c){
    80005ba0:	07f00793          	li	a5,127
    80005ba4:	0af48e63          	beq	s1,a5,80005c60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ba8:	000ac717          	auipc	a4,0xac
    80005bac:	59870713          	addi	a4,a4,1432 # 800b2140 <cons>
    80005bb0:	0a072783          	lw	a5,160(a4)
    80005bb4:	09872703          	lw	a4,152(a4)
    80005bb8:	9f99                	subw	a5,a5,a4
    80005bba:	07f00713          	li	a4,127
    80005bbe:	fcf763e3          	bltu	a4,a5,80005b84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bc2:	47b5                	li	a5,13
    80005bc4:	0cf48763          	beq	s1,a5,80005c92 <consoleintr+0x14a>
      consputc(c);
    80005bc8:	8526                	mv	a0,s1
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	f3c080e7          	jalr	-196(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd2:	000ac797          	auipc	a5,0xac
    80005bd6:	56e78793          	addi	a5,a5,1390 # 800b2140 <cons>
    80005bda:	0a07a703          	lw	a4,160(a5)
    80005bde:	0017069b          	addiw	a3,a4,1
    80005be2:	0006861b          	sext.w	a2,a3
    80005be6:	0ad7a023          	sw	a3,160(a5)
    80005bea:	07f77713          	andi	a4,a4,127
    80005bee:	97ba                	add	a5,a5,a4
    80005bf0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bf4:	47a9                	li	a5,10
    80005bf6:	0cf48563          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005bfa:	4791                	li	a5,4
    80005bfc:	0cf48263          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005c00:	000ac797          	auipc	a5,0xac
    80005c04:	5d87a783          	lw	a5,1496(a5) # 800b21d8 <cons+0x98>
    80005c08:	0807879b          	addiw	a5,a5,128
    80005c0c:	f6f61ce3          	bne	a2,a5,80005b84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c10:	863e                	mv	a2,a5
    80005c12:	a07d                	j	80005cc0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c14:	000ac717          	auipc	a4,0xac
    80005c18:	52c70713          	addi	a4,a4,1324 # 800b2140 <cons>
    80005c1c:	0a072783          	lw	a5,160(a4)
    80005c20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c24:	000ac497          	auipc	s1,0xac
    80005c28:	51c48493          	addi	s1,s1,1308 # 800b2140 <cons>
    while(cons.e != cons.w &&
    80005c2c:	4929                	li	s2,10
    80005c2e:	f4f70be3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c32:	37fd                	addiw	a5,a5,-1
    80005c34:	07f7f713          	andi	a4,a5,127
    80005c38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c3a:	01874703          	lbu	a4,24(a4)
    80005c3e:	f52703e3          	beq	a4,s2,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	ebc080e7          	jalr	-324(ra) # 80005b06 <consputc>
    while(cons.e != cons.w &&
    80005c52:	0a04a783          	lw	a5,160(s1)
    80005c56:	09c4a703          	lw	a4,156(s1)
    80005c5a:	fcf71ce3          	bne	a4,a5,80005c32 <consoleintr+0xea>
    80005c5e:	b71d                	j	80005b84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c60:	000ac717          	auipc	a4,0xac
    80005c64:	4e070713          	addi	a4,a4,1248 # 800b2140 <cons>
    80005c68:	0a072783          	lw	a5,160(a4)
    80005c6c:	09c72703          	lw	a4,156(a4)
    80005c70:	f0f70ae3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c74:	37fd                	addiw	a5,a5,-1
    80005c76:	000ac717          	auipc	a4,0xac
    80005c7a:	56f72523          	sw	a5,1386(a4) # 800b21e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c7e:	10000513          	li	a0,256
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	e84080e7          	jalr	-380(ra) # 80005b06 <consputc>
    80005c8a:	bded                	j	80005b84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c8c:	ee048ce3          	beqz	s1,80005b84 <consoleintr+0x3c>
    80005c90:	bf21                	j	80005ba8 <consoleintr+0x60>
      consputc(c);
    80005c92:	4529                	li	a0,10
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	e72080e7          	jalr	-398(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c9c:	000ac797          	auipc	a5,0xac
    80005ca0:	4a478793          	addi	a5,a5,1188 # 800b2140 <cons>
    80005ca4:	0a07a703          	lw	a4,160(a5)
    80005ca8:	0017069b          	addiw	a3,a4,1
    80005cac:	0006861b          	sext.w	a2,a3
    80005cb0:	0ad7a023          	sw	a3,160(a5)
    80005cb4:	07f77713          	andi	a4,a4,127
    80005cb8:	97ba                	add	a5,a5,a4
    80005cba:	4729                	li	a4,10
    80005cbc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cc0:	000ac797          	auipc	a5,0xac
    80005cc4:	50c7ae23          	sw	a2,1308(a5) # 800b21dc <cons+0x9c>
        wakeup(&cons.r);
    80005cc8:	000ac517          	auipc	a0,0xac
    80005ccc:	51050513          	addi	a0,a0,1296 # 800b21d8 <cons+0x98>
    80005cd0:	ffffc097          	auipc	ra,0xffffc
    80005cd4:	b64080e7          	jalr	-1180(ra) # 80001834 <wakeup>
    80005cd8:	b575                	j	80005b84 <consoleintr+0x3c>

0000000080005cda <consoleinit>:

void
consoleinit(void)
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e406                	sd	ra,8(sp)
    80005cde:	e022                	sd	s0,0(sp)
    80005ce0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	af658593          	addi	a1,a1,-1290 # 800087d8 <syscalls+0x3c8>
    80005cea:	000ac517          	auipc	a0,0xac
    80005cee:	45650513          	addi	a0,a0,1110 # 800b2140 <cons>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	590080e7          	jalr	1424(ra) # 80006282 <initlock>

  uartinit();
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	330080e7          	jalr	816(ra) # 8000602a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d02:	000a0797          	auipc	a5,0xa0
    80005d06:	1de78793          	addi	a5,a5,478 # 800a5ee0 <devsw>
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	ce470713          	addi	a4,a4,-796 # 800059ee <consoleread>
    80005d12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d14:	00000717          	auipc	a4,0x0
    80005d18:	c7870713          	addi	a4,a4,-904 # 8000598c <consolewrite>
    80005d1c:	ef98                	sd	a4,24(a5)
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret

0000000080005d26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d26:	7179                	addi	sp,sp,-48
    80005d28:	f406                	sd	ra,40(sp)
    80005d2a:	f022                	sd	s0,32(sp)
    80005d2c:	ec26                	sd	s1,24(sp)
    80005d2e:	e84a                	sd	s2,16(sp)
    80005d30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d32:	c219                	beqz	a2,80005d38 <printint+0x12>
    80005d34:	08054663          	bltz	a0,80005dc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d38:	2501                	sext.w	a0,a0
    80005d3a:	4881                	li	a7,0
    80005d3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d42:	2581                	sext.w	a1,a1
    80005d44:	00003617          	auipc	a2,0x3
    80005d48:	ac460613          	addi	a2,a2,-1340 # 80008808 <digits>
    80005d4c:	883a                	mv	a6,a4
    80005d4e:	2705                	addiw	a4,a4,1
    80005d50:	02b577bb          	remuw	a5,a0,a1
    80005d54:	1782                	slli	a5,a5,0x20
    80005d56:	9381                	srli	a5,a5,0x20
    80005d58:	97b2                	add	a5,a5,a2
    80005d5a:	0007c783          	lbu	a5,0(a5)
    80005d5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d62:	0005079b          	sext.w	a5,a0
    80005d66:	02b5553b          	divuw	a0,a0,a1
    80005d6a:	0685                	addi	a3,a3,1
    80005d6c:	feb7f0e3          	bgeu	a5,a1,80005d4c <printint+0x26>

  if(sign)
    80005d70:	00088b63          	beqz	a7,80005d86 <printint+0x60>
    buf[i++] = '-';
    80005d74:	fe040793          	addi	a5,s0,-32
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	02d00793          	li	a5,45
    80005d7e:	fef70823          	sb	a5,-16(a4)
    80005d82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d86:	02e05763          	blez	a4,80005db4 <printint+0x8e>
    80005d8a:	fd040793          	addi	a5,s0,-48
    80005d8e:	00e784b3          	add	s1,a5,a4
    80005d92:	fff78913          	addi	s2,a5,-1
    80005d96:	993a                	add	s2,s2,a4
    80005d98:	377d                	addiw	a4,a4,-1
    80005d9a:	1702                	slli	a4,a4,0x20
    80005d9c:	9301                	srli	a4,a4,0x20
    80005d9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005da2:	fff4c503          	lbu	a0,-1(s1)
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	d60080e7          	jalr	-672(ra) # 80005b06 <consputc>
  while(--i >= 0)
    80005dae:	14fd                	addi	s1,s1,-1
    80005db0:	ff2499e3          	bne	s1,s2,80005da2 <printint+0x7c>
}
    80005db4:	70a2                	ld	ra,40(sp)
    80005db6:	7402                	ld	s0,32(sp)
    80005db8:	64e2                	ld	s1,24(sp)
    80005dba:	6942                	ld	s2,16(sp)
    80005dbc:	6145                	addi	sp,sp,48
    80005dbe:	8082                	ret
    x = -xx;
    80005dc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dc4:	4885                	li	a7,1
    x = -xx;
    80005dc6:	bf9d                	j	80005d3c <printint+0x16>

0000000080005dc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc8:	1101                	addi	sp,sp,-32
    80005dca:	ec06                	sd	ra,24(sp)
    80005dcc:	e822                	sd	s0,16(sp)
    80005dce:	e426                	sd	s1,8(sp)
    80005dd0:	1000                	addi	s0,sp,32
    80005dd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dd4:	000ac797          	auipc	a5,0xac
    80005dd8:	4207a623          	sw	zero,1068(a5) # 800b2200 <pr+0x18>
  printf("panic: ");
    80005ddc:	00003517          	auipc	a0,0x3
    80005de0:	a0450513          	addi	a0,a0,-1532 # 800087e0 <syscalls+0x3d0>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	02e080e7          	jalr	46(ra) # 80005e12 <printf>
  printf(s);
    80005dec:	8526                	mv	a0,s1
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	024080e7          	jalr	36(ra) # 80005e12 <printf>
  printf("\n");
    80005df6:	00002517          	auipc	a0,0x2
    80005dfa:	25a50513          	addi	a0,a0,602 # 80008050 <etext+0x50>
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	014080e7          	jalr	20(ra) # 80005e12 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e06:	4785                	li	a5,1
    80005e08:	00003717          	auipc	a4,0x3
    80005e0c:	20f72a23          	sw	a5,532(a4) # 8000901c <panicked>
  for(;;)
    80005e10:	a001                	j	80005e10 <panic+0x48>

0000000080005e12 <printf>:
{
    80005e12:	7131                	addi	sp,sp,-192
    80005e14:	fc86                	sd	ra,120(sp)
    80005e16:	f8a2                	sd	s0,112(sp)
    80005e18:	f4a6                	sd	s1,104(sp)
    80005e1a:	f0ca                	sd	s2,96(sp)
    80005e1c:	ecce                	sd	s3,88(sp)
    80005e1e:	e8d2                	sd	s4,80(sp)
    80005e20:	e4d6                	sd	s5,72(sp)
    80005e22:	e0da                	sd	s6,64(sp)
    80005e24:	fc5e                	sd	s7,56(sp)
    80005e26:	f862                	sd	s8,48(sp)
    80005e28:	f466                	sd	s9,40(sp)
    80005e2a:	f06a                	sd	s10,32(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	0100                	addi	s0,sp,128
    80005e30:	8a2a                	mv	s4,a0
    80005e32:	e40c                	sd	a1,8(s0)
    80005e34:	e810                	sd	a2,16(s0)
    80005e36:	ec14                	sd	a3,24(s0)
    80005e38:	f018                	sd	a4,32(s0)
    80005e3a:	f41c                	sd	a5,40(s0)
    80005e3c:	03043823          	sd	a6,48(s0)
    80005e40:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e44:	000acd97          	auipc	s11,0xac
    80005e48:	3bcdad83          	lw	s11,956(s11) # 800b2200 <pr+0x18>
  if(locking)
    80005e4c:	020d9b63          	bnez	s11,80005e82 <printf+0x70>
  if (fmt == 0)
    80005e50:	040a0263          	beqz	s4,80005e94 <printf+0x82>
  va_start(ap, fmt);
    80005e54:	00840793          	addi	a5,s0,8
    80005e58:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5c:	000a4503          	lbu	a0,0(s4)
    80005e60:	16050263          	beqz	a0,80005fc4 <printf+0x1b2>
    80005e64:	4481                	li	s1,0
    if(c != '%'){
    80005e66:	02500a93          	li	s5,37
    switch(c){
    80005e6a:	07000b13          	li	s6,112
  consputc('x');
    80005e6e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e70:	00003b97          	auipc	s7,0x3
    80005e74:	998b8b93          	addi	s7,s7,-1640 # 80008808 <digits>
    switch(c){
    80005e78:	07300c93          	li	s9,115
    80005e7c:	06400c13          	li	s8,100
    80005e80:	a82d                	j	80005eba <printf+0xa8>
    acquire(&pr.lock);
    80005e82:	000ac517          	auipc	a0,0xac
    80005e86:	36650513          	addi	a0,a0,870 # 800b21e8 <pr>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	488080e7          	jalr	1160(ra) # 80006312 <acquire>
    80005e92:	bf7d                	j	80005e50 <printf+0x3e>
    panic("null fmt");
    80005e94:	00003517          	auipc	a0,0x3
    80005e98:	95c50513          	addi	a0,a0,-1700 # 800087f0 <syscalls+0x3e0>
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	f2c080e7          	jalr	-212(ra) # 80005dc8 <panic>
      consputc(c);
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	c62080e7          	jalr	-926(ra) # 80005b06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eac:	2485                	addiw	s1,s1,1
    80005eae:	009a07b3          	add	a5,s4,s1
    80005eb2:	0007c503          	lbu	a0,0(a5)
    80005eb6:	10050763          	beqz	a0,80005fc4 <printf+0x1b2>
    if(c != '%'){
    80005eba:	ff5515e3          	bne	a0,s5,80005ea4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ebe:	2485                	addiw	s1,s1,1
    80005ec0:	009a07b3          	add	a5,s4,s1
    80005ec4:	0007c783          	lbu	a5,0(a5)
    80005ec8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ecc:	cfe5                	beqz	a5,80005fc4 <printf+0x1b2>
    switch(c){
    80005ece:	05678a63          	beq	a5,s6,80005f22 <printf+0x110>
    80005ed2:	02fb7663          	bgeu	s6,a5,80005efe <printf+0xec>
    80005ed6:	09978963          	beq	a5,s9,80005f68 <printf+0x156>
    80005eda:	07800713          	li	a4,120
    80005ede:	0ce79863          	bne	a5,a4,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	4605                	li	a2,1
    80005ef0:	85ea                	mv	a1,s10
    80005ef2:	4388                	lw	a0,0(a5)
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	e32080e7          	jalr	-462(ra) # 80005d26 <printint>
      break;
    80005efc:	bf45                	j	80005eac <printf+0x9a>
    switch(c){
    80005efe:	0b578263          	beq	a5,s5,80005fa2 <printf+0x190>
    80005f02:	0b879663          	bne	a5,s8,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f06:	f8843783          	ld	a5,-120(s0)
    80005f0a:	00878713          	addi	a4,a5,8
    80005f0e:	f8e43423          	sd	a4,-120(s0)
    80005f12:	4605                	li	a2,1
    80005f14:	45a9                	li	a1,10
    80005f16:	4388                	lw	a0,0(a5)
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	e0e080e7          	jalr	-498(ra) # 80005d26 <printint>
      break;
    80005f20:	b771                	j	80005eac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f32:	03000513          	li	a0,48
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	bd0080e7          	jalr	-1072(ra) # 80005b06 <consputc>
  consputc('x');
    80005f3e:	07800513          	li	a0,120
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	bc4080e7          	jalr	-1084(ra) # 80005b06 <consputc>
    80005f4a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f4c:	03c9d793          	srli	a5,s3,0x3c
    80005f50:	97de                	add	a5,a5,s7
    80005f52:	0007c503          	lbu	a0,0(a5)
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	bb0080e7          	jalr	-1104(ra) # 80005b06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f5e:	0992                	slli	s3,s3,0x4
    80005f60:	397d                	addiw	s2,s2,-1
    80005f62:	fe0915e3          	bnez	s2,80005f4c <printf+0x13a>
    80005f66:	b799                	j	80005eac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f68:	f8843783          	ld	a5,-120(s0)
    80005f6c:	00878713          	addi	a4,a5,8
    80005f70:	f8e43423          	sd	a4,-120(s0)
    80005f74:	0007b903          	ld	s2,0(a5)
    80005f78:	00090e63          	beqz	s2,80005f94 <printf+0x182>
      for(; *s; s++)
    80005f7c:	00094503          	lbu	a0,0(s2)
    80005f80:	d515                	beqz	a0,80005eac <printf+0x9a>
        consputc(*s);
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b84080e7          	jalr	-1148(ra) # 80005b06 <consputc>
      for(; *s; s++)
    80005f8a:	0905                	addi	s2,s2,1
    80005f8c:	00094503          	lbu	a0,0(s2)
    80005f90:	f96d                	bnez	a0,80005f82 <printf+0x170>
    80005f92:	bf29                	j	80005eac <printf+0x9a>
        s = "(null)";
    80005f94:	00003917          	auipc	s2,0x3
    80005f98:	85490913          	addi	s2,s2,-1964 # 800087e8 <syscalls+0x3d8>
      for(; *s; s++)
    80005f9c:	02800513          	li	a0,40
    80005fa0:	b7cd                	j	80005f82 <printf+0x170>
      consputc('%');
    80005fa2:	8556                	mv	a0,s5
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	b62080e7          	jalr	-1182(ra) # 80005b06 <consputc>
      break;
    80005fac:	b701                	j	80005eac <printf+0x9a>
      consputc('%');
    80005fae:	8556                	mv	a0,s5
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b56080e7          	jalr	-1194(ra) # 80005b06 <consputc>
      consputc(c);
    80005fb8:	854a                	mv	a0,s2
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	b4c080e7          	jalr	-1204(ra) # 80005b06 <consputc>
      break;
    80005fc2:	b5ed                	j	80005eac <printf+0x9a>
  if(locking)
    80005fc4:	020d9163          	bnez	s11,80005fe6 <printf+0x1d4>
}
    80005fc8:	70e6                	ld	ra,120(sp)
    80005fca:	7446                	ld	s0,112(sp)
    80005fcc:	74a6                	ld	s1,104(sp)
    80005fce:	7906                	ld	s2,96(sp)
    80005fd0:	69e6                	ld	s3,88(sp)
    80005fd2:	6a46                	ld	s4,80(sp)
    80005fd4:	6aa6                	ld	s5,72(sp)
    80005fd6:	6b06                	ld	s6,64(sp)
    80005fd8:	7be2                	ld	s7,56(sp)
    80005fda:	7c42                	ld	s8,48(sp)
    80005fdc:	7ca2                	ld	s9,40(sp)
    80005fde:	7d02                	ld	s10,32(sp)
    80005fe0:	6de2                	ld	s11,24(sp)
    80005fe2:	6129                	addi	sp,sp,192
    80005fe4:	8082                	ret
    release(&pr.lock);
    80005fe6:	000ac517          	auipc	a0,0xac
    80005fea:	20250513          	addi	a0,a0,514 # 800b21e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	3d8080e7          	jalr	984(ra) # 800063c6 <release>
}
    80005ff6:	bfc9                	j	80005fc8 <printf+0x1b6>

0000000080005ff8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ff8:	1101                	addi	sp,sp,-32
    80005ffa:	ec06                	sd	ra,24(sp)
    80005ffc:	e822                	sd	s0,16(sp)
    80005ffe:	e426                	sd	s1,8(sp)
    80006000:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006002:	000ac497          	auipc	s1,0xac
    80006006:	1e648493          	addi	s1,s1,486 # 800b21e8 <pr>
    8000600a:	00002597          	auipc	a1,0x2
    8000600e:	7f658593          	addi	a1,a1,2038 # 80008800 <syscalls+0x3f0>
    80006012:	8526                	mv	a0,s1
    80006014:	00000097          	auipc	ra,0x0
    80006018:	26e080e7          	jalr	622(ra) # 80006282 <initlock>
  pr.locking = 1;
    8000601c:	4785                	li	a5,1
    8000601e:	cc9c                	sw	a5,24(s1)
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e406                	sd	ra,8(sp)
    8000602e:	e022                	sd	s0,0(sp)
    80006030:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006032:	100007b7          	lui	a5,0x10000
    80006036:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000603a:	f8000713          	li	a4,-128
    8000603e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006042:	470d                	li	a4,3
    80006044:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006048:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000604c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006050:	469d                	li	a3,7
    80006052:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006056:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000605a:	00002597          	auipc	a1,0x2
    8000605e:	7c658593          	addi	a1,a1,1990 # 80008820 <digits+0x18>
    80006062:	000ac517          	auipc	a0,0xac
    80006066:	1a650513          	addi	a0,a0,422 # 800b2208 <uart_tx_lock>
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	218080e7          	jalr	536(ra) # 80006282 <initlock>
}
    80006072:	60a2                	ld	ra,8(sp)
    80006074:	6402                	ld	s0,0(sp)
    80006076:	0141                	addi	sp,sp,16
    80006078:	8082                	ret

000000008000607a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000607a:	1101                	addi	sp,sp,-32
    8000607c:	ec06                	sd	ra,24(sp)
    8000607e:	e822                	sd	s0,16(sp)
    80006080:	e426                	sd	s1,8(sp)
    80006082:	1000                	addi	s0,sp,32
    80006084:	84aa                	mv	s1,a0
  push_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	240080e7          	jalr	576(ra) # 800062c6 <push_off>

  if(panicked){
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	f8e7a783          	lw	a5,-114(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006096:	10000737          	lui	a4,0x10000
  if(panicked){
    8000609a:	c391                	beqz	a5,8000609e <uartputc_sync+0x24>
    for(;;)
    8000609c:	a001                	j	8000609c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060a2:	0ff7f793          	andi	a5,a5,255
    800060a6:	0207f793          	andi	a5,a5,32
    800060aa:	dbf5                	beqz	a5,8000609e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060ac:	0ff4f793          	andi	a5,s1,255
    800060b0:	10000737          	lui	a4,0x10000
    800060b4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	2ae080e7          	jalr	686(ra) # 80006366 <pop_off>
}
    800060c0:	60e2                	ld	ra,24(sp)
    800060c2:	6442                	ld	s0,16(sp)
    800060c4:	64a2                	ld	s1,8(sp)
    800060c6:	6105                	addi	sp,sp,32
    800060c8:	8082                	ret

00000000800060ca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ca:	00003717          	auipc	a4,0x3
    800060ce:	f5673703          	ld	a4,-170(a4) # 80009020 <uart_tx_r>
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f567b783          	ld	a5,-170(a5) # 80009028 <uart_tx_w>
    800060da:	06e78c63          	beq	a5,a4,80006152 <uartstart+0x88>
{
    800060de:	7139                	addi	sp,sp,-64
    800060e0:	fc06                	sd	ra,56(sp)
    800060e2:	f822                	sd	s0,48(sp)
    800060e4:	f426                	sd	s1,40(sp)
    800060e6:	f04a                	sd	s2,32(sp)
    800060e8:	ec4e                	sd	s3,24(sp)
    800060ea:	e852                	sd	s4,16(sp)
    800060ec:	e456                	sd	s5,8(sp)
    800060ee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f4:	000aca17          	auipc	s4,0xac
    800060f8:	114a0a13          	addi	s4,s4,276 # 800b2208 <uart_tx_lock>
    uart_tx_r += 1;
    800060fc:	00003497          	auipc	s1,0x3
    80006100:	f2448493          	addi	s1,s1,-220 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006104:	00003997          	auipc	s3,0x3
    80006108:	f2498993          	addi	s3,s3,-220 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000610c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006110:	0ff7f793          	andi	a5,a5,255
    80006114:	0207f793          	andi	a5,a5,32
    80006118:	c785                	beqz	a5,80006140 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611a:	01f77793          	andi	a5,a4,31
    8000611e:	97d2                	add	a5,a5,s4
    80006120:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006124:	0705                	addi	a4,a4,1
    80006126:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006128:	8526                	mv	a0,s1
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	70a080e7          	jalr	1802(ra) # 80001834 <wakeup>
    
    WriteReg(THR, c);
    80006132:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006136:	6098                	ld	a4,0(s1)
    80006138:	0009b783          	ld	a5,0(s3)
    8000613c:	fce798e3          	bne	a5,a4,8000610c <uartstart+0x42>
  }
}
    80006140:	70e2                	ld	ra,56(sp)
    80006142:	7442                	ld	s0,48(sp)
    80006144:	74a2                	ld	s1,40(sp)
    80006146:	7902                	ld	s2,32(sp)
    80006148:	69e2                	ld	s3,24(sp)
    8000614a:	6a42                	ld	s4,16(sp)
    8000614c:	6aa2                	ld	s5,8(sp)
    8000614e:	6121                	addi	sp,sp,64
    80006150:	8082                	ret
    80006152:	8082                	ret

0000000080006154 <uartputc>:
{
    80006154:	7179                	addi	sp,sp,-48
    80006156:	f406                	sd	ra,40(sp)
    80006158:	f022                	sd	s0,32(sp)
    8000615a:	ec26                	sd	s1,24(sp)
    8000615c:	e84a                	sd	s2,16(sp)
    8000615e:	e44e                	sd	s3,8(sp)
    80006160:	e052                	sd	s4,0(sp)
    80006162:	1800                	addi	s0,sp,48
    80006164:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006166:	000ac517          	auipc	a0,0xac
    8000616a:	0a250513          	addi	a0,a0,162 # 800b2208 <uart_tx_lock>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	1a4080e7          	jalr	420(ra) # 80006312 <acquire>
  if(panicked){
    80006176:	00003797          	auipc	a5,0x3
    8000617a:	ea67a783          	lw	a5,-346(a5) # 8000901c <panicked>
    8000617e:	c391                	beqz	a5,80006182 <uartputc+0x2e>
    for(;;)
    80006180:	a001                	j	80006180 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006182:	00003797          	auipc	a5,0x3
    80006186:	ea67b783          	ld	a5,-346(a5) # 80009028 <uart_tx_w>
    8000618a:	00003717          	auipc	a4,0x3
    8000618e:	e9673703          	ld	a4,-362(a4) # 80009020 <uart_tx_r>
    80006192:	02070713          	addi	a4,a4,32
    80006196:	02f71b63          	bne	a4,a5,800061cc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000619a:	000aca17          	auipc	s4,0xac
    8000619e:	06ea0a13          	addi	s4,s4,110 # 800b2208 <uart_tx_lock>
    800061a2:	00003497          	auipc	s1,0x3
    800061a6:	e7e48493          	addi	s1,s1,-386 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061aa:	00003917          	auipc	s2,0x3
    800061ae:	e7e90913          	addi	s2,s2,-386 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061b2:	85d2                	mv	a1,s4
    800061b4:	8526                	mv	a0,s1
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	4f2080e7          	jalr	1266(ra) # 800016a8 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061be:	00093783          	ld	a5,0(s2)
    800061c2:	6098                	ld	a4,0(s1)
    800061c4:	02070713          	addi	a4,a4,32
    800061c8:	fef705e3          	beq	a4,a5,800061b2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061cc:	000ac497          	auipc	s1,0xac
    800061d0:	03c48493          	addi	s1,s1,60 # 800b2208 <uart_tx_lock>
    800061d4:	01f7f713          	andi	a4,a5,31
    800061d8:	9726                	add	a4,a4,s1
    800061da:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061de:	0785                	addi	a5,a5,1
    800061e0:	00003717          	auipc	a4,0x3
    800061e4:	e4f73423          	sd	a5,-440(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	ee2080e7          	jalr	-286(ra) # 800060ca <uartstart>
      release(&uart_tx_lock);
    800061f0:	8526                	mv	a0,s1
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	1d4080e7          	jalr	468(ra) # 800063c6 <release>
}
    800061fa:	70a2                	ld	ra,40(sp)
    800061fc:	7402                	ld	s0,32(sp)
    800061fe:	64e2                	ld	s1,24(sp)
    80006200:	6942                	ld	s2,16(sp)
    80006202:	69a2                	ld	s3,8(sp)
    80006204:	6a02                	ld	s4,0(sp)
    80006206:	6145                	addi	sp,sp,48
    80006208:	8082                	ret

000000008000620a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000620a:	1141                	addi	sp,sp,-16
    8000620c:	e422                	sd	s0,8(sp)
    8000620e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006210:	100007b7          	lui	a5,0x10000
    80006214:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006218:	8b85                	andi	a5,a5,1
    8000621a:	cb91                	beqz	a5,8000622e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000621c:	100007b7          	lui	a5,0x10000
    80006220:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006224:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006228:	6422                	ld	s0,8(sp)
    8000622a:	0141                	addi	sp,sp,16
    8000622c:	8082                	ret
    return -1;
    8000622e:	557d                	li	a0,-1
    80006230:	bfe5                	j	80006228 <uartgetc+0x1e>

0000000080006232 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006232:	1101                	addi	sp,sp,-32
    80006234:	ec06                	sd	ra,24(sp)
    80006236:	e822                	sd	s0,16(sp)
    80006238:	e426                	sd	s1,8(sp)
    8000623a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000623c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	fcc080e7          	jalr	-52(ra) # 8000620a <uartgetc>
    if(c == -1)
    80006246:	00950763          	beq	a0,s1,80006254 <uartintr+0x22>
      break;
    consoleintr(c);
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	8fe080e7          	jalr	-1794(ra) # 80005b48 <consoleintr>
  while(1){
    80006252:	b7f5                	j	8000623e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006254:	000ac497          	auipc	s1,0xac
    80006258:	fb448493          	addi	s1,s1,-76 # 800b2208 <uart_tx_lock>
    8000625c:	8526                	mv	a0,s1
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	0b4080e7          	jalr	180(ra) # 80006312 <acquire>
  uartstart();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	e64080e7          	jalr	-412(ra) # 800060ca <uartstart>
  release(&uart_tx_lock);
    8000626e:	8526                	mv	a0,s1
    80006270:	00000097          	auipc	ra,0x0
    80006274:	156080e7          	jalr	342(ra) # 800063c6 <release>
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6105                	addi	sp,sp,32
    80006280:	8082                	ret

0000000080006282 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006282:	1141                	addi	sp,sp,-16
    80006284:	e422                	sd	s0,8(sp)
    80006286:	0800                	addi	s0,sp,16
  lk->name = name;
    80006288:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000628a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000628e:	00053823          	sd	zero,16(a0)
}
    80006292:	6422                	ld	s0,8(sp)
    80006294:	0141                	addi	sp,sp,16
    80006296:	8082                	ret

0000000080006298 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006298:	411c                	lw	a5,0(a0)
    8000629a:	e399                	bnez	a5,800062a0 <holding+0x8>
    8000629c:	4501                	li	a0,0
  return r;
}
    8000629e:	8082                	ret
{
    800062a0:	1101                	addi	sp,sp,-32
    800062a2:	ec06                	sd	ra,24(sp)
    800062a4:	e822                	sd	s0,16(sp)
    800062a6:	e426                	sd	s1,8(sp)
    800062a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062aa:	6904                	ld	s1,16(a0)
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	d16080e7          	jalr	-746(ra) # 80000fc2 <mycpu>
    800062b4:	40a48533          	sub	a0,s1,a0
    800062b8:	00153513          	seqz	a0,a0
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret

00000000800062c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c6:	1101                	addi	sp,sp,-32
    800062c8:	ec06                	sd	ra,24(sp)
    800062ca:	e822                	sd	s0,16(sp)
    800062cc:	e426                	sd	s1,8(sp)
    800062ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d0:	100024f3          	csrr	s1,sstatus
    800062d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	ce4080e7          	jalr	-796(ra) # 80000fc2 <mycpu>
    800062e6:	5d3c                	lw	a5,120(a0)
    800062e8:	cf89                	beqz	a5,80006302 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ea:	ffffb097          	auipc	ra,0xffffb
    800062ee:	cd8080e7          	jalr	-808(ra) # 80000fc2 <mycpu>
    800062f2:	5d3c                	lw	a5,120(a0)
    800062f4:	2785                	addiw	a5,a5,1
    800062f6:	dd3c                	sw	a5,120(a0)
}
    800062f8:	60e2                	ld	ra,24(sp)
    800062fa:	6442                	ld	s0,16(sp)
    800062fc:	64a2                	ld	s1,8(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret
    mycpu()->intena = old;
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	cc0080e7          	jalr	-832(ra) # 80000fc2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000630a:	8085                	srli	s1,s1,0x1
    8000630c:	8885                	andi	s1,s1,1
    8000630e:	dd64                	sw	s1,124(a0)
    80006310:	bfe9                	j	800062ea <push_off+0x24>

0000000080006312 <acquire>:
{
    80006312:	1101                	addi	sp,sp,-32
    80006314:	ec06                	sd	ra,24(sp)
    80006316:	e822                	sd	s0,16(sp)
    80006318:	e426                	sd	s1,8(sp)
    8000631a:	1000                	addi	s0,sp,32
    8000631c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	fa8080e7          	jalr	-88(ra) # 800062c6 <push_off>
  if(holding(lk))
    80006326:	8526                	mv	a0,s1
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	f70080e7          	jalr	-144(ra) # 80006298 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006330:	4705                	li	a4,1
  if(holding(lk))
    80006332:	e115                	bnez	a0,80006356 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006334:	87ba                	mv	a5,a4
    80006336:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000633a:	2781                	sext.w	a5,a5
    8000633c:	ffe5                	bnez	a5,80006334 <acquire+0x22>
  __sync_synchronize();
    8000633e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	c80080e7          	jalr	-896(ra) # 80000fc2 <mycpu>
    8000634a:	e888                	sd	a0,16(s1)
}
    8000634c:	60e2                	ld	ra,24(sp)
    8000634e:	6442                	ld	s0,16(sp)
    80006350:	64a2                	ld	s1,8(sp)
    80006352:	6105                	addi	sp,sp,32
    80006354:	8082                	ret
    panic("acquire");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	4d250513          	addi	a0,a0,1234 # 80008828 <digits+0x20>
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	a6a080e7          	jalr	-1430(ra) # 80005dc8 <panic>

0000000080006366 <pop_off>:

void
pop_off(void)
{
    80006366:	1141                	addi	sp,sp,-16
    80006368:	e406                	sd	ra,8(sp)
    8000636a:	e022                	sd	s0,0(sp)
    8000636c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000636e:	ffffb097          	auipc	ra,0xffffb
    80006372:	c54080e7          	jalr	-940(ra) # 80000fc2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006376:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000637a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000637c:	e78d                	bnez	a5,800063a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000637e:	5d3c                	lw	a5,120(a0)
    80006380:	02f05b63          	blez	a5,800063b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006384:	37fd                	addiw	a5,a5,-1
    80006386:	0007871b          	sext.w	a4,a5
    8000638a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000638c:	eb09                	bnez	a4,8000639e <pop_off+0x38>
    8000638e:	5d7c                	lw	a5,124(a0)
    80006390:	c799                	beqz	a5,8000639e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006392:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006396:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000639a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000639e:	60a2                	ld	ra,8(sp)
    800063a0:	6402                	ld	s0,0(sp)
    800063a2:	0141                	addi	sp,sp,16
    800063a4:	8082                	ret
    panic("pop_off - interruptible");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	48a50513          	addi	a0,a0,1162 # 80008830 <digits+0x28>
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	a1a080e7          	jalr	-1510(ra) # 80005dc8 <panic>
    panic("pop_off");
    800063b6:	00002517          	auipc	a0,0x2
    800063ba:	49250513          	addi	a0,a0,1170 # 80008848 <digits+0x40>
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	a0a080e7          	jalr	-1526(ra) # 80005dc8 <panic>

00000000800063c6 <release>:
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
    800063d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	ec6080e7          	jalr	-314(ra) # 80006298 <holding>
    800063da:	c115                	beqz	a0,800063fe <release+0x38>
  lk->cpu = 0;
    800063dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063e4:	0f50000f          	fence	iorw,ow
    800063e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	f7a080e7          	jalr	-134(ra) # 80006366 <pop_off>
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret
    panic("release");
    800063fe:	00002517          	auipc	a0,0x2
    80006402:	45250513          	addi	a0,a0,1106 # 80008850 <digits+0x48>
    80006406:	00000097          	auipc	ra,0x0
    8000640a:	9c2080e7          	jalr	-1598(ra) # 80005dc8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
