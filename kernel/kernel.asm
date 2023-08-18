
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	453050ef          	jal	ra,80005c68 <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000005e:	608080e7          	jalr	1544(ra) # 80006662 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	6a8080e7          	jalr	1704(ra) # 80006716 <release>
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
    8000008e:	08e080e7          	jalr	142(ra) # 80006118 <panic>

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
    800000f8:	4de080e7          	jalr	1246(ra) # 800065d2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
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
    80000130:	536080e7          	jalr	1334(ra) # 80006662 <acquire>
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
    80000148:	5d2080e7          	jalr	1490(ra) # 80006716 <release>

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
    80000172:	5a8080e7          	jalr	1448(ra) # 80006716 <release>
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
    80000332:	b2c080e7          	jalr	-1236(ra) # 80000e5a <cpuid>
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
    8000034e:	b10080e7          	jalr	-1264(ra) # 80000e5a <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	e06080e7          	jalr	-506(ra) # 80006162 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	938080e7          	jalr	-1736(ra) # 80001ca4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	27c080e7          	jalr	636(ra) # 800055f0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	08e080e7          	jalr	142(ra) # 8000140a <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	ca6080e7          	jalr	-858(ra) # 8000602a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	fbc080e7          	jalr	-68(ra) # 80006348 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	dc6080e7          	jalr	-570(ra) # 80006162 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	db6080e7          	jalr	-586(ra) # 80006162 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	da6080e7          	jalr	-602(ra) # 80006162 <printf>
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
    800003e0:	9ce080e7          	jalr	-1586(ra) # 80000daa <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	898080e7          	jalr	-1896(ra) # 80001c7c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	8b8080e7          	jalr	-1864(ra) # 80001ca4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	1e6080e7          	jalr	486(ra) # 800055da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	1f4080e7          	jalr	500(ra) # 800055f0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	3d0080e7          	jalr	976(ra) # 800027d4 <binit>
    iinit();         // inode table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	a60080e7          	jalr	-1440(ra) # 80002e6c <iinit>
    fileinit();      // file table
    80000414:	00004097          	auipc	ra,0x4
    80000418:	a0a080e7          	jalr	-1526(ra) # 80003e1e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	2f6080e7          	jalr	758(ra) # 80005712 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d3c080e7          	jalr	-708(ra) # 80001160 <userinit>
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
    80000492:	c8a080e7          	jalr	-886(ra) # 80006118 <panic>
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
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	b92080e7          	jalr	-1134(ra) # 80006118 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	b82080e7          	jalr	-1150(ra) # 80006118 <panic>
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
    80000610:	00006097          	auipc	ra,0x6
    80000614:	b08080e7          	jalr	-1272(ra) # 80006118 <panic>

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
    800006dc:	63c080e7          	jalr	1596(ra) # 80000d14 <proc_mapstacks>
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
    8000072e:	8b36                	mv	s6,a3
panic("uvmunmap: not aligned");
for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
// panic("uvmunmap: walk");
continue;
if((*pte & PTE_V) == 0)
// panic("uvmunmap: not mapped");
continue;
if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6a85                	lui	s5,0x1
    8000073a:	0535e963          	bltu	a1,s3,8000078c <uvmunmap+0x7e>
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
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	9bc080e7          	jalr	-1604(ra) # 80006118 <panic>
panic("uvmunmap: not a leaf");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	9ac080e7          	jalr	-1620(ra) # 80006118 <panic>
uint64 pa = PTE2PA(*pte);
    80000774:	83a9                	srli	a5,a5,0xa
kfree((void*)pa);
    80000776:	00c79513          	slli	a0,a5,0xc
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	8a2080e7          	jalr	-1886(ra) # 8000001c <kfree>
*pte = 0;
    80000782:	0004b023          	sd	zero,0(s1)
for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000786:	9956                	add	s2,s2,s5
    80000788:	fb397be3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
if((pte = walk(pagetable, a, 0)) == 0)
    8000078c:	4601                	li	a2,0
    8000078e:	85ca                	mv	a1,s2
    80000790:	8552                	mv	a0,s4
    80000792:	00000097          	auipc	ra,0x0
    80000796:	cce080e7          	jalr	-818(ra) # 80000460 <walk>
    8000079a:	84aa                	mv	s1,a0
    8000079c:	d56d                	beqz	a0,80000786 <uvmunmap+0x78>
if((*pte & PTE_V) == 0)
    8000079e:	611c                	ld	a5,0(a0)
    800007a0:	0017f713          	andi	a4,a5,1
    800007a4:	d36d                	beqz	a4,80000786 <uvmunmap+0x78>
if(PTE_FLAGS(*pte) == PTE_V)
    800007a6:	3ff7f713          	andi	a4,a5,1023
    800007aa:	fb770de3          	beq	a4,s7,80000764 <uvmunmap+0x56>
if(do_free){
    800007ae:	fc0b0ae3          	beqz	s6,80000782 <uvmunmap+0x74>
    800007b2:	b7c9                	j	80000774 <uvmunmap+0x66>

00000000800007b4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	95a080e7          	jalr	-1702(ra) # 80000118 <kalloc>
    800007c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007c8:	c519                	beqz	a0,800007d6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ca:	6605                	lui	a2,0x1
    800007cc:	4581                	li	a1,0
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	9aa080e7          	jalr	-1622(ra) # 80000178 <memset>
  return pagetable;
}
    800007d6:	8526                	mv	a0,s1
    800007d8:	60e2                	ld	ra,24(sp)
    800007da:	6442                	ld	s0,16(sp)
    800007dc:	64a2                	ld	s1,8(sp)
    800007de:	6105                	addi	sp,sp,32
    800007e0:	8082                	ret

00000000800007e2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007e2:	7179                	addi	sp,sp,-48
    800007e4:	f406                	sd	ra,40(sp)
    800007e6:	f022                	sd	s0,32(sp)
    800007e8:	ec26                	sd	s1,24(sp)
    800007ea:	e84a                	sd	s2,16(sp)
    800007ec:	e44e                	sd	s3,8(sp)
    800007ee:	e052                	sd	s4,0(sp)
    800007f0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800007f2:	6785                	lui	a5,0x1
    800007f4:	04f67863          	bgeu	a2,a5,80000844 <uvminit+0x62>
    800007f8:	8a2a                	mv	s4,a0
    800007fa:	89ae                	mv	s3,a1
    800007fc:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	91a080e7          	jalr	-1766(ra) # 80000118 <kalloc>
    80000806:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000808:	6605                	lui	a2,0x1
    8000080a:	4581                	li	a1,0
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	96c080e7          	jalr	-1684(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000814:	4779                	li	a4,30
    80000816:	86ca                	mv	a3,s2
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	8552                	mv	a0,s4
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	d2a080e7          	jalr	-726(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000826:	8626                	mv	a2,s1
    80000828:	85ce                	mv	a1,s3
    8000082a:	854a                	mv	a0,s2
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	9ac080e7          	jalr	-1620(ra) # 800001d8 <memmove>
}
    80000834:	70a2                	ld	ra,40(sp)
    80000836:	7402                	ld	s0,32(sp)
    80000838:	64e2                	ld	s1,24(sp)
    8000083a:	6942                	ld	s2,16(sp)
    8000083c:	69a2                	ld	s3,8(sp)
    8000083e:	6a02                	ld	s4,0(sp)
    80000840:	6145                	addi	sp,sp,48
    80000842:	8082                	ret
    panic("inituvm: more than a page");
    80000844:	00008517          	auipc	a0,0x8
    80000848:	86c50513          	addi	a0,a0,-1940 # 800080b0 <etext+0xb0>
    8000084c:	00006097          	auipc	ra,0x6
    80000850:	8cc080e7          	jalr	-1844(ra) # 80006118 <panic>

0000000080000854 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000085e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000860:	00b67d63          	bgeu	a2,a1,8000087a <uvmdealloc+0x26>
    80000864:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000866:	6785                	lui	a5,0x1
    80000868:	17fd                	addi	a5,a5,-1
    8000086a:	00f60733          	add	a4,a2,a5
    8000086e:	767d                	lui	a2,0xfffff
    80000870:	8f71                	and	a4,a4,a2
    80000872:	97ae                	add	a5,a5,a1
    80000874:	8ff1                	and	a5,a5,a2
    80000876:	00f76863          	bltu	a4,a5,80000886 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000087a:	8526                	mv	a0,s1
    8000087c:	60e2                	ld	ra,24(sp)
    8000087e:	6442                	ld	s0,16(sp)
    80000880:	64a2                	ld	s1,8(sp)
    80000882:	6105                	addi	sp,sp,32
    80000884:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000886:	8f99                	sub	a5,a5,a4
    80000888:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000088a:	4685                	li	a3,1
    8000088c:	0007861b          	sext.w	a2,a5
    80000890:	85ba                	mv	a1,a4
    80000892:	00000097          	auipc	ra,0x0
    80000896:	e7c080e7          	jalr	-388(ra) # 8000070e <uvmunmap>
    8000089a:	b7c5                	j	8000087a <uvmdealloc+0x26>

000000008000089c <uvmalloc>:
  if(newsz < oldsz)
    8000089c:	0ab66163          	bltu	a2,a1,8000093e <uvmalloc+0xa2>
{
    800008a0:	7139                	addi	sp,sp,-64
    800008a2:	fc06                	sd	ra,56(sp)
    800008a4:	f822                	sd	s0,48(sp)
    800008a6:	f426                	sd	s1,40(sp)
    800008a8:	f04a                	sd	s2,32(sp)
    800008aa:	ec4e                	sd	s3,24(sp)
    800008ac:	e852                	sd	s4,16(sp)
    800008ae:	e456                	sd	s5,8(sp)
    800008b0:	0080                	addi	s0,sp,64
    800008b2:	8aaa                	mv	s5,a0
    800008b4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008b6:	6985                	lui	s3,0x1
    800008b8:	19fd                	addi	s3,s3,-1
    800008ba:	95ce                	add	a1,a1,s3
    800008bc:	79fd                	lui	s3,0xfffff
    800008be:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008c2:	08c9f063          	bgeu	s3,a2,80000942 <uvmalloc+0xa6>
    800008c6:	894e                	mv	s2,s3
    mem = kalloc();
    800008c8:	00000097          	auipc	ra,0x0
    800008cc:	850080e7          	jalr	-1968(ra) # 80000118 <kalloc>
    800008d0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008d2:	c51d                	beqz	a0,80000900 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008d4:	6605                	lui	a2,0x1
    800008d6:	4581                	li	a1,0
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	8a0080e7          	jalr	-1888(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008e0:	4779                	li	a4,30
    800008e2:	86a6                	mv	a3,s1
    800008e4:	6605                	lui	a2,0x1
    800008e6:	85ca                	mv	a1,s2
    800008e8:	8556                	mv	a0,s5
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	c5e080e7          	jalr	-930(ra) # 80000548 <mappages>
    800008f2:	e905                	bnez	a0,80000922 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008f4:	6785                	lui	a5,0x1
    800008f6:	993e                	add	s2,s2,a5
    800008f8:	fd4968e3          	bltu	s2,s4,800008c8 <uvmalloc+0x2c>
  return newsz;
    800008fc:	8552                	mv	a0,s4
    800008fe:	a809                	j	80000910 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000900:	864e                	mv	a2,s3
    80000902:	85ca                	mv	a1,s2
    80000904:	8556                	mv	a0,s5
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f4e080e7          	jalr	-178(ra) # 80000854 <uvmdealloc>
      return 0;
    8000090e:	4501                	li	a0,0
}
    80000910:	70e2                	ld	ra,56(sp)
    80000912:	7442                	ld	s0,48(sp)
    80000914:	74a2                	ld	s1,40(sp)
    80000916:	7902                	ld	s2,32(sp)
    80000918:	69e2                	ld	s3,24(sp)
    8000091a:	6a42                	ld	s4,16(sp)
    8000091c:	6aa2                	ld	s5,8(sp)
    8000091e:	6121                	addi	sp,sp,64
    80000920:	8082                	ret
      kfree(mem);
    80000922:	8526                	mv	a0,s1
    80000924:	fffff097          	auipc	ra,0xfffff
    80000928:	6f8080e7          	jalr	1784(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000092c:	864e                	mv	a2,s3
    8000092e:	85ca                	mv	a1,s2
    80000930:	8556                	mv	a0,s5
    80000932:	00000097          	auipc	ra,0x0
    80000936:	f22080e7          	jalr	-222(ra) # 80000854 <uvmdealloc>
      return 0;
    8000093a:	4501                	li	a0,0
    8000093c:	bfd1                	j	80000910 <uvmalloc+0x74>
    return oldsz;
    8000093e:	852e                	mv	a0,a1
}
    80000940:	8082                	ret
  return newsz;
    80000942:	8532                	mv	a0,a2
    80000944:	b7f1                	j	80000910 <uvmalloc+0x74>

0000000080000946 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000946:	7179                	addi	sp,sp,-48
    80000948:	f406                	sd	ra,40(sp)
    8000094a:	f022                	sd	s0,32(sp)
    8000094c:	ec26                	sd	s1,24(sp)
    8000094e:	e84a                	sd	s2,16(sp)
    80000950:	e44e                	sd	s3,8(sp)
    80000952:	e052                	sd	s4,0(sp)
    80000954:	1800                	addi	s0,sp,48
    80000956:	8a2a                	mv	s4,a0
// there are 2^9 = 512 PTEs in a page table.
for(int i = 0; i < 512; i++){
    80000958:	84aa                	mv	s1,a0
    8000095a:	6905                	lui	s2,0x1
    8000095c:	992a                	add	s2,s2,a0
pte_t pte = pagetable[i];
if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000095e:	4985                	li	s3,1
    80000960:	a821                	j	80000978 <freewalk+0x32>
// this PTE points to a lower-level page table.
uint64 child = PTE2PA(pte);
    80000962:	8129                	srli	a0,a0,0xa
freewalk((pagetable_t)child);
    80000964:	0532                	slli	a0,a0,0xc
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	fe0080e7          	jalr	-32(ra) # 80000946 <freewalk>
pagetable[i] = 0;
    8000096e:	0004b023          	sd	zero,0(s1)
for(int i = 0; i < 512; i++){
    80000972:	04a1                	addi	s1,s1,8
    80000974:	01248863          	beq	s1,s2,80000984 <freewalk+0x3e>
pte_t pte = pagetable[i];
    80000978:	6088                	ld	a0,0(s1)
if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097a:	00f57793          	andi	a5,a0,15
    8000097e:	ff379ae3          	bne	a5,s3,80000972 <freewalk+0x2c>
    80000982:	b7c5                	j	80000962 <freewalk+0x1c>
} else if(pte & PTE_V){
// panic("freewalk: leaf");
continue;
}
}
kfree((void*)pagetable);
    80000984:	8552                	mv	a0,s4
    80000986:	fffff097          	auipc	ra,0xfffff
    8000098a:	696080e7          	jalr	1686(ra) # 8000001c <kfree>
}
    8000098e:	70a2                	ld	ra,40(sp)
    80000990:	7402                	ld	s0,32(sp)
    80000992:	64e2                	ld	s1,24(sp)
    80000994:	6942                	ld	s2,16(sp)
    80000996:	69a2                	ld	s3,8(sp)
    80000998:	6a02                	ld	s4,0(sp)
    8000099a:	6145                	addi	sp,sp,48
    8000099c:	8082                	ret

000000008000099e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000099e:	1101                	addi	sp,sp,-32
    800009a0:	ec06                	sd	ra,24(sp)
    800009a2:	e822                	sd	s0,16(sp)
    800009a4:	e426                	sd	s1,8(sp)
    800009a6:	1000                	addi	s0,sp,32
    800009a8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009aa:	e999                	bnez	a1,800009c0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009ac:	8526                	mv	a0,s1
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	f98080e7          	jalr	-104(ra) # 80000946 <freewalk>
}
    800009b6:	60e2                	ld	ra,24(sp)
    800009b8:	6442                	ld	s0,16(sp)
    800009ba:	64a2                	ld	s1,8(sp)
    800009bc:	6105                	addi	sp,sp,32
    800009be:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009c0:	6605                	lui	a2,0x1
    800009c2:	167d                	addi	a2,a2,-1
    800009c4:	962e                	add	a2,a2,a1
    800009c6:	4685                	li	a3,1
    800009c8:	8231                	srli	a2,a2,0xc
    800009ca:	4581                	li	a1,0
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	d42080e7          	jalr	-702(ra) # 8000070e <uvmunmap>
    800009d4:	bfe1                	j	800009ac <uvmfree+0xe>

00000000800009d6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009d6:	c679                	beqz	a2,80000aa4 <uvmcopy+0xce>
{
    800009d8:	715d                	addi	sp,sp,-80
    800009da:	e486                	sd	ra,72(sp)
    800009dc:	e0a2                	sd	s0,64(sp)
    800009de:	fc26                	sd	s1,56(sp)
    800009e0:	f84a                	sd	s2,48(sp)
    800009e2:	f44e                	sd	s3,40(sp)
    800009e4:	f052                	sd	s4,32(sp)
    800009e6:	ec56                	sd	s5,24(sp)
    800009e8:	e85a                	sd	s6,16(sp)
    800009ea:	e45e                	sd	s7,8(sp)
    800009ec:	0880                	addi	s0,sp,80
    800009ee:	8b2a                	mv	s6,a0
    800009f0:	8aae                	mv	s5,a1
    800009f2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800009f4:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800009f6:	4601                	li	a2,0
    800009f8:	85ce                	mv	a1,s3
    800009fa:	855a                	mv	a0,s6
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	a64080e7          	jalr	-1436(ra) # 80000460 <walk>
    80000a04:	c531                	beqz	a0,80000a50 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a06:	6118                	ld	a4,0(a0)
    80000a08:	00177793          	andi	a5,a4,1
    80000a0c:	cbb1                	beqz	a5,80000a60 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a0e:	00a75593          	srli	a1,a4,0xa
    80000a12:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a16:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a1a:	fffff097          	auipc	ra,0xfffff
    80000a1e:	6fe080e7          	jalr	1790(ra) # 80000118 <kalloc>
    80000a22:	892a                	mv	s2,a0
    80000a24:	c939                	beqz	a0,80000a7a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a26:	6605                	lui	a2,0x1
    80000a28:	85de                	mv	a1,s7
    80000a2a:	fffff097          	auipc	ra,0xfffff
    80000a2e:	7ae080e7          	jalr	1966(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a32:	8726                	mv	a4,s1
    80000a34:	86ca                	mv	a3,s2
    80000a36:	6605                	lui	a2,0x1
    80000a38:	85ce                	mv	a1,s3
    80000a3a:	8556                	mv	a0,s5
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	b0c080e7          	jalr	-1268(ra) # 80000548 <mappages>
    80000a44:	e515                	bnez	a0,80000a70 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a46:	6785                	lui	a5,0x1
    80000a48:	99be                	add	s3,s3,a5
    80000a4a:	fb49e6e3          	bltu	s3,s4,800009f6 <uvmcopy+0x20>
    80000a4e:	a081                	j	80000a8e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a50:	00007517          	auipc	a0,0x7
    80000a54:	68050513          	addi	a0,a0,1664 # 800080d0 <etext+0xd0>
    80000a58:	00005097          	auipc	ra,0x5
    80000a5c:	6c0080e7          	jalr	1728(ra) # 80006118 <panic>
      panic("uvmcopy: page not present");
    80000a60:	00007517          	auipc	a0,0x7
    80000a64:	69050513          	addi	a0,a0,1680 # 800080f0 <etext+0xf0>
    80000a68:	00005097          	auipc	ra,0x5
    80000a6c:	6b0080e7          	jalr	1712(ra) # 80006118 <panic>
      kfree(mem);
    80000a70:	854a                	mv	a0,s2
    80000a72:	fffff097          	auipc	ra,0xfffff
    80000a76:	5aa080e7          	jalr	1450(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a7a:	4685                	li	a3,1
    80000a7c:	00c9d613          	srli	a2,s3,0xc
    80000a80:	4581                	li	a1,0
    80000a82:	8556                	mv	a0,s5
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	c8a080e7          	jalr	-886(ra) # 8000070e <uvmunmap>
  return -1;
    80000a8c:	557d                	li	a0,-1
}
    80000a8e:	60a6                	ld	ra,72(sp)
    80000a90:	6406                	ld	s0,64(sp)
    80000a92:	74e2                	ld	s1,56(sp)
    80000a94:	7942                	ld	s2,48(sp)
    80000a96:	79a2                	ld	s3,40(sp)
    80000a98:	7a02                	ld	s4,32(sp)
    80000a9a:	6ae2                	ld	s5,24(sp)
    80000a9c:	6b42                	ld	s6,16(sp)
    80000a9e:	6ba2                	ld	s7,8(sp)
    80000aa0:	6161                	addi	sp,sp,80
    80000aa2:	8082                	ret
  return 0;
    80000aa4:	4501                	li	a0,0
}
    80000aa6:	8082                	ret

0000000080000aa8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aa8:	1141                	addi	sp,sp,-16
    80000aaa:	e406                	sd	ra,8(sp)
    80000aac:	e022                	sd	s0,0(sp)
    80000aae:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ab0:	4601                	li	a2,0
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	9ae080e7          	jalr	-1618(ra) # 80000460 <walk>
  if(pte == 0)
    80000aba:	c901                	beqz	a0,80000aca <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000abc:	611c                	ld	a5,0(a0)
    80000abe:	9bbd                	andi	a5,a5,-17
    80000ac0:	e11c                	sd	a5,0(a0)
}
    80000ac2:	60a2                	ld	ra,8(sp)
    80000ac4:	6402                	ld	s0,0(sp)
    80000ac6:	0141                	addi	sp,sp,16
    80000ac8:	8082                	ret
    panic("uvmclear");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	64650513          	addi	a0,a0,1606 # 80008110 <etext+0x110>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	646080e7          	jalr	1606(ra) # 80006118 <panic>

0000000080000ada <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ada:	c6bd                	beqz	a3,80000b48 <copyout+0x6e>
{
    80000adc:	715d                	addi	sp,sp,-80
    80000ade:	e486                	sd	ra,72(sp)
    80000ae0:	e0a2                	sd	s0,64(sp)
    80000ae2:	fc26                	sd	s1,56(sp)
    80000ae4:	f84a                	sd	s2,48(sp)
    80000ae6:	f44e                	sd	s3,40(sp)
    80000ae8:	f052                	sd	s4,32(sp)
    80000aea:	ec56                	sd	s5,24(sp)
    80000aec:	e85a                	sd	s6,16(sp)
    80000aee:	e45e                	sd	s7,8(sp)
    80000af0:	e062                	sd	s8,0(sp)
    80000af2:	0880                	addi	s0,sp,80
    80000af4:	8b2a                	mv	s6,a0
    80000af6:	8c2e                	mv	s8,a1
    80000af8:	8a32                	mv	s4,a2
    80000afa:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000afc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000afe:	6a85                	lui	s5,0x1
    80000b00:	a015                	j	80000b24 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b02:	9562                	add	a0,a0,s8
    80000b04:	0004861b          	sext.w	a2,s1
    80000b08:	85d2                	mv	a1,s4
    80000b0a:	41250533          	sub	a0,a0,s2
    80000b0e:	fffff097          	auipc	ra,0xfffff
    80000b12:	6ca080e7          	jalr	1738(ra) # 800001d8 <memmove>

    len -= n;
    80000b16:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b1a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b1c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b20:	02098263          	beqz	s3,80000b44 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b24:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b28:	85ca                	mv	a1,s2
    80000b2a:	855a                	mv	a0,s6
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	9da080e7          	jalr	-1574(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b34:	cd01                	beqz	a0,80000b4c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b36:	418904b3          	sub	s1,s2,s8
    80000b3a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b3c:	fc99f3e3          	bgeu	s3,s1,80000b02 <copyout+0x28>
    80000b40:	84ce                	mv	s1,s3
    80000b42:	b7c1                	j	80000b02 <copyout+0x28>
  }
  return 0;
    80000b44:	4501                	li	a0,0
    80000b46:	a021                	j	80000b4e <copyout+0x74>
    80000b48:	4501                	li	a0,0
}
    80000b4a:	8082                	ret
      return -1;
    80000b4c:	557d                	li	a0,-1
}
    80000b4e:	60a6                	ld	ra,72(sp)
    80000b50:	6406                	ld	s0,64(sp)
    80000b52:	74e2                	ld	s1,56(sp)
    80000b54:	7942                	ld	s2,48(sp)
    80000b56:	79a2                	ld	s3,40(sp)
    80000b58:	7a02                	ld	s4,32(sp)
    80000b5a:	6ae2                	ld	s5,24(sp)
    80000b5c:	6b42                	ld	s6,16(sp)
    80000b5e:	6ba2                	ld	s7,8(sp)
    80000b60:	6c02                	ld	s8,0(sp)
    80000b62:	6161                	addi	sp,sp,80
    80000b64:	8082                	ret

0000000080000b66 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b66:	c6bd                	beqz	a3,80000bd4 <copyin+0x6e>
{
    80000b68:	715d                	addi	sp,sp,-80
    80000b6a:	e486                	sd	ra,72(sp)
    80000b6c:	e0a2                	sd	s0,64(sp)
    80000b6e:	fc26                	sd	s1,56(sp)
    80000b70:	f84a                	sd	s2,48(sp)
    80000b72:	f44e                	sd	s3,40(sp)
    80000b74:	f052                	sd	s4,32(sp)
    80000b76:	ec56                	sd	s5,24(sp)
    80000b78:	e85a                	sd	s6,16(sp)
    80000b7a:	e45e                	sd	s7,8(sp)
    80000b7c:	e062                	sd	s8,0(sp)
    80000b7e:	0880                	addi	s0,sp,80
    80000b80:	8b2a                	mv	s6,a0
    80000b82:	8a2e                	mv	s4,a1
    80000b84:	8c32                	mv	s8,a2
    80000b86:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b88:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b8a:	6a85                	lui	s5,0x1
    80000b8c:	a015                	j	80000bb0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b8e:	9562                	add	a0,a0,s8
    80000b90:	0004861b          	sext.w	a2,s1
    80000b94:	412505b3          	sub	a1,a0,s2
    80000b98:	8552                	mv	a0,s4
    80000b9a:	fffff097          	auipc	ra,0xfffff
    80000b9e:	63e080e7          	jalr	1598(ra) # 800001d8 <memmove>

    len -= n;
    80000ba2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ba6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ba8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bac:	02098263          	beqz	s3,80000bd0 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb4:	85ca                	mv	a1,s2
    80000bb6:	855a                	mv	a0,s6
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	94e080e7          	jalr	-1714(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bc0:	cd01                	beqz	a0,80000bd8 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bc2:	418904b3          	sub	s1,s2,s8
    80000bc6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc8:	fc99f3e3          	bgeu	s3,s1,80000b8e <copyin+0x28>
    80000bcc:	84ce                	mv	s1,s3
    80000bce:	b7c1                	j	80000b8e <copyin+0x28>
  }
  return 0;
    80000bd0:	4501                	li	a0,0
    80000bd2:	a021                	j	80000bda <copyin+0x74>
    80000bd4:	4501                	li	a0,0
}
    80000bd6:	8082                	ret
      return -1;
    80000bd8:	557d                	li	a0,-1
}
    80000bda:	60a6                	ld	ra,72(sp)
    80000bdc:	6406                	ld	s0,64(sp)
    80000bde:	74e2                	ld	s1,56(sp)
    80000be0:	7942                	ld	s2,48(sp)
    80000be2:	79a2                	ld	s3,40(sp)
    80000be4:	7a02                	ld	s4,32(sp)
    80000be6:	6ae2                	ld	s5,24(sp)
    80000be8:	6b42                	ld	s6,16(sp)
    80000bea:	6ba2                	ld	s7,8(sp)
    80000bec:	6c02                	ld	s8,0(sp)
    80000bee:	6161                	addi	sp,sp,80
    80000bf0:	8082                	ret

0000000080000bf2 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000bf2:	c6c5                	beqz	a3,80000c9a <copyinstr+0xa8>
{
    80000bf4:	715d                	addi	sp,sp,-80
    80000bf6:	e486                	sd	ra,72(sp)
    80000bf8:	e0a2                	sd	s0,64(sp)
    80000bfa:	fc26                	sd	s1,56(sp)
    80000bfc:	f84a                	sd	s2,48(sp)
    80000bfe:	f44e                	sd	s3,40(sp)
    80000c00:	f052                	sd	s4,32(sp)
    80000c02:	ec56                	sd	s5,24(sp)
    80000c04:	e85a                	sd	s6,16(sp)
    80000c06:	e45e                	sd	s7,8(sp)
    80000c08:	0880                	addi	s0,sp,80
    80000c0a:	8a2a                	mv	s4,a0
    80000c0c:	8b2e                	mv	s6,a1
    80000c0e:	8bb2                	mv	s7,a2
    80000c10:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c12:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c14:	6985                	lui	s3,0x1
    80000c16:	a035                	j	80000c42 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c18:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c1c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c1e:	0017b793          	seqz	a5,a5
    80000c22:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c26:	60a6                	ld	ra,72(sp)
    80000c28:	6406                	ld	s0,64(sp)
    80000c2a:	74e2                	ld	s1,56(sp)
    80000c2c:	7942                	ld	s2,48(sp)
    80000c2e:	79a2                	ld	s3,40(sp)
    80000c30:	7a02                	ld	s4,32(sp)
    80000c32:	6ae2                	ld	s5,24(sp)
    80000c34:	6b42                	ld	s6,16(sp)
    80000c36:	6ba2                	ld	s7,8(sp)
    80000c38:	6161                	addi	sp,sp,80
    80000c3a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c3c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c40:	c8a9                	beqz	s1,80000c92 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c42:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c46:	85ca                	mv	a1,s2
    80000c48:	8552                	mv	a0,s4
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	8bc080e7          	jalr	-1860(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c52:	c131                	beqz	a0,80000c96 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c54:	41790833          	sub	a6,s2,s7
    80000c58:	984e                	add	a6,a6,s3
    if(n > max)
    80000c5a:	0104f363          	bgeu	s1,a6,80000c60 <copyinstr+0x6e>
    80000c5e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c60:	955e                	add	a0,a0,s7
    80000c62:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c66:	fc080be3          	beqz	a6,80000c3c <copyinstr+0x4a>
    80000c6a:	985a                	add	a6,a6,s6
    80000c6c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c6e:	41650633          	sub	a2,a0,s6
    80000c72:	14fd                	addi	s1,s1,-1
    80000c74:	9b26                	add	s6,s6,s1
    80000c76:	00f60733          	add	a4,a2,a5
    80000c7a:	00074703          	lbu	a4,0(a4)
    80000c7e:	df49                	beqz	a4,80000c18 <copyinstr+0x26>
        *dst = *p;
    80000c80:	00e78023          	sb	a4,0(a5)
      --max;
    80000c84:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000c88:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c8a:	ff0796e3          	bne	a5,a6,80000c76 <copyinstr+0x84>
      dst++;
    80000c8e:	8b42                	mv	s6,a6
    80000c90:	b775                	j	80000c3c <copyinstr+0x4a>
    80000c92:	4781                	li	a5,0
    80000c94:	b769                	j	80000c1e <copyinstr+0x2c>
      return -1;
    80000c96:	557d                	li	a0,-1
    80000c98:	b779                	j	80000c26 <copyinstr+0x34>
  int got_null = 0;
    80000c9a:	4781                	li	a5,0
  if(got_null){
    80000c9c:	0017b793          	seqz	a5,a5
    80000ca0:	40f00533          	neg	a0,a5
}
    80000ca4:	8082                	ret

0000000080000ca6 <vma_alloc>:
// must be acquired before any p->lock.
struct spinlock wait_lock;

struct vma vma_list[NVMA];
struct vma* vma_alloc()
{
    80000ca6:	7179                	addi	sp,sp,-48
    80000ca8:	f406                	sd	ra,40(sp)
    80000caa:	f022                	sd	s0,32(sp)
    80000cac:	ec26                	sd	s1,24(sp)
    80000cae:	e84a                	sd	s2,16(sp)
    80000cb0:	e44e                	sd	s3,8(sp)
    80000cb2:	1800                	addi	s0,sp,48
for(int i = 0; i < NVMA; i++)
    80000cb4:	00008497          	auipc	s1,0x8
    80000cb8:	3d448493          	addi	s1,s1,980 # 80009088 <vma_list+0x38>
    80000cbc:	4901                	li	s2,0
    80000cbe:	49c1                	li	s3,16
{
acquire(&vma_list[i].lock);
    80000cc0:	8526                	mv	a0,s1
    80000cc2:	00006097          	auipc	ra,0x6
    80000cc6:	9a0080e7          	jalr	-1632(ra) # 80006662 <acquire>
if (vma_list[i].length == 0)
    80000cca:	fd84b783          	ld	a5,-40(s1)
    80000cce:	c39d                	beqz	a5,80000cf4 <vma_alloc+0x4e>
{
return &vma_list[i];
} else
{
release(&vma_list[i].lock);
    80000cd0:	8526                	mv	a0,s1
    80000cd2:	00006097          	auipc	ra,0x6
    80000cd6:	a44080e7          	jalr	-1468(ra) # 80006716 <release>
for(int i = 0; i < NVMA; i++)
    80000cda:	2905                	addiw	s2,s2,1
    80000cdc:	05048493          	addi	s1,s1,80
    80000ce0:	ff3910e3          	bne	s2,s3,80000cc0 <vma_alloc+0x1a>
}
}
panic("no free vma");
    80000ce4:	00007517          	auipc	a0,0x7
    80000ce8:	43c50513          	addi	a0,a0,1084 # 80008120 <etext+0x120>
    80000cec:	00005097          	auipc	ra,0x5
    80000cf0:	42c080e7          	jalr	1068(ra) # 80006118 <panic>
return &vma_list[i];
    80000cf4:	00291513          	slli	a0,s2,0x2
    80000cf8:	954a                	add	a0,a0,s2
    80000cfa:	0512                	slli	a0,a0,0x4
    80000cfc:	00008797          	auipc	a5,0x8
    80000d00:	35478793          	addi	a5,a5,852 # 80009050 <vma_list>
    80000d04:	953e                	add	a0,a0,a5
}
    80000d06:	70a2                	ld	ra,40(sp)
    80000d08:	7402                	ld	s0,32(sp)
    80000d0a:	64e2                	ld	s1,24(sp)
    80000d0c:	6942                	ld	s2,16(sp)
    80000d0e:	69a2                	ld	s3,8(sp)
    80000d10:	6145                	addi	sp,sp,48
    80000d12:	8082                	ret

0000000080000d14 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d14:	7139                	addi	sp,sp,-64
    80000d16:	fc06                	sd	ra,56(sp)
    80000d18:	f822                	sd	s0,48(sp)
    80000d1a:	f426                	sd	s1,40(sp)
    80000d1c:	f04a                	sd	s2,32(sp)
    80000d1e:	ec4e                	sd	s3,24(sp)
    80000d20:	e852                	sd	s4,16(sp)
    80000d22:	e456                	sd	s5,8(sp)
    80000d24:	e05a                	sd	s6,0(sp)
    80000d26:	0080                	addi	s0,sp,64
    80000d28:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2a:	00009497          	auipc	s1,0x9
    80000d2e:	c5648493          	addi	s1,s1,-938 # 80009980 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d32:	8b26                	mv	s6,s1
    80000d34:	00007a97          	auipc	s5,0x7
    80000d38:	2cca8a93          	addi	s5,s5,716 # 80008000 <etext>
    80000d3c:	04000937          	lui	s2,0x4000
    80000d40:	197d                	addi	s2,s2,-1
    80000d42:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	0000fa17          	auipc	s4,0xf
    80000d48:	83ca0a13          	addi	s4,s4,-1988 # 8000f580 <tickslock>
    char *pa = kalloc();
    80000d4c:	fffff097          	auipc	ra,0xfffff
    80000d50:	3cc080e7          	jalr	972(ra) # 80000118 <kalloc>
    80000d54:	862a                	mv	a2,a0
    if(pa == 0)
    80000d56:	c131                	beqz	a0,80000d9a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d58:	416485b3          	sub	a1,s1,s6
    80000d5c:	8591                	srai	a1,a1,0x4
    80000d5e:	000ab783          	ld	a5,0(s5)
    80000d62:	02f585b3          	mul	a1,a1,a5
    80000d66:	2585                	addiw	a1,a1,1
    80000d68:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d6c:	4719                	li	a4,6
    80000d6e:	6685                	lui	a3,0x1
    80000d70:	40b905b3          	sub	a1,s2,a1
    80000d74:	854e                	mv	a0,s3
    80000d76:	00000097          	auipc	ra,0x0
    80000d7a:	872080e7          	jalr	-1934(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7e:	17048493          	addi	s1,s1,368
    80000d82:	fd4495e3          	bne	s1,s4,80000d4c <proc_mapstacks+0x38>
  }
}
    80000d86:	70e2                	ld	ra,56(sp)
    80000d88:	7442                	ld	s0,48(sp)
    80000d8a:	74a2                	ld	s1,40(sp)
    80000d8c:	7902                	ld	s2,32(sp)
    80000d8e:	69e2                	ld	s3,24(sp)
    80000d90:	6a42                	ld	s4,16(sp)
    80000d92:	6aa2                	ld	s5,8(sp)
    80000d94:	6b02                	ld	s6,0(sp)
    80000d96:	6121                	addi	sp,sp,64
    80000d98:	8082                	ret
      panic("kalloc");
    80000d9a:	00007517          	auipc	a0,0x7
    80000d9e:	39650513          	addi	a0,a0,918 # 80008130 <etext+0x130>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	376080e7          	jalr	886(ra) # 80006118 <panic>

0000000080000daa <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000daa:	7139                	addi	sp,sp,-64
    80000dac:	fc06                	sd	ra,56(sp)
    80000dae:	f822                	sd	s0,48(sp)
    80000db0:	f426                	sd	s1,40(sp)
    80000db2:	f04a                	sd	s2,32(sp)
    80000db4:	ec4e                	sd	s3,24(sp)
    80000db6:	e852                	sd	s4,16(sp)
    80000db8:	e456                	sd	s5,8(sp)
    80000dba:	e05a                	sd	s6,0(sp)
    80000dbc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	37a58593          	addi	a1,a1,890 # 80008138 <etext+0x138>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	78a50513          	addi	a0,a0,1930 # 80009550 <pid_lock>
    80000dce:	00006097          	auipc	ra,0x6
    80000dd2:	804080e7          	jalr	-2044(ra) # 800065d2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dd6:	00007597          	auipc	a1,0x7
    80000dda:	36a58593          	addi	a1,a1,874 # 80008140 <etext+0x140>
    80000dde:	00008517          	auipc	a0,0x8
    80000de2:	78a50513          	addi	a0,a0,1930 # 80009568 <wait_lock>
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	7ec080e7          	jalr	2028(ra) # 800065d2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dee:	00009497          	auipc	s1,0x9
    80000df2:	b9248493          	addi	s1,s1,-1134 # 80009980 <proc>
      initlock(&p->lock, "proc");
    80000df6:	00007b17          	auipc	s6,0x7
    80000dfa:	35ab0b13          	addi	s6,s6,858 # 80008150 <etext+0x150>
      p->kstack = KSTACK((int) (p - proc));
    80000dfe:	8aa6                	mv	s5,s1
    80000e00:	00007a17          	auipc	s4,0x7
    80000e04:	200a0a13          	addi	s4,s4,512 # 80008000 <etext>
    80000e08:	04000937          	lui	s2,0x4000
    80000e0c:	197d                	addi	s2,s2,-1
    80000e0e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	0000e997          	auipc	s3,0xe
    80000e14:	77098993          	addi	s3,s3,1904 # 8000f580 <tickslock>
      initlock(&p->lock, "proc");
    80000e18:	85da                	mv	a1,s6
    80000e1a:	8526                	mv	a0,s1
    80000e1c:	00005097          	auipc	ra,0x5
    80000e20:	7b6080e7          	jalr	1974(ra) # 800065d2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e24:	415487b3          	sub	a5,s1,s5
    80000e28:	8791                	srai	a5,a5,0x4
    80000e2a:	000a3703          	ld	a4,0(s4)
    80000e2e:	02e787b3          	mul	a5,a5,a4
    80000e32:	2785                	addiw	a5,a5,1
    80000e34:	00d7979b          	slliw	a5,a5,0xd
    80000e38:	40f907b3          	sub	a5,s2,a5
    80000e3c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3e:	17048493          	addi	s1,s1,368
    80000e42:	fd349be3          	bne	s1,s3,80000e18 <procinit+0x6e>
  }
}
    80000e46:	70e2                	ld	ra,56(sp)
    80000e48:	7442                	ld	s0,48(sp)
    80000e4a:	74a2                	ld	s1,40(sp)
    80000e4c:	7902                	ld	s2,32(sp)
    80000e4e:	69e2                	ld	s3,24(sp)
    80000e50:	6a42                	ld	s4,16(sp)
    80000e52:	6aa2                	ld	s5,8(sp)
    80000e54:	6b02                	ld	s6,0(sp)
    80000e56:	6121                	addi	sp,sp,64
    80000e58:	8082                	ret

0000000080000e5a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e5a:	1141                	addi	sp,sp,-16
    80000e5c:	e422                	sd	s0,8(sp)
    80000e5e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e60:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e62:	2501                	sext.w	a0,a0
    80000e64:	6422                	ld	s0,8(sp)
    80000e66:	0141                	addi	sp,sp,16
    80000e68:	8082                	ret

0000000080000e6a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e6a:	1141                	addi	sp,sp,-16
    80000e6c:	e422                	sd	s0,8(sp)
    80000e6e:	0800                	addi	s0,sp,16
    80000e70:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e72:	2781                	sext.w	a5,a5
    80000e74:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e76:	00008517          	auipc	a0,0x8
    80000e7a:	70a50513          	addi	a0,a0,1802 # 80009580 <cpus>
    80000e7e:	953e                	add	a0,a0,a5
    80000e80:	6422                	ld	s0,8(sp)
    80000e82:	0141                	addi	sp,sp,16
    80000e84:	8082                	ret

0000000080000e86 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e86:	1101                	addi	sp,sp,-32
    80000e88:	ec06                	sd	ra,24(sp)
    80000e8a:	e822                	sd	s0,16(sp)
    80000e8c:	e426                	sd	s1,8(sp)
    80000e8e:	1000                	addi	s0,sp,32
  push_off();
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	786080e7          	jalr	1926(ra) # 80006616 <push_off>
    80000e98:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e9a:	2781                	sext.w	a5,a5
    80000e9c:	079e                	slli	a5,a5,0x7
    80000e9e:	00008717          	auipc	a4,0x8
    80000ea2:	1b270713          	addi	a4,a4,434 # 80009050 <vma_list>
    80000ea6:	97ba                	add	a5,a5,a4
    80000ea8:	5307b483          	ld	s1,1328(a5)
  pop_off();
    80000eac:	00006097          	auipc	ra,0x6
    80000eb0:	80a080e7          	jalr	-2038(ra) # 800066b6 <pop_off>
  return p;
}
    80000eb4:	8526                	mv	a0,s1
    80000eb6:	60e2                	ld	ra,24(sp)
    80000eb8:	6442                	ld	s0,16(sp)
    80000eba:	64a2                	ld	s1,8(sp)
    80000ebc:	6105                	addi	sp,sp,32
    80000ebe:	8082                	ret

0000000080000ec0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e406                	sd	ra,8(sp)
    80000ec4:	e022                	sd	s0,0(sp)
    80000ec6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ec8:	00000097          	auipc	ra,0x0
    80000ecc:	fbe080e7          	jalr	-66(ra) # 80000e86 <myproc>
    80000ed0:	00006097          	auipc	ra,0x6
    80000ed4:	846080e7          	jalr	-1978(ra) # 80006716 <release>

  if (first) {
    80000ed8:	00008797          	auipc	a5,0x8
    80000edc:	9687a783          	lw	a5,-1688(a5) # 80008840 <first.1705>
    80000ee0:	eb89                	bnez	a5,80000ef2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ee2:	00001097          	auipc	ra,0x1
    80000ee6:	dda080e7          	jalr	-550(ra) # 80001cbc <usertrapret>
}
    80000eea:	60a2                	ld	ra,8(sp)
    80000eec:	6402                	ld	s0,0(sp)
    80000eee:	0141                	addi	sp,sp,16
    80000ef0:	8082                	ret
    first = 0;
    80000ef2:	00008797          	auipc	a5,0x8
    80000ef6:	9407a723          	sw	zero,-1714(a5) # 80008840 <first.1705>
    fsinit(ROOTDEV);
    80000efa:	4505                	li	a0,1
    80000efc:	00002097          	auipc	ra,0x2
    80000f00:	ef0080e7          	jalr	-272(ra) # 80002dec <fsinit>
    80000f04:	bff9                	j	80000ee2 <forkret+0x22>

0000000080000f06 <allocpid>:
allocpid() {
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	e04a                	sd	s2,0(sp)
    80000f10:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f12:	00008917          	auipc	s2,0x8
    80000f16:	63e90913          	addi	s2,s2,1598 # 80009550 <pid_lock>
    80000f1a:	854a                	mv	a0,s2
    80000f1c:	00005097          	auipc	ra,0x5
    80000f20:	746080e7          	jalr	1862(ra) # 80006662 <acquire>
  pid = nextpid;
    80000f24:	00008797          	auipc	a5,0x8
    80000f28:	92078793          	addi	a5,a5,-1760 # 80008844 <nextpid>
    80000f2c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f2e:	0014871b          	addiw	a4,s1,1
    80000f32:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f34:	854a                	mv	a0,s2
    80000f36:	00005097          	auipc	ra,0x5
    80000f3a:	7e0080e7          	jalr	2016(ra) # 80006716 <release>
}
    80000f3e:	8526                	mv	a0,s1
    80000f40:	60e2                	ld	ra,24(sp)
    80000f42:	6442                	ld	s0,16(sp)
    80000f44:	64a2                	ld	s1,8(sp)
    80000f46:	6902                	ld	s2,0(sp)
    80000f48:	6105                	addi	sp,sp,32
    80000f4a:	8082                	ret

0000000080000f4c <proc_pagetable>:
{
    80000f4c:	1101                	addi	sp,sp,-32
    80000f4e:	ec06                	sd	ra,24(sp)
    80000f50:	e822                	sd	s0,16(sp)
    80000f52:	e426                	sd	s1,8(sp)
    80000f54:	e04a                	sd	s2,0(sp)
    80000f56:	1000                	addi	s0,sp,32
    80000f58:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f5a:	00000097          	auipc	ra,0x0
    80000f5e:	85a080e7          	jalr	-1958(ra) # 800007b4 <uvmcreate>
    80000f62:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f64:	c121                	beqz	a0,80000fa4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f66:	4729                	li	a4,10
    80000f68:	00006697          	auipc	a3,0x6
    80000f6c:	09868693          	addi	a3,a3,152 # 80007000 <_trampoline>
    80000f70:	6605                	lui	a2,0x1
    80000f72:	040005b7          	lui	a1,0x4000
    80000f76:	15fd                	addi	a1,a1,-1
    80000f78:	05b2                	slli	a1,a1,0xc
    80000f7a:	fffff097          	auipc	ra,0xfffff
    80000f7e:	5ce080e7          	jalr	1486(ra) # 80000548 <mappages>
    80000f82:	02054863          	bltz	a0,80000fb2 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f86:	4719                	li	a4,6
    80000f88:	05893683          	ld	a3,88(s2)
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	020005b7          	lui	a1,0x2000
    80000f92:	15fd                	addi	a1,a1,-1
    80000f94:	05b6                	slli	a1,a1,0xd
    80000f96:	8526                	mv	a0,s1
    80000f98:	fffff097          	auipc	ra,0xfffff
    80000f9c:	5b0080e7          	jalr	1456(ra) # 80000548 <mappages>
    80000fa0:	02054163          	bltz	a0,80000fc2 <proc_pagetable+0x76>
}
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	60e2                	ld	ra,24(sp)
    80000fa8:	6442                	ld	s0,16(sp)
    80000faa:	64a2                	ld	s1,8(sp)
    80000fac:	6902                	ld	s2,0(sp)
    80000fae:	6105                	addi	sp,sp,32
    80000fb0:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb2:	4581                	li	a1,0
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	9e8080e7          	jalr	-1560(ra) # 8000099e <uvmfree>
    return 0;
    80000fbe:	4481                	li	s1,0
    80000fc0:	b7d5                	j	80000fa4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	8526                	mv	a0,s1
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	73e080e7          	jalr	1854(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000fd8:	4581                	li	a1,0
    80000fda:	8526                	mv	a0,s1
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	9c2080e7          	jalr	-1598(ra) # 8000099e <uvmfree>
    return 0;
    80000fe4:	4481                	li	s1,0
    80000fe6:	bf7d                	j	80000fa4 <proc_pagetable+0x58>

0000000080000fe8 <proc_freepagetable>:
{
    80000fe8:	1101                	addi	sp,sp,-32
    80000fea:	ec06                	sd	ra,24(sp)
    80000fec:	e822                	sd	s0,16(sp)
    80000fee:	e426                	sd	s1,8(sp)
    80000ff0:	e04a                	sd	s2,0(sp)
    80000ff2:	1000                	addi	s0,sp,32
    80000ff4:	84aa                	mv	s1,a0
    80000ff6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ff8:	4681                	li	a3,0
    80000ffa:	4605                	li	a2,1
    80000ffc:	040005b7          	lui	a1,0x4000
    80001000:	15fd                	addi	a1,a1,-1
    80001002:	05b2                	slli	a1,a1,0xc
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	70a080e7          	jalr	1802(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000100c:	4681                	li	a3,0
    8000100e:	4605                	li	a2,1
    80001010:	020005b7          	lui	a1,0x2000
    80001014:	15fd                	addi	a1,a1,-1
    80001016:	05b6                	slli	a1,a1,0xd
    80001018:	8526                	mv	a0,s1
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	6f4080e7          	jalr	1780(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001022:	85ca                	mv	a1,s2
    80001024:	8526                	mv	a0,s1
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	978080e7          	jalr	-1672(ra) # 8000099e <uvmfree>
}
    8000102e:	60e2                	ld	ra,24(sp)
    80001030:	6442                	ld	s0,16(sp)
    80001032:	64a2                	ld	s1,8(sp)
    80001034:	6902                	ld	s2,0(sp)
    80001036:	6105                	addi	sp,sp,32
    80001038:	8082                	ret

000000008000103a <freeproc>:
{
    8000103a:	1101                	addi	sp,sp,-32
    8000103c:	ec06                	sd	ra,24(sp)
    8000103e:	e822                	sd	s0,16(sp)
    80001040:	e426                	sd	s1,8(sp)
    80001042:	1000                	addi	s0,sp,32
    80001044:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001046:	6d28                	ld	a0,88(a0)
    80001048:	c509                	beqz	a0,80001052 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	fd2080e7          	jalr	-46(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001052:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001056:	68a8                	ld	a0,80(s1)
    80001058:	c511                	beqz	a0,80001064 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000105a:	64ac                	ld	a1,72(s1)
    8000105c:	00000097          	auipc	ra,0x0
    80001060:	f8c080e7          	jalr	-116(ra) # 80000fe8 <proc_freepagetable>
  p->pagetable = 0;
    80001064:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001068:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000106c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001070:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001074:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001078:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000107c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001080:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001084:	0004ac23          	sw	zero,24(s1)
}
    80001088:	60e2                	ld	ra,24(sp)
    8000108a:	6442                	ld	s0,16(sp)
    8000108c:	64a2                	ld	s1,8(sp)
    8000108e:	6105                	addi	sp,sp,32
    80001090:	8082                	ret

0000000080001092 <allocproc>:
{
    80001092:	1101                	addi	sp,sp,-32
    80001094:	ec06                	sd	ra,24(sp)
    80001096:	e822                	sd	s0,16(sp)
    80001098:	e426                	sd	s1,8(sp)
    8000109a:	e04a                	sd	s2,0(sp)
    8000109c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109e:	00009497          	auipc	s1,0x9
    800010a2:	8e248493          	addi	s1,s1,-1822 # 80009980 <proc>
    800010a6:	0000e917          	auipc	s2,0xe
    800010aa:	4da90913          	addi	s2,s2,1242 # 8000f580 <tickslock>
    acquire(&p->lock);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00005097          	auipc	ra,0x5
    800010b4:	5b2080e7          	jalr	1458(ra) # 80006662 <acquire>
    if(p->state == UNUSED) {
    800010b8:	4c9c                	lw	a5,24(s1)
    800010ba:	cf81                	beqz	a5,800010d2 <allocproc+0x40>
      release(&p->lock);
    800010bc:	8526                	mv	a0,s1
    800010be:	00005097          	auipc	ra,0x5
    800010c2:	658080e7          	jalr	1624(ra) # 80006716 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c6:	17048493          	addi	s1,s1,368
    800010ca:	ff2492e3          	bne	s1,s2,800010ae <allocproc+0x1c>
  return 0;
    800010ce:	4481                	li	s1,0
    800010d0:	a889                	j	80001122 <allocproc+0x90>
  p->pid = allocpid();
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	e34080e7          	jalr	-460(ra) # 80000f06 <allocpid>
    800010da:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010dc:	4785                	li	a5,1
    800010de:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	038080e7          	jalr	56(ra) # 80000118 <kalloc>
    800010e8:	892a                	mv	s2,a0
    800010ea:	eca8                	sd	a0,88(s1)
    800010ec:	c131                	beqz	a0,80001130 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	e5c080e7          	jalr	-420(ra) # 80000f4c <proc_pagetable>
    800010f8:	892a                	mv	s2,a0
    800010fa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010fc:	c531                	beqz	a0,80001148 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010fe:	07000613          	li	a2,112
    80001102:	4581                	li	a1,0
    80001104:	06048513          	addi	a0,s1,96
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	070080e7          	jalr	112(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001110:	00000797          	auipc	a5,0x0
    80001114:	db078793          	addi	a5,a5,-592 # 80000ec0 <forkret>
    80001118:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000111a:	60bc                	ld	a5,64(s1)
    8000111c:	6705                	lui	a4,0x1
    8000111e:	97ba                	add	a5,a5,a4
    80001120:	f4bc                	sd	a5,104(s1)
}
    80001122:	8526                	mv	a0,s1
    80001124:	60e2                	ld	ra,24(sp)
    80001126:	6442                	ld	s0,16(sp)
    80001128:	64a2                	ld	s1,8(sp)
    8000112a:	6902                	ld	s2,0(sp)
    8000112c:	6105                	addi	sp,sp,32
    8000112e:	8082                	ret
    freeproc(p);
    80001130:	8526                	mv	a0,s1
    80001132:	00000097          	auipc	ra,0x0
    80001136:	f08080e7          	jalr	-248(ra) # 8000103a <freeproc>
    release(&p->lock);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00005097          	auipc	ra,0x5
    80001140:	5da080e7          	jalr	1498(ra) # 80006716 <release>
    return 0;
    80001144:	84ca                	mv	s1,s2
    80001146:	bff1                	j	80001122 <allocproc+0x90>
    freeproc(p);
    80001148:	8526                	mv	a0,s1
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	ef0080e7          	jalr	-272(ra) # 8000103a <freeproc>
    release(&p->lock);
    80001152:	8526                	mv	a0,s1
    80001154:	00005097          	auipc	ra,0x5
    80001158:	5c2080e7          	jalr	1474(ra) # 80006716 <release>
    return 0;
    8000115c:	84ca                	mv	s1,s2
    8000115e:	b7d1                	j	80001122 <allocproc+0x90>

0000000080001160 <userinit>:
{
    80001160:	1101                	addi	sp,sp,-32
    80001162:	ec06                	sd	ra,24(sp)
    80001164:	e822                	sd	s0,16(sp)
    80001166:	e426                	sd	s1,8(sp)
    80001168:	1000                	addi	s0,sp,32
  p = allocproc();
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	f28080e7          	jalr	-216(ra) # 80001092 <allocproc>
    80001172:	84aa                	mv	s1,a0
  initproc = p;
    80001174:	00008797          	auipc	a5,0x8
    80001178:	e8a7be23          	sd	a0,-356(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000117c:	03400613          	li	a2,52
    80001180:	00007597          	auipc	a1,0x7
    80001184:	6d058593          	addi	a1,a1,1744 # 80008850 <initcode>
    80001188:	6928                	ld	a0,80(a0)
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	658080e7          	jalr	1624(ra) # 800007e2 <uvminit>
  p->sz = PGSIZE;
    80001192:	6785                	lui	a5,0x1
    80001194:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001196:	6cb8                	ld	a4,88(s1)
    80001198:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000119c:	6cb8                	ld	a4,88(s1)
    8000119e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a0:	4641                	li	a2,16
    800011a2:	00007597          	auipc	a1,0x7
    800011a6:	fb658593          	addi	a1,a1,-74 # 80008158 <etext+0x158>
    800011aa:	15848513          	addi	a0,s1,344
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	11c080e7          	jalr	284(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011b6:	00007517          	auipc	a0,0x7
    800011ba:	fb250513          	addi	a0,a0,-78 # 80008168 <etext+0x168>
    800011be:	00002097          	auipc	ra,0x2
    800011c2:	65c080e7          	jalr	1628(ra) # 8000381a <namei>
    800011c6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ca:	478d                	li	a5,3
    800011cc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ce:	8526                	mv	a0,s1
    800011d0:	00005097          	auipc	ra,0x5
    800011d4:	546080e7          	jalr	1350(ra) # 80006716 <release>
}
    800011d8:	60e2                	ld	ra,24(sp)
    800011da:	6442                	ld	s0,16(sp)
    800011dc:	64a2                	ld	s1,8(sp)
    800011de:	6105                	addi	sp,sp,32
    800011e0:	8082                	ret

00000000800011e2 <growproc>:
{
    800011e2:	1101                	addi	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	e04a                	sd	s2,0(sp)
    800011ec:	1000                	addi	s0,sp,32
    800011ee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	c96080e7          	jalr	-874(ra) # 80000e86 <myproc>
    800011f8:	892a                	mv	s2,a0
  sz = p->sz;
    800011fa:	652c                	ld	a1,72(a0)
    800011fc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001200:	00904f63          	bgtz	s1,8000121e <growproc+0x3c>
  } else if(n < 0){
    80001204:	0204cc63          	bltz	s1,8000123c <growproc+0x5a>
  p->sz = sz;
    80001208:	1602                	slli	a2,a2,0x20
    8000120a:	9201                	srli	a2,a2,0x20
    8000120c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001210:	4501                	li	a0,0
}
    80001212:	60e2                	ld	ra,24(sp)
    80001214:	6442                	ld	s0,16(sp)
    80001216:	64a2                	ld	s1,8(sp)
    80001218:	6902                	ld	s2,0(sp)
    8000121a:	6105                	addi	sp,sp,32
    8000121c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000121e:	9e25                	addw	a2,a2,s1
    80001220:	1602                	slli	a2,a2,0x20
    80001222:	9201                	srli	a2,a2,0x20
    80001224:	1582                	slli	a1,a1,0x20
    80001226:	9181                	srli	a1,a1,0x20
    80001228:	6928                	ld	a0,80(a0)
    8000122a:	fffff097          	auipc	ra,0xfffff
    8000122e:	672080e7          	jalr	1650(ra) # 8000089c <uvmalloc>
    80001232:	0005061b          	sext.w	a2,a0
    80001236:	fa69                	bnez	a2,80001208 <growproc+0x26>
      return -1;
    80001238:	557d                	li	a0,-1
    8000123a:	bfe1                	j	80001212 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000123c:	9e25                	addw	a2,a2,s1
    8000123e:	1602                	slli	a2,a2,0x20
    80001240:	9201                	srli	a2,a2,0x20
    80001242:	1582                	slli	a1,a1,0x20
    80001244:	9181                	srli	a1,a1,0x20
    80001246:	6928                	ld	a0,80(a0)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	60c080e7          	jalr	1548(ra) # 80000854 <uvmdealloc>
    80001250:	0005061b          	sext.w	a2,a0
    80001254:	bf55                	j	80001208 <growproc+0x26>

0000000080001256 <fork>:
{
    80001256:	7139                	addi	sp,sp,-64
    80001258:	fc06                	sd	ra,56(sp)
    8000125a:	f822                	sd	s0,48(sp)
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	c1e080e7          	jalr	-994(ra) # 80000e86 <myproc>
    80001270:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001272:	00000097          	auipc	ra,0x0
    80001276:	e20080e7          	jalr	-480(ra) # 80001092 <allocproc>
    8000127a:	18050663          	beqz	a0,80001406 <fork+0x1b0>
    8000127e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001280:	04893603          	ld	a2,72(s2)
    80001284:	692c                	ld	a1,80(a0)
    80001286:	05093503          	ld	a0,80(s2)
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	74c080e7          	jalr	1868(ra) # 800009d6 <uvmcopy>
    80001292:	04054663          	bltz	a0,800012de <fork+0x88>
  np->sz = p->sz;
    80001296:	04893783          	ld	a5,72(s2)
    8000129a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000129e:	05893683          	ld	a3,88(s2)
    800012a2:	87b6                	mv	a5,a3
    800012a4:	0589b703          	ld	a4,88(s3)
    800012a8:	12068693          	addi	a3,a3,288
    800012ac:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b0:	6788                	ld	a0,8(a5)
    800012b2:	6b8c                	ld	a1,16(a5)
    800012b4:	6f90                	ld	a2,24(a5)
    800012b6:	01073023          	sd	a6,0(a4)
    800012ba:	e708                	sd	a0,8(a4)
    800012bc:	eb0c                	sd	a1,16(a4)
    800012be:	ef10                	sd	a2,24(a4)
    800012c0:	02078793          	addi	a5,a5,32
    800012c4:	02070713          	addi	a4,a4,32
    800012c8:	fed792e3          	bne	a5,a3,800012ac <fork+0x56>
  np->trapframe->a0 = 0;
    800012cc:	0589b783          	ld	a5,88(s3)
    800012d0:	0607b823          	sd	zero,112(a5)
    800012d4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012d8:	15000a13          	li	s4,336
    800012dc:	a03d                	j	8000130a <fork+0xb4>
    freeproc(np);
    800012de:	854e                	mv	a0,s3
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	d5a080e7          	jalr	-678(ra) # 8000103a <freeproc>
    release(&np->lock);
    800012e8:	854e                	mv	a0,s3
    800012ea:	00005097          	auipc	ra,0x5
    800012ee:	42c080e7          	jalr	1068(ra) # 80006716 <release>
    return -1;
    800012f2:	5afd                	li	s5,-1
    800012f4:	a8fd                	j	800013f2 <fork+0x19c>
      np->ofile[i] = filedup(p->ofile[i]);
    800012f6:	00003097          	auipc	ra,0x3
    800012fa:	bba080e7          	jalr	-1094(ra) # 80003eb0 <filedup>
    800012fe:	009987b3          	add	a5,s3,s1
    80001302:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001304:	04a1                	addi	s1,s1,8
    80001306:	01448763          	beq	s1,s4,80001314 <fork+0xbe>
    if(p->ofile[i])
    8000130a:	009907b3          	add	a5,s2,s1
    8000130e:	6388                	ld	a0,0(a5)
    80001310:	f17d                	bnez	a0,800012f6 <fork+0xa0>
    80001312:	bfcd                	j	80001304 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001314:	15093503          	ld	a0,336(s2)
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	d0e080e7          	jalr	-754(ra) # 80003026 <idup>
    80001320:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001324:	4641                	li	a2,16
    80001326:	15890593          	addi	a1,s2,344
    8000132a:	15898513          	addi	a0,s3,344
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	f9c080e7          	jalr	-100(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001336:	0309aa83          	lw	s5,48(s3)
  release(&np->lock);
    8000133a:	854e                	mv	a0,s3
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	3da080e7          	jalr	986(ra) # 80006716 <release>
  acquire(&wait_lock);
    80001344:	00008497          	auipc	s1,0x8
    80001348:	22448493          	addi	s1,s1,548 # 80009568 <wait_lock>
    8000134c:	8526                	mv	a0,s1
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	314080e7          	jalr	788(ra) # 80006662 <acquire>
  np->parent = p;
    80001356:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	3ba080e7          	jalr	954(ra) # 80006716 <release>
  acquire(&np->lock);
    80001364:	854e                	mv	a0,s3
    80001366:	00005097          	auipc	ra,0x5
    8000136a:	2fc080e7          	jalr	764(ra) # 80006662 <acquire>
np->state = RUNNABLE;
    8000136e:	478d                	li	a5,3
    80001370:	00f9ac23          	sw	a5,24(s3)
np->vma = 0;
    80001374:	1609b423          	sd	zero,360(s3)
struct vma *pvma = p->vma;
    80001378:	16893903          	ld	s2,360(s2)
while (pvma)
    8000137c:	06090663          	beqz	s2,800013e8 <fork+0x192>
struct vma *pre = 0;
    80001380:	4481                	li	s1,0
    80001382:	a829                	j	8000139c <fork+0x146>
np->vma = nvma;
    80001384:	1699b423          	sd	s1,360(s3)
release(&nvma->lock);
    80001388:	03848513          	addi	a0,s1,56
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	38a080e7          	jalr	906(ra) # 80006716 <release>
pvma = pvma->next;
    80001394:	03093903          	ld	s2,48(s2)
while (pvma)
    80001398:	04090863          	beqz	s2,800013e8 <fork+0x192>
struct vma *nvma = vma_alloc();
    8000139c:	8a26                	mv	s4,s1
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	908080e7          	jalr	-1784(ra) # 80000ca6 <vma_alloc>
    800013a6:	84aa                	mv	s1,a0
nvma->start = pvma->start;
    800013a8:	00093783          	ld	a5,0(s2)
    800013ac:	e11c                	sd	a5,0(a0)
nvma->end = pvma->end;
    800013ae:	00893783          	ld	a5,8(s2)
    800013b2:	e51c                	sd	a5,8(a0)
nvma->off = pvma->off;
    800013b4:	01893783          	ld	a5,24(s2)
    800013b8:	ed1c                	sd	a5,24(a0)
nvma->length = pvma->length;
    800013ba:	01093783          	ld	a5,16(s2)
    800013be:	e91c                	sd	a5,16(a0)
nvma->perm = pvma->perm;
    800013c0:	02092783          	lw	a5,32(s2)
    800013c4:	d11c                	sw	a5,32(a0)
nvma->flags = pvma->flags;
    800013c6:	02492783          	lw	a5,36(s2)
    800013ca:	d15c                	sw	a5,36(a0)
nvma->file = pvma->file;
    800013cc:	02893503          	ld	a0,40(s2)
    800013d0:	f488                	sd	a0,40(s1)
filedup(nvma->file);
    800013d2:	00003097          	auipc	ra,0x3
    800013d6:	ade080e7          	jalr	-1314(ra) # 80003eb0 <filedup>
nvma->next = 0;
    800013da:	0204b823          	sd	zero,48(s1)
if (pre == 0)
    800013de:	fa0a03e3          	beqz	s4,80001384 <fork+0x12e>
pre->next = nvma;
    800013e2:	029a3823          	sd	s1,48(s4)
    800013e6:	b74d                	j	80001388 <fork+0x132>
release(&np->lock);
    800013e8:	854e                	mv	a0,s3
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	32c080e7          	jalr	812(ra) # 80006716 <release>
}
    800013f2:	8556                	mv	a0,s5
    800013f4:	70e2                	ld	ra,56(sp)
    800013f6:	7442                	ld	s0,48(sp)
    800013f8:	74a2                	ld	s1,40(sp)
    800013fa:	7902                	ld	s2,32(sp)
    800013fc:	69e2                	ld	s3,24(sp)
    800013fe:	6a42                	ld	s4,16(sp)
    80001400:	6aa2                	ld	s5,8(sp)
    80001402:	6121                	addi	sp,sp,64
    80001404:	8082                	ret
    return -1;
    80001406:	5afd                	li	s5,-1
    80001408:	b7ed                	j	800013f2 <fork+0x19c>

000000008000140a <scheduler>:
{
    8000140a:	7139                	addi	sp,sp,-64
    8000140c:	fc06                	sd	ra,56(sp)
    8000140e:	f822                	sd	s0,48(sp)
    80001410:	f426                	sd	s1,40(sp)
    80001412:	f04a                	sd	s2,32(sp)
    80001414:	ec4e                	sd	s3,24(sp)
    80001416:	e852                	sd	s4,16(sp)
    80001418:	e456                	sd	s5,8(sp)
    8000141a:	e05a                	sd	s6,0(sp)
    8000141c:	0080                	addi	s0,sp,64
    8000141e:	8792                	mv	a5,tp
  int id = r_tp();
    80001420:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001422:	00779a93          	slli	s5,a5,0x7
    80001426:	00008717          	auipc	a4,0x8
    8000142a:	c2a70713          	addi	a4,a4,-982 # 80009050 <vma_list>
    8000142e:	9756                	add	a4,a4,s5
    80001430:	52073823          	sd	zero,1328(a4)
        swtch(&c->context, &p->context);
    80001434:	00008717          	auipc	a4,0x8
    80001438:	15470713          	addi	a4,a4,340 # 80009588 <cpus+0x8>
    8000143c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000143e:	498d                	li	s3,3
        p->state = RUNNING;
    80001440:	4b11                	li	s6,4
        c->proc = p;
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	00008a17          	auipc	s4,0x8
    80001448:	c0ca0a13          	addi	s4,s4,-1012 # 80009050 <vma_list>
    8000144c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000144e:	0000e917          	auipc	s2,0xe
    80001452:	13290913          	addi	s2,s2,306 # 8000f580 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001456:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000145a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000145e:	10079073          	csrw	sstatus,a5
    80001462:	00008497          	auipc	s1,0x8
    80001466:	51e48493          	addi	s1,s1,1310 # 80009980 <proc>
    8000146a:	a03d                	j	80001498 <scheduler+0x8e>
        p->state = RUNNING;
    8000146c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001470:	529a3823          	sd	s1,1328(s4)
        swtch(&c->context, &p->context);
    80001474:	06048593          	addi	a1,s1,96
    80001478:	8556                	mv	a0,s5
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	6a4080e7          	jalr	1700(ra) # 80001b1e <swtch>
        c->proc = 0;
    80001482:	520a3823          	sd	zero,1328(s4)
      release(&p->lock);
    80001486:	8526                	mv	a0,s1
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	28e080e7          	jalr	654(ra) # 80006716 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001490:	17048493          	addi	s1,s1,368
    80001494:	fd2481e3          	beq	s1,s2,80001456 <scheduler+0x4c>
      acquire(&p->lock);
    80001498:	8526                	mv	a0,s1
    8000149a:	00005097          	auipc	ra,0x5
    8000149e:	1c8080e7          	jalr	456(ra) # 80006662 <acquire>
      if(p->state == RUNNABLE) {
    800014a2:	4c9c                	lw	a5,24(s1)
    800014a4:	ff3791e3          	bne	a5,s3,80001486 <scheduler+0x7c>
    800014a8:	b7d1                	j	8000146c <scheduler+0x62>

00000000800014aa <sched>:
{
    800014aa:	7179                	addi	sp,sp,-48
    800014ac:	f406                	sd	ra,40(sp)
    800014ae:	f022                	sd	s0,32(sp)
    800014b0:	ec26                	sd	s1,24(sp)
    800014b2:	e84a                	sd	s2,16(sp)
    800014b4:	e44e                	sd	s3,8(sp)
    800014b6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	9ce080e7          	jalr	-1586(ra) # 80000e86 <myproc>
    800014c0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	126080e7          	jalr	294(ra) # 800065e8 <holding>
    800014ca:	c93d                	beqz	a0,80001540 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014cc:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014ce:	2781                	sext.w	a5,a5
    800014d0:	079e                	slli	a5,a5,0x7
    800014d2:	00008717          	auipc	a4,0x8
    800014d6:	b7e70713          	addi	a4,a4,-1154 # 80009050 <vma_list>
    800014da:	97ba                	add	a5,a5,a4
    800014dc:	5a87a703          	lw	a4,1448(a5)
    800014e0:	4785                	li	a5,1
    800014e2:	06f71763          	bne	a4,a5,80001550 <sched+0xa6>
  if(p->state == RUNNING)
    800014e6:	4c98                	lw	a4,24(s1)
    800014e8:	4791                	li	a5,4
    800014ea:	06f70b63          	beq	a4,a5,80001560 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014f2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014f4:	efb5                	bnez	a5,80001570 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014f6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014f8:	00008917          	auipc	s2,0x8
    800014fc:	b5890913          	addi	s2,s2,-1192 # 80009050 <vma_list>
    80001500:	2781                	sext.w	a5,a5
    80001502:	079e                	slli	a5,a5,0x7
    80001504:	97ca                	add	a5,a5,s2
    80001506:	5ac7a983          	lw	s3,1452(a5)
    8000150a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000150c:	2781                	sext.w	a5,a5
    8000150e:	079e                	slli	a5,a5,0x7
    80001510:	00008597          	auipc	a1,0x8
    80001514:	07858593          	addi	a1,a1,120 # 80009588 <cpus+0x8>
    80001518:	95be                	add	a1,a1,a5
    8000151a:	06048513          	addi	a0,s1,96
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	600080e7          	jalr	1536(ra) # 80001b1e <swtch>
    80001526:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001528:	2781                	sext.w	a5,a5
    8000152a:	079e                	slli	a5,a5,0x7
    8000152c:	97ca                	add	a5,a5,s2
    8000152e:	5b37a623          	sw	s3,1452(a5)
}
    80001532:	70a2                	ld	ra,40(sp)
    80001534:	7402                	ld	s0,32(sp)
    80001536:	64e2                	ld	s1,24(sp)
    80001538:	6942                	ld	s2,16(sp)
    8000153a:	69a2                	ld	s3,8(sp)
    8000153c:	6145                	addi	sp,sp,48
    8000153e:	8082                	ret
    panic("sched p->lock");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	c3050513          	addi	a0,a0,-976 # 80008170 <etext+0x170>
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	bd0080e7          	jalr	-1072(ra) # 80006118 <panic>
    panic("sched locks");
    80001550:	00007517          	auipc	a0,0x7
    80001554:	c3050513          	addi	a0,a0,-976 # 80008180 <etext+0x180>
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	bc0080e7          	jalr	-1088(ra) # 80006118 <panic>
    panic("sched running");
    80001560:	00007517          	auipc	a0,0x7
    80001564:	c3050513          	addi	a0,a0,-976 # 80008190 <etext+0x190>
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	bb0080e7          	jalr	-1104(ra) # 80006118 <panic>
    panic("sched interruptible");
    80001570:	00007517          	auipc	a0,0x7
    80001574:	c3050513          	addi	a0,a0,-976 # 800081a0 <etext+0x1a0>
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	ba0080e7          	jalr	-1120(ra) # 80006118 <panic>

0000000080001580 <yield>:
{
    80001580:	1101                	addi	sp,sp,-32
    80001582:	ec06                	sd	ra,24(sp)
    80001584:	e822                	sd	s0,16(sp)
    80001586:	e426                	sd	s1,8(sp)
    80001588:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	8fc080e7          	jalr	-1796(ra) # 80000e86 <myproc>
    80001592:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001594:	00005097          	auipc	ra,0x5
    80001598:	0ce080e7          	jalr	206(ra) # 80006662 <acquire>
  p->state = RUNNABLE;
    8000159c:	478d                	li	a5,3
    8000159e:	cc9c                	sw	a5,24(s1)
  sched();
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	f0a080e7          	jalr	-246(ra) # 800014aa <sched>
  release(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	16c080e7          	jalr	364(ra) # 80006716 <release>
}
    800015b2:	60e2                	ld	ra,24(sp)
    800015b4:	6442                	ld	s0,16(sp)
    800015b6:	64a2                	ld	s1,8(sp)
    800015b8:	6105                	addi	sp,sp,32
    800015ba:	8082                	ret

00000000800015bc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015bc:	7179                	addi	sp,sp,-48
    800015be:	f406                	sd	ra,40(sp)
    800015c0:	f022                	sd	s0,32(sp)
    800015c2:	ec26                	sd	s1,24(sp)
    800015c4:	e84a                	sd	s2,16(sp)
    800015c6:	e44e                	sd	s3,8(sp)
    800015c8:	1800                	addi	s0,sp,48
    800015ca:	89aa                	mv	s3,a0
    800015cc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	8b8080e7          	jalr	-1864(ra) # 80000e86 <myproc>
    800015d6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	08a080e7          	jalr	138(ra) # 80006662 <acquire>
  release(lk);
    800015e0:	854a                	mv	a0,s2
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	134080e7          	jalr	308(ra) # 80006716 <release>

  // Go to sleep.
  p->chan = chan;
    800015ea:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ee:	4789                	li	a5,2
    800015f0:	cc9c                	sw	a5,24(s1)

  sched();
    800015f2:	00000097          	auipc	ra,0x0
    800015f6:	eb8080e7          	jalr	-328(ra) # 800014aa <sched>

  // Tidy up.
  p->chan = 0;
    800015fa:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015fe:	8526                	mv	a0,s1
    80001600:	00005097          	auipc	ra,0x5
    80001604:	116080e7          	jalr	278(ra) # 80006716 <release>
  acquire(lk);
    80001608:	854a                	mv	a0,s2
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	058080e7          	jalr	88(ra) # 80006662 <acquire>
}
    80001612:	70a2                	ld	ra,40(sp)
    80001614:	7402                	ld	s0,32(sp)
    80001616:	64e2                	ld	s1,24(sp)
    80001618:	6942                	ld	s2,16(sp)
    8000161a:	69a2                	ld	s3,8(sp)
    8000161c:	6145                	addi	sp,sp,48
    8000161e:	8082                	ret

0000000080001620 <wait>:
{
    80001620:	715d                	addi	sp,sp,-80
    80001622:	e486                	sd	ra,72(sp)
    80001624:	e0a2                	sd	s0,64(sp)
    80001626:	fc26                	sd	s1,56(sp)
    80001628:	f84a                	sd	s2,48(sp)
    8000162a:	f44e                	sd	s3,40(sp)
    8000162c:	f052                	sd	s4,32(sp)
    8000162e:	ec56                	sd	s5,24(sp)
    80001630:	e85a                	sd	s6,16(sp)
    80001632:	e45e                	sd	s7,8(sp)
    80001634:	e062                	sd	s8,0(sp)
    80001636:	0880                	addi	s0,sp,80
    80001638:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	84c080e7          	jalr	-1972(ra) # 80000e86 <myproc>
    80001642:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	f2450513          	addi	a0,a0,-220 # 80009568 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	016080e7          	jalr	22(ra) # 80006662 <acquire>
    havekids = 0;
    80001654:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001656:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001658:	0000e997          	auipc	s3,0xe
    8000165c:	f2898993          	addi	s3,s3,-216 # 8000f580 <tickslock>
        havekids = 1;
    80001660:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001662:	00008c17          	auipc	s8,0x8
    80001666:	f06c0c13          	addi	s8,s8,-250 # 80009568 <wait_lock>
    havekids = 0;
    8000166a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000166c:	00008497          	auipc	s1,0x8
    80001670:	31448493          	addi	s1,s1,788 # 80009980 <proc>
    80001674:	a0bd                	j	800016e2 <wait+0xc2>
          pid = np->pid;
    80001676:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000167a:	000b0e63          	beqz	s6,80001696 <wait+0x76>
    8000167e:	4691                	li	a3,4
    80001680:	02c48613          	addi	a2,s1,44
    80001684:	85da                	mv	a1,s6
    80001686:	05093503          	ld	a0,80(s2)
    8000168a:	fffff097          	auipc	ra,0xfffff
    8000168e:	450080e7          	jalr	1104(ra) # 80000ada <copyout>
    80001692:	02054563          	bltz	a0,800016bc <wait+0x9c>
          freeproc(np);
    80001696:	8526                	mv	a0,s1
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	9a2080e7          	jalr	-1630(ra) # 8000103a <freeproc>
          release(&np->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	074080e7          	jalr	116(ra) # 80006716 <release>
          release(&wait_lock);
    800016aa:	00008517          	auipc	a0,0x8
    800016ae:	ebe50513          	addi	a0,a0,-322 # 80009568 <wait_lock>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	064080e7          	jalr	100(ra) # 80006716 <release>
          return pid;
    800016ba:	a09d                	j	80001720 <wait+0x100>
            release(&np->lock);
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	058080e7          	jalr	88(ra) # 80006716 <release>
            release(&wait_lock);
    800016c6:	00008517          	auipc	a0,0x8
    800016ca:	ea250513          	addi	a0,a0,-350 # 80009568 <wait_lock>
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	048080e7          	jalr	72(ra) # 80006716 <release>
            return -1;
    800016d6:	59fd                	li	s3,-1
    800016d8:	a0a1                	j	80001720 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800016da:	17048493          	addi	s1,s1,368
    800016de:	03348463          	beq	s1,s3,80001706 <wait+0xe6>
      if(np->parent == p){
    800016e2:	7c9c                	ld	a5,56(s1)
    800016e4:	ff279be3          	bne	a5,s2,800016da <wait+0xba>
        acquire(&np->lock);
    800016e8:	8526                	mv	a0,s1
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	f78080e7          	jalr	-136(ra) # 80006662 <acquire>
        if(np->state == ZOMBIE){
    800016f2:	4c9c                	lw	a5,24(s1)
    800016f4:	f94781e3          	beq	a5,s4,80001676 <wait+0x56>
        release(&np->lock);
    800016f8:	8526                	mv	a0,s1
    800016fa:	00005097          	auipc	ra,0x5
    800016fe:	01c080e7          	jalr	28(ra) # 80006716 <release>
        havekids = 1;
    80001702:	8756                	mv	a4,s5
    80001704:	bfd9                	j	800016da <wait+0xba>
    if(!havekids || p->killed){
    80001706:	c701                	beqz	a4,8000170e <wait+0xee>
    80001708:	02892783          	lw	a5,40(s2)
    8000170c:	c79d                	beqz	a5,8000173a <wait+0x11a>
      release(&wait_lock);
    8000170e:	00008517          	auipc	a0,0x8
    80001712:	e5a50513          	addi	a0,a0,-422 # 80009568 <wait_lock>
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	000080e7          	jalr	ra # 80006716 <release>
      return -1;
    8000171e:	59fd                	li	s3,-1
}
    80001720:	854e                	mv	a0,s3
    80001722:	60a6                	ld	ra,72(sp)
    80001724:	6406                	ld	s0,64(sp)
    80001726:	74e2                	ld	s1,56(sp)
    80001728:	7942                	ld	s2,48(sp)
    8000172a:	79a2                	ld	s3,40(sp)
    8000172c:	7a02                	ld	s4,32(sp)
    8000172e:	6ae2                	ld	s5,24(sp)
    80001730:	6b42                	ld	s6,16(sp)
    80001732:	6ba2                	ld	s7,8(sp)
    80001734:	6c02                	ld	s8,0(sp)
    80001736:	6161                	addi	sp,sp,80
    80001738:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000173a:	85e2                	mv	a1,s8
    8000173c:	854a                	mv	a0,s2
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	e7e080e7          	jalr	-386(ra) # 800015bc <sleep>
    havekids = 0;
    80001746:	b715                	j	8000166a <wait+0x4a>

0000000080001748 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001748:	7139                	addi	sp,sp,-64
    8000174a:	fc06                	sd	ra,56(sp)
    8000174c:	f822                	sd	s0,48(sp)
    8000174e:	f426                	sd	s1,40(sp)
    80001750:	f04a                	sd	s2,32(sp)
    80001752:	ec4e                	sd	s3,24(sp)
    80001754:	e852                	sd	s4,16(sp)
    80001756:	e456                	sd	s5,8(sp)
    80001758:	0080                	addi	s0,sp,64
    8000175a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000175c:	00008497          	auipc	s1,0x8
    80001760:	22448493          	addi	s1,s1,548 # 80009980 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001764:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001766:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001768:	0000e917          	auipc	s2,0xe
    8000176c:	e1890913          	addi	s2,s2,-488 # 8000f580 <tickslock>
    80001770:	a821                	j	80001788 <wakeup+0x40>
        p->state = RUNNABLE;
    80001772:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001776:	8526                	mv	a0,s1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	f9e080e7          	jalr	-98(ra) # 80006716 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001780:	17048493          	addi	s1,s1,368
    80001784:	03248463          	beq	s1,s2,800017ac <wakeup+0x64>
    if(p != myproc()){
    80001788:	fffff097          	auipc	ra,0xfffff
    8000178c:	6fe080e7          	jalr	1790(ra) # 80000e86 <myproc>
    80001790:	fea488e3          	beq	s1,a0,80001780 <wakeup+0x38>
      acquire(&p->lock);
    80001794:	8526                	mv	a0,s1
    80001796:	00005097          	auipc	ra,0x5
    8000179a:	ecc080e7          	jalr	-308(ra) # 80006662 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000179e:	4c9c                	lw	a5,24(s1)
    800017a0:	fd379be3          	bne	a5,s3,80001776 <wakeup+0x2e>
    800017a4:	709c                	ld	a5,32(s1)
    800017a6:	fd4798e3          	bne	a5,s4,80001776 <wakeup+0x2e>
    800017aa:	b7e1                	j	80001772 <wakeup+0x2a>
    }
  }
}
    800017ac:	70e2                	ld	ra,56(sp)
    800017ae:	7442                	ld	s0,48(sp)
    800017b0:	74a2                	ld	s1,40(sp)
    800017b2:	7902                	ld	s2,32(sp)
    800017b4:	69e2                	ld	s3,24(sp)
    800017b6:	6a42                	ld	s4,16(sp)
    800017b8:	6aa2                	ld	s5,8(sp)
    800017ba:	6121                	addi	sp,sp,64
    800017bc:	8082                	ret

00000000800017be <reparent>:
{
    800017be:	7179                	addi	sp,sp,-48
    800017c0:	f406                	sd	ra,40(sp)
    800017c2:	f022                	sd	s0,32(sp)
    800017c4:	ec26                	sd	s1,24(sp)
    800017c6:	e84a                	sd	s2,16(sp)
    800017c8:	e44e                	sd	s3,8(sp)
    800017ca:	e052                	sd	s4,0(sp)
    800017cc:	1800                	addi	s0,sp,48
    800017ce:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017d0:	00008497          	auipc	s1,0x8
    800017d4:	1b048493          	addi	s1,s1,432 # 80009980 <proc>
      pp->parent = initproc;
    800017d8:	00008a17          	auipc	s4,0x8
    800017dc:	838a0a13          	addi	s4,s4,-1992 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017e0:	0000e997          	auipc	s3,0xe
    800017e4:	da098993          	addi	s3,s3,-608 # 8000f580 <tickslock>
    800017e8:	a029                	j	800017f2 <reparent+0x34>
    800017ea:	17048493          	addi	s1,s1,368
    800017ee:	01348d63          	beq	s1,s3,80001808 <reparent+0x4a>
    if(pp->parent == p){
    800017f2:	7c9c                	ld	a5,56(s1)
    800017f4:	ff279be3          	bne	a5,s2,800017ea <reparent+0x2c>
      pp->parent = initproc;
    800017f8:	000a3503          	ld	a0,0(s4)
    800017fc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017fe:	00000097          	auipc	ra,0x0
    80001802:	f4a080e7          	jalr	-182(ra) # 80001748 <wakeup>
    80001806:	b7d5                	j	800017ea <reparent+0x2c>
}
    80001808:	70a2                	ld	ra,40(sp)
    8000180a:	7402                	ld	s0,32(sp)
    8000180c:	64e2                	ld	s1,24(sp)
    8000180e:	6942                	ld	s2,16(sp)
    80001810:	69a2                	ld	s3,8(sp)
    80001812:	6a02                	ld	s4,0(sp)
    80001814:	6145                	addi	sp,sp,48
    80001816:	8082                	ret

0000000080001818 <exit>:
{
    80001818:	7139                	addi	sp,sp,-64
    8000181a:	fc06                	sd	ra,56(sp)
    8000181c:	f822                	sd	s0,48(sp)
    8000181e:	f426                	sd	s1,40(sp)
    80001820:	f04a                	sd	s2,32(sp)
    80001822:	ec4e                	sd	s3,24(sp)
    80001824:	e852                	sd	s4,16(sp)
    80001826:	e456                	sd	s5,8(sp)
    80001828:	e05a                	sd	s6,0(sp)
    8000182a:	0080                	addi	s0,sp,64
    8000182c:	8b2a                	mv	s6,a0
struct proc *p = myproc();
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	658080e7          	jalr	1624(ra) # 80000e86 <myproc>
if (p == initproc)
    80001836:	00007797          	auipc	a5,0x7
    8000183a:	7da7b783          	ld	a5,2010(a5) # 80009010 <initproc>
    8000183e:	06a78763          	beq	a5,a0,800018ac <exit+0x94>
    80001842:	8a2a                	mv	s4,a0
struct vma *v = p->vma;
    80001844:	16853483          	ld	s1,360(a0)
while (v)
    80001848:	cca9                	beqz	s1,800018a2 <exit+0x8a>
uvmunmap(p->pagetable, v->start, PGROUNDUP(v->length) / PGSIZE, 1);
    8000184a:	6a85                	lui	s5,0x1
    8000184c:	1afd                	addi	s5,s5,-1
write_back(v, v->start, v->length);
    8000184e:	4890                	lw	a2,16(s1)
    80001850:	608c                	ld	a1,0(s1)
    80001852:	8526                	mv	a0,s1
    80001854:	00001097          	auipc	ra,0x1
    80001858:	9ce080e7          	jalr	-1586(ra) # 80002222 <write_back>
uvmunmap(p->pagetable, v->start, PGROUNDUP(v->length) / PGSIZE, 1);
    8000185c:	6890                	ld	a2,16(s1)
    8000185e:	9656                	add	a2,a2,s5
    80001860:	4685                	li	a3,1
    80001862:	8231                	srli	a2,a2,0xc
    80001864:	608c                	ld	a1,0(s1)
    80001866:	050a3503          	ld	a0,80(s4)
    8000186a:	fffff097          	auipc	ra,0xfffff
    8000186e:	ea4080e7          	jalr	-348(ra) # 8000070e <uvmunmap>
fileclose(v->file);
    80001872:	7488                	ld	a0,40(s1)
    80001874:	00002097          	auipc	ra,0x2
    80001878:	68e080e7          	jalr	1678(ra) # 80003f02 <fileclose>
pvma = v->next;
    8000187c:	8926                	mv	s2,s1
    8000187e:	7884                	ld	s1,48(s1)
acquire(&v->lock);
    80001880:	03890993          	addi	s3,s2,56
    80001884:	854e                	mv	a0,s3
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	ddc080e7          	jalr	-548(ra) # 80006662 <acquire>
v->next = 0;
    8000188e:	02093823          	sd	zero,48(s2)
v->length = 0;
    80001892:	00093823          	sd	zero,16(s2)
release(&v->lock);
    80001896:	854e                	mv	a0,s3
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	e7e080e7          	jalr	-386(ra) # 80006716 <release>
while (v)
    800018a0:	f4dd                	bnez	s1,8000184e <exit+0x36>
  for(int fd = 0; fd < NOFILE; fd++){
    800018a2:	0d0a0493          	addi	s1,s4,208
    800018a6:	150a0913          	addi	s2,s4,336
    800018aa:	a015                	j	800018ce <exit+0xb6>
panic("init exiting");
    800018ac:	00007517          	auipc	a0,0x7
    800018b0:	90c50513          	addi	a0,a0,-1780 # 800081b8 <etext+0x1b8>
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	864080e7          	jalr	-1948(ra) # 80006118 <panic>
      fileclose(f);
    800018bc:	00002097          	auipc	ra,0x2
    800018c0:	646080e7          	jalr	1606(ra) # 80003f02 <fileclose>
      p->ofile[fd] = 0;
    800018c4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018c8:	04a1                	addi	s1,s1,8
    800018ca:	01248563          	beq	s1,s2,800018d4 <exit+0xbc>
    if(p->ofile[fd]){
    800018ce:	6088                	ld	a0,0(s1)
    800018d0:	f575                	bnez	a0,800018bc <exit+0xa4>
    800018d2:	bfdd                	j	800018c8 <exit+0xb0>
  begin_op();
    800018d4:	00002097          	auipc	ra,0x2
    800018d8:	162080e7          	jalr	354(ra) # 80003a36 <begin_op>
  iput(p->cwd);
    800018dc:	150a3503          	ld	a0,336(s4)
    800018e0:	00002097          	auipc	ra,0x2
    800018e4:	93e080e7          	jalr	-1730(ra) # 8000321e <iput>
  end_op();
    800018e8:	00002097          	auipc	ra,0x2
    800018ec:	1ce080e7          	jalr	462(ra) # 80003ab6 <end_op>
  p->cwd = 0;
    800018f0:	140a3823          	sd	zero,336(s4)
  acquire(&wait_lock);
    800018f4:	00008497          	auipc	s1,0x8
    800018f8:	c7448493          	addi	s1,s1,-908 # 80009568 <wait_lock>
    800018fc:	8526                	mv	a0,s1
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	d64080e7          	jalr	-668(ra) # 80006662 <acquire>
  reparent(p);
    80001906:	8552                	mv	a0,s4
    80001908:	00000097          	auipc	ra,0x0
    8000190c:	eb6080e7          	jalr	-330(ra) # 800017be <reparent>
  wakeup(p->parent);
    80001910:	038a3503          	ld	a0,56(s4)
    80001914:	00000097          	auipc	ra,0x0
    80001918:	e34080e7          	jalr	-460(ra) # 80001748 <wakeup>
  acquire(&p->lock);
    8000191c:	8552                	mv	a0,s4
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	d44080e7          	jalr	-700(ra) # 80006662 <acquire>
  p->xstate = status;
    80001926:	036a2623          	sw	s6,44(s4)
  p->state = ZOMBIE;
    8000192a:	4795                	li	a5,5
    8000192c:	00fa2c23          	sw	a5,24(s4)
  release(&wait_lock);
    80001930:	8526                	mv	a0,s1
    80001932:	00005097          	auipc	ra,0x5
    80001936:	de4080e7          	jalr	-540(ra) # 80006716 <release>
  sched();
    8000193a:	00000097          	auipc	ra,0x0
    8000193e:	b70080e7          	jalr	-1168(ra) # 800014aa <sched>
  panic("zombie exit");
    80001942:	00007517          	auipc	a0,0x7
    80001946:	88650513          	addi	a0,a0,-1914 # 800081c8 <etext+0x1c8>
    8000194a:	00004097          	auipc	ra,0x4
    8000194e:	7ce080e7          	jalr	1998(ra) # 80006118 <panic>

0000000080001952 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001962:	00008497          	auipc	s1,0x8
    80001966:	01e48493          	addi	s1,s1,30 # 80009980 <proc>
    8000196a:	0000e997          	auipc	s3,0xe
    8000196e:	c1698993          	addi	s3,s3,-1002 # 8000f580 <tickslock>
    acquire(&p->lock);
    80001972:	8526                	mv	a0,s1
    80001974:	00005097          	auipc	ra,0x5
    80001978:	cee080e7          	jalr	-786(ra) # 80006662 <acquire>
    if(p->pid == pid){
    8000197c:	589c                	lw	a5,48(s1)
    8000197e:	01278d63          	beq	a5,s2,80001998 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001982:	8526                	mv	a0,s1
    80001984:	00005097          	auipc	ra,0x5
    80001988:	d92080e7          	jalr	-622(ra) # 80006716 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000198c:	17048493          	addi	s1,s1,368
    80001990:	ff3491e3          	bne	s1,s3,80001972 <kill+0x20>
  }
  return -1;
    80001994:	557d                	li	a0,-1
    80001996:	a829                	j	800019b0 <kill+0x5e>
      p->killed = 1;
    80001998:	4785                	li	a5,1
    8000199a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000199c:	4c98                	lw	a4,24(s1)
    8000199e:	4789                	li	a5,2
    800019a0:	00f70f63          	beq	a4,a5,800019be <kill+0x6c>
      release(&p->lock);
    800019a4:	8526                	mv	a0,s1
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	d70080e7          	jalr	-656(ra) # 80006716 <release>
      return 0;
    800019ae:	4501                	li	a0,0
}
    800019b0:	70a2                	ld	ra,40(sp)
    800019b2:	7402                	ld	s0,32(sp)
    800019b4:	64e2                	ld	s1,24(sp)
    800019b6:	6942                	ld	s2,16(sp)
    800019b8:	69a2                	ld	s3,8(sp)
    800019ba:	6145                	addi	sp,sp,48
    800019bc:	8082                	ret
        p->state = RUNNABLE;
    800019be:	478d                	li	a5,3
    800019c0:	cc9c                	sw	a5,24(s1)
    800019c2:	b7cd                	j	800019a4 <kill+0x52>

00000000800019c4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019c4:	7179                	addi	sp,sp,-48
    800019c6:	f406                	sd	ra,40(sp)
    800019c8:	f022                	sd	s0,32(sp)
    800019ca:	ec26                	sd	s1,24(sp)
    800019cc:	e84a                	sd	s2,16(sp)
    800019ce:	e44e                	sd	s3,8(sp)
    800019d0:	e052                	sd	s4,0(sp)
    800019d2:	1800                	addi	s0,sp,48
    800019d4:	84aa                	mv	s1,a0
    800019d6:	892e                	mv	s2,a1
    800019d8:	89b2                	mv	s3,a2
    800019da:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	4aa080e7          	jalr	1194(ra) # 80000e86 <myproc>
  if(user_dst){
    800019e4:	c08d                	beqz	s1,80001a06 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019e6:	86d2                	mv	a3,s4
    800019e8:	864e                	mv	a2,s3
    800019ea:	85ca                	mv	a1,s2
    800019ec:	6928                	ld	a0,80(a0)
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	0ec080e7          	jalr	236(ra) # 80000ada <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019f6:	70a2                	ld	ra,40(sp)
    800019f8:	7402                	ld	s0,32(sp)
    800019fa:	64e2                	ld	s1,24(sp)
    800019fc:	6942                	ld	s2,16(sp)
    800019fe:	69a2                	ld	s3,8(sp)
    80001a00:	6a02                	ld	s4,0(sp)
    80001a02:	6145                	addi	sp,sp,48
    80001a04:	8082                	ret
    memmove((char *)dst, src, len);
    80001a06:	000a061b          	sext.w	a2,s4
    80001a0a:	85ce                	mv	a1,s3
    80001a0c:	854a                	mv	a0,s2
    80001a0e:	ffffe097          	auipc	ra,0xffffe
    80001a12:	7ca080e7          	jalr	1994(ra) # 800001d8 <memmove>
    return 0;
    80001a16:	8526                	mv	a0,s1
    80001a18:	bff9                	j	800019f6 <either_copyout+0x32>

0000000080001a1a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a1a:	7179                	addi	sp,sp,-48
    80001a1c:	f406                	sd	ra,40(sp)
    80001a1e:	f022                	sd	s0,32(sp)
    80001a20:	ec26                	sd	s1,24(sp)
    80001a22:	e84a                	sd	s2,16(sp)
    80001a24:	e44e                	sd	s3,8(sp)
    80001a26:	e052                	sd	s4,0(sp)
    80001a28:	1800                	addi	s0,sp,48
    80001a2a:	892a                	mv	s2,a0
    80001a2c:	84ae                	mv	s1,a1
    80001a2e:	89b2                	mv	s3,a2
    80001a30:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a32:	fffff097          	auipc	ra,0xfffff
    80001a36:	454080e7          	jalr	1108(ra) # 80000e86 <myproc>
  if(user_src){
    80001a3a:	c08d                	beqz	s1,80001a5c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a3c:	86d2                	mv	a3,s4
    80001a3e:	864e                	mv	a2,s3
    80001a40:	85ca                	mv	a1,s2
    80001a42:	6928                	ld	a0,80(a0)
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	122080e7          	jalr	290(ra) # 80000b66 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a4c:	70a2                	ld	ra,40(sp)
    80001a4e:	7402                	ld	s0,32(sp)
    80001a50:	64e2                	ld	s1,24(sp)
    80001a52:	6942                	ld	s2,16(sp)
    80001a54:	69a2                	ld	s3,8(sp)
    80001a56:	6a02                	ld	s4,0(sp)
    80001a58:	6145                	addi	sp,sp,48
    80001a5a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a5c:	000a061b          	sext.w	a2,s4
    80001a60:	85ce                	mv	a1,s3
    80001a62:	854a                	mv	a0,s2
    80001a64:	ffffe097          	auipc	ra,0xffffe
    80001a68:	774080e7          	jalr	1908(ra) # 800001d8 <memmove>
    return 0;
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	bff9                	j	80001a4c <either_copyin+0x32>

0000000080001a70 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a70:	715d                	addi	sp,sp,-80
    80001a72:	e486                	sd	ra,72(sp)
    80001a74:	e0a2                	sd	s0,64(sp)
    80001a76:	fc26                	sd	s1,56(sp)
    80001a78:	f84a                	sd	s2,48(sp)
    80001a7a:	f44e                	sd	s3,40(sp)
    80001a7c:	f052                	sd	s4,32(sp)
    80001a7e:	ec56                	sd	s5,24(sp)
    80001a80:	e85a                	sd	s6,16(sp)
    80001a82:	e45e                	sd	s7,8(sp)
    80001a84:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a86:	00006517          	auipc	a0,0x6
    80001a8a:	5c250513          	addi	a0,a0,1474 # 80008048 <etext+0x48>
    80001a8e:	00004097          	auipc	ra,0x4
    80001a92:	6d4080e7          	jalr	1748(ra) # 80006162 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a96:	00008497          	auipc	s1,0x8
    80001a9a:	04248493          	addi	s1,s1,66 # 80009ad8 <proc+0x158>
    80001a9e:	0000e917          	auipc	s2,0xe
    80001aa2:	c3a90913          	addi	s2,s2,-966 # 8000f6d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa8:	00006997          	auipc	s3,0x6
    80001aac:	73098993          	addi	s3,s3,1840 # 800081d8 <etext+0x1d8>
    printf("%d %s %s", p->pid, state, p->name);
    80001ab0:	00006a97          	auipc	s5,0x6
    80001ab4:	730a8a93          	addi	s5,s5,1840 # 800081e0 <etext+0x1e0>
    printf("\n");
    80001ab8:	00006a17          	auipc	s4,0x6
    80001abc:	590a0a13          	addi	s4,s4,1424 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ac0:	00006b97          	auipc	s7,0x6
    80001ac4:	758b8b93          	addi	s7,s7,1880 # 80008218 <states.1742>
    80001ac8:	a00d                	j	80001aea <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001aca:	ed86a583          	lw	a1,-296(a3)
    80001ace:	8556                	mv	a0,s5
    80001ad0:	00004097          	auipc	ra,0x4
    80001ad4:	692080e7          	jalr	1682(ra) # 80006162 <printf>
    printf("\n");
    80001ad8:	8552                	mv	a0,s4
    80001ada:	00004097          	auipc	ra,0x4
    80001ade:	688080e7          	jalr	1672(ra) # 80006162 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ae2:	17048493          	addi	s1,s1,368
    80001ae6:	03248163          	beq	s1,s2,80001b08 <procdump+0x98>
    if(p->state == UNUSED)
    80001aea:	86a6                	mv	a3,s1
    80001aec:	ec04a783          	lw	a5,-320(s1)
    80001af0:	dbed                	beqz	a5,80001ae2 <procdump+0x72>
      state = "???";
    80001af2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af4:	fcfb6be3          	bltu	s6,a5,80001aca <procdump+0x5a>
    80001af8:	1782                	slli	a5,a5,0x20
    80001afa:	9381                	srli	a5,a5,0x20
    80001afc:	078e                	slli	a5,a5,0x3
    80001afe:	97de                	add	a5,a5,s7
    80001b00:	6390                	ld	a2,0(a5)
    80001b02:	f661                	bnez	a2,80001aca <procdump+0x5a>
      state = "???";
    80001b04:	864e                	mv	a2,s3
    80001b06:	b7d1                	j	80001aca <procdump+0x5a>
  }
}
    80001b08:	60a6                	ld	ra,72(sp)
    80001b0a:	6406                	ld	s0,64(sp)
    80001b0c:	74e2                	ld	s1,56(sp)
    80001b0e:	7942                	ld	s2,48(sp)
    80001b10:	79a2                	ld	s3,40(sp)
    80001b12:	7a02                	ld	s4,32(sp)
    80001b14:	6ae2                	ld	s5,24(sp)
    80001b16:	6b42                	ld	s6,16(sp)
    80001b18:	6ba2                	ld	s7,8(sp)
    80001b1a:	6161                	addi	sp,sp,80
    80001b1c:	8082                	ret

0000000080001b1e <swtch>:
    80001b1e:	00153023          	sd	ra,0(a0)
    80001b22:	00253423          	sd	sp,8(a0)
    80001b26:	e900                	sd	s0,16(a0)
    80001b28:	ed04                	sd	s1,24(a0)
    80001b2a:	03253023          	sd	s2,32(a0)
    80001b2e:	03353423          	sd	s3,40(a0)
    80001b32:	03453823          	sd	s4,48(a0)
    80001b36:	03553c23          	sd	s5,56(a0)
    80001b3a:	05653023          	sd	s6,64(a0)
    80001b3e:	05753423          	sd	s7,72(a0)
    80001b42:	05853823          	sd	s8,80(a0)
    80001b46:	05953c23          	sd	s9,88(a0)
    80001b4a:	07a53023          	sd	s10,96(a0)
    80001b4e:	07b53423          	sd	s11,104(a0)
    80001b52:	0005b083          	ld	ra,0(a1)
    80001b56:	0085b103          	ld	sp,8(a1)
    80001b5a:	6980                	ld	s0,16(a1)
    80001b5c:	6d84                	ld	s1,24(a1)
    80001b5e:	0205b903          	ld	s2,32(a1)
    80001b62:	0285b983          	ld	s3,40(a1)
    80001b66:	0305ba03          	ld	s4,48(a1)
    80001b6a:	0385ba83          	ld	s5,56(a1)
    80001b6e:	0405bb03          	ld	s6,64(a1)
    80001b72:	0485bb83          	ld	s7,72(a1)
    80001b76:	0505bc03          	ld	s8,80(a1)
    80001b7a:	0585bc83          	ld	s9,88(a1)
    80001b7e:	0605bd03          	ld	s10,96(a1)
    80001b82:	0685bd83          	ld	s11,104(a1)
    80001b86:	8082                	ret

0000000080001b88 <mmap_alloc>:
void kernelvec();

extern int devintr();

int mmap_alloc(uint64 va, int scause)
{
    80001b88:	7139                	addi	sp,sp,-64
    80001b8a:	fc06                	sd	ra,56(sp)
    80001b8c:	f822                	sd	s0,48(sp)
    80001b8e:	f426                	sd	s1,40(sp)
    80001b90:	f04a                	sd	s2,32(sp)
    80001b92:	ec4e                	sd	s3,24(sp)
    80001b94:	e852                	sd	s4,16(sp)
    80001b96:	e456                	sd	s5,8(sp)
    80001b98:	0080                	addi	s0,sp,64
    80001b9a:	892a                	mv	s2,a0
    80001b9c:	8a2e                	mv	s4,a1
struct proc *p = myproc();
    80001b9e:	fffff097          	auipc	ra,0xfffff
    80001ba2:	2e8080e7          	jalr	744(ra) # 80000e86 <myproc>
    80001ba6:	89aa                	mv	s3,a0
struct vma* v = p->vma;
    80001ba8:	16853483          	ld	s1,360(a0)
while(v != 0)
    80001bac:	e489                	bnez	s1,80001bb6 <mmap_alloc+0x2e>
break;
}
v = v->next;
}
if (v == 0)
return -1;
    80001bae:	59fd                	li	s3,-1
    80001bb0:	a851                	j	80001c44 <mmap_alloc+0xbc>
v = v->next;
    80001bb2:	7884                	ld	s1,48(s1)
while(v != 0)
    80001bb4:	c0d5                	beqz	s1,80001c58 <mmap_alloc+0xd0>
if (va >= v->start && va < v->end)
    80001bb6:	609c                	ld	a5,0(s1)
    80001bb8:	fef96de3          	bltu	s2,a5,80001bb2 <mmap_alloc+0x2a>
    80001bbc:	649c                	ld	a5,8(s1)
    80001bbe:	fef97ae3          	bgeu	s2,a5,80001bb2 <mmap_alloc+0x2a>
if (scause == 13 && !(v->perm & PTE_R))
    80001bc2:	47b5                	li	a5,13
    80001bc4:	08fa0c63          	beq	s4,a5,80001c5c <mmap_alloc+0xd4>
return -1;
if (scause == 15 && !(v->perm & PTE_W))
    80001bc8:	47bd                	li	a5,15
    80001bca:	00fa1563          	bne	s4,a5,80001bd4 <mmap_alloc+0x4c>
    80001bce:	509c                	lw	a5,32(s1)
    80001bd0:	8b91                	andi	a5,a5,4
    80001bd2:	c3cd                	beqz	a5,80001c74 <mmap_alloc+0xec>
return -1;
// load from file
va = PGROUNDDOWN(va);
    80001bd4:	7a7d                	lui	s4,0xfffff
    80001bd6:	01497a33          	and	s4,s2,s4
char* mmem = kalloc();
    80001bda:	ffffe097          	auipc	ra,0xffffe
    80001bde:	53e080e7          	jalr	1342(ra) # 80000118 <kalloc>
    80001be2:	892a                	mv	s2,a0
if (mmem == 0)
    80001be4:	c951                	beqz	a0,80001c78 <mmap_alloc+0xf0>
return -1;
memset(mmem, 0, PGSIZE);
    80001be6:	6605                	lui	a2,0x1
    80001be8:	4581                	li	a1,0
    80001bea:	ffffe097          	auipc	ra,0xffffe
    80001bee:	58e080e7          	jalr	1422(ra) # 80000178 <memset>
if (mappages(p->pagetable, va, PGSIZE, (uint64)mmem, v->perm) != 0)
    80001bf2:	5098                	lw	a4,32(s1)
    80001bf4:	86ca                	mv	a3,s2
    80001bf6:	6605                	lui	a2,0x1
    80001bf8:	85d2                	mv	a1,s4
    80001bfa:	0509b503          	ld	a0,80(s3)
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	94a080e7          	jalr	-1718(ra) # 80000548 <mappages>
    80001c06:	89aa                	mv	s3,a0
    80001c08:	ed39                	bnez	a0,80001c66 <mmap_alloc+0xde>
{
kfree(mmem);
return -1;
}
struct file *f = v->file;
    80001c0a:	0284ba83          	ld	s5,40(s1)
ilock(f->ip);
    80001c0e:	018ab503          	ld	a0,24(s5)
    80001c12:	00001097          	auipc	ra,0x1
    80001c16:	452080e7          	jalr	1106(ra) # 80003064 <ilock>
readi(f->ip, 0, (uint64)mmem, v->off + va - v->start, PGSIZE);
    80001c1a:	6c94                	ld	a3,24(s1)
    80001c1c:	01468a3b          	addw	s4,a3,s4
    80001c20:	6094                	ld	a3,0(s1)
    80001c22:	6705                	lui	a4,0x1
    80001c24:	40da06bb          	subw	a3,s4,a3
    80001c28:	864a                	mv	a2,s2
    80001c2a:	4581                	li	a1,0
    80001c2c:	018ab503          	ld	a0,24(s5)
    80001c30:	00001097          	auipc	ra,0x1
    80001c34:	6e8080e7          	jalr	1768(ra) # 80003318 <readi>
iunlock(f->ip);
    80001c38:	018ab503          	ld	a0,24(s5)
    80001c3c:	00001097          	auipc	ra,0x1
    80001c40:	4ea080e7          	jalr	1258(ra) # 80003126 <iunlock>
return 0;
}
    80001c44:	854e                	mv	a0,s3
    80001c46:	70e2                	ld	ra,56(sp)
    80001c48:	7442                	ld	s0,48(sp)
    80001c4a:	74a2                	ld	s1,40(sp)
    80001c4c:	7902                	ld	s2,32(sp)
    80001c4e:	69e2                	ld	s3,24(sp)
    80001c50:	6a42                	ld	s4,16(sp)
    80001c52:	6aa2                	ld	s5,8(sp)
    80001c54:	6121                	addi	sp,sp,64
    80001c56:	8082                	ret
return -1;
    80001c58:	59fd                	li	s3,-1
    80001c5a:	b7ed                	j	80001c44 <mmap_alloc+0xbc>
if (scause == 13 && !(v->perm & PTE_R))
    80001c5c:	509c                	lw	a5,32(s1)
    80001c5e:	8b89                	andi	a5,a5,2
    80001c60:	fbb5                	bnez	a5,80001bd4 <mmap_alloc+0x4c>
return -1;
    80001c62:	59fd                	li	s3,-1
    80001c64:	b7c5                	j	80001c44 <mmap_alloc+0xbc>
kfree(mmem);
    80001c66:	854a                	mv	a0,s2
    80001c68:	ffffe097          	auipc	ra,0xffffe
    80001c6c:	3b4080e7          	jalr	948(ra) # 8000001c <kfree>
return -1;
    80001c70:	59fd                	li	s3,-1
    80001c72:	bfc9                	j	80001c44 <mmap_alloc+0xbc>
return -1;
    80001c74:	59fd                	li	s3,-1
    80001c76:	b7f9                	j	80001c44 <mmap_alloc+0xbc>
return -1;
    80001c78:	59fd                	li	s3,-1
    80001c7a:	b7e9                	j	80001c44 <mmap_alloc+0xbc>

0000000080001c7c <trapinit>:

void
trapinit(void)
{
    80001c7c:	1141                	addi	sp,sp,-16
    80001c7e:	e406                	sd	ra,8(sp)
    80001c80:	e022                	sd	s0,0(sp)
    80001c82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c84:	00006597          	auipc	a1,0x6
    80001c88:	5c458593          	addi	a1,a1,1476 # 80008248 <states.1742+0x30>
    80001c8c:	0000e517          	auipc	a0,0xe
    80001c90:	8f450513          	addi	a0,a0,-1804 # 8000f580 <tickslock>
    80001c94:	00005097          	auipc	ra,0x5
    80001c98:	93e080e7          	jalr	-1730(ra) # 800065d2 <initlock>
}
    80001c9c:	60a2                	ld	ra,8(sp)
    80001c9e:	6402                	ld	s0,0(sp)
    80001ca0:	0141                	addi	sp,sp,16
    80001ca2:	8082                	ret

0000000080001ca4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ca4:	1141                	addi	sp,sp,-16
    80001ca6:	e422                	sd	s0,8(sp)
    80001ca8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001caa:	00004797          	auipc	a5,0x4
    80001cae:	87678793          	addi	a5,a5,-1930 # 80005520 <kernelvec>
    80001cb2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cb6:	6422                	ld	s0,8(sp)
    80001cb8:	0141                	addi	sp,sp,16
    80001cba:	8082                	ret

0000000080001cbc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cbc:	1141                	addi	sp,sp,-16
    80001cbe:	e406                	sd	ra,8(sp)
    80001cc0:	e022                	sd	s0,0(sp)
    80001cc2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	1c2080e7          	jalr	450(ra) # 80000e86 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cd6:	00005617          	auipc	a2,0x5
    80001cda:	32a60613          	addi	a2,a2,810 # 80007000 <_trampoline>
    80001cde:	00005697          	auipc	a3,0x5
    80001ce2:	32268693          	addi	a3,a3,802 # 80007000 <_trampoline>
    80001ce6:	8e91                	sub	a3,a3,a2
    80001ce8:	040007b7          	lui	a5,0x4000
    80001cec:	17fd                	addi	a5,a5,-1
    80001cee:	07b2                	slli	a5,a5,0xc
    80001cf0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cf6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cf8:	180026f3          	csrr	a3,satp
    80001cfc:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cfe:	6d38                	ld	a4,88(a0)
    80001d00:	6134                	ld	a3,64(a0)
    80001d02:	6585                	lui	a1,0x1
    80001d04:	96ae                	add	a3,a3,a1
    80001d06:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d08:	6d38                	ld	a4,88(a0)
    80001d0a:	00000697          	auipc	a3,0x0
    80001d0e:	13868693          	addi	a3,a3,312 # 80001e42 <usertrap>
    80001d12:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d14:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d16:	8692                	mv	a3,tp
    80001d18:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d1e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d22:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d26:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d2a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d2c:	6f18                	ld	a4,24(a4)
    80001d2e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d32:	692c                	ld	a1,80(a0)
    80001d34:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d36:	00005717          	auipc	a4,0x5
    80001d3a:	35a70713          	addi	a4,a4,858 # 80007090 <userret>
    80001d3e:	8f11                	sub	a4,a4,a2
    80001d40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d42:	577d                	li	a4,-1
    80001d44:	177e                	slli	a4,a4,0x3f
    80001d46:	8dd9                	or	a1,a1,a4
    80001d48:	02000537          	lui	a0,0x2000
    80001d4c:	157d                	addi	a0,a0,-1
    80001d4e:	0536                	slli	a0,a0,0xd
    80001d50:	9782                	jalr	a5
}
    80001d52:	60a2                	ld	ra,8(sp)
    80001d54:	6402                	ld	s0,0(sp)
    80001d56:	0141                	addi	sp,sp,16
    80001d58:	8082                	ret

0000000080001d5a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d5a:	1101                	addi	sp,sp,-32
    80001d5c:	ec06                	sd	ra,24(sp)
    80001d5e:	e822                	sd	s0,16(sp)
    80001d60:	e426                	sd	s1,8(sp)
    80001d62:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d64:	0000e497          	auipc	s1,0xe
    80001d68:	81c48493          	addi	s1,s1,-2020 # 8000f580 <tickslock>
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	00005097          	auipc	ra,0x5
    80001d72:	8f4080e7          	jalr	-1804(ra) # 80006662 <acquire>
  ticks++;
    80001d76:	00007517          	auipc	a0,0x7
    80001d7a:	2a250513          	addi	a0,a0,674 # 80009018 <ticks>
    80001d7e:	411c                	lw	a5,0(a0)
    80001d80:	2785                	addiw	a5,a5,1
    80001d82:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	9c4080e7          	jalr	-1596(ra) # 80001748 <wakeup>
  release(&tickslock);
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	00005097          	auipc	ra,0x5
    80001d92:	988080e7          	jalr	-1656(ra) # 80006716 <release>
}
    80001d96:	60e2                	ld	ra,24(sp)
    80001d98:	6442                	ld	s0,16(sp)
    80001d9a:	64a2                	ld	s1,8(sp)
    80001d9c:	6105                	addi	sp,sp,32
    80001d9e:	8082                	ret

0000000080001da0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001da0:	1101                	addi	sp,sp,-32
    80001da2:	ec06                	sd	ra,24(sp)
    80001da4:	e822                	sd	s0,16(sp)
    80001da6:	e426                	sd	s1,8(sp)
    80001da8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001daa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dae:	00074d63          	bltz	a4,80001dc8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001db2:	57fd                	li	a5,-1
    80001db4:	17fe                	slli	a5,a5,0x3f
    80001db6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001db8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dba:	06f70363          	beq	a4,a5,80001e20 <devintr+0x80>
  }
}
    80001dbe:	60e2                	ld	ra,24(sp)
    80001dc0:	6442                	ld	s0,16(sp)
    80001dc2:	64a2                	ld	s1,8(sp)
    80001dc4:	6105                	addi	sp,sp,32
    80001dc6:	8082                	ret
     (scause & 0xff) == 9){
    80001dc8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dcc:	46a5                	li	a3,9
    80001dce:	fed792e3          	bne	a5,a3,80001db2 <devintr+0x12>
    int irq = plic_claim();
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	856080e7          	jalr	-1962(ra) # 80005628 <plic_claim>
    80001dda:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ddc:	47a9                	li	a5,10
    80001dde:	02f50763          	beq	a0,a5,80001e0c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001de2:	4785                	li	a5,1
    80001de4:	02f50963          	beq	a0,a5,80001e16 <devintr+0x76>
    return 1;
    80001de8:	4505                	li	a0,1
    } else if(irq){
    80001dea:	d8f1                	beqz	s1,80001dbe <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dec:	85a6                	mv	a1,s1
    80001dee:	00006517          	auipc	a0,0x6
    80001df2:	46250513          	addi	a0,a0,1122 # 80008250 <states.1742+0x38>
    80001df6:	00004097          	auipc	ra,0x4
    80001dfa:	36c080e7          	jalr	876(ra) # 80006162 <printf>
      plic_complete(irq);
    80001dfe:	8526                	mv	a0,s1
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	84c080e7          	jalr	-1972(ra) # 8000564c <plic_complete>
    return 1;
    80001e08:	4505                	li	a0,1
    80001e0a:	bf55                	j	80001dbe <devintr+0x1e>
      uartintr();
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	776080e7          	jalr	1910(ra) # 80006582 <uartintr>
    80001e14:	b7ed                	j	80001dfe <devintr+0x5e>
      virtio_disk_intr();
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	d16080e7          	jalr	-746(ra) # 80005b2c <virtio_disk_intr>
    80001e1e:	b7c5                	j	80001dfe <devintr+0x5e>
    if(cpuid() == 0){
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	03a080e7          	jalr	58(ra) # 80000e5a <cpuid>
    80001e28:	c901                	beqz	a0,80001e38 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e2a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e2e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e30:	14479073          	csrw	sip,a5
    return 2;
    80001e34:	4509                	li	a0,2
    80001e36:	b761                	j	80001dbe <devintr+0x1e>
      clockintr();
    80001e38:	00000097          	auipc	ra,0x0
    80001e3c:	f22080e7          	jalr	-222(ra) # 80001d5a <clockintr>
    80001e40:	b7ed                	j	80001e2a <devintr+0x8a>

0000000080001e42 <usertrap>:
{
    80001e42:	1101                	addi	sp,sp,-32
    80001e44:	ec06                	sd	ra,24(sp)
    80001e46:	e822                	sd	s0,16(sp)
    80001e48:	e426                	sd	s1,8(sp)
    80001e4a:	e04a                	sd	s2,0(sp)
    80001e4c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e52:	1007f793          	andi	a5,a5,256
    80001e56:	e3ad                	bnez	a5,80001eb8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e58:	00003797          	auipc	a5,0x3
    80001e5c:	6c878793          	addi	a5,a5,1736 # 80005520 <kernelvec>
    80001e60:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	022080e7          	jalr	34(ra) # 80000e86 <myproc>
    80001e6c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e6e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e70:	14102773          	csrr	a4,sepc
    80001e74:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e76:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e7a:	47a1                	li	a5,8
    80001e7c:	04f71c63          	bne	a4,a5,80001ed4 <usertrap+0x92>
    if(p->killed)
    80001e80:	551c                	lw	a5,40(a0)
    80001e82:	e3b9                	bnez	a5,80001ec8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e84:	6cb8                	ld	a4,88(s1)
    80001e86:	6f1c                	ld	a5,24(a4)
    80001e88:	0791                	addi	a5,a5,4
    80001e8a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e94:	10079073          	csrw	sstatus,a5
    syscall();
    80001e98:	00000097          	auipc	ra,0x0
    80001e9c:	31e080e7          	jalr	798(ra) # 800021b6 <syscall>
  if(p->killed)
    80001ea0:	549c                	lw	a5,40(s1)
    80001ea2:	ebdd                	bnez	a5,80001f58 <usertrap+0x116>
  usertrapret();
    80001ea4:	00000097          	auipc	ra,0x0
    80001ea8:	e18080e7          	jalr	-488(ra) # 80001cbc <usertrapret>
}
    80001eac:	60e2                	ld	ra,24(sp)
    80001eae:	6442                	ld	s0,16(sp)
    80001eb0:	64a2                	ld	s1,8(sp)
    80001eb2:	6902                	ld	s2,0(sp)
    80001eb4:	6105                	addi	sp,sp,32
    80001eb6:	8082                	ret
    panic("usertrap: not from user mode");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	3b850513          	addi	a0,a0,952 # 80008270 <states.1742+0x58>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	258080e7          	jalr	600(ra) # 80006118 <panic>
      exit(-1);
    80001ec8:	557d                	li	a0,-1
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	94e080e7          	jalr	-1714(ra) # 80001818 <exit>
    80001ed2:	bf4d                	j	80001e84 <usertrap+0x42>
  }  else if((which_dev = devintr()) != 0){
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	ecc080e7          	jalr	-308(ra) # 80001da0 <devintr>
    80001edc:	892a                	mv	s2,a0
    80001ede:	e935                	bnez	a0,80001f52 <usertrap+0x110>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee0:	14202773          	csrr	a4,scause
  }else if((r_scause() == 13) || (r_scause() == 15)){ // page fault
    80001ee4:	47b5                	li	a5,13
    80001ee6:	00f70763          	beq	a4,a5,80001ef4 <usertrap+0xb2>
    80001eea:	14202773          	csrr	a4,scause
    80001eee:	47bd                	li	a5,15
    80001ef0:	02f71763          	bne	a4,a5,80001f1e <usertrap+0xdc>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef4:	14302573          	csrr	a0,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef8:	142025f3          	csrr	a1,scause
if (mmap_alloc(r_stval(), r_scause()) != 0)
    80001efc:	2581                	sext.w	a1,a1
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	c8a080e7          	jalr	-886(ra) # 80001b88 <mmap_alloc>
    80001f06:	dd49                	beqz	a0,80001ea0 <usertrap+0x5e>
printf("mmap: page fault\n");
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	38850513          	addi	a0,a0,904 # 80008290 <states.1742+0x78>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	252080e7          	jalr	594(ra) # 80006162 <printf>
p->killed = 1;
    80001f18:	4785                	li	a5,1
    80001f1a:	d49c                	sw	a5,40(s1)
    80001f1c:	a83d                	j	80001f5a <usertrap+0x118>
    80001f1e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f22:	5890                	lw	a2,48(s1)
    80001f24:	00006517          	auipc	a0,0x6
    80001f28:	38450513          	addi	a0,a0,900 # 800082a8 <states.1742+0x90>
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	236080e7          	jalr	566(ra) # 80006162 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f38:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	39c50513          	addi	a0,a0,924 # 800082d8 <states.1742+0xc0>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	21e080e7          	jalr	542(ra) # 80006162 <printf>
    p->killed = 1;
    80001f4c:	4785                	li	a5,1
    80001f4e:	d49c                	sw	a5,40(s1)
    80001f50:	a029                	j	80001f5a <usertrap+0x118>
  if(p->killed)
    80001f52:	549c                	lw	a5,40(s1)
    80001f54:	cb81                	beqz	a5,80001f64 <usertrap+0x122>
    80001f56:	a011                	j	80001f5a <usertrap+0x118>
    80001f58:	4901                	li	s2,0
    exit(-1);
    80001f5a:	557d                	li	a0,-1
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	8bc080e7          	jalr	-1860(ra) # 80001818 <exit>
  if(which_dev == 2)
    80001f64:	4789                	li	a5,2
    80001f66:	f2f91fe3          	bne	s2,a5,80001ea4 <usertrap+0x62>
    yield();
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	616080e7          	jalr	1558(ra) # 80001580 <yield>
    80001f72:	bf0d                	j	80001ea4 <usertrap+0x62>

0000000080001f74 <kerneltrap>:
{
    80001f74:	7179                	addi	sp,sp,-48
    80001f76:	f406                	sd	ra,40(sp)
    80001f78:	f022                	sd	s0,32(sp)
    80001f7a:	ec26                	sd	s1,24(sp)
    80001f7c:	e84a                	sd	s2,16(sp)
    80001f7e:	e44e                	sd	s3,8(sp)
    80001f80:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f82:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f86:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f8a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f8e:	1004f793          	andi	a5,s1,256
    80001f92:	cb85                	beqz	a5,80001fc2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f94:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f98:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f9a:	ef85                	bnez	a5,80001fd2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	e04080e7          	jalr	-508(ra) # 80001da0 <devintr>
    80001fa4:	cd1d                	beqz	a0,80001fe2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fa6:	4789                	li	a5,2
    80001fa8:	06f50a63          	beq	a0,a5,8000201c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fac:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb0:	10049073          	csrw	sstatus,s1
}
    80001fb4:	70a2                	ld	ra,40(sp)
    80001fb6:	7402                	ld	s0,32(sp)
    80001fb8:	64e2                	ld	s1,24(sp)
    80001fba:	6942                	ld	s2,16(sp)
    80001fbc:	69a2                	ld	s3,8(sp)
    80001fbe:	6145                	addi	sp,sp,48
    80001fc0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	33650513          	addi	a0,a0,822 # 800082f8 <states.1742+0xe0>
    80001fca:	00004097          	auipc	ra,0x4
    80001fce:	14e080e7          	jalr	334(ra) # 80006118 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fd2:	00006517          	auipc	a0,0x6
    80001fd6:	34e50513          	addi	a0,a0,846 # 80008320 <states.1742+0x108>
    80001fda:	00004097          	auipc	ra,0x4
    80001fde:	13e080e7          	jalr	318(ra) # 80006118 <panic>
    printf("scause %p\n", scause);
    80001fe2:	85ce                	mv	a1,s3
    80001fe4:	00006517          	auipc	a0,0x6
    80001fe8:	35c50513          	addi	a0,a0,860 # 80008340 <states.1742+0x128>
    80001fec:	00004097          	auipc	ra,0x4
    80001ff0:	176080e7          	jalr	374(ra) # 80006162 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ff4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ff8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ffc:	00006517          	auipc	a0,0x6
    80002000:	35450513          	addi	a0,a0,852 # 80008350 <states.1742+0x138>
    80002004:	00004097          	auipc	ra,0x4
    80002008:	15e080e7          	jalr	350(ra) # 80006162 <printf>
    panic("kerneltrap");
    8000200c:	00006517          	auipc	a0,0x6
    80002010:	35c50513          	addi	a0,a0,860 # 80008368 <states.1742+0x150>
    80002014:	00004097          	auipc	ra,0x4
    80002018:	104080e7          	jalr	260(ra) # 80006118 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	e6a080e7          	jalr	-406(ra) # 80000e86 <myproc>
    80002024:	d541                	beqz	a0,80001fac <kerneltrap+0x38>
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	e60080e7          	jalr	-416(ra) # 80000e86 <myproc>
    8000202e:	4d18                	lw	a4,24(a0)
    80002030:	4791                	li	a5,4
    80002032:	f6f71de3          	bne	a4,a5,80001fac <kerneltrap+0x38>
    yield();
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	54a080e7          	jalr	1354(ra) # 80001580 <yield>
    8000203e:	b7bd                	j	80001fac <kerneltrap+0x38>

0000000080002040 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	1000                	addi	s0,sp,32
    8000204a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	e3a080e7          	jalr	-454(ra) # 80000e86 <myproc>
  switch (n) {
    80002054:	4795                	li	a5,5
    80002056:	0497e163          	bltu	a5,s1,80002098 <argraw+0x58>
    8000205a:	048a                	slli	s1,s1,0x2
    8000205c:	00006717          	auipc	a4,0x6
    80002060:	34470713          	addi	a4,a4,836 # 800083a0 <states.1742+0x188>
    80002064:	94ba                	add	s1,s1,a4
    80002066:	409c                	lw	a5,0(s1)
    80002068:	97ba                	add	a5,a5,a4
    8000206a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000206c:	6d3c                	ld	a5,88(a0)
    8000206e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002070:	60e2                	ld	ra,24(sp)
    80002072:	6442                	ld	s0,16(sp)
    80002074:	64a2                	ld	s1,8(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret
    return p->trapframe->a1;
    8000207a:	6d3c                	ld	a5,88(a0)
    8000207c:	7fa8                	ld	a0,120(a5)
    8000207e:	bfcd                	j	80002070 <argraw+0x30>
    return p->trapframe->a2;
    80002080:	6d3c                	ld	a5,88(a0)
    80002082:	63c8                	ld	a0,128(a5)
    80002084:	b7f5                	j	80002070 <argraw+0x30>
    return p->trapframe->a3;
    80002086:	6d3c                	ld	a5,88(a0)
    80002088:	67c8                	ld	a0,136(a5)
    8000208a:	b7dd                	j	80002070 <argraw+0x30>
    return p->trapframe->a4;
    8000208c:	6d3c                	ld	a5,88(a0)
    8000208e:	6bc8                	ld	a0,144(a5)
    80002090:	b7c5                	j	80002070 <argraw+0x30>
    return p->trapframe->a5;
    80002092:	6d3c                	ld	a5,88(a0)
    80002094:	6fc8                	ld	a0,152(a5)
    80002096:	bfe9                	j	80002070 <argraw+0x30>
  panic("argraw");
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	2e050513          	addi	a0,a0,736 # 80008378 <states.1742+0x160>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	078080e7          	jalr	120(ra) # 80006118 <panic>

00000000800020a8 <fetchaddr>:
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	e426                	sd	s1,8(sp)
    800020b0:	e04a                	sd	s2,0(sp)
    800020b2:	1000                	addi	s0,sp,32
    800020b4:	84aa                	mv	s1,a0
    800020b6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	dce080e7          	jalr	-562(ra) # 80000e86 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020c0:	653c                	ld	a5,72(a0)
    800020c2:	02f4f863          	bgeu	s1,a5,800020f2 <fetchaddr+0x4a>
    800020c6:	00848713          	addi	a4,s1,8
    800020ca:	02e7e663          	bltu	a5,a4,800020f6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020ce:	46a1                	li	a3,8
    800020d0:	8626                	mv	a2,s1
    800020d2:	85ca                	mv	a1,s2
    800020d4:	6928                	ld	a0,80(a0)
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	a90080e7          	jalr	-1392(ra) # 80000b66 <copyin>
    800020de:	00a03533          	snez	a0,a0
    800020e2:	40a00533          	neg	a0,a0
}
    800020e6:	60e2                	ld	ra,24(sp)
    800020e8:	6442                	ld	s0,16(sp)
    800020ea:	64a2                	ld	s1,8(sp)
    800020ec:	6902                	ld	s2,0(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret
    return -1;
    800020f2:	557d                	li	a0,-1
    800020f4:	bfcd                	j	800020e6 <fetchaddr+0x3e>
    800020f6:	557d                	li	a0,-1
    800020f8:	b7fd                	j	800020e6 <fetchaddr+0x3e>

00000000800020fa <fetchstr>:
{
    800020fa:	7179                	addi	sp,sp,-48
    800020fc:	f406                	sd	ra,40(sp)
    800020fe:	f022                	sd	s0,32(sp)
    80002100:	ec26                	sd	s1,24(sp)
    80002102:	e84a                	sd	s2,16(sp)
    80002104:	e44e                	sd	s3,8(sp)
    80002106:	1800                	addi	s0,sp,48
    80002108:	892a                	mv	s2,a0
    8000210a:	84ae                	mv	s1,a1
    8000210c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	d78080e7          	jalr	-648(ra) # 80000e86 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002116:	86ce                	mv	a3,s3
    80002118:	864a                	mv	a2,s2
    8000211a:	85a6                	mv	a1,s1
    8000211c:	6928                	ld	a0,80(a0)
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	ad4080e7          	jalr	-1324(ra) # 80000bf2 <copyinstr>
  if(err < 0)
    80002126:	00054763          	bltz	a0,80002134 <fetchstr+0x3a>
  return strlen(buf);
    8000212a:	8526                	mv	a0,s1
    8000212c:	ffffe097          	auipc	ra,0xffffe
    80002130:	1d0080e7          	jalr	464(ra) # 800002fc <strlen>
}
    80002134:	70a2                	ld	ra,40(sp)
    80002136:	7402                	ld	s0,32(sp)
    80002138:	64e2                	ld	s1,24(sp)
    8000213a:	6942                	ld	s2,16(sp)
    8000213c:	69a2                	ld	s3,8(sp)
    8000213e:	6145                	addi	sp,sp,48
    80002140:	8082                	ret

0000000080002142 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	1000                	addi	s0,sp,32
    8000214c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	ef2080e7          	jalr	-270(ra) # 80002040 <argraw>
    80002156:	c088                	sw	a0,0(s1)
  return 0;
}
    80002158:	4501                	li	a0,0
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret

0000000080002164 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	e426                	sd	s1,8(sp)
    8000216c:	1000                	addi	s0,sp,32
    8000216e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002170:	00000097          	auipc	ra,0x0
    80002174:	ed0080e7          	jalr	-304(ra) # 80002040 <argraw>
    80002178:	e088                	sd	a0,0(s1)
  return 0;
}
    8000217a:	4501                	li	a0,0
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	64a2                	ld	s1,8(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	e426                	sd	s1,8(sp)
    8000218e:	e04a                	sd	s2,0(sp)
    80002190:	1000                	addi	s0,sp,32
    80002192:	84ae                	mv	s1,a1
    80002194:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	eaa080e7          	jalr	-342(ra) # 80002040 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000219e:	864a                	mv	a2,s2
    800021a0:	85a6                	mv	a1,s1
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	f58080e7          	jalr	-168(ra) # 800020fa <fetchstr>
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6902                	ld	s2,0(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <syscall>:
[SYS_munmap] sys_munmap,
};

void
syscall(void)
{
    800021b6:	1101                	addi	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	e426                	sd	s1,8(sp)
    800021be:	e04a                	sd	s2,0(sp)
    800021c0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	cc4080e7          	jalr	-828(ra) # 80000e86 <myproc>
    800021ca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021cc:	05853903          	ld	s2,88(a0)
    800021d0:	0a893783          	ld	a5,168(s2)
    800021d4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021d8:	37fd                	addiw	a5,a5,-1
    800021da:	4759                	li	a4,22
    800021dc:	00f76f63          	bltu	a4,a5,800021fa <syscall+0x44>
    800021e0:	00369713          	slli	a4,a3,0x3
    800021e4:	00006797          	auipc	a5,0x6
    800021e8:	1d478793          	addi	a5,a5,468 # 800083b8 <syscalls>
    800021ec:	97ba                	add	a5,a5,a4
    800021ee:	639c                	ld	a5,0(a5)
    800021f0:	c789                	beqz	a5,800021fa <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021f2:	9782                	jalr	a5
    800021f4:	06a93823          	sd	a0,112(s2)
    800021f8:	a839                	j	80002216 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021fa:	15848613          	addi	a2,s1,344
    800021fe:	588c                	lw	a1,48(s1)
    80002200:	00006517          	auipc	a0,0x6
    80002204:	18050513          	addi	a0,a0,384 # 80008380 <states.1742+0x168>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	f5a080e7          	jalr	-166(ra) # 80006162 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002210:	6cbc                	ld	a5,88(s1)
    80002212:	577d                	li	a4,-1
    80002214:	fbb8                	sd	a4,112(a5)
  }
}
    80002216:	60e2                	ld	ra,24(sp)
    80002218:	6442                	ld	s0,16(sp)
    8000221a:	64a2                	ld	s1,8(sp)
    8000221c:	6902                	ld	s2,0(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret

0000000080002222 <write_back>:
#include "file.h"

void write_back(struct vma *v, uint64 addr, int n)
{
// no need to writeback
if (!(v->perm & PTE_W) || (v->flags & MAP_PRIVATE))
    80002222:	511c                	lw	a5,32(a0)
    80002224:	8b91                	andi	a5,a5,4
    80002226:	cfe1                	beqz	a5,800022fe <write_back+0xdc>
{
    80002228:	715d                	addi	sp,sp,-80
    8000222a:	e486                	sd	ra,72(sp)
    8000222c:	e0a2                	sd	s0,64(sp)
    8000222e:	fc26                	sd	s1,56(sp)
    80002230:	f84a                	sd	s2,48(sp)
    80002232:	f44e                	sd	s3,40(sp)
    80002234:	f052                	sd	s4,32(sp)
    80002236:	ec56                	sd	s5,24(sp)
    80002238:	e85a                	sd	s6,16(sp)
    8000223a:	e45e                	sd	s7,8(sp)
    8000223c:	e062                	sd	s8,0(sp)
    8000223e:	0880                	addi	s0,sp,80
    80002240:	89aa                	mv	s3,a0
    80002242:	8aae                	mv	s5,a1
    80002244:	8b32                	mv	s6,a2
if (!(v->perm & PTE_W) || (v->flags & MAP_PRIVATE))
    80002246:	515c                	lw	a5,36(a0)
    80002248:	8b89                	andi	a5,a5,2
    8000224a:	0007891b          	sext.w	s2,a5
    8000224e:	efc1                	bnez	a5,800022e6 <write_back+0xc4>
return;
if ((addr % PGSIZE) != 0)
    80002250:	03459793          	slli	a5,a1,0x34
    80002254:	ef81                	bnez	a5,8000226c <write_back+0x4a>
panic("unmap: not aligned");
struct file *f = v->file;
    80002256:	02853a03          	ld	s4,40(a0)
int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
int i = 0;
while (i < n)
    8000225a:	08c05663          	blez	a2,800022e6 <write_back+0xc4>
int k = n - i;
if (k > max)
k = max;
begin_op();
ilock(f->ip);
int wcnt = writei(f->ip, 1, addr + i, v->off + v->start - addr + i, k);
    8000225e:	6b85                	lui	s7,0x1
    80002260:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80002264:	6c05                	lui	s8,0x1
    80002266:	c00c0c1b          	addiw	s8,s8,-1024
    8000226a:	a899                	j	800022c0 <write_back+0x9e>
panic("unmap: not aligned");
    8000226c:	00006517          	auipc	a0,0x6
    80002270:	20c50513          	addi	a0,a0,524 # 80008478 <syscalls+0xc0>
    80002274:	00004097          	auipc	ra,0x4
    80002278:	ea4080e7          	jalr	-348(ra) # 80006118 <panic>
int wcnt = writei(f->ip, 1, addr + i, v->off + v->start - addr + i, k);
    8000227c:	0189b683          	ld	a3,24(s3)
    80002280:	0009b783          	ld	a5,0(s3)
    80002284:	9ebd                	addw	a3,a3,a5
    80002286:	415686bb          	subw	a3,a3,s5
    8000228a:	2701                	sext.w	a4,a4
    8000228c:	012686bb          	addw	a3,a3,s2
    80002290:	01590633          	add	a2,s2,s5
    80002294:	4585                	li	a1,1
    80002296:	018a3503          	ld	a0,24(s4) # fffffffffffff018 <end+0xffffffff7ffd8dd8>
    8000229a:	00001097          	auipc	ra,0x1
    8000229e:	176080e7          	jalr	374(ra) # 80003410 <writei>
    800022a2:	84aa                	mv	s1,a0
iunlock(f->ip);
    800022a4:	018a3503          	ld	a0,24(s4)
    800022a8:	00001097          	auipc	ra,0x1
    800022ac:	e7e080e7          	jalr	-386(ra) # 80003126 <iunlock>
end_op();
    800022b0:	00002097          	auipc	ra,0x2
    800022b4:	806080e7          	jalr	-2042(ra) # 80003ab6 <end_op>
i += wcnt;
    800022b8:	0124893b          	addw	s2,s1,s2
while (i < n)
    800022bc:	03695563          	bge	s2,s6,800022e6 <write_back+0xc4>
int k = n - i;
    800022c0:	412b04bb          	subw	s1,s6,s2
begin_op();
    800022c4:	00001097          	auipc	ra,0x1
    800022c8:	772080e7          	jalr	1906(ra) # 80003a36 <begin_op>
ilock(f->ip);
    800022cc:	018a3503          	ld	a0,24(s4)
    800022d0:	00001097          	auipc	ra,0x1
    800022d4:	d94080e7          	jalr	-620(ra) # 80003064 <ilock>
int wcnt = writei(f->ip, 1, addr + i, v->off + v->start - addr + i, k);
    800022d8:	8726                	mv	a4,s1
    800022da:	0004879b          	sext.w	a5,s1
    800022de:	f8fbdfe3          	bge	s7,a5,8000227c <write_back+0x5a>
    800022e2:	8762                	mv	a4,s8
    800022e4:	bf61                	j	8000227c <write_back+0x5a>
}
}
    800022e6:	60a6                	ld	ra,72(sp)
    800022e8:	6406                	ld	s0,64(sp)
    800022ea:	74e2                	ld	s1,56(sp)
    800022ec:	7942                	ld	s2,48(sp)
    800022ee:	79a2                	ld	s3,40(sp)
    800022f0:	7a02                	ld	s4,32(sp)
    800022f2:	6ae2                	ld	s5,24(sp)
    800022f4:	6b42                	ld	s6,16(sp)
    800022f6:	6ba2                	ld	s7,8(sp)
    800022f8:	6c02                	ld	s8,0(sp)
    800022fa:	6161                	addi	sp,sp,80
    800022fc:	8082                	ret
    800022fe:	8082                	ret

0000000080002300 <sys_exit>:

uint64
sys_exit(void)
{
    80002300:	1101                	addi	sp,sp,-32
    80002302:	ec06                	sd	ra,24(sp)
    80002304:	e822                	sd	s0,16(sp)
    80002306:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002308:	fec40593          	addi	a1,s0,-20
    8000230c:	4501                	li	a0,0
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	e34080e7          	jalr	-460(ra) # 80002142 <argint>
    return -1;
    80002316:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002318:	00054963          	bltz	a0,8000232a <sys_exit+0x2a>
  exit(n);
    8000231c:	fec42503          	lw	a0,-20(s0)
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	4f8080e7          	jalr	1272(ra) # 80001818 <exit>
  return 0;  // not reached
    80002328:	4781                	li	a5,0
}
    8000232a:	853e                	mv	a0,a5
    8000232c:	60e2                	ld	ra,24(sp)
    8000232e:	6442                	ld	s0,16(sp)
    80002330:	6105                	addi	sp,sp,32
    80002332:	8082                	ret

0000000080002334 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002334:	1141                	addi	sp,sp,-16
    80002336:	e406                	sd	ra,8(sp)
    80002338:	e022                	sd	s0,0(sp)
    8000233a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	b4a080e7          	jalr	-1206(ra) # 80000e86 <myproc>
}
    80002344:	5908                	lw	a0,48(a0)
    80002346:	60a2                	ld	ra,8(sp)
    80002348:	6402                	ld	s0,0(sp)
    8000234a:	0141                	addi	sp,sp,16
    8000234c:	8082                	ret

000000008000234e <sys_fork>:

uint64
sys_fork(void)
{
    8000234e:	1141                	addi	sp,sp,-16
    80002350:	e406                	sd	ra,8(sp)
    80002352:	e022                	sd	s0,0(sp)
    80002354:	0800                	addi	s0,sp,16
  return fork();
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	f00080e7          	jalr	-256(ra) # 80001256 <fork>
}
    8000235e:	60a2                	ld	ra,8(sp)
    80002360:	6402                	ld	s0,0(sp)
    80002362:	0141                	addi	sp,sp,16
    80002364:	8082                	ret

0000000080002366 <sys_wait>:

uint64
sys_wait(void)
{
    80002366:	1101                	addi	sp,sp,-32
    80002368:	ec06                	sd	ra,24(sp)
    8000236a:	e822                	sd	s0,16(sp)
    8000236c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000236e:	fe840593          	addi	a1,s0,-24
    80002372:	4501                	li	a0,0
    80002374:	00000097          	auipc	ra,0x0
    80002378:	df0080e7          	jalr	-528(ra) # 80002164 <argaddr>
    8000237c:	87aa                	mv	a5,a0
    return -1;
    8000237e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002380:	0007c863          	bltz	a5,80002390 <sys_wait+0x2a>
  return wait(p);
    80002384:	fe843503          	ld	a0,-24(s0)
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	298080e7          	jalr	664(ra) # 80001620 <wait>
}
    80002390:	60e2                	ld	ra,24(sp)
    80002392:	6442                	ld	s0,16(sp)
    80002394:	6105                	addi	sp,sp,32
    80002396:	8082                	ret

0000000080002398 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002398:	7179                	addi	sp,sp,-48
    8000239a:	f406                	sd	ra,40(sp)
    8000239c:	f022                	sd	s0,32(sp)
    8000239e:	ec26                	sd	s1,24(sp)
    800023a0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023a2:	fdc40593          	addi	a1,s0,-36
    800023a6:	4501                	li	a0,0
    800023a8:	00000097          	auipc	ra,0x0
    800023ac:	d9a080e7          	jalr	-614(ra) # 80002142 <argint>
    800023b0:	87aa                	mv	a5,a0
    return -1;
    800023b2:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800023b4:	0207c063          	bltz	a5,800023d4 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	ace080e7          	jalr	-1330(ra) # 80000e86 <myproc>
    800023c0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023c2:	fdc42503          	lw	a0,-36(s0)
    800023c6:	fffff097          	auipc	ra,0xfffff
    800023ca:	e1c080e7          	jalr	-484(ra) # 800011e2 <growproc>
    800023ce:	00054863          	bltz	a0,800023de <sys_sbrk+0x46>
    return -1;
  return addr;
    800023d2:	8526                	mv	a0,s1
}
    800023d4:	70a2                	ld	ra,40(sp)
    800023d6:	7402                	ld	s0,32(sp)
    800023d8:	64e2                	ld	s1,24(sp)
    800023da:	6145                	addi	sp,sp,48
    800023dc:	8082                	ret
    return -1;
    800023de:	557d                	li	a0,-1
    800023e0:	bfd5                	j	800023d4 <sys_sbrk+0x3c>

00000000800023e2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800023e2:	7139                	addi	sp,sp,-64
    800023e4:	fc06                	sd	ra,56(sp)
    800023e6:	f822                	sd	s0,48(sp)
    800023e8:	f426                	sd	s1,40(sp)
    800023ea:	f04a                	sd	s2,32(sp)
    800023ec:	ec4e                	sd	s3,24(sp)
    800023ee:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023f0:	fcc40593          	addi	a1,s0,-52
    800023f4:	4501                	li	a0,0
    800023f6:	00000097          	auipc	ra,0x0
    800023fa:	d4c080e7          	jalr	-692(ra) # 80002142 <argint>
    return -1;
    800023fe:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002400:	06054563          	bltz	a0,8000246a <sys_sleep+0x88>
  acquire(&tickslock);
    80002404:	0000d517          	auipc	a0,0xd
    80002408:	17c50513          	addi	a0,a0,380 # 8000f580 <tickslock>
    8000240c:	00004097          	auipc	ra,0x4
    80002410:	256080e7          	jalr	598(ra) # 80006662 <acquire>
  ticks0 = ticks;
    80002414:	00007917          	auipc	s2,0x7
    80002418:	c0492903          	lw	s2,-1020(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000241c:	fcc42783          	lw	a5,-52(s0)
    80002420:	cf85                	beqz	a5,80002458 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002422:	0000d997          	auipc	s3,0xd
    80002426:	15e98993          	addi	s3,s3,350 # 8000f580 <tickslock>
    8000242a:	00007497          	auipc	s1,0x7
    8000242e:	bee48493          	addi	s1,s1,-1042 # 80009018 <ticks>
    if(myproc()->killed){
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	a54080e7          	jalr	-1452(ra) # 80000e86 <myproc>
    8000243a:	551c                	lw	a5,40(a0)
    8000243c:	ef9d                	bnez	a5,8000247a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000243e:	85ce                	mv	a1,s3
    80002440:	8526                	mv	a0,s1
    80002442:	fffff097          	auipc	ra,0xfffff
    80002446:	17a080e7          	jalr	378(ra) # 800015bc <sleep>
  while(ticks - ticks0 < n){
    8000244a:	409c                	lw	a5,0(s1)
    8000244c:	412787bb          	subw	a5,a5,s2
    80002450:	fcc42703          	lw	a4,-52(s0)
    80002454:	fce7efe3          	bltu	a5,a4,80002432 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002458:	0000d517          	auipc	a0,0xd
    8000245c:	12850513          	addi	a0,a0,296 # 8000f580 <tickslock>
    80002460:	00004097          	auipc	ra,0x4
    80002464:	2b6080e7          	jalr	694(ra) # 80006716 <release>
  return 0;
    80002468:	4781                	li	a5,0
}
    8000246a:	853e                	mv	a0,a5
    8000246c:	70e2                	ld	ra,56(sp)
    8000246e:	7442                	ld	s0,48(sp)
    80002470:	74a2                	ld	s1,40(sp)
    80002472:	7902                	ld	s2,32(sp)
    80002474:	69e2                	ld	s3,24(sp)
    80002476:	6121                	addi	sp,sp,64
    80002478:	8082                	ret
      release(&tickslock);
    8000247a:	0000d517          	auipc	a0,0xd
    8000247e:	10650513          	addi	a0,a0,262 # 8000f580 <tickslock>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	294080e7          	jalr	660(ra) # 80006716 <release>
      return -1;
    8000248a:	57fd                	li	a5,-1
    8000248c:	bff9                	j	8000246a <sys_sleep+0x88>

000000008000248e <sys_kill>:

uint64
sys_kill(void)
{
    8000248e:	1101                	addi	sp,sp,-32
    80002490:	ec06                	sd	ra,24(sp)
    80002492:	e822                	sd	s0,16(sp)
    80002494:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002496:	fec40593          	addi	a1,s0,-20
    8000249a:	4501                	li	a0,0
    8000249c:	00000097          	auipc	ra,0x0
    800024a0:	ca6080e7          	jalr	-858(ra) # 80002142 <argint>
    800024a4:	87aa                	mv	a5,a0
    return -1;
    800024a6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024a8:	0007c863          	bltz	a5,800024b8 <sys_kill+0x2a>
  return kill(pid);
    800024ac:	fec42503          	lw	a0,-20(s0)
    800024b0:	fffff097          	auipc	ra,0xfffff
    800024b4:	4a2080e7          	jalr	1186(ra) # 80001952 <kill>
}
    800024b8:	60e2                	ld	ra,24(sp)
    800024ba:	6442                	ld	s0,16(sp)
    800024bc:	6105                	addi	sp,sp,32
    800024be:	8082                	ret

00000000800024c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024c0:	1101                	addi	sp,sp,-32
    800024c2:	ec06                	sd	ra,24(sp)
    800024c4:	e822                	sd	s0,16(sp)
    800024c6:	e426                	sd	s1,8(sp)
    800024c8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024ca:	0000d517          	auipc	a0,0xd
    800024ce:	0b650513          	addi	a0,a0,182 # 8000f580 <tickslock>
    800024d2:	00004097          	auipc	ra,0x4
    800024d6:	190080e7          	jalr	400(ra) # 80006662 <acquire>
  xticks = ticks;
    800024da:	00007497          	auipc	s1,0x7
    800024de:	b3e4a483          	lw	s1,-1218(s1) # 80009018 <ticks>
  release(&tickslock);
    800024e2:	0000d517          	auipc	a0,0xd
    800024e6:	09e50513          	addi	a0,a0,158 # 8000f580 <tickslock>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	22c080e7          	jalr	556(ra) # 80006716 <release>
  return xticks;
}
    800024f2:	02049513          	slli	a0,s1,0x20
    800024f6:	9101                	srli	a0,a0,0x20
    800024f8:	60e2                	ld	ra,24(sp)
    800024fa:	6442                	ld	s0,16(sp)
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret

0000000080002502 <sys_mmap>:

extern struct vma *vma_alloc();
void *sys_mmap(void)
{
    80002502:	715d                	addi	sp,sp,-80
    80002504:	e486                	sd	ra,72(sp)
    80002506:	e0a2                	sd	s0,64(sp)
    80002508:	fc26                	sd	s1,56(sp)
    8000250a:	f84a                	sd	s2,48(sp)
    8000250c:	f44e                	sd	s3,40(sp)
    8000250e:	f052                	sd	s4,32(sp)
    80002510:	0880                	addi	s0,sp,80
uint64 addr;
struct proc *p = myproc();
    80002512:	fffff097          	auipc	ra,0xfffff
    80002516:	974080e7          	jalr	-1676(ra) # 80000e86 <myproc>
    8000251a:	84aa                	mv	s1,a0
int length, prot, flags, fd, offset;
if (argaddr(0, &addr) < 0)
    8000251c:	fc840593          	addi	a1,s0,-56
    80002520:	4501                	li	a0,0
    80002522:	00000097          	auipc	ra,0x0
    80002526:	c42080e7          	jalr	-958(ra) # 80002164 <argaddr>
return (void *)-1;
    8000252a:	57fd                	li	a5,-1
if (argaddr(0, &addr) < 0)
    8000252c:	14054263          	bltz	a0,80002670 <sys_mmap+0x16e>
if (argint(1, &length) < 0)
    80002530:	fc440593          	addi	a1,s0,-60
    80002534:	4505                	li	a0,1
    80002536:	00000097          	auipc	ra,0x0
    8000253a:	c0c080e7          	jalr	-1012(ra) # 80002142 <argint>
return (void *)-1;
    8000253e:	57fd                	li	a5,-1
if (argint(1, &length) < 0)
    80002540:	12054863          	bltz	a0,80002670 <sys_mmap+0x16e>
if (argint(2, &prot) < 0)
    80002544:	fc040593          	addi	a1,s0,-64
    80002548:	4509                	li	a0,2
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	bf8080e7          	jalr	-1032(ra) # 80002142 <argint>
return (void *)-1;
    80002552:	57fd                	li	a5,-1
if (argint(2, &prot) < 0)
    80002554:	10054e63          	bltz	a0,80002670 <sys_mmap+0x16e>
if (argint(3, &flags) < 0)
    80002558:	fbc40593          	addi	a1,s0,-68
    8000255c:	450d                	li	a0,3
    8000255e:	00000097          	auipc	ra,0x0
    80002562:	be4080e7          	jalr	-1052(ra) # 80002142 <argint>
return (void *)-1;
    80002566:	57fd                	li	a5,-1
if (argint(3, &flags) < 0)
    80002568:	10054463          	bltz	a0,80002670 <sys_mmap+0x16e>
if (argint(4, &fd) < 0)
    8000256c:	fb840593          	addi	a1,s0,-72
    80002570:	4511                	li	a0,4
    80002572:	00000097          	auipc	ra,0x0
    80002576:	bd0080e7          	jalr	-1072(ra) # 80002142 <argint>
return (void *)-1;
    8000257a:	57fd                	li	a5,-1
if (argint(4, &fd) < 0)
    8000257c:	0e054a63          	bltz	a0,80002670 <sys_mmap+0x16e>
if (argint(5, &offset) < 0)
    80002580:	fb440593          	addi	a1,s0,-76
    80002584:	4515                	li	a0,5
    80002586:	00000097          	auipc	ra,0x0
    8000258a:	bbc080e7          	jalr	-1092(ra) # 80002142 <argint>
return (void *)-1;
    8000258e:	57fd                	li	a5,-1
if (argint(5, &offset) < 0)
    80002590:	0e054063          	bltz	a0,80002670 <sys_mmap+0x16e>
if (addr != 0)
    80002594:	fc843783          	ld	a5,-56(s0)
    80002598:	c399                	beqz	a5,8000259e <sys_mmap+0x9c>
addr = 0;
    8000259a:	fc043423          	sd	zero,-56(s0)
if (offset != 0)
    8000259e:	fb442783          	lw	a5,-76(s0)
    800025a2:	c399                	beqz	a5,800025a8 <sys_mmap+0xa6>
offset = 0;
    800025a4:	fa042a23          	sw	zero,-76(s0)
struct file *f = p->ofile[fd];
    800025a8:	fb842783          	lw	a5,-72(s0)
    800025ac:	07e9                	addi	a5,a5,26
    800025ae:	078e                	slli	a5,a5,0x3
    800025b0:	97a6                	add	a5,a5,s1
    800025b2:	0007b983          	ld	s3,0(a5)
// Check flags
int pte_flag = PTE_U;
if (prot & PROT_READ)
    800025b6:	fc042703          	lw	a4,-64(s0)
    800025ba:	00177793          	andi	a5,a4,1
    800025be:	c799                	beqz	a5,800025cc <sys_mmap+0xca>
{
if (!f->readable)
    800025c0:	0089c683          	lbu	a3,8(s3)
return (void *)-1;
    800025c4:	57fd                	li	a5,-1
pte_flag |= PTE_R;
    800025c6:	4a49                	li	s4,18
if (!f->readable)
    800025c8:	e299                	bnez	a3,800025ce <sys_mmap+0xcc>
    800025ca:	a05d                	j	80002670 <sys_mmap+0x16e>
int pte_flag = PTE_U;
    800025cc:	4a41                	li	s4,16
}
if (prot & PROT_WRITE)
    800025ce:	8b09                	andi	a4,a4,2
    800025d0:	cb19                	beqz	a4,800025e6 <sys_mmap+0xe4>
{
if (!f->writable && !(flags & MAP_PRIVATE))
    800025d2:	0099c783          	lbu	a5,9(s3)
    800025d6:	e791                	bnez	a5,800025e2 <sys_mmap+0xe0>
    800025d8:	fbc42703          	lw	a4,-68(s0)
    800025dc:	8b09                	andi	a4,a4,2
return (void *)-1;
    800025de:	57fd                	li	a5,-1
if (!f->writable && !(flags & MAP_PRIVATE))
    800025e0:	cb41                	beqz	a4,80002670 <sys_mmap+0x16e>
pte_flag |= PTE_W;
    800025e2:	004a6a13          	ori	s4,s4,4
}
// Setting up vma
struct vma *v = vma_alloc();
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	6c0080e7          	jalr	1728(ra) # 80000ca6 <vma_alloc>
    800025ee:	892a                	mv	s2,a0
v->perm = pte_flag;
    800025f0:	03452023          	sw	s4,32(a0)
v->length = length;
    800025f4:	fc442783          	lw	a5,-60(s0)
    800025f8:	e91c                	sd	a5,16(a0)
v->off = offset;
    800025fa:	fb442783          	lw	a5,-76(s0)
    800025fe:	ed1c                	sd	a5,24(a0)
v->file = myproc()->ofile[fd];
    80002600:	fffff097          	auipc	ra,0xfffff
    80002604:	886080e7          	jalr	-1914(ra) # 80000e86 <myproc>
    80002608:	fb842783          	lw	a5,-72(s0)
    8000260c:	07e9                	addi	a5,a5,26
    8000260e:	078e                	slli	a5,a5,0x3
    80002610:	97aa                	add	a5,a5,a0
    80002612:	639c                	ld	a5,0(a5)
    80002614:	02f93423          	sd	a5,40(s2)
v->flags = flags;
    80002618:	fbc42783          	lw	a5,-68(s0)
    8000261c:	02f92223          	sw	a5,36(s2)
filedup(f);
    80002620:	854e                	mv	a0,s3
    80002622:	00002097          	auipc	ra,0x2
    80002626:	88e080e7          	jalr	-1906(ra) # 80003eb0 <filedup>
struct vma *pv = p->vma;
    8000262a:	1684b783          	ld	a5,360(s1)
if (pv == 0)
    8000262e:	cbb1                	beqz	a5,80002682 <sys_mmap+0x180>
v->end = length + v->start;
p->vma = v;
}
else
{
while (pv->next)
    80002630:	873e                	mv	a4,a5
    80002632:	7b9c                	ld	a5,48(a5)
    80002634:	fff5                	bnez	a5,80002630 <sys_mmap+0x12e>
pv = pv->next;
v->start = PGROUNDUP(pv->end);
    80002636:	671c                	ld	a5,8(a4)
    80002638:	6685                	lui	a3,0x1
    8000263a:	16fd                	addi	a3,a3,-1
    8000263c:	97b6                	add	a5,a5,a3
    8000263e:	76fd                	lui	a3,0xfffff
    80002640:	8ff5                	and	a5,a5,a3
    80002642:	00f93023          	sd	a5,0(s2)
v->end = v->start + length;
    80002646:	fc442683          	lw	a3,-60(s0)
    8000264a:	97b6                	add	a5,a5,a3
    8000264c:	00f93423          	sd	a5,8(s2)
pv->next = v;
    80002650:	03273823          	sd	s2,48(a4)
v->next = 0;
    80002654:	02093823          	sd	zero,48(s2)
}
addr = v->start;
    80002658:	00093783          	ld	a5,0(s2)
    8000265c:	fcf43423          	sd	a5,-56(s0)
release(&v->lock);
    80002660:	03890513          	addi	a0,s2,56
    80002664:	00004097          	auipc	ra,0x4
    80002668:	0b2080e7          	jalr	178(ra) # 80006716 <release>
return (void *)(addr);
    8000266c:	fc843783          	ld	a5,-56(s0)
}
    80002670:	853e                	mv	a0,a5
    80002672:	60a6                	ld	ra,72(sp)
    80002674:	6406                	ld	s0,64(sp)
    80002676:	74e2                	ld	s1,56(sp)
    80002678:	7942                	ld	s2,48(sp)
    8000267a:	79a2                	ld	s3,40(sp)
    8000267c:	7a02                	ld	s4,32(sp)
    8000267e:	6161                	addi	sp,sp,80
    80002680:	8082                	ret
v->start = VMA_START;
    80002682:	4785                	li	a5,1
    80002684:	1796                	slli	a5,a5,0x25
    80002686:	00f93023          	sd	a5,0(s2)
v->end = length + v->start;
    8000268a:	fc442703          	lw	a4,-60(s0)
    8000268e:	97ba                	add	a5,a5,a4
    80002690:	00f93423          	sd	a5,8(s2)
p->vma = v;
    80002694:	1724b423          	sd	s2,360(s1)
    80002698:	b7c1                	j	80002658 <sys_mmap+0x156>

000000008000269a <sys_munmap>:

int sys_munmap(void)
{
    8000269a:	7139                	addi	sp,sp,-64
    8000269c:	fc06                	sd	ra,56(sp)
    8000269e:	f822                	sd	s0,48(sp)
    800026a0:	f426                	sd	s1,40(sp)
    800026a2:	f04a                	sd	s2,32(sp)
    800026a4:	ec4e                	sd	s3,24(sp)
    800026a6:	0080                	addi	s0,sp,64
uint64 addr;
int length;
if (argaddr(0, &addr) < 0)
    800026a8:	fc840593          	addi	a1,s0,-56
    800026ac:	4501                	li	a0,0
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	ab6080e7          	jalr	-1354(ra) # 80002164 <argaddr>
    800026b6:	10054963          	bltz	a0,800027c8 <sys_munmap+0x12e>
return -1;
if (argint(1, &length) < 0)
    800026ba:	fc440593          	addi	a1,s0,-60
    800026be:	4505                	li	a0,1
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	a82080e7          	jalr	-1406(ra) # 80002142 <argint>
    800026c8:	10054263          	bltz	a0,800027cc <sys_munmap+0x132>
return -1;
struct proc *p = myproc();
    800026cc:	ffffe097          	auipc	ra,0xffffe
    800026d0:	7ba080e7          	jalr	1978(ra) # 80000e86 <myproc>
    800026d4:	89aa                	mv	s3,a0
struct vma *v = p->vma;
    800026d6:	16853483          	ld	s1,360(a0)
struct vma *pre = 0;
while (v != 0)
    800026da:	c8fd                	beqz	s1,800027d0 <sys_munmap+0x136>
{
if (addr >= v->start && addr < v->end)
    800026dc:	fc843583          	ld	a1,-56(s0)
struct vma *pre = 0;
    800026e0:	4901                	li	s2,0
    800026e2:	a029                	j	800026ec <sys_munmap+0x52>
break;
pre = v;
v = v->next;
    800026e4:	789c                	ld	a5,48(s1)
while (v != 0)
    800026e6:	8926                	mv	s2,s1
    800026e8:	cf85                	beqz	a5,80002720 <sys_munmap+0x86>
v = v->next;
    800026ea:	84be                	mv	s1,a5
if (addr >= v->start && addr < v->end)
    800026ec:	609c                	ld	a5,0(s1)
    800026ee:	fef5ebe3          	bltu	a1,a5,800026e4 <sys_munmap+0x4a>
    800026f2:	6498                	ld	a4,8(s1)
    800026f4:	fee5f8e3          	bgeu	a1,a4,800026e4 <sys_munmap+0x4a>
}
// not mapped
if (v == 0)
return -1;
if (addr != v->start && addr + length != v->end)
    800026f8:	02b78e63          	beq	a5,a1,80002734 <sys_munmap+0x9a>
    800026fc:	fc442683          	lw	a3,-60(s0)
    80002700:	95b6                	add	a1,a1,a3
    80002702:	02b71163          	bne	a4,a1,80002724 <sys_munmap+0x8a>
}
}
else
{
// tail
v->length -= length;
    80002706:	689c                	ld	a5,16(s1)
    80002708:	8f95                	sub	a5,a5,a3
    8000270a:	e89c                	sd	a5,16(s1)
v->end -= length;
    8000270c:	8f15                	sub	a4,a4,a3
    8000270e:	e498                	sd	a4,8(s1)
}
return 0;
    80002710:	4501                	li	a0,0
}
    80002712:	70e2                	ld	ra,56(sp)
    80002714:	7442                	ld	s0,48(sp)
    80002716:	74a2                	ld	s1,40(sp)
    80002718:	7902                	ld	s2,32(sp)
    8000271a:	69e2                	ld	s3,24(sp)
    8000271c:	6121                	addi	sp,sp,64
    8000271e:	8082                	ret
return -1;
    80002720:	557d                	li	a0,-1
    80002722:	bfc5                	j	80002712 <sys_munmap+0x78>
panic("munmap: middle of vma");
    80002724:	00006517          	auipc	a0,0x6
    80002728:	d6c50513          	addi	a0,a0,-660 # 80008490 <syscalls+0xd8>
    8000272c:	00004097          	auipc	ra,0x4
    80002730:	9ec080e7          	jalr	-1556(ra) # 80006118 <panic>
write_back(v, addr, length);
    80002734:	fc442603          	lw	a2,-60(s0)
    80002738:	8526                	mv	a0,s1
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	ae8080e7          	jalr	-1304(ra) # 80002222 <write_back>
uvmunmap(p->pagetable, addr, length / PGSIZE, 1);
    80002742:	fc442783          	lw	a5,-60(s0)
    80002746:	41f7d61b          	sraiw	a2,a5,0x1f
    8000274a:	0146561b          	srliw	a2,a2,0x14
    8000274e:	9e3d                	addw	a2,a2,a5
    80002750:	4685                	li	a3,1
    80002752:	40c6561b          	sraiw	a2,a2,0xc
    80002756:	fc843583          	ld	a1,-56(s0)
    8000275a:	0509b503          	ld	a0,80(s3)
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	fb0080e7          	jalr	-80(ra) # 8000070e <uvmunmap>
if (length == v->length)
    80002766:	fc442683          	lw	a3,-60(s0)
    8000276a:	689c                	ld	a5,16(s1)
    8000276c:	00f68e63          	beq	a3,a5,80002788 <sys_munmap+0xee>
v->start -= length;
    80002770:	6098                	ld	a4,0(s1)
    80002772:	8f15                	sub	a4,a4,a3
    80002774:	e098                	sd	a4,0(s1)
v->off += length;
    80002776:	fc442683          	lw	a3,-60(s0)
    8000277a:	6c98                	ld	a4,24(s1)
    8000277c:	9736                	add	a4,a4,a3
    8000277e:	ec98                	sd	a4,24(s1)
v->length -= length;
    80002780:	8f95                	sub	a5,a5,a3
    80002782:	e89c                	sd	a5,16(s1)
return 0;
    80002784:	4501                	li	a0,0
    80002786:	b771                	j	80002712 <sys_munmap+0x78>
fileclose(v->file);
    80002788:	7488                	ld	a0,40(s1)
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	778080e7          	jalr	1912(ra) # 80003f02 <fileclose>
if (pre == 0)
    80002792:	02090763          	beqz	s2,800027c0 <sys_munmap+0x126>
pre->next = v->next;
    80002796:	789c                	ld	a5,48(s1)
    80002798:	02f93823          	sd	a5,48(s2)
v->next = 0;
    8000279c:	0204b823          	sd	zero,48(s1)
acquire(&v->lock);
    800027a0:	03848913          	addi	s2,s1,56
    800027a4:	854a                	mv	a0,s2
    800027a6:	00004097          	auipc	ra,0x4
    800027aa:	ebc080e7          	jalr	-324(ra) # 80006662 <acquire>
v->length = 0;
    800027ae:	0004b823          	sd	zero,16(s1)
release(&v->lock);
    800027b2:	854a                	mv	a0,s2
    800027b4:	00004097          	auipc	ra,0x4
    800027b8:	f62080e7          	jalr	-158(ra) # 80006716 <release>
return 0;
    800027bc:	4501                	li	a0,0
    800027be:	bf91                	j	80002712 <sys_munmap+0x78>
p->vma = v->next;
    800027c0:	789c                	ld	a5,48(s1)
    800027c2:	16f9b423          	sd	a5,360(s3)
    800027c6:	bfe9                	j	800027a0 <sys_munmap+0x106>
return -1;
    800027c8:	557d                	li	a0,-1
    800027ca:	b7a1                	j	80002712 <sys_munmap+0x78>
return -1;
    800027cc:	557d                	li	a0,-1
    800027ce:	b791                	j	80002712 <sys_munmap+0x78>
return -1;
    800027d0:	557d                	li	a0,-1
    800027d2:	b781                	j	80002712 <sys_munmap+0x78>

00000000800027d4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800027d4:	7179                	addi	sp,sp,-48
    800027d6:	f406                	sd	ra,40(sp)
    800027d8:	f022                	sd	s0,32(sp)
    800027da:	ec26                	sd	s1,24(sp)
    800027dc:	e84a                	sd	s2,16(sp)
    800027de:	e44e                	sd	s3,8(sp)
    800027e0:	e052                	sd	s4,0(sp)
    800027e2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800027e4:	00006597          	auipc	a1,0x6
    800027e8:	cc458593          	addi	a1,a1,-828 # 800084a8 <syscalls+0xf0>
    800027ec:	0000d517          	auipc	a0,0xd
    800027f0:	dac50513          	addi	a0,a0,-596 # 8000f598 <bcache>
    800027f4:	00004097          	auipc	ra,0x4
    800027f8:	dde080e7          	jalr	-546(ra) # 800065d2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800027fc:	00015797          	auipc	a5,0x15
    80002800:	d9c78793          	addi	a5,a5,-612 # 80017598 <bcache+0x8000>
    80002804:	00015717          	auipc	a4,0x15
    80002808:	ffc70713          	addi	a4,a4,-4 # 80017800 <bcache+0x8268>
    8000280c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002810:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002814:	0000d497          	auipc	s1,0xd
    80002818:	d9c48493          	addi	s1,s1,-612 # 8000f5b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000281c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000281e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002820:	00006a17          	auipc	s4,0x6
    80002824:	c90a0a13          	addi	s4,s4,-880 # 800084b0 <syscalls+0xf8>
    b->next = bcache.head.next;
    80002828:	2b893783          	ld	a5,696(s2)
    8000282c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000282e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002832:	85d2                	mv	a1,s4
    80002834:	01048513          	addi	a0,s1,16
    80002838:	00001097          	auipc	ra,0x1
    8000283c:	4bc080e7          	jalr	1212(ra) # 80003cf4 <initsleeplock>
    bcache.head.next->prev = b;
    80002840:	2b893783          	ld	a5,696(s2)
    80002844:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002846:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000284a:	45848493          	addi	s1,s1,1112
    8000284e:	fd349de3          	bne	s1,s3,80002828 <binit+0x54>
  }
}
    80002852:	70a2                	ld	ra,40(sp)
    80002854:	7402                	ld	s0,32(sp)
    80002856:	64e2                	ld	s1,24(sp)
    80002858:	6942                	ld	s2,16(sp)
    8000285a:	69a2                	ld	s3,8(sp)
    8000285c:	6a02                	ld	s4,0(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret

0000000080002862 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	1800                	addi	s0,sp,48
    80002870:	89aa                	mv	s3,a0
    80002872:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002874:	0000d517          	auipc	a0,0xd
    80002878:	d2450513          	addi	a0,a0,-732 # 8000f598 <bcache>
    8000287c:	00004097          	auipc	ra,0x4
    80002880:	de6080e7          	jalr	-538(ra) # 80006662 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002884:	00015497          	auipc	s1,0x15
    80002888:	fcc4b483          	ld	s1,-52(s1) # 80017850 <bcache+0x82b8>
    8000288c:	00015797          	auipc	a5,0x15
    80002890:	f7478793          	addi	a5,a5,-140 # 80017800 <bcache+0x8268>
    80002894:	02f48f63          	beq	s1,a5,800028d2 <bread+0x70>
    80002898:	873e                	mv	a4,a5
    8000289a:	a021                	j	800028a2 <bread+0x40>
    8000289c:	68a4                	ld	s1,80(s1)
    8000289e:	02e48a63          	beq	s1,a4,800028d2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800028a2:	449c                	lw	a5,8(s1)
    800028a4:	ff379ce3          	bne	a5,s3,8000289c <bread+0x3a>
    800028a8:	44dc                	lw	a5,12(s1)
    800028aa:	ff2799e3          	bne	a5,s2,8000289c <bread+0x3a>
      b->refcnt++;
    800028ae:	40bc                	lw	a5,64(s1)
    800028b0:	2785                	addiw	a5,a5,1
    800028b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800028b4:	0000d517          	auipc	a0,0xd
    800028b8:	ce450513          	addi	a0,a0,-796 # 8000f598 <bcache>
    800028bc:	00004097          	auipc	ra,0x4
    800028c0:	e5a080e7          	jalr	-422(ra) # 80006716 <release>
      acquiresleep(&b->lock);
    800028c4:	01048513          	addi	a0,s1,16
    800028c8:	00001097          	auipc	ra,0x1
    800028cc:	466080e7          	jalr	1126(ra) # 80003d2e <acquiresleep>
      return b;
    800028d0:	a8b9                	j	8000292e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800028d2:	00015497          	auipc	s1,0x15
    800028d6:	f764b483          	ld	s1,-138(s1) # 80017848 <bcache+0x82b0>
    800028da:	00015797          	auipc	a5,0x15
    800028de:	f2678793          	addi	a5,a5,-218 # 80017800 <bcache+0x8268>
    800028e2:	00f48863          	beq	s1,a5,800028f2 <bread+0x90>
    800028e6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800028e8:	40bc                	lw	a5,64(s1)
    800028ea:	cf81                	beqz	a5,80002902 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800028ec:	64a4                	ld	s1,72(s1)
    800028ee:	fee49de3          	bne	s1,a4,800028e8 <bread+0x86>
  panic("bget: no buffers");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	bc650513          	addi	a0,a0,-1082 # 800084b8 <syscalls+0x100>
    800028fa:	00004097          	auipc	ra,0x4
    800028fe:	81e080e7          	jalr	-2018(ra) # 80006118 <panic>
      b->dev = dev;
    80002902:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002906:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000290a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000290e:	4785                	li	a5,1
    80002910:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002912:	0000d517          	auipc	a0,0xd
    80002916:	c8650513          	addi	a0,a0,-890 # 8000f598 <bcache>
    8000291a:	00004097          	auipc	ra,0x4
    8000291e:	dfc080e7          	jalr	-516(ra) # 80006716 <release>
      acquiresleep(&b->lock);
    80002922:	01048513          	addi	a0,s1,16
    80002926:	00001097          	auipc	ra,0x1
    8000292a:	408080e7          	jalr	1032(ra) # 80003d2e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000292e:	409c                	lw	a5,0(s1)
    80002930:	cb89                	beqz	a5,80002942 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002932:	8526                	mv	a0,s1
    80002934:	70a2                	ld	ra,40(sp)
    80002936:	7402                	ld	s0,32(sp)
    80002938:	64e2                	ld	s1,24(sp)
    8000293a:	6942                	ld	s2,16(sp)
    8000293c:	69a2                	ld	s3,8(sp)
    8000293e:	6145                	addi	sp,sp,48
    80002940:	8082                	ret
    virtio_disk_rw(b, 0);
    80002942:	4581                	li	a1,0
    80002944:	8526                	mv	a0,s1
    80002946:	00003097          	auipc	ra,0x3
    8000294a:	f10080e7          	jalr	-240(ra) # 80005856 <virtio_disk_rw>
    b->valid = 1;
    8000294e:	4785                	li	a5,1
    80002950:	c09c                	sw	a5,0(s1)
  return b;
    80002952:	b7c5                	j	80002932 <bread+0xd0>

0000000080002954 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002954:	1101                	addi	sp,sp,-32
    80002956:	ec06                	sd	ra,24(sp)
    80002958:	e822                	sd	s0,16(sp)
    8000295a:	e426                	sd	s1,8(sp)
    8000295c:	1000                	addi	s0,sp,32
    8000295e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002960:	0541                	addi	a0,a0,16
    80002962:	00001097          	auipc	ra,0x1
    80002966:	466080e7          	jalr	1126(ra) # 80003dc8 <holdingsleep>
    8000296a:	cd01                	beqz	a0,80002982 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000296c:	4585                	li	a1,1
    8000296e:	8526                	mv	a0,s1
    80002970:	00003097          	auipc	ra,0x3
    80002974:	ee6080e7          	jalr	-282(ra) # 80005856 <virtio_disk_rw>
}
    80002978:	60e2                	ld	ra,24(sp)
    8000297a:	6442                	ld	s0,16(sp)
    8000297c:	64a2                	ld	s1,8(sp)
    8000297e:	6105                	addi	sp,sp,32
    80002980:	8082                	ret
    panic("bwrite");
    80002982:	00006517          	auipc	a0,0x6
    80002986:	b4e50513          	addi	a0,a0,-1202 # 800084d0 <syscalls+0x118>
    8000298a:	00003097          	auipc	ra,0x3
    8000298e:	78e080e7          	jalr	1934(ra) # 80006118 <panic>

0000000080002992 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002992:	1101                	addi	sp,sp,-32
    80002994:	ec06                	sd	ra,24(sp)
    80002996:	e822                	sd	s0,16(sp)
    80002998:	e426                	sd	s1,8(sp)
    8000299a:	e04a                	sd	s2,0(sp)
    8000299c:	1000                	addi	s0,sp,32
    8000299e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800029a0:	01050913          	addi	s2,a0,16
    800029a4:	854a                	mv	a0,s2
    800029a6:	00001097          	auipc	ra,0x1
    800029aa:	422080e7          	jalr	1058(ra) # 80003dc8 <holdingsleep>
    800029ae:	c92d                	beqz	a0,80002a20 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800029b0:	854a                	mv	a0,s2
    800029b2:	00001097          	auipc	ra,0x1
    800029b6:	3d2080e7          	jalr	978(ra) # 80003d84 <releasesleep>

  acquire(&bcache.lock);
    800029ba:	0000d517          	auipc	a0,0xd
    800029be:	bde50513          	addi	a0,a0,-1058 # 8000f598 <bcache>
    800029c2:	00004097          	auipc	ra,0x4
    800029c6:	ca0080e7          	jalr	-864(ra) # 80006662 <acquire>
  b->refcnt--;
    800029ca:	40bc                	lw	a5,64(s1)
    800029cc:	37fd                	addiw	a5,a5,-1
    800029ce:	0007871b          	sext.w	a4,a5
    800029d2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800029d4:	eb05                	bnez	a4,80002a04 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800029d6:	68bc                	ld	a5,80(s1)
    800029d8:	64b8                	ld	a4,72(s1)
    800029da:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800029dc:	64bc                	ld	a5,72(s1)
    800029de:	68b8                	ld	a4,80(s1)
    800029e0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800029e2:	00015797          	auipc	a5,0x15
    800029e6:	bb678793          	addi	a5,a5,-1098 # 80017598 <bcache+0x8000>
    800029ea:	2b87b703          	ld	a4,696(a5)
    800029ee:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800029f0:	00015717          	auipc	a4,0x15
    800029f4:	e1070713          	addi	a4,a4,-496 # 80017800 <bcache+0x8268>
    800029f8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800029fa:	2b87b703          	ld	a4,696(a5)
    800029fe:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002a00:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002a04:	0000d517          	auipc	a0,0xd
    80002a08:	b9450513          	addi	a0,a0,-1132 # 8000f598 <bcache>
    80002a0c:	00004097          	auipc	ra,0x4
    80002a10:	d0a080e7          	jalr	-758(ra) # 80006716 <release>
}
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6902                	ld	s2,0(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret
    panic("brelse");
    80002a20:	00006517          	auipc	a0,0x6
    80002a24:	ab850513          	addi	a0,a0,-1352 # 800084d8 <syscalls+0x120>
    80002a28:	00003097          	auipc	ra,0x3
    80002a2c:	6f0080e7          	jalr	1776(ra) # 80006118 <panic>

0000000080002a30 <bpin>:

void
bpin(struct buf *b) {
    80002a30:	1101                	addi	sp,sp,-32
    80002a32:	ec06                	sd	ra,24(sp)
    80002a34:	e822                	sd	s0,16(sp)
    80002a36:	e426                	sd	s1,8(sp)
    80002a38:	1000                	addi	s0,sp,32
    80002a3a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002a3c:	0000d517          	auipc	a0,0xd
    80002a40:	b5c50513          	addi	a0,a0,-1188 # 8000f598 <bcache>
    80002a44:	00004097          	auipc	ra,0x4
    80002a48:	c1e080e7          	jalr	-994(ra) # 80006662 <acquire>
  b->refcnt++;
    80002a4c:	40bc                	lw	a5,64(s1)
    80002a4e:	2785                	addiw	a5,a5,1
    80002a50:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002a52:	0000d517          	auipc	a0,0xd
    80002a56:	b4650513          	addi	a0,a0,-1210 # 8000f598 <bcache>
    80002a5a:	00004097          	auipc	ra,0x4
    80002a5e:	cbc080e7          	jalr	-836(ra) # 80006716 <release>
}
    80002a62:	60e2                	ld	ra,24(sp)
    80002a64:	6442                	ld	s0,16(sp)
    80002a66:	64a2                	ld	s1,8(sp)
    80002a68:	6105                	addi	sp,sp,32
    80002a6a:	8082                	ret

0000000080002a6c <bunpin>:

void
bunpin(struct buf *b) {
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	1000                	addi	s0,sp,32
    80002a76:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002a78:	0000d517          	auipc	a0,0xd
    80002a7c:	b2050513          	addi	a0,a0,-1248 # 8000f598 <bcache>
    80002a80:	00004097          	auipc	ra,0x4
    80002a84:	be2080e7          	jalr	-1054(ra) # 80006662 <acquire>
  b->refcnt--;
    80002a88:	40bc                	lw	a5,64(s1)
    80002a8a:	37fd                	addiw	a5,a5,-1
    80002a8c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002a8e:	0000d517          	auipc	a0,0xd
    80002a92:	b0a50513          	addi	a0,a0,-1270 # 8000f598 <bcache>
    80002a96:	00004097          	auipc	ra,0x4
    80002a9a:	c80080e7          	jalr	-896(ra) # 80006716 <release>
}
    80002a9e:	60e2                	ld	ra,24(sp)
    80002aa0:	6442                	ld	s0,16(sp)
    80002aa2:	64a2                	ld	s1,8(sp)
    80002aa4:	6105                	addi	sp,sp,32
    80002aa6:	8082                	ret

0000000080002aa8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002aa8:	1101                	addi	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	e426                	sd	s1,8(sp)
    80002ab0:	e04a                	sd	s2,0(sp)
    80002ab2:	1000                	addi	s0,sp,32
    80002ab4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002ab6:	00d5d59b          	srliw	a1,a1,0xd
    80002aba:	00015797          	auipc	a5,0x15
    80002abe:	1ba7a783          	lw	a5,442(a5) # 80017c74 <sb+0x1c>
    80002ac2:	9dbd                	addw	a1,a1,a5
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	d9e080e7          	jalr	-610(ra) # 80002862 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002acc:	0074f713          	andi	a4,s1,7
    80002ad0:	4785                	li	a5,1
    80002ad2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002ad6:	14ce                	slli	s1,s1,0x33
    80002ad8:	90d9                	srli	s1,s1,0x36
    80002ada:	00950733          	add	a4,a0,s1
    80002ade:	05874703          	lbu	a4,88(a4)
    80002ae2:	00e7f6b3          	and	a3,a5,a4
    80002ae6:	c69d                	beqz	a3,80002b14 <bfree+0x6c>
    80002ae8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002aea:	94aa                	add	s1,s1,a0
    80002aec:	fff7c793          	not	a5,a5
    80002af0:	8ff9                	and	a5,a5,a4
    80002af2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	118080e7          	jalr	280(ra) # 80003c0e <log_write>
  brelse(bp);
    80002afe:	854a                	mv	a0,s2
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	e92080e7          	jalr	-366(ra) # 80002992 <brelse>
}
    80002b08:	60e2                	ld	ra,24(sp)
    80002b0a:	6442                	ld	s0,16(sp)
    80002b0c:	64a2                	ld	s1,8(sp)
    80002b0e:	6902                	ld	s2,0(sp)
    80002b10:	6105                	addi	sp,sp,32
    80002b12:	8082                	ret
    panic("freeing free block");
    80002b14:	00006517          	auipc	a0,0x6
    80002b18:	9cc50513          	addi	a0,a0,-1588 # 800084e0 <syscalls+0x128>
    80002b1c:	00003097          	auipc	ra,0x3
    80002b20:	5fc080e7          	jalr	1532(ra) # 80006118 <panic>

0000000080002b24 <balloc>:
{
    80002b24:	711d                	addi	sp,sp,-96
    80002b26:	ec86                	sd	ra,88(sp)
    80002b28:	e8a2                	sd	s0,80(sp)
    80002b2a:	e4a6                	sd	s1,72(sp)
    80002b2c:	e0ca                	sd	s2,64(sp)
    80002b2e:	fc4e                	sd	s3,56(sp)
    80002b30:	f852                	sd	s4,48(sp)
    80002b32:	f456                	sd	s5,40(sp)
    80002b34:	f05a                	sd	s6,32(sp)
    80002b36:	ec5e                	sd	s7,24(sp)
    80002b38:	e862                	sd	s8,16(sp)
    80002b3a:	e466                	sd	s9,8(sp)
    80002b3c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002b3e:	00015797          	auipc	a5,0x15
    80002b42:	11e7a783          	lw	a5,286(a5) # 80017c5c <sb+0x4>
    80002b46:	cbd1                	beqz	a5,80002bda <balloc+0xb6>
    80002b48:	8baa                	mv	s7,a0
    80002b4a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002b4c:	00015b17          	auipc	s6,0x15
    80002b50:	10cb0b13          	addi	s6,s6,268 # 80017c58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b54:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002b56:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b58:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002b5a:	6c89                	lui	s9,0x2
    80002b5c:	a831                	j	80002b78 <balloc+0x54>
    brelse(bp);
    80002b5e:	854a                	mv	a0,s2
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	e32080e7          	jalr	-462(ra) # 80002992 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002b68:	015c87bb          	addw	a5,s9,s5
    80002b6c:	00078a9b          	sext.w	s5,a5
    80002b70:	004b2703          	lw	a4,4(s6)
    80002b74:	06eaf363          	bgeu	s5,a4,80002bda <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002b78:	41fad79b          	sraiw	a5,s5,0x1f
    80002b7c:	0137d79b          	srliw	a5,a5,0x13
    80002b80:	015787bb          	addw	a5,a5,s5
    80002b84:	40d7d79b          	sraiw	a5,a5,0xd
    80002b88:	01cb2583          	lw	a1,28(s6)
    80002b8c:	9dbd                	addw	a1,a1,a5
    80002b8e:	855e                	mv	a0,s7
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	cd2080e7          	jalr	-814(ra) # 80002862 <bread>
    80002b98:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b9a:	004b2503          	lw	a0,4(s6)
    80002b9e:	000a849b          	sext.w	s1,s5
    80002ba2:	8662                	mv	a2,s8
    80002ba4:	faa4fde3          	bgeu	s1,a0,80002b5e <balloc+0x3a>
      m = 1 << (bi % 8);
    80002ba8:	41f6579b          	sraiw	a5,a2,0x1f
    80002bac:	01d7d69b          	srliw	a3,a5,0x1d
    80002bb0:	00c6873b          	addw	a4,a3,a2
    80002bb4:	00777793          	andi	a5,a4,7
    80002bb8:	9f95                	subw	a5,a5,a3
    80002bba:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002bbe:	4037571b          	sraiw	a4,a4,0x3
    80002bc2:	00e906b3          	add	a3,s2,a4
    80002bc6:	0586c683          	lbu	a3,88(a3) # fffffffffffff058 <end+0xffffffff7ffd8e18>
    80002bca:	00d7f5b3          	and	a1,a5,a3
    80002bce:	cd91                	beqz	a1,80002bea <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002bd0:	2605                	addiw	a2,a2,1
    80002bd2:	2485                	addiw	s1,s1,1
    80002bd4:	fd4618e3          	bne	a2,s4,80002ba4 <balloc+0x80>
    80002bd8:	b759                	j	80002b5e <balloc+0x3a>
  panic("balloc: out of blocks");
    80002bda:	00006517          	auipc	a0,0x6
    80002bde:	91e50513          	addi	a0,a0,-1762 # 800084f8 <syscalls+0x140>
    80002be2:	00003097          	auipc	ra,0x3
    80002be6:	536080e7          	jalr	1334(ra) # 80006118 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002bea:	974a                	add	a4,a4,s2
    80002bec:	8fd5                	or	a5,a5,a3
    80002bee:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002bf2:	854a                	mv	a0,s2
    80002bf4:	00001097          	auipc	ra,0x1
    80002bf8:	01a080e7          	jalr	26(ra) # 80003c0e <log_write>
        brelse(bp);
    80002bfc:	854a                	mv	a0,s2
    80002bfe:	00000097          	auipc	ra,0x0
    80002c02:	d94080e7          	jalr	-620(ra) # 80002992 <brelse>
  bp = bread(dev, bno);
    80002c06:	85a6                	mv	a1,s1
    80002c08:	855e                	mv	a0,s7
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	c58080e7          	jalr	-936(ra) # 80002862 <bread>
    80002c12:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002c14:	40000613          	li	a2,1024
    80002c18:	4581                	li	a1,0
    80002c1a:	05850513          	addi	a0,a0,88
    80002c1e:	ffffd097          	auipc	ra,0xffffd
    80002c22:	55a080e7          	jalr	1370(ra) # 80000178 <memset>
  log_write(bp);
    80002c26:	854a                	mv	a0,s2
    80002c28:	00001097          	auipc	ra,0x1
    80002c2c:	fe6080e7          	jalr	-26(ra) # 80003c0e <log_write>
  brelse(bp);
    80002c30:	854a                	mv	a0,s2
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	d60080e7          	jalr	-672(ra) # 80002992 <brelse>
}
    80002c3a:	8526                	mv	a0,s1
    80002c3c:	60e6                	ld	ra,88(sp)
    80002c3e:	6446                	ld	s0,80(sp)
    80002c40:	64a6                	ld	s1,72(sp)
    80002c42:	6906                	ld	s2,64(sp)
    80002c44:	79e2                	ld	s3,56(sp)
    80002c46:	7a42                	ld	s4,48(sp)
    80002c48:	7aa2                	ld	s5,40(sp)
    80002c4a:	7b02                	ld	s6,32(sp)
    80002c4c:	6be2                	ld	s7,24(sp)
    80002c4e:	6c42                	ld	s8,16(sp)
    80002c50:	6ca2                	ld	s9,8(sp)
    80002c52:	6125                	addi	sp,sp,96
    80002c54:	8082                	ret

0000000080002c56 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002c56:	7179                	addi	sp,sp,-48
    80002c58:	f406                	sd	ra,40(sp)
    80002c5a:	f022                	sd	s0,32(sp)
    80002c5c:	ec26                	sd	s1,24(sp)
    80002c5e:	e84a                	sd	s2,16(sp)
    80002c60:	e44e                	sd	s3,8(sp)
    80002c62:	e052                	sd	s4,0(sp)
    80002c64:	1800                	addi	s0,sp,48
    80002c66:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002c68:	47ad                	li	a5,11
    80002c6a:	04b7fe63          	bgeu	a5,a1,80002cc6 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002c6e:	ff45849b          	addiw	s1,a1,-12
    80002c72:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002c76:	0ff00793          	li	a5,255
    80002c7a:	0ae7e363          	bltu	a5,a4,80002d20 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002c7e:	08052583          	lw	a1,128(a0)
    80002c82:	c5ad                	beqz	a1,80002cec <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002c84:	00092503          	lw	a0,0(s2)
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	bda080e7          	jalr	-1062(ra) # 80002862 <bread>
    80002c90:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002c92:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002c96:	02049593          	slli	a1,s1,0x20
    80002c9a:	9181                	srli	a1,a1,0x20
    80002c9c:	058a                	slli	a1,a1,0x2
    80002c9e:	00b784b3          	add	s1,a5,a1
    80002ca2:	0004a983          	lw	s3,0(s1)
    80002ca6:	04098d63          	beqz	s3,80002d00 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002caa:	8552                	mv	a0,s4
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	ce6080e7          	jalr	-794(ra) # 80002992 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002cb4:	854e                	mv	a0,s3
    80002cb6:	70a2                	ld	ra,40(sp)
    80002cb8:	7402                	ld	s0,32(sp)
    80002cba:	64e2                	ld	s1,24(sp)
    80002cbc:	6942                	ld	s2,16(sp)
    80002cbe:	69a2                	ld	s3,8(sp)
    80002cc0:	6a02                	ld	s4,0(sp)
    80002cc2:	6145                	addi	sp,sp,48
    80002cc4:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002cc6:	02059493          	slli	s1,a1,0x20
    80002cca:	9081                	srli	s1,s1,0x20
    80002ccc:	048a                	slli	s1,s1,0x2
    80002cce:	94aa                	add	s1,s1,a0
    80002cd0:	0504a983          	lw	s3,80(s1)
    80002cd4:	fe0990e3          	bnez	s3,80002cb4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002cd8:	4108                	lw	a0,0(a0)
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	e4a080e7          	jalr	-438(ra) # 80002b24 <balloc>
    80002ce2:	0005099b          	sext.w	s3,a0
    80002ce6:	0534a823          	sw	s3,80(s1)
    80002cea:	b7e9                	j	80002cb4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002cec:	4108                	lw	a0,0(a0)
    80002cee:	00000097          	auipc	ra,0x0
    80002cf2:	e36080e7          	jalr	-458(ra) # 80002b24 <balloc>
    80002cf6:	0005059b          	sext.w	a1,a0
    80002cfa:	08b92023          	sw	a1,128(s2)
    80002cfe:	b759                	j	80002c84 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002d00:	00092503          	lw	a0,0(s2)
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	e20080e7          	jalr	-480(ra) # 80002b24 <balloc>
    80002d0c:	0005099b          	sext.w	s3,a0
    80002d10:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002d14:	8552                	mv	a0,s4
    80002d16:	00001097          	auipc	ra,0x1
    80002d1a:	ef8080e7          	jalr	-264(ra) # 80003c0e <log_write>
    80002d1e:	b771                	j	80002caa <bmap+0x54>
  panic("bmap: out of range");
    80002d20:	00005517          	auipc	a0,0x5
    80002d24:	7f050513          	addi	a0,a0,2032 # 80008510 <syscalls+0x158>
    80002d28:	00003097          	auipc	ra,0x3
    80002d2c:	3f0080e7          	jalr	1008(ra) # 80006118 <panic>

0000000080002d30 <iget>:
{
    80002d30:	7179                	addi	sp,sp,-48
    80002d32:	f406                	sd	ra,40(sp)
    80002d34:	f022                	sd	s0,32(sp)
    80002d36:	ec26                	sd	s1,24(sp)
    80002d38:	e84a                	sd	s2,16(sp)
    80002d3a:	e44e                	sd	s3,8(sp)
    80002d3c:	e052                	sd	s4,0(sp)
    80002d3e:	1800                	addi	s0,sp,48
    80002d40:	89aa                	mv	s3,a0
    80002d42:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002d44:	00015517          	auipc	a0,0x15
    80002d48:	f3450513          	addi	a0,a0,-204 # 80017c78 <itable>
    80002d4c:	00004097          	auipc	ra,0x4
    80002d50:	916080e7          	jalr	-1770(ra) # 80006662 <acquire>
  empty = 0;
    80002d54:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002d56:	00015497          	auipc	s1,0x15
    80002d5a:	f3a48493          	addi	s1,s1,-198 # 80017c90 <itable+0x18>
    80002d5e:	00017697          	auipc	a3,0x17
    80002d62:	9c268693          	addi	a3,a3,-1598 # 80019720 <log>
    80002d66:	a039                	j	80002d74 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002d68:	02090b63          	beqz	s2,80002d9e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002d6c:	08848493          	addi	s1,s1,136
    80002d70:	02d48a63          	beq	s1,a3,80002da4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002d74:	449c                	lw	a5,8(s1)
    80002d76:	fef059e3          	blez	a5,80002d68 <iget+0x38>
    80002d7a:	4098                	lw	a4,0(s1)
    80002d7c:	ff3716e3          	bne	a4,s3,80002d68 <iget+0x38>
    80002d80:	40d8                	lw	a4,4(s1)
    80002d82:	ff4713e3          	bne	a4,s4,80002d68 <iget+0x38>
      ip->ref++;
    80002d86:	2785                	addiw	a5,a5,1
    80002d88:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002d8a:	00015517          	auipc	a0,0x15
    80002d8e:	eee50513          	addi	a0,a0,-274 # 80017c78 <itable>
    80002d92:	00004097          	auipc	ra,0x4
    80002d96:	984080e7          	jalr	-1660(ra) # 80006716 <release>
      return ip;
    80002d9a:	8926                	mv	s2,s1
    80002d9c:	a03d                	j	80002dca <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002d9e:	f7f9                	bnez	a5,80002d6c <iget+0x3c>
    80002da0:	8926                	mv	s2,s1
    80002da2:	b7e9                	j	80002d6c <iget+0x3c>
  if(empty == 0)
    80002da4:	02090c63          	beqz	s2,80002ddc <iget+0xac>
  ip->dev = dev;
    80002da8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002dac:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002db0:	4785                	li	a5,1
    80002db2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002db6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002dba:	00015517          	auipc	a0,0x15
    80002dbe:	ebe50513          	addi	a0,a0,-322 # 80017c78 <itable>
    80002dc2:	00004097          	auipc	ra,0x4
    80002dc6:	954080e7          	jalr	-1708(ra) # 80006716 <release>
}
    80002dca:	854a                	mv	a0,s2
    80002dcc:	70a2                	ld	ra,40(sp)
    80002dce:	7402                	ld	s0,32(sp)
    80002dd0:	64e2                	ld	s1,24(sp)
    80002dd2:	6942                	ld	s2,16(sp)
    80002dd4:	69a2                	ld	s3,8(sp)
    80002dd6:	6a02                	ld	s4,0(sp)
    80002dd8:	6145                	addi	sp,sp,48
    80002dda:	8082                	ret
    panic("iget: no inodes");
    80002ddc:	00005517          	auipc	a0,0x5
    80002de0:	74c50513          	addi	a0,a0,1868 # 80008528 <syscalls+0x170>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	334080e7          	jalr	820(ra) # 80006118 <panic>

0000000080002dec <fsinit>:
fsinit(int dev) {
    80002dec:	7179                	addi	sp,sp,-48
    80002dee:	f406                	sd	ra,40(sp)
    80002df0:	f022                	sd	s0,32(sp)
    80002df2:	ec26                	sd	s1,24(sp)
    80002df4:	e84a                	sd	s2,16(sp)
    80002df6:	e44e                	sd	s3,8(sp)
    80002df8:	1800                	addi	s0,sp,48
    80002dfa:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002dfc:	4585                	li	a1,1
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	a64080e7          	jalr	-1436(ra) # 80002862 <bread>
    80002e06:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002e08:	00015997          	auipc	s3,0x15
    80002e0c:	e5098993          	addi	s3,s3,-432 # 80017c58 <sb>
    80002e10:	02000613          	li	a2,32
    80002e14:	05850593          	addi	a1,a0,88
    80002e18:	854e                	mv	a0,s3
    80002e1a:	ffffd097          	auipc	ra,0xffffd
    80002e1e:	3be080e7          	jalr	958(ra) # 800001d8 <memmove>
  brelse(bp);
    80002e22:	8526                	mv	a0,s1
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	b6e080e7          	jalr	-1170(ra) # 80002992 <brelse>
  if(sb.magic != FSMAGIC)
    80002e2c:	0009a703          	lw	a4,0(s3)
    80002e30:	102037b7          	lui	a5,0x10203
    80002e34:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002e38:	02f71263          	bne	a4,a5,80002e5c <fsinit+0x70>
  initlog(dev, &sb);
    80002e3c:	00015597          	auipc	a1,0x15
    80002e40:	e1c58593          	addi	a1,a1,-484 # 80017c58 <sb>
    80002e44:	854a                	mv	a0,s2
    80002e46:	00001097          	auipc	ra,0x1
    80002e4a:	b4c080e7          	jalr	-1204(ra) # 80003992 <initlog>
}
    80002e4e:	70a2                	ld	ra,40(sp)
    80002e50:	7402                	ld	s0,32(sp)
    80002e52:	64e2                	ld	s1,24(sp)
    80002e54:	6942                	ld	s2,16(sp)
    80002e56:	69a2                	ld	s3,8(sp)
    80002e58:	6145                	addi	sp,sp,48
    80002e5a:	8082                	ret
    panic("invalid file system");
    80002e5c:	00005517          	auipc	a0,0x5
    80002e60:	6dc50513          	addi	a0,a0,1756 # 80008538 <syscalls+0x180>
    80002e64:	00003097          	auipc	ra,0x3
    80002e68:	2b4080e7          	jalr	692(ra) # 80006118 <panic>

0000000080002e6c <iinit>:
{
    80002e6c:	7179                	addi	sp,sp,-48
    80002e6e:	f406                	sd	ra,40(sp)
    80002e70:	f022                	sd	s0,32(sp)
    80002e72:	ec26                	sd	s1,24(sp)
    80002e74:	e84a                	sd	s2,16(sp)
    80002e76:	e44e                	sd	s3,8(sp)
    80002e78:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002e7a:	00005597          	auipc	a1,0x5
    80002e7e:	6d658593          	addi	a1,a1,1750 # 80008550 <syscalls+0x198>
    80002e82:	00015517          	auipc	a0,0x15
    80002e86:	df650513          	addi	a0,a0,-522 # 80017c78 <itable>
    80002e8a:	00003097          	auipc	ra,0x3
    80002e8e:	748080e7          	jalr	1864(ra) # 800065d2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002e92:	00015497          	auipc	s1,0x15
    80002e96:	e0e48493          	addi	s1,s1,-498 # 80017ca0 <itable+0x28>
    80002e9a:	00017997          	auipc	s3,0x17
    80002e9e:	89698993          	addi	s3,s3,-1898 # 80019730 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ea2:	00005917          	auipc	s2,0x5
    80002ea6:	6b690913          	addi	s2,s2,1718 # 80008558 <syscalls+0x1a0>
    80002eaa:	85ca                	mv	a1,s2
    80002eac:	8526                	mv	a0,s1
    80002eae:	00001097          	auipc	ra,0x1
    80002eb2:	e46080e7          	jalr	-442(ra) # 80003cf4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002eb6:	08848493          	addi	s1,s1,136
    80002eba:	ff3498e3          	bne	s1,s3,80002eaa <iinit+0x3e>
}
    80002ebe:	70a2                	ld	ra,40(sp)
    80002ec0:	7402                	ld	s0,32(sp)
    80002ec2:	64e2                	ld	s1,24(sp)
    80002ec4:	6942                	ld	s2,16(sp)
    80002ec6:	69a2                	ld	s3,8(sp)
    80002ec8:	6145                	addi	sp,sp,48
    80002eca:	8082                	ret

0000000080002ecc <ialloc>:
{
    80002ecc:	715d                	addi	sp,sp,-80
    80002ece:	e486                	sd	ra,72(sp)
    80002ed0:	e0a2                	sd	s0,64(sp)
    80002ed2:	fc26                	sd	s1,56(sp)
    80002ed4:	f84a                	sd	s2,48(sp)
    80002ed6:	f44e                	sd	s3,40(sp)
    80002ed8:	f052                	sd	s4,32(sp)
    80002eda:	ec56                	sd	s5,24(sp)
    80002edc:	e85a                	sd	s6,16(sp)
    80002ede:	e45e                	sd	s7,8(sp)
    80002ee0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ee2:	00015717          	auipc	a4,0x15
    80002ee6:	d8272703          	lw	a4,-638(a4) # 80017c64 <sb+0xc>
    80002eea:	4785                	li	a5,1
    80002eec:	04e7fa63          	bgeu	a5,a4,80002f40 <ialloc+0x74>
    80002ef0:	8aaa                	mv	s5,a0
    80002ef2:	8bae                	mv	s7,a1
    80002ef4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ef6:	00015a17          	auipc	s4,0x15
    80002efa:	d62a0a13          	addi	s4,s4,-670 # 80017c58 <sb>
    80002efe:	00048b1b          	sext.w	s6,s1
    80002f02:	0044d593          	srli	a1,s1,0x4
    80002f06:	018a2783          	lw	a5,24(s4)
    80002f0a:	9dbd                	addw	a1,a1,a5
    80002f0c:	8556                	mv	a0,s5
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	954080e7          	jalr	-1708(ra) # 80002862 <bread>
    80002f16:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002f18:	05850993          	addi	s3,a0,88
    80002f1c:	00f4f793          	andi	a5,s1,15
    80002f20:	079a                	slli	a5,a5,0x6
    80002f22:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002f24:	00099783          	lh	a5,0(s3)
    80002f28:	c785                	beqz	a5,80002f50 <ialloc+0x84>
    brelse(bp);
    80002f2a:	00000097          	auipc	ra,0x0
    80002f2e:	a68080e7          	jalr	-1432(ra) # 80002992 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002f32:	0485                	addi	s1,s1,1
    80002f34:	00ca2703          	lw	a4,12(s4)
    80002f38:	0004879b          	sext.w	a5,s1
    80002f3c:	fce7e1e3          	bltu	a5,a4,80002efe <ialloc+0x32>
  panic("ialloc: no inodes");
    80002f40:	00005517          	auipc	a0,0x5
    80002f44:	62050513          	addi	a0,a0,1568 # 80008560 <syscalls+0x1a8>
    80002f48:	00003097          	auipc	ra,0x3
    80002f4c:	1d0080e7          	jalr	464(ra) # 80006118 <panic>
      memset(dip, 0, sizeof(*dip));
    80002f50:	04000613          	li	a2,64
    80002f54:	4581                	li	a1,0
    80002f56:	854e                	mv	a0,s3
    80002f58:	ffffd097          	auipc	ra,0xffffd
    80002f5c:	220080e7          	jalr	544(ra) # 80000178 <memset>
      dip->type = type;
    80002f60:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002f64:	854a                	mv	a0,s2
    80002f66:	00001097          	auipc	ra,0x1
    80002f6a:	ca8080e7          	jalr	-856(ra) # 80003c0e <log_write>
      brelse(bp);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	a22080e7          	jalr	-1502(ra) # 80002992 <brelse>
      return iget(dev, inum);
    80002f78:	85da                	mv	a1,s6
    80002f7a:	8556                	mv	a0,s5
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	db4080e7          	jalr	-588(ra) # 80002d30 <iget>
}
    80002f84:	60a6                	ld	ra,72(sp)
    80002f86:	6406                	ld	s0,64(sp)
    80002f88:	74e2                	ld	s1,56(sp)
    80002f8a:	7942                	ld	s2,48(sp)
    80002f8c:	79a2                	ld	s3,40(sp)
    80002f8e:	7a02                	ld	s4,32(sp)
    80002f90:	6ae2                	ld	s5,24(sp)
    80002f92:	6b42                	ld	s6,16(sp)
    80002f94:	6ba2                	ld	s7,8(sp)
    80002f96:	6161                	addi	sp,sp,80
    80002f98:	8082                	ret

0000000080002f9a <iupdate>:
{
    80002f9a:	1101                	addi	sp,sp,-32
    80002f9c:	ec06                	sd	ra,24(sp)
    80002f9e:	e822                	sd	s0,16(sp)
    80002fa0:	e426                	sd	s1,8(sp)
    80002fa2:	e04a                	sd	s2,0(sp)
    80002fa4:	1000                	addi	s0,sp,32
    80002fa6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002fa8:	415c                	lw	a5,4(a0)
    80002faa:	0047d79b          	srliw	a5,a5,0x4
    80002fae:	00015597          	auipc	a1,0x15
    80002fb2:	cc25a583          	lw	a1,-830(a1) # 80017c70 <sb+0x18>
    80002fb6:	9dbd                	addw	a1,a1,a5
    80002fb8:	4108                	lw	a0,0(a0)
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	8a8080e7          	jalr	-1880(ra) # 80002862 <bread>
    80002fc2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002fc4:	05850793          	addi	a5,a0,88
    80002fc8:	40c8                	lw	a0,4(s1)
    80002fca:	893d                	andi	a0,a0,15
    80002fcc:	051a                	slli	a0,a0,0x6
    80002fce:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002fd0:	04449703          	lh	a4,68(s1)
    80002fd4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002fd8:	04649703          	lh	a4,70(s1)
    80002fdc:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002fe0:	04849703          	lh	a4,72(s1)
    80002fe4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002fe8:	04a49703          	lh	a4,74(s1)
    80002fec:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ff0:	44f8                	lw	a4,76(s1)
    80002ff2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ff4:	03400613          	li	a2,52
    80002ff8:	05048593          	addi	a1,s1,80
    80002ffc:	0531                	addi	a0,a0,12
    80002ffe:	ffffd097          	auipc	ra,0xffffd
    80003002:	1da080e7          	jalr	474(ra) # 800001d8 <memmove>
  log_write(bp);
    80003006:	854a                	mv	a0,s2
    80003008:	00001097          	auipc	ra,0x1
    8000300c:	c06080e7          	jalr	-1018(ra) # 80003c0e <log_write>
  brelse(bp);
    80003010:	854a                	mv	a0,s2
    80003012:	00000097          	auipc	ra,0x0
    80003016:	980080e7          	jalr	-1664(ra) # 80002992 <brelse>
}
    8000301a:	60e2                	ld	ra,24(sp)
    8000301c:	6442                	ld	s0,16(sp)
    8000301e:	64a2                	ld	s1,8(sp)
    80003020:	6902                	ld	s2,0(sp)
    80003022:	6105                	addi	sp,sp,32
    80003024:	8082                	ret

0000000080003026 <idup>:
{
    80003026:	1101                	addi	sp,sp,-32
    80003028:	ec06                	sd	ra,24(sp)
    8000302a:	e822                	sd	s0,16(sp)
    8000302c:	e426                	sd	s1,8(sp)
    8000302e:	1000                	addi	s0,sp,32
    80003030:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003032:	00015517          	auipc	a0,0x15
    80003036:	c4650513          	addi	a0,a0,-954 # 80017c78 <itable>
    8000303a:	00003097          	auipc	ra,0x3
    8000303e:	628080e7          	jalr	1576(ra) # 80006662 <acquire>
  ip->ref++;
    80003042:	449c                	lw	a5,8(s1)
    80003044:	2785                	addiw	a5,a5,1
    80003046:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003048:	00015517          	auipc	a0,0x15
    8000304c:	c3050513          	addi	a0,a0,-976 # 80017c78 <itable>
    80003050:	00003097          	auipc	ra,0x3
    80003054:	6c6080e7          	jalr	1734(ra) # 80006716 <release>
}
    80003058:	8526                	mv	a0,s1
    8000305a:	60e2                	ld	ra,24(sp)
    8000305c:	6442                	ld	s0,16(sp)
    8000305e:	64a2                	ld	s1,8(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret

0000000080003064 <ilock>:
{
    80003064:	1101                	addi	sp,sp,-32
    80003066:	ec06                	sd	ra,24(sp)
    80003068:	e822                	sd	s0,16(sp)
    8000306a:	e426                	sd	s1,8(sp)
    8000306c:	e04a                	sd	s2,0(sp)
    8000306e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003070:	c115                	beqz	a0,80003094 <ilock+0x30>
    80003072:	84aa                	mv	s1,a0
    80003074:	451c                	lw	a5,8(a0)
    80003076:	00f05f63          	blez	a5,80003094 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000307a:	0541                	addi	a0,a0,16
    8000307c:	00001097          	auipc	ra,0x1
    80003080:	cb2080e7          	jalr	-846(ra) # 80003d2e <acquiresleep>
  if(ip->valid == 0){
    80003084:	40bc                	lw	a5,64(s1)
    80003086:	cf99                	beqz	a5,800030a4 <ilock+0x40>
}
    80003088:	60e2                	ld	ra,24(sp)
    8000308a:	6442                	ld	s0,16(sp)
    8000308c:	64a2                	ld	s1,8(sp)
    8000308e:	6902                	ld	s2,0(sp)
    80003090:	6105                	addi	sp,sp,32
    80003092:	8082                	ret
    panic("ilock");
    80003094:	00005517          	auipc	a0,0x5
    80003098:	4e450513          	addi	a0,a0,1252 # 80008578 <syscalls+0x1c0>
    8000309c:	00003097          	auipc	ra,0x3
    800030a0:	07c080e7          	jalr	124(ra) # 80006118 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800030a4:	40dc                	lw	a5,4(s1)
    800030a6:	0047d79b          	srliw	a5,a5,0x4
    800030aa:	00015597          	auipc	a1,0x15
    800030ae:	bc65a583          	lw	a1,-1082(a1) # 80017c70 <sb+0x18>
    800030b2:	9dbd                	addw	a1,a1,a5
    800030b4:	4088                	lw	a0,0(s1)
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	7ac080e7          	jalr	1964(ra) # 80002862 <bread>
    800030be:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800030c0:	05850593          	addi	a1,a0,88
    800030c4:	40dc                	lw	a5,4(s1)
    800030c6:	8bbd                	andi	a5,a5,15
    800030c8:	079a                	slli	a5,a5,0x6
    800030ca:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800030cc:	00059783          	lh	a5,0(a1)
    800030d0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800030d4:	00259783          	lh	a5,2(a1)
    800030d8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800030dc:	00459783          	lh	a5,4(a1)
    800030e0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800030e4:	00659783          	lh	a5,6(a1)
    800030e8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800030ec:	459c                	lw	a5,8(a1)
    800030ee:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800030f0:	03400613          	li	a2,52
    800030f4:	05b1                	addi	a1,a1,12
    800030f6:	05048513          	addi	a0,s1,80
    800030fa:	ffffd097          	auipc	ra,0xffffd
    800030fe:	0de080e7          	jalr	222(ra) # 800001d8 <memmove>
    brelse(bp);
    80003102:	854a                	mv	a0,s2
    80003104:	00000097          	auipc	ra,0x0
    80003108:	88e080e7          	jalr	-1906(ra) # 80002992 <brelse>
    ip->valid = 1;
    8000310c:	4785                	li	a5,1
    8000310e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003110:	04449783          	lh	a5,68(s1)
    80003114:	fbb5                	bnez	a5,80003088 <ilock+0x24>
      panic("ilock: no type");
    80003116:	00005517          	auipc	a0,0x5
    8000311a:	46a50513          	addi	a0,a0,1130 # 80008580 <syscalls+0x1c8>
    8000311e:	00003097          	auipc	ra,0x3
    80003122:	ffa080e7          	jalr	-6(ra) # 80006118 <panic>

0000000080003126 <iunlock>:
{
    80003126:	1101                	addi	sp,sp,-32
    80003128:	ec06                	sd	ra,24(sp)
    8000312a:	e822                	sd	s0,16(sp)
    8000312c:	e426                	sd	s1,8(sp)
    8000312e:	e04a                	sd	s2,0(sp)
    80003130:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003132:	c905                	beqz	a0,80003162 <iunlock+0x3c>
    80003134:	84aa                	mv	s1,a0
    80003136:	01050913          	addi	s2,a0,16
    8000313a:	854a                	mv	a0,s2
    8000313c:	00001097          	auipc	ra,0x1
    80003140:	c8c080e7          	jalr	-884(ra) # 80003dc8 <holdingsleep>
    80003144:	cd19                	beqz	a0,80003162 <iunlock+0x3c>
    80003146:	449c                	lw	a5,8(s1)
    80003148:	00f05d63          	blez	a5,80003162 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000314c:	854a                	mv	a0,s2
    8000314e:	00001097          	auipc	ra,0x1
    80003152:	c36080e7          	jalr	-970(ra) # 80003d84 <releasesleep>
}
    80003156:	60e2                	ld	ra,24(sp)
    80003158:	6442                	ld	s0,16(sp)
    8000315a:	64a2                	ld	s1,8(sp)
    8000315c:	6902                	ld	s2,0(sp)
    8000315e:	6105                	addi	sp,sp,32
    80003160:	8082                	ret
    panic("iunlock");
    80003162:	00005517          	auipc	a0,0x5
    80003166:	42e50513          	addi	a0,a0,1070 # 80008590 <syscalls+0x1d8>
    8000316a:	00003097          	auipc	ra,0x3
    8000316e:	fae080e7          	jalr	-82(ra) # 80006118 <panic>

0000000080003172 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003172:	7179                	addi	sp,sp,-48
    80003174:	f406                	sd	ra,40(sp)
    80003176:	f022                	sd	s0,32(sp)
    80003178:	ec26                	sd	s1,24(sp)
    8000317a:	e84a                	sd	s2,16(sp)
    8000317c:	e44e                	sd	s3,8(sp)
    8000317e:	e052                	sd	s4,0(sp)
    80003180:	1800                	addi	s0,sp,48
    80003182:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003184:	05050493          	addi	s1,a0,80
    80003188:	08050913          	addi	s2,a0,128
    8000318c:	a021                	j	80003194 <itrunc+0x22>
    8000318e:	0491                	addi	s1,s1,4
    80003190:	01248d63          	beq	s1,s2,800031aa <itrunc+0x38>
    if(ip->addrs[i]){
    80003194:	408c                	lw	a1,0(s1)
    80003196:	dde5                	beqz	a1,8000318e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003198:	0009a503          	lw	a0,0(s3)
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	90c080e7          	jalr	-1780(ra) # 80002aa8 <bfree>
      ip->addrs[i] = 0;
    800031a4:	0004a023          	sw	zero,0(s1)
    800031a8:	b7dd                	j	8000318e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800031aa:	0809a583          	lw	a1,128(s3)
    800031ae:	e185                	bnez	a1,800031ce <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800031b0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800031b4:	854e                	mv	a0,s3
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	de4080e7          	jalr	-540(ra) # 80002f9a <iupdate>
}
    800031be:	70a2                	ld	ra,40(sp)
    800031c0:	7402                	ld	s0,32(sp)
    800031c2:	64e2                	ld	s1,24(sp)
    800031c4:	6942                	ld	s2,16(sp)
    800031c6:	69a2                	ld	s3,8(sp)
    800031c8:	6a02                	ld	s4,0(sp)
    800031ca:	6145                	addi	sp,sp,48
    800031cc:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800031ce:	0009a503          	lw	a0,0(s3)
    800031d2:	fffff097          	auipc	ra,0xfffff
    800031d6:	690080e7          	jalr	1680(ra) # 80002862 <bread>
    800031da:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800031dc:	05850493          	addi	s1,a0,88
    800031e0:	45850913          	addi	s2,a0,1112
    800031e4:	a811                	j	800031f8 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    800031e6:	0009a503          	lw	a0,0(s3)
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	8be080e7          	jalr	-1858(ra) # 80002aa8 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800031f2:	0491                	addi	s1,s1,4
    800031f4:	01248563          	beq	s1,s2,800031fe <itrunc+0x8c>
      if(a[j])
    800031f8:	408c                	lw	a1,0(s1)
    800031fa:	dde5                	beqz	a1,800031f2 <itrunc+0x80>
    800031fc:	b7ed                	j	800031e6 <itrunc+0x74>
    brelse(bp);
    800031fe:	8552                	mv	a0,s4
    80003200:	fffff097          	auipc	ra,0xfffff
    80003204:	792080e7          	jalr	1938(ra) # 80002992 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003208:	0809a583          	lw	a1,128(s3)
    8000320c:	0009a503          	lw	a0,0(s3)
    80003210:	00000097          	auipc	ra,0x0
    80003214:	898080e7          	jalr	-1896(ra) # 80002aa8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003218:	0809a023          	sw	zero,128(s3)
    8000321c:	bf51                	j	800031b0 <itrunc+0x3e>

000000008000321e <iput>:
{
    8000321e:	1101                	addi	sp,sp,-32
    80003220:	ec06                	sd	ra,24(sp)
    80003222:	e822                	sd	s0,16(sp)
    80003224:	e426                	sd	s1,8(sp)
    80003226:	e04a                	sd	s2,0(sp)
    80003228:	1000                	addi	s0,sp,32
    8000322a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000322c:	00015517          	auipc	a0,0x15
    80003230:	a4c50513          	addi	a0,a0,-1460 # 80017c78 <itable>
    80003234:	00003097          	auipc	ra,0x3
    80003238:	42e080e7          	jalr	1070(ra) # 80006662 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000323c:	4498                	lw	a4,8(s1)
    8000323e:	4785                	li	a5,1
    80003240:	02f70363          	beq	a4,a5,80003266 <iput+0x48>
  ip->ref--;
    80003244:	449c                	lw	a5,8(s1)
    80003246:	37fd                	addiw	a5,a5,-1
    80003248:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000324a:	00015517          	auipc	a0,0x15
    8000324e:	a2e50513          	addi	a0,a0,-1490 # 80017c78 <itable>
    80003252:	00003097          	auipc	ra,0x3
    80003256:	4c4080e7          	jalr	1220(ra) # 80006716 <release>
}
    8000325a:	60e2                	ld	ra,24(sp)
    8000325c:	6442                	ld	s0,16(sp)
    8000325e:	64a2                	ld	s1,8(sp)
    80003260:	6902                	ld	s2,0(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003266:	40bc                	lw	a5,64(s1)
    80003268:	dff1                	beqz	a5,80003244 <iput+0x26>
    8000326a:	04a49783          	lh	a5,74(s1)
    8000326e:	fbf9                	bnez	a5,80003244 <iput+0x26>
    acquiresleep(&ip->lock);
    80003270:	01048913          	addi	s2,s1,16
    80003274:	854a                	mv	a0,s2
    80003276:	00001097          	auipc	ra,0x1
    8000327a:	ab8080e7          	jalr	-1352(ra) # 80003d2e <acquiresleep>
    release(&itable.lock);
    8000327e:	00015517          	auipc	a0,0x15
    80003282:	9fa50513          	addi	a0,a0,-1542 # 80017c78 <itable>
    80003286:	00003097          	auipc	ra,0x3
    8000328a:	490080e7          	jalr	1168(ra) # 80006716 <release>
    itrunc(ip);
    8000328e:	8526                	mv	a0,s1
    80003290:	00000097          	auipc	ra,0x0
    80003294:	ee2080e7          	jalr	-286(ra) # 80003172 <itrunc>
    ip->type = 0;
    80003298:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000329c:	8526                	mv	a0,s1
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	cfc080e7          	jalr	-772(ra) # 80002f9a <iupdate>
    ip->valid = 0;
    800032a6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800032aa:	854a                	mv	a0,s2
    800032ac:	00001097          	auipc	ra,0x1
    800032b0:	ad8080e7          	jalr	-1320(ra) # 80003d84 <releasesleep>
    acquire(&itable.lock);
    800032b4:	00015517          	auipc	a0,0x15
    800032b8:	9c450513          	addi	a0,a0,-1596 # 80017c78 <itable>
    800032bc:	00003097          	auipc	ra,0x3
    800032c0:	3a6080e7          	jalr	934(ra) # 80006662 <acquire>
    800032c4:	b741                	j	80003244 <iput+0x26>

00000000800032c6 <iunlockput>:
{
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	e426                	sd	s1,8(sp)
    800032ce:	1000                	addi	s0,sp,32
    800032d0:	84aa                	mv	s1,a0
  iunlock(ip);
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	e54080e7          	jalr	-428(ra) # 80003126 <iunlock>
  iput(ip);
    800032da:	8526                	mv	a0,s1
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	f42080e7          	jalr	-190(ra) # 8000321e <iput>
}
    800032e4:	60e2                	ld	ra,24(sp)
    800032e6:	6442                	ld	s0,16(sp)
    800032e8:	64a2                	ld	s1,8(sp)
    800032ea:	6105                	addi	sp,sp,32
    800032ec:	8082                	ret

00000000800032ee <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800032ee:	1141                	addi	sp,sp,-16
    800032f0:	e422                	sd	s0,8(sp)
    800032f2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800032f4:	411c                	lw	a5,0(a0)
    800032f6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800032f8:	415c                	lw	a5,4(a0)
    800032fa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800032fc:	04451783          	lh	a5,68(a0)
    80003300:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003304:	04a51783          	lh	a5,74(a0)
    80003308:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000330c:	04c56783          	lwu	a5,76(a0)
    80003310:	e99c                	sd	a5,16(a1)
}
    80003312:	6422                	ld	s0,8(sp)
    80003314:	0141                	addi	sp,sp,16
    80003316:	8082                	ret

0000000080003318 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003318:	457c                	lw	a5,76(a0)
    8000331a:	0ed7e963          	bltu	a5,a3,8000340c <readi+0xf4>
{
    8000331e:	7159                	addi	sp,sp,-112
    80003320:	f486                	sd	ra,104(sp)
    80003322:	f0a2                	sd	s0,96(sp)
    80003324:	eca6                	sd	s1,88(sp)
    80003326:	e8ca                	sd	s2,80(sp)
    80003328:	e4ce                	sd	s3,72(sp)
    8000332a:	e0d2                	sd	s4,64(sp)
    8000332c:	fc56                	sd	s5,56(sp)
    8000332e:	f85a                	sd	s6,48(sp)
    80003330:	f45e                	sd	s7,40(sp)
    80003332:	f062                	sd	s8,32(sp)
    80003334:	ec66                	sd	s9,24(sp)
    80003336:	e86a                	sd	s10,16(sp)
    80003338:	e46e                	sd	s11,8(sp)
    8000333a:	1880                	addi	s0,sp,112
    8000333c:	8baa                	mv	s7,a0
    8000333e:	8c2e                	mv	s8,a1
    80003340:	8ab2                	mv	s5,a2
    80003342:	84b6                	mv	s1,a3
    80003344:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003346:	9f35                	addw	a4,a4,a3
    return 0;
    80003348:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000334a:	0ad76063          	bltu	a4,a3,800033ea <readi+0xd2>
  if(off + n > ip->size)
    8000334e:	00e7f463          	bgeu	a5,a4,80003356 <readi+0x3e>
    n = ip->size - off;
    80003352:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003356:	0a0b0963          	beqz	s6,80003408 <readi+0xf0>
    8000335a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000335c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003360:	5cfd                	li	s9,-1
    80003362:	a82d                	j	8000339c <readi+0x84>
    80003364:	020a1d93          	slli	s11,s4,0x20
    80003368:	020ddd93          	srli	s11,s11,0x20
    8000336c:	05890613          	addi	a2,s2,88
    80003370:	86ee                	mv	a3,s11
    80003372:	963a                	add	a2,a2,a4
    80003374:	85d6                	mv	a1,s5
    80003376:	8562                	mv	a0,s8
    80003378:	ffffe097          	auipc	ra,0xffffe
    8000337c:	64c080e7          	jalr	1612(ra) # 800019c4 <either_copyout>
    80003380:	05950d63          	beq	a0,s9,800033da <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003384:	854a                	mv	a0,s2
    80003386:	fffff097          	auipc	ra,0xfffff
    8000338a:	60c080e7          	jalr	1548(ra) # 80002992 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000338e:	013a09bb          	addw	s3,s4,s3
    80003392:	009a04bb          	addw	s1,s4,s1
    80003396:	9aee                	add	s5,s5,s11
    80003398:	0569f763          	bgeu	s3,s6,800033e6 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000339c:	000ba903          	lw	s2,0(s7)
    800033a0:	00a4d59b          	srliw	a1,s1,0xa
    800033a4:	855e                	mv	a0,s7
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	8b0080e7          	jalr	-1872(ra) # 80002c56 <bmap>
    800033ae:	0005059b          	sext.w	a1,a0
    800033b2:	854a                	mv	a0,s2
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	4ae080e7          	jalr	1198(ra) # 80002862 <bread>
    800033bc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800033be:	3ff4f713          	andi	a4,s1,1023
    800033c2:	40ed07bb          	subw	a5,s10,a4
    800033c6:	413b06bb          	subw	a3,s6,s3
    800033ca:	8a3e                	mv	s4,a5
    800033cc:	2781                	sext.w	a5,a5
    800033ce:	0006861b          	sext.w	a2,a3
    800033d2:	f8f679e3          	bgeu	a2,a5,80003364 <readi+0x4c>
    800033d6:	8a36                	mv	s4,a3
    800033d8:	b771                	j	80003364 <readi+0x4c>
      brelse(bp);
    800033da:	854a                	mv	a0,s2
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	5b6080e7          	jalr	1462(ra) # 80002992 <brelse>
      tot = -1;
    800033e4:	59fd                	li	s3,-1
  }
  return tot;
    800033e6:	0009851b          	sext.w	a0,s3
}
    800033ea:	70a6                	ld	ra,104(sp)
    800033ec:	7406                	ld	s0,96(sp)
    800033ee:	64e6                	ld	s1,88(sp)
    800033f0:	6946                	ld	s2,80(sp)
    800033f2:	69a6                	ld	s3,72(sp)
    800033f4:	6a06                	ld	s4,64(sp)
    800033f6:	7ae2                	ld	s5,56(sp)
    800033f8:	7b42                	ld	s6,48(sp)
    800033fa:	7ba2                	ld	s7,40(sp)
    800033fc:	7c02                	ld	s8,32(sp)
    800033fe:	6ce2                	ld	s9,24(sp)
    80003400:	6d42                	ld	s10,16(sp)
    80003402:	6da2                	ld	s11,8(sp)
    80003404:	6165                	addi	sp,sp,112
    80003406:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003408:	89da                	mv	s3,s6
    8000340a:	bff1                	j	800033e6 <readi+0xce>
    return 0;
    8000340c:	4501                	li	a0,0
}
    8000340e:	8082                	ret

0000000080003410 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003410:	457c                	lw	a5,76(a0)
    80003412:	10d7e863          	bltu	a5,a3,80003522 <writei+0x112>
{
    80003416:	7159                	addi	sp,sp,-112
    80003418:	f486                	sd	ra,104(sp)
    8000341a:	f0a2                	sd	s0,96(sp)
    8000341c:	eca6                	sd	s1,88(sp)
    8000341e:	e8ca                	sd	s2,80(sp)
    80003420:	e4ce                	sd	s3,72(sp)
    80003422:	e0d2                	sd	s4,64(sp)
    80003424:	fc56                	sd	s5,56(sp)
    80003426:	f85a                	sd	s6,48(sp)
    80003428:	f45e                	sd	s7,40(sp)
    8000342a:	f062                	sd	s8,32(sp)
    8000342c:	ec66                	sd	s9,24(sp)
    8000342e:	e86a                	sd	s10,16(sp)
    80003430:	e46e                	sd	s11,8(sp)
    80003432:	1880                	addi	s0,sp,112
    80003434:	8b2a                	mv	s6,a0
    80003436:	8c2e                	mv	s8,a1
    80003438:	8ab2                	mv	s5,a2
    8000343a:	8936                	mv	s2,a3
    8000343c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000343e:	00e687bb          	addw	a5,a3,a4
    80003442:	0ed7e263          	bltu	a5,a3,80003526 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003446:	00043737          	lui	a4,0x43
    8000344a:	0ef76063          	bltu	a4,a5,8000352a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000344e:	0c0b8863          	beqz	s7,8000351e <writei+0x10e>
    80003452:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003454:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003458:	5cfd                	li	s9,-1
    8000345a:	a091                	j	8000349e <writei+0x8e>
    8000345c:	02099d93          	slli	s11,s3,0x20
    80003460:	020ddd93          	srli	s11,s11,0x20
    80003464:	05848513          	addi	a0,s1,88
    80003468:	86ee                	mv	a3,s11
    8000346a:	8656                	mv	a2,s5
    8000346c:	85e2                	mv	a1,s8
    8000346e:	953a                	add	a0,a0,a4
    80003470:	ffffe097          	auipc	ra,0xffffe
    80003474:	5aa080e7          	jalr	1450(ra) # 80001a1a <either_copyin>
    80003478:	07950263          	beq	a0,s9,800034dc <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000347c:	8526                	mv	a0,s1
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	790080e7          	jalr	1936(ra) # 80003c0e <log_write>
    brelse(bp);
    80003486:	8526                	mv	a0,s1
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	50a080e7          	jalr	1290(ra) # 80002992 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003490:	01498a3b          	addw	s4,s3,s4
    80003494:	0129893b          	addw	s2,s3,s2
    80003498:	9aee                	add	s5,s5,s11
    8000349a:	057a7663          	bgeu	s4,s7,800034e6 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000349e:	000b2483          	lw	s1,0(s6)
    800034a2:	00a9559b          	srliw	a1,s2,0xa
    800034a6:	855a                	mv	a0,s6
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	7ae080e7          	jalr	1966(ra) # 80002c56 <bmap>
    800034b0:	0005059b          	sext.w	a1,a0
    800034b4:	8526                	mv	a0,s1
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	3ac080e7          	jalr	940(ra) # 80002862 <bread>
    800034be:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034c0:	3ff97713          	andi	a4,s2,1023
    800034c4:	40ed07bb          	subw	a5,s10,a4
    800034c8:	414b86bb          	subw	a3,s7,s4
    800034cc:	89be                	mv	s3,a5
    800034ce:	2781                	sext.w	a5,a5
    800034d0:	0006861b          	sext.w	a2,a3
    800034d4:	f8f674e3          	bgeu	a2,a5,8000345c <writei+0x4c>
    800034d8:	89b6                	mv	s3,a3
    800034da:	b749                	j	8000345c <writei+0x4c>
      brelse(bp);
    800034dc:	8526                	mv	a0,s1
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	4b4080e7          	jalr	1204(ra) # 80002992 <brelse>
  }

  if(off > ip->size)
    800034e6:	04cb2783          	lw	a5,76(s6)
    800034ea:	0127f463          	bgeu	a5,s2,800034f2 <writei+0xe2>
    ip->size = off;
    800034ee:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800034f2:	855a                	mv	a0,s6
    800034f4:	00000097          	auipc	ra,0x0
    800034f8:	aa6080e7          	jalr	-1370(ra) # 80002f9a <iupdate>

  return tot;
    800034fc:	000a051b          	sext.w	a0,s4
}
    80003500:	70a6                	ld	ra,104(sp)
    80003502:	7406                	ld	s0,96(sp)
    80003504:	64e6                	ld	s1,88(sp)
    80003506:	6946                	ld	s2,80(sp)
    80003508:	69a6                	ld	s3,72(sp)
    8000350a:	6a06                	ld	s4,64(sp)
    8000350c:	7ae2                	ld	s5,56(sp)
    8000350e:	7b42                	ld	s6,48(sp)
    80003510:	7ba2                	ld	s7,40(sp)
    80003512:	7c02                	ld	s8,32(sp)
    80003514:	6ce2                	ld	s9,24(sp)
    80003516:	6d42                	ld	s10,16(sp)
    80003518:	6da2                	ld	s11,8(sp)
    8000351a:	6165                	addi	sp,sp,112
    8000351c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000351e:	8a5e                	mv	s4,s7
    80003520:	bfc9                	j	800034f2 <writei+0xe2>
    return -1;
    80003522:	557d                	li	a0,-1
}
    80003524:	8082                	ret
    return -1;
    80003526:	557d                	li	a0,-1
    80003528:	bfe1                	j	80003500 <writei+0xf0>
    return -1;
    8000352a:	557d                	li	a0,-1
    8000352c:	bfd1                	j	80003500 <writei+0xf0>

000000008000352e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000352e:	1141                	addi	sp,sp,-16
    80003530:	e406                	sd	ra,8(sp)
    80003532:	e022                	sd	s0,0(sp)
    80003534:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003536:	4639                	li	a2,14
    80003538:	ffffd097          	auipc	ra,0xffffd
    8000353c:	d18080e7          	jalr	-744(ra) # 80000250 <strncmp>
}
    80003540:	60a2                	ld	ra,8(sp)
    80003542:	6402                	ld	s0,0(sp)
    80003544:	0141                	addi	sp,sp,16
    80003546:	8082                	ret

0000000080003548 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003548:	7139                	addi	sp,sp,-64
    8000354a:	fc06                	sd	ra,56(sp)
    8000354c:	f822                	sd	s0,48(sp)
    8000354e:	f426                	sd	s1,40(sp)
    80003550:	f04a                	sd	s2,32(sp)
    80003552:	ec4e                	sd	s3,24(sp)
    80003554:	e852                	sd	s4,16(sp)
    80003556:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003558:	04451703          	lh	a4,68(a0)
    8000355c:	4785                	li	a5,1
    8000355e:	00f71a63          	bne	a4,a5,80003572 <dirlookup+0x2a>
    80003562:	892a                	mv	s2,a0
    80003564:	89ae                	mv	s3,a1
    80003566:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003568:	457c                	lw	a5,76(a0)
    8000356a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000356c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000356e:	e79d                	bnez	a5,8000359c <dirlookup+0x54>
    80003570:	a8a5                	j	800035e8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003572:	00005517          	auipc	a0,0x5
    80003576:	02650513          	addi	a0,a0,38 # 80008598 <syscalls+0x1e0>
    8000357a:	00003097          	auipc	ra,0x3
    8000357e:	b9e080e7          	jalr	-1122(ra) # 80006118 <panic>
      panic("dirlookup read");
    80003582:	00005517          	auipc	a0,0x5
    80003586:	02e50513          	addi	a0,a0,46 # 800085b0 <syscalls+0x1f8>
    8000358a:	00003097          	auipc	ra,0x3
    8000358e:	b8e080e7          	jalr	-1138(ra) # 80006118 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003592:	24c1                	addiw	s1,s1,16
    80003594:	04c92783          	lw	a5,76(s2)
    80003598:	04f4f763          	bgeu	s1,a5,800035e6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000359c:	4741                	li	a4,16
    8000359e:	86a6                	mv	a3,s1
    800035a0:	fc040613          	addi	a2,s0,-64
    800035a4:	4581                	li	a1,0
    800035a6:	854a                	mv	a0,s2
    800035a8:	00000097          	auipc	ra,0x0
    800035ac:	d70080e7          	jalr	-656(ra) # 80003318 <readi>
    800035b0:	47c1                	li	a5,16
    800035b2:	fcf518e3          	bne	a0,a5,80003582 <dirlookup+0x3a>
    if(de.inum == 0)
    800035b6:	fc045783          	lhu	a5,-64(s0)
    800035ba:	dfe1                	beqz	a5,80003592 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800035bc:	fc240593          	addi	a1,s0,-62
    800035c0:	854e                	mv	a0,s3
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	f6c080e7          	jalr	-148(ra) # 8000352e <namecmp>
    800035ca:	f561                	bnez	a0,80003592 <dirlookup+0x4a>
      if(poff)
    800035cc:	000a0463          	beqz	s4,800035d4 <dirlookup+0x8c>
        *poff = off;
    800035d0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800035d4:	fc045583          	lhu	a1,-64(s0)
    800035d8:	00092503          	lw	a0,0(s2)
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	754080e7          	jalr	1876(ra) # 80002d30 <iget>
    800035e4:	a011                	j	800035e8 <dirlookup+0xa0>
  return 0;
    800035e6:	4501                	li	a0,0
}
    800035e8:	70e2                	ld	ra,56(sp)
    800035ea:	7442                	ld	s0,48(sp)
    800035ec:	74a2                	ld	s1,40(sp)
    800035ee:	7902                	ld	s2,32(sp)
    800035f0:	69e2                	ld	s3,24(sp)
    800035f2:	6a42                	ld	s4,16(sp)
    800035f4:	6121                	addi	sp,sp,64
    800035f6:	8082                	ret

00000000800035f8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800035f8:	711d                	addi	sp,sp,-96
    800035fa:	ec86                	sd	ra,88(sp)
    800035fc:	e8a2                	sd	s0,80(sp)
    800035fe:	e4a6                	sd	s1,72(sp)
    80003600:	e0ca                	sd	s2,64(sp)
    80003602:	fc4e                	sd	s3,56(sp)
    80003604:	f852                	sd	s4,48(sp)
    80003606:	f456                	sd	s5,40(sp)
    80003608:	f05a                	sd	s6,32(sp)
    8000360a:	ec5e                	sd	s7,24(sp)
    8000360c:	e862                	sd	s8,16(sp)
    8000360e:	e466                	sd	s9,8(sp)
    80003610:	1080                	addi	s0,sp,96
    80003612:	84aa                	mv	s1,a0
    80003614:	8b2e                	mv	s6,a1
    80003616:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003618:	00054703          	lbu	a4,0(a0)
    8000361c:	02f00793          	li	a5,47
    80003620:	02f70363          	beq	a4,a5,80003646 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	862080e7          	jalr	-1950(ra) # 80000e86 <myproc>
    8000362c:	15053503          	ld	a0,336(a0)
    80003630:	00000097          	auipc	ra,0x0
    80003634:	9f6080e7          	jalr	-1546(ra) # 80003026 <idup>
    80003638:	89aa                	mv	s3,a0
  while(*path == '/')
    8000363a:	02f00913          	li	s2,47
  len = path - s;
    8000363e:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003640:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003642:	4c05                	li	s8,1
    80003644:	a865                	j	800036fc <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003646:	4585                	li	a1,1
    80003648:	4505                	li	a0,1
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	6e6080e7          	jalr	1766(ra) # 80002d30 <iget>
    80003652:	89aa                	mv	s3,a0
    80003654:	b7dd                	j	8000363a <namex+0x42>
      iunlockput(ip);
    80003656:	854e                	mv	a0,s3
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	c6e080e7          	jalr	-914(ra) # 800032c6 <iunlockput>
      return 0;
    80003660:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003662:	854e                	mv	a0,s3
    80003664:	60e6                	ld	ra,88(sp)
    80003666:	6446                	ld	s0,80(sp)
    80003668:	64a6                	ld	s1,72(sp)
    8000366a:	6906                	ld	s2,64(sp)
    8000366c:	79e2                	ld	s3,56(sp)
    8000366e:	7a42                	ld	s4,48(sp)
    80003670:	7aa2                	ld	s5,40(sp)
    80003672:	7b02                	ld	s6,32(sp)
    80003674:	6be2                	ld	s7,24(sp)
    80003676:	6c42                	ld	s8,16(sp)
    80003678:	6ca2                	ld	s9,8(sp)
    8000367a:	6125                	addi	sp,sp,96
    8000367c:	8082                	ret
      iunlock(ip);
    8000367e:	854e                	mv	a0,s3
    80003680:	00000097          	auipc	ra,0x0
    80003684:	aa6080e7          	jalr	-1370(ra) # 80003126 <iunlock>
      return ip;
    80003688:	bfe9                	j	80003662 <namex+0x6a>
      iunlockput(ip);
    8000368a:	854e                	mv	a0,s3
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	c3a080e7          	jalr	-966(ra) # 800032c6 <iunlockput>
      return 0;
    80003694:	89d2                	mv	s3,s4
    80003696:	b7f1                	j	80003662 <namex+0x6a>
  len = path - s;
    80003698:	40b48633          	sub	a2,s1,a1
    8000369c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800036a0:	094cd463          	bge	s9,s4,80003728 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800036a4:	4639                	li	a2,14
    800036a6:	8556                	mv	a0,s5
    800036a8:	ffffd097          	auipc	ra,0xffffd
    800036ac:	b30080e7          	jalr	-1232(ra) # 800001d8 <memmove>
  while(*path == '/')
    800036b0:	0004c783          	lbu	a5,0(s1)
    800036b4:	01279763          	bne	a5,s2,800036c2 <namex+0xca>
    path++;
    800036b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800036ba:	0004c783          	lbu	a5,0(s1)
    800036be:	ff278de3          	beq	a5,s2,800036b8 <namex+0xc0>
    ilock(ip);
    800036c2:	854e                	mv	a0,s3
    800036c4:	00000097          	auipc	ra,0x0
    800036c8:	9a0080e7          	jalr	-1632(ra) # 80003064 <ilock>
    if(ip->type != T_DIR){
    800036cc:	04499783          	lh	a5,68(s3)
    800036d0:	f98793e3          	bne	a5,s8,80003656 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800036d4:	000b0563          	beqz	s6,800036de <namex+0xe6>
    800036d8:	0004c783          	lbu	a5,0(s1)
    800036dc:	d3cd                	beqz	a5,8000367e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800036de:	865e                	mv	a2,s7
    800036e0:	85d6                	mv	a1,s5
    800036e2:	854e                	mv	a0,s3
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	e64080e7          	jalr	-412(ra) # 80003548 <dirlookup>
    800036ec:	8a2a                	mv	s4,a0
    800036ee:	dd51                	beqz	a0,8000368a <namex+0x92>
    iunlockput(ip);
    800036f0:	854e                	mv	a0,s3
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	bd4080e7          	jalr	-1068(ra) # 800032c6 <iunlockput>
    ip = next;
    800036fa:	89d2                	mv	s3,s4
  while(*path == '/')
    800036fc:	0004c783          	lbu	a5,0(s1)
    80003700:	05279763          	bne	a5,s2,8000374e <namex+0x156>
    path++;
    80003704:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003706:	0004c783          	lbu	a5,0(s1)
    8000370a:	ff278de3          	beq	a5,s2,80003704 <namex+0x10c>
  if(*path == 0)
    8000370e:	c79d                	beqz	a5,8000373c <namex+0x144>
    path++;
    80003710:	85a6                	mv	a1,s1
  len = path - s;
    80003712:	8a5e                	mv	s4,s7
    80003714:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003716:	01278963          	beq	a5,s2,80003728 <namex+0x130>
    8000371a:	dfbd                	beqz	a5,80003698 <namex+0xa0>
    path++;
    8000371c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000371e:	0004c783          	lbu	a5,0(s1)
    80003722:	ff279ce3          	bne	a5,s2,8000371a <namex+0x122>
    80003726:	bf8d                	j	80003698 <namex+0xa0>
    memmove(name, s, len);
    80003728:	2601                	sext.w	a2,a2
    8000372a:	8556                	mv	a0,s5
    8000372c:	ffffd097          	auipc	ra,0xffffd
    80003730:	aac080e7          	jalr	-1364(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003734:	9a56                	add	s4,s4,s5
    80003736:	000a0023          	sb	zero,0(s4)
    8000373a:	bf9d                	j	800036b0 <namex+0xb8>
  if(nameiparent){
    8000373c:	f20b03e3          	beqz	s6,80003662 <namex+0x6a>
    iput(ip);
    80003740:	854e                	mv	a0,s3
    80003742:	00000097          	auipc	ra,0x0
    80003746:	adc080e7          	jalr	-1316(ra) # 8000321e <iput>
    return 0;
    8000374a:	4981                	li	s3,0
    8000374c:	bf19                	j	80003662 <namex+0x6a>
  if(*path == 0)
    8000374e:	d7fd                	beqz	a5,8000373c <namex+0x144>
  while(*path != '/' && *path != 0)
    80003750:	0004c783          	lbu	a5,0(s1)
    80003754:	85a6                	mv	a1,s1
    80003756:	b7d1                	j	8000371a <namex+0x122>

0000000080003758 <dirlink>:
{
    80003758:	7139                	addi	sp,sp,-64
    8000375a:	fc06                	sd	ra,56(sp)
    8000375c:	f822                	sd	s0,48(sp)
    8000375e:	f426                	sd	s1,40(sp)
    80003760:	f04a                	sd	s2,32(sp)
    80003762:	ec4e                	sd	s3,24(sp)
    80003764:	e852                	sd	s4,16(sp)
    80003766:	0080                	addi	s0,sp,64
    80003768:	892a                	mv	s2,a0
    8000376a:	8a2e                	mv	s4,a1
    8000376c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000376e:	4601                	li	a2,0
    80003770:	00000097          	auipc	ra,0x0
    80003774:	dd8080e7          	jalr	-552(ra) # 80003548 <dirlookup>
    80003778:	e93d                	bnez	a0,800037ee <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000377a:	04c92483          	lw	s1,76(s2)
    8000377e:	c49d                	beqz	s1,800037ac <dirlink+0x54>
    80003780:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003782:	4741                	li	a4,16
    80003784:	86a6                	mv	a3,s1
    80003786:	fc040613          	addi	a2,s0,-64
    8000378a:	4581                	li	a1,0
    8000378c:	854a                	mv	a0,s2
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	b8a080e7          	jalr	-1142(ra) # 80003318 <readi>
    80003796:	47c1                	li	a5,16
    80003798:	06f51163          	bne	a0,a5,800037fa <dirlink+0xa2>
    if(de.inum == 0)
    8000379c:	fc045783          	lhu	a5,-64(s0)
    800037a0:	c791                	beqz	a5,800037ac <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037a2:	24c1                	addiw	s1,s1,16
    800037a4:	04c92783          	lw	a5,76(s2)
    800037a8:	fcf4ede3          	bltu	s1,a5,80003782 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800037ac:	4639                	li	a2,14
    800037ae:	85d2                	mv	a1,s4
    800037b0:	fc240513          	addi	a0,s0,-62
    800037b4:	ffffd097          	auipc	ra,0xffffd
    800037b8:	ad8080e7          	jalr	-1320(ra) # 8000028c <strncpy>
  de.inum = inum;
    800037bc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037c0:	4741                	li	a4,16
    800037c2:	86a6                	mv	a3,s1
    800037c4:	fc040613          	addi	a2,s0,-64
    800037c8:	4581                	li	a1,0
    800037ca:	854a                	mv	a0,s2
    800037cc:	00000097          	auipc	ra,0x0
    800037d0:	c44080e7          	jalr	-956(ra) # 80003410 <writei>
    800037d4:	872a                	mv	a4,a0
    800037d6:	47c1                	li	a5,16
  return 0;
    800037d8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037da:	02f71863          	bne	a4,a5,8000380a <dirlink+0xb2>
}
    800037de:	70e2                	ld	ra,56(sp)
    800037e0:	7442                	ld	s0,48(sp)
    800037e2:	74a2                	ld	s1,40(sp)
    800037e4:	7902                	ld	s2,32(sp)
    800037e6:	69e2                	ld	s3,24(sp)
    800037e8:	6a42                	ld	s4,16(sp)
    800037ea:	6121                	addi	sp,sp,64
    800037ec:	8082                	ret
    iput(ip);
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	a30080e7          	jalr	-1488(ra) # 8000321e <iput>
    return -1;
    800037f6:	557d                	li	a0,-1
    800037f8:	b7dd                	j	800037de <dirlink+0x86>
      panic("dirlink read");
    800037fa:	00005517          	auipc	a0,0x5
    800037fe:	dc650513          	addi	a0,a0,-570 # 800085c0 <syscalls+0x208>
    80003802:	00003097          	auipc	ra,0x3
    80003806:	916080e7          	jalr	-1770(ra) # 80006118 <panic>
    panic("dirlink");
    8000380a:	00005517          	auipc	a0,0x5
    8000380e:	ec650513          	addi	a0,a0,-314 # 800086d0 <syscalls+0x318>
    80003812:	00003097          	auipc	ra,0x3
    80003816:	906080e7          	jalr	-1786(ra) # 80006118 <panic>

000000008000381a <namei>:

struct inode*
namei(char *path)
{
    8000381a:	1101                	addi	sp,sp,-32
    8000381c:	ec06                	sd	ra,24(sp)
    8000381e:	e822                	sd	s0,16(sp)
    80003820:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003822:	fe040613          	addi	a2,s0,-32
    80003826:	4581                	li	a1,0
    80003828:	00000097          	auipc	ra,0x0
    8000382c:	dd0080e7          	jalr	-560(ra) # 800035f8 <namex>
}
    80003830:	60e2                	ld	ra,24(sp)
    80003832:	6442                	ld	s0,16(sp)
    80003834:	6105                	addi	sp,sp,32
    80003836:	8082                	ret

0000000080003838 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003838:	1141                	addi	sp,sp,-16
    8000383a:	e406                	sd	ra,8(sp)
    8000383c:	e022                	sd	s0,0(sp)
    8000383e:	0800                	addi	s0,sp,16
    80003840:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003842:	4585                	li	a1,1
    80003844:	00000097          	auipc	ra,0x0
    80003848:	db4080e7          	jalr	-588(ra) # 800035f8 <namex>
}
    8000384c:	60a2                	ld	ra,8(sp)
    8000384e:	6402                	ld	s0,0(sp)
    80003850:	0141                	addi	sp,sp,16
    80003852:	8082                	ret

0000000080003854 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003860:	00016917          	auipc	s2,0x16
    80003864:	ec090913          	addi	s2,s2,-320 # 80019720 <log>
    80003868:	01892583          	lw	a1,24(s2)
    8000386c:	02892503          	lw	a0,40(s2)
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	ff2080e7          	jalr	-14(ra) # 80002862 <bread>
    80003878:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000387a:	02c92683          	lw	a3,44(s2)
    8000387e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003880:	02d05763          	blez	a3,800038ae <write_head+0x5a>
    80003884:	00016797          	auipc	a5,0x16
    80003888:	ecc78793          	addi	a5,a5,-308 # 80019750 <log+0x30>
    8000388c:	05c50713          	addi	a4,a0,92
    80003890:	36fd                	addiw	a3,a3,-1
    80003892:	1682                	slli	a3,a3,0x20
    80003894:	9281                	srli	a3,a3,0x20
    80003896:	068a                	slli	a3,a3,0x2
    80003898:	00016617          	auipc	a2,0x16
    8000389c:	ebc60613          	addi	a2,a2,-324 # 80019754 <log+0x34>
    800038a0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800038a2:	4390                	lw	a2,0(a5)
    800038a4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800038a6:	0791                	addi	a5,a5,4
    800038a8:	0711                	addi	a4,a4,4
    800038aa:	fed79ce3          	bne	a5,a3,800038a2 <write_head+0x4e>
  }
  bwrite(buf);
    800038ae:	8526                	mv	a0,s1
    800038b0:	fffff097          	auipc	ra,0xfffff
    800038b4:	0a4080e7          	jalr	164(ra) # 80002954 <bwrite>
  brelse(buf);
    800038b8:	8526                	mv	a0,s1
    800038ba:	fffff097          	auipc	ra,0xfffff
    800038be:	0d8080e7          	jalr	216(ra) # 80002992 <brelse>
}
    800038c2:	60e2                	ld	ra,24(sp)
    800038c4:	6442                	ld	s0,16(sp)
    800038c6:	64a2                	ld	s1,8(sp)
    800038c8:	6902                	ld	s2,0(sp)
    800038ca:	6105                	addi	sp,sp,32
    800038cc:	8082                	ret

00000000800038ce <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ce:	00016797          	auipc	a5,0x16
    800038d2:	e7e7a783          	lw	a5,-386(a5) # 8001974c <log+0x2c>
    800038d6:	0af05d63          	blez	a5,80003990 <install_trans+0xc2>
{
    800038da:	7139                	addi	sp,sp,-64
    800038dc:	fc06                	sd	ra,56(sp)
    800038de:	f822                	sd	s0,48(sp)
    800038e0:	f426                	sd	s1,40(sp)
    800038e2:	f04a                	sd	s2,32(sp)
    800038e4:	ec4e                	sd	s3,24(sp)
    800038e6:	e852                	sd	s4,16(sp)
    800038e8:	e456                	sd	s5,8(sp)
    800038ea:	e05a                	sd	s6,0(sp)
    800038ec:	0080                	addi	s0,sp,64
    800038ee:	8b2a                	mv	s6,a0
    800038f0:	00016a97          	auipc	s5,0x16
    800038f4:	e60a8a93          	addi	s5,s5,-416 # 80019750 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800038fa:	00016997          	auipc	s3,0x16
    800038fe:	e2698993          	addi	s3,s3,-474 # 80019720 <log>
    80003902:	a035                	j	8000392e <install_trans+0x60>
      bunpin(dbuf);
    80003904:	8526                	mv	a0,s1
    80003906:	fffff097          	auipc	ra,0xfffff
    8000390a:	166080e7          	jalr	358(ra) # 80002a6c <bunpin>
    brelse(lbuf);
    8000390e:	854a                	mv	a0,s2
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	082080e7          	jalr	130(ra) # 80002992 <brelse>
    brelse(dbuf);
    80003918:	8526                	mv	a0,s1
    8000391a:	fffff097          	auipc	ra,0xfffff
    8000391e:	078080e7          	jalr	120(ra) # 80002992 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003922:	2a05                	addiw	s4,s4,1
    80003924:	0a91                	addi	s5,s5,4
    80003926:	02c9a783          	lw	a5,44(s3)
    8000392a:	04fa5963          	bge	s4,a5,8000397c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000392e:	0189a583          	lw	a1,24(s3)
    80003932:	014585bb          	addw	a1,a1,s4
    80003936:	2585                	addiw	a1,a1,1
    80003938:	0289a503          	lw	a0,40(s3)
    8000393c:	fffff097          	auipc	ra,0xfffff
    80003940:	f26080e7          	jalr	-218(ra) # 80002862 <bread>
    80003944:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003946:	000aa583          	lw	a1,0(s5)
    8000394a:	0289a503          	lw	a0,40(s3)
    8000394e:	fffff097          	auipc	ra,0xfffff
    80003952:	f14080e7          	jalr	-236(ra) # 80002862 <bread>
    80003956:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003958:	40000613          	li	a2,1024
    8000395c:	05890593          	addi	a1,s2,88
    80003960:	05850513          	addi	a0,a0,88
    80003964:	ffffd097          	auipc	ra,0xffffd
    80003968:	874080e7          	jalr	-1932(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000396c:	8526                	mv	a0,s1
    8000396e:	fffff097          	auipc	ra,0xfffff
    80003972:	fe6080e7          	jalr	-26(ra) # 80002954 <bwrite>
    if(recovering == 0)
    80003976:	f80b1ce3          	bnez	s6,8000390e <install_trans+0x40>
    8000397a:	b769                	j	80003904 <install_trans+0x36>
}
    8000397c:	70e2                	ld	ra,56(sp)
    8000397e:	7442                	ld	s0,48(sp)
    80003980:	74a2                	ld	s1,40(sp)
    80003982:	7902                	ld	s2,32(sp)
    80003984:	69e2                	ld	s3,24(sp)
    80003986:	6a42                	ld	s4,16(sp)
    80003988:	6aa2                	ld	s5,8(sp)
    8000398a:	6b02                	ld	s6,0(sp)
    8000398c:	6121                	addi	sp,sp,64
    8000398e:	8082                	ret
    80003990:	8082                	ret

0000000080003992 <initlog>:
{
    80003992:	7179                	addi	sp,sp,-48
    80003994:	f406                	sd	ra,40(sp)
    80003996:	f022                	sd	s0,32(sp)
    80003998:	ec26                	sd	s1,24(sp)
    8000399a:	e84a                	sd	s2,16(sp)
    8000399c:	e44e                	sd	s3,8(sp)
    8000399e:	1800                	addi	s0,sp,48
    800039a0:	892a                	mv	s2,a0
    800039a2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800039a4:	00016497          	auipc	s1,0x16
    800039a8:	d7c48493          	addi	s1,s1,-644 # 80019720 <log>
    800039ac:	00005597          	auipc	a1,0x5
    800039b0:	c2458593          	addi	a1,a1,-988 # 800085d0 <syscalls+0x218>
    800039b4:	8526                	mv	a0,s1
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	c1c080e7          	jalr	-996(ra) # 800065d2 <initlock>
  log.start = sb->logstart;
    800039be:	0149a583          	lw	a1,20(s3)
    800039c2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800039c4:	0109a783          	lw	a5,16(s3)
    800039c8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800039ca:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800039ce:	854a                	mv	a0,s2
    800039d0:	fffff097          	auipc	ra,0xfffff
    800039d4:	e92080e7          	jalr	-366(ra) # 80002862 <bread>
  log.lh.n = lh->n;
    800039d8:	4d3c                	lw	a5,88(a0)
    800039da:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800039dc:	02f05563          	blez	a5,80003a06 <initlog+0x74>
    800039e0:	05c50713          	addi	a4,a0,92
    800039e4:	00016697          	auipc	a3,0x16
    800039e8:	d6c68693          	addi	a3,a3,-660 # 80019750 <log+0x30>
    800039ec:	37fd                	addiw	a5,a5,-1
    800039ee:	1782                	slli	a5,a5,0x20
    800039f0:	9381                	srli	a5,a5,0x20
    800039f2:	078a                	slli	a5,a5,0x2
    800039f4:	06050613          	addi	a2,a0,96
    800039f8:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800039fa:	4310                	lw	a2,0(a4)
    800039fc:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800039fe:	0711                	addi	a4,a4,4
    80003a00:	0691                	addi	a3,a3,4
    80003a02:	fef71ce3          	bne	a4,a5,800039fa <initlog+0x68>
  brelse(buf);
    80003a06:	fffff097          	auipc	ra,0xfffff
    80003a0a:	f8c080e7          	jalr	-116(ra) # 80002992 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003a0e:	4505                	li	a0,1
    80003a10:	00000097          	auipc	ra,0x0
    80003a14:	ebe080e7          	jalr	-322(ra) # 800038ce <install_trans>
  log.lh.n = 0;
    80003a18:	00016797          	auipc	a5,0x16
    80003a1c:	d207aa23          	sw	zero,-716(a5) # 8001974c <log+0x2c>
  write_head(); // clear the log
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	e34080e7          	jalr	-460(ra) # 80003854 <write_head>
}
    80003a28:	70a2                	ld	ra,40(sp)
    80003a2a:	7402                	ld	s0,32(sp)
    80003a2c:	64e2                	ld	s1,24(sp)
    80003a2e:	6942                	ld	s2,16(sp)
    80003a30:	69a2                	ld	s3,8(sp)
    80003a32:	6145                	addi	sp,sp,48
    80003a34:	8082                	ret

0000000080003a36 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003a36:	1101                	addi	sp,sp,-32
    80003a38:	ec06                	sd	ra,24(sp)
    80003a3a:	e822                	sd	s0,16(sp)
    80003a3c:	e426                	sd	s1,8(sp)
    80003a3e:	e04a                	sd	s2,0(sp)
    80003a40:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003a42:	00016517          	auipc	a0,0x16
    80003a46:	cde50513          	addi	a0,a0,-802 # 80019720 <log>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	c18080e7          	jalr	-1000(ra) # 80006662 <acquire>
  while(1){
    if(log.committing){
    80003a52:	00016497          	auipc	s1,0x16
    80003a56:	cce48493          	addi	s1,s1,-818 # 80019720 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a5a:	4979                	li	s2,30
    80003a5c:	a039                	j	80003a6a <begin_op+0x34>
      sleep(&log, &log.lock);
    80003a5e:	85a6                	mv	a1,s1
    80003a60:	8526                	mv	a0,s1
    80003a62:	ffffe097          	auipc	ra,0xffffe
    80003a66:	b5a080e7          	jalr	-1190(ra) # 800015bc <sleep>
    if(log.committing){
    80003a6a:	50dc                	lw	a5,36(s1)
    80003a6c:	fbed                	bnez	a5,80003a5e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a6e:	509c                	lw	a5,32(s1)
    80003a70:	0017871b          	addiw	a4,a5,1
    80003a74:	0007069b          	sext.w	a3,a4
    80003a78:	0027179b          	slliw	a5,a4,0x2
    80003a7c:	9fb9                	addw	a5,a5,a4
    80003a7e:	0017979b          	slliw	a5,a5,0x1
    80003a82:	54d8                	lw	a4,44(s1)
    80003a84:	9fb9                	addw	a5,a5,a4
    80003a86:	00f95963          	bge	s2,a5,80003a98 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003a8a:	85a6                	mv	a1,s1
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	ffffe097          	auipc	ra,0xffffe
    80003a92:	b2e080e7          	jalr	-1234(ra) # 800015bc <sleep>
    80003a96:	bfd1                	j	80003a6a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003a98:	00016517          	auipc	a0,0x16
    80003a9c:	c8850513          	addi	a0,a0,-888 # 80019720 <log>
    80003aa0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	c74080e7          	jalr	-908(ra) # 80006716 <release>
      break;
    }
  }
}
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6902                	ld	s2,0(sp)
    80003ab2:	6105                	addi	sp,sp,32
    80003ab4:	8082                	ret

0000000080003ab6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003ab6:	7139                	addi	sp,sp,-64
    80003ab8:	fc06                	sd	ra,56(sp)
    80003aba:	f822                	sd	s0,48(sp)
    80003abc:	f426                	sd	s1,40(sp)
    80003abe:	f04a                	sd	s2,32(sp)
    80003ac0:	ec4e                	sd	s3,24(sp)
    80003ac2:	e852                	sd	s4,16(sp)
    80003ac4:	e456                	sd	s5,8(sp)
    80003ac6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003ac8:	00016497          	auipc	s1,0x16
    80003acc:	c5848493          	addi	s1,s1,-936 # 80019720 <log>
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	b90080e7          	jalr	-1136(ra) # 80006662 <acquire>
  log.outstanding -= 1;
    80003ada:	509c                	lw	a5,32(s1)
    80003adc:	37fd                	addiw	a5,a5,-1
    80003ade:	0007891b          	sext.w	s2,a5
    80003ae2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003ae4:	50dc                	lw	a5,36(s1)
    80003ae6:	efb9                	bnez	a5,80003b44 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ae8:	06091663          	bnez	s2,80003b54 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003aec:	00016497          	auipc	s1,0x16
    80003af0:	c3448493          	addi	s1,s1,-972 # 80019720 <log>
    80003af4:	4785                	li	a5,1
    80003af6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003af8:	8526                	mv	a0,s1
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	c1c080e7          	jalr	-996(ra) # 80006716 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b02:	54dc                	lw	a5,44(s1)
    80003b04:	06f04763          	bgtz	a5,80003b72 <end_op+0xbc>
    acquire(&log.lock);
    80003b08:	00016497          	auipc	s1,0x16
    80003b0c:	c1848493          	addi	s1,s1,-1000 # 80019720 <log>
    80003b10:	8526                	mv	a0,s1
    80003b12:	00003097          	auipc	ra,0x3
    80003b16:	b50080e7          	jalr	-1200(ra) # 80006662 <acquire>
    log.committing = 0;
    80003b1a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b1e:	8526                	mv	a0,s1
    80003b20:	ffffe097          	auipc	ra,0xffffe
    80003b24:	c28080e7          	jalr	-984(ra) # 80001748 <wakeup>
    release(&log.lock);
    80003b28:	8526                	mv	a0,s1
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	bec080e7          	jalr	-1044(ra) # 80006716 <release>
}
    80003b32:	70e2                	ld	ra,56(sp)
    80003b34:	7442                	ld	s0,48(sp)
    80003b36:	74a2                	ld	s1,40(sp)
    80003b38:	7902                	ld	s2,32(sp)
    80003b3a:	69e2                	ld	s3,24(sp)
    80003b3c:	6a42                	ld	s4,16(sp)
    80003b3e:	6aa2                	ld	s5,8(sp)
    80003b40:	6121                	addi	sp,sp,64
    80003b42:	8082                	ret
    panic("log.committing");
    80003b44:	00005517          	auipc	a0,0x5
    80003b48:	a9450513          	addi	a0,a0,-1388 # 800085d8 <syscalls+0x220>
    80003b4c:	00002097          	auipc	ra,0x2
    80003b50:	5cc080e7          	jalr	1484(ra) # 80006118 <panic>
    wakeup(&log);
    80003b54:	00016497          	auipc	s1,0x16
    80003b58:	bcc48493          	addi	s1,s1,-1076 # 80019720 <log>
    80003b5c:	8526                	mv	a0,s1
    80003b5e:	ffffe097          	auipc	ra,0xffffe
    80003b62:	bea080e7          	jalr	-1046(ra) # 80001748 <wakeup>
  release(&log.lock);
    80003b66:	8526                	mv	a0,s1
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	bae080e7          	jalr	-1106(ra) # 80006716 <release>
  if(do_commit){
    80003b70:	b7c9                	j	80003b32 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b72:	00016a97          	auipc	s5,0x16
    80003b76:	bdea8a93          	addi	s5,s5,-1058 # 80019750 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003b7a:	00016a17          	auipc	s4,0x16
    80003b7e:	ba6a0a13          	addi	s4,s4,-1114 # 80019720 <log>
    80003b82:	018a2583          	lw	a1,24(s4)
    80003b86:	012585bb          	addw	a1,a1,s2
    80003b8a:	2585                	addiw	a1,a1,1
    80003b8c:	028a2503          	lw	a0,40(s4)
    80003b90:	fffff097          	auipc	ra,0xfffff
    80003b94:	cd2080e7          	jalr	-814(ra) # 80002862 <bread>
    80003b98:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003b9a:	000aa583          	lw	a1,0(s5)
    80003b9e:	028a2503          	lw	a0,40(s4)
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	cc0080e7          	jalr	-832(ra) # 80002862 <bread>
    80003baa:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003bac:	40000613          	li	a2,1024
    80003bb0:	05850593          	addi	a1,a0,88
    80003bb4:	05848513          	addi	a0,s1,88
    80003bb8:	ffffc097          	auipc	ra,0xffffc
    80003bbc:	620080e7          	jalr	1568(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	d92080e7          	jalr	-622(ra) # 80002954 <bwrite>
    brelse(from);
    80003bca:	854e                	mv	a0,s3
    80003bcc:	fffff097          	auipc	ra,0xfffff
    80003bd0:	dc6080e7          	jalr	-570(ra) # 80002992 <brelse>
    brelse(to);
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	dbc080e7          	jalr	-580(ra) # 80002992 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bde:	2905                	addiw	s2,s2,1
    80003be0:	0a91                	addi	s5,s5,4
    80003be2:	02ca2783          	lw	a5,44(s4)
    80003be6:	f8f94ee3          	blt	s2,a5,80003b82 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003bea:	00000097          	auipc	ra,0x0
    80003bee:	c6a080e7          	jalr	-918(ra) # 80003854 <write_head>
    install_trans(0); // Now install writes to home locations
    80003bf2:	4501                	li	a0,0
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	cda080e7          	jalr	-806(ra) # 800038ce <install_trans>
    log.lh.n = 0;
    80003bfc:	00016797          	auipc	a5,0x16
    80003c00:	b407a823          	sw	zero,-1200(a5) # 8001974c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	c50080e7          	jalr	-944(ra) # 80003854 <write_head>
    80003c0c:	bdf5                	j	80003b08 <end_op+0x52>

0000000080003c0e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c0e:	1101                	addi	sp,sp,-32
    80003c10:	ec06                	sd	ra,24(sp)
    80003c12:	e822                	sd	s0,16(sp)
    80003c14:	e426                	sd	s1,8(sp)
    80003c16:	e04a                	sd	s2,0(sp)
    80003c18:	1000                	addi	s0,sp,32
    80003c1a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c1c:	00016917          	auipc	s2,0x16
    80003c20:	b0490913          	addi	s2,s2,-1276 # 80019720 <log>
    80003c24:	854a                	mv	a0,s2
    80003c26:	00003097          	auipc	ra,0x3
    80003c2a:	a3c080e7          	jalr	-1476(ra) # 80006662 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c2e:	02c92603          	lw	a2,44(s2)
    80003c32:	47f5                	li	a5,29
    80003c34:	06c7c563          	blt	a5,a2,80003c9e <log_write+0x90>
    80003c38:	00016797          	auipc	a5,0x16
    80003c3c:	b047a783          	lw	a5,-1276(a5) # 8001973c <log+0x1c>
    80003c40:	37fd                	addiw	a5,a5,-1
    80003c42:	04f65e63          	bge	a2,a5,80003c9e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003c46:	00016797          	auipc	a5,0x16
    80003c4a:	afa7a783          	lw	a5,-1286(a5) # 80019740 <log+0x20>
    80003c4e:	06f05063          	blez	a5,80003cae <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c52:	4781                	li	a5,0
    80003c54:	06c05563          	blez	a2,80003cbe <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c58:	44cc                	lw	a1,12(s1)
    80003c5a:	00016717          	auipc	a4,0x16
    80003c5e:	af670713          	addi	a4,a4,-1290 # 80019750 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003c62:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c64:	4314                	lw	a3,0(a4)
    80003c66:	04b68c63          	beq	a3,a1,80003cbe <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003c6a:	2785                	addiw	a5,a5,1
    80003c6c:	0711                	addi	a4,a4,4
    80003c6e:	fef61be3          	bne	a2,a5,80003c64 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003c72:	0621                	addi	a2,a2,8
    80003c74:	060a                	slli	a2,a2,0x2
    80003c76:	00016797          	auipc	a5,0x16
    80003c7a:	aaa78793          	addi	a5,a5,-1366 # 80019720 <log>
    80003c7e:	963e                	add	a2,a2,a5
    80003c80:	44dc                	lw	a5,12(s1)
    80003c82:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003c84:	8526                	mv	a0,s1
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	daa080e7          	jalr	-598(ra) # 80002a30 <bpin>
    log.lh.n++;
    80003c8e:	00016717          	auipc	a4,0x16
    80003c92:	a9270713          	addi	a4,a4,-1390 # 80019720 <log>
    80003c96:	575c                	lw	a5,44(a4)
    80003c98:	2785                	addiw	a5,a5,1
    80003c9a:	d75c                	sw	a5,44(a4)
    80003c9c:	a835                	j	80003cd8 <log_write+0xca>
    panic("too big a transaction");
    80003c9e:	00005517          	auipc	a0,0x5
    80003ca2:	94a50513          	addi	a0,a0,-1718 # 800085e8 <syscalls+0x230>
    80003ca6:	00002097          	auipc	ra,0x2
    80003caa:	472080e7          	jalr	1138(ra) # 80006118 <panic>
    panic("log_write outside of trans");
    80003cae:	00005517          	auipc	a0,0x5
    80003cb2:	95250513          	addi	a0,a0,-1710 # 80008600 <syscalls+0x248>
    80003cb6:	00002097          	auipc	ra,0x2
    80003cba:	462080e7          	jalr	1122(ra) # 80006118 <panic>
  log.lh.block[i] = b->blockno;
    80003cbe:	00878713          	addi	a4,a5,8
    80003cc2:	00271693          	slli	a3,a4,0x2
    80003cc6:	00016717          	auipc	a4,0x16
    80003cca:	a5a70713          	addi	a4,a4,-1446 # 80019720 <log>
    80003cce:	9736                	add	a4,a4,a3
    80003cd0:	44d4                	lw	a3,12(s1)
    80003cd2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003cd4:	faf608e3          	beq	a2,a5,80003c84 <log_write+0x76>
  }
  release(&log.lock);
    80003cd8:	00016517          	auipc	a0,0x16
    80003cdc:	a4850513          	addi	a0,a0,-1464 # 80019720 <log>
    80003ce0:	00003097          	auipc	ra,0x3
    80003ce4:	a36080e7          	jalr	-1482(ra) # 80006716 <release>
}
    80003ce8:	60e2                	ld	ra,24(sp)
    80003cea:	6442                	ld	s0,16(sp)
    80003cec:	64a2                	ld	s1,8(sp)
    80003cee:	6902                	ld	s2,0(sp)
    80003cf0:	6105                	addi	sp,sp,32
    80003cf2:	8082                	ret

0000000080003cf4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003cf4:	1101                	addi	sp,sp,-32
    80003cf6:	ec06                	sd	ra,24(sp)
    80003cf8:	e822                	sd	s0,16(sp)
    80003cfa:	e426                	sd	s1,8(sp)
    80003cfc:	e04a                	sd	s2,0(sp)
    80003cfe:	1000                	addi	s0,sp,32
    80003d00:	84aa                	mv	s1,a0
    80003d02:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d04:	00005597          	auipc	a1,0x5
    80003d08:	91c58593          	addi	a1,a1,-1764 # 80008620 <syscalls+0x268>
    80003d0c:	0521                	addi	a0,a0,8
    80003d0e:	00003097          	auipc	ra,0x3
    80003d12:	8c4080e7          	jalr	-1852(ra) # 800065d2 <initlock>
  lk->name = name;
    80003d16:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003d1a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d1e:	0204a423          	sw	zero,40(s1)
}
    80003d22:	60e2                	ld	ra,24(sp)
    80003d24:	6442                	ld	s0,16(sp)
    80003d26:	64a2                	ld	s1,8(sp)
    80003d28:	6902                	ld	s2,0(sp)
    80003d2a:	6105                	addi	sp,sp,32
    80003d2c:	8082                	ret

0000000080003d2e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d2e:	1101                	addi	sp,sp,-32
    80003d30:	ec06                	sd	ra,24(sp)
    80003d32:	e822                	sd	s0,16(sp)
    80003d34:	e426                	sd	s1,8(sp)
    80003d36:	e04a                	sd	s2,0(sp)
    80003d38:	1000                	addi	s0,sp,32
    80003d3a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d3c:	00850913          	addi	s2,a0,8
    80003d40:	854a                	mv	a0,s2
    80003d42:	00003097          	auipc	ra,0x3
    80003d46:	920080e7          	jalr	-1760(ra) # 80006662 <acquire>
  while (lk->locked) {
    80003d4a:	409c                	lw	a5,0(s1)
    80003d4c:	cb89                	beqz	a5,80003d5e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003d4e:	85ca                	mv	a1,s2
    80003d50:	8526                	mv	a0,s1
    80003d52:	ffffe097          	auipc	ra,0xffffe
    80003d56:	86a080e7          	jalr	-1942(ra) # 800015bc <sleep>
  while (lk->locked) {
    80003d5a:	409c                	lw	a5,0(s1)
    80003d5c:	fbed                	bnez	a5,80003d4e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003d5e:	4785                	li	a5,1
    80003d60:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	124080e7          	jalr	292(ra) # 80000e86 <myproc>
    80003d6a:	591c                	lw	a5,48(a0)
    80003d6c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d6e:	854a                	mv	a0,s2
    80003d70:	00003097          	auipc	ra,0x3
    80003d74:	9a6080e7          	jalr	-1626(ra) # 80006716 <release>
}
    80003d78:	60e2                	ld	ra,24(sp)
    80003d7a:	6442                	ld	s0,16(sp)
    80003d7c:	64a2                	ld	s1,8(sp)
    80003d7e:	6902                	ld	s2,0(sp)
    80003d80:	6105                	addi	sp,sp,32
    80003d82:	8082                	ret

0000000080003d84 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d84:	1101                	addi	sp,sp,-32
    80003d86:	ec06                	sd	ra,24(sp)
    80003d88:	e822                	sd	s0,16(sp)
    80003d8a:	e426                	sd	s1,8(sp)
    80003d8c:	e04a                	sd	s2,0(sp)
    80003d8e:	1000                	addi	s0,sp,32
    80003d90:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d92:	00850913          	addi	s2,a0,8
    80003d96:	854a                	mv	a0,s2
    80003d98:	00003097          	auipc	ra,0x3
    80003d9c:	8ca080e7          	jalr	-1846(ra) # 80006662 <acquire>
  lk->locked = 0;
    80003da0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003da4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003da8:	8526                	mv	a0,s1
    80003daa:	ffffe097          	auipc	ra,0xffffe
    80003dae:	99e080e7          	jalr	-1634(ra) # 80001748 <wakeup>
  release(&lk->lk);
    80003db2:	854a                	mv	a0,s2
    80003db4:	00003097          	auipc	ra,0x3
    80003db8:	962080e7          	jalr	-1694(ra) # 80006716 <release>
}
    80003dbc:	60e2                	ld	ra,24(sp)
    80003dbe:	6442                	ld	s0,16(sp)
    80003dc0:	64a2                	ld	s1,8(sp)
    80003dc2:	6902                	ld	s2,0(sp)
    80003dc4:	6105                	addi	sp,sp,32
    80003dc6:	8082                	ret

0000000080003dc8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003dc8:	7179                	addi	sp,sp,-48
    80003dca:	f406                	sd	ra,40(sp)
    80003dcc:	f022                	sd	s0,32(sp)
    80003dce:	ec26                	sd	s1,24(sp)
    80003dd0:	e84a                	sd	s2,16(sp)
    80003dd2:	e44e                	sd	s3,8(sp)
    80003dd4:	1800                	addi	s0,sp,48
    80003dd6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003dd8:	00850913          	addi	s2,a0,8
    80003ddc:	854a                	mv	a0,s2
    80003dde:	00003097          	auipc	ra,0x3
    80003de2:	884080e7          	jalr	-1916(ra) # 80006662 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003de6:	409c                	lw	a5,0(s1)
    80003de8:	ef99                	bnez	a5,80003e06 <holdingsleep+0x3e>
    80003dea:	4481                	li	s1,0
  release(&lk->lk);
    80003dec:	854a                	mv	a0,s2
    80003dee:	00003097          	auipc	ra,0x3
    80003df2:	928080e7          	jalr	-1752(ra) # 80006716 <release>
  return r;
}
    80003df6:	8526                	mv	a0,s1
    80003df8:	70a2                	ld	ra,40(sp)
    80003dfa:	7402                	ld	s0,32(sp)
    80003dfc:	64e2                	ld	s1,24(sp)
    80003dfe:	6942                	ld	s2,16(sp)
    80003e00:	69a2                	ld	s3,8(sp)
    80003e02:	6145                	addi	sp,sp,48
    80003e04:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e06:	0284a983          	lw	s3,40(s1)
    80003e0a:	ffffd097          	auipc	ra,0xffffd
    80003e0e:	07c080e7          	jalr	124(ra) # 80000e86 <myproc>
    80003e12:	5904                	lw	s1,48(a0)
    80003e14:	413484b3          	sub	s1,s1,s3
    80003e18:	0014b493          	seqz	s1,s1
    80003e1c:	bfc1                	j	80003dec <holdingsleep+0x24>

0000000080003e1e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e1e:	1141                	addi	sp,sp,-16
    80003e20:	e406                	sd	ra,8(sp)
    80003e22:	e022                	sd	s0,0(sp)
    80003e24:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e26:	00005597          	auipc	a1,0x5
    80003e2a:	80a58593          	addi	a1,a1,-2038 # 80008630 <syscalls+0x278>
    80003e2e:	00016517          	auipc	a0,0x16
    80003e32:	a3a50513          	addi	a0,a0,-1478 # 80019868 <ftable>
    80003e36:	00002097          	auipc	ra,0x2
    80003e3a:	79c080e7          	jalr	1948(ra) # 800065d2 <initlock>
}
    80003e3e:	60a2                	ld	ra,8(sp)
    80003e40:	6402                	ld	s0,0(sp)
    80003e42:	0141                	addi	sp,sp,16
    80003e44:	8082                	ret

0000000080003e46 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003e46:	1101                	addi	sp,sp,-32
    80003e48:	ec06                	sd	ra,24(sp)
    80003e4a:	e822                	sd	s0,16(sp)
    80003e4c:	e426                	sd	s1,8(sp)
    80003e4e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003e50:	00016517          	auipc	a0,0x16
    80003e54:	a1850513          	addi	a0,a0,-1512 # 80019868 <ftable>
    80003e58:	00003097          	auipc	ra,0x3
    80003e5c:	80a080e7          	jalr	-2038(ra) # 80006662 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e60:	00016497          	auipc	s1,0x16
    80003e64:	a2048493          	addi	s1,s1,-1504 # 80019880 <ftable+0x18>
    80003e68:	00017717          	auipc	a4,0x17
    80003e6c:	9b870713          	addi	a4,a4,-1608 # 8001a820 <ftable+0xfb8>
    if(f->ref == 0){
    80003e70:	40dc                	lw	a5,4(s1)
    80003e72:	cf99                	beqz	a5,80003e90 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e74:	02848493          	addi	s1,s1,40
    80003e78:	fee49ce3          	bne	s1,a4,80003e70 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e7c:	00016517          	auipc	a0,0x16
    80003e80:	9ec50513          	addi	a0,a0,-1556 # 80019868 <ftable>
    80003e84:	00003097          	auipc	ra,0x3
    80003e88:	892080e7          	jalr	-1902(ra) # 80006716 <release>
  return 0;
    80003e8c:	4481                	li	s1,0
    80003e8e:	a819                	j	80003ea4 <filealloc+0x5e>
      f->ref = 1;
    80003e90:	4785                	li	a5,1
    80003e92:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e94:	00016517          	auipc	a0,0x16
    80003e98:	9d450513          	addi	a0,a0,-1580 # 80019868 <ftable>
    80003e9c:	00003097          	auipc	ra,0x3
    80003ea0:	87a080e7          	jalr	-1926(ra) # 80006716 <release>
}
    80003ea4:	8526                	mv	a0,s1
    80003ea6:	60e2                	ld	ra,24(sp)
    80003ea8:	6442                	ld	s0,16(sp)
    80003eaa:	64a2                	ld	s1,8(sp)
    80003eac:	6105                	addi	sp,sp,32
    80003eae:	8082                	ret

0000000080003eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003eb0:	1101                	addi	sp,sp,-32
    80003eb2:	ec06                	sd	ra,24(sp)
    80003eb4:	e822                	sd	s0,16(sp)
    80003eb6:	e426                	sd	s1,8(sp)
    80003eb8:	1000                	addi	s0,sp,32
    80003eba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ebc:	00016517          	auipc	a0,0x16
    80003ec0:	9ac50513          	addi	a0,a0,-1620 # 80019868 <ftable>
    80003ec4:	00002097          	auipc	ra,0x2
    80003ec8:	79e080e7          	jalr	1950(ra) # 80006662 <acquire>
  if(f->ref < 1)
    80003ecc:	40dc                	lw	a5,4(s1)
    80003ece:	02f05263          	blez	a5,80003ef2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ed2:	2785                	addiw	a5,a5,1
    80003ed4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ed6:	00016517          	auipc	a0,0x16
    80003eda:	99250513          	addi	a0,a0,-1646 # 80019868 <ftable>
    80003ede:	00003097          	auipc	ra,0x3
    80003ee2:	838080e7          	jalr	-1992(ra) # 80006716 <release>
  return f;
}
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	60e2                	ld	ra,24(sp)
    80003eea:	6442                	ld	s0,16(sp)
    80003eec:	64a2                	ld	s1,8(sp)
    80003eee:	6105                	addi	sp,sp,32
    80003ef0:	8082                	ret
    panic("filedup");
    80003ef2:	00004517          	auipc	a0,0x4
    80003ef6:	74650513          	addi	a0,a0,1862 # 80008638 <syscalls+0x280>
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	21e080e7          	jalr	542(ra) # 80006118 <panic>

0000000080003f02 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f02:	7139                	addi	sp,sp,-64
    80003f04:	fc06                	sd	ra,56(sp)
    80003f06:	f822                	sd	s0,48(sp)
    80003f08:	f426                	sd	s1,40(sp)
    80003f0a:	f04a                	sd	s2,32(sp)
    80003f0c:	ec4e                	sd	s3,24(sp)
    80003f0e:	e852                	sd	s4,16(sp)
    80003f10:	e456                	sd	s5,8(sp)
    80003f12:	0080                	addi	s0,sp,64
    80003f14:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003f16:	00016517          	auipc	a0,0x16
    80003f1a:	95250513          	addi	a0,a0,-1710 # 80019868 <ftable>
    80003f1e:	00002097          	auipc	ra,0x2
    80003f22:	744080e7          	jalr	1860(ra) # 80006662 <acquire>
  if(f->ref < 1)
    80003f26:	40dc                	lw	a5,4(s1)
    80003f28:	06f05163          	blez	a5,80003f8a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003f2c:	37fd                	addiw	a5,a5,-1
    80003f2e:	0007871b          	sext.w	a4,a5
    80003f32:	c0dc                	sw	a5,4(s1)
    80003f34:	06e04363          	bgtz	a4,80003f9a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f38:	0004a903          	lw	s2,0(s1)
    80003f3c:	0094ca83          	lbu	s5,9(s1)
    80003f40:	0104ba03          	ld	s4,16(s1)
    80003f44:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003f48:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003f4c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003f50:	00016517          	auipc	a0,0x16
    80003f54:	91850513          	addi	a0,a0,-1768 # 80019868 <ftable>
    80003f58:	00002097          	auipc	ra,0x2
    80003f5c:	7be080e7          	jalr	1982(ra) # 80006716 <release>

  if(ff.type == FD_PIPE){
    80003f60:	4785                	li	a5,1
    80003f62:	04f90d63          	beq	s2,a5,80003fbc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003f66:	3979                	addiw	s2,s2,-2
    80003f68:	4785                	li	a5,1
    80003f6a:	0527e063          	bltu	a5,s2,80003faa <fileclose+0xa8>
    begin_op();
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	ac8080e7          	jalr	-1336(ra) # 80003a36 <begin_op>
    iput(ff.ip);
    80003f76:	854e                	mv	a0,s3
    80003f78:	fffff097          	auipc	ra,0xfffff
    80003f7c:	2a6080e7          	jalr	678(ra) # 8000321e <iput>
    end_op();
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	b36080e7          	jalr	-1226(ra) # 80003ab6 <end_op>
    80003f88:	a00d                	j	80003faa <fileclose+0xa8>
    panic("fileclose");
    80003f8a:	00004517          	auipc	a0,0x4
    80003f8e:	6b650513          	addi	a0,a0,1718 # 80008640 <syscalls+0x288>
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	186080e7          	jalr	390(ra) # 80006118 <panic>
    release(&ftable.lock);
    80003f9a:	00016517          	auipc	a0,0x16
    80003f9e:	8ce50513          	addi	a0,a0,-1842 # 80019868 <ftable>
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	774080e7          	jalr	1908(ra) # 80006716 <release>
  }
}
    80003faa:	70e2                	ld	ra,56(sp)
    80003fac:	7442                	ld	s0,48(sp)
    80003fae:	74a2                	ld	s1,40(sp)
    80003fb0:	7902                	ld	s2,32(sp)
    80003fb2:	69e2                	ld	s3,24(sp)
    80003fb4:	6a42                	ld	s4,16(sp)
    80003fb6:	6aa2                	ld	s5,8(sp)
    80003fb8:	6121                	addi	sp,sp,64
    80003fba:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003fbc:	85d6                	mv	a1,s5
    80003fbe:	8552                	mv	a0,s4
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	34c080e7          	jalr	844(ra) # 8000430c <pipeclose>
    80003fc8:	b7cd                	j	80003faa <fileclose+0xa8>

0000000080003fca <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003fca:	715d                	addi	sp,sp,-80
    80003fcc:	e486                	sd	ra,72(sp)
    80003fce:	e0a2                	sd	s0,64(sp)
    80003fd0:	fc26                	sd	s1,56(sp)
    80003fd2:	f84a                	sd	s2,48(sp)
    80003fd4:	f44e                	sd	s3,40(sp)
    80003fd6:	0880                	addi	s0,sp,80
    80003fd8:	84aa                	mv	s1,a0
    80003fda:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	eaa080e7          	jalr	-342(ra) # 80000e86 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003fe4:	409c                	lw	a5,0(s1)
    80003fe6:	37f9                	addiw	a5,a5,-2
    80003fe8:	4705                	li	a4,1
    80003fea:	04f76763          	bltu	a4,a5,80004038 <filestat+0x6e>
    80003fee:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ff0:	6c88                	ld	a0,24(s1)
    80003ff2:	fffff097          	auipc	ra,0xfffff
    80003ff6:	072080e7          	jalr	114(ra) # 80003064 <ilock>
    stati(f->ip, &st);
    80003ffa:	fb840593          	addi	a1,s0,-72
    80003ffe:	6c88                	ld	a0,24(s1)
    80004000:	fffff097          	auipc	ra,0xfffff
    80004004:	2ee080e7          	jalr	750(ra) # 800032ee <stati>
    iunlock(f->ip);
    80004008:	6c88                	ld	a0,24(s1)
    8000400a:	fffff097          	auipc	ra,0xfffff
    8000400e:	11c080e7          	jalr	284(ra) # 80003126 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004012:	46e1                	li	a3,24
    80004014:	fb840613          	addi	a2,s0,-72
    80004018:	85ce                	mv	a1,s3
    8000401a:	05093503          	ld	a0,80(s2)
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	abc080e7          	jalr	-1348(ra) # 80000ada <copyout>
    80004026:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000402a:	60a6                	ld	ra,72(sp)
    8000402c:	6406                	ld	s0,64(sp)
    8000402e:	74e2                	ld	s1,56(sp)
    80004030:	7942                	ld	s2,48(sp)
    80004032:	79a2                	ld	s3,40(sp)
    80004034:	6161                	addi	sp,sp,80
    80004036:	8082                	ret
  return -1;
    80004038:	557d                	li	a0,-1
    8000403a:	bfc5                	j	8000402a <filestat+0x60>

000000008000403c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000403c:	7179                	addi	sp,sp,-48
    8000403e:	f406                	sd	ra,40(sp)
    80004040:	f022                	sd	s0,32(sp)
    80004042:	ec26                	sd	s1,24(sp)
    80004044:	e84a                	sd	s2,16(sp)
    80004046:	e44e                	sd	s3,8(sp)
    80004048:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000404a:	00854783          	lbu	a5,8(a0)
    8000404e:	c3d5                	beqz	a5,800040f2 <fileread+0xb6>
    80004050:	84aa                	mv	s1,a0
    80004052:	89ae                	mv	s3,a1
    80004054:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004056:	411c                	lw	a5,0(a0)
    80004058:	4705                	li	a4,1
    8000405a:	04e78963          	beq	a5,a4,800040ac <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000405e:	470d                	li	a4,3
    80004060:	04e78d63          	beq	a5,a4,800040ba <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004064:	4709                	li	a4,2
    80004066:	06e79e63          	bne	a5,a4,800040e2 <fileread+0xa6>
    ilock(f->ip);
    8000406a:	6d08                	ld	a0,24(a0)
    8000406c:	fffff097          	auipc	ra,0xfffff
    80004070:	ff8080e7          	jalr	-8(ra) # 80003064 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004074:	874a                	mv	a4,s2
    80004076:	5094                	lw	a3,32(s1)
    80004078:	864e                	mv	a2,s3
    8000407a:	4585                	li	a1,1
    8000407c:	6c88                	ld	a0,24(s1)
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	29a080e7          	jalr	666(ra) # 80003318 <readi>
    80004086:	892a                	mv	s2,a0
    80004088:	00a05563          	blez	a0,80004092 <fileread+0x56>
      f->off += r;
    8000408c:	509c                	lw	a5,32(s1)
    8000408e:	9fa9                	addw	a5,a5,a0
    80004090:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004092:	6c88                	ld	a0,24(s1)
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	092080e7          	jalr	146(ra) # 80003126 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000409c:	854a                	mv	a0,s2
    8000409e:	70a2                	ld	ra,40(sp)
    800040a0:	7402                	ld	s0,32(sp)
    800040a2:	64e2                	ld	s1,24(sp)
    800040a4:	6942                	ld	s2,16(sp)
    800040a6:	69a2                	ld	s3,8(sp)
    800040a8:	6145                	addi	sp,sp,48
    800040aa:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800040ac:	6908                	ld	a0,16(a0)
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	3c8080e7          	jalr	968(ra) # 80004476 <piperead>
    800040b6:	892a                	mv	s2,a0
    800040b8:	b7d5                	j	8000409c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800040ba:	02451783          	lh	a5,36(a0)
    800040be:	03079693          	slli	a3,a5,0x30
    800040c2:	92c1                	srli	a3,a3,0x30
    800040c4:	4725                	li	a4,9
    800040c6:	02d76863          	bltu	a4,a3,800040f6 <fileread+0xba>
    800040ca:	0792                	slli	a5,a5,0x4
    800040cc:	00015717          	auipc	a4,0x15
    800040d0:	6fc70713          	addi	a4,a4,1788 # 800197c8 <devsw>
    800040d4:	97ba                	add	a5,a5,a4
    800040d6:	639c                	ld	a5,0(a5)
    800040d8:	c38d                	beqz	a5,800040fa <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800040da:	4505                	li	a0,1
    800040dc:	9782                	jalr	a5
    800040de:	892a                	mv	s2,a0
    800040e0:	bf75                	j	8000409c <fileread+0x60>
    panic("fileread");
    800040e2:	00004517          	auipc	a0,0x4
    800040e6:	56e50513          	addi	a0,a0,1390 # 80008650 <syscalls+0x298>
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	02e080e7          	jalr	46(ra) # 80006118 <panic>
    return -1;
    800040f2:	597d                	li	s2,-1
    800040f4:	b765                	j	8000409c <fileread+0x60>
      return -1;
    800040f6:	597d                	li	s2,-1
    800040f8:	b755                	j	8000409c <fileread+0x60>
    800040fa:	597d                	li	s2,-1
    800040fc:	b745                	j	8000409c <fileread+0x60>

00000000800040fe <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800040fe:	715d                	addi	sp,sp,-80
    80004100:	e486                	sd	ra,72(sp)
    80004102:	e0a2                	sd	s0,64(sp)
    80004104:	fc26                	sd	s1,56(sp)
    80004106:	f84a                	sd	s2,48(sp)
    80004108:	f44e                	sd	s3,40(sp)
    8000410a:	f052                	sd	s4,32(sp)
    8000410c:	ec56                	sd	s5,24(sp)
    8000410e:	e85a                	sd	s6,16(sp)
    80004110:	e45e                	sd	s7,8(sp)
    80004112:	e062                	sd	s8,0(sp)
    80004114:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004116:	00954783          	lbu	a5,9(a0)
    8000411a:	10078663          	beqz	a5,80004226 <filewrite+0x128>
    8000411e:	892a                	mv	s2,a0
    80004120:	8aae                	mv	s5,a1
    80004122:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004124:	411c                	lw	a5,0(a0)
    80004126:	4705                	li	a4,1
    80004128:	02e78263          	beq	a5,a4,8000414c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000412c:	470d                	li	a4,3
    8000412e:	02e78663          	beq	a5,a4,8000415a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004132:	4709                	li	a4,2
    80004134:	0ee79163          	bne	a5,a4,80004216 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004138:	0ac05d63          	blez	a2,800041f2 <filewrite+0xf4>
    int i = 0;
    8000413c:	4981                	li	s3,0
    8000413e:	6b05                	lui	s6,0x1
    80004140:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004144:	6b85                	lui	s7,0x1
    80004146:	c00b8b9b          	addiw	s7,s7,-1024
    8000414a:	a861                	j	800041e2 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000414c:	6908                	ld	a0,16(a0)
    8000414e:	00000097          	auipc	ra,0x0
    80004152:	22e080e7          	jalr	558(ra) # 8000437c <pipewrite>
    80004156:	8a2a                	mv	s4,a0
    80004158:	a045                	j	800041f8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000415a:	02451783          	lh	a5,36(a0)
    8000415e:	03079693          	slli	a3,a5,0x30
    80004162:	92c1                	srli	a3,a3,0x30
    80004164:	4725                	li	a4,9
    80004166:	0cd76263          	bltu	a4,a3,8000422a <filewrite+0x12c>
    8000416a:	0792                	slli	a5,a5,0x4
    8000416c:	00015717          	auipc	a4,0x15
    80004170:	65c70713          	addi	a4,a4,1628 # 800197c8 <devsw>
    80004174:	97ba                	add	a5,a5,a4
    80004176:	679c                	ld	a5,8(a5)
    80004178:	cbdd                	beqz	a5,8000422e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    8000417a:	4505                	li	a0,1
    8000417c:	9782                	jalr	a5
    8000417e:	8a2a                	mv	s4,a0
    80004180:	a8a5                	j	800041f8 <filewrite+0xfa>
    80004182:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004186:	00000097          	auipc	ra,0x0
    8000418a:	8b0080e7          	jalr	-1872(ra) # 80003a36 <begin_op>
      ilock(f->ip);
    8000418e:	01893503          	ld	a0,24(s2)
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	ed2080e7          	jalr	-302(ra) # 80003064 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000419a:	8762                	mv	a4,s8
    8000419c:	02092683          	lw	a3,32(s2)
    800041a0:	01598633          	add	a2,s3,s5
    800041a4:	4585                	li	a1,1
    800041a6:	01893503          	ld	a0,24(s2)
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	266080e7          	jalr	614(ra) # 80003410 <writei>
    800041b2:	84aa                	mv	s1,a0
    800041b4:	00a05763          	blez	a0,800041c2 <filewrite+0xc4>
        f->off += r;
    800041b8:	02092783          	lw	a5,32(s2)
    800041bc:	9fa9                	addw	a5,a5,a0
    800041be:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800041c2:	01893503          	ld	a0,24(s2)
    800041c6:	fffff097          	auipc	ra,0xfffff
    800041ca:	f60080e7          	jalr	-160(ra) # 80003126 <iunlock>
      end_op();
    800041ce:	00000097          	auipc	ra,0x0
    800041d2:	8e8080e7          	jalr	-1816(ra) # 80003ab6 <end_op>

      if(r != n1){
    800041d6:	009c1f63          	bne	s8,s1,800041f4 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800041da:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800041de:	0149db63          	bge	s3,s4,800041f4 <filewrite+0xf6>
      int n1 = n - i;
    800041e2:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800041e6:	84be                	mv	s1,a5
    800041e8:	2781                	sext.w	a5,a5
    800041ea:	f8fb5ce3          	bge	s6,a5,80004182 <filewrite+0x84>
    800041ee:	84de                	mv	s1,s7
    800041f0:	bf49                	j	80004182 <filewrite+0x84>
    int i = 0;
    800041f2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800041f4:	013a1f63          	bne	s4,s3,80004212 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800041f8:	8552                	mv	a0,s4
    800041fa:	60a6                	ld	ra,72(sp)
    800041fc:	6406                	ld	s0,64(sp)
    800041fe:	74e2                	ld	s1,56(sp)
    80004200:	7942                	ld	s2,48(sp)
    80004202:	79a2                	ld	s3,40(sp)
    80004204:	7a02                	ld	s4,32(sp)
    80004206:	6ae2                	ld	s5,24(sp)
    80004208:	6b42                	ld	s6,16(sp)
    8000420a:	6ba2                	ld	s7,8(sp)
    8000420c:	6c02                	ld	s8,0(sp)
    8000420e:	6161                	addi	sp,sp,80
    80004210:	8082                	ret
    ret = (i == n ? n : -1);
    80004212:	5a7d                	li	s4,-1
    80004214:	b7d5                	j	800041f8 <filewrite+0xfa>
    panic("filewrite");
    80004216:	00004517          	auipc	a0,0x4
    8000421a:	44a50513          	addi	a0,a0,1098 # 80008660 <syscalls+0x2a8>
    8000421e:	00002097          	auipc	ra,0x2
    80004222:	efa080e7          	jalr	-262(ra) # 80006118 <panic>
    return -1;
    80004226:	5a7d                	li	s4,-1
    80004228:	bfc1                	j	800041f8 <filewrite+0xfa>
      return -1;
    8000422a:	5a7d                	li	s4,-1
    8000422c:	b7f1                	j	800041f8 <filewrite+0xfa>
    8000422e:	5a7d                	li	s4,-1
    80004230:	b7e1                	j	800041f8 <filewrite+0xfa>

0000000080004232 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004232:	7179                	addi	sp,sp,-48
    80004234:	f406                	sd	ra,40(sp)
    80004236:	f022                	sd	s0,32(sp)
    80004238:	ec26                	sd	s1,24(sp)
    8000423a:	e84a                	sd	s2,16(sp)
    8000423c:	e44e                	sd	s3,8(sp)
    8000423e:	e052                	sd	s4,0(sp)
    80004240:	1800                	addi	s0,sp,48
    80004242:	84aa                	mv	s1,a0
    80004244:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004246:	0005b023          	sd	zero,0(a1)
    8000424a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000424e:	00000097          	auipc	ra,0x0
    80004252:	bf8080e7          	jalr	-1032(ra) # 80003e46 <filealloc>
    80004256:	e088                	sd	a0,0(s1)
    80004258:	c551                	beqz	a0,800042e4 <pipealloc+0xb2>
    8000425a:	00000097          	auipc	ra,0x0
    8000425e:	bec080e7          	jalr	-1044(ra) # 80003e46 <filealloc>
    80004262:	00aa3023          	sd	a0,0(s4)
    80004266:	c92d                	beqz	a0,800042d8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004268:	ffffc097          	auipc	ra,0xffffc
    8000426c:	eb0080e7          	jalr	-336(ra) # 80000118 <kalloc>
    80004270:	892a                	mv	s2,a0
    80004272:	c125                	beqz	a0,800042d2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004274:	4985                	li	s3,1
    80004276:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000427a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000427e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004282:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004286:	00004597          	auipc	a1,0x4
    8000428a:	3ea58593          	addi	a1,a1,1002 # 80008670 <syscalls+0x2b8>
    8000428e:	00002097          	auipc	ra,0x2
    80004292:	344080e7          	jalr	836(ra) # 800065d2 <initlock>
  (*f0)->type = FD_PIPE;
    80004296:	609c                	ld	a5,0(s1)
    80004298:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000429c:	609c                	ld	a5,0(s1)
    8000429e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800042a2:	609c                	ld	a5,0(s1)
    800042a4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800042a8:	609c                	ld	a5,0(s1)
    800042aa:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800042ae:	000a3783          	ld	a5,0(s4)
    800042b2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800042b6:	000a3783          	ld	a5,0(s4)
    800042ba:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800042be:	000a3783          	ld	a5,0(s4)
    800042c2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800042c6:	000a3783          	ld	a5,0(s4)
    800042ca:	0127b823          	sd	s2,16(a5)
  return 0;
    800042ce:	4501                	li	a0,0
    800042d0:	a025                	j	800042f8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800042d2:	6088                	ld	a0,0(s1)
    800042d4:	e501                	bnez	a0,800042dc <pipealloc+0xaa>
    800042d6:	a039                	j	800042e4 <pipealloc+0xb2>
    800042d8:	6088                	ld	a0,0(s1)
    800042da:	c51d                	beqz	a0,80004308 <pipealloc+0xd6>
    fileclose(*f0);
    800042dc:	00000097          	auipc	ra,0x0
    800042e0:	c26080e7          	jalr	-986(ra) # 80003f02 <fileclose>
  if(*f1)
    800042e4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800042e8:	557d                	li	a0,-1
  if(*f1)
    800042ea:	c799                	beqz	a5,800042f8 <pipealloc+0xc6>
    fileclose(*f1);
    800042ec:	853e                	mv	a0,a5
    800042ee:	00000097          	auipc	ra,0x0
    800042f2:	c14080e7          	jalr	-1004(ra) # 80003f02 <fileclose>
  return -1;
    800042f6:	557d                	li	a0,-1
}
    800042f8:	70a2                	ld	ra,40(sp)
    800042fa:	7402                	ld	s0,32(sp)
    800042fc:	64e2                	ld	s1,24(sp)
    800042fe:	6942                	ld	s2,16(sp)
    80004300:	69a2                	ld	s3,8(sp)
    80004302:	6a02                	ld	s4,0(sp)
    80004304:	6145                	addi	sp,sp,48
    80004306:	8082                	ret
  return -1;
    80004308:	557d                	li	a0,-1
    8000430a:	b7fd                	j	800042f8 <pipealloc+0xc6>

000000008000430c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000430c:	1101                	addi	sp,sp,-32
    8000430e:	ec06                	sd	ra,24(sp)
    80004310:	e822                	sd	s0,16(sp)
    80004312:	e426                	sd	s1,8(sp)
    80004314:	e04a                	sd	s2,0(sp)
    80004316:	1000                	addi	s0,sp,32
    80004318:	84aa                	mv	s1,a0
    8000431a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000431c:	00002097          	auipc	ra,0x2
    80004320:	346080e7          	jalr	838(ra) # 80006662 <acquire>
  if(writable){
    80004324:	02090d63          	beqz	s2,8000435e <pipeclose+0x52>
    pi->writeopen = 0;
    80004328:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000432c:	21848513          	addi	a0,s1,536
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	418080e7          	jalr	1048(ra) # 80001748 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004338:	2204b783          	ld	a5,544(s1)
    8000433c:	eb95                	bnez	a5,80004370 <pipeclose+0x64>
    release(&pi->lock);
    8000433e:	8526                	mv	a0,s1
    80004340:	00002097          	auipc	ra,0x2
    80004344:	3d6080e7          	jalr	982(ra) # 80006716 <release>
    kfree((char*)pi);
    80004348:	8526                	mv	a0,s1
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	cd2080e7          	jalr	-814(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004352:	60e2                	ld	ra,24(sp)
    80004354:	6442                	ld	s0,16(sp)
    80004356:	64a2                	ld	s1,8(sp)
    80004358:	6902                	ld	s2,0(sp)
    8000435a:	6105                	addi	sp,sp,32
    8000435c:	8082                	ret
    pi->readopen = 0;
    8000435e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004362:	21c48513          	addi	a0,s1,540
    80004366:	ffffd097          	auipc	ra,0xffffd
    8000436a:	3e2080e7          	jalr	994(ra) # 80001748 <wakeup>
    8000436e:	b7e9                	j	80004338 <pipeclose+0x2c>
    release(&pi->lock);
    80004370:	8526                	mv	a0,s1
    80004372:	00002097          	auipc	ra,0x2
    80004376:	3a4080e7          	jalr	932(ra) # 80006716 <release>
}
    8000437a:	bfe1                	j	80004352 <pipeclose+0x46>

000000008000437c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000437c:	7159                	addi	sp,sp,-112
    8000437e:	f486                	sd	ra,104(sp)
    80004380:	f0a2                	sd	s0,96(sp)
    80004382:	eca6                	sd	s1,88(sp)
    80004384:	e8ca                	sd	s2,80(sp)
    80004386:	e4ce                	sd	s3,72(sp)
    80004388:	e0d2                	sd	s4,64(sp)
    8000438a:	fc56                	sd	s5,56(sp)
    8000438c:	f85a                	sd	s6,48(sp)
    8000438e:	f45e                	sd	s7,40(sp)
    80004390:	f062                	sd	s8,32(sp)
    80004392:	ec66                	sd	s9,24(sp)
    80004394:	1880                	addi	s0,sp,112
    80004396:	84aa                	mv	s1,a0
    80004398:	8aae                	mv	s5,a1
    8000439a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	aea080e7          	jalr	-1302(ra) # 80000e86 <myproc>
    800043a4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800043a6:	8526                	mv	a0,s1
    800043a8:	00002097          	auipc	ra,0x2
    800043ac:	2ba080e7          	jalr	698(ra) # 80006662 <acquire>
  while(i < n){
    800043b0:	0d405163          	blez	s4,80004472 <pipewrite+0xf6>
    800043b4:	8ba6                	mv	s7,s1
  int i = 0;
    800043b6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800043b8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800043ba:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800043be:	21c48c13          	addi	s8,s1,540
    800043c2:	a08d                	j	80004424 <pipewrite+0xa8>
      release(&pi->lock);
    800043c4:	8526                	mv	a0,s1
    800043c6:	00002097          	auipc	ra,0x2
    800043ca:	350080e7          	jalr	848(ra) # 80006716 <release>
      return -1;
    800043ce:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800043d0:	854a                	mv	a0,s2
    800043d2:	70a6                	ld	ra,104(sp)
    800043d4:	7406                	ld	s0,96(sp)
    800043d6:	64e6                	ld	s1,88(sp)
    800043d8:	6946                	ld	s2,80(sp)
    800043da:	69a6                	ld	s3,72(sp)
    800043dc:	6a06                	ld	s4,64(sp)
    800043de:	7ae2                	ld	s5,56(sp)
    800043e0:	7b42                	ld	s6,48(sp)
    800043e2:	7ba2                	ld	s7,40(sp)
    800043e4:	7c02                	ld	s8,32(sp)
    800043e6:	6ce2                	ld	s9,24(sp)
    800043e8:	6165                	addi	sp,sp,112
    800043ea:	8082                	ret
      wakeup(&pi->nread);
    800043ec:	8566                	mv	a0,s9
    800043ee:	ffffd097          	auipc	ra,0xffffd
    800043f2:	35a080e7          	jalr	858(ra) # 80001748 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800043f6:	85de                	mv	a1,s7
    800043f8:	8562                	mv	a0,s8
    800043fa:	ffffd097          	auipc	ra,0xffffd
    800043fe:	1c2080e7          	jalr	450(ra) # 800015bc <sleep>
    80004402:	a839                	j	80004420 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004404:	21c4a783          	lw	a5,540(s1)
    80004408:	0017871b          	addiw	a4,a5,1
    8000440c:	20e4ae23          	sw	a4,540(s1)
    80004410:	1ff7f793          	andi	a5,a5,511
    80004414:	97a6                	add	a5,a5,s1
    80004416:	f9f44703          	lbu	a4,-97(s0)
    8000441a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000441e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004420:	03495d63          	bge	s2,s4,8000445a <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004424:	2204a783          	lw	a5,544(s1)
    80004428:	dfd1                	beqz	a5,800043c4 <pipewrite+0x48>
    8000442a:	0289a783          	lw	a5,40(s3)
    8000442e:	fbd9                	bnez	a5,800043c4 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004430:	2184a783          	lw	a5,536(s1)
    80004434:	21c4a703          	lw	a4,540(s1)
    80004438:	2007879b          	addiw	a5,a5,512
    8000443c:	faf708e3          	beq	a4,a5,800043ec <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004440:	4685                	li	a3,1
    80004442:	01590633          	add	a2,s2,s5
    80004446:	f9f40593          	addi	a1,s0,-97
    8000444a:	0509b503          	ld	a0,80(s3)
    8000444e:	ffffc097          	auipc	ra,0xffffc
    80004452:	718080e7          	jalr	1816(ra) # 80000b66 <copyin>
    80004456:	fb6517e3          	bne	a0,s6,80004404 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000445a:	21848513          	addi	a0,s1,536
    8000445e:	ffffd097          	auipc	ra,0xffffd
    80004462:	2ea080e7          	jalr	746(ra) # 80001748 <wakeup>
  release(&pi->lock);
    80004466:	8526                	mv	a0,s1
    80004468:	00002097          	auipc	ra,0x2
    8000446c:	2ae080e7          	jalr	686(ra) # 80006716 <release>
  return i;
    80004470:	b785                	j	800043d0 <pipewrite+0x54>
  int i = 0;
    80004472:	4901                	li	s2,0
    80004474:	b7dd                	j	8000445a <pipewrite+0xde>

0000000080004476 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004476:	715d                	addi	sp,sp,-80
    80004478:	e486                	sd	ra,72(sp)
    8000447a:	e0a2                	sd	s0,64(sp)
    8000447c:	fc26                	sd	s1,56(sp)
    8000447e:	f84a                	sd	s2,48(sp)
    80004480:	f44e                	sd	s3,40(sp)
    80004482:	f052                	sd	s4,32(sp)
    80004484:	ec56                	sd	s5,24(sp)
    80004486:	e85a                	sd	s6,16(sp)
    80004488:	0880                	addi	s0,sp,80
    8000448a:	84aa                	mv	s1,a0
    8000448c:	892e                	mv	s2,a1
    8000448e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004490:	ffffd097          	auipc	ra,0xffffd
    80004494:	9f6080e7          	jalr	-1546(ra) # 80000e86 <myproc>
    80004498:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000449a:	8b26                	mv	s6,s1
    8000449c:	8526                	mv	a0,s1
    8000449e:	00002097          	auipc	ra,0x2
    800044a2:	1c4080e7          	jalr	452(ra) # 80006662 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044a6:	2184a703          	lw	a4,536(s1)
    800044aa:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800044ae:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044b2:	02f71463          	bne	a4,a5,800044da <piperead+0x64>
    800044b6:	2244a783          	lw	a5,548(s1)
    800044ba:	c385                	beqz	a5,800044da <piperead+0x64>
    if(pr->killed){
    800044bc:	028a2783          	lw	a5,40(s4)
    800044c0:	ebc1                	bnez	a5,80004550 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800044c2:	85da                	mv	a1,s6
    800044c4:	854e                	mv	a0,s3
    800044c6:	ffffd097          	auipc	ra,0xffffd
    800044ca:	0f6080e7          	jalr	246(ra) # 800015bc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044ce:	2184a703          	lw	a4,536(s1)
    800044d2:	21c4a783          	lw	a5,540(s1)
    800044d6:	fef700e3          	beq	a4,a5,800044b6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044da:	09505263          	blez	s5,8000455e <piperead+0xe8>
    800044de:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800044e0:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800044e2:	2184a783          	lw	a5,536(s1)
    800044e6:	21c4a703          	lw	a4,540(s1)
    800044ea:	02f70d63          	beq	a4,a5,80004524 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800044ee:	0017871b          	addiw	a4,a5,1
    800044f2:	20e4ac23          	sw	a4,536(s1)
    800044f6:	1ff7f793          	andi	a5,a5,511
    800044fa:	97a6                	add	a5,a5,s1
    800044fc:	0187c783          	lbu	a5,24(a5)
    80004500:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004504:	4685                	li	a3,1
    80004506:	fbf40613          	addi	a2,s0,-65
    8000450a:	85ca                	mv	a1,s2
    8000450c:	050a3503          	ld	a0,80(s4)
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	5ca080e7          	jalr	1482(ra) # 80000ada <copyout>
    80004518:	01650663          	beq	a0,s6,80004524 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000451c:	2985                	addiw	s3,s3,1
    8000451e:	0905                	addi	s2,s2,1
    80004520:	fd3a91e3          	bne	s5,s3,800044e2 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004524:	21c48513          	addi	a0,s1,540
    80004528:	ffffd097          	auipc	ra,0xffffd
    8000452c:	220080e7          	jalr	544(ra) # 80001748 <wakeup>
  release(&pi->lock);
    80004530:	8526                	mv	a0,s1
    80004532:	00002097          	auipc	ra,0x2
    80004536:	1e4080e7          	jalr	484(ra) # 80006716 <release>
  return i;
}
    8000453a:	854e                	mv	a0,s3
    8000453c:	60a6                	ld	ra,72(sp)
    8000453e:	6406                	ld	s0,64(sp)
    80004540:	74e2                	ld	s1,56(sp)
    80004542:	7942                	ld	s2,48(sp)
    80004544:	79a2                	ld	s3,40(sp)
    80004546:	7a02                	ld	s4,32(sp)
    80004548:	6ae2                	ld	s5,24(sp)
    8000454a:	6b42                	ld	s6,16(sp)
    8000454c:	6161                	addi	sp,sp,80
    8000454e:	8082                	ret
      release(&pi->lock);
    80004550:	8526                	mv	a0,s1
    80004552:	00002097          	auipc	ra,0x2
    80004556:	1c4080e7          	jalr	452(ra) # 80006716 <release>
      return -1;
    8000455a:	59fd                	li	s3,-1
    8000455c:	bff9                	j	8000453a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000455e:	4981                	li	s3,0
    80004560:	b7d1                	j	80004524 <piperead+0xae>

0000000080004562 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004562:	df010113          	addi	sp,sp,-528
    80004566:	20113423          	sd	ra,520(sp)
    8000456a:	20813023          	sd	s0,512(sp)
    8000456e:	ffa6                	sd	s1,504(sp)
    80004570:	fbca                	sd	s2,496(sp)
    80004572:	f7ce                	sd	s3,488(sp)
    80004574:	f3d2                	sd	s4,480(sp)
    80004576:	efd6                	sd	s5,472(sp)
    80004578:	ebda                	sd	s6,464(sp)
    8000457a:	e7de                	sd	s7,456(sp)
    8000457c:	e3e2                	sd	s8,448(sp)
    8000457e:	ff66                	sd	s9,440(sp)
    80004580:	fb6a                	sd	s10,432(sp)
    80004582:	f76e                	sd	s11,424(sp)
    80004584:	0c00                	addi	s0,sp,528
    80004586:	84aa                	mv	s1,a0
    80004588:	dea43c23          	sd	a0,-520(s0)
    8000458c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004590:	ffffd097          	auipc	ra,0xffffd
    80004594:	8f6080e7          	jalr	-1802(ra) # 80000e86 <myproc>
    80004598:	892a                	mv	s2,a0

  begin_op();
    8000459a:	fffff097          	auipc	ra,0xfffff
    8000459e:	49c080e7          	jalr	1180(ra) # 80003a36 <begin_op>

  if((ip = namei(path)) == 0){
    800045a2:	8526                	mv	a0,s1
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	276080e7          	jalr	630(ra) # 8000381a <namei>
    800045ac:	c92d                	beqz	a0,8000461e <exec+0xbc>
    800045ae:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	ab4080e7          	jalr	-1356(ra) # 80003064 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800045b8:	04000713          	li	a4,64
    800045bc:	4681                	li	a3,0
    800045be:	e5040613          	addi	a2,s0,-432
    800045c2:	4581                	li	a1,0
    800045c4:	8526                	mv	a0,s1
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	d52080e7          	jalr	-686(ra) # 80003318 <readi>
    800045ce:	04000793          	li	a5,64
    800045d2:	00f51a63          	bne	a0,a5,800045e6 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800045d6:	e5042703          	lw	a4,-432(s0)
    800045da:	464c47b7          	lui	a5,0x464c4
    800045de:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800045e2:	04f70463          	beq	a4,a5,8000462a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800045e6:	8526                	mv	a0,s1
    800045e8:	fffff097          	auipc	ra,0xfffff
    800045ec:	cde080e7          	jalr	-802(ra) # 800032c6 <iunlockput>
    end_op();
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	4c6080e7          	jalr	1222(ra) # 80003ab6 <end_op>
  }
  return -1;
    800045f8:	557d                	li	a0,-1
}
    800045fa:	20813083          	ld	ra,520(sp)
    800045fe:	20013403          	ld	s0,512(sp)
    80004602:	74fe                	ld	s1,504(sp)
    80004604:	795e                	ld	s2,496(sp)
    80004606:	79be                	ld	s3,488(sp)
    80004608:	7a1e                	ld	s4,480(sp)
    8000460a:	6afe                	ld	s5,472(sp)
    8000460c:	6b5e                	ld	s6,464(sp)
    8000460e:	6bbe                	ld	s7,456(sp)
    80004610:	6c1e                	ld	s8,448(sp)
    80004612:	7cfa                	ld	s9,440(sp)
    80004614:	7d5a                	ld	s10,432(sp)
    80004616:	7dba                	ld	s11,424(sp)
    80004618:	21010113          	addi	sp,sp,528
    8000461c:	8082                	ret
    end_op();
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	498080e7          	jalr	1176(ra) # 80003ab6 <end_op>
    return -1;
    80004626:	557d                	li	a0,-1
    80004628:	bfc9                	j	800045fa <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000462a:	854a                	mv	a0,s2
    8000462c:	ffffd097          	auipc	ra,0xffffd
    80004630:	920080e7          	jalr	-1760(ra) # 80000f4c <proc_pagetable>
    80004634:	8baa                	mv	s7,a0
    80004636:	d945                	beqz	a0,800045e6 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004638:	e7042983          	lw	s3,-400(s0)
    8000463c:	e8845783          	lhu	a5,-376(s0)
    80004640:	c7ad                	beqz	a5,800046aa <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004642:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004644:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004646:	6c85                	lui	s9,0x1
    80004648:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000464c:	def43823          	sd	a5,-528(s0)
    80004650:	a42d                	j	8000487a <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004652:	00004517          	auipc	a0,0x4
    80004656:	02650513          	addi	a0,a0,38 # 80008678 <syscalls+0x2c0>
    8000465a:	00002097          	auipc	ra,0x2
    8000465e:	abe080e7          	jalr	-1346(ra) # 80006118 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004662:	8756                	mv	a4,s5
    80004664:	012d86bb          	addw	a3,s11,s2
    80004668:	4581                	li	a1,0
    8000466a:	8526                	mv	a0,s1
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	cac080e7          	jalr	-852(ra) # 80003318 <readi>
    80004674:	2501                	sext.w	a0,a0
    80004676:	1aaa9963          	bne	s5,a0,80004828 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000467a:	6785                	lui	a5,0x1
    8000467c:	0127893b          	addw	s2,a5,s2
    80004680:	77fd                	lui	a5,0xfffff
    80004682:	01478a3b          	addw	s4,a5,s4
    80004686:	1f897163          	bgeu	s2,s8,80004868 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000468a:	02091593          	slli	a1,s2,0x20
    8000468e:	9181                	srli	a1,a1,0x20
    80004690:	95ea                	add	a1,a1,s10
    80004692:	855e                	mv	a0,s7
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	e72080e7          	jalr	-398(ra) # 80000506 <walkaddr>
    8000469c:	862a                	mv	a2,a0
    if(pa == 0)
    8000469e:	d955                	beqz	a0,80004652 <exec+0xf0>
      n = PGSIZE;
    800046a0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800046a2:	fd9a70e3          	bgeu	s4,s9,80004662 <exec+0x100>
      n = sz - i;
    800046a6:	8ad2                	mv	s5,s4
    800046a8:	bf6d                	j	80004662 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046aa:	4901                	li	s2,0
  iunlockput(ip);
    800046ac:	8526                	mv	a0,s1
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	c18080e7          	jalr	-1000(ra) # 800032c6 <iunlockput>
  end_op();
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	400080e7          	jalr	1024(ra) # 80003ab6 <end_op>
  p = myproc();
    800046be:	ffffc097          	auipc	ra,0xffffc
    800046c2:	7c8080e7          	jalr	1992(ra) # 80000e86 <myproc>
    800046c6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800046c8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800046cc:	6785                	lui	a5,0x1
    800046ce:	17fd                	addi	a5,a5,-1
    800046d0:	993e                	add	s2,s2,a5
    800046d2:	757d                	lui	a0,0xfffff
    800046d4:	00a977b3          	and	a5,s2,a0
    800046d8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800046dc:	6609                	lui	a2,0x2
    800046de:	963e                	add	a2,a2,a5
    800046e0:	85be                	mv	a1,a5
    800046e2:	855e                	mv	a0,s7
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	1b8080e7          	jalr	440(ra) # 8000089c <uvmalloc>
    800046ec:	8b2a                	mv	s6,a0
  ip = 0;
    800046ee:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800046f0:	12050c63          	beqz	a0,80004828 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800046f4:	75f9                	lui	a1,0xffffe
    800046f6:	95aa                	add	a1,a1,a0
    800046f8:	855e                	mv	a0,s7
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	3ae080e7          	jalr	942(ra) # 80000aa8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004702:	7c7d                	lui	s8,0xfffff
    80004704:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004706:	e0043783          	ld	a5,-512(s0)
    8000470a:	6388                	ld	a0,0(a5)
    8000470c:	c535                	beqz	a0,80004778 <exec+0x216>
    8000470e:	e9040993          	addi	s3,s0,-368
    80004712:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004716:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004718:	ffffc097          	auipc	ra,0xffffc
    8000471c:	be4080e7          	jalr	-1052(ra) # 800002fc <strlen>
    80004720:	2505                	addiw	a0,a0,1
    80004722:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004726:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000472a:	13896363          	bltu	s2,s8,80004850 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000472e:	e0043d83          	ld	s11,-512(s0)
    80004732:	000dba03          	ld	s4,0(s11)
    80004736:	8552                	mv	a0,s4
    80004738:	ffffc097          	auipc	ra,0xffffc
    8000473c:	bc4080e7          	jalr	-1084(ra) # 800002fc <strlen>
    80004740:	0015069b          	addiw	a3,a0,1
    80004744:	8652                	mv	a2,s4
    80004746:	85ca                	mv	a1,s2
    80004748:	855e                	mv	a0,s7
    8000474a:	ffffc097          	auipc	ra,0xffffc
    8000474e:	390080e7          	jalr	912(ra) # 80000ada <copyout>
    80004752:	10054363          	bltz	a0,80004858 <exec+0x2f6>
    ustack[argc] = sp;
    80004756:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000475a:	0485                	addi	s1,s1,1
    8000475c:	008d8793          	addi	a5,s11,8
    80004760:	e0f43023          	sd	a5,-512(s0)
    80004764:	008db503          	ld	a0,8(s11)
    80004768:	c911                	beqz	a0,8000477c <exec+0x21a>
    if(argc >= MAXARG)
    8000476a:	09a1                	addi	s3,s3,8
    8000476c:	fb3c96e3          	bne	s9,s3,80004718 <exec+0x1b6>
  sz = sz1;
    80004770:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004774:	4481                	li	s1,0
    80004776:	a84d                	j	80004828 <exec+0x2c6>
  sp = sz;
    80004778:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000477a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000477c:	00349793          	slli	a5,s1,0x3
    80004780:	f9040713          	addi	a4,s0,-112
    80004784:	97ba                	add	a5,a5,a4
    80004786:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000478a:	00148693          	addi	a3,s1,1
    8000478e:	068e                	slli	a3,a3,0x3
    80004790:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004794:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004798:	01897663          	bgeu	s2,s8,800047a4 <exec+0x242>
  sz = sz1;
    8000479c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800047a0:	4481                	li	s1,0
    800047a2:	a059                	j	80004828 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800047a4:	e9040613          	addi	a2,s0,-368
    800047a8:	85ca                	mv	a1,s2
    800047aa:	855e                	mv	a0,s7
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	32e080e7          	jalr	814(ra) # 80000ada <copyout>
    800047b4:	0a054663          	bltz	a0,80004860 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800047b8:	058ab783          	ld	a5,88(s5)
    800047bc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800047c0:	df843783          	ld	a5,-520(s0)
    800047c4:	0007c703          	lbu	a4,0(a5)
    800047c8:	cf11                	beqz	a4,800047e4 <exec+0x282>
    800047ca:	0785                	addi	a5,a5,1
    if(*s == '/')
    800047cc:	02f00693          	li	a3,47
    800047d0:	a039                	j	800047de <exec+0x27c>
      last = s+1;
    800047d2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800047d6:	0785                	addi	a5,a5,1
    800047d8:	fff7c703          	lbu	a4,-1(a5)
    800047dc:	c701                	beqz	a4,800047e4 <exec+0x282>
    if(*s == '/')
    800047de:	fed71ce3          	bne	a4,a3,800047d6 <exec+0x274>
    800047e2:	bfc5                	j	800047d2 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800047e4:	4641                	li	a2,16
    800047e6:	df843583          	ld	a1,-520(s0)
    800047ea:	158a8513          	addi	a0,s5,344
    800047ee:	ffffc097          	auipc	ra,0xffffc
    800047f2:	adc080e7          	jalr	-1316(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800047f6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800047fa:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800047fe:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004802:	058ab783          	ld	a5,88(s5)
    80004806:	e6843703          	ld	a4,-408(s0)
    8000480a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000480c:	058ab783          	ld	a5,88(s5)
    80004810:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004814:	85ea                	mv	a1,s10
    80004816:	ffffc097          	auipc	ra,0xffffc
    8000481a:	7d2080e7          	jalr	2002(ra) # 80000fe8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000481e:	0004851b          	sext.w	a0,s1
    80004822:	bbe1                	j	800045fa <exec+0x98>
    80004824:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004828:	e0843583          	ld	a1,-504(s0)
    8000482c:	855e                	mv	a0,s7
    8000482e:	ffffc097          	auipc	ra,0xffffc
    80004832:	7ba080e7          	jalr	1978(ra) # 80000fe8 <proc_freepagetable>
  if(ip){
    80004836:	da0498e3          	bnez	s1,800045e6 <exec+0x84>
  return -1;
    8000483a:	557d                	li	a0,-1
    8000483c:	bb7d                	j	800045fa <exec+0x98>
    8000483e:	e1243423          	sd	s2,-504(s0)
    80004842:	b7dd                	j	80004828 <exec+0x2c6>
    80004844:	e1243423          	sd	s2,-504(s0)
    80004848:	b7c5                	j	80004828 <exec+0x2c6>
    8000484a:	e1243423          	sd	s2,-504(s0)
    8000484e:	bfe9                	j	80004828 <exec+0x2c6>
  sz = sz1;
    80004850:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004854:	4481                	li	s1,0
    80004856:	bfc9                	j	80004828 <exec+0x2c6>
  sz = sz1;
    80004858:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000485c:	4481                	li	s1,0
    8000485e:	b7e9                	j	80004828 <exec+0x2c6>
  sz = sz1;
    80004860:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004864:	4481                	li	s1,0
    80004866:	b7c9                	j	80004828 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004868:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000486c:	2b05                	addiw	s6,s6,1
    8000486e:	0389899b          	addiw	s3,s3,56
    80004872:	e8845783          	lhu	a5,-376(s0)
    80004876:	e2fb5be3          	bge	s6,a5,800046ac <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000487a:	2981                	sext.w	s3,s3
    8000487c:	03800713          	li	a4,56
    80004880:	86ce                	mv	a3,s3
    80004882:	e1840613          	addi	a2,s0,-488
    80004886:	4581                	li	a1,0
    80004888:	8526                	mv	a0,s1
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	a8e080e7          	jalr	-1394(ra) # 80003318 <readi>
    80004892:	03800793          	li	a5,56
    80004896:	f8f517e3          	bne	a0,a5,80004824 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000489a:	e1842783          	lw	a5,-488(s0)
    8000489e:	4705                	li	a4,1
    800048a0:	fce796e3          	bne	a5,a4,8000486c <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800048a4:	e4043603          	ld	a2,-448(s0)
    800048a8:	e3843783          	ld	a5,-456(s0)
    800048ac:	f8f669e3          	bltu	a2,a5,8000483e <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800048b0:	e2843783          	ld	a5,-472(s0)
    800048b4:	963e                	add	a2,a2,a5
    800048b6:	f8f667e3          	bltu	a2,a5,80004844 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800048ba:	85ca                	mv	a1,s2
    800048bc:	855e                	mv	a0,s7
    800048be:	ffffc097          	auipc	ra,0xffffc
    800048c2:	fde080e7          	jalr	-34(ra) # 8000089c <uvmalloc>
    800048c6:	e0a43423          	sd	a0,-504(s0)
    800048ca:	d141                	beqz	a0,8000484a <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800048cc:	e2843d03          	ld	s10,-472(s0)
    800048d0:	df043783          	ld	a5,-528(s0)
    800048d4:	00fd77b3          	and	a5,s10,a5
    800048d8:	fba1                	bnez	a5,80004828 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800048da:	e2042d83          	lw	s11,-480(s0)
    800048de:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800048e2:	f80c03e3          	beqz	s8,80004868 <exec+0x306>
    800048e6:	8a62                	mv	s4,s8
    800048e8:	4901                	li	s2,0
    800048ea:	b345                	j	8000468a <exec+0x128>

00000000800048ec <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800048ec:	7179                	addi	sp,sp,-48
    800048ee:	f406                	sd	ra,40(sp)
    800048f0:	f022                	sd	s0,32(sp)
    800048f2:	ec26                	sd	s1,24(sp)
    800048f4:	e84a                	sd	s2,16(sp)
    800048f6:	1800                	addi	s0,sp,48
    800048f8:	892e                	mv	s2,a1
    800048fa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800048fc:	fdc40593          	addi	a1,s0,-36
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	842080e7          	jalr	-1982(ra) # 80002142 <argint>
    80004908:	04054063          	bltz	a0,80004948 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000490c:	fdc42703          	lw	a4,-36(s0)
    80004910:	47bd                	li	a5,15
    80004912:	02e7ed63          	bltu	a5,a4,8000494c <argfd+0x60>
    80004916:	ffffc097          	auipc	ra,0xffffc
    8000491a:	570080e7          	jalr	1392(ra) # 80000e86 <myproc>
    8000491e:	fdc42703          	lw	a4,-36(s0)
    80004922:	01a70793          	addi	a5,a4,26
    80004926:	078e                	slli	a5,a5,0x3
    80004928:	953e                	add	a0,a0,a5
    8000492a:	611c                	ld	a5,0(a0)
    8000492c:	c395                	beqz	a5,80004950 <argfd+0x64>
    return -1;
  if(pfd)
    8000492e:	00090463          	beqz	s2,80004936 <argfd+0x4a>
    *pfd = fd;
    80004932:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004936:	4501                	li	a0,0
  if(pf)
    80004938:	c091                	beqz	s1,8000493c <argfd+0x50>
    *pf = f;
    8000493a:	e09c                	sd	a5,0(s1)
}
    8000493c:	70a2                	ld	ra,40(sp)
    8000493e:	7402                	ld	s0,32(sp)
    80004940:	64e2                	ld	s1,24(sp)
    80004942:	6942                	ld	s2,16(sp)
    80004944:	6145                	addi	sp,sp,48
    80004946:	8082                	ret
    return -1;
    80004948:	557d                	li	a0,-1
    8000494a:	bfcd                	j	8000493c <argfd+0x50>
    return -1;
    8000494c:	557d                	li	a0,-1
    8000494e:	b7fd                	j	8000493c <argfd+0x50>
    80004950:	557d                	li	a0,-1
    80004952:	b7ed                	j	8000493c <argfd+0x50>

0000000080004954 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004954:	1101                	addi	sp,sp,-32
    80004956:	ec06                	sd	ra,24(sp)
    80004958:	e822                	sd	s0,16(sp)
    8000495a:	e426                	sd	s1,8(sp)
    8000495c:	1000                	addi	s0,sp,32
    8000495e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004960:	ffffc097          	auipc	ra,0xffffc
    80004964:	526080e7          	jalr	1318(ra) # 80000e86 <myproc>
    80004968:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000496a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    8000496e:	4501                	li	a0,0
    80004970:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004972:	6398                	ld	a4,0(a5)
    80004974:	cb19                	beqz	a4,8000498a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004976:	2505                	addiw	a0,a0,1
    80004978:	07a1                	addi	a5,a5,8
    8000497a:	fed51ce3          	bne	a0,a3,80004972 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000497e:	557d                	li	a0,-1
}
    80004980:	60e2                	ld	ra,24(sp)
    80004982:	6442                	ld	s0,16(sp)
    80004984:	64a2                	ld	s1,8(sp)
    80004986:	6105                	addi	sp,sp,32
    80004988:	8082                	ret
      p->ofile[fd] = f;
    8000498a:	01a50793          	addi	a5,a0,26
    8000498e:	078e                	slli	a5,a5,0x3
    80004990:	963e                	add	a2,a2,a5
    80004992:	e204                	sd	s1,0(a2)
      return fd;
    80004994:	b7f5                	j	80004980 <fdalloc+0x2c>

0000000080004996 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004996:	715d                	addi	sp,sp,-80
    80004998:	e486                	sd	ra,72(sp)
    8000499a:	e0a2                	sd	s0,64(sp)
    8000499c:	fc26                	sd	s1,56(sp)
    8000499e:	f84a                	sd	s2,48(sp)
    800049a0:	f44e                	sd	s3,40(sp)
    800049a2:	f052                	sd	s4,32(sp)
    800049a4:	ec56                	sd	s5,24(sp)
    800049a6:	0880                	addi	s0,sp,80
    800049a8:	89ae                	mv	s3,a1
    800049aa:	8ab2                	mv	s5,a2
    800049ac:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800049ae:	fb040593          	addi	a1,s0,-80
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	e86080e7          	jalr	-378(ra) # 80003838 <nameiparent>
    800049ba:	892a                	mv	s2,a0
    800049bc:	12050f63          	beqz	a0,80004afa <create+0x164>
    return 0;

  ilock(dp);
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	6a4080e7          	jalr	1700(ra) # 80003064 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800049c8:	4601                	li	a2,0
    800049ca:	fb040593          	addi	a1,s0,-80
    800049ce:	854a                	mv	a0,s2
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	b78080e7          	jalr	-1160(ra) # 80003548 <dirlookup>
    800049d8:	84aa                	mv	s1,a0
    800049da:	c921                	beqz	a0,80004a2a <create+0x94>
    iunlockput(dp);
    800049dc:	854a                	mv	a0,s2
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	8e8080e7          	jalr	-1816(ra) # 800032c6 <iunlockput>
    ilock(ip);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	67c080e7          	jalr	1660(ra) # 80003064 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800049f0:	2981                	sext.w	s3,s3
    800049f2:	4789                	li	a5,2
    800049f4:	02f99463          	bne	s3,a5,80004a1c <create+0x86>
    800049f8:	0444d783          	lhu	a5,68(s1)
    800049fc:	37f9                	addiw	a5,a5,-2
    800049fe:	17c2                	slli	a5,a5,0x30
    80004a00:	93c1                	srli	a5,a5,0x30
    80004a02:	4705                	li	a4,1
    80004a04:	00f76c63          	bltu	a4,a5,80004a1c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004a08:	8526                	mv	a0,s1
    80004a0a:	60a6                	ld	ra,72(sp)
    80004a0c:	6406                	ld	s0,64(sp)
    80004a0e:	74e2                	ld	s1,56(sp)
    80004a10:	7942                	ld	s2,48(sp)
    80004a12:	79a2                	ld	s3,40(sp)
    80004a14:	7a02                	ld	s4,32(sp)
    80004a16:	6ae2                	ld	s5,24(sp)
    80004a18:	6161                	addi	sp,sp,80
    80004a1a:	8082                	ret
    iunlockput(ip);
    80004a1c:	8526                	mv	a0,s1
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	8a8080e7          	jalr	-1880(ra) # 800032c6 <iunlockput>
    return 0;
    80004a26:	4481                	li	s1,0
    80004a28:	b7c5                	j	80004a08 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004a2a:	85ce                	mv	a1,s3
    80004a2c:	00092503          	lw	a0,0(s2)
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	49c080e7          	jalr	1180(ra) # 80002ecc <ialloc>
    80004a38:	84aa                	mv	s1,a0
    80004a3a:	c529                	beqz	a0,80004a84 <create+0xee>
  ilock(ip);
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	628080e7          	jalr	1576(ra) # 80003064 <ilock>
  ip->major = major;
    80004a44:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004a48:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004a4c:	4785                	li	a5,1
    80004a4e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	546080e7          	jalr	1350(ra) # 80002f9a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a5c:	2981                	sext.w	s3,s3
    80004a5e:	4785                	li	a5,1
    80004a60:	02f98a63          	beq	s3,a5,80004a94 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a64:	40d0                	lw	a2,4(s1)
    80004a66:	fb040593          	addi	a1,s0,-80
    80004a6a:	854a                	mv	a0,s2
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	cec080e7          	jalr	-788(ra) # 80003758 <dirlink>
    80004a74:	06054b63          	bltz	a0,80004aea <create+0x154>
  iunlockput(dp);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	84c080e7          	jalr	-1972(ra) # 800032c6 <iunlockput>
  return ip;
    80004a82:	b759                	j	80004a08 <create+0x72>
    panic("create: ialloc");
    80004a84:	00004517          	auipc	a0,0x4
    80004a88:	c1450513          	addi	a0,a0,-1004 # 80008698 <syscalls+0x2e0>
    80004a8c:	00001097          	auipc	ra,0x1
    80004a90:	68c080e7          	jalr	1676(ra) # 80006118 <panic>
    dp->nlink++;  // for ".."
    80004a94:	04a95783          	lhu	a5,74(s2)
    80004a98:	2785                	addiw	a5,a5,1
    80004a9a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004a9e:	854a                	mv	a0,s2
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	4fa080e7          	jalr	1274(ra) # 80002f9a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004aa8:	40d0                	lw	a2,4(s1)
    80004aaa:	00004597          	auipc	a1,0x4
    80004aae:	bfe58593          	addi	a1,a1,-1026 # 800086a8 <syscalls+0x2f0>
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	ca4080e7          	jalr	-860(ra) # 80003758 <dirlink>
    80004abc:	00054f63          	bltz	a0,80004ada <create+0x144>
    80004ac0:	00492603          	lw	a2,4(s2)
    80004ac4:	00004597          	auipc	a1,0x4
    80004ac8:	bec58593          	addi	a1,a1,-1044 # 800086b0 <syscalls+0x2f8>
    80004acc:	8526                	mv	a0,s1
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	c8a080e7          	jalr	-886(ra) # 80003758 <dirlink>
    80004ad6:	f80557e3          	bgez	a0,80004a64 <create+0xce>
      panic("create dots");
    80004ada:	00004517          	auipc	a0,0x4
    80004ade:	bde50513          	addi	a0,a0,-1058 # 800086b8 <syscalls+0x300>
    80004ae2:	00001097          	auipc	ra,0x1
    80004ae6:	636080e7          	jalr	1590(ra) # 80006118 <panic>
    panic("create: dirlink");
    80004aea:	00004517          	auipc	a0,0x4
    80004aee:	bde50513          	addi	a0,a0,-1058 # 800086c8 <syscalls+0x310>
    80004af2:	00001097          	auipc	ra,0x1
    80004af6:	626080e7          	jalr	1574(ra) # 80006118 <panic>
    return 0;
    80004afa:	84aa                	mv	s1,a0
    80004afc:	b731                	j	80004a08 <create+0x72>

0000000080004afe <sys_dup>:
{
    80004afe:	7179                	addi	sp,sp,-48
    80004b00:	f406                	sd	ra,40(sp)
    80004b02:	f022                	sd	s0,32(sp)
    80004b04:	ec26                	sd	s1,24(sp)
    80004b06:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b08:	fd840613          	addi	a2,s0,-40
    80004b0c:	4581                	li	a1,0
    80004b0e:	4501                	li	a0,0
    80004b10:	00000097          	auipc	ra,0x0
    80004b14:	ddc080e7          	jalr	-548(ra) # 800048ec <argfd>
    return -1;
    80004b18:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b1a:	02054363          	bltz	a0,80004b40 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004b1e:	fd843503          	ld	a0,-40(s0)
    80004b22:	00000097          	auipc	ra,0x0
    80004b26:	e32080e7          	jalr	-462(ra) # 80004954 <fdalloc>
    80004b2a:	84aa                	mv	s1,a0
    return -1;
    80004b2c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b2e:	00054963          	bltz	a0,80004b40 <sys_dup+0x42>
  filedup(f);
    80004b32:	fd843503          	ld	a0,-40(s0)
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	37a080e7          	jalr	890(ra) # 80003eb0 <filedup>
  return fd;
    80004b3e:	87a6                	mv	a5,s1
}
    80004b40:	853e                	mv	a0,a5
    80004b42:	70a2                	ld	ra,40(sp)
    80004b44:	7402                	ld	s0,32(sp)
    80004b46:	64e2                	ld	s1,24(sp)
    80004b48:	6145                	addi	sp,sp,48
    80004b4a:	8082                	ret

0000000080004b4c <sys_read>:
{
    80004b4c:	7179                	addi	sp,sp,-48
    80004b4e:	f406                	sd	ra,40(sp)
    80004b50:	f022                	sd	s0,32(sp)
    80004b52:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004b54:	fe840613          	addi	a2,s0,-24
    80004b58:	4581                	li	a1,0
    80004b5a:	4501                	li	a0,0
    80004b5c:	00000097          	auipc	ra,0x0
    80004b60:	d90080e7          	jalr	-624(ra) # 800048ec <argfd>
    return -1;
    80004b64:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004b66:	04054163          	bltz	a0,80004ba8 <sys_read+0x5c>
    80004b6a:	fe440593          	addi	a1,s0,-28
    80004b6e:	4509                	li	a0,2
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	5d2080e7          	jalr	1490(ra) # 80002142 <argint>
    return -1;
    80004b78:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004b7a:	02054763          	bltz	a0,80004ba8 <sys_read+0x5c>
    80004b7e:	fd840593          	addi	a1,s0,-40
    80004b82:	4505                	li	a0,1
    80004b84:	ffffd097          	auipc	ra,0xffffd
    80004b88:	5e0080e7          	jalr	1504(ra) # 80002164 <argaddr>
    return -1;
    80004b8c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004b8e:	00054d63          	bltz	a0,80004ba8 <sys_read+0x5c>
  return fileread(f, p, n);
    80004b92:	fe442603          	lw	a2,-28(s0)
    80004b96:	fd843583          	ld	a1,-40(s0)
    80004b9a:	fe843503          	ld	a0,-24(s0)
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	49e080e7          	jalr	1182(ra) # 8000403c <fileread>
    80004ba6:	87aa                	mv	a5,a0
}
    80004ba8:	853e                	mv	a0,a5
    80004baa:	70a2                	ld	ra,40(sp)
    80004bac:	7402                	ld	s0,32(sp)
    80004bae:	6145                	addi	sp,sp,48
    80004bb0:	8082                	ret

0000000080004bb2 <sys_write>:
{
    80004bb2:	7179                	addi	sp,sp,-48
    80004bb4:	f406                	sd	ra,40(sp)
    80004bb6:	f022                	sd	s0,32(sp)
    80004bb8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004bba:	fe840613          	addi	a2,s0,-24
    80004bbe:	4581                	li	a1,0
    80004bc0:	4501                	li	a0,0
    80004bc2:	00000097          	auipc	ra,0x0
    80004bc6:	d2a080e7          	jalr	-726(ra) # 800048ec <argfd>
    return -1;
    80004bca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004bcc:	04054163          	bltz	a0,80004c0e <sys_write+0x5c>
    80004bd0:	fe440593          	addi	a1,s0,-28
    80004bd4:	4509                	li	a0,2
    80004bd6:	ffffd097          	auipc	ra,0xffffd
    80004bda:	56c080e7          	jalr	1388(ra) # 80002142 <argint>
    return -1;
    80004bde:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004be0:	02054763          	bltz	a0,80004c0e <sys_write+0x5c>
    80004be4:	fd840593          	addi	a1,s0,-40
    80004be8:	4505                	li	a0,1
    80004bea:	ffffd097          	auipc	ra,0xffffd
    80004bee:	57a080e7          	jalr	1402(ra) # 80002164 <argaddr>
    return -1;
    80004bf2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004bf4:	00054d63          	bltz	a0,80004c0e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004bf8:	fe442603          	lw	a2,-28(s0)
    80004bfc:	fd843583          	ld	a1,-40(s0)
    80004c00:	fe843503          	ld	a0,-24(s0)
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	4fa080e7          	jalr	1274(ra) # 800040fe <filewrite>
    80004c0c:	87aa                	mv	a5,a0
}
    80004c0e:	853e                	mv	a0,a5
    80004c10:	70a2                	ld	ra,40(sp)
    80004c12:	7402                	ld	s0,32(sp)
    80004c14:	6145                	addi	sp,sp,48
    80004c16:	8082                	ret

0000000080004c18 <sys_close>:
{
    80004c18:	1101                	addi	sp,sp,-32
    80004c1a:	ec06                	sd	ra,24(sp)
    80004c1c:	e822                	sd	s0,16(sp)
    80004c1e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c20:	fe040613          	addi	a2,s0,-32
    80004c24:	fec40593          	addi	a1,s0,-20
    80004c28:	4501                	li	a0,0
    80004c2a:	00000097          	auipc	ra,0x0
    80004c2e:	cc2080e7          	jalr	-830(ra) # 800048ec <argfd>
    return -1;
    80004c32:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c34:	02054463          	bltz	a0,80004c5c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004c38:	ffffc097          	auipc	ra,0xffffc
    80004c3c:	24e080e7          	jalr	590(ra) # 80000e86 <myproc>
    80004c40:	fec42783          	lw	a5,-20(s0)
    80004c44:	07e9                	addi	a5,a5,26
    80004c46:	078e                	slli	a5,a5,0x3
    80004c48:	97aa                	add	a5,a5,a0
    80004c4a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004c4e:	fe043503          	ld	a0,-32(s0)
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	2b0080e7          	jalr	688(ra) # 80003f02 <fileclose>
  return 0;
    80004c5a:	4781                	li	a5,0
}
    80004c5c:	853e                	mv	a0,a5
    80004c5e:	60e2                	ld	ra,24(sp)
    80004c60:	6442                	ld	s0,16(sp)
    80004c62:	6105                	addi	sp,sp,32
    80004c64:	8082                	ret

0000000080004c66 <sys_fstat>:
{
    80004c66:	1101                	addi	sp,sp,-32
    80004c68:	ec06                	sd	ra,24(sp)
    80004c6a:	e822                	sd	s0,16(sp)
    80004c6c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004c6e:	fe840613          	addi	a2,s0,-24
    80004c72:	4581                	li	a1,0
    80004c74:	4501                	li	a0,0
    80004c76:	00000097          	auipc	ra,0x0
    80004c7a:	c76080e7          	jalr	-906(ra) # 800048ec <argfd>
    return -1;
    80004c7e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004c80:	02054563          	bltz	a0,80004caa <sys_fstat+0x44>
    80004c84:	fe040593          	addi	a1,s0,-32
    80004c88:	4505                	li	a0,1
    80004c8a:	ffffd097          	auipc	ra,0xffffd
    80004c8e:	4da080e7          	jalr	1242(ra) # 80002164 <argaddr>
    return -1;
    80004c92:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004c94:	00054b63          	bltz	a0,80004caa <sys_fstat+0x44>
  return filestat(f, st);
    80004c98:	fe043583          	ld	a1,-32(s0)
    80004c9c:	fe843503          	ld	a0,-24(s0)
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	32a080e7          	jalr	810(ra) # 80003fca <filestat>
    80004ca8:	87aa                	mv	a5,a0
}
    80004caa:	853e                	mv	a0,a5
    80004cac:	60e2                	ld	ra,24(sp)
    80004cae:	6442                	ld	s0,16(sp)
    80004cb0:	6105                	addi	sp,sp,32
    80004cb2:	8082                	ret

0000000080004cb4 <sys_link>:
{
    80004cb4:	7169                	addi	sp,sp,-304
    80004cb6:	f606                	sd	ra,296(sp)
    80004cb8:	f222                	sd	s0,288(sp)
    80004cba:	ee26                	sd	s1,280(sp)
    80004cbc:	ea4a                	sd	s2,272(sp)
    80004cbe:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cc0:	08000613          	li	a2,128
    80004cc4:	ed040593          	addi	a1,s0,-304
    80004cc8:	4501                	li	a0,0
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	4bc080e7          	jalr	1212(ra) # 80002186 <argstr>
    return -1;
    80004cd2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cd4:	10054e63          	bltz	a0,80004df0 <sys_link+0x13c>
    80004cd8:	08000613          	li	a2,128
    80004cdc:	f5040593          	addi	a1,s0,-176
    80004ce0:	4505                	li	a0,1
    80004ce2:	ffffd097          	auipc	ra,0xffffd
    80004ce6:	4a4080e7          	jalr	1188(ra) # 80002186 <argstr>
    return -1;
    80004cea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cec:	10054263          	bltz	a0,80004df0 <sys_link+0x13c>
  begin_op();
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	d46080e7          	jalr	-698(ra) # 80003a36 <begin_op>
  if((ip = namei(old)) == 0){
    80004cf8:	ed040513          	addi	a0,s0,-304
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	b1e080e7          	jalr	-1250(ra) # 8000381a <namei>
    80004d04:	84aa                	mv	s1,a0
    80004d06:	c551                	beqz	a0,80004d92 <sys_link+0xde>
  ilock(ip);
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	35c080e7          	jalr	860(ra) # 80003064 <ilock>
  if(ip->type == T_DIR){
    80004d10:	04449703          	lh	a4,68(s1)
    80004d14:	4785                	li	a5,1
    80004d16:	08f70463          	beq	a4,a5,80004d9e <sys_link+0xea>
  ip->nlink++;
    80004d1a:	04a4d783          	lhu	a5,74(s1)
    80004d1e:	2785                	addiw	a5,a5,1
    80004d20:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	274080e7          	jalr	628(ra) # 80002f9a <iupdate>
  iunlock(ip);
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	3f6080e7          	jalr	1014(ra) # 80003126 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d38:	fd040593          	addi	a1,s0,-48
    80004d3c:	f5040513          	addi	a0,s0,-176
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	af8080e7          	jalr	-1288(ra) # 80003838 <nameiparent>
    80004d48:	892a                	mv	s2,a0
    80004d4a:	c935                	beqz	a0,80004dbe <sys_link+0x10a>
  ilock(dp);
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	318080e7          	jalr	792(ra) # 80003064 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d54:	00092703          	lw	a4,0(s2)
    80004d58:	409c                	lw	a5,0(s1)
    80004d5a:	04f71d63          	bne	a4,a5,80004db4 <sys_link+0x100>
    80004d5e:	40d0                	lw	a2,4(s1)
    80004d60:	fd040593          	addi	a1,s0,-48
    80004d64:	854a                	mv	a0,s2
    80004d66:	fffff097          	auipc	ra,0xfffff
    80004d6a:	9f2080e7          	jalr	-1550(ra) # 80003758 <dirlink>
    80004d6e:	04054363          	bltz	a0,80004db4 <sys_link+0x100>
  iunlockput(dp);
    80004d72:	854a                	mv	a0,s2
    80004d74:	ffffe097          	auipc	ra,0xffffe
    80004d78:	552080e7          	jalr	1362(ra) # 800032c6 <iunlockput>
  iput(ip);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	4a0080e7          	jalr	1184(ra) # 8000321e <iput>
  end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	d30080e7          	jalr	-720(ra) # 80003ab6 <end_op>
  return 0;
    80004d8e:	4781                	li	a5,0
    80004d90:	a085                	j	80004df0 <sys_link+0x13c>
    end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	d24080e7          	jalr	-732(ra) # 80003ab6 <end_op>
    return -1;
    80004d9a:	57fd                	li	a5,-1
    80004d9c:	a891                	j	80004df0 <sys_link+0x13c>
    iunlockput(ip);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	526080e7          	jalr	1318(ra) # 800032c6 <iunlockput>
    end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	d0e080e7          	jalr	-754(ra) # 80003ab6 <end_op>
    return -1;
    80004db0:	57fd                	li	a5,-1
    80004db2:	a83d                	j	80004df0 <sys_link+0x13c>
    iunlockput(dp);
    80004db4:	854a                	mv	a0,s2
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	510080e7          	jalr	1296(ra) # 800032c6 <iunlockput>
  ilock(ip);
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	ffffe097          	auipc	ra,0xffffe
    80004dc4:	2a4080e7          	jalr	676(ra) # 80003064 <ilock>
  ip->nlink--;
    80004dc8:	04a4d783          	lhu	a5,74(s1)
    80004dcc:	37fd                	addiw	a5,a5,-1
    80004dce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dd2:	8526                	mv	a0,s1
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	1c6080e7          	jalr	454(ra) # 80002f9a <iupdate>
  iunlockput(ip);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	4e8080e7          	jalr	1256(ra) # 800032c6 <iunlockput>
  end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	cd0080e7          	jalr	-816(ra) # 80003ab6 <end_op>
  return -1;
    80004dee:	57fd                	li	a5,-1
}
    80004df0:	853e                	mv	a0,a5
    80004df2:	70b2                	ld	ra,296(sp)
    80004df4:	7412                	ld	s0,288(sp)
    80004df6:	64f2                	ld	s1,280(sp)
    80004df8:	6952                	ld	s2,272(sp)
    80004dfa:	6155                	addi	sp,sp,304
    80004dfc:	8082                	ret

0000000080004dfe <sys_unlink>:
{
    80004dfe:	7151                	addi	sp,sp,-240
    80004e00:	f586                	sd	ra,232(sp)
    80004e02:	f1a2                	sd	s0,224(sp)
    80004e04:	eda6                	sd	s1,216(sp)
    80004e06:	e9ca                	sd	s2,208(sp)
    80004e08:	e5ce                	sd	s3,200(sp)
    80004e0a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004e0c:	08000613          	li	a2,128
    80004e10:	f3040593          	addi	a1,s0,-208
    80004e14:	4501                	li	a0,0
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	370080e7          	jalr	880(ra) # 80002186 <argstr>
    80004e1e:	18054163          	bltz	a0,80004fa0 <sys_unlink+0x1a2>
  begin_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	c14080e7          	jalr	-1004(ra) # 80003a36 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004e2a:	fb040593          	addi	a1,s0,-80
    80004e2e:	f3040513          	addi	a0,s0,-208
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	a06080e7          	jalr	-1530(ra) # 80003838 <nameiparent>
    80004e3a:	84aa                	mv	s1,a0
    80004e3c:	c979                	beqz	a0,80004f12 <sys_unlink+0x114>
  ilock(dp);
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	226080e7          	jalr	550(ra) # 80003064 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004e46:	00004597          	auipc	a1,0x4
    80004e4a:	86258593          	addi	a1,a1,-1950 # 800086a8 <syscalls+0x2f0>
    80004e4e:	fb040513          	addi	a0,s0,-80
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	6dc080e7          	jalr	1756(ra) # 8000352e <namecmp>
    80004e5a:	14050a63          	beqz	a0,80004fae <sys_unlink+0x1b0>
    80004e5e:	00004597          	auipc	a1,0x4
    80004e62:	85258593          	addi	a1,a1,-1966 # 800086b0 <syscalls+0x2f8>
    80004e66:	fb040513          	addi	a0,s0,-80
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	6c4080e7          	jalr	1732(ra) # 8000352e <namecmp>
    80004e72:	12050e63          	beqz	a0,80004fae <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e76:	f2c40613          	addi	a2,s0,-212
    80004e7a:	fb040593          	addi	a1,s0,-80
    80004e7e:	8526                	mv	a0,s1
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	6c8080e7          	jalr	1736(ra) # 80003548 <dirlookup>
    80004e88:	892a                	mv	s2,a0
    80004e8a:	12050263          	beqz	a0,80004fae <sys_unlink+0x1b0>
  ilock(ip);
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	1d6080e7          	jalr	470(ra) # 80003064 <ilock>
  if(ip->nlink < 1)
    80004e96:	04a91783          	lh	a5,74(s2)
    80004e9a:	08f05263          	blez	a5,80004f1e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e9e:	04491703          	lh	a4,68(s2)
    80004ea2:	4785                	li	a5,1
    80004ea4:	08f70563          	beq	a4,a5,80004f2e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ea8:	4641                	li	a2,16
    80004eaa:	4581                	li	a1,0
    80004eac:	fc040513          	addi	a0,s0,-64
    80004eb0:	ffffb097          	auipc	ra,0xffffb
    80004eb4:	2c8080e7          	jalr	712(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004eb8:	4741                	li	a4,16
    80004eba:	f2c42683          	lw	a3,-212(s0)
    80004ebe:	fc040613          	addi	a2,s0,-64
    80004ec2:	4581                	li	a1,0
    80004ec4:	8526                	mv	a0,s1
    80004ec6:	ffffe097          	auipc	ra,0xffffe
    80004eca:	54a080e7          	jalr	1354(ra) # 80003410 <writei>
    80004ece:	47c1                	li	a5,16
    80004ed0:	0af51563          	bne	a0,a5,80004f7a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ed4:	04491703          	lh	a4,68(s2)
    80004ed8:	4785                	li	a5,1
    80004eda:	0af70863          	beq	a4,a5,80004f8a <sys_unlink+0x18c>
  iunlockput(dp);
    80004ede:	8526                	mv	a0,s1
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	3e6080e7          	jalr	998(ra) # 800032c6 <iunlockput>
  ip->nlink--;
    80004ee8:	04a95783          	lhu	a5,74(s2)
    80004eec:	37fd                	addiw	a5,a5,-1
    80004eee:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ef2:	854a                	mv	a0,s2
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	0a6080e7          	jalr	166(ra) # 80002f9a <iupdate>
  iunlockput(ip);
    80004efc:	854a                	mv	a0,s2
    80004efe:	ffffe097          	auipc	ra,0xffffe
    80004f02:	3c8080e7          	jalr	968(ra) # 800032c6 <iunlockput>
  end_op();
    80004f06:	fffff097          	auipc	ra,0xfffff
    80004f0a:	bb0080e7          	jalr	-1104(ra) # 80003ab6 <end_op>
  return 0;
    80004f0e:	4501                	li	a0,0
    80004f10:	a84d                	j	80004fc2 <sys_unlink+0x1c4>
    end_op();
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	ba4080e7          	jalr	-1116(ra) # 80003ab6 <end_op>
    return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	a05d                	j	80004fc2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004f1e:	00003517          	auipc	a0,0x3
    80004f22:	7ba50513          	addi	a0,a0,1978 # 800086d8 <syscalls+0x320>
    80004f26:	00001097          	auipc	ra,0x1
    80004f2a:	1f2080e7          	jalr	498(ra) # 80006118 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f2e:	04c92703          	lw	a4,76(s2)
    80004f32:	02000793          	li	a5,32
    80004f36:	f6e7f9e3          	bgeu	a5,a4,80004ea8 <sys_unlink+0xaa>
    80004f3a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f3e:	4741                	li	a4,16
    80004f40:	86ce                	mv	a3,s3
    80004f42:	f1840613          	addi	a2,s0,-232
    80004f46:	4581                	li	a1,0
    80004f48:	854a                	mv	a0,s2
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	3ce080e7          	jalr	974(ra) # 80003318 <readi>
    80004f52:	47c1                	li	a5,16
    80004f54:	00f51b63          	bne	a0,a5,80004f6a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004f58:	f1845783          	lhu	a5,-232(s0)
    80004f5c:	e7a1                	bnez	a5,80004fa4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f5e:	29c1                	addiw	s3,s3,16
    80004f60:	04c92783          	lw	a5,76(s2)
    80004f64:	fcf9ede3          	bltu	s3,a5,80004f3e <sys_unlink+0x140>
    80004f68:	b781                	j	80004ea8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004f6a:	00003517          	auipc	a0,0x3
    80004f6e:	78650513          	addi	a0,a0,1926 # 800086f0 <syscalls+0x338>
    80004f72:	00001097          	auipc	ra,0x1
    80004f76:	1a6080e7          	jalr	422(ra) # 80006118 <panic>
    panic("unlink: writei");
    80004f7a:	00003517          	auipc	a0,0x3
    80004f7e:	78e50513          	addi	a0,a0,1934 # 80008708 <syscalls+0x350>
    80004f82:	00001097          	auipc	ra,0x1
    80004f86:	196080e7          	jalr	406(ra) # 80006118 <panic>
    dp->nlink--;
    80004f8a:	04a4d783          	lhu	a5,74(s1)
    80004f8e:	37fd                	addiw	a5,a5,-1
    80004f90:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f94:	8526                	mv	a0,s1
    80004f96:	ffffe097          	auipc	ra,0xffffe
    80004f9a:	004080e7          	jalr	4(ra) # 80002f9a <iupdate>
    80004f9e:	b781                	j	80004ede <sys_unlink+0xe0>
    return -1;
    80004fa0:	557d                	li	a0,-1
    80004fa2:	a005                	j	80004fc2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004fa4:	854a                	mv	a0,s2
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	320080e7          	jalr	800(ra) # 800032c6 <iunlockput>
  iunlockput(dp);
    80004fae:	8526                	mv	a0,s1
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	316080e7          	jalr	790(ra) # 800032c6 <iunlockput>
  end_op();
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	afe080e7          	jalr	-1282(ra) # 80003ab6 <end_op>
  return -1;
    80004fc0:	557d                	li	a0,-1
}
    80004fc2:	70ae                	ld	ra,232(sp)
    80004fc4:	740e                	ld	s0,224(sp)
    80004fc6:	64ee                	ld	s1,216(sp)
    80004fc8:	694e                	ld	s2,208(sp)
    80004fca:	69ae                	ld	s3,200(sp)
    80004fcc:	616d                	addi	sp,sp,240
    80004fce:	8082                	ret

0000000080004fd0 <sys_open>:

uint64
sys_open(void)
{
    80004fd0:	7131                	addi	sp,sp,-192
    80004fd2:	fd06                	sd	ra,184(sp)
    80004fd4:	f922                	sd	s0,176(sp)
    80004fd6:	f526                	sd	s1,168(sp)
    80004fd8:	f14a                	sd	s2,160(sp)
    80004fda:	ed4e                	sd	s3,152(sp)
    80004fdc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004fde:	08000613          	li	a2,128
    80004fe2:	f5040593          	addi	a1,s0,-176
    80004fe6:	4501                	li	a0,0
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	19e080e7          	jalr	414(ra) # 80002186 <argstr>
    return -1;
    80004ff0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ff2:	0c054163          	bltz	a0,800050b4 <sys_open+0xe4>
    80004ff6:	f4c40593          	addi	a1,s0,-180
    80004ffa:	4505                	li	a0,1
    80004ffc:	ffffd097          	auipc	ra,0xffffd
    80005000:	146080e7          	jalr	326(ra) # 80002142 <argint>
    80005004:	0a054863          	bltz	a0,800050b4 <sys_open+0xe4>

  begin_op();
    80005008:	fffff097          	auipc	ra,0xfffff
    8000500c:	a2e080e7          	jalr	-1490(ra) # 80003a36 <begin_op>

  if(omode & O_CREATE){
    80005010:	f4c42783          	lw	a5,-180(s0)
    80005014:	2007f793          	andi	a5,a5,512
    80005018:	cbdd                	beqz	a5,800050ce <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    8000501a:	4681                	li	a3,0
    8000501c:	4601                	li	a2,0
    8000501e:	4589                	li	a1,2
    80005020:	f5040513          	addi	a0,s0,-176
    80005024:	00000097          	auipc	ra,0x0
    80005028:	972080e7          	jalr	-1678(ra) # 80004996 <create>
    8000502c:	892a                	mv	s2,a0
    if(ip == 0){
    8000502e:	c959                	beqz	a0,800050c4 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005030:	04491703          	lh	a4,68(s2)
    80005034:	478d                	li	a5,3
    80005036:	00f71763          	bne	a4,a5,80005044 <sys_open+0x74>
    8000503a:	04695703          	lhu	a4,70(s2)
    8000503e:	47a5                	li	a5,9
    80005040:	0ce7ec63          	bltu	a5,a4,80005118 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	e02080e7          	jalr	-510(ra) # 80003e46 <filealloc>
    8000504c:	89aa                	mv	s3,a0
    8000504e:	10050263          	beqz	a0,80005152 <sys_open+0x182>
    80005052:	00000097          	auipc	ra,0x0
    80005056:	902080e7          	jalr	-1790(ra) # 80004954 <fdalloc>
    8000505a:	84aa                	mv	s1,a0
    8000505c:	0e054663          	bltz	a0,80005148 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005060:	04491703          	lh	a4,68(s2)
    80005064:	478d                	li	a5,3
    80005066:	0cf70463          	beq	a4,a5,8000512e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000506a:	4789                	li	a5,2
    8000506c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005070:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005074:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005078:	f4c42783          	lw	a5,-180(s0)
    8000507c:	0017c713          	xori	a4,a5,1
    80005080:	8b05                	andi	a4,a4,1
    80005082:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005086:	0037f713          	andi	a4,a5,3
    8000508a:	00e03733          	snez	a4,a4
    8000508e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005092:	4007f793          	andi	a5,a5,1024
    80005096:	c791                	beqz	a5,800050a2 <sys_open+0xd2>
    80005098:	04491703          	lh	a4,68(s2)
    8000509c:	4789                	li	a5,2
    8000509e:	08f70f63          	beq	a4,a5,8000513c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800050a2:	854a                	mv	a0,s2
    800050a4:	ffffe097          	auipc	ra,0xffffe
    800050a8:	082080e7          	jalr	130(ra) # 80003126 <iunlock>
  end_op();
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	a0a080e7          	jalr	-1526(ra) # 80003ab6 <end_op>

  return fd;
}
    800050b4:	8526                	mv	a0,s1
    800050b6:	70ea                	ld	ra,184(sp)
    800050b8:	744a                	ld	s0,176(sp)
    800050ba:	74aa                	ld	s1,168(sp)
    800050bc:	790a                	ld	s2,160(sp)
    800050be:	69ea                	ld	s3,152(sp)
    800050c0:	6129                	addi	sp,sp,192
    800050c2:	8082                	ret
      end_op();
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	9f2080e7          	jalr	-1550(ra) # 80003ab6 <end_op>
      return -1;
    800050cc:	b7e5                	j	800050b4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800050ce:	f5040513          	addi	a0,s0,-176
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	748080e7          	jalr	1864(ra) # 8000381a <namei>
    800050da:	892a                	mv	s2,a0
    800050dc:	c905                	beqz	a0,8000510c <sys_open+0x13c>
    ilock(ip);
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	f86080e7          	jalr	-122(ra) # 80003064 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800050e6:	04491703          	lh	a4,68(s2)
    800050ea:	4785                	li	a5,1
    800050ec:	f4f712e3          	bne	a4,a5,80005030 <sys_open+0x60>
    800050f0:	f4c42783          	lw	a5,-180(s0)
    800050f4:	dba1                	beqz	a5,80005044 <sys_open+0x74>
      iunlockput(ip);
    800050f6:	854a                	mv	a0,s2
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	1ce080e7          	jalr	462(ra) # 800032c6 <iunlockput>
      end_op();
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	9b6080e7          	jalr	-1610(ra) # 80003ab6 <end_op>
      return -1;
    80005108:	54fd                	li	s1,-1
    8000510a:	b76d                	j	800050b4 <sys_open+0xe4>
      end_op();
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	9aa080e7          	jalr	-1622(ra) # 80003ab6 <end_op>
      return -1;
    80005114:	54fd                	li	s1,-1
    80005116:	bf79                	j	800050b4 <sys_open+0xe4>
    iunlockput(ip);
    80005118:	854a                	mv	a0,s2
    8000511a:	ffffe097          	auipc	ra,0xffffe
    8000511e:	1ac080e7          	jalr	428(ra) # 800032c6 <iunlockput>
    end_op();
    80005122:	fffff097          	auipc	ra,0xfffff
    80005126:	994080e7          	jalr	-1644(ra) # 80003ab6 <end_op>
    return -1;
    8000512a:	54fd                	li	s1,-1
    8000512c:	b761                	j	800050b4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000512e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005132:	04691783          	lh	a5,70(s2)
    80005136:	02f99223          	sh	a5,36(s3)
    8000513a:	bf2d                	j	80005074 <sys_open+0xa4>
    itrunc(ip);
    8000513c:	854a                	mv	a0,s2
    8000513e:	ffffe097          	auipc	ra,0xffffe
    80005142:	034080e7          	jalr	52(ra) # 80003172 <itrunc>
    80005146:	bfb1                	j	800050a2 <sys_open+0xd2>
      fileclose(f);
    80005148:	854e                	mv	a0,s3
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	db8080e7          	jalr	-584(ra) # 80003f02 <fileclose>
    iunlockput(ip);
    80005152:	854a                	mv	a0,s2
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	172080e7          	jalr	370(ra) # 800032c6 <iunlockput>
    end_op();
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	95a080e7          	jalr	-1702(ra) # 80003ab6 <end_op>
    return -1;
    80005164:	54fd                	li	s1,-1
    80005166:	b7b9                	j	800050b4 <sys_open+0xe4>

0000000080005168 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005168:	7175                	addi	sp,sp,-144
    8000516a:	e506                	sd	ra,136(sp)
    8000516c:	e122                	sd	s0,128(sp)
    8000516e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	8c6080e7          	jalr	-1850(ra) # 80003a36 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005178:	08000613          	li	a2,128
    8000517c:	f7040593          	addi	a1,s0,-144
    80005180:	4501                	li	a0,0
    80005182:	ffffd097          	auipc	ra,0xffffd
    80005186:	004080e7          	jalr	4(ra) # 80002186 <argstr>
    8000518a:	02054963          	bltz	a0,800051bc <sys_mkdir+0x54>
    8000518e:	4681                	li	a3,0
    80005190:	4601                	li	a2,0
    80005192:	4585                	li	a1,1
    80005194:	f7040513          	addi	a0,s0,-144
    80005198:	fffff097          	auipc	ra,0xfffff
    8000519c:	7fe080e7          	jalr	2046(ra) # 80004996 <create>
    800051a0:	cd11                	beqz	a0,800051bc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800051a2:	ffffe097          	auipc	ra,0xffffe
    800051a6:	124080e7          	jalr	292(ra) # 800032c6 <iunlockput>
  end_op();
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	90c080e7          	jalr	-1780(ra) # 80003ab6 <end_op>
  return 0;
    800051b2:	4501                	li	a0,0
}
    800051b4:	60aa                	ld	ra,136(sp)
    800051b6:	640a                	ld	s0,128(sp)
    800051b8:	6149                	addi	sp,sp,144
    800051ba:	8082                	ret
    end_op();
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	8fa080e7          	jalr	-1798(ra) # 80003ab6 <end_op>
    return -1;
    800051c4:	557d                	li	a0,-1
    800051c6:	b7fd                	j	800051b4 <sys_mkdir+0x4c>

00000000800051c8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800051c8:	7135                	addi	sp,sp,-160
    800051ca:	ed06                	sd	ra,152(sp)
    800051cc:	e922                	sd	s0,144(sp)
    800051ce:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	866080e7          	jalr	-1946(ra) # 80003a36 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051d8:	08000613          	li	a2,128
    800051dc:	f7040593          	addi	a1,s0,-144
    800051e0:	4501                	li	a0,0
    800051e2:	ffffd097          	auipc	ra,0xffffd
    800051e6:	fa4080e7          	jalr	-92(ra) # 80002186 <argstr>
    800051ea:	04054a63          	bltz	a0,8000523e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800051ee:	f6c40593          	addi	a1,s0,-148
    800051f2:	4505                	li	a0,1
    800051f4:	ffffd097          	auipc	ra,0xffffd
    800051f8:	f4e080e7          	jalr	-178(ra) # 80002142 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051fc:	04054163          	bltz	a0,8000523e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005200:	f6840593          	addi	a1,s0,-152
    80005204:	4509                	li	a0,2
    80005206:	ffffd097          	auipc	ra,0xffffd
    8000520a:	f3c080e7          	jalr	-196(ra) # 80002142 <argint>
     argint(1, &major) < 0 ||
    8000520e:	02054863          	bltz	a0,8000523e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005212:	f6841683          	lh	a3,-152(s0)
    80005216:	f6c41603          	lh	a2,-148(s0)
    8000521a:	458d                	li	a1,3
    8000521c:	f7040513          	addi	a0,s0,-144
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	776080e7          	jalr	1910(ra) # 80004996 <create>
     argint(2, &minor) < 0 ||
    80005228:	c919                	beqz	a0,8000523e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000522a:	ffffe097          	auipc	ra,0xffffe
    8000522e:	09c080e7          	jalr	156(ra) # 800032c6 <iunlockput>
  end_op();
    80005232:	fffff097          	auipc	ra,0xfffff
    80005236:	884080e7          	jalr	-1916(ra) # 80003ab6 <end_op>
  return 0;
    8000523a:	4501                	li	a0,0
    8000523c:	a031                	j	80005248 <sys_mknod+0x80>
    end_op();
    8000523e:	fffff097          	auipc	ra,0xfffff
    80005242:	878080e7          	jalr	-1928(ra) # 80003ab6 <end_op>
    return -1;
    80005246:	557d                	li	a0,-1
}
    80005248:	60ea                	ld	ra,152(sp)
    8000524a:	644a                	ld	s0,144(sp)
    8000524c:	610d                	addi	sp,sp,160
    8000524e:	8082                	ret

0000000080005250 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005250:	7135                	addi	sp,sp,-160
    80005252:	ed06                	sd	ra,152(sp)
    80005254:	e922                	sd	s0,144(sp)
    80005256:	e526                	sd	s1,136(sp)
    80005258:	e14a                	sd	s2,128(sp)
    8000525a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	c2a080e7          	jalr	-982(ra) # 80000e86 <myproc>
    80005264:	892a                	mv	s2,a0
  
  begin_op();
    80005266:	ffffe097          	auipc	ra,0xffffe
    8000526a:	7d0080e7          	jalr	2000(ra) # 80003a36 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000526e:	08000613          	li	a2,128
    80005272:	f6040593          	addi	a1,s0,-160
    80005276:	4501                	li	a0,0
    80005278:	ffffd097          	auipc	ra,0xffffd
    8000527c:	f0e080e7          	jalr	-242(ra) # 80002186 <argstr>
    80005280:	04054b63          	bltz	a0,800052d6 <sys_chdir+0x86>
    80005284:	f6040513          	addi	a0,s0,-160
    80005288:	ffffe097          	auipc	ra,0xffffe
    8000528c:	592080e7          	jalr	1426(ra) # 8000381a <namei>
    80005290:	84aa                	mv	s1,a0
    80005292:	c131                	beqz	a0,800052d6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005294:	ffffe097          	auipc	ra,0xffffe
    80005298:	dd0080e7          	jalr	-560(ra) # 80003064 <ilock>
  if(ip->type != T_DIR){
    8000529c:	04449703          	lh	a4,68(s1)
    800052a0:	4785                	li	a5,1
    800052a2:	04f71063          	bne	a4,a5,800052e2 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800052a6:	8526                	mv	a0,s1
    800052a8:	ffffe097          	auipc	ra,0xffffe
    800052ac:	e7e080e7          	jalr	-386(ra) # 80003126 <iunlock>
  iput(p->cwd);
    800052b0:	15093503          	ld	a0,336(s2)
    800052b4:	ffffe097          	auipc	ra,0xffffe
    800052b8:	f6a080e7          	jalr	-150(ra) # 8000321e <iput>
  end_op();
    800052bc:	ffffe097          	auipc	ra,0xffffe
    800052c0:	7fa080e7          	jalr	2042(ra) # 80003ab6 <end_op>
  p->cwd = ip;
    800052c4:	14993823          	sd	s1,336(s2)
  return 0;
    800052c8:	4501                	li	a0,0
}
    800052ca:	60ea                	ld	ra,152(sp)
    800052cc:	644a                	ld	s0,144(sp)
    800052ce:	64aa                	ld	s1,136(sp)
    800052d0:	690a                	ld	s2,128(sp)
    800052d2:	610d                	addi	sp,sp,160
    800052d4:	8082                	ret
    end_op();
    800052d6:	ffffe097          	auipc	ra,0xffffe
    800052da:	7e0080e7          	jalr	2016(ra) # 80003ab6 <end_op>
    return -1;
    800052de:	557d                	li	a0,-1
    800052e0:	b7ed                	j	800052ca <sys_chdir+0x7a>
    iunlockput(ip);
    800052e2:	8526                	mv	a0,s1
    800052e4:	ffffe097          	auipc	ra,0xffffe
    800052e8:	fe2080e7          	jalr	-30(ra) # 800032c6 <iunlockput>
    end_op();
    800052ec:	ffffe097          	auipc	ra,0xffffe
    800052f0:	7ca080e7          	jalr	1994(ra) # 80003ab6 <end_op>
    return -1;
    800052f4:	557d                	li	a0,-1
    800052f6:	bfd1                	j	800052ca <sys_chdir+0x7a>

00000000800052f8 <sys_exec>:

uint64
sys_exec(void)
{
    800052f8:	7145                	addi	sp,sp,-464
    800052fa:	e786                	sd	ra,456(sp)
    800052fc:	e3a2                	sd	s0,448(sp)
    800052fe:	ff26                	sd	s1,440(sp)
    80005300:	fb4a                	sd	s2,432(sp)
    80005302:	f74e                	sd	s3,424(sp)
    80005304:	f352                	sd	s4,416(sp)
    80005306:	ef56                	sd	s5,408(sp)
    80005308:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000530a:	08000613          	li	a2,128
    8000530e:	f4040593          	addi	a1,s0,-192
    80005312:	4501                	li	a0,0
    80005314:	ffffd097          	auipc	ra,0xffffd
    80005318:	e72080e7          	jalr	-398(ra) # 80002186 <argstr>
    return -1;
    8000531c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000531e:	0c054a63          	bltz	a0,800053f2 <sys_exec+0xfa>
    80005322:	e3840593          	addi	a1,s0,-456
    80005326:	4505                	li	a0,1
    80005328:	ffffd097          	auipc	ra,0xffffd
    8000532c:	e3c080e7          	jalr	-452(ra) # 80002164 <argaddr>
    80005330:	0c054163          	bltz	a0,800053f2 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005334:	10000613          	li	a2,256
    80005338:	4581                	li	a1,0
    8000533a:	e4040513          	addi	a0,s0,-448
    8000533e:	ffffb097          	auipc	ra,0xffffb
    80005342:	e3a080e7          	jalr	-454(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005346:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000534a:	89a6                	mv	s3,s1
    8000534c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000534e:	02000a13          	li	s4,32
    80005352:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005356:	00391513          	slli	a0,s2,0x3
    8000535a:	e3040593          	addi	a1,s0,-464
    8000535e:	e3843783          	ld	a5,-456(s0)
    80005362:	953e                	add	a0,a0,a5
    80005364:	ffffd097          	auipc	ra,0xffffd
    80005368:	d44080e7          	jalr	-700(ra) # 800020a8 <fetchaddr>
    8000536c:	02054a63          	bltz	a0,800053a0 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005370:	e3043783          	ld	a5,-464(s0)
    80005374:	c3b9                	beqz	a5,800053ba <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005376:	ffffb097          	auipc	ra,0xffffb
    8000537a:	da2080e7          	jalr	-606(ra) # 80000118 <kalloc>
    8000537e:	85aa                	mv	a1,a0
    80005380:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005384:	cd11                	beqz	a0,800053a0 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005386:	6605                	lui	a2,0x1
    80005388:	e3043503          	ld	a0,-464(s0)
    8000538c:	ffffd097          	auipc	ra,0xffffd
    80005390:	d6e080e7          	jalr	-658(ra) # 800020fa <fetchstr>
    80005394:	00054663          	bltz	a0,800053a0 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005398:	0905                	addi	s2,s2,1
    8000539a:	09a1                	addi	s3,s3,8
    8000539c:	fb491be3          	bne	s2,s4,80005352 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053a0:	10048913          	addi	s2,s1,256
    800053a4:	6088                	ld	a0,0(s1)
    800053a6:	c529                	beqz	a0,800053f0 <sys_exec+0xf8>
    kfree(argv[i]);
    800053a8:	ffffb097          	auipc	ra,0xffffb
    800053ac:	c74080e7          	jalr	-908(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053b0:	04a1                	addi	s1,s1,8
    800053b2:	ff2499e3          	bne	s1,s2,800053a4 <sys_exec+0xac>
  return -1;
    800053b6:	597d                	li	s2,-1
    800053b8:	a82d                	j	800053f2 <sys_exec+0xfa>
      argv[i] = 0;
    800053ba:	0a8e                	slli	s5,s5,0x3
    800053bc:	fc040793          	addi	a5,s0,-64
    800053c0:	9abe                	add	s5,s5,a5
    800053c2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800053c6:	e4040593          	addi	a1,s0,-448
    800053ca:	f4040513          	addi	a0,s0,-192
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	194080e7          	jalr	404(ra) # 80004562 <exec>
    800053d6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053d8:	10048993          	addi	s3,s1,256
    800053dc:	6088                	ld	a0,0(s1)
    800053de:	c911                	beqz	a0,800053f2 <sys_exec+0xfa>
    kfree(argv[i]);
    800053e0:	ffffb097          	auipc	ra,0xffffb
    800053e4:	c3c080e7          	jalr	-964(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053e8:	04a1                	addi	s1,s1,8
    800053ea:	ff3499e3          	bne	s1,s3,800053dc <sys_exec+0xe4>
    800053ee:	a011                	j	800053f2 <sys_exec+0xfa>
  return -1;
    800053f0:	597d                	li	s2,-1
}
    800053f2:	854a                	mv	a0,s2
    800053f4:	60be                	ld	ra,456(sp)
    800053f6:	641e                	ld	s0,448(sp)
    800053f8:	74fa                	ld	s1,440(sp)
    800053fa:	795a                	ld	s2,432(sp)
    800053fc:	79ba                	ld	s3,424(sp)
    800053fe:	7a1a                	ld	s4,416(sp)
    80005400:	6afa                	ld	s5,408(sp)
    80005402:	6179                	addi	sp,sp,464
    80005404:	8082                	ret

0000000080005406 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005406:	7139                	addi	sp,sp,-64
    80005408:	fc06                	sd	ra,56(sp)
    8000540a:	f822                	sd	s0,48(sp)
    8000540c:	f426                	sd	s1,40(sp)
    8000540e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005410:	ffffc097          	auipc	ra,0xffffc
    80005414:	a76080e7          	jalr	-1418(ra) # 80000e86 <myproc>
    80005418:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000541a:	fd840593          	addi	a1,s0,-40
    8000541e:	4501                	li	a0,0
    80005420:	ffffd097          	auipc	ra,0xffffd
    80005424:	d44080e7          	jalr	-700(ra) # 80002164 <argaddr>
    return -1;
    80005428:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000542a:	0e054063          	bltz	a0,8000550a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000542e:	fc840593          	addi	a1,s0,-56
    80005432:	fd040513          	addi	a0,s0,-48
    80005436:	fffff097          	auipc	ra,0xfffff
    8000543a:	dfc080e7          	jalr	-516(ra) # 80004232 <pipealloc>
    return -1;
    8000543e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005440:	0c054563          	bltz	a0,8000550a <sys_pipe+0x104>
  fd0 = -1;
    80005444:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005448:	fd043503          	ld	a0,-48(s0)
    8000544c:	fffff097          	auipc	ra,0xfffff
    80005450:	508080e7          	jalr	1288(ra) # 80004954 <fdalloc>
    80005454:	fca42223          	sw	a0,-60(s0)
    80005458:	08054c63          	bltz	a0,800054f0 <sys_pipe+0xea>
    8000545c:	fc843503          	ld	a0,-56(s0)
    80005460:	fffff097          	auipc	ra,0xfffff
    80005464:	4f4080e7          	jalr	1268(ra) # 80004954 <fdalloc>
    80005468:	fca42023          	sw	a0,-64(s0)
    8000546c:	06054863          	bltz	a0,800054dc <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005470:	4691                	li	a3,4
    80005472:	fc440613          	addi	a2,s0,-60
    80005476:	fd843583          	ld	a1,-40(s0)
    8000547a:	68a8                	ld	a0,80(s1)
    8000547c:	ffffb097          	auipc	ra,0xffffb
    80005480:	65e080e7          	jalr	1630(ra) # 80000ada <copyout>
    80005484:	02054063          	bltz	a0,800054a4 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005488:	4691                	li	a3,4
    8000548a:	fc040613          	addi	a2,s0,-64
    8000548e:	fd843583          	ld	a1,-40(s0)
    80005492:	0591                	addi	a1,a1,4
    80005494:	68a8                	ld	a0,80(s1)
    80005496:	ffffb097          	auipc	ra,0xffffb
    8000549a:	644080e7          	jalr	1604(ra) # 80000ada <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000549e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054a0:	06055563          	bgez	a0,8000550a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800054a4:	fc442783          	lw	a5,-60(s0)
    800054a8:	07e9                	addi	a5,a5,26
    800054aa:	078e                	slli	a5,a5,0x3
    800054ac:	97a6                	add	a5,a5,s1
    800054ae:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054b2:	fc042503          	lw	a0,-64(s0)
    800054b6:	0569                	addi	a0,a0,26
    800054b8:	050e                	slli	a0,a0,0x3
    800054ba:	9526                	add	a0,a0,s1
    800054bc:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800054c0:	fd043503          	ld	a0,-48(s0)
    800054c4:	fffff097          	auipc	ra,0xfffff
    800054c8:	a3e080e7          	jalr	-1474(ra) # 80003f02 <fileclose>
    fileclose(wf);
    800054cc:	fc843503          	ld	a0,-56(s0)
    800054d0:	fffff097          	auipc	ra,0xfffff
    800054d4:	a32080e7          	jalr	-1486(ra) # 80003f02 <fileclose>
    return -1;
    800054d8:	57fd                	li	a5,-1
    800054da:	a805                	j	8000550a <sys_pipe+0x104>
    if(fd0 >= 0)
    800054dc:	fc442783          	lw	a5,-60(s0)
    800054e0:	0007c863          	bltz	a5,800054f0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800054e4:	01a78513          	addi	a0,a5,26
    800054e8:	050e                	slli	a0,a0,0x3
    800054ea:	9526                	add	a0,a0,s1
    800054ec:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800054f0:	fd043503          	ld	a0,-48(s0)
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	a0e080e7          	jalr	-1522(ra) # 80003f02 <fileclose>
    fileclose(wf);
    800054fc:	fc843503          	ld	a0,-56(s0)
    80005500:	fffff097          	auipc	ra,0xfffff
    80005504:	a02080e7          	jalr	-1534(ra) # 80003f02 <fileclose>
    return -1;
    80005508:	57fd                	li	a5,-1
}
    8000550a:	853e                	mv	a0,a5
    8000550c:	70e2                	ld	ra,56(sp)
    8000550e:	7442                	ld	s0,48(sp)
    80005510:	74a2                	ld	s1,40(sp)
    80005512:	6121                	addi	sp,sp,64
    80005514:	8082                	ret
	...

0000000080005520 <kernelvec>:
    80005520:	7111                	addi	sp,sp,-256
    80005522:	e006                	sd	ra,0(sp)
    80005524:	e40a                	sd	sp,8(sp)
    80005526:	e80e                	sd	gp,16(sp)
    80005528:	ec12                	sd	tp,24(sp)
    8000552a:	f016                	sd	t0,32(sp)
    8000552c:	f41a                	sd	t1,40(sp)
    8000552e:	f81e                	sd	t2,48(sp)
    80005530:	fc22                	sd	s0,56(sp)
    80005532:	e0a6                	sd	s1,64(sp)
    80005534:	e4aa                	sd	a0,72(sp)
    80005536:	e8ae                	sd	a1,80(sp)
    80005538:	ecb2                	sd	a2,88(sp)
    8000553a:	f0b6                	sd	a3,96(sp)
    8000553c:	f4ba                	sd	a4,104(sp)
    8000553e:	f8be                	sd	a5,112(sp)
    80005540:	fcc2                	sd	a6,120(sp)
    80005542:	e146                	sd	a7,128(sp)
    80005544:	e54a                	sd	s2,136(sp)
    80005546:	e94e                	sd	s3,144(sp)
    80005548:	ed52                	sd	s4,152(sp)
    8000554a:	f156                	sd	s5,160(sp)
    8000554c:	f55a                	sd	s6,168(sp)
    8000554e:	f95e                	sd	s7,176(sp)
    80005550:	fd62                	sd	s8,184(sp)
    80005552:	e1e6                	sd	s9,192(sp)
    80005554:	e5ea                	sd	s10,200(sp)
    80005556:	e9ee                	sd	s11,208(sp)
    80005558:	edf2                	sd	t3,216(sp)
    8000555a:	f1f6                	sd	t4,224(sp)
    8000555c:	f5fa                	sd	t5,232(sp)
    8000555e:	f9fe                	sd	t6,240(sp)
    80005560:	a15fc0ef          	jal	ra,80001f74 <kerneltrap>
    80005564:	6082                	ld	ra,0(sp)
    80005566:	6122                	ld	sp,8(sp)
    80005568:	61c2                	ld	gp,16(sp)
    8000556a:	7282                	ld	t0,32(sp)
    8000556c:	7322                	ld	t1,40(sp)
    8000556e:	73c2                	ld	t2,48(sp)
    80005570:	7462                	ld	s0,56(sp)
    80005572:	6486                	ld	s1,64(sp)
    80005574:	6526                	ld	a0,72(sp)
    80005576:	65c6                	ld	a1,80(sp)
    80005578:	6666                	ld	a2,88(sp)
    8000557a:	7686                	ld	a3,96(sp)
    8000557c:	7726                	ld	a4,104(sp)
    8000557e:	77c6                	ld	a5,112(sp)
    80005580:	7866                	ld	a6,120(sp)
    80005582:	688a                	ld	a7,128(sp)
    80005584:	692a                	ld	s2,136(sp)
    80005586:	69ca                	ld	s3,144(sp)
    80005588:	6a6a                	ld	s4,152(sp)
    8000558a:	7a8a                	ld	s5,160(sp)
    8000558c:	7b2a                	ld	s6,168(sp)
    8000558e:	7bca                	ld	s7,176(sp)
    80005590:	7c6a                	ld	s8,184(sp)
    80005592:	6c8e                	ld	s9,192(sp)
    80005594:	6d2e                	ld	s10,200(sp)
    80005596:	6dce                	ld	s11,208(sp)
    80005598:	6e6e                	ld	t3,216(sp)
    8000559a:	7e8e                	ld	t4,224(sp)
    8000559c:	7f2e                	ld	t5,232(sp)
    8000559e:	7fce                	ld	t6,240(sp)
    800055a0:	6111                	addi	sp,sp,256
    800055a2:	10200073          	sret
    800055a6:	00000013          	nop
    800055aa:	00000013          	nop
    800055ae:	0001                	nop

00000000800055b0 <timervec>:
    800055b0:	34051573          	csrrw	a0,mscratch,a0
    800055b4:	e10c                	sd	a1,0(a0)
    800055b6:	e510                	sd	a2,8(a0)
    800055b8:	e914                	sd	a3,16(a0)
    800055ba:	6d0c                	ld	a1,24(a0)
    800055bc:	7110                	ld	a2,32(a0)
    800055be:	6194                	ld	a3,0(a1)
    800055c0:	96b2                	add	a3,a3,a2
    800055c2:	e194                	sd	a3,0(a1)
    800055c4:	4589                	li	a1,2
    800055c6:	14459073          	csrw	sip,a1
    800055ca:	6914                	ld	a3,16(a0)
    800055cc:	6510                	ld	a2,8(a0)
    800055ce:	610c                	ld	a1,0(a0)
    800055d0:	34051573          	csrrw	a0,mscratch,a0
    800055d4:	30200073          	mret
	...

00000000800055da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055da:	1141                	addi	sp,sp,-16
    800055dc:	e422                	sd	s0,8(sp)
    800055de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800055e0:	0c0007b7          	lui	a5,0xc000
    800055e4:	4705                	li	a4,1
    800055e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800055e8:	c3d8                	sw	a4,4(a5)
}
    800055ea:	6422                	ld	s0,8(sp)
    800055ec:	0141                	addi	sp,sp,16
    800055ee:	8082                	ret

00000000800055f0 <plicinithart>:

void
plicinithart(void)
{
    800055f0:	1141                	addi	sp,sp,-16
    800055f2:	e406                	sd	ra,8(sp)
    800055f4:	e022                	sd	s0,0(sp)
    800055f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055f8:	ffffc097          	auipc	ra,0xffffc
    800055fc:	862080e7          	jalr	-1950(ra) # 80000e5a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005600:	0085171b          	slliw	a4,a0,0x8
    80005604:	0c0027b7          	lui	a5,0xc002
    80005608:	97ba                	add	a5,a5,a4
    8000560a:	40200713          	li	a4,1026
    8000560e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005612:	00d5151b          	slliw	a0,a0,0xd
    80005616:	0c2017b7          	lui	a5,0xc201
    8000561a:	953e                	add	a0,a0,a5
    8000561c:	00052023          	sw	zero,0(a0)
}
    80005620:	60a2                	ld	ra,8(sp)
    80005622:	6402                	ld	s0,0(sp)
    80005624:	0141                	addi	sp,sp,16
    80005626:	8082                	ret

0000000080005628 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005628:	1141                	addi	sp,sp,-16
    8000562a:	e406                	sd	ra,8(sp)
    8000562c:	e022                	sd	s0,0(sp)
    8000562e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005630:	ffffc097          	auipc	ra,0xffffc
    80005634:	82a080e7          	jalr	-2006(ra) # 80000e5a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005638:	00d5179b          	slliw	a5,a0,0xd
    8000563c:	0c201537          	lui	a0,0xc201
    80005640:	953e                	add	a0,a0,a5
  return irq;
}
    80005642:	4148                	lw	a0,4(a0)
    80005644:	60a2                	ld	ra,8(sp)
    80005646:	6402                	ld	s0,0(sp)
    80005648:	0141                	addi	sp,sp,16
    8000564a:	8082                	ret

000000008000564c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000564c:	1101                	addi	sp,sp,-32
    8000564e:	ec06                	sd	ra,24(sp)
    80005650:	e822                	sd	s0,16(sp)
    80005652:	e426                	sd	s1,8(sp)
    80005654:	1000                	addi	s0,sp,32
    80005656:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005658:	ffffc097          	auipc	ra,0xffffc
    8000565c:	802080e7          	jalr	-2046(ra) # 80000e5a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005660:	00d5151b          	slliw	a0,a0,0xd
    80005664:	0c2017b7          	lui	a5,0xc201
    80005668:	97aa                	add	a5,a5,a0
    8000566a:	c3c4                	sw	s1,4(a5)
}
    8000566c:	60e2                	ld	ra,24(sp)
    8000566e:	6442                	ld	s0,16(sp)
    80005670:	64a2                	ld	s1,8(sp)
    80005672:	6105                	addi	sp,sp,32
    80005674:	8082                	ret

0000000080005676 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005676:	1141                	addi	sp,sp,-16
    80005678:	e406                	sd	ra,8(sp)
    8000567a:	e022                	sd	s0,0(sp)
    8000567c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000567e:	479d                	li	a5,7
    80005680:	06a7c963          	blt	a5,a0,800056f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005684:	00016797          	auipc	a5,0x16
    80005688:	97c78793          	addi	a5,a5,-1668 # 8001b000 <disk>
    8000568c:	00a78733          	add	a4,a5,a0
    80005690:	6789                	lui	a5,0x2
    80005692:	97ba                	add	a5,a5,a4
    80005694:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005698:	e7ad                	bnez	a5,80005702 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000569a:	00451793          	slli	a5,a0,0x4
    8000569e:	00018717          	auipc	a4,0x18
    800056a2:	96270713          	addi	a4,a4,-1694 # 8001d000 <disk+0x2000>
    800056a6:	6314                	ld	a3,0(a4)
    800056a8:	96be                	add	a3,a3,a5
    800056aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800056ae:	6314                	ld	a3,0(a4)
    800056b0:	96be                	add	a3,a3,a5
    800056b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800056b6:	6314                	ld	a3,0(a4)
    800056b8:	96be                	add	a3,a3,a5
    800056ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800056be:	6318                	ld	a4,0(a4)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800056c6:	00016797          	auipc	a5,0x16
    800056ca:	93a78793          	addi	a5,a5,-1734 # 8001b000 <disk>
    800056ce:	97aa                	add	a5,a5,a0
    800056d0:	6509                	lui	a0,0x2
    800056d2:	953e                	add	a0,a0,a5
    800056d4:	4785                	li	a5,1
    800056d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800056da:	00018517          	auipc	a0,0x18
    800056de:	93e50513          	addi	a0,a0,-1730 # 8001d018 <disk+0x2018>
    800056e2:	ffffc097          	auipc	ra,0xffffc
    800056e6:	066080e7          	jalr	102(ra) # 80001748 <wakeup>
}
    800056ea:	60a2                	ld	ra,8(sp)
    800056ec:	6402                	ld	s0,0(sp)
    800056ee:	0141                	addi	sp,sp,16
    800056f0:	8082                	ret
    panic("free_desc 1");
    800056f2:	00003517          	auipc	a0,0x3
    800056f6:	02650513          	addi	a0,a0,38 # 80008718 <syscalls+0x360>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	a1e080e7          	jalr	-1506(ra) # 80006118 <panic>
    panic("free_desc 2");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	02650513          	addi	a0,a0,38 # 80008728 <syscalls+0x370>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	a0e080e7          	jalr	-1522(ra) # 80006118 <panic>

0000000080005712 <virtio_disk_init>:
{
    80005712:	1101                	addi	sp,sp,-32
    80005714:	ec06                	sd	ra,24(sp)
    80005716:	e822                	sd	s0,16(sp)
    80005718:	e426                	sd	s1,8(sp)
    8000571a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000571c:	00003597          	auipc	a1,0x3
    80005720:	01c58593          	addi	a1,a1,28 # 80008738 <syscalls+0x380>
    80005724:	00018517          	auipc	a0,0x18
    80005728:	a0450513          	addi	a0,a0,-1532 # 8001d128 <disk+0x2128>
    8000572c:	00001097          	auipc	ra,0x1
    80005730:	ea6080e7          	jalr	-346(ra) # 800065d2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005734:	100017b7          	lui	a5,0x10001
    80005738:	4398                	lw	a4,0(a5)
    8000573a:	2701                	sext.w	a4,a4
    8000573c:	747277b7          	lui	a5,0x74727
    80005740:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005744:	0ef71163          	bne	a4,a5,80005826 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005748:	100017b7          	lui	a5,0x10001
    8000574c:	43dc                	lw	a5,4(a5)
    8000574e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005750:	4705                	li	a4,1
    80005752:	0ce79a63          	bne	a5,a4,80005826 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005756:	100017b7          	lui	a5,0x10001
    8000575a:	479c                	lw	a5,8(a5)
    8000575c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000575e:	4709                	li	a4,2
    80005760:	0ce79363          	bne	a5,a4,80005826 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005764:	100017b7          	lui	a5,0x10001
    80005768:	47d8                	lw	a4,12(a5)
    8000576a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000576c:	554d47b7          	lui	a5,0x554d4
    80005770:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005774:	0af71963          	bne	a4,a5,80005826 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005778:	100017b7          	lui	a5,0x10001
    8000577c:	4705                	li	a4,1
    8000577e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005780:	470d                	li	a4,3
    80005782:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005784:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005786:	c7ffe737          	lui	a4,0xc7ffe
    8000578a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000578e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005790:	2701                	sext.w	a4,a4
    80005792:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005794:	472d                	li	a4,11
    80005796:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005798:	473d                	li	a4,15
    8000579a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000579c:	6705                	lui	a4,0x1
    8000579e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800057a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800057a4:	5bdc                	lw	a5,52(a5)
    800057a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800057a8:	c7d9                	beqz	a5,80005836 <virtio_disk_init+0x124>
  if(max < NUM)
    800057aa:	471d                	li	a4,7
    800057ac:	08f77d63          	bgeu	a4,a5,80005846 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057b0:	100014b7          	lui	s1,0x10001
    800057b4:	47a1                	li	a5,8
    800057b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800057b8:	6609                	lui	a2,0x2
    800057ba:	4581                	li	a1,0
    800057bc:	00016517          	auipc	a0,0x16
    800057c0:	84450513          	addi	a0,a0,-1980 # 8001b000 <disk>
    800057c4:	ffffb097          	auipc	ra,0xffffb
    800057c8:	9b4080e7          	jalr	-1612(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800057cc:	00016717          	auipc	a4,0x16
    800057d0:	83470713          	addi	a4,a4,-1996 # 8001b000 <disk>
    800057d4:	00c75793          	srli	a5,a4,0xc
    800057d8:	2781                	sext.w	a5,a5
    800057da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800057dc:	00018797          	auipc	a5,0x18
    800057e0:	82478793          	addi	a5,a5,-2012 # 8001d000 <disk+0x2000>
    800057e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800057e6:	00016717          	auipc	a4,0x16
    800057ea:	89a70713          	addi	a4,a4,-1894 # 8001b080 <disk+0x80>
    800057ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800057f0:	00017717          	auipc	a4,0x17
    800057f4:	81070713          	addi	a4,a4,-2032 # 8001c000 <disk+0x1000>
    800057f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800057fa:	4705                	li	a4,1
    800057fc:	00e78c23          	sb	a4,24(a5)
    80005800:	00e78ca3          	sb	a4,25(a5)
    80005804:	00e78d23          	sb	a4,26(a5)
    80005808:	00e78da3          	sb	a4,27(a5)
    8000580c:	00e78e23          	sb	a4,28(a5)
    80005810:	00e78ea3          	sb	a4,29(a5)
    80005814:	00e78f23          	sb	a4,30(a5)
    80005818:	00e78fa3          	sb	a4,31(a5)
}
    8000581c:	60e2                	ld	ra,24(sp)
    8000581e:	6442                	ld	s0,16(sp)
    80005820:	64a2                	ld	s1,8(sp)
    80005822:	6105                	addi	sp,sp,32
    80005824:	8082                	ret
    panic("could not find virtio disk");
    80005826:	00003517          	auipc	a0,0x3
    8000582a:	f2250513          	addi	a0,a0,-222 # 80008748 <syscalls+0x390>
    8000582e:	00001097          	auipc	ra,0x1
    80005832:	8ea080e7          	jalr	-1814(ra) # 80006118 <panic>
    panic("virtio disk has no queue 0");
    80005836:	00003517          	auipc	a0,0x3
    8000583a:	f3250513          	addi	a0,a0,-206 # 80008768 <syscalls+0x3b0>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	8da080e7          	jalr	-1830(ra) # 80006118 <panic>
    panic("virtio disk max queue too short");
    80005846:	00003517          	auipc	a0,0x3
    8000584a:	f4250513          	addi	a0,a0,-190 # 80008788 <syscalls+0x3d0>
    8000584e:	00001097          	auipc	ra,0x1
    80005852:	8ca080e7          	jalr	-1846(ra) # 80006118 <panic>

0000000080005856 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005856:	7159                	addi	sp,sp,-112
    80005858:	f486                	sd	ra,104(sp)
    8000585a:	f0a2                	sd	s0,96(sp)
    8000585c:	eca6                	sd	s1,88(sp)
    8000585e:	e8ca                	sd	s2,80(sp)
    80005860:	e4ce                	sd	s3,72(sp)
    80005862:	e0d2                	sd	s4,64(sp)
    80005864:	fc56                	sd	s5,56(sp)
    80005866:	f85a                	sd	s6,48(sp)
    80005868:	f45e                	sd	s7,40(sp)
    8000586a:	f062                	sd	s8,32(sp)
    8000586c:	ec66                	sd	s9,24(sp)
    8000586e:	e86a                	sd	s10,16(sp)
    80005870:	1880                	addi	s0,sp,112
    80005872:	892a                	mv	s2,a0
    80005874:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005876:	00c52c83          	lw	s9,12(a0)
    8000587a:	001c9c9b          	slliw	s9,s9,0x1
    8000587e:	1c82                	slli	s9,s9,0x20
    80005880:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005884:	00018517          	auipc	a0,0x18
    80005888:	8a450513          	addi	a0,a0,-1884 # 8001d128 <disk+0x2128>
    8000588c:	00001097          	auipc	ra,0x1
    80005890:	dd6080e7          	jalr	-554(ra) # 80006662 <acquire>
  for(int i = 0; i < 3; i++){
    80005894:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005896:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005898:	00015b97          	auipc	s7,0x15
    8000589c:	768b8b93          	addi	s7,s7,1896 # 8001b000 <disk>
    800058a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800058a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800058a4:	8a4e                	mv	s4,s3
    800058a6:	a051                	j	8000592a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800058a8:	00fb86b3          	add	a3,s7,a5
    800058ac:	96da                	add	a3,a3,s6
    800058ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800058b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800058b4:	0207c563          	bltz	a5,800058de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800058b8:	2485                	addiw	s1,s1,1
    800058ba:	0711                	addi	a4,a4,4
    800058bc:	25548063          	beq	s1,s5,80005afc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800058c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800058c2:	00017697          	auipc	a3,0x17
    800058c6:	75668693          	addi	a3,a3,1878 # 8001d018 <disk+0x2018>
    800058ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800058cc:	0006c583          	lbu	a1,0(a3)
    800058d0:	fde1                	bnez	a1,800058a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800058d2:	2785                	addiw	a5,a5,1
    800058d4:	0685                	addi	a3,a3,1
    800058d6:	ff879be3          	bne	a5,s8,800058cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800058da:	57fd                	li	a5,-1
    800058dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800058de:	02905a63          	blez	s1,80005912 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800058e2:	f9042503          	lw	a0,-112(s0)
    800058e6:	00000097          	auipc	ra,0x0
    800058ea:	d90080e7          	jalr	-624(ra) # 80005676 <free_desc>
      for(int j = 0; j < i; j++)
    800058ee:	4785                	li	a5,1
    800058f0:	0297d163          	bge	a5,s1,80005912 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800058f4:	f9442503          	lw	a0,-108(s0)
    800058f8:	00000097          	auipc	ra,0x0
    800058fc:	d7e080e7          	jalr	-642(ra) # 80005676 <free_desc>
      for(int j = 0; j < i; j++)
    80005900:	4789                	li	a5,2
    80005902:	0097d863          	bge	a5,s1,80005912 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005906:	f9842503          	lw	a0,-104(s0)
    8000590a:	00000097          	auipc	ra,0x0
    8000590e:	d6c080e7          	jalr	-660(ra) # 80005676 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005912:	00018597          	auipc	a1,0x18
    80005916:	81658593          	addi	a1,a1,-2026 # 8001d128 <disk+0x2128>
    8000591a:	00017517          	auipc	a0,0x17
    8000591e:	6fe50513          	addi	a0,a0,1790 # 8001d018 <disk+0x2018>
    80005922:	ffffc097          	auipc	ra,0xffffc
    80005926:	c9a080e7          	jalr	-870(ra) # 800015bc <sleep>
  for(int i = 0; i < 3; i++){
    8000592a:	f9040713          	addi	a4,s0,-112
    8000592e:	84ce                	mv	s1,s3
    80005930:	bf41                	j	800058c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005932:	20058713          	addi	a4,a1,512
    80005936:	00471693          	slli	a3,a4,0x4
    8000593a:	00015717          	auipc	a4,0x15
    8000593e:	6c670713          	addi	a4,a4,1734 # 8001b000 <disk>
    80005942:	9736                	add	a4,a4,a3
    80005944:	4685                	li	a3,1
    80005946:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000594a:	20058713          	addi	a4,a1,512
    8000594e:	00471693          	slli	a3,a4,0x4
    80005952:	00015717          	auipc	a4,0x15
    80005956:	6ae70713          	addi	a4,a4,1710 # 8001b000 <disk>
    8000595a:	9736                	add	a4,a4,a3
    8000595c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005960:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005964:	7679                	lui	a2,0xffffe
    80005966:	963e                	add	a2,a2,a5
    80005968:	00017697          	auipc	a3,0x17
    8000596c:	69868693          	addi	a3,a3,1688 # 8001d000 <disk+0x2000>
    80005970:	6298                	ld	a4,0(a3)
    80005972:	9732                	add	a4,a4,a2
    80005974:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005976:	6298                	ld	a4,0(a3)
    80005978:	9732                	add	a4,a4,a2
    8000597a:	4541                	li	a0,16
    8000597c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000597e:	6298                	ld	a4,0(a3)
    80005980:	9732                	add	a4,a4,a2
    80005982:	4505                	li	a0,1
    80005984:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005988:	f9442703          	lw	a4,-108(s0)
    8000598c:	6288                	ld	a0,0(a3)
    8000598e:	962a                	add	a2,a2,a0
    80005990:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005994:	0712                	slli	a4,a4,0x4
    80005996:	6290                	ld	a2,0(a3)
    80005998:	963a                	add	a2,a2,a4
    8000599a:	05890513          	addi	a0,s2,88
    8000599e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800059a0:	6294                	ld	a3,0(a3)
    800059a2:	96ba                	add	a3,a3,a4
    800059a4:	40000613          	li	a2,1024
    800059a8:	c690                	sw	a2,8(a3)
  if(write)
    800059aa:	140d0063          	beqz	s10,80005aea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800059ae:	00017697          	auipc	a3,0x17
    800059b2:	6526b683          	ld	a3,1618(a3) # 8001d000 <disk+0x2000>
    800059b6:	96ba                	add	a3,a3,a4
    800059b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059bc:	00015817          	auipc	a6,0x15
    800059c0:	64480813          	addi	a6,a6,1604 # 8001b000 <disk>
    800059c4:	00017517          	auipc	a0,0x17
    800059c8:	63c50513          	addi	a0,a0,1596 # 8001d000 <disk+0x2000>
    800059cc:	6114                	ld	a3,0(a0)
    800059ce:	96ba                	add	a3,a3,a4
    800059d0:	00c6d603          	lhu	a2,12(a3)
    800059d4:	00166613          	ori	a2,a2,1
    800059d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800059dc:	f9842683          	lw	a3,-104(s0)
    800059e0:	6110                	ld	a2,0(a0)
    800059e2:	9732                	add	a4,a4,a2
    800059e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059e8:	20058613          	addi	a2,a1,512
    800059ec:	0612                	slli	a2,a2,0x4
    800059ee:	9642                	add	a2,a2,a6
    800059f0:	577d                	li	a4,-1
    800059f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800059f6:	00469713          	slli	a4,a3,0x4
    800059fa:	6114                	ld	a3,0(a0)
    800059fc:	96ba                	add	a3,a3,a4
    800059fe:	03078793          	addi	a5,a5,48
    80005a02:	97c2                	add	a5,a5,a6
    80005a04:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005a06:	611c                	ld	a5,0(a0)
    80005a08:	97ba                	add	a5,a5,a4
    80005a0a:	4685                	li	a3,1
    80005a0c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a0e:	611c                	ld	a5,0(a0)
    80005a10:	97ba                	add	a5,a5,a4
    80005a12:	4809                	li	a6,2
    80005a14:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005a18:	611c                	ld	a5,0(a0)
    80005a1a:	973e                	add	a4,a4,a5
    80005a1c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a20:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005a24:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a28:	6518                	ld	a4,8(a0)
    80005a2a:	00275783          	lhu	a5,2(a4)
    80005a2e:	8b9d                	andi	a5,a5,7
    80005a30:	0786                	slli	a5,a5,0x1
    80005a32:	97ba                	add	a5,a5,a4
    80005a34:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005a38:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a3c:	6518                	ld	a4,8(a0)
    80005a3e:	00275783          	lhu	a5,2(a4)
    80005a42:	2785                	addiw	a5,a5,1
    80005a44:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005a48:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a4c:	100017b7          	lui	a5,0x10001
    80005a50:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005a54:	00492703          	lw	a4,4(s2)
    80005a58:	4785                	li	a5,1
    80005a5a:	02f71163          	bne	a4,a5,80005a7c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80005a5e:	00017997          	auipc	s3,0x17
    80005a62:	6ca98993          	addi	s3,s3,1738 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005a66:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005a68:	85ce                	mv	a1,s3
    80005a6a:	854a                	mv	a0,s2
    80005a6c:	ffffc097          	auipc	ra,0xffffc
    80005a70:	b50080e7          	jalr	-1200(ra) # 800015bc <sleep>
  while(b->disk == 1) {
    80005a74:	00492783          	lw	a5,4(s2)
    80005a78:	fe9788e3          	beq	a5,s1,80005a68 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005a7c:	f9042903          	lw	s2,-112(s0)
    80005a80:	20090793          	addi	a5,s2,512
    80005a84:	00479713          	slli	a4,a5,0x4
    80005a88:	00015797          	auipc	a5,0x15
    80005a8c:	57878793          	addi	a5,a5,1400 # 8001b000 <disk>
    80005a90:	97ba                	add	a5,a5,a4
    80005a92:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005a96:	00017997          	auipc	s3,0x17
    80005a9a:	56a98993          	addi	s3,s3,1386 # 8001d000 <disk+0x2000>
    80005a9e:	00491713          	slli	a4,s2,0x4
    80005aa2:	0009b783          	ld	a5,0(s3)
    80005aa6:	97ba                	add	a5,a5,a4
    80005aa8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005aac:	854a                	mv	a0,s2
    80005aae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005ab2:	00000097          	auipc	ra,0x0
    80005ab6:	bc4080e7          	jalr	-1084(ra) # 80005676 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005aba:	8885                	andi	s1,s1,1
    80005abc:	f0ed                	bnez	s1,80005a9e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005abe:	00017517          	auipc	a0,0x17
    80005ac2:	66a50513          	addi	a0,a0,1642 # 8001d128 <disk+0x2128>
    80005ac6:	00001097          	auipc	ra,0x1
    80005aca:	c50080e7          	jalr	-944(ra) # 80006716 <release>
}
    80005ace:	70a6                	ld	ra,104(sp)
    80005ad0:	7406                	ld	s0,96(sp)
    80005ad2:	64e6                	ld	s1,88(sp)
    80005ad4:	6946                	ld	s2,80(sp)
    80005ad6:	69a6                	ld	s3,72(sp)
    80005ad8:	6a06                	ld	s4,64(sp)
    80005ada:	7ae2                	ld	s5,56(sp)
    80005adc:	7b42                	ld	s6,48(sp)
    80005ade:	7ba2                	ld	s7,40(sp)
    80005ae0:	7c02                	ld	s8,32(sp)
    80005ae2:	6ce2                	ld	s9,24(sp)
    80005ae4:	6d42                	ld	s10,16(sp)
    80005ae6:	6165                	addi	sp,sp,112
    80005ae8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005aea:	00017697          	auipc	a3,0x17
    80005aee:	5166b683          	ld	a3,1302(a3) # 8001d000 <disk+0x2000>
    80005af2:	96ba                	add	a3,a3,a4
    80005af4:	4609                	li	a2,2
    80005af6:	00c69623          	sh	a2,12(a3)
    80005afa:	b5c9                	j	800059bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005afc:	f9042583          	lw	a1,-112(s0)
    80005b00:	20058793          	addi	a5,a1,512
    80005b04:	0792                	slli	a5,a5,0x4
    80005b06:	00015517          	auipc	a0,0x15
    80005b0a:	5a250513          	addi	a0,a0,1442 # 8001b0a8 <disk+0xa8>
    80005b0e:	953e                	add	a0,a0,a5
  if(write)
    80005b10:	e20d11e3          	bnez	s10,80005932 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005b14:	20058713          	addi	a4,a1,512
    80005b18:	00471693          	slli	a3,a4,0x4
    80005b1c:	00015717          	auipc	a4,0x15
    80005b20:	4e470713          	addi	a4,a4,1252 # 8001b000 <disk>
    80005b24:	9736                	add	a4,a4,a3
    80005b26:	0a072423          	sw	zero,168(a4)
    80005b2a:	b505                	j	8000594a <virtio_disk_rw+0xf4>

0000000080005b2c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b2c:	1101                	addi	sp,sp,-32
    80005b2e:	ec06                	sd	ra,24(sp)
    80005b30:	e822                	sd	s0,16(sp)
    80005b32:	e426                	sd	s1,8(sp)
    80005b34:	e04a                	sd	s2,0(sp)
    80005b36:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b38:	00017517          	auipc	a0,0x17
    80005b3c:	5f050513          	addi	a0,a0,1520 # 8001d128 <disk+0x2128>
    80005b40:	00001097          	auipc	ra,0x1
    80005b44:	b22080e7          	jalr	-1246(ra) # 80006662 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b48:	10001737          	lui	a4,0x10001
    80005b4c:	533c                	lw	a5,96(a4)
    80005b4e:	8b8d                	andi	a5,a5,3
    80005b50:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b52:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b56:	00017797          	auipc	a5,0x17
    80005b5a:	4aa78793          	addi	a5,a5,1194 # 8001d000 <disk+0x2000>
    80005b5e:	6b94                	ld	a3,16(a5)
    80005b60:	0207d703          	lhu	a4,32(a5)
    80005b64:	0026d783          	lhu	a5,2(a3)
    80005b68:	06f70163          	beq	a4,a5,80005bca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b6c:	00015917          	auipc	s2,0x15
    80005b70:	49490913          	addi	s2,s2,1172 # 8001b000 <disk>
    80005b74:	00017497          	auipc	s1,0x17
    80005b78:	48c48493          	addi	s1,s1,1164 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005b7c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b80:	6898                	ld	a4,16(s1)
    80005b82:	0204d783          	lhu	a5,32(s1)
    80005b86:	8b9d                	andi	a5,a5,7
    80005b88:	078e                	slli	a5,a5,0x3
    80005b8a:	97ba                	add	a5,a5,a4
    80005b8c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b8e:	20078713          	addi	a4,a5,512
    80005b92:	0712                	slli	a4,a4,0x4
    80005b94:	974a                	add	a4,a4,s2
    80005b96:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005b9a:	e731                	bnez	a4,80005be6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b9c:	20078793          	addi	a5,a5,512
    80005ba0:	0792                	slli	a5,a5,0x4
    80005ba2:	97ca                	add	a5,a5,s2
    80005ba4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005ba6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005baa:	ffffc097          	auipc	ra,0xffffc
    80005bae:	b9e080e7          	jalr	-1122(ra) # 80001748 <wakeup>

    disk.used_idx += 1;
    80005bb2:	0204d783          	lhu	a5,32(s1)
    80005bb6:	2785                	addiw	a5,a5,1
    80005bb8:	17c2                	slli	a5,a5,0x30
    80005bba:	93c1                	srli	a5,a5,0x30
    80005bbc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005bc0:	6898                	ld	a4,16(s1)
    80005bc2:	00275703          	lhu	a4,2(a4)
    80005bc6:	faf71be3          	bne	a4,a5,80005b7c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005bca:	00017517          	auipc	a0,0x17
    80005bce:	55e50513          	addi	a0,a0,1374 # 8001d128 <disk+0x2128>
    80005bd2:	00001097          	auipc	ra,0x1
    80005bd6:	b44080e7          	jalr	-1212(ra) # 80006716 <release>
}
    80005bda:	60e2                	ld	ra,24(sp)
    80005bdc:	6442                	ld	s0,16(sp)
    80005bde:	64a2                	ld	s1,8(sp)
    80005be0:	6902                	ld	s2,0(sp)
    80005be2:	6105                	addi	sp,sp,32
    80005be4:	8082                	ret
      panic("virtio_disk_intr status");
    80005be6:	00003517          	auipc	a0,0x3
    80005bea:	bc250513          	addi	a0,a0,-1086 # 800087a8 <syscalls+0x3f0>
    80005bee:	00000097          	auipc	ra,0x0
    80005bf2:	52a080e7          	jalr	1322(ra) # 80006118 <panic>

0000000080005bf6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005bf6:	1141                	addi	sp,sp,-16
    80005bf8:	e422                	sd	s0,8(sp)
    80005bfa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bfc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c00:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c04:	0037979b          	slliw	a5,a5,0x3
    80005c08:	02004737          	lui	a4,0x2004
    80005c0c:	97ba                	add	a5,a5,a4
    80005c0e:	0200c737          	lui	a4,0x200c
    80005c12:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c16:	000f4637          	lui	a2,0xf4
    80005c1a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c1e:	95b2                	add	a1,a1,a2
    80005c20:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c22:	00269713          	slli	a4,a3,0x2
    80005c26:	9736                	add	a4,a4,a3
    80005c28:	00371693          	slli	a3,a4,0x3
    80005c2c:	00018717          	auipc	a4,0x18
    80005c30:	3d470713          	addi	a4,a4,980 # 8001e000 <timer_scratch>
    80005c34:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c36:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c38:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c3a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c3e:	00000797          	auipc	a5,0x0
    80005c42:	97278793          	addi	a5,a5,-1678 # 800055b0 <timervec>
    80005c46:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c4a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c4e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c52:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c56:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c5a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c5e:	30479073          	csrw	mie,a5
}
    80005c62:	6422                	ld	s0,8(sp)
    80005c64:	0141                	addi	sp,sp,16
    80005c66:	8082                	ret

0000000080005c68 <start>:
{
    80005c68:	1141                	addi	sp,sp,-16
    80005c6a:	e406                	sd	ra,8(sp)
    80005c6c:	e022                	sd	s0,0(sp)
    80005c6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c70:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c74:	7779                	lui	a4,0xffffe
    80005c76:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005c7a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c7c:	6705                	lui	a4,0x1
    80005c7e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c82:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c84:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c88:	ffffa797          	auipc	a5,0xffffa
    80005c8c:	69e78793          	addi	a5,a5,1694 # 80000326 <main>
    80005c90:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c94:	4781                	li	a5,0
    80005c96:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c9a:	67c1                	lui	a5,0x10
    80005c9c:	17fd                	addi	a5,a5,-1
    80005c9e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ca2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ca6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005caa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cb2:	57fd                	li	a5,-1
    80005cb4:	83a9                	srli	a5,a5,0xa
    80005cb6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cba:	47bd                	li	a5,15
    80005cbc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	f36080e7          	jalr	-202(ra) # 80005bf6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cc8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ccc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005cce:	823e                	mv	tp,a5
  asm volatile("mret");
    80005cd0:	30200073          	mret
}
    80005cd4:	60a2                	ld	ra,8(sp)
    80005cd6:	6402                	ld	s0,0(sp)
    80005cd8:	0141                	addi	sp,sp,16
    80005cda:	8082                	ret

0000000080005cdc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cdc:	715d                	addi	sp,sp,-80
    80005cde:	e486                	sd	ra,72(sp)
    80005ce0:	e0a2                	sd	s0,64(sp)
    80005ce2:	fc26                	sd	s1,56(sp)
    80005ce4:	f84a                	sd	s2,48(sp)
    80005ce6:	f44e                	sd	s3,40(sp)
    80005ce8:	f052                	sd	s4,32(sp)
    80005cea:	ec56                	sd	s5,24(sp)
    80005cec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005cee:	04c05663          	blez	a2,80005d3a <consolewrite+0x5e>
    80005cf2:	8a2a                	mv	s4,a0
    80005cf4:	84ae                	mv	s1,a1
    80005cf6:	89b2                	mv	s3,a2
    80005cf8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005cfa:	5afd                	li	s5,-1
    80005cfc:	4685                	li	a3,1
    80005cfe:	8626                	mv	a2,s1
    80005d00:	85d2                	mv	a1,s4
    80005d02:	fbf40513          	addi	a0,s0,-65
    80005d06:	ffffc097          	auipc	ra,0xffffc
    80005d0a:	d14080e7          	jalr	-748(ra) # 80001a1a <either_copyin>
    80005d0e:	01550c63          	beq	a0,s5,80005d26 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005d12:	fbf44503          	lbu	a0,-65(s0)
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	78e080e7          	jalr	1934(ra) # 800064a4 <uartputc>
  for(i = 0; i < n; i++){
    80005d1e:	2905                	addiw	s2,s2,1
    80005d20:	0485                	addi	s1,s1,1
    80005d22:	fd299de3          	bne	s3,s2,80005cfc <consolewrite+0x20>
  }

  return i;
}
    80005d26:	854a                	mv	a0,s2
    80005d28:	60a6                	ld	ra,72(sp)
    80005d2a:	6406                	ld	s0,64(sp)
    80005d2c:	74e2                	ld	s1,56(sp)
    80005d2e:	7942                	ld	s2,48(sp)
    80005d30:	79a2                	ld	s3,40(sp)
    80005d32:	7a02                	ld	s4,32(sp)
    80005d34:	6ae2                	ld	s5,24(sp)
    80005d36:	6161                	addi	sp,sp,80
    80005d38:	8082                	ret
  for(i = 0; i < n; i++){
    80005d3a:	4901                	li	s2,0
    80005d3c:	b7ed                	j	80005d26 <consolewrite+0x4a>

0000000080005d3e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d3e:	7119                	addi	sp,sp,-128
    80005d40:	fc86                	sd	ra,120(sp)
    80005d42:	f8a2                	sd	s0,112(sp)
    80005d44:	f4a6                	sd	s1,104(sp)
    80005d46:	f0ca                	sd	s2,96(sp)
    80005d48:	ecce                	sd	s3,88(sp)
    80005d4a:	e8d2                	sd	s4,80(sp)
    80005d4c:	e4d6                	sd	s5,72(sp)
    80005d4e:	e0da                	sd	s6,64(sp)
    80005d50:	fc5e                	sd	s7,56(sp)
    80005d52:	f862                	sd	s8,48(sp)
    80005d54:	f466                	sd	s9,40(sp)
    80005d56:	f06a                	sd	s10,32(sp)
    80005d58:	ec6e                	sd	s11,24(sp)
    80005d5a:	0100                	addi	s0,sp,128
    80005d5c:	8b2a                	mv	s6,a0
    80005d5e:	8aae                	mv	s5,a1
    80005d60:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d62:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005d66:	00020517          	auipc	a0,0x20
    80005d6a:	3da50513          	addi	a0,a0,986 # 80026140 <cons>
    80005d6e:	00001097          	auipc	ra,0x1
    80005d72:	8f4080e7          	jalr	-1804(ra) # 80006662 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d76:	00020497          	auipc	s1,0x20
    80005d7a:	3ca48493          	addi	s1,s1,970 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d7e:	89a6                	mv	s3,s1
    80005d80:	00020917          	auipc	s2,0x20
    80005d84:	45890913          	addi	s2,s2,1112 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005d88:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d8a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d8c:	4da9                	li	s11,10
  while(n > 0){
    80005d8e:	07405863          	blez	s4,80005dfe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005d92:	0984a783          	lw	a5,152(s1)
    80005d96:	09c4a703          	lw	a4,156(s1)
    80005d9a:	02f71463          	bne	a4,a5,80005dc2 <consoleread+0x84>
      if(myproc()->killed){
    80005d9e:	ffffb097          	auipc	ra,0xffffb
    80005da2:	0e8080e7          	jalr	232(ra) # 80000e86 <myproc>
    80005da6:	551c                	lw	a5,40(a0)
    80005da8:	e7b5                	bnez	a5,80005e14 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005daa:	85ce                	mv	a1,s3
    80005dac:	854a                	mv	a0,s2
    80005dae:	ffffc097          	auipc	ra,0xffffc
    80005db2:	80e080e7          	jalr	-2034(ra) # 800015bc <sleep>
    while(cons.r == cons.w){
    80005db6:	0984a783          	lw	a5,152(s1)
    80005dba:	09c4a703          	lw	a4,156(s1)
    80005dbe:	fef700e3          	beq	a4,a5,80005d9e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005dc2:	0017871b          	addiw	a4,a5,1
    80005dc6:	08e4ac23          	sw	a4,152(s1)
    80005dca:	07f7f713          	andi	a4,a5,127
    80005dce:	9726                	add	a4,a4,s1
    80005dd0:	01874703          	lbu	a4,24(a4)
    80005dd4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005dd8:	079c0663          	beq	s8,s9,80005e44 <consoleread+0x106>
    cbuf = c;
    80005ddc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005de0:	4685                	li	a3,1
    80005de2:	f8f40613          	addi	a2,s0,-113
    80005de6:	85d6                	mv	a1,s5
    80005de8:	855a                	mv	a0,s6
    80005dea:	ffffc097          	auipc	ra,0xffffc
    80005dee:	bda080e7          	jalr	-1062(ra) # 800019c4 <either_copyout>
    80005df2:	01a50663          	beq	a0,s10,80005dfe <consoleread+0xc0>
    dst++;
    80005df6:	0a85                	addi	s5,s5,1
    --n;
    80005df8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005dfa:	f9bc1ae3          	bne	s8,s11,80005d8e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005dfe:	00020517          	auipc	a0,0x20
    80005e02:	34250513          	addi	a0,a0,834 # 80026140 <cons>
    80005e06:	00001097          	auipc	ra,0x1
    80005e0a:	910080e7          	jalr	-1776(ra) # 80006716 <release>

  return target - n;
    80005e0e:	414b853b          	subw	a0,s7,s4
    80005e12:	a811                	j	80005e26 <consoleread+0xe8>
        release(&cons.lock);
    80005e14:	00020517          	auipc	a0,0x20
    80005e18:	32c50513          	addi	a0,a0,812 # 80026140 <cons>
    80005e1c:	00001097          	auipc	ra,0x1
    80005e20:	8fa080e7          	jalr	-1798(ra) # 80006716 <release>
        return -1;
    80005e24:	557d                	li	a0,-1
}
    80005e26:	70e6                	ld	ra,120(sp)
    80005e28:	7446                	ld	s0,112(sp)
    80005e2a:	74a6                	ld	s1,104(sp)
    80005e2c:	7906                	ld	s2,96(sp)
    80005e2e:	69e6                	ld	s3,88(sp)
    80005e30:	6a46                	ld	s4,80(sp)
    80005e32:	6aa6                	ld	s5,72(sp)
    80005e34:	6b06                	ld	s6,64(sp)
    80005e36:	7be2                	ld	s7,56(sp)
    80005e38:	7c42                	ld	s8,48(sp)
    80005e3a:	7ca2                	ld	s9,40(sp)
    80005e3c:	7d02                	ld	s10,32(sp)
    80005e3e:	6de2                	ld	s11,24(sp)
    80005e40:	6109                	addi	sp,sp,128
    80005e42:	8082                	ret
      if(n < target){
    80005e44:	000a071b          	sext.w	a4,s4
    80005e48:	fb777be3          	bgeu	a4,s7,80005dfe <consoleread+0xc0>
        cons.r--;
    80005e4c:	00020717          	auipc	a4,0x20
    80005e50:	38f72623          	sw	a5,908(a4) # 800261d8 <cons+0x98>
    80005e54:	b76d                	j	80005dfe <consoleread+0xc0>

0000000080005e56 <consputc>:
{
    80005e56:	1141                	addi	sp,sp,-16
    80005e58:	e406                	sd	ra,8(sp)
    80005e5a:	e022                	sd	s0,0(sp)
    80005e5c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e5e:	10000793          	li	a5,256
    80005e62:	00f50a63          	beq	a0,a5,80005e76 <consputc+0x20>
    uartputc_sync(c);
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	564080e7          	jalr	1380(ra) # 800063ca <uartputc_sync>
}
    80005e6e:	60a2                	ld	ra,8(sp)
    80005e70:	6402                	ld	s0,0(sp)
    80005e72:	0141                	addi	sp,sp,16
    80005e74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e76:	4521                	li	a0,8
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	552080e7          	jalr	1362(ra) # 800063ca <uartputc_sync>
    80005e80:	02000513          	li	a0,32
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	546080e7          	jalr	1350(ra) # 800063ca <uartputc_sync>
    80005e8c:	4521                	li	a0,8
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	53c080e7          	jalr	1340(ra) # 800063ca <uartputc_sync>
    80005e96:	bfe1                	j	80005e6e <consputc+0x18>

0000000080005e98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e98:	1101                	addi	sp,sp,-32
    80005e9a:	ec06                	sd	ra,24(sp)
    80005e9c:	e822                	sd	s0,16(sp)
    80005e9e:	e426                	sd	s1,8(sp)
    80005ea0:	e04a                	sd	s2,0(sp)
    80005ea2:	1000                	addi	s0,sp,32
    80005ea4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ea6:	00020517          	auipc	a0,0x20
    80005eaa:	29a50513          	addi	a0,a0,666 # 80026140 <cons>
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	7b4080e7          	jalr	1972(ra) # 80006662 <acquire>

  switch(c){
    80005eb6:	47d5                	li	a5,21
    80005eb8:	0af48663          	beq	s1,a5,80005f64 <consoleintr+0xcc>
    80005ebc:	0297ca63          	blt	a5,s1,80005ef0 <consoleintr+0x58>
    80005ec0:	47a1                	li	a5,8
    80005ec2:	0ef48763          	beq	s1,a5,80005fb0 <consoleintr+0x118>
    80005ec6:	47c1                	li	a5,16
    80005ec8:	10f49a63          	bne	s1,a5,80005fdc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ecc:	ffffc097          	auipc	ra,0xffffc
    80005ed0:	ba4080e7          	jalr	-1116(ra) # 80001a70 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ed4:	00020517          	auipc	a0,0x20
    80005ed8:	26c50513          	addi	a0,a0,620 # 80026140 <cons>
    80005edc:	00001097          	auipc	ra,0x1
    80005ee0:	83a080e7          	jalr	-1990(ra) # 80006716 <release>
}
    80005ee4:	60e2                	ld	ra,24(sp)
    80005ee6:	6442                	ld	s0,16(sp)
    80005ee8:	64a2                	ld	s1,8(sp)
    80005eea:	6902                	ld	s2,0(sp)
    80005eec:	6105                	addi	sp,sp,32
    80005eee:	8082                	ret
  switch(c){
    80005ef0:	07f00793          	li	a5,127
    80005ef4:	0af48e63          	beq	s1,a5,80005fb0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ef8:	00020717          	auipc	a4,0x20
    80005efc:	24870713          	addi	a4,a4,584 # 80026140 <cons>
    80005f00:	0a072783          	lw	a5,160(a4)
    80005f04:	09872703          	lw	a4,152(a4)
    80005f08:	9f99                	subw	a5,a5,a4
    80005f0a:	07f00713          	li	a4,127
    80005f0e:	fcf763e3          	bltu	a4,a5,80005ed4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f12:	47b5                	li	a5,13
    80005f14:	0cf48763          	beq	s1,a5,80005fe2 <consoleintr+0x14a>
      consputc(c);
    80005f18:	8526                	mv	a0,s1
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	f3c080e7          	jalr	-196(ra) # 80005e56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f22:	00020797          	auipc	a5,0x20
    80005f26:	21e78793          	addi	a5,a5,542 # 80026140 <cons>
    80005f2a:	0a07a703          	lw	a4,160(a5)
    80005f2e:	0017069b          	addiw	a3,a4,1
    80005f32:	0006861b          	sext.w	a2,a3
    80005f36:	0ad7a023          	sw	a3,160(a5)
    80005f3a:	07f77713          	andi	a4,a4,127
    80005f3e:	97ba                	add	a5,a5,a4
    80005f40:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f44:	47a9                	li	a5,10
    80005f46:	0cf48563          	beq	s1,a5,80006010 <consoleintr+0x178>
    80005f4a:	4791                	li	a5,4
    80005f4c:	0cf48263          	beq	s1,a5,80006010 <consoleintr+0x178>
    80005f50:	00020797          	auipc	a5,0x20
    80005f54:	2887a783          	lw	a5,648(a5) # 800261d8 <cons+0x98>
    80005f58:	0807879b          	addiw	a5,a5,128
    80005f5c:	f6f61ce3          	bne	a2,a5,80005ed4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f60:	863e                	mv	a2,a5
    80005f62:	a07d                	j	80006010 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f64:	00020717          	auipc	a4,0x20
    80005f68:	1dc70713          	addi	a4,a4,476 # 80026140 <cons>
    80005f6c:	0a072783          	lw	a5,160(a4)
    80005f70:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f74:	00020497          	auipc	s1,0x20
    80005f78:	1cc48493          	addi	s1,s1,460 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005f7c:	4929                	li	s2,10
    80005f7e:	f4f70be3          	beq	a4,a5,80005ed4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f82:	37fd                	addiw	a5,a5,-1
    80005f84:	07f7f713          	andi	a4,a5,127
    80005f88:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f8a:	01874703          	lbu	a4,24(a4)
    80005f8e:	f52703e3          	beq	a4,s2,80005ed4 <consoleintr+0x3c>
      cons.e--;
    80005f92:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005f96:	10000513          	li	a0,256
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	ebc080e7          	jalr	-324(ra) # 80005e56 <consputc>
    while(cons.e != cons.w &&
    80005fa2:	0a04a783          	lw	a5,160(s1)
    80005fa6:	09c4a703          	lw	a4,156(s1)
    80005faa:	fcf71ce3          	bne	a4,a5,80005f82 <consoleintr+0xea>
    80005fae:	b71d                	j	80005ed4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005fb0:	00020717          	auipc	a4,0x20
    80005fb4:	19070713          	addi	a4,a4,400 # 80026140 <cons>
    80005fb8:	0a072783          	lw	a5,160(a4)
    80005fbc:	09c72703          	lw	a4,156(a4)
    80005fc0:	f0f70ae3          	beq	a4,a5,80005ed4 <consoleintr+0x3c>
      cons.e--;
    80005fc4:	37fd                	addiw	a5,a5,-1
    80005fc6:	00020717          	auipc	a4,0x20
    80005fca:	20f72d23          	sw	a5,538(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005fce:	10000513          	li	a0,256
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	e84080e7          	jalr	-380(ra) # 80005e56 <consputc>
    80005fda:	bded                	j	80005ed4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fdc:	ee048ce3          	beqz	s1,80005ed4 <consoleintr+0x3c>
    80005fe0:	bf21                	j	80005ef8 <consoleintr+0x60>
      consputc(c);
    80005fe2:	4529                	li	a0,10
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	e72080e7          	jalr	-398(ra) # 80005e56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005fec:	00020797          	auipc	a5,0x20
    80005ff0:	15478793          	addi	a5,a5,340 # 80026140 <cons>
    80005ff4:	0a07a703          	lw	a4,160(a5)
    80005ff8:	0017069b          	addiw	a3,a4,1
    80005ffc:	0006861b          	sext.w	a2,a3
    80006000:	0ad7a023          	sw	a3,160(a5)
    80006004:	07f77713          	andi	a4,a4,127
    80006008:	97ba                	add	a5,a5,a4
    8000600a:	4729                	li	a4,10
    8000600c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006010:	00020797          	auipc	a5,0x20
    80006014:	1cc7a623          	sw	a2,460(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80006018:	00020517          	auipc	a0,0x20
    8000601c:	1c050513          	addi	a0,a0,448 # 800261d8 <cons+0x98>
    80006020:	ffffb097          	auipc	ra,0xffffb
    80006024:	728080e7          	jalr	1832(ra) # 80001748 <wakeup>
    80006028:	b575                	j	80005ed4 <consoleintr+0x3c>

000000008000602a <consoleinit>:

void
consoleinit(void)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e406                	sd	ra,8(sp)
    8000602e:	e022                	sd	s0,0(sp)
    80006030:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006032:	00002597          	auipc	a1,0x2
    80006036:	78e58593          	addi	a1,a1,1934 # 800087c0 <syscalls+0x408>
    8000603a:	00020517          	auipc	a0,0x20
    8000603e:	10650513          	addi	a0,a0,262 # 80026140 <cons>
    80006042:	00000097          	auipc	ra,0x0
    80006046:	590080e7          	jalr	1424(ra) # 800065d2 <initlock>

  uartinit();
    8000604a:	00000097          	auipc	ra,0x0
    8000604e:	330080e7          	jalr	816(ra) # 8000637a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006052:	00013797          	auipc	a5,0x13
    80006056:	77678793          	addi	a5,a5,1910 # 800197c8 <devsw>
    8000605a:	00000717          	auipc	a4,0x0
    8000605e:	ce470713          	addi	a4,a4,-796 # 80005d3e <consoleread>
    80006062:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006064:	00000717          	auipc	a4,0x0
    80006068:	c7870713          	addi	a4,a4,-904 # 80005cdc <consolewrite>
    8000606c:	ef98                	sd	a4,24(a5)
}
    8000606e:	60a2                	ld	ra,8(sp)
    80006070:	6402                	ld	s0,0(sp)
    80006072:	0141                	addi	sp,sp,16
    80006074:	8082                	ret

0000000080006076 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006076:	7179                	addi	sp,sp,-48
    80006078:	f406                	sd	ra,40(sp)
    8000607a:	f022                	sd	s0,32(sp)
    8000607c:	ec26                	sd	s1,24(sp)
    8000607e:	e84a                	sd	s2,16(sp)
    80006080:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006082:	c219                	beqz	a2,80006088 <printint+0x12>
    80006084:	08054663          	bltz	a0,80006110 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006088:	2501                	sext.w	a0,a0
    8000608a:	4881                	li	a7,0
    8000608c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006090:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006092:	2581                	sext.w	a1,a1
    80006094:	00002617          	auipc	a2,0x2
    80006098:	75c60613          	addi	a2,a2,1884 # 800087f0 <digits>
    8000609c:	883a                	mv	a6,a4
    8000609e:	2705                	addiw	a4,a4,1
    800060a0:	02b577bb          	remuw	a5,a0,a1
    800060a4:	1782                	slli	a5,a5,0x20
    800060a6:	9381                	srli	a5,a5,0x20
    800060a8:	97b2                	add	a5,a5,a2
    800060aa:	0007c783          	lbu	a5,0(a5)
    800060ae:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060b2:	0005079b          	sext.w	a5,a0
    800060b6:	02b5553b          	divuw	a0,a0,a1
    800060ba:	0685                	addi	a3,a3,1
    800060bc:	feb7f0e3          	bgeu	a5,a1,8000609c <printint+0x26>

  if(sign)
    800060c0:	00088b63          	beqz	a7,800060d6 <printint+0x60>
    buf[i++] = '-';
    800060c4:	fe040793          	addi	a5,s0,-32
    800060c8:	973e                	add	a4,a4,a5
    800060ca:	02d00793          	li	a5,45
    800060ce:	fef70823          	sb	a5,-16(a4)
    800060d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800060d6:	02e05763          	blez	a4,80006104 <printint+0x8e>
    800060da:	fd040793          	addi	a5,s0,-48
    800060de:	00e784b3          	add	s1,a5,a4
    800060e2:	fff78913          	addi	s2,a5,-1
    800060e6:	993a                	add	s2,s2,a4
    800060e8:	377d                	addiw	a4,a4,-1
    800060ea:	1702                	slli	a4,a4,0x20
    800060ec:	9301                	srli	a4,a4,0x20
    800060ee:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800060f2:	fff4c503          	lbu	a0,-1(s1)
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	d60080e7          	jalr	-672(ra) # 80005e56 <consputc>
  while(--i >= 0)
    800060fe:	14fd                	addi	s1,s1,-1
    80006100:	ff2499e3          	bne	s1,s2,800060f2 <printint+0x7c>
}
    80006104:	70a2                	ld	ra,40(sp)
    80006106:	7402                	ld	s0,32(sp)
    80006108:	64e2                	ld	s1,24(sp)
    8000610a:	6942                	ld	s2,16(sp)
    8000610c:	6145                	addi	sp,sp,48
    8000610e:	8082                	ret
    x = -xx;
    80006110:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006114:	4885                	li	a7,1
    x = -xx;
    80006116:	bf9d                	j	8000608c <printint+0x16>

0000000080006118 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
    80006122:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006124:	00020797          	auipc	a5,0x20
    80006128:	0c07ae23          	sw	zero,220(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    8000612c:	00002517          	auipc	a0,0x2
    80006130:	69c50513          	addi	a0,a0,1692 # 800087c8 <syscalls+0x410>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	02e080e7          	jalr	46(ra) # 80006162 <printf>
  printf(s);
    8000613c:	8526                	mv	a0,s1
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	024080e7          	jalr	36(ra) # 80006162 <printf>
  printf("\n");
    80006146:	00002517          	auipc	a0,0x2
    8000614a:	f0250513          	addi	a0,a0,-254 # 80008048 <etext+0x48>
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	014080e7          	jalr	20(ra) # 80006162 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006156:	4785                	li	a5,1
    80006158:	00003717          	auipc	a4,0x3
    8000615c:	ecf72223          	sw	a5,-316(a4) # 8000901c <panicked>
  for(;;)
    80006160:	a001                	j	80006160 <panic+0x48>

0000000080006162 <printf>:
{
    80006162:	7131                	addi	sp,sp,-192
    80006164:	fc86                	sd	ra,120(sp)
    80006166:	f8a2                	sd	s0,112(sp)
    80006168:	f4a6                	sd	s1,104(sp)
    8000616a:	f0ca                	sd	s2,96(sp)
    8000616c:	ecce                	sd	s3,88(sp)
    8000616e:	e8d2                	sd	s4,80(sp)
    80006170:	e4d6                	sd	s5,72(sp)
    80006172:	e0da                	sd	s6,64(sp)
    80006174:	fc5e                	sd	s7,56(sp)
    80006176:	f862                	sd	s8,48(sp)
    80006178:	f466                	sd	s9,40(sp)
    8000617a:	f06a                	sd	s10,32(sp)
    8000617c:	ec6e                	sd	s11,24(sp)
    8000617e:	0100                	addi	s0,sp,128
    80006180:	8a2a                	mv	s4,a0
    80006182:	e40c                	sd	a1,8(s0)
    80006184:	e810                	sd	a2,16(s0)
    80006186:	ec14                	sd	a3,24(s0)
    80006188:	f018                	sd	a4,32(s0)
    8000618a:	f41c                	sd	a5,40(s0)
    8000618c:	03043823          	sd	a6,48(s0)
    80006190:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006194:	00020d97          	auipc	s11,0x20
    80006198:	06cdad83          	lw	s11,108(s11) # 80026200 <pr+0x18>
  if(locking)
    8000619c:	020d9b63          	bnez	s11,800061d2 <printf+0x70>
  if (fmt == 0)
    800061a0:	040a0263          	beqz	s4,800061e4 <printf+0x82>
  va_start(ap, fmt);
    800061a4:	00840793          	addi	a5,s0,8
    800061a8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061ac:	000a4503          	lbu	a0,0(s4)
    800061b0:	16050263          	beqz	a0,80006314 <printf+0x1b2>
    800061b4:	4481                	li	s1,0
    if(c != '%'){
    800061b6:	02500a93          	li	s5,37
    switch(c){
    800061ba:	07000b13          	li	s6,112
  consputc('x');
    800061be:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061c0:	00002b97          	auipc	s7,0x2
    800061c4:	630b8b93          	addi	s7,s7,1584 # 800087f0 <digits>
    switch(c){
    800061c8:	07300c93          	li	s9,115
    800061cc:	06400c13          	li	s8,100
    800061d0:	a82d                	j	8000620a <printf+0xa8>
    acquire(&pr.lock);
    800061d2:	00020517          	auipc	a0,0x20
    800061d6:	01650513          	addi	a0,a0,22 # 800261e8 <pr>
    800061da:	00000097          	auipc	ra,0x0
    800061de:	488080e7          	jalr	1160(ra) # 80006662 <acquire>
    800061e2:	bf7d                	j	800061a0 <printf+0x3e>
    panic("null fmt");
    800061e4:	00002517          	auipc	a0,0x2
    800061e8:	5f450513          	addi	a0,a0,1524 # 800087d8 <syscalls+0x420>
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	f2c080e7          	jalr	-212(ra) # 80006118 <panic>
      consputc(c);
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	c62080e7          	jalr	-926(ra) # 80005e56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061fc:	2485                	addiw	s1,s1,1
    800061fe:	009a07b3          	add	a5,s4,s1
    80006202:	0007c503          	lbu	a0,0(a5)
    80006206:	10050763          	beqz	a0,80006314 <printf+0x1b2>
    if(c != '%'){
    8000620a:	ff5515e3          	bne	a0,s5,800061f4 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000620e:	2485                	addiw	s1,s1,1
    80006210:	009a07b3          	add	a5,s4,s1
    80006214:	0007c783          	lbu	a5,0(a5)
    80006218:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000621c:	cfe5                	beqz	a5,80006314 <printf+0x1b2>
    switch(c){
    8000621e:	05678a63          	beq	a5,s6,80006272 <printf+0x110>
    80006222:	02fb7663          	bgeu	s6,a5,8000624e <printf+0xec>
    80006226:	09978963          	beq	a5,s9,800062b8 <printf+0x156>
    8000622a:	07800713          	li	a4,120
    8000622e:	0ce79863          	bne	a5,a4,800062fe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006232:	f8843783          	ld	a5,-120(s0)
    80006236:	00878713          	addi	a4,a5,8
    8000623a:	f8e43423          	sd	a4,-120(s0)
    8000623e:	4605                	li	a2,1
    80006240:	85ea                	mv	a1,s10
    80006242:	4388                	lw	a0,0(a5)
    80006244:	00000097          	auipc	ra,0x0
    80006248:	e32080e7          	jalr	-462(ra) # 80006076 <printint>
      break;
    8000624c:	bf45                	j	800061fc <printf+0x9a>
    switch(c){
    8000624e:	0b578263          	beq	a5,s5,800062f2 <printf+0x190>
    80006252:	0b879663          	bne	a5,s8,800062fe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006256:	f8843783          	ld	a5,-120(s0)
    8000625a:	00878713          	addi	a4,a5,8
    8000625e:	f8e43423          	sd	a4,-120(s0)
    80006262:	4605                	li	a2,1
    80006264:	45a9                	li	a1,10
    80006266:	4388                	lw	a0,0(a5)
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	e0e080e7          	jalr	-498(ra) # 80006076 <printint>
      break;
    80006270:	b771                	j	800061fc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006272:	f8843783          	ld	a5,-120(s0)
    80006276:	00878713          	addi	a4,a5,8
    8000627a:	f8e43423          	sd	a4,-120(s0)
    8000627e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006282:	03000513          	li	a0,48
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	bd0080e7          	jalr	-1072(ra) # 80005e56 <consputc>
  consputc('x');
    8000628e:	07800513          	li	a0,120
    80006292:	00000097          	auipc	ra,0x0
    80006296:	bc4080e7          	jalr	-1084(ra) # 80005e56 <consputc>
    8000629a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000629c:	03c9d793          	srli	a5,s3,0x3c
    800062a0:	97de                	add	a5,a5,s7
    800062a2:	0007c503          	lbu	a0,0(a5)
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	bb0080e7          	jalr	-1104(ra) # 80005e56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062ae:	0992                	slli	s3,s3,0x4
    800062b0:	397d                	addiw	s2,s2,-1
    800062b2:	fe0915e3          	bnez	s2,8000629c <printf+0x13a>
    800062b6:	b799                	j	800061fc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800062b8:	f8843783          	ld	a5,-120(s0)
    800062bc:	00878713          	addi	a4,a5,8
    800062c0:	f8e43423          	sd	a4,-120(s0)
    800062c4:	0007b903          	ld	s2,0(a5)
    800062c8:	00090e63          	beqz	s2,800062e4 <printf+0x182>
      for(; *s; s++)
    800062cc:	00094503          	lbu	a0,0(s2)
    800062d0:	d515                	beqz	a0,800061fc <printf+0x9a>
        consputc(*s);
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	b84080e7          	jalr	-1148(ra) # 80005e56 <consputc>
      for(; *s; s++)
    800062da:	0905                	addi	s2,s2,1
    800062dc:	00094503          	lbu	a0,0(s2)
    800062e0:	f96d                	bnez	a0,800062d2 <printf+0x170>
    800062e2:	bf29                	j	800061fc <printf+0x9a>
        s = "(null)";
    800062e4:	00002917          	auipc	s2,0x2
    800062e8:	4ec90913          	addi	s2,s2,1260 # 800087d0 <syscalls+0x418>
      for(; *s; s++)
    800062ec:	02800513          	li	a0,40
    800062f0:	b7cd                	j	800062d2 <printf+0x170>
      consputc('%');
    800062f2:	8556                	mv	a0,s5
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	b62080e7          	jalr	-1182(ra) # 80005e56 <consputc>
      break;
    800062fc:	b701                	j	800061fc <printf+0x9a>
      consputc('%');
    800062fe:	8556                	mv	a0,s5
    80006300:	00000097          	auipc	ra,0x0
    80006304:	b56080e7          	jalr	-1194(ra) # 80005e56 <consputc>
      consputc(c);
    80006308:	854a                	mv	a0,s2
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	b4c080e7          	jalr	-1204(ra) # 80005e56 <consputc>
      break;
    80006312:	b5ed                	j	800061fc <printf+0x9a>
  if(locking)
    80006314:	020d9163          	bnez	s11,80006336 <printf+0x1d4>
}
    80006318:	70e6                	ld	ra,120(sp)
    8000631a:	7446                	ld	s0,112(sp)
    8000631c:	74a6                	ld	s1,104(sp)
    8000631e:	7906                	ld	s2,96(sp)
    80006320:	69e6                	ld	s3,88(sp)
    80006322:	6a46                	ld	s4,80(sp)
    80006324:	6aa6                	ld	s5,72(sp)
    80006326:	6b06                	ld	s6,64(sp)
    80006328:	7be2                	ld	s7,56(sp)
    8000632a:	7c42                	ld	s8,48(sp)
    8000632c:	7ca2                	ld	s9,40(sp)
    8000632e:	7d02                	ld	s10,32(sp)
    80006330:	6de2                	ld	s11,24(sp)
    80006332:	6129                	addi	sp,sp,192
    80006334:	8082                	ret
    release(&pr.lock);
    80006336:	00020517          	auipc	a0,0x20
    8000633a:	eb250513          	addi	a0,a0,-334 # 800261e8 <pr>
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	3d8080e7          	jalr	984(ra) # 80006716 <release>
}
    80006346:	bfc9                	j	80006318 <printf+0x1b6>

0000000080006348 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006348:	1101                	addi	sp,sp,-32
    8000634a:	ec06                	sd	ra,24(sp)
    8000634c:	e822                	sd	s0,16(sp)
    8000634e:	e426                	sd	s1,8(sp)
    80006350:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006352:	00020497          	auipc	s1,0x20
    80006356:	e9648493          	addi	s1,s1,-362 # 800261e8 <pr>
    8000635a:	00002597          	auipc	a1,0x2
    8000635e:	48e58593          	addi	a1,a1,1166 # 800087e8 <syscalls+0x430>
    80006362:	8526                	mv	a0,s1
    80006364:	00000097          	auipc	ra,0x0
    80006368:	26e080e7          	jalr	622(ra) # 800065d2 <initlock>
  pr.locking = 1;
    8000636c:	4785                	li	a5,1
    8000636e:	cc9c                	sw	a5,24(s1)
}
    80006370:	60e2                	ld	ra,24(sp)
    80006372:	6442                	ld	s0,16(sp)
    80006374:	64a2                	ld	s1,8(sp)
    80006376:	6105                	addi	sp,sp,32
    80006378:	8082                	ret

000000008000637a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000637a:	1141                	addi	sp,sp,-16
    8000637c:	e406                	sd	ra,8(sp)
    8000637e:	e022                	sd	s0,0(sp)
    80006380:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006382:	100007b7          	lui	a5,0x10000
    80006386:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000638a:	f8000713          	li	a4,-128
    8000638e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006392:	470d                	li	a4,3
    80006394:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006398:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000639c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800063a0:	469d                	li	a3,7
    800063a2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800063a6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063aa:	00002597          	auipc	a1,0x2
    800063ae:	45e58593          	addi	a1,a1,1118 # 80008808 <digits+0x18>
    800063b2:	00020517          	auipc	a0,0x20
    800063b6:	e5650513          	addi	a0,a0,-426 # 80026208 <uart_tx_lock>
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	218080e7          	jalr	536(ra) # 800065d2 <initlock>
}
    800063c2:	60a2                	ld	ra,8(sp)
    800063c4:	6402                	ld	s0,0(sp)
    800063c6:	0141                	addi	sp,sp,16
    800063c8:	8082                	ret

00000000800063ca <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800063ca:	1101                	addi	sp,sp,-32
    800063cc:	ec06                	sd	ra,24(sp)
    800063ce:	e822                	sd	s0,16(sp)
    800063d0:	e426                	sd	s1,8(sp)
    800063d2:	1000                	addi	s0,sp,32
    800063d4:	84aa                	mv	s1,a0
  push_off();
    800063d6:	00000097          	auipc	ra,0x0
    800063da:	240080e7          	jalr	576(ra) # 80006616 <push_off>

  if(panicked){
    800063de:	00003797          	auipc	a5,0x3
    800063e2:	c3e7a783          	lw	a5,-962(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063e6:	10000737          	lui	a4,0x10000
  if(panicked){
    800063ea:	c391                	beqz	a5,800063ee <uartputc_sync+0x24>
    for(;;)
    800063ec:	a001                	j	800063ec <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063ee:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800063f2:	0ff7f793          	andi	a5,a5,255
    800063f6:	0207f793          	andi	a5,a5,32
    800063fa:	dbf5                	beqz	a5,800063ee <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800063fc:	0ff4f793          	andi	a5,s1,255
    80006400:	10000737          	lui	a4,0x10000
    80006404:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	2ae080e7          	jalr	686(ra) # 800066b6 <pop_off>
}
    80006410:	60e2                	ld	ra,24(sp)
    80006412:	6442                	ld	s0,16(sp)
    80006414:	64a2                	ld	s1,8(sp)
    80006416:	6105                	addi	sp,sp,32
    80006418:	8082                	ret

000000008000641a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000641a:	00003717          	auipc	a4,0x3
    8000641e:	c0673703          	ld	a4,-1018(a4) # 80009020 <uart_tx_r>
    80006422:	00003797          	auipc	a5,0x3
    80006426:	c067b783          	ld	a5,-1018(a5) # 80009028 <uart_tx_w>
    8000642a:	06e78c63          	beq	a5,a4,800064a2 <uartstart+0x88>
{
    8000642e:	7139                	addi	sp,sp,-64
    80006430:	fc06                	sd	ra,56(sp)
    80006432:	f822                	sd	s0,48(sp)
    80006434:	f426                	sd	s1,40(sp)
    80006436:	f04a                	sd	s2,32(sp)
    80006438:	ec4e                	sd	s3,24(sp)
    8000643a:	e852                	sd	s4,16(sp)
    8000643c:	e456                	sd	s5,8(sp)
    8000643e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006440:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006444:	00020a17          	auipc	s4,0x20
    80006448:	dc4a0a13          	addi	s4,s4,-572 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000644c:	00003497          	auipc	s1,0x3
    80006450:	bd448493          	addi	s1,s1,-1068 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006454:	00003997          	auipc	s3,0x3
    80006458:	bd498993          	addi	s3,s3,-1068 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000645c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006460:	0ff7f793          	andi	a5,a5,255
    80006464:	0207f793          	andi	a5,a5,32
    80006468:	c785                	beqz	a5,80006490 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000646a:	01f77793          	andi	a5,a4,31
    8000646e:	97d2                	add	a5,a5,s4
    80006470:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006474:	0705                	addi	a4,a4,1
    80006476:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006478:	8526                	mv	a0,s1
    8000647a:	ffffb097          	auipc	ra,0xffffb
    8000647e:	2ce080e7          	jalr	718(ra) # 80001748 <wakeup>
    
    WriteReg(THR, c);
    80006482:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006486:	6098                	ld	a4,0(s1)
    80006488:	0009b783          	ld	a5,0(s3)
    8000648c:	fce798e3          	bne	a5,a4,8000645c <uartstart+0x42>
  }
}
    80006490:	70e2                	ld	ra,56(sp)
    80006492:	7442                	ld	s0,48(sp)
    80006494:	74a2                	ld	s1,40(sp)
    80006496:	7902                	ld	s2,32(sp)
    80006498:	69e2                	ld	s3,24(sp)
    8000649a:	6a42                	ld	s4,16(sp)
    8000649c:	6aa2                	ld	s5,8(sp)
    8000649e:	6121                	addi	sp,sp,64
    800064a0:	8082                	ret
    800064a2:	8082                	ret

00000000800064a4 <uartputc>:
{
    800064a4:	7179                	addi	sp,sp,-48
    800064a6:	f406                	sd	ra,40(sp)
    800064a8:	f022                	sd	s0,32(sp)
    800064aa:	ec26                	sd	s1,24(sp)
    800064ac:	e84a                	sd	s2,16(sp)
    800064ae:	e44e                	sd	s3,8(sp)
    800064b0:	e052                	sd	s4,0(sp)
    800064b2:	1800                	addi	s0,sp,48
    800064b4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800064b6:	00020517          	auipc	a0,0x20
    800064ba:	d5250513          	addi	a0,a0,-686 # 80026208 <uart_tx_lock>
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	1a4080e7          	jalr	420(ra) # 80006662 <acquire>
  if(panicked){
    800064c6:	00003797          	auipc	a5,0x3
    800064ca:	b567a783          	lw	a5,-1194(a5) # 8000901c <panicked>
    800064ce:	c391                	beqz	a5,800064d2 <uartputc+0x2e>
    for(;;)
    800064d0:	a001                	j	800064d0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064d2:	00003797          	auipc	a5,0x3
    800064d6:	b567b783          	ld	a5,-1194(a5) # 80009028 <uart_tx_w>
    800064da:	00003717          	auipc	a4,0x3
    800064de:	b4673703          	ld	a4,-1210(a4) # 80009020 <uart_tx_r>
    800064e2:	02070713          	addi	a4,a4,32
    800064e6:	02f71b63          	bne	a4,a5,8000651c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064ea:	00020a17          	auipc	s4,0x20
    800064ee:	d1ea0a13          	addi	s4,s4,-738 # 80026208 <uart_tx_lock>
    800064f2:	00003497          	auipc	s1,0x3
    800064f6:	b2e48493          	addi	s1,s1,-1234 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064fa:	00003917          	auipc	s2,0x3
    800064fe:	b2e90913          	addi	s2,s2,-1234 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006502:	85d2                	mv	a1,s4
    80006504:	8526                	mv	a0,s1
    80006506:	ffffb097          	auipc	ra,0xffffb
    8000650a:	0b6080e7          	jalr	182(ra) # 800015bc <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000650e:	00093783          	ld	a5,0(s2)
    80006512:	6098                	ld	a4,0(s1)
    80006514:	02070713          	addi	a4,a4,32
    80006518:	fef705e3          	beq	a4,a5,80006502 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000651c:	00020497          	auipc	s1,0x20
    80006520:	cec48493          	addi	s1,s1,-788 # 80026208 <uart_tx_lock>
    80006524:	01f7f713          	andi	a4,a5,31
    80006528:	9726                	add	a4,a4,s1
    8000652a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000652e:	0785                	addi	a5,a5,1
    80006530:	00003717          	auipc	a4,0x3
    80006534:	aef73c23          	sd	a5,-1288(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006538:	00000097          	auipc	ra,0x0
    8000653c:	ee2080e7          	jalr	-286(ra) # 8000641a <uartstart>
      release(&uart_tx_lock);
    80006540:	8526                	mv	a0,s1
    80006542:	00000097          	auipc	ra,0x0
    80006546:	1d4080e7          	jalr	468(ra) # 80006716 <release>
}
    8000654a:	70a2                	ld	ra,40(sp)
    8000654c:	7402                	ld	s0,32(sp)
    8000654e:	64e2                	ld	s1,24(sp)
    80006550:	6942                	ld	s2,16(sp)
    80006552:	69a2                	ld	s3,8(sp)
    80006554:	6a02                	ld	s4,0(sp)
    80006556:	6145                	addi	sp,sp,48
    80006558:	8082                	ret

000000008000655a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000655a:	1141                	addi	sp,sp,-16
    8000655c:	e422                	sd	s0,8(sp)
    8000655e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006560:	100007b7          	lui	a5,0x10000
    80006564:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006568:	8b85                	andi	a5,a5,1
    8000656a:	cb91                	beqz	a5,8000657e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000656c:	100007b7          	lui	a5,0x10000
    80006570:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006574:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006578:	6422                	ld	s0,8(sp)
    8000657a:	0141                	addi	sp,sp,16
    8000657c:	8082                	ret
    return -1;
    8000657e:	557d                	li	a0,-1
    80006580:	bfe5                	j	80006578 <uartgetc+0x1e>

0000000080006582 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006582:	1101                	addi	sp,sp,-32
    80006584:	ec06                	sd	ra,24(sp)
    80006586:	e822                	sd	s0,16(sp)
    80006588:	e426                	sd	s1,8(sp)
    8000658a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000658c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000658e:	00000097          	auipc	ra,0x0
    80006592:	fcc080e7          	jalr	-52(ra) # 8000655a <uartgetc>
    if(c == -1)
    80006596:	00950763          	beq	a0,s1,800065a4 <uartintr+0x22>
      break;
    consoleintr(c);
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	8fe080e7          	jalr	-1794(ra) # 80005e98 <consoleintr>
  while(1){
    800065a2:	b7f5                	j	8000658e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800065a4:	00020497          	auipc	s1,0x20
    800065a8:	c6448493          	addi	s1,s1,-924 # 80026208 <uart_tx_lock>
    800065ac:	8526                	mv	a0,s1
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	0b4080e7          	jalr	180(ra) # 80006662 <acquire>
  uartstart();
    800065b6:	00000097          	auipc	ra,0x0
    800065ba:	e64080e7          	jalr	-412(ra) # 8000641a <uartstart>
  release(&uart_tx_lock);
    800065be:	8526                	mv	a0,s1
    800065c0:	00000097          	auipc	ra,0x0
    800065c4:	156080e7          	jalr	342(ra) # 80006716 <release>
}
    800065c8:	60e2                	ld	ra,24(sp)
    800065ca:	6442                	ld	s0,16(sp)
    800065cc:	64a2                	ld	s1,8(sp)
    800065ce:	6105                	addi	sp,sp,32
    800065d0:	8082                	ret

00000000800065d2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800065d2:	1141                	addi	sp,sp,-16
    800065d4:	e422                	sd	s0,8(sp)
    800065d6:	0800                	addi	s0,sp,16
  lk->name = name;
    800065d8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800065da:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800065de:	00053823          	sd	zero,16(a0)
}
    800065e2:	6422                	ld	s0,8(sp)
    800065e4:	0141                	addi	sp,sp,16
    800065e6:	8082                	ret

00000000800065e8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065e8:	411c                	lw	a5,0(a0)
    800065ea:	e399                	bnez	a5,800065f0 <holding+0x8>
    800065ec:	4501                	li	a0,0
  return r;
}
    800065ee:	8082                	ret
{
    800065f0:	1101                	addi	sp,sp,-32
    800065f2:	ec06                	sd	ra,24(sp)
    800065f4:	e822                	sd	s0,16(sp)
    800065f6:	e426                	sd	s1,8(sp)
    800065f8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800065fa:	6904                	ld	s1,16(a0)
    800065fc:	ffffb097          	auipc	ra,0xffffb
    80006600:	86e080e7          	jalr	-1938(ra) # 80000e6a <mycpu>
    80006604:	40a48533          	sub	a0,s1,a0
    80006608:	00153513          	seqz	a0,a0
}
    8000660c:	60e2                	ld	ra,24(sp)
    8000660e:	6442                	ld	s0,16(sp)
    80006610:	64a2                	ld	s1,8(sp)
    80006612:	6105                	addi	sp,sp,32
    80006614:	8082                	ret

0000000080006616 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006616:	1101                	addi	sp,sp,-32
    80006618:	ec06                	sd	ra,24(sp)
    8000661a:	e822                	sd	s0,16(sp)
    8000661c:	e426                	sd	s1,8(sp)
    8000661e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006620:	100024f3          	csrr	s1,sstatus
    80006624:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006628:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000662a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000662e:	ffffb097          	auipc	ra,0xffffb
    80006632:	83c080e7          	jalr	-1988(ra) # 80000e6a <mycpu>
    80006636:	5d3c                	lw	a5,120(a0)
    80006638:	cf89                	beqz	a5,80006652 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000663a:	ffffb097          	auipc	ra,0xffffb
    8000663e:	830080e7          	jalr	-2000(ra) # 80000e6a <mycpu>
    80006642:	5d3c                	lw	a5,120(a0)
    80006644:	2785                	addiw	a5,a5,1
    80006646:	dd3c                	sw	a5,120(a0)
}
    80006648:	60e2                	ld	ra,24(sp)
    8000664a:	6442                	ld	s0,16(sp)
    8000664c:	64a2                	ld	s1,8(sp)
    8000664e:	6105                	addi	sp,sp,32
    80006650:	8082                	ret
    mycpu()->intena = old;
    80006652:	ffffb097          	auipc	ra,0xffffb
    80006656:	818080e7          	jalr	-2024(ra) # 80000e6a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000665a:	8085                	srli	s1,s1,0x1
    8000665c:	8885                	andi	s1,s1,1
    8000665e:	dd64                	sw	s1,124(a0)
    80006660:	bfe9                	j	8000663a <push_off+0x24>

0000000080006662 <acquire>:
{
    80006662:	1101                	addi	sp,sp,-32
    80006664:	ec06                	sd	ra,24(sp)
    80006666:	e822                	sd	s0,16(sp)
    80006668:	e426                	sd	s1,8(sp)
    8000666a:	1000                	addi	s0,sp,32
    8000666c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000666e:	00000097          	auipc	ra,0x0
    80006672:	fa8080e7          	jalr	-88(ra) # 80006616 <push_off>
  if(holding(lk))
    80006676:	8526                	mv	a0,s1
    80006678:	00000097          	auipc	ra,0x0
    8000667c:	f70080e7          	jalr	-144(ra) # 800065e8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006680:	4705                	li	a4,1
  if(holding(lk))
    80006682:	e115                	bnez	a0,800066a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006684:	87ba                	mv	a5,a4
    80006686:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000668a:	2781                	sext.w	a5,a5
    8000668c:	ffe5                	bnez	a5,80006684 <acquire+0x22>
  __sync_synchronize();
    8000668e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006692:	ffffa097          	auipc	ra,0xffffa
    80006696:	7d8080e7          	jalr	2008(ra) # 80000e6a <mycpu>
    8000669a:	e888                	sd	a0,16(s1)
}
    8000669c:	60e2                	ld	ra,24(sp)
    8000669e:	6442                	ld	s0,16(sp)
    800066a0:	64a2                	ld	s1,8(sp)
    800066a2:	6105                	addi	sp,sp,32
    800066a4:	8082                	ret
    panic("acquire");
    800066a6:	00002517          	auipc	a0,0x2
    800066aa:	16a50513          	addi	a0,a0,362 # 80008810 <digits+0x20>
    800066ae:	00000097          	auipc	ra,0x0
    800066b2:	a6a080e7          	jalr	-1430(ra) # 80006118 <panic>

00000000800066b6 <pop_off>:

void
pop_off(void)
{
    800066b6:	1141                	addi	sp,sp,-16
    800066b8:	e406                	sd	ra,8(sp)
    800066ba:	e022                	sd	s0,0(sp)
    800066bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066be:	ffffa097          	auipc	ra,0xffffa
    800066c2:	7ac080e7          	jalr	1964(ra) # 80000e6a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800066ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800066cc:	e78d                	bnez	a5,800066f6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800066ce:	5d3c                	lw	a5,120(a0)
    800066d0:	02f05b63          	blez	a5,80006706 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800066d4:	37fd                	addiw	a5,a5,-1
    800066d6:	0007871b          	sext.w	a4,a5
    800066da:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800066dc:	eb09                	bnez	a4,800066ee <pop_off+0x38>
    800066de:	5d7c                	lw	a5,124(a0)
    800066e0:	c799                	beqz	a5,800066ee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066e6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066ea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066ee:	60a2                	ld	ra,8(sp)
    800066f0:	6402                	ld	s0,0(sp)
    800066f2:	0141                	addi	sp,sp,16
    800066f4:	8082                	ret
    panic("pop_off - interruptible");
    800066f6:	00002517          	auipc	a0,0x2
    800066fa:	12250513          	addi	a0,a0,290 # 80008818 <digits+0x28>
    800066fe:	00000097          	auipc	ra,0x0
    80006702:	a1a080e7          	jalr	-1510(ra) # 80006118 <panic>
    panic("pop_off");
    80006706:	00002517          	auipc	a0,0x2
    8000670a:	12a50513          	addi	a0,a0,298 # 80008830 <digits+0x40>
    8000670e:	00000097          	auipc	ra,0x0
    80006712:	a0a080e7          	jalr	-1526(ra) # 80006118 <panic>

0000000080006716 <release>:
{
    80006716:	1101                	addi	sp,sp,-32
    80006718:	ec06                	sd	ra,24(sp)
    8000671a:	e822                	sd	s0,16(sp)
    8000671c:	e426                	sd	s1,8(sp)
    8000671e:	1000                	addi	s0,sp,32
    80006720:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006722:	00000097          	auipc	ra,0x0
    80006726:	ec6080e7          	jalr	-314(ra) # 800065e8 <holding>
    8000672a:	c115                	beqz	a0,8000674e <release+0x38>
  lk->cpu = 0;
    8000672c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006730:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006734:	0f50000f          	fence	iorw,ow
    80006738:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000673c:	00000097          	auipc	ra,0x0
    80006740:	f7a080e7          	jalr	-134(ra) # 800066b6 <pop_off>
}
    80006744:	60e2                	ld	ra,24(sp)
    80006746:	6442                	ld	s0,16(sp)
    80006748:	64a2                	ld	s1,8(sp)
    8000674a:	6105                	addi	sp,sp,32
    8000674c:	8082                	ret
    panic("release");
    8000674e:	00002517          	auipc	a0,0x2
    80006752:	0ea50513          	addi	a0,a0,234 # 80008838 <digits+0x48>
    80006756:	00000097          	auipc	ra,0x0
    8000675a:	9c2080e7          	jalr	-1598(ra) # 80006118 <panic>
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
