
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	063050ef          	jal	ra,80005878 <start>

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
    80000030:	00021797          	auipc	a5,0x21
    80000034:	21078793          	addi	a5,a5,528 # 80021240 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	218080e7          	jalr	536(ra) # 80006272 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2b8080e7          	jalr	696(ra) # 80006326 <release>
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
    8000008e:	c9e080e7          	jalr	-866(ra) # 80005d28 <panic>

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
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0ee080e7          	jalr	238(ra) # 800061e2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00021517          	auipc	a0,0x21
    80000104:	14050513          	addi	a0,a0,320 # 80021240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	146080e7          	jalr	326(ra) # 80006272 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1e2080e7          	jalr	482(ra) # 80006326 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	1b8080e7          	jalr	440(ra) # 80006326 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	a16080e7          	jalr	-1514(ra) # 80005d72 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	728080e7          	jalr	1832(ra) # 80001a94 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	e8c080e7          	jalr	-372(ra) # 80005200 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd6080e7          	jalr	-42(ra) # 80001352 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	8b6080e7          	jalr	-1866(ra) # 80005c3a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	bcc080e7          	jalr	-1076(ra) # 80005f58 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	9d6080e7          	jalr	-1578(ra) # 80005d72 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	9c6080e7          	jalr	-1594(ra) # 80005d72 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	9b6080e7          	jalr	-1610(ra) # 80005d72 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	688080e7          	jalr	1672(ra) # 80001a6c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6a8080e7          	jalr	1704(ra) # 80001a94 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	df6080e7          	jalr	-522(ra) # 800051ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	e04080e7          	jalr	-508(ra) # 80005200 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	dd2080e7          	jalr	-558(ra) # 800021d6 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	528080e7          	jalr	1320(ra) # 80002934 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	4d4080e7          	jalr	1236(ra) # 800038e8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	f06080e7          	jalr	-250(ra) # 80005322 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	89a080e7          	jalr	-1894(ra) # 80005d28 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	7a2080e7          	jalr	1954(ra) # 80005d28 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	792080e7          	jalr	1938(ra) # 80005d28 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	718080e7          	jalr	1816(ra) # 80005d28 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	5cc080e7          	jalr	1484(ra) # 80005d28 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	5bc080e7          	jalr	1468(ra) # 80005d28 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	5ac080e7          	jalr	1452(ra) # 80005d28 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	59c080e7          	jalr	1436(ra) # 80005d28 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	4be080e7          	jalr	1214(ra) # 80005d28 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	37c080e7          	jalr	892(ra) # 80005d28 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	2a0080e7          	jalr	672(ra) # 80005d28 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	290080e7          	jalr	656(ra) # 80005d28 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	226080e7          	jalr	550(ra) # 80005d28 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00009a17          	auipc	s4,0x9
    80000d0a:	58aa0a13          	addi	s4,s4,1418 # 8000a290 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	16848493          	addi	s1,s1,360
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	fc4080e7          	jalr	-60(ra) # 80005d28 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	452080e7          	jalr	1106(ra) # 800061e2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	43a080e7          	jalr	1082(ra) # 800061e2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00009997          	auipc	s3,0x9
    80000dd6:	4be98993          	addi	s3,s3,1214 # 8000a290 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	404080e7          	jalr	1028(ra) # 800061e2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	16848493          	addi	s1,s1,360
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	3d4080e7          	jalr	980(ra) # 80006226 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	45a080e7          	jalr	1114(ra) # 800062c6 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	496080e7          	jalr	1174(ra) # 80006326 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9887a783          	lw	a5,-1656(a5) # 80008820 <first.1672>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c0a080e7          	jalr	-1014(ra) # 80001aac <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9607a723          	sw	zero,-1682(a5) # 80008820 <first.1672>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	9f8080e7          	jalr	-1544(ra) # 800028b4 <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	396080e7          	jalr	918(ra) # 80006272 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	94078793          	addi	a5,a5,-1728 # 80008824 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	430080e7          	jalr	1072(ra) # 80006326 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00009917          	auipc	s2,0x9
    8000106a:	22a90913          	addi	s2,s2,554 # 8000a290 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	202080e7          	jalr	514(ra) # 80006272 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	c395                	beqz	a5,8000109e <allocproc+0x4c>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	2a8080e7          	jalr	680(ra) # 80006326 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	16848493          	addi	s1,s1,360
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
}
    80001090:	8526                	mv	a0,s1
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6902                	ld	s2,0(sp)
    8000109a:	6105                	addi	sp,sp,32
    8000109c:	8082                	ret
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e28080e7          	jalr	-472(ra) # 80000ec6 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06c080e7          	jalr	108(ra) # 80000118 <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	cd05                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e50080e7          	jalr	-432(ra) # 80000f0c <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c8:	c121                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a4080e7          	jalr	164(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	da478793          	addi	a5,a5,-604 # 80000e80 <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
  return p;
    800010ee:	b74d                	j	80001090 <allocproc+0x3e>
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	22a080e7          	jalr	554(ra) # 80006326 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	b769                	j	80001090 <allocproc+0x3e>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	212080e7          	jalr	530(ra) # 80006326 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	bf8d                	j	80001090 <allocproc+0x3e>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00007597          	auipc	a1,0x7
    80001144:	6f058593          	addi	a1,a1,1776 # 80008830 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	166080e7          	jalr	358(ra) # 800032e4 <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	196080e7          	jalr	406(ra) # 80006326 <release>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <growproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	c98080e7          	jalr	-872(ra) # 80000e48 <myproc>
    800011b8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ba:	652c                	ld	a1,72(a0)
    800011bc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c0:	00904f63          	bgtz	s1,800011de <growproc+0x3c>
  } else if(n < 0){
    800011c4:	0204cc63          	bltz	s1,800011fc <growproc+0x5a>
  p->sz = sz;
    800011c8:	1602                	slli	a2,a2,0x20
    800011ca:	9201                	srli	a2,a2,0x20
    800011cc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	6d0080e7          	jalr	1744(ra) # 800008ba <uvmalloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	fa69                	bnez	a2,800011c8 <growproc+0x26>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bfe1                	j	800011d2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	9e25                	addw	a2,a2,s1
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	66a080e7          	jalr	1642(ra) # 80000872 <uvmdealloc>
    80001210:	0005061b          	sext.w	a2,a0
    80001214:	bf55                	j	800011c8 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7179                	addi	sp,sp,-48
    80001218:	f406                	sd	ra,40(sp)
    8000121a:	f022                	sd	s0,32(sp)
    8000121c:	ec26                	sd	s1,24(sp)
    8000121e:	e84a                	sd	s2,16(sp)
    80001220:	e44e                	sd	s3,8(sp)
    80001222:	e052                	sd	s4,0(sp)
    80001224:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	c22080e7          	jalr	-990(ra) # 80000e48 <myproc>
    8000122e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001230:	00000097          	auipc	ra,0x0
    80001234:	e22080e7          	jalr	-478(ra) # 80001052 <allocproc>
    80001238:	10050b63          	beqz	a0,8000134e <fork+0x138>
    8000123c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123e:	04893603          	ld	a2,72(s2)
    80001242:	692c                	ld	a1,80(a0)
    80001244:	05093503          	ld	a0,80(s2)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	7be080e7          	jalr	1982(ra) # 80000a06 <uvmcopy>
    80001250:	04054663          	bltz	a0,8000129c <fork+0x86>
  np->sz = p->sz;
    80001254:	04893783          	ld	a5,72(s2)
    80001258:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125c:	05893683          	ld	a3,88(s2)
    80001260:	87b6                	mv	a5,a3
    80001262:	0589b703          	ld	a4,88(s3)
    80001266:	12068693          	addi	a3,a3,288
    8000126a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126e:	6788                	ld	a0,8(a5)
    80001270:	6b8c                	ld	a1,16(a5)
    80001272:	6f90                	ld	a2,24(a5)
    80001274:	01073023          	sd	a6,0(a4)
    80001278:	e708                	sd	a0,8(a4)
    8000127a:	eb0c                	sd	a1,16(a4)
    8000127c:	ef10                	sd	a2,24(a4)
    8000127e:	02078793          	addi	a5,a5,32
    80001282:	02070713          	addi	a4,a4,32
    80001286:	fed792e3          	bne	a5,a3,8000126a <fork+0x54>
  np->trapframe->a0 = 0;
    8000128a:	0589b783          	ld	a5,88(s3)
    8000128e:	0607b823          	sd	zero,112(a5)
    80001292:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001296:	15000a13          	li	s4,336
    8000129a:	a03d                	j	800012c8 <fork+0xb2>
    freeproc(np);
    8000129c:	854e                	mv	a0,s3
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	d5c080e7          	jalr	-676(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012a6:	854e                	mv	a0,s3
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	07e080e7          	jalr	126(ra) # 80006326 <release>
    return -1;
    800012b0:	5a7d                	li	s4,-1
    800012b2:	a069                	j	8000133c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b4:	00002097          	auipc	ra,0x2
    800012b8:	6c6080e7          	jalr	1734(ra) # 8000397a <filedup>
    800012bc:	009987b3          	add	a5,s3,s1
    800012c0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012c2:	04a1                	addi	s1,s1,8
    800012c4:	01448763          	beq	s1,s4,800012d2 <fork+0xbc>
    if(p->ofile[i])
    800012c8:	009907b3          	add	a5,s2,s1
    800012cc:	6388                	ld	a0,0(a5)
    800012ce:	f17d                	bnez	a0,800012b4 <fork+0x9e>
    800012d0:	bfcd                	j	800012c2 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012d2:	15093503          	ld	a0,336(s2)
    800012d6:	00002097          	auipc	ra,0x2
    800012da:	818080e7          	jalr	-2024(ra) # 80002aee <idup>
    800012de:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e2:	4641                	li	a2,16
    800012e4:	15890593          	addi	a1,s2,344
    800012e8:	15898513          	addi	a0,s3,344
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	fde080e7          	jalr	-34(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f4:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	02c080e7          	jalr	44(ra) # 80006326 <release>
  acquire(&wait_lock);
    80001302:	00008497          	auipc	s1,0x8
    80001306:	d6648493          	addi	s1,s1,-666 # 80009068 <wait_lock>
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	f66080e7          	jalr	-154(ra) # 80006272 <acquire>
  np->parent = p;
    80001314:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	00c080e7          	jalr	12(ra) # 80006326 <release>
  acquire(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	f4e080e7          	jalr	-178(ra) # 80006272 <acquire>
  np->state = RUNNABLE;
    8000132c:	478d                	li	a5,3
    8000132e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	ff2080e7          	jalr	-14(ra) # 80006326 <release>
}
    8000133c:	8552                	mv	a0,s4
    8000133e:	70a2                	ld	ra,40(sp)
    80001340:	7402                	ld	s0,32(sp)
    80001342:	64e2                	ld	s1,24(sp)
    80001344:	6942                	ld	s2,16(sp)
    80001346:	69a2                	ld	s3,8(sp)
    80001348:	6a02                	ld	s4,0(sp)
    8000134a:	6145                	addi	sp,sp,48
    8000134c:	8082                	ret
    return -1;
    8000134e:	5a7d                	li	s4,-1
    80001350:	b7f5                	j	8000133c <fork+0x126>

0000000080001352 <scheduler>:
{
    80001352:	7139                	addi	sp,sp,-64
    80001354:	fc06                	sd	ra,56(sp)
    80001356:	f822                	sd	s0,48(sp)
    80001358:	f426                	sd	s1,40(sp)
    8000135a:	f04a                	sd	s2,32(sp)
    8000135c:	ec4e                	sd	s3,24(sp)
    8000135e:	e852                	sd	s4,16(sp)
    80001360:	e456                	sd	s5,8(sp)
    80001362:	e05a                	sd	s6,0(sp)
    80001364:	0080                	addi	s0,sp,64
    80001366:	8792                	mv	a5,tp
  int id = r_tp();
    80001368:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136a:	00779a93          	slli	s5,a5,0x7
    8000136e:	00008717          	auipc	a4,0x8
    80001372:	ce270713          	addi	a4,a4,-798 # 80009050 <pid_lock>
    80001376:	9756                	add	a4,a4,s5
    80001378:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137c:	00008717          	auipc	a4,0x8
    80001380:	d0c70713          	addi	a4,a4,-756 # 80009088 <cpus+0x8>
    80001384:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001386:	498d                	li	s3,3
        p->state = RUNNING;
    80001388:	4b11                	li	s6,4
        c->proc = p;
    8000138a:	079e                	slli	a5,a5,0x7
    8000138c:	00008a17          	auipc	s4,0x8
    80001390:	cc4a0a13          	addi	s4,s4,-828 # 80009050 <pid_lock>
    80001394:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	00009917          	auipc	s2,0x9
    8000139a:	efa90913          	addi	s2,s2,-262 # 8000a290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a6:	10079073          	csrw	sstatus,a5
    800013aa:	00008497          	auipc	s1,0x8
    800013ae:	0d648493          	addi	s1,s1,214 # 80009480 <proc>
    800013b2:	a03d                	j	800013e0 <scheduler+0x8e>
        p->state = RUNNING;
    800013b4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013bc:	06048593          	addi	a1,s1,96
    800013c0:	8556                	mv	a0,s5
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	640080e7          	jalr	1600(ra) # 80001a02 <swtch>
        c->proc = 0;
    800013ca:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013ce:	8526                	mv	a0,s1
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	f56080e7          	jalr	-170(ra) # 80006326 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d8:	16848493          	addi	s1,s1,360
    800013dc:	fd2481e3          	beq	s1,s2,8000139e <scheduler+0x4c>
      acquire(&p->lock);
    800013e0:	8526                	mv	a0,s1
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	e90080e7          	jalr	-368(ra) # 80006272 <acquire>
      if(p->state == RUNNABLE) {
    800013ea:	4c9c                	lw	a5,24(s1)
    800013ec:	ff3791e3          	bne	a5,s3,800013ce <scheduler+0x7c>
    800013f0:	b7d1                	j	800013b4 <scheduler+0x62>

00000000800013f2 <sched>:
{
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001400:	00000097          	auipc	ra,0x0
    80001404:	a48080e7          	jalr	-1464(ra) # 80000e48 <myproc>
    80001408:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	dee080e7          	jalr	-530(ra) # 800061f8 <holding>
    80001412:	c93d                	beqz	a0,80001488 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001414:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001416:	2781                	sext.w	a5,a5
    80001418:	079e                	slli	a5,a5,0x7
    8000141a:	00008717          	auipc	a4,0x8
    8000141e:	c3670713          	addi	a4,a4,-970 # 80009050 <pid_lock>
    80001422:	97ba                	add	a5,a5,a4
    80001424:	0a87a703          	lw	a4,168(a5)
    80001428:	4785                	li	a5,1
    8000142a:	06f71763          	bne	a4,a5,80001498 <sched+0xa6>
  if(p->state == RUNNING)
    8000142e:	4c98                	lw	a4,24(s1)
    80001430:	4791                	li	a5,4
    80001432:	06f70b63          	beq	a4,a5,800014a8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001436:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143c:	efb5                	bnez	a5,800014b8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001440:	00008917          	auipc	s2,0x8
    80001444:	c1090913          	addi	s2,s2,-1008 # 80009050 <pid_lock>
    80001448:	2781                	sext.w	a5,a5
    8000144a:	079e                	slli	a5,a5,0x7
    8000144c:	97ca                	add	a5,a5,s2
    8000144e:	0ac7a983          	lw	s3,172(a5)
    80001452:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	00008597          	auipc	a1,0x8
    8000145c:	c3058593          	addi	a1,a1,-976 # 80009088 <cpus+0x8>
    80001460:	95be                	add	a1,a1,a5
    80001462:	06048513          	addi	a0,s1,96
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	59c080e7          	jalr	1436(ra) # 80001a02 <swtch>
    8000146e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	97ca                	add	a5,a5,s2
    80001476:	0b37a623          	sw	s3,172(a5)
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6145                	addi	sp,sp,48
    80001486:	8082                	ret
    panic("sched p->lock");
    80001488:	00007517          	auipc	a0,0x7
    8000148c:	d1050513          	addi	a0,a0,-752 # 80008198 <etext+0x198>
    80001490:	00005097          	auipc	ra,0x5
    80001494:	898080e7          	jalr	-1896(ra) # 80005d28 <panic>
    panic("sched locks");
    80001498:	00007517          	auipc	a0,0x7
    8000149c:	d1050513          	addi	a0,a0,-752 # 800081a8 <etext+0x1a8>
    800014a0:	00005097          	auipc	ra,0x5
    800014a4:	888080e7          	jalr	-1912(ra) # 80005d28 <panic>
    panic("sched running");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	d1050513          	addi	a0,a0,-752 # 800081b8 <etext+0x1b8>
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	878080e7          	jalr	-1928(ra) # 80005d28 <panic>
    panic("sched interruptible");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d1050513          	addi	a0,a0,-752 # 800081c8 <etext+0x1c8>
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	868080e7          	jalr	-1944(ra) # 80005d28 <panic>

00000000800014c8 <yield>:
{
    800014c8:	1101                	addi	sp,sp,-32
    800014ca:	ec06                	sd	ra,24(sp)
    800014cc:	e822                	sd	s0,16(sp)
    800014ce:	e426                	sd	s1,8(sp)
    800014d0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	976080e7          	jalr	-1674(ra) # 80000e48 <myproc>
    800014da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	d96080e7          	jalr	-618(ra) # 80006272 <acquire>
  p->state = RUNNABLE;
    800014e4:	478d                	li	a5,3
    800014e6:	cc9c                	sw	a5,24(s1)
  sched();
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	f0a080e7          	jalr	-246(ra) # 800013f2 <sched>
  release(&p->lock);
    800014f0:	8526                	mv	a0,s1
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	e34080e7          	jalr	-460(ra) # 80006326 <release>
}
    800014fa:	60e2                	ld	ra,24(sp)
    800014fc:	6442                	ld	s0,16(sp)
    800014fe:	64a2                	ld	s1,8(sp)
    80001500:	6105                	addi	sp,sp,32
    80001502:	8082                	ret

0000000080001504 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001504:	7179                	addi	sp,sp,-48
    80001506:	f406                	sd	ra,40(sp)
    80001508:	f022                	sd	s0,32(sp)
    8000150a:	ec26                	sd	s1,24(sp)
    8000150c:	e84a                	sd	s2,16(sp)
    8000150e:	e44e                	sd	s3,8(sp)
    80001510:	1800                	addi	s0,sp,48
    80001512:	89aa                	mv	s3,a0
    80001514:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	932080e7          	jalr	-1742(ra) # 80000e48 <myproc>
    8000151e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	d52080e7          	jalr	-686(ra) # 80006272 <acquire>
  release(lk);
    80001528:	854a                	mv	a0,s2
    8000152a:	00005097          	auipc	ra,0x5
    8000152e:	dfc080e7          	jalr	-516(ra) # 80006326 <release>

  // Go to sleep.
  p->chan = chan;
    80001532:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001536:	4789                	li	a5,2
    80001538:	cc9c                	sw	a5,24(s1)

  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	eb8080e7          	jalr	-328(ra) # 800013f2 <sched>

  // Tidy up.
  p->chan = 0;
    80001542:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	dde080e7          	jalr	-546(ra) # 80006326 <release>
  acquire(lk);
    80001550:	854a                	mv	a0,s2
    80001552:	00005097          	auipc	ra,0x5
    80001556:	d20080e7          	jalr	-736(ra) # 80006272 <acquire>
}
    8000155a:	70a2                	ld	ra,40(sp)
    8000155c:	7402                	ld	s0,32(sp)
    8000155e:	64e2                	ld	s1,24(sp)
    80001560:	6942                	ld	s2,16(sp)
    80001562:	69a2                	ld	s3,8(sp)
    80001564:	6145                	addi	sp,sp,48
    80001566:	8082                	ret

0000000080001568 <wait>:
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	fc26                	sd	s1,56(sp)
    80001570:	f84a                	sd	s2,48(sp)
    80001572:	f44e                	sd	s3,40(sp)
    80001574:	f052                	sd	s4,32(sp)
    80001576:	ec56                	sd	s5,24(sp)
    80001578:	e85a                	sd	s6,16(sp)
    8000157a:	e45e                	sd	s7,8(sp)
    8000157c:	e062                	sd	s8,0(sp)
    8000157e:	0880                	addi	s0,sp,80
    80001580:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	8c6080e7          	jalr	-1850(ra) # 80000e48 <myproc>
    8000158a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158c:	00008517          	auipc	a0,0x8
    80001590:	adc50513          	addi	a0,a0,-1316 # 80009068 <wait_lock>
    80001594:	00005097          	auipc	ra,0x5
    80001598:	cde080e7          	jalr	-802(ra) # 80006272 <acquire>
    havekids = 0;
    8000159c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159e:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015a0:	00009997          	auipc	s3,0x9
    800015a4:	cf098993          	addi	s3,s3,-784 # 8000a290 <tickslock>
        havekids = 1;
    800015a8:	4b05                	li	s6,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015aa:	00008c17          	auipc	s8,0x8
    800015ae:	abec0c13          	addi	s8,s8,-1346 # 80009068 <wait_lock>
    havekids = 0;
    800015b2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b4:	00008497          	auipc	s1,0x8
    800015b8:	ecc48493          	addi	s1,s1,-308 # 80009480 <proc>
    800015bc:	a0bd                	j	8000162a <wait+0xc2>
          pid = np->pid;
    800015be:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c2:	000a8e63          	beqz	s5,800015de <wait+0x76>
    800015c6:	4691                	li	a3,4
    800015c8:	02c48613          	addi	a2,s1,44
    800015cc:	85d6                	mv	a1,s5
    800015ce:	05093503          	ld	a0,80(s2)
    800015d2:	fffff097          	auipc	ra,0xfffff
    800015d6:	538080e7          	jalr	1336(ra) # 80000b0a <copyout>
    800015da:	02054563          	bltz	a0,80001604 <wait+0x9c>
          freeproc(np);
    800015de:	8526                	mv	a0,s1
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	a1a080e7          	jalr	-1510(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015e8:	8526                	mv	a0,s1
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	d3c080e7          	jalr	-708(ra) # 80006326 <release>
          release(&wait_lock);
    800015f2:	00008517          	auipc	a0,0x8
    800015f6:	a7650513          	addi	a0,a0,-1418 # 80009068 <wait_lock>
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	d2c080e7          	jalr	-724(ra) # 80006326 <release>
          return pid;
    80001602:	a09d                	j	80001668 <wait+0x100>
            release(&np->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	d20080e7          	jalr	-736(ra) # 80006326 <release>
            release(&wait_lock);
    8000160e:	00008517          	auipc	a0,0x8
    80001612:	a5a50513          	addi	a0,a0,-1446 # 80009068 <wait_lock>
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	d10080e7          	jalr	-752(ra) # 80006326 <release>
            return -1;
    8000161e:	59fd                	li	s3,-1
    80001620:	a0a1                	j	80001668 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001622:	16848493          	addi	s1,s1,360
    80001626:	03348463          	beq	s1,s3,8000164e <wait+0xe6>
      if(np->parent == p){
    8000162a:	7c9c                	ld	a5,56(s1)
    8000162c:	ff279be3          	bne	a5,s2,80001622 <wait+0xba>
        acquire(&np->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	c40080e7          	jalr	-960(ra) # 80006272 <acquire>
        if(np->state == ZOMBIE){
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	f94781e3          	beq	a5,s4,800015be <wait+0x56>
        release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	ce4080e7          	jalr	-796(ra) # 80006326 <release>
        havekids = 1;
    8000164a:	875a                	mv	a4,s6
    8000164c:	bfd9                	j	80001622 <wait+0xba>
    if(!havekids || p->killed){
    8000164e:	c701                	beqz	a4,80001656 <wait+0xee>
    80001650:	02892783          	lw	a5,40(s2)
    80001654:	c79d                	beqz	a5,80001682 <wait+0x11a>
      release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	cc8080e7          	jalr	-824(ra) # 80006326 <release>
      return -1;
    80001666:	59fd                	li	s3,-1
}
    80001668:	854e                	mv	a0,s3
    8000166a:	60a6                	ld	ra,72(sp)
    8000166c:	6406                	ld	s0,64(sp)
    8000166e:	74e2                	ld	s1,56(sp)
    80001670:	7942                	ld	s2,48(sp)
    80001672:	79a2                	ld	s3,40(sp)
    80001674:	7a02                	ld	s4,32(sp)
    80001676:	6ae2                	ld	s5,24(sp)
    80001678:	6b42                	ld	s6,16(sp)
    8000167a:	6ba2                	ld	s7,8(sp)
    8000167c:	6c02                	ld	s8,0(sp)
    8000167e:	6161                	addi	sp,sp,80
    80001680:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001682:	85e2                	mv	a1,s8
    80001684:	854a                	mv	a0,s2
    80001686:	00000097          	auipc	ra,0x0
    8000168a:	e7e080e7          	jalr	-386(ra) # 80001504 <sleep>
    havekids = 0;
    8000168e:	b715                	j	800015b2 <wait+0x4a>

0000000080001690 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001690:	7139                	addi	sp,sp,-64
    80001692:	fc06                	sd	ra,56(sp)
    80001694:	f822                	sd	s0,48(sp)
    80001696:	f426                	sd	s1,40(sp)
    80001698:	f04a                	sd	s2,32(sp)
    8000169a:	ec4e                	sd	s3,24(sp)
    8000169c:	e852                	sd	s4,16(sp)
    8000169e:	e456                	sd	s5,8(sp)
    800016a0:	0080                	addi	s0,sp,64
    800016a2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a4:	00008497          	auipc	s1,0x8
    800016a8:	ddc48493          	addi	s1,s1,-548 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ac:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ae:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	00009917          	auipc	s2,0x9
    800016b4:	be090913          	addi	s2,s2,-1056 # 8000a290 <tickslock>
    800016b8:	a811                	j	800016cc <wakeup+0x3c>
      }
      release(&p->lock);
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	c6a080e7          	jalr	-918(ra) # 80006326 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c4:	16848493          	addi	s1,s1,360
    800016c8:	03248663          	beq	s1,s2,800016f4 <wakeup+0x64>
    if(p != myproc()){
    800016cc:	fffff097          	auipc	ra,0xfffff
    800016d0:	77c080e7          	jalr	1916(ra) # 80000e48 <myproc>
    800016d4:	fea488e3          	beq	s1,a0,800016c4 <wakeup+0x34>
      acquire(&p->lock);
    800016d8:	8526                	mv	a0,s1
    800016da:	00005097          	auipc	ra,0x5
    800016de:	b98080e7          	jalr	-1128(ra) # 80006272 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e2:	4c9c                	lw	a5,24(s1)
    800016e4:	fd379be3          	bne	a5,s3,800016ba <wakeup+0x2a>
    800016e8:	709c                	ld	a5,32(s1)
    800016ea:	fd4798e3          	bne	a5,s4,800016ba <wakeup+0x2a>
        p->state = RUNNABLE;
    800016ee:	0154ac23          	sw	s5,24(s1)
    800016f2:	b7e1                	j	800016ba <wakeup+0x2a>
    }
  }
}
    800016f4:	70e2                	ld	ra,56(sp)
    800016f6:	7442                	ld	s0,48(sp)
    800016f8:	74a2                	ld	s1,40(sp)
    800016fa:	7902                	ld	s2,32(sp)
    800016fc:	69e2                	ld	s3,24(sp)
    800016fe:	6a42                	ld	s4,16(sp)
    80001700:	6aa2                	ld	s5,8(sp)
    80001702:	6121                	addi	sp,sp,64
    80001704:	8082                	ret

0000000080001706 <reparent>:
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
    80001716:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001718:	00008497          	auipc	s1,0x8
    8000171c:	d6848493          	addi	s1,s1,-664 # 80009480 <proc>
      pp->parent = initproc;
    80001720:	00008a17          	auipc	s4,0x8
    80001724:	8f0a0a13          	addi	s4,s4,-1808 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001728:	00009997          	auipc	s3,0x9
    8000172c:	b6898993          	addi	s3,s3,-1176 # 8000a290 <tickslock>
    80001730:	a029                	j	8000173a <reparent+0x34>
    80001732:	16848493          	addi	s1,s1,360
    80001736:	01348d63          	beq	s1,s3,80001750 <reparent+0x4a>
    if(pp->parent == p){
    8000173a:	7c9c                	ld	a5,56(s1)
    8000173c:	ff279be3          	bne	a5,s2,80001732 <reparent+0x2c>
      pp->parent = initproc;
    80001740:	000a3503          	ld	a0,0(s4)
    80001744:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	f4a080e7          	jalr	-182(ra) # 80001690 <wakeup>
    8000174e:	b7d5                	j	80001732 <reparent+0x2c>
}
    80001750:	70a2                	ld	ra,40(sp)
    80001752:	7402                	ld	s0,32(sp)
    80001754:	64e2                	ld	s1,24(sp)
    80001756:	6942                	ld	s2,16(sp)
    80001758:	69a2                	ld	s3,8(sp)
    8000175a:	6a02                	ld	s4,0(sp)
    8000175c:	6145                	addi	sp,sp,48
    8000175e:	8082                	ret

0000000080001760 <exit>:
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	e052                	sd	s4,0(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001772:	fffff097          	auipc	ra,0xfffff
    80001776:	6d6080e7          	jalr	1750(ra) # 80000e48 <myproc>
    8000177a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000177c:	00008797          	auipc	a5,0x8
    80001780:	8947b783          	ld	a5,-1900(a5) # 80009010 <initproc>
    80001784:	0d050493          	addi	s1,a0,208
    80001788:	15050913          	addi	s2,a0,336
    8000178c:	02a79363          	bne	a5,a0,800017b2 <exit+0x52>
    panic("init exiting");
    80001790:	00007517          	auipc	a0,0x7
    80001794:	a5050513          	addi	a0,a0,-1456 # 800081e0 <etext+0x1e0>
    80001798:	00004097          	auipc	ra,0x4
    8000179c:	590080e7          	jalr	1424(ra) # 80005d28 <panic>
      fileclose(f);
    800017a0:	00002097          	auipc	ra,0x2
    800017a4:	22c080e7          	jalr	556(ra) # 800039cc <fileclose>
      p->ofile[fd] = 0;
    800017a8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ac:	04a1                	addi	s1,s1,8
    800017ae:	01248563          	beq	s1,s2,800017b8 <exit+0x58>
    if(p->ofile[fd]){
    800017b2:	6088                	ld	a0,0(s1)
    800017b4:	f575                	bnez	a0,800017a0 <exit+0x40>
    800017b6:	bfdd                	j	800017ac <exit+0x4c>
  begin_op();
    800017b8:	00002097          	auipc	ra,0x2
    800017bc:	d48080e7          	jalr	-696(ra) # 80003500 <begin_op>
  iput(p->cwd);
    800017c0:	1509b503          	ld	a0,336(s3)
    800017c4:	00001097          	auipc	ra,0x1
    800017c8:	522080e7          	jalr	1314(ra) # 80002ce6 <iput>
  end_op();
    800017cc:	00002097          	auipc	ra,0x2
    800017d0:	db4080e7          	jalr	-588(ra) # 80003580 <end_op>
  p->cwd = 0;
    800017d4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d8:	00008497          	auipc	s1,0x8
    800017dc:	89048493          	addi	s1,s1,-1904 # 80009068 <wait_lock>
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	a90080e7          	jalr	-1392(ra) # 80006272 <acquire>
  reparent(p);
    800017ea:	854e                	mv	a0,s3
    800017ec:	00000097          	auipc	ra,0x0
    800017f0:	f1a080e7          	jalr	-230(ra) # 80001706 <reparent>
  wakeup(p->parent);
    800017f4:	0389b503          	ld	a0,56(s3)
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	e98080e7          	jalr	-360(ra) # 80001690 <wakeup>
  acquire(&p->lock);
    80001800:	854e                	mv	a0,s3
    80001802:	00005097          	auipc	ra,0x5
    80001806:	a70080e7          	jalr	-1424(ra) # 80006272 <acquire>
  p->xstate = status;
    8000180a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180e:	4795                	li	a5,5
    80001810:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	b10080e7          	jalr	-1264(ra) # 80006326 <release>
  sched();
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	bd4080e7          	jalr	-1068(ra) # 800013f2 <sched>
  panic("zombie exit");
    80001826:	00007517          	auipc	a0,0x7
    8000182a:	9ca50513          	addi	a0,a0,-1590 # 800081f0 <etext+0x1f0>
    8000182e:	00004097          	auipc	ra,0x4
    80001832:	4fa080e7          	jalr	1274(ra) # 80005d28 <panic>

0000000080001836 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001836:	7179                	addi	sp,sp,-48
    80001838:	f406                	sd	ra,40(sp)
    8000183a:	f022                	sd	s0,32(sp)
    8000183c:	ec26                	sd	s1,24(sp)
    8000183e:	e84a                	sd	s2,16(sp)
    80001840:	e44e                	sd	s3,8(sp)
    80001842:	1800                	addi	s0,sp,48
    80001844:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001846:	00008497          	auipc	s1,0x8
    8000184a:	c3a48493          	addi	s1,s1,-966 # 80009480 <proc>
    8000184e:	00009997          	auipc	s3,0x9
    80001852:	a4298993          	addi	s3,s3,-1470 # 8000a290 <tickslock>
    acquire(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	a1a080e7          	jalr	-1510(ra) # 80006272 <acquire>
    if(p->pid == pid){
    80001860:	589c                	lw	a5,48(s1)
    80001862:	03278363          	beq	a5,s2,80001888 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	abe080e7          	jalr	-1346(ra) # 80006326 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001870:	16848493          	addi	s1,s1,360
    80001874:	ff3491e3          	bne	s1,s3,80001856 <kill+0x20>
  }
  return -1;
    80001878:	557d                	li	a0,-1
}
    8000187a:	70a2                	ld	ra,40(sp)
    8000187c:	7402                	ld	s0,32(sp)
    8000187e:	64e2                	ld	s1,24(sp)
    80001880:	6942                	ld	s2,16(sp)
    80001882:	69a2                	ld	s3,8(sp)
    80001884:	6145                	addi	sp,sp,48
    80001886:	8082                	ret
      p->killed = 1;
    80001888:	4785                	li	a5,1
    8000188a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188c:	4c98                	lw	a4,24(s1)
    8000188e:	4789                	li	a5,2
    80001890:	00f70963          	beq	a4,a5,800018a2 <kill+0x6c>
      release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	a90080e7          	jalr	-1392(ra) # 80006326 <release>
      return 0;
    8000189e:	4501                	li	a0,0
    800018a0:	bfe9                	j	8000187a <kill+0x44>
        p->state = RUNNABLE;
    800018a2:	478d                	li	a5,3
    800018a4:	cc9c                	sw	a5,24(s1)
    800018a6:	b7fd                	j	80001894 <kill+0x5e>

00000000800018a8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	e052                	sd	s4,0(sp)
    800018b6:	1800                	addi	s0,sp,48
    800018b8:	84aa                	mv	s1,a0
    800018ba:	892e                	mv	s2,a1
    800018bc:	89b2                	mv	s3,a2
    800018be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c0:	fffff097          	auipc	ra,0xfffff
    800018c4:	588080e7          	jalr	1416(ra) # 80000e48 <myproc>
  if(user_dst){
    800018c8:	c08d                	beqz	s1,800018ea <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018ca:	86d2                	mv	a3,s4
    800018cc:	864e                	mv	a2,s3
    800018ce:	85ca                	mv	a1,s2
    800018d0:	6928                	ld	a0,80(a0)
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	238080e7          	jalr	568(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018da:	70a2                	ld	ra,40(sp)
    800018dc:	7402                	ld	s0,32(sp)
    800018de:	64e2                	ld	s1,24(sp)
    800018e0:	6942                	ld	s2,16(sp)
    800018e2:	69a2                	ld	s3,8(sp)
    800018e4:	6a02                	ld	s4,0(sp)
    800018e6:	6145                	addi	sp,sp,48
    800018e8:	8082                	ret
    memmove((char *)dst, src, len);
    800018ea:	000a061b          	sext.w	a2,s4
    800018ee:	85ce                	mv	a1,s3
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	8e6080e7          	jalr	-1818(ra) # 800001d8 <memmove>
    return 0;
    800018fa:	8526                	mv	a0,s1
    800018fc:	bff9                	j	800018da <either_copyout+0x32>

00000000800018fe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	892a                	mv	s2,a0
    80001910:	84ae                	mv	s1,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	532080e7          	jalr	1330(ra) # 80000e48 <myproc>
  if(user_src){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	26e080e7          	jalr	622(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	890080e7          	jalr	-1904(ra) # 800001d8 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyin+0x32>

0000000080001954 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001954:	715d                	addi	sp,sp,-80
    80001956:	e486                	sd	ra,72(sp)
    80001958:	e0a2                	sd	s0,64(sp)
    8000195a:	fc26                	sd	s1,56(sp)
    8000195c:	f84a                	sd	s2,48(sp)
    8000195e:	f44e                	sd	s3,40(sp)
    80001960:	f052                	sd	s4,32(sp)
    80001962:	ec56                	sd	s5,24(sp)
    80001964:	e85a                	sd	s6,16(sp)
    80001966:	e45e                	sd	s7,8(sp)
    80001968:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000196a:	00006517          	auipc	a0,0x6
    8000196e:	6de50513          	addi	a0,a0,1758 # 80008048 <etext+0x48>
    80001972:	00004097          	auipc	ra,0x4
    80001976:	400080e7          	jalr	1024(ra) # 80005d72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197a:	00008497          	auipc	s1,0x8
    8000197e:	c5e48493          	addi	s1,s1,-930 # 800095d8 <proc+0x158>
    80001982:	00009917          	auipc	s2,0x9
    80001986:	a6690913          	addi	s2,s2,-1434 # 8000a3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000198c:	00007997          	auipc	s3,0x7
    80001990:	87498993          	addi	s3,s3,-1932 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001994:	00007a97          	auipc	s5,0x7
    80001998:	874a8a93          	addi	s5,s5,-1932 # 80008208 <etext+0x208>
    printf("\n");
    8000199c:	00006a17          	auipc	s4,0x6
    800019a0:	6aca0a13          	addi	s4,s4,1708 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a4:	00007b97          	auipc	s7,0x7
    800019a8:	89cb8b93          	addi	s7,s7,-1892 # 80008240 <states.1709>
    800019ac:	a00d                	j	800019ce <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ae:	ed86a583          	lw	a1,-296(a3)
    800019b2:	8556                	mv	a0,s5
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	3be080e7          	jalr	958(ra) # 80005d72 <printf>
    printf("\n");
    800019bc:	8552                	mv	a0,s4
    800019be:	00004097          	auipc	ra,0x4
    800019c2:	3b4080e7          	jalr	948(ra) # 80005d72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c6:	16848493          	addi	s1,s1,360
    800019ca:	03248163          	beq	s1,s2,800019ec <procdump+0x98>
    if(p->state == UNUSED)
    800019ce:	86a6                	mv	a3,s1
    800019d0:	ec04a783          	lw	a5,-320(s1)
    800019d4:	dbed                	beqz	a5,800019c6 <procdump+0x72>
      state = "???";
    800019d6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d8:	fcfb6be3          	bltu	s6,a5,800019ae <procdump+0x5a>
    800019dc:	1782                	slli	a5,a5,0x20
    800019de:	9381                	srli	a5,a5,0x20
    800019e0:	078e                	slli	a5,a5,0x3
    800019e2:	97de                	add	a5,a5,s7
    800019e4:	6390                	ld	a2,0(a5)
    800019e6:	f661                	bnez	a2,800019ae <procdump+0x5a>
      state = "???";
    800019e8:	864e                	mv	a2,s3
    800019ea:	b7d1                	j	800019ae <procdump+0x5a>
  }
}
    800019ec:	60a6                	ld	ra,72(sp)
    800019ee:	6406                	ld	s0,64(sp)
    800019f0:	74e2                	ld	s1,56(sp)
    800019f2:	7942                	ld	s2,48(sp)
    800019f4:	79a2                	ld	s3,40(sp)
    800019f6:	7a02                	ld	s4,32(sp)
    800019f8:	6ae2                	ld	s5,24(sp)
    800019fa:	6b42                	ld	s6,16(sp)
    800019fc:	6ba2                	ld	s7,8(sp)
    800019fe:	6161                	addi	sp,sp,80
    80001a00:	8082                	ret

0000000080001a02 <swtch>:
    80001a02:	00153023          	sd	ra,0(a0)
    80001a06:	00253423          	sd	sp,8(a0)
    80001a0a:	e900                	sd	s0,16(a0)
    80001a0c:	ed04                	sd	s1,24(a0)
    80001a0e:	03253023          	sd	s2,32(a0)
    80001a12:	03353423          	sd	s3,40(a0)
    80001a16:	03453823          	sd	s4,48(a0)
    80001a1a:	03553c23          	sd	s5,56(a0)
    80001a1e:	05653023          	sd	s6,64(a0)
    80001a22:	05753423          	sd	s7,72(a0)
    80001a26:	05853823          	sd	s8,80(a0)
    80001a2a:	05953c23          	sd	s9,88(a0)
    80001a2e:	07a53023          	sd	s10,96(a0)
    80001a32:	07b53423          	sd	s11,104(a0)
    80001a36:	0005b083          	ld	ra,0(a1)
    80001a3a:	0085b103          	ld	sp,8(a1)
    80001a3e:	6980                	ld	s0,16(a1)
    80001a40:	6d84                	ld	s1,24(a1)
    80001a42:	0205b903          	ld	s2,32(a1)
    80001a46:	0285b983          	ld	s3,40(a1)
    80001a4a:	0305ba03          	ld	s4,48(a1)
    80001a4e:	0385ba83          	ld	s5,56(a1)
    80001a52:	0405bb03          	ld	s6,64(a1)
    80001a56:	0485bb83          	ld	s7,72(a1)
    80001a5a:	0505bc03          	ld	s8,80(a1)
    80001a5e:	0585bc83          	ld	s9,88(a1)
    80001a62:	0605bd03          	ld	s10,96(a1)
    80001a66:	0685bd83          	ld	s11,104(a1)
    80001a6a:	8082                	ret

0000000080001a6c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a6c:	1141                	addi	sp,sp,-16
    80001a6e:	e406                	sd	ra,8(sp)
    80001a70:	e022                	sd	s0,0(sp)
    80001a72:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a74:	00006597          	auipc	a1,0x6
    80001a78:	7fc58593          	addi	a1,a1,2044 # 80008270 <states.1709+0x30>
    80001a7c:	00009517          	auipc	a0,0x9
    80001a80:	81450513          	addi	a0,a0,-2028 # 8000a290 <tickslock>
    80001a84:	00004097          	auipc	ra,0x4
    80001a88:	75e080e7          	jalr	1886(ra) # 800061e2 <initlock>
}
    80001a8c:	60a2                	ld	ra,8(sp)
    80001a8e:	6402                	ld	s0,0(sp)
    80001a90:	0141                	addi	sp,sp,16
    80001a92:	8082                	ret

0000000080001a94 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a94:	1141                	addi	sp,sp,-16
    80001a96:	e422                	sd	s0,8(sp)
    80001a98:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a9a:	00003797          	auipc	a5,0x3
    80001a9e:	69678793          	addi	a5,a5,1686 # 80005130 <kernelvec>
    80001aa2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa6:	6422                	ld	s0,8(sp)
    80001aa8:	0141                	addi	sp,sp,16
    80001aaa:	8082                	ret

0000000080001aac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e406                	sd	ra,8(sp)
    80001ab0:	e022                	sd	s0,0(sp)
    80001ab2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	394080e7          	jalr	916(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac6:	00005617          	auipc	a2,0x5
    80001aca:	53a60613          	addi	a2,a2,1338 # 80007000 <_trampoline>
    80001ace:	00005697          	auipc	a3,0x5
    80001ad2:	53268693          	addi	a3,a3,1330 # 80007000 <_trampoline>
    80001ad6:	8e91                	sub	a3,a3,a2
    80001ad8:	040007b7          	lui	a5,0x4000
    80001adc:	17fd                	addi	a5,a5,-1
    80001ade:	07b2                	slli	a5,a5,0xc
    80001ae0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae8:	180026f3          	csrr	a3,satp
    80001aec:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aee:	6d38                	ld	a4,88(a0)
    80001af0:	6134                	ld	a3,64(a0)
    80001af2:	6585                	lui	a1,0x1
    80001af4:	96ae                	add	a3,a3,a1
    80001af6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af8:	6d38                	ld	a4,88(a0)
    80001afa:	00000697          	auipc	a3,0x0
    80001afe:	13868693          	addi	a3,a3,312 # 80001c32 <usertrap>
    80001b02:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b04:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b06:	8692                	mv	a3,tp
    80001b08:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b12:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b16:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b1a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1c:	6f18                	ld	a4,24(a4)
    80001b1e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b22:	692c                	ld	a1,80(a0)
    80001b24:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b26:	00005717          	auipc	a4,0x5
    80001b2a:	56a70713          	addi	a4,a4,1386 # 80007090 <userret>
    80001b2e:	8f11                	sub	a4,a4,a2
    80001b30:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b32:	577d                	li	a4,-1
    80001b34:	177e                	slli	a4,a4,0x3f
    80001b36:	8dd9                	or	a1,a1,a4
    80001b38:	02000537          	lui	a0,0x2000
    80001b3c:	157d                	addi	a0,a0,-1
    80001b3e:	0536                	slli	a0,a0,0xd
    80001b40:	9782                	jalr	a5
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b4a:	1101                	addi	sp,sp,-32
    80001b4c:	ec06                	sd	ra,24(sp)
    80001b4e:	e822                	sd	s0,16(sp)
    80001b50:	e426                	sd	s1,8(sp)
    80001b52:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b54:	00008497          	auipc	s1,0x8
    80001b58:	73c48493          	addi	s1,s1,1852 # 8000a290 <tickslock>
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	00004097          	auipc	ra,0x4
    80001b62:	714080e7          	jalr	1812(ra) # 80006272 <acquire>
  ticks++;
    80001b66:	00007517          	auipc	a0,0x7
    80001b6a:	4b250513          	addi	a0,a0,1202 # 80009018 <ticks>
    80001b6e:	411c                	lw	a5,0(a0)
    80001b70:	2785                	addiw	a5,a5,1
    80001b72:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b74:	00000097          	auipc	ra,0x0
    80001b78:	b1c080e7          	jalr	-1252(ra) # 80001690 <wakeup>
  release(&tickslock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	00004097          	auipc	ra,0x4
    80001b82:	7a8080e7          	jalr	1960(ra) # 80006326 <release>
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6105                	addi	sp,sp,32
    80001b8e:	8082                	ret

0000000080001b90 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b9a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9e:	00074d63          	bltz	a4,80001bb8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba2:	57fd                	li	a5,-1
    80001ba4:	17fe                	slli	a5,a5,0x3f
    80001ba6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001baa:	06f70363          	beq	a4,a5,80001c10 <devintr+0x80>
  }
}
    80001bae:	60e2                	ld	ra,24(sp)
    80001bb0:	6442                	ld	s0,16(sp)
    80001bb2:	64a2                	ld	s1,8(sp)
    80001bb4:	6105                	addi	sp,sp,32
    80001bb6:	8082                	ret
     (scause & 0xff) == 9){
    80001bb8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bbc:	46a5                	li	a3,9
    80001bbe:	fed792e3          	bne	a5,a3,80001ba2 <devintr+0x12>
    int irq = plic_claim();
    80001bc2:	00003097          	auipc	ra,0x3
    80001bc6:	676080e7          	jalr	1654(ra) # 80005238 <plic_claim>
    80001bca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bcc:	47a9                	li	a5,10
    80001bce:	02f50763          	beq	a0,a5,80001bfc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd2:	4785                	li	a5,1
    80001bd4:	02f50963          	beq	a0,a5,80001c06 <devintr+0x76>
    return 1;
    80001bd8:	4505                	li	a0,1
    } else if(irq){
    80001bda:	d8f1                	beqz	s1,80001bae <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bdc:	85a6                	mv	a1,s1
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	69a50513          	addi	a0,a0,1690 # 80008278 <states.1709+0x38>
    80001be6:	00004097          	auipc	ra,0x4
    80001bea:	18c080e7          	jalr	396(ra) # 80005d72 <printf>
      plic_complete(irq);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00003097          	auipc	ra,0x3
    80001bf4:	66c080e7          	jalr	1644(ra) # 8000525c <plic_complete>
    return 1;
    80001bf8:	4505                	li	a0,1
    80001bfa:	bf55                	j	80001bae <devintr+0x1e>
      uartintr();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	596080e7          	jalr	1430(ra) # 80006192 <uartintr>
    80001c04:	b7ed                	j	80001bee <devintr+0x5e>
      virtio_disk_intr();
    80001c06:	00004097          	auipc	ra,0x4
    80001c0a:	b36080e7          	jalr	-1226(ra) # 8000573c <virtio_disk_intr>
    80001c0e:	b7c5                	j	80001bee <devintr+0x5e>
    if(cpuid() == 0){
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	20c080e7          	jalr	524(ra) # 80000e1c <cpuid>
    80001c18:	c901                	beqz	a0,80001c28 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c1a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c20:	14479073          	csrw	sip,a5
    return 2;
    80001c24:	4509                	li	a0,2
    80001c26:	b761                	j	80001bae <devintr+0x1e>
      clockintr();
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	f22080e7          	jalr	-222(ra) # 80001b4a <clockintr>
    80001c30:	b7ed                	j	80001c1a <devintr+0x8a>

0000000080001c32 <usertrap>:
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	e04a                	sd	s2,0(sp)
    80001c3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c42:	1007f793          	andi	a5,a5,256
    80001c46:	e3ad                	bnez	a5,80001ca8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c48:	00003797          	auipc	a5,0x3
    80001c4c:	4e878793          	addi	a5,a5,1256 # 80005130 <kernelvec>
    80001c50:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	1f4080e7          	jalr	500(ra) # 80000e48 <myproc>
    80001c5c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c60:	14102773          	csrr	a4,sepc
    80001c64:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c66:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c6a:	47a1                	li	a5,8
    80001c6c:	04f71c63          	bne	a4,a5,80001cc4 <usertrap+0x92>
    if(p->killed)
    80001c70:	551c                	lw	a5,40(a0)
    80001c72:	e3b9                	bnez	a5,80001cb8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c74:	6cb8                	ld	a4,88(s1)
    80001c76:	6f1c                	ld	a5,24(a4)
    80001c78:	0791                	addi	a5,a5,4
    80001c7a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c84:	10079073          	csrw	sstatus,a5
    syscall();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	2e0080e7          	jalr	736(ra) # 80001f68 <syscall>
  if(p->killed)
    80001c90:	549c                	lw	a5,40(s1)
    80001c92:	ebc1                	bnez	a5,80001d22 <usertrap+0xf0>
  usertrapret();
    80001c94:	00000097          	auipc	ra,0x0
    80001c98:	e18080e7          	jalr	-488(ra) # 80001aac <usertrapret>
}
    80001c9c:	60e2                	ld	ra,24(sp)
    80001c9e:	6442                	ld	s0,16(sp)
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	6902                	ld	s2,0(sp)
    80001ca4:	6105                	addi	sp,sp,32
    80001ca6:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca8:	00006517          	auipc	a0,0x6
    80001cac:	5f050513          	addi	a0,a0,1520 # 80008298 <states.1709+0x58>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	078080e7          	jalr	120(ra) # 80005d28 <panic>
      exit(-1);
    80001cb8:	557d                	li	a0,-1
    80001cba:	00000097          	auipc	ra,0x0
    80001cbe:	aa6080e7          	jalr	-1370(ra) # 80001760 <exit>
    80001cc2:	bf4d                	j	80001c74 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	ecc080e7          	jalr	-308(ra) # 80001b90 <devintr>
    80001ccc:	892a                	mv	s2,a0
    80001cce:	c501                	beqz	a0,80001cd6 <usertrap+0xa4>
  if(p->killed)
    80001cd0:	549c                	lw	a5,40(s1)
    80001cd2:	c3a1                	beqz	a5,80001d12 <usertrap+0xe0>
    80001cd4:	a815                	j	80001d08 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cda:	5890                	lw	a2,48(s1)
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5dc50513          	addi	a0,a0,1500 # 800082b8 <states.1709+0x78>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	08e080e7          	jalr	142(ra) # 80005d72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5f450513          	addi	a0,a0,1524 # 800082e8 <states.1709+0xa8>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	076080e7          	jalr	118(ra) # 80005d72 <printf>
    p->killed = 1;
    80001d04:	4785                	li	a5,1
    80001d06:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d08:	557d                	li	a0,-1
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	a56080e7          	jalr	-1450(ra) # 80001760 <exit>
  if(which_dev == 2)
    80001d12:	4789                	li	a5,2
    80001d14:	f8f910e3          	bne	s2,a5,80001c94 <usertrap+0x62>
    yield();
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	7b0080e7          	jalr	1968(ra) # 800014c8 <yield>
    80001d20:	bf95                	j	80001c94 <usertrap+0x62>
  int which_dev = 0;
    80001d22:	4901                	li	s2,0
    80001d24:	b7d5                	j	80001d08 <usertrap+0xd6>

0000000080001d26 <kerneltrap>:
{
    80001d26:	7179                	addi	sp,sp,-48
    80001d28:	f406                	sd	ra,40(sp)
    80001d2a:	f022                	sd	s0,32(sp)
    80001d2c:	ec26                	sd	s1,24(sp)
    80001d2e:	e84a                	sd	s2,16(sp)
    80001d30:	e44e                	sd	s3,8(sp)
    80001d32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d40:	1004f793          	andi	a5,s1,256
    80001d44:	cb85                	beqz	a5,80001d74 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d4c:	ef85                	bnez	a5,80001d84 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	e42080e7          	jalr	-446(ra) # 80001b90 <devintr>
    80001d56:	cd1d                	beqz	a0,80001d94 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d58:	4789                	li	a5,2
    80001d5a:	06f50a63          	beq	a0,a5,80001dce <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10049073          	csrw	sstatus,s1
}
    80001d66:	70a2                	ld	ra,40(sp)
    80001d68:	7402                	ld	s0,32(sp)
    80001d6a:	64e2                	ld	s1,24(sp)
    80001d6c:	6942                	ld	s2,16(sp)
    80001d6e:	69a2                	ld	s3,8(sp)
    80001d70:	6145                	addi	sp,sp,48
    80001d72:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	59450513          	addi	a0,a0,1428 # 80008308 <states.1709+0xc8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	fac080e7          	jalr	-84(ra) # 80005d28 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	5ac50513          	addi	a0,a0,1452 # 80008330 <states.1709+0xf0>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	f9c080e7          	jalr	-100(ra) # 80005d28 <panic>
    printf("scause %p\n", scause);
    80001d94:	85ce                	mv	a1,s3
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	5ba50513          	addi	a0,a0,1466 # 80008350 <states.1709+0x110>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	fd4080e7          	jalr	-44(ra) # 80005d72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001daa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dae:	00006517          	auipc	a0,0x6
    80001db2:	5b250513          	addi	a0,a0,1458 # 80008360 <states.1709+0x120>
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	fbc080e7          	jalr	-68(ra) # 80005d72 <printf>
    panic("kerneltrap");
    80001dbe:	00006517          	auipc	a0,0x6
    80001dc2:	5ba50513          	addi	a0,a0,1466 # 80008378 <states.1709+0x138>
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	f62080e7          	jalr	-158(ra) # 80005d28 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	07a080e7          	jalr	122(ra) # 80000e48 <myproc>
    80001dd6:	d541                	beqz	a0,80001d5e <kerneltrap+0x38>
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	070080e7          	jalr	112(ra) # 80000e48 <myproc>
    80001de0:	4d18                	lw	a4,24(a0)
    80001de2:	4791                	li	a5,4
    80001de4:	f6f71de3          	bne	a4,a5,80001d5e <kerneltrap+0x38>
    yield();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	6e0080e7          	jalr	1760(ra) # 800014c8 <yield>
    80001df0:	b7bd                	j	80001d5e <kerneltrap+0x38>

0000000080001df2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	1000                	addi	s0,sp,32
    80001dfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	04a080e7          	jalr	74(ra) # 80000e48 <myproc>
  switch (n) {
    80001e06:	4795                	li	a5,5
    80001e08:	0497e163          	bltu	a5,s1,80001e4a <argraw+0x58>
    80001e0c:	048a                	slli	s1,s1,0x2
    80001e0e:	00006717          	auipc	a4,0x6
    80001e12:	5a270713          	addi	a4,a4,1442 # 800083b0 <states.1709+0x170>
    80001e16:	94ba                	add	s1,s1,a4
    80001e18:	409c                	lw	a5,0(s1)
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1e:	6d3c                	ld	a5,88(a0)
    80001e20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e22:	60e2                	ld	ra,24(sp)
    80001e24:	6442                	ld	s0,16(sp)
    80001e26:	64a2                	ld	s1,8(sp)
    80001e28:	6105                	addi	sp,sp,32
    80001e2a:	8082                	ret
    return p->trapframe->a1;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7fa8                	ld	a0,120(a5)
    80001e30:	bfcd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a2;
    80001e32:	6d3c                	ld	a5,88(a0)
    80001e34:	63c8                	ld	a0,128(a5)
    80001e36:	b7f5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a3;
    80001e38:	6d3c                	ld	a5,88(a0)
    80001e3a:	67c8                	ld	a0,136(a5)
    80001e3c:	b7dd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a4;
    80001e3e:	6d3c                	ld	a5,88(a0)
    80001e40:	6bc8                	ld	a0,144(a5)
    80001e42:	b7c5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a5;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	6fc8                	ld	a0,152(a5)
    80001e48:	bfe9                	j	80001e22 <argraw+0x30>
  panic("argraw");
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	53e50513          	addi	a0,a0,1342 # 80008388 <states.1709+0x148>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	ed6080e7          	jalr	-298(ra) # 80005d28 <panic>

0000000080001e5a <fetchaddr>:
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	e426                	sd	s1,8(sp)
    80001e62:	e04a                	sd	s2,0(sp)
    80001e64:	1000                	addi	s0,sp,32
    80001e66:	84aa                	mv	s1,a0
    80001e68:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	fde080e7          	jalr	-34(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e72:	653c                	ld	a5,72(a0)
    80001e74:	02f4f863          	bgeu	s1,a5,80001ea4 <fetchaddr+0x4a>
    80001e78:	00848713          	addi	a4,s1,8
    80001e7c:	02e7e663          	bltu	a5,a4,80001ea8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e80:	46a1                	li	a3,8
    80001e82:	8626                	mv	a2,s1
    80001e84:	85ca                	mv	a1,s2
    80001e86:	6928                	ld	a0,80(a0)
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	d0e080e7          	jalr	-754(ra) # 80000b96 <copyin>
    80001e90:	00a03533          	snez	a0,a0
    80001e94:	40a00533          	neg	a0,a0
}
    80001e98:	60e2                	ld	ra,24(sp)
    80001e9a:	6442                	ld	s0,16(sp)
    80001e9c:	64a2                	ld	s1,8(sp)
    80001e9e:	6902                	ld	s2,0(sp)
    80001ea0:	6105                	addi	sp,sp,32
    80001ea2:	8082                	ret
    return -1;
    80001ea4:	557d                	li	a0,-1
    80001ea6:	bfcd                	j	80001e98 <fetchaddr+0x3e>
    80001ea8:	557d                	li	a0,-1
    80001eaa:	b7fd                	j	80001e98 <fetchaddr+0x3e>

0000000080001eac <fetchstr>:
{
    80001eac:	7179                	addi	sp,sp,-48
    80001eae:	f406                	sd	ra,40(sp)
    80001eb0:	f022                	sd	s0,32(sp)
    80001eb2:	ec26                	sd	s1,24(sp)
    80001eb4:	e84a                	sd	s2,16(sp)
    80001eb6:	e44e                	sd	s3,8(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	892a                	mv	s2,a0
    80001ebc:	84ae                	mv	s1,a1
    80001ebe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	f88080e7          	jalr	-120(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec8:	86ce                	mv	a3,s3
    80001eca:	864a                	mv	a2,s2
    80001ecc:	85a6                	mv	a1,s1
    80001ece:	6928                	ld	a0,80(a0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	d52080e7          	jalr	-686(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ed8:	00054763          	bltz	a0,80001ee6 <fetchstr+0x3a>
  return strlen(buf);
    80001edc:	8526                	mv	a0,s1
    80001ede:	ffffe097          	auipc	ra,0xffffe
    80001ee2:	41e080e7          	jalr	1054(ra) # 800002fc <strlen>
}
    80001ee6:	70a2                	ld	ra,40(sp)
    80001ee8:	7402                	ld	s0,32(sp)
    80001eea:	64e2                	ld	s1,24(sp)
    80001eec:	6942                	ld	s2,16(sp)
    80001eee:	69a2                	ld	s3,8(sp)
    80001ef0:	6145                	addi	sp,sp,48
    80001ef2:	8082                	ret

0000000080001ef4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef4:	1101                	addi	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	e426                	sd	s1,8(sp)
    80001efc:	1000                	addi	s0,sp,32
    80001efe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	ef2080e7          	jalr	-270(ra) # 80001df2 <argraw>
    80001f08:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f0a:	4501                	li	a0,0
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	1000                	addi	s0,sp,32
    80001f20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	ed0080e7          	jalr	-304(ra) # 80001df2 <argraw>
    80001f2a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f2c:	4501                	li	a0,0
    80001f2e:	60e2                	ld	ra,24(sp)
    80001f30:	6442                	ld	s0,16(sp)
    80001f32:	64a2                	ld	s1,8(sp)
    80001f34:	6105                	addi	sp,sp,32
    80001f36:	8082                	ret

0000000080001f38 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84ae                	mv	s1,a1
    80001f46:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	eaa080e7          	jalr	-342(ra) # 80001df2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	f58080e7          	jalr	-168(ra) # 80001eac <fetchstr>
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6902                	ld	s2,0(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret

0000000080001f68 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	e04a                	sd	s2,0(sp)
    80001f72:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	ed4080e7          	jalr	-300(ra) # 80000e48 <myproc>
    80001f7c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7e:	05853903          	ld	s2,88(a0)
    80001f82:	0a893783          	ld	a5,168(s2)
    80001f86:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f8a:	37fd                	addiw	a5,a5,-1
    80001f8c:	4755                	li	a4,21
    80001f8e:	00f76f63          	bltu	a4,a5,80001fac <syscall+0x44>
    80001f92:	00369713          	slli	a4,a3,0x3
    80001f96:	00006797          	auipc	a5,0x6
    80001f9a:	43278793          	addi	a5,a5,1074 # 800083c8 <syscalls>
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	639c                	ld	a5,0(a5)
    80001fa2:	c789                	beqz	a5,80001fac <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa4:	9782                	jalr	a5
    80001fa6:	06a93823          	sd	a0,112(s2)
    80001faa:	a839                	j	80001fc8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fac:	15848613          	addi	a2,s1,344
    80001fb0:	588c                	lw	a1,48(s1)
    80001fb2:	00006517          	auipc	a0,0x6
    80001fb6:	3de50513          	addi	a0,a0,990 # 80008390 <states.1709+0x150>
    80001fba:	00004097          	auipc	ra,0x4
    80001fbe:	db8080e7          	jalr	-584(ra) # 80005d72 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc2:	6cbc                	ld	a5,88(s1)
    80001fc4:	577d                	li	a4,-1
    80001fc6:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fdc:	fec40593          	addi	a1,s0,-20
    80001fe0:	4501                	li	a0,0
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f12080e7          	jalr	-238(ra) # 80001ef4 <argint>
    return -1;
    80001fea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fec:	00054963          	bltz	a0,80001ffe <sys_exit+0x2a>
  exit(n);
    80001ff0:	fec42503          	lw	a0,-20(s0)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	76c080e7          	jalr	1900(ra) # 80001760 <exit>
  return 0;  // not reached
    80001ffc:	4781                	li	a5,0
}
    80001ffe:	853e                	mv	a0,a5
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002008:	1141                	addi	sp,sp,-16
    8000200a:	e406                	sd	ra,8(sp)
    8000200c:	e022                	sd	s0,0(sp)
    8000200e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	e38080e7          	jalr	-456(ra) # 80000e48 <myproc>
}
    80002018:	5908                	lw	a0,48(a0)
    8000201a:	60a2                	ld	ra,8(sp)
    8000201c:	6402                	ld	s0,0(sp)
    8000201e:	0141                	addi	sp,sp,16
    80002020:	8082                	ret

0000000080002022 <sys_fork>:

uint64
sys_fork(void)
{
    80002022:	1141                	addi	sp,sp,-16
    80002024:	e406                	sd	ra,8(sp)
    80002026:	e022                	sd	s0,0(sp)
    80002028:	0800                	addi	s0,sp,16
  return fork();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	1ec080e7          	jalr	492(ra) # 80001216 <fork>
}
    80002032:	60a2                	ld	ra,8(sp)
    80002034:	6402                	ld	s0,0(sp)
    80002036:	0141                	addi	sp,sp,16
    80002038:	8082                	ret

000000008000203a <sys_wait>:

uint64
sys_wait(void)
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002042:	fe840593          	addi	a1,s0,-24
    80002046:	4501                	li	a0,0
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	ece080e7          	jalr	-306(ra) # 80001f16 <argaddr>
    80002050:	87aa                	mv	a5,a0
    return -1;
    80002052:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002054:	0007c863          	bltz	a5,80002064 <sys_wait+0x2a>
  return wait(p);
    80002058:	fe843503          	ld	a0,-24(s0)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	50c080e7          	jalr	1292(ra) # 80001568 <wait>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000206c:	7179                	addi	sp,sp,-48
    8000206e:	f406                	sd	ra,40(sp)
    80002070:	f022                	sd	s0,32(sp)
    80002072:	ec26                	sd	s1,24(sp)
    80002074:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002076:	fdc40593          	addi	a1,s0,-36
    8000207a:	4501                	li	a0,0
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	e78080e7          	jalr	-392(ra) # 80001ef4 <argint>
    80002084:	87aa                	mv	a5,a0
    return -1;
    80002086:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002088:	0207c063          	bltz	a5,800020a8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	dbc080e7          	jalr	-580(ra) # 80000e48 <myproc>
    80002094:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002096:	fdc42503          	lw	a0,-36(s0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	108080e7          	jalr	264(ra) # 800011a2 <growproc>
    800020a2:	00054863          	bltz	a0,800020b2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020a6:	8526                	mv	a0,s1
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret
    return -1;
    800020b2:	557d                	li	a0,-1
    800020b4:	bfd5                	j	800020a8 <sys_sbrk+0x3c>

00000000800020b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b6:	7139                	addi	sp,sp,-64
    800020b8:	fc06                	sd	ra,56(sp)
    800020ba:	f822                	sd	s0,48(sp)
    800020bc:	f426                	sd	s1,40(sp)
    800020be:	f04a                	sd	s2,32(sp)
    800020c0:	ec4e                	sd	s3,24(sp)
    800020c2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020c4:	fcc40593          	addi	a1,s0,-52
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	e2a080e7          	jalr	-470(ra) # 80001ef4 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	06054563          	bltz	a0,8000213e <sys_sleep+0x88>
  acquire(&tickslock);
    800020d8:	00008517          	auipc	a0,0x8
    800020dc:	1b850513          	addi	a0,a0,440 # 8000a290 <tickslock>
    800020e0:	00004097          	auipc	ra,0x4
    800020e4:	192080e7          	jalr	402(ra) # 80006272 <acquire>
  ticks0 = ticks;
    800020e8:	00007917          	auipc	s2,0x7
    800020ec:	f3092903          	lw	s2,-208(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020f0:	fcc42783          	lw	a5,-52(s0)
    800020f4:	cf85                	beqz	a5,8000212c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f6:	00008997          	auipc	s3,0x8
    800020fa:	19a98993          	addi	s3,s3,410 # 8000a290 <tickslock>
    800020fe:	00007497          	auipc	s1,0x7
    80002102:	f1a48493          	addi	s1,s1,-230 # 80009018 <ticks>
    if(myproc()->killed){
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	d42080e7          	jalr	-702(ra) # 80000e48 <myproc>
    8000210e:	551c                	lw	a5,40(a0)
    80002110:	ef9d                	bnez	a5,8000214e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002112:	85ce                	mv	a1,s3
    80002114:	8526                	mv	a0,s1
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	3ee080e7          	jalr	1006(ra) # 80001504 <sleep>
  while(ticks - ticks0 < n){
    8000211e:	409c                	lw	a5,0(s1)
    80002120:	412787bb          	subw	a5,a5,s2
    80002124:	fcc42703          	lw	a4,-52(s0)
    80002128:	fce7efe3          	bltu	a5,a4,80002106 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000212c:	00008517          	auipc	a0,0x8
    80002130:	16450513          	addi	a0,a0,356 # 8000a290 <tickslock>
    80002134:	00004097          	auipc	ra,0x4
    80002138:	1f2080e7          	jalr	498(ra) # 80006326 <release>
  return 0;
    8000213c:	4781                	li	a5,0
}
    8000213e:	853e                	mv	a0,a5
    80002140:	70e2                	ld	ra,56(sp)
    80002142:	7442                	ld	s0,48(sp)
    80002144:	74a2                	ld	s1,40(sp)
    80002146:	7902                	ld	s2,32(sp)
    80002148:	69e2                	ld	s3,24(sp)
    8000214a:	6121                	addi	sp,sp,64
    8000214c:	8082                	ret
      release(&tickslock);
    8000214e:	00008517          	auipc	a0,0x8
    80002152:	14250513          	addi	a0,a0,322 # 8000a290 <tickslock>
    80002156:	00004097          	auipc	ra,0x4
    8000215a:	1d0080e7          	jalr	464(ra) # 80006326 <release>
      return -1;
    8000215e:	57fd                	li	a5,-1
    80002160:	bff9                	j	8000213e <sys_sleep+0x88>

0000000080002162 <sys_kill>:

uint64
sys_kill(void)
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000216a:	fec40593          	addi	a1,s0,-20
    8000216e:	4501                	li	a0,0
    80002170:	00000097          	auipc	ra,0x0
    80002174:	d84080e7          	jalr	-636(ra) # 80001ef4 <argint>
    80002178:	87aa                	mv	a5,a0
    return -1;
    8000217a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000217c:	0007c863          	bltz	a5,8000218c <sys_kill+0x2a>
  return kill(pid);
    80002180:	fec42503          	lw	a0,-20(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	6b2080e7          	jalr	1714(ra) # 80001836 <kill>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000219e:	00008517          	auipc	a0,0x8
    800021a2:	0f250513          	addi	a0,a0,242 # 8000a290 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	0cc080e7          	jalr	204(ra) # 80006272 <acquire>
  xticks = ticks;
    800021ae:	00007497          	auipc	s1,0x7
    800021b2:	e6a4a483          	lw	s1,-406(s1) # 80009018 <ticks>
  release(&tickslock);
    800021b6:	00008517          	auipc	a0,0x8
    800021ba:	0da50513          	addi	a0,a0,218 # 8000a290 <tickslock>
    800021be:	00004097          	auipc	ra,0x4
    800021c2:	168080e7          	jalr	360(ra) # 80006326 <release>
  return xticks;
}
    800021c6:	02049513          	slli	a0,s1,0x20
    800021ca:	9101                	srli	a0,a0,0x20
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	64a2                	ld	s1,8(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	e44e                	sd	s3,8(sp)
    800021e2:	e052                	sd	s4,0(sp)
    800021e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021e6:	00006597          	auipc	a1,0x6
    800021ea:	29a58593          	addi	a1,a1,666 # 80008480 <syscalls+0xb8>
    800021ee:	00008517          	auipc	a0,0x8
    800021f2:	0ba50513          	addi	a0,a0,186 # 8000a2a8 <bcache>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	fec080e7          	jalr	-20(ra) # 800061e2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021fe:	00010797          	auipc	a5,0x10
    80002202:	0aa78793          	addi	a5,a5,170 # 800122a8 <bcache+0x8000>
    80002206:	00010717          	auipc	a4,0x10
    8000220a:	30a70713          	addi	a4,a4,778 # 80012510 <bcache+0x8268>
    8000220e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002212:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002216:	00008497          	auipc	s1,0x8
    8000221a:	0aa48493          	addi	s1,s1,170 # 8000a2c0 <bcache+0x18>
    b->next = bcache.head.next;
    8000221e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002220:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002222:	00006a17          	auipc	s4,0x6
    80002226:	266a0a13          	addi	s4,s4,614 # 80008488 <syscalls+0xc0>
    b->next = bcache.head.next;
    8000222a:	2b893783          	ld	a5,696(s2)
    8000222e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002230:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002234:	85d2                	mv	a1,s4
    80002236:	01048513          	addi	a0,s1,16
    8000223a:	00001097          	auipc	ra,0x1
    8000223e:	584080e7          	jalr	1412(ra) # 800037be <initsleeplock>
    bcache.head.next->prev = b;
    80002242:	2b893783          	ld	a5,696(s2)
    80002246:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002248:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000224c:	45848493          	addi	s1,s1,1112
    80002250:	fd349de3          	bne	s1,s3,8000222a <binit+0x54>
  }
}
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6a02                	ld	s4,0(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret

0000000080002264 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	89aa                	mv	s3,a0
    80002274:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002276:	00008517          	auipc	a0,0x8
    8000227a:	03250513          	addi	a0,a0,50 # 8000a2a8 <bcache>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	ff4080e7          	jalr	-12(ra) # 80006272 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002286:	00010497          	auipc	s1,0x10
    8000228a:	2da4b483          	ld	s1,730(s1) # 80012560 <bcache+0x82b8>
    8000228e:	00010797          	auipc	a5,0x10
    80002292:	28278793          	addi	a5,a5,642 # 80012510 <bcache+0x8268>
    80002296:	02f48f63          	beq	s1,a5,800022d4 <bread+0x70>
    8000229a:	873e                	mv	a4,a5
    8000229c:	a021                	j	800022a4 <bread+0x40>
    8000229e:	68a4                	ld	s1,80(s1)
    800022a0:	02e48a63          	beq	s1,a4,800022d4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022a4:	449c                	lw	a5,8(s1)
    800022a6:	ff379ce3          	bne	a5,s3,8000229e <bread+0x3a>
    800022aa:	44dc                	lw	a5,12(s1)
    800022ac:	ff2799e3          	bne	a5,s2,8000229e <bread+0x3a>
      b->refcnt++;
    800022b0:	40bc                	lw	a5,64(s1)
    800022b2:	2785                	addiw	a5,a5,1
    800022b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022b6:	00008517          	auipc	a0,0x8
    800022ba:	ff250513          	addi	a0,a0,-14 # 8000a2a8 <bcache>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	068080e7          	jalr	104(ra) # 80006326 <release>
      acquiresleep(&b->lock);
    800022c6:	01048513          	addi	a0,s1,16
    800022ca:	00001097          	auipc	ra,0x1
    800022ce:	52e080e7          	jalr	1326(ra) # 800037f8 <acquiresleep>
      return b;
    800022d2:	a8b9                	j	80002330 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d4:	00010497          	auipc	s1,0x10
    800022d8:	2844b483          	ld	s1,644(s1) # 80012558 <bcache+0x82b0>
    800022dc:	00010797          	auipc	a5,0x10
    800022e0:	23478793          	addi	a5,a5,564 # 80012510 <bcache+0x8268>
    800022e4:	00f48863          	beq	s1,a5,800022f4 <bread+0x90>
    800022e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022ea:	40bc                	lw	a5,64(s1)
    800022ec:	cf81                	beqz	a5,80002304 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ee:	64a4                	ld	s1,72(s1)
    800022f0:	fee49de3          	bne	s1,a4,800022ea <bread+0x86>
  panic("bget: no buffers");
    800022f4:	00006517          	auipc	a0,0x6
    800022f8:	19c50513          	addi	a0,a0,412 # 80008490 <syscalls+0xc8>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	a2c080e7          	jalr	-1492(ra) # 80005d28 <panic>
      b->dev = dev;
    80002304:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002308:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000230c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002310:	4785                	li	a5,1
    80002312:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002314:	00008517          	auipc	a0,0x8
    80002318:	f9450513          	addi	a0,a0,-108 # 8000a2a8 <bcache>
    8000231c:	00004097          	auipc	ra,0x4
    80002320:	00a080e7          	jalr	10(ra) # 80006326 <release>
      acquiresleep(&b->lock);
    80002324:	01048513          	addi	a0,s1,16
    80002328:	00001097          	auipc	ra,0x1
    8000232c:	4d0080e7          	jalr	1232(ra) # 800037f8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002330:	409c                	lw	a5,0(s1)
    80002332:	cb89                	beqz	a5,80002344 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002334:	8526                	mv	a0,s1
    80002336:	70a2                	ld	ra,40(sp)
    80002338:	7402                	ld	s0,32(sp)
    8000233a:	64e2                	ld	s1,24(sp)
    8000233c:	6942                	ld	s2,16(sp)
    8000233e:	69a2                	ld	s3,8(sp)
    80002340:	6145                	addi	sp,sp,48
    80002342:	8082                	ret
    virtio_disk_rw(b, 0);
    80002344:	4581                	li	a1,0
    80002346:	8526                	mv	a0,s1
    80002348:	00003097          	auipc	ra,0x3
    8000234c:	11e080e7          	jalr	286(ra) # 80005466 <virtio_disk_rw>
    b->valid = 1;
    80002350:	4785                	li	a5,1
    80002352:	c09c                	sw	a5,0(s1)
  return b;
    80002354:	b7c5                	j	80002334 <bread+0xd0>

0000000080002356 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	1000                	addi	s0,sp,32
    80002360:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002362:	0541                	addi	a0,a0,16
    80002364:	00001097          	auipc	ra,0x1
    80002368:	52e080e7          	jalr	1326(ra) # 80003892 <holdingsleep>
    8000236c:	cd01                	beqz	a0,80002384 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000236e:	4585                	li	a1,1
    80002370:	8526                	mv	a0,s1
    80002372:	00003097          	auipc	ra,0x3
    80002376:	0f4080e7          	jalr	244(ra) # 80005466 <virtio_disk_rw>
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret
    panic("bwrite");
    80002384:	00006517          	auipc	a0,0x6
    80002388:	12450513          	addi	a0,a0,292 # 800084a8 <syscalls+0xe0>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	99c080e7          	jalr	-1636(ra) # 80005d28 <panic>

0000000080002394 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002394:	1101                	addi	sp,sp,-32
    80002396:	ec06                	sd	ra,24(sp)
    80002398:	e822                	sd	s0,16(sp)
    8000239a:	e426                	sd	s1,8(sp)
    8000239c:	e04a                	sd	s2,0(sp)
    8000239e:	1000                	addi	s0,sp,32
    800023a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a2:	01050913          	addi	s2,a0,16
    800023a6:	854a                	mv	a0,s2
    800023a8:	00001097          	auipc	ra,0x1
    800023ac:	4ea080e7          	jalr	1258(ra) # 80003892 <holdingsleep>
    800023b0:	c92d                	beqz	a0,80002422 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023b2:	854a                	mv	a0,s2
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	49a080e7          	jalr	1178(ra) # 8000384e <releasesleep>

  acquire(&bcache.lock);
    800023bc:	00008517          	auipc	a0,0x8
    800023c0:	eec50513          	addi	a0,a0,-276 # 8000a2a8 <bcache>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	eae080e7          	jalr	-338(ra) # 80006272 <acquire>
  b->refcnt--;
    800023cc:	40bc                	lw	a5,64(s1)
    800023ce:	37fd                	addiw	a5,a5,-1
    800023d0:	0007871b          	sext.w	a4,a5
    800023d4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023d6:	eb05                	bnez	a4,80002406 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023d8:	68bc                	ld	a5,80(s1)
    800023da:	64b8                	ld	a4,72(s1)
    800023dc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023de:	64bc                	ld	a5,72(s1)
    800023e0:	68b8                	ld	a4,80(s1)
    800023e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023e4:	00010797          	auipc	a5,0x10
    800023e8:	ec478793          	addi	a5,a5,-316 # 800122a8 <bcache+0x8000>
    800023ec:	2b87b703          	ld	a4,696(a5)
    800023f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023f2:	00010717          	auipc	a4,0x10
    800023f6:	11e70713          	addi	a4,a4,286 # 80012510 <bcache+0x8268>
    800023fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023fc:	2b87b703          	ld	a4,696(a5)
    80002400:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002402:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002406:	00008517          	auipc	a0,0x8
    8000240a:	ea250513          	addi	a0,a0,-350 # 8000a2a8 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	f18080e7          	jalr	-232(ra) # 80006326 <release>
}
    80002416:	60e2                	ld	ra,24(sp)
    80002418:	6442                	ld	s0,16(sp)
    8000241a:	64a2                	ld	s1,8(sp)
    8000241c:	6902                	ld	s2,0(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret
    panic("brelse");
    80002422:	00006517          	auipc	a0,0x6
    80002426:	08e50513          	addi	a0,a0,142 # 800084b0 <syscalls+0xe8>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	8fe080e7          	jalr	-1794(ra) # 80005d28 <panic>

0000000080002432 <bpin>:

void
bpin(struct buf *b) {
    80002432:	1101                	addi	sp,sp,-32
    80002434:	ec06                	sd	ra,24(sp)
    80002436:	e822                	sd	s0,16(sp)
    80002438:	e426                	sd	s1,8(sp)
    8000243a:	1000                	addi	s0,sp,32
    8000243c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243e:	00008517          	auipc	a0,0x8
    80002442:	e6a50513          	addi	a0,a0,-406 # 8000a2a8 <bcache>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	e2c080e7          	jalr	-468(ra) # 80006272 <acquire>
  b->refcnt++;
    8000244e:	40bc                	lw	a5,64(s1)
    80002450:	2785                	addiw	a5,a5,1
    80002452:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002454:	00008517          	auipc	a0,0x8
    80002458:	e5450513          	addi	a0,a0,-428 # 8000a2a8 <bcache>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	eca080e7          	jalr	-310(ra) # 80006326 <release>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <bunpin>:

void
bunpin(struct buf *b) {
    8000246e:	1101                	addi	sp,sp,-32
    80002470:	ec06                	sd	ra,24(sp)
    80002472:	e822                	sd	s0,16(sp)
    80002474:	e426                	sd	s1,8(sp)
    80002476:	1000                	addi	s0,sp,32
    80002478:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000247a:	00008517          	auipc	a0,0x8
    8000247e:	e2e50513          	addi	a0,a0,-466 # 8000a2a8 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	df0080e7          	jalr	-528(ra) # 80006272 <acquire>
  b->refcnt--;
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	37fd                	addiw	a5,a5,-1
    8000248e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002490:	00008517          	auipc	a0,0x8
    80002494:	e1850513          	addi	a0,a0,-488 # 8000a2a8 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	e8e080e7          	jalr	-370(ra) # 80006326 <release>
}
    800024a0:	60e2                	ld	ra,24(sp)
    800024a2:	6442                	ld	s0,16(sp)
    800024a4:	64a2                	ld	s1,8(sp)
    800024a6:	6105                	addi	sp,sp,32
    800024a8:	8082                	ret

00000000800024aa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	e04a                	sd	s2,0(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b8:	00d5d59b          	srliw	a1,a1,0xd
    800024bc:	00010797          	auipc	a5,0x10
    800024c0:	4c87a783          	lw	a5,1224(a5) # 80012984 <sb+0x1c>
    800024c4:	9dbd                	addw	a1,a1,a5
    800024c6:	00000097          	auipc	ra,0x0
    800024ca:	d9e080e7          	jalr	-610(ra) # 80002264 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ce:	0074f713          	andi	a4,s1,7
    800024d2:	4785                	li	a5,1
    800024d4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d8:	14ce                	slli	s1,s1,0x33
    800024da:	90d9                	srli	s1,s1,0x36
    800024dc:	00950733          	add	a4,a0,s1
    800024e0:	05874703          	lbu	a4,88(a4)
    800024e4:	00e7f6b3          	and	a3,a5,a4
    800024e8:	c69d                	beqz	a3,80002516 <bfree+0x6c>
    800024ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024ec:	94aa                	add	s1,s1,a0
    800024ee:	fff7c793          	not	a5,a5
    800024f2:	8ff9                	and	a5,a5,a4
    800024f4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	1e0080e7          	jalr	480(ra) # 800036d8 <log_write>
  brelse(bp);
    80002500:	854a                	mv	a0,s2
    80002502:	00000097          	auipc	ra,0x0
    80002506:	e92080e7          	jalr	-366(ra) # 80002394 <brelse>
}
    8000250a:	60e2                	ld	ra,24(sp)
    8000250c:	6442                	ld	s0,16(sp)
    8000250e:	64a2                	ld	s1,8(sp)
    80002510:	6902                	ld	s2,0(sp)
    80002512:	6105                	addi	sp,sp,32
    80002514:	8082                	ret
    panic("freeing free block");
    80002516:	00006517          	auipc	a0,0x6
    8000251a:	fa250513          	addi	a0,a0,-94 # 800084b8 <syscalls+0xf0>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	80a080e7          	jalr	-2038(ra) # 80005d28 <panic>

0000000080002526 <balloc>:
{
    80002526:	711d                	addi	sp,sp,-96
    80002528:	ec86                	sd	ra,88(sp)
    8000252a:	e8a2                	sd	s0,80(sp)
    8000252c:	e4a6                	sd	s1,72(sp)
    8000252e:	e0ca                	sd	s2,64(sp)
    80002530:	fc4e                	sd	s3,56(sp)
    80002532:	f852                	sd	s4,48(sp)
    80002534:	f456                	sd	s5,40(sp)
    80002536:	f05a                	sd	s6,32(sp)
    80002538:	ec5e                	sd	s7,24(sp)
    8000253a:	e862                	sd	s8,16(sp)
    8000253c:	e466                	sd	s9,8(sp)
    8000253e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002540:	00010797          	auipc	a5,0x10
    80002544:	42c7a783          	lw	a5,1068(a5) # 8001296c <sb+0x4>
    80002548:	cbd1                	beqz	a5,800025dc <balloc+0xb6>
    8000254a:	8baa                	mv	s7,a0
    8000254c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000254e:	00010b17          	auipc	s6,0x10
    80002552:	41ab0b13          	addi	s6,s6,1050 # 80012968 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002556:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002558:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000255a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000255c:	6c89                	lui	s9,0x2
    8000255e:	a831                	j	8000257a <balloc+0x54>
    brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e32080e7          	jalr	-462(ra) # 80002394 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000256a:	015c87bb          	addw	a5,s9,s5
    8000256e:	00078a9b          	sext.w	s5,a5
    80002572:	004b2703          	lw	a4,4(s6)
    80002576:	06eaf363          	bgeu	s5,a4,800025dc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000257a:	41fad79b          	sraiw	a5,s5,0x1f
    8000257e:	0137d79b          	srliw	a5,a5,0x13
    80002582:	015787bb          	addw	a5,a5,s5
    80002586:	40d7d79b          	sraiw	a5,a5,0xd
    8000258a:	01cb2583          	lw	a1,28(s6)
    8000258e:	9dbd                	addw	a1,a1,a5
    80002590:	855e                	mv	a0,s7
    80002592:	00000097          	auipc	ra,0x0
    80002596:	cd2080e7          	jalr	-814(ra) # 80002264 <bread>
    8000259a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000259c:	004b2503          	lw	a0,4(s6)
    800025a0:	000a849b          	sext.w	s1,s5
    800025a4:	8662                	mv	a2,s8
    800025a6:	faa4fde3          	bgeu	s1,a0,80002560 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025aa:	41f6579b          	sraiw	a5,a2,0x1f
    800025ae:	01d7d69b          	srliw	a3,a5,0x1d
    800025b2:	00c6873b          	addw	a4,a3,a2
    800025b6:	00777793          	andi	a5,a4,7
    800025ba:	9f95                	subw	a5,a5,a3
    800025bc:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025c0:	4037571b          	sraiw	a4,a4,0x3
    800025c4:	00e906b3          	add	a3,s2,a4
    800025c8:	0586c683          	lbu	a3,88(a3)
    800025cc:	00d7f5b3          	and	a1,a5,a3
    800025d0:	cd91                	beqz	a1,800025ec <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d2:	2605                	addiw	a2,a2,1
    800025d4:	2485                	addiw	s1,s1,1
    800025d6:	fd4618e3          	bne	a2,s4,800025a6 <balloc+0x80>
    800025da:	b759                	j	80002560 <balloc+0x3a>
  panic("balloc: out of blocks");
    800025dc:	00006517          	auipc	a0,0x6
    800025e0:	ef450513          	addi	a0,a0,-268 # 800084d0 <syscalls+0x108>
    800025e4:	00003097          	auipc	ra,0x3
    800025e8:	744080e7          	jalr	1860(ra) # 80005d28 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025ec:	974a                	add	a4,a4,s2
    800025ee:	8fd5                	or	a5,a5,a3
    800025f0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	0e2080e7          	jalr	226(ra) # 800036d8 <log_write>
        brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00000097          	auipc	ra,0x0
    80002604:	d94080e7          	jalr	-620(ra) # 80002394 <brelse>
  bp = bread(dev, bno);
    80002608:	85a6                	mv	a1,s1
    8000260a:	855e                	mv	a0,s7
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	c58080e7          	jalr	-936(ra) # 80002264 <bread>
    80002614:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002616:	40000613          	li	a2,1024
    8000261a:	4581                	li	a1,0
    8000261c:	05850513          	addi	a0,a0,88
    80002620:	ffffe097          	auipc	ra,0xffffe
    80002624:	b58080e7          	jalr	-1192(ra) # 80000178 <memset>
  log_write(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	0ae080e7          	jalr	174(ra) # 800036d8 <log_write>
  brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	d60080e7          	jalr	-672(ra) # 80002394 <brelse>
}
    8000263c:	8526                	mv	a0,s1
    8000263e:	60e6                	ld	ra,88(sp)
    80002640:	6446                	ld	s0,80(sp)
    80002642:	64a6                	ld	s1,72(sp)
    80002644:	6906                	ld	s2,64(sp)
    80002646:	79e2                	ld	s3,56(sp)
    80002648:	7a42                	ld	s4,48(sp)
    8000264a:	7aa2                	ld	s5,40(sp)
    8000264c:	7b02                	ld	s6,32(sp)
    8000264e:	6be2                	ld	s7,24(sp)
    80002650:	6c42                	ld	s8,16(sp)
    80002652:	6ca2                	ld	s9,8(sp)
    80002654:	6125                	addi	sp,sp,96
    80002656:	8082                	ret

0000000080002658 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002658:	7139                	addi	sp,sp,-64
    8000265a:	fc06                	sd	ra,56(sp)
    8000265c:	f822                	sd	s0,48(sp)
    8000265e:	f426                	sd	s1,40(sp)
    80002660:	f04a                	sd	s2,32(sp)
    80002662:	ec4e                	sd	s3,24(sp)
    80002664:	e852                	sd	s4,16(sp)
    80002666:	e456                	sd	s5,8(sp)
    80002668:	0080                	addi	s0,sp,64
    8000266a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000266c:	47a9                	li	a5,10
    8000266e:	08b7fd63          	bgeu	a5,a1,80002708 <bmap+0xb0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002672:	ff55849b          	addiw	s1,a1,-11
    80002676:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000267a:	0ff00793          	li	a5,255
    8000267e:	0ae7f863          	bgeu	a5,a4,8000272e <bmap+0xd6>
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }
  bn -= NINDIRECT;
    80002682:	ef55849b          	addiw	s1,a1,-267
    80002686:	0004871b          	sext.w	a4,s1

  if(bn < NDOUBLEINDIRECT){
    8000268a:	67c1                	lui	a5,0x10
    8000268c:	14f77e63          	bgeu	a4,a5,800027e8 <bmap+0x190>
    // load doubly-indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT+1]) == 0){
    80002690:	08052583          	lw	a1,128(a0)
    80002694:	10058063          	beqz	a1,80002794 <bmap+0x13c>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
    80002698:	0009a503          	lw	a0,0(s3)
    8000269c:	00000097          	auipc	ra,0x0
    800026a0:	bc8080e7          	jalr	-1080(ra) # 80002264 <bread>
    800026a4:	892a                	mv	s2,a0
    a = (uint*)bp->data;
    800026a6:	05850a13          	addi	s4,a0,88
    if((addr = a[bn/NINDIRECT]) == 0){
    800026aa:	0084d79b          	srliw	a5,s1,0x8
    800026ae:	078a                	slli	a5,a5,0x2
    800026b0:	9a3e                	add	s4,s4,a5
    800026b2:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800026b6:	0e0a8963          	beqz	s5,800027a8 <bmap+0x150>
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	cd8080e7          	jalr	-808(ra) # 80002394 <brelse>
    bp = bread(ip->dev, addr);
    800026c4:	85d6                	mv	a1,s5
    800026c6:	0009a503          	lw	a0,0(s3)
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	b9a080e7          	jalr	-1126(ra) # 80002264 <bread>
    800026d2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026d4:	05850793          	addi	a5,a0,88
    if((addr = a[bn%NINDIRECT]) == 0){
    800026d8:	0ff4f593          	andi	a1,s1,255
    800026dc:	058a                	slli	a1,a1,0x2
    800026de:	00b784b3          	add	s1,a5,a1
    800026e2:	0004a903          	lw	s2,0(s1)
    800026e6:	0e090163          	beqz	s2,800027c8 <bmap+0x170>
      a[bn%NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ea:	8552                	mv	a0,s4
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	ca8080e7          	jalr	-856(ra) # 80002394 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026f4:	854a                	mv	a0,s2
    800026f6:	70e2                	ld	ra,56(sp)
    800026f8:	7442                	ld	s0,48(sp)
    800026fa:	74a2                	ld	s1,40(sp)
    800026fc:	7902                	ld	s2,32(sp)
    800026fe:	69e2                	ld	s3,24(sp)
    80002700:	6a42                	ld	s4,16(sp)
    80002702:	6aa2                	ld	s5,8(sp)
    80002704:	6121                	addi	sp,sp,64
    80002706:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002708:	02059493          	slli	s1,a1,0x20
    8000270c:	9081                	srli	s1,s1,0x20
    8000270e:	048a                	slli	s1,s1,0x2
    80002710:	94aa                	add	s1,s1,a0
    80002712:	0504a903          	lw	s2,80(s1)
    80002716:	fc091fe3          	bnez	s2,800026f4 <bmap+0x9c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000271a:	4108                	lw	a0,0(a0)
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	e0a080e7          	jalr	-502(ra) # 80002526 <balloc>
    80002724:	0005091b          	sext.w	s2,a0
    80002728:	0524a823          	sw	s2,80(s1)
    8000272c:	b7e1                	j	800026f4 <bmap+0x9c>
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000272e:	5d6c                	lw	a1,124(a0)
    80002730:	c985                	beqz	a1,80002760 <bmap+0x108>
    bp = bread(ip->dev, addr);
    80002732:	0009a503          	lw	a0,0(s3)
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	b2e080e7          	jalr	-1234(ra) # 80002264 <bread>
    8000273e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002740:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002744:	1482                	slli	s1,s1,0x20
    80002746:	9081                	srli	s1,s1,0x20
    80002748:	048a                	slli	s1,s1,0x2
    8000274a:	94be                	add	s1,s1,a5
    8000274c:	0004a903          	lw	s2,0(s1)
    80002750:	02090263          	beqz	s2,80002774 <bmap+0x11c>
    brelse(bp);
    80002754:	8552                	mv	a0,s4
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	c3e080e7          	jalr	-962(ra) # 80002394 <brelse>
    return addr;
    8000275e:	bf59                	j	800026f4 <bmap+0x9c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002760:	4108                	lw	a0,0(a0)
    80002762:	00000097          	auipc	ra,0x0
    80002766:	dc4080e7          	jalr	-572(ra) # 80002526 <balloc>
    8000276a:	0005059b          	sext.w	a1,a0
    8000276e:	06b9ae23          	sw	a1,124(s3)
    80002772:	b7c1                	j	80002732 <bmap+0xda>
      a[bn] = addr = balloc(ip->dev);
    80002774:	0009a503          	lw	a0,0(s3)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	dae080e7          	jalr	-594(ra) # 80002526 <balloc>
    80002780:	0005091b          	sext.w	s2,a0
    80002784:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    80002788:	8552                	mv	a0,s4
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	f4e080e7          	jalr	-178(ra) # 800036d8 <log_write>
    80002792:	b7c9                	j	80002754 <bmap+0xfc>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    80002794:	4108                	lw	a0,0(a0)
    80002796:	00000097          	auipc	ra,0x0
    8000279a:	d90080e7          	jalr	-624(ra) # 80002526 <balloc>
    8000279e:	0005059b          	sext.w	a1,a0
    800027a2:	08b9a023          	sw	a1,128(s3)
    800027a6:	bdcd                	j	80002698 <bmap+0x40>
      a[bn/NINDIRECT] = addr = balloc(ip->dev);
    800027a8:	0009a503          	lw	a0,0(s3)
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	d7a080e7          	jalr	-646(ra) # 80002526 <balloc>
    800027b4:	00050a9b          	sext.w	s5,a0
    800027b8:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    800027bc:	854a                	mv	a0,s2
    800027be:	00001097          	auipc	ra,0x1
    800027c2:	f1a080e7          	jalr	-230(ra) # 800036d8 <log_write>
    800027c6:	bdd5                	j	800026ba <bmap+0x62>
      a[bn%NINDIRECT] = addr = balloc(ip->dev);
    800027c8:	0009a503          	lw	a0,0(s3)
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	d5a080e7          	jalr	-678(ra) # 80002526 <balloc>
    800027d4:	0005091b          	sext.w	s2,a0
    800027d8:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    800027dc:	8552                	mv	a0,s4
    800027de:	00001097          	auipc	ra,0x1
    800027e2:	efa080e7          	jalr	-262(ra) # 800036d8 <log_write>
    800027e6:	b711                	j	800026ea <bmap+0x92>
  panic("bmap: out of range");
    800027e8:	00006517          	auipc	a0,0x6
    800027ec:	d0050513          	addi	a0,a0,-768 # 800084e8 <syscalls+0x120>
    800027f0:	00003097          	auipc	ra,0x3
    800027f4:	538080e7          	jalr	1336(ra) # 80005d28 <panic>

00000000800027f8 <iget>:
{
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	e052                	sd	s4,0(sp)
    80002806:	1800                	addi	s0,sp,48
    80002808:	89aa                	mv	s3,a0
    8000280a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000280c:	00010517          	auipc	a0,0x10
    80002810:	17c50513          	addi	a0,a0,380 # 80012988 <itable>
    80002814:	00004097          	auipc	ra,0x4
    80002818:	a5e080e7          	jalr	-1442(ra) # 80006272 <acquire>
  empty = 0;
    8000281c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000281e:	00010497          	auipc	s1,0x10
    80002822:	18248493          	addi	s1,s1,386 # 800129a0 <itable+0x18>
    80002826:	00012697          	auipc	a3,0x12
    8000282a:	c0a68693          	addi	a3,a3,-1014 # 80014430 <log>
    8000282e:	a039                	j	8000283c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002830:	02090b63          	beqz	s2,80002866 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002834:	08848493          	addi	s1,s1,136
    80002838:	02d48a63          	beq	s1,a3,8000286c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000283c:	449c                	lw	a5,8(s1)
    8000283e:	fef059e3          	blez	a5,80002830 <iget+0x38>
    80002842:	4098                	lw	a4,0(s1)
    80002844:	ff3716e3          	bne	a4,s3,80002830 <iget+0x38>
    80002848:	40d8                	lw	a4,4(s1)
    8000284a:	ff4713e3          	bne	a4,s4,80002830 <iget+0x38>
      ip->ref++;
    8000284e:	2785                	addiw	a5,a5,1
    80002850:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002852:	00010517          	auipc	a0,0x10
    80002856:	13650513          	addi	a0,a0,310 # 80012988 <itable>
    8000285a:	00004097          	auipc	ra,0x4
    8000285e:	acc080e7          	jalr	-1332(ra) # 80006326 <release>
      return ip;
    80002862:	8926                	mv	s2,s1
    80002864:	a03d                	j	80002892 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002866:	f7f9                	bnez	a5,80002834 <iget+0x3c>
    80002868:	8926                	mv	s2,s1
    8000286a:	b7e9                	j	80002834 <iget+0x3c>
  if(empty == 0)
    8000286c:	02090c63          	beqz	s2,800028a4 <iget+0xac>
  ip->dev = dev;
    80002870:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002874:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002878:	4785                	li	a5,1
    8000287a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000287e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002882:	00010517          	auipc	a0,0x10
    80002886:	10650513          	addi	a0,a0,262 # 80012988 <itable>
    8000288a:	00004097          	auipc	ra,0x4
    8000288e:	a9c080e7          	jalr	-1380(ra) # 80006326 <release>
}
    80002892:	854a                	mv	a0,s2
    80002894:	70a2                	ld	ra,40(sp)
    80002896:	7402                	ld	s0,32(sp)
    80002898:	64e2                	ld	s1,24(sp)
    8000289a:	6942                	ld	s2,16(sp)
    8000289c:	69a2                	ld	s3,8(sp)
    8000289e:	6a02                	ld	s4,0(sp)
    800028a0:	6145                	addi	sp,sp,48
    800028a2:	8082                	ret
    panic("iget: no inodes");
    800028a4:	00006517          	auipc	a0,0x6
    800028a8:	c5c50513          	addi	a0,a0,-932 # 80008500 <syscalls+0x138>
    800028ac:	00003097          	auipc	ra,0x3
    800028b0:	47c080e7          	jalr	1148(ra) # 80005d28 <panic>

00000000800028b4 <fsinit>:
fsinit(int dev) {
    800028b4:	7179                	addi	sp,sp,-48
    800028b6:	f406                	sd	ra,40(sp)
    800028b8:	f022                	sd	s0,32(sp)
    800028ba:	ec26                	sd	s1,24(sp)
    800028bc:	e84a                	sd	s2,16(sp)
    800028be:	e44e                	sd	s3,8(sp)
    800028c0:	1800                	addi	s0,sp,48
    800028c2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028c4:	4585                	li	a1,1
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	99e080e7          	jalr	-1634(ra) # 80002264 <bread>
    800028ce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028d0:	00010997          	auipc	s3,0x10
    800028d4:	09898993          	addi	s3,s3,152 # 80012968 <sb>
    800028d8:	02000613          	li	a2,32
    800028dc:	05850593          	addi	a1,a0,88
    800028e0:	854e                	mv	a0,s3
    800028e2:	ffffe097          	auipc	ra,0xffffe
    800028e6:	8f6080e7          	jalr	-1802(ra) # 800001d8 <memmove>
  brelse(bp);
    800028ea:	8526                	mv	a0,s1
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	aa8080e7          	jalr	-1368(ra) # 80002394 <brelse>
  if(sb.magic != FSMAGIC)
    800028f4:	0009a703          	lw	a4,0(s3)
    800028f8:	102037b7          	lui	a5,0x10203
    800028fc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002900:	02f71263          	bne	a4,a5,80002924 <fsinit+0x70>
  initlog(dev, &sb);
    80002904:	00010597          	auipc	a1,0x10
    80002908:	06458593          	addi	a1,a1,100 # 80012968 <sb>
    8000290c:	854a                	mv	a0,s2
    8000290e:	00001097          	auipc	ra,0x1
    80002912:	b4e080e7          	jalr	-1202(ra) # 8000345c <initlog>
}
    80002916:	70a2                	ld	ra,40(sp)
    80002918:	7402                	ld	s0,32(sp)
    8000291a:	64e2                	ld	s1,24(sp)
    8000291c:	6942                	ld	s2,16(sp)
    8000291e:	69a2                	ld	s3,8(sp)
    80002920:	6145                	addi	sp,sp,48
    80002922:	8082                	ret
    panic("invalid file system");
    80002924:	00006517          	auipc	a0,0x6
    80002928:	bec50513          	addi	a0,a0,-1044 # 80008510 <syscalls+0x148>
    8000292c:	00003097          	auipc	ra,0x3
    80002930:	3fc080e7          	jalr	1020(ra) # 80005d28 <panic>

0000000080002934 <iinit>:
{
    80002934:	7179                	addi	sp,sp,-48
    80002936:	f406                	sd	ra,40(sp)
    80002938:	f022                	sd	s0,32(sp)
    8000293a:	ec26                	sd	s1,24(sp)
    8000293c:	e84a                	sd	s2,16(sp)
    8000293e:	e44e                	sd	s3,8(sp)
    80002940:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002942:	00006597          	auipc	a1,0x6
    80002946:	be658593          	addi	a1,a1,-1050 # 80008528 <syscalls+0x160>
    8000294a:	00010517          	auipc	a0,0x10
    8000294e:	03e50513          	addi	a0,a0,62 # 80012988 <itable>
    80002952:	00004097          	auipc	ra,0x4
    80002956:	890080e7          	jalr	-1904(ra) # 800061e2 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000295a:	00010497          	auipc	s1,0x10
    8000295e:	05648493          	addi	s1,s1,86 # 800129b0 <itable+0x28>
    80002962:	00012997          	auipc	s3,0x12
    80002966:	ade98993          	addi	s3,s3,-1314 # 80014440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000296a:	00006917          	auipc	s2,0x6
    8000296e:	bc690913          	addi	s2,s2,-1082 # 80008530 <syscalls+0x168>
    80002972:	85ca                	mv	a1,s2
    80002974:	8526                	mv	a0,s1
    80002976:	00001097          	auipc	ra,0x1
    8000297a:	e48080e7          	jalr	-440(ra) # 800037be <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000297e:	08848493          	addi	s1,s1,136
    80002982:	ff3498e3          	bne	s1,s3,80002972 <iinit+0x3e>
}
    80002986:	70a2                	ld	ra,40(sp)
    80002988:	7402                	ld	s0,32(sp)
    8000298a:	64e2                	ld	s1,24(sp)
    8000298c:	6942                	ld	s2,16(sp)
    8000298e:	69a2                	ld	s3,8(sp)
    80002990:	6145                	addi	sp,sp,48
    80002992:	8082                	ret

0000000080002994 <ialloc>:
{
    80002994:	715d                	addi	sp,sp,-80
    80002996:	e486                	sd	ra,72(sp)
    80002998:	e0a2                	sd	s0,64(sp)
    8000299a:	fc26                	sd	s1,56(sp)
    8000299c:	f84a                	sd	s2,48(sp)
    8000299e:	f44e                	sd	s3,40(sp)
    800029a0:	f052                	sd	s4,32(sp)
    800029a2:	ec56                	sd	s5,24(sp)
    800029a4:	e85a                	sd	s6,16(sp)
    800029a6:	e45e                	sd	s7,8(sp)
    800029a8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029aa:	00010717          	auipc	a4,0x10
    800029ae:	fca72703          	lw	a4,-54(a4) # 80012974 <sb+0xc>
    800029b2:	4785                	li	a5,1
    800029b4:	04e7fa63          	bgeu	a5,a4,80002a08 <ialloc+0x74>
    800029b8:	8aaa                	mv	s5,a0
    800029ba:	8bae                	mv	s7,a1
    800029bc:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029be:	00010a17          	auipc	s4,0x10
    800029c2:	faaa0a13          	addi	s4,s4,-86 # 80012968 <sb>
    800029c6:	00048b1b          	sext.w	s6,s1
    800029ca:	0044d593          	srli	a1,s1,0x4
    800029ce:	018a2783          	lw	a5,24(s4)
    800029d2:	9dbd                	addw	a1,a1,a5
    800029d4:	8556                	mv	a0,s5
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	88e080e7          	jalr	-1906(ra) # 80002264 <bread>
    800029de:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029e0:	05850993          	addi	s3,a0,88
    800029e4:	00f4f793          	andi	a5,s1,15
    800029e8:	079a                	slli	a5,a5,0x6
    800029ea:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029ec:	00099783          	lh	a5,0(s3)
    800029f0:	c785                	beqz	a5,80002a18 <ialloc+0x84>
    brelse(bp);
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	9a2080e7          	jalr	-1630(ra) # 80002394 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029fa:	0485                	addi	s1,s1,1
    800029fc:	00ca2703          	lw	a4,12(s4)
    80002a00:	0004879b          	sext.w	a5,s1
    80002a04:	fce7e1e3          	bltu	a5,a4,800029c6 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a08:	00006517          	auipc	a0,0x6
    80002a0c:	b3050513          	addi	a0,a0,-1232 # 80008538 <syscalls+0x170>
    80002a10:	00003097          	auipc	ra,0x3
    80002a14:	318080e7          	jalr	792(ra) # 80005d28 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a18:	04000613          	li	a2,64
    80002a1c:	4581                	li	a1,0
    80002a1e:	854e                	mv	a0,s3
    80002a20:	ffffd097          	auipc	ra,0xffffd
    80002a24:	758080e7          	jalr	1880(ra) # 80000178 <memset>
      dip->type = type;
    80002a28:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a2c:	854a                	mv	a0,s2
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	caa080e7          	jalr	-854(ra) # 800036d8 <log_write>
      brelse(bp);
    80002a36:	854a                	mv	a0,s2
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	95c080e7          	jalr	-1700(ra) # 80002394 <brelse>
      return iget(dev, inum);
    80002a40:	85da                	mv	a1,s6
    80002a42:	8556                	mv	a0,s5
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	db4080e7          	jalr	-588(ra) # 800027f8 <iget>
}
    80002a4c:	60a6                	ld	ra,72(sp)
    80002a4e:	6406                	ld	s0,64(sp)
    80002a50:	74e2                	ld	s1,56(sp)
    80002a52:	7942                	ld	s2,48(sp)
    80002a54:	79a2                	ld	s3,40(sp)
    80002a56:	7a02                	ld	s4,32(sp)
    80002a58:	6ae2                	ld	s5,24(sp)
    80002a5a:	6b42                	ld	s6,16(sp)
    80002a5c:	6ba2                	ld	s7,8(sp)
    80002a5e:	6161                	addi	sp,sp,80
    80002a60:	8082                	ret

0000000080002a62 <iupdate>:
{
    80002a62:	1101                	addi	sp,sp,-32
    80002a64:	ec06                	sd	ra,24(sp)
    80002a66:	e822                	sd	s0,16(sp)
    80002a68:	e426                	sd	s1,8(sp)
    80002a6a:	e04a                	sd	s2,0(sp)
    80002a6c:	1000                	addi	s0,sp,32
    80002a6e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a70:	415c                	lw	a5,4(a0)
    80002a72:	0047d79b          	srliw	a5,a5,0x4
    80002a76:	00010597          	auipc	a1,0x10
    80002a7a:	f0a5a583          	lw	a1,-246(a1) # 80012980 <sb+0x18>
    80002a7e:	9dbd                	addw	a1,a1,a5
    80002a80:	4108                	lw	a0,0(a0)
    80002a82:	fffff097          	auipc	ra,0xfffff
    80002a86:	7e2080e7          	jalr	2018(ra) # 80002264 <bread>
    80002a8a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a8c:	05850793          	addi	a5,a0,88
    80002a90:	40c8                	lw	a0,4(s1)
    80002a92:	893d                	andi	a0,a0,15
    80002a94:	051a                	slli	a0,a0,0x6
    80002a96:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a98:	04449703          	lh	a4,68(s1)
    80002a9c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002aa0:	04649703          	lh	a4,70(s1)
    80002aa4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002aa8:	04849703          	lh	a4,72(s1)
    80002aac:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ab0:	04a49703          	lh	a4,74(s1)
    80002ab4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ab8:	44f8                	lw	a4,76(s1)
    80002aba:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002abc:	03400613          	li	a2,52
    80002ac0:	05048593          	addi	a1,s1,80
    80002ac4:	0531                	addi	a0,a0,12
    80002ac6:	ffffd097          	auipc	ra,0xffffd
    80002aca:	712080e7          	jalr	1810(ra) # 800001d8 <memmove>
  log_write(bp);
    80002ace:	854a                	mv	a0,s2
    80002ad0:	00001097          	auipc	ra,0x1
    80002ad4:	c08080e7          	jalr	-1016(ra) # 800036d8 <log_write>
  brelse(bp);
    80002ad8:	854a                	mv	a0,s2
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	8ba080e7          	jalr	-1862(ra) # 80002394 <brelse>
}
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6902                	ld	s2,0(sp)
    80002aea:	6105                	addi	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <idup>:
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	e426                	sd	s1,8(sp)
    80002af6:	1000                	addi	s0,sp,32
    80002af8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002afa:	00010517          	auipc	a0,0x10
    80002afe:	e8e50513          	addi	a0,a0,-370 # 80012988 <itable>
    80002b02:	00003097          	auipc	ra,0x3
    80002b06:	770080e7          	jalr	1904(ra) # 80006272 <acquire>
  ip->ref++;
    80002b0a:	449c                	lw	a5,8(s1)
    80002b0c:	2785                	addiw	a5,a5,1
    80002b0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b10:	00010517          	auipc	a0,0x10
    80002b14:	e7850513          	addi	a0,a0,-392 # 80012988 <itable>
    80002b18:	00004097          	auipc	ra,0x4
    80002b1c:	80e080e7          	jalr	-2034(ra) # 80006326 <release>
}
    80002b20:	8526                	mv	a0,s1
    80002b22:	60e2                	ld	ra,24(sp)
    80002b24:	6442                	ld	s0,16(sp)
    80002b26:	64a2                	ld	s1,8(sp)
    80002b28:	6105                	addi	sp,sp,32
    80002b2a:	8082                	ret

0000000080002b2c <ilock>:
{
    80002b2c:	1101                	addi	sp,sp,-32
    80002b2e:	ec06                	sd	ra,24(sp)
    80002b30:	e822                	sd	s0,16(sp)
    80002b32:	e426                	sd	s1,8(sp)
    80002b34:	e04a                	sd	s2,0(sp)
    80002b36:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b38:	c115                	beqz	a0,80002b5c <ilock+0x30>
    80002b3a:	84aa                	mv	s1,a0
    80002b3c:	451c                	lw	a5,8(a0)
    80002b3e:	00f05f63          	blez	a5,80002b5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b42:	0541                	addi	a0,a0,16
    80002b44:	00001097          	auipc	ra,0x1
    80002b48:	cb4080e7          	jalr	-844(ra) # 800037f8 <acquiresleep>
  if(ip->valid == 0){
    80002b4c:	40bc                	lw	a5,64(s1)
    80002b4e:	cf99                	beqz	a5,80002b6c <ilock+0x40>
}
    80002b50:	60e2                	ld	ra,24(sp)
    80002b52:	6442                	ld	s0,16(sp)
    80002b54:	64a2                	ld	s1,8(sp)
    80002b56:	6902                	ld	s2,0(sp)
    80002b58:	6105                	addi	sp,sp,32
    80002b5a:	8082                	ret
    panic("ilock");
    80002b5c:	00006517          	auipc	a0,0x6
    80002b60:	9f450513          	addi	a0,a0,-1548 # 80008550 <syscalls+0x188>
    80002b64:	00003097          	auipc	ra,0x3
    80002b68:	1c4080e7          	jalr	452(ra) # 80005d28 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b6c:	40dc                	lw	a5,4(s1)
    80002b6e:	0047d79b          	srliw	a5,a5,0x4
    80002b72:	00010597          	auipc	a1,0x10
    80002b76:	e0e5a583          	lw	a1,-498(a1) # 80012980 <sb+0x18>
    80002b7a:	9dbd                	addw	a1,a1,a5
    80002b7c:	4088                	lw	a0,0(s1)
    80002b7e:	fffff097          	auipc	ra,0xfffff
    80002b82:	6e6080e7          	jalr	1766(ra) # 80002264 <bread>
    80002b86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b88:	05850593          	addi	a1,a0,88
    80002b8c:	40dc                	lw	a5,4(s1)
    80002b8e:	8bbd                	andi	a5,a5,15
    80002b90:	079a                	slli	a5,a5,0x6
    80002b92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b94:	00059783          	lh	a5,0(a1)
    80002b98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b9c:	00259783          	lh	a5,2(a1)
    80002ba0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ba4:	00459783          	lh	a5,4(a1)
    80002ba8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bac:	00659783          	lh	a5,6(a1)
    80002bb0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bb4:	459c                	lw	a5,8(a1)
    80002bb6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bb8:	03400613          	li	a2,52
    80002bbc:	05b1                	addi	a1,a1,12
    80002bbe:	05048513          	addi	a0,s1,80
    80002bc2:	ffffd097          	auipc	ra,0xffffd
    80002bc6:	616080e7          	jalr	1558(ra) # 800001d8 <memmove>
    brelse(bp);
    80002bca:	854a                	mv	a0,s2
    80002bcc:	fffff097          	auipc	ra,0xfffff
    80002bd0:	7c8080e7          	jalr	1992(ra) # 80002394 <brelse>
    ip->valid = 1;
    80002bd4:	4785                	li	a5,1
    80002bd6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bd8:	04449783          	lh	a5,68(s1)
    80002bdc:	fbb5                	bnez	a5,80002b50 <ilock+0x24>
      panic("ilock: no type");
    80002bde:	00006517          	auipc	a0,0x6
    80002be2:	97a50513          	addi	a0,a0,-1670 # 80008558 <syscalls+0x190>
    80002be6:	00003097          	auipc	ra,0x3
    80002bea:	142080e7          	jalr	322(ra) # 80005d28 <panic>

0000000080002bee <iunlock>:
{
    80002bee:	1101                	addi	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	e04a                	sd	s2,0(sp)
    80002bf8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bfa:	c905                	beqz	a0,80002c2a <iunlock+0x3c>
    80002bfc:	84aa                	mv	s1,a0
    80002bfe:	01050913          	addi	s2,a0,16
    80002c02:	854a                	mv	a0,s2
    80002c04:	00001097          	auipc	ra,0x1
    80002c08:	c8e080e7          	jalr	-882(ra) # 80003892 <holdingsleep>
    80002c0c:	cd19                	beqz	a0,80002c2a <iunlock+0x3c>
    80002c0e:	449c                	lw	a5,8(s1)
    80002c10:	00f05d63          	blez	a5,80002c2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	c38080e7          	jalr	-968(ra) # 8000384e <releasesleep>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret
    panic("iunlock");
    80002c2a:	00006517          	auipc	a0,0x6
    80002c2e:	93e50513          	addi	a0,a0,-1730 # 80008568 <syscalls+0x1a0>
    80002c32:	00003097          	auipc	ra,0x3
    80002c36:	0f6080e7          	jalr	246(ra) # 80005d28 <panic>

0000000080002c3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c3a:	7179                	addi	sp,sp,-48
    80002c3c:	f406                	sd	ra,40(sp)
    80002c3e:	f022                	sd	s0,32(sp)
    80002c40:	ec26                	sd	s1,24(sp)
    80002c42:	e84a                	sd	s2,16(sp)
    80002c44:	e44e                	sd	s3,8(sp)
    80002c46:	e052                	sd	s4,0(sp)
    80002c48:	1800                	addi	s0,sp,48
    80002c4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c4c:	05050493          	addi	s1,a0,80
    80002c50:	07c50913          	addi	s2,a0,124
    80002c54:	a821                	j	80002c6c <itrunc+0x32>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80002c56:	0009a503          	lw	a0,0(s3)
    80002c5a:	00000097          	auipc	ra,0x0
    80002c5e:	850080e7          	jalr	-1968(ra) # 800024aa <bfree>
      ip->addrs[i] = 0;
    80002c62:	0004a023          	sw	zero,0(s1)
  for(i = 0; i < NDIRECT; i++){
    80002c66:	0491                	addi	s1,s1,4
    80002c68:	01248563          	beq	s1,s2,80002c72 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c6c:	408c                	lw	a1,0(s1)
    80002c6e:	dde5                	beqz	a1,80002c66 <itrunc+0x2c>
    80002c70:	b7dd                	j	80002c56 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c72:	07c9a583          	lw	a1,124(s3)
    80002c76:	e185                	bnez	a1,80002c96 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c7c:	854e                	mv	a0,s3
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	de4080e7          	jalr	-540(ra) # 80002a62 <iupdate>
}
    80002c86:	70a2                	ld	ra,40(sp)
    80002c88:	7402                	ld	s0,32(sp)
    80002c8a:	64e2                	ld	s1,24(sp)
    80002c8c:	6942                	ld	s2,16(sp)
    80002c8e:	69a2                	ld	s3,8(sp)
    80002c90:	6a02                	ld	s4,0(sp)
    80002c92:	6145                	addi	sp,sp,48
    80002c94:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c96:	0009a503          	lw	a0,0(s3)
    80002c9a:	fffff097          	auipc	ra,0xfffff
    80002c9e:	5ca080e7          	jalr	1482(ra) # 80002264 <bread>
    80002ca2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ca4:	05850493          	addi	s1,a0,88
    80002ca8:	45850913          	addi	s2,a0,1112
    80002cac:	a811                	j	80002cc0 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002cae:	0009a503          	lw	a0,0(s3)
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	7f8080e7          	jalr	2040(ra) # 800024aa <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002cba:	0491                	addi	s1,s1,4
    80002cbc:	01248563          	beq	s1,s2,80002cc6 <itrunc+0x8c>
      if(a[j])
    80002cc0:	408c                	lw	a1,0(s1)
    80002cc2:	dde5                	beqz	a1,80002cba <itrunc+0x80>
    80002cc4:	b7ed                	j	80002cae <itrunc+0x74>
    brelse(bp);
    80002cc6:	8552                	mv	a0,s4
    80002cc8:	fffff097          	auipc	ra,0xfffff
    80002ccc:	6cc080e7          	jalr	1740(ra) # 80002394 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cd0:	07c9a583          	lw	a1,124(s3)
    80002cd4:	0009a503          	lw	a0,0(s3)
    80002cd8:	fffff097          	auipc	ra,0xfffff
    80002cdc:	7d2080e7          	jalr	2002(ra) # 800024aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ce0:	0609ae23          	sw	zero,124(s3)
    80002ce4:	bf51                	j	80002c78 <itrunc+0x3e>

0000000080002ce6 <iput>:
{
    80002ce6:	1101                	addi	sp,sp,-32
    80002ce8:	ec06                	sd	ra,24(sp)
    80002cea:	e822                	sd	s0,16(sp)
    80002cec:	e426                	sd	s1,8(sp)
    80002cee:	e04a                	sd	s2,0(sp)
    80002cf0:	1000                	addi	s0,sp,32
    80002cf2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cf4:	00010517          	auipc	a0,0x10
    80002cf8:	c9450513          	addi	a0,a0,-876 # 80012988 <itable>
    80002cfc:	00003097          	auipc	ra,0x3
    80002d00:	576080e7          	jalr	1398(ra) # 80006272 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d04:	4498                	lw	a4,8(s1)
    80002d06:	4785                	li	a5,1
    80002d08:	02f70363          	beq	a4,a5,80002d2e <iput+0x48>
  ip->ref--;
    80002d0c:	449c                	lw	a5,8(s1)
    80002d0e:	37fd                	addiw	a5,a5,-1
    80002d10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d12:	00010517          	auipc	a0,0x10
    80002d16:	c7650513          	addi	a0,a0,-906 # 80012988 <itable>
    80002d1a:	00003097          	auipc	ra,0x3
    80002d1e:	60c080e7          	jalr	1548(ra) # 80006326 <release>
}
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6902                	ld	s2,0(sp)
    80002d2a:	6105                	addi	sp,sp,32
    80002d2c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d2e:	40bc                	lw	a5,64(s1)
    80002d30:	dff1                	beqz	a5,80002d0c <iput+0x26>
    80002d32:	04a49783          	lh	a5,74(s1)
    80002d36:	fbf9                	bnez	a5,80002d0c <iput+0x26>
    acquiresleep(&ip->lock);
    80002d38:	01048913          	addi	s2,s1,16
    80002d3c:	854a                	mv	a0,s2
    80002d3e:	00001097          	auipc	ra,0x1
    80002d42:	aba080e7          	jalr	-1350(ra) # 800037f8 <acquiresleep>
    release(&itable.lock);
    80002d46:	00010517          	auipc	a0,0x10
    80002d4a:	c4250513          	addi	a0,a0,-958 # 80012988 <itable>
    80002d4e:	00003097          	auipc	ra,0x3
    80002d52:	5d8080e7          	jalr	1496(ra) # 80006326 <release>
    itrunc(ip);
    80002d56:	8526                	mv	a0,s1
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	ee2080e7          	jalr	-286(ra) # 80002c3a <itrunc>
    ip->type = 0;
    80002d60:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d64:	8526                	mv	a0,s1
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	cfc080e7          	jalr	-772(ra) # 80002a62 <iupdate>
    ip->valid = 0;
    80002d6e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d72:	854a                	mv	a0,s2
    80002d74:	00001097          	auipc	ra,0x1
    80002d78:	ada080e7          	jalr	-1318(ra) # 8000384e <releasesleep>
    acquire(&itable.lock);
    80002d7c:	00010517          	auipc	a0,0x10
    80002d80:	c0c50513          	addi	a0,a0,-1012 # 80012988 <itable>
    80002d84:	00003097          	auipc	ra,0x3
    80002d88:	4ee080e7          	jalr	1262(ra) # 80006272 <acquire>
    80002d8c:	b741                	j	80002d0c <iput+0x26>

0000000080002d8e <iunlockput>:
{
    80002d8e:	1101                	addi	sp,sp,-32
    80002d90:	ec06                	sd	ra,24(sp)
    80002d92:	e822                	sd	s0,16(sp)
    80002d94:	e426                	sd	s1,8(sp)
    80002d96:	1000                	addi	s0,sp,32
    80002d98:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d9a:	00000097          	auipc	ra,0x0
    80002d9e:	e54080e7          	jalr	-428(ra) # 80002bee <iunlock>
  iput(ip);
    80002da2:	8526                	mv	a0,s1
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	f42080e7          	jalr	-190(ra) # 80002ce6 <iput>
}
    80002dac:	60e2                	ld	ra,24(sp)
    80002dae:	6442                	ld	s0,16(sp)
    80002db0:	64a2                	ld	s1,8(sp)
    80002db2:	6105                	addi	sp,sp,32
    80002db4:	8082                	ret

0000000080002db6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002db6:	1141                	addi	sp,sp,-16
    80002db8:	e422                	sd	s0,8(sp)
    80002dba:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dbc:	411c                	lw	a5,0(a0)
    80002dbe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dc0:	415c                	lw	a5,4(a0)
    80002dc2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dc4:	04451783          	lh	a5,68(a0)
    80002dc8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dcc:	04a51783          	lh	a5,74(a0)
    80002dd0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dd4:	04c56783          	lwu	a5,76(a0)
    80002dd8:	e99c                	sd	a5,16(a1)
}
    80002dda:	6422                	ld	s0,8(sp)
    80002ddc:	0141                	addi	sp,sp,16
    80002dde:	8082                	ret

0000000080002de0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002de0:	457c                	lw	a5,76(a0)
    80002de2:	0ed7e963          	bltu	a5,a3,80002ed4 <readi+0xf4>
{
    80002de6:	7159                	addi	sp,sp,-112
    80002de8:	f486                	sd	ra,104(sp)
    80002dea:	f0a2                	sd	s0,96(sp)
    80002dec:	eca6                	sd	s1,88(sp)
    80002dee:	e8ca                	sd	s2,80(sp)
    80002df0:	e4ce                	sd	s3,72(sp)
    80002df2:	e0d2                	sd	s4,64(sp)
    80002df4:	fc56                	sd	s5,56(sp)
    80002df6:	f85a                	sd	s6,48(sp)
    80002df8:	f45e                	sd	s7,40(sp)
    80002dfa:	f062                	sd	s8,32(sp)
    80002dfc:	ec66                	sd	s9,24(sp)
    80002dfe:	e86a                	sd	s10,16(sp)
    80002e00:	e46e                	sd	s11,8(sp)
    80002e02:	1880                	addi	s0,sp,112
    80002e04:	8baa                	mv	s7,a0
    80002e06:	8c2e                	mv	s8,a1
    80002e08:	8ab2                	mv	s5,a2
    80002e0a:	84b6                	mv	s1,a3
    80002e0c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e0e:	9f35                	addw	a4,a4,a3
    return 0;
    80002e10:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e12:	0ad76063          	bltu	a4,a3,80002eb2 <readi+0xd2>
  if(off + n > ip->size)
    80002e16:	00e7f463          	bgeu	a5,a4,80002e1e <readi+0x3e>
    n = ip->size - off;
    80002e1a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e1e:	0a0b0963          	beqz	s6,80002ed0 <readi+0xf0>
    80002e22:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e24:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e28:	5cfd                	li	s9,-1
    80002e2a:	a82d                	j	80002e64 <readi+0x84>
    80002e2c:	020a1d93          	slli	s11,s4,0x20
    80002e30:	020ddd93          	srli	s11,s11,0x20
    80002e34:	05890613          	addi	a2,s2,88
    80002e38:	86ee                	mv	a3,s11
    80002e3a:	963a                	add	a2,a2,a4
    80002e3c:	85d6                	mv	a1,s5
    80002e3e:	8562                	mv	a0,s8
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	a68080e7          	jalr	-1432(ra) # 800018a8 <either_copyout>
    80002e48:	05950d63          	beq	a0,s9,80002ea2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e4c:	854a                	mv	a0,s2
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	546080e7          	jalr	1350(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e56:	013a09bb          	addw	s3,s4,s3
    80002e5a:	009a04bb          	addw	s1,s4,s1
    80002e5e:	9aee                	add	s5,s5,s11
    80002e60:	0569f763          	bgeu	s3,s6,80002eae <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e64:	000ba903          	lw	s2,0(s7)
    80002e68:	00a4d59b          	srliw	a1,s1,0xa
    80002e6c:	855e                	mv	a0,s7
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	7ea080e7          	jalr	2026(ra) # 80002658 <bmap>
    80002e76:	0005059b          	sext.w	a1,a0
    80002e7a:	854a                	mv	a0,s2
    80002e7c:	fffff097          	auipc	ra,0xfffff
    80002e80:	3e8080e7          	jalr	1000(ra) # 80002264 <bread>
    80002e84:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e86:	3ff4f713          	andi	a4,s1,1023
    80002e8a:	40ed07bb          	subw	a5,s10,a4
    80002e8e:	413b06bb          	subw	a3,s6,s3
    80002e92:	8a3e                	mv	s4,a5
    80002e94:	2781                	sext.w	a5,a5
    80002e96:	0006861b          	sext.w	a2,a3
    80002e9a:	f8f679e3          	bgeu	a2,a5,80002e2c <readi+0x4c>
    80002e9e:	8a36                	mv	s4,a3
    80002ea0:	b771                	j	80002e2c <readi+0x4c>
      brelse(bp);
    80002ea2:	854a                	mv	a0,s2
    80002ea4:	fffff097          	auipc	ra,0xfffff
    80002ea8:	4f0080e7          	jalr	1264(ra) # 80002394 <brelse>
      tot = -1;
    80002eac:	59fd                	li	s3,-1
  }
  return tot;
    80002eae:	0009851b          	sext.w	a0,s3
}
    80002eb2:	70a6                	ld	ra,104(sp)
    80002eb4:	7406                	ld	s0,96(sp)
    80002eb6:	64e6                	ld	s1,88(sp)
    80002eb8:	6946                	ld	s2,80(sp)
    80002eba:	69a6                	ld	s3,72(sp)
    80002ebc:	6a06                	ld	s4,64(sp)
    80002ebe:	7ae2                	ld	s5,56(sp)
    80002ec0:	7b42                	ld	s6,48(sp)
    80002ec2:	7ba2                	ld	s7,40(sp)
    80002ec4:	7c02                	ld	s8,32(sp)
    80002ec6:	6ce2                	ld	s9,24(sp)
    80002ec8:	6d42                	ld	s10,16(sp)
    80002eca:	6da2                	ld	s11,8(sp)
    80002ecc:	6165                	addi	sp,sp,112
    80002ece:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed0:	89da                	mv	s3,s6
    80002ed2:	bff1                	j	80002eae <readi+0xce>
    return 0;
    80002ed4:	4501                	li	a0,0
}
    80002ed6:	8082                	ret

0000000080002ed8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ed8:	457c                	lw	a5,76(a0)
    80002eda:	10d7e963          	bltu	a5,a3,80002fec <writei+0x114>
{
    80002ede:	7159                	addi	sp,sp,-112
    80002ee0:	f486                	sd	ra,104(sp)
    80002ee2:	f0a2                	sd	s0,96(sp)
    80002ee4:	eca6                	sd	s1,88(sp)
    80002ee6:	e8ca                	sd	s2,80(sp)
    80002ee8:	e4ce                	sd	s3,72(sp)
    80002eea:	e0d2                	sd	s4,64(sp)
    80002eec:	fc56                	sd	s5,56(sp)
    80002eee:	f85a                	sd	s6,48(sp)
    80002ef0:	f45e                	sd	s7,40(sp)
    80002ef2:	f062                	sd	s8,32(sp)
    80002ef4:	ec66                	sd	s9,24(sp)
    80002ef6:	e86a                	sd	s10,16(sp)
    80002ef8:	e46e                	sd	s11,8(sp)
    80002efa:	1880                	addi	s0,sp,112
    80002efc:	8b2a                	mv	s6,a0
    80002efe:	8c2e                	mv	s8,a1
    80002f00:	8ab2                	mv	s5,a2
    80002f02:	8936                	mv	s2,a3
    80002f04:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f06:	9f35                	addw	a4,a4,a3
    80002f08:	0ed76463          	bltu	a4,a3,80002ff0 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f0c:	040437b7          	lui	a5,0x4043
    80002f10:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002f14:	0ee7e063          	bltu	a5,a4,80002ff4 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f18:	0c0b8863          	beqz	s7,80002fe8 <writei+0x110>
    80002f1c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f22:	5cfd                	li	s9,-1
    80002f24:	a091                	j	80002f68 <writei+0x90>
    80002f26:	02099d93          	slli	s11,s3,0x20
    80002f2a:	020ddd93          	srli	s11,s11,0x20
    80002f2e:	05848513          	addi	a0,s1,88
    80002f32:	86ee                	mv	a3,s11
    80002f34:	8656                	mv	a2,s5
    80002f36:	85e2                	mv	a1,s8
    80002f38:	953a                	add	a0,a0,a4
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	9c4080e7          	jalr	-1596(ra) # 800018fe <either_copyin>
    80002f42:	07950263          	beq	a0,s9,80002fa6 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f46:	8526                	mv	a0,s1
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	790080e7          	jalr	1936(ra) # 800036d8 <log_write>
    brelse(bp);
    80002f50:	8526                	mv	a0,s1
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	442080e7          	jalr	1090(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f5a:	01498a3b          	addw	s4,s3,s4
    80002f5e:	0129893b          	addw	s2,s3,s2
    80002f62:	9aee                	add	s5,s5,s11
    80002f64:	057a7663          	bgeu	s4,s7,80002fb0 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f68:	000b2483          	lw	s1,0(s6)
    80002f6c:	00a9559b          	srliw	a1,s2,0xa
    80002f70:	855a                	mv	a0,s6
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	6e6080e7          	jalr	1766(ra) # 80002658 <bmap>
    80002f7a:	0005059b          	sext.w	a1,a0
    80002f7e:	8526                	mv	a0,s1
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	2e4080e7          	jalr	740(ra) # 80002264 <bread>
    80002f88:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8a:	3ff97713          	andi	a4,s2,1023
    80002f8e:	40ed07bb          	subw	a5,s10,a4
    80002f92:	414b86bb          	subw	a3,s7,s4
    80002f96:	89be                	mv	s3,a5
    80002f98:	2781                	sext.w	a5,a5
    80002f9a:	0006861b          	sext.w	a2,a3
    80002f9e:	f8f674e3          	bgeu	a2,a5,80002f26 <writei+0x4e>
    80002fa2:	89b6                	mv	s3,a3
    80002fa4:	b749                	j	80002f26 <writei+0x4e>
      brelse(bp);
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	fffff097          	auipc	ra,0xfffff
    80002fac:	3ec080e7          	jalr	1004(ra) # 80002394 <brelse>
  }

  if(off > ip->size)
    80002fb0:	04cb2783          	lw	a5,76(s6)
    80002fb4:	0127f463          	bgeu	a5,s2,80002fbc <writei+0xe4>
    ip->size = off;
    80002fb8:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fbc:	855a                	mv	a0,s6
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	aa4080e7          	jalr	-1372(ra) # 80002a62 <iupdate>

  return tot;
    80002fc6:	000a051b          	sext.w	a0,s4
}
    80002fca:	70a6                	ld	ra,104(sp)
    80002fcc:	7406                	ld	s0,96(sp)
    80002fce:	64e6                	ld	s1,88(sp)
    80002fd0:	6946                	ld	s2,80(sp)
    80002fd2:	69a6                	ld	s3,72(sp)
    80002fd4:	6a06                	ld	s4,64(sp)
    80002fd6:	7ae2                	ld	s5,56(sp)
    80002fd8:	7b42                	ld	s6,48(sp)
    80002fda:	7ba2                	ld	s7,40(sp)
    80002fdc:	7c02                	ld	s8,32(sp)
    80002fde:	6ce2                	ld	s9,24(sp)
    80002fe0:	6d42                	ld	s10,16(sp)
    80002fe2:	6da2                	ld	s11,8(sp)
    80002fe4:	6165                	addi	sp,sp,112
    80002fe6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe8:	8a5e                	mv	s4,s7
    80002fea:	bfc9                	j	80002fbc <writei+0xe4>
    return -1;
    80002fec:	557d                	li	a0,-1
}
    80002fee:	8082                	ret
    return -1;
    80002ff0:	557d                	li	a0,-1
    80002ff2:	bfe1                	j	80002fca <writei+0xf2>
    return -1;
    80002ff4:	557d                	li	a0,-1
    80002ff6:	bfd1                	j	80002fca <writei+0xf2>

0000000080002ff8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002ff8:	1141                	addi	sp,sp,-16
    80002ffa:	e406                	sd	ra,8(sp)
    80002ffc:	e022                	sd	s0,0(sp)
    80002ffe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003000:	4639                	li	a2,14
    80003002:	ffffd097          	auipc	ra,0xffffd
    80003006:	24e080e7          	jalr	590(ra) # 80000250 <strncmp>
}
    8000300a:	60a2                	ld	ra,8(sp)
    8000300c:	6402                	ld	s0,0(sp)
    8000300e:	0141                	addi	sp,sp,16
    80003010:	8082                	ret

0000000080003012 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003012:	7139                	addi	sp,sp,-64
    80003014:	fc06                	sd	ra,56(sp)
    80003016:	f822                	sd	s0,48(sp)
    80003018:	f426                	sd	s1,40(sp)
    8000301a:	f04a                	sd	s2,32(sp)
    8000301c:	ec4e                	sd	s3,24(sp)
    8000301e:	e852                	sd	s4,16(sp)
    80003020:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003022:	04451703          	lh	a4,68(a0)
    80003026:	4785                	li	a5,1
    80003028:	00f71a63          	bne	a4,a5,8000303c <dirlookup+0x2a>
    8000302c:	892a                	mv	s2,a0
    8000302e:	89ae                	mv	s3,a1
    80003030:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003032:	457c                	lw	a5,76(a0)
    80003034:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003036:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003038:	e79d                	bnez	a5,80003066 <dirlookup+0x54>
    8000303a:	a8a5                	j	800030b2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000303c:	00005517          	auipc	a0,0x5
    80003040:	53450513          	addi	a0,a0,1332 # 80008570 <syscalls+0x1a8>
    80003044:	00003097          	auipc	ra,0x3
    80003048:	ce4080e7          	jalr	-796(ra) # 80005d28 <panic>
      panic("dirlookup read");
    8000304c:	00005517          	auipc	a0,0x5
    80003050:	53c50513          	addi	a0,a0,1340 # 80008588 <syscalls+0x1c0>
    80003054:	00003097          	auipc	ra,0x3
    80003058:	cd4080e7          	jalr	-812(ra) # 80005d28 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000305c:	24c1                	addiw	s1,s1,16
    8000305e:	04c92783          	lw	a5,76(s2)
    80003062:	04f4f763          	bgeu	s1,a5,800030b0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003066:	4741                	li	a4,16
    80003068:	86a6                	mv	a3,s1
    8000306a:	fc040613          	addi	a2,s0,-64
    8000306e:	4581                	li	a1,0
    80003070:	854a                	mv	a0,s2
    80003072:	00000097          	auipc	ra,0x0
    80003076:	d6e080e7          	jalr	-658(ra) # 80002de0 <readi>
    8000307a:	47c1                	li	a5,16
    8000307c:	fcf518e3          	bne	a0,a5,8000304c <dirlookup+0x3a>
    if(de.inum == 0)
    80003080:	fc045783          	lhu	a5,-64(s0)
    80003084:	dfe1                	beqz	a5,8000305c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003086:	fc240593          	addi	a1,s0,-62
    8000308a:	854e                	mv	a0,s3
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	f6c080e7          	jalr	-148(ra) # 80002ff8 <namecmp>
    80003094:	f561                	bnez	a0,8000305c <dirlookup+0x4a>
      if(poff)
    80003096:	000a0463          	beqz	s4,8000309e <dirlookup+0x8c>
        *poff = off;
    8000309a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000309e:	fc045583          	lhu	a1,-64(s0)
    800030a2:	00092503          	lw	a0,0(s2)
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	752080e7          	jalr	1874(ra) # 800027f8 <iget>
    800030ae:	a011                	j	800030b2 <dirlookup+0xa0>
  return 0;
    800030b0:	4501                	li	a0,0
}
    800030b2:	70e2                	ld	ra,56(sp)
    800030b4:	7442                	ld	s0,48(sp)
    800030b6:	74a2                	ld	s1,40(sp)
    800030b8:	7902                	ld	s2,32(sp)
    800030ba:	69e2                	ld	s3,24(sp)
    800030bc:	6a42                	ld	s4,16(sp)
    800030be:	6121                	addi	sp,sp,64
    800030c0:	8082                	ret

00000000800030c2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030c2:	711d                	addi	sp,sp,-96
    800030c4:	ec86                	sd	ra,88(sp)
    800030c6:	e8a2                	sd	s0,80(sp)
    800030c8:	e4a6                	sd	s1,72(sp)
    800030ca:	e0ca                	sd	s2,64(sp)
    800030cc:	fc4e                	sd	s3,56(sp)
    800030ce:	f852                	sd	s4,48(sp)
    800030d0:	f456                	sd	s5,40(sp)
    800030d2:	f05a                	sd	s6,32(sp)
    800030d4:	ec5e                	sd	s7,24(sp)
    800030d6:	e862                	sd	s8,16(sp)
    800030d8:	e466                	sd	s9,8(sp)
    800030da:	1080                	addi	s0,sp,96
    800030dc:	84aa                	mv	s1,a0
    800030de:	8b2e                	mv	s6,a1
    800030e0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030e2:	00054703          	lbu	a4,0(a0)
    800030e6:	02f00793          	li	a5,47
    800030ea:	02f70363          	beq	a4,a5,80003110 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030ee:	ffffe097          	auipc	ra,0xffffe
    800030f2:	d5a080e7          	jalr	-678(ra) # 80000e48 <myproc>
    800030f6:	15053503          	ld	a0,336(a0)
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	9f4080e7          	jalr	-1548(ra) # 80002aee <idup>
    80003102:	89aa                	mv	s3,a0
  while(*path == '/')
    80003104:	02f00913          	li	s2,47
  len = path - s;
    80003108:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000310a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000310c:	4c05                	li	s8,1
    8000310e:	a865                	j	800031c6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003110:	4585                	li	a1,1
    80003112:	4505                	li	a0,1
    80003114:	fffff097          	auipc	ra,0xfffff
    80003118:	6e4080e7          	jalr	1764(ra) # 800027f8 <iget>
    8000311c:	89aa                	mv	s3,a0
    8000311e:	b7dd                	j	80003104 <namex+0x42>
      iunlockput(ip);
    80003120:	854e                	mv	a0,s3
    80003122:	00000097          	auipc	ra,0x0
    80003126:	c6c080e7          	jalr	-916(ra) # 80002d8e <iunlockput>
      return 0;
    8000312a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000312c:	854e                	mv	a0,s3
    8000312e:	60e6                	ld	ra,88(sp)
    80003130:	6446                	ld	s0,80(sp)
    80003132:	64a6                	ld	s1,72(sp)
    80003134:	6906                	ld	s2,64(sp)
    80003136:	79e2                	ld	s3,56(sp)
    80003138:	7a42                	ld	s4,48(sp)
    8000313a:	7aa2                	ld	s5,40(sp)
    8000313c:	7b02                	ld	s6,32(sp)
    8000313e:	6be2                	ld	s7,24(sp)
    80003140:	6c42                	ld	s8,16(sp)
    80003142:	6ca2                	ld	s9,8(sp)
    80003144:	6125                	addi	sp,sp,96
    80003146:	8082                	ret
      iunlock(ip);
    80003148:	854e                	mv	a0,s3
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	aa4080e7          	jalr	-1372(ra) # 80002bee <iunlock>
      return ip;
    80003152:	bfe9                	j	8000312c <namex+0x6a>
      iunlockput(ip);
    80003154:	854e                	mv	a0,s3
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	c38080e7          	jalr	-968(ra) # 80002d8e <iunlockput>
      return 0;
    8000315e:	89d2                	mv	s3,s4
    80003160:	b7f1                	j	8000312c <namex+0x6a>
  len = path - s;
    80003162:	40b48633          	sub	a2,s1,a1
    80003166:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000316a:	094cd463          	bge	s9,s4,800031f2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000316e:	4639                	li	a2,14
    80003170:	8556                	mv	a0,s5
    80003172:	ffffd097          	auipc	ra,0xffffd
    80003176:	066080e7          	jalr	102(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000317a:	0004c783          	lbu	a5,0(s1)
    8000317e:	01279763          	bne	a5,s2,8000318c <namex+0xca>
    path++;
    80003182:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003184:	0004c783          	lbu	a5,0(s1)
    80003188:	ff278de3          	beq	a5,s2,80003182 <namex+0xc0>
    ilock(ip);
    8000318c:	854e                	mv	a0,s3
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	99e080e7          	jalr	-1634(ra) # 80002b2c <ilock>
    if(ip->type != T_DIR){
    80003196:	04499783          	lh	a5,68(s3)
    8000319a:	f98793e3          	bne	a5,s8,80003120 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000319e:	000b0563          	beqz	s6,800031a8 <namex+0xe6>
    800031a2:	0004c783          	lbu	a5,0(s1)
    800031a6:	d3cd                	beqz	a5,80003148 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031a8:	865e                	mv	a2,s7
    800031aa:	85d6                	mv	a1,s5
    800031ac:	854e                	mv	a0,s3
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	e64080e7          	jalr	-412(ra) # 80003012 <dirlookup>
    800031b6:	8a2a                	mv	s4,a0
    800031b8:	dd51                	beqz	a0,80003154 <namex+0x92>
    iunlockput(ip);
    800031ba:	854e                	mv	a0,s3
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	bd2080e7          	jalr	-1070(ra) # 80002d8e <iunlockput>
    ip = next;
    800031c4:	89d2                	mv	s3,s4
  while(*path == '/')
    800031c6:	0004c783          	lbu	a5,0(s1)
    800031ca:	05279763          	bne	a5,s2,80003218 <namex+0x156>
    path++;
    800031ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031d0:	0004c783          	lbu	a5,0(s1)
    800031d4:	ff278de3          	beq	a5,s2,800031ce <namex+0x10c>
  if(*path == 0)
    800031d8:	c79d                	beqz	a5,80003206 <namex+0x144>
    path++;
    800031da:	85a6                	mv	a1,s1
  len = path - s;
    800031dc:	8a5e                	mv	s4,s7
    800031de:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031e0:	01278963          	beq	a5,s2,800031f2 <namex+0x130>
    800031e4:	dfbd                	beqz	a5,80003162 <namex+0xa0>
    path++;
    800031e6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031e8:	0004c783          	lbu	a5,0(s1)
    800031ec:	ff279ce3          	bne	a5,s2,800031e4 <namex+0x122>
    800031f0:	bf8d                	j	80003162 <namex+0xa0>
    memmove(name, s, len);
    800031f2:	2601                	sext.w	a2,a2
    800031f4:	8556                	mv	a0,s5
    800031f6:	ffffd097          	auipc	ra,0xffffd
    800031fa:	fe2080e7          	jalr	-30(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031fe:	9a56                	add	s4,s4,s5
    80003200:	000a0023          	sb	zero,0(s4)
    80003204:	bf9d                	j	8000317a <namex+0xb8>
  if(nameiparent){
    80003206:	f20b03e3          	beqz	s6,8000312c <namex+0x6a>
    iput(ip);
    8000320a:	854e                	mv	a0,s3
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	ada080e7          	jalr	-1318(ra) # 80002ce6 <iput>
    return 0;
    80003214:	4981                	li	s3,0
    80003216:	bf19                	j	8000312c <namex+0x6a>
  if(*path == 0)
    80003218:	d7fd                	beqz	a5,80003206 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000321a:	0004c783          	lbu	a5,0(s1)
    8000321e:	85a6                	mv	a1,s1
    80003220:	b7d1                	j	800031e4 <namex+0x122>

0000000080003222 <dirlink>:
{
    80003222:	7139                	addi	sp,sp,-64
    80003224:	fc06                	sd	ra,56(sp)
    80003226:	f822                	sd	s0,48(sp)
    80003228:	f426                	sd	s1,40(sp)
    8000322a:	f04a                	sd	s2,32(sp)
    8000322c:	ec4e                	sd	s3,24(sp)
    8000322e:	e852                	sd	s4,16(sp)
    80003230:	0080                	addi	s0,sp,64
    80003232:	892a                	mv	s2,a0
    80003234:	8a2e                	mv	s4,a1
    80003236:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003238:	4601                	li	a2,0
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	dd8080e7          	jalr	-552(ra) # 80003012 <dirlookup>
    80003242:	e93d                	bnez	a0,800032b8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003244:	04c92483          	lw	s1,76(s2)
    80003248:	c49d                	beqz	s1,80003276 <dirlink+0x54>
    8000324a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324c:	4741                	li	a4,16
    8000324e:	86a6                	mv	a3,s1
    80003250:	fc040613          	addi	a2,s0,-64
    80003254:	4581                	li	a1,0
    80003256:	854a                	mv	a0,s2
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	b88080e7          	jalr	-1144(ra) # 80002de0 <readi>
    80003260:	47c1                	li	a5,16
    80003262:	06f51163          	bne	a0,a5,800032c4 <dirlink+0xa2>
    if(de.inum == 0)
    80003266:	fc045783          	lhu	a5,-64(s0)
    8000326a:	c791                	beqz	a5,80003276 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000326c:	24c1                	addiw	s1,s1,16
    8000326e:	04c92783          	lw	a5,76(s2)
    80003272:	fcf4ede3          	bltu	s1,a5,8000324c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003276:	4639                	li	a2,14
    80003278:	85d2                	mv	a1,s4
    8000327a:	fc240513          	addi	a0,s0,-62
    8000327e:	ffffd097          	auipc	ra,0xffffd
    80003282:	00e080e7          	jalr	14(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003286:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000328a:	4741                	li	a4,16
    8000328c:	86a6                	mv	a3,s1
    8000328e:	fc040613          	addi	a2,s0,-64
    80003292:	4581                	li	a1,0
    80003294:	854a                	mv	a0,s2
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	c42080e7          	jalr	-958(ra) # 80002ed8 <writei>
    8000329e:	872a                	mv	a4,a0
    800032a0:	47c1                	li	a5,16
  return 0;
    800032a2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a4:	02f71863          	bne	a4,a5,800032d4 <dirlink+0xb2>
}
    800032a8:	70e2                	ld	ra,56(sp)
    800032aa:	7442                	ld	s0,48(sp)
    800032ac:	74a2                	ld	s1,40(sp)
    800032ae:	7902                	ld	s2,32(sp)
    800032b0:	69e2                	ld	s3,24(sp)
    800032b2:	6a42                	ld	s4,16(sp)
    800032b4:	6121                	addi	sp,sp,64
    800032b6:	8082                	ret
    iput(ip);
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	a2e080e7          	jalr	-1490(ra) # 80002ce6 <iput>
    return -1;
    800032c0:	557d                	li	a0,-1
    800032c2:	b7dd                	j	800032a8 <dirlink+0x86>
      panic("dirlink read");
    800032c4:	00005517          	auipc	a0,0x5
    800032c8:	2d450513          	addi	a0,a0,724 # 80008598 <syscalls+0x1d0>
    800032cc:	00003097          	auipc	ra,0x3
    800032d0:	a5c080e7          	jalr	-1444(ra) # 80005d28 <panic>
    panic("dirlink");
    800032d4:	00005517          	auipc	a0,0x5
    800032d8:	3d450513          	addi	a0,a0,980 # 800086a8 <syscalls+0x2e0>
    800032dc:	00003097          	auipc	ra,0x3
    800032e0:	a4c080e7          	jalr	-1460(ra) # 80005d28 <panic>

00000000800032e4 <namei>:

struct inode*
namei(char *path)
{
    800032e4:	1101                	addi	sp,sp,-32
    800032e6:	ec06                	sd	ra,24(sp)
    800032e8:	e822                	sd	s0,16(sp)
    800032ea:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032ec:	fe040613          	addi	a2,s0,-32
    800032f0:	4581                	li	a1,0
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	dd0080e7          	jalr	-560(ra) # 800030c2 <namex>
}
    800032fa:	60e2                	ld	ra,24(sp)
    800032fc:	6442                	ld	s0,16(sp)
    800032fe:	6105                	addi	sp,sp,32
    80003300:	8082                	ret

0000000080003302 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003302:	1141                	addi	sp,sp,-16
    80003304:	e406                	sd	ra,8(sp)
    80003306:	e022                	sd	s0,0(sp)
    80003308:	0800                	addi	s0,sp,16
    8000330a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000330c:	4585                	li	a1,1
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	db4080e7          	jalr	-588(ra) # 800030c2 <namex>
}
    80003316:	60a2                	ld	ra,8(sp)
    80003318:	6402                	ld	s0,0(sp)
    8000331a:	0141                	addi	sp,sp,16
    8000331c:	8082                	ret

000000008000331e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000331e:	1101                	addi	sp,sp,-32
    80003320:	ec06                	sd	ra,24(sp)
    80003322:	e822                	sd	s0,16(sp)
    80003324:	e426                	sd	s1,8(sp)
    80003326:	e04a                	sd	s2,0(sp)
    80003328:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000332a:	00011917          	auipc	s2,0x11
    8000332e:	10690913          	addi	s2,s2,262 # 80014430 <log>
    80003332:	01892583          	lw	a1,24(s2)
    80003336:	02892503          	lw	a0,40(s2)
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	f2a080e7          	jalr	-214(ra) # 80002264 <bread>
    80003342:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003344:	02c92683          	lw	a3,44(s2)
    80003348:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000334a:	02d05763          	blez	a3,80003378 <write_head+0x5a>
    8000334e:	00011797          	auipc	a5,0x11
    80003352:	11278793          	addi	a5,a5,274 # 80014460 <log+0x30>
    80003356:	05c50713          	addi	a4,a0,92
    8000335a:	36fd                	addiw	a3,a3,-1
    8000335c:	1682                	slli	a3,a3,0x20
    8000335e:	9281                	srli	a3,a3,0x20
    80003360:	068a                	slli	a3,a3,0x2
    80003362:	00011617          	auipc	a2,0x11
    80003366:	10260613          	addi	a2,a2,258 # 80014464 <log+0x34>
    8000336a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000336c:	4390                	lw	a2,0(a5)
    8000336e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003370:	0791                	addi	a5,a5,4
    80003372:	0711                	addi	a4,a4,4
    80003374:	fed79ce3          	bne	a5,a3,8000336c <write_head+0x4e>
  }
  bwrite(buf);
    80003378:	8526                	mv	a0,s1
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	fdc080e7          	jalr	-36(ra) # 80002356 <bwrite>
  brelse(buf);
    80003382:	8526                	mv	a0,s1
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	010080e7          	jalr	16(ra) # 80002394 <brelse>
}
    8000338c:	60e2                	ld	ra,24(sp)
    8000338e:	6442                	ld	s0,16(sp)
    80003390:	64a2                	ld	s1,8(sp)
    80003392:	6902                	ld	s2,0(sp)
    80003394:	6105                	addi	sp,sp,32
    80003396:	8082                	ret

0000000080003398 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003398:	00011797          	auipc	a5,0x11
    8000339c:	0c47a783          	lw	a5,196(a5) # 8001445c <log+0x2c>
    800033a0:	0af05d63          	blez	a5,8000345a <install_trans+0xc2>
{
    800033a4:	7139                	addi	sp,sp,-64
    800033a6:	fc06                	sd	ra,56(sp)
    800033a8:	f822                	sd	s0,48(sp)
    800033aa:	f426                	sd	s1,40(sp)
    800033ac:	f04a                	sd	s2,32(sp)
    800033ae:	ec4e                	sd	s3,24(sp)
    800033b0:	e852                	sd	s4,16(sp)
    800033b2:	e456                	sd	s5,8(sp)
    800033b4:	e05a                	sd	s6,0(sp)
    800033b6:	0080                	addi	s0,sp,64
    800033b8:	8b2a                	mv	s6,a0
    800033ba:	00011a97          	auipc	s5,0x11
    800033be:	0a6a8a93          	addi	s5,s5,166 # 80014460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033c2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033c4:	00011997          	auipc	s3,0x11
    800033c8:	06c98993          	addi	s3,s3,108 # 80014430 <log>
    800033cc:	a035                	j	800033f8 <install_trans+0x60>
      bunpin(dbuf);
    800033ce:	8526                	mv	a0,s1
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	09e080e7          	jalr	158(ra) # 8000246e <bunpin>
    brelse(lbuf);
    800033d8:	854a                	mv	a0,s2
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	fba080e7          	jalr	-70(ra) # 80002394 <brelse>
    brelse(dbuf);
    800033e2:	8526                	mv	a0,s1
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	fb0080e7          	jalr	-80(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ec:	2a05                	addiw	s4,s4,1
    800033ee:	0a91                	addi	s5,s5,4
    800033f0:	02c9a783          	lw	a5,44(s3)
    800033f4:	04fa5963          	bge	s4,a5,80003446 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033f8:	0189a583          	lw	a1,24(s3)
    800033fc:	014585bb          	addw	a1,a1,s4
    80003400:	2585                	addiw	a1,a1,1
    80003402:	0289a503          	lw	a0,40(s3)
    80003406:	fffff097          	auipc	ra,0xfffff
    8000340a:	e5e080e7          	jalr	-418(ra) # 80002264 <bread>
    8000340e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003410:	000aa583          	lw	a1,0(s5)
    80003414:	0289a503          	lw	a0,40(s3)
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	e4c080e7          	jalr	-436(ra) # 80002264 <bread>
    80003420:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003422:	40000613          	li	a2,1024
    80003426:	05890593          	addi	a1,s2,88
    8000342a:	05850513          	addi	a0,a0,88
    8000342e:	ffffd097          	auipc	ra,0xffffd
    80003432:	daa080e7          	jalr	-598(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003436:	8526                	mv	a0,s1
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	f1e080e7          	jalr	-226(ra) # 80002356 <bwrite>
    if(recovering == 0)
    80003440:	f80b1ce3          	bnez	s6,800033d8 <install_trans+0x40>
    80003444:	b769                	j	800033ce <install_trans+0x36>
}
    80003446:	70e2                	ld	ra,56(sp)
    80003448:	7442                	ld	s0,48(sp)
    8000344a:	74a2                	ld	s1,40(sp)
    8000344c:	7902                	ld	s2,32(sp)
    8000344e:	69e2                	ld	s3,24(sp)
    80003450:	6a42                	ld	s4,16(sp)
    80003452:	6aa2                	ld	s5,8(sp)
    80003454:	6b02                	ld	s6,0(sp)
    80003456:	6121                	addi	sp,sp,64
    80003458:	8082                	ret
    8000345a:	8082                	ret

000000008000345c <initlog>:
{
    8000345c:	7179                	addi	sp,sp,-48
    8000345e:	f406                	sd	ra,40(sp)
    80003460:	f022                	sd	s0,32(sp)
    80003462:	ec26                	sd	s1,24(sp)
    80003464:	e84a                	sd	s2,16(sp)
    80003466:	e44e                	sd	s3,8(sp)
    80003468:	1800                	addi	s0,sp,48
    8000346a:	892a                	mv	s2,a0
    8000346c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000346e:	00011497          	auipc	s1,0x11
    80003472:	fc248493          	addi	s1,s1,-62 # 80014430 <log>
    80003476:	00005597          	auipc	a1,0x5
    8000347a:	13258593          	addi	a1,a1,306 # 800085a8 <syscalls+0x1e0>
    8000347e:	8526                	mv	a0,s1
    80003480:	00003097          	auipc	ra,0x3
    80003484:	d62080e7          	jalr	-670(ra) # 800061e2 <initlock>
  log.start = sb->logstart;
    80003488:	0149a583          	lw	a1,20(s3)
    8000348c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000348e:	0109a783          	lw	a5,16(s3)
    80003492:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003494:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003498:	854a                	mv	a0,s2
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	dca080e7          	jalr	-566(ra) # 80002264 <bread>
  log.lh.n = lh->n;
    800034a2:	4d3c                	lw	a5,88(a0)
    800034a4:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034a6:	02f05563          	blez	a5,800034d0 <initlog+0x74>
    800034aa:	05c50713          	addi	a4,a0,92
    800034ae:	00011697          	auipc	a3,0x11
    800034b2:	fb268693          	addi	a3,a3,-78 # 80014460 <log+0x30>
    800034b6:	37fd                	addiw	a5,a5,-1
    800034b8:	1782                	slli	a5,a5,0x20
    800034ba:	9381                	srli	a5,a5,0x20
    800034bc:	078a                	slli	a5,a5,0x2
    800034be:	06050613          	addi	a2,a0,96
    800034c2:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800034c4:	4310                	lw	a2,0(a4)
    800034c6:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800034c8:	0711                	addi	a4,a4,4
    800034ca:	0691                	addi	a3,a3,4
    800034cc:	fef71ce3          	bne	a4,a5,800034c4 <initlog+0x68>
  brelse(buf);
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	ec4080e7          	jalr	-316(ra) # 80002394 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034d8:	4505                	li	a0,1
    800034da:	00000097          	auipc	ra,0x0
    800034de:	ebe080e7          	jalr	-322(ra) # 80003398 <install_trans>
  log.lh.n = 0;
    800034e2:	00011797          	auipc	a5,0x11
    800034e6:	f607ad23          	sw	zero,-134(a5) # 8001445c <log+0x2c>
  write_head(); // clear the log
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	e34080e7          	jalr	-460(ra) # 8000331e <write_head>
}
    800034f2:	70a2                	ld	ra,40(sp)
    800034f4:	7402                	ld	s0,32(sp)
    800034f6:	64e2                	ld	s1,24(sp)
    800034f8:	6942                	ld	s2,16(sp)
    800034fa:	69a2                	ld	s3,8(sp)
    800034fc:	6145                	addi	sp,sp,48
    800034fe:	8082                	ret

0000000080003500 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003500:	1101                	addi	sp,sp,-32
    80003502:	ec06                	sd	ra,24(sp)
    80003504:	e822                	sd	s0,16(sp)
    80003506:	e426                	sd	s1,8(sp)
    80003508:	e04a                	sd	s2,0(sp)
    8000350a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000350c:	00011517          	auipc	a0,0x11
    80003510:	f2450513          	addi	a0,a0,-220 # 80014430 <log>
    80003514:	00003097          	auipc	ra,0x3
    80003518:	d5e080e7          	jalr	-674(ra) # 80006272 <acquire>
  while(1){
    if(log.committing){
    8000351c:	00011497          	auipc	s1,0x11
    80003520:	f1448493          	addi	s1,s1,-236 # 80014430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003524:	4979                	li	s2,30
    80003526:	a039                	j	80003534 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003528:	85a6                	mv	a1,s1
    8000352a:	8526                	mv	a0,s1
    8000352c:	ffffe097          	auipc	ra,0xffffe
    80003530:	fd8080e7          	jalr	-40(ra) # 80001504 <sleep>
    if(log.committing){
    80003534:	50dc                	lw	a5,36(s1)
    80003536:	fbed                	bnez	a5,80003528 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003538:	509c                	lw	a5,32(s1)
    8000353a:	0017871b          	addiw	a4,a5,1
    8000353e:	0007069b          	sext.w	a3,a4
    80003542:	0027179b          	slliw	a5,a4,0x2
    80003546:	9fb9                	addw	a5,a5,a4
    80003548:	0017979b          	slliw	a5,a5,0x1
    8000354c:	54d8                	lw	a4,44(s1)
    8000354e:	9fb9                	addw	a5,a5,a4
    80003550:	00f95963          	bge	s2,a5,80003562 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003554:	85a6                	mv	a1,s1
    80003556:	8526                	mv	a0,s1
    80003558:	ffffe097          	auipc	ra,0xffffe
    8000355c:	fac080e7          	jalr	-84(ra) # 80001504 <sleep>
    80003560:	bfd1                	j	80003534 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003562:	00011517          	auipc	a0,0x11
    80003566:	ece50513          	addi	a0,a0,-306 # 80014430 <log>
    8000356a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000356c:	00003097          	auipc	ra,0x3
    80003570:	dba080e7          	jalr	-582(ra) # 80006326 <release>
      break;
    }
  }
}
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	64a2                	ld	s1,8(sp)
    8000357a:	6902                	ld	s2,0(sp)
    8000357c:	6105                	addi	sp,sp,32
    8000357e:	8082                	ret

0000000080003580 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003580:	7139                	addi	sp,sp,-64
    80003582:	fc06                	sd	ra,56(sp)
    80003584:	f822                	sd	s0,48(sp)
    80003586:	f426                	sd	s1,40(sp)
    80003588:	f04a                	sd	s2,32(sp)
    8000358a:	ec4e                	sd	s3,24(sp)
    8000358c:	e852                	sd	s4,16(sp)
    8000358e:	e456                	sd	s5,8(sp)
    80003590:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003592:	00011497          	auipc	s1,0x11
    80003596:	e9e48493          	addi	s1,s1,-354 # 80014430 <log>
    8000359a:	8526                	mv	a0,s1
    8000359c:	00003097          	auipc	ra,0x3
    800035a0:	cd6080e7          	jalr	-810(ra) # 80006272 <acquire>
  log.outstanding -= 1;
    800035a4:	509c                	lw	a5,32(s1)
    800035a6:	37fd                	addiw	a5,a5,-1
    800035a8:	0007891b          	sext.w	s2,a5
    800035ac:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035ae:	50dc                	lw	a5,36(s1)
    800035b0:	efb9                	bnez	a5,8000360e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035b2:	06091663          	bnez	s2,8000361e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800035b6:	00011497          	auipc	s1,0x11
    800035ba:	e7a48493          	addi	s1,s1,-390 # 80014430 <log>
    800035be:	4785                	li	a5,1
    800035c0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035c2:	8526                	mv	a0,s1
    800035c4:	00003097          	auipc	ra,0x3
    800035c8:	d62080e7          	jalr	-670(ra) # 80006326 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035cc:	54dc                	lw	a5,44(s1)
    800035ce:	06f04763          	bgtz	a5,8000363c <end_op+0xbc>
    acquire(&log.lock);
    800035d2:	00011497          	auipc	s1,0x11
    800035d6:	e5e48493          	addi	s1,s1,-418 # 80014430 <log>
    800035da:	8526                	mv	a0,s1
    800035dc:	00003097          	auipc	ra,0x3
    800035e0:	c96080e7          	jalr	-874(ra) # 80006272 <acquire>
    log.committing = 0;
    800035e4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035e8:	8526                	mv	a0,s1
    800035ea:	ffffe097          	auipc	ra,0xffffe
    800035ee:	0a6080e7          	jalr	166(ra) # 80001690 <wakeup>
    release(&log.lock);
    800035f2:	8526                	mv	a0,s1
    800035f4:	00003097          	auipc	ra,0x3
    800035f8:	d32080e7          	jalr	-718(ra) # 80006326 <release>
}
    800035fc:	70e2                	ld	ra,56(sp)
    800035fe:	7442                	ld	s0,48(sp)
    80003600:	74a2                	ld	s1,40(sp)
    80003602:	7902                	ld	s2,32(sp)
    80003604:	69e2                	ld	s3,24(sp)
    80003606:	6a42                	ld	s4,16(sp)
    80003608:	6aa2                	ld	s5,8(sp)
    8000360a:	6121                	addi	sp,sp,64
    8000360c:	8082                	ret
    panic("log.committing");
    8000360e:	00005517          	auipc	a0,0x5
    80003612:	fa250513          	addi	a0,a0,-94 # 800085b0 <syscalls+0x1e8>
    80003616:	00002097          	auipc	ra,0x2
    8000361a:	712080e7          	jalr	1810(ra) # 80005d28 <panic>
    wakeup(&log);
    8000361e:	00011497          	auipc	s1,0x11
    80003622:	e1248493          	addi	s1,s1,-494 # 80014430 <log>
    80003626:	8526                	mv	a0,s1
    80003628:	ffffe097          	auipc	ra,0xffffe
    8000362c:	068080e7          	jalr	104(ra) # 80001690 <wakeup>
  release(&log.lock);
    80003630:	8526                	mv	a0,s1
    80003632:	00003097          	auipc	ra,0x3
    80003636:	cf4080e7          	jalr	-780(ra) # 80006326 <release>
  if(do_commit){
    8000363a:	b7c9                	j	800035fc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363c:	00011a97          	auipc	s5,0x11
    80003640:	e24a8a93          	addi	s5,s5,-476 # 80014460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003644:	00011a17          	auipc	s4,0x11
    80003648:	deca0a13          	addi	s4,s4,-532 # 80014430 <log>
    8000364c:	018a2583          	lw	a1,24(s4)
    80003650:	012585bb          	addw	a1,a1,s2
    80003654:	2585                	addiw	a1,a1,1
    80003656:	028a2503          	lw	a0,40(s4)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	c0a080e7          	jalr	-1014(ra) # 80002264 <bread>
    80003662:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003664:	000aa583          	lw	a1,0(s5)
    80003668:	028a2503          	lw	a0,40(s4)
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	bf8080e7          	jalr	-1032(ra) # 80002264 <bread>
    80003674:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003676:	40000613          	li	a2,1024
    8000367a:	05850593          	addi	a1,a0,88
    8000367e:	05848513          	addi	a0,s1,88
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	b56080e7          	jalr	-1194(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000368a:	8526                	mv	a0,s1
    8000368c:	fffff097          	auipc	ra,0xfffff
    80003690:	cca080e7          	jalr	-822(ra) # 80002356 <bwrite>
    brelse(from);
    80003694:	854e                	mv	a0,s3
    80003696:	fffff097          	auipc	ra,0xfffff
    8000369a:	cfe080e7          	jalr	-770(ra) # 80002394 <brelse>
    brelse(to);
    8000369e:	8526                	mv	a0,s1
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	cf4080e7          	jalr	-780(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a8:	2905                	addiw	s2,s2,1
    800036aa:	0a91                	addi	s5,s5,4
    800036ac:	02ca2783          	lw	a5,44(s4)
    800036b0:	f8f94ee3          	blt	s2,a5,8000364c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	c6a080e7          	jalr	-918(ra) # 8000331e <write_head>
    install_trans(0); // Now install writes to home locations
    800036bc:	4501                	li	a0,0
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	cda080e7          	jalr	-806(ra) # 80003398 <install_trans>
    log.lh.n = 0;
    800036c6:	00011797          	auipc	a5,0x11
    800036ca:	d807ab23          	sw	zero,-618(a5) # 8001445c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036ce:	00000097          	auipc	ra,0x0
    800036d2:	c50080e7          	jalr	-944(ra) # 8000331e <write_head>
    800036d6:	bdf5                	j	800035d2 <end_op+0x52>

00000000800036d8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036d8:	1101                	addi	sp,sp,-32
    800036da:	ec06                	sd	ra,24(sp)
    800036dc:	e822                	sd	s0,16(sp)
    800036de:	e426                	sd	s1,8(sp)
    800036e0:	e04a                	sd	s2,0(sp)
    800036e2:	1000                	addi	s0,sp,32
    800036e4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036e6:	00011917          	auipc	s2,0x11
    800036ea:	d4a90913          	addi	s2,s2,-694 # 80014430 <log>
    800036ee:	854a                	mv	a0,s2
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	b82080e7          	jalr	-1150(ra) # 80006272 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036f8:	02c92603          	lw	a2,44(s2)
    800036fc:	47f5                	li	a5,29
    800036fe:	06c7c563          	blt	a5,a2,80003768 <log_write+0x90>
    80003702:	00011797          	auipc	a5,0x11
    80003706:	d4a7a783          	lw	a5,-694(a5) # 8001444c <log+0x1c>
    8000370a:	37fd                	addiw	a5,a5,-1
    8000370c:	04f65e63          	bge	a2,a5,80003768 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003710:	00011797          	auipc	a5,0x11
    80003714:	d407a783          	lw	a5,-704(a5) # 80014450 <log+0x20>
    80003718:	06f05063          	blez	a5,80003778 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000371c:	4781                	li	a5,0
    8000371e:	06c05563          	blez	a2,80003788 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003722:	44cc                	lw	a1,12(s1)
    80003724:	00011717          	auipc	a4,0x11
    80003728:	d3c70713          	addi	a4,a4,-708 # 80014460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000372c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000372e:	4314                	lw	a3,0(a4)
    80003730:	04b68c63          	beq	a3,a1,80003788 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003734:	2785                	addiw	a5,a5,1
    80003736:	0711                	addi	a4,a4,4
    80003738:	fef61be3          	bne	a2,a5,8000372e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000373c:	0621                	addi	a2,a2,8
    8000373e:	060a                	slli	a2,a2,0x2
    80003740:	00011797          	auipc	a5,0x11
    80003744:	cf078793          	addi	a5,a5,-784 # 80014430 <log>
    80003748:	963e                	add	a2,a2,a5
    8000374a:	44dc                	lw	a5,12(s1)
    8000374c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000374e:	8526                	mv	a0,s1
    80003750:	fffff097          	auipc	ra,0xfffff
    80003754:	ce2080e7          	jalr	-798(ra) # 80002432 <bpin>
    log.lh.n++;
    80003758:	00011717          	auipc	a4,0x11
    8000375c:	cd870713          	addi	a4,a4,-808 # 80014430 <log>
    80003760:	575c                	lw	a5,44(a4)
    80003762:	2785                	addiw	a5,a5,1
    80003764:	d75c                	sw	a5,44(a4)
    80003766:	a835                	j	800037a2 <log_write+0xca>
    panic("too big a transaction");
    80003768:	00005517          	auipc	a0,0x5
    8000376c:	e5850513          	addi	a0,a0,-424 # 800085c0 <syscalls+0x1f8>
    80003770:	00002097          	auipc	ra,0x2
    80003774:	5b8080e7          	jalr	1464(ra) # 80005d28 <panic>
    panic("log_write outside of trans");
    80003778:	00005517          	auipc	a0,0x5
    8000377c:	e6050513          	addi	a0,a0,-416 # 800085d8 <syscalls+0x210>
    80003780:	00002097          	auipc	ra,0x2
    80003784:	5a8080e7          	jalr	1448(ra) # 80005d28 <panic>
  log.lh.block[i] = b->blockno;
    80003788:	00878713          	addi	a4,a5,8
    8000378c:	00271693          	slli	a3,a4,0x2
    80003790:	00011717          	auipc	a4,0x11
    80003794:	ca070713          	addi	a4,a4,-864 # 80014430 <log>
    80003798:	9736                	add	a4,a4,a3
    8000379a:	44d4                	lw	a3,12(s1)
    8000379c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000379e:	faf608e3          	beq	a2,a5,8000374e <log_write+0x76>
  }
  release(&log.lock);
    800037a2:	00011517          	auipc	a0,0x11
    800037a6:	c8e50513          	addi	a0,a0,-882 # 80014430 <log>
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	b7c080e7          	jalr	-1156(ra) # 80006326 <release>
}
    800037b2:	60e2                	ld	ra,24(sp)
    800037b4:	6442                	ld	s0,16(sp)
    800037b6:	64a2                	ld	s1,8(sp)
    800037b8:	6902                	ld	s2,0(sp)
    800037ba:	6105                	addi	sp,sp,32
    800037bc:	8082                	ret

00000000800037be <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037be:	1101                	addi	sp,sp,-32
    800037c0:	ec06                	sd	ra,24(sp)
    800037c2:	e822                	sd	s0,16(sp)
    800037c4:	e426                	sd	s1,8(sp)
    800037c6:	e04a                	sd	s2,0(sp)
    800037c8:	1000                	addi	s0,sp,32
    800037ca:	84aa                	mv	s1,a0
    800037cc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037ce:	00005597          	auipc	a1,0x5
    800037d2:	e2a58593          	addi	a1,a1,-470 # 800085f8 <syscalls+0x230>
    800037d6:	0521                	addi	a0,a0,8
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	a0a080e7          	jalr	-1526(ra) # 800061e2 <initlock>
  lk->name = name;
    800037e0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037e8:	0204a423          	sw	zero,40(s1)
}
    800037ec:	60e2                	ld	ra,24(sp)
    800037ee:	6442                	ld	s0,16(sp)
    800037f0:	64a2                	ld	s1,8(sp)
    800037f2:	6902                	ld	s2,0(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret

00000000800037f8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	e426                	sd	s1,8(sp)
    80003800:	e04a                	sd	s2,0(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003806:	00850913          	addi	s2,a0,8
    8000380a:	854a                	mv	a0,s2
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	a66080e7          	jalr	-1434(ra) # 80006272 <acquire>
  while (lk->locked) {
    80003814:	409c                	lw	a5,0(s1)
    80003816:	cb89                	beqz	a5,80003828 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003818:	85ca                	mv	a1,s2
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	ce8080e7          	jalr	-792(ra) # 80001504 <sleep>
  while (lk->locked) {
    80003824:	409c                	lw	a5,0(s1)
    80003826:	fbed                	bnez	a5,80003818 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003828:	4785                	li	a5,1
    8000382a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000382c:	ffffd097          	auipc	ra,0xffffd
    80003830:	61c080e7          	jalr	1564(ra) # 80000e48 <myproc>
    80003834:	591c                	lw	a5,48(a0)
    80003836:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003838:	854a                	mv	a0,s2
    8000383a:	00003097          	auipc	ra,0x3
    8000383e:	aec080e7          	jalr	-1300(ra) # 80006326 <release>
}
    80003842:	60e2                	ld	ra,24(sp)
    80003844:	6442                	ld	s0,16(sp)
    80003846:	64a2                	ld	s1,8(sp)
    80003848:	6902                	ld	s2,0(sp)
    8000384a:	6105                	addi	sp,sp,32
    8000384c:	8082                	ret

000000008000384e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000384e:	1101                	addi	sp,sp,-32
    80003850:	ec06                	sd	ra,24(sp)
    80003852:	e822                	sd	s0,16(sp)
    80003854:	e426                	sd	s1,8(sp)
    80003856:	e04a                	sd	s2,0(sp)
    80003858:	1000                	addi	s0,sp,32
    8000385a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000385c:	00850913          	addi	s2,a0,8
    80003860:	854a                	mv	a0,s2
    80003862:	00003097          	auipc	ra,0x3
    80003866:	a10080e7          	jalr	-1520(ra) # 80006272 <acquire>
  lk->locked = 0;
    8000386a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000386e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003872:	8526                	mv	a0,s1
    80003874:	ffffe097          	auipc	ra,0xffffe
    80003878:	e1c080e7          	jalr	-484(ra) # 80001690 <wakeup>
  release(&lk->lk);
    8000387c:	854a                	mv	a0,s2
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	aa8080e7          	jalr	-1368(ra) # 80006326 <release>
}
    80003886:	60e2                	ld	ra,24(sp)
    80003888:	6442                	ld	s0,16(sp)
    8000388a:	64a2                	ld	s1,8(sp)
    8000388c:	6902                	ld	s2,0(sp)
    8000388e:	6105                	addi	sp,sp,32
    80003890:	8082                	ret

0000000080003892 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003892:	7179                	addi	sp,sp,-48
    80003894:	f406                	sd	ra,40(sp)
    80003896:	f022                	sd	s0,32(sp)
    80003898:	ec26                	sd	s1,24(sp)
    8000389a:	e84a                	sd	s2,16(sp)
    8000389c:	e44e                	sd	s3,8(sp)
    8000389e:	1800                	addi	s0,sp,48
    800038a0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038a2:	00850913          	addi	s2,a0,8
    800038a6:	854a                	mv	a0,s2
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	9ca080e7          	jalr	-1590(ra) # 80006272 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038b0:	409c                	lw	a5,0(s1)
    800038b2:	ef99                	bnez	a5,800038d0 <holdingsleep+0x3e>
    800038b4:	4481                	li	s1,0
  release(&lk->lk);
    800038b6:	854a                	mv	a0,s2
    800038b8:	00003097          	auipc	ra,0x3
    800038bc:	a6e080e7          	jalr	-1426(ra) # 80006326 <release>
  return r;
}
    800038c0:	8526                	mv	a0,s1
    800038c2:	70a2                	ld	ra,40(sp)
    800038c4:	7402                	ld	s0,32(sp)
    800038c6:	64e2                	ld	s1,24(sp)
    800038c8:	6942                	ld	s2,16(sp)
    800038ca:	69a2                	ld	s3,8(sp)
    800038cc:	6145                	addi	sp,sp,48
    800038ce:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038d0:	0284a983          	lw	s3,40(s1)
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	574080e7          	jalr	1396(ra) # 80000e48 <myproc>
    800038dc:	5904                	lw	s1,48(a0)
    800038de:	413484b3          	sub	s1,s1,s3
    800038e2:	0014b493          	seqz	s1,s1
    800038e6:	bfc1                	j	800038b6 <holdingsleep+0x24>

00000000800038e8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038e8:	1141                	addi	sp,sp,-16
    800038ea:	e406                	sd	ra,8(sp)
    800038ec:	e022                	sd	s0,0(sp)
    800038ee:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038f0:	00005597          	auipc	a1,0x5
    800038f4:	d1858593          	addi	a1,a1,-744 # 80008608 <syscalls+0x240>
    800038f8:	00011517          	auipc	a0,0x11
    800038fc:	c8050513          	addi	a0,a0,-896 # 80014578 <ftable>
    80003900:	00003097          	auipc	ra,0x3
    80003904:	8e2080e7          	jalr	-1822(ra) # 800061e2 <initlock>
}
    80003908:	60a2                	ld	ra,8(sp)
    8000390a:	6402                	ld	s0,0(sp)
    8000390c:	0141                	addi	sp,sp,16
    8000390e:	8082                	ret

0000000080003910 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003910:	1101                	addi	sp,sp,-32
    80003912:	ec06                	sd	ra,24(sp)
    80003914:	e822                	sd	s0,16(sp)
    80003916:	e426                	sd	s1,8(sp)
    80003918:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000391a:	00011517          	auipc	a0,0x11
    8000391e:	c5e50513          	addi	a0,a0,-930 # 80014578 <ftable>
    80003922:	00003097          	auipc	ra,0x3
    80003926:	950080e7          	jalr	-1712(ra) # 80006272 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000392a:	00011497          	auipc	s1,0x11
    8000392e:	c6648493          	addi	s1,s1,-922 # 80014590 <ftable+0x18>
    80003932:	00012717          	auipc	a4,0x12
    80003936:	bfe70713          	addi	a4,a4,-1026 # 80015530 <ftable+0xfb8>
    if(f->ref == 0){
    8000393a:	40dc                	lw	a5,4(s1)
    8000393c:	cf99                	beqz	a5,8000395a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000393e:	02848493          	addi	s1,s1,40
    80003942:	fee49ce3          	bne	s1,a4,8000393a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003946:	00011517          	auipc	a0,0x11
    8000394a:	c3250513          	addi	a0,a0,-974 # 80014578 <ftable>
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	9d8080e7          	jalr	-1576(ra) # 80006326 <release>
  return 0;
    80003956:	4481                	li	s1,0
    80003958:	a819                	j	8000396e <filealloc+0x5e>
      f->ref = 1;
    8000395a:	4785                	li	a5,1
    8000395c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000395e:	00011517          	auipc	a0,0x11
    80003962:	c1a50513          	addi	a0,a0,-998 # 80014578 <ftable>
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	9c0080e7          	jalr	-1600(ra) # 80006326 <release>
}
    8000396e:	8526                	mv	a0,s1
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6105                	addi	sp,sp,32
    80003978:	8082                	ret

000000008000397a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000397a:	1101                	addi	sp,sp,-32
    8000397c:	ec06                	sd	ra,24(sp)
    8000397e:	e822                	sd	s0,16(sp)
    80003980:	e426                	sd	s1,8(sp)
    80003982:	1000                	addi	s0,sp,32
    80003984:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003986:	00011517          	auipc	a0,0x11
    8000398a:	bf250513          	addi	a0,a0,-1038 # 80014578 <ftable>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	8e4080e7          	jalr	-1820(ra) # 80006272 <acquire>
  if(f->ref < 1)
    80003996:	40dc                	lw	a5,4(s1)
    80003998:	02f05263          	blez	a5,800039bc <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000399c:	2785                	addiw	a5,a5,1
    8000399e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039a0:	00011517          	auipc	a0,0x11
    800039a4:	bd850513          	addi	a0,a0,-1064 # 80014578 <ftable>
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	97e080e7          	jalr	-1666(ra) # 80006326 <release>
  return f;
}
    800039b0:	8526                	mv	a0,s1
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6105                	addi	sp,sp,32
    800039ba:	8082                	ret
    panic("filedup");
    800039bc:	00005517          	auipc	a0,0x5
    800039c0:	c5450513          	addi	a0,a0,-940 # 80008610 <syscalls+0x248>
    800039c4:	00002097          	auipc	ra,0x2
    800039c8:	364080e7          	jalr	868(ra) # 80005d28 <panic>

00000000800039cc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039cc:	7139                	addi	sp,sp,-64
    800039ce:	fc06                	sd	ra,56(sp)
    800039d0:	f822                	sd	s0,48(sp)
    800039d2:	f426                	sd	s1,40(sp)
    800039d4:	f04a                	sd	s2,32(sp)
    800039d6:	ec4e                	sd	s3,24(sp)
    800039d8:	e852                	sd	s4,16(sp)
    800039da:	e456                	sd	s5,8(sp)
    800039dc:	0080                	addi	s0,sp,64
    800039de:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039e0:	00011517          	auipc	a0,0x11
    800039e4:	b9850513          	addi	a0,a0,-1128 # 80014578 <ftable>
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	88a080e7          	jalr	-1910(ra) # 80006272 <acquire>
  if(f->ref < 1)
    800039f0:	40dc                	lw	a5,4(s1)
    800039f2:	06f05163          	blez	a5,80003a54 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039f6:	37fd                	addiw	a5,a5,-1
    800039f8:	0007871b          	sext.w	a4,a5
    800039fc:	c0dc                	sw	a5,4(s1)
    800039fe:	06e04363          	bgtz	a4,80003a64 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a02:	0004a903          	lw	s2,0(s1)
    80003a06:	0094ca83          	lbu	s5,9(s1)
    80003a0a:	0104ba03          	ld	s4,16(s1)
    80003a0e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a12:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a16:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a1a:	00011517          	auipc	a0,0x11
    80003a1e:	b5e50513          	addi	a0,a0,-1186 # 80014578 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	904080e7          	jalr	-1788(ra) # 80006326 <release>

  if(ff.type == FD_PIPE){
    80003a2a:	4785                	li	a5,1
    80003a2c:	04f90d63          	beq	s2,a5,80003a86 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a30:	3979                	addiw	s2,s2,-2
    80003a32:	4785                	li	a5,1
    80003a34:	0527e063          	bltu	a5,s2,80003a74 <fileclose+0xa8>
    begin_op();
    80003a38:	00000097          	auipc	ra,0x0
    80003a3c:	ac8080e7          	jalr	-1336(ra) # 80003500 <begin_op>
    iput(ff.ip);
    80003a40:	854e                	mv	a0,s3
    80003a42:	fffff097          	auipc	ra,0xfffff
    80003a46:	2a4080e7          	jalr	676(ra) # 80002ce6 <iput>
    end_op();
    80003a4a:	00000097          	auipc	ra,0x0
    80003a4e:	b36080e7          	jalr	-1226(ra) # 80003580 <end_op>
    80003a52:	a00d                	j	80003a74 <fileclose+0xa8>
    panic("fileclose");
    80003a54:	00005517          	auipc	a0,0x5
    80003a58:	bc450513          	addi	a0,a0,-1084 # 80008618 <syscalls+0x250>
    80003a5c:	00002097          	auipc	ra,0x2
    80003a60:	2cc080e7          	jalr	716(ra) # 80005d28 <panic>
    release(&ftable.lock);
    80003a64:	00011517          	auipc	a0,0x11
    80003a68:	b1450513          	addi	a0,a0,-1260 # 80014578 <ftable>
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	8ba080e7          	jalr	-1862(ra) # 80006326 <release>
  }
}
    80003a74:	70e2                	ld	ra,56(sp)
    80003a76:	7442                	ld	s0,48(sp)
    80003a78:	74a2                	ld	s1,40(sp)
    80003a7a:	7902                	ld	s2,32(sp)
    80003a7c:	69e2                	ld	s3,24(sp)
    80003a7e:	6a42                	ld	s4,16(sp)
    80003a80:	6aa2                	ld	s5,8(sp)
    80003a82:	6121                	addi	sp,sp,64
    80003a84:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a86:	85d6                	mv	a1,s5
    80003a88:	8552                	mv	a0,s4
    80003a8a:	00000097          	auipc	ra,0x0
    80003a8e:	34c080e7          	jalr	844(ra) # 80003dd6 <pipeclose>
    80003a92:	b7cd                	j	80003a74 <fileclose+0xa8>

0000000080003a94 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a94:	715d                	addi	sp,sp,-80
    80003a96:	e486                	sd	ra,72(sp)
    80003a98:	e0a2                	sd	s0,64(sp)
    80003a9a:	fc26                	sd	s1,56(sp)
    80003a9c:	f84a                	sd	s2,48(sp)
    80003a9e:	f44e                	sd	s3,40(sp)
    80003aa0:	0880                	addi	s0,sp,80
    80003aa2:	84aa                	mv	s1,a0
    80003aa4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	3a2080e7          	jalr	930(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003aae:	409c                	lw	a5,0(s1)
    80003ab0:	37f9                	addiw	a5,a5,-2
    80003ab2:	4705                	li	a4,1
    80003ab4:	04f76763          	bltu	a4,a5,80003b02 <filestat+0x6e>
    80003ab8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aba:	6c88                	ld	a0,24(s1)
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	070080e7          	jalr	112(ra) # 80002b2c <ilock>
    stati(f->ip, &st);
    80003ac4:	fb840593          	addi	a1,s0,-72
    80003ac8:	6c88                	ld	a0,24(s1)
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	2ec080e7          	jalr	748(ra) # 80002db6 <stati>
    iunlock(f->ip);
    80003ad2:	6c88                	ld	a0,24(s1)
    80003ad4:	fffff097          	auipc	ra,0xfffff
    80003ad8:	11a080e7          	jalr	282(ra) # 80002bee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003adc:	46e1                	li	a3,24
    80003ade:	fb840613          	addi	a2,s0,-72
    80003ae2:	85ce                	mv	a1,s3
    80003ae4:	05093503          	ld	a0,80(s2)
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	022080e7          	jalr	34(ra) # 80000b0a <copyout>
    80003af0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003af4:	60a6                	ld	ra,72(sp)
    80003af6:	6406                	ld	s0,64(sp)
    80003af8:	74e2                	ld	s1,56(sp)
    80003afa:	7942                	ld	s2,48(sp)
    80003afc:	79a2                	ld	s3,40(sp)
    80003afe:	6161                	addi	sp,sp,80
    80003b00:	8082                	ret
  return -1;
    80003b02:	557d                	li	a0,-1
    80003b04:	bfc5                	j	80003af4 <filestat+0x60>

0000000080003b06 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b06:	7179                	addi	sp,sp,-48
    80003b08:	f406                	sd	ra,40(sp)
    80003b0a:	f022                	sd	s0,32(sp)
    80003b0c:	ec26                	sd	s1,24(sp)
    80003b0e:	e84a                	sd	s2,16(sp)
    80003b10:	e44e                	sd	s3,8(sp)
    80003b12:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b14:	00854783          	lbu	a5,8(a0)
    80003b18:	c3d5                	beqz	a5,80003bbc <fileread+0xb6>
    80003b1a:	84aa                	mv	s1,a0
    80003b1c:	89ae                	mv	s3,a1
    80003b1e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b20:	411c                	lw	a5,0(a0)
    80003b22:	4705                	li	a4,1
    80003b24:	04e78963          	beq	a5,a4,80003b76 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b28:	470d                	li	a4,3
    80003b2a:	04e78d63          	beq	a5,a4,80003b84 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b2e:	4709                	li	a4,2
    80003b30:	06e79e63          	bne	a5,a4,80003bac <fileread+0xa6>
    ilock(f->ip);
    80003b34:	6d08                	ld	a0,24(a0)
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	ff6080e7          	jalr	-10(ra) # 80002b2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b3e:	874a                	mv	a4,s2
    80003b40:	5094                	lw	a3,32(s1)
    80003b42:	864e                	mv	a2,s3
    80003b44:	4585                	li	a1,1
    80003b46:	6c88                	ld	a0,24(s1)
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	298080e7          	jalr	664(ra) # 80002de0 <readi>
    80003b50:	892a                	mv	s2,a0
    80003b52:	00a05563          	blez	a0,80003b5c <fileread+0x56>
      f->off += r;
    80003b56:	509c                	lw	a5,32(s1)
    80003b58:	9fa9                	addw	a5,a5,a0
    80003b5a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b5c:	6c88                	ld	a0,24(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	090080e7          	jalr	144(ra) # 80002bee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b66:	854a                	mv	a0,s2
    80003b68:	70a2                	ld	ra,40(sp)
    80003b6a:	7402                	ld	s0,32(sp)
    80003b6c:	64e2                	ld	s1,24(sp)
    80003b6e:	6942                	ld	s2,16(sp)
    80003b70:	69a2                	ld	s3,8(sp)
    80003b72:	6145                	addi	sp,sp,48
    80003b74:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b76:	6908                	ld	a0,16(a0)
    80003b78:	00000097          	auipc	ra,0x0
    80003b7c:	3c8080e7          	jalr	968(ra) # 80003f40 <piperead>
    80003b80:	892a                	mv	s2,a0
    80003b82:	b7d5                	j	80003b66 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b84:	02451783          	lh	a5,36(a0)
    80003b88:	03079693          	slli	a3,a5,0x30
    80003b8c:	92c1                	srli	a3,a3,0x30
    80003b8e:	4725                	li	a4,9
    80003b90:	02d76863          	bltu	a4,a3,80003bc0 <fileread+0xba>
    80003b94:	0792                	slli	a5,a5,0x4
    80003b96:	00011717          	auipc	a4,0x11
    80003b9a:	94270713          	addi	a4,a4,-1726 # 800144d8 <devsw>
    80003b9e:	97ba                	add	a5,a5,a4
    80003ba0:	639c                	ld	a5,0(a5)
    80003ba2:	c38d                	beqz	a5,80003bc4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ba4:	4505                	li	a0,1
    80003ba6:	9782                	jalr	a5
    80003ba8:	892a                	mv	s2,a0
    80003baa:	bf75                	j	80003b66 <fileread+0x60>
    panic("fileread");
    80003bac:	00005517          	auipc	a0,0x5
    80003bb0:	a7c50513          	addi	a0,a0,-1412 # 80008628 <syscalls+0x260>
    80003bb4:	00002097          	auipc	ra,0x2
    80003bb8:	174080e7          	jalr	372(ra) # 80005d28 <panic>
    return -1;
    80003bbc:	597d                	li	s2,-1
    80003bbe:	b765                	j	80003b66 <fileread+0x60>
      return -1;
    80003bc0:	597d                	li	s2,-1
    80003bc2:	b755                	j	80003b66 <fileread+0x60>
    80003bc4:	597d                	li	s2,-1
    80003bc6:	b745                	j	80003b66 <fileread+0x60>

0000000080003bc8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bc8:	715d                	addi	sp,sp,-80
    80003bca:	e486                	sd	ra,72(sp)
    80003bcc:	e0a2                	sd	s0,64(sp)
    80003bce:	fc26                	sd	s1,56(sp)
    80003bd0:	f84a                	sd	s2,48(sp)
    80003bd2:	f44e                	sd	s3,40(sp)
    80003bd4:	f052                	sd	s4,32(sp)
    80003bd6:	ec56                	sd	s5,24(sp)
    80003bd8:	e85a                	sd	s6,16(sp)
    80003bda:	e45e                	sd	s7,8(sp)
    80003bdc:	e062                	sd	s8,0(sp)
    80003bde:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003be0:	00954783          	lbu	a5,9(a0)
    80003be4:	10078663          	beqz	a5,80003cf0 <filewrite+0x128>
    80003be8:	892a                	mv	s2,a0
    80003bea:	8aae                	mv	s5,a1
    80003bec:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bee:	411c                	lw	a5,0(a0)
    80003bf0:	4705                	li	a4,1
    80003bf2:	02e78263          	beq	a5,a4,80003c16 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf6:	470d                	li	a4,3
    80003bf8:	02e78663          	beq	a5,a4,80003c24 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfc:	4709                	li	a4,2
    80003bfe:	0ee79163          	bne	a5,a4,80003ce0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c02:	0ac05d63          	blez	a2,80003cbc <filewrite+0xf4>
    int i = 0;
    80003c06:	4981                	li	s3,0
    80003c08:	6b05                	lui	s6,0x1
    80003c0a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c0e:	6b85                	lui	s7,0x1
    80003c10:	c00b8b9b          	addiw	s7,s7,-1024
    80003c14:	a861                	j	80003cac <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c16:	6908                	ld	a0,16(a0)
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	22e080e7          	jalr	558(ra) # 80003e46 <pipewrite>
    80003c20:	8a2a                	mv	s4,a0
    80003c22:	a045                	j	80003cc2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c24:	02451783          	lh	a5,36(a0)
    80003c28:	03079693          	slli	a3,a5,0x30
    80003c2c:	92c1                	srli	a3,a3,0x30
    80003c2e:	4725                	li	a4,9
    80003c30:	0cd76263          	bltu	a4,a3,80003cf4 <filewrite+0x12c>
    80003c34:	0792                	slli	a5,a5,0x4
    80003c36:	00011717          	auipc	a4,0x11
    80003c3a:	8a270713          	addi	a4,a4,-1886 # 800144d8 <devsw>
    80003c3e:	97ba                	add	a5,a5,a4
    80003c40:	679c                	ld	a5,8(a5)
    80003c42:	cbdd                	beqz	a5,80003cf8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c44:	4505                	li	a0,1
    80003c46:	9782                	jalr	a5
    80003c48:	8a2a                	mv	s4,a0
    80003c4a:	a8a5                	j	80003cc2 <filewrite+0xfa>
    80003c4c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	8b0080e7          	jalr	-1872(ra) # 80003500 <begin_op>
      ilock(f->ip);
    80003c58:	01893503          	ld	a0,24(s2)
    80003c5c:	fffff097          	auipc	ra,0xfffff
    80003c60:	ed0080e7          	jalr	-304(ra) # 80002b2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c64:	8762                	mv	a4,s8
    80003c66:	02092683          	lw	a3,32(s2)
    80003c6a:	01598633          	add	a2,s3,s5
    80003c6e:	4585                	li	a1,1
    80003c70:	01893503          	ld	a0,24(s2)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	264080e7          	jalr	612(ra) # 80002ed8 <writei>
    80003c7c:	84aa                	mv	s1,a0
    80003c7e:	00a05763          	blez	a0,80003c8c <filewrite+0xc4>
        f->off += r;
    80003c82:	02092783          	lw	a5,32(s2)
    80003c86:	9fa9                	addw	a5,a5,a0
    80003c88:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c8c:	01893503          	ld	a0,24(s2)
    80003c90:	fffff097          	auipc	ra,0xfffff
    80003c94:	f5e080e7          	jalr	-162(ra) # 80002bee <iunlock>
      end_op();
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	8e8080e7          	jalr	-1816(ra) # 80003580 <end_op>

      if(r != n1){
    80003ca0:	009c1f63          	bne	s8,s1,80003cbe <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ca4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ca8:	0149db63          	bge	s3,s4,80003cbe <filewrite+0xf6>
      int n1 = n - i;
    80003cac:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cb0:	84be                	mv	s1,a5
    80003cb2:	2781                	sext.w	a5,a5
    80003cb4:	f8fb5ce3          	bge	s6,a5,80003c4c <filewrite+0x84>
    80003cb8:	84de                	mv	s1,s7
    80003cba:	bf49                	j	80003c4c <filewrite+0x84>
    int i = 0;
    80003cbc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cbe:	013a1f63          	bne	s4,s3,80003cdc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cc2:	8552                	mv	a0,s4
    80003cc4:	60a6                	ld	ra,72(sp)
    80003cc6:	6406                	ld	s0,64(sp)
    80003cc8:	74e2                	ld	s1,56(sp)
    80003cca:	7942                	ld	s2,48(sp)
    80003ccc:	79a2                	ld	s3,40(sp)
    80003cce:	7a02                	ld	s4,32(sp)
    80003cd0:	6ae2                	ld	s5,24(sp)
    80003cd2:	6b42                	ld	s6,16(sp)
    80003cd4:	6ba2                	ld	s7,8(sp)
    80003cd6:	6c02                	ld	s8,0(sp)
    80003cd8:	6161                	addi	sp,sp,80
    80003cda:	8082                	ret
    ret = (i == n ? n : -1);
    80003cdc:	5a7d                	li	s4,-1
    80003cde:	b7d5                	j	80003cc2 <filewrite+0xfa>
    panic("filewrite");
    80003ce0:	00005517          	auipc	a0,0x5
    80003ce4:	95850513          	addi	a0,a0,-1704 # 80008638 <syscalls+0x270>
    80003ce8:	00002097          	auipc	ra,0x2
    80003cec:	040080e7          	jalr	64(ra) # 80005d28 <panic>
    return -1;
    80003cf0:	5a7d                	li	s4,-1
    80003cf2:	bfc1                	j	80003cc2 <filewrite+0xfa>
      return -1;
    80003cf4:	5a7d                	li	s4,-1
    80003cf6:	b7f1                	j	80003cc2 <filewrite+0xfa>
    80003cf8:	5a7d                	li	s4,-1
    80003cfa:	b7e1                	j	80003cc2 <filewrite+0xfa>

0000000080003cfc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cfc:	7179                	addi	sp,sp,-48
    80003cfe:	f406                	sd	ra,40(sp)
    80003d00:	f022                	sd	s0,32(sp)
    80003d02:	ec26                	sd	s1,24(sp)
    80003d04:	e84a                	sd	s2,16(sp)
    80003d06:	e44e                	sd	s3,8(sp)
    80003d08:	e052                	sd	s4,0(sp)
    80003d0a:	1800                	addi	s0,sp,48
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d10:	0005b023          	sd	zero,0(a1)
    80003d14:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	bf8080e7          	jalr	-1032(ra) # 80003910 <filealloc>
    80003d20:	e088                	sd	a0,0(s1)
    80003d22:	c551                	beqz	a0,80003dae <pipealloc+0xb2>
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	bec080e7          	jalr	-1044(ra) # 80003910 <filealloc>
    80003d2c:	00aa3023          	sd	a0,0(s4)
    80003d30:	c92d                	beqz	a0,80003da2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d32:	ffffc097          	auipc	ra,0xffffc
    80003d36:	3e6080e7          	jalr	998(ra) # 80000118 <kalloc>
    80003d3a:	892a                	mv	s2,a0
    80003d3c:	c125                	beqz	a0,80003d9c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d3e:	4985                	li	s3,1
    80003d40:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d44:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d48:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d4c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d50:	00005597          	auipc	a1,0x5
    80003d54:	8f858593          	addi	a1,a1,-1800 # 80008648 <syscalls+0x280>
    80003d58:	00002097          	auipc	ra,0x2
    80003d5c:	48a080e7          	jalr	1162(ra) # 800061e2 <initlock>
  (*f0)->type = FD_PIPE;
    80003d60:	609c                	ld	a5,0(s1)
    80003d62:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d66:	609c                	ld	a5,0(s1)
    80003d68:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d6c:	609c                	ld	a5,0(s1)
    80003d6e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d72:	609c                	ld	a5,0(s1)
    80003d74:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d78:	000a3783          	ld	a5,0(s4)
    80003d7c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d80:	000a3783          	ld	a5,0(s4)
    80003d84:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d88:	000a3783          	ld	a5,0(s4)
    80003d8c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d90:	000a3783          	ld	a5,0(s4)
    80003d94:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d98:	4501                	li	a0,0
    80003d9a:	a025                	j	80003dc2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d9c:	6088                	ld	a0,0(s1)
    80003d9e:	e501                	bnez	a0,80003da6 <pipealloc+0xaa>
    80003da0:	a039                	j	80003dae <pipealloc+0xb2>
    80003da2:	6088                	ld	a0,0(s1)
    80003da4:	c51d                	beqz	a0,80003dd2 <pipealloc+0xd6>
    fileclose(*f0);
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	c26080e7          	jalr	-986(ra) # 800039cc <fileclose>
  if(*f1)
    80003dae:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003db2:	557d                	li	a0,-1
  if(*f1)
    80003db4:	c799                	beqz	a5,80003dc2 <pipealloc+0xc6>
    fileclose(*f1);
    80003db6:	853e                	mv	a0,a5
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	c14080e7          	jalr	-1004(ra) # 800039cc <fileclose>
  return -1;
    80003dc0:	557d                	li	a0,-1
}
    80003dc2:	70a2                	ld	ra,40(sp)
    80003dc4:	7402                	ld	s0,32(sp)
    80003dc6:	64e2                	ld	s1,24(sp)
    80003dc8:	6942                	ld	s2,16(sp)
    80003dca:	69a2                	ld	s3,8(sp)
    80003dcc:	6a02                	ld	s4,0(sp)
    80003dce:	6145                	addi	sp,sp,48
    80003dd0:	8082                	ret
  return -1;
    80003dd2:	557d                	li	a0,-1
    80003dd4:	b7fd                	j	80003dc2 <pipealloc+0xc6>

0000000080003dd6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dd6:	1101                	addi	sp,sp,-32
    80003dd8:	ec06                	sd	ra,24(sp)
    80003dda:	e822                	sd	s0,16(sp)
    80003ddc:	e426                	sd	s1,8(sp)
    80003dde:	e04a                	sd	s2,0(sp)
    80003de0:	1000                	addi	s0,sp,32
    80003de2:	84aa                	mv	s1,a0
    80003de4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	48c080e7          	jalr	1164(ra) # 80006272 <acquire>
  if(writable){
    80003dee:	02090d63          	beqz	s2,80003e28 <pipeclose+0x52>
    pi->writeopen = 0;
    80003df2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003df6:	21848513          	addi	a0,s1,536
    80003dfa:	ffffe097          	auipc	ra,0xffffe
    80003dfe:	896080e7          	jalr	-1898(ra) # 80001690 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e02:	2204b783          	ld	a5,544(s1)
    80003e06:	eb95                	bnez	a5,80003e3a <pipeclose+0x64>
    release(&pi->lock);
    80003e08:	8526                	mv	a0,s1
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	51c080e7          	jalr	1308(ra) # 80006326 <release>
    kfree((char*)pi);
    80003e12:	8526                	mv	a0,s1
    80003e14:	ffffc097          	auipc	ra,0xffffc
    80003e18:	208080e7          	jalr	520(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e1c:	60e2                	ld	ra,24(sp)
    80003e1e:	6442                	ld	s0,16(sp)
    80003e20:	64a2                	ld	s1,8(sp)
    80003e22:	6902                	ld	s2,0(sp)
    80003e24:	6105                	addi	sp,sp,32
    80003e26:	8082                	ret
    pi->readopen = 0;
    80003e28:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e2c:	21c48513          	addi	a0,s1,540
    80003e30:	ffffe097          	auipc	ra,0xffffe
    80003e34:	860080e7          	jalr	-1952(ra) # 80001690 <wakeup>
    80003e38:	b7e9                	j	80003e02 <pipeclose+0x2c>
    release(&pi->lock);
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	00002097          	auipc	ra,0x2
    80003e40:	4ea080e7          	jalr	1258(ra) # 80006326 <release>
}
    80003e44:	bfe1                	j	80003e1c <pipeclose+0x46>

0000000080003e46 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e46:	7159                	addi	sp,sp,-112
    80003e48:	f486                	sd	ra,104(sp)
    80003e4a:	f0a2                	sd	s0,96(sp)
    80003e4c:	eca6                	sd	s1,88(sp)
    80003e4e:	e8ca                	sd	s2,80(sp)
    80003e50:	e4ce                	sd	s3,72(sp)
    80003e52:	e0d2                	sd	s4,64(sp)
    80003e54:	fc56                	sd	s5,56(sp)
    80003e56:	f85a                	sd	s6,48(sp)
    80003e58:	f45e                	sd	s7,40(sp)
    80003e5a:	f062                	sd	s8,32(sp)
    80003e5c:	ec66                	sd	s9,24(sp)
    80003e5e:	1880                	addi	s0,sp,112
    80003e60:	84aa                	mv	s1,a0
    80003e62:	8aae                	mv	s5,a1
    80003e64:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e66:	ffffd097          	auipc	ra,0xffffd
    80003e6a:	fe2080e7          	jalr	-30(ra) # 80000e48 <myproc>
    80003e6e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e70:	8526                	mv	a0,s1
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	400080e7          	jalr	1024(ra) # 80006272 <acquire>
  while(i < n){
    80003e7a:	0d405163          	blez	s4,80003f3c <pipewrite+0xf6>
    80003e7e:	8ba6                	mv	s7,s1
  int i = 0;
    80003e80:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e82:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e84:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e88:	21c48c13          	addi	s8,s1,540
    80003e8c:	a08d                	j	80003eee <pipewrite+0xa8>
      release(&pi->lock);
    80003e8e:	8526                	mv	a0,s1
    80003e90:	00002097          	auipc	ra,0x2
    80003e94:	496080e7          	jalr	1174(ra) # 80006326 <release>
      return -1;
    80003e98:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e9a:	854a                	mv	a0,s2
    80003e9c:	70a6                	ld	ra,104(sp)
    80003e9e:	7406                	ld	s0,96(sp)
    80003ea0:	64e6                	ld	s1,88(sp)
    80003ea2:	6946                	ld	s2,80(sp)
    80003ea4:	69a6                	ld	s3,72(sp)
    80003ea6:	6a06                	ld	s4,64(sp)
    80003ea8:	7ae2                	ld	s5,56(sp)
    80003eaa:	7b42                	ld	s6,48(sp)
    80003eac:	7ba2                	ld	s7,40(sp)
    80003eae:	7c02                	ld	s8,32(sp)
    80003eb0:	6ce2                	ld	s9,24(sp)
    80003eb2:	6165                	addi	sp,sp,112
    80003eb4:	8082                	ret
      wakeup(&pi->nread);
    80003eb6:	8566                	mv	a0,s9
    80003eb8:	ffffd097          	auipc	ra,0xffffd
    80003ebc:	7d8080e7          	jalr	2008(ra) # 80001690 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ec0:	85de                	mv	a1,s7
    80003ec2:	8562                	mv	a0,s8
    80003ec4:	ffffd097          	auipc	ra,0xffffd
    80003ec8:	640080e7          	jalr	1600(ra) # 80001504 <sleep>
    80003ecc:	a839                	j	80003eea <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ece:	21c4a783          	lw	a5,540(s1)
    80003ed2:	0017871b          	addiw	a4,a5,1
    80003ed6:	20e4ae23          	sw	a4,540(s1)
    80003eda:	1ff7f793          	andi	a5,a5,511
    80003ede:	97a6                	add	a5,a5,s1
    80003ee0:	f9f44703          	lbu	a4,-97(s0)
    80003ee4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ee8:	2905                	addiw	s2,s2,1
  while(i < n){
    80003eea:	03495d63          	bge	s2,s4,80003f24 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003eee:	2204a783          	lw	a5,544(s1)
    80003ef2:	dfd1                	beqz	a5,80003e8e <pipewrite+0x48>
    80003ef4:	0289a783          	lw	a5,40(s3)
    80003ef8:	fbd9                	bnez	a5,80003e8e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003efa:	2184a783          	lw	a5,536(s1)
    80003efe:	21c4a703          	lw	a4,540(s1)
    80003f02:	2007879b          	addiw	a5,a5,512
    80003f06:	faf708e3          	beq	a4,a5,80003eb6 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f0a:	4685                	li	a3,1
    80003f0c:	01590633          	add	a2,s2,s5
    80003f10:	f9f40593          	addi	a1,s0,-97
    80003f14:	0509b503          	ld	a0,80(s3)
    80003f18:	ffffd097          	auipc	ra,0xffffd
    80003f1c:	c7e080e7          	jalr	-898(ra) # 80000b96 <copyin>
    80003f20:	fb6517e3          	bne	a0,s6,80003ece <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f24:	21848513          	addi	a0,s1,536
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	768080e7          	jalr	1896(ra) # 80001690 <wakeup>
  release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	3f4080e7          	jalr	1012(ra) # 80006326 <release>
  return i;
    80003f3a:	b785                	j	80003e9a <pipewrite+0x54>
  int i = 0;
    80003f3c:	4901                	li	s2,0
    80003f3e:	b7dd                	j	80003f24 <pipewrite+0xde>

0000000080003f40 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f40:	715d                	addi	sp,sp,-80
    80003f42:	e486                	sd	ra,72(sp)
    80003f44:	e0a2                	sd	s0,64(sp)
    80003f46:	fc26                	sd	s1,56(sp)
    80003f48:	f84a                	sd	s2,48(sp)
    80003f4a:	f44e                	sd	s3,40(sp)
    80003f4c:	f052                	sd	s4,32(sp)
    80003f4e:	ec56                	sd	s5,24(sp)
    80003f50:	e85a                	sd	s6,16(sp)
    80003f52:	0880                	addi	s0,sp,80
    80003f54:	84aa                	mv	s1,a0
    80003f56:	892e                	mv	s2,a1
    80003f58:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	eee080e7          	jalr	-274(ra) # 80000e48 <myproc>
    80003f62:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f64:	8b26                	mv	s6,s1
    80003f66:	8526                	mv	a0,s1
    80003f68:	00002097          	auipc	ra,0x2
    80003f6c:	30a080e7          	jalr	778(ra) # 80006272 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f70:	2184a703          	lw	a4,536(s1)
    80003f74:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f78:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f7c:	02f71463          	bne	a4,a5,80003fa4 <piperead+0x64>
    80003f80:	2244a783          	lw	a5,548(s1)
    80003f84:	c385                	beqz	a5,80003fa4 <piperead+0x64>
    if(pr->killed){
    80003f86:	028a2783          	lw	a5,40(s4)
    80003f8a:	ebc1                	bnez	a5,8000401a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f8c:	85da                	mv	a1,s6
    80003f8e:	854e                	mv	a0,s3
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	574080e7          	jalr	1396(ra) # 80001504 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f98:	2184a703          	lw	a4,536(s1)
    80003f9c:	21c4a783          	lw	a5,540(s1)
    80003fa0:	fef700e3          	beq	a4,a5,80003f80 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa4:	09505263          	blez	s5,80004028 <piperead+0xe8>
    80003fa8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003faa:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003fac:	2184a783          	lw	a5,536(s1)
    80003fb0:	21c4a703          	lw	a4,540(s1)
    80003fb4:	02f70d63          	beq	a4,a5,80003fee <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fb8:	0017871b          	addiw	a4,a5,1
    80003fbc:	20e4ac23          	sw	a4,536(s1)
    80003fc0:	1ff7f793          	andi	a5,a5,511
    80003fc4:	97a6                	add	a5,a5,s1
    80003fc6:	0187c783          	lbu	a5,24(a5)
    80003fca:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fce:	4685                	li	a3,1
    80003fd0:	fbf40613          	addi	a2,s0,-65
    80003fd4:	85ca                	mv	a1,s2
    80003fd6:	050a3503          	ld	a0,80(s4)
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	b30080e7          	jalr	-1232(ra) # 80000b0a <copyout>
    80003fe2:	01650663          	beq	a0,s6,80003fee <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fe6:	2985                	addiw	s3,s3,1
    80003fe8:	0905                	addi	s2,s2,1
    80003fea:	fd3a91e3          	bne	s5,s3,80003fac <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fee:	21c48513          	addi	a0,s1,540
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	69e080e7          	jalr	1694(ra) # 80001690 <wakeup>
  release(&pi->lock);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00002097          	auipc	ra,0x2
    80004000:	32a080e7          	jalr	810(ra) # 80006326 <release>
  return i;
}
    80004004:	854e                	mv	a0,s3
    80004006:	60a6                	ld	ra,72(sp)
    80004008:	6406                	ld	s0,64(sp)
    8000400a:	74e2                	ld	s1,56(sp)
    8000400c:	7942                	ld	s2,48(sp)
    8000400e:	79a2                	ld	s3,40(sp)
    80004010:	7a02                	ld	s4,32(sp)
    80004012:	6ae2                	ld	s5,24(sp)
    80004014:	6b42                	ld	s6,16(sp)
    80004016:	6161                	addi	sp,sp,80
    80004018:	8082                	ret
      release(&pi->lock);
    8000401a:	8526                	mv	a0,s1
    8000401c:	00002097          	auipc	ra,0x2
    80004020:	30a080e7          	jalr	778(ra) # 80006326 <release>
      return -1;
    80004024:	59fd                	li	s3,-1
    80004026:	bff9                	j	80004004 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004028:	4981                	li	s3,0
    8000402a:	b7d1                	j	80003fee <piperead+0xae>

000000008000402c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000402c:	df010113          	addi	sp,sp,-528
    80004030:	20113423          	sd	ra,520(sp)
    80004034:	20813023          	sd	s0,512(sp)
    80004038:	ffa6                	sd	s1,504(sp)
    8000403a:	fbca                	sd	s2,496(sp)
    8000403c:	f7ce                	sd	s3,488(sp)
    8000403e:	f3d2                	sd	s4,480(sp)
    80004040:	efd6                	sd	s5,472(sp)
    80004042:	ebda                	sd	s6,464(sp)
    80004044:	e7de                	sd	s7,456(sp)
    80004046:	e3e2                	sd	s8,448(sp)
    80004048:	ff66                	sd	s9,440(sp)
    8000404a:	fb6a                	sd	s10,432(sp)
    8000404c:	f76e                	sd	s11,424(sp)
    8000404e:	0c00                	addi	s0,sp,528
    80004050:	84aa                	mv	s1,a0
    80004052:	dea43c23          	sd	a0,-520(s0)
    80004056:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	dee080e7          	jalr	-530(ra) # 80000e48 <myproc>
    80004062:	892a                	mv	s2,a0

  begin_op();
    80004064:	fffff097          	auipc	ra,0xfffff
    80004068:	49c080e7          	jalr	1180(ra) # 80003500 <begin_op>

  if((ip = namei(path)) == 0){
    8000406c:	8526                	mv	a0,s1
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	276080e7          	jalr	630(ra) # 800032e4 <namei>
    80004076:	c92d                	beqz	a0,800040e8 <exec+0xbc>
    80004078:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000407a:	fffff097          	auipc	ra,0xfffff
    8000407e:	ab2080e7          	jalr	-1358(ra) # 80002b2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004082:	04000713          	li	a4,64
    80004086:	4681                	li	a3,0
    80004088:	e5040613          	addi	a2,s0,-432
    8000408c:	4581                	li	a1,0
    8000408e:	8526                	mv	a0,s1
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	d50080e7          	jalr	-688(ra) # 80002de0 <readi>
    80004098:	04000793          	li	a5,64
    8000409c:	00f51a63          	bne	a0,a5,800040b0 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040a0:	e5042703          	lw	a4,-432(s0)
    800040a4:	464c47b7          	lui	a5,0x464c4
    800040a8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040ac:	04f70463          	beq	a4,a5,800040f4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040b0:	8526                	mv	a0,s1
    800040b2:	fffff097          	auipc	ra,0xfffff
    800040b6:	cdc080e7          	jalr	-804(ra) # 80002d8e <iunlockput>
    end_op();
    800040ba:	fffff097          	auipc	ra,0xfffff
    800040be:	4c6080e7          	jalr	1222(ra) # 80003580 <end_op>
  }
  return -1;
    800040c2:	557d                	li	a0,-1
}
    800040c4:	20813083          	ld	ra,520(sp)
    800040c8:	20013403          	ld	s0,512(sp)
    800040cc:	74fe                	ld	s1,504(sp)
    800040ce:	795e                	ld	s2,496(sp)
    800040d0:	79be                	ld	s3,488(sp)
    800040d2:	7a1e                	ld	s4,480(sp)
    800040d4:	6afe                	ld	s5,472(sp)
    800040d6:	6b5e                	ld	s6,464(sp)
    800040d8:	6bbe                	ld	s7,456(sp)
    800040da:	6c1e                	ld	s8,448(sp)
    800040dc:	7cfa                	ld	s9,440(sp)
    800040de:	7d5a                	ld	s10,432(sp)
    800040e0:	7dba                	ld	s11,424(sp)
    800040e2:	21010113          	addi	sp,sp,528
    800040e6:	8082                	ret
    end_op();
    800040e8:	fffff097          	auipc	ra,0xfffff
    800040ec:	498080e7          	jalr	1176(ra) # 80003580 <end_op>
    return -1;
    800040f0:	557d                	li	a0,-1
    800040f2:	bfc9                	j	800040c4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800040f4:	854a                	mv	a0,s2
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	e16080e7          	jalr	-490(ra) # 80000f0c <proc_pagetable>
    800040fe:	8baa                	mv	s7,a0
    80004100:	d945                	beqz	a0,800040b0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004102:	e7042983          	lw	s3,-400(s0)
    80004106:	e8845783          	lhu	a5,-376(s0)
    8000410a:	c7ad                	beqz	a5,80004174 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000410c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000410e:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004110:	6c85                	lui	s9,0x1
    80004112:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004116:	def43823          	sd	a5,-528(s0)
    8000411a:	a42d                	j	80004344 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000411c:	00004517          	auipc	a0,0x4
    80004120:	53450513          	addi	a0,a0,1332 # 80008650 <syscalls+0x288>
    80004124:	00002097          	auipc	ra,0x2
    80004128:	c04080e7          	jalr	-1020(ra) # 80005d28 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000412c:	8756                	mv	a4,s5
    8000412e:	012d86bb          	addw	a3,s11,s2
    80004132:	4581                	li	a1,0
    80004134:	8526                	mv	a0,s1
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	caa080e7          	jalr	-854(ra) # 80002de0 <readi>
    8000413e:	2501                	sext.w	a0,a0
    80004140:	1aaa9963          	bne	s5,a0,800042f2 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004144:	6785                	lui	a5,0x1
    80004146:	0127893b          	addw	s2,a5,s2
    8000414a:	77fd                	lui	a5,0xfffff
    8000414c:	01478a3b          	addw	s4,a5,s4
    80004150:	1f897163          	bgeu	s2,s8,80004332 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004154:	02091593          	slli	a1,s2,0x20
    80004158:	9181                	srli	a1,a1,0x20
    8000415a:	95ea                	add	a1,a1,s10
    8000415c:	855e                	mv	a0,s7
    8000415e:	ffffc097          	auipc	ra,0xffffc
    80004162:	3a8080e7          	jalr	936(ra) # 80000506 <walkaddr>
    80004166:	862a                	mv	a2,a0
    if(pa == 0)
    80004168:	d955                	beqz	a0,8000411c <exec+0xf0>
      n = PGSIZE;
    8000416a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000416c:	fd9a70e3          	bgeu	s4,s9,8000412c <exec+0x100>
      n = sz - i;
    80004170:	8ad2                	mv	s5,s4
    80004172:	bf6d                	j	8000412c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004174:	4901                	li	s2,0
  iunlockput(ip);
    80004176:	8526                	mv	a0,s1
    80004178:	fffff097          	auipc	ra,0xfffff
    8000417c:	c16080e7          	jalr	-1002(ra) # 80002d8e <iunlockput>
  end_op();
    80004180:	fffff097          	auipc	ra,0xfffff
    80004184:	400080e7          	jalr	1024(ra) # 80003580 <end_op>
  p = myproc();
    80004188:	ffffd097          	auipc	ra,0xffffd
    8000418c:	cc0080e7          	jalr	-832(ra) # 80000e48 <myproc>
    80004190:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004192:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004196:	6785                	lui	a5,0x1
    80004198:	17fd                	addi	a5,a5,-1
    8000419a:	993e                	add	s2,s2,a5
    8000419c:	757d                	lui	a0,0xfffff
    8000419e:	00a977b3          	and	a5,s2,a0
    800041a2:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041a6:	6609                	lui	a2,0x2
    800041a8:	963e                	add	a2,a2,a5
    800041aa:	85be                	mv	a1,a5
    800041ac:	855e                	mv	a0,s7
    800041ae:	ffffc097          	auipc	ra,0xffffc
    800041b2:	70c080e7          	jalr	1804(ra) # 800008ba <uvmalloc>
    800041b6:	8b2a                	mv	s6,a0
  ip = 0;
    800041b8:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041ba:	12050c63          	beqz	a0,800042f2 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041be:	75f9                	lui	a1,0xffffe
    800041c0:	95aa                	add	a1,a1,a0
    800041c2:	855e                	mv	a0,s7
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	914080e7          	jalr	-1772(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800041cc:	7c7d                	lui	s8,0xfffff
    800041ce:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800041d0:	e0043783          	ld	a5,-512(s0)
    800041d4:	6388                	ld	a0,0(a5)
    800041d6:	c535                	beqz	a0,80004242 <exec+0x216>
    800041d8:	e9040993          	addi	s3,s0,-368
    800041dc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041e0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800041e2:	ffffc097          	auipc	ra,0xffffc
    800041e6:	11a080e7          	jalr	282(ra) # 800002fc <strlen>
    800041ea:	2505                	addiw	a0,a0,1
    800041ec:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041f0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041f4:	13896363          	bltu	s2,s8,8000431a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041f8:	e0043d83          	ld	s11,-512(s0)
    800041fc:	000dba03          	ld	s4,0(s11)
    80004200:	8552                	mv	a0,s4
    80004202:	ffffc097          	auipc	ra,0xffffc
    80004206:	0fa080e7          	jalr	250(ra) # 800002fc <strlen>
    8000420a:	0015069b          	addiw	a3,a0,1
    8000420e:	8652                	mv	a2,s4
    80004210:	85ca                	mv	a1,s2
    80004212:	855e                	mv	a0,s7
    80004214:	ffffd097          	auipc	ra,0xffffd
    80004218:	8f6080e7          	jalr	-1802(ra) # 80000b0a <copyout>
    8000421c:	10054363          	bltz	a0,80004322 <exec+0x2f6>
    ustack[argc] = sp;
    80004220:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004224:	0485                	addi	s1,s1,1
    80004226:	008d8793          	addi	a5,s11,8
    8000422a:	e0f43023          	sd	a5,-512(s0)
    8000422e:	008db503          	ld	a0,8(s11)
    80004232:	c911                	beqz	a0,80004246 <exec+0x21a>
    if(argc >= MAXARG)
    80004234:	09a1                	addi	s3,s3,8
    80004236:	fb3c96e3          	bne	s9,s3,800041e2 <exec+0x1b6>
  sz = sz1;
    8000423a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000423e:	4481                	li	s1,0
    80004240:	a84d                	j	800042f2 <exec+0x2c6>
  sp = sz;
    80004242:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004244:	4481                	li	s1,0
  ustack[argc] = 0;
    80004246:	00349793          	slli	a5,s1,0x3
    8000424a:	f9040713          	addi	a4,s0,-112
    8000424e:	97ba                	add	a5,a5,a4
    80004250:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004254:	00148693          	addi	a3,s1,1
    80004258:	068e                	slli	a3,a3,0x3
    8000425a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000425e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004262:	01897663          	bgeu	s2,s8,8000426e <exec+0x242>
  sz = sz1;
    80004266:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000426a:	4481                	li	s1,0
    8000426c:	a059                	j	800042f2 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000426e:	e9040613          	addi	a2,s0,-368
    80004272:	85ca                	mv	a1,s2
    80004274:	855e                	mv	a0,s7
    80004276:	ffffd097          	auipc	ra,0xffffd
    8000427a:	894080e7          	jalr	-1900(ra) # 80000b0a <copyout>
    8000427e:	0a054663          	bltz	a0,8000432a <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004282:	058ab783          	ld	a5,88(s5)
    80004286:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000428a:	df843783          	ld	a5,-520(s0)
    8000428e:	0007c703          	lbu	a4,0(a5)
    80004292:	cf11                	beqz	a4,800042ae <exec+0x282>
    80004294:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004296:	02f00693          	li	a3,47
    8000429a:	a039                	j	800042a8 <exec+0x27c>
      last = s+1;
    8000429c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042a0:	0785                	addi	a5,a5,1
    800042a2:	fff7c703          	lbu	a4,-1(a5)
    800042a6:	c701                	beqz	a4,800042ae <exec+0x282>
    if(*s == '/')
    800042a8:	fed71ce3          	bne	a4,a3,800042a0 <exec+0x274>
    800042ac:	bfc5                	j	8000429c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800042ae:	4641                	li	a2,16
    800042b0:	df843583          	ld	a1,-520(s0)
    800042b4:	158a8513          	addi	a0,s5,344
    800042b8:	ffffc097          	auipc	ra,0xffffc
    800042bc:	012080e7          	jalr	18(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800042c0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042c4:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800042c8:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042cc:	058ab783          	ld	a5,88(s5)
    800042d0:	e6843703          	ld	a4,-408(s0)
    800042d4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042d6:	058ab783          	ld	a5,88(s5)
    800042da:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042de:	85ea                	mv	a1,s10
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	cc8080e7          	jalr	-824(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042e8:	0004851b          	sext.w	a0,s1
    800042ec:	bbe1                	j	800040c4 <exec+0x98>
    800042ee:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800042f2:	e0843583          	ld	a1,-504(s0)
    800042f6:	855e                	mv	a0,s7
    800042f8:	ffffd097          	auipc	ra,0xffffd
    800042fc:	cb0080e7          	jalr	-848(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004300:	da0498e3          	bnez	s1,800040b0 <exec+0x84>
  return -1;
    80004304:	557d                	li	a0,-1
    80004306:	bb7d                	j	800040c4 <exec+0x98>
    80004308:	e1243423          	sd	s2,-504(s0)
    8000430c:	b7dd                	j	800042f2 <exec+0x2c6>
    8000430e:	e1243423          	sd	s2,-504(s0)
    80004312:	b7c5                	j	800042f2 <exec+0x2c6>
    80004314:	e1243423          	sd	s2,-504(s0)
    80004318:	bfe9                	j	800042f2 <exec+0x2c6>
  sz = sz1;
    8000431a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000431e:	4481                	li	s1,0
    80004320:	bfc9                	j	800042f2 <exec+0x2c6>
  sz = sz1;
    80004322:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004326:	4481                	li	s1,0
    80004328:	b7e9                	j	800042f2 <exec+0x2c6>
  sz = sz1;
    8000432a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000432e:	4481                	li	s1,0
    80004330:	b7c9                	j	800042f2 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004332:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004336:	2b05                	addiw	s6,s6,1
    80004338:	0389899b          	addiw	s3,s3,56
    8000433c:	e8845783          	lhu	a5,-376(s0)
    80004340:	e2fb5be3          	bge	s6,a5,80004176 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004344:	2981                	sext.w	s3,s3
    80004346:	03800713          	li	a4,56
    8000434a:	86ce                	mv	a3,s3
    8000434c:	e1840613          	addi	a2,s0,-488
    80004350:	4581                	li	a1,0
    80004352:	8526                	mv	a0,s1
    80004354:	fffff097          	auipc	ra,0xfffff
    80004358:	a8c080e7          	jalr	-1396(ra) # 80002de0 <readi>
    8000435c:	03800793          	li	a5,56
    80004360:	f8f517e3          	bne	a0,a5,800042ee <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004364:	e1842783          	lw	a5,-488(s0)
    80004368:	4705                	li	a4,1
    8000436a:	fce796e3          	bne	a5,a4,80004336 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000436e:	e4043603          	ld	a2,-448(s0)
    80004372:	e3843783          	ld	a5,-456(s0)
    80004376:	f8f669e3          	bltu	a2,a5,80004308 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000437a:	e2843783          	ld	a5,-472(s0)
    8000437e:	963e                	add	a2,a2,a5
    80004380:	f8f667e3          	bltu	a2,a5,8000430e <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004384:	85ca                	mv	a1,s2
    80004386:	855e                	mv	a0,s7
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	532080e7          	jalr	1330(ra) # 800008ba <uvmalloc>
    80004390:	e0a43423          	sd	a0,-504(s0)
    80004394:	d141                	beqz	a0,80004314 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004396:	e2843d03          	ld	s10,-472(s0)
    8000439a:	df043783          	ld	a5,-528(s0)
    8000439e:	00fd77b3          	and	a5,s10,a5
    800043a2:	fba1                	bnez	a5,800042f2 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043a4:	e2042d83          	lw	s11,-480(s0)
    800043a8:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043ac:	f80c03e3          	beqz	s8,80004332 <exec+0x306>
    800043b0:	8a62                	mv	s4,s8
    800043b2:	4901                	li	s2,0
    800043b4:	b345                	j	80004154 <exec+0x128>

00000000800043b6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043b6:	7179                	addi	sp,sp,-48
    800043b8:	f406                	sd	ra,40(sp)
    800043ba:	f022                	sd	s0,32(sp)
    800043bc:	ec26                	sd	s1,24(sp)
    800043be:	e84a                	sd	s2,16(sp)
    800043c0:	1800                	addi	s0,sp,48
    800043c2:	892e                	mv	s2,a1
    800043c4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043c6:	fdc40593          	addi	a1,s0,-36
    800043ca:	ffffe097          	auipc	ra,0xffffe
    800043ce:	b2a080e7          	jalr	-1238(ra) # 80001ef4 <argint>
    800043d2:	04054063          	bltz	a0,80004412 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043d6:	fdc42703          	lw	a4,-36(s0)
    800043da:	47bd                	li	a5,15
    800043dc:	02e7ed63          	bltu	a5,a4,80004416 <argfd+0x60>
    800043e0:	ffffd097          	auipc	ra,0xffffd
    800043e4:	a68080e7          	jalr	-1432(ra) # 80000e48 <myproc>
    800043e8:	fdc42703          	lw	a4,-36(s0)
    800043ec:	01a70793          	addi	a5,a4,26
    800043f0:	078e                	slli	a5,a5,0x3
    800043f2:	953e                	add	a0,a0,a5
    800043f4:	611c                	ld	a5,0(a0)
    800043f6:	c395                	beqz	a5,8000441a <argfd+0x64>
    return -1;
  if(pfd)
    800043f8:	00090463          	beqz	s2,80004400 <argfd+0x4a>
    *pfd = fd;
    800043fc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004400:	4501                	li	a0,0
  if(pf)
    80004402:	c091                	beqz	s1,80004406 <argfd+0x50>
    *pf = f;
    80004404:	e09c                	sd	a5,0(s1)
}
    80004406:	70a2                	ld	ra,40(sp)
    80004408:	7402                	ld	s0,32(sp)
    8000440a:	64e2                	ld	s1,24(sp)
    8000440c:	6942                	ld	s2,16(sp)
    8000440e:	6145                	addi	sp,sp,48
    80004410:	8082                	ret
    return -1;
    80004412:	557d                	li	a0,-1
    80004414:	bfcd                	j	80004406 <argfd+0x50>
    return -1;
    80004416:	557d                	li	a0,-1
    80004418:	b7fd                	j	80004406 <argfd+0x50>
    8000441a:	557d                	li	a0,-1
    8000441c:	b7ed                	j	80004406 <argfd+0x50>

000000008000441e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000441e:	1101                	addi	sp,sp,-32
    80004420:	ec06                	sd	ra,24(sp)
    80004422:	e822                	sd	s0,16(sp)
    80004424:	e426                	sd	s1,8(sp)
    80004426:	1000                	addi	s0,sp,32
    80004428:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000442a:	ffffd097          	auipc	ra,0xffffd
    8000442e:	a1e080e7          	jalr	-1506(ra) # 80000e48 <myproc>
    80004432:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004434:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdde90>
    80004438:	4501                	li	a0,0
    8000443a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000443c:	6398                	ld	a4,0(a5)
    8000443e:	cb19                	beqz	a4,80004454 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004440:	2505                	addiw	a0,a0,1
    80004442:	07a1                	addi	a5,a5,8
    80004444:	fed51ce3          	bne	a0,a3,8000443c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004448:	557d                	li	a0,-1
}
    8000444a:	60e2                	ld	ra,24(sp)
    8000444c:	6442                	ld	s0,16(sp)
    8000444e:	64a2                	ld	s1,8(sp)
    80004450:	6105                	addi	sp,sp,32
    80004452:	8082                	ret
      p->ofile[fd] = f;
    80004454:	01a50793          	addi	a5,a0,26
    80004458:	078e                	slli	a5,a5,0x3
    8000445a:	963e                	add	a2,a2,a5
    8000445c:	e204                	sd	s1,0(a2)
      return fd;
    8000445e:	b7f5                	j	8000444a <fdalloc+0x2c>

0000000080004460 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004460:	715d                	addi	sp,sp,-80
    80004462:	e486                	sd	ra,72(sp)
    80004464:	e0a2                	sd	s0,64(sp)
    80004466:	fc26                	sd	s1,56(sp)
    80004468:	f84a                	sd	s2,48(sp)
    8000446a:	f44e                	sd	s3,40(sp)
    8000446c:	f052                	sd	s4,32(sp)
    8000446e:	ec56                	sd	s5,24(sp)
    80004470:	0880                	addi	s0,sp,80
    80004472:	89ae                	mv	s3,a1
    80004474:	8ab2                	mv	s5,a2
    80004476:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004478:	fb040593          	addi	a1,s0,-80
    8000447c:	fffff097          	auipc	ra,0xfffff
    80004480:	e86080e7          	jalr	-378(ra) # 80003302 <nameiparent>
    80004484:	892a                	mv	s2,a0
    80004486:	12050f63          	beqz	a0,800045c4 <create+0x164>
    return 0;

  ilock(dp);
    8000448a:	ffffe097          	auipc	ra,0xffffe
    8000448e:	6a2080e7          	jalr	1698(ra) # 80002b2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004492:	4601                	li	a2,0
    80004494:	fb040593          	addi	a1,s0,-80
    80004498:	854a                	mv	a0,s2
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	b78080e7          	jalr	-1160(ra) # 80003012 <dirlookup>
    800044a2:	84aa                	mv	s1,a0
    800044a4:	c921                	beqz	a0,800044f4 <create+0x94>
    iunlockput(dp);
    800044a6:	854a                	mv	a0,s2
    800044a8:	fffff097          	auipc	ra,0xfffff
    800044ac:	8e6080e7          	jalr	-1818(ra) # 80002d8e <iunlockput>
    ilock(ip);
    800044b0:	8526                	mv	a0,s1
    800044b2:	ffffe097          	auipc	ra,0xffffe
    800044b6:	67a080e7          	jalr	1658(ra) # 80002b2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044ba:	2981                	sext.w	s3,s3
    800044bc:	4789                	li	a5,2
    800044be:	02f99463          	bne	s3,a5,800044e6 <create+0x86>
    800044c2:	0444d783          	lhu	a5,68(s1)
    800044c6:	37f9                	addiw	a5,a5,-2
    800044c8:	17c2                	slli	a5,a5,0x30
    800044ca:	93c1                	srli	a5,a5,0x30
    800044cc:	4705                	li	a4,1
    800044ce:	00f76c63          	bltu	a4,a5,800044e6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044d2:	8526                	mv	a0,s1
    800044d4:	60a6                	ld	ra,72(sp)
    800044d6:	6406                	ld	s0,64(sp)
    800044d8:	74e2                	ld	s1,56(sp)
    800044da:	7942                	ld	s2,48(sp)
    800044dc:	79a2                	ld	s3,40(sp)
    800044de:	7a02                	ld	s4,32(sp)
    800044e0:	6ae2                	ld	s5,24(sp)
    800044e2:	6161                	addi	sp,sp,80
    800044e4:	8082                	ret
    iunlockput(ip);
    800044e6:	8526                	mv	a0,s1
    800044e8:	fffff097          	auipc	ra,0xfffff
    800044ec:	8a6080e7          	jalr	-1882(ra) # 80002d8e <iunlockput>
    return 0;
    800044f0:	4481                	li	s1,0
    800044f2:	b7c5                	j	800044d2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800044f4:	85ce                	mv	a1,s3
    800044f6:	00092503          	lw	a0,0(s2)
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	49a080e7          	jalr	1178(ra) # 80002994 <ialloc>
    80004502:	84aa                	mv	s1,a0
    80004504:	c529                	beqz	a0,8000454e <create+0xee>
  ilock(ip);
    80004506:	ffffe097          	auipc	ra,0xffffe
    8000450a:	626080e7          	jalr	1574(ra) # 80002b2c <ilock>
  ip->major = major;
    8000450e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004512:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004516:	4785                	li	a5,1
    80004518:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000451c:	8526                	mv	a0,s1
    8000451e:	ffffe097          	auipc	ra,0xffffe
    80004522:	544080e7          	jalr	1348(ra) # 80002a62 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004526:	2981                	sext.w	s3,s3
    80004528:	4785                	li	a5,1
    8000452a:	02f98a63          	beq	s3,a5,8000455e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000452e:	40d0                	lw	a2,4(s1)
    80004530:	fb040593          	addi	a1,s0,-80
    80004534:	854a                	mv	a0,s2
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	cec080e7          	jalr	-788(ra) # 80003222 <dirlink>
    8000453e:	06054b63          	bltz	a0,800045b4 <create+0x154>
  iunlockput(dp);
    80004542:	854a                	mv	a0,s2
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	84a080e7          	jalr	-1974(ra) # 80002d8e <iunlockput>
  return ip;
    8000454c:	b759                	j	800044d2 <create+0x72>
    panic("create: ialloc");
    8000454e:	00004517          	auipc	a0,0x4
    80004552:	12250513          	addi	a0,a0,290 # 80008670 <syscalls+0x2a8>
    80004556:	00001097          	auipc	ra,0x1
    8000455a:	7d2080e7          	jalr	2002(ra) # 80005d28 <panic>
    dp->nlink++;  // for ".."
    8000455e:	04a95783          	lhu	a5,74(s2)
    80004562:	2785                	addiw	a5,a5,1
    80004564:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004568:	854a                	mv	a0,s2
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	4f8080e7          	jalr	1272(ra) # 80002a62 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004572:	40d0                	lw	a2,4(s1)
    80004574:	00004597          	auipc	a1,0x4
    80004578:	10c58593          	addi	a1,a1,268 # 80008680 <syscalls+0x2b8>
    8000457c:	8526                	mv	a0,s1
    8000457e:	fffff097          	auipc	ra,0xfffff
    80004582:	ca4080e7          	jalr	-860(ra) # 80003222 <dirlink>
    80004586:	00054f63          	bltz	a0,800045a4 <create+0x144>
    8000458a:	00492603          	lw	a2,4(s2)
    8000458e:	00004597          	auipc	a1,0x4
    80004592:	0fa58593          	addi	a1,a1,250 # 80008688 <syscalls+0x2c0>
    80004596:	8526                	mv	a0,s1
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	c8a080e7          	jalr	-886(ra) # 80003222 <dirlink>
    800045a0:	f80557e3          	bgez	a0,8000452e <create+0xce>
      panic("create dots");
    800045a4:	00004517          	auipc	a0,0x4
    800045a8:	0ec50513          	addi	a0,a0,236 # 80008690 <syscalls+0x2c8>
    800045ac:	00001097          	auipc	ra,0x1
    800045b0:	77c080e7          	jalr	1916(ra) # 80005d28 <panic>
    panic("create: dirlink");
    800045b4:	00004517          	auipc	a0,0x4
    800045b8:	0ec50513          	addi	a0,a0,236 # 800086a0 <syscalls+0x2d8>
    800045bc:	00001097          	auipc	ra,0x1
    800045c0:	76c080e7          	jalr	1900(ra) # 80005d28 <panic>
    return 0;
    800045c4:	84aa                	mv	s1,a0
    800045c6:	b731                	j	800044d2 <create+0x72>

00000000800045c8 <sys_dup>:
{
    800045c8:	7179                	addi	sp,sp,-48
    800045ca:	f406                	sd	ra,40(sp)
    800045cc:	f022                	sd	s0,32(sp)
    800045ce:	ec26                	sd	s1,24(sp)
    800045d0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045d2:	fd840613          	addi	a2,s0,-40
    800045d6:	4581                	li	a1,0
    800045d8:	4501                	li	a0,0
    800045da:	00000097          	auipc	ra,0x0
    800045de:	ddc080e7          	jalr	-548(ra) # 800043b6 <argfd>
    return -1;
    800045e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045e4:	02054363          	bltz	a0,8000460a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045e8:	fd843503          	ld	a0,-40(s0)
    800045ec:	00000097          	auipc	ra,0x0
    800045f0:	e32080e7          	jalr	-462(ra) # 8000441e <fdalloc>
    800045f4:	84aa                	mv	s1,a0
    return -1;
    800045f6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045f8:	00054963          	bltz	a0,8000460a <sys_dup+0x42>
  filedup(f);
    800045fc:	fd843503          	ld	a0,-40(s0)
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	37a080e7          	jalr	890(ra) # 8000397a <filedup>
  return fd;
    80004608:	87a6                	mv	a5,s1
}
    8000460a:	853e                	mv	a0,a5
    8000460c:	70a2                	ld	ra,40(sp)
    8000460e:	7402                	ld	s0,32(sp)
    80004610:	64e2                	ld	s1,24(sp)
    80004612:	6145                	addi	sp,sp,48
    80004614:	8082                	ret

0000000080004616 <sys_read>:
{
    80004616:	7179                	addi	sp,sp,-48
    80004618:	f406                	sd	ra,40(sp)
    8000461a:	f022                	sd	s0,32(sp)
    8000461c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000461e:	fe840613          	addi	a2,s0,-24
    80004622:	4581                	li	a1,0
    80004624:	4501                	li	a0,0
    80004626:	00000097          	auipc	ra,0x0
    8000462a:	d90080e7          	jalr	-624(ra) # 800043b6 <argfd>
    return -1;
    8000462e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004630:	04054163          	bltz	a0,80004672 <sys_read+0x5c>
    80004634:	fe440593          	addi	a1,s0,-28
    80004638:	4509                	li	a0,2
    8000463a:	ffffe097          	auipc	ra,0xffffe
    8000463e:	8ba080e7          	jalr	-1862(ra) # 80001ef4 <argint>
    return -1;
    80004642:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004644:	02054763          	bltz	a0,80004672 <sys_read+0x5c>
    80004648:	fd840593          	addi	a1,s0,-40
    8000464c:	4505                	li	a0,1
    8000464e:	ffffe097          	auipc	ra,0xffffe
    80004652:	8c8080e7          	jalr	-1848(ra) # 80001f16 <argaddr>
    return -1;
    80004656:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004658:	00054d63          	bltz	a0,80004672 <sys_read+0x5c>
  return fileread(f, p, n);
    8000465c:	fe442603          	lw	a2,-28(s0)
    80004660:	fd843583          	ld	a1,-40(s0)
    80004664:	fe843503          	ld	a0,-24(s0)
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	49e080e7          	jalr	1182(ra) # 80003b06 <fileread>
    80004670:	87aa                	mv	a5,a0
}
    80004672:	853e                	mv	a0,a5
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	6145                	addi	sp,sp,48
    8000467a:	8082                	ret

000000008000467c <sys_write>:
{
    8000467c:	7179                	addi	sp,sp,-48
    8000467e:	f406                	sd	ra,40(sp)
    80004680:	f022                	sd	s0,32(sp)
    80004682:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004684:	fe840613          	addi	a2,s0,-24
    80004688:	4581                	li	a1,0
    8000468a:	4501                	li	a0,0
    8000468c:	00000097          	auipc	ra,0x0
    80004690:	d2a080e7          	jalr	-726(ra) # 800043b6 <argfd>
    return -1;
    80004694:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004696:	04054163          	bltz	a0,800046d8 <sys_write+0x5c>
    8000469a:	fe440593          	addi	a1,s0,-28
    8000469e:	4509                	li	a0,2
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	854080e7          	jalr	-1964(ra) # 80001ef4 <argint>
    return -1;
    800046a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046aa:	02054763          	bltz	a0,800046d8 <sys_write+0x5c>
    800046ae:	fd840593          	addi	a1,s0,-40
    800046b2:	4505                	li	a0,1
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	862080e7          	jalr	-1950(ra) # 80001f16 <argaddr>
    return -1;
    800046bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046be:	00054d63          	bltz	a0,800046d8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800046c2:	fe442603          	lw	a2,-28(s0)
    800046c6:	fd843583          	ld	a1,-40(s0)
    800046ca:	fe843503          	ld	a0,-24(s0)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	4fa080e7          	jalr	1274(ra) # 80003bc8 <filewrite>
    800046d6:	87aa                	mv	a5,a0
}
    800046d8:	853e                	mv	a0,a5
    800046da:	70a2                	ld	ra,40(sp)
    800046dc:	7402                	ld	s0,32(sp)
    800046de:	6145                	addi	sp,sp,48
    800046e0:	8082                	ret

00000000800046e2 <sys_close>:
{
    800046e2:	1101                	addi	sp,sp,-32
    800046e4:	ec06                	sd	ra,24(sp)
    800046e6:	e822                	sd	s0,16(sp)
    800046e8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046ea:	fe040613          	addi	a2,s0,-32
    800046ee:	fec40593          	addi	a1,s0,-20
    800046f2:	4501                	li	a0,0
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	cc2080e7          	jalr	-830(ra) # 800043b6 <argfd>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046fe:	02054463          	bltz	a0,80004726 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	746080e7          	jalr	1862(ra) # 80000e48 <myproc>
    8000470a:	fec42783          	lw	a5,-20(s0)
    8000470e:	07e9                	addi	a5,a5,26
    80004710:	078e                	slli	a5,a5,0x3
    80004712:	97aa                	add	a5,a5,a0
    80004714:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004718:	fe043503          	ld	a0,-32(s0)
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	2b0080e7          	jalr	688(ra) # 800039cc <fileclose>
  return 0;
    80004724:	4781                	li	a5,0
}
    80004726:	853e                	mv	a0,a5
    80004728:	60e2                	ld	ra,24(sp)
    8000472a:	6442                	ld	s0,16(sp)
    8000472c:	6105                	addi	sp,sp,32
    8000472e:	8082                	ret

0000000080004730 <sys_fstat>:
{
    80004730:	1101                	addi	sp,sp,-32
    80004732:	ec06                	sd	ra,24(sp)
    80004734:	e822                	sd	s0,16(sp)
    80004736:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004738:	fe840613          	addi	a2,s0,-24
    8000473c:	4581                	li	a1,0
    8000473e:	4501                	li	a0,0
    80004740:	00000097          	auipc	ra,0x0
    80004744:	c76080e7          	jalr	-906(ra) # 800043b6 <argfd>
    return -1;
    80004748:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000474a:	02054563          	bltz	a0,80004774 <sys_fstat+0x44>
    8000474e:	fe040593          	addi	a1,s0,-32
    80004752:	4505                	li	a0,1
    80004754:	ffffd097          	auipc	ra,0xffffd
    80004758:	7c2080e7          	jalr	1986(ra) # 80001f16 <argaddr>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000475e:	00054b63          	bltz	a0,80004774 <sys_fstat+0x44>
  return filestat(f, st);
    80004762:	fe043583          	ld	a1,-32(s0)
    80004766:	fe843503          	ld	a0,-24(s0)
    8000476a:	fffff097          	auipc	ra,0xfffff
    8000476e:	32a080e7          	jalr	810(ra) # 80003a94 <filestat>
    80004772:	87aa                	mv	a5,a0
}
    80004774:	853e                	mv	a0,a5
    80004776:	60e2                	ld	ra,24(sp)
    80004778:	6442                	ld	s0,16(sp)
    8000477a:	6105                	addi	sp,sp,32
    8000477c:	8082                	ret

000000008000477e <sys_link>:
{
    8000477e:	7169                	addi	sp,sp,-304
    80004780:	f606                	sd	ra,296(sp)
    80004782:	f222                	sd	s0,288(sp)
    80004784:	ee26                	sd	s1,280(sp)
    80004786:	ea4a                	sd	s2,272(sp)
    80004788:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000478a:	08000613          	li	a2,128
    8000478e:	ed040593          	addi	a1,s0,-304
    80004792:	4501                	li	a0,0
    80004794:	ffffd097          	auipc	ra,0xffffd
    80004798:	7a4080e7          	jalr	1956(ra) # 80001f38 <argstr>
    return -1;
    8000479c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000479e:	10054e63          	bltz	a0,800048ba <sys_link+0x13c>
    800047a2:	08000613          	li	a2,128
    800047a6:	f5040593          	addi	a1,s0,-176
    800047aa:	4505                	li	a0,1
    800047ac:	ffffd097          	auipc	ra,0xffffd
    800047b0:	78c080e7          	jalr	1932(ra) # 80001f38 <argstr>
    return -1;
    800047b4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047b6:	10054263          	bltz	a0,800048ba <sys_link+0x13c>
  begin_op();
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	d46080e7          	jalr	-698(ra) # 80003500 <begin_op>
  if((ip = namei(old)) == 0){
    800047c2:	ed040513          	addi	a0,s0,-304
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	b1e080e7          	jalr	-1250(ra) # 800032e4 <namei>
    800047ce:	84aa                	mv	s1,a0
    800047d0:	c551                	beqz	a0,8000485c <sys_link+0xde>
  ilock(ip);
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	35a080e7          	jalr	858(ra) # 80002b2c <ilock>
  if(ip->type == T_DIR){
    800047da:	04449703          	lh	a4,68(s1)
    800047de:	4785                	li	a5,1
    800047e0:	08f70463          	beq	a4,a5,80004868 <sys_link+0xea>
  ip->nlink++;
    800047e4:	04a4d783          	lhu	a5,74(s1)
    800047e8:	2785                	addiw	a5,a5,1
    800047ea:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047ee:	8526                	mv	a0,s1
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	272080e7          	jalr	626(ra) # 80002a62 <iupdate>
  iunlock(ip);
    800047f8:	8526                	mv	a0,s1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	3f4080e7          	jalr	1012(ra) # 80002bee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004802:	fd040593          	addi	a1,s0,-48
    80004806:	f5040513          	addi	a0,s0,-176
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	af8080e7          	jalr	-1288(ra) # 80003302 <nameiparent>
    80004812:	892a                	mv	s2,a0
    80004814:	c935                	beqz	a0,80004888 <sys_link+0x10a>
  ilock(dp);
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	316080e7          	jalr	790(ra) # 80002b2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000481e:	00092703          	lw	a4,0(s2)
    80004822:	409c                	lw	a5,0(s1)
    80004824:	04f71d63          	bne	a4,a5,8000487e <sys_link+0x100>
    80004828:	40d0                	lw	a2,4(s1)
    8000482a:	fd040593          	addi	a1,s0,-48
    8000482e:	854a                	mv	a0,s2
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	9f2080e7          	jalr	-1550(ra) # 80003222 <dirlink>
    80004838:	04054363          	bltz	a0,8000487e <sys_link+0x100>
  iunlockput(dp);
    8000483c:	854a                	mv	a0,s2
    8000483e:	ffffe097          	auipc	ra,0xffffe
    80004842:	550080e7          	jalr	1360(ra) # 80002d8e <iunlockput>
  iput(ip);
    80004846:	8526                	mv	a0,s1
    80004848:	ffffe097          	auipc	ra,0xffffe
    8000484c:	49e080e7          	jalr	1182(ra) # 80002ce6 <iput>
  end_op();
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	d30080e7          	jalr	-720(ra) # 80003580 <end_op>
  return 0;
    80004858:	4781                	li	a5,0
    8000485a:	a085                	j	800048ba <sys_link+0x13c>
    end_op();
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	d24080e7          	jalr	-732(ra) # 80003580 <end_op>
    return -1;
    80004864:	57fd                	li	a5,-1
    80004866:	a891                	j	800048ba <sys_link+0x13c>
    iunlockput(ip);
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	524080e7          	jalr	1316(ra) # 80002d8e <iunlockput>
    end_op();
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	d0e080e7          	jalr	-754(ra) # 80003580 <end_op>
    return -1;
    8000487a:	57fd                	li	a5,-1
    8000487c:	a83d                	j	800048ba <sys_link+0x13c>
    iunlockput(dp);
    8000487e:	854a                	mv	a0,s2
    80004880:	ffffe097          	auipc	ra,0xffffe
    80004884:	50e080e7          	jalr	1294(ra) # 80002d8e <iunlockput>
  ilock(ip);
    80004888:	8526                	mv	a0,s1
    8000488a:	ffffe097          	auipc	ra,0xffffe
    8000488e:	2a2080e7          	jalr	674(ra) # 80002b2c <ilock>
  ip->nlink--;
    80004892:	04a4d783          	lhu	a5,74(s1)
    80004896:	37fd                	addiw	a5,a5,-1
    80004898:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000489c:	8526                	mv	a0,s1
    8000489e:	ffffe097          	auipc	ra,0xffffe
    800048a2:	1c4080e7          	jalr	452(ra) # 80002a62 <iupdate>
  iunlockput(ip);
    800048a6:	8526                	mv	a0,s1
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	4e6080e7          	jalr	1254(ra) # 80002d8e <iunlockput>
  end_op();
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	cd0080e7          	jalr	-816(ra) # 80003580 <end_op>
  return -1;
    800048b8:	57fd                	li	a5,-1
}
    800048ba:	853e                	mv	a0,a5
    800048bc:	70b2                	ld	ra,296(sp)
    800048be:	7412                	ld	s0,288(sp)
    800048c0:	64f2                	ld	s1,280(sp)
    800048c2:	6952                	ld	s2,272(sp)
    800048c4:	6155                	addi	sp,sp,304
    800048c6:	8082                	ret

00000000800048c8 <sys_unlink>:
{
    800048c8:	7151                	addi	sp,sp,-240
    800048ca:	f586                	sd	ra,232(sp)
    800048cc:	f1a2                	sd	s0,224(sp)
    800048ce:	eda6                	sd	s1,216(sp)
    800048d0:	e9ca                	sd	s2,208(sp)
    800048d2:	e5ce                	sd	s3,200(sp)
    800048d4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048d6:	08000613          	li	a2,128
    800048da:	f3040593          	addi	a1,s0,-208
    800048de:	4501                	li	a0,0
    800048e0:	ffffd097          	auipc	ra,0xffffd
    800048e4:	658080e7          	jalr	1624(ra) # 80001f38 <argstr>
    800048e8:	18054163          	bltz	a0,80004a6a <sys_unlink+0x1a2>
  begin_op();
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	c14080e7          	jalr	-1004(ra) # 80003500 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048f4:	fb040593          	addi	a1,s0,-80
    800048f8:	f3040513          	addi	a0,s0,-208
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	a06080e7          	jalr	-1530(ra) # 80003302 <nameiparent>
    80004904:	84aa                	mv	s1,a0
    80004906:	c979                	beqz	a0,800049dc <sys_unlink+0x114>
  ilock(dp);
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	224080e7          	jalr	548(ra) # 80002b2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004910:	00004597          	auipc	a1,0x4
    80004914:	d7058593          	addi	a1,a1,-656 # 80008680 <syscalls+0x2b8>
    80004918:	fb040513          	addi	a0,s0,-80
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	6dc080e7          	jalr	1756(ra) # 80002ff8 <namecmp>
    80004924:	14050a63          	beqz	a0,80004a78 <sys_unlink+0x1b0>
    80004928:	00004597          	auipc	a1,0x4
    8000492c:	d6058593          	addi	a1,a1,-672 # 80008688 <syscalls+0x2c0>
    80004930:	fb040513          	addi	a0,s0,-80
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	6c4080e7          	jalr	1732(ra) # 80002ff8 <namecmp>
    8000493c:	12050e63          	beqz	a0,80004a78 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004940:	f2c40613          	addi	a2,s0,-212
    80004944:	fb040593          	addi	a1,s0,-80
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	6c8080e7          	jalr	1736(ra) # 80003012 <dirlookup>
    80004952:	892a                	mv	s2,a0
    80004954:	12050263          	beqz	a0,80004a78 <sys_unlink+0x1b0>
  ilock(ip);
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	1d4080e7          	jalr	468(ra) # 80002b2c <ilock>
  if(ip->nlink < 1)
    80004960:	04a91783          	lh	a5,74(s2)
    80004964:	08f05263          	blez	a5,800049e8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004968:	04491703          	lh	a4,68(s2)
    8000496c:	4785                	li	a5,1
    8000496e:	08f70563          	beq	a4,a5,800049f8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004972:	4641                	li	a2,16
    80004974:	4581                	li	a1,0
    80004976:	fc040513          	addi	a0,s0,-64
    8000497a:	ffffb097          	auipc	ra,0xffffb
    8000497e:	7fe080e7          	jalr	2046(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004982:	4741                	li	a4,16
    80004984:	f2c42683          	lw	a3,-212(s0)
    80004988:	fc040613          	addi	a2,s0,-64
    8000498c:	4581                	li	a1,0
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	548080e7          	jalr	1352(ra) # 80002ed8 <writei>
    80004998:	47c1                	li	a5,16
    8000499a:	0af51563          	bne	a0,a5,80004a44 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000499e:	04491703          	lh	a4,68(s2)
    800049a2:	4785                	li	a5,1
    800049a4:	0af70863          	beq	a4,a5,80004a54 <sys_unlink+0x18c>
  iunlockput(dp);
    800049a8:	8526                	mv	a0,s1
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	3e4080e7          	jalr	996(ra) # 80002d8e <iunlockput>
  ip->nlink--;
    800049b2:	04a95783          	lhu	a5,74(s2)
    800049b6:	37fd                	addiw	a5,a5,-1
    800049b8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049bc:	854a                	mv	a0,s2
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	0a4080e7          	jalr	164(ra) # 80002a62 <iupdate>
  iunlockput(ip);
    800049c6:	854a                	mv	a0,s2
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	3c6080e7          	jalr	966(ra) # 80002d8e <iunlockput>
  end_op();
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	bb0080e7          	jalr	-1104(ra) # 80003580 <end_op>
  return 0;
    800049d8:	4501                	li	a0,0
    800049da:	a84d                	j	80004a8c <sys_unlink+0x1c4>
    end_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	ba4080e7          	jalr	-1116(ra) # 80003580 <end_op>
    return -1;
    800049e4:	557d                	li	a0,-1
    800049e6:	a05d                	j	80004a8c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049e8:	00004517          	auipc	a0,0x4
    800049ec:	cc850513          	addi	a0,a0,-824 # 800086b0 <syscalls+0x2e8>
    800049f0:	00001097          	auipc	ra,0x1
    800049f4:	338080e7          	jalr	824(ra) # 80005d28 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049f8:	04c92703          	lw	a4,76(s2)
    800049fc:	02000793          	li	a5,32
    80004a00:	f6e7f9e3          	bgeu	a5,a4,80004972 <sys_unlink+0xaa>
    80004a04:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a08:	4741                	li	a4,16
    80004a0a:	86ce                	mv	a3,s3
    80004a0c:	f1840613          	addi	a2,s0,-232
    80004a10:	4581                	li	a1,0
    80004a12:	854a                	mv	a0,s2
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	3cc080e7          	jalr	972(ra) # 80002de0 <readi>
    80004a1c:	47c1                	li	a5,16
    80004a1e:	00f51b63          	bne	a0,a5,80004a34 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a22:	f1845783          	lhu	a5,-232(s0)
    80004a26:	e7a1                	bnez	a5,80004a6e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a28:	29c1                	addiw	s3,s3,16
    80004a2a:	04c92783          	lw	a5,76(s2)
    80004a2e:	fcf9ede3          	bltu	s3,a5,80004a08 <sys_unlink+0x140>
    80004a32:	b781                	j	80004972 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a34:	00004517          	auipc	a0,0x4
    80004a38:	c9450513          	addi	a0,a0,-876 # 800086c8 <syscalls+0x300>
    80004a3c:	00001097          	auipc	ra,0x1
    80004a40:	2ec080e7          	jalr	748(ra) # 80005d28 <panic>
    panic("unlink: writei");
    80004a44:	00004517          	auipc	a0,0x4
    80004a48:	c9c50513          	addi	a0,a0,-868 # 800086e0 <syscalls+0x318>
    80004a4c:	00001097          	auipc	ra,0x1
    80004a50:	2dc080e7          	jalr	732(ra) # 80005d28 <panic>
    dp->nlink--;
    80004a54:	04a4d783          	lhu	a5,74(s1)
    80004a58:	37fd                	addiw	a5,a5,-1
    80004a5a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	002080e7          	jalr	2(ra) # 80002a62 <iupdate>
    80004a68:	b781                	j	800049a8 <sys_unlink+0xe0>
    return -1;
    80004a6a:	557d                	li	a0,-1
    80004a6c:	a005                	j	80004a8c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a6e:	854a                	mv	a0,s2
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	31e080e7          	jalr	798(ra) # 80002d8e <iunlockput>
  iunlockput(dp);
    80004a78:	8526                	mv	a0,s1
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	314080e7          	jalr	788(ra) # 80002d8e <iunlockput>
  end_op();
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	afe080e7          	jalr	-1282(ra) # 80003580 <end_op>
  return -1;
    80004a8a:	557d                	li	a0,-1
}
    80004a8c:	70ae                	ld	ra,232(sp)
    80004a8e:	740e                	ld	s0,224(sp)
    80004a90:	64ee                	ld	s1,216(sp)
    80004a92:	694e                	ld	s2,208(sp)
    80004a94:	69ae                	ld	s3,200(sp)
    80004a96:	616d                	addi	sp,sp,240
    80004a98:	8082                	ret

0000000080004a9a <sys_open>:

uint64
sys_open(void)
{
    80004a9a:	7129                	addi	sp,sp,-320
    80004a9c:	fe06                	sd	ra,312(sp)
    80004a9e:	fa22                	sd	s0,304(sp)
    80004aa0:	f626                	sd	s1,296(sp)
    80004aa2:	f24a                	sd	s2,288(sp)
    80004aa4:	ee4e                	sd	s3,280(sp)
    80004aa6:	0280                	addi	s0,sp,320
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004aa8:	08000613          	li	a2,128
    80004aac:	f5040593          	addi	a1,s0,-176
    80004ab0:	4501                	li	a0,0
    80004ab2:	ffffd097          	auipc	ra,0xffffd
    80004ab6:	486080e7          	jalr	1158(ra) # 80001f38 <argstr>
    return -1;
    80004aba:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004abc:	0c054163          	bltz	a0,80004b7e <sys_open+0xe4>
    80004ac0:	f4c40593          	addi	a1,s0,-180
    80004ac4:	4505                	li	a0,1
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	42e080e7          	jalr	1070(ra) # 80001ef4 <argint>
    80004ace:	0a054863          	bltz	a0,80004b7e <sys_open+0xe4>

  begin_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	a2e080e7          	jalr	-1490(ra) # 80003500 <begin_op>

  if(omode & O_CREATE){
    80004ada:	f4c42783          	lw	a5,-180(s0)
    80004ade:	2007f793          	andi	a5,a5,512
    80004ae2:	cbdd                	beqz	a5,80004b98 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ae4:	4681                	li	a3,0
    80004ae6:	4601                	li	a2,0
    80004ae8:	4589                	li	a1,2
    80004aea:	f5040513          	addi	a0,s0,-176
    80004aee:	00000097          	auipc	ra,0x0
    80004af2:	972080e7          	jalr	-1678(ra) # 80004460 <create>
    80004af6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004af8:	c959                	beqz	a0,80004b8e <sys_open+0xf4>
	  recursive_depth++;
        }
      }
    }
  }
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004afa:	04449703          	lh	a4,68(s1)
    80004afe:	478d                	li	a5,3
    80004b00:	00f71763          	bne	a4,a5,80004b0e <sys_open+0x74>
    80004b04:	0464d703          	lhu	a4,70(s1)
    80004b08:	47a5                	li	a5,9
    80004b0a:	16e7e263          	bltu	a5,a4,80004c6e <sys_open+0x1d4>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	e02080e7          	jalr	-510(ra) # 80003910 <filealloc>
    80004b16:	89aa                	mv	s3,a0
    80004b18:	18050863          	beqz	a0,80004ca8 <sys_open+0x20e>
    80004b1c:	00000097          	auipc	ra,0x0
    80004b20:	902080e7          	jalr	-1790(ra) # 8000441e <fdalloc>
    80004b24:	892a                	mv	s2,a0
    80004b26:	16054c63          	bltz	a0,80004c9e <sys_open+0x204>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b2a:	04449703          	lh	a4,68(s1)
    80004b2e:	478d                	li	a5,3
    80004b30:	14f70a63          	beq	a4,a5,80004c84 <sys_open+0x1ea>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b34:	4789                	li	a5,2
    80004b36:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b3a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b3e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b42:	f4c42783          	lw	a5,-180(s0)
    80004b46:	0017c713          	xori	a4,a5,1
    80004b4a:	8b05                	andi	a4,a4,1
    80004b4c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b50:	0037f713          	andi	a4,a5,3
    80004b54:	00e03733          	snez	a4,a4
    80004b58:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b5c:	4007f793          	andi	a5,a5,1024
    80004b60:	c791                	beqz	a5,80004b6c <sys_open+0xd2>
    80004b62:	04449703          	lh	a4,68(s1)
    80004b66:	4789                	li	a5,2
    80004b68:	12f70563          	beq	a4,a5,80004c92 <sys_open+0x1f8>
    itrunc(ip);
  }

  iunlock(ip);
    80004b6c:	8526                	mv	a0,s1
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	080080e7          	jalr	128(ra) # 80002bee <iunlock>
  end_op();
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	a0a080e7          	jalr	-1526(ra) # 80003580 <end_op>

  return fd;
}
    80004b7e:	854a                	mv	a0,s2
    80004b80:	70f2                	ld	ra,312(sp)
    80004b82:	7452                	ld	s0,304(sp)
    80004b84:	74b2                	ld	s1,296(sp)
    80004b86:	7912                	ld	s2,288(sp)
    80004b88:	69f2                	ld	s3,280(sp)
    80004b8a:	6131                	addi	sp,sp,320
    80004b8c:	8082                	ret
      end_op();
    80004b8e:	fffff097          	auipc	ra,0xfffff
    80004b92:	9f2080e7          	jalr	-1550(ra) # 80003580 <end_op>
      return -1;
    80004b96:	b7e5                	j	80004b7e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b98:	f5040513          	addi	a0,s0,-176
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	748080e7          	jalr	1864(ra) # 800032e4 <namei>
    80004ba4:	84aa                	mv	s1,a0
    80004ba6:	c951                	beqz	a0,80004c3a <sys_open+0x1a0>
    ilock(ip);
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	f84080e7          	jalr	-124(ra) # 80002b2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bb0:	04449783          	lh	a5,68(s1)
    80004bb4:	0007869b          	sext.w	a3,a5
    80004bb8:	4705                	li	a4,1
    80004bba:	08e68663          	beq	a3,a4,80004c46 <sys_open+0x1ac>
    if(ip->type == T_SYMLINK) {
    80004bbe:	2781                	sext.w	a5,a5
    80004bc0:	4711                	li	a4,4
    80004bc2:	f2e79ce3          	bne	a5,a4,80004afa <sys_open+0x60>
      if((omode & O_NOFOLLOW) == 0){
    80004bc6:	f4c42783          	lw	a5,-180(s0)
    80004bca:	8bc1                	andi	a5,a5,16
    80004bcc:	f3a9                	bnez	a5,80004b0e <sys_open+0x74>
    80004bce:	4929                	li	s2,10
	  if(ip->type != T_SYMLINK){
    80004bd0:	4991                	li	s3,4
          if(readi(ip, 0, (uint64)target, ip->size-MAXPATH, MAXPATH) != MAXPATH){
    80004bd2:	44f4                	lw	a3,76(s1)
    80004bd4:	08000713          	li	a4,128
    80004bd8:	f806869b          	addiw	a3,a3,-128
    80004bdc:	ec840613          	addi	a2,s0,-312
    80004be0:	4581                	li	a1,0
    80004be2:	8526                	mv	a0,s1
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	1fc080e7          	jalr	508(ra) # 80002de0 <readi>
    80004bec:	08000793          	li	a5,128
    80004bf0:	04f51363          	bne	a0,a5,80004c36 <sys_open+0x19c>
          iunlockput(ip);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	198080e7          	jalr	408(ra) # 80002d8e <iunlockput>
	  if((ip = namei(target)) == 0){
    80004bfe:	ec840513          	addi	a0,s0,-312
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	6e2080e7          	jalr	1762(ra) # 800032e4 <namei>
    80004c0a:	84aa                	mv	s1,a0
    80004c0c:	cd21                	beqz	a0,80004c64 <sys_open+0x1ca>
	  ilock(ip);
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	f1e080e7          	jalr	-226(ra) # 80002b2c <ilock>
	  if(ip->type != T_SYMLINK){
    80004c16:	04449783          	lh	a5,68(s1)
    80004c1a:	ef3790e3          	bne	a5,s3,80004afa <sys_open+0x60>
          if(recursive_depth >= 10){
    80004c1e:	397d                	addiw	s2,s2,-1
    80004c20:	fa0919e3          	bnez	s2,80004bd2 <sys_open+0x138>
	    iunlockput(ip);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	168080e7          	jalr	360(ra) # 80002d8e <iunlockput>
	    end_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	952080e7          	jalr	-1710(ra) # 80003580 <end_op>
	    return -1;
    80004c36:	597d                	li	s2,-1
    80004c38:	b799                	j	80004b7e <sys_open+0xe4>
      end_op();
    80004c3a:	fffff097          	auipc	ra,0xfffff
    80004c3e:	946080e7          	jalr	-1722(ra) # 80003580 <end_op>
      return -1;
    80004c42:	597d                	li	s2,-1
    80004c44:	bf2d                	j	80004b7e <sys_open+0xe4>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c46:	f4c42783          	lw	a5,-180(s0)
    80004c4a:	ec0782e3          	beqz	a5,80004b0e <sys_open+0x74>
      iunlockput(ip);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	13e080e7          	jalr	318(ra) # 80002d8e <iunlockput>
      end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	928080e7          	jalr	-1752(ra) # 80003580 <end_op>
      return -1;
    80004c60:	597d                	li	s2,-1
    80004c62:	bf31                	j	80004b7e <sys_open+0xe4>
	    end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	91c080e7          	jalr	-1764(ra) # 80003580 <end_op>
	    return -1;
    80004c6c:	b7e9                	j	80004c36 <sys_open+0x19c>
    iunlockput(ip);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	11e080e7          	jalr	286(ra) # 80002d8e <iunlockput>
    end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	908080e7          	jalr	-1784(ra) # 80003580 <end_op>
    return -1;
    80004c80:	597d                	li	s2,-1
    80004c82:	bdf5                	j	80004b7e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c84:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c88:	04649783          	lh	a5,70(s1)
    80004c8c:	02f99223          	sh	a5,36(s3)
    80004c90:	b57d                	j	80004b3e <sys_open+0xa4>
    itrunc(ip);
    80004c92:	8526                	mv	a0,s1
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	fa6080e7          	jalr	-90(ra) # 80002c3a <itrunc>
    80004c9c:	bdc1                	j	80004b6c <sys_open+0xd2>
      fileclose(f);
    80004c9e:	854e                	mv	a0,s3
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	d2c080e7          	jalr	-724(ra) # 800039cc <fileclose>
    iunlockput(ip);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	0e4080e7          	jalr	228(ra) # 80002d8e <iunlockput>
    end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	8ce080e7          	jalr	-1842(ra) # 80003580 <end_op>
    return -1;
    80004cba:	597d                	li	s2,-1
    80004cbc:	b5c9                	j	80004b7e <sys_open+0xe4>

0000000080004cbe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cbe:	7175                	addi	sp,sp,-144
    80004cc0:	e506                	sd	ra,136(sp)
    80004cc2:	e122                	sd	s0,128(sp)
    80004cc4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	83a080e7          	jalr	-1990(ra) # 80003500 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cce:	08000613          	li	a2,128
    80004cd2:	f7040593          	addi	a1,s0,-144
    80004cd6:	4501                	li	a0,0
    80004cd8:	ffffd097          	auipc	ra,0xffffd
    80004cdc:	260080e7          	jalr	608(ra) # 80001f38 <argstr>
    80004ce0:	02054963          	bltz	a0,80004d12 <sys_mkdir+0x54>
    80004ce4:	4681                	li	a3,0
    80004ce6:	4601                	li	a2,0
    80004ce8:	4585                	li	a1,1
    80004cea:	f7040513          	addi	a0,s0,-144
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	772080e7          	jalr	1906(ra) # 80004460 <create>
    80004cf6:	cd11                	beqz	a0,80004d12 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	096080e7          	jalr	150(ra) # 80002d8e <iunlockput>
  end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	880080e7          	jalr	-1920(ra) # 80003580 <end_op>
  return 0;
    80004d08:	4501                	li	a0,0
}
    80004d0a:	60aa                	ld	ra,136(sp)
    80004d0c:	640a                	ld	s0,128(sp)
    80004d0e:	6149                	addi	sp,sp,144
    80004d10:	8082                	ret
    end_op();
    80004d12:	fffff097          	auipc	ra,0xfffff
    80004d16:	86e080e7          	jalr	-1938(ra) # 80003580 <end_op>
    return -1;
    80004d1a:	557d                	li	a0,-1
    80004d1c:	b7fd                	j	80004d0a <sys_mkdir+0x4c>

0000000080004d1e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d1e:	7135                	addi	sp,sp,-160
    80004d20:	ed06                	sd	ra,152(sp)
    80004d22:	e922                	sd	s0,144(sp)
    80004d24:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	7da080e7          	jalr	2010(ra) # 80003500 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d2e:	08000613          	li	a2,128
    80004d32:	f7040593          	addi	a1,s0,-144
    80004d36:	4501                	li	a0,0
    80004d38:	ffffd097          	auipc	ra,0xffffd
    80004d3c:	200080e7          	jalr	512(ra) # 80001f38 <argstr>
    80004d40:	04054a63          	bltz	a0,80004d94 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d44:	f6c40593          	addi	a1,s0,-148
    80004d48:	4505                	li	a0,1
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	1aa080e7          	jalr	426(ra) # 80001ef4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d52:	04054163          	bltz	a0,80004d94 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d56:	f6840593          	addi	a1,s0,-152
    80004d5a:	4509                	li	a0,2
    80004d5c:	ffffd097          	auipc	ra,0xffffd
    80004d60:	198080e7          	jalr	408(ra) # 80001ef4 <argint>
     argint(1, &major) < 0 ||
    80004d64:	02054863          	bltz	a0,80004d94 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d68:	f6841683          	lh	a3,-152(s0)
    80004d6c:	f6c41603          	lh	a2,-148(s0)
    80004d70:	458d                	li	a1,3
    80004d72:	f7040513          	addi	a0,s0,-144
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	6ea080e7          	jalr	1770(ra) # 80004460 <create>
     argint(2, &minor) < 0 ||
    80004d7e:	c919                	beqz	a0,80004d94 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	00e080e7          	jalr	14(ra) # 80002d8e <iunlockput>
  end_op();
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	7f8080e7          	jalr	2040(ra) # 80003580 <end_op>
  return 0;
    80004d90:	4501                	li	a0,0
    80004d92:	a031                	j	80004d9e <sys_mknod+0x80>
    end_op();
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	7ec080e7          	jalr	2028(ra) # 80003580 <end_op>
    return -1;
    80004d9c:	557d                	li	a0,-1
}
    80004d9e:	60ea                	ld	ra,152(sp)
    80004da0:	644a                	ld	s0,144(sp)
    80004da2:	610d                	addi	sp,sp,160
    80004da4:	8082                	ret

0000000080004da6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004da6:	7135                	addi	sp,sp,-160
    80004da8:	ed06                	sd	ra,152(sp)
    80004daa:	e922                	sd	s0,144(sp)
    80004dac:	e526                	sd	s1,136(sp)
    80004dae:	e14a                	sd	s2,128(sp)
    80004db0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004db2:	ffffc097          	auipc	ra,0xffffc
    80004db6:	096080e7          	jalr	150(ra) # 80000e48 <myproc>
    80004dba:	892a                	mv	s2,a0
  
  begin_op();
    80004dbc:	ffffe097          	auipc	ra,0xffffe
    80004dc0:	744080e7          	jalr	1860(ra) # 80003500 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dc4:	08000613          	li	a2,128
    80004dc8:	f6040593          	addi	a1,s0,-160
    80004dcc:	4501                	li	a0,0
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	16a080e7          	jalr	362(ra) # 80001f38 <argstr>
    80004dd6:	04054b63          	bltz	a0,80004e2c <sys_chdir+0x86>
    80004dda:	f6040513          	addi	a0,s0,-160
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	506080e7          	jalr	1286(ra) # 800032e4 <namei>
    80004de6:	84aa                	mv	s1,a0
    80004de8:	c131                	beqz	a0,80004e2c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	d42080e7          	jalr	-702(ra) # 80002b2c <ilock>
  if(ip->type != T_DIR){
    80004df2:	04449703          	lh	a4,68(s1)
    80004df6:	4785                	li	a5,1
    80004df8:	04f71063          	bne	a4,a5,80004e38 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	df0080e7          	jalr	-528(ra) # 80002bee <iunlock>
  iput(p->cwd);
    80004e06:	15093503          	ld	a0,336(s2)
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	edc080e7          	jalr	-292(ra) # 80002ce6 <iput>
  end_op();
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	76e080e7          	jalr	1902(ra) # 80003580 <end_op>
  p->cwd = ip;
    80004e1a:	14993823          	sd	s1,336(s2)
  return 0;
    80004e1e:	4501                	li	a0,0
}
    80004e20:	60ea                	ld	ra,152(sp)
    80004e22:	644a                	ld	s0,144(sp)
    80004e24:	64aa                	ld	s1,136(sp)
    80004e26:	690a                	ld	s2,128(sp)
    80004e28:	610d                	addi	sp,sp,160
    80004e2a:	8082                	ret
    end_op();
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	754080e7          	jalr	1876(ra) # 80003580 <end_op>
    return -1;
    80004e34:	557d                	li	a0,-1
    80004e36:	b7ed                	j	80004e20 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e38:	8526                	mv	a0,s1
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	f54080e7          	jalr	-172(ra) # 80002d8e <iunlockput>
    end_op();
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	73e080e7          	jalr	1854(ra) # 80003580 <end_op>
    return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	bfd1                	j	80004e20 <sys_chdir+0x7a>

0000000080004e4e <sys_exec>:

uint64
sys_exec(void)
{
    80004e4e:	7145                	addi	sp,sp,-464
    80004e50:	e786                	sd	ra,456(sp)
    80004e52:	e3a2                	sd	s0,448(sp)
    80004e54:	ff26                	sd	s1,440(sp)
    80004e56:	fb4a                	sd	s2,432(sp)
    80004e58:	f74e                	sd	s3,424(sp)
    80004e5a:	f352                	sd	s4,416(sp)
    80004e5c:	ef56                	sd	s5,408(sp)
    80004e5e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e60:	08000613          	li	a2,128
    80004e64:	f4040593          	addi	a1,s0,-192
    80004e68:	4501                	li	a0,0
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	0ce080e7          	jalr	206(ra) # 80001f38 <argstr>
    return -1;
    80004e72:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e74:	0c054a63          	bltz	a0,80004f48 <sys_exec+0xfa>
    80004e78:	e3840593          	addi	a1,s0,-456
    80004e7c:	4505                	li	a0,1
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	098080e7          	jalr	152(ra) # 80001f16 <argaddr>
    80004e86:	0c054163          	bltz	a0,80004f48 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e8a:	10000613          	li	a2,256
    80004e8e:	4581                	li	a1,0
    80004e90:	e4040513          	addi	a0,s0,-448
    80004e94:	ffffb097          	auipc	ra,0xffffb
    80004e98:	2e4080e7          	jalr	740(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e9c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ea0:	89a6                	mv	s3,s1
    80004ea2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ea4:	02000a13          	li	s4,32
    80004ea8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eac:	00391513          	slli	a0,s2,0x3
    80004eb0:	e3040593          	addi	a1,s0,-464
    80004eb4:	e3843783          	ld	a5,-456(s0)
    80004eb8:	953e                	add	a0,a0,a5
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	fa0080e7          	jalr	-96(ra) # 80001e5a <fetchaddr>
    80004ec2:	02054a63          	bltz	a0,80004ef6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ec6:	e3043783          	ld	a5,-464(s0)
    80004eca:	c3b9                	beqz	a5,80004f10 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ecc:	ffffb097          	auipc	ra,0xffffb
    80004ed0:	24c080e7          	jalr	588(ra) # 80000118 <kalloc>
    80004ed4:	85aa                	mv	a1,a0
    80004ed6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eda:	cd11                	beqz	a0,80004ef6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004edc:	6605                	lui	a2,0x1
    80004ede:	e3043503          	ld	a0,-464(s0)
    80004ee2:	ffffd097          	auipc	ra,0xffffd
    80004ee6:	fca080e7          	jalr	-54(ra) # 80001eac <fetchstr>
    80004eea:	00054663          	bltz	a0,80004ef6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004eee:	0905                	addi	s2,s2,1
    80004ef0:	09a1                	addi	s3,s3,8
    80004ef2:	fb491be3          	bne	s2,s4,80004ea8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef6:	10048913          	addi	s2,s1,256
    80004efa:	6088                	ld	a0,0(s1)
    80004efc:	c529                	beqz	a0,80004f46 <sys_exec+0xf8>
    kfree(argv[i]);
    80004efe:	ffffb097          	auipc	ra,0xffffb
    80004f02:	11e080e7          	jalr	286(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f06:	04a1                	addi	s1,s1,8
    80004f08:	ff2499e3          	bne	s1,s2,80004efa <sys_exec+0xac>
  return -1;
    80004f0c:	597d                	li	s2,-1
    80004f0e:	a82d                	j	80004f48 <sys_exec+0xfa>
      argv[i] = 0;
    80004f10:	0a8e                	slli	s5,s5,0x3
    80004f12:	fc040793          	addi	a5,s0,-64
    80004f16:	9abe                	add	s5,s5,a5
    80004f18:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f1c:	e4040593          	addi	a1,s0,-448
    80004f20:	f4040513          	addi	a0,s0,-192
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	108080e7          	jalr	264(ra) # 8000402c <exec>
    80004f2c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f2e:	10048993          	addi	s3,s1,256
    80004f32:	6088                	ld	a0,0(s1)
    80004f34:	c911                	beqz	a0,80004f48 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f36:	ffffb097          	auipc	ra,0xffffb
    80004f3a:	0e6080e7          	jalr	230(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3e:	04a1                	addi	s1,s1,8
    80004f40:	ff3499e3          	bne	s1,s3,80004f32 <sys_exec+0xe4>
    80004f44:	a011                	j	80004f48 <sys_exec+0xfa>
  return -1;
    80004f46:	597d                	li	s2,-1
}
    80004f48:	854a                	mv	a0,s2
    80004f4a:	60be                	ld	ra,456(sp)
    80004f4c:	641e                	ld	s0,448(sp)
    80004f4e:	74fa                	ld	s1,440(sp)
    80004f50:	795a                	ld	s2,432(sp)
    80004f52:	79ba                	ld	s3,424(sp)
    80004f54:	7a1a                	ld	s4,416(sp)
    80004f56:	6afa                	ld	s5,408(sp)
    80004f58:	6179                	addi	sp,sp,464
    80004f5a:	8082                	ret

0000000080004f5c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f5c:	7139                	addi	sp,sp,-64
    80004f5e:	fc06                	sd	ra,56(sp)
    80004f60:	f822                	sd	s0,48(sp)
    80004f62:	f426                	sd	s1,40(sp)
    80004f64:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f66:	ffffc097          	auipc	ra,0xffffc
    80004f6a:	ee2080e7          	jalr	-286(ra) # 80000e48 <myproc>
    80004f6e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f70:	fd840593          	addi	a1,s0,-40
    80004f74:	4501                	li	a0,0
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	fa0080e7          	jalr	-96(ra) # 80001f16 <argaddr>
    return -1;
    80004f7e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f80:	0e054063          	bltz	a0,80005060 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f84:	fc840593          	addi	a1,s0,-56
    80004f88:	fd040513          	addi	a0,s0,-48
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	d70080e7          	jalr	-656(ra) # 80003cfc <pipealloc>
    return -1;
    80004f94:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f96:	0c054563          	bltz	a0,80005060 <sys_pipe+0x104>
  fd0 = -1;
    80004f9a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f9e:	fd043503          	ld	a0,-48(s0)
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	47c080e7          	jalr	1148(ra) # 8000441e <fdalloc>
    80004faa:	fca42223          	sw	a0,-60(s0)
    80004fae:	08054c63          	bltz	a0,80005046 <sys_pipe+0xea>
    80004fb2:	fc843503          	ld	a0,-56(s0)
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	468080e7          	jalr	1128(ra) # 8000441e <fdalloc>
    80004fbe:	fca42023          	sw	a0,-64(s0)
    80004fc2:	06054863          	bltz	a0,80005032 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fc6:	4691                	li	a3,4
    80004fc8:	fc440613          	addi	a2,s0,-60
    80004fcc:	fd843583          	ld	a1,-40(s0)
    80004fd0:	68a8                	ld	a0,80(s1)
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	b38080e7          	jalr	-1224(ra) # 80000b0a <copyout>
    80004fda:	02054063          	bltz	a0,80004ffa <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fde:	4691                	li	a3,4
    80004fe0:	fc040613          	addi	a2,s0,-64
    80004fe4:	fd843583          	ld	a1,-40(s0)
    80004fe8:	0591                	addi	a1,a1,4
    80004fea:	68a8                	ld	a0,80(s1)
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	b1e080e7          	jalr	-1250(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ff4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff6:	06055563          	bgez	a0,80005060 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004ffa:	fc442783          	lw	a5,-60(s0)
    80004ffe:	07e9                	addi	a5,a5,26
    80005000:	078e                	slli	a5,a5,0x3
    80005002:	97a6                	add	a5,a5,s1
    80005004:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005008:	fc042503          	lw	a0,-64(s0)
    8000500c:	0569                	addi	a0,a0,26
    8000500e:	050e                	slli	a0,a0,0x3
    80005010:	9526                	add	a0,a0,s1
    80005012:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005016:	fd043503          	ld	a0,-48(s0)
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	9b2080e7          	jalr	-1614(ra) # 800039cc <fileclose>
    fileclose(wf);
    80005022:	fc843503          	ld	a0,-56(s0)
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	9a6080e7          	jalr	-1626(ra) # 800039cc <fileclose>
    return -1;
    8000502e:	57fd                	li	a5,-1
    80005030:	a805                	j	80005060 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005032:	fc442783          	lw	a5,-60(s0)
    80005036:	0007c863          	bltz	a5,80005046 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000503a:	01a78513          	addi	a0,a5,26
    8000503e:	050e                	slli	a0,a0,0x3
    80005040:	9526                	add	a0,a0,s1
    80005042:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005046:	fd043503          	ld	a0,-48(s0)
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	982080e7          	jalr	-1662(ra) # 800039cc <fileclose>
    fileclose(wf);
    80005052:	fc843503          	ld	a0,-56(s0)
    80005056:	fffff097          	auipc	ra,0xfffff
    8000505a:	976080e7          	jalr	-1674(ra) # 800039cc <fileclose>
    return -1;
    8000505e:	57fd                	li	a5,-1
}
    80005060:	853e                	mv	a0,a5
    80005062:	70e2                	ld	ra,56(sp)
    80005064:	7442                	ld	s0,48(sp)
    80005066:	74a2                	ld	s1,40(sp)
    80005068:	6121                	addi	sp,sp,64
    8000506a:	8082                	ret

000000008000506c <sys_symlink>:

uint64
sys_symlink(void){
    8000506c:	712d                	addi	sp,sp,-288
    8000506e:	ee06                	sd	ra,280(sp)
    80005070:	ea22                	sd	s0,272(sp)
    80005072:	e626                	sd	s1,264(sp)
    80005074:	1200                	addi	s0,sp,288
  char target[MAXPATH], path[MAXPATH];
  struct inode *ip;

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80005076:	08000613          	li	a2,128
    8000507a:	f6040593          	addi	a1,s0,-160
    8000507e:	4501                	li	a0,0
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	eb8080e7          	jalr	-328(ra) # 80001f38 <argstr>
    return -1;
    80005088:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    8000508a:	04054f63          	bltz	a0,800050e8 <sys_symlink+0x7c>
    8000508e:	08000613          	li	a2,128
    80005092:	ee040593          	addi	a1,s0,-288
    80005096:	4505                	li	a0,1
    80005098:	ffffd097          	auipc	ra,0xffffd
    8000509c:	ea0080e7          	jalr	-352(ra) # 80001f38 <argstr>
    return -1;
    800050a0:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    800050a2:	04054363          	bltz	a0,800050e8 <sys_symlink+0x7c>
  }

  begin_op();
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	45a080e7          	jalr	1114(ra) # 80003500 <begin_op>
  if((ip = namei(path)) == 0){
    800050ae:	ee040513          	addi	a0,s0,-288
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	232080e7          	jalr	562(ra) # 800032e4 <namei>
    800050ba:	84aa                	mv	s1,a0
    800050bc:	cd05                	beqz	a0,800050f4 <sys_symlink+0x88>
    ip = create(path, T_SYMLINK, 0, 0);
    iunlock(ip);
  }

  ilock(ip);
    800050be:	8526                	mv	a0,s1
    800050c0:	ffffe097          	auipc	ra,0xffffe
    800050c4:	a6c080e7          	jalr	-1428(ra) # 80002b2c <ilock>
  if(writei(ip, 0, (uint64)target, ip->size, MAXPATH) != MAXPATH){
    800050c8:	08000713          	li	a4,128
    800050cc:	44f4                	lw	a3,76(s1)
    800050ce:	f6040613          	addi	a2,s0,-160
    800050d2:	4581                	li	a1,0
    800050d4:	8526                	mv	a0,s1
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	e02080e7          	jalr	-510(ra) # 80002ed8 <writei>
    800050de:	08000713          	li	a4,128
    return -1;
    800050e2:	57fd                	li	a5,-1
  if(writei(ip, 0, (uint64)target, ip->size, MAXPATH) != MAXPATH){
    800050e4:	02e50763          	beq	a0,a4,80005112 <sys_symlink+0xa6>
  }
  iunlockput(ip);
  end_op();
  return 0;
}
    800050e8:	853e                	mv	a0,a5
    800050ea:	60f2                	ld	ra,280(sp)
    800050ec:	6452                	ld	s0,272(sp)
    800050ee:	64b2                	ld	s1,264(sp)
    800050f0:	6115                	addi	sp,sp,288
    800050f2:	8082                	ret
    ip = create(path, T_SYMLINK, 0, 0);
    800050f4:	4681                	li	a3,0
    800050f6:	4601                	li	a2,0
    800050f8:	4591                	li	a1,4
    800050fa:	ee040513          	addi	a0,s0,-288
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	362080e7          	jalr	866(ra) # 80004460 <create>
    80005106:	84aa                	mv	s1,a0
    iunlock(ip);
    80005108:	ffffe097          	auipc	ra,0xffffe
    8000510c:	ae6080e7          	jalr	-1306(ra) # 80002bee <iunlock>
    80005110:	b77d                	j	800050be <sys_symlink+0x52>
  iunlockput(ip);
    80005112:	8526                	mv	a0,s1
    80005114:	ffffe097          	auipc	ra,0xffffe
    80005118:	c7a080e7          	jalr	-902(ra) # 80002d8e <iunlockput>
  end_op();
    8000511c:	ffffe097          	auipc	ra,0xffffe
    80005120:	464080e7          	jalr	1124(ra) # 80003580 <end_op>
  return 0;
    80005124:	4781                	li	a5,0
    80005126:	b7c9                	j	800050e8 <sys_symlink+0x7c>
	...

0000000080005130 <kernelvec>:
    80005130:	7111                	addi	sp,sp,-256
    80005132:	e006                	sd	ra,0(sp)
    80005134:	e40a                	sd	sp,8(sp)
    80005136:	e80e                	sd	gp,16(sp)
    80005138:	ec12                	sd	tp,24(sp)
    8000513a:	f016                	sd	t0,32(sp)
    8000513c:	f41a                	sd	t1,40(sp)
    8000513e:	f81e                	sd	t2,48(sp)
    80005140:	fc22                	sd	s0,56(sp)
    80005142:	e0a6                	sd	s1,64(sp)
    80005144:	e4aa                	sd	a0,72(sp)
    80005146:	e8ae                	sd	a1,80(sp)
    80005148:	ecb2                	sd	a2,88(sp)
    8000514a:	f0b6                	sd	a3,96(sp)
    8000514c:	f4ba                	sd	a4,104(sp)
    8000514e:	f8be                	sd	a5,112(sp)
    80005150:	fcc2                	sd	a6,120(sp)
    80005152:	e146                	sd	a7,128(sp)
    80005154:	e54a                	sd	s2,136(sp)
    80005156:	e94e                	sd	s3,144(sp)
    80005158:	ed52                	sd	s4,152(sp)
    8000515a:	f156                	sd	s5,160(sp)
    8000515c:	f55a                	sd	s6,168(sp)
    8000515e:	f95e                	sd	s7,176(sp)
    80005160:	fd62                	sd	s8,184(sp)
    80005162:	e1e6                	sd	s9,192(sp)
    80005164:	e5ea                	sd	s10,200(sp)
    80005166:	e9ee                	sd	s11,208(sp)
    80005168:	edf2                	sd	t3,216(sp)
    8000516a:	f1f6                	sd	t4,224(sp)
    8000516c:	f5fa                	sd	t5,232(sp)
    8000516e:	f9fe                	sd	t6,240(sp)
    80005170:	bb7fc0ef          	jal	ra,80001d26 <kerneltrap>
    80005174:	6082                	ld	ra,0(sp)
    80005176:	6122                	ld	sp,8(sp)
    80005178:	61c2                	ld	gp,16(sp)
    8000517a:	7282                	ld	t0,32(sp)
    8000517c:	7322                	ld	t1,40(sp)
    8000517e:	73c2                	ld	t2,48(sp)
    80005180:	7462                	ld	s0,56(sp)
    80005182:	6486                	ld	s1,64(sp)
    80005184:	6526                	ld	a0,72(sp)
    80005186:	65c6                	ld	a1,80(sp)
    80005188:	6666                	ld	a2,88(sp)
    8000518a:	7686                	ld	a3,96(sp)
    8000518c:	7726                	ld	a4,104(sp)
    8000518e:	77c6                	ld	a5,112(sp)
    80005190:	7866                	ld	a6,120(sp)
    80005192:	688a                	ld	a7,128(sp)
    80005194:	692a                	ld	s2,136(sp)
    80005196:	69ca                	ld	s3,144(sp)
    80005198:	6a6a                	ld	s4,152(sp)
    8000519a:	7a8a                	ld	s5,160(sp)
    8000519c:	7b2a                	ld	s6,168(sp)
    8000519e:	7bca                	ld	s7,176(sp)
    800051a0:	7c6a                	ld	s8,184(sp)
    800051a2:	6c8e                	ld	s9,192(sp)
    800051a4:	6d2e                	ld	s10,200(sp)
    800051a6:	6dce                	ld	s11,208(sp)
    800051a8:	6e6e                	ld	t3,216(sp)
    800051aa:	7e8e                	ld	t4,224(sp)
    800051ac:	7f2e                	ld	t5,232(sp)
    800051ae:	7fce                	ld	t6,240(sp)
    800051b0:	6111                	addi	sp,sp,256
    800051b2:	10200073          	sret
    800051b6:	00000013          	nop
    800051ba:	00000013          	nop
    800051be:	0001                	nop

00000000800051c0 <timervec>:
    800051c0:	34051573          	csrrw	a0,mscratch,a0
    800051c4:	e10c                	sd	a1,0(a0)
    800051c6:	e510                	sd	a2,8(a0)
    800051c8:	e914                	sd	a3,16(a0)
    800051ca:	6d0c                	ld	a1,24(a0)
    800051cc:	7110                	ld	a2,32(a0)
    800051ce:	6194                	ld	a3,0(a1)
    800051d0:	96b2                	add	a3,a3,a2
    800051d2:	e194                	sd	a3,0(a1)
    800051d4:	4589                	li	a1,2
    800051d6:	14459073          	csrw	sip,a1
    800051da:	6914                	ld	a3,16(a0)
    800051dc:	6510                	ld	a2,8(a0)
    800051de:	610c                	ld	a1,0(a0)
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	30200073          	mret
	...

00000000800051ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ea:	1141                	addi	sp,sp,-16
    800051ec:	e422                	sd	s0,8(sp)
    800051ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051f0:	0c0007b7          	lui	a5,0xc000
    800051f4:	4705                	li	a4,1
    800051f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051f8:	c3d8                	sw	a4,4(a5)
}
    800051fa:	6422                	ld	s0,8(sp)
    800051fc:	0141                	addi	sp,sp,16
    800051fe:	8082                	ret

0000000080005200 <plicinithart>:

void
plicinithart(void)
{
    80005200:	1141                	addi	sp,sp,-16
    80005202:	e406                	sd	ra,8(sp)
    80005204:	e022                	sd	s0,0(sp)
    80005206:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	c14080e7          	jalr	-1004(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005210:	0085171b          	slliw	a4,a0,0x8
    80005214:	0c0027b7          	lui	a5,0xc002
    80005218:	97ba                	add	a5,a5,a4
    8000521a:	40200713          	li	a4,1026
    8000521e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005222:	00d5151b          	slliw	a0,a0,0xd
    80005226:	0c2017b7          	lui	a5,0xc201
    8000522a:	953e                	add	a0,a0,a5
    8000522c:	00052023          	sw	zero,0(a0)
}
    80005230:	60a2                	ld	ra,8(sp)
    80005232:	6402                	ld	s0,0(sp)
    80005234:	0141                	addi	sp,sp,16
    80005236:	8082                	ret

0000000080005238 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005238:	1141                	addi	sp,sp,-16
    8000523a:	e406                	sd	ra,8(sp)
    8000523c:	e022                	sd	s0,0(sp)
    8000523e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	bdc080e7          	jalr	-1060(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005248:	00d5179b          	slliw	a5,a0,0xd
    8000524c:	0c201537          	lui	a0,0xc201
    80005250:	953e                	add	a0,a0,a5
  return irq;
}
    80005252:	4148                	lw	a0,4(a0)
    80005254:	60a2                	ld	ra,8(sp)
    80005256:	6402                	ld	s0,0(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret

000000008000525c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000525c:	1101                	addi	sp,sp,-32
    8000525e:	ec06                	sd	ra,24(sp)
    80005260:	e822                	sd	s0,16(sp)
    80005262:	e426                	sd	s1,8(sp)
    80005264:	1000                	addi	s0,sp,32
    80005266:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	bb4080e7          	jalr	-1100(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005270:	00d5151b          	slliw	a0,a0,0xd
    80005274:	0c2017b7          	lui	a5,0xc201
    80005278:	97aa                	add	a5,a5,a0
    8000527a:	c3c4                	sw	s1,4(a5)
}
    8000527c:	60e2                	ld	ra,24(sp)
    8000527e:	6442                	ld	s0,16(sp)
    80005280:	64a2                	ld	s1,8(sp)
    80005282:	6105                	addi	sp,sp,32
    80005284:	8082                	ret

0000000080005286 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005286:	1141                	addi	sp,sp,-16
    80005288:	e406                	sd	ra,8(sp)
    8000528a:	e022                	sd	s0,0(sp)
    8000528c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000528e:	479d                	li	a5,7
    80005290:	06a7c963          	blt	a5,a0,80005302 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005294:	00011797          	auipc	a5,0x11
    80005298:	d6c78793          	addi	a5,a5,-660 # 80016000 <disk>
    8000529c:	00a78733          	add	a4,a5,a0
    800052a0:	6789                	lui	a5,0x2
    800052a2:	97ba                	add	a5,a5,a4
    800052a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052a8:	e7ad                	bnez	a5,80005312 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052aa:	00451793          	slli	a5,a0,0x4
    800052ae:	00013717          	auipc	a4,0x13
    800052b2:	d5270713          	addi	a4,a4,-686 # 80018000 <disk+0x2000>
    800052b6:	6314                	ld	a3,0(a4)
    800052b8:	96be                	add	a3,a3,a5
    800052ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052be:	6314                	ld	a3,0(a4)
    800052c0:	96be                	add	a3,a3,a5
    800052c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052c6:	6314                	ld	a3,0(a4)
    800052c8:	96be                	add	a3,a3,a5
    800052ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052ce:	6318                	ld	a4,0(a4)
    800052d0:	97ba                	add	a5,a5,a4
    800052d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052d6:	00011797          	auipc	a5,0x11
    800052da:	d2a78793          	addi	a5,a5,-726 # 80016000 <disk>
    800052de:	97aa                	add	a5,a5,a0
    800052e0:	6509                	lui	a0,0x2
    800052e2:	953e                	add	a0,a0,a5
    800052e4:	4785                	li	a5,1
    800052e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800052ea:	00013517          	auipc	a0,0x13
    800052ee:	d2e50513          	addi	a0,a0,-722 # 80018018 <disk+0x2018>
    800052f2:	ffffc097          	auipc	ra,0xffffc
    800052f6:	39e080e7          	jalr	926(ra) # 80001690 <wakeup>
}
    800052fa:	60a2                	ld	ra,8(sp)
    800052fc:	6402                	ld	s0,0(sp)
    800052fe:	0141                	addi	sp,sp,16
    80005300:	8082                	ret
    panic("free_desc 1");
    80005302:	00003517          	auipc	a0,0x3
    80005306:	3ee50513          	addi	a0,a0,1006 # 800086f0 <syscalls+0x328>
    8000530a:	00001097          	auipc	ra,0x1
    8000530e:	a1e080e7          	jalr	-1506(ra) # 80005d28 <panic>
    panic("free_desc 2");
    80005312:	00003517          	auipc	a0,0x3
    80005316:	3ee50513          	addi	a0,a0,1006 # 80008700 <syscalls+0x338>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	a0e080e7          	jalr	-1522(ra) # 80005d28 <panic>

0000000080005322 <virtio_disk_init>:
{
    80005322:	1101                	addi	sp,sp,-32
    80005324:	ec06                	sd	ra,24(sp)
    80005326:	e822                	sd	s0,16(sp)
    80005328:	e426                	sd	s1,8(sp)
    8000532a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000532c:	00003597          	auipc	a1,0x3
    80005330:	3e458593          	addi	a1,a1,996 # 80008710 <syscalls+0x348>
    80005334:	00013517          	auipc	a0,0x13
    80005338:	df450513          	addi	a0,a0,-524 # 80018128 <disk+0x2128>
    8000533c:	00001097          	auipc	ra,0x1
    80005340:	ea6080e7          	jalr	-346(ra) # 800061e2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005344:	100017b7          	lui	a5,0x10001
    80005348:	4398                	lw	a4,0(a5)
    8000534a:	2701                	sext.w	a4,a4
    8000534c:	747277b7          	lui	a5,0x74727
    80005350:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005354:	0ef71163          	bne	a4,a5,80005436 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005358:	100017b7          	lui	a5,0x10001
    8000535c:	43dc                	lw	a5,4(a5)
    8000535e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005360:	4705                	li	a4,1
    80005362:	0ce79a63          	bne	a5,a4,80005436 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005366:	100017b7          	lui	a5,0x10001
    8000536a:	479c                	lw	a5,8(a5)
    8000536c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000536e:	4709                	li	a4,2
    80005370:	0ce79363          	bne	a5,a4,80005436 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	47d8                	lw	a4,12(a5)
    8000537a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000537c:	554d47b7          	lui	a5,0x554d4
    80005380:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005384:	0af71963          	bne	a4,a5,80005436 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005388:	100017b7          	lui	a5,0x10001
    8000538c:	4705                	li	a4,1
    8000538e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005390:	470d                	li	a4,3
    80005392:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005394:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005396:	c7ffe737          	lui	a4,0xc7ffe
    8000539a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd51f>
    8000539e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053a0:	2701                	sext.w	a4,a4
    800053a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a4:	472d                	li	a4,11
    800053a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a8:	473d                	li	a4,15
    800053aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053ac:	6705                	lui	a4,0x1
    800053ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053b4:	5bdc                	lw	a5,52(a5)
    800053b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053b8:	c7d9                	beqz	a5,80005446 <virtio_disk_init+0x124>
  if(max < NUM)
    800053ba:	471d                	li	a4,7
    800053bc:	08f77d63          	bgeu	a4,a5,80005456 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053c0:	100014b7          	lui	s1,0x10001
    800053c4:	47a1                	li	a5,8
    800053c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053c8:	6609                	lui	a2,0x2
    800053ca:	4581                	li	a1,0
    800053cc:	00011517          	auipc	a0,0x11
    800053d0:	c3450513          	addi	a0,a0,-972 # 80016000 <disk>
    800053d4:	ffffb097          	auipc	ra,0xffffb
    800053d8:	da4080e7          	jalr	-604(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053dc:	00011717          	auipc	a4,0x11
    800053e0:	c2470713          	addi	a4,a4,-988 # 80016000 <disk>
    800053e4:	00c75793          	srli	a5,a4,0xc
    800053e8:	2781                	sext.w	a5,a5
    800053ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800053ec:	00013797          	auipc	a5,0x13
    800053f0:	c1478793          	addi	a5,a5,-1004 # 80018000 <disk+0x2000>
    800053f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800053f6:	00011717          	auipc	a4,0x11
    800053fa:	c8a70713          	addi	a4,a4,-886 # 80016080 <disk+0x80>
    800053fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005400:	00012717          	auipc	a4,0x12
    80005404:	c0070713          	addi	a4,a4,-1024 # 80017000 <disk+0x1000>
    80005408:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000540a:	4705                	li	a4,1
    8000540c:	00e78c23          	sb	a4,24(a5)
    80005410:	00e78ca3          	sb	a4,25(a5)
    80005414:	00e78d23          	sb	a4,26(a5)
    80005418:	00e78da3          	sb	a4,27(a5)
    8000541c:	00e78e23          	sb	a4,28(a5)
    80005420:	00e78ea3          	sb	a4,29(a5)
    80005424:	00e78f23          	sb	a4,30(a5)
    80005428:	00e78fa3          	sb	a4,31(a5)
}
    8000542c:	60e2                	ld	ra,24(sp)
    8000542e:	6442                	ld	s0,16(sp)
    80005430:	64a2                	ld	s1,8(sp)
    80005432:	6105                	addi	sp,sp,32
    80005434:	8082                	ret
    panic("could not find virtio disk");
    80005436:	00003517          	auipc	a0,0x3
    8000543a:	2ea50513          	addi	a0,a0,746 # 80008720 <syscalls+0x358>
    8000543e:	00001097          	auipc	ra,0x1
    80005442:	8ea080e7          	jalr	-1814(ra) # 80005d28 <panic>
    panic("virtio disk has no queue 0");
    80005446:	00003517          	auipc	a0,0x3
    8000544a:	2fa50513          	addi	a0,a0,762 # 80008740 <syscalls+0x378>
    8000544e:	00001097          	auipc	ra,0x1
    80005452:	8da080e7          	jalr	-1830(ra) # 80005d28 <panic>
    panic("virtio disk max queue too short");
    80005456:	00003517          	auipc	a0,0x3
    8000545a:	30a50513          	addi	a0,a0,778 # 80008760 <syscalls+0x398>
    8000545e:	00001097          	auipc	ra,0x1
    80005462:	8ca080e7          	jalr	-1846(ra) # 80005d28 <panic>

0000000080005466 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005466:	7159                	addi	sp,sp,-112
    80005468:	f486                	sd	ra,104(sp)
    8000546a:	f0a2                	sd	s0,96(sp)
    8000546c:	eca6                	sd	s1,88(sp)
    8000546e:	e8ca                	sd	s2,80(sp)
    80005470:	e4ce                	sd	s3,72(sp)
    80005472:	e0d2                	sd	s4,64(sp)
    80005474:	fc56                	sd	s5,56(sp)
    80005476:	f85a                	sd	s6,48(sp)
    80005478:	f45e                	sd	s7,40(sp)
    8000547a:	f062                	sd	s8,32(sp)
    8000547c:	ec66                	sd	s9,24(sp)
    8000547e:	e86a                	sd	s10,16(sp)
    80005480:	1880                	addi	s0,sp,112
    80005482:	892a                	mv	s2,a0
    80005484:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005486:	00c52c83          	lw	s9,12(a0)
    8000548a:	001c9c9b          	slliw	s9,s9,0x1
    8000548e:	1c82                	slli	s9,s9,0x20
    80005490:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005494:	00013517          	auipc	a0,0x13
    80005498:	c9450513          	addi	a0,a0,-876 # 80018128 <disk+0x2128>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	dd6080e7          	jalr	-554(ra) # 80006272 <acquire>
  for(int i = 0; i < 3; i++){
    800054a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054a6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054a8:	00011b97          	auipc	s7,0x11
    800054ac:	b58b8b93          	addi	s7,s7,-1192 # 80016000 <disk>
    800054b0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054b4:	8a4e                	mv	s4,s3
    800054b6:	a051                	j	8000553a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054b8:	00fb86b3          	add	a3,s7,a5
    800054bc:	96da                	add	a3,a3,s6
    800054be:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054c2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054c4:	0207c563          	bltz	a5,800054ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054c8:	2485                	addiw	s1,s1,1
    800054ca:	0711                	addi	a4,a4,4
    800054cc:	25548063          	beq	s1,s5,8000570c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800054d0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054d2:	00013697          	auipc	a3,0x13
    800054d6:	b4668693          	addi	a3,a3,-1210 # 80018018 <disk+0x2018>
    800054da:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054dc:	0006c583          	lbu	a1,0(a3)
    800054e0:	fde1                	bnez	a1,800054b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800054e2:	2785                	addiw	a5,a5,1
    800054e4:	0685                	addi	a3,a3,1
    800054e6:	ff879be3          	bne	a5,s8,800054dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800054ea:	57fd                	li	a5,-1
    800054ec:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054ee:	02905a63          	blez	s1,80005522 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054f2:	f9042503          	lw	a0,-112(s0)
    800054f6:	00000097          	auipc	ra,0x0
    800054fa:	d90080e7          	jalr	-624(ra) # 80005286 <free_desc>
      for(int j = 0; j < i; j++)
    800054fe:	4785                	li	a5,1
    80005500:	0297d163          	bge	a5,s1,80005522 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005504:	f9442503          	lw	a0,-108(s0)
    80005508:	00000097          	auipc	ra,0x0
    8000550c:	d7e080e7          	jalr	-642(ra) # 80005286 <free_desc>
      for(int j = 0; j < i; j++)
    80005510:	4789                	li	a5,2
    80005512:	0097d863          	bge	a5,s1,80005522 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005516:	f9842503          	lw	a0,-104(s0)
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	d6c080e7          	jalr	-660(ra) # 80005286 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005522:	00013597          	auipc	a1,0x13
    80005526:	c0658593          	addi	a1,a1,-1018 # 80018128 <disk+0x2128>
    8000552a:	00013517          	auipc	a0,0x13
    8000552e:	aee50513          	addi	a0,a0,-1298 # 80018018 <disk+0x2018>
    80005532:	ffffc097          	auipc	ra,0xffffc
    80005536:	fd2080e7          	jalr	-46(ra) # 80001504 <sleep>
  for(int i = 0; i < 3; i++){
    8000553a:	f9040713          	addi	a4,s0,-112
    8000553e:	84ce                	mv	s1,s3
    80005540:	bf41                	j	800054d0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005542:	20058713          	addi	a4,a1,512
    80005546:	00471693          	slli	a3,a4,0x4
    8000554a:	00011717          	auipc	a4,0x11
    8000554e:	ab670713          	addi	a4,a4,-1354 # 80016000 <disk>
    80005552:	9736                	add	a4,a4,a3
    80005554:	4685                	li	a3,1
    80005556:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000555a:	20058713          	addi	a4,a1,512
    8000555e:	00471693          	slli	a3,a4,0x4
    80005562:	00011717          	auipc	a4,0x11
    80005566:	a9e70713          	addi	a4,a4,-1378 # 80016000 <disk>
    8000556a:	9736                	add	a4,a4,a3
    8000556c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005570:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005574:	7679                	lui	a2,0xffffe
    80005576:	963e                	add	a2,a2,a5
    80005578:	00013697          	auipc	a3,0x13
    8000557c:	a8868693          	addi	a3,a3,-1400 # 80018000 <disk+0x2000>
    80005580:	6298                	ld	a4,0(a3)
    80005582:	9732                	add	a4,a4,a2
    80005584:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005586:	6298                	ld	a4,0(a3)
    80005588:	9732                	add	a4,a4,a2
    8000558a:	4541                	li	a0,16
    8000558c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000558e:	6298                	ld	a4,0(a3)
    80005590:	9732                	add	a4,a4,a2
    80005592:	4505                	li	a0,1
    80005594:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005598:	f9442703          	lw	a4,-108(s0)
    8000559c:	6288                	ld	a0,0(a3)
    8000559e:	962a                	add	a2,a2,a0
    800055a0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdcdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055a4:	0712                	slli	a4,a4,0x4
    800055a6:	6290                	ld	a2,0(a3)
    800055a8:	963a                	add	a2,a2,a4
    800055aa:	05890513          	addi	a0,s2,88
    800055ae:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055b0:	6294                	ld	a3,0(a3)
    800055b2:	96ba                	add	a3,a3,a4
    800055b4:	40000613          	li	a2,1024
    800055b8:	c690                	sw	a2,8(a3)
  if(write)
    800055ba:	140d0063          	beqz	s10,800056fa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055be:	00013697          	auipc	a3,0x13
    800055c2:	a426b683          	ld	a3,-1470(a3) # 80018000 <disk+0x2000>
    800055c6:	96ba                	add	a3,a3,a4
    800055c8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055cc:	00011817          	auipc	a6,0x11
    800055d0:	a3480813          	addi	a6,a6,-1484 # 80016000 <disk>
    800055d4:	00013517          	auipc	a0,0x13
    800055d8:	a2c50513          	addi	a0,a0,-1492 # 80018000 <disk+0x2000>
    800055dc:	6114                	ld	a3,0(a0)
    800055de:	96ba                	add	a3,a3,a4
    800055e0:	00c6d603          	lhu	a2,12(a3)
    800055e4:	00166613          	ori	a2,a2,1
    800055e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055ec:	f9842683          	lw	a3,-104(s0)
    800055f0:	6110                	ld	a2,0(a0)
    800055f2:	9732                	add	a4,a4,a2
    800055f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055f8:	20058613          	addi	a2,a1,512
    800055fc:	0612                	slli	a2,a2,0x4
    800055fe:	9642                	add	a2,a2,a6
    80005600:	577d                	li	a4,-1
    80005602:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005606:	00469713          	slli	a4,a3,0x4
    8000560a:	6114                	ld	a3,0(a0)
    8000560c:	96ba                	add	a3,a3,a4
    8000560e:	03078793          	addi	a5,a5,48
    80005612:	97c2                	add	a5,a5,a6
    80005614:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005616:	611c                	ld	a5,0(a0)
    80005618:	97ba                	add	a5,a5,a4
    8000561a:	4685                	li	a3,1
    8000561c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000561e:	611c                	ld	a5,0(a0)
    80005620:	97ba                	add	a5,a5,a4
    80005622:	4809                	li	a6,2
    80005624:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005628:	611c                	ld	a5,0(a0)
    8000562a:	973e                	add	a4,a4,a5
    8000562c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005630:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005634:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005638:	6518                	ld	a4,8(a0)
    8000563a:	00275783          	lhu	a5,2(a4)
    8000563e:	8b9d                	andi	a5,a5,7
    80005640:	0786                	slli	a5,a5,0x1
    80005642:	97ba                	add	a5,a5,a4
    80005644:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005648:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000564c:	6518                	ld	a4,8(a0)
    8000564e:	00275783          	lhu	a5,2(a4)
    80005652:	2785                	addiw	a5,a5,1
    80005654:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005658:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000565c:	100017b7          	lui	a5,0x10001
    80005660:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005664:	00492703          	lw	a4,4(s2)
    80005668:	4785                	li	a5,1
    8000566a:	02f71163          	bne	a4,a5,8000568c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000566e:	00013997          	auipc	s3,0x13
    80005672:	aba98993          	addi	s3,s3,-1350 # 80018128 <disk+0x2128>
  while(b->disk == 1) {
    80005676:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005678:	85ce                	mv	a1,s3
    8000567a:	854a                	mv	a0,s2
    8000567c:	ffffc097          	auipc	ra,0xffffc
    80005680:	e88080e7          	jalr	-376(ra) # 80001504 <sleep>
  while(b->disk == 1) {
    80005684:	00492783          	lw	a5,4(s2)
    80005688:	fe9788e3          	beq	a5,s1,80005678 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000568c:	f9042903          	lw	s2,-112(s0)
    80005690:	20090793          	addi	a5,s2,512
    80005694:	00479713          	slli	a4,a5,0x4
    80005698:	00011797          	auipc	a5,0x11
    8000569c:	96878793          	addi	a5,a5,-1688 # 80016000 <disk>
    800056a0:	97ba                	add	a5,a5,a4
    800056a2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056a6:	00013997          	auipc	s3,0x13
    800056aa:	95a98993          	addi	s3,s3,-1702 # 80018000 <disk+0x2000>
    800056ae:	00491713          	slli	a4,s2,0x4
    800056b2:	0009b783          	ld	a5,0(s3)
    800056b6:	97ba                	add	a5,a5,a4
    800056b8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056bc:	854a                	mv	a0,s2
    800056be:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056c2:	00000097          	auipc	ra,0x0
    800056c6:	bc4080e7          	jalr	-1084(ra) # 80005286 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ca:	8885                	andi	s1,s1,1
    800056cc:	f0ed                	bnez	s1,800056ae <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056ce:	00013517          	auipc	a0,0x13
    800056d2:	a5a50513          	addi	a0,a0,-1446 # 80018128 <disk+0x2128>
    800056d6:	00001097          	auipc	ra,0x1
    800056da:	c50080e7          	jalr	-944(ra) # 80006326 <release>
}
    800056de:	70a6                	ld	ra,104(sp)
    800056e0:	7406                	ld	s0,96(sp)
    800056e2:	64e6                	ld	s1,88(sp)
    800056e4:	6946                	ld	s2,80(sp)
    800056e6:	69a6                	ld	s3,72(sp)
    800056e8:	6a06                	ld	s4,64(sp)
    800056ea:	7ae2                	ld	s5,56(sp)
    800056ec:	7b42                	ld	s6,48(sp)
    800056ee:	7ba2                	ld	s7,40(sp)
    800056f0:	7c02                	ld	s8,32(sp)
    800056f2:	6ce2                	ld	s9,24(sp)
    800056f4:	6d42                	ld	s10,16(sp)
    800056f6:	6165                	addi	sp,sp,112
    800056f8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056fa:	00013697          	auipc	a3,0x13
    800056fe:	9066b683          	ld	a3,-1786(a3) # 80018000 <disk+0x2000>
    80005702:	96ba                	add	a3,a3,a4
    80005704:	4609                	li	a2,2
    80005706:	00c69623          	sh	a2,12(a3)
    8000570a:	b5c9                	j	800055cc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000570c:	f9042583          	lw	a1,-112(s0)
    80005710:	20058793          	addi	a5,a1,512
    80005714:	0792                	slli	a5,a5,0x4
    80005716:	00011517          	auipc	a0,0x11
    8000571a:	99250513          	addi	a0,a0,-1646 # 800160a8 <disk+0xa8>
    8000571e:	953e                	add	a0,a0,a5
  if(write)
    80005720:	e20d11e3          	bnez	s10,80005542 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005724:	20058713          	addi	a4,a1,512
    80005728:	00471693          	slli	a3,a4,0x4
    8000572c:	00011717          	auipc	a4,0x11
    80005730:	8d470713          	addi	a4,a4,-1836 # 80016000 <disk>
    80005734:	9736                	add	a4,a4,a3
    80005736:	0a072423          	sw	zero,168(a4)
    8000573a:	b505                	j	8000555a <virtio_disk_rw+0xf4>

000000008000573c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000573c:	1101                	addi	sp,sp,-32
    8000573e:	ec06                	sd	ra,24(sp)
    80005740:	e822                	sd	s0,16(sp)
    80005742:	e426                	sd	s1,8(sp)
    80005744:	e04a                	sd	s2,0(sp)
    80005746:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005748:	00013517          	auipc	a0,0x13
    8000574c:	9e050513          	addi	a0,a0,-1568 # 80018128 <disk+0x2128>
    80005750:	00001097          	auipc	ra,0x1
    80005754:	b22080e7          	jalr	-1246(ra) # 80006272 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005758:	10001737          	lui	a4,0x10001
    8000575c:	533c                	lw	a5,96(a4)
    8000575e:	8b8d                	andi	a5,a5,3
    80005760:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005762:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005766:	00013797          	auipc	a5,0x13
    8000576a:	89a78793          	addi	a5,a5,-1894 # 80018000 <disk+0x2000>
    8000576e:	6b94                	ld	a3,16(a5)
    80005770:	0207d703          	lhu	a4,32(a5)
    80005774:	0026d783          	lhu	a5,2(a3)
    80005778:	06f70163          	beq	a4,a5,800057da <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000577c:	00011917          	auipc	s2,0x11
    80005780:	88490913          	addi	s2,s2,-1916 # 80016000 <disk>
    80005784:	00013497          	auipc	s1,0x13
    80005788:	87c48493          	addi	s1,s1,-1924 # 80018000 <disk+0x2000>
    __sync_synchronize();
    8000578c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005790:	6898                	ld	a4,16(s1)
    80005792:	0204d783          	lhu	a5,32(s1)
    80005796:	8b9d                	andi	a5,a5,7
    80005798:	078e                	slli	a5,a5,0x3
    8000579a:	97ba                	add	a5,a5,a4
    8000579c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000579e:	20078713          	addi	a4,a5,512
    800057a2:	0712                	slli	a4,a4,0x4
    800057a4:	974a                	add	a4,a4,s2
    800057a6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057aa:	e731                	bnez	a4,800057f6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057ac:	20078793          	addi	a5,a5,512
    800057b0:	0792                	slli	a5,a5,0x4
    800057b2:	97ca                	add	a5,a5,s2
    800057b4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057b6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ba:	ffffc097          	auipc	ra,0xffffc
    800057be:	ed6080e7          	jalr	-298(ra) # 80001690 <wakeup>

    disk.used_idx += 1;
    800057c2:	0204d783          	lhu	a5,32(s1)
    800057c6:	2785                	addiw	a5,a5,1
    800057c8:	17c2                	slli	a5,a5,0x30
    800057ca:	93c1                	srli	a5,a5,0x30
    800057cc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057d0:	6898                	ld	a4,16(s1)
    800057d2:	00275703          	lhu	a4,2(a4)
    800057d6:	faf71be3          	bne	a4,a5,8000578c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800057da:	00013517          	auipc	a0,0x13
    800057de:	94e50513          	addi	a0,a0,-1714 # 80018128 <disk+0x2128>
    800057e2:	00001097          	auipc	ra,0x1
    800057e6:	b44080e7          	jalr	-1212(ra) # 80006326 <release>
}
    800057ea:	60e2                	ld	ra,24(sp)
    800057ec:	6442                	ld	s0,16(sp)
    800057ee:	64a2                	ld	s1,8(sp)
    800057f0:	6902                	ld	s2,0(sp)
    800057f2:	6105                	addi	sp,sp,32
    800057f4:	8082                	ret
      panic("virtio_disk_intr status");
    800057f6:	00003517          	auipc	a0,0x3
    800057fa:	f8a50513          	addi	a0,a0,-118 # 80008780 <syscalls+0x3b8>
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	52a080e7          	jalr	1322(ra) # 80005d28 <panic>

0000000080005806 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005806:	1141                	addi	sp,sp,-16
    80005808:	e422                	sd	s0,8(sp)
    8000580a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000580c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005810:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005814:	0037979b          	slliw	a5,a5,0x3
    80005818:	02004737          	lui	a4,0x2004
    8000581c:	97ba                	add	a5,a5,a4
    8000581e:	0200c737          	lui	a4,0x200c
    80005822:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005826:	000f4637          	lui	a2,0xf4
    8000582a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000582e:	95b2                	add	a1,a1,a2
    80005830:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005832:	00269713          	slli	a4,a3,0x2
    80005836:	9736                	add	a4,a4,a3
    80005838:	00371693          	slli	a3,a4,0x3
    8000583c:	00013717          	auipc	a4,0x13
    80005840:	7c470713          	addi	a4,a4,1988 # 80019000 <timer_scratch>
    80005844:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005846:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005848:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000584a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000584e:	00000797          	auipc	a5,0x0
    80005852:	97278793          	addi	a5,a5,-1678 # 800051c0 <timervec>
    80005856:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000585a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000585e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005862:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005866:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000586a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000586e:	30479073          	csrw	mie,a5
}
    80005872:	6422                	ld	s0,8(sp)
    80005874:	0141                	addi	sp,sp,16
    80005876:	8082                	ret

0000000080005878 <start>:
{
    80005878:	1141                	addi	sp,sp,-16
    8000587a:	e406                	sd	ra,8(sp)
    8000587c:	e022                	sd	s0,0(sp)
    8000587e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005880:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005884:	7779                	lui	a4,0xffffe
    80005886:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd5bf>
    8000588a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000588c:	6705                	lui	a4,0x1
    8000588e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005892:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005894:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005898:	ffffb797          	auipc	a5,0xffffb
    8000589c:	a8e78793          	addi	a5,a5,-1394 # 80000326 <main>
    800058a0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058a4:	4781                	li	a5,0
    800058a6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058aa:	67c1                	lui	a5,0x10
    800058ac:	17fd                	addi	a5,a5,-1
    800058ae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058b2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058b6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ba:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058be:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058c2:	57fd                	li	a5,-1
    800058c4:	83a9                	srli	a5,a5,0xa
    800058c6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058ca:	47bd                	li	a5,15
    800058cc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058d0:	00000097          	auipc	ra,0x0
    800058d4:	f36080e7          	jalr	-202(ra) # 80005806 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058dc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058de:	823e                	mv	tp,a5
  asm volatile("mret");
    800058e0:	30200073          	mret
}
    800058e4:	60a2                	ld	ra,8(sp)
    800058e6:	6402                	ld	s0,0(sp)
    800058e8:	0141                	addi	sp,sp,16
    800058ea:	8082                	ret

00000000800058ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058ec:	715d                	addi	sp,sp,-80
    800058ee:	e486                	sd	ra,72(sp)
    800058f0:	e0a2                	sd	s0,64(sp)
    800058f2:	fc26                	sd	s1,56(sp)
    800058f4:	f84a                	sd	s2,48(sp)
    800058f6:	f44e                	sd	s3,40(sp)
    800058f8:	f052                	sd	s4,32(sp)
    800058fa:	ec56                	sd	s5,24(sp)
    800058fc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058fe:	04c05663          	blez	a2,8000594a <consolewrite+0x5e>
    80005902:	8a2a                	mv	s4,a0
    80005904:	84ae                	mv	s1,a1
    80005906:	89b2                	mv	s3,a2
    80005908:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000590a:	5afd                	li	s5,-1
    8000590c:	4685                	li	a3,1
    8000590e:	8626                	mv	a2,s1
    80005910:	85d2                	mv	a1,s4
    80005912:	fbf40513          	addi	a0,s0,-65
    80005916:	ffffc097          	auipc	ra,0xffffc
    8000591a:	fe8080e7          	jalr	-24(ra) # 800018fe <either_copyin>
    8000591e:	01550c63          	beq	a0,s5,80005936 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005922:	fbf44503          	lbu	a0,-65(s0)
    80005926:	00000097          	auipc	ra,0x0
    8000592a:	78e080e7          	jalr	1934(ra) # 800060b4 <uartputc>
  for(i = 0; i < n; i++){
    8000592e:	2905                	addiw	s2,s2,1
    80005930:	0485                	addi	s1,s1,1
    80005932:	fd299de3          	bne	s3,s2,8000590c <consolewrite+0x20>
  }

  return i;
}
    80005936:	854a                	mv	a0,s2
    80005938:	60a6                	ld	ra,72(sp)
    8000593a:	6406                	ld	s0,64(sp)
    8000593c:	74e2                	ld	s1,56(sp)
    8000593e:	7942                	ld	s2,48(sp)
    80005940:	79a2                	ld	s3,40(sp)
    80005942:	7a02                	ld	s4,32(sp)
    80005944:	6ae2                	ld	s5,24(sp)
    80005946:	6161                	addi	sp,sp,80
    80005948:	8082                	ret
  for(i = 0; i < n; i++){
    8000594a:	4901                	li	s2,0
    8000594c:	b7ed                	j	80005936 <consolewrite+0x4a>

000000008000594e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000594e:	7119                	addi	sp,sp,-128
    80005950:	fc86                	sd	ra,120(sp)
    80005952:	f8a2                	sd	s0,112(sp)
    80005954:	f4a6                	sd	s1,104(sp)
    80005956:	f0ca                	sd	s2,96(sp)
    80005958:	ecce                	sd	s3,88(sp)
    8000595a:	e8d2                	sd	s4,80(sp)
    8000595c:	e4d6                	sd	s5,72(sp)
    8000595e:	e0da                	sd	s6,64(sp)
    80005960:	fc5e                	sd	s7,56(sp)
    80005962:	f862                	sd	s8,48(sp)
    80005964:	f466                	sd	s9,40(sp)
    80005966:	f06a                	sd	s10,32(sp)
    80005968:	ec6e                	sd	s11,24(sp)
    8000596a:	0100                	addi	s0,sp,128
    8000596c:	8b2a                	mv	s6,a0
    8000596e:	8aae                	mv	s5,a1
    80005970:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005972:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005976:	0001b517          	auipc	a0,0x1b
    8000597a:	7ca50513          	addi	a0,a0,1994 # 80021140 <cons>
    8000597e:	00001097          	auipc	ra,0x1
    80005982:	8f4080e7          	jalr	-1804(ra) # 80006272 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005986:	0001b497          	auipc	s1,0x1b
    8000598a:	7ba48493          	addi	s1,s1,1978 # 80021140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000598e:	89a6                	mv	s3,s1
    80005990:	0001c917          	auipc	s2,0x1c
    80005994:	84890913          	addi	s2,s2,-1976 # 800211d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005998:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000599a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000599c:	4da9                	li	s11,10
  while(n > 0){
    8000599e:	07405863          	blez	s4,80005a0e <consoleread+0xc0>
    while(cons.r == cons.w){
    800059a2:	0984a783          	lw	a5,152(s1)
    800059a6:	09c4a703          	lw	a4,156(s1)
    800059aa:	02f71463          	bne	a4,a5,800059d2 <consoleread+0x84>
      if(myproc()->killed){
    800059ae:	ffffb097          	auipc	ra,0xffffb
    800059b2:	49a080e7          	jalr	1178(ra) # 80000e48 <myproc>
    800059b6:	551c                	lw	a5,40(a0)
    800059b8:	e7b5                	bnez	a5,80005a24 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059ba:	85ce                	mv	a1,s3
    800059bc:	854a                	mv	a0,s2
    800059be:	ffffc097          	auipc	ra,0xffffc
    800059c2:	b46080e7          	jalr	-1210(ra) # 80001504 <sleep>
    while(cons.r == cons.w){
    800059c6:	0984a783          	lw	a5,152(s1)
    800059ca:	09c4a703          	lw	a4,156(s1)
    800059ce:	fef700e3          	beq	a4,a5,800059ae <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800059d2:	0017871b          	addiw	a4,a5,1
    800059d6:	08e4ac23          	sw	a4,152(s1)
    800059da:	07f7f713          	andi	a4,a5,127
    800059de:	9726                	add	a4,a4,s1
    800059e0:	01874703          	lbu	a4,24(a4)
    800059e4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059e8:	079c0663          	beq	s8,s9,80005a54 <consoleread+0x106>
    cbuf = c;
    800059ec:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059f0:	4685                	li	a3,1
    800059f2:	f8f40613          	addi	a2,s0,-113
    800059f6:	85d6                	mv	a1,s5
    800059f8:	855a                	mv	a0,s6
    800059fa:	ffffc097          	auipc	ra,0xffffc
    800059fe:	eae080e7          	jalr	-338(ra) # 800018a8 <either_copyout>
    80005a02:	01a50663          	beq	a0,s10,80005a0e <consoleread+0xc0>
    dst++;
    80005a06:	0a85                	addi	s5,s5,1
    --n;
    80005a08:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a0a:	f9bc1ae3          	bne	s8,s11,8000599e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a0e:	0001b517          	auipc	a0,0x1b
    80005a12:	73250513          	addi	a0,a0,1842 # 80021140 <cons>
    80005a16:	00001097          	auipc	ra,0x1
    80005a1a:	910080e7          	jalr	-1776(ra) # 80006326 <release>

  return target - n;
    80005a1e:	414b853b          	subw	a0,s7,s4
    80005a22:	a811                	j	80005a36 <consoleread+0xe8>
        release(&cons.lock);
    80005a24:	0001b517          	auipc	a0,0x1b
    80005a28:	71c50513          	addi	a0,a0,1820 # 80021140 <cons>
    80005a2c:	00001097          	auipc	ra,0x1
    80005a30:	8fa080e7          	jalr	-1798(ra) # 80006326 <release>
        return -1;
    80005a34:	557d                	li	a0,-1
}
    80005a36:	70e6                	ld	ra,120(sp)
    80005a38:	7446                	ld	s0,112(sp)
    80005a3a:	74a6                	ld	s1,104(sp)
    80005a3c:	7906                	ld	s2,96(sp)
    80005a3e:	69e6                	ld	s3,88(sp)
    80005a40:	6a46                	ld	s4,80(sp)
    80005a42:	6aa6                	ld	s5,72(sp)
    80005a44:	6b06                	ld	s6,64(sp)
    80005a46:	7be2                	ld	s7,56(sp)
    80005a48:	7c42                	ld	s8,48(sp)
    80005a4a:	7ca2                	ld	s9,40(sp)
    80005a4c:	7d02                	ld	s10,32(sp)
    80005a4e:	6de2                	ld	s11,24(sp)
    80005a50:	6109                	addi	sp,sp,128
    80005a52:	8082                	ret
      if(n < target){
    80005a54:	000a071b          	sext.w	a4,s4
    80005a58:	fb777be3          	bgeu	a4,s7,80005a0e <consoleread+0xc0>
        cons.r--;
    80005a5c:	0001b717          	auipc	a4,0x1b
    80005a60:	76f72e23          	sw	a5,1916(a4) # 800211d8 <cons+0x98>
    80005a64:	b76d                	j	80005a0e <consoleread+0xc0>

0000000080005a66 <consputc>:
{
    80005a66:	1141                	addi	sp,sp,-16
    80005a68:	e406                	sd	ra,8(sp)
    80005a6a:	e022                	sd	s0,0(sp)
    80005a6c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a6e:	10000793          	li	a5,256
    80005a72:	00f50a63          	beq	a0,a5,80005a86 <consputc+0x20>
    uartputc_sync(c);
    80005a76:	00000097          	auipc	ra,0x0
    80005a7a:	564080e7          	jalr	1380(ra) # 80005fda <uartputc_sync>
}
    80005a7e:	60a2                	ld	ra,8(sp)
    80005a80:	6402                	ld	s0,0(sp)
    80005a82:	0141                	addi	sp,sp,16
    80005a84:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a86:	4521                	li	a0,8
    80005a88:	00000097          	auipc	ra,0x0
    80005a8c:	552080e7          	jalr	1362(ra) # 80005fda <uartputc_sync>
    80005a90:	02000513          	li	a0,32
    80005a94:	00000097          	auipc	ra,0x0
    80005a98:	546080e7          	jalr	1350(ra) # 80005fda <uartputc_sync>
    80005a9c:	4521                	li	a0,8
    80005a9e:	00000097          	auipc	ra,0x0
    80005aa2:	53c080e7          	jalr	1340(ra) # 80005fda <uartputc_sync>
    80005aa6:	bfe1                	j	80005a7e <consputc+0x18>

0000000080005aa8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005aa8:	1101                	addi	sp,sp,-32
    80005aaa:	ec06                	sd	ra,24(sp)
    80005aac:	e822                	sd	s0,16(sp)
    80005aae:	e426                	sd	s1,8(sp)
    80005ab0:	e04a                	sd	s2,0(sp)
    80005ab2:	1000                	addi	s0,sp,32
    80005ab4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ab6:	0001b517          	auipc	a0,0x1b
    80005aba:	68a50513          	addi	a0,a0,1674 # 80021140 <cons>
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	7b4080e7          	jalr	1972(ra) # 80006272 <acquire>

  switch(c){
    80005ac6:	47d5                	li	a5,21
    80005ac8:	0af48663          	beq	s1,a5,80005b74 <consoleintr+0xcc>
    80005acc:	0297ca63          	blt	a5,s1,80005b00 <consoleintr+0x58>
    80005ad0:	47a1                	li	a5,8
    80005ad2:	0ef48763          	beq	s1,a5,80005bc0 <consoleintr+0x118>
    80005ad6:	47c1                	li	a5,16
    80005ad8:	10f49a63          	bne	s1,a5,80005bec <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005adc:	ffffc097          	auipc	ra,0xffffc
    80005ae0:	e78080e7          	jalr	-392(ra) # 80001954 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ae4:	0001b517          	auipc	a0,0x1b
    80005ae8:	65c50513          	addi	a0,a0,1628 # 80021140 <cons>
    80005aec:	00001097          	auipc	ra,0x1
    80005af0:	83a080e7          	jalr	-1990(ra) # 80006326 <release>
}
    80005af4:	60e2                	ld	ra,24(sp)
    80005af6:	6442                	ld	s0,16(sp)
    80005af8:	64a2                	ld	s1,8(sp)
    80005afa:	6902                	ld	s2,0(sp)
    80005afc:	6105                	addi	sp,sp,32
    80005afe:	8082                	ret
  switch(c){
    80005b00:	07f00793          	li	a5,127
    80005b04:	0af48e63          	beq	s1,a5,80005bc0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b08:	0001b717          	auipc	a4,0x1b
    80005b0c:	63870713          	addi	a4,a4,1592 # 80021140 <cons>
    80005b10:	0a072783          	lw	a5,160(a4)
    80005b14:	09872703          	lw	a4,152(a4)
    80005b18:	9f99                	subw	a5,a5,a4
    80005b1a:	07f00713          	li	a4,127
    80005b1e:	fcf763e3          	bltu	a4,a5,80005ae4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b22:	47b5                	li	a5,13
    80005b24:	0cf48763          	beq	s1,a5,80005bf2 <consoleintr+0x14a>
      consputc(c);
    80005b28:	8526                	mv	a0,s1
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	f3c080e7          	jalr	-196(ra) # 80005a66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b32:	0001b797          	auipc	a5,0x1b
    80005b36:	60e78793          	addi	a5,a5,1550 # 80021140 <cons>
    80005b3a:	0a07a703          	lw	a4,160(a5)
    80005b3e:	0017069b          	addiw	a3,a4,1
    80005b42:	0006861b          	sext.w	a2,a3
    80005b46:	0ad7a023          	sw	a3,160(a5)
    80005b4a:	07f77713          	andi	a4,a4,127
    80005b4e:	97ba                	add	a5,a5,a4
    80005b50:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b54:	47a9                	li	a5,10
    80005b56:	0cf48563          	beq	s1,a5,80005c20 <consoleintr+0x178>
    80005b5a:	4791                	li	a5,4
    80005b5c:	0cf48263          	beq	s1,a5,80005c20 <consoleintr+0x178>
    80005b60:	0001b797          	auipc	a5,0x1b
    80005b64:	6787a783          	lw	a5,1656(a5) # 800211d8 <cons+0x98>
    80005b68:	0807879b          	addiw	a5,a5,128
    80005b6c:	f6f61ce3          	bne	a2,a5,80005ae4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b70:	863e                	mv	a2,a5
    80005b72:	a07d                	j	80005c20 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b74:	0001b717          	auipc	a4,0x1b
    80005b78:	5cc70713          	addi	a4,a4,1484 # 80021140 <cons>
    80005b7c:	0a072783          	lw	a5,160(a4)
    80005b80:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b84:	0001b497          	auipc	s1,0x1b
    80005b88:	5bc48493          	addi	s1,s1,1468 # 80021140 <cons>
    while(cons.e != cons.w &&
    80005b8c:	4929                	li	s2,10
    80005b8e:	f4f70be3          	beq	a4,a5,80005ae4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b92:	37fd                	addiw	a5,a5,-1
    80005b94:	07f7f713          	andi	a4,a5,127
    80005b98:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b9a:	01874703          	lbu	a4,24(a4)
    80005b9e:	f52703e3          	beq	a4,s2,80005ae4 <consoleintr+0x3c>
      cons.e--;
    80005ba2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ba6:	10000513          	li	a0,256
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	ebc080e7          	jalr	-324(ra) # 80005a66 <consputc>
    while(cons.e != cons.w &&
    80005bb2:	0a04a783          	lw	a5,160(s1)
    80005bb6:	09c4a703          	lw	a4,156(s1)
    80005bba:	fcf71ce3          	bne	a4,a5,80005b92 <consoleintr+0xea>
    80005bbe:	b71d                	j	80005ae4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bc0:	0001b717          	auipc	a4,0x1b
    80005bc4:	58070713          	addi	a4,a4,1408 # 80021140 <cons>
    80005bc8:	0a072783          	lw	a5,160(a4)
    80005bcc:	09c72703          	lw	a4,156(a4)
    80005bd0:	f0f70ae3          	beq	a4,a5,80005ae4 <consoleintr+0x3c>
      cons.e--;
    80005bd4:	37fd                	addiw	a5,a5,-1
    80005bd6:	0001b717          	auipc	a4,0x1b
    80005bda:	60f72523          	sw	a5,1546(a4) # 800211e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005bde:	10000513          	li	a0,256
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	e84080e7          	jalr	-380(ra) # 80005a66 <consputc>
    80005bea:	bded                	j	80005ae4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bec:	ee048ce3          	beqz	s1,80005ae4 <consoleintr+0x3c>
    80005bf0:	bf21                	j	80005b08 <consoleintr+0x60>
      consputc(c);
    80005bf2:	4529                	li	a0,10
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	e72080e7          	jalr	-398(ra) # 80005a66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bfc:	0001b797          	auipc	a5,0x1b
    80005c00:	54478793          	addi	a5,a5,1348 # 80021140 <cons>
    80005c04:	0a07a703          	lw	a4,160(a5)
    80005c08:	0017069b          	addiw	a3,a4,1
    80005c0c:	0006861b          	sext.w	a2,a3
    80005c10:	0ad7a023          	sw	a3,160(a5)
    80005c14:	07f77713          	andi	a4,a4,127
    80005c18:	97ba                	add	a5,a5,a4
    80005c1a:	4729                	li	a4,10
    80005c1c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c20:	0001b797          	auipc	a5,0x1b
    80005c24:	5ac7ae23          	sw	a2,1468(a5) # 800211dc <cons+0x9c>
        wakeup(&cons.r);
    80005c28:	0001b517          	auipc	a0,0x1b
    80005c2c:	5b050513          	addi	a0,a0,1456 # 800211d8 <cons+0x98>
    80005c30:	ffffc097          	auipc	ra,0xffffc
    80005c34:	a60080e7          	jalr	-1440(ra) # 80001690 <wakeup>
    80005c38:	b575                	j	80005ae4 <consoleintr+0x3c>

0000000080005c3a <consoleinit>:

void
consoleinit(void)
{
    80005c3a:	1141                	addi	sp,sp,-16
    80005c3c:	e406                	sd	ra,8(sp)
    80005c3e:	e022                	sd	s0,0(sp)
    80005c40:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c42:	00003597          	auipc	a1,0x3
    80005c46:	b5658593          	addi	a1,a1,-1194 # 80008798 <syscalls+0x3d0>
    80005c4a:	0001b517          	auipc	a0,0x1b
    80005c4e:	4f650513          	addi	a0,a0,1270 # 80021140 <cons>
    80005c52:	00000097          	auipc	ra,0x0
    80005c56:	590080e7          	jalr	1424(ra) # 800061e2 <initlock>

  uartinit();
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	330080e7          	jalr	816(ra) # 80005f8a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c62:	0000f797          	auipc	a5,0xf
    80005c66:	87678793          	addi	a5,a5,-1930 # 800144d8 <devsw>
    80005c6a:	00000717          	auipc	a4,0x0
    80005c6e:	ce470713          	addi	a4,a4,-796 # 8000594e <consoleread>
    80005c72:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c74:	00000717          	auipc	a4,0x0
    80005c78:	c7870713          	addi	a4,a4,-904 # 800058ec <consolewrite>
    80005c7c:	ef98                	sd	a4,24(a5)
}
    80005c7e:	60a2                	ld	ra,8(sp)
    80005c80:	6402                	ld	s0,0(sp)
    80005c82:	0141                	addi	sp,sp,16
    80005c84:	8082                	ret

0000000080005c86 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c86:	7179                	addi	sp,sp,-48
    80005c88:	f406                	sd	ra,40(sp)
    80005c8a:	f022                	sd	s0,32(sp)
    80005c8c:	ec26                	sd	s1,24(sp)
    80005c8e:	e84a                	sd	s2,16(sp)
    80005c90:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c92:	c219                	beqz	a2,80005c98 <printint+0x12>
    80005c94:	08054663          	bltz	a0,80005d20 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c98:	2501                	sext.w	a0,a0
    80005c9a:	4881                	li	a7,0
    80005c9c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ca0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ca2:	2581                	sext.w	a1,a1
    80005ca4:	00003617          	auipc	a2,0x3
    80005ca8:	b2460613          	addi	a2,a2,-1244 # 800087c8 <digits>
    80005cac:	883a                	mv	a6,a4
    80005cae:	2705                	addiw	a4,a4,1
    80005cb0:	02b577bb          	remuw	a5,a0,a1
    80005cb4:	1782                	slli	a5,a5,0x20
    80005cb6:	9381                	srli	a5,a5,0x20
    80005cb8:	97b2                	add	a5,a5,a2
    80005cba:	0007c783          	lbu	a5,0(a5)
    80005cbe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cc2:	0005079b          	sext.w	a5,a0
    80005cc6:	02b5553b          	divuw	a0,a0,a1
    80005cca:	0685                	addi	a3,a3,1
    80005ccc:	feb7f0e3          	bgeu	a5,a1,80005cac <printint+0x26>

  if(sign)
    80005cd0:	00088b63          	beqz	a7,80005ce6 <printint+0x60>
    buf[i++] = '-';
    80005cd4:	fe040793          	addi	a5,s0,-32
    80005cd8:	973e                	add	a4,a4,a5
    80005cda:	02d00793          	li	a5,45
    80005cde:	fef70823          	sb	a5,-16(a4)
    80005ce2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ce6:	02e05763          	blez	a4,80005d14 <printint+0x8e>
    80005cea:	fd040793          	addi	a5,s0,-48
    80005cee:	00e784b3          	add	s1,a5,a4
    80005cf2:	fff78913          	addi	s2,a5,-1
    80005cf6:	993a                	add	s2,s2,a4
    80005cf8:	377d                	addiw	a4,a4,-1
    80005cfa:	1702                	slli	a4,a4,0x20
    80005cfc:	9301                	srli	a4,a4,0x20
    80005cfe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d02:	fff4c503          	lbu	a0,-1(s1)
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	d60080e7          	jalr	-672(ra) # 80005a66 <consputc>
  while(--i >= 0)
    80005d0e:	14fd                	addi	s1,s1,-1
    80005d10:	ff2499e3          	bne	s1,s2,80005d02 <printint+0x7c>
}
    80005d14:	70a2                	ld	ra,40(sp)
    80005d16:	7402                	ld	s0,32(sp)
    80005d18:	64e2                	ld	s1,24(sp)
    80005d1a:	6942                	ld	s2,16(sp)
    80005d1c:	6145                	addi	sp,sp,48
    80005d1e:	8082                	ret
    x = -xx;
    80005d20:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d24:	4885                	li	a7,1
    x = -xx;
    80005d26:	bf9d                	j	80005c9c <printint+0x16>

0000000080005d28 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d28:	1101                	addi	sp,sp,-32
    80005d2a:	ec06                	sd	ra,24(sp)
    80005d2c:	e822                	sd	s0,16(sp)
    80005d2e:	e426                	sd	s1,8(sp)
    80005d30:	1000                	addi	s0,sp,32
    80005d32:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d34:	0001b797          	auipc	a5,0x1b
    80005d38:	4c07a623          	sw	zero,1228(a5) # 80021200 <pr+0x18>
  printf("panic: ");
    80005d3c:	00003517          	auipc	a0,0x3
    80005d40:	a6450513          	addi	a0,a0,-1436 # 800087a0 <syscalls+0x3d8>
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	02e080e7          	jalr	46(ra) # 80005d72 <printf>
  printf(s);
    80005d4c:	8526                	mv	a0,s1
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	024080e7          	jalr	36(ra) # 80005d72 <printf>
  printf("\n");
    80005d56:	00002517          	auipc	a0,0x2
    80005d5a:	2f250513          	addi	a0,a0,754 # 80008048 <etext+0x48>
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	014080e7          	jalr	20(ra) # 80005d72 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d66:	4785                	li	a5,1
    80005d68:	00003717          	auipc	a4,0x3
    80005d6c:	2af72a23          	sw	a5,692(a4) # 8000901c <panicked>
  for(;;)
    80005d70:	a001                	j	80005d70 <panic+0x48>

0000000080005d72 <printf>:
{
    80005d72:	7131                	addi	sp,sp,-192
    80005d74:	fc86                	sd	ra,120(sp)
    80005d76:	f8a2                	sd	s0,112(sp)
    80005d78:	f4a6                	sd	s1,104(sp)
    80005d7a:	f0ca                	sd	s2,96(sp)
    80005d7c:	ecce                	sd	s3,88(sp)
    80005d7e:	e8d2                	sd	s4,80(sp)
    80005d80:	e4d6                	sd	s5,72(sp)
    80005d82:	e0da                	sd	s6,64(sp)
    80005d84:	fc5e                	sd	s7,56(sp)
    80005d86:	f862                	sd	s8,48(sp)
    80005d88:	f466                	sd	s9,40(sp)
    80005d8a:	f06a                	sd	s10,32(sp)
    80005d8c:	ec6e                	sd	s11,24(sp)
    80005d8e:	0100                	addi	s0,sp,128
    80005d90:	8a2a                	mv	s4,a0
    80005d92:	e40c                	sd	a1,8(s0)
    80005d94:	e810                	sd	a2,16(s0)
    80005d96:	ec14                	sd	a3,24(s0)
    80005d98:	f018                	sd	a4,32(s0)
    80005d9a:	f41c                	sd	a5,40(s0)
    80005d9c:	03043823          	sd	a6,48(s0)
    80005da0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005da4:	0001bd97          	auipc	s11,0x1b
    80005da8:	45cdad83          	lw	s11,1116(s11) # 80021200 <pr+0x18>
  if(locking)
    80005dac:	020d9b63          	bnez	s11,80005de2 <printf+0x70>
  if (fmt == 0)
    80005db0:	040a0263          	beqz	s4,80005df4 <printf+0x82>
  va_start(ap, fmt);
    80005db4:	00840793          	addi	a5,s0,8
    80005db8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dbc:	000a4503          	lbu	a0,0(s4)
    80005dc0:	16050263          	beqz	a0,80005f24 <printf+0x1b2>
    80005dc4:	4481                	li	s1,0
    if(c != '%'){
    80005dc6:	02500a93          	li	s5,37
    switch(c){
    80005dca:	07000b13          	li	s6,112
  consputc('x');
    80005dce:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dd0:	00003b97          	auipc	s7,0x3
    80005dd4:	9f8b8b93          	addi	s7,s7,-1544 # 800087c8 <digits>
    switch(c){
    80005dd8:	07300c93          	li	s9,115
    80005ddc:	06400c13          	li	s8,100
    80005de0:	a82d                	j	80005e1a <printf+0xa8>
    acquire(&pr.lock);
    80005de2:	0001b517          	auipc	a0,0x1b
    80005de6:	40650513          	addi	a0,a0,1030 # 800211e8 <pr>
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	488080e7          	jalr	1160(ra) # 80006272 <acquire>
    80005df2:	bf7d                	j	80005db0 <printf+0x3e>
    panic("null fmt");
    80005df4:	00003517          	auipc	a0,0x3
    80005df8:	9bc50513          	addi	a0,a0,-1604 # 800087b0 <syscalls+0x3e8>
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	f2c080e7          	jalr	-212(ra) # 80005d28 <panic>
      consputc(c);
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	c62080e7          	jalr	-926(ra) # 80005a66 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e0c:	2485                	addiw	s1,s1,1
    80005e0e:	009a07b3          	add	a5,s4,s1
    80005e12:	0007c503          	lbu	a0,0(a5)
    80005e16:	10050763          	beqz	a0,80005f24 <printf+0x1b2>
    if(c != '%'){
    80005e1a:	ff5515e3          	bne	a0,s5,80005e04 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e1e:	2485                	addiw	s1,s1,1
    80005e20:	009a07b3          	add	a5,s4,s1
    80005e24:	0007c783          	lbu	a5,0(a5)
    80005e28:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e2c:	cfe5                	beqz	a5,80005f24 <printf+0x1b2>
    switch(c){
    80005e2e:	05678a63          	beq	a5,s6,80005e82 <printf+0x110>
    80005e32:	02fb7663          	bgeu	s6,a5,80005e5e <printf+0xec>
    80005e36:	09978963          	beq	a5,s9,80005ec8 <printf+0x156>
    80005e3a:	07800713          	li	a4,120
    80005e3e:	0ce79863          	bne	a5,a4,80005f0e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e42:	f8843783          	ld	a5,-120(s0)
    80005e46:	00878713          	addi	a4,a5,8
    80005e4a:	f8e43423          	sd	a4,-120(s0)
    80005e4e:	4605                	li	a2,1
    80005e50:	85ea                	mv	a1,s10
    80005e52:	4388                	lw	a0,0(a5)
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	e32080e7          	jalr	-462(ra) # 80005c86 <printint>
      break;
    80005e5c:	bf45                	j	80005e0c <printf+0x9a>
    switch(c){
    80005e5e:	0b578263          	beq	a5,s5,80005f02 <printf+0x190>
    80005e62:	0b879663          	bne	a5,s8,80005f0e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e66:	f8843783          	ld	a5,-120(s0)
    80005e6a:	00878713          	addi	a4,a5,8
    80005e6e:	f8e43423          	sd	a4,-120(s0)
    80005e72:	4605                	li	a2,1
    80005e74:	45a9                	li	a1,10
    80005e76:	4388                	lw	a0,0(a5)
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	e0e080e7          	jalr	-498(ra) # 80005c86 <printint>
      break;
    80005e80:	b771                	j	80005e0c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e82:	f8843783          	ld	a5,-120(s0)
    80005e86:	00878713          	addi	a4,a5,8
    80005e8a:	f8e43423          	sd	a4,-120(s0)
    80005e8e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e92:	03000513          	li	a0,48
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	bd0080e7          	jalr	-1072(ra) # 80005a66 <consputc>
  consputc('x');
    80005e9e:	07800513          	li	a0,120
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	bc4080e7          	jalr	-1084(ra) # 80005a66 <consputc>
    80005eaa:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eac:	03c9d793          	srli	a5,s3,0x3c
    80005eb0:	97de                	add	a5,a5,s7
    80005eb2:	0007c503          	lbu	a0,0(a5)
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	bb0080e7          	jalr	-1104(ra) # 80005a66 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ebe:	0992                	slli	s3,s3,0x4
    80005ec0:	397d                	addiw	s2,s2,-1
    80005ec2:	fe0915e3          	bnez	s2,80005eac <printf+0x13a>
    80005ec6:	b799                	j	80005e0c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ec8:	f8843783          	ld	a5,-120(s0)
    80005ecc:	00878713          	addi	a4,a5,8
    80005ed0:	f8e43423          	sd	a4,-120(s0)
    80005ed4:	0007b903          	ld	s2,0(a5)
    80005ed8:	00090e63          	beqz	s2,80005ef4 <printf+0x182>
      for(; *s; s++)
    80005edc:	00094503          	lbu	a0,0(s2)
    80005ee0:	d515                	beqz	a0,80005e0c <printf+0x9a>
        consputc(*s);
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	b84080e7          	jalr	-1148(ra) # 80005a66 <consputc>
      for(; *s; s++)
    80005eea:	0905                	addi	s2,s2,1
    80005eec:	00094503          	lbu	a0,0(s2)
    80005ef0:	f96d                	bnez	a0,80005ee2 <printf+0x170>
    80005ef2:	bf29                	j	80005e0c <printf+0x9a>
        s = "(null)";
    80005ef4:	00003917          	auipc	s2,0x3
    80005ef8:	8b490913          	addi	s2,s2,-1868 # 800087a8 <syscalls+0x3e0>
      for(; *s; s++)
    80005efc:	02800513          	li	a0,40
    80005f00:	b7cd                	j	80005ee2 <printf+0x170>
      consputc('%');
    80005f02:	8556                	mv	a0,s5
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	b62080e7          	jalr	-1182(ra) # 80005a66 <consputc>
      break;
    80005f0c:	b701                	j	80005e0c <printf+0x9a>
      consputc('%');
    80005f0e:	8556                	mv	a0,s5
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	b56080e7          	jalr	-1194(ra) # 80005a66 <consputc>
      consputc(c);
    80005f18:	854a                	mv	a0,s2
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	b4c080e7          	jalr	-1204(ra) # 80005a66 <consputc>
      break;
    80005f22:	b5ed                	j	80005e0c <printf+0x9a>
  if(locking)
    80005f24:	020d9163          	bnez	s11,80005f46 <printf+0x1d4>
}
    80005f28:	70e6                	ld	ra,120(sp)
    80005f2a:	7446                	ld	s0,112(sp)
    80005f2c:	74a6                	ld	s1,104(sp)
    80005f2e:	7906                	ld	s2,96(sp)
    80005f30:	69e6                	ld	s3,88(sp)
    80005f32:	6a46                	ld	s4,80(sp)
    80005f34:	6aa6                	ld	s5,72(sp)
    80005f36:	6b06                	ld	s6,64(sp)
    80005f38:	7be2                	ld	s7,56(sp)
    80005f3a:	7c42                	ld	s8,48(sp)
    80005f3c:	7ca2                	ld	s9,40(sp)
    80005f3e:	7d02                	ld	s10,32(sp)
    80005f40:	6de2                	ld	s11,24(sp)
    80005f42:	6129                	addi	sp,sp,192
    80005f44:	8082                	ret
    release(&pr.lock);
    80005f46:	0001b517          	auipc	a0,0x1b
    80005f4a:	2a250513          	addi	a0,a0,674 # 800211e8 <pr>
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	3d8080e7          	jalr	984(ra) # 80006326 <release>
}
    80005f56:	bfc9                	j	80005f28 <printf+0x1b6>

0000000080005f58 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f58:	1101                	addi	sp,sp,-32
    80005f5a:	ec06                	sd	ra,24(sp)
    80005f5c:	e822                	sd	s0,16(sp)
    80005f5e:	e426                	sd	s1,8(sp)
    80005f60:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f62:	0001b497          	auipc	s1,0x1b
    80005f66:	28648493          	addi	s1,s1,646 # 800211e8 <pr>
    80005f6a:	00003597          	auipc	a1,0x3
    80005f6e:	85658593          	addi	a1,a1,-1962 # 800087c0 <syscalls+0x3f8>
    80005f72:	8526                	mv	a0,s1
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	26e080e7          	jalr	622(ra) # 800061e2 <initlock>
  pr.locking = 1;
    80005f7c:	4785                	li	a5,1
    80005f7e:	cc9c                	sw	a5,24(s1)
}
    80005f80:	60e2                	ld	ra,24(sp)
    80005f82:	6442                	ld	s0,16(sp)
    80005f84:	64a2                	ld	s1,8(sp)
    80005f86:	6105                	addi	sp,sp,32
    80005f88:	8082                	ret

0000000080005f8a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f8a:	1141                	addi	sp,sp,-16
    80005f8c:	e406                	sd	ra,8(sp)
    80005f8e:	e022                	sd	s0,0(sp)
    80005f90:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f92:	100007b7          	lui	a5,0x10000
    80005f96:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f9a:	f8000713          	li	a4,-128
    80005f9e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fa2:	470d                	li	a4,3
    80005fa4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fa8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fac:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fb0:	469d                	li	a3,7
    80005fb2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fb6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fba:	00003597          	auipc	a1,0x3
    80005fbe:	82658593          	addi	a1,a1,-2010 # 800087e0 <digits+0x18>
    80005fc2:	0001b517          	auipc	a0,0x1b
    80005fc6:	24650513          	addi	a0,a0,582 # 80021208 <uart_tx_lock>
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	218080e7          	jalr	536(ra) # 800061e2 <initlock>
}
    80005fd2:	60a2                	ld	ra,8(sp)
    80005fd4:	6402                	ld	s0,0(sp)
    80005fd6:	0141                	addi	sp,sp,16
    80005fd8:	8082                	ret

0000000080005fda <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fda:	1101                	addi	sp,sp,-32
    80005fdc:	ec06                	sd	ra,24(sp)
    80005fde:	e822                	sd	s0,16(sp)
    80005fe0:	e426                	sd	s1,8(sp)
    80005fe2:	1000                	addi	s0,sp,32
    80005fe4:	84aa                	mv	s1,a0
  push_off();
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	240080e7          	jalr	576(ra) # 80006226 <push_off>

  if(panicked){
    80005fee:	00003797          	auipc	a5,0x3
    80005ff2:	02e7a783          	lw	a5,46(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ff6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ffa:	c391                	beqz	a5,80005ffe <uartputc_sync+0x24>
    for(;;)
    80005ffc:	a001                	j	80005ffc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ffe:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006002:	0ff7f793          	andi	a5,a5,255
    80006006:	0207f793          	andi	a5,a5,32
    8000600a:	dbf5                	beqz	a5,80005ffe <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000600c:	0ff4f793          	andi	a5,s1,255
    80006010:	10000737          	lui	a4,0x10000
    80006014:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	2ae080e7          	jalr	686(ra) # 800062c6 <pop_off>
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000602a:	00003717          	auipc	a4,0x3
    8000602e:	ff673703          	ld	a4,-10(a4) # 80009020 <uart_tx_r>
    80006032:	00003797          	auipc	a5,0x3
    80006036:	ff67b783          	ld	a5,-10(a5) # 80009028 <uart_tx_w>
    8000603a:	06e78c63          	beq	a5,a4,800060b2 <uartstart+0x88>
{
    8000603e:	7139                	addi	sp,sp,-64
    80006040:	fc06                	sd	ra,56(sp)
    80006042:	f822                	sd	s0,48(sp)
    80006044:	f426                	sd	s1,40(sp)
    80006046:	f04a                	sd	s2,32(sp)
    80006048:	ec4e                	sd	s3,24(sp)
    8000604a:	e852                	sd	s4,16(sp)
    8000604c:	e456                	sd	s5,8(sp)
    8000604e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006050:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006054:	0001ba17          	auipc	s4,0x1b
    80006058:	1b4a0a13          	addi	s4,s4,436 # 80021208 <uart_tx_lock>
    uart_tx_r += 1;
    8000605c:	00003497          	auipc	s1,0x3
    80006060:	fc448493          	addi	s1,s1,-60 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006064:	00003997          	auipc	s3,0x3
    80006068:	fc498993          	addi	s3,s3,-60 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000606c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006070:	0ff7f793          	andi	a5,a5,255
    80006074:	0207f793          	andi	a5,a5,32
    80006078:	c785                	beqz	a5,800060a0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000607a:	01f77793          	andi	a5,a4,31
    8000607e:	97d2                	add	a5,a5,s4
    80006080:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006084:	0705                	addi	a4,a4,1
    80006086:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006088:	8526                	mv	a0,s1
    8000608a:	ffffb097          	auipc	ra,0xffffb
    8000608e:	606080e7          	jalr	1542(ra) # 80001690 <wakeup>
    
    WriteReg(THR, c);
    80006092:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006096:	6098                	ld	a4,0(s1)
    80006098:	0009b783          	ld	a5,0(s3)
    8000609c:	fce798e3          	bne	a5,a4,8000606c <uartstart+0x42>
  }
}
    800060a0:	70e2                	ld	ra,56(sp)
    800060a2:	7442                	ld	s0,48(sp)
    800060a4:	74a2                	ld	s1,40(sp)
    800060a6:	7902                	ld	s2,32(sp)
    800060a8:	69e2                	ld	s3,24(sp)
    800060aa:	6a42                	ld	s4,16(sp)
    800060ac:	6aa2                	ld	s5,8(sp)
    800060ae:	6121                	addi	sp,sp,64
    800060b0:	8082                	ret
    800060b2:	8082                	ret

00000000800060b4 <uartputc>:
{
    800060b4:	7179                	addi	sp,sp,-48
    800060b6:	f406                	sd	ra,40(sp)
    800060b8:	f022                	sd	s0,32(sp)
    800060ba:	ec26                	sd	s1,24(sp)
    800060bc:	e84a                	sd	s2,16(sp)
    800060be:	e44e                	sd	s3,8(sp)
    800060c0:	e052                	sd	s4,0(sp)
    800060c2:	1800                	addi	s0,sp,48
    800060c4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060c6:	0001b517          	auipc	a0,0x1b
    800060ca:	14250513          	addi	a0,a0,322 # 80021208 <uart_tx_lock>
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	1a4080e7          	jalr	420(ra) # 80006272 <acquire>
  if(panicked){
    800060d6:	00003797          	auipc	a5,0x3
    800060da:	f467a783          	lw	a5,-186(a5) # 8000901c <panicked>
    800060de:	c391                	beqz	a5,800060e2 <uartputc+0x2e>
    for(;;)
    800060e0:	a001                	j	800060e0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060e2:	00003797          	auipc	a5,0x3
    800060e6:	f467b783          	ld	a5,-186(a5) # 80009028 <uart_tx_w>
    800060ea:	00003717          	auipc	a4,0x3
    800060ee:	f3673703          	ld	a4,-202(a4) # 80009020 <uart_tx_r>
    800060f2:	02070713          	addi	a4,a4,32
    800060f6:	02f71b63          	bne	a4,a5,8000612c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060fa:	0001ba17          	auipc	s4,0x1b
    800060fe:	10ea0a13          	addi	s4,s4,270 # 80021208 <uart_tx_lock>
    80006102:	00003497          	auipc	s1,0x3
    80006106:	f1e48493          	addi	s1,s1,-226 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610a:	00003917          	auipc	s2,0x3
    8000610e:	f1e90913          	addi	s2,s2,-226 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006112:	85d2                	mv	a1,s4
    80006114:	8526                	mv	a0,s1
    80006116:	ffffb097          	auipc	ra,0xffffb
    8000611a:	3ee080e7          	jalr	1006(ra) # 80001504 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000611e:	00093783          	ld	a5,0(s2)
    80006122:	6098                	ld	a4,0(s1)
    80006124:	02070713          	addi	a4,a4,32
    80006128:	fef705e3          	beq	a4,a5,80006112 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000612c:	0001b497          	auipc	s1,0x1b
    80006130:	0dc48493          	addi	s1,s1,220 # 80021208 <uart_tx_lock>
    80006134:	01f7f713          	andi	a4,a5,31
    80006138:	9726                	add	a4,a4,s1
    8000613a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000613e:	0785                	addi	a5,a5,1
    80006140:	00003717          	auipc	a4,0x3
    80006144:	eef73423          	sd	a5,-280(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	ee2080e7          	jalr	-286(ra) # 8000602a <uartstart>
      release(&uart_tx_lock);
    80006150:	8526                	mv	a0,s1
    80006152:	00000097          	auipc	ra,0x0
    80006156:	1d4080e7          	jalr	468(ra) # 80006326 <release>
}
    8000615a:	70a2                	ld	ra,40(sp)
    8000615c:	7402                	ld	s0,32(sp)
    8000615e:	64e2                	ld	s1,24(sp)
    80006160:	6942                	ld	s2,16(sp)
    80006162:	69a2                	ld	s3,8(sp)
    80006164:	6a02                	ld	s4,0(sp)
    80006166:	6145                	addi	sp,sp,48
    80006168:	8082                	ret

000000008000616a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000616a:	1141                	addi	sp,sp,-16
    8000616c:	e422                	sd	s0,8(sp)
    8000616e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006170:	100007b7          	lui	a5,0x10000
    80006174:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006178:	8b85                	andi	a5,a5,1
    8000617a:	cb91                	beqz	a5,8000618e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000617c:	100007b7          	lui	a5,0x10000
    80006180:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006184:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006188:	6422                	ld	s0,8(sp)
    8000618a:	0141                	addi	sp,sp,16
    8000618c:	8082                	ret
    return -1;
    8000618e:	557d                	li	a0,-1
    80006190:	bfe5                	j	80006188 <uartgetc+0x1e>

0000000080006192 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006192:	1101                	addi	sp,sp,-32
    80006194:	ec06                	sd	ra,24(sp)
    80006196:	e822                	sd	s0,16(sp)
    80006198:	e426                	sd	s1,8(sp)
    8000619a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000619c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	fcc080e7          	jalr	-52(ra) # 8000616a <uartgetc>
    if(c == -1)
    800061a6:	00950763          	beq	a0,s1,800061b4 <uartintr+0x22>
      break;
    consoleintr(c);
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	8fe080e7          	jalr	-1794(ra) # 80005aa8 <consoleintr>
  while(1){
    800061b2:	b7f5                	j	8000619e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061b4:	0001b497          	auipc	s1,0x1b
    800061b8:	05448493          	addi	s1,s1,84 # 80021208 <uart_tx_lock>
    800061bc:	8526                	mv	a0,s1
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	0b4080e7          	jalr	180(ra) # 80006272 <acquire>
  uartstart();
    800061c6:	00000097          	auipc	ra,0x0
    800061ca:	e64080e7          	jalr	-412(ra) # 8000602a <uartstart>
  release(&uart_tx_lock);
    800061ce:	8526                	mv	a0,s1
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	156080e7          	jalr	342(ra) # 80006326 <release>
}
    800061d8:	60e2                	ld	ra,24(sp)
    800061da:	6442                	ld	s0,16(sp)
    800061dc:	64a2                	ld	s1,8(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret

00000000800061e2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061e2:	1141                	addi	sp,sp,-16
    800061e4:	e422                	sd	s0,8(sp)
    800061e6:	0800                	addi	s0,sp,16
  lk->name = name;
    800061e8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061ea:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061ee:	00053823          	sd	zero,16(a0)
}
    800061f2:	6422                	ld	s0,8(sp)
    800061f4:	0141                	addi	sp,sp,16
    800061f6:	8082                	ret

00000000800061f8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061f8:	411c                	lw	a5,0(a0)
    800061fa:	e399                	bnez	a5,80006200 <holding+0x8>
    800061fc:	4501                	li	a0,0
  return r;
}
    800061fe:	8082                	ret
{
    80006200:	1101                	addi	sp,sp,-32
    80006202:	ec06                	sd	ra,24(sp)
    80006204:	e822                	sd	s0,16(sp)
    80006206:	e426                	sd	s1,8(sp)
    80006208:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000620a:	6904                	ld	s1,16(a0)
    8000620c:	ffffb097          	auipc	ra,0xffffb
    80006210:	c20080e7          	jalr	-992(ra) # 80000e2c <mycpu>
    80006214:	40a48533          	sub	a0,s1,a0
    80006218:	00153513          	seqz	a0,a0
}
    8000621c:	60e2                	ld	ra,24(sp)
    8000621e:	6442                	ld	s0,16(sp)
    80006220:	64a2                	ld	s1,8(sp)
    80006222:	6105                	addi	sp,sp,32
    80006224:	8082                	ret

0000000080006226 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006226:	1101                	addi	sp,sp,-32
    80006228:	ec06                	sd	ra,24(sp)
    8000622a:	e822                	sd	s0,16(sp)
    8000622c:	e426                	sd	s1,8(sp)
    8000622e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006230:	100024f3          	csrr	s1,sstatus
    80006234:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006238:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000623a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	bee080e7          	jalr	-1042(ra) # 80000e2c <mycpu>
    80006246:	5d3c                	lw	a5,120(a0)
    80006248:	cf89                	beqz	a5,80006262 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	be2080e7          	jalr	-1054(ra) # 80000e2c <mycpu>
    80006252:	5d3c                	lw	a5,120(a0)
    80006254:	2785                	addiw	a5,a5,1
    80006256:	dd3c                	sw	a5,120(a0)
}
    80006258:	60e2                	ld	ra,24(sp)
    8000625a:	6442                	ld	s0,16(sp)
    8000625c:	64a2                	ld	s1,8(sp)
    8000625e:	6105                	addi	sp,sp,32
    80006260:	8082                	ret
    mycpu()->intena = old;
    80006262:	ffffb097          	auipc	ra,0xffffb
    80006266:	bca080e7          	jalr	-1078(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000626a:	8085                	srli	s1,s1,0x1
    8000626c:	8885                	andi	s1,s1,1
    8000626e:	dd64                	sw	s1,124(a0)
    80006270:	bfe9                	j	8000624a <push_off+0x24>

0000000080006272 <acquire>:
{
    80006272:	1101                	addi	sp,sp,-32
    80006274:	ec06                	sd	ra,24(sp)
    80006276:	e822                	sd	s0,16(sp)
    80006278:	e426                	sd	s1,8(sp)
    8000627a:	1000                	addi	s0,sp,32
    8000627c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	fa8080e7          	jalr	-88(ra) # 80006226 <push_off>
  if(holding(lk))
    80006286:	8526                	mv	a0,s1
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	f70080e7          	jalr	-144(ra) # 800061f8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006290:	4705                	li	a4,1
  if(holding(lk))
    80006292:	e115                	bnez	a0,800062b6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006294:	87ba                	mv	a5,a4
    80006296:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000629a:	2781                	sext.w	a5,a5
    8000629c:	ffe5                	bnez	a5,80006294 <acquire+0x22>
  __sync_synchronize();
    8000629e:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062a2:	ffffb097          	auipc	ra,0xffffb
    800062a6:	b8a080e7          	jalr	-1142(ra) # 80000e2c <mycpu>
    800062aa:	e888                	sd	a0,16(s1)
}
    800062ac:	60e2                	ld	ra,24(sp)
    800062ae:	6442                	ld	s0,16(sp)
    800062b0:	64a2                	ld	s1,8(sp)
    800062b2:	6105                	addi	sp,sp,32
    800062b4:	8082                	ret
    panic("acquire");
    800062b6:	00002517          	auipc	a0,0x2
    800062ba:	53250513          	addi	a0,a0,1330 # 800087e8 <digits+0x20>
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	a6a080e7          	jalr	-1430(ra) # 80005d28 <panic>

00000000800062c6 <pop_off>:

void
pop_off(void)
{
    800062c6:	1141                	addi	sp,sp,-16
    800062c8:	e406                	sd	ra,8(sp)
    800062ca:	e022                	sd	s0,0(sp)
    800062cc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	b5e080e7          	jalr	-1186(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062da:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062dc:	e78d                	bnez	a5,80006306 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062de:	5d3c                	lw	a5,120(a0)
    800062e0:	02f05b63          	blez	a5,80006316 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062e4:	37fd                	addiw	a5,a5,-1
    800062e6:	0007871b          	sext.w	a4,a5
    800062ea:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062ec:	eb09                	bnez	a4,800062fe <pop_off+0x38>
    800062ee:	5d7c                	lw	a5,124(a0)
    800062f0:	c799                	beqz	a5,800062fe <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062fa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062fe:	60a2                	ld	ra,8(sp)
    80006300:	6402                	ld	s0,0(sp)
    80006302:	0141                	addi	sp,sp,16
    80006304:	8082                	ret
    panic("pop_off - interruptible");
    80006306:	00002517          	auipc	a0,0x2
    8000630a:	4ea50513          	addi	a0,a0,1258 # 800087f0 <digits+0x28>
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	a1a080e7          	jalr	-1510(ra) # 80005d28 <panic>
    panic("pop_off");
    80006316:	00002517          	auipc	a0,0x2
    8000631a:	4f250513          	addi	a0,a0,1266 # 80008808 <digits+0x40>
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	a0a080e7          	jalr	-1526(ra) # 80005d28 <panic>

0000000080006326 <release>:
{
    80006326:	1101                	addi	sp,sp,-32
    80006328:	ec06                	sd	ra,24(sp)
    8000632a:	e822                	sd	s0,16(sp)
    8000632c:	e426                	sd	s1,8(sp)
    8000632e:	1000                	addi	s0,sp,32
    80006330:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006332:	00000097          	auipc	ra,0x0
    80006336:	ec6080e7          	jalr	-314(ra) # 800061f8 <holding>
    8000633a:	c115                	beqz	a0,8000635e <release+0x38>
  lk->cpu = 0;
    8000633c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006340:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006344:	0f50000f          	fence	iorw,ow
    80006348:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000634c:	00000097          	auipc	ra,0x0
    80006350:	f7a080e7          	jalr	-134(ra) # 800062c6 <pop_off>
}
    80006354:	60e2                	ld	ra,24(sp)
    80006356:	6442                	ld	s0,16(sp)
    80006358:	64a2                	ld	s1,8(sp)
    8000635a:	6105                	addi	sp,sp,32
    8000635c:	8082                	ret
    panic("release");
    8000635e:	00002517          	auipc	a0,0x2
    80006362:	4b250513          	addi	a0,a0,1202 # 80008810 <digits+0x48>
    80006366:	00000097          	auipc	ra,0x0
    8000636a:	9c2080e7          	jalr	-1598(ra) # 80005d28 <panic>
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
