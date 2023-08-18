
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a0013103          	ld	sp,-1536(sp) # 80008a00 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7d2050ef          	jal	ra,800057e8 <start>

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
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	188080e7          	jalr	392(ra) # 800061e2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	228080e7          	jalr	552(ra) # 80006296 <release>
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
    8000008e:	c0e080e7          	jalr	-1010(ra) # 80005c98 <panic>

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
    800000f8:	05e080e7          	jalr	94(ra) # 80006152 <initlock>
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
    80000130:	0b6080e7          	jalr	182(ra) # 800061e2 <acquire>
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
    80000148:	152080e7          	jalr	338(ra) # 80006296 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
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
    80000172:	128080e7          	jalr	296(ra) # 80006296 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <getfreemem>:

// Return the amount of free memory.
int getfreemem(void)
{
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  int count = 0;
  struct run *r;

  acquire(&kmem.lock);
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	056080e7          	jalr	86(ra) # 800061e2 <acquire>
  r = kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
  while (r)
    80000196:	c785                	beqz	a5,800001be <getfreemem+0x46>
  int count = 0;
    80000198:	4481                	li	s1,0
  {
    count++;
    8000019a:	2485                	addiw	s1,s1,1
    r = r->next;
    8000019c:	639c                	ld	a5,0(a5)
  while (r)
    8000019e:	fff5                	bnez	a5,8000019a <getfreemem+0x22>
  }
  release(&kmem.lock);
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	e9050513          	addi	a0,a0,-368 # 80009030 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	0ee080e7          	jalr	238(ra) # 80006296 <release>
  return count * PGSIZE;
}
    800001b0:	00c4951b          	slliw	a0,s1,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  int count = 0;
    800001be:	4481                	li	s1,0
    800001c0:	b7c5                	j	800001a0 <getfreemem+0x28>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	93c080e7          	jalr	-1732(ra) # 80005ce2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	790080e7          	jalr	1936(ra) # 80001b46 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	db2080e7          	jalr	-590(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fde080e7          	jalr	-34(ra) # 800013a4 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7dc080e7          	jalr	2012(ra) # 80005baa <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	af2080e7          	jalr	-1294(ra) # 80005ec8 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	8fc080e7          	jalr	-1796(ra) # 80005ce2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8ec080e7          	jalr	-1812(ra) # 80005ce2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8dc080e7          	jalr	-1828(ra) # 80005ce2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6f0080e7          	jalr	1776(ra) # 80001b1e <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	710080e7          	jalr	1808(ra) # 80001b46 <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d1c080e7          	jalr	-740(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	d2a080e7          	jalr	-726(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	f06080e7          	jalr	-250(ra) # 80002354 <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	596080e7          	jalr	1430(ra) # 800029ec <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	540080e7          	jalr	1344(ra) # 8000399e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	e2c080e7          	jalr	-468(ra) # 80005292 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfc080e7          	jalr	-772(ra) # 8000116a <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	7c0080e7          	jalr	1984(ra) # 80005c98 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	6c8080e7          	jalr	1736(ra) # 80005c98 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	6b8080e7          	jalr	1720(ra) # 80005c98 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	63e080e7          	jalr	1598(ra) # 80005c98 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	4f2080e7          	jalr	1266(ra) # 80005c98 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4e2080e7          	jalr	1250(ra) # 80005c98 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4d2080e7          	jalr	1234(ra) # 80005c98 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	4c2080e7          	jalr	1218(ra) # 80005c98 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3e4080e7          	jalr	996(ra) # 80005c98 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	2a2080e7          	jalr	674(ra) # 80005c98 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	1c6080e7          	jalr	454(ra) # 80005c98 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	1b6080e7          	jalr	438(ra) # 80005c98 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	14c080e7          	jalr	332(ra) # 80005c98 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea17          	auipc	s4,0xe
    80000d54:	330a0a13          	addi	s4,s4,816 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	8591                	srai	a1,a1,0x4
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	17048493          	addi	s1,s1,368
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	eea080e7          	jalr	-278(ra) # 80005c98 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	378080e7          	jalr	888(ra) # 80006152 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	360080e7          	jalr	864(ra) # 80006152 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000e997          	auipc	s3,0xe
    80000e20:	26498993          	addi	s3,s3,612 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	32a080e7          	jalr	810(ra) # 80006152 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	8791                	srai	a5,a5,0x4
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	17048493          	addi	s1,s1,368
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	2fa080e7          	jalr	762(ra) # 80006196 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	380080e7          	jalr	896(ra) # 80006236 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	3bc080e7          	jalr	956(ra) # 80006296 <release>

  if (first) {
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	a0e7a783          	lw	a5,-1522(a5) # 800088f0 <first.1677>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c72080e7          	jalr	-910(ra) # 80001b5e <usertrapret>
}
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    first = 0;
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	9e07aa23          	sw	zero,-1548(a5) # 800088f0 <first.1677>
    fsinit(ROOTDEV);
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a66080e7          	jalr	-1434(ra) # 8000296c <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
allocpid() {
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	2bc080e7          	jalr	700(ra) # 800061e2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	9c678793          	addi	a5,a5,-1594 # 800088f4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	356080e7          	jalr	854(ra) # 80006296 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f90:	4719                	li	a4,6
    80000f92:	05893683          	ld	a3,88(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001050:	6d28                	ld	a0,88(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001060:	68a8                	ld	a0,80(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001064:	64ac                	ld	a1,72(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    8000106e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001072:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001076:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108e:	0004ac23          	sw	zero,24(s1)
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <allocproc>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	00008497          	auipc	s1,0x8
    800010ac:	3d848493          	addi	s1,s1,984 # 80009480 <proc>
    800010b0:	0000e917          	auipc	s2,0xe
    800010b4:	fd090913          	addi	s2,s2,-48 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	128080e7          	jalr	296(ra) # 800061e2 <acquire>
    if(p->state == UNUSED) {
    800010c2:	4c9c                	lw	a5,24(s1)
    800010c4:	cf81                	beqz	a5,800010dc <allocproc+0x40>
      release(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00005097          	auipc	ra,0x5
    800010cc:	1ce080e7          	jalr	462(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d0:	17048493          	addi	s1,s1,368
    800010d4:	ff2492e3          	bne	s1,s2,800010b8 <allocproc+0x1c>
  return 0;
    800010d8:	4481                	li	s1,0
    800010da:	a889                	j	8000112c <allocproc+0x90>
  p->pid = allocpid();
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e34080e7          	jalr	-460(ra) # 80000f10 <allocpid>
    800010e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e6:	4785                	li	a5,1
    800010e8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	02e080e7          	jalr	46(ra) # 80000118 <kalloc>
    800010f2:	892a                	mv	s2,a0
    800010f4:	eca8                	sd	a0,88(s1)
    800010f6:	c131                	beqz	a0,8000113a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	e5c080e7          	jalr	-420(ra) # 80000f56 <proc_pagetable>
    80001102:	892a                	mv	s2,a0
    80001104:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001106:	c531                	beqz	a0,80001152 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001108:	07000613          	li	a2,112
    8000110c:	4581                	li	a1,0
    8000110e:	06048513          	addi	a0,s1,96
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	0b0080e7          	jalr	176(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    8000111a:	00000797          	auipc	a5,0x0
    8000111e:	db078793          	addi	a5,a5,-592 # 80000eca <forkret>
    80001122:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001124:	60bc                	ld	a5,64(s1)
    80001126:	6705                	lui	a4,0x1
    80001128:	97ba                	add	a5,a5,a4
    8000112a:	f4bc                	sd	a5,104(s1)
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    freeproc(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f08080e7          	jalr	-248(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	150080e7          	jalr	336(ra) # 80006296 <release>
    return 0;
    8000114e:	84ca                	mv	s1,s2
    80001150:	bff1                	j	8000112c <allocproc+0x90>
    freeproc(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	ef0080e7          	jalr	-272(ra) # 80001044 <freeproc>
    release(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	138080e7          	jalr	312(ra) # 80006296 <release>
    return 0;
    80001166:	84ca                	mv	s1,s2
    80001168:	b7d1                	j	8000112c <allocproc+0x90>

000000008000116a <userinit>:
{
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
  p = allocproc();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f28080e7          	jalr	-216(ra) # 8000109c <allocproc>
    8000117c:	84aa                	mv	s1,a0
  initproc = p;
    8000117e:	00008797          	auipc	a5,0x8
    80001182:	e8a7b923          	sd	a0,-366(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001186:	03400613          	li	a2,52
    8000118a:	00007597          	auipc	a1,0x7
    8000118e:	77658593          	addi	a1,a1,1910 # 80008900 <initcode>
    80001192:	6928                	ld	a0,80(a0)
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	6b6080e7          	jalr	1718(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    8000119c:	6785                	lui	a5,0x1
    8000119e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a0:	6cb8                	ld	a4,88(s1)
    800011a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a6:	6cb8                	ld	a4,88(s1)
    800011a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011aa:	4641                	li	a2,16
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	fd458593          	addi	a1,a1,-44 # 80008180 <etext+0x180>
    800011b4:	15848513          	addi	a0,s1,344
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	15c080e7          	jalr	348(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	fd050513          	addi	a0,a0,-48 # 80008190 <etext+0x190>
    800011c8:	00002097          	auipc	ra,0x2
    800011cc:	1d2080e7          	jalr	466(ra) # 8000339a <namei>
    800011d0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	0bc080e7          	jalr	188(ra) # 80006296 <release>
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <growproc>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	c98080e7          	jalr	-872(ra) # 80000e92 <myproc>
    80001202:	892a                	mv	s2,a0
  sz = p->sz;
    80001204:	652c                	ld	a1,72(a0)
    80001206:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000120a:	00904f63          	bgtz	s1,80001228 <growproc+0x3c>
  } else if(n < 0){
    8000120e:	0204cc63          	bltz	s1,80001246 <growproc+0x5a>
  p->sz = sz;
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	04c93423          	sd	a2,72(s2)
  return 0;
    8000121a:	4501                	li	a0,0
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001228:	9e25                	addw	a2,a2,s1
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	6928                	ld	a0,80(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6d0080e7          	jalr	1744(ra) # 80000904 <uvmalloc>
    8000123c:	0005061b          	sext.w	a2,a0
    80001240:	fa69                	bnez	a2,80001212 <growproc+0x26>
      return -1;
    80001242:	557d                	li	a0,-1
    80001244:	bfe1                	j	8000121c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001246:	9e25                	addw	a2,a2,s1
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	66a080e7          	jalr	1642(ra) # 800008bc <uvmdealloc>
    8000125a:	0005061b          	sext.w	a2,a0
    8000125e:	bf55                	j	80001212 <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7179                	addi	sp,sp,-48
    80001262:	f406                	sd	ra,40(sp)
    80001264:	f022                	sd	s0,32(sp)
    80001266:	ec26                	sd	s1,24(sp)
    80001268:	e84a                	sd	s2,16(sp)
    8000126a:	e44e                	sd	s3,8(sp)
    8000126c:	e052                	sd	s4,0(sp)
    8000126e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c22080e7          	jalr	-990(ra) # 80000e92 <myproc>
    80001278:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e22080e7          	jalr	-478(ra) # 8000109c <allocproc>
    80001282:	10050f63          	beqz	a0,800013a0 <fork+0x140>
    80001286:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001288:	04893603          	ld	a2,72(s2)
    8000128c:	692c                	ld	a1,80(a0)
    8000128e:	05093503          	ld	a0,80(s2)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7be080e7          	jalr	1982(ra) # 80000a50 <uvmcopy>
    8000129a:	04054a63          	bltz	a0,800012ee <fork+0x8e>
  np->sz = p->sz;
    8000129e:	04893783          	ld	a5,72(s2)
    800012a2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a6:	05893683          	ld	a3,88(s2)
    800012aa:	87b6                	mv	a5,a3
    800012ac:	0589b703          	ld	a4,88(s3)
    800012b0:	12068693          	addi	a3,a3,288
    800012b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b8:	6788                	ld	a0,8(a5)
    800012ba:	6b8c                	ld	a1,16(a5)
    800012bc:	6f90                	ld	a2,24(a5)
    800012be:	01073023          	sd	a6,0(a4)
    800012c2:	e708                	sd	a0,8(a4)
    800012c4:	eb0c                	sd	a1,16(a4)
    800012c6:	ef10                	sd	a2,24(a4)
    800012c8:	02078793          	addi	a5,a5,32
    800012cc:	02070713          	addi	a4,a4,32
    800012d0:	fed792e3          	bne	a5,a3,800012b4 <fork+0x54>
   np->tracemask = p->tracemask;
    800012d4:	16892783          	lw	a5,360(s2)
    800012d8:	16f9a423          	sw	a5,360(s3)
  np->trapframe->a0 = 0;
    800012dc:	0589b783          	ld	a5,88(s3)
    800012e0:	0607b823          	sd	zero,112(a5)
    800012e4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012e8:	15000a13          	li	s4,336
    800012ec:	a03d                	j	8000131a <fork+0xba>
    freeproc(np);
    800012ee:	854e                	mv	a0,s3
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d54080e7          	jalr	-684(ra) # 80001044 <freeproc>
    release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	f9c080e7          	jalr	-100(ra) # 80006296 <release>
    return -1;
    80001302:	5a7d                	li	s4,-1
    80001304:	a069                	j	8000138e <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	72a080e7          	jalr	1834(ra) # 80003a30 <filedup>
    8000130e:	009987b3          	add	a5,s3,s1
    80001312:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001314:	04a1                	addi	s1,s1,8
    80001316:	01448763          	beq	s1,s4,80001324 <fork+0xc4>
    if(p->ofile[i])
    8000131a:	009907b3          	add	a5,s2,s1
    8000131e:	6388                	ld	a0,0(a5)
    80001320:	f17d                	bnez	a0,80001306 <fork+0xa6>
    80001322:	bfcd                	j	80001314 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001324:	15093503          	ld	a0,336(s2)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	87e080e7          	jalr	-1922(ra) # 80002ba6 <idup>
    80001330:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001334:	4641                	li	a2,16
    80001336:	15890593          	addi	a1,s2,344
    8000133a:	15898513          	addi	a0,s3,344
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	fd6080e7          	jalr	-42(ra) # 80000314 <safestrcpy>
  pid = np->pid;
    80001346:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000134a:	854e                	mv	a0,s3
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	f4a080e7          	jalr	-182(ra) # 80006296 <release>
  acquire(&wait_lock);
    80001354:	00008497          	auipc	s1,0x8
    80001358:	d1448493          	addi	s1,s1,-748 # 80009068 <wait_lock>
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	e84080e7          	jalr	-380(ra) # 800061e2 <acquire>
  np->parent = p;
    80001366:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	f2a080e7          	jalr	-214(ra) # 80006296 <release>
  acquire(&np->lock);
    80001374:	854e                	mv	a0,s3
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	e6c080e7          	jalr	-404(ra) # 800061e2 <acquire>
  np->state = RUNNABLE;
    8000137e:	478d                	li	a5,3
    80001380:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001384:	854e                	mv	a0,s3
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	f10080e7          	jalr	-240(ra) # 80006296 <release>
}
    8000138e:	8552                	mv	a0,s4
    80001390:	70a2                	ld	ra,40(sp)
    80001392:	7402                	ld	s0,32(sp)
    80001394:	64e2                	ld	s1,24(sp)
    80001396:	6942                	ld	s2,16(sp)
    80001398:	69a2                	ld	s3,8(sp)
    8000139a:	6a02                	ld	s4,0(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
    return -1;
    800013a0:	5a7d                	li	s4,-1
    800013a2:	b7f5                	j	8000138e <fork+0x12e>

00000000800013a4 <scheduler>:
{
    800013a4:	7139                	addi	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	addi	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013bc:	00779a93          	slli	s5,a5,0x7
    800013c0:	00008717          	auipc	a4,0x8
    800013c4:	c9070713          	addi	a4,a4,-880 # 80009050 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ce:	00008717          	auipc	a4,0x8
    800013d2:	cba70713          	addi	a4,a4,-838 # 80009088 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d8:	498d                	li	s3,3
        p->state = RUNNING;
    800013da:	4b11                	li	s6,4
        c->proc = p;
    800013dc:	079e                	slli	a5,a5,0x7
    800013de:	00008a17          	auipc	s4,0x8
    800013e2:	c72a0a13          	addi	s4,s4,-910 # 80009050 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	0000e917          	auipc	s2,0xe
    800013ec:	c9890913          	addi	s2,s2,-872 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	08448493          	addi	s1,s1,132 # 80009480 <proc>
    80001404:	a03d                	j	80001432 <scheduler+0x8e>
        p->state = RUNNING;
    80001406:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140e:	06048593          	addi	a1,s1,96
    80001412:	8556                	mv	a0,s5
    80001414:	00000097          	auipc	ra,0x0
    80001418:	6a0080e7          	jalr	1696(ra) # 80001ab4 <swtch>
        c->proc = 0;
    8000141c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	e74080e7          	jalr	-396(ra) # 80006296 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	17048493          	addi	s1,s1,368
    8000142e:	fd2481e3          	beq	s1,s2,800013f0 <scheduler+0x4c>
      acquire(&p->lock);
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	dae080e7          	jalr	-594(ra) # 800061e2 <acquire>
      if(p->state == RUNNABLE) {
    8000143c:	4c9c                	lw	a5,24(s1)
    8000143e:	ff3791e3          	bne	a5,s3,80001420 <scheduler+0x7c>
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a40080e7          	jalr	-1472(ra) # 80000e92 <myproc>
    8000145a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	d0c080e7          	jalr	-756(ra) # 80006168 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00008717          	auipc	a4,0x8
    80001470:	be470713          	addi	a4,a4,-1052 # 80009050 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
  if(p->state == RUNNING)
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001490:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001492:	00008917          	auipc	s2,0x8
    80001496:	bbe90913          	addi	s2,s2,-1090 # 80009050 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008597          	auipc	a1,0x8
    800014ae:	bde58593          	addi	a1,a1,-1058 # 80009088 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06048513          	addi	a0,s1,96
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	5fc080e7          	jalr	1532(ra) # 80001ab4 <swtch>
    800014c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	slli	a5,a5,0x7
    800014c6:	97ca                	add	a5,a5,s2
    800014c8:	0b37a623          	sw	s3,172(a5)
}
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
    panic("sched p->lock");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cbe50513          	addi	a0,a0,-834 # 80008198 <etext+0x198>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	7b6080e7          	jalr	1974(ra) # 80005c98 <panic>
    panic("sched locks");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cbe50513          	addi	a0,a0,-834 # 800081a8 <etext+0x1a8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	7a6080e7          	jalr	1958(ra) # 80005c98 <panic>
    panic("sched running");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cbe50513          	addi	a0,a0,-834 # 800081b8 <etext+0x1b8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	796080e7          	jalr	1942(ra) # 80005c98 <panic>
    panic("sched interruptible");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cbe50513          	addi	a0,a0,-834 # 800081c8 <etext+0x1c8>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	786080e7          	jalr	1926(ra) # 80005c98 <panic>

000000008000151a <yield>:
{
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	96e080e7          	jalr	-1682(ra) # 80000e92 <myproc>
    8000152c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	cb4080e7          	jalr	-844(ra) # 800061e2 <acquire>
  p->state = RUNNABLE;
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	d52080e7          	jalr	-686(ra) # 80006296 <release>
}
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	addi	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	92a080e7          	jalr	-1750(ra) # 80000e92 <myproc>
    80001570:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	c70080e7          	jalr	-912(ra) # 800061e2 <acquire>
  release(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	d1a080e7          	jalr	-742(ra) # 80006296 <release>

  // Go to sleep.
  p->chan = chan;
    80001584:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)

  sched();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>

  // Tidy up.
  p->chan = 0;
    80001594:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	cfc080e7          	jalr	-772(ra) # 80006296 <release>
  acquire(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c3e080e7          	jalr	-962(ra) # 800061e2 <acquire>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wait>:
{
    800015ba:	715d                	addi	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	e062                	sd	s8,0(sp)
    800015d0:	0880                	addi	s0,sp,80
    800015d2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	8be080e7          	jalr	-1858(ra) # 80000e92 <myproc>
    800015dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015de:	00008517          	auipc	a0,0x8
    800015e2:	a8a50513          	addi	a0,a0,-1398 # 80009068 <wait_lock>
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	bfc080e7          	jalr	-1028(ra) # 800061e2 <acquire>
    havekids = 0;
    800015ee:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f2:	0000e997          	auipc	s3,0xe
    800015f6:	a8e98993          	addi	s3,s3,-1394 # 8000f080 <tickslock>
        havekids = 1;
    800015fa:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fc:	00008c17          	auipc	s8,0x8
    80001600:	a6cc0c13          	addi	s8,s8,-1428 # 80009068 <wait_lock>
    havekids = 0;
    80001604:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001606:	00008497          	auipc	s1,0x8
    8000160a:	e7a48493          	addi	s1,s1,-390 # 80009480 <proc>
    8000160e:	a0bd                	j	8000167c <wait+0xc2>
          pid = np->pid;
    80001610:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001614:	000b0e63          	beqz	s6,80001630 <wait+0x76>
    80001618:	4691                	li	a3,4
    8000161a:	02c48613          	addi	a2,s1,44
    8000161e:	85da                	mv	a1,s6
    80001620:	05093503          	ld	a0,80(s2)
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	530080e7          	jalr	1328(ra) # 80000b54 <copyout>
    8000162c:	02054563          	bltz	a0,80001656 <wait+0x9c>
          freeproc(np);
    80001630:	8526                	mv	a0,s1
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a12080e7          	jalr	-1518(ra) # 80001044 <freeproc>
          release(&np->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c5a080e7          	jalr	-934(ra) # 80006296 <release>
          release(&wait_lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	a2450513          	addi	a0,a0,-1500 # 80009068 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	c4a080e7          	jalr	-950(ra) # 80006296 <release>
          return pid;
    80001654:	a09d                	j	800016ba <wait+0x100>
            release(&np->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	c3e080e7          	jalr	-962(ra) # 80006296 <release>
            release(&wait_lock);
    80001660:	00008517          	auipc	a0,0x8
    80001664:	a0850513          	addi	a0,a0,-1528 # 80009068 <wait_lock>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	c2e080e7          	jalr	-978(ra) # 80006296 <release>
            return -1;
    80001670:	59fd                	li	s3,-1
    80001672:	a0a1                	j	800016ba <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001674:	17048493          	addi	s1,s1,368
    80001678:	03348463          	beq	s1,s3,800016a0 <wait+0xe6>
      if(np->parent == p){
    8000167c:	7c9c                	ld	a5,56(s1)
    8000167e:	ff279be3          	bne	a5,s2,80001674 <wait+0xba>
        acquire(&np->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	b5e080e7          	jalr	-1186(ra) # 800061e2 <acquire>
        if(np->state == ZOMBIE){
    8000168c:	4c9c                	lw	a5,24(s1)
    8000168e:	f94781e3          	beq	a5,s4,80001610 <wait+0x56>
        release(&np->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	c02080e7          	jalr	-1022(ra) # 80006296 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bfd9                	j	80001674 <wait+0xba>
    if(!havekids || p->killed){
    800016a0:	c701                	beqz	a4,800016a8 <wait+0xee>
    800016a2:	02892783          	lw	a5,40(s2)
    800016a6:	c79d                	beqz	a5,800016d4 <wait+0x11a>
      release(&wait_lock);
    800016a8:	00008517          	auipc	a0,0x8
    800016ac:	9c050513          	addi	a0,a0,-1600 # 80009068 <wait_lock>
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	be6080e7          	jalr	-1050(ra) # 80006296 <release>
      return -1;
    800016b8:	59fd                	li	s3,-1
}
    800016ba:	854e                	mv	a0,s3
    800016bc:	60a6                	ld	ra,72(sp)
    800016be:	6406                	ld	s0,64(sp)
    800016c0:	74e2                	ld	s1,56(sp)
    800016c2:	7942                	ld	s2,48(sp)
    800016c4:	79a2                	ld	s3,40(sp)
    800016c6:	7a02                	ld	s4,32(sp)
    800016c8:	6ae2                	ld	s5,24(sp)
    800016ca:	6b42                	ld	s6,16(sp)
    800016cc:	6ba2                	ld	s7,8(sp)
    800016ce:	6c02                	ld	s8,0(sp)
    800016d0:	6161                	addi	sp,sp,80
    800016d2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d4:	85e2                	mv	a1,s8
    800016d6:	854a                	mv	a0,s2
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e7e080e7          	jalr	-386(ra) # 80001556 <sleep>
    havekids = 0;
    800016e0:	b715                	j	80001604 <wait+0x4a>

00000000800016e2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e2:	7139                	addi	sp,sp,-64
    800016e4:	fc06                	sd	ra,56(sp)
    800016e6:	f822                	sd	s0,48(sp)
    800016e8:	f426                	sd	s1,40(sp)
    800016ea:	f04a                	sd	s2,32(sp)
    800016ec:	ec4e                	sd	s3,24(sp)
    800016ee:	e852                	sd	s4,16(sp)
    800016f0:	e456                	sd	s5,8(sp)
    800016f2:	0080                	addi	s0,sp,64
    800016f4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f6:	00008497          	auipc	s1,0x8
    800016fa:	d8a48493          	addi	s1,s1,-630 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fe:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001700:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	0000e917          	auipc	s2,0xe
    80001706:	97e90913          	addi	s2,s2,-1666 # 8000f080 <tickslock>
    8000170a:	a821                	j	80001722 <wakeup+0x40>
        p->state = RUNNABLE;
    8000170c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b84080e7          	jalr	-1148(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	17048493          	addi	s1,s1,368
    8000171e:	03248463          	beq	s1,s2,80001746 <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	770080e7          	jalr	1904(ra) # 80000e92 <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x38>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	ab2080e7          	jalr	-1358(ra) # 800061e2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2e>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2e>
    80001744:	b7e1                	j	8000170c <wakeup+0x2a>
    }
  }
}
    80001746:	70e2                	ld	ra,56(sp)
    80001748:	7442                	ld	s0,48(sp)
    8000174a:	74a2                	ld	s1,40(sp)
    8000174c:	7902                	ld	s2,32(sp)
    8000174e:	69e2                	ld	s3,24(sp)
    80001750:	6a42                	ld	s4,16(sp)
    80001752:	6aa2                	ld	s5,8(sp)
    80001754:	6121                	addi	sp,sp,64
    80001756:	8082                	ret

0000000080001758 <reparent>:
{
    80001758:	7179                	addi	sp,sp,-48
    8000175a:	f406                	sd	ra,40(sp)
    8000175c:	f022                	sd	s0,32(sp)
    8000175e:	ec26                	sd	s1,24(sp)
    80001760:	e84a                	sd	s2,16(sp)
    80001762:	e44e                	sd	s3,8(sp)
    80001764:	e052                	sd	s4,0(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176a:	00008497          	auipc	s1,0x8
    8000176e:	d1648493          	addi	s1,s1,-746 # 80009480 <proc>
      pp->parent = initproc;
    80001772:	00008a17          	auipc	s4,0x8
    80001776:	89ea0a13          	addi	s4,s4,-1890 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177a:	0000e997          	auipc	s3,0xe
    8000177e:	90698993          	addi	s3,s3,-1786 # 8000f080 <tickslock>
    80001782:	a029                	j	8000178c <reparent+0x34>
    80001784:	17048493          	addi	s1,s1,368
    80001788:	01348d63          	beq	s1,s3,800017a2 <reparent+0x4a>
    if(pp->parent == p){
    8000178c:	7c9c                	ld	a5,56(s1)
    8000178e:	ff279be3          	bne	a5,s2,80001784 <reparent+0x2c>
      pp->parent = initproc;
    80001792:	000a3503          	ld	a0,0(s4)
    80001796:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	f4a080e7          	jalr	-182(ra) # 800016e2 <wakeup>
    800017a0:	b7d5                	j	80001784 <reparent+0x2c>
}
    800017a2:	70a2                	ld	ra,40(sp)
    800017a4:	7402                	ld	s0,32(sp)
    800017a6:	64e2                	ld	s1,24(sp)
    800017a8:	6942                	ld	s2,16(sp)
    800017aa:	69a2                	ld	s3,8(sp)
    800017ac:	6a02                	ld	s4,0(sp)
    800017ae:	6145                	addi	sp,sp,48
    800017b0:	8082                	ret

00000000800017b2 <exit>:
{
    800017b2:	7179                	addi	sp,sp,-48
    800017b4:	f406                	sd	ra,40(sp)
    800017b6:	f022                	sd	s0,32(sp)
    800017b8:	ec26                	sd	s1,24(sp)
    800017ba:	e84a                	sd	s2,16(sp)
    800017bc:	e44e                	sd	s3,8(sp)
    800017be:	e052                	sd	s4,0(sp)
    800017c0:	1800                	addi	s0,sp,48
    800017c2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	6ce080e7          	jalr	1742(ra) # 80000e92 <myproc>
    800017cc:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ce:	00008797          	auipc	a5,0x8
    800017d2:	8427b783          	ld	a5,-1982(a5) # 80009010 <initproc>
    800017d6:	0d050493          	addi	s1,a0,208
    800017da:	15050913          	addi	s2,a0,336
    800017de:	02a79363          	bne	a5,a0,80001804 <exit+0x52>
    panic("init exiting");
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	9fe50513          	addi	a0,a0,-1538 # 800081e0 <etext+0x1e0>
    800017ea:	00004097          	auipc	ra,0x4
    800017ee:	4ae080e7          	jalr	1198(ra) # 80005c98 <panic>
      fileclose(f);
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	290080e7          	jalr	656(ra) # 80003a82 <fileclose>
      p->ofile[fd] = 0;
    800017fa:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248563          	beq	s1,s2,8000180a <exit+0x58>
    if(p->ofile[fd]){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	f575                	bnez	a0,800017f2 <exit+0x40>
    80001808:	bfdd                	j	800017fe <exit+0x4c>
  begin_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	dac080e7          	jalr	-596(ra) # 800035b6 <begin_op>
  iput(p->cwd);
    80001812:	1509b503          	ld	a0,336(s3)
    80001816:	00001097          	auipc	ra,0x1
    8000181a:	588080e7          	jalr	1416(ra) # 80002d9e <iput>
  end_op();
    8000181e:	00002097          	auipc	ra,0x2
    80001822:	e18080e7          	jalr	-488(ra) # 80003636 <end_op>
  p->cwd = 0;
    80001826:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182a:	00008497          	auipc	s1,0x8
    8000182e:	83e48493          	addi	s1,s1,-1986 # 80009068 <wait_lock>
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	9ae080e7          	jalr	-1618(ra) # 800061e2 <acquire>
  reparent(p);
    8000183c:	854e                	mv	a0,s3
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	f1a080e7          	jalr	-230(ra) # 80001758 <reparent>
  wakeup(p->parent);
    80001846:	0389b503          	ld	a0,56(s3)
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	e98080e7          	jalr	-360(ra) # 800016e2 <wakeup>
  acquire(&p->lock);
    80001852:	854e                	mv	a0,s3
    80001854:	00005097          	auipc	ra,0x5
    80001858:	98e080e7          	jalr	-1650(ra) # 800061e2 <acquire>
  p->xstate = status;
    8000185c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001860:	4795                	li	a5,5
    80001862:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	a2e080e7          	jalr	-1490(ra) # 80006296 <release>
  sched();
    80001870:	00000097          	auipc	ra,0x0
    80001874:	bd4080e7          	jalr	-1068(ra) # 80001444 <sched>
  panic("zombie exit");
    80001878:	00007517          	auipc	a0,0x7
    8000187c:	97850513          	addi	a0,a0,-1672 # 800081f0 <etext+0x1f0>
    80001880:	00004097          	auipc	ra,0x4
    80001884:	418080e7          	jalr	1048(ra) # 80005c98 <panic>

0000000080001888 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	1800                	addi	s0,sp,48
    80001896:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001898:	00008497          	auipc	s1,0x8
    8000189c:	be848493          	addi	s1,s1,-1048 # 80009480 <proc>
    800018a0:	0000d997          	auipc	s3,0xd
    800018a4:	7e098993          	addi	s3,s3,2016 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	938080e7          	jalr	-1736(ra) # 800061e2 <acquire>
    if(p->pid == pid){
    800018b2:	589c                	lw	a5,48(s1)
    800018b4:	01278d63          	beq	a5,s2,800018ce <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	9dc080e7          	jalr	-1572(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c2:	17048493          	addi	s1,s1,368
    800018c6:	ff3491e3          	bne	s1,s3,800018a8 <kill+0x20>
  }
  return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	a829                	j	800018e6 <kill+0x5e>
      p->killed = 1;
    800018ce:	4785                	li	a5,1
    800018d0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d2:	4c98                	lw	a4,24(s1)
    800018d4:	4789                	li	a5,2
    800018d6:	00f70f63          	beq	a4,a5,800018f4 <kill+0x6c>
      release(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	9ba080e7          	jalr	-1606(ra) # 80006296 <release>
      return 0;
    800018e4:	4501                	li	a0,0
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret
        p->state = RUNNABLE;
    800018f4:	478d                	li	a5,3
    800018f6:	cc9c                	sw	a5,24(s1)
    800018f8:	b7cd                	j	800018da <kill+0x52>

00000000800018fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	e052                	sd	s4,0(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	84aa                	mv	s1,a0
    8000190c:	892e                	mv	s2,a1
    8000190e:	89b2                	mv	s3,a2
    80001910:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	580080e7          	jalr	1408(ra) # 80000e92 <myproc>
  if(user_dst){
    8000191a:	c08d                	beqz	s1,8000193c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191c:	86d2                	mv	a3,s4
    8000191e:	864e                	mv	a2,s3
    80001920:	85ca                	mv	a1,s2
    80001922:	6928                	ld	a0,80(a0)
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	230080e7          	jalr	560(ra) # 80000b54 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
    memmove((char *)dst, src, len);
    8000193c:	000a061b          	sext.w	a2,s4
    80001940:	85ce                	mv	a1,s3
    80001942:	854a                	mv	a0,s2
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	8de080e7          	jalr	-1826(ra) # 80000222 <memmove>
    return 0;
    8000194c:	8526                	mv	a0,s1
    8000194e:	bff9                	j	8000192c <either_copyout+0x32>

0000000080001950 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001950:	7179                	addi	sp,sp,-48
    80001952:	f406                	sd	ra,40(sp)
    80001954:	f022                	sd	s0,32(sp)
    80001956:	ec26                	sd	s1,24(sp)
    80001958:	e84a                	sd	s2,16(sp)
    8000195a:	e44e                	sd	s3,8(sp)
    8000195c:	e052                	sd	s4,0(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	892a                	mv	s2,a0
    80001962:	84ae                	mv	s1,a1
    80001964:	89b2                	mv	s3,a2
    80001966:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	52a080e7          	jalr	1322(ra) # 80000e92 <myproc>
  if(user_src){
    80001970:	c08d                	beqz	s1,80001992 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001972:	86d2                	mv	a3,s4
    80001974:	864e                	mv	a2,s3
    80001976:	85ca                	mv	a1,s2
    80001978:	6928                	ld	a0,80(a0)
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	266080e7          	jalr	614(ra) # 80000be0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6a02                	ld	s4,0(sp)
    8000198e:	6145                	addi	sp,sp,48
    80001990:	8082                	ret
    memmove(dst, (char*)src, len);
    80001992:	000a061b          	sext.w	a2,s4
    80001996:	85ce                	mv	a1,s3
    80001998:	854a                	mv	a0,s2
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	888080e7          	jalr	-1912(ra) # 80000222 <memmove>
    return 0;
    800019a2:	8526                	mv	a0,s1
    800019a4:	bff9                	j	80001982 <either_copyin+0x32>

00000000800019a6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a6:	715d                	addi	sp,sp,-80
    800019a8:	e486                	sd	ra,72(sp)
    800019aa:	e0a2                	sd	s0,64(sp)
    800019ac:	fc26                	sd	s1,56(sp)
    800019ae:	f84a                	sd	s2,48(sp)
    800019b0:	f44e                	sd	s3,40(sp)
    800019b2:	f052                	sd	s4,32(sp)
    800019b4:	ec56                	sd	s5,24(sp)
    800019b6:	e85a                	sd	s6,16(sp)
    800019b8:	e45e                	sd	s7,8(sp)
    800019ba:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019bc:	00006517          	auipc	a0,0x6
    800019c0:	68c50513          	addi	a0,a0,1676 # 80008048 <etext+0x48>
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	31e080e7          	jalr	798(ra) # 80005ce2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019cc:	00008497          	auipc	s1,0x8
    800019d0:	c0c48493          	addi	s1,s1,-1012 # 800095d8 <proc+0x158>
    800019d4:	0000e917          	auipc	s2,0xe
    800019d8:	80490913          	addi	s2,s2,-2044 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019de:	00007997          	auipc	s3,0x7
    800019e2:	82298993          	addi	s3,s3,-2014 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e6:	00007a97          	auipc	s5,0x7
    800019ea:	822a8a93          	addi	s5,s5,-2014 # 80008208 <etext+0x208>
    printf("\n");
    800019ee:	00006a17          	auipc	s4,0x6
    800019f2:	65aa0a13          	addi	s4,s4,1626 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f6:	00007b97          	auipc	s7,0x7
    800019fa:	84ab8b93          	addi	s7,s7,-1974 # 80008240 <states.1714>
    800019fe:	a00d                	j	80001a20 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a00:	ed86a583          	lw	a1,-296(a3)
    80001a04:	8556                	mv	a0,s5
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	2dc080e7          	jalr	732(ra) # 80005ce2 <printf>
    printf("\n");
    80001a0e:	8552                	mv	a0,s4
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	2d2080e7          	jalr	722(ra) # 80005ce2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a18:	17048493          	addi	s1,s1,368
    80001a1c:	03248163          	beq	s1,s2,80001a3e <procdump+0x98>
    if(p->state == UNUSED)
    80001a20:	86a6                	mv	a3,s1
    80001a22:	ec04a783          	lw	a5,-320(s1)
    80001a26:	dbed                	beqz	a5,80001a18 <procdump+0x72>
      state = "???";
    80001a28:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2a:	fcfb6be3          	bltu	s6,a5,80001a00 <procdump+0x5a>
    80001a2e:	1782                	slli	a5,a5,0x20
    80001a30:	9381                	srli	a5,a5,0x20
    80001a32:	078e                	slli	a5,a5,0x3
    80001a34:	97de                	add	a5,a5,s7
    80001a36:	6390                	ld	a2,0(a5)
    80001a38:	f661                	bnez	a2,80001a00 <procdump+0x5a>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	b7d1                	j	80001a00 <procdump+0x5a>
  }
}
    80001a3e:	60a6                	ld	ra,72(sp)
    80001a40:	6406                	ld	s0,64(sp)
    80001a42:	74e2                	ld	s1,56(sp)
    80001a44:	7942                	ld	s2,48(sp)
    80001a46:	79a2                	ld	s3,40(sp)
    80001a48:	7a02                	ld	s4,32(sp)
    80001a4a:	6ae2                	ld	s5,24(sp)
    80001a4c:	6b42                	ld	s6,16(sp)
    80001a4e:	6ba2                	ld	s7,8(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <getnproc>:

// Return the number of non-UNUSED procs in the process table.
int getnproc(void)
{
    80001a54:	7179                	addi	sp,sp,-48
    80001a56:	f406                	sd	ra,40(sp)
    80001a58:	f022                	sd	s0,32(sp)
    80001a5a:	ec26                	sd	s1,24(sp)
    80001a5c:	e84a                	sd	s2,16(sp)
    80001a5e:	e44e                	sd	s3,8(sp)
    80001a60:	1800                	addi	s0,sp,48
  struct proc *p;
  int count = 0;
    80001a62:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++)
    80001a64:	00008497          	auipc	s1,0x8
    80001a68:	a1c48493          	addi	s1,s1,-1508 # 80009480 <proc>
    80001a6c:	0000d997          	auipc	s3,0xd
    80001a70:	61498993          	addi	s3,s3,1556 # 8000f080 <tickslock>
    80001a74:	a811                	j	80001a88 <getnproc+0x34>
      count++;
      release(&p->lock);
    }
    else
    {
      release(&p->lock);
    80001a76:	8526                	mv	a0,s1
    80001a78:	00005097          	auipc	ra,0x5
    80001a7c:	81e080e7          	jalr	-2018(ra) # 80006296 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a80:	17048493          	addi	s1,s1,368
    80001a84:	03348063          	beq	s1,s3,80001aa4 <getnproc+0x50>
    acquire(&p->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	00004097          	auipc	ra,0x4
    80001a8e:	758080e7          	jalr	1880(ra) # 800061e2 <acquire>
    if (p->state != UNUSED)
    80001a92:	4c9c                	lw	a5,24(s1)
    80001a94:	d3ed                	beqz	a5,80001a76 <getnproc+0x22>
      count++;
    80001a96:	2905                	addiw	s2,s2,1
      release(&p->lock);
    80001a98:	8526                	mv	a0,s1
    80001a9a:	00004097          	auipc	ra,0x4
    80001a9e:	7fc080e7          	jalr	2044(ra) # 80006296 <release>
    80001aa2:	bff9                	j	80001a80 <getnproc+0x2c>
    }
  }
  return count;
}
    80001aa4:	854a                	mv	a0,s2
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6145                	addi	sp,sp,48
    80001ab2:	8082                	ret

0000000080001ab4 <swtch>:
    80001ab4:	00153023          	sd	ra,0(a0)
    80001ab8:	00253423          	sd	sp,8(a0)
    80001abc:	e900                	sd	s0,16(a0)
    80001abe:	ed04                	sd	s1,24(a0)
    80001ac0:	03253023          	sd	s2,32(a0)
    80001ac4:	03353423          	sd	s3,40(a0)
    80001ac8:	03453823          	sd	s4,48(a0)
    80001acc:	03553c23          	sd	s5,56(a0)
    80001ad0:	05653023          	sd	s6,64(a0)
    80001ad4:	05753423          	sd	s7,72(a0)
    80001ad8:	05853823          	sd	s8,80(a0)
    80001adc:	05953c23          	sd	s9,88(a0)
    80001ae0:	07a53023          	sd	s10,96(a0)
    80001ae4:	07b53423          	sd	s11,104(a0)
    80001ae8:	0005b083          	ld	ra,0(a1)
    80001aec:	0085b103          	ld	sp,8(a1)
    80001af0:	6980                	ld	s0,16(a1)
    80001af2:	6d84                	ld	s1,24(a1)
    80001af4:	0205b903          	ld	s2,32(a1)
    80001af8:	0285b983          	ld	s3,40(a1)
    80001afc:	0305ba03          	ld	s4,48(a1)
    80001b00:	0385ba83          	ld	s5,56(a1)
    80001b04:	0405bb03          	ld	s6,64(a1)
    80001b08:	0485bb83          	ld	s7,72(a1)
    80001b0c:	0505bc03          	ld	s8,80(a1)
    80001b10:	0585bc83          	ld	s9,88(a1)
    80001b14:	0605bd03          	ld	s10,96(a1)
    80001b18:	0685bd83          	ld	s11,104(a1)
    80001b1c:	8082                	ret

0000000080001b1e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b1e:	1141                	addi	sp,sp,-16
    80001b20:	e406                	sd	ra,8(sp)
    80001b22:	e022                	sd	s0,0(sp)
    80001b24:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b26:	00006597          	auipc	a1,0x6
    80001b2a:	74a58593          	addi	a1,a1,1866 # 80008270 <states.1714+0x30>
    80001b2e:	0000d517          	auipc	a0,0xd
    80001b32:	55250513          	addi	a0,a0,1362 # 8000f080 <tickslock>
    80001b36:	00004097          	auipc	ra,0x4
    80001b3a:	61c080e7          	jalr	1564(ra) # 80006152 <initlock>
}
    80001b3e:	60a2                	ld	ra,8(sp)
    80001b40:	6402                	ld	s0,0(sp)
    80001b42:	0141                	addi	sp,sp,16
    80001b44:	8082                	ret

0000000080001b46 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b46:	1141                	addi	sp,sp,-16
    80001b48:	e422                	sd	s0,8(sp)
    80001b4a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4c:	00003797          	auipc	a5,0x3
    80001b50:	55478793          	addi	a5,a5,1364 # 800050a0 <kernelvec>
    80001b54:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b58:	6422                	ld	s0,8(sp)
    80001b5a:	0141                	addi	sp,sp,16
    80001b5c:	8082                	ret

0000000080001b5e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b5e:	1141                	addi	sp,sp,-16
    80001b60:	e406                	sd	ra,8(sp)
    80001b62:	e022                	sd	s0,0(sp)
    80001b64:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b66:	fffff097          	auipc	ra,0xfffff
    80001b6a:	32c080e7          	jalr	812(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b72:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b74:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b78:	00005617          	auipc	a2,0x5
    80001b7c:	48860613          	addi	a2,a2,1160 # 80007000 <_trampoline>
    80001b80:	00005697          	auipc	a3,0x5
    80001b84:	48068693          	addi	a3,a3,1152 # 80007000 <_trampoline>
    80001b88:	8e91                	sub	a3,a3,a2
    80001b8a:	040007b7          	lui	a5,0x4000
    80001b8e:	17fd                	addi	a5,a5,-1
    80001b90:	07b2                	slli	a5,a5,0xc
    80001b92:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b94:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b98:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9a:	180026f3          	csrr	a3,satp
    80001b9e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba0:	6d38                	ld	a4,88(a0)
    80001ba2:	6134                	ld	a3,64(a0)
    80001ba4:	6585                	lui	a1,0x1
    80001ba6:	96ae                	add	a3,a3,a1
    80001ba8:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001baa:	6d38                	ld	a4,88(a0)
    80001bac:	00000697          	auipc	a3,0x0
    80001bb0:	13868693          	addi	a3,a3,312 # 80001ce4 <usertrap>
    80001bb4:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb8:	8692                	mv	a3,tp
    80001bba:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bbc:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc0:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc4:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc8:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bcc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bce:	6f18                	ld	a4,24(a4)
    80001bd0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd4:	692c                	ld	a1,80(a0)
    80001bd6:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bd8:	00005717          	auipc	a4,0x5
    80001bdc:	4b870713          	addi	a4,a4,1208 # 80007090 <userret>
    80001be0:	8f11                	sub	a4,a4,a2
    80001be2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001be4:	577d                	li	a4,-1
    80001be6:	177e                	slli	a4,a4,0x3f
    80001be8:	8dd9                	or	a1,a1,a4
    80001bea:	02000537          	lui	a0,0x2000
    80001bee:	157d                	addi	a0,a0,-1
    80001bf0:	0536                	slli	a0,a0,0xd
    80001bf2:	9782                	jalr	a5
}
    80001bf4:	60a2                	ld	ra,8(sp)
    80001bf6:	6402                	ld	s0,0(sp)
    80001bf8:	0141                	addi	sp,sp,16
    80001bfa:	8082                	ret

0000000080001bfc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c06:	0000d497          	auipc	s1,0xd
    80001c0a:	47a48493          	addi	s1,s1,1146 # 8000f080 <tickslock>
    80001c0e:	8526                	mv	a0,s1
    80001c10:	00004097          	auipc	ra,0x4
    80001c14:	5d2080e7          	jalr	1490(ra) # 800061e2 <acquire>
  ticks++;
    80001c18:	00007517          	auipc	a0,0x7
    80001c1c:	40050513          	addi	a0,a0,1024 # 80009018 <ticks>
    80001c20:	411c                	lw	a5,0(a0)
    80001c22:	2785                	addiw	a5,a5,1
    80001c24:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c26:	00000097          	auipc	ra,0x0
    80001c2a:	abc080e7          	jalr	-1348(ra) # 800016e2 <wakeup>
  release(&tickslock);
    80001c2e:	8526                	mv	a0,s1
    80001c30:	00004097          	auipc	ra,0x4
    80001c34:	666080e7          	jalr	1638(ra) # 80006296 <release>
}
    80001c38:	60e2                	ld	ra,24(sp)
    80001c3a:	6442                	ld	s0,16(sp)
    80001c3c:	64a2                	ld	s1,8(sp)
    80001c3e:	6105                	addi	sp,sp,32
    80001c40:	8082                	ret

0000000080001c42 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c42:	1101                	addi	sp,sp,-32
    80001c44:	ec06                	sd	ra,24(sp)
    80001c46:	e822                	sd	s0,16(sp)
    80001c48:	e426                	sd	s1,8(sp)
    80001c4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c50:	00074d63          	bltz	a4,80001c6a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c54:	57fd                	li	a5,-1
    80001c56:	17fe                	slli	a5,a5,0x3f
    80001c58:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c5a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5c:	06f70363          	beq	a4,a5,80001cc2 <devintr+0x80>
  }
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret
     (scause & 0xff) == 9){
    80001c6a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c6e:	46a5                	li	a3,9
    80001c70:	fed792e3          	bne	a5,a3,80001c54 <devintr+0x12>
    int irq = plic_claim();
    80001c74:	00003097          	auipc	ra,0x3
    80001c78:	534080e7          	jalr	1332(ra) # 800051a8 <plic_claim>
    80001c7c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7e:	47a9                	li	a5,10
    80001c80:	02f50763          	beq	a0,a5,80001cae <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c84:	4785                	li	a5,1
    80001c86:	02f50963          	beq	a0,a5,80001cb8 <devintr+0x76>
    return 1;
    80001c8a:	4505                	li	a0,1
    } else if(irq){
    80001c8c:	d8f1                	beqz	s1,80001c60 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8e:	85a6                	mv	a1,s1
    80001c90:	00006517          	auipc	a0,0x6
    80001c94:	5e850513          	addi	a0,a0,1512 # 80008278 <states.1714+0x38>
    80001c98:	00004097          	auipc	ra,0x4
    80001c9c:	04a080e7          	jalr	74(ra) # 80005ce2 <printf>
      plic_complete(irq);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00003097          	auipc	ra,0x3
    80001ca6:	52a080e7          	jalr	1322(ra) # 800051cc <plic_complete>
    return 1;
    80001caa:	4505                	li	a0,1
    80001cac:	bf55                	j	80001c60 <devintr+0x1e>
      uartintr();
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	454080e7          	jalr	1108(ra) # 80006102 <uartintr>
    80001cb6:	b7ed                	j	80001ca0 <devintr+0x5e>
      virtio_disk_intr();
    80001cb8:	00004097          	auipc	ra,0x4
    80001cbc:	9f4080e7          	jalr	-1548(ra) # 800056ac <virtio_disk_intr>
    80001cc0:	b7c5                	j	80001ca0 <devintr+0x5e>
    if(cpuid() == 0){
    80001cc2:	fffff097          	auipc	ra,0xfffff
    80001cc6:	1a4080e7          	jalr	420(ra) # 80000e66 <cpuid>
    80001cca:	c901                	beqz	a0,80001cda <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ccc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd2:	14479073          	csrw	sip,a5
    return 2;
    80001cd6:	4509                	li	a0,2
    80001cd8:	b761                	j	80001c60 <devintr+0x1e>
      clockintr();
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	f22080e7          	jalr	-222(ra) # 80001bfc <clockintr>
    80001ce2:	b7ed                	j	80001ccc <devintr+0x8a>

0000000080001ce4 <usertrap>:
{
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	e426                	sd	s1,8(sp)
    80001cec:	e04a                	sd	s2,0(sp)
    80001cee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf4:	1007f793          	andi	a5,a5,256
    80001cf8:	e3ad                	bnez	a5,80001d5a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfa:	00003797          	auipc	a5,0x3
    80001cfe:	3a678793          	addi	a5,a5,934 # 800050a0 <kernelvec>
    80001d02:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d06:	fffff097          	auipc	ra,0xfffff
    80001d0a:	18c080e7          	jalr	396(ra) # 80000e92 <myproc>
    80001d0e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d10:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d12:	14102773          	csrr	a4,sepc
    80001d16:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d18:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1c:	47a1                	li	a5,8
    80001d1e:	04f71c63          	bne	a4,a5,80001d76 <usertrap+0x92>
    if(p->killed)
    80001d22:	551c                	lw	a5,40(a0)
    80001d24:	e3b9                	bnez	a5,80001d6a <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d26:	6cb8                	ld	a4,88(s1)
    80001d28:	6f1c                	ld	a5,24(a4)
    80001d2a:	0791                	addi	a5,a5,4
    80001d2c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d32:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d36:	10079073          	csrw	sstatus,a5
    syscall();
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	2e0080e7          	jalr	736(ra) # 8000201a <syscall>
  if(p->killed)
    80001d42:	549c                	lw	a5,40(s1)
    80001d44:	ebc1                	bnez	a5,80001dd4 <usertrap+0xf0>
  usertrapret();
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	e18080e7          	jalr	-488(ra) # 80001b5e <usertrapret>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	64a2                	ld	s1,8(sp)
    80001d54:	6902                	ld	s2,0(sp)
    80001d56:	6105                	addi	sp,sp,32
    80001d58:	8082                	ret
    panic("usertrap: not from user mode");
    80001d5a:	00006517          	auipc	a0,0x6
    80001d5e:	53e50513          	addi	a0,a0,1342 # 80008298 <states.1714+0x58>
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	f36080e7          	jalr	-202(ra) # 80005c98 <panic>
      exit(-1);
    80001d6a:	557d                	li	a0,-1
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	a46080e7          	jalr	-1466(ra) # 800017b2 <exit>
    80001d74:	bf4d                	j	80001d26 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	ecc080e7          	jalr	-308(ra) # 80001c42 <devintr>
    80001d7e:	892a                	mv	s2,a0
    80001d80:	c501                	beqz	a0,80001d88 <usertrap+0xa4>
  if(p->killed)
    80001d82:	549c                	lw	a5,40(s1)
    80001d84:	c3a1                	beqz	a5,80001dc4 <usertrap+0xe0>
    80001d86:	a815                	j	80001dba <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d88:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d8c:	5890                	lw	a2,48(s1)
    80001d8e:	00006517          	auipc	a0,0x6
    80001d92:	52a50513          	addi	a0,a0,1322 # 800082b8 <states.1714+0x78>
    80001d96:	00004097          	auipc	ra,0x4
    80001d9a:	f4c080e7          	jalr	-180(ra) # 80005ce2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d9e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001da6:	00006517          	auipc	a0,0x6
    80001daa:	54250513          	addi	a0,a0,1346 # 800082e8 <states.1714+0xa8>
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	f34080e7          	jalr	-204(ra) # 80005ce2 <printf>
    p->killed = 1;
    80001db6:	4785                	li	a5,1
    80001db8:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dba:	557d                	li	a0,-1
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	9f6080e7          	jalr	-1546(ra) # 800017b2 <exit>
  if(which_dev == 2)
    80001dc4:	4789                	li	a5,2
    80001dc6:	f8f910e3          	bne	s2,a5,80001d46 <usertrap+0x62>
    yield();
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	750080e7          	jalr	1872(ra) # 8000151a <yield>
    80001dd2:	bf95                	j	80001d46 <usertrap+0x62>
  int which_dev = 0;
    80001dd4:	4901                	li	s2,0
    80001dd6:	b7d5                	j	80001dba <usertrap+0xd6>

0000000080001dd8 <kerneltrap>:
{
    80001dd8:	7179                	addi	sp,sp,-48
    80001dda:	f406                	sd	ra,40(sp)
    80001ddc:	f022                	sd	s0,32(sp)
    80001dde:	ec26                	sd	s1,24(sp)
    80001de0:	e84a                	sd	s2,16(sp)
    80001de2:	e44e                	sd	s3,8(sp)
    80001de4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dea:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dee:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001df2:	1004f793          	andi	a5,s1,256
    80001df6:	cb85                	beqz	a5,80001e26 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dfc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dfe:	ef85                	bnez	a5,80001e36 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	e42080e7          	jalr	-446(ra) # 80001c42 <devintr>
    80001e08:	cd1d                	beqz	a0,80001e46 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e0a:	4789                	li	a5,2
    80001e0c:	06f50a63          	beq	a0,a5,80001e80 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e10:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e14:	10049073          	csrw	sstatus,s1
}
    80001e18:	70a2                	ld	ra,40(sp)
    80001e1a:	7402                	ld	s0,32(sp)
    80001e1c:	64e2                	ld	s1,24(sp)
    80001e1e:	6942                	ld	s2,16(sp)
    80001e20:	69a2                	ld	s3,8(sp)
    80001e22:	6145                	addi	sp,sp,48
    80001e24:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e26:	00006517          	auipc	a0,0x6
    80001e2a:	4e250513          	addi	a0,a0,1250 # 80008308 <states.1714+0xc8>
    80001e2e:	00004097          	auipc	ra,0x4
    80001e32:	e6a080e7          	jalr	-406(ra) # 80005c98 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e36:	00006517          	auipc	a0,0x6
    80001e3a:	4fa50513          	addi	a0,a0,1274 # 80008330 <states.1714+0xf0>
    80001e3e:	00004097          	auipc	ra,0x4
    80001e42:	e5a080e7          	jalr	-422(ra) # 80005c98 <panic>
    printf("scause %p\n", scause);
    80001e46:	85ce                	mv	a1,s3
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	50850513          	addi	a0,a0,1288 # 80008350 <states.1714+0x110>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	e92080e7          	jalr	-366(ra) # 80005ce2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e58:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e5c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	50050513          	addi	a0,a0,1280 # 80008360 <states.1714+0x120>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	e7a080e7          	jalr	-390(ra) # 80005ce2 <printf>
    panic("kerneltrap");
    80001e70:	00006517          	auipc	a0,0x6
    80001e74:	50850513          	addi	a0,a0,1288 # 80008378 <states.1714+0x138>
    80001e78:	00004097          	auipc	ra,0x4
    80001e7c:	e20080e7          	jalr	-480(ra) # 80005c98 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	012080e7          	jalr	18(ra) # 80000e92 <myproc>
    80001e88:	d541                	beqz	a0,80001e10 <kerneltrap+0x38>
    80001e8a:	fffff097          	auipc	ra,0xfffff
    80001e8e:	008080e7          	jalr	8(ra) # 80000e92 <myproc>
    80001e92:	4d18                	lw	a4,24(a0)
    80001e94:	4791                	li	a5,4
    80001e96:	f6f71de3          	bne	a4,a5,80001e10 <kerneltrap+0x38>
    yield();
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	680080e7          	jalr	1664(ra) # 8000151a <yield>
    80001ea2:	b7bd                	j	80001e10 <kerneltrap+0x38>

0000000080001ea4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ea4:	1101                	addi	sp,sp,-32
    80001ea6:	ec06                	sd	ra,24(sp)
    80001ea8:	e822                	sd	s0,16(sp)
    80001eaa:	e426                	sd	s1,8(sp)
    80001eac:	1000                	addi	s0,sp,32
    80001eae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	fe2080e7          	jalr	-30(ra) # 80000e92 <myproc>
  switch (n) {
    80001eb8:	4795                	li	a5,5
    80001eba:	0497e163          	bltu	a5,s1,80001efc <argraw+0x58>
    80001ebe:	048a                	slli	s1,s1,0x2
    80001ec0:	00006717          	auipc	a4,0x6
    80001ec4:	5c070713          	addi	a4,a4,1472 # 80008480 <states.1714+0x240>
    80001ec8:	94ba                	add	s1,s1,a4
    80001eca:	409c                	lw	a5,0(s1)
    80001ecc:	97ba                	add	a5,a5,a4
    80001ece:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ed0:	6d3c                	ld	a5,88(a0)
    80001ed2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ed4:	60e2                	ld	ra,24(sp)
    80001ed6:	6442                	ld	s0,16(sp)
    80001ed8:	64a2                	ld	s1,8(sp)
    80001eda:	6105                	addi	sp,sp,32
    80001edc:	8082                	ret
    return p->trapframe->a1;
    80001ede:	6d3c                	ld	a5,88(a0)
    80001ee0:	7fa8                	ld	a0,120(a5)
    80001ee2:	bfcd                	j	80001ed4 <argraw+0x30>
    return p->trapframe->a2;
    80001ee4:	6d3c                	ld	a5,88(a0)
    80001ee6:	63c8                	ld	a0,128(a5)
    80001ee8:	b7f5                	j	80001ed4 <argraw+0x30>
    return p->trapframe->a3;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	67c8                	ld	a0,136(a5)
    80001eee:	b7dd                	j	80001ed4 <argraw+0x30>
    return p->trapframe->a4;
    80001ef0:	6d3c                	ld	a5,88(a0)
    80001ef2:	6bc8                	ld	a0,144(a5)
    80001ef4:	b7c5                	j	80001ed4 <argraw+0x30>
    return p->trapframe->a5;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	6fc8                	ld	a0,152(a5)
    80001efa:	bfe9                	j	80001ed4 <argraw+0x30>
  panic("argraw");
    80001efc:	00006517          	auipc	a0,0x6
    80001f00:	48c50513          	addi	a0,a0,1164 # 80008388 <states.1714+0x148>
    80001f04:	00004097          	auipc	ra,0x4
    80001f08:	d94080e7          	jalr	-620(ra) # 80005c98 <panic>

0000000080001f0c <fetchaddr>:
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	e04a                	sd	s2,0(sp)
    80001f16:	1000                	addi	s0,sp,32
    80001f18:	84aa                	mv	s1,a0
    80001f1a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	f76080e7          	jalr	-138(ra) # 80000e92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f24:	653c                	ld	a5,72(a0)
    80001f26:	02f4f863          	bgeu	s1,a5,80001f56 <fetchaddr+0x4a>
    80001f2a:	00848713          	addi	a4,s1,8
    80001f2e:	02e7e663          	bltu	a5,a4,80001f5a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f32:	46a1                	li	a3,8
    80001f34:	8626                	mv	a2,s1
    80001f36:	85ca                	mv	a1,s2
    80001f38:	6928                	ld	a0,80(a0)
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	ca6080e7          	jalr	-858(ra) # 80000be0 <copyin>
    80001f42:	00a03533          	snez	a0,a0
    80001f46:	40a00533          	neg	a0,a0
}
    80001f4a:	60e2                	ld	ra,24(sp)
    80001f4c:	6442                	ld	s0,16(sp)
    80001f4e:	64a2                	ld	s1,8(sp)
    80001f50:	6902                	ld	s2,0(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret
    return -1;
    80001f56:	557d                	li	a0,-1
    80001f58:	bfcd                	j	80001f4a <fetchaddr+0x3e>
    80001f5a:	557d                	li	a0,-1
    80001f5c:	b7fd                	j	80001f4a <fetchaddr+0x3e>

0000000080001f5e <fetchstr>:
{
    80001f5e:	7179                	addi	sp,sp,-48
    80001f60:	f406                	sd	ra,40(sp)
    80001f62:	f022                	sd	s0,32(sp)
    80001f64:	ec26                	sd	s1,24(sp)
    80001f66:	e84a                	sd	s2,16(sp)
    80001f68:	e44e                	sd	s3,8(sp)
    80001f6a:	1800                	addi	s0,sp,48
    80001f6c:	892a                	mv	s2,a0
    80001f6e:	84ae                	mv	s1,a1
    80001f70:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	f20080e7          	jalr	-224(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f7a:	86ce                	mv	a3,s3
    80001f7c:	864a                	mv	a2,s2
    80001f7e:	85a6                	mv	a1,s1
    80001f80:	6928                	ld	a0,80(a0)
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	cea080e7          	jalr	-790(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f8a:	00054763          	bltz	a0,80001f98 <fetchstr+0x3a>
  return strlen(buf);
    80001f8e:	8526                	mv	a0,s1
    80001f90:	ffffe097          	auipc	ra,0xffffe
    80001f94:	3b6080e7          	jalr	950(ra) # 80000346 <strlen>
}
    80001f98:	70a2                	ld	ra,40(sp)
    80001f9a:	7402                	ld	s0,32(sp)
    80001f9c:	64e2                	ld	s1,24(sp)
    80001f9e:	6942                	ld	s2,16(sp)
    80001fa0:	69a2                	ld	s3,8(sp)
    80001fa2:	6145                	addi	sp,sp,48
    80001fa4:	8082                	ret

0000000080001fa6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa6:	1101                	addi	sp,sp,-32
    80001fa8:	ec06                	sd	ra,24(sp)
    80001faa:	e822                	sd	s0,16(sp)
    80001fac:	e426                	sd	s1,8(sp)
    80001fae:	1000                	addi	s0,sp,32
    80001fb0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	ef2080e7          	jalr	-270(ra) # 80001ea4 <argraw>
    80001fba:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fbc:	4501                	li	a0,0
    80001fbe:	60e2                	ld	ra,24(sp)
    80001fc0:	6442                	ld	s0,16(sp)
    80001fc2:	64a2                	ld	s1,8(sp)
    80001fc4:	6105                	addi	sp,sp,32
    80001fc6:	8082                	ret

0000000080001fc8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	ed0080e7          	jalr	-304(ra) # 80001ea4 <argraw>
    80001fdc:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fde:	4501                	li	a0,0
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret

0000000080001fea <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fea:	1101                	addi	sp,sp,-32
    80001fec:	ec06                	sd	ra,24(sp)
    80001fee:	e822                	sd	s0,16(sp)
    80001ff0:	e426                	sd	s1,8(sp)
    80001ff2:	e04a                	sd	s2,0(sp)
    80001ff4:	1000                	addi	s0,sp,32
    80001ff6:	84ae                	mv	s1,a1
    80001ff8:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	eaa080e7          	jalr	-342(ra) # 80001ea4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002002:	864a                	mv	a2,s2
    80002004:	85a6                	mv	a1,s1
    80002006:	00000097          	auipc	ra,0x0
    8000200a:	f58080e7          	jalr	-168(ra) # 80001f5e <fetchstr>
}
    8000200e:	60e2                	ld	ra,24(sp)
    80002010:	6442                	ld	s0,16(sp)
    80002012:	64a2                	ld	s1,8(sp)
    80002014:	6902                	ld	s2,0(sp)
    80002016:	6105                	addi	sp,sp,32
    80002018:	8082                	ret

000000008000201a <syscall>:
    "trace",
    "sys_sysinfo",
};

void syscall(void)
{
    8000201a:	7179                	addi	sp,sp,-48
    8000201c:	f406                	sd	ra,40(sp)
    8000201e:	f022                	sd	s0,32(sp)
    80002020:	ec26                	sd	s1,24(sp)
    80002022:	e84a                	sd	s2,16(sp)
    80002024:	e44e                	sd	s3,8(sp)
    80002026:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	e6a080e7          	jalr	-406(ra) # 80000e92 <myproc>
    80002030:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80002032:	05853903          	ld	s2,88(a0)
    80002036:	0a893783          	ld	a5,168(s2)
    8000203a:	0007899b          	sext.w	s3,a5
  // if (num == 22)
  //   printf("%d: called system call %d.\n", p->pid, num);
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000203e:	37fd                	addiw	a5,a5,-1
    80002040:	4759                	li	a4,22
    80002042:	04f76863          	bltu	a4,a5,80002092 <syscall+0x78>
    80002046:	00399713          	slli	a4,s3,0x3
    8000204a:	00006797          	auipc	a5,0x6
    8000204e:	44e78793          	addi	a5,a5,1102 # 80008498 <syscalls>
    80002052:	97ba                	add	a5,a5,a4
    80002054:	639c                	ld	a5,0(a5)
    80002056:	cf95                	beqz	a5,80002092 <syscall+0x78>
  {

    p->trapframe->a0 = syscalls[num]();
    80002058:	9782                	jalr	a5
    8000205a:	06a93823          	sd	a0,112(s2)

    if (p->tracemask >> num & 1)
    8000205e:	1684a783          	lw	a5,360(s1)
    80002062:	4137d7bb          	sraw	a5,a5,s3
    80002066:	8b85                	andi	a5,a5,1
    80002068:	c7a1                	beqz	a5,800020b0 <syscall+0x96>
    {
      printf("%d: syscall %s -> %d\n",
    8000206a:	6cb8                	ld	a4,88(s1)
    8000206c:	098e                	slli	s3,s3,0x3
    8000206e:	00007797          	auipc	a5,0x7
    80002072:	8ca78793          	addi	a5,a5,-1846 # 80008938 <syscallnames>
    80002076:	99be                	add	s3,s3,a5
    80002078:	7b34                	ld	a3,112(a4)
    8000207a:	0009b603          	ld	a2,0(s3)
    8000207e:	588c                	lw	a1,48(s1)
    80002080:	00006517          	auipc	a0,0x6
    80002084:	31050513          	addi	a0,a0,784 # 80008390 <states.1714+0x150>
    80002088:	00004097          	auipc	ra,0x4
    8000208c:	c5a080e7          	jalr	-934(ra) # 80005ce2 <printf>
    80002090:	a005                	j	800020b0 <syscall+0x96>
             p->pid, syscallnames[num], p->trapframe->a0);
    }
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    80002092:	86ce                	mv	a3,s3
    80002094:	15848613          	addi	a2,s1,344
    80002098:	588c                	lw	a1,48(s1)
    8000209a:	00006517          	auipc	a0,0x6
    8000209e:	30e50513          	addi	a0,a0,782 # 800083a8 <states.1714+0x168>
    800020a2:	00004097          	auipc	ra,0x4
    800020a6:	c40080e7          	jalr	-960(ra) # 80005ce2 <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020aa:	6cbc                	ld	a5,88(s1)
    800020ac:	577d                	li	a4,-1
    800020ae:	fbb8                	sd	a4,112(a5)
  }
}
    800020b0:	70a2                	ld	ra,40(sp)
    800020b2:	7402                	ld	s0,32(sp)
    800020b4:	64e2                	ld	s1,24(sp)
    800020b6:	6942                	ld	s2,16(sp)
    800020b8:	69a2                	ld	s3,8(sp)
    800020ba:	6145                	addi	sp,sp,48
    800020bc:	8082                	ret

00000000800020be <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020c6:	fec40593          	addi	a1,s0,-20
    800020ca:	4501                	li	a0,0
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	eda080e7          	jalr	-294(ra) # 80001fa6 <argint>
    return -1;
    800020d4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d6:	00054963          	bltz	a0,800020e8 <sys_exit+0x2a>
  exit(n);
    800020da:	fec42503          	lw	a0,-20(s0)
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	6d4080e7          	jalr	1748(ra) # 800017b2 <exit>
  return 0;  // not reached
    800020e6:	4781                	li	a5,0
}
    800020e8:	853e                	mv	a0,a5
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020f2:	1141                	addi	sp,sp,-16
    800020f4:	e406                	sd	ra,8(sp)
    800020f6:	e022                	sd	s0,0(sp)
    800020f8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	d98080e7          	jalr	-616(ra) # 80000e92 <myproc>
}
    80002102:	5908                	lw	a0,48(a0)
    80002104:	60a2                	ld	ra,8(sp)
    80002106:	6402                	ld	s0,0(sp)
    80002108:	0141                	addi	sp,sp,16
    8000210a:	8082                	ret

000000008000210c <sys_fork>:

uint64
sys_fork(void)
{
    8000210c:	1141                	addi	sp,sp,-16
    8000210e:	e406                	sd	ra,8(sp)
    80002110:	e022                	sd	s0,0(sp)
    80002112:	0800                	addi	s0,sp,16
  return fork();
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	14c080e7          	jalr	332(ra) # 80001260 <fork>
}
    8000211c:	60a2                	ld	ra,8(sp)
    8000211e:	6402                	ld	s0,0(sp)
    80002120:	0141                	addi	sp,sp,16
    80002122:	8082                	ret

0000000080002124 <sys_wait>:

uint64
sys_wait(void)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000212c:	fe840593          	addi	a1,s0,-24
    80002130:	4501                	li	a0,0
    80002132:	00000097          	auipc	ra,0x0
    80002136:	e96080e7          	jalr	-362(ra) # 80001fc8 <argaddr>
    8000213a:	87aa                	mv	a5,a0
    return -1;
    8000213c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000213e:	0007c863          	bltz	a5,8000214e <sys_wait+0x2a>
  return wait(p);
    80002142:	fe843503          	ld	a0,-24(s0)
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	474080e7          	jalr	1140(ra) # 800015ba <wait>
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret

0000000080002156 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002156:	7179                	addi	sp,sp,-48
    80002158:	f406                	sd	ra,40(sp)
    8000215a:	f022                	sd	s0,32(sp)
    8000215c:	ec26                	sd	s1,24(sp)
    8000215e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002160:	fdc40593          	addi	a1,s0,-36
    80002164:	4501                	li	a0,0
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	e40080e7          	jalr	-448(ra) # 80001fa6 <argint>
    8000216e:	87aa                	mv	a5,a0
    return -1;
    80002170:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002172:	0207c063          	bltz	a5,80002192 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	d1c080e7          	jalr	-740(ra) # 80000e92 <myproc>
    8000217e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002180:	fdc42503          	lw	a0,-36(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	068080e7          	jalr	104(ra) # 800011ec <growproc>
    8000218c:	00054863          	bltz	a0,8000219c <sys_sbrk+0x46>
    return -1;
  return addr;
    80002190:	8526                	mv	a0,s1
}
    80002192:	70a2                	ld	ra,40(sp)
    80002194:	7402                	ld	s0,32(sp)
    80002196:	64e2                	ld	s1,24(sp)
    80002198:	6145                	addi	sp,sp,48
    8000219a:	8082                	ret
    return -1;
    8000219c:	557d                	li	a0,-1
    8000219e:	bfd5                	j	80002192 <sys_sbrk+0x3c>

00000000800021a0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021a0:	7139                	addi	sp,sp,-64
    800021a2:	fc06                	sd	ra,56(sp)
    800021a4:	f822                	sd	s0,48(sp)
    800021a6:	f426                	sd	s1,40(sp)
    800021a8:	f04a                	sd	s2,32(sp)
    800021aa:	ec4e                	sd	s3,24(sp)
    800021ac:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021ae:	fcc40593          	addi	a1,s0,-52
    800021b2:	4501                	li	a0,0
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	df2080e7          	jalr	-526(ra) # 80001fa6 <argint>
    return -1;
    800021bc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021be:	06054563          	bltz	a0,80002228 <sys_sleep+0x88>
  acquire(&tickslock);
    800021c2:	0000d517          	auipc	a0,0xd
    800021c6:	ebe50513          	addi	a0,a0,-322 # 8000f080 <tickslock>
    800021ca:	00004097          	auipc	ra,0x4
    800021ce:	018080e7          	jalr	24(ra) # 800061e2 <acquire>
  ticks0 = ticks;
    800021d2:	00007917          	auipc	s2,0x7
    800021d6:	e4692903          	lw	s2,-442(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021da:	fcc42783          	lw	a5,-52(s0)
    800021de:	cf85                	beqz	a5,80002216 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e0:	0000d997          	auipc	s3,0xd
    800021e4:	ea098993          	addi	s3,s3,-352 # 8000f080 <tickslock>
    800021e8:	00007497          	auipc	s1,0x7
    800021ec:	e3048493          	addi	s1,s1,-464 # 80009018 <ticks>
    if(myproc()->killed){
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	ca2080e7          	jalr	-862(ra) # 80000e92 <myproc>
    800021f8:	551c                	lw	a5,40(a0)
    800021fa:	ef9d                	bnez	a5,80002238 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021fc:	85ce                	mv	a1,s3
    800021fe:	8526                	mv	a0,s1
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	356080e7          	jalr	854(ra) # 80001556 <sleep>
  while(ticks - ticks0 < n){
    80002208:	409c                	lw	a5,0(s1)
    8000220a:	412787bb          	subw	a5,a5,s2
    8000220e:	fcc42703          	lw	a4,-52(s0)
    80002212:	fce7efe3          	bltu	a5,a4,800021f0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002216:	0000d517          	auipc	a0,0xd
    8000221a:	e6a50513          	addi	a0,a0,-406 # 8000f080 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	078080e7          	jalr	120(ra) # 80006296 <release>
  return 0;
    80002226:	4781                	li	a5,0
}
    80002228:	853e                	mv	a0,a5
    8000222a:	70e2                	ld	ra,56(sp)
    8000222c:	7442                	ld	s0,48(sp)
    8000222e:	74a2                	ld	s1,40(sp)
    80002230:	7902                	ld	s2,32(sp)
    80002232:	69e2                	ld	s3,24(sp)
    80002234:	6121                	addi	sp,sp,64
    80002236:	8082                	ret
      release(&tickslock);
    80002238:	0000d517          	auipc	a0,0xd
    8000223c:	e4850513          	addi	a0,a0,-440 # 8000f080 <tickslock>
    80002240:	00004097          	auipc	ra,0x4
    80002244:	056080e7          	jalr	86(ra) # 80006296 <release>
      return -1;
    80002248:	57fd                	li	a5,-1
    8000224a:	bff9                	j	80002228 <sys_sleep+0x88>

000000008000224c <sys_kill>:

uint64
sys_kill(void)
{
    8000224c:	1101                	addi	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002254:	fec40593          	addi	a1,s0,-20
    80002258:	4501                	li	a0,0
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	d4c080e7          	jalr	-692(ra) # 80001fa6 <argint>
    80002262:	87aa                	mv	a5,a0
    return -1;
    80002264:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002266:	0007c863          	bltz	a5,80002276 <sys_kill+0x2a>
  return kill(pid);
    8000226a:	fec42503          	lw	a0,-20(s0)
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	61a080e7          	jalr	1562(ra) # 80001888 <kill>
}
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	6105                	addi	sp,sp,32
    8000227c:	8082                	ret

000000008000227e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227e:	1101                	addi	sp,sp,-32
    80002280:	ec06                	sd	ra,24(sp)
    80002282:	e822                	sd	s0,16(sp)
    80002284:	e426                	sd	s1,8(sp)
    80002286:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002288:	0000d517          	auipc	a0,0xd
    8000228c:	df850513          	addi	a0,a0,-520 # 8000f080 <tickslock>
    80002290:	00004097          	auipc	ra,0x4
    80002294:	f52080e7          	jalr	-174(ra) # 800061e2 <acquire>
  xticks = ticks;
    80002298:	00007497          	auipc	s1,0x7
    8000229c:	d804a483          	lw	s1,-640(s1) # 80009018 <ticks>
  release(&tickslock);
    800022a0:	0000d517          	auipc	a0,0xd
    800022a4:	de050513          	addi	a0,a0,-544 # 8000f080 <tickslock>
    800022a8:	00004097          	auipc	ra,0x4
    800022ac:	fee080e7          	jalr	-18(ra) # 80006296 <release>
  return xticks;
}
    800022b0:	02049513          	slli	a0,s1,0x20
    800022b4:	9101                	srli	a0,a0,0x20
    800022b6:	60e2                	ld	ra,24(sp)
    800022b8:	6442                	ld	s0,16(sp)
    800022ba:	64a2                	ld	s1,8(sp)
    800022bc:	6105                	addi	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <sys_trace>:

uint64
sys_trace(void)
{
    800022c0:	1101                	addi	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	1000                	addi	s0,sp,32
int mask;
argint(0, &mask);
    800022c8:	fec40593          	addi	a1,s0,-20
    800022cc:	4501                	li	a0,0
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	cd8080e7          	jalr	-808(ra) # 80001fa6 <argint>
myproc()->tracemask = mask;
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	bbc080e7          	jalr	-1092(ra) # 80000e92 <myproc>
    800022de:	fec42783          	lw	a5,-20(s0)
    800022e2:	16f52423          	sw	a5,360(a0)
return 0;
}
    800022e6:	4501                	li	a0,0
    800022e8:	60e2                	ld	ra,24(sp)
    800022ea:	6442                	ld	s0,16(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <sys_sysinfo>:

extern int getnproc(void);
extern int getfreemem(void);
uint64
sys_sysinfo(void)
{
    800022f0:	7139                	addi	sp,sp,-64
    800022f2:	fc06                	sd	ra,56(sp)
    800022f4:	f822                	sd	s0,48(sp)
    800022f6:	f426                	sd	s1,40(sp)
    800022f8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	b98080e7          	jalr	-1128(ra) # 80000e92 <myproc>
    80002302:	84aa                	mv	s1,a0
  struct sysinfo st;
  uint64 addr; // user pointer to struct stat
  st.freemem = getfreemem();
    80002304:	ffffe097          	auipc	ra,0xffffe
    80002308:	e74080e7          	jalr	-396(ra) # 80000178 <getfreemem>
    8000230c:	fca43823          	sd	a0,-48(s0)
  st.nproc = getnproc();
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	744080e7          	jalr	1860(ra) # 80001a54 <getnproc>
    80002318:	fca43c23          	sd	a0,-40(s0)
  if (argaddr(0, &addr) < 0)
    8000231c:	fc840593          	addi	a1,s0,-56
    80002320:	4501                	li	a0,0
    80002322:	00000097          	auipc	ra,0x0
    80002326:	ca6080e7          	jalr	-858(ra) # 80001fc8 <argaddr>
    return -1;
    8000232a:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0)
    8000232c:	00054e63          	bltz	a0,80002348 <sys_sysinfo+0x58>
  if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80002330:	46c1                	li	a3,16
    80002332:	fd040613          	addi	a2,s0,-48
    80002336:	fc843583          	ld	a1,-56(s0)
    8000233a:	68a8                	ld	a0,80(s1)
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	818080e7          	jalr	-2024(ra) # 80000b54 <copyout>
    80002344:	43f55793          	srai	a5,a0,0x3f
    return -1;
  return 0;
}
    80002348:	853e                	mv	a0,a5
    8000234a:	70e2                	ld	ra,56(sp)
    8000234c:	7442                	ld	s0,48(sp)
    8000234e:	74a2                	ld	s1,40(sp)
    80002350:	6121                	addi	sp,sp,64
    80002352:	8082                	ret

0000000080002354 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002354:	7179                	addi	sp,sp,-48
    80002356:	f406                	sd	ra,40(sp)
    80002358:	f022                	sd	s0,32(sp)
    8000235a:	ec26                	sd	s1,24(sp)
    8000235c:	e84a                	sd	s2,16(sp)
    8000235e:	e44e                	sd	s3,8(sp)
    80002360:	e052                	sd	s4,0(sp)
    80002362:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002364:	00006597          	auipc	a1,0x6
    80002368:	1f458593          	addi	a1,a1,500 # 80008558 <syscalls+0xc0>
    8000236c:	0000d517          	auipc	a0,0xd
    80002370:	d2c50513          	addi	a0,a0,-724 # 8000f098 <bcache>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	dde080e7          	jalr	-546(ra) # 80006152 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237c:	00015797          	auipc	a5,0x15
    80002380:	d1c78793          	addi	a5,a5,-740 # 80017098 <bcache+0x8000>
    80002384:	00015717          	auipc	a4,0x15
    80002388:	f7c70713          	addi	a4,a4,-132 # 80017300 <bcache+0x8268>
    8000238c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002390:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002394:	0000d497          	auipc	s1,0xd
    80002398:	d1c48493          	addi	s1,s1,-740 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000239c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a0:	00006a17          	auipc	s4,0x6
    800023a4:	1c0a0a13          	addi	s4,s4,448 # 80008560 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023a8:	2b893783          	ld	a5,696(s2)
    800023ac:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ae:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b2:	85d2                	mv	a1,s4
    800023b4:	01048513          	addi	a0,s1,16
    800023b8:	00001097          	auipc	ra,0x1
    800023bc:	4bc080e7          	jalr	1212(ra) # 80003874 <initsleeplock>
    bcache.head.next->prev = b;
    800023c0:	2b893783          	ld	a5,696(s2)
    800023c4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ca:	45848493          	addi	s1,s1,1112
    800023ce:	fd349de3          	bne	s1,s3,800023a8 <binit+0x54>
  }
}
    800023d2:	70a2                	ld	ra,40(sp)
    800023d4:	7402                	ld	s0,32(sp)
    800023d6:	64e2                	ld	s1,24(sp)
    800023d8:	6942                	ld	s2,16(sp)
    800023da:	69a2                	ld	s3,8(sp)
    800023dc:	6a02                	ld	s4,0(sp)
    800023de:	6145                	addi	sp,sp,48
    800023e0:	8082                	ret

00000000800023e2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e2:	7179                	addi	sp,sp,-48
    800023e4:	f406                	sd	ra,40(sp)
    800023e6:	f022                	sd	s0,32(sp)
    800023e8:	ec26                	sd	s1,24(sp)
    800023ea:	e84a                	sd	s2,16(sp)
    800023ec:	e44e                	sd	s3,8(sp)
    800023ee:	1800                	addi	s0,sp,48
    800023f0:	89aa                	mv	s3,a0
    800023f2:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023f4:	0000d517          	auipc	a0,0xd
    800023f8:	ca450513          	addi	a0,a0,-860 # 8000f098 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	de6080e7          	jalr	-538(ra) # 800061e2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002404:	00015497          	auipc	s1,0x15
    80002408:	f4c4b483          	ld	s1,-180(s1) # 80017350 <bcache+0x82b8>
    8000240c:	00015797          	auipc	a5,0x15
    80002410:	ef478793          	addi	a5,a5,-268 # 80017300 <bcache+0x8268>
    80002414:	02f48f63          	beq	s1,a5,80002452 <bread+0x70>
    80002418:	873e                	mv	a4,a5
    8000241a:	a021                	j	80002422 <bread+0x40>
    8000241c:	68a4                	ld	s1,80(s1)
    8000241e:	02e48a63          	beq	s1,a4,80002452 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002422:	449c                	lw	a5,8(s1)
    80002424:	ff379ce3          	bne	a5,s3,8000241c <bread+0x3a>
    80002428:	44dc                	lw	a5,12(s1)
    8000242a:	ff2799e3          	bne	a5,s2,8000241c <bread+0x3a>
      b->refcnt++;
    8000242e:	40bc                	lw	a5,64(s1)
    80002430:	2785                	addiw	a5,a5,1
    80002432:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002434:	0000d517          	auipc	a0,0xd
    80002438:	c6450513          	addi	a0,a0,-924 # 8000f098 <bcache>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	e5a080e7          	jalr	-422(ra) # 80006296 <release>
      acquiresleep(&b->lock);
    80002444:	01048513          	addi	a0,s1,16
    80002448:	00001097          	auipc	ra,0x1
    8000244c:	466080e7          	jalr	1126(ra) # 800038ae <acquiresleep>
      return b;
    80002450:	a8b9                	j	800024ae <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002452:	00015497          	auipc	s1,0x15
    80002456:	ef64b483          	ld	s1,-266(s1) # 80017348 <bcache+0x82b0>
    8000245a:	00015797          	auipc	a5,0x15
    8000245e:	ea678793          	addi	a5,a5,-346 # 80017300 <bcache+0x8268>
    80002462:	00f48863          	beq	s1,a5,80002472 <bread+0x90>
    80002466:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002468:	40bc                	lw	a5,64(s1)
    8000246a:	cf81                	beqz	a5,80002482 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246c:	64a4                	ld	s1,72(s1)
    8000246e:	fee49de3          	bne	s1,a4,80002468 <bread+0x86>
  panic("bget: no buffers");
    80002472:	00006517          	auipc	a0,0x6
    80002476:	0f650513          	addi	a0,a0,246 # 80008568 <syscalls+0xd0>
    8000247a:	00004097          	auipc	ra,0x4
    8000247e:	81e080e7          	jalr	-2018(ra) # 80005c98 <panic>
      b->dev = dev;
    80002482:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002486:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000248a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248e:	4785                	li	a5,1
    80002490:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002492:	0000d517          	auipc	a0,0xd
    80002496:	c0650513          	addi	a0,a0,-1018 # 8000f098 <bcache>
    8000249a:	00004097          	auipc	ra,0x4
    8000249e:	dfc080e7          	jalr	-516(ra) # 80006296 <release>
      acquiresleep(&b->lock);
    800024a2:	01048513          	addi	a0,s1,16
    800024a6:	00001097          	auipc	ra,0x1
    800024aa:	408080e7          	jalr	1032(ra) # 800038ae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ae:	409c                	lw	a5,0(s1)
    800024b0:	cb89                	beqz	a5,800024c2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b2:	8526                	mv	a0,s1
    800024b4:	70a2                	ld	ra,40(sp)
    800024b6:	7402                	ld	s0,32(sp)
    800024b8:	64e2                	ld	s1,24(sp)
    800024ba:	6942                	ld	s2,16(sp)
    800024bc:	69a2                	ld	s3,8(sp)
    800024be:	6145                	addi	sp,sp,48
    800024c0:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c2:	4581                	li	a1,0
    800024c4:	8526                	mv	a0,s1
    800024c6:	00003097          	auipc	ra,0x3
    800024ca:	f10080e7          	jalr	-240(ra) # 800053d6 <virtio_disk_rw>
    b->valid = 1;
    800024ce:	4785                	li	a5,1
    800024d0:	c09c                	sw	a5,0(s1)
  return b;
    800024d2:	b7c5                	j	800024b2 <bread+0xd0>

00000000800024d4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d4:	1101                	addi	sp,sp,-32
    800024d6:	ec06                	sd	ra,24(sp)
    800024d8:	e822                	sd	s0,16(sp)
    800024da:	e426                	sd	s1,8(sp)
    800024dc:	1000                	addi	s0,sp,32
    800024de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e0:	0541                	addi	a0,a0,16
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	466080e7          	jalr	1126(ra) # 80003948 <holdingsleep>
    800024ea:	cd01                	beqz	a0,80002502 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ec:	4585                	li	a1,1
    800024ee:	8526                	mv	a0,s1
    800024f0:	00003097          	auipc	ra,0x3
    800024f4:	ee6080e7          	jalr	-282(ra) # 800053d6 <virtio_disk_rw>
}
    800024f8:	60e2                	ld	ra,24(sp)
    800024fa:	6442                	ld	s0,16(sp)
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret
    panic("bwrite");
    80002502:	00006517          	auipc	a0,0x6
    80002506:	07e50513          	addi	a0,a0,126 # 80008580 <syscalls+0xe8>
    8000250a:	00003097          	auipc	ra,0x3
    8000250e:	78e080e7          	jalr	1934(ra) # 80005c98 <panic>

0000000080002512 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002512:	1101                	addi	sp,sp,-32
    80002514:	ec06                	sd	ra,24(sp)
    80002516:	e822                	sd	s0,16(sp)
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	e04a                	sd	s2,0(sp)
    8000251c:	1000                	addi	s0,sp,32
    8000251e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002520:	01050913          	addi	s2,a0,16
    80002524:	854a                	mv	a0,s2
    80002526:	00001097          	auipc	ra,0x1
    8000252a:	422080e7          	jalr	1058(ra) # 80003948 <holdingsleep>
    8000252e:	c92d                	beqz	a0,800025a0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002530:	854a                	mv	a0,s2
    80002532:	00001097          	auipc	ra,0x1
    80002536:	3d2080e7          	jalr	978(ra) # 80003904 <releasesleep>

  acquire(&bcache.lock);
    8000253a:	0000d517          	auipc	a0,0xd
    8000253e:	b5e50513          	addi	a0,a0,-1186 # 8000f098 <bcache>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	ca0080e7          	jalr	-864(ra) # 800061e2 <acquire>
  b->refcnt--;
    8000254a:	40bc                	lw	a5,64(s1)
    8000254c:	37fd                	addiw	a5,a5,-1
    8000254e:	0007871b          	sext.w	a4,a5
    80002552:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002554:	eb05                	bnez	a4,80002584 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002556:	68bc                	ld	a5,80(s1)
    80002558:	64b8                	ld	a4,72(s1)
    8000255a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000255c:	64bc                	ld	a5,72(s1)
    8000255e:	68b8                	ld	a4,80(s1)
    80002560:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002562:	00015797          	auipc	a5,0x15
    80002566:	b3678793          	addi	a5,a5,-1226 # 80017098 <bcache+0x8000>
    8000256a:	2b87b703          	ld	a4,696(a5)
    8000256e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002570:	00015717          	auipc	a4,0x15
    80002574:	d9070713          	addi	a4,a4,-624 # 80017300 <bcache+0x8268>
    80002578:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000257a:	2b87b703          	ld	a4,696(a5)
    8000257e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002580:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002584:	0000d517          	auipc	a0,0xd
    80002588:	b1450513          	addi	a0,a0,-1260 # 8000f098 <bcache>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	d0a080e7          	jalr	-758(ra) # 80006296 <release>
}
    80002594:	60e2                	ld	ra,24(sp)
    80002596:	6442                	ld	s0,16(sp)
    80002598:	64a2                	ld	s1,8(sp)
    8000259a:	6902                	ld	s2,0(sp)
    8000259c:	6105                	addi	sp,sp,32
    8000259e:	8082                	ret
    panic("brelse");
    800025a0:	00006517          	auipc	a0,0x6
    800025a4:	fe850513          	addi	a0,a0,-24 # 80008588 <syscalls+0xf0>
    800025a8:	00003097          	auipc	ra,0x3
    800025ac:	6f0080e7          	jalr	1776(ra) # 80005c98 <panic>

00000000800025b0 <bpin>:

void
bpin(struct buf *b) {
    800025b0:	1101                	addi	sp,sp,-32
    800025b2:	ec06                	sd	ra,24(sp)
    800025b4:	e822                	sd	s0,16(sp)
    800025b6:	e426                	sd	s1,8(sp)
    800025b8:	1000                	addi	s0,sp,32
    800025ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	adc50513          	addi	a0,a0,-1316 # 8000f098 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	c1e080e7          	jalr	-994(ra) # 800061e2 <acquire>
  b->refcnt++;
    800025cc:	40bc                	lw	a5,64(s1)
    800025ce:	2785                	addiw	a5,a5,1
    800025d0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d2:	0000d517          	auipc	a0,0xd
    800025d6:	ac650513          	addi	a0,a0,-1338 # 8000f098 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	cbc080e7          	jalr	-836(ra) # 80006296 <release>
}
    800025e2:	60e2                	ld	ra,24(sp)
    800025e4:	6442                	ld	s0,16(sp)
    800025e6:	64a2                	ld	s1,8(sp)
    800025e8:	6105                	addi	sp,sp,32
    800025ea:	8082                	ret

00000000800025ec <bunpin>:

void
bunpin(struct buf *b) {
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	1000                	addi	s0,sp,32
    800025f6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f8:	0000d517          	auipc	a0,0xd
    800025fc:	aa050513          	addi	a0,a0,-1376 # 8000f098 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	be2080e7          	jalr	-1054(ra) # 800061e2 <acquire>
  b->refcnt--;
    80002608:	40bc                	lw	a5,64(s1)
    8000260a:	37fd                	addiw	a5,a5,-1
    8000260c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260e:	0000d517          	auipc	a0,0xd
    80002612:	a8a50513          	addi	a0,a0,-1398 # 8000f098 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	c80080e7          	jalr	-896(ra) # 80006296 <release>
}
    8000261e:	60e2                	ld	ra,24(sp)
    80002620:	6442                	ld	s0,16(sp)
    80002622:	64a2                	ld	s1,8(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret

0000000080002628 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002628:	1101                	addi	sp,sp,-32
    8000262a:	ec06                	sd	ra,24(sp)
    8000262c:	e822                	sd	s0,16(sp)
    8000262e:	e426                	sd	s1,8(sp)
    80002630:	e04a                	sd	s2,0(sp)
    80002632:	1000                	addi	s0,sp,32
    80002634:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002636:	00d5d59b          	srliw	a1,a1,0xd
    8000263a:	00015797          	auipc	a5,0x15
    8000263e:	13a7a783          	lw	a5,314(a5) # 80017774 <sb+0x1c>
    80002642:	9dbd                	addw	a1,a1,a5
    80002644:	00000097          	auipc	ra,0x0
    80002648:	d9e080e7          	jalr	-610(ra) # 800023e2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000264c:	0074f713          	andi	a4,s1,7
    80002650:	4785                	li	a5,1
    80002652:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002656:	14ce                	slli	s1,s1,0x33
    80002658:	90d9                	srli	s1,s1,0x36
    8000265a:	00950733          	add	a4,a0,s1
    8000265e:	05874703          	lbu	a4,88(a4)
    80002662:	00e7f6b3          	and	a3,a5,a4
    80002666:	c69d                	beqz	a3,80002694 <bfree+0x6c>
    80002668:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000266a:	94aa                	add	s1,s1,a0
    8000266c:	fff7c793          	not	a5,a5
    80002670:	8ff9                	and	a5,a5,a4
    80002672:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	118080e7          	jalr	280(ra) # 8000378e <log_write>
  brelse(bp);
    8000267e:	854a                	mv	a0,s2
    80002680:	00000097          	auipc	ra,0x0
    80002684:	e92080e7          	jalr	-366(ra) # 80002512 <brelse>
}
    80002688:	60e2                	ld	ra,24(sp)
    8000268a:	6442                	ld	s0,16(sp)
    8000268c:	64a2                	ld	s1,8(sp)
    8000268e:	6902                	ld	s2,0(sp)
    80002690:	6105                	addi	sp,sp,32
    80002692:	8082                	ret
    panic("freeing free block");
    80002694:	00006517          	auipc	a0,0x6
    80002698:	efc50513          	addi	a0,a0,-260 # 80008590 <syscalls+0xf8>
    8000269c:	00003097          	auipc	ra,0x3
    800026a0:	5fc080e7          	jalr	1532(ra) # 80005c98 <panic>

00000000800026a4 <balloc>:
{
    800026a4:	711d                	addi	sp,sp,-96
    800026a6:	ec86                	sd	ra,88(sp)
    800026a8:	e8a2                	sd	s0,80(sp)
    800026aa:	e4a6                	sd	s1,72(sp)
    800026ac:	e0ca                	sd	s2,64(sp)
    800026ae:	fc4e                	sd	s3,56(sp)
    800026b0:	f852                	sd	s4,48(sp)
    800026b2:	f456                	sd	s5,40(sp)
    800026b4:	f05a                	sd	s6,32(sp)
    800026b6:	ec5e                	sd	s7,24(sp)
    800026b8:	e862                	sd	s8,16(sp)
    800026ba:	e466                	sd	s9,8(sp)
    800026bc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026be:	00015797          	auipc	a5,0x15
    800026c2:	09e7a783          	lw	a5,158(a5) # 8001775c <sb+0x4>
    800026c6:	cbd1                	beqz	a5,8000275a <balloc+0xb6>
    800026c8:	8baa                	mv	s7,a0
    800026ca:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026cc:	00015b17          	auipc	s6,0x15
    800026d0:	08cb0b13          	addi	s6,s6,140 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026da:	6c89                	lui	s9,0x2
    800026dc:	a831                	j	800026f8 <balloc+0x54>
    brelse(bp);
    800026de:	854a                	mv	a0,s2
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	e32080e7          	jalr	-462(ra) # 80002512 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e8:	015c87bb          	addw	a5,s9,s5
    800026ec:	00078a9b          	sext.w	s5,a5
    800026f0:	004b2703          	lw	a4,4(s6)
    800026f4:	06eaf363          	bgeu	s5,a4,8000275a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026f8:	41fad79b          	sraiw	a5,s5,0x1f
    800026fc:	0137d79b          	srliw	a5,a5,0x13
    80002700:	015787bb          	addw	a5,a5,s5
    80002704:	40d7d79b          	sraiw	a5,a5,0xd
    80002708:	01cb2583          	lw	a1,28(s6)
    8000270c:	9dbd                	addw	a1,a1,a5
    8000270e:	855e                	mv	a0,s7
    80002710:	00000097          	auipc	ra,0x0
    80002714:	cd2080e7          	jalr	-814(ra) # 800023e2 <bread>
    80002718:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271a:	004b2503          	lw	a0,4(s6)
    8000271e:	000a849b          	sext.w	s1,s5
    80002722:	8662                	mv	a2,s8
    80002724:	faa4fde3          	bgeu	s1,a0,800026de <balloc+0x3a>
      m = 1 << (bi % 8);
    80002728:	41f6579b          	sraiw	a5,a2,0x1f
    8000272c:	01d7d69b          	srliw	a3,a5,0x1d
    80002730:	00c6873b          	addw	a4,a3,a2
    80002734:	00777793          	andi	a5,a4,7
    80002738:	9f95                	subw	a5,a5,a3
    8000273a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000273e:	4037571b          	sraiw	a4,a4,0x3
    80002742:	00e906b3          	add	a3,s2,a4
    80002746:	0586c683          	lbu	a3,88(a3)
    8000274a:	00d7f5b3          	and	a1,a5,a3
    8000274e:	cd91                	beqz	a1,8000276a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002750:	2605                	addiw	a2,a2,1
    80002752:	2485                	addiw	s1,s1,1
    80002754:	fd4618e3          	bne	a2,s4,80002724 <balloc+0x80>
    80002758:	b759                	j	800026de <balloc+0x3a>
  panic("balloc: out of blocks");
    8000275a:	00006517          	auipc	a0,0x6
    8000275e:	e4e50513          	addi	a0,a0,-434 # 800085a8 <syscalls+0x110>
    80002762:	00003097          	auipc	ra,0x3
    80002766:	536080e7          	jalr	1334(ra) # 80005c98 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000276a:	974a                	add	a4,a4,s2
    8000276c:	8fd5                	or	a5,a5,a3
    8000276e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00001097          	auipc	ra,0x1
    80002778:	01a080e7          	jalr	26(ra) # 8000378e <log_write>
        brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	d94080e7          	jalr	-620(ra) # 80002512 <brelse>
  bp = bread(dev, bno);
    80002786:	85a6                	mv	a1,s1
    80002788:	855e                	mv	a0,s7
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	c58080e7          	jalr	-936(ra) # 800023e2 <bread>
    80002792:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002794:	40000613          	li	a2,1024
    80002798:	4581                	li	a1,0
    8000279a:	05850513          	addi	a0,a0,88
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	a24080e7          	jalr	-1500(ra) # 800001c2 <memset>
  log_write(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00001097          	auipc	ra,0x1
    800027ac:	fe6080e7          	jalr	-26(ra) # 8000378e <log_write>
  brelse(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	d60080e7          	jalr	-672(ra) # 80002512 <brelse>
}
    800027ba:	8526                	mv	a0,s1
    800027bc:	60e6                	ld	ra,88(sp)
    800027be:	6446                	ld	s0,80(sp)
    800027c0:	64a6                	ld	s1,72(sp)
    800027c2:	6906                	ld	s2,64(sp)
    800027c4:	79e2                	ld	s3,56(sp)
    800027c6:	7a42                	ld	s4,48(sp)
    800027c8:	7aa2                	ld	s5,40(sp)
    800027ca:	7b02                	ld	s6,32(sp)
    800027cc:	6be2                	ld	s7,24(sp)
    800027ce:	6c42                	ld	s8,16(sp)
    800027d0:	6ca2                	ld	s9,8(sp)
    800027d2:	6125                	addi	sp,sp,96
    800027d4:	8082                	ret

00000000800027d6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d6:	7179                	addi	sp,sp,-48
    800027d8:	f406                	sd	ra,40(sp)
    800027da:	f022                	sd	s0,32(sp)
    800027dc:	ec26                	sd	s1,24(sp)
    800027de:	e84a                	sd	s2,16(sp)
    800027e0:	e44e                	sd	s3,8(sp)
    800027e2:	e052                	sd	s4,0(sp)
    800027e4:	1800                	addi	s0,sp,48
    800027e6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e8:	47ad                	li	a5,11
    800027ea:	04b7fe63          	bgeu	a5,a1,80002846 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ee:	ff45849b          	addiw	s1,a1,-12
    800027f2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f6:	0ff00793          	li	a5,255
    800027fa:	0ae7e363          	bltu	a5,a4,800028a0 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027fe:	08052583          	lw	a1,128(a0)
    80002802:	c5ad                	beqz	a1,8000286c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002804:	00092503          	lw	a0,0(s2)
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	bda080e7          	jalr	-1062(ra) # 800023e2 <bread>
    80002810:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002812:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002816:	02049593          	slli	a1,s1,0x20
    8000281a:	9181                	srli	a1,a1,0x20
    8000281c:	058a                	slli	a1,a1,0x2
    8000281e:	00b784b3          	add	s1,a5,a1
    80002822:	0004a983          	lw	s3,0(s1)
    80002826:	04098d63          	beqz	s3,80002880 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000282a:	8552                	mv	a0,s4
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	ce6080e7          	jalr	-794(ra) # 80002512 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002834:	854e                	mv	a0,s3
    80002836:	70a2                	ld	ra,40(sp)
    80002838:	7402                	ld	s0,32(sp)
    8000283a:	64e2                	ld	s1,24(sp)
    8000283c:	6942                	ld	s2,16(sp)
    8000283e:	69a2                	ld	s3,8(sp)
    80002840:	6a02                	ld	s4,0(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002846:	02059493          	slli	s1,a1,0x20
    8000284a:	9081                	srli	s1,s1,0x20
    8000284c:	048a                	slli	s1,s1,0x2
    8000284e:	94aa                	add	s1,s1,a0
    80002850:	0504a983          	lw	s3,80(s1)
    80002854:	fe0990e3          	bnez	s3,80002834 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002858:	4108                	lw	a0,0(a0)
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	e4a080e7          	jalr	-438(ra) # 800026a4 <balloc>
    80002862:	0005099b          	sext.w	s3,a0
    80002866:	0534a823          	sw	s3,80(s1)
    8000286a:	b7e9                	j	80002834 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000286c:	4108                	lw	a0,0(a0)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e36080e7          	jalr	-458(ra) # 800026a4 <balloc>
    80002876:	0005059b          	sext.w	a1,a0
    8000287a:	08b92023          	sw	a1,128(s2)
    8000287e:	b759                	j	80002804 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002880:	00092503          	lw	a0,0(s2)
    80002884:	00000097          	auipc	ra,0x0
    80002888:	e20080e7          	jalr	-480(ra) # 800026a4 <balloc>
    8000288c:	0005099b          	sext.w	s3,a0
    80002890:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002894:	8552                	mv	a0,s4
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	ef8080e7          	jalr	-264(ra) # 8000378e <log_write>
    8000289e:	b771                	j	8000282a <bmap+0x54>
  panic("bmap: out of range");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	d2050513          	addi	a0,a0,-736 # 800085c0 <syscalls+0x128>
    800028a8:	00003097          	auipc	ra,0x3
    800028ac:	3f0080e7          	jalr	1008(ra) # 80005c98 <panic>

00000000800028b0 <iget>:
{
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	e052                	sd	s4,0(sp)
    800028be:	1800                	addi	s0,sp,48
    800028c0:	89aa                	mv	s3,a0
    800028c2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028c4:	00015517          	auipc	a0,0x15
    800028c8:	eb450513          	addi	a0,a0,-332 # 80017778 <itable>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	916080e7          	jalr	-1770(ra) # 800061e2 <acquire>
  empty = 0;
    800028d4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d6:	00015497          	auipc	s1,0x15
    800028da:	eba48493          	addi	s1,s1,-326 # 80017790 <itable+0x18>
    800028de:	00017697          	auipc	a3,0x17
    800028e2:	94268693          	addi	a3,a3,-1726 # 80019220 <log>
    800028e6:	a039                	j	800028f4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e8:	02090b63          	beqz	s2,8000291e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ec:	08848493          	addi	s1,s1,136
    800028f0:	02d48a63          	beq	s1,a3,80002924 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028f4:	449c                	lw	a5,8(s1)
    800028f6:	fef059e3          	blez	a5,800028e8 <iget+0x38>
    800028fa:	4098                	lw	a4,0(s1)
    800028fc:	ff3716e3          	bne	a4,s3,800028e8 <iget+0x38>
    80002900:	40d8                	lw	a4,4(s1)
    80002902:	ff4713e3          	bne	a4,s4,800028e8 <iget+0x38>
      ip->ref++;
    80002906:	2785                	addiw	a5,a5,1
    80002908:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000290a:	00015517          	auipc	a0,0x15
    8000290e:	e6e50513          	addi	a0,a0,-402 # 80017778 <itable>
    80002912:	00004097          	auipc	ra,0x4
    80002916:	984080e7          	jalr	-1660(ra) # 80006296 <release>
      return ip;
    8000291a:	8926                	mv	s2,s1
    8000291c:	a03d                	j	8000294a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000291e:	f7f9                	bnez	a5,800028ec <iget+0x3c>
    80002920:	8926                	mv	s2,s1
    80002922:	b7e9                	j	800028ec <iget+0x3c>
  if(empty == 0)
    80002924:	02090c63          	beqz	s2,8000295c <iget+0xac>
  ip->dev = dev;
    80002928:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000292c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002930:	4785                	li	a5,1
    80002932:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002936:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000293a:	00015517          	auipc	a0,0x15
    8000293e:	e3e50513          	addi	a0,a0,-450 # 80017778 <itable>
    80002942:	00004097          	auipc	ra,0x4
    80002946:	954080e7          	jalr	-1708(ra) # 80006296 <release>
}
    8000294a:	854a                	mv	a0,s2
    8000294c:	70a2                	ld	ra,40(sp)
    8000294e:	7402                	ld	s0,32(sp)
    80002950:	64e2                	ld	s1,24(sp)
    80002952:	6942                	ld	s2,16(sp)
    80002954:	69a2                	ld	s3,8(sp)
    80002956:	6a02                	ld	s4,0(sp)
    80002958:	6145                	addi	sp,sp,48
    8000295a:	8082                	ret
    panic("iget: no inodes");
    8000295c:	00006517          	auipc	a0,0x6
    80002960:	c7c50513          	addi	a0,a0,-900 # 800085d8 <syscalls+0x140>
    80002964:	00003097          	auipc	ra,0x3
    80002968:	334080e7          	jalr	820(ra) # 80005c98 <panic>

000000008000296c <fsinit>:
fsinit(int dev) {
    8000296c:	7179                	addi	sp,sp,-48
    8000296e:	f406                	sd	ra,40(sp)
    80002970:	f022                	sd	s0,32(sp)
    80002972:	ec26                	sd	s1,24(sp)
    80002974:	e84a                	sd	s2,16(sp)
    80002976:	e44e                	sd	s3,8(sp)
    80002978:	1800                	addi	s0,sp,48
    8000297a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000297c:	4585                	li	a1,1
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	a64080e7          	jalr	-1436(ra) # 800023e2 <bread>
    80002986:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002988:	00015997          	auipc	s3,0x15
    8000298c:	dd098993          	addi	s3,s3,-560 # 80017758 <sb>
    80002990:	02000613          	li	a2,32
    80002994:	05850593          	addi	a1,a0,88
    80002998:	854e                	mv	a0,s3
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	888080e7          	jalr	-1912(ra) # 80000222 <memmove>
  brelse(bp);
    800029a2:	8526                	mv	a0,s1
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	b6e080e7          	jalr	-1170(ra) # 80002512 <brelse>
  if(sb.magic != FSMAGIC)
    800029ac:	0009a703          	lw	a4,0(s3)
    800029b0:	102037b7          	lui	a5,0x10203
    800029b4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029b8:	02f71263          	bne	a4,a5,800029dc <fsinit+0x70>
  initlog(dev, &sb);
    800029bc:	00015597          	auipc	a1,0x15
    800029c0:	d9c58593          	addi	a1,a1,-612 # 80017758 <sb>
    800029c4:	854a                	mv	a0,s2
    800029c6:	00001097          	auipc	ra,0x1
    800029ca:	b4c080e7          	jalr	-1204(ra) # 80003512 <initlog>
}
    800029ce:	70a2                	ld	ra,40(sp)
    800029d0:	7402                	ld	s0,32(sp)
    800029d2:	64e2                	ld	s1,24(sp)
    800029d4:	6942                	ld	s2,16(sp)
    800029d6:	69a2                	ld	s3,8(sp)
    800029d8:	6145                	addi	sp,sp,48
    800029da:	8082                	ret
    panic("invalid file system");
    800029dc:	00006517          	auipc	a0,0x6
    800029e0:	c0c50513          	addi	a0,a0,-1012 # 800085e8 <syscalls+0x150>
    800029e4:	00003097          	auipc	ra,0x3
    800029e8:	2b4080e7          	jalr	692(ra) # 80005c98 <panic>

00000000800029ec <iinit>:
{
    800029ec:	7179                	addi	sp,sp,-48
    800029ee:	f406                	sd	ra,40(sp)
    800029f0:	f022                	sd	s0,32(sp)
    800029f2:	ec26                	sd	s1,24(sp)
    800029f4:	e84a                	sd	s2,16(sp)
    800029f6:	e44e                	sd	s3,8(sp)
    800029f8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029fa:	00006597          	auipc	a1,0x6
    800029fe:	c0658593          	addi	a1,a1,-1018 # 80008600 <syscalls+0x168>
    80002a02:	00015517          	auipc	a0,0x15
    80002a06:	d7650513          	addi	a0,a0,-650 # 80017778 <itable>
    80002a0a:	00003097          	auipc	ra,0x3
    80002a0e:	748080e7          	jalr	1864(ra) # 80006152 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a12:	00015497          	auipc	s1,0x15
    80002a16:	d8e48493          	addi	s1,s1,-626 # 800177a0 <itable+0x28>
    80002a1a:	00017997          	auipc	s3,0x17
    80002a1e:	81698993          	addi	s3,s3,-2026 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a22:	00006917          	auipc	s2,0x6
    80002a26:	be690913          	addi	s2,s2,-1050 # 80008608 <syscalls+0x170>
    80002a2a:	85ca                	mv	a1,s2
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	e46080e7          	jalr	-442(ra) # 80003874 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a36:	08848493          	addi	s1,s1,136
    80002a3a:	ff3498e3          	bne	s1,s3,80002a2a <iinit+0x3e>
}
    80002a3e:	70a2                	ld	ra,40(sp)
    80002a40:	7402                	ld	s0,32(sp)
    80002a42:	64e2                	ld	s1,24(sp)
    80002a44:	6942                	ld	s2,16(sp)
    80002a46:	69a2                	ld	s3,8(sp)
    80002a48:	6145                	addi	sp,sp,48
    80002a4a:	8082                	ret

0000000080002a4c <ialloc>:
{
    80002a4c:	715d                	addi	sp,sp,-80
    80002a4e:	e486                	sd	ra,72(sp)
    80002a50:	e0a2                	sd	s0,64(sp)
    80002a52:	fc26                	sd	s1,56(sp)
    80002a54:	f84a                	sd	s2,48(sp)
    80002a56:	f44e                	sd	s3,40(sp)
    80002a58:	f052                	sd	s4,32(sp)
    80002a5a:	ec56                	sd	s5,24(sp)
    80002a5c:	e85a                	sd	s6,16(sp)
    80002a5e:	e45e                	sd	s7,8(sp)
    80002a60:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a62:	00015717          	auipc	a4,0x15
    80002a66:	d0272703          	lw	a4,-766(a4) # 80017764 <sb+0xc>
    80002a6a:	4785                	li	a5,1
    80002a6c:	04e7fa63          	bgeu	a5,a4,80002ac0 <ialloc+0x74>
    80002a70:	8aaa                	mv	s5,a0
    80002a72:	8bae                	mv	s7,a1
    80002a74:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a76:	00015a17          	auipc	s4,0x15
    80002a7a:	ce2a0a13          	addi	s4,s4,-798 # 80017758 <sb>
    80002a7e:	00048b1b          	sext.w	s6,s1
    80002a82:	0044d593          	srli	a1,s1,0x4
    80002a86:	018a2783          	lw	a5,24(s4)
    80002a8a:	9dbd                	addw	a1,a1,a5
    80002a8c:	8556                	mv	a0,s5
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	954080e7          	jalr	-1708(ra) # 800023e2 <bread>
    80002a96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a98:	05850993          	addi	s3,a0,88
    80002a9c:	00f4f793          	andi	a5,s1,15
    80002aa0:	079a                	slli	a5,a5,0x6
    80002aa2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aa4:	00099783          	lh	a5,0(s3)
    80002aa8:	c785                	beqz	a5,80002ad0 <ialloc+0x84>
    brelse(bp);
    80002aaa:	00000097          	auipc	ra,0x0
    80002aae:	a68080e7          	jalr	-1432(ra) # 80002512 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab2:	0485                	addi	s1,s1,1
    80002ab4:	00ca2703          	lw	a4,12(s4)
    80002ab8:	0004879b          	sext.w	a5,s1
    80002abc:	fce7e1e3          	bltu	a5,a4,80002a7e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ac0:	00006517          	auipc	a0,0x6
    80002ac4:	b5050513          	addi	a0,a0,-1200 # 80008610 <syscalls+0x178>
    80002ac8:	00003097          	auipc	ra,0x3
    80002acc:	1d0080e7          	jalr	464(ra) # 80005c98 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ad0:	04000613          	li	a2,64
    80002ad4:	4581                	li	a1,0
    80002ad6:	854e                	mv	a0,s3
    80002ad8:	ffffd097          	auipc	ra,0xffffd
    80002adc:	6ea080e7          	jalr	1770(ra) # 800001c2 <memset>
      dip->type = type;
    80002ae0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00001097          	auipc	ra,0x1
    80002aea:	ca8080e7          	jalr	-856(ra) # 8000378e <log_write>
      brelse(bp);
    80002aee:	854a                	mv	a0,s2
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	a22080e7          	jalr	-1502(ra) # 80002512 <brelse>
      return iget(dev, inum);
    80002af8:	85da                	mv	a1,s6
    80002afa:	8556                	mv	a0,s5
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	db4080e7          	jalr	-588(ra) # 800028b0 <iget>
}
    80002b04:	60a6                	ld	ra,72(sp)
    80002b06:	6406                	ld	s0,64(sp)
    80002b08:	74e2                	ld	s1,56(sp)
    80002b0a:	7942                	ld	s2,48(sp)
    80002b0c:	79a2                	ld	s3,40(sp)
    80002b0e:	7a02                	ld	s4,32(sp)
    80002b10:	6ae2                	ld	s5,24(sp)
    80002b12:	6b42                	ld	s6,16(sp)
    80002b14:	6ba2                	ld	s7,8(sp)
    80002b16:	6161                	addi	sp,sp,80
    80002b18:	8082                	ret

0000000080002b1a <iupdate>:
{
    80002b1a:	1101                	addi	sp,sp,-32
    80002b1c:	ec06                	sd	ra,24(sp)
    80002b1e:	e822                	sd	s0,16(sp)
    80002b20:	e426                	sd	s1,8(sp)
    80002b22:	e04a                	sd	s2,0(sp)
    80002b24:	1000                	addi	s0,sp,32
    80002b26:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b28:	415c                	lw	a5,4(a0)
    80002b2a:	0047d79b          	srliw	a5,a5,0x4
    80002b2e:	00015597          	auipc	a1,0x15
    80002b32:	c425a583          	lw	a1,-958(a1) # 80017770 <sb+0x18>
    80002b36:	9dbd                	addw	a1,a1,a5
    80002b38:	4108                	lw	a0,0(a0)
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	8a8080e7          	jalr	-1880(ra) # 800023e2 <bread>
    80002b42:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b44:	05850793          	addi	a5,a0,88
    80002b48:	40c8                	lw	a0,4(s1)
    80002b4a:	893d                	andi	a0,a0,15
    80002b4c:	051a                	slli	a0,a0,0x6
    80002b4e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b50:	04449703          	lh	a4,68(s1)
    80002b54:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b58:	04649703          	lh	a4,70(s1)
    80002b5c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b60:	04849703          	lh	a4,72(s1)
    80002b64:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b68:	04a49703          	lh	a4,74(s1)
    80002b6c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b70:	44f8                	lw	a4,76(s1)
    80002b72:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b74:	03400613          	li	a2,52
    80002b78:	05048593          	addi	a1,s1,80
    80002b7c:	0531                	addi	a0,a0,12
    80002b7e:	ffffd097          	auipc	ra,0xffffd
    80002b82:	6a4080e7          	jalr	1700(ra) # 80000222 <memmove>
  log_write(bp);
    80002b86:	854a                	mv	a0,s2
    80002b88:	00001097          	auipc	ra,0x1
    80002b8c:	c06080e7          	jalr	-1018(ra) # 8000378e <log_write>
  brelse(bp);
    80002b90:	854a                	mv	a0,s2
    80002b92:	00000097          	auipc	ra,0x0
    80002b96:	980080e7          	jalr	-1664(ra) # 80002512 <brelse>
}
    80002b9a:	60e2                	ld	ra,24(sp)
    80002b9c:	6442                	ld	s0,16(sp)
    80002b9e:	64a2                	ld	s1,8(sp)
    80002ba0:	6902                	ld	s2,0(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret

0000000080002ba6 <idup>:
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	1000                	addi	s0,sp,32
    80002bb0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb2:	00015517          	auipc	a0,0x15
    80002bb6:	bc650513          	addi	a0,a0,-1082 # 80017778 <itable>
    80002bba:	00003097          	auipc	ra,0x3
    80002bbe:	628080e7          	jalr	1576(ra) # 800061e2 <acquire>
  ip->ref++;
    80002bc2:	449c                	lw	a5,8(s1)
    80002bc4:	2785                	addiw	a5,a5,1
    80002bc6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bc8:	00015517          	auipc	a0,0x15
    80002bcc:	bb050513          	addi	a0,a0,-1104 # 80017778 <itable>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	6c6080e7          	jalr	1734(ra) # 80006296 <release>
}
    80002bd8:	8526                	mv	a0,s1
    80002bda:	60e2                	ld	ra,24(sp)
    80002bdc:	6442                	ld	s0,16(sp)
    80002bde:	64a2                	ld	s1,8(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret

0000000080002be4 <ilock>:
{
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	e04a                	sd	s2,0(sp)
    80002bee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bf0:	c115                	beqz	a0,80002c14 <ilock+0x30>
    80002bf2:	84aa                	mv	s1,a0
    80002bf4:	451c                	lw	a5,8(a0)
    80002bf6:	00f05f63          	blez	a5,80002c14 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bfa:	0541                	addi	a0,a0,16
    80002bfc:	00001097          	auipc	ra,0x1
    80002c00:	cb2080e7          	jalr	-846(ra) # 800038ae <acquiresleep>
  if(ip->valid == 0){
    80002c04:	40bc                	lw	a5,64(s1)
    80002c06:	cf99                	beqz	a5,80002c24 <ilock+0x40>
}
    80002c08:	60e2                	ld	ra,24(sp)
    80002c0a:	6442                	ld	s0,16(sp)
    80002c0c:	64a2                	ld	s1,8(sp)
    80002c0e:	6902                	ld	s2,0(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret
    panic("ilock");
    80002c14:	00006517          	auipc	a0,0x6
    80002c18:	a1450513          	addi	a0,a0,-1516 # 80008628 <syscalls+0x190>
    80002c1c:	00003097          	auipc	ra,0x3
    80002c20:	07c080e7          	jalr	124(ra) # 80005c98 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c24:	40dc                	lw	a5,4(s1)
    80002c26:	0047d79b          	srliw	a5,a5,0x4
    80002c2a:	00015597          	auipc	a1,0x15
    80002c2e:	b465a583          	lw	a1,-1210(a1) # 80017770 <sb+0x18>
    80002c32:	9dbd                	addw	a1,a1,a5
    80002c34:	4088                	lw	a0,0(s1)
    80002c36:	fffff097          	auipc	ra,0xfffff
    80002c3a:	7ac080e7          	jalr	1964(ra) # 800023e2 <bread>
    80002c3e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c40:	05850593          	addi	a1,a0,88
    80002c44:	40dc                	lw	a5,4(s1)
    80002c46:	8bbd                	andi	a5,a5,15
    80002c48:	079a                	slli	a5,a5,0x6
    80002c4a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c4c:	00059783          	lh	a5,0(a1)
    80002c50:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c54:	00259783          	lh	a5,2(a1)
    80002c58:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c5c:	00459783          	lh	a5,4(a1)
    80002c60:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c64:	00659783          	lh	a5,6(a1)
    80002c68:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c6c:	459c                	lw	a5,8(a1)
    80002c6e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c70:	03400613          	li	a2,52
    80002c74:	05b1                	addi	a1,a1,12
    80002c76:	05048513          	addi	a0,s1,80
    80002c7a:	ffffd097          	auipc	ra,0xffffd
    80002c7e:	5a8080e7          	jalr	1448(ra) # 80000222 <memmove>
    brelse(bp);
    80002c82:	854a                	mv	a0,s2
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	88e080e7          	jalr	-1906(ra) # 80002512 <brelse>
    ip->valid = 1;
    80002c8c:	4785                	li	a5,1
    80002c8e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c90:	04449783          	lh	a5,68(s1)
    80002c94:	fbb5                	bnez	a5,80002c08 <ilock+0x24>
      panic("ilock: no type");
    80002c96:	00006517          	auipc	a0,0x6
    80002c9a:	99a50513          	addi	a0,a0,-1638 # 80008630 <syscalls+0x198>
    80002c9e:	00003097          	auipc	ra,0x3
    80002ca2:	ffa080e7          	jalr	-6(ra) # 80005c98 <panic>

0000000080002ca6 <iunlock>:
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	e426                	sd	s1,8(sp)
    80002cae:	e04a                	sd	s2,0(sp)
    80002cb0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cb2:	c905                	beqz	a0,80002ce2 <iunlock+0x3c>
    80002cb4:	84aa                	mv	s1,a0
    80002cb6:	01050913          	addi	s2,a0,16
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	c8c080e7          	jalr	-884(ra) # 80003948 <holdingsleep>
    80002cc4:	cd19                	beqz	a0,80002ce2 <iunlock+0x3c>
    80002cc6:	449c                	lw	a5,8(s1)
    80002cc8:	00f05d63          	blez	a5,80002ce2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ccc:	854a                	mv	a0,s2
    80002cce:	00001097          	auipc	ra,0x1
    80002cd2:	c36080e7          	jalr	-970(ra) # 80003904 <releasesleep>
}
    80002cd6:	60e2                	ld	ra,24(sp)
    80002cd8:	6442                	ld	s0,16(sp)
    80002cda:	64a2                	ld	s1,8(sp)
    80002cdc:	6902                	ld	s2,0(sp)
    80002cde:	6105                	addi	sp,sp,32
    80002ce0:	8082                	ret
    panic("iunlock");
    80002ce2:	00006517          	auipc	a0,0x6
    80002ce6:	95e50513          	addi	a0,a0,-1698 # 80008640 <syscalls+0x1a8>
    80002cea:	00003097          	auipc	ra,0x3
    80002cee:	fae080e7          	jalr	-82(ra) # 80005c98 <panic>

0000000080002cf2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cf2:	7179                	addi	sp,sp,-48
    80002cf4:	f406                	sd	ra,40(sp)
    80002cf6:	f022                	sd	s0,32(sp)
    80002cf8:	ec26                	sd	s1,24(sp)
    80002cfa:	e84a                	sd	s2,16(sp)
    80002cfc:	e44e                	sd	s3,8(sp)
    80002cfe:	e052                	sd	s4,0(sp)
    80002d00:	1800                	addi	s0,sp,48
    80002d02:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d04:	05050493          	addi	s1,a0,80
    80002d08:	08050913          	addi	s2,a0,128
    80002d0c:	a021                	j	80002d14 <itrunc+0x22>
    80002d0e:	0491                	addi	s1,s1,4
    80002d10:	01248d63          	beq	s1,s2,80002d2a <itrunc+0x38>
    if(ip->addrs[i]){
    80002d14:	408c                	lw	a1,0(s1)
    80002d16:	dde5                	beqz	a1,80002d0e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d18:	0009a503          	lw	a0,0(s3)
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	90c080e7          	jalr	-1780(ra) # 80002628 <bfree>
      ip->addrs[i] = 0;
    80002d24:	0004a023          	sw	zero,0(s1)
    80002d28:	b7dd                	j	80002d0e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d2a:	0809a583          	lw	a1,128(s3)
    80002d2e:	e185                	bnez	a1,80002d4e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d30:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d34:	854e                	mv	a0,s3
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	de4080e7          	jalr	-540(ra) # 80002b1a <iupdate>
}
    80002d3e:	70a2                	ld	ra,40(sp)
    80002d40:	7402                	ld	s0,32(sp)
    80002d42:	64e2                	ld	s1,24(sp)
    80002d44:	6942                	ld	s2,16(sp)
    80002d46:	69a2                	ld	s3,8(sp)
    80002d48:	6a02                	ld	s4,0(sp)
    80002d4a:	6145                	addi	sp,sp,48
    80002d4c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d4e:	0009a503          	lw	a0,0(s3)
    80002d52:	fffff097          	auipc	ra,0xfffff
    80002d56:	690080e7          	jalr	1680(ra) # 800023e2 <bread>
    80002d5a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d5c:	05850493          	addi	s1,a0,88
    80002d60:	45850913          	addi	s2,a0,1112
    80002d64:	a811                	j	80002d78 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	8be080e7          	jalr	-1858(ra) # 80002628 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d72:	0491                	addi	s1,s1,4
    80002d74:	01248563          	beq	s1,s2,80002d7e <itrunc+0x8c>
      if(a[j])
    80002d78:	408c                	lw	a1,0(s1)
    80002d7a:	dde5                	beqz	a1,80002d72 <itrunc+0x80>
    80002d7c:	b7ed                	j	80002d66 <itrunc+0x74>
    brelse(bp);
    80002d7e:	8552                	mv	a0,s4
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	792080e7          	jalr	1938(ra) # 80002512 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d88:	0809a583          	lw	a1,128(s3)
    80002d8c:	0009a503          	lw	a0,0(s3)
    80002d90:	00000097          	auipc	ra,0x0
    80002d94:	898080e7          	jalr	-1896(ra) # 80002628 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d98:	0809a023          	sw	zero,128(s3)
    80002d9c:	bf51                	j	80002d30 <itrunc+0x3e>

0000000080002d9e <iput>:
{
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	e426                	sd	s1,8(sp)
    80002da6:	e04a                	sd	s2,0(sp)
    80002da8:	1000                	addi	s0,sp,32
    80002daa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dac:	00015517          	auipc	a0,0x15
    80002db0:	9cc50513          	addi	a0,a0,-1588 # 80017778 <itable>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	42e080e7          	jalr	1070(ra) # 800061e2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dbc:	4498                	lw	a4,8(s1)
    80002dbe:	4785                	li	a5,1
    80002dc0:	02f70363          	beq	a4,a5,80002de6 <iput+0x48>
  ip->ref--;
    80002dc4:	449c                	lw	a5,8(s1)
    80002dc6:	37fd                	addiw	a5,a5,-1
    80002dc8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dca:	00015517          	auipc	a0,0x15
    80002dce:	9ae50513          	addi	a0,a0,-1618 # 80017778 <itable>
    80002dd2:	00003097          	auipc	ra,0x3
    80002dd6:	4c4080e7          	jalr	1220(ra) # 80006296 <release>
}
    80002dda:	60e2                	ld	ra,24(sp)
    80002ddc:	6442                	ld	s0,16(sp)
    80002dde:	64a2                	ld	s1,8(sp)
    80002de0:	6902                	ld	s2,0(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de6:	40bc                	lw	a5,64(s1)
    80002de8:	dff1                	beqz	a5,80002dc4 <iput+0x26>
    80002dea:	04a49783          	lh	a5,74(s1)
    80002dee:	fbf9                	bnez	a5,80002dc4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002df0:	01048913          	addi	s2,s1,16
    80002df4:	854a                	mv	a0,s2
    80002df6:	00001097          	auipc	ra,0x1
    80002dfa:	ab8080e7          	jalr	-1352(ra) # 800038ae <acquiresleep>
    release(&itable.lock);
    80002dfe:	00015517          	auipc	a0,0x15
    80002e02:	97a50513          	addi	a0,a0,-1670 # 80017778 <itable>
    80002e06:	00003097          	auipc	ra,0x3
    80002e0a:	490080e7          	jalr	1168(ra) # 80006296 <release>
    itrunc(ip);
    80002e0e:	8526                	mv	a0,s1
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	ee2080e7          	jalr	-286(ra) # 80002cf2 <itrunc>
    ip->type = 0;
    80002e18:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	cfc080e7          	jalr	-772(ra) # 80002b1a <iupdate>
    ip->valid = 0;
    80002e26:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e2a:	854a                	mv	a0,s2
    80002e2c:	00001097          	auipc	ra,0x1
    80002e30:	ad8080e7          	jalr	-1320(ra) # 80003904 <releasesleep>
    acquire(&itable.lock);
    80002e34:	00015517          	auipc	a0,0x15
    80002e38:	94450513          	addi	a0,a0,-1724 # 80017778 <itable>
    80002e3c:	00003097          	auipc	ra,0x3
    80002e40:	3a6080e7          	jalr	934(ra) # 800061e2 <acquire>
    80002e44:	b741                	j	80002dc4 <iput+0x26>

0000000080002e46 <iunlockput>:
{
    80002e46:	1101                	addi	sp,sp,-32
    80002e48:	ec06                	sd	ra,24(sp)
    80002e4a:	e822                	sd	s0,16(sp)
    80002e4c:	e426                	sd	s1,8(sp)
    80002e4e:	1000                	addi	s0,sp,32
    80002e50:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	e54080e7          	jalr	-428(ra) # 80002ca6 <iunlock>
  iput(ip);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	f42080e7          	jalr	-190(ra) # 80002d9e <iput>
}
    80002e64:	60e2                	ld	ra,24(sp)
    80002e66:	6442                	ld	s0,16(sp)
    80002e68:	64a2                	ld	s1,8(sp)
    80002e6a:	6105                	addi	sp,sp,32
    80002e6c:	8082                	ret

0000000080002e6e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e6e:	1141                	addi	sp,sp,-16
    80002e70:	e422                	sd	s0,8(sp)
    80002e72:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e74:	411c                	lw	a5,0(a0)
    80002e76:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e78:	415c                	lw	a5,4(a0)
    80002e7a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e7c:	04451783          	lh	a5,68(a0)
    80002e80:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e84:	04a51783          	lh	a5,74(a0)
    80002e88:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e8c:	04c56783          	lwu	a5,76(a0)
    80002e90:	e99c                	sd	a5,16(a1)
}
    80002e92:	6422                	ld	s0,8(sp)
    80002e94:	0141                	addi	sp,sp,16
    80002e96:	8082                	ret

0000000080002e98 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e98:	457c                	lw	a5,76(a0)
    80002e9a:	0ed7e963          	bltu	a5,a3,80002f8c <readi+0xf4>
{
    80002e9e:	7159                	addi	sp,sp,-112
    80002ea0:	f486                	sd	ra,104(sp)
    80002ea2:	f0a2                	sd	s0,96(sp)
    80002ea4:	eca6                	sd	s1,88(sp)
    80002ea6:	e8ca                	sd	s2,80(sp)
    80002ea8:	e4ce                	sd	s3,72(sp)
    80002eaa:	e0d2                	sd	s4,64(sp)
    80002eac:	fc56                	sd	s5,56(sp)
    80002eae:	f85a                	sd	s6,48(sp)
    80002eb0:	f45e                	sd	s7,40(sp)
    80002eb2:	f062                	sd	s8,32(sp)
    80002eb4:	ec66                	sd	s9,24(sp)
    80002eb6:	e86a                	sd	s10,16(sp)
    80002eb8:	e46e                	sd	s11,8(sp)
    80002eba:	1880                	addi	s0,sp,112
    80002ebc:	8baa                	mv	s7,a0
    80002ebe:	8c2e                	mv	s8,a1
    80002ec0:	8ab2                	mv	s5,a2
    80002ec2:	84b6                	mv	s1,a3
    80002ec4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec6:	9f35                	addw	a4,a4,a3
    return 0;
    80002ec8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eca:	0ad76063          	bltu	a4,a3,80002f6a <readi+0xd2>
  if(off + n > ip->size)
    80002ece:	00e7f463          	bgeu	a5,a4,80002ed6 <readi+0x3e>
    n = ip->size - off;
    80002ed2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed6:	0a0b0963          	beqz	s6,80002f88 <readi+0xf0>
    80002eda:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002edc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ee0:	5cfd                	li	s9,-1
    80002ee2:	a82d                	j	80002f1c <readi+0x84>
    80002ee4:	020a1d93          	slli	s11,s4,0x20
    80002ee8:	020ddd93          	srli	s11,s11,0x20
    80002eec:	05890613          	addi	a2,s2,88
    80002ef0:	86ee                	mv	a3,s11
    80002ef2:	963a                	add	a2,a2,a4
    80002ef4:	85d6                	mv	a1,s5
    80002ef6:	8562                	mv	a0,s8
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	a02080e7          	jalr	-1534(ra) # 800018fa <either_copyout>
    80002f00:	05950d63          	beq	a0,s9,80002f5a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f04:	854a                	mv	a0,s2
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	60c080e7          	jalr	1548(ra) # 80002512 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0e:	013a09bb          	addw	s3,s4,s3
    80002f12:	009a04bb          	addw	s1,s4,s1
    80002f16:	9aee                	add	s5,s5,s11
    80002f18:	0569f763          	bgeu	s3,s6,80002f66 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f1c:	000ba903          	lw	s2,0(s7)
    80002f20:	00a4d59b          	srliw	a1,s1,0xa
    80002f24:	855e                	mv	a0,s7
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	8b0080e7          	jalr	-1872(ra) # 800027d6 <bmap>
    80002f2e:	0005059b          	sext.w	a1,a0
    80002f32:	854a                	mv	a0,s2
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	4ae080e7          	jalr	1198(ra) # 800023e2 <bread>
    80002f3c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3e:	3ff4f713          	andi	a4,s1,1023
    80002f42:	40ed07bb          	subw	a5,s10,a4
    80002f46:	413b06bb          	subw	a3,s6,s3
    80002f4a:	8a3e                	mv	s4,a5
    80002f4c:	2781                	sext.w	a5,a5
    80002f4e:	0006861b          	sext.w	a2,a3
    80002f52:	f8f679e3          	bgeu	a2,a5,80002ee4 <readi+0x4c>
    80002f56:	8a36                	mv	s4,a3
    80002f58:	b771                	j	80002ee4 <readi+0x4c>
      brelse(bp);
    80002f5a:	854a                	mv	a0,s2
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	5b6080e7          	jalr	1462(ra) # 80002512 <brelse>
      tot = -1;
    80002f64:	59fd                	li	s3,-1
  }
  return tot;
    80002f66:	0009851b          	sext.w	a0,s3
}
    80002f6a:	70a6                	ld	ra,104(sp)
    80002f6c:	7406                	ld	s0,96(sp)
    80002f6e:	64e6                	ld	s1,88(sp)
    80002f70:	6946                	ld	s2,80(sp)
    80002f72:	69a6                	ld	s3,72(sp)
    80002f74:	6a06                	ld	s4,64(sp)
    80002f76:	7ae2                	ld	s5,56(sp)
    80002f78:	7b42                	ld	s6,48(sp)
    80002f7a:	7ba2                	ld	s7,40(sp)
    80002f7c:	7c02                	ld	s8,32(sp)
    80002f7e:	6ce2                	ld	s9,24(sp)
    80002f80:	6d42                	ld	s10,16(sp)
    80002f82:	6da2                	ld	s11,8(sp)
    80002f84:	6165                	addi	sp,sp,112
    80002f86:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f88:	89da                	mv	s3,s6
    80002f8a:	bff1                	j	80002f66 <readi+0xce>
    return 0;
    80002f8c:	4501                	li	a0,0
}
    80002f8e:	8082                	ret

0000000080002f90 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f90:	457c                	lw	a5,76(a0)
    80002f92:	10d7e863          	bltu	a5,a3,800030a2 <writei+0x112>
{
    80002f96:	7159                	addi	sp,sp,-112
    80002f98:	f486                	sd	ra,104(sp)
    80002f9a:	f0a2                	sd	s0,96(sp)
    80002f9c:	eca6                	sd	s1,88(sp)
    80002f9e:	e8ca                	sd	s2,80(sp)
    80002fa0:	e4ce                	sd	s3,72(sp)
    80002fa2:	e0d2                	sd	s4,64(sp)
    80002fa4:	fc56                	sd	s5,56(sp)
    80002fa6:	f85a                	sd	s6,48(sp)
    80002fa8:	f45e                	sd	s7,40(sp)
    80002faa:	f062                	sd	s8,32(sp)
    80002fac:	ec66                	sd	s9,24(sp)
    80002fae:	e86a                	sd	s10,16(sp)
    80002fb0:	e46e                	sd	s11,8(sp)
    80002fb2:	1880                	addi	s0,sp,112
    80002fb4:	8b2a                	mv	s6,a0
    80002fb6:	8c2e                	mv	s8,a1
    80002fb8:	8ab2                	mv	s5,a2
    80002fba:	8936                	mv	s2,a3
    80002fbc:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fbe:	00e687bb          	addw	a5,a3,a4
    80002fc2:	0ed7e263          	bltu	a5,a3,800030a6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fc6:	00043737          	lui	a4,0x43
    80002fca:	0ef76063          	bltu	a4,a5,800030aa <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fce:	0c0b8863          	beqz	s7,8000309e <writei+0x10e>
    80002fd2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fd8:	5cfd                	li	s9,-1
    80002fda:	a091                	j	8000301e <writei+0x8e>
    80002fdc:	02099d93          	slli	s11,s3,0x20
    80002fe0:	020ddd93          	srli	s11,s11,0x20
    80002fe4:	05848513          	addi	a0,s1,88
    80002fe8:	86ee                	mv	a3,s11
    80002fea:	8656                	mv	a2,s5
    80002fec:	85e2                	mv	a1,s8
    80002fee:	953a                	add	a0,a0,a4
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	960080e7          	jalr	-1696(ra) # 80001950 <either_copyin>
    80002ff8:	07950263          	beq	a0,s9,8000305c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ffc:	8526                	mv	a0,s1
    80002ffe:	00000097          	auipc	ra,0x0
    80003002:	790080e7          	jalr	1936(ra) # 8000378e <log_write>
    brelse(bp);
    80003006:	8526                	mv	a0,s1
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	50a080e7          	jalr	1290(ra) # 80002512 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003010:	01498a3b          	addw	s4,s3,s4
    80003014:	0129893b          	addw	s2,s3,s2
    80003018:	9aee                	add	s5,s5,s11
    8000301a:	057a7663          	bgeu	s4,s7,80003066 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000301e:	000b2483          	lw	s1,0(s6)
    80003022:	00a9559b          	srliw	a1,s2,0xa
    80003026:	855a                	mv	a0,s6
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	7ae080e7          	jalr	1966(ra) # 800027d6 <bmap>
    80003030:	0005059b          	sext.w	a1,a0
    80003034:	8526                	mv	a0,s1
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	3ac080e7          	jalr	940(ra) # 800023e2 <bread>
    8000303e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003040:	3ff97713          	andi	a4,s2,1023
    80003044:	40ed07bb          	subw	a5,s10,a4
    80003048:	414b86bb          	subw	a3,s7,s4
    8000304c:	89be                	mv	s3,a5
    8000304e:	2781                	sext.w	a5,a5
    80003050:	0006861b          	sext.w	a2,a3
    80003054:	f8f674e3          	bgeu	a2,a5,80002fdc <writei+0x4c>
    80003058:	89b6                	mv	s3,a3
    8000305a:	b749                	j	80002fdc <writei+0x4c>
      brelse(bp);
    8000305c:	8526                	mv	a0,s1
    8000305e:	fffff097          	auipc	ra,0xfffff
    80003062:	4b4080e7          	jalr	1204(ra) # 80002512 <brelse>
  }

  if(off > ip->size)
    80003066:	04cb2783          	lw	a5,76(s6)
    8000306a:	0127f463          	bgeu	a5,s2,80003072 <writei+0xe2>
    ip->size = off;
    8000306e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003072:	855a                	mv	a0,s6
    80003074:	00000097          	auipc	ra,0x0
    80003078:	aa6080e7          	jalr	-1370(ra) # 80002b1a <iupdate>

  return tot;
    8000307c:	000a051b          	sext.w	a0,s4
}
    80003080:	70a6                	ld	ra,104(sp)
    80003082:	7406                	ld	s0,96(sp)
    80003084:	64e6                	ld	s1,88(sp)
    80003086:	6946                	ld	s2,80(sp)
    80003088:	69a6                	ld	s3,72(sp)
    8000308a:	6a06                	ld	s4,64(sp)
    8000308c:	7ae2                	ld	s5,56(sp)
    8000308e:	7b42                	ld	s6,48(sp)
    80003090:	7ba2                	ld	s7,40(sp)
    80003092:	7c02                	ld	s8,32(sp)
    80003094:	6ce2                	ld	s9,24(sp)
    80003096:	6d42                	ld	s10,16(sp)
    80003098:	6da2                	ld	s11,8(sp)
    8000309a:	6165                	addi	sp,sp,112
    8000309c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000309e:	8a5e                	mv	s4,s7
    800030a0:	bfc9                	j	80003072 <writei+0xe2>
    return -1;
    800030a2:	557d                	li	a0,-1
}
    800030a4:	8082                	ret
    return -1;
    800030a6:	557d                	li	a0,-1
    800030a8:	bfe1                	j	80003080 <writei+0xf0>
    return -1;
    800030aa:	557d                	li	a0,-1
    800030ac:	bfd1                	j	80003080 <writei+0xf0>

00000000800030ae <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030ae:	1141                	addi	sp,sp,-16
    800030b0:	e406                	sd	ra,8(sp)
    800030b2:	e022                	sd	s0,0(sp)
    800030b4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030b6:	4639                	li	a2,14
    800030b8:	ffffd097          	auipc	ra,0xffffd
    800030bc:	1e2080e7          	jalr	482(ra) # 8000029a <strncmp>
}
    800030c0:	60a2                	ld	ra,8(sp)
    800030c2:	6402                	ld	s0,0(sp)
    800030c4:	0141                	addi	sp,sp,16
    800030c6:	8082                	ret

00000000800030c8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030c8:	7139                	addi	sp,sp,-64
    800030ca:	fc06                	sd	ra,56(sp)
    800030cc:	f822                	sd	s0,48(sp)
    800030ce:	f426                	sd	s1,40(sp)
    800030d0:	f04a                	sd	s2,32(sp)
    800030d2:	ec4e                	sd	s3,24(sp)
    800030d4:	e852                	sd	s4,16(sp)
    800030d6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030d8:	04451703          	lh	a4,68(a0)
    800030dc:	4785                	li	a5,1
    800030de:	00f71a63          	bne	a4,a5,800030f2 <dirlookup+0x2a>
    800030e2:	892a                	mv	s2,a0
    800030e4:	89ae                	mv	s3,a1
    800030e6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e8:	457c                	lw	a5,76(a0)
    800030ea:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ec:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ee:	e79d                	bnez	a5,8000311c <dirlookup+0x54>
    800030f0:	a8a5                	j	80003168 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f2:	00005517          	auipc	a0,0x5
    800030f6:	55650513          	addi	a0,a0,1366 # 80008648 <syscalls+0x1b0>
    800030fa:	00003097          	auipc	ra,0x3
    800030fe:	b9e080e7          	jalr	-1122(ra) # 80005c98 <panic>
      panic("dirlookup read");
    80003102:	00005517          	auipc	a0,0x5
    80003106:	55e50513          	addi	a0,a0,1374 # 80008660 <syscalls+0x1c8>
    8000310a:	00003097          	auipc	ra,0x3
    8000310e:	b8e080e7          	jalr	-1138(ra) # 80005c98 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003112:	24c1                	addiw	s1,s1,16
    80003114:	04c92783          	lw	a5,76(s2)
    80003118:	04f4f763          	bgeu	s1,a5,80003166 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000311c:	4741                	li	a4,16
    8000311e:	86a6                	mv	a3,s1
    80003120:	fc040613          	addi	a2,s0,-64
    80003124:	4581                	li	a1,0
    80003126:	854a                	mv	a0,s2
    80003128:	00000097          	auipc	ra,0x0
    8000312c:	d70080e7          	jalr	-656(ra) # 80002e98 <readi>
    80003130:	47c1                	li	a5,16
    80003132:	fcf518e3          	bne	a0,a5,80003102 <dirlookup+0x3a>
    if(de.inum == 0)
    80003136:	fc045783          	lhu	a5,-64(s0)
    8000313a:	dfe1                	beqz	a5,80003112 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000313c:	fc240593          	addi	a1,s0,-62
    80003140:	854e                	mv	a0,s3
    80003142:	00000097          	auipc	ra,0x0
    80003146:	f6c080e7          	jalr	-148(ra) # 800030ae <namecmp>
    8000314a:	f561                	bnez	a0,80003112 <dirlookup+0x4a>
      if(poff)
    8000314c:	000a0463          	beqz	s4,80003154 <dirlookup+0x8c>
        *poff = off;
    80003150:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003154:	fc045583          	lhu	a1,-64(s0)
    80003158:	00092503          	lw	a0,0(s2)
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	754080e7          	jalr	1876(ra) # 800028b0 <iget>
    80003164:	a011                	j	80003168 <dirlookup+0xa0>
  return 0;
    80003166:	4501                	li	a0,0
}
    80003168:	70e2                	ld	ra,56(sp)
    8000316a:	7442                	ld	s0,48(sp)
    8000316c:	74a2                	ld	s1,40(sp)
    8000316e:	7902                	ld	s2,32(sp)
    80003170:	69e2                	ld	s3,24(sp)
    80003172:	6a42                	ld	s4,16(sp)
    80003174:	6121                	addi	sp,sp,64
    80003176:	8082                	ret

0000000080003178 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003178:	711d                	addi	sp,sp,-96
    8000317a:	ec86                	sd	ra,88(sp)
    8000317c:	e8a2                	sd	s0,80(sp)
    8000317e:	e4a6                	sd	s1,72(sp)
    80003180:	e0ca                	sd	s2,64(sp)
    80003182:	fc4e                	sd	s3,56(sp)
    80003184:	f852                	sd	s4,48(sp)
    80003186:	f456                	sd	s5,40(sp)
    80003188:	f05a                	sd	s6,32(sp)
    8000318a:	ec5e                	sd	s7,24(sp)
    8000318c:	e862                	sd	s8,16(sp)
    8000318e:	e466                	sd	s9,8(sp)
    80003190:	1080                	addi	s0,sp,96
    80003192:	84aa                	mv	s1,a0
    80003194:	8b2e                	mv	s6,a1
    80003196:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003198:	00054703          	lbu	a4,0(a0)
    8000319c:	02f00793          	li	a5,47
    800031a0:	02f70363          	beq	a4,a5,800031c6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a4:	ffffe097          	auipc	ra,0xffffe
    800031a8:	cee080e7          	jalr	-786(ra) # 80000e92 <myproc>
    800031ac:	15053503          	ld	a0,336(a0)
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	9f6080e7          	jalr	-1546(ra) # 80002ba6 <idup>
    800031b8:	89aa                	mv	s3,a0
  while(*path == '/')
    800031ba:	02f00913          	li	s2,47
  len = path - s;
    800031be:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031c0:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031c2:	4c05                	li	s8,1
    800031c4:	a865                	j	8000327c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031c6:	4585                	li	a1,1
    800031c8:	4505                	li	a0,1
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	6e6080e7          	jalr	1766(ra) # 800028b0 <iget>
    800031d2:	89aa                	mv	s3,a0
    800031d4:	b7dd                	j	800031ba <namex+0x42>
      iunlockput(ip);
    800031d6:	854e                	mv	a0,s3
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	c6e080e7          	jalr	-914(ra) # 80002e46 <iunlockput>
      return 0;
    800031e0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e2:	854e                	mv	a0,s3
    800031e4:	60e6                	ld	ra,88(sp)
    800031e6:	6446                	ld	s0,80(sp)
    800031e8:	64a6                	ld	s1,72(sp)
    800031ea:	6906                	ld	s2,64(sp)
    800031ec:	79e2                	ld	s3,56(sp)
    800031ee:	7a42                	ld	s4,48(sp)
    800031f0:	7aa2                	ld	s5,40(sp)
    800031f2:	7b02                	ld	s6,32(sp)
    800031f4:	6be2                	ld	s7,24(sp)
    800031f6:	6c42                	ld	s8,16(sp)
    800031f8:	6ca2                	ld	s9,8(sp)
    800031fa:	6125                	addi	sp,sp,96
    800031fc:	8082                	ret
      iunlock(ip);
    800031fe:	854e                	mv	a0,s3
    80003200:	00000097          	auipc	ra,0x0
    80003204:	aa6080e7          	jalr	-1370(ra) # 80002ca6 <iunlock>
      return ip;
    80003208:	bfe9                	j	800031e2 <namex+0x6a>
      iunlockput(ip);
    8000320a:	854e                	mv	a0,s3
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	c3a080e7          	jalr	-966(ra) # 80002e46 <iunlockput>
      return 0;
    80003214:	89d2                	mv	s3,s4
    80003216:	b7f1                	j	800031e2 <namex+0x6a>
  len = path - s;
    80003218:	40b48633          	sub	a2,s1,a1
    8000321c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003220:	094cd463          	bge	s9,s4,800032a8 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003224:	4639                	li	a2,14
    80003226:	8556                	mv	a0,s5
    80003228:	ffffd097          	auipc	ra,0xffffd
    8000322c:	ffa080e7          	jalr	-6(ra) # 80000222 <memmove>
  while(*path == '/')
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	01279763          	bne	a5,s2,80003242 <namex+0xca>
    path++;
    80003238:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	ff278de3          	beq	a5,s2,80003238 <namex+0xc0>
    ilock(ip);
    80003242:	854e                	mv	a0,s3
    80003244:	00000097          	auipc	ra,0x0
    80003248:	9a0080e7          	jalr	-1632(ra) # 80002be4 <ilock>
    if(ip->type != T_DIR){
    8000324c:	04499783          	lh	a5,68(s3)
    80003250:	f98793e3          	bne	a5,s8,800031d6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003254:	000b0563          	beqz	s6,8000325e <namex+0xe6>
    80003258:	0004c783          	lbu	a5,0(s1)
    8000325c:	d3cd                	beqz	a5,800031fe <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000325e:	865e                	mv	a2,s7
    80003260:	85d6                	mv	a1,s5
    80003262:	854e                	mv	a0,s3
    80003264:	00000097          	auipc	ra,0x0
    80003268:	e64080e7          	jalr	-412(ra) # 800030c8 <dirlookup>
    8000326c:	8a2a                	mv	s4,a0
    8000326e:	dd51                	beqz	a0,8000320a <namex+0x92>
    iunlockput(ip);
    80003270:	854e                	mv	a0,s3
    80003272:	00000097          	auipc	ra,0x0
    80003276:	bd4080e7          	jalr	-1068(ra) # 80002e46 <iunlockput>
    ip = next;
    8000327a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000327c:	0004c783          	lbu	a5,0(s1)
    80003280:	05279763          	bne	a5,s2,800032ce <namex+0x156>
    path++;
    80003284:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	ff278de3          	beq	a5,s2,80003284 <namex+0x10c>
  if(*path == 0)
    8000328e:	c79d                	beqz	a5,800032bc <namex+0x144>
    path++;
    80003290:	85a6                	mv	a1,s1
  len = path - s;
    80003292:	8a5e                	mv	s4,s7
    80003294:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003296:	01278963          	beq	a5,s2,800032a8 <namex+0x130>
    8000329a:	dfbd                	beqz	a5,80003218 <namex+0xa0>
    path++;
    8000329c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	ff279ce3          	bne	a5,s2,8000329a <namex+0x122>
    800032a6:	bf8d                	j	80003218 <namex+0xa0>
    memmove(name, s, len);
    800032a8:	2601                	sext.w	a2,a2
    800032aa:	8556                	mv	a0,s5
    800032ac:	ffffd097          	auipc	ra,0xffffd
    800032b0:	f76080e7          	jalr	-138(ra) # 80000222 <memmove>
    name[len] = 0;
    800032b4:	9a56                	add	s4,s4,s5
    800032b6:	000a0023          	sb	zero,0(s4)
    800032ba:	bf9d                	j	80003230 <namex+0xb8>
  if(nameiparent){
    800032bc:	f20b03e3          	beqz	s6,800031e2 <namex+0x6a>
    iput(ip);
    800032c0:	854e                	mv	a0,s3
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	adc080e7          	jalr	-1316(ra) # 80002d9e <iput>
    return 0;
    800032ca:	4981                	li	s3,0
    800032cc:	bf19                	j	800031e2 <namex+0x6a>
  if(*path == 0)
    800032ce:	d7fd                	beqz	a5,800032bc <namex+0x144>
  while(*path != '/' && *path != 0)
    800032d0:	0004c783          	lbu	a5,0(s1)
    800032d4:	85a6                	mv	a1,s1
    800032d6:	b7d1                	j	8000329a <namex+0x122>

00000000800032d8 <dirlink>:
{
    800032d8:	7139                	addi	sp,sp,-64
    800032da:	fc06                	sd	ra,56(sp)
    800032dc:	f822                	sd	s0,48(sp)
    800032de:	f426                	sd	s1,40(sp)
    800032e0:	f04a                	sd	s2,32(sp)
    800032e2:	ec4e                	sd	s3,24(sp)
    800032e4:	e852                	sd	s4,16(sp)
    800032e6:	0080                	addi	s0,sp,64
    800032e8:	892a                	mv	s2,a0
    800032ea:	8a2e                	mv	s4,a1
    800032ec:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ee:	4601                	li	a2,0
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	dd8080e7          	jalr	-552(ra) # 800030c8 <dirlookup>
    800032f8:	e93d                	bnez	a0,8000336e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fa:	04c92483          	lw	s1,76(s2)
    800032fe:	c49d                	beqz	s1,8000332c <dirlink+0x54>
    80003300:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003302:	4741                	li	a4,16
    80003304:	86a6                	mv	a3,s1
    80003306:	fc040613          	addi	a2,s0,-64
    8000330a:	4581                	li	a1,0
    8000330c:	854a                	mv	a0,s2
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	b8a080e7          	jalr	-1142(ra) # 80002e98 <readi>
    80003316:	47c1                	li	a5,16
    80003318:	06f51163          	bne	a0,a5,8000337a <dirlink+0xa2>
    if(de.inum == 0)
    8000331c:	fc045783          	lhu	a5,-64(s0)
    80003320:	c791                	beqz	a5,8000332c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003322:	24c1                	addiw	s1,s1,16
    80003324:	04c92783          	lw	a5,76(s2)
    80003328:	fcf4ede3          	bltu	s1,a5,80003302 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000332c:	4639                	li	a2,14
    8000332e:	85d2                	mv	a1,s4
    80003330:	fc240513          	addi	a0,s0,-62
    80003334:	ffffd097          	auipc	ra,0xffffd
    80003338:	fa2080e7          	jalr	-94(ra) # 800002d6 <strncpy>
  de.inum = inum;
    8000333c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003340:	4741                	li	a4,16
    80003342:	86a6                	mv	a3,s1
    80003344:	fc040613          	addi	a2,s0,-64
    80003348:	4581                	li	a1,0
    8000334a:	854a                	mv	a0,s2
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	c44080e7          	jalr	-956(ra) # 80002f90 <writei>
    80003354:	872a                	mv	a4,a0
    80003356:	47c1                	li	a5,16
  return 0;
    80003358:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335a:	02f71863          	bne	a4,a5,8000338a <dirlink+0xb2>
}
    8000335e:	70e2                	ld	ra,56(sp)
    80003360:	7442                	ld	s0,48(sp)
    80003362:	74a2                	ld	s1,40(sp)
    80003364:	7902                	ld	s2,32(sp)
    80003366:	69e2                	ld	s3,24(sp)
    80003368:	6a42                	ld	s4,16(sp)
    8000336a:	6121                	addi	sp,sp,64
    8000336c:	8082                	ret
    iput(ip);
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	a30080e7          	jalr	-1488(ra) # 80002d9e <iput>
    return -1;
    80003376:	557d                	li	a0,-1
    80003378:	b7dd                	j	8000335e <dirlink+0x86>
      panic("dirlink read");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	2f650513          	addi	a0,a0,758 # 80008670 <syscalls+0x1d8>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	916080e7          	jalr	-1770(ra) # 80005c98 <panic>
    panic("dirlink");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	3ee50513          	addi	a0,a0,1006 # 80008778 <syscalls+0x2e0>
    80003392:	00003097          	auipc	ra,0x3
    80003396:	906080e7          	jalr	-1786(ra) # 80005c98 <panic>

000000008000339a <namei>:

struct inode*
namei(char *path)
{
    8000339a:	1101                	addi	sp,sp,-32
    8000339c:	ec06                	sd	ra,24(sp)
    8000339e:	e822                	sd	s0,16(sp)
    800033a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a2:	fe040613          	addi	a2,s0,-32
    800033a6:	4581                	li	a1,0
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	dd0080e7          	jalr	-560(ra) # 80003178 <namex>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
    800033c0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c2:	4585                	li	a1,1
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	db4080e7          	jalr	-588(ra) # 80003178 <namex>
}
    800033cc:	60a2                	ld	ra,8(sp)
    800033ce:	6402                	ld	s0,0(sp)
    800033d0:	0141                	addi	sp,sp,16
    800033d2:	8082                	ret

00000000800033d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d4:	1101                	addi	sp,sp,-32
    800033d6:	ec06                	sd	ra,24(sp)
    800033d8:	e822                	sd	s0,16(sp)
    800033da:	e426                	sd	s1,8(sp)
    800033dc:	e04a                	sd	s2,0(sp)
    800033de:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e0:	00016917          	auipc	s2,0x16
    800033e4:	e4090913          	addi	s2,s2,-448 # 80019220 <log>
    800033e8:	01892583          	lw	a1,24(s2)
    800033ec:	02892503          	lw	a0,40(s2)
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	ff2080e7          	jalr	-14(ra) # 800023e2 <bread>
    800033f8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033fa:	02c92683          	lw	a3,44(s2)
    800033fe:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003400:	02d05763          	blez	a3,8000342e <write_head+0x5a>
    80003404:	00016797          	auipc	a5,0x16
    80003408:	e4c78793          	addi	a5,a5,-436 # 80019250 <log+0x30>
    8000340c:	05c50713          	addi	a4,a0,92
    80003410:	36fd                	addiw	a3,a3,-1
    80003412:	1682                	slli	a3,a3,0x20
    80003414:	9281                	srli	a3,a3,0x20
    80003416:	068a                	slli	a3,a3,0x2
    80003418:	00016617          	auipc	a2,0x16
    8000341c:	e3c60613          	addi	a2,a2,-452 # 80019254 <log+0x34>
    80003420:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003422:	4390                	lw	a2,0(a5)
    80003424:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003426:	0791                	addi	a5,a5,4
    80003428:	0711                	addi	a4,a4,4
    8000342a:	fed79ce3          	bne	a5,a3,80003422 <write_head+0x4e>
  }
  bwrite(buf);
    8000342e:	8526                	mv	a0,s1
    80003430:	fffff097          	auipc	ra,0xfffff
    80003434:	0a4080e7          	jalr	164(ra) # 800024d4 <bwrite>
  brelse(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	0d8080e7          	jalr	216(ra) # 80002512 <brelse>
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6902                	ld	s2,0(sp)
    8000344a:	6105                	addi	sp,sp,32
    8000344c:	8082                	ret

000000008000344e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344e:	00016797          	auipc	a5,0x16
    80003452:	dfe7a783          	lw	a5,-514(a5) # 8001924c <log+0x2c>
    80003456:	0af05d63          	blez	a5,80003510 <install_trans+0xc2>
{
    8000345a:	7139                	addi	sp,sp,-64
    8000345c:	fc06                	sd	ra,56(sp)
    8000345e:	f822                	sd	s0,48(sp)
    80003460:	f426                	sd	s1,40(sp)
    80003462:	f04a                	sd	s2,32(sp)
    80003464:	ec4e                	sd	s3,24(sp)
    80003466:	e852                	sd	s4,16(sp)
    80003468:	e456                	sd	s5,8(sp)
    8000346a:	e05a                	sd	s6,0(sp)
    8000346c:	0080                	addi	s0,sp,64
    8000346e:	8b2a                	mv	s6,a0
    80003470:	00016a97          	auipc	s5,0x16
    80003474:	de0a8a93          	addi	s5,s5,-544 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003478:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347a:	00016997          	auipc	s3,0x16
    8000347e:	da698993          	addi	s3,s3,-602 # 80019220 <log>
    80003482:	a035                	j	800034ae <install_trans+0x60>
      bunpin(dbuf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	166080e7          	jalr	358(ra) # 800025ec <bunpin>
    brelse(lbuf);
    8000348e:	854a                	mv	a0,s2
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	082080e7          	jalr	130(ra) # 80002512 <brelse>
    brelse(dbuf);
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	078080e7          	jalr	120(ra) # 80002512 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a2:	2a05                	addiw	s4,s4,1
    800034a4:	0a91                	addi	s5,s5,4
    800034a6:	02c9a783          	lw	a5,44(s3)
    800034aa:	04fa5963          	bge	s4,a5,800034fc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ae:	0189a583          	lw	a1,24(s3)
    800034b2:	014585bb          	addw	a1,a1,s4
    800034b6:	2585                	addiw	a1,a1,1
    800034b8:	0289a503          	lw	a0,40(s3)
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	f26080e7          	jalr	-218(ra) # 800023e2 <bread>
    800034c4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c6:	000aa583          	lw	a1,0(s5)
    800034ca:	0289a503          	lw	a0,40(s3)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f14080e7          	jalr	-236(ra) # 800023e2 <bread>
    800034d6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d8:	40000613          	li	a2,1024
    800034dc:	05890593          	addi	a1,s2,88
    800034e0:	05850513          	addi	a0,a0,88
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	d3e080e7          	jalr	-706(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	fe6080e7          	jalr	-26(ra) # 800024d4 <bwrite>
    if(recovering == 0)
    800034f6:	f80b1ce3          	bnez	s6,8000348e <install_trans+0x40>
    800034fa:	b769                	j	80003484 <install_trans+0x36>
}
    800034fc:	70e2                	ld	ra,56(sp)
    800034fe:	7442                	ld	s0,48(sp)
    80003500:	74a2                	ld	s1,40(sp)
    80003502:	7902                	ld	s2,32(sp)
    80003504:	69e2                	ld	s3,24(sp)
    80003506:	6a42                	ld	s4,16(sp)
    80003508:	6aa2                	ld	s5,8(sp)
    8000350a:	6b02                	ld	s6,0(sp)
    8000350c:	6121                	addi	sp,sp,64
    8000350e:	8082                	ret
    80003510:	8082                	ret

0000000080003512 <initlog>:
{
    80003512:	7179                	addi	sp,sp,-48
    80003514:	f406                	sd	ra,40(sp)
    80003516:	f022                	sd	s0,32(sp)
    80003518:	ec26                	sd	s1,24(sp)
    8000351a:	e84a                	sd	s2,16(sp)
    8000351c:	e44e                	sd	s3,8(sp)
    8000351e:	1800                	addi	s0,sp,48
    80003520:	892a                	mv	s2,a0
    80003522:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003524:	00016497          	auipc	s1,0x16
    80003528:	cfc48493          	addi	s1,s1,-772 # 80019220 <log>
    8000352c:	00005597          	auipc	a1,0x5
    80003530:	15458593          	addi	a1,a1,340 # 80008680 <syscalls+0x1e8>
    80003534:	8526                	mv	a0,s1
    80003536:	00003097          	auipc	ra,0x3
    8000353a:	c1c080e7          	jalr	-996(ra) # 80006152 <initlock>
  log.start = sb->logstart;
    8000353e:	0149a583          	lw	a1,20(s3)
    80003542:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003544:	0109a783          	lw	a5,16(s3)
    80003548:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000354a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000354e:	854a                	mv	a0,s2
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	e92080e7          	jalr	-366(ra) # 800023e2 <bread>
  log.lh.n = lh->n;
    80003558:	4d3c                	lw	a5,88(a0)
    8000355a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000355c:	02f05563          	blez	a5,80003586 <initlog+0x74>
    80003560:	05c50713          	addi	a4,a0,92
    80003564:	00016697          	auipc	a3,0x16
    80003568:	cec68693          	addi	a3,a3,-788 # 80019250 <log+0x30>
    8000356c:	37fd                	addiw	a5,a5,-1
    8000356e:	1782                	slli	a5,a5,0x20
    80003570:	9381                	srli	a5,a5,0x20
    80003572:	078a                	slli	a5,a5,0x2
    80003574:	06050613          	addi	a2,a0,96
    80003578:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000357a:	4310                	lw	a2,0(a4)
    8000357c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000357e:	0711                	addi	a4,a4,4
    80003580:	0691                	addi	a3,a3,4
    80003582:	fef71ce3          	bne	a4,a5,8000357a <initlog+0x68>
  brelse(buf);
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	f8c080e7          	jalr	-116(ra) # 80002512 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358e:	4505                	li	a0,1
    80003590:	00000097          	auipc	ra,0x0
    80003594:	ebe080e7          	jalr	-322(ra) # 8000344e <install_trans>
  log.lh.n = 0;
    80003598:	00016797          	auipc	a5,0x16
    8000359c:	ca07aa23          	sw	zero,-844(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	e34080e7          	jalr	-460(ra) # 800033d4 <write_head>
}
    800035a8:	70a2                	ld	ra,40(sp)
    800035aa:	7402                	ld	s0,32(sp)
    800035ac:	64e2                	ld	s1,24(sp)
    800035ae:	6942                	ld	s2,16(sp)
    800035b0:	69a2                	ld	s3,8(sp)
    800035b2:	6145                	addi	sp,sp,48
    800035b4:	8082                	ret

00000000800035b6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	e04a                	sd	s2,0(sp)
    800035c0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c2:	00016517          	auipc	a0,0x16
    800035c6:	c5e50513          	addi	a0,a0,-930 # 80019220 <log>
    800035ca:	00003097          	auipc	ra,0x3
    800035ce:	c18080e7          	jalr	-1000(ra) # 800061e2 <acquire>
  while(1){
    if(log.committing){
    800035d2:	00016497          	auipc	s1,0x16
    800035d6:	c4e48493          	addi	s1,s1,-946 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035da:	4979                	li	s2,30
    800035dc:	a039                	j	800035ea <begin_op+0x34>
      sleep(&log, &log.lock);
    800035de:	85a6                	mv	a1,s1
    800035e0:	8526                	mv	a0,s1
    800035e2:	ffffe097          	auipc	ra,0xffffe
    800035e6:	f74080e7          	jalr	-140(ra) # 80001556 <sleep>
    if(log.committing){
    800035ea:	50dc                	lw	a5,36(s1)
    800035ec:	fbed                	bnez	a5,800035de <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ee:	509c                	lw	a5,32(s1)
    800035f0:	0017871b          	addiw	a4,a5,1
    800035f4:	0007069b          	sext.w	a3,a4
    800035f8:	0027179b          	slliw	a5,a4,0x2
    800035fc:	9fb9                	addw	a5,a5,a4
    800035fe:	0017979b          	slliw	a5,a5,0x1
    80003602:	54d8                	lw	a4,44(s1)
    80003604:	9fb9                	addw	a5,a5,a4
    80003606:	00f95963          	bge	s2,a5,80003618 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000360a:	85a6                	mv	a1,s1
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	f48080e7          	jalr	-184(ra) # 80001556 <sleep>
    80003616:	bfd1                	j	800035ea <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003618:	00016517          	auipc	a0,0x16
    8000361c:	c0850513          	addi	a0,a0,-1016 # 80019220 <log>
    80003620:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003622:	00003097          	auipc	ra,0x3
    80003626:	c74080e7          	jalr	-908(ra) # 80006296 <release>
      break;
    }
  }
}
    8000362a:	60e2                	ld	ra,24(sp)
    8000362c:	6442                	ld	s0,16(sp)
    8000362e:	64a2                	ld	s1,8(sp)
    80003630:	6902                	ld	s2,0(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003636:	7139                	addi	sp,sp,-64
    80003638:	fc06                	sd	ra,56(sp)
    8000363a:	f822                	sd	s0,48(sp)
    8000363c:	f426                	sd	s1,40(sp)
    8000363e:	f04a                	sd	s2,32(sp)
    80003640:	ec4e                	sd	s3,24(sp)
    80003642:	e852                	sd	s4,16(sp)
    80003644:	e456                	sd	s5,8(sp)
    80003646:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003648:	00016497          	auipc	s1,0x16
    8000364c:	bd848493          	addi	s1,s1,-1064 # 80019220 <log>
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	b90080e7          	jalr	-1136(ra) # 800061e2 <acquire>
  log.outstanding -= 1;
    8000365a:	509c                	lw	a5,32(s1)
    8000365c:	37fd                	addiw	a5,a5,-1
    8000365e:	0007891b          	sext.w	s2,a5
    80003662:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003664:	50dc                	lw	a5,36(s1)
    80003666:	efb9                	bnez	a5,800036c4 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003668:	06091663          	bnez	s2,800036d4 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000366c:	00016497          	auipc	s1,0x16
    80003670:	bb448493          	addi	s1,s1,-1100 # 80019220 <log>
    80003674:	4785                	li	a5,1
    80003676:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	c1c080e7          	jalr	-996(ra) # 80006296 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003682:	54dc                	lw	a5,44(s1)
    80003684:	06f04763          	bgtz	a5,800036f2 <end_op+0xbc>
    acquire(&log.lock);
    80003688:	00016497          	auipc	s1,0x16
    8000368c:	b9848493          	addi	s1,s1,-1128 # 80019220 <log>
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	b50080e7          	jalr	-1200(ra) # 800061e2 <acquire>
    log.committing = 0;
    8000369a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000369e:	8526                	mv	a0,s1
    800036a0:	ffffe097          	auipc	ra,0xffffe
    800036a4:	042080e7          	jalr	66(ra) # 800016e2 <wakeup>
    release(&log.lock);
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	bec080e7          	jalr	-1044(ra) # 80006296 <release>
}
    800036b2:	70e2                	ld	ra,56(sp)
    800036b4:	7442                	ld	s0,48(sp)
    800036b6:	74a2                	ld	s1,40(sp)
    800036b8:	7902                	ld	s2,32(sp)
    800036ba:	69e2                	ld	s3,24(sp)
    800036bc:	6a42                	ld	s4,16(sp)
    800036be:	6aa2                	ld	s5,8(sp)
    800036c0:	6121                	addi	sp,sp,64
    800036c2:	8082                	ret
    panic("log.committing");
    800036c4:	00005517          	auipc	a0,0x5
    800036c8:	fc450513          	addi	a0,a0,-60 # 80008688 <syscalls+0x1f0>
    800036cc:	00002097          	auipc	ra,0x2
    800036d0:	5cc080e7          	jalr	1484(ra) # 80005c98 <panic>
    wakeup(&log);
    800036d4:	00016497          	auipc	s1,0x16
    800036d8:	b4c48493          	addi	s1,s1,-1204 # 80019220 <log>
    800036dc:	8526                	mv	a0,s1
    800036de:	ffffe097          	auipc	ra,0xffffe
    800036e2:	004080e7          	jalr	4(ra) # 800016e2 <wakeup>
  release(&log.lock);
    800036e6:	8526                	mv	a0,s1
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	bae080e7          	jalr	-1106(ra) # 80006296 <release>
  if(do_commit){
    800036f0:	b7c9                	j	800036b2 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f2:	00016a97          	auipc	s5,0x16
    800036f6:	b5ea8a93          	addi	s5,s5,-1186 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036fa:	00016a17          	auipc	s4,0x16
    800036fe:	b26a0a13          	addi	s4,s4,-1242 # 80019220 <log>
    80003702:	018a2583          	lw	a1,24(s4)
    80003706:	012585bb          	addw	a1,a1,s2
    8000370a:	2585                	addiw	a1,a1,1
    8000370c:	028a2503          	lw	a0,40(s4)
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	cd2080e7          	jalr	-814(ra) # 800023e2 <bread>
    80003718:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000371a:	000aa583          	lw	a1,0(s5)
    8000371e:	028a2503          	lw	a0,40(s4)
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	cc0080e7          	jalr	-832(ra) # 800023e2 <bread>
    8000372a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000372c:	40000613          	li	a2,1024
    80003730:	05850593          	addi	a1,a0,88
    80003734:	05848513          	addi	a0,s1,88
    80003738:	ffffd097          	auipc	ra,0xffffd
    8000373c:	aea080e7          	jalr	-1302(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    80003740:	8526                	mv	a0,s1
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	d92080e7          	jalr	-622(ra) # 800024d4 <bwrite>
    brelse(from);
    8000374a:	854e                	mv	a0,s3
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	dc6080e7          	jalr	-570(ra) # 80002512 <brelse>
    brelse(to);
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dbc080e7          	jalr	-580(ra) # 80002512 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375e:	2905                	addiw	s2,s2,1
    80003760:	0a91                	addi	s5,s5,4
    80003762:	02ca2783          	lw	a5,44(s4)
    80003766:	f8f94ee3          	blt	s2,a5,80003702 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	c6a080e7          	jalr	-918(ra) # 800033d4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003772:	4501                	li	a0,0
    80003774:	00000097          	auipc	ra,0x0
    80003778:	cda080e7          	jalr	-806(ra) # 8000344e <install_trans>
    log.lh.n = 0;
    8000377c:	00016797          	auipc	a5,0x16
    80003780:	ac07a823          	sw	zero,-1328(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003784:	00000097          	auipc	ra,0x0
    80003788:	c50080e7          	jalr	-944(ra) # 800033d4 <write_head>
    8000378c:	bdf5                	j	80003688 <end_op+0x52>

000000008000378e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000378e:	1101                	addi	sp,sp,-32
    80003790:	ec06                	sd	ra,24(sp)
    80003792:	e822                	sd	s0,16(sp)
    80003794:	e426                	sd	s1,8(sp)
    80003796:	e04a                	sd	s2,0(sp)
    80003798:	1000                	addi	s0,sp,32
    8000379a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000379c:	00016917          	auipc	s2,0x16
    800037a0:	a8490913          	addi	s2,s2,-1404 # 80019220 <log>
    800037a4:	854a                	mv	a0,s2
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	a3c080e7          	jalr	-1476(ra) # 800061e2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ae:	02c92603          	lw	a2,44(s2)
    800037b2:	47f5                	li	a5,29
    800037b4:	06c7c563          	blt	a5,a2,8000381e <log_write+0x90>
    800037b8:	00016797          	auipc	a5,0x16
    800037bc:	a847a783          	lw	a5,-1404(a5) # 8001923c <log+0x1c>
    800037c0:	37fd                	addiw	a5,a5,-1
    800037c2:	04f65e63          	bge	a2,a5,8000381e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037c6:	00016797          	auipc	a5,0x16
    800037ca:	a7a7a783          	lw	a5,-1414(a5) # 80019240 <log+0x20>
    800037ce:	06f05063          	blez	a5,8000382e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d2:	4781                	li	a5,0
    800037d4:	06c05563          	blez	a2,8000383e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d8:	44cc                	lw	a1,12(s1)
    800037da:	00016717          	auipc	a4,0x16
    800037de:	a7670713          	addi	a4,a4,-1418 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e4:	4314                	lw	a3,0(a4)
    800037e6:	04b68c63          	beq	a3,a1,8000383e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ea:	2785                	addiw	a5,a5,1
    800037ec:	0711                	addi	a4,a4,4
    800037ee:	fef61be3          	bne	a2,a5,800037e4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f2:	0621                	addi	a2,a2,8
    800037f4:	060a                	slli	a2,a2,0x2
    800037f6:	00016797          	auipc	a5,0x16
    800037fa:	a2a78793          	addi	a5,a5,-1494 # 80019220 <log>
    800037fe:	963e                	add	a2,a2,a5
    80003800:	44dc                	lw	a5,12(s1)
    80003802:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003804:	8526                	mv	a0,s1
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	daa080e7          	jalr	-598(ra) # 800025b0 <bpin>
    log.lh.n++;
    8000380e:	00016717          	auipc	a4,0x16
    80003812:	a1270713          	addi	a4,a4,-1518 # 80019220 <log>
    80003816:	575c                	lw	a5,44(a4)
    80003818:	2785                	addiw	a5,a5,1
    8000381a:	d75c                	sw	a5,44(a4)
    8000381c:	a835                	j	80003858 <log_write+0xca>
    panic("too big a transaction");
    8000381e:	00005517          	auipc	a0,0x5
    80003822:	e7a50513          	addi	a0,a0,-390 # 80008698 <syscalls+0x200>
    80003826:	00002097          	auipc	ra,0x2
    8000382a:	472080e7          	jalr	1138(ra) # 80005c98 <panic>
    panic("log_write outside of trans");
    8000382e:	00005517          	auipc	a0,0x5
    80003832:	e8250513          	addi	a0,a0,-382 # 800086b0 <syscalls+0x218>
    80003836:	00002097          	auipc	ra,0x2
    8000383a:	462080e7          	jalr	1122(ra) # 80005c98 <panic>
  log.lh.block[i] = b->blockno;
    8000383e:	00878713          	addi	a4,a5,8
    80003842:	00271693          	slli	a3,a4,0x2
    80003846:	00016717          	auipc	a4,0x16
    8000384a:	9da70713          	addi	a4,a4,-1574 # 80019220 <log>
    8000384e:	9736                	add	a4,a4,a3
    80003850:	44d4                	lw	a3,12(s1)
    80003852:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003854:	faf608e3          	beq	a2,a5,80003804 <log_write+0x76>
  }
  release(&log.lock);
    80003858:	00016517          	auipc	a0,0x16
    8000385c:	9c850513          	addi	a0,a0,-1592 # 80019220 <log>
    80003860:	00003097          	auipc	ra,0x3
    80003864:	a36080e7          	jalr	-1482(ra) # 80006296 <release>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6902                	ld	s2,0(sp)
    80003870:	6105                	addi	sp,sp,32
    80003872:	8082                	ret

0000000080003874 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003874:	1101                	addi	sp,sp,-32
    80003876:	ec06                	sd	ra,24(sp)
    80003878:	e822                	sd	s0,16(sp)
    8000387a:	e426                	sd	s1,8(sp)
    8000387c:	e04a                	sd	s2,0(sp)
    8000387e:	1000                	addi	s0,sp,32
    80003880:	84aa                	mv	s1,a0
    80003882:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003884:	00005597          	auipc	a1,0x5
    80003888:	e4c58593          	addi	a1,a1,-436 # 800086d0 <syscalls+0x238>
    8000388c:	0521                	addi	a0,a0,8
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	8c4080e7          	jalr	-1852(ra) # 80006152 <initlock>
  lk->name = name;
    80003896:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000389a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000389e:	0204a423          	sw	zero,40(s1)
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	e04a                	sd	s2,0(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038bc:	00850913          	addi	s2,a0,8
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	920080e7          	jalr	-1760(ra) # 800061e2 <acquire>
  while (lk->locked) {
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	cb89                	beqz	a5,800038de <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ce:	85ca                	mv	a1,s2
    800038d0:	8526                	mv	a0,s1
    800038d2:	ffffe097          	auipc	ra,0xffffe
    800038d6:	c84080e7          	jalr	-892(ra) # 80001556 <sleep>
  while (lk->locked) {
    800038da:	409c                	lw	a5,0(s1)
    800038dc:	fbed                	bnez	a5,800038ce <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038de:	4785                	li	a5,1
    800038e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e2:	ffffd097          	auipc	ra,0xffffd
    800038e6:	5b0080e7          	jalr	1456(ra) # 80000e92 <myproc>
    800038ea:	591c                	lw	a5,48(a0)
    800038ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	9a6080e7          	jalr	-1626(ra) # 80006296 <release>
}
    800038f8:	60e2                	ld	ra,24(sp)
    800038fa:	6442                	ld	s0,16(sp)
    800038fc:	64a2                	ld	s1,8(sp)
    800038fe:	6902                	ld	s2,0(sp)
    80003900:	6105                	addi	sp,sp,32
    80003902:	8082                	ret

0000000080003904 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003904:	1101                	addi	sp,sp,-32
    80003906:	ec06                	sd	ra,24(sp)
    80003908:	e822                	sd	s0,16(sp)
    8000390a:	e426                	sd	s1,8(sp)
    8000390c:	e04a                	sd	s2,0(sp)
    8000390e:	1000                	addi	s0,sp,32
    80003910:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003912:	00850913          	addi	s2,a0,8
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	8ca080e7          	jalr	-1846(ra) # 800061e2 <acquire>
  lk->locked = 0;
    80003920:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003924:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003928:	8526                	mv	a0,s1
    8000392a:	ffffe097          	auipc	ra,0xffffe
    8000392e:	db8080e7          	jalr	-584(ra) # 800016e2 <wakeup>
  release(&lk->lk);
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	962080e7          	jalr	-1694(ra) # 80006296 <release>
}
    8000393c:	60e2                	ld	ra,24(sp)
    8000393e:	6442                	ld	s0,16(sp)
    80003940:	64a2                	ld	s1,8(sp)
    80003942:	6902                	ld	s2,0(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003948:	7179                	addi	sp,sp,-48
    8000394a:	f406                	sd	ra,40(sp)
    8000394c:	f022                	sd	s0,32(sp)
    8000394e:	ec26                	sd	s1,24(sp)
    80003950:	e84a                	sd	s2,16(sp)
    80003952:	e44e                	sd	s3,8(sp)
    80003954:	1800                	addi	s0,sp,48
    80003956:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003958:	00850913          	addi	s2,a0,8
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	884080e7          	jalr	-1916(ra) # 800061e2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003966:	409c                	lw	a5,0(s1)
    80003968:	ef99                	bnez	a5,80003986 <holdingsleep+0x3e>
    8000396a:	4481                	li	s1,0
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	928080e7          	jalr	-1752(ra) # 80006296 <release>
  return r;
}
    80003976:	8526                	mv	a0,s1
    80003978:	70a2                	ld	ra,40(sp)
    8000397a:	7402                	ld	s0,32(sp)
    8000397c:	64e2                	ld	s1,24(sp)
    8000397e:	6942                	ld	s2,16(sp)
    80003980:	69a2                	ld	s3,8(sp)
    80003982:	6145                	addi	sp,sp,48
    80003984:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003986:	0284a983          	lw	s3,40(s1)
    8000398a:	ffffd097          	auipc	ra,0xffffd
    8000398e:	508080e7          	jalr	1288(ra) # 80000e92 <myproc>
    80003992:	5904                	lw	s1,48(a0)
    80003994:	413484b3          	sub	s1,s1,s3
    80003998:	0014b493          	seqz	s1,s1
    8000399c:	bfc1                	j	8000396c <holdingsleep+0x24>

000000008000399e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000399e:	1141                	addi	sp,sp,-16
    800039a0:	e406                	sd	ra,8(sp)
    800039a2:	e022                	sd	s0,0(sp)
    800039a4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a6:	00005597          	auipc	a1,0x5
    800039aa:	d3a58593          	addi	a1,a1,-710 # 800086e0 <syscalls+0x248>
    800039ae:	00016517          	auipc	a0,0x16
    800039b2:	9ba50513          	addi	a0,a0,-1606 # 80019368 <ftable>
    800039b6:	00002097          	auipc	ra,0x2
    800039ba:	79c080e7          	jalr	1948(ra) # 80006152 <initlock>
}
    800039be:	60a2                	ld	ra,8(sp)
    800039c0:	6402                	ld	s0,0(sp)
    800039c2:	0141                	addi	sp,sp,16
    800039c4:	8082                	ret

00000000800039c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c6:	1101                	addi	sp,sp,-32
    800039c8:	ec06                	sd	ra,24(sp)
    800039ca:	e822                	sd	s0,16(sp)
    800039cc:	e426                	sd	s1,8(sp)
    800039ce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d0:	00016517          	auipc	a0,0x16
    800039d4:	99850513          	addi	a0,a0,-1640 # 80019368 <ftable>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	80a080e7          	jalr	-2038(ra) # 800061e2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e0:	00016497          	auipc	s1,0x16
    800039e4:	9a048493          	addi	s1,s1,-1632 # 80019380 <ftable+0x18>
    800039e8:	00017717          	auipc	a4,0x17
    800039ec:	93870713          	addi	a4,a4,-1736 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039f0:	40dc                	lw	a5,4(s1)
    800039f2:	cf99                	beqz	a5,80003a10 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f4:	02848493          	addi	s1,s1,40
    800039f8:	fee49ce3          	bne	s1,a4,800039f0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039fc:	00016517          	auipc	a0,0x16
    80003a00:	96c50513          	addi	a0,a0,-1684 # 80019368 <ftable>
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	892080e7          	jalr	-1902(ra) # 80006296 <release>
  return 0;
    80003a0c:	4481                	li	s1,0
    80003a0e:	a819                	j	80003a24 <filealloc+0x5e>
      f->ref = 1;
    80003a10:	4785                	li	a5,1
    80003a12:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a14:	00016517          	auipc	a0,0x16
    80003a18:	95450513          	addi	a0,a0,-1708 # 80019368 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	87a080e7          	jalr	-1926(ra) # 80006296 <release>
}
    80003a24:	8526                	mv	a0,s1
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6105                	addi	sp,sp,32
    80003a2e:	8082                	ret

0000000080003a30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	1000                	addi	s0,sp,32
    80003a3a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a3c:	00016517          	auipc	a0,0x16
    80003a40:	92c50513          	addi	a0,a0,-1748 # 80019368 <ftable>
    80003a44:	00002097          	auipc	ra,0x2
    80003a48:	79e080e7          	jalr	1950(ra) # 800061e2 <acquire>
  if(f->ref < 1)
    80003a4c:	40dc                	lw	a5,4(s1)
    80003a4e:	02f05263          	blez	a5,80003a72 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a52:	2785                	addiw	a5,a5,1
    80003a54:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a56:	00016517          	auipc	a0,0x16
    80003a5a:	91250513          	addi	a0,a0,-1774 # 80019368 <ftable>
    80003a5e:	00003097          	auipc	ra,0x3
    80003a62:	838080e7          	jalr	-1992(ra) # 80006296 <release>
  return f;
}
    80003a66:	8526                	mv	a0,s1
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6105                	addi	sp,sp,32
    80003a70:	8082                	ret
    panic("filedup");
    80003a72:	00005517          	auipc	a0,0x5
    80003a76:	c7650513          	addi	a0,a0,-906 # 800086e8 <syscalls+0x250>
    80003a7a:	00002097          	auipc	ra,0x2
    80003a7e:	21e080e7          	jalr	542(ra) # 80005c98 <panic>

0000000080003a82 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a82:	7139                	addi	sp,sp,-64
    80003a84:	fc06                	sd	ra,56(sp)
    80003a86:	f822                	sd	s0,48(sp)
    80003a88:	f426                	sd	s1,40(sp)
    80003a8a:	f04a                	sd	s2,32(sp)
    80003a8c:	ec4e                	sd	s3,24(sp)
    80003a8e:	e852                	sd	s4,16(sp)
    80003a90:	e456                	sd	s5,8(sp)
    80003a92:	0080                	addi	s0,sp,64
    80003a94:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a96:	00016517          	auipc	a0,0x16
    80003a9a:	8d250513          	addi	a0,a0,-1838 # 80019368 <ftable>
    80003a9e:	00002097          	auipc	ra,0x2
    80003aa2:	744080e7          	jalr	1860(ra) # 800061e2 <acquire>
  if(f->ref < 1)
    80003aa6:	40dc                	lw	a5,4(s1)
    80003aa8:	06f05163          	blez	a5,80003b0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aac:	37fd                	addiw	a5,a5,-1
    80003aae:	0007871b          	sext.w	a4,a5
    80003ab2:	c0dc                	sw	a5,4(s1)
    80003ab4:	06e04363          	bgtz	a4,80003b1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab8:	0004a903          	lw	s2,0(s1)
    80003abc:	0094ca83          	lbu	s5,9(s1)
    80003ac0:	0104ba03          	ld	s4,16(s1)
    80003ac4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ac8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003acc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad0:	00016517          	auipc	a0,0x16
    80003ad4:	89850513          	addi	a0,a0,-1896 # 80019368 <ftable>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	7be080e7          	jalr	1982(ra) # 80006296 <release>

  if(ff.type == FD_PIPE){
    80003ae0:	4785                	li	a5,1
    80003ae2:	04f90d63          	beq	s2,a5,80003b3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae6:	3979                	addiw	s2,s2,-2
    80003ae8:	4785                	li	a5,1
    80003aea:	0527e063          	bltu	a5,s2,80003b2a <fileclose+0xa8>
    begin_op();
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	ac8080e7          	jalr	-1336(ra) # 800035b6 <begin_op>
    iput(ff.ip);
    80003af6:	854e                	mv	a0,s3
    80003af8:	fffff097          	auipc	ra,0xfffff
    80003afc:	2a6080e7          	jalr	678(ra) # 80002d9e <iput>
    end_op();
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	b36080e7          	jalr	-1226(ra) # 80003636 <end_op>
    80003b08:	a00d                	j	80003b2a <fileclose+0xa8>
    panic("fileclose");
    80003b0a:	00005517          	auipc	a0,0x5
    80003b0e:	be650513          	addi	a0,a0,-1050 # 800086f0 <syscalls+0x258>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	186080e7          	jalr	390(ra) # 80005c98 <panic>
    release(&ftable.lock);
    80003b1a:	00016517          	auipc	a0,0x16
    80003b1e:	84e50513          	addi	a0,a0,-1970 # 80019368 <ftable>
    80003b22:	00002097          	auipc	ra,0x2
    80003b26:	774080e7          	jalr	1908(ra) # 80006296 <release>
  }
}
    80003b2a:	70e2                	ld	ra,56(sp)
    80003b2c:	7442                	ld	s0,48(sp)
    80003b2e:	74a2                	ld	s1,40(sp)
    80003b30:	7902                	ld	s2,32(sp)
    80003b32:	69e2                	ld	s3,24(sp)
    80003b34:	6a42                	ld	s4,16(sp)
    80003b36:	6aa2                	ld	s5,8(sp)
    80003b38:	6121                	addi	sp,sp,64
    80003b3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b3c:	85d6                	mv	a1,s5
    80003b3e:	8552                	mv	a0,s4
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	34c080e7          	jalr	844(ra) # 80003e8c <pipeclose>
    80003b48:	b7cd                	j	80003b2a <fileclose+0xa8>

0000000080003b4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b4a:	715d                	addi	sp,sp,-80
    80003b4c:	e486                	sd	ra,72(sp)
    80003b4e:	e0a2                	sd	s0,64(sp)
    80003b50:	fc26                	sd	s1,56(sp)
    80003b52:	f84a                	sd	s2,48(sp)
    80003b54:	f44e                	sd	s3,40(sp)
    80003b56:	0880                	addi	s0,sp,80
    80003b58:	84aa                	mv	s1,a0
    80003b5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b5c:	ffffd097          	auipc	ra,0xffffd
    80003b60:	336080e7          	jalr	822(ra) # 80000e92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b64:	409c                	lw	a5,0(s1)
    80003b66:	37f9                	addiw	a5,a5,-2
    80003b68:	4705                	li	a4,1
    80003b6a:	04f76763          	bltu	a4,a5,80003bb8 <filestat+0x6e>
    80003b6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b70:	6c88                	ld	a0,24(s1)
    80003b72:	fffff097          	auipc	ra,0xfffff
    80003b76:	072080e7          	jalr	114(ra) # 80002be4 <ilock>
    stati(f->ip, &st);
    80003b7a:	fb840593          	addi	a1,s0,-72
    80003b7e:	6c88                	ld	a0,24(s1)
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	2ee080e7          	jalr	750(ra) # 80002e6e <stati>
    iunlock(f->ip);
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	11c080e7          	jalr	284(ra) # 80002ca6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b92:	46e1                	li	a3,24
    80003b94:	fb840613          	addi	a2,s0,-72
    80003b98:	85ce                	mv	a1,s3
    80003b9a:	05093503          	ld	a0,80(s2)
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	fb6080e7          	jalr	-74(ra) # 80000b54 <copyout>
    80003ba6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003baa:	60a6                	ld	ra,72(sp)
    80003bac:	6406                	ld	s0,64(sp)
    80003bae:	74e2                	ld	s1,56(sp)
    80003bb0:	7942                	ld	s2,48(sp)
    80003bb2:	79a2                	ld	s3,40(sp)
    80003bb4:	6161                	addi	sp,sp,80
    80003bb6:	8082                	ret
  return -1;
    80003bb8:	557d                	li	a0,-1
    80003bba:	bfc5                	j	80003baa <filestat+0x60>

0000000080003bbc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bbc:	7179                	addi	sp,sp,-48
    80003bbe:	f406                	sd	ra,40(sp)
    80003bc0:	f022                	sd	s0,32(sp)
    80003bc2:	ec26                	sd	s1,24(sp)
    80003bc4:	e84a                	sd	s2,16(sp)
    80003bc6:	e44e                	sd	s3,8(sp)
    80003bc8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bca:	00854783          	lbu	a5,8(a0)
    80003bce:	c3d5                	beqz	a5,80003c72 <fileread+0xb6>
    80003bd0:	84aa                	mv	s1,a0
    80003bd2:	89ae                	mv	s3,a1
    80003bd4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd6:	411c                	lw	a5,0(a0)
    80003bd8:	4705                	li	a4,1
    80003bda:	04e78963          	beq	a5,a4,80003c2c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bde:	470d                	li	a4,3
    80003be0:	04e78d63          	beq	a5,a4,80003c3a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be4:	4709                	li	a4,2
    80003be6:	06e79e63          	bne	a5,a4,80003c62 <fileread+0xa6>
    ilock(f->ip);
    80003bea:	6d08                	ld	a0,24(a0)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	ff8080e7          	jalr	-8(ra) # 80002be4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bf4:	874a                	mv	a4,s2
    80003bf6:	5094                	lw	a3,32(s1)
    80003bf8:	864e                	mv	a2,s3
    80003bfa:	4585                	li	a1,1
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	29a080e7          	jalr	666(ra) # 80002e98 <readi>
    80003c06:	892a                	mv	s2,a0
    80003c08:	00a05563          	blez	a0,80003c12 <fileread+0x56>
      f->off += r;
    80003c0c:	509c                	lw	a5,32(s1)
    80003c0e:	9fa9                	addw	a5,a5,a0
    80003c10:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c12:	6c88                	ld	a0,24(s1)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	092080e7          	jalr	146(ra) # 80002ca6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c1c:	854a                	mv	a0,s2
    80003c1e:	70a2                	ld	ra,40(sp)
    80003c20:	7402                	ld	s0,32(sp)
    80003c22:	64e2                	ld	s1,24(sp)
    80003c24:	6942                	ld	s2,16(sp)
    80003c26:	69a2                	ld	s3,8(sp)
    80003c28:	6145                	addi	sp,sp,48
    80003c2a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c2c:	6908                	ld	a0,16(a0)
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	3c8080e7          	jalr	968(ra) # 80003ff6 <piperead>
    80003c36:	892a                	mv	s2,a0
    80003c38:	b7d5                	j	80003c1c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c3a:	02451783          	lh	a5,36(a0)
    80003c3e:	03079693          	slli	a3,a5,0x30
    80003c42:	92c1                	srli	a3,a3,0x30
    80003c44:	4725                	li	a4,9
    80003c46:	02d76863          	bltu	a4,a3,80003c76 <fileread+0xba>
    80003c4a:	0792                	slli	a5,a5,0x4
    80003c4c:	00015717          	auipc	a4,0x15
    80003c50:	67c70713          	addi	a4,a4,1660 # 800192c8 <devsw>
    80003c54:	97ba                	add	a5,a5,a4
    80003c56:	639c                	ld	a5,0(a5)
    80003c58:	c38d                	beqz	a5,80003c7a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c5a:	4505                	li	a0,1
    80003c5c:	9782                	jalr	a5
    80003c5e:	892a                	mv	s2,a0
    80003c60:	bf75                	j	80003c1c <fileread+0x60>
    panic("fileread");
    80003c62:	00005517          	auipc	a0,0x5
    80003c66:	a9e50513          	addi	a0,a0,-1378 # 80008700 <syscalls+0x268>
    80003c6a:	00002097          	auipc	ra,0x2
    80003c6e:	02e080e7          	jalr	46(ra) # 80005c98 <panic>
    return -1;
    80003c72:	597d                	li	s2,-1
    80003c74:	b765                	j	80003c1c <fileread+0x60>
      return -1;
    80003c76:	597d                	li	s2,-1
    80003c78:	b755                	j	80003c1c <fileread+0x60>
    80003c7a:	597d                	li	s2,-1
    80003c7c:	b745                	j	80003c1c <fileread+0x60>

0000000080003c7e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c7e:	715d                	addi	sp,sp,-80
    80003c80:	e486                	sd	ra,72(sp)
    80003c82:	e0a2                	sd	s0,64(sp)
    80003c84:	fc26                	sd	s1,56(sp)
    80003c86:	f84a                	sd	s2,48(sp)
    80003c88:	f44e                	sd	s3,40(sp)
    80003c8a:	f052                	sd	s4,32(sp)
    80003c8c:	ec56                	sd	s5,24(sp)
    80003c8e:	e85a                	sd	s6,16(sp)
    80003c90:	e45e                	sd	s7,8(sp)
    80003c92:	e062                	sd	s8,0(sp)
    80003c94:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c96:	00954783          	lbu	a5,9(a0)
    80003c9a:	10078663          	beqz	a5,80003da6 <filewrite+0x128>
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	8aae                	mv	s5,a1
    80003ca2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca4:	411c                	lw	a5,0(a0)
    80003ca6:	4705                	li	a4,1
    80003ca8:	02e78263          	beq	a5,a4,80003ccc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cac:	470d                	li	a4,3
    80003cae:	02e78663          	beq	a5,a4,80003cda <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb2:	4709                	li	a4,2
    80003cb4:	0ee79163          	bne	a5,a4,80003d96 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cb8:	0ac05d63          	blez	a2,80003d72 <filewrite+0xf4>
    int i = 0;
    80003cbc:	4981                	li	s3,0
    80003cbe:	6b05                	lui	s6,0x1
    80003cc0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cc4:	6b85                	lui	s7,0x1
    80003cc6:	c00b8b9b          	addiw	s7,s7,-1024
    80003cca:	a861                	j	80003d62 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ccc:	6908                	ld	a0,16(a0)
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	22e080e7          	jalr	558(ra) # 80003efc <pipewrite>
    80003cd6:	8a2a                	mv	s4,a0
    80003cd8:	a045                	j	80003d78 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cda:	02451783          	lh	a5,36(a0)
    80003cde:	03079693          	slli	a3,a5,0x30
    80003ce2:	92c1                	srli	a3,a3,0x30
    80003ce4:	4725                	li	a4,9
    80003ce6:	0cd76263          	bltu	a4,a3,80003daa <filewrite+0x12c>
    80003cea:	0792                	slli	a5,a5,0x4
    80003cec:	00015717          	auipc	a4,0x15
    80003cf0:	5dc70713          	addi	a4,a4,1500 # 800192c8 <devsw>
    80003cf4:	97ba                	add	a5,a5,a4
    80003cf6:	679c                	ld	a5,8(a5)
    80003cf8:	cbdd                	beqz	a5,80003dae <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cfa:	4505                	li	a0,1
    80003cfc:	9782                	jalr	a5
    80003cfe:	8a2a                	mv	s4,a0
    80003d00:	a8a5                	j	80003d78 <filewrite+0xfa>
    80003d02:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	8b0080e7          	jalr	-1872(ra) # 800035b6 <begin_op>
      ilock(f->ip);
    80003d0e:	01893503          	ld	a0,24(s2)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	ed2080e7          	jalr	-302(ra) # 80002be4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d1a:	8762                	mv	a4,s8
    80003d1c:	02092683          	lw	a3,32(s2)
    80003d20:	01598633          	add	a2,s3,s5
    80003d24:	4585                	li	a1,1
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	266080e7          	jalr	614(ra) # 80002f90 <writei>
    80003d32:	84aa                	mv	s1,a0
    80003d34:	00a05763          	blez	a0,80003d42 <filewrite+0xc4>
        f->off += r;
    80003d38:	02092783          	lw	a5,32(s2)
    80003d3c:	9fa9                	addw	a5,a5,a0
    80003d3e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d42:	01893503          	ld	a0,24(s2)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	f60080e7          	jalr	-160(ra) # 80002ca6 <iunlock>
      end_op();
    80003d4e:	00000097          	auipc	ra,0x0
    80003d52:	8e8080e7          	jalr	-1816(ra) # 80003636 <end_op>

      if(r != n1){
    80003d56:	009c1f63          	bne	s8,s1,80003d74 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d5a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d5e:	0149db63          	bge	s3,s4,80003d74 <filewrite+0xf6>
      int n1 = n - i;
    80003d62:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d66:	84be                	mv	s1,a5
    80003d68:	2781                	sext.w	a5,a5
    80003d6a:	f8fb5ce3          	bge	s6,a5,80003d02 <filewrite+0x84>
    80003d6e:	84de                	mv	s1,s7
    80003d70:	bf49                	j	80003d02 <filewrite+0x84>
    int i = 0;
    80003d72:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d74:	013a1f63          	bne	s4,s3,80003d92 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d78:	8552                	mv	a0,s4
    80003d7a:	60a6                	ld	ra,72(sp)
    80003d7c:	6406                	ld	s0,64(sp)
    80003d7e:	74e2                	ld	s1,56(sp)
    80003d80:	7942                	ld	s2,48(sp)
    80003d82:	79a2                	ld	s3,40(sp)
    80003d84:	7a02                	ld	s4,32(sp)
    80003d86:	6ae2                	ld	s5,24(sp)
    80003d88:	6b42                	ld	s6,16(sp)
    80003d8a:	6ba2                	ld	s7,8(sp)
    80003d8c:	6c02                	ld	s8,0(sp)
    80003d8e:	6161                	addi	sp,sp,80
    80003d90:	8082                	ret
    ret = (i == n ? n : -1);
    80003d92:	5a7d                	li	s4,-1
    80003d94:	b7d5                	j	80003d78 <filewrite+0xfa>
    panic("filewrite");
    80003d96:	00005517          	auipc	a0,0x5
    80003d9a:	97a50513          	addi	a0,a0,-1670 # 80008710 <syscalls+0x278>
    80003d9e:	00002097          	auipc	ra,0x2
    80003da2:	efa080e7          	jalr	-262(ra) # 80005c98 <panic>
    return -1;
    80003da6:	5a7d                	li	s4,-1
    80003da8:	bfc1                	j	80003d78 <filewrite+0xfa>
      return -1;
    80003daa:	5a7d                	li	s4,-1
    80003dac:	b7f1                	j	80003d78 <filewrite+0xfa>
    80003dae:	5a7d                	li	s4,-1
    80003db0:	b7e1                	j	80003d78 <filewrite+0xfa>

0000000080003db2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003db2:	7179                	addi	sp,sp,-48
    80003db4:	f406                	sd	ra,40(sp)
    80003db6:	f022                	sd	s0,32(sp)
    80003db8:	ec26                	sd	s1,24(sp)
    80003dba:	e84a                	sd	s2,16(sp)
    80003dbc:	e44e                	sd	s3,8(sp)
    80003dbe:	e052                	sd	s4,0(sp)
    80003dc0:	1800                	addi	s0,sp,48
    80003dc2:	84aa                	mv	s1,a0
    80003dc4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dc6:	0005b023          	sd	zero,0(a1)
    80003dca:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	bf8080e7          	jalr	-1032(ra) # 800039c6 <filealloc>
    80003dd6:	e088                	sd	a0,0(s1)
    80003dd8:	c551                	beqz	a0,80003e64 <pipealloc+0xb2>
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	bec080e7          	jalr	-1044(ra) # 800039c6 <filealloc>
    80003de2:	00aa3023          	sd	a0,0(s4)
    80003de6:	c92d                	beqz	a0,80003e58 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003de8:	ffffc097          	auipc	ra,0xffffc
    80003dec:	330080e7          	jalr	816(ra) # 80000118 <kalloc>
    80003df0:	892a                	mv	s2,a0
    80003df2:	c125                	beqz	a0,80003e52 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003df4:	4985                	li	s3,1
    80003df6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dfa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dfe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e02:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e06:	00004597          	auipc	a1,0x4
    80003e0a:	5da58593          	addi	a1,a1,1498 # 800083e0 <states.1714+0x1a0>
    80003e0e:	00002097          	auipc	ra,0x2
    80003e12:	344080e7          	jalr	836(ra) # 80006152 <initlock>
  (*f0)->type = FD_PIPE;
    80003e16:	609c                	ld	a5,0(s1)
    80003e18:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e1c:	609c                	ld	a5,0(s1)
    80003e1e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e22:	609c                	ld	a5,0(s1)
    80003e24:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e28:	609c                	ld	a5,0(s1)
    80003e2a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e2e:	000a3783          	ld	a5,0(s4)
    80003e32:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e4e:	4501                	li	a0,0
    80003e50:	a025                	j	80003e78 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e52:	6088                	ld	a0,0(s1)
    80003e54:	e501                	bnez	a0,80003e5c <pipealloc+0xaa>
    80003e56:	a039                	j	80003e64 <pipealloc+0xb2>
    80003e58:	6088                	ld	a0,0(s1)
    80003e5a:	c51d                	beqz	a0,80003e88 <pipealloc+0xd6>
    fileclose(*f0);
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	c26080e7          	jalr	-986(ra) # 80003a82 <fileclose>
  if(*f1)
    80003e64:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e68:	557d                	li	a0,-1
  if(*f1)
    80003e6a:	c799                	beqz	a5,80003e78 <pipealloc+0xc6>
    fileclose(*f1);
    80003e6c:	853e                	mv	a0,a5
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	c14080e7          	jalr	-1004(ra) # 80003a82 <fileclose>
  return -1;
    80003e76:	557d                	li	a0,-1
}
    80003e78:	70a2                	ld	ra,40(sp)
    80003e7a:	7402                	ld	s0,32(sp)
    80003e7c:	64e2                	ld	s1,24(sp)
    80003e7e:	6942                	ld	s2,16(sp)
    80003e80:	69a2                	ld	s3,8(sp)
    80003e82:	6a02                	ld	s4,0(sp)
    80003e84:	6145                	addi	sp,sp,48
    80003e86:	8082                	ret
  return -1;
    80003e88:	557d                	li	a0,-1
    80003e8a:	b7fd                	j	80003e78 <pipealloc+0xc6>

0000000080003e8c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e8c:	1101                	addi	sp,sp,-32
    80003e8e:	ec06                	sd	ra,24(sp)
    80003e90:	e822                	sd	s0,16(sp)
    80003e92:	e426                	sd	s1,8(sp)
    80003e94:	e04a                	sd	s2,0(sp)
    80003e96:	1000                	addi	s0,sp,32
    80003e98:	84aa                	mv	s1,a0
    80003e9a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	346080e7          	jalr	838(ra) # 800061e2 <acquire>
  if(writable){
    80003ea4:	02090d63          	beqz	s2,80003ede <pipeclose+0x52>
    pi->writeopen = 0;
    80003ea8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eac:	21848513          	addi	a0,s1,536
    80003eb0:	ffffe097          	auipc	ra,0xffffe
    80003eb4:	832080e7          	jalr	-1998(ra) # 800016e2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eb8:	2204b783          	ld	a5,544(s1)
    80003ebc:	eb95                	bnez	a5,80003ef0 <pipeclose+0x64>
    release(&pi->lock);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	3d6080e7          	jalr	982(ra) # 80006296 <release>
    kfree((char*)pi);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	ffffc097          	auipc	ra,0xffffc
    80003ece:	152080e7          	jalr	338(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ed2:	60e2                	ld	ra,24(sp)
    80003ed4:	6442                	ld	s0,16(sp)
    80003ed6:	64a2                	ld	s1,8(sp)
    80003ed8:	6902                	ld	s2,0(sp)
    80003eda:	6105                	addi	sp,sp,32
    80003edc:	8082                	ret
    pi->readopen = 0;
    80003ede:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee2:	21c48513          	addi	a0,s1,540
    80003ee6:	ffffd097          	auipc	ra,0xffffd
    80003eea:	7fc080e7          	jalr	2044(ra) # 800016e2 <wakeup>
    80003eee:	b7e9                	j	80003eb8 <pipeclose+0x2c>
    release(&pi->lock);
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	00002097          	auipc	ra,0x2
    80003ef6:	3a4080e7          	jalr	932(ra) # 80006296 <release>
}
    80003efa:	bfe1                	j	80003ed2 <pipeclose+0x46>

0000000080003efc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003efc:	7159                	addi	sp,sp,-112
    80003efe:	f486                	sd	ra,104(sp)
    80003f00:	f0a2                	sd	s0,96(sp)
    80003f02:	eca6                	sd	s1,88(sp)
    80003f04:	e8ca                	sd	s2,80(sp)
    80003f06:	e4ce                	sd	s3,72(sp)
    80003f08:	e0d2                	sd	s4,64(sp)
    80003f0a:	fc56                	sd	s5,56(sp)
    80003f0c:	f85a                	sd	s6,48(sp)
    80003f0e:	f45e                	sd	s7,40(sp)
    80003f10:	f062                	sd	s8,32(sp)
    80003f12:	ec66                	sd	s9,24(sp)
    80003f14:	1880                	addi	s0,sp,112
    80003f16:	84aa                	mv	s1,a0
    80003f18:	8aae                	mv	s5,a1
    80003f1a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	f76080e7          	jalr	-138(ra) # 80000e92 <myproc>
    80003f24:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f26:	8526                	mv	a0,s1
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	2ba080e7          	jalr	698(ra) # 800061e2 <acquire>
  while(i < n){
    80003f30:	0d405163          	blez	s4,80003ff2 <pipewrite+0xf6>
    80003f34:	8ba6                	mv	s7,s1
  int i = 0;
    80003f36:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f38:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f3a:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f3e:	21c48c13          	addi	s8,s1,540
    80003f42:	a08d                	j	80003fa4 <pipewrite+0xa8>
      release(&pi->lock);
    80003f44:	8526                	mv	a0,s1
    80003f46:	00002097          	auipc	ra,0x2
    80003f4a:	350080e7          	jalr	848(ra) # 80006296 <release>
      return -1;
    80003f4e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f50:	854a                	mv	a0,s2
    80003f52:	70a6                	ld	ra,104(sp)
    80003f54:	7406                	ld	s0,96(sp)
    80003f56:	64e6                	ld	s1,88(sp)
    80003f58:	6946                	ld	s2,80(sp)
    80003f5a:	69a6                	ld	s3,72(sp)
    80003f5c:	6a06                	ld	s4,64(sp)
    80003f5e:	7ae2                	ld	s5,56(sp)
    80003f60:	7b42                	ld	s6,48(sp)
    80003f62:	7ba2                	ld	s7,40(sp)
    80003f64:	7c02                	ld	s8,32(sp)
    80003f66:	6ce2                	ld	s9,24(sp)
    80003f68:	6165                	addi	sp,sp,112
    80003f6a:	8082                	ret
      wakeup(&pi->nread);
    80003f6c:	8566                	mv	a0,s9
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	774080e7          	jalr	1908(ra) # 800016e2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f76:	85de                	mv	a1,s7
    80003f78:	8562                	mv	a0,s8
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	5dc080e7          	jalr	1500(ra) # 80001556 <sleep>
    80003f82:	a839                	j	80003fa0 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f84:	21c4a783          	lw	a5,540(s1)
    80003f88:	0017871b          	addiw	a4,a5,1
    80003f8c:	20e4ae23          	sw	a4,540(s1)
    80003f90:	1ff7f793          	andi	a5,a5,511
    80003f94:	97a6                	add	a5,a5,s1
    80003f96:	f9f44703          	lbu	a4,-97(s0)
    80003f9a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f9e:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fa0:	03495d63          	bge	s2,s4,80003fda <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003fa4:	2204a783          	lw	a5,544(s1)
    80003fa8:	dfd1                	beqz	a5,80003f44 <pipewrite+0x48>
    80003faa:	0289a783          	lw	a5,40(s3)
    80003fae:	fbd9                	bnez	a5,80003f44 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fb0:	2184a783          	lw	a5,536(s1)
    80003fb4:	21c4a703          	lw	a4,540(s1)
    80003fb8:	2007879b          	addiw	a5,a5,512
    80003fbc:	faf708e3          	beq	a4,a5,80003f6c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc0:	4685                	li	a3,1
    80003fc2:	01590633          	add	a2,s2,s5
    80003fc6:	f9f40593          	addi	a1,s0,-97
    80003fca:	0509b503          	ld	a0,80(s3)
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	c12080e7          	jalr	-1006(ra) # 80000be0 <copyin>
    80003fd6:	fb6517e3          	bne	a0,s6,80003f84 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fda:	21848513          	addi	a0,s1,536
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	704080e7          	jalr	1796(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	00002097          	auipc	ra,0x2
    80003fec:	2ae080e7          	jalr	686(ra) # 80006296 <release>
  return i;
    80003ff0:	b785                	j	80003f50 <pipewrite+0x54>
  int i = 0;
    80003ff2:	4901                	li	s2,0
    80003ff4:	b7dd                	j	80003fda <pipewrite+0xde>

0000000080003ff6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ff6:	715d                	addi	sp,sp,-80
    80003ff8:	e486                	sd	ra,72(sp)
    80003ffa:	e0a2                	sd	s0,64(sp)
    80003ffc:	fc26                	sd	s1,56(sp)
    80003ffe:	f84a                	sd	s2,48(sp)
    80004000:	f44e                	sd	s3,40(sp)
    80004002:	f052                	sd	s4,32(sp)
    80004004:	ec56                	sd	s5,24(sp)
    80004006:	e85a                	sd	s6,16(sp)
    80004008:	0880                	addi	s0,sp,80
    8000400a:	84aa                	mv	s1,a0
    8000400c:	892e                	mv	s2,a1
    8000400e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	e82080e7          	jalr	-382(ra) # 80000e92 <myproc>
    80004018:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000401a:	8b26                	mv	s6,s1
    8000401c:	8526                	mv	a0,s1
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	1c4080e7          	jalr	452(ra) # 800061e2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004026:	2184a703          	lw	a4,536(s1)
    8000402a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000402e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004032:	02f71463          	bne	a4,a5,8000405a <piperead+0x64>
    80004036:	2244a783          	lw	a5,548(s1)
    8000403a:	c385                	beqz	a5,8000405a <piperead+0x64>
    if(pr->killed){
    8000403c:	028a2783          	lw	a5,40(s4)
    80004040:	ebc1                	bnez	a5,800040d0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004042:	85da                	mv	a1,s6
    80004044:	854e                	mv	a0,s3
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	510080e7          	jalr	1296(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000404e:	2184a703          	lw	a4,536(s1)
    80004052:	21c4a783          	lw	a5,540(s1)
    80004056:	fef700e3          	beq	a4,a5,80004036 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000405a:	09505263          	blez	s5,800040de <piperead+0xe8>
    8000405e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004060:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004062:	2184a783          	lw	a5,536(s1)
    80004066:	21c4a703          	lw	a4,540(s1)
    8000406a:	02f70d63          	beq	a4,a5,800040a4 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000406e:	0017871b          	addiw	a4,a5,1
    80004072:	20e4ac23          	sw	a4,536(s1)
    80004076:	1ff7f793          	andi	a5,a5,511
    8000407a:	97a6                	add	a5,a5,s1
    8000407c:	0187c783          	lbu	a5,24(a5)
    80004080:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004084:	4685                	li	a3,1
    80004086:	fbf40613          	addi	a2,s0,-65
    8000408a:	85ca                	mv	a1,s2
    8000408c:	050a3503          	ld	a0,80(s4)
    80004090:	ffffd097          	auipc	ra,0xffffd
    80004094:	ac4080e7          	jalr	-1340(ra) # 80000b54 <copyout>
    80004098:	01650663          	beq	a0,s6,800040a4 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409c:	2985                	addiw	s3,s3,1
    8000409e:	0905                	addi	s2,s2,1
    800040a0:	fd3a91e3          	bne	s5,s3,80004062 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040a4:	21c48513          	addi	a0,s1,540
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	63a080e7          	jalr	1594(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	00002097          	auipc	ra,0x2
    800040b6:	1e4080e7          	jalr	484(ra) # 80006296 <release>
  return i;
}
    800040ba:	854e                	mv	a0,s3
    800040bc:	60a6                	ld	ra,72(sp)
    800040be:	6406                	ld	s0,64(sp)
    800040c0:	74e2                	ld	s1,56(sp)
    800040c2:	7942                	ld	s2,48(sp)
    800040c4:	79a2                	ld	s3,40(sp)
    800040c6:	7a02                	ld	s4,32(sp)
    800040c8:	6ae2                	ld	s5,24(sp)
    800040ca:	6b42                	ld	s6,16(sp)
    800040cc:	6161                	addi	sp,sp,80
    800040ce:	8082                	ret
      release(&pi->lock);
    800040d0:	8526                	mv	a0,s1
    800040d2:	00002097          	auipc	ra,0x2
    800040d6:	1c4080e7          	jalr	452(ra) # 80006296 <release>
      return -1;
    800040da:	59fd                	li	s3,-1
    800040dc:	bff9                	j	800040ba <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040de:	4981                	li	s3,0
    800040e0:	b7d1                	j	800040a4 <piperead+0xae>

00000000800040e2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040e2:	df010113          	addi	sp,sp,-528
    800040e6:	20113423          	sd	ra,520(sp)
    800040ea:	20813023          	sd	s0,512(sp)
    800040ee:	ffa6                	sd	s1,504(sp)
    800040f0:	fbca                	sd	s2,496(sp)
    800040f2:	f7ce                	sd	s3,488(sp)
    800040f4:	f3d2                	sd	s4,480(sp)
    800040f6:	efd6                	sd	s5,472(sp)
    800040f8:	ebda                	sd	s6,464(sp)
    800040fa:	e7de                	sd	s7,456(sp)
    800040fc:	e3e2                	sd	s8,448(sp)
    800040fe:	ff66                	sd	s9,440(sp)
    80004100:	fb6a                	sd	s10,432(sp)
    80004102:	f76e                	sd	s11,424(sp)
    80004104:	0c00                	addi	s0,sp,528
    80004106:	84aa                	mv	s1,a0
    80004108:	dea43c23          	sd	a0,-520(s0)
    8000410c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	d82080e7          	jalr	-638(ra) # 80000e92 <myproc>
    80004118:	892a                	mv	s2,a0

  begin_op();
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	49c080e7          	jalr	1180(ra) # 800035b6 <begin_op>

  if((ip = namei(path)) == 0){
    80004122:	8526                	mv	a0,s1
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	276080e7          	jalr	630(ra) # 8000339a <namei>
    8000412c:	c92d                	beqz	a0,8000419e <exec+0xbc>
    8000412e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	ab4080e7          	jalr	-1356(ra) # 80002be4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004138:	04000713          	li	a4,64
    8000413c:	4681                	li	a3,0
    8000413e:	e5040613          	addi	a2,s0,-432
    80004142:	4581                	li	a1,0
    80004144:	8526                	mv	a0,s1
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	d52080e7          	jalr	-686(ra) # 80002e98 <readi>
    8000414e:	04000793          	li	a5,64
    80004152:	00f51a63          	bne	a0,a5,80004166 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004156:	e5042703          	lw	a4,-432(s0)
    8000415a:	464c47b7          	lui	a5,0x464c4
    8000415e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004162:	04f70463          	beq	a4,a5,800041aa <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004166:	8526                	mv	a0,s1
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	cde080e7          	jalr	-802(ra) # 80002e46 <iunlockput>
    end_op();
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	4c6080e7          	jalr	1222(ra) # 80003636 <end_op>
  }
  return -1;
    80004178:	557d                	li	a0,-1
}
    8000417a:	20813083          	ld	ra,520(sp)
    8000417e:	20013403          	ld	s0,512(sp)
    80004182:	74fe                	ld	s1,504(sp)
    80004184:	795e                	ld	s2,496(sp)
    80004186:	79be                	ld	s3,488(sp)
    80004188:	7a1e                	ld	s4,480(sp)
    8000418a:	6afe                	ld	s5,472(sp)
    8000418c:	6b5e                	ld	s6,464(sp)
    8000418e:	6bbe                	ld	s7,456(sp)
    80004190:	6c1e                	ld	s8,448(sp)
    80004192:	7cfa                	ld	s9,440(sp)
    80004194:	7d5a                	ld	s10,432(sp)
    80004196:	7dba                	ld	s11,424(sp)
    80004198:	21010113          	addi	sp,sp,528
    8000419c:	8082                	ret
    end_op();
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	498080e7          	jalr	1176(ra) # 80003636 <end_op>
    return -1;
    800041a6:	557d                	li	a0,-1
    800041a8:	bfc9                	j	8000417a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041aa:	854a                	mv	a0,s2
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	daa080e7          	jalr	-598(ra) # 80000f56 <proc_pagetable>
    800041b4:	8baa                	mv	s7,a0
    800041b6:	d945                	beqz	a0,80004166 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b8:	e7042983          	lw	s3,-400(s0)
    800041bc:	e8845783          	lhu	a5,-376(s0)
    800041c0:	c7ad                	beqz	a5,8000422a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c4:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041c6:	6c85                	lui	s9,0x1
    800041c8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041cc:	def43823          	sd	a5,-528(s0)
    800041d0:	a42d                	j	800043fa <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041d2:	00004517          	auipc	a0,0x4
    800041d6:	54e50513          	addi	a0,a0,1358 # 80008720 <syscalls+0x288>
    800041da:	00002097          	auipc	ra,0x2
    800041de:	abe080e7          	jalr	-1346(ra) # 80005c98 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041e2:	8756                	mv	a4,s5
    800041e4:	012d86bb          	addw	a3,s11,s2
    800041e8:	4581                	li	a1,0
    800041ea:	8526                	mv	a0,s1
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	cac080e7          	jalr	-852(ra) # 80002e98 <readi>
    800041f4:	2501                	sext.w	a0,a0
    800041f6:	1aaa9963          	bne	s5,a0,800043a8 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041fa:	6785                	lui	a5,0x1
    800041fc:	0127893b          	addw	s2,a5,s2
    80004200:	77fd                	lui	a5,0xfffff
    80004202:	01478a3b          	addw	s4,a5,s4
    80004206:	1f897163          	bgeu	s2,s8,800043e8 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000420a:	02091593          	slli	a1,s2,0x20
    8000420e:	9181                	srli	a1,a1,0x20
    80004210:	95ea                	add	a1,a1,s10
    80004212:	855e                	mv	a0,s7
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	33c080e7          	jalr	828(ra) # 80000550 <walkaddr>
    8000421c:	862a                	mv	a2,a0
    if(pa == 0)
    8000421e:	d955                	beqz	a0,800041d2 <exec+0xf0>
      n = PGSIZE;
    80004220:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004222:	fd9a70e3          	bgeu	s4,s9,800041e2 <exec+0x100>
      n = sz - i;
    80004226:	8ad2                	mv	s5,s4
    80004228:	bf6d                	j	800041e2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000422a:	4901                	li	s2,0
  iunlockput(ip);
    8000422c:	8526                	mv	a0,s1
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	c18080e7          	jalr	-1000(ra) # 80002e46 <iunlockput>
  end_op();
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	400080e7          	jalr	1024(ra) # 80003636 <end_op>
  p = myproc();
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	c54080e7          	jalr	-940(ra) # 80000e92 <myproc>
    80004246:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004248:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000424c:	6785                	lui	a5,0x1
    8000424e:	17fd                	addi	a5,a5,-1
    80004250:	993e                	add	s2,s2,a5
    80004252:	757d                	lui	a0,0xfffff
    80004254:	00a977b3          	and	a5,s2,a0
    80004258:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000425c:	6609                	lui	a2,0x2
    8000425e:	963e                	add	a2,a2,a5
    80004260:	85be                	mv	a1,a5
    80004262:	855e                	mv	a0,s7
    80004264:	ffffc097          	auipc	ra,0xffffc
    80004268:	6a0080e7          	jalr	1696(ra) # 80000904 <uvmalloc>
    8000426c:	8b2a                	mv	s6,a0
  ip = 0;
    8000426e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004270:	12050c63          	beqz	a0,800043a8 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004274:	75f9                	lui	a1,0xffffe
    80004276:	95aa                	add	a1,a1,a0
    80004278:	855e                	mv	a0,s7
    8000427a:	ffffd097          	auipc	ra,0xffffd
    8000427e:	8a8080e7          	jalr	-1880(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    80004282:	7c7d                	lui	s8,0xfffff
    80004284:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004286:	e0043783          	ld	a5,-512(s0)
    8000428a:	6388                	ld	a0,0(a5)
    8000428c:	c535                	beqz	a0,800042f8 <exec+0x216>
    8000428e:	e9040993          	addi	s3,s0,-368
    80004292:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004296:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004298:	ffffc097          	auipc	ra,0xffffc
    8000429c:	0ae080e7          	jalr	174(ra) # 80000346 <strlen>
    800042a0:	2505                	addiw	a0,a0,1
    800042a2:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042a6:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042aa:	13896363          	bltu	s2,s8,800043d0 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ae:	e0043d83          	ld	s11,-512(s0)
    800042b2:	000dba03          	ld	s4,0(s11)
    800042b6:	8552                	mv	a0,s4
    800042b8:	ffffc097          	auipc	ra,0xffffc
    800042bc:	08e080e7          	jalr	142(ra) # 80000346 <strlen>
    800042c0:	0015069b          	addiw	a3,a0,1
    800042c4:	8652                	mv	a2,s4
    800042c6:	85ca                	mv	a1,s2
    800042c8:	855e                	mv	a0,s7
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	88a080e7          	jalr	-1910(ra) # 80000b54 <copyout>
    800042d2:	10054363          	bltz	a0,800043d8 <exec+0x2f6>
    ustack[argc] = sp;
    800042d6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042da:	0485                	addi	s1,s1,1
    800042dc:	008d8793          	addi	a5,s11,8
    800042e0:	e0f43023          	sd	a5,-512(s0)
    800042e4:	008db503          	ld	a0,8(s11)
    800042e8:	c911                	beqz	a0,800042fc <exec+0x21a>
    if(argc >= MAXARG)
    800042ea:	09a1                	addi	s3,s3,8
    800042ec:	fb3c96e3          	bne	s9,s3,80004298 <exec+0x1b6>
  sz = sz1;
    800042f0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042f4:	4481                	li	s1,0
    800042f6:	a84d                	j	800043a8 <exec+0x2c6>
  sp = sz;
    800042f8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042fa:	4481                	li	s1,0
  ustack[argc] = 0;
    800042fc:	00349793          	slli	a5,s1,0x3
    80004300:	f9040713          	addi	a4,s0,-112
    80004304:	97ba                	add	a5,a5,a4
    80004306:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000430a:	00148693          	addi	a3,s1,1
    8000430e:	068e                	slli	a3,a3,0x3
    80004310:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004314:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004318:	01897663          	bgeu	s2,s8,80004324 <exec+0x242>
  sz = sz1;
    8000431c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004320:	4481                	li	s1,0
    80004322:	a059                	j	800043a8 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004324:	e9040613          	addi	a2,s0,-368
    80004328:	85ca                	mv	a1,s2
    8000432a:	855e                	mv	a0,s7
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	828080e7          	jalr	-2008(ra) # 80000b54 <copyout>
    80004334:	0a054663          	bltz	a0,800043e0 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004338:	058ab783          	ld	a5,88(s5)
    8000433c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004340:	df843783          	ld	a5,-520(s0)
    80004344:	0007c703          	lbu	a4,0(a5)
    80004348:	cf11                	beqz	a4,80004364 <exec+0x282>
    8000434a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000434c:	02f00693          	li	a3,47
    80004350:	a039                	j	8000435e <exec+0x27c>
      last = s+1;
    80004352:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004356:	0785                	addi	a5,a5,1
    80004358:	fff7c703          	lbu	a4,-1(a5)
    8000435c:	c701                	beqz	a4,80004364 <exec+0x282>
    if(*s == '/')
    8000435e:	fed71ce3          	bne	a4,a3,80004356 <exec+0x274>
    80004362:	bfc5                	j	80004352 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004364:	4641                	li	a2,16
    80004366:	df843583          	ld	a1,-520(s0)
    8000436a:	158a8513          	addi	a0,s5,344
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	fa6080e7          	jalr	-90(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    80004376:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000437a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000437e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004382:	058ab783          	ld	a5,88(s5)
    80004386:	e6843703          	ld	a4,-408(s0)
    8000438a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000438c:	058ab783          	ld	a5,88(s5)
    80004390:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004394:	85ea                	mv	a1,s10
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	c5c080e7          	jalr	-932(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000439e:	0004851b          	sext.w	a0,s1
    800043a2:	bbe1                	j	8000417a <exec+0x98>
    800043a4:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043a8:	e0843583          	ld	a1,-504(s0)
    800043ac:	855e                	mv	a0,s7
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	c44080e7          	jalr	-956(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    800043b6:	da0498e3          	bnez	s1,80004166 <exec+0x84>
  return -1;
    800043ba:	557d                	li	a0,-1
    800043bc:	bb7d                	j	8000417a <exec+0x98>
    800043be:	e1243423          	sd	s2,-504(s0)
    800043c2:	b7dd                	j	800043a8 <exec+0x2c6>
    800043c4:	e1243423          	sd	s2,-504(s0)
    800043c8:	b7c5                	j	800043a8 <exec+0x2c6>
    800043ca:	e1243423          	sd	s2,-504(s0)
    800043ce:	bfe9                	j	800043a8 <exec+0x2c6>
  sz = sz1;
    800043d0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d4:	4481                	li	s1,0
    800043d6:	bfc9                	j	800043a8 <exec+0x2c6>
  sz = sz1;
    800043d8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043dc:	4481                	li	s1,0
    800043de:	b7e9                	j	800043a8 <exec+0x2c6>
  sz = sz1;
    800043e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e4:	4481                	li	s1,0
    800043e6:	b7c9                	j	800043a8 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043e8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ec:	2b05                	addiw	s6,s6,1
    800043ee:	0389899b          	addiw	s3,s3,56
    800043f2:	e8845783          	lhu	a5,-376(s0)
    800043f6:	e2fb5be3          	bge	s6,a5,8000422c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043fa:	2981                	sext.w	s3,s3
    800043fc:	03800713          	li	a4,56
    80004400:	86ce                	mv	a3,s3
    80004402:	e1840613          	addi	a2,s0,-488
    80004406:	4581                	li	a1,0
    80004408:	8526                	mv	a0,s1
    8000440a:	fffff097          	auipc	ra,0xfffff
    8000440e:	a8e080e7          	jalr	-1394(ra) # 80002e98 <readi>
    80004412:	03800793          	li	a5,56
    80004416:	f8f517e3          	bne	a0,a5,800043a4 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000441a:	e1842783          	lw	a5,-488(s0)
    8000441e:	4705                	li	a4,1
    80004420:	fce796e3          	bne	a5,a4,800043ec <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004424:	e4043603          	ld	a2,-448(s0)
    80004428:	e3843783          	ld	a5,-456(s0)
    8000442c:	f8f669e3          	bltu	a2,a5,800043be <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004430:	e2843783          	ld	a5,-472(s0)
    80004434:	963e                	add	a2,a2,a5
    80004436:	f8f667e3          	bltu	a2,a5,800043c4 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000443a:	85ca                	mv	a1,s2
    8000443c:	855e                	mv	a0,s7
    8000443e:	ffffc097          	auipc	ra,0xffffc
    80004442:	4c6080e7          	jalr	1222(ra) # 80000904 <uvmalloc>
    80004446:	e0a43423          	sd	a0,-504(s0)
    8000444a:	d141                	beqz	a0,800043ca <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000444c:	e2843d03          	ld	s10,-472(s0)
    80004450:	df043783          	ld	a5,-528(s0)
    80004454:	00fd77b3          	and	a5,s10,a5
    80004458:	fba1                	bnez	a5,800043a8 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000445a:	e2042d83          	lw	s11,-480(s0)
    8000445e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004462:	f80c03e3          	beqz	s8,800043e8 <exec+0x306>
    80004466:	8a62                	mv	s4,s8
    80004468:	4901                	li	s2,0
    8000446a:	b345                	j	8000420a <exec+0x128>

000000008000446c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000446c:	7179                	addi	sp,sp,-48
    8000446e:	f406                	sd	ra,40(sp)
    80004470:	f022                	sd	s0,32(sp)
    80004472:	ec26                	sd	s1,24(sp)
    80004474:	e84a                	sd	s2,16(sp)
    80004476:	1800                	addi	s0,sp,48
    80004478:	892e                	mv	s2,a1
    8000447a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000447c:	fdc40593          	addi	a1,s0,-36
    80004480:	ffffe097          	auipc	ra,0xffffe
    80004484:	b26080e7          	jalr	-1242(ra) # 80001fa6 <argint>
    80004488:	04054063          	bltz	a0,800044c8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000448c:	fdc42703          	lw	a4,-36(s0)
    80004490:	47bd                	li	a5,15
    80004492:	02e7ed63          	bltu	a5,a4,800044cc <argfd+0x60>
    80004496:	ffffd097          	auipc	ra,0xffffd
    8000449a:	9fc080e7          	jalr	-1540(ra) # 80000e92 <myproc>
    8000449e:	fdc42703          	lw	a4,-36(s0)
    800044a2:	01a70793          	addi	a5,a4,26
    800044a6:	078e                	slli	a5,a5,0x3
    800044a8:	953e                	add	a0,a0,a5
    800044aa:	611c                	ld	a5,0(a0)
    800044ac:	c395                	beqz	a5,800044d0 <argfd+0x64>
    return -1;
  if(pfd)
    800044ae:	00090463          	beqz	s2,800044b6 <argfd+0x4a>
    *pfd = fd;
    800044b2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044b6:	4501                	li	a0,0
  if(pf)
    800044b8:	c091                	beqz	s1,800044bc <argfd+0x50>
    *pf = f;
    800044ba:	e09c                	sd	a5,0(s1)
}
    800044bc:	70a2                	ld	ra,40(sp)
    800044be:	7402                	ld	s0,32(sp)
    800044c0:	64e2                	ld	s1,24(sp)
    800044c2:	6942                	ld	s2,16(sp)
    800044c4:	6145                	addi	sp,sp,48
    800044c6:	8082                	ret
    return -1;
    800044c8:	557d                	li	a0,-1
    800044ca:	bfcd                	j	800044bc <argfd+0x50>
    return -1;
    800044cc:	557d                	li	a0,-1
    800044ce:	b7fd                	j	800044bc <argfd+0x50>
    800044d0:	557d                	li	a0,-1
    800044d2:	b7ed                	j	800044bc <argfd+0x50>

00000000800044d4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044d4:	1101                	addi	sp,sp,-32
    800044d6:	ec06                	sd	ra,24(sp)
    800044d8:	e822                	sd	s0,16(sp)
    800044da:	e426                	sd	s1,8(sp)
    800044dc:	1000                	addi	s0,sp,32
    800044de:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044e0:	ffffd097          	auipc	ra,0xffffd
    800044e4:	9b2080e7          	jalr	-1614(ra) # 80000e92 <myproc>
    800044e8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044ea:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800044ee:	4501                	li	a0,0
    800044f0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044f2:	6398                	ld	a4,0(a5)
    800044f4:	cb19                	beqz	a4,8000450a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044f6:	2505                	addiw	a0,a0,1
    800044f8:	07a1                	addi	a5,a5,8
    800044fa:	fed51ce3          	bne	a0,a3,800044f2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044fe:	557d                	li	a0,-1
}
    80004500:	60e2                	ld	ra,24(sp)
    80004502:	6442                	ld	s0,16(sp)
    80004504:	64a2                	ld	s1,8(sp)
    80004506:	6105                	addi	sp,sp,32
    80004508:	8082                	ret
      p->ofile[fd] = f;
    8000450a:	01a50793          	addi	a5,a0,26
    8000450e:	078e                	slli	a5,a5,0x3
    80004510:	963e                	add	a2,a2,a5
    80004512:	e204                	sd	s1,0(a2)
      return fd;
    80004514:	b7f5                	j	80004500 <fdalloc+0x2c>

0000000080004516 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004516:	715d                	addi	sp,sp,-80
    80004518:	e486                	sd	ra,72(sp)
    8000451a:	e0a2                	sd	s0,64(sp)
    8000451c:	fc26                	sd	s1,56(sp)
    8000451e:	f84a                	sd	s2,48(sp)
    80004520:	f44e                	sd	s3,40(sp)
    80004522:	f052                	sd	s4,32(sp)
    80004524:	ec56                	sd	s5,24(sp)
    80004526:	0880                	addi	s0,sp,80
    80004528:	89ae                	mv	s3,a1
    8000452a:	8ab2                	mv	s5,a2
    8000452c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000452e:	fb040593          	addi	a1,s0,-80
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	e86080e7          	jalr	-378(ra) # 800033b8 <nameiparent>
    8000453a:	892a                	mv	s2,a0
    8000453c:	12050f63          	beqz	a0,8000467a <create+0x164>
    return 0;

  ilock(dp);
    80004540:	ffffe097          	auipc	ra,0xffffe
    80004544:	6a4080e7          	jalr	1700(ra) # 80002be4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004548:	4601                	li	a2,0
    8000454a:	fb040593          	addi	a1,s0,-80
    8000454e:	854a                	mv	a0,s2
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	b78080e7          	jalr	-1160(ra) # 800030c8 <dirlookup>
    80004558:	84aa                	mv	s1,a0
    8000455a:	c921                	beqz	a0,800045aa <create+0x94>
    iunlockput(dp);
    8000455c:	854a                	mv	a0,s2
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	8e8080e7          	jalr	-1816(ra) # 80002e46 <iunlockput>
    ilock(ip);
    80004566:	8526                	mv	a0,s1
    80004568:	ffffe097          	auipc	ra,0xffffe
    8000456c:	67c080e7          	jalr	1660(ra) # 80002be4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004570:	2981                	sext.w	s3,s3
    80004572:	4789                	li	a5,2
    80004574:	02f99463          	bne	s3,a5,8000459c <create+0x86>
    80004578:	0444d783          	lhu	a5,68(s1)
    8000457c:	37f9                	addiw	a5,a5,-2
    8000457e:	17c2                	slli	a5,a5,0x30
    80004580:	93c1                	srli	a5,a5,0x30
    80004582:	4705                	li	a4,1
    80004584:	00f76c63          	bltu	a4,a5,8000459c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004588:	8526                	mv	a0,s1
    8000458a:	60a6                	ld	ra,72(sp)
    8000458c:	6406                	ld	s0,64(sp)
    8000458e:	74e2                	ld	s1,56(sp)
    80004590:	7942                	ld	s2,48(sp)
    80004592:	79a2                	ld	s3,40(sp)
    80004594:	7a02                	ld	s4,32(sp)
    80004596:	6ae2                	ld	s5,24(sp)
    80004598:	6161                	addi	sp,sp,80
    8000459a:	8082                	ret
    iunlockput(ip);
    8000459c:	8526                	mv	a0,s1
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	8a8080e7          	jalr	-1880(ra) # 80002e46 <iunlockput>
    return 0;
    800045a6:	4481                	li	s1,0
    800045a8:	b7c5                	j	80004588 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045aa:	85ce                	mv	a1,s3
    800045ac:	00092503          	lw	a0,0(s2)
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	49c080e7          	jalr	1180(ra) # 80002a4c <ialloc>
    800045b8:	84aa                	mv	s1,a0
    800045ba:	c529                	beqz	a0,80004604 <create+0xee>
  ilock(ip);
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	628080e7          	jalr	1576(ra) # 80002be4 <ilock>
  ip->major = major;
    800045c4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045c8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045cc:	4785                	li	a5,1
    800045ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045d2:	8526                	mv	a0,s1
    800045d4:	ffffe097          	auipc	ra,0xffffe
    800045d8:	546080e7          	jalr	1350(ra) # 80002b1a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045dc:	2981                	sext.w	s3,s3
    800045de:	4785                	li	a5,1
    800045e0:	02f98a63          	beq	s3,a5,80004614 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e4:	40d0                	lw	a2,4(s1)
    800045e6:	fb040593          	addi	a1,s0,-80
    800045ea:	854a                	mv	a0,s2
    800045ec:	fffff097          	auipc	ra,0xfffff
    800045f0:	cec080e7          	jalr	-788(ra) # 800032d8 <dirlink>
    800045f4:	06054b63          	bltz	a0,8000466a <create+0x154>
  iunlockput(dp);
    800045f8:	854a                	mv	a0,s2
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	84c080e7          	jalr	-1972(ra) # 80002e46 <iunlockput>
  return ip;
    80004602:	b759                	j	80004588 <create+0x72>
    panic("create: ialloc");
    80004604:	00004517          	auipc	a0,0x4
    80004608:	13c50513          	addi	a0,a0,316 # 80008740 <syscalls+0x2a8>
    8000460c:	00001097          	auipc	ra,0x1
    80004610:	68c080e7          	jalr	1676(ra) # 80005c98 <panic>
    dp->nlink++;  // for ".."
    80004614:	04a95783          	lhu	a5,74(s2)
    80004618:	2785                	addiw	a5,a5,1
    8000461a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000461e:	854a                	mv	a0,s2
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	4fa080e7          	jalr	1274(ra) # 80002b1a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004628:	40d0                	lw	a2,4(s1)
    8000462a:	00004597          	auipc	a1,0x4
    8000462e:	12658593          	addi	a1,a1,294 # 80008750 <syscalls+0x2b8>
    80004632:	8526                	mv	a0,s1
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	ca4080e7          	jalr	-860(ra) # 800032d8 <dirlink>
    8000463c:	00054f63          	bltz	a0,8000465a <create+0x144>
    80004640:	00492603          	lw	a2,4(s2)
    80004644:	00004597          	auipc	a1,0x4
    80004648:	11458593          	addi	a1,a1,276 # 80008758 <syscalls+0x2c0>
    8000464c:	8526                	mv	a0,s1
    8000464e:	fffff097          	auipc	ra,0xfffff
    80004652:	c8a080e7          	jalr	-886(ra) # 800032d8 <dirlink>
    80004656:	f80557e3          	bgez	a0,800045e4 <create+0xce>
      panic("create dots");
    8000465a:	00004517          	auipc	a0,0x4
    8000465e:	10650513          	addi	a0,a0,262 # 80008760 <syscalls+0x2c8>
    80004662:	00001097          	auipc	ra,0x1
    80004666:	636080e7          	jalr	1590(ra) # 80005c98 <panic>
    panic("create: dirlink");
    8000466a:	00004517          	auipc	a0,0x4
    8000466e:	10650513          	addi	a0,a0,262 # 80008770 <syscalls+0x2d8>
    80004672:	00001097          	auipc	ra,0x1
    80004676:	626080e7          	jalr	1574(ra) # 80005c98 <panic>
    return 0;
    8000467a:	84aa                	mv	s1,a0
    8000467c:	b731                	j	80004588 <create+0x72>

000000008000467e <sys_dup>:
{
    8000467e:	7179                	addi	sp,sp,-48
    80004680:	f406                	sd	ra,40(sp)
    80004682:	f022                	sd	s0,32(sp)
    80004684:	ec26                	sd	s1,24(sp)
    80004686:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004688:	fd840613          	addi	a2,s0,-40
    8000468c:	4581                	li	a1,0
    8000468e:	4501                	li	a0,0
    80004690:	00000097          	auipc	ra,0x0
    80004694:	ddc080e7          	jalr	-548(ra) # 8000446c <argfd>
    return -1;
    80004698:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000469a:	02054363          	bltz	a0,800046c0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000469e:	fd843503          	ld	a0,-40(s0)
    800046a2:	00000097          	auipc	ra,0x0
    800046a6:	e32080e7          	jalr	-462(ra) # 800044d4 <fdalloc>
    800046aa:	84aa                	mv	s1,a0
    return -1;
    800046ac:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046ae:	00054963          	bltz	a0,800046c0 <sys_dup+0x42>
  filedup(f);
    800046b2:	fd843503          	ld	a0,-40(s0)
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	37a080e7          	jalr	890(ra) # 80003a30 <filedup>
  return fd;
    800046be:	87a6                	mv	a5,s1
}
    800046c0:	853e                	mv	a0,a5
    800046c2:	70a2                	ld	ra,40(sp)
    800046c4:	7402                	ld	s0,32(sp)
    800046c6:	64e2                	ld	s1,24(sp)
    800046c8:	6145                	addi	sp,sp,48
    800046ca:	8082                	ret

00000000800046cc <sys_read>:
{
    800046cc:	7179                	addi	sp,sp,-48
    800046ce:	f406                	sd	ra,40(sp)
    800046d0:	f022                	sd	s0,32(sp)
    800046d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d4:	fe840613          	addi	a2,s0,-24
    800046d8:	4581                	li	a1,0
    800046da:	4501                	li	a0,0
    800046dc:	00000097          	auipc	ra,0x0
    800046e0:	d90080e7          	jalr	-624(ra) # 8000446c <argfd>
    return -1;
    800046e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e6:	04054163          	bltz	a0,80004728 <sys_read+0x5c>
    800046ea:	fe440593          	addi	a1,s0,-28
    800046ee:	4509                	li	a0,2
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	8b6080e7          	jalr	-1866(ra) # 80001fa6 <argint>
    return -1;
    800046f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fa:	02054763          	bltz	a0,80004728 <sys_read+0x5c>
    800046fe:	fd840593          	addi	a1,s0,-40
    80004702:	4505                	li	a0,1
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	8c4080e7          	jalr	-1852(ra) # 80001fc8 <argaddr>
    return -1;
    8000470c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470e:	00054d63          	bltz	a0,80004728 <sys_read+0x5c>
  return fileread(f, p, n);
    80004712:	fe442603          	lw	a2,-28(s0)
    80004716:	fd843583          	ld	a1,-40(s0)
    8000471a:	fe843503          	ld	a0,-24(s0)
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	49e080e7          	jalr	1182(ra) # 80003bbc <fileread>
    80004726:	87aa                	mv	a5,a0
}
    80004728:	853e                	mv	a0,a5
    8000472a:	70a2                	ld	ra,40(sp)
    8000472c:	7402                	ld	s0,32(sp)
    8000472e:	6145                	addi	sp,sp,48
    80004730:	8082                	ret

0000000080004732 <sys_write>:
{
    80004732:	7179                	addi	sp,sp,-48
    80004734:	f406                	sd	ra,40(sp)
    80004736:	f022                	sd	s0,32(sp)
    80004738:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000473a:	fe840613          	addi	a2,s0,-24
    8000473e:	4581                	li	a1,0
    80004740:	4501                	li	a0,0
    80004742:	00000097          	auipc	ra,0x0
    80004746:	d2a080e7          	jalr	-726(ra) # 8000446c <argfd>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474c:	04054163          	bltz	a0,8000478e <sys_write+0x5c>
    80004750:	fe440593          	addi	a1,s0,-28
    80004754:	4509                	li	a0,2
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	850080e7          	jalr	-1968(ra) # 80001fa6 <argint>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004760:	02054763          	bltz	a0,8000478e <sys_write+0x5c>
    80004764:	fd840593          	addi	a1,s0,-40
    80004768:	4505                	li	a0,1
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	85e080e7          	jalr	-1954(ra) # 80001fc8 <argaddr>
    return -1;
    80004772:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004774:	00054d63          	bltz	a0,8000478e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004778:	fe442603          	lw	a2,-28(s0)
    8000477c:	fd843583          	ld	a1,-40(s0)
    80004780:	fe843503          	ld	a0,-24(s0)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	4fa080e7          	jalr	1274(ra) # 80003c7e <filewrite>
    8000478c:	87aa                	mv	a5,a0
}
    8000478e:	853e                	mv	a0,a5
    80004790:	70a2                	ld	ra,40(sp)
    80004792:	7402                	ld	s0,32(sp)
    80004794:	6145                	addi	sp,sp,48
    80004796:	8082                	ret

0000000080004798 <sys_close>:
{
    80004798:	1101                	addi	sp,sp,-32
    8000479a:	ec06                	sd	ra,24(sp)
    8000479c:	e822                	sd	s0,16(sp)
    8000479e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047a0:	fe040613          	addi	a2,s0,-32
    800047a4:	fec40593          	addi	a1,s0,-20
    800047a8:	4501                	li	a0,0
    800047aa:	00000097          	auipc	ra,0x0
    800047ae:	cc2080e7          	jalr	-830(ra) # 8000446c <argfd>
    return -1;
    800047b2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047b4:	02054463          	bltz	a0,800047dc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	6da080e7          	jalr	1754(ra) # 80000e92 <myproc>
    800047c0:	fec42783          	lw	a5,-20(s0)
    800047c4:	07e9                	addi	a5,a5,26
    800047c6:	078e                	slli	a5,a5,0x3
    800047c8:	97aa                	add	a5,a5,a0
    800047ca:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047ce:	fe043503          	ld	a0,-32(s0)
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	2b0080e7          	jalr	688(ra) # 80003a82 <fileclose>
  return 0;
    800047da:	4781                	li	a5,0
}
    800047dc:	853e                	mv	a0,a5
    800047de:	60e2                	ld	ra,24(sp)
    800047e0:	6442                	ld	s0,16(sp)
    800047e2:	6105                	addi	sp,sp,32
    800047e4:	8082                	ret

00000000800047e6 <sys_fstat>:
{
    800047e6:	1101                	addi	sp,sp,-32
    800047e8:	ec06                	sd	ra,24(sp)
    800047ea:	e822                	sd	s0,16(sp)
    800047ec:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ee:	fe840613          	addi	a2,s0,-24
    800047f2:	4581                	li	a1,0
    800047f4:	4501                	li	a0,0
    800047f6:	00000097          	auipc	ra,0x0
    800047fa:	c76080e7          	jalr	-906(ra) # 8000446c <argfd>
    return -1;
    800047fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004800:	02054563          	bltz	a0,8000482a <sys_fstat+0x44>
    80004804:	fe040593          	addi	a1,s0,-32
    80004808:	4505                	li	a0,1
    8000480a:	ffffd097          	auipc	ra,0xffffd
    8000480e:	7be080e7          	jalr	1982(ra) # 80001fc8 <argaddr>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004814:	00054b63          	bltz	a0,8000482a <sys_fstat+0x44>
  return filestat(f, st);
    80004818:	fe043583          	ld	a1,-32(s0)
    8000481c:	fe843503          	ld	a0,-24(s0)
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	32a080e7          	jalr	810(ra) # 80003b4a <filestat>
    80004828:	87aa                	mv	a5,a0
}
    8000482a:	853e                	mv	a0,a5
    8000482c:	60e2                	ld	ra,24(sp)
    8000482e:	6442                	ld	s0,16(sp)
    80004830:	6105                	addi	sp,sp,32
    80004832:	8082                	ret

0000000080004834 <sys_link>:
{
    80004834:	7169                	addi	sp,sp,-304
    80004836:	f606                	sd	ra,296(sp)
    80004838:	f222                	sd	s0,288(sp)
    8000483a:	ee26                	sd	s1,280(sp)
    8000483c:	ea4a                	sd	s2,272(sp)
    8000483e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004840:	08000613          	li	a2,128
    80004844:	ed040593          	addi	a1,s0,-304
    80004848:	4501                	li	a0,0
    8000484a:	ffffd097          	auipc	ra,0xffffd
    8000484e:	7a0080e7          	jalr	1952(ra) # 80001fea <argstr>
    return -1;
    80004852:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004854:	10054e63          	bltz	a0,80004970 <sys_link+0x13c>
    80004858:	08000613          	li	a2,128
    8000485c:	f5040593          	addi	a1,s0,-176
    80004860:	4505                	li	a0,1
    80004862:	ffffd097          	auipc	ra,0xffffd
    80004866:	788080e7          	jalr	1928(ra) # 80001fea <argstr>
    return -1;
    8000486a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486c:	10054263          	bltz	a0,80004970 <sys_link+0x13c>
  begin_op();
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	d46080e7          	jalr	-698(ra) # 800035b6 <begin_op>
  if((ip = namei(old)) == 0){
    80004878:	ed040513          	addi	a0,s0,-304
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	b1e080e7          	jalr	-1250(ra) # 8000339a <namei>
    80004884:	84aa                	mv	s1,a0
    80004886:	c551                	beqz	a0,80004912 <sys_link+0xde>
  ilock(ip);
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	35c080e7          	jalr	860(ra) # 80002be4 <ilock>
  if(ip->type == T_DIR){
    80004890:	04449703          	lh	a4,68(s1)
    80004894:	4785                	li	a5,1
    80004896:	08f70463          	beq	a4,a5,8000491e <sys_link+0xea>
  ip->nlink++;
    8000489a:	04a4d783          	lhu	a5,74(s1)
    8000489e:	2785                	addiw	a5,a5,1
    800048a0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048a4:	8526                	mv	a0,s1
    800048a6:	ffffe097          	auipc	ra,0xffffe
    800048aa:	274080e7          	jalr	628(ra) # 80002b1a <iupdate>
  iunlock(ip);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	3f6080e7          	jalr	1014(ra) # 80002ca6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048b8:	fd040593          	addi	a1,s0,-48
    800048bc:	f5040513          	addi	a0,s0,-176
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	af8080e7          	jalr	-1288(ra) # 800033b8 <nameiparent>
    800048c8:	892a                	mv	s2,a0
    800048ca:	c935                	beqz	a0,8000493e <sys_link+0x10a>
  ilock(dp);
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	318080e7          	jalr	792(ra) # 80002be4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048d4:	00092703          	lw	a4,0(s2)
    800048d8:	409c                	lw	a5,0(s1)
    800048da:	04f71d63          	bne	a4,a5,80004934 <sys_link+0x100>
    800048de:	40d0                	lw	a2,4(s1)
    800048e0:	fd040593          	addi	a1,s0,-48
    800048e4:	854a                	mv	a0,s2
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	9f2080e7          	jalr	-1550(ra) # 800032d8 <dirlink>
    800048ee:	04054363          	bltz	a0,80004934 <sys_link+0x100>
  iunlockput(dp);
    800048f2:	854a                	mv	a0,s2
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	552080e7          	jalr	1362(ra) # 80002e46 <iunlockput>
  iput(ip);
    800048fc:	8526                	mv	a0,s1
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	4a0080e7          	jalr	1184(ra) # 80002d9e <iput>
  end_op();
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	d30080e7          	jalr	-720(ra) # 80003636 <end_op>
  return 0;
    8000490e:	4781                	li	a5,0
    80004910:	a085                	j	80004970 <sys_link+0x13c>
    end_op();
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	d24080e7          	jalr	-732(ra) # 80003636 <end_op>
    return -1;
    8000491a:	57fd                	li	a5,-1
    8000491c:	a891                	j	80004970 <sys_link+0x13c>
    iunlockput(ip);
    8000491e:	8526                	mv	a0,s1
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	526080e7          	jalr	1318(ra) # 80002e46 <iunlockput>
    end_op();
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	d0e080e7          	jalr	-754(ra) # 80003636 <end_op>
    return -1;
    80004930:	57fd                	li	a5,-1
    80004932:	a83d                	j	80004970 <sys_link+0x13c>
    iunlockput(dp);
    80004934:	854a                	mv	a0,s2
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	510080e7          	jalr	1296(ra) # 80002e46 <iunlockput>
  ilock(ip);
    8000493e:	8526                	mv	a0,s1
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	2a4080e7          	jalr	676(ra) # 80002be4 <ilock>
  ip->nlink--;
    80004948:	04a4d783          	lhu	a5,74(s1)
    8000494c:	37fd                	addiw	a5,a5,-1
    8000494e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	1c6080e7          	jalr	454(ra) # 80002b1a <iupdate>
  iunlockput(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	4e8080e7          	jalr	1256(ra) # 80002e46 <iunlockput>
  end_op();
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	cd0080e7          	jalr	-816(ra) # 80003636 <end_op>
  return -1;
    8000496e:	57fd                	li	a5,-1
}
    80004970:	853e                	mv	a0,a5
    80004972:	70b2                	ld	ra,296(sp)
    80004974:	7412                	ld	s0,288(sp)
    80004976:	64f2                	ld	s1,280(sp)
    80004978:	6952                	ld	s2,272(sp)
    8000497a:	6155                	addi	sp,sp,304
    8000497c:	8082                	ret

000000008000497e <sys_unlink>:
{
    8000497e:	7151                	addi	sp,sp,-240
    80004980:	f586                	sd	ra,232(sp)
    80004982:	f1a2                	sd	s0,224(sp)
    80004984:	eda6                	sd	s1,216(sp)
    80004986:	e9ca                	sd	s2,208(sp)
    80004988:	e5ce                	sd	s3,200(sp)
    8000498a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000498c:	08000613          	li	a2,128
    80004990:	f3040593          	addi	a1,s0,-208
    80004994:	4501                	li	a0,0
    80004996:	ffffd097          	auipc	ra,0xffffd
    8000499a:	654080e7          	jalr	1620(ra) # 80001fea <argstr>
    8000499e:	18054163          	bltz	a0,80004b20 <sys_unlink+0x1a2>
  begin_op();
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	c14080e7          	jalr	-1004(ra) # 800035b6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049aa:	fb040593          	addi	a1,s0,-80
    800049ae:	f3040513          	addi	a0,s0,-208
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	a06080e7          	jalr	-1530(ra) # 800033b8 <nameiparent>
    800049ba:	84aa                	mv	s1,a0
    800049bc:	c979                	beqz	a0,80004a92 <sys_unlink+0x114>
  ilock(dp);
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	226080e7          	jalr	550(ra) # 80002be4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049c6:	00004597          	auipc	a1,0x4
    800049ca:	d8a58593          	addi	a1,a1,-630 # 80008750 <syscalls+0x2b8>
    800049ce:	fb040513          	addi	a0,s0,-80
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	6dc080e7          	jalr	1756(ra) # 800030ae <namecmp>
    800049da:	14050a63          	beqz	a0,80004b2e <sys_unlink+0x1b0>
    800049de:	00004597          	auipc	a1,0x4
    800049e2:	d7a58593          	addi	a1,a1,-646 # 80008758 <syscalls+0x2c0>
    800049e6:	fb040513          	addi	a0,s0,-80
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	6c4080e7          	jalr	1732(ra) # 800030ae <namecmp>
    800049f2:	12050e63          	beqz	a0,80004b2e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049f6:	f2c40613          	addi	a2,s0,-212
    800049fa:	fb040593          	addi	a1,s0,-80
    800049fe:	8526                	mv	a0,s1
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	6c8080e7          	jalr	1736(ra) # 800030c8 <dirlookup>
    80004a08:	892a                	mv	s2,a0
    80004a0a:	12050263          	beqz	a0,80004b2e <sys_unlink+0x1b0>
  ilock(ip);
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	1d6080e7          	jalr	470(ra) # 80002be4 <ilock>
  if(ip->nlink < 1)
    80004a16:	04a91783          	lh	a5,74(s2)
    80004a1a:	08f05263          	blez	a5,80004a9e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a1e:	04491703          	lh	a4,68(s2)
    80004a22:	4785                	li	a5,1
    80004a24:	08f70563          	beq	a4,a5,80004aae <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a28:	4641                	li	a2,16
    80004a2a:	4581                	li	a1,0
    80004a2c:	fc040513          	addi	a0,s0,-64
    80004a30:	ffffb097          	auipc	ra,0xffffb
    80004a34:	792080e7          	jalr	1938(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a38:	4741                	li	a4,16
    80004a3a:	f2c42683          	lw	a3,-212(s0)
    80004a3e:	fc040613          	addi	a2,s0,-64
    80004a42:	4581                	li	a1,0
    80004a44:	8526                	mv	a0,s1
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	54a080e7          	jalr	1354(ra) # 80002f90 <writei>
    80004a4e:	47c1                	li	a5,16
    80004a50:	0af51563          	bne	a0,a5,80004afa <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a54:	04491703          	lh	a4,68(s2)
    80004a58:	4785                	li	a5,1
    80004a5a:	0af70863          	beq	a4,a5,80004b0a <sys_unlink+0x18c>
  iunlockput(dp);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	3e6080e7          	jalr	998(ra) # 80002e46 <iunlockput>
  ip->nlink--;
    80004a68:	04a95783          	lhu	a5,74(s2)
    80004a6c:	37fd                	addiw	a5,a5,-1
    80004a6e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a72:	854a                	mv	a0,s2
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	0a6080e7          	jalr	166(ra) # 80002b1a <iupdate>
  iunlockput(ip);
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	3c8080e7          	jalr	968(ra) # 80002e46 <iunlockput>
  end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	bb0080e7          	jalr	-1104(ra) # 80003636 <end_op>
  return 0;
    80004a8e:	4501                	li	a0,0
    80004a90:	a84d                	j	80004b42 <sys_unlink+0x1c4>
    end_op();
    80004a92:	fffff097          	auipc	ra,0xfffff
    80004a96:	ba4080e7          	jalr	-1116(ra) # 80003636 <end_op>
    return -1;
    80004a9a:	557d                	li	a0,-1
    80004a9c:	a05d                	j	80004b42 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a9e:	00004517          	auipc	a0,0x4
    80004aa2:	ce250513          	addi	a0,a0,-798 # 80008780 <syscalls+0x2e8>
    80004aa6:	00001097          	auipc	ra,0x1
    80004aaa:	1f2080e7          	jalr	498(ra) # 80005c98 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aae:	04c92703          	lw	a4,76(s2)
    80004ab2:	02000793          	li	a5,32
    80004ab6:	f6e7f9e3          	bgeu	a5,a4,80004a28 <sys_unlink+0xaa>
    80004aba:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004abe:	4741                	li	a4,16
    80004ac0:	86ce                	mv	a3,s3
    80004ac2:	f1840613          	addi	a2,s0,-232
    80004ac6:	4581                	li	a1,0
    80004ac8:	854a                	mv	a0,s2
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	3ce080e7          	jalr	974(ra) # 80002e98 <readi>
    80004ad2:	47c1                	li	a5,16
    80004ad4:	00f51b63          	bne	a0,a5,80004aea <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ad8:	f1845783          	lhu	a5,-232(s0)
    80004adc:	e7a1                	bnez	a5,80004b24 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ade:	29c1                	addiw	s3,s3,16
    80004ae0:	04c92783          	lw	a5,76(s2)
    80004ae4:	fcf9ede3          	bltu	s3,a5,80004abe <sys_unlink+0x140>
    80004ae8:	b781                	j	80004a28 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aea:	00004517          	auipc	a0,0x4
    80004aee:	cae50513          	addi	a0,a0,-850 # 80008798 <syscalls+0x300>
    80004af2:	00001097          	auipc	ra,0x1
    80004af6:	1a6080e7          	jalr	422(ra) # 80005c98 <panic>
    panic("unlink: writei");
    80004afa:	00004517          	auipc	a0,0x4
    80004afe:	cb650513          	addi	a0,a0,-842 # 800087b0 <syscalls+0x318>
    80004b02:	00001097          	auipc	ra,0x1
    80004b06:	196080e7          	jalr	406(ra) # 80005c98 <panic>
    dp->nlink--;
    80004b0a:	04a4d783          	lhu	a5,74(s1)
    80004b0e:	37fd                	addiw	a5,a5,-1
    80004b10:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	004080e7          	jalr	4(ra) # 80002b1a <iupdate>
    80004b1e:	b781                	j	80004a5e <sys_unlink+0xe0>
    return -1;
    80004b20:	557d                	li	a0,-1
    80004b22:	a005                	j	80004b42 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	320080e7          	jalr	800(ra) # 80002e46 <iunlockput>
  iunlockput(dp);
    80004b2e:	8526                	mv	a0,s1
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	316080e7          	jalr	790(ra) # 80002e46 <iunlockput>
  end_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	afe080e7          	jalr	-1282(ra) # 80003636 <end_op>
  return -1;
    80004b40:	557d                	li	a0,-1
}
    80004b42:	70ae                	ld	ra,232(sp)
    80004b44:	740e                	ld	s0,224(sp)
    80004b46:	64ee                	ld	s1,216(sp)
    80004b48:	694e                	ld	s2,208(sp)
    80004b4a:	69ae                	ld	s3,200(sp)
    80004b4c:	616d                	addi	sp,sp,240
    80004b4e:	8082                	ret

0000000080004b50 <sys_open>:

uint64
sys_open(void)
{
    80004b50:	7131                	addi	sp,sp,-192
    80004b52:	fd06                	sd	ra,184(sp)
    80004b54:	f922                	sd	s0,176(sp)
    80004b56:	f526                	sd	s1,168(sp)
    80004b58:	f14a                	sd	s2,160(sp)
    80004b5a:	ed4e                	sd	s3,152(sp)
    80004b5c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b5e:	08000613          	li	a2,128
    80004b62:	f5040593          	addi	a1,s0,-176
    80004b66:	4501                	li	a0,0
    80004b68:	ffffd097          	auipc	ra,0xffffd
    80004b6c:	482080e7          	jalr	1154(ra) # 80001fea <argstr>
    return -1;
    80004b70:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b72:	0c054163          	bltz	a0,80004c34 <sys_open+0xe4>
    80004b76:	f4c40593          	addi	a1,s0,-180
    80004b7a:	4505                	li	a0,1
    80004b7c:	ffffd097          	auipc	ra,0xffffd
    80004b80:	42a080e7          	jalr	1066(ra) # 80001fa6 <argint>
    80004b84:	0a054863          	bltz	a0,80004c34 <sys_open+0xe4>

  begin_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	a2e080e7          	jalr	-1490(ra) # 800035b6 <begin_op>

  if(omode & O_CREATE){
    80004b90:	f4c42783          	lw	a5,-180(s0)
    80004b94:	2007f793          	andi	a5,a5,512
    80004b98:	cbdd                	beqz	a5,80004c4e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b9a:	4681                	li	a3,0
    80004b9c:	4601                	li	a2,0
    80004b9e:	4589                	li	a1,2
    80004ba0:	f5040513          	addi	a0,s0,-176
    80004ba4:	00000097          	auipc	ra,0x0
    80004ba8:	972080e7          	jalr	-1678(ra) # 80004516 <create>
    80004bac:	892a                	mv	s2,a0
    if(ip == 0){
    80004bae:	c959                	beqz	a0,80004c44 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb0:	04491703          	lh	a4,68(s2)
    80004bb4:	478d                	li	a5,3
    80004bb6:	00f71763          	bne	a4,a5,80004bc4 <sys_open+0x74>
    80004bba:	04695703          	lhu	a4,70(s2)
    80004bbe:	47a5                	li	a5,9
    80004bc0:	0ce7ec63          	bltu	a5,a4,80004c98 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	e02080e7          	jalr	-510(ra) # 800039c6 <filealloc>
    80004bcc:	89aa                	mv	s3,a0
    80004bce:	10050263          	beqz	a0,80004cd2 <sys_open+0x182>
    80004bd2:	00000097          	auipc	ra,0x0
    80004bd6:	902080e7          	jalr	-1790(ra) # 800044d4 <fdalloc>
    80004bda:	84aa                	mv	s1,a0
    80004bdc:	0e054663          	bltz	a0,80004cc8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be0:	04491703          	lh	a4,68(s2)
    80004be4:	478d                	li	a5,3
    80004be6:	0cf70463          	beq	a4,a5,80004cae <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bea:	4789                	li	a5,2
    80004bec:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bf4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bf8:	f4c42783          	lw	a5,-180(s0)
    80004bfc:	0017c713          	xori	a4,a5,1
    80004c00:	8b05                	andi	a4,a4,1
    80004c02:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c06:	0037f713          	andi	a4,a5,3
    80004c0a:	00e03733          	snez	a4,a4
    80004c0e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c12:	4007f793          	andi	a5,a5,1024
    80004c16:	c791                	beqz	a5,80004c22 <sys_open+0xd2>
    80004c18:	04491703          	lh	a4,68(s2)
    80004c1c:	4789                	li	a5,2
    80004c1e:	08f70f63          	beq	a4,a5,80004cbc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c22:	854a                	mv	a0,s2
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	082080e7          	jalr	130(ra) # 80002ca6 <iunlock>
  end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	a0a080e7          	jalr	-1526(ra) # 80003636 <end_op>

  return fd;
}
    80004c34:	8526                	mv	a0,s1
    80004c36:	70ea                	ld	ra,184(sp)
    80004c38:	744a                	ld	s0,176(sp)
    80004c3a:	74aa                	ld	s1,168(sp)
    80004c3c:	790a                	ld	s2,160(sp)
    80004c3e:	69ea                	ld	s3,152(sp)
    80004c40:	6129                	addi	sp,sp,192
    80004c42:	8082                	ret
      end_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	9f2080e7          	jalr	-1550(ra) # 80003636 <end_op>
      return -1;
    80004c4c:	b7e5                	j	80004c34 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c4e:	f5040513          	addi	a0,s0,-176
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	748080e7          	jalr	1864(ra) # 8000339a <namei>
    80004c5a:	892a                	mv	s2,a0
    80004c5c:	c905                	beqz	a0,80004c8c <sys_open+0x13c>
    ilock(ip);
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	f86080e7          	jalr	-122(ra) # 80002be4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c66:	04491703          	lh	a4,68(s2)
    80004c6a:	4785                	li	a5,1
    80004c6c:	f4f712e3          	bne	a4,a5,80004bb0 <sys_open+0x60>
    80004c70:	f4c42783          	lw	a5,-180(s0)
    80004c74:	dba1                	beqz	a5,80004bc4 <sys_open+0x74>
      iunlockput(ip);
    80004c76:	854a                	mv	a0,s2
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	1ce080e7          	jalr	462(ra) # 80002e46 <iunlockput>
      end_op();
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	9b6080e7          	jalr	-1610(ra) # 80003636 <end_op>
      return -1;
    80004c88:	54fd                	li	s1,-1
    80004c8a:	b76d                	j	80004c34 <sys_open+0xe4>
      end_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	9aa080e7          	jalr	-1622(ra) # 80003636 <end_op>
      return -1;
    80004c94:	54fd                	li	s1,-1
    80004c96:	bf79                	j	80004c34 <sys_open+0xe4>
    iunlockput(ip);
    80004c98:	854a                	mv	a0,s2
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	1ac080e7          	jalr	428(ra) # 80002e46 <iunlockput>
    end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	994080e7          	jalr	-1644(ra) # 80003636 <end_op>
    return -1;
    80004caa:	54fd                	li	s1,-1
    80004cac:	b761                	j	80004c34 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cae:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cb2:	04691783          	lh	a5,70(s2)
    80004cb6:	02f99223          	sh	a5,36(s3)
    80004cba:	bf2d                	j	80004bf4 <sys_open+0xa4>
    itrunc(ip);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	034080e7          	jalr	52(ra) # 80002cf2 <itrunc>
    80004cc6:	bfb1                	j	80004c22 <sys_open+0xd2>
      fileclose(f);
    80004cc8:	854e                	mv	a0,s3
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	db8080e7          	jalr	-584(ra) # 80003a82 <fileclose>
    iunlockput(ip);
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	172080e7          	jalr	370(ra) # 80002e46 <iunlockput>
    end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	95a080e7          	jalr	-1702(ra) # 80003636 <end_op>
    return -1;
    80004ce4:	54fd                	li	s1,-1
    80004ce6:	b7b9                	j	80004c34 <sys_open+0xe4>

0000000080004ce8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ce8:	7175                	addi	sp,sp,-144
    80004cea:	e506                	sd	ra,136(sp)
    80004cec:	e122                	sd	s0,128(sp)
    80004cee:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	8c6080e7          	jalr	-1850(ra) # 800035b6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cf8:	08000613          	li	a2,128
    80004cfc:	f7040593          	addi	a1,s0,-144
    80004d00:	4501                	li	a0,0
    80004d02:	ffffd097          	auipc	ra,0xffffd
    80004d06:	2e8080e7          	jalr	744(ra) # 80001fea <argstr>
    80004d0a:	02054963          	bltz	a0,80004d3c <sys_mkdir+0x54>
    80004d0e:	4681                	li	a3,0
    80004d10:	4601                	li	a2,0
    80004d12:	4585                	li	a1,1
    80004d14:	f7040513          	addi	a0,s0,-144
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	7fe080e7          	jalr	2046(ra) # 80004516 <create>
    80004d20:	cd11                	beqz	a0,80004d3c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	124080e7          	jalr	292(ra) # 80002e46 <iunlockput>
  end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	90c080e7          	jalr	-1780(ra) # 80003636 <end_op>
  return 0;
    80004d32:	4501                	li	a0,0
}
    80004d34:	60aa                	ld	ra,136(sp)
    80004d36:	640a                	ld	s0,128(sp)
    80004d38:	6149                	addi	sp,sp,144
    80004d3a:	8082                	ret
    end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	8fa080e7          	jalr	-1798(ra) # 80003636 <end_op>
    return -1;
    80004d44:	557d                	li	a0,-1
    80004d46:	b7fd                	j	80004d34 <sys_mkdir+0x4c>

0000000080004d48 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d48:	7135                	addi	sp,sp,-160
    80004d4a:	ed06                	sd	ra,152(sp)
    80004d4c:	e922                	sd	s0,144(sp)
    80004d4e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	866080e7          	jalr	-1946(ra) # 800035b6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d58:	08000613          	li	a2,128
    80004d5c:	f7040593          	addi	a1,s0,-144
    80004d60:	4501                	li	a0,0
    80004d62:	ffffd097          	auipc	ra,0xffffd
    80004d66:	288080e7          	jalr	648(ra) # 80001fea <argstr>
    80004d6a:	04054a63          	bltz	a0,80004dbe <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d6e:	f6c40593          	addi	a1,s0,-148
    80004d72:	4505                	li	a0,1
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	232080e7          	jalr	562(ra) # 80001fa6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d7c:	04054163          	bltz	a0,80004dbe <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d80:	f6840593          	addi	a1,s0,-152
    80004d84:	4509                	li	a0,2
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	220080e7          	jalr	544(ra) # 80001fa6 <argint>
     argint(1, &major) < 0 ||
    80004d8e:	02054863          	bltz	a0,80004dbe <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d92:	f6841683          	lh	a3,-152(s0)
    80004d96:	f6c41603          	lh	a2,-148(s0)
    80004d9a:	458d                	li	a1,3
    80004d9c:	f7040513          	addi	a0,s0,-144
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	776080e7          	jalr	1910(ra) # 80004516 <create>
     argint(2, &minor) < 0 ||
    80004da8:	c919                	beqz	a0,80004dbe <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	09c080e7          	jalr	156(ra) # 80002e46 <iunlockput>
  end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	884080e7          	jalr	-1916(ra) # 80003636 <end_op>
  return 0;
    80004dba:	4501                	li	a0,0
    80004dbc:	a031                	j	80004dc8 <sys_mknod+0x80>
    end_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	878080e7          	jalr	-1928(ra) # 80003636 <end_op>
    return -1;
    80004dc6:	557d                	li	a0,-1
}
    80004dc8:	60ea                	ld	ra,152(sp)
    80004dca:	644a                	ld	s0,144(sp)
    80004dcc:	610d                	addi	sp,sp,160
    80004dce:	8082                	ret

0000000080004dd0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dd0:	7135                	addi	sp,sp,-160
    80004dd2:	ed06                	sd	ra,152(sp)
    80004dd4:	e922                	sd	s0,144(sp)
    80004dd6:	e526                	sd	s1,136(sp)
    80004dd8:	e14a                	sd	s2,128(sp)
    80004dda:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ddc:	ffffc097          	auipc	ra,0xffffc
    80004de0:	0b6080e7          	jalr	182(ra) # 80000e92 <myproc>
    80004de4:	892a                	mv	s2,a0
  
  begin_op();
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	7d0080e7          	jalr	2000(ra) # 800035b6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dee:	08000613          	li	a2,128
    80004df2:	f6040593          	addi	a1,s0,-160
    80004df6:	4501                	li	a0,0
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	1f2080e7          	jalr	498(ra) # 80001fea <argstr>
    80004e00:	04054b63          	bltz	a0,80004e56 <sys_chdir+0x86>
    80004e04:	f6040513          	addi	a0,s0,-160
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	592080e7          	jalr	1426(ra) # 8000339a <namei>
    80004e10:	84aa                	mv	s1,a0
    80004e12:	c131                	beqz	a0,80004e56 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	dd0080e7          	jalr	-560(ra) # 80002be4 <ilock>
  if(ip->type != T_DIR){
    80004e1c:	04449703          	lh	a4,68(s1)
    80004e20:	4785                	li	a5,1
    80004e22:	04f71063          	bne	a4,a5,80004e62 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	e7e080e7          	jalr	-386(ra) # 80002ca6 <iunlock>
  iput(p->cwd);
    80004e30:	15093503          	ld	a0,336(s2)
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	f6a080e7          	jalr	-150(ra) # 80002d9e <iput>
  end_op();
    80004e3c:	ffffe097          	auipc	ra,0xffffe
    80004e40:	7fa080e7          	jalr	2042(ra) # 80003636 <end_op>
  p->cwd = ip;
    80004e44:	14993823          	sd	s1,336(s2)
  return 0;
    80004e48:	4501                	li	a0,0
}
    80004e4a:	60ea                	ld	ra,152(sp)
    80004e4c:	644a                	ld	s0,144(sp)
    80004e4e:	64aa                	ld	s1,136(sp)
    80004e50:	690a                	ld	s2,128(sp)
    80004e52:	610d                	addi	sp,sp,160
    80004e54:	8082                	ret
    end_op();
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	7e0080e7          	jalr	2016(ra) # 80003636 <end_op>
    return -1;
    80004e5e:	557d                	li	a0,-1
    80004e60:	b7ed                	j	80004e4a <sys_chdir+0x7a>
    iunlockput(ip);
    80004e62:	8526                	mv	a0,s1
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	fe2080e7          	jalr	-30(ra) # 80002e46 <iunlockput>
    end_op();
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	7ca080e7          	jalr	1994(ra) # 80003636 <end_op>
    return -1;
    80004e74:	557d                	li	a0,-1
    80004e76:	bfd1                	j	80004e4a <sys_chdir+0x7a>

0000000080004e78 <sys_exec>:

uint64
sys_exec(void)
{
    80004e78:	7145                	addi	sp,sp,-464
    80004e7a:	e786                	sd	ra,456(sp)
    80004e7c:	e3a2                	sd	s0,448(sp)
    80004e7e:	ff26                	sd	s1,440(sp)
    80004e80:	fb4a                	sd	s2,432(sp)
    80004e82:	f74e                	sd	s3,424(sp)
    80004e84:	f352                	sd	s4,416(sp)
    80004e86:	ef56                	sd	s5,408(sp)
    80004e88:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e8a:	08000613          	li	a2,128
    80004e8e:	f4040593          	addi	a1,s0,-192
    80004e92:	4501                	li	a0,0
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	156080e7          	jalr	342(ra) # 80001fea <argstr>
    return -1;
    80004e9c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e9e:	0c054a63          	bltz	a0,80004f72 <sys_exec+0xfa>
    80004ea2:	e3840593          	addi	a1,s0,-456
    80004ea6:	4505                	li	a0,1
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	120080e7          	jalr	288(ra) # 80001fc8 <argaddr>
    80004eb0:	0c054163          	bltz	a0,80004f72 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004eb4:	10000613          	li	a2,256
    80004eb8:	4581                	li	a1,0
    80004eba:	e4040513          	addi	a0,s0,-448
    80004ebe:	ffffb097          	auipc	ra,0xffffb
    80004ec2:	304080e7          	jalr	772(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ec6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eca:	89a6                	mv	s3,s1
    80004ecc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ece:	02000a13          	li	s4,32
    80004ed2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ed6:	00391513          	slli	a0,s2,0x3
    80004eda:	e3040593          	addi	a1,s0,-464
    80004ede:	e3843783          	ld	a5,-456(s0)
    80004ee2:	953e                	add	a0,a0,a5
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	028080e7          	jalr	40(ra) # 80001f0c <fetchaddr>
    80004eec:	02054a63          	bltz	a0,80004f20 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ef0:	e3043783          	ld	a5,-464(s0)
    80004ef4:	c3b9                	beqz	a5,80004f3a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ef6:	ffffb097          	auipc	ra,0xffffb
    80004efa:	222080e7          	jalr	546(ra) # 80000118 <kalloc>
    80004efe:	85aa                	mv	a1,a0
    80004f00:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f04:	cd11                	beqz	a0,80004f20 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f06:	6605                	lui	a2,0x1
    80004f08:	e3043503          	ld	a0,-464(s0)
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	052080e7          	jalr	82(ra) # 80001f5e <fetchstr>
    80004f14:	00054663          	bltz	a0,80004f20 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f18:	0905                	addi	s2,s2,1
    80004f1a:	09a1                	addi	s3,s3,8
    80004f1c:	fb491be3          	bne	s2,s4,80004ed2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f20:	10048913          	addi	s2,s1,256
    80004f24:	6088                	ld	a0,0(s1)
    80004f26:	c529                	beqz	a0,80004f70 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f28:	ffffb097          	auipc	ra,0xffffb
    80004f2c:	0f4080e7          	jalr	244(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f30:	04a1                	addi	s1,s1,8
    80004f32:	ff2499e3          	bne	s1,s2,80004f24 <sys_exec+0xac>
  return -1;
    80004f36:	597d                	li	s2,-1
    80004f38:	a82d                	j	80004f72 <sys_exec+0xfa>
      argv[i] = 0;
    80004f3a:	0a8e                	slli	s5,s5,0x3
    80004f3c:	fc040793          	addi	a5,s0,-64
    80004f40:	9abe                	add	s5,s5,a5
    80004f42:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f46:	e4040593          	addi	a1,s0,-448
    80004f4a:	f4040513          	addi	a0,s0,-192
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	194080e7          	jalr	404(ra) # 800040e2 <exec>
    80004f56:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f58:	10048993          	addi	s3,s1,256
    80004f5c:	6088                	ld	a0,0(s1)
    80004f5e:	c911                	beqz	a0,80004f72 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f60:	ffffb097          	auipc	ra,0xffffb
    80004f64:	0bc080e7          	jalr	188(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f68:	04a1                	addi	s1,s1,8
    80004f6a:	ff3499e3          	bne	s1,s3,80004f5c <sys_exec+0xe4>
    80004f6e:	a011                	j	80004f72 <sys_exec+0xfa>
  return -1;
    80004f70:	597d                	li	s2,-1
}
    80004f72:	854a                	mv	a0,s2
    80004f74:	60be                	ld	ra,456(sp)
    80004f76:	641e                	ld	s0,448(sp)
    80004f78:	74fa                	ld	s1,440(sp)
    80004f7a:	795a                	ld	s2,432(sp)
    80004f7c:	79ba                	ld	s3,424(sp)
    80004f7e:	7a1a                	ld	s4,416(sp)
    80004f80:	6afa                	ld	s5,408(sp)
    80004f82:	6179                	addi	sp,sp,464
    80004f84:	8082                	ret

0000000080004f86 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f86:	7139                	addi	sp,sp,-64
    80004f88:	fc06                	sd	ra,56(sp)
    80004f8a:	f822                	sd	s0,48(sp)
    80004f8c:	f426                	sd	s1,40(sp)
    80004f8e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f90:	ffffc097          	auipc	ra,0xffffc
    80004f94:	f02080e7          	jalr	-254(ra) # 80000e92 <myproc>
    80004f98:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f9a:	fd840593          	addi	a1,s0,-40
    80004f9e:	4501                	li	a0,0
    80004fa0:	ffffd097          	auipc	ra,0xffffd
    80004fa4:	028080e7          	jalr	40(ra) # 80001fc8 <argaddr>
    return -1;
    80004fa8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004faa:	0e054063          	bltz	a0,8000508a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fae:	fc840593          	addi	a1,s0,-56
    80004fb2:	fd040513          	addi	a0,s0,-48
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	dfc080e7          	jalr	-516(ra) # 80003db2 <pipealloc>
    return -1;
    80004fbe:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fc0:	0c054563          	bltz	a0,8000508a <sys_pipe+0x104>
  fd0 = -1;
    80004fc4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fc8:	fd043503          	ld	a0,-48(s0)
    80004fcc:	fffff097          	auipc	ra,0xfffff
    80004fd0:	508080e7          	jalr	1288(ra) # 800044d4 <fdalloc>
    80004fd4:	fca42223          	sw	a0,-60(s0)
    80004fd8:	08054c63          	bltz	a0,80005070 <sys_pipe+0xea>
    80004fdc:	fc843503          	ld	a0,-56(s0)
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	4f4080e7          	jalr	1268(ra) # 800044d4 <fdalloc>
    80004fe8:	fca42023          	sw	a0,-64(s0)
    80004fec:	06054863          	bltz	a0,8000505c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff0:	4691                	li	a3,4
    80004ff2:	fc440613          	addi	a2,s0,-60
    80004ff6:	fd843583          	ld	a1,-40(s0)
    80004ffa:	68a8                	ld	a0,80(s1)
    80004ffc:	ffffc097          	auipc	ra,0xffffc
    80005000:	b58080e7          	jalr	-1192(ra) # 80000b54 <copyout>
    80005004:	02054063          	bltz	a0,80005024 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005008:	4691                	li	a3,4
    8000500a:	fc040613          	addi	a2,s0,-64
    8000500e:	fd843583          	ld	a1,-40(s0)
    80005012:	0591                	addi	a1,a1,4
    80005014:	68a8                	ld	a0,80(s1)
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	b3e080e7          	jalr	-1218(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000501e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005020:	06055563          	bgez	a0,8000508a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005024:	fc442783          	lw	a5,-60(s0)
    80005028:	07e9                	addi	a5,a5,26
    8000502a:	078e                	slli	a5,a5,0x3
    8000502c:	97a6                	add	a5,a5,s1
    8000502e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005032:	fc042503          	lw	a0,-64(s0)
    80005036:	0569                	addi	a0,a0,26
    80005038:	050e                	slli	a0,a0,0x3
    8000503a:	9526                	add	a0,a0,s1
    8000503c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005040:	fd043503          	ld	a0,-48(s0)
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	a3e080e7          	jalr	-1474(ra) # 80003a82 <fileclose>
    fileclose(wf);
    8000504c:	fc843503          	ld	a0,-56(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	a32080e7          	jalr	-1486(ra) # 80003a82 <fileclose>
    return -1;
    80005058:	57fd                	li	a5,-1
    8000505a:	a805                	j	8000508a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000505c:	fc442783          	lw	a5,-60(s0)
    80005060:	0007c863          	bltz	a5,80005070 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005064:	01a78513          	addi	a0,a5,26
    80005068:	050e                	slli	a0,a0,0x3
    8000506a:	9526                	add	a0,a0,s1
    8000506c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005070:	fd043503          	ld	a0,-48(s0)
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	a0e080e7          	jalr	-1522(ra) # 80003a82 <fileclose>
    fileclose(wf);
    8000507c:	fc843503          	ld	a0,-56(s0)
    80005080:	fffff097          	auipc	ra,0xfffff
    80005084:	a02080e7          	jalr	-1534(ra) # 80003a82 <fileclose>
    return -1;
    80005088:	57fd                	li	a5,-1
}
    8000508a:	853e                	mv	a0,a5
    8000508c:	70e2                	ld	ra,56(sp)
    8000508e:	7442                	ld	s0,48(sp)
    80005090:	74a2                	ld	s1,40(sp)
    80005092:	6121                	addi	sp,sp,64
    80005094:	8082                	ret
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	cf9fc0ef          	jal	ra,80001dd8 <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	cee080e7          	jalr	-786(ra) # 80000e66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	953e                	add	a0,a0,a5
    8000519c:	00052023          	sw	zero,0(a0)
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	cb6080e7          	jalr	-842(ra) # 80000e66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5179b          	slliw	a5,a0,0xd
    800051bc:	0c201537          	lui	a0,0xc201
    800051c0:	953e                	add	a0,a0,a5
  return irq;
}
    800051c2:	4148                	lw	a0,4(a0)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c8e080e7          	jalr	-882(ra) # 80000e66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	06a7c963          	blt	a5,a0,80005272 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00016797          	auipc	a5,0x16
    80005208:	dfc78793          	addi	a5,a5,-516 # 8001b000 <disk>
    8000520c:	00a78733          	add	a4,a5,a0
    80005210:	6789                	lui	a5,0x2
    80005212:	97ba                	add	a5,a5,a4
    80005214:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005218:	e7ad                	bnez	a5,80005282 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000521a:	00451793          	slli	a5,a0,0x4
    8000521e:	00018717          	auipc	a4,0x18
    80005222:	de270713          	addi	a4,a4,-542 # 8001d000 <disk+0x2000>
    80005226:	6314                	ld	a3,0(a4)
    80005228:	96be                	add	a3,a3,a5
    8000522a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000522e:	6314                	ld	a3,0(a4)
    80005230:	96be                	add	a3,a3,a5
    80005232:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000523e:	6318                	ld	a4,0(a4)
    80005240:	97ba                	add	a5,a5,a4
    80005242:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005246:	00016797          	auipc	a5,0x16
    8000524a:	dba78793          	addi	a5,a5,-582 # 8001b000 <disk>
    8000524e:	97aa                	add	a5,a5,a0
    80005250:	6509                	lui	a0,0x2
    80005252:	953e                	add	a0,a0,a5
    80005254:	4785                	li	a5,1
    80005256:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000525a:	00018517          	auipc	a0,0x18
    8000525e:	dbe50513          	addi	a0,a0,-578 # 8001d018 <disk+0x2018>
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	480080e7          	jalr	1152(ra) # 800016e2 <wakeup>
}
    8000526a:	60a2                	ld	ra,8(sp)
    8000526c:	6402                	ld	s0,0(sp)
    8000526e:	0141                	addi	sp,sp,16
    80005270:	8082                	ret
    panic("free_desc 1");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	54e50513          	addi	a0,a0,1358 # 800087c0 <syscalls+0x328>
    8000527a:	00001097          	auipc	ra,0x1
    8000527e:	a1e080e7          	jalr	-1506(ra) # 80005c98 <panic>
    panic("free_desc 2");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	54e50513          	addi	a0,a0,1358 # 800087d0 <syscalls+0x338>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	a0e080e7          	jalr	-1522(ra) # 80005c98 <panic>

0000000080005292 <virtio_disk_init>:
{
    80005292:	1101                	addi	sp,sp,-32
    80005294:	ec06                	sd	ra,24(sp)
    80005296:	e822                	sd	s0,16(sp)
    80005298:	e426                	sd	s1,8(sp)
    8000529a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000529c:	00003597          	auipc	a1,0x3
    800052a0:	54458593          	addi	a1,a1,1348 # 800087e0 <syscalls+0x348>
    800052a4:	00018517          	auipc	a0,0x18
    800052a8:	e8450513          	addi	a0,a0,-380 # 8001d128 <disk+0x2128>
    800052ac:	00001097          	auipc	ra,0x1
    800052b0:	ea6080e7          	jalr	-346(ra) # 80006152 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	4398                	lw	a4,0(a5)
    800052ba:	2701                	sext.w	a4,a4
    800052bc:	747277b7          	lui	a5,0x74727
    800052c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052c4:	0ef71163          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	43dc                	lw	a5,4(a5)
    800052ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d0:	4705                	li	a4,1
    800052d2:	0ce79a63          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	100017b7          	lui	a5,0x10001
    800052da:	479c                	lw	a5,8(a5)
    800052dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052de:	4709                	li	a4,2
    800052e0:	0ce79363          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	47d8                	lw	a4,12(a5)
    800052ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ec:	554d47b7          	lui	a5,0x554d4
    800052f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052f4:	0af71963          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	4705                	li	a4,1
    800052fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	470d                	li	a4,3
    80005302:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005304:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005306:	c7ffe737          	lui	a4,0xc7ffe
    8000530a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000530e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	2701                	sext.w	a4,a4
    80005312:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005314:	472d                	li	a4,11
    80005316:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005318:	473d                	li	a4,15
    8000531a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000531c:	6705                	lui	a4,0x1
    8000531e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005320:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005324:	5bdc                	lw	a5,52(a5)
    80005326:	2781                	sext.w	a5,a5
  if(max == 0)
    80005328:	c7d9                	beqz	a5,800053b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000532a:	471d                	li	a4,7
    8000532c:	08f77d63          	bgeu	a4,a5,800053c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005330:	100014b7          	lui	s1,0x10001
    80005334:	47a1                	li	a5,8
    80005336:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005338:	6609                	lui	a2,0x2
    8000533a:	4581                	li	a1,0
    8000533c:	00016517          	auipc	a0,0x16
    80005340:	cc450513          	addi	a0,a0,-828 # 8001b000 <disk>
    80005344:	ffffb097          	auipc	ra,0xffffb
    80005348:	e7e080e7          	jalr	-386(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000534c:	00016717          	auipc	a4,0x16
    80005350:	cb470713          	addi	a4,a4,-844 # 8001b000 <disk>
    80005354:	00c75793          	srli	a5,a4,0xc
    80005358:	2781                	sext.w	a5,a5
    8000535a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000535c:	00018797          	auipc	a5,0x18
    80005360:	ca478793          	addi	a5,a5,-860 # 8001d000 <disk+0x2000>
    80005364:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005366:	00016717          	auipc	a4,0x16
    8000536a:	d1a70713          	addi	a4,a4,-742 # 8001b080 <disk+0x80>
    8000536e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005370:	00017717          	auipc	a4,0x17
    80005374:	c9070713          	addi	a4,a4,-880 # 8001c000 <disk+0x1000>
    80005378:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000537a:	4705                	li	a4,1
    8000537c:	00e78c23          	sb	a4,24(a5)
    80005380:	00e78ca3          	sb	a4,25(a5)
    80005384:	00e78d23          	sb	a4,26(a5)
    80005388:	00e78da3          	sb	a4,27(a5)
    8000538c:	00e78e23          	sb	a4,28(a5)
    80005390:	00e78ea3          	sb	a4,29(a5)
    80005394:	00e78f23          	sb	a4,30(a5)
    80005398:	00e78fa3          	sb	a4,31(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret
    panic("could not find virtio disk");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	44a50513          	addi	a0,a0,1098 # 800087f0 <syscalls+0x358>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	8ea080e7          	jalr	-1814(ra) # 80005c98 <panic>
    panic("virtio disk has no queue 0");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	45a50513          	addi	a0,a0,1114 # 80008810 <syscalls+0x378>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8da080e7          	jalr	-1830(ra) # 80005c98 <panic>
    panic("virtio disk max queue too short");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	46a50513          	addi	a0,a0,1130 # 80008830 <syscalls+0x398>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	8ca080e7          	jalr	-1846(ra) # 80005c98 <panic>

00000000800053d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053d6:	7159                	addi	sp,sp,-112
    800053d8:	f486                	sd	ra,104(sp)
    800053da:	f0a2                	sd	s0,96(sp)
    800053dc:	eca6                	sd	s1,88(sp)
    800053de:	e8ca                	sd	s2,80(sp)
    800053e0:	e4ce                	sd	s3,72(sp)
    800053e2:	e0d2                	sd	s4,64(sp)
    800053e4:	fc56                	sd	s5,56(sp)
    800053e6:	f85a                	sd	s6,48(sp)
    800053e8:	f45e                	sd	s7,40(sp)
    800053ea:	f062                	sd	s8,32(sp)
    800053ec:	ec66                	sd	s9,24(sp)
    800053ee:	e86a                	sd	s10,16(sp)
    800053f0:	1880                	addi	s0,sp,112
    800053f2:	892a                	mv	s2,a0
    800053f4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053f6:	00c52c83          	lw	s9,12(a0)
    800053fa:	001c9c9b          	slliw	s9,s9,0x1
    800053fe:	1c82                	slli	s9,s9,0x20
    80005400:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005404:	00018517          	auipc	a0,0x18
    80005408:	d2450513          	addi	a0,a0,-732 # 8001d128 <disk+0x2128>
    8000540c:	00001097          	auipc	ra,0x1
    80005410:	dd6080e7          	jalr	-554(ra) # 800061e2 <acquire>
  for(int i = 0; i < 3; i++){
    80005414:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005416:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005418:	00016b97          	auipc	s7,0x16
    8000541c:	be8b8b93          	addi	s7,s7,-1048 # 8001b000 <disk>
    80005420:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005422:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005424:	8a4e                	mv	s4,s3
    80005426:	a051                	j	800054aa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005428:	00fb86b3          	add	a3,s7,a5
    8000542c:	96da                	add	a3,a3,s6
    8000542e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005432:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005434:	0207c563          	bltz	a5,8000545e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005438:	2485                	addiw	s1,s1,1
    8000543a:	0711                	addi	a4,a4,4
    8000543c:	25548063          	beq	s1,s5,8000567c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005440:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005442:	00018697          	auipc	a3,0x18
    80005446:	bd668693          	addi	a3,a3,-1066 # 8001d018 <disk+0x2018>
    8000544a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000544c:	0006c583          	lbu	a1,0(a3)
    80005450:	fde1                	bnez	a1,80005428 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005452:	2785                	addiw	a5,a5,1
    80005454:	0685                	addi	a3,a3,1
    80005456:	ff879be3          	bne	a5,s8,8000544c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000545a:	57fd                	li	a5,-1
    8000545c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000545e:	02905a63          	blez	s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005462:	f9042503          	lw	a0,-112(s0)
    80005466:	00000097          	auipc	ra,0x0
    8000546a:	d90080e7          	jalr	-624(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    8000546e:	4785                	li	a5,1
    80005470:	0297d163          	bge	a5,s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005474:	f9442503          	lw	a0,-108(s0)
    80005478:	00000097          	auipc	ra,0x0
    8000547c:	d7e080e7          	jalr	-642(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005480:	4789                	li	a5,2
    80005482:	0097d863          	bge	a5,s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005486:	f9842503          	lw	a0,-104(s0)
    8000548a:	00000097          	auipc	ra,0x0
    8000548e:	d6c080e7          	jalr	-660(ra) # 800051f6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005492:	00018597          	auipc	a1,0x18
    80005496:	c9658593          	addi	a1,a1,-874 # 8001d128 <disk+0x2128>
    8000549a:	00018517          	auipc	a0,0x18
    8000549e:	b7e50513          	addi	a0,a0,-1154 # 8001d018 <disk+0x2018>
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	0b4080e7          	jalr	180(ra) # 80001556 <sleep>
  for(int i = 0; i < 3; i++){
    800054aa:	f9040713          	addi	a4,s0,-112
    800054ae:	84ce                	mv	s1,s3
    800054b0:	bf41                	j	80005440 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054b2:	20058713          	addi	a4,a1,512
    800054b6:	00471693          	slli	a3,a4,0x4
    800054ba:	00016717          	auipc	a4,0x16
    800054be:	b4670713          	addi	a4,a4,-1210 # 8001b000 <disk>
    800054c2:	9736                	add	a4,a4,a3
    800054c4:	4685                	li	a3,1
    800054c6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054ca:	20058713          	addi	a4,a1,512
    800054ce:	00471693          	slli	a3,a4,0x4
    800054d2:	00016717          	auipc	a4,0x16
    800054d6:	b2e70713          	addi	a4,a4,-1234 # 8001b000 <disk>
    800054da:	9736                	add	a4,a4,a3
    800054dc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054e0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e4:	7679                	lui	a2,0xffffe
    800054e6:	963e                	add	a2,a2,a5
    800054e8:	00018697          	auipc	a3,0x18
    800054ec:	b1868693          	addi	a3,a3,-1256 # 8001d000 <disk+0x2000>
    800054f0:	6298                	ld	a4,0(a3)
    800054f2:	9732                	add	a4,a4,a2
    800054f4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054f6:	6298                	ld	a4,0(a3)
    800054f8:	9732                	add	a4,a4,a2
    800054fa:	4541                	li	a0,16
    800054fc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054fe:	6298                	ld	a4,0(a3)
    80005500:	9732                	add	a4,a4,a2
    80005502:	4505                	li	a0,1
    80005504:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005508:	f9442703          	lw	a4,-108(s0)
    8000550c:	6288                	ld	a0,0(a3)
    8000550e:	962a                	add	a2,a2,a0
    80005510:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005514:	0712                	slli	a4,a4,0x4
    80005516:	6290                	ld	a2,0(a3)
    80005518:	963a                	add	a2,a2,a4
    8000551a:	05890513          	addi	a0,s2,88
    8000551e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005520:	6294                	ld	a3,0(a3)
    80005522:	96ba                	add	a3,a3,a4
    80005524:	40000613          	li	a2,1024
    80005528:	c690                	sw	a2,8(a3)
  if(write)
    8000552a:	140d0063          	beqz	s10,8000566a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000552e:	00018697          	auipc	a3,0x18
    80005532:	ad26b683          	ld	a3,-1326(a3) # 8001d000 <disk+0x2000>
    80005536:	96ba                	add	a3,a3,a4
    80005538:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000553c:	00016817          	auipc	a6,0x16
    80005540:	ac480813          	addi	a6,a6,-1340 # 8001b000 <disk>
    80005544:	00018517          	auipc	a0,0x18
    80005548:	abc50513          	addi	a0,a0,-1348 # 8001d000 <disk+0x2000>
    8000554c:	6114                	ld	a3,0(a0)
    8000554e:	96ba                	add	a3,a3,a4
    80005550:	00c6d603          	lhu	a2,12(a3)
    80005554:	00166613          	ori	a2,a2,1
    80005558:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000555c:	f9842683          	lw	a3,-104(s0)
    80005560:	6110                	ld	a2,0(a0)
    80005562:	9732                	add	a4,a4,a2
    80005564:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005568:	20058613          	addi	a2,a1,512
    8000556c:	0612                	slli	a2,a2,0x4
    8000556e:	9642                	add	a2,a2,a6
    80005570:	577d                	li	a4,-1
    80005572:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005576:	00469713          	slli	a4,a3,0x4
    8000557a:	6114                	ld	a3,0(a0)
    8000557c:	96ba                	add	a3,a3,a4
    8000557e:	03078793          	addi	a5,a5,48
    80005582:	97c2                	add	a5,a5,a6
    80005584:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005586:	611c                	ld	a5,0(a0)
    80005588:	97ba                	add	a5,a5,a4
    8000558a:	4685                	li	a3,1
    8000558c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000558e:	611c                	ld	a5,0(a0)
    80005590:	97ba                	add	a5,a5,a4
    80005592:	4809                	li	a6,2
    80005594:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005598:	611c                	ld	a5,0(a0)
    8000559a:	973e                	add	a4,a4,a5
    8000559c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055a0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055a4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055a8:	6518                	ld	a4,8(a0)
    800055aa:	00275783          	lhu	a5,2(a4)
    800055ae:	8b9d                	andi	a5,a5,7
    800055b0:	0786                	slli	a5,a5,0x1
    800055b2:	97ba                	add	a5,a5,a4
    800055b4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055b8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055bc:	6518                	ld	a4,8(a0)
    800055be:	00275783          	lhu	a5,2(a4)
    800055c2:	2785                	addiw	a5,a5,1
    800055c4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055c8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055cc:	100017b7          	lui	a5,0x10001
    800055d0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055d4:	00492703          	lw	a4,4(s2)
    800055d8:	4785                	li	a5,1
    800055da:	02f71163          	bne	a4,a5,800055fc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055de:	00018997          	auipc	s3,0x18
    800055e2:	b4a98993          	addi	s3,s3,-1206 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055e6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055e8:	85ce                	mv	a1,s3
    800055ea:	854a                	mv	a0,s2
    800055ec:	ffffc097          	auipc	ra,0xffffc
    800055f0:	f6a080e7          	jalr	-150(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    800055f4:	00492783          	lw	a5,4(s2)
    800055f8:	fe9788e3          	beq	a5,s1,800055e8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055fc:	f9042903          	lw	s2,-112(s0)
    80005600:	20090793          	addi	a5,s2,512
    80005604:	00479713          	slli	a4,a5,0x4
    80005608:	00016797          	auipc	a5,0x16
    8000560c:	9f878793          	addi	a5,a5,-1544 # 8001b000 <disk>
    80005610:	97ba                	add	a5,a5,a4
    80005612:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005616:	00018997          	auipc	s3,0x18
    8000561a:	9ea98993          	addi	s3,s3,-1558 # 8001d000 <disk+0x2000>
    8000561e:	00491713          	slli	a4,s2,0x4
    80005622:	0009b783          	ld	a5,0(s3)
    80005626:	97ba                	add	a5,a5,a4
    80005628:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000562c:	854a                	mv	a0,s2
    8000562e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005632:	00000097          	auipc	ra,0x0
    80005636:	bc4080e7          	jalr	-1084(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000563a:	8885                	andi	s1,s1,1
    8000563c:	f0ed                	bnez	s1,8000561e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000563e:	00018517          	auipc	a0,0x18
    80005642:	aea50513          	addi	a0,a0,-1302 # 8001d128 <disk+0x2128>
    80005646:	00001097          	auipc	ra,0x1
    8000564a:	c50080e7          	jalr	-944(ra) # 80006296 <release>
}
    8000564e:	70a6                	ld	ra,104(sp)
    80005650:	7406                	ld	s0,96(sp)
    80005652:	64e6                	ld	s1,88(sp)
    80005654:	6946                	ld	s2,80(sp)
    80005656:	69a6                	ld	s3,72(sp)
    80005658:	6a06                	ld	s4,64(sp)
    8000565a:	7ae2                	ld	s5,56(sp)
    8000565c:	7b42                	ld	s6,48(sp)
    8000565e:	7ba2                	ld	s7,40(sp)
    80005660:	7c02                	ld	s8,32(sp)
    80005662:	6ce2                	ld	s9,24(sp)
    80005664:	6d42                	ld	s10,16(sp)
    80005666:	6165                	addi	sp,sp,112
    80005668:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000566a:	00018697          	auipc	a3,0x18
    8000566e:	9966b683          	ld	a3,-1642(a3) # 8001d000 <disk+0x2000>
    80005672:	96ba                	add	a3,a3,a4
    80005674:	4609                	li	a2,2
    80005676:	00c69623          	sh	a2,12(a3)
    8000567a:	b5c9                	j	8000553c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000567c:	f9042583          	lw	a1,-112(s0)
    80005680:	20058793          	addi	a5,a1,512
    80005684:	0792                	slli	a5,a5,0x4
    80005686:	00016517          	auipc	a0,0x16
    8000568a:	a2250513          	addi	a0,a0,-1502 # 8001b0a8 <disk+0xa8>
    8000568e:	953e                	add	a0,a0,a5
  if(write)
    80005690:	e20d11e3          	bnez	s10,800054b2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005694:	20058713          	addi	a4,a1,512
    80005698:	00471693          	slli	a3,a4,0x4
    8000569c:	00016717          	auipc	a4,0x16
    800056a0:	96470713          	addi	a4,a4,-1692 # 8001b000 <disk>
    800056a4:	9736                	add	a4,a4,a3
    800056a6:	0a072423          	sw	zero,168(a4)
    800056aa:	b505                	j	800054ca <virtio_disk_rw+0xf4>

00000000800056ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056ac:	1101                	addi	sp,sp,-32
    800056ae:	ec06                	sd	ra,24(sp)
    800056b0:	e822                	sd	s0,16(sp)
    800056b2:	e426                	sd	s1,8(sp)
    800056b4:	e04a                	sd	s2,0(sp)
    800056b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056b8:	00018517          	auipc	a0,0x18
    800056bc:	a7050513          	addi	a0,a0,-1424 # 8001d128 <disk+0x2128>
    800056c0:	00001097          	auipc	ra,0x1
    800056c4:	b22080e7          	jalr	-1246(ra) # 800061e2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056c8:	10001737          	lui	a4,0x10001
    800056cc:	533c                	lw	a5,96(a4)
    800056ce:	8b8d                	andi	a5,a5,3
    800056d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056d6:	00018797          	auipc	a5,0x18
    800056da:	92a78793          	addi	a5,a5,-1750 # 8001d000 <disk+0x2000>
    800056de:	6b94                	ld	a3,16(a5)
    800056e0:	0207d703          	lhu	a4,32(a5)
    800056e4:	0026d783          	lhu	a5,2(a3)
    800056e8:	06f70163          	beq	a4,a5,8000574a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ec:	00016917          	auipc	s2,0x16
    800056f0:	91490913          	addi	s2,s2,-1772 # 8001b000 <disk>
    800056f4:	00018497          	auipc	s1,0x18
    800056f8:	90c48493          	addi	s1,s1,-1780 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056fc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005700:	6898                	ld	a4,16(s1)
    80005702:	0204d783          	lhu	a5,32(s1)
    80005706:	8b9d                	andi	a5,a5,7
    80005708:	078e                	slli	a5,a5,0x3
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000570e:	20078713          	addi	a4,a5,512
    80005712:	0712                	slli	a4,a4,0x4
    80005714:	974a                	add	a4,a4,s2
    80005716:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000571a:	e731                	bnez	a4,80005766 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000571c:	20078793          	addi	a5,a5,512
    80005720:	0792                	slli	a5,a5,0x4
    80005722:	97ca                	add	a5,a5,s2
    80005724:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005726:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000572a:	ffffc097          	auipc	ra,0xffffc
    8000572e:	fb8080e7          	jalr	-72(ra) # 800016e2 <wakeup>

    disk.used_idx += 1;
    80005732:	0204d783          	lhu	a5,32(s1)
    80005736:	2785                	addiw	a5,a5,1
    80005738:	17c2                	slli	a5,a5,0x30
    8000573a:	93c1                	srli	a5,a5,0x30
    8000573c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005740:	6898                	ld	a4,16(s1)
    80005742:	00275703          	lhu	a4,2(a4)
    80005746:	faf71be3          	bne	a4,a5,800056fc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000574a:	00018517          	auipc	a0,0x18
    8000574e:	9de50513          	addi	a0,a0,-1570 # 8001d128 <disk+0x2128>
    80005752:	00001097          	auipc	ra,0x1
    80005756:	b44080e7          	jalr	-1212(ra) # 80006296 <release>
}
    8000575a:	60e2                	ld	ra,24(sp)
    8000575c:	6442                	ld	s0,16(sp)
    8000575e:	64a2                	ld	s1,8(sp)
    80005760:	6902                	ld	s2,0(sp)
    80005762:	6105                	addi	sp,sp,32
    80005764:	8082                	ret
      panic("virtio_disk_intr status");
    80005766:	00003517          	auipc	a0,0x3
    8000576a:	0ea50513          	addi	a0,a0,234 # 80008850 <syscalls+0x3b8>
    8000576e:	00000097          	auipc	ra,0x0
    80005772:	52a080e7          	jalr	1322(ra) # 80005c98 <panic>

0000000080005776 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005776:	1141                	addi	sp,sp,-16
    80005778:	e422                	sd	s0,8(sp)
    8000577a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000577c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005780:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005784:	0037979b          	slliw	a5,a5,0x3
    80005788:	02004737          	lui	a4,0x2004
    8000578c:	97ba                	add	a5,a5,a4
    8000578e:	0200c737          	lui	a4,0x200c
    80005792:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005796:	000f4637          	lui	a2,0xf4
    8000579a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000579e:	95b2                	add	a1,a1,a2
    800057a0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057a2:	00269713          	slli	a4,a3,0x2
    800057a6:	9736                	add	a4,a4,a3
    800057a8:	00371693          	slli	a3,a4,0x3
    800057ac:	00019717          	auipc	a4,0x19
    800057b0:	85470713          	addi	a4,a4,-1964 # 8001e000 <timer_scratch>
    800057b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057be:	00000797          	auipc	a5,0x0
    800057c2:	97278793          	addi	a5,a5,-1678 # 80005130 <timervec>
    800057c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057de:	30479073          	csrw	mie,a5
}
    800057e2:	6422                	ld	s0,8(sp)
    800057e4:	0141                	addi	sp,sp,16
    800057e6:	8082                	ret

00000000800057e8 <start>:
{
    800057e8:	1141                	addi	sp,sp,-16
    800057ea:	e406                	sd	ra,8(sp)
    800057ec:	e022                	sd	s0,0(sp)
    800057ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057f4:	7779                	lui	a4,0xffffe
    800057f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057fc:	6705                	lui	a4,0x1
    800057fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005802:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005804:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005808:	ffffb797          	auipc	a5,0xffffb
    8000580c:	b6878793          	addi	a5,a5,-1176 # 80000370 <main>
    80005810:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005814:	4781                	li	a5,0
    80005816:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000581a:	67c1                	lui	a5,0x10
    8000581c:	17fd                	addi	a5,a5,-1
    8000581e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005822:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005826:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000582a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000582e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005832:	57fd                	li	a5,-1
    80005834:	83a9                	srli	a5,a5,0xa
    80005836:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000583a:	47bd                	li	a5,15
    8000583c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005840:	00000097          	auipc	ra,0x0
    80005844:	f36080e7          	jalr	-202(ra) # 80005776 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005848:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000584c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000584e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005850:	30200073          	mret
}
    80005854:	60a2                	ld	ra,8(sp)
    80005856:	6402                	ld	s0,0(sp)
    80005858:	0141                	addi	sp,sp,16
    8000585a:	8082                	ret

000000008000585c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000585c:	715d                	addi	sp,sp,-80
    8000585e:	e486                	sd	ra,72(sp)
    80005860:	e0a2                	sd	s0,64(sp)
    80005862:	fc26                	sd	s1,56(sp)
    80005864:	f84a                	sd	s2,48(sp)
    80005866:	f44e                	sd	s3,40(sp)
    80005868:	f052                	sd	s4,32(sp)
    8000586a:	ec56                	sd	s5,24(sp)
    8000586c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000586e:	04c05663          	blez	a2,800058ba <consolewrite+0x5e>
    80005872:	8a2a                	mv	s4,a0
    80005874:	84ae                	mv	s1,a1
    80005876:	89b2                	mv	s3,a2
    80005878:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000587a:	5afd                	li	s5,-1
    8000587c:	4685                	li	a3,1
    8000587e:	8626                	mv	a2,s1
    80005880:	85d2                	mv	a1,s4
    80005882:	fbf40513          	addi	a0,s0,-65
    80005886:	ffffc097          	auipc	ra,0xffffc
    8000588a:	0ca080e7          	jalr	202(ra) # 80001950 <either_copyin>
    8000588e:	01550c63          	beq	a0,s5,800058a6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005892:	fbf44503          	lbu	a0,-65(s0)
    80005896:	00000097          	auipc	ra,0x0
    8000589a:	78e080e7          	jalr	1934(ra) # 80006024 <uartputc>
  for(i = 0; i < n; i++){
    8000589e:	2905                	addiw	s2,s2,1
    800058a0:	0485                	addi	s1,s1,1
    800058a2:	fd299de3          	bne	s3,s2,8000587c <consolewrite+0x20>
  }

  return i;
}
    800058a6:	854a                	mv	a0,s2
    800058a8:	60a6                	ld	ra,72(sp)
    800058aa:	6406                	ld	s0,64(sp)
    800058ac:	74e2                	ld	s1,56(sp)
    800058ae:	7942                	ld	s2,48(sp)
    800058b0:	79a2                	ld	s3,40(sp)
    800058b2:	7a02                	ld	s4,32(sp)
    800058b4:	6ae2                	ld	s5,24(sp)
    800058b6:	6161                	addi	sp,sp,80
    800058b8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ba:	4901                	li	s2,0
    800058bc:	b7ed                	j	800058a6 <consolewrite+0x4a>

00000000800058be <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058be:	7119                	addi	sp,sp,-128
    800058c0:	fc86                	sd	ra,120(sp)
    800058c2:	f8a2                	sd	s0,112(sp)
    800058c4:	f4a6                	sd	s1,104(sp)
    800058c6:	f0ca                	sd	s2,96(sp)
    800058c8:	ecce                	sd	s3,88(sp)
    800058ca:	e8d2                	sd	s4,80(sp)
    800058cc:	e4d6                	sd	s5,72(sp)
    800058ce:	e0da                	sd	s6,64(sp)
    800058d0:	fc5e                	sd	s7,56(sp)
    800058d2:	f862                	sd	s8,48(sp)
    800058d4:	f466                	sd	s9,40(sp)
    800058d6:	f06a                	sd	s10,32(sp)
    800058d8:	ec6e                	sd	s11,24(sp)
    800058da:	0100                	addi	s0,sp,128
    800058dc:	8b2a                	mv	s6,a0
    800058de:	8aae                	mv	s5,a1
    800058e0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058e2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058e6:	00021517          	auipc	a0,0x21
    800058ea:	85a50513          	addi	a0,a0,-1958 # 80026140 <cons>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	8f4080e7          	jalr	-1804(ra) # 800061e2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058f6:	00021497          	auipc	s1,0x21
    800058fa:	84a48493          	addi	s1,s1,-1974 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058fe:	89a6                	mv	s3,s1
    80005900:	00021917          	auipc	s2,0x21
    80005904:	8d890913          	addi	s2,s2,-1832 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005908:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000590a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000590c:	4da9                	li	s11,10
  while(n > 0){
    8000590e:	07405863          	blez	s4,8000597e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005912:	0984a783          	lw	a5,152(s1)
    80005916:	09c4a703          	lw	a4,156(s1)
    8000591a:	02f71463          	bne	a4,a5,80005942 <consoleread+0x84>
      if(myproc()->killed){
    8000591e:	ffffb097          	auipc	ra,0xffffb
    80005922:	574080e7          	jalr	1396(ra) # 80000e92 <myproc>
    80005926:	551c                	lw	a5,40(a0)
    80005928:	e7b5                	bnez	a5,80005994 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000592a:	85ce                	mv	a1,s3
    8000592c:	854a                	mv	a0,s2
    8000592e:	ffffc097          	auipc	ra,0xffffc
    80005932:	c28080e7          	jalr	-984(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    80005936:	0984a783          	lw	a5,152(s1)
    8000593a:	09c4a703          	lw	a4,156(s1)
    8000593e:	fef700e3          	beq	a4,a5,8000591e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005942:	0017871b          	addiw	a4,a5,1
    80005946:	08e4ac23          	sw	a4,152(s1)
    8000594a:	07f7f713          	andi	a4,a5,127
    8000594e:	9726                	add	a4,a4,s1
    80005950:	01874703          	lbu	a4,24(a4)
    80005954:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005958:	079c0663          	beq	s8,s9,800059c4 <consoleread+0x106>
    cbuf = c;
    8000595c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005960:	4685                	li	a3,1
    80005962:	f8f40613          	addi	a2,s0,-113
    80005966:	85d6                	mv	a1,s5
    80005968:	855a                	mv	a0,s6
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	f90080e7          	jalr	-112(ra) # 800018fa <either_copyout>
    80005972:	01a50663          	beq	a0,s10,8000597e <consoleread+0xc0>
    dst++;
    80005976:	0a85                	addi	s5,s5,1
    --n;
    80005978:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000597a:	f9bc1ae3          	bne	s8,s11,8000590e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000597e:	00020517          	auipc	a0,0x20
    80005982:	7c250513          	addi	a0,a0,1986 # 80026140 <cons>
    80005986:	00001097          	auipc	ra,0x1
    8000598a:	910080e7          	jalr	-1776(ra) # 80006296 <release>

  return target - n;
    8000598e:	414b853b          	subw	a0,s7,s4
    80005992:	a811                	j	800059a6 <consoleread+0xe8>
        release(&cons.lock);
    80005994:	00020517          	auipc	a0,0x20
    80005998:	7ac50513          	addi	a0,a0,1964 # 80026140 <cons>
    8000599c:	00001097          	auipc	ra,0x1
    800059a0:	8fa080e7          	jalr	-1798(ra) # 80006296 <release>
        return -1;
    800059a4:	557d                	li	a0,-1
}
    800059a6:	70e6                	ld	ra,120(sp)
    800059a8:	7446                	ld	s0,112(sp)
    800059aa:	74a6                	ld	s1,104(sp)
    800059ac:	7906                	ld	s2,96(sp)
    800059ae:	69e6                	ld	s3,88(sp)
    800059b0:	6a46                	ld	s4,80(sp)
    800059b2:	6aa6                	ld	s5,72(sp)
    800059b4:	6b06                	ld	s6,64(sp)
    800059b6:	7be2                	ld	s7,56(sp)
    800059b8:	7c42                	ld	s8,48(sp)
    800059ba:	7ca2                	ld	s9,40(sp)
    800059bc:	7d02                	ld	s10,32(sp)
    800059be:	6de2                	ld	s11,24(sp)
    800059c0:	6109                	addi	sp,sp,128
    800059c2:	8082                	ret
      if(n < target){
    800059c4:	000a071b          	sext.w	a4,s4
    800059c8:	fb777be3          	bgeu	a4,s7,8000597e <consoleread+0xc0>
        cons.r--;
    800059cc:	00021717          	auipc	a4,0x21
    800059d0:	80f72623          	sw	a5,-2036(a4) # 800261d8 <cons+0x98>
    800059d4:	b76d                	j	8000597e <consoleread+0xc0>

00000000800059d6 <consputc>:
{
    800059d6:	1141                	addi	sp,sp,-16
    800059d8:	e406                	sd	ra,8(sp)
    800059da:	e022                	sd	s0,0(sp)
    800059dc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059de:	10000793          	li	a5,256
    800059e2:	00f50a63          	beq	a0,a5,800059f6 <consputc+0x20>
    uartputc_sync(c);
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	564080e7          	jalr	1380(ra) # 80005f4a <uartputc_sync>
}
    800059ee:	60a2                	ld	ra,8(sp)
    800059f0:	6402                	ld	s0,0(sp)
    800059f2:	0141                	addi	sp,sp,16
    800059f4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059f6:	4521                	li	a0,8
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	552080e7          	jalr	1362(ra) # 80005f4a <uartputc_sync>
    80005a00:	02000513          	li	a0,32
    80005a04:	00000097          	auipc	ra,0x0
    80005a08:	546080e7          	jalr	1350(ra) # 80005f4a <uartputc_sync>
    80005a0c:	4521                	li	a0,8
    80005a0e:	00000097          	auipc	ra,0x0
    80005a12:	53c080e7          	jalr	1340(ra) # 80005f4a <uartputc_sync>
    80005a16:	bfe1                	j	800059ee <consputc+0x18>

0000000080005a18 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a18:	1101                	addi	sp,sp,-32
    80005a1a:	ec06                	sd	ra,24(sp)
    80005a1c:	e822                	sd	s0,16(sp)
    80005a1e:	e426                	sd	s1,8(sp)
    80005a20:	e04a                	sd	s2,0(sp)
    80005a22:	1000                	addi	s0,sp,32
    80005a24:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a26:	00020517          	auipc	a0,0x20
    80005a2a:	71a50513          	addi	a0,a0,1818 # 80026140 <cons>
    80005a2e:	00000097          	auipc	ra,0x0
    80005a32:	7b4080e7          	jalr	1972(ra) # 800061e2 <acquire>

  switch(c){
    80005a36:	47d5                	li	a5,21
    80005a38:	0af48663          	beq	s1,a5,80005ae4 <consoleintr+0xcc>
    80005a3c:	0297ca63          	blt	a5,s1,80005a70 <consoleintr+0x58>
    80005a40:	47a1                	li	a5,8
    80005a42:	0ef48763          	beq	s1,a5,80005b30 <consoleintr+0x118>
    80005a46:	47c1                	li	a5,16
    80005a48:	10f49a63          	bne	s1,a5,80005b5c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	f5a080e7          	jalr	-166(ra) # 800019a6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a54:	00020517          	auipc	a0,0x20
    80005a58:	6ec50513          	addi	a0,a0,1772 # 80026140 <cons>
    80005a5c:	00001097          	auipc	ra,0x1
    80005a60:	83a080e7          	jalr	-1990(ra) # 80006296 <release>
}
    80005a64:	60e2                	ld	ra,24(sp)
    80005a66:	6442                	ld	s0,16(sp)
    80005a68:	64a2                	ld	s1,8(sp)
    80005a6a:	6902                	ld	s2,0(sp)
    80005a6c:	6105                	addi	sp,sp,32
    80005a6e:	8082                	ret
  switch(c){
    80005a70:	07f00793          	li	a5,127
    80005a74:	0af48e63          	beq	s1,a5,80005b30 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a78:	00020717          	auipc	a4,0x20
    80005a7c:	6c870713          	addi	a4,a4,1736 # 80026140 <cons>
    80005a80:	0a072783          	lw	a5,160(a4)
    80005a84:	09872703          	lw	a4,152(a4)
    80005a88:	9f99                	subw	a5,a5,a4
    80005a8a:	07f00713          	li	a4,127
    80005a8e:	fcf763e3          	bltu	a4,a5,80005a54 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a92:	47b5                	li	a5,13
    80005a94:	0cf48763          	beq	s1,a5,80005b62 <consoleintr+0x14a>
      consputc(c);
    80005a98:	8526                	mv	a0,s1
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	f3c080e7          	jalr	-196(ra) # 800059d6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa2:	00020797          	auipc	a5,0x20
    80005aa6:	69e78793          	addi	a5,a5,1694 # 80026140 <cons>
    80005aaa:	0a07a703          	lw	a4,160(a5)
    80005aae:	0017069b          	addiw	a3,a4,1
    80005ab2:	0006861b          	sext.w	a2,a3
    80005ab6:	0ad7a023          	sw	a3,160(a5)
    80005aba:	07f77713          	andi	a4,a4,127
    80005abe:	97ba                	add	a5,a5,a4
    80005ac0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ac4:	47a9                	li	a5,10
    80005ac6:	0cf48563          	beq	s1,a5,80005b90 <consoleintr+0x178>
    80005aca:	4791                	li	a5,4
    80005acc:	0cf48263          	beq	s1,a5,80005b90 <consoleintr+0x178>
    80005ad0:	00020797          	auipc	a5,0x20
    80005ad4:	7087a783          	lw	a5,1800(a5) # 800261d8 <cons+0x98>
    80005ad8:	0807879b          	addiw	a5,a5,128
    80005adc:	f6f61ce3          	bne	a2,a5,80005a54 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ae0:	863e                	mv	a2,a5
    80005ae2:	a07d                	j	80005b90 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ae4:	00020717          	auipc	a4,0x20
    80005ae8:	65c70713          	addi	a4,a4,1628 # 80026140 <cons>
    80005aec:	0a072783          	lw	a5,160(a4)
    80005af0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005af4:	00020497          	auipc	s1,0x20
    80005af8:	64c48493          	addi	s1,s1,1612 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005afc:	4929                	li	s2,10
    80005afe:	f4f70be3          	beq	a4,a5,80005a54 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b02:	37fd                	addiw	a5,a5,-1
    80005b04:	07f7f713          	andi	a4,a5,127
    80005b08:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b0a:	01874703          	lbu	a4,24(a4)
    80005b0e:	f52703e3          	beq	a4,s2,80005a54 <consoleintr+0x3c>
      cons.e--;
    80005b12:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b16:	10000513          	li	a0,256
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	ebc080e7          	jalr	-324(ra) # 800059d6 <consputc>
    while(cons.e != cons.w &&
    80005b22:	0a04a783          	lw	a5,160(s1)
    80005b26:	09c4a703          	lw	a4,156(s1)
    80005b2a:	fcf71ce3          	bne	a4,a5,80005b02 <consoleintr+0xea>
    80005b2e:	b71d                	j	80005a54 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b30:	00020717          	auipc	a4,0x20
    80005b34:	61070713          	addi	a4,a4,1552 # 80026140 <cons>
    80005b38:	0a072783          	lw	a5,160(a4)
    80005b3c:	09c72703          	lw	a4,156(a4)
    80005b40:	f0f70ae3          	beq	a4,a5,80005a54 <consoleintr+0x3c>
      cons.e--;
    80005b44:	37fd                	addiw	a5,a5,-1
    80005b46:	00020717          	auipc	a4,0x20
    80005b4a:	68f72d23          	sw	a5,1690(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b4e:	10000513          	li	a0,256
    80005b52:	00000097          	auipc	ra,0x0
    80005b56:	e84080e7          	jalr	-380(ra) # 800059d6 <consputc>
    80005b5a:	bded                	j	80005a54 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b5c:	ee048ce3          	beqz	s1,80005a54 <consoleintr+0x3c>
    80005b60:	bf21                	j	80005a78 <consoleintr+0x60>
      consputc(c);
    80005b62:	4529                	li	a0,10
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	e72080e7          	jalr	-398(ra) # 800059d6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b6c:	00020797          	auipc	a5,0x20
    80005b70:	5d478793          	addi	a5,a5,1492 # 80026140 <cons>
    80005b74:	0a07a703          	lw	a4,160(a5)
    80005b78:	0017069b          	addiw	a3,a4,1
    80005b7c:	0006861b          	sext.w	a2,a3
    80005b80:	0ad7a023          	sw	a3,160(a5)
    80005b84:	07f77713          	andi	a4,a4,127
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	4729                	li	a4,10
    80005b8c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b90:	00020797          	auipc	a5,0x20
    80005b94:	64c7a623          	sw	a2,1612(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b98:	00020517          	auipc	a0,0x20
    80005b9c:	64050513          	addi	a0,a0,1600 # 800261d8 <cons+0x98>
    80005ba0:	ffffc097          	auipc	ra,0xffffc
    80005ba4:	b42080e7          	jalr	-1214(ra) # 800016e2 <wakeup>
    80005ba8:	b575                	j	80005a54 <consoleintr+0x3c>

0000000080005baa <consoleinit>:

void
consoleinit(void)
{
    80005baa:	1141                	addi	sp,sp,-16
    80005bac:	e406                	sd	ra,8(sp)
    80005bae:	e022                	sd	s0,0(sp)
    80005bb0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bb2:	00003597          	auipc	a1,0x3
    80005bb6:	cb658593          	addi	a1,a1,-842 # 80008868 <syscalls+0x3d0>
    80005bba:	00020517          	auipc	a0,0x20
    80005bbe:	58650513          	addi	a0,a0,1414 # 80026140 <cons>
    80005bc2:	00000097          	auipc	ra,0x0
    80005bc6:	590080e7          	jalr	1424(ra) # 80006152 <initlock>

  uartinit();
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	330080e7          	jalr	816(ra) # 80005efa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bd2:	00013797          	auipc	a5,0x13
    80005bd6:	6f678793          	addi	a5,a5,1782 # 800192c8 <devsw>
    80005bda:	00000717          	auipc	a4,0x0
    80005bde:	ce470713          	addi	a4,a4,-796 # 800058be <consoleread>
    80005be2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005be4:	00000717          	auipc	a4,0x0
    80005be8:	c7870713          	addi	a4,a4,-904 # 8000585c <consolewrite>
    80005bec:	ef98                	sd	a4,24(a5)
}
    80005bee:	60a2                	ld	ra,8(sp)
    80005bf0:	6402                	ld	s0,0(sp)
    80005bf2:	0141                	addi	sp,sp,16
    80005bf4:	8082                	ret

0000000080005bf6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bf6:	7179                	addi	sp,sp,-48
    80005bf8:	f406                	sd	ra,40(sp)
    80005bfa:	f022                	sd	s0,32(sp)
    80005bfc:	ec26                	sd	s1,24(sp)
    80005bfe:	e84a                	sd	s2,16(sp)
    80005c00:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c02:	c219                	beqz	a2,80005c08 <printint+0x12>
    80005c04:	08054663          	bltz	a0,80005c90 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c08:	2501                	sext.w	a0,a0
    80005c0a:	4881                	li	a7,0
    80005c0c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c10:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c12:	2581                	sext.w	a1,a1
    80005c14:	00003617          	auipc	a2,0x3
    80005c18:	c8460613          	addi	a2,a2,-892 # 80008898 <digits>
    80005c1c:	883a                	mv	a6,a4
    80005c1e:	2705                	addiw	a4,a4,1
    80005c20:	02b577bb          	remuw	a5,a0,a1
    80005c24:	1782                	slli	a5,a5,0x20
    80005c26:	9381                	srli	a5,a5,0x20
    80005c28:	97b2                	add	a5,a5,a2
    80005c2a:	0007c783          	lbu	a5,0(a5)
    80005c2e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c32:	0005079b          	sext.w	a5,a0
    80005c36:	02b5553b          	divuw	a0,a0,a1
    80005c3a:	0685                	addi	a3,a3,1
    80005c3c:	feb7f0e3          	bgeu	a5,a1,80005c1c <printint+0x26>

  if(sign)
    80005c40:	00088b63          	beqz	a7,80005c56 <printint+0x60>
    buf[i++] = '-';
    80005c44:	fe040793          	addi	a5,s0,-32
    80005c48:	973e                	add	a4,a4,a5
    80005c4a:	02d00793          	li	a5,45
    80005c4e:	fef70823          	sb	a5,-16(a4)
    80005c52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c56:	02e05763          	blez	a4,80005c84 <printint+0x8e>
    80005c5a:	fd040793          	addi	a5,s0,-48
    80005c5e:	00e784b3          	add	s1,a5,a4
    80005c62:	fff78913          	addi	s2,a5,-1
    80005c66:	993a                	add	s2,s2,a4
    80005c68:	377d                	addiw	a4,a4,-1
    80005c6a:	1702                	slli	a4,a4,0x20
    80005c6c:	9301                	srli	a4,a4,0x20
    80005c6e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c72:	fff4c503          	lbu	a0,-1(s1)
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	d60080e7          	jalr	-672(ra) # 800059d6 <consputc>
  while(--i >= 0)
    80005c7e:	14fd                	addi	s1,s1,-1
    80005c80:	ff2499e3          	bne	s1,s2,80005c72 <printint+0x7c>
}
    80005c84:	70a2                	ld	ra,40(sp)
    80005c86:	7402                	ld	s0,32(sp)
    80005c88:	64e2                	ld	s1,24(sp)
    80005c8a:	6942                	ld	s2,16(sp)
    80005c8c:	6145                	addi	sp,sp,48
    80005c8e:	8082                	ret
    x = -xx;
    80005c90:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c94:	4885                	li	a7,1
    x = -xx;
    80005c96:	bf9d                	j	80005c0c <printint+0x16>

0000000080005c98 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c98:	1101                	addi	sp,sp,-32
    80005c9a:	ec06                	sd	ra,24(sp)
    80005c9c:	e822                	sd	s0,16(sp)
    80005c9e:	e426                	sd	s1,8(sp)
    80005ca0:	1000                	addi	s0,sp,32
    80005ca2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ca4:	00020797          	auipc	a5,0x20
    80005ca8:	5407ae23          	sw	zero,1372(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cac:	00003517          	auipc	a0,0x3
    80005cb0:	bc450513          	addi	a0,a0,-1084 # 80008870 <syscalls+0x3d8>
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	02e080e7          	jalr	46(ra) # 80005ce2 <printf>
  printf(s);
    80005cbc:	8526                	mv	a0,s1
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	024080e7          	jalr	36(ra) # 80005ce2 <printf>
  printf("\n");
    80005cc6:	00002517          	auipc	a0,0x2
    80005cca:	38250513          	addi	a0,a0,898 # 80008048 <etext+0x48>
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	014080e7          	jalr	20(ra) # 80005ce2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cd6:	4785                	li	a5,1
    80005cd8:	00003717          	auipc	a4,0x3
    80005cdc:	34f72223          	sw	a5,836(a4) # 8000901c <panicked>
  for(;;)
    80005ce0:	a001                	j	80005ce0 <panic+0x48>

0000000080005ce2 <printf>:
{
    80005ce2:	7131                	addi	sp,sp,-192
    80005ce4:	fc86                	sd	ra,120(sp)
    80005ce6:	f8a2                	sd	s0,112(sp)
    80005ce8:	f4a6                	sd	s1,104(sp)
    80005cea:	f0ca                	sd	s2,96(sp)
    80005cec:	ecce                	sd	s3,88(sp)
    80005cee:	e8d2                	sd	s4,80(sp)
    80005cf0:	e4d6                	sd	s5,72(sp)
    80005cf2:	e0da                	sd	s6,64(sp)
    80005cf4:	fc5e                	sd	s7,56(sp)
    80005cf6:	f862                	sd	s8,48(sp)
    80005cf8:	f466                	sd	s9,40(sp)
    80005cfa:	f06a                	sd	s10,32(sp)
    80005cfc:	ec6e                	sd	s11,24(sp)
    80005cfe:	0100                	addi	s0,sp,128
    80005d00:	8a2a                	mv	s4,a0
    80005d02:	e40c                	sd	a1,8(s0)
    80005d04:	e810                	sd	a2,16(s0)
    80005d06:	ec14                	sd	a3,24(s0)
    80005d08:	f018                	sd	a4,32(s0)
    80005d0a:	f41c                	sd	a5,40(s0)
    80005d0c:	03043823          	sd	a6,48(s0)
    80005d10:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d14:	00020d97          	auipc	s11,0x20
    80005d18:	4ecdad83          	lw	s11,1260(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d1c:	020d9b63          	bnez	s11,80005d52 <printf+0x70>
  if (fmt == 0)
    80005d20:	040a0263          	beqz	s4,80005d64 <printf+0x82>
  va_start(ap, fmt);
    80005d24:	00840793          	addi	a5,s0,8
    80005d28:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d2c:	000a4503          	lbu	a0,0(s4)
    80005d30:	16050263          	beqz	a0,80005e94 <printf+0x1b2>
    80005d34:	4481                	li	s1,0
    if(c != '%'){
    80005d36:	02500a93          	li	s5,37
    switch(c){
    80005d3a:	07000b13          	li	s6,112
  consputc('x');
    80005d3e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d40:	00003b97          	auipc	s7,0x3
    80005d44:	b58b8b93          	addi	s7,s7,-1192 # 80008898 <digits>
    switch(c){
    80005d48:	07300c93          	li	s9,115
    80005d4c:	06400c13          	li	s8,100
    80005d50:	a82d                	j	80005d8a <printf+0xa8>
    acquire(&pr.lock);
    80005d52:	00020517          	auipc	a0,0x20
    80005d56:	49650513          	addi	a0,a0,1174 # 800261e8 <pr>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	488080e7          	jalr	1160(ra) # 800061e2 <acquire>
    80005d62:	bf7d                	j	80005d20 <printf+0x3e>
    panic("null fmt");
    80005d64:	00003517          	auipc	a0,0x3
    80005d68:	b1c50513          	addi	a0,a0,-1252 # 80008880 <syscalls+0x3e8>
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	f2c080e7          	jalr	-212(ra) # 80005c98 <panic>
      consputc(c);
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	c62080e7          	jalr	-926(ra) # 800059d6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d7c:	2485                	addiw	s1,s1,1
    80005d7e:	009a07b3          	add	a5,s4,s1
    80005d82:	0007c503          	lbu	a0,0(a5)
    80005d86:	10050763          	beqz	a0,80005e94 <printf+0x1b2>
    if(c != '%'){
    80005d8a:	ff5515e3          	bne	a0,s5,80005d74 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d8e:	2485                	addiw	s1,s1,1
    80005d90:	009a07b3          	add	a5,s4,s1
    80005d94:	0007c783          	lbu	a5,0(a5)
    80005d98:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d9c:	cfe5                	beqz	a5,80005e94 <printf+0x1b2>
    switch(c){
    80005d9e:	05678a63          	beq	a5,s6,80005df2 <printf+0x110>
    80005da2:	02fb7663          	bgeu	s6,a5,80005dce <printf+0xec>
    80005da6:	09978963          	beq	a5,s9,80005e38 <printf+0x156>
    80005daa:	07800713          	li	a4,120
    80005dae:	0ce79863          	bne	a5,a4,80005e7e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	4605                	li	a2,1
    80005dc0:	85ea                	mv	a1,s10
    80005dc2:	4388                	lw	a0,0(a5)
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	e32080e7          	jalr	-462(ra) # 80005bf6 <printint>
      break;
    80005dcc:	bf45                	j	80005d7c <printf+0x9a>
    switch(c){
    80005dce:	0b578263          	beq	a5,s5,80005e72 <printf+0x190>
    80005dd2:	0b879663          	bne	a5,s8,80005e7e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005dd6:	f8843783          	ld	a5,-120(s0)
    80005dda:	00878713          	addi	a4,a5,8
    80005dde:	f8e43423          	sd	a4,-120(s0)
    80005de2:	4605                	li	a2,1
    80005de4:	45a9                	li	a1,10
    80005de6:	4388                	lw	a0,0(a5)
    80005de8:	00000097          	auipc	ra,0x0
    80005dec:	e0e080e7          	jalr	-498(ra) # 80005bf6 <printint>
      break;
    80005df0:	b771                	j	80005d7c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005df2:	f8843783          	ld	a5,-120(s0)
    80005df6:	00878713          	addi	a4,a5,8
    80005dfa:	f8e43423          	sd	a4,-120(s0)
    80005dfe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e02:	03000513          	li	a0,48
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	bd0080e7          	jalr	-1072(ra) # 800059d6 <consputc>
  consputc('x');
    80005e0e:	07800513          	li	a0,120
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	bc4080e7          	jalr	-1084(ra) # 800059d6 <consputc>
    80005e1a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e1c:	03c9d793          	srli	a5,s3,0x3c
    80005e20:	97de                	add	a5,a5,s7
    80005e22:	0007c503          	lbu	a0,0(a5)
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	bb0080e7          	jalr	-1104(ra) # 800059d6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e2e:	0992                	slli	s3,s3,0x4
    80005e30:	397d                	addiw	s2,s2,-1
    80005e32:	fe0915e3          	bnez	s2,80005e1c <printf+0x13a>
    80005e36:	b799                	j	80005d7c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e38:	f8843783          	ld	a5,-120(s0)
    80005e3c:	00878713          	addi	a4,a5,8
    80005e40:	f8e43423          	sd	a4,-120(s0)
    80005e44:	0007b903          	ld	s2,0(a5)
    80005e48:	00090e63          	beqz	s2,80005e64 <printf+0x182>
      for(; *s; s++)
    80005e4c:	00094503          	lbu	a0,0(s2)
    80005e50:	d515                	beqz	a0,80005d7c <printf+0x9a>
        consputc(*s);
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	b84080e7          	jalr	-1148(ra) # 800059d6 <consputc>
      for(; *s; s++)
    80005e5a:	0905                	addi	s2,s2,1
    80005e5c:	00094503          	lbu	a0,0(s2)
    80005e60:	f96d                	bnez	a0,80005e52 <printf+0x170>
    80005e62:	bf29                	j	80005d7c <printf+0x9a>
        s = "(null)";
    80005e64:	00003917          	auipc	s2,0x3
    80005e68:	a1490913          	addi	s2,s2,-1516 # 80008878 <syscalls+0x3e0>
      for(; *s; s++)
    80005e6c:	02800513          	li	a0,40
    80005e70:	b7cd                	j	80005e52 <printf+0x170>
      consputc('%');
    80005e72:	8556                	mv	a0,s5
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	b62080e7          	jalr	-1182(ra) # 800059d6 <consputc>
      break;
    80005e7c:	b701                	j	80005d7c <printf+0x9a>
      consputc('%');
    80005e7e:	8556                	mv	a0,s5
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	b56080e7          	jalr	-1194(ra) # 800059d6 <consputc>
      consputc(c);
    80005e88:	854a                	mv	a0,s2
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	b4c080e7          	jalr	-1204(ra) # 800059d6 <consputc>
      break;
    80005e92:	b5ed                	j	80005d7c <printf+0x9a>
  if(locking)
    80005e94:	020d9163          	bnez	s11,80005eb6 <printf+0x1d4>
}
    80005e98:	70e6                	ld	ra,120(sp)
    80005e9a:	7446                	ld	s0,112(sp)
    80005e9c:	74a6                	ld	s1,104(sp)
    80005e9e:	7906                	ld	s2,96(sp)
    80005ea0:	69e6                	ld	s3,88(sp)
    80005ea2:	6a46                	ld	s4,80(sp)
    80005ea4:	6aa6                	ld	s5,72(sp)
    80005ea6:	6b06                	ld	s6,64(sp)
    80005ea8:	7be2                	ld	s7,56(sp)
    80005eaa:	7c42                	ld	s8,48(sp)
    80005eac:	7ca2                	ld	s9,40(sp)
    80005eae:	7d02                	ld	s10,32(sp)
    80005eb0:	6de2                	ld	s11,24(sp)
    80005eb2:	6129                	addi	sp,sp,192
    80005eb4:	8082                	ret
    release(&pr.lock);
    80005eb6:	00020517          	auipc	a0,0x20
    80005eba:	33250513          	addi	a0,a0,818 # 800261e8 <pr>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	3d8080e7          	jalr	984(ra) # 80006296 <release>
}
    80005ec6:	bfc9                	j	80005e98 <printf+0x1b6>

0000000080005ec8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ec8:	1101                	addi	sp,sp,-32
    80005eca:	ec06                	sd	ra,24(sp)
    80005ecc:	e822                	sd	s0,16(sp)
    80005ece:	e426                	sd	s1,8(sp)
    80005ed0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ed2:	00020497          	auipc	s1,0x20
    80005ed6:	31648493          	addi	s1,s1,790 # 800261e8 <pr>
    80005eda:	00003597          	auipc	a1,0x3
    80005ede:	9b658593          	addi	a1,a1,-1610 # 80008890 <syscalls+0x3f8>
    80005ee2:	8526                	mv	a0,s1
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	26e080e7          	jalr	622(ra) # 80006152 <initlock>
  pr.locking = 1;
    80005eec:	4785                	li	a5,1
    80005eee:	cc9c                	sw	a5,24(s1)
}
    80005ef0:	60e2                	ld	ra,24(sp)
    80005ef2:	6442                	ld	s0,16(sp)
    80005ef4:	64a2                	ld	s1,8(sp)
    80005ef6:	6105                	addi	sp,sp,32
    80005ef8:	8082                	ret

0000000080005efa <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005efa:	1141                	addi	sp,sp,-16
    80005efc:	e406                	sd	ra,8(sp)
    80005efe:	e022                	sd	s0,0(sp)
    80005f00:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f02:	100007b7          	lui	a5,0x10000
    80005f06:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f0a:	f8000713          	li	a4,-128
    80005f0e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f12:	470d                	li	a4,3
    80005f14:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f18:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f1c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f20:	469d                	li	a3,7
    80005f22:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f26:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f2a:	00003597          	auipc	a1,0x3
    80005f2e:	98658593          	addi	a1,a1,-1658 # 800088b0 <digits+0x18>
    80005f32:	00020517          	auipc	a0,0x20
    80005f36:	2d650513          	addi	a0,a0,726 # 80026208 <uart_tx_lock>
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	218080e7          	jalr	536(ra) # 80006152 <initlock>
}
    80005f42:	60a2                	ld	ra,8(sp)
    80005f44:	6402                	ld	s0,0(sp)
    80005f46:	0141                	addi	sp,sp,16
    80005f48:	8082                	ret

0000000080005f4a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f4a:	1101                	addi	sp,sp,-32
    80005f4c:	ec06                	sd	ra,24(sp)
    80005f4e:	e822                	sd	s0,16(sp)
    80005f50:	e426                	sd	s1,8(sp)
    80005f52:	1000                	addi	s0,sp,32
    80005f54:	84aa                	mv	s1,a0
  push_off();
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	240080e7          	jalr	576(ra) # 80006196 <push_off>

  if(panicked){
    80005f5e:	00003797          	auipc	a5,0x3
    80005f62:	0be7a783          	lw	a5,190(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f66:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f6a:	c391                	beqz	a5,80005f6e <uartputc_sync+0x24>
    for(;;)
    80005f6c:	a001                	j	80005f6c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f6e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f72:	0ff7f793          	andi	a5,a5,255
    80005f76:	0207f793          	andi	a5,a5,32
    80005f7a:	dbf5                	beqz	a5,80005f6e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f7c:	0ff4f793          	andi	a5,s1,255
    80005f80:	10000737          	lui	a4,0x10000
    80005f84:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	2ae080e7          	jalr	686(ra) # 80006236 <pop_off>
}
    80005f90:	60e2                	ld	ra,24(sp)
    80005f92:	6442                	ld	s0,16(sp)
    80005f94:	64a2                	ld	s1,8(sp)
    80005f96:	6105                	addi	sp,sp,32
    80005f98:	8082                	ret

0000000080005f9a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f9a:	00003717          	auipc	a4,0x3
    80005f9e:	08673703          	ld	a4,134(a4) # 80009020 <uart_tx_r>
    80005fa2:	00003797          	auipc	a5,0x3
    80005fa6:	0867b783          	ld	a5,134(a5) # 80009028 <uart_tx_w>
    80005faa:	06e78c63          	beq	a5,a4,80006022 <uartstart+0x88>
{
    80005fae:	7139                	addi	sp,sp,-64
    80005fb0:	fc06                	sd	ra,56(sp)
    80005fb2:	f822                	sd	s0,48(sp)
    80005fb4:	f426                	sd	s1,40(sp)
    80005fb6:	f04a                	sd	s2,32(sp)
    80005fb8:	ec4e                	sd	s3,24(sp)
    80005fba:	e852                	sd	s4,16(sp)
    80005fbc:	e456                	sd	s5,8(sp)
    80005fbe:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fc4:	00020a17          	auipc	s4,0x20
    80005fc8:	244a0a13          	addi	s4,s4,580 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fcc:	00003497          	auipc	s1,0x3
    80005fd0:	05448493          	addi	s1,s1,84 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fd4:	00003997          	auipc	s3,0x3
    80005fd8:	05498993          	addi	s3,s3,84 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fdc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fe0:	0ff7f793          	andi	a5,a5,255
    80005fe4:	0207f793          	andi	a5,a5,32
    80005fe8:	c785                	beqz	a5,80006010 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fea:	01f77793          	andi	a5,a4,31
    80005fee:	97d2                	add	a5,a5,s4
    80005ff0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005ff4:	0705                	addi	a4,a4,1
    80005ff6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ff8:	8526                	mv	a0,s1
    80005ffa:	ffffb097          	auipc	ra,0xffffb
    80005ffe:	6e8080e7          	jalr	1768(ra) # 800016e2 <wakeup>
    
    WriteReg(THR, c);
    80006002:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006006:	6098                	ld	a4,0(s1)
    80006008:	0009b783          	ld	a5,0(s3)
    8000600c:	fce798e3          	bne	a5,a4,80005fdc <uartstart+0x42>
  }
}
    80006010:	70e2                	ld	ra,56(sp)
    80006012:	7442                	ld	s0,48(sp)
    80006014:	74a2                	ld	s1,40(sp)
    80006016:	7902                	ld	s2,32(sp)
    80006018:	69e2                	ld	s3,24(sp)
    8000601a:	6a42                	ld	s4,16(sp)
    8000601c:	6aa2                	ld	s5,8(sp)
    8000601e:	6121                	addi	sp,sp,64
    80006020:	8082                	ret
    80006022:	8082                	ret

0000000080006024 <uartputc>:
{
    80006024:	7179                	addi	sp,sp,-48
    80006026:	f406                	sd	ra,40(sp)
    80006028:	f022                	sd	s0,32(sp)
    8000602a:	ec26                	sd	s1,24(sp)
    8000602c:	e84a                	sd	s2,16(sp)
    8000602e:	e44e                	sd	s3,8(sp)
    80006030:	e052                	sd	s4,0(sp)
    80006032:	1800                	addi	s0,sp,48
    80006034:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006036:	00020517          	auipc	a0,0x20
    8000603a:	1d250513          	addi	a0,a0,466 # 80026208 <uart_tx_lock>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	1a4080e7          	jalr	420(ra) # 800061e2 <acquire>
  if(panicked){
    80006046:	00003797          	auipc	a5,0x3
    8000604a:	fd67a783          	lw	a5,-42(a5) # 8000901c <panicked>
    8000604e:	c391                	beqz	a5,80006052 <uartputc+0x2e>
    for(;;)
    80006050:	a001                	j	80006050 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006052:	00003797          	auipc	a5,0x3
    80006056:	fd67b783          	ld	a5,-42(a5) # 80009028 <uart_tx_w>
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fc673703          	ld	a4,-58(a4) # 80009020 <uart_tx_r>
    80006062:	02070713          	addi	a4,a4,32
    80006066:	02f71b63          	bne	a4,a5,8000609c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000606a:	00020a17          	auipc	s4,0x20
    8000606e:	19ea0a13          	addi	s4,s4,414 # 80026208 <uart_tx_lock>
    80006072:	00003497          	auipc	s1,0x3
    80006076:	fae48493          	addi	s1,s1,-82 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607a:	00003917          	auipc	s2,0x3
    8000607e:	fae90913          	addi	s2,s2,-82 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006082:	85d2                	mv	a1,s4
    80006084:	8526                	mv	a0,s1
    80006086:	ffffb097          	auipc	ra,0xffffb
    8000608a:	4d0080e7          	jalr	1232(ra) # 80001556 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000608e:	00093783          	ld	a5,0(s2)
    80006092:	6098                	ld	a4,0(s1)
    80006094:	02070713          	addi	a4,a4,32
    80006098:	fef705e3          	beq	a4,a5,80006082 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000609c:	00020497          	auipc	s1,0x20
    800060a0:	16c48493          	addi	s1,s1,364 # 80026208 <uart_tx_lock>
    800060a4:	01f7f713          	andi	a4,a5,31
    800060a8:	9726                	add	a4,a4,s1
    800060aa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060ae:	0785                	addi	a5,a5,1
    800060b0:	00003717          	auipc	a4,0x3
    800060b4:	f6f73c23          	sd	a5,-136(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	ee2080e7          	jalr	-286(ra) # 80005f9a <uartstart>
      release(&uart_tx_lock);
    800060c0:	8526                	mv	a0,s1
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	1d4080e7          	jalr	468(ra) # 80006296 <release>
}
    800060ca:	70a2                	ld	ra,40(sp)
    800060cc:	7402                	ld	s0,32(sp)
    800060ce:	64e2                	ld	s1,24(sp)
    800060d0:	6942                	ld	s2,16(sp)
    800060d2:	69a2                	ld	s3,8(sp)
    800060d4:	6a02                	ld	s4,0(sp)
    800060d6:	6145                	addi	sp,sp,48
    800060d8:	8082                	ret

00000000800060da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060da:	1141                	addi	sp,sp,-16
    800060dc:	e422                	sd	s0,8(sp)
    800060de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e0:	100007b7          	lui	a5,0x10000
    800060e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060e8:	8b85                	andi	a5,a5,1
    800060ea:	cb91                	beqz	a5,800060fe <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060f4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060f8:	6422                	ld	s0,8(sp)
    800060fa:	0141                	addi	sp,sp,16
    800060fc:	8082                	ret
    return -1;
    800060fe:	557d                	li	a0,-1
    80006100:	bfe5                	j	800060f8 <uartgetc+0x1e>

0000000080006102 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006102:	1101                	addi	sp,sp,-32
    80006104:	ec06                	sd	ra,24(sp)
    80006106:	e822                	sd	s0,16(sp)
    80006108:	e426                	sd	s1,8(sp)
    8000610a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000610c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	fcc080e7          	jalr	-52(ra) # 800060da <uartgetc>
    if(c == -1)
    80006116:	00950763          	beq	a0,s1,80006124 <uartintr+0x22>
      break;
    consoleintr(c);
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	8fe080e7          	jalr	-1794(ra) # 80005a18 <consoleintr>
  while(1){
    80006122:	b7f5                	j	8000610e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006124:	00020497          	auipc	s1,0x20
    80006128:	0e448493          	addi	s1,s1,228 # 80026208 <uart_tx_lock>
    8000612c:	8526                	mv	a0,s1
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	0b4080e7          	jalr	180(ra) # 800061e2 <acquire>
  uartstart();
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	e64080e7          	jalr	-412(ra) # 80005f9a <uartstart>
  release(&uart_tx_lock);
    8000613e:	8526                	mv	a0,s1
    80006140:	00000097          	auipc	ra,0x0
    80006144:	156080e7          	jalr	342(ra) # 80006296 <release>
}
    80006148:	60e2                	ld	ra,24(sp)
    8000614a:	6442                	ld	s0,16(sp)
    8000614c:	64a2                	ld	s1,8(sp)
    8000614e:	6105                	addi	sp,sp,32
    80006150:	8082                	ret

0000000080006152 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006152:	1141                	addi	sp,sp,-16
    80006154:	e422                	sd	s0,8(sp)
    80006156:	0800                	addi	s0,sp,16
  lk->name = name;
    80006158:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000615a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000615e:	00053823          	sd	zero,16(a0)
}
    80006162:	6422                	ld	s0,8(sp)
    80006164:	0141                	addi	sp,sp,16
    80006166:	8082                	ret

0000000080006168 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006168:	411c                	lw	a5,0(a0)
    8000616a:	e399                	bnez	a5,80006170 <holding+0x8>
    8000616c:	4501                	li	a0,0
  return r;
}
    8000616e:	8082                	ret
{
    80006170:	1101                	addi	sp,sp,-32
    80006172:	ec06                	sd	ra,24(sp)
    80006174:	e822                	sd	s0,16(sp)
    80006176:	e426                	sd	s1,8(sp)
    80006178:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000617a:	6904                	ld	s1,16(a0)
    8000617c:	ffffb097          	auipc	ra,0xffffb
    80006180:	cfa080e7          	jalr	-774(ra) # 80000e76 <mycpu>
    80006184:	40a48533          	sub	a0,s1,a0
    80006188:	00153513          	seqz	a0,a0
}
    8000618c:	60e2                	ld	ra,24(sp)
    8000618e:	6442                	ld	s0,16(sp)
    80006190:	64a2                	ld	s1,8(sp)
    80006192:	6105                	addi	sp,sp,32
    80006194:	8082                	ret

0000000080006196 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006196:	1101                	addi	sp,sp,-32
    80006198:	ec06                	sd	ra,24(sp)
    8000619a:	e822                	sd	s0,16(sp)
    8000619c:	e426                	sd	s1,8(sp)
    8000619e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a0:	100024f3          	csrr	s1,sstatus
    800061a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061a8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061aa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061ae:	ffffb097          	auipc	ra,0xffffb
    800061b2:	cc8080e7          	jalr	-824(ra) # 80000e76 <mycpu>
    800061b6:	5d3c                	lw	a5,120(a0)
    800061b8:	cf89                	beqz	a5,800061d2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ba:	ffffb097          	auipc	ra,0xffffb
    800061be:	cbc080e7          	jalr	-836(ra) # 80000e76 <mycpu>
    800061c2:	5d3c                	lw	a5,120(a0)
    800061c4:	2785                	addiw	a5,a5,1
    800061c6:	dd3c                	sw	a5,120(a0)
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	addi	sp,sp,32
    800061d0:	8082                	ret
    mycpu()->intena = old;
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	ca4080e7          	jalr	-860(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061da:	8085                	srli	s1,s1,0x1
    800061dc:	8885                	andi	s1,s1,1
    800061de:	dd64                	sw	s1,124(a0)
    800061e0:	bfe9                	j	800061ba <push_off+0x24>

00000000800061e2 <acquire>:
{
    800061e2:	1101                	addi	sp,sp,-32
    800061e4:	ec06                	sd	ra,24(sp)
    800061e6:	e822                	sd	s0,16(sp)
    800061e8:	e426                	sd	s1,8(sp)
    800061ea:	1000                	addi	s0,sp,32
    800061ec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	fa8080e7          	jalr	-88(ra) # 80006196 <push_off>
  if(holding(lk))
    800061f6:	8526                	mv	a0,s1
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	f70080e7          	jalr	-144(ra) # 80006168 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006200:	4705                	li	a4,1
  if(holding(lk))
    80006202:	e115                	bnez	a0,80006226 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006204:	87ba                	mv	a5,a4
    80006206:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000620a:	2781                	sext.w	a5,a5
    8000620c:	ffe5                	bnez	a5,80006204 <acquire+0x22>
  __sync_synchronize();
    8000620e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006212:	ffffb097          	auipc	ra,0xffffb
    80006216:	c64080e7          	jalr	-924(ra) # 80000e76 <mycpu>
    8000621a:	e888                	sd	a0,16(s1)
}
    8000621c:	60e2                	ld	ra,24(sp)
    8000621e:	6442                	ld	s0,16(sp)
    80006220:	64a2                	ld	s1,8(sp)
    80006222:	6105                	addi	sp,sp,32
    80006224:	8082                	ret
    panic("acquire");
    80006226:	00002517          	auipc	a0,0x2
    8000622a:	69250513          	addi	a0,a0,1682 # 800088b8 <digits+0x20>
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	a6a080e7          	jalr	-1430(ra) # 80005c98 <panic>

0000000080006236 <pop_off>:

void
pop_off(void)
{
    80006236:	1141                	addi	sp,sp,-16
    80006238:	e406                	sd	ra,8(sp)
    8000623a:	e022                	sd	s0,0(sp)
    8000623c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	c38080e7          	jalr	-968(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006246:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000624a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000624c:	e78d                	bnez	a5,80006276 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000624e:	5d3c                	lw	a5,120(a0)
    80006250:	02f05b63          	blez	a5,80006286 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006254:	37fd                	addiw	a5,a5,-1
    80006256:	0007871b          	sext.w	a4,a5
    8000625a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000625c:	eb09                	bnez	a4,8000626e <pop_off+0x38>
    8000625e:	5d7c                	lw	a5,124(a0)
    80006260:	c799                	beqz	a5,8000626e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006262:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006266:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000626e:	60a2                	ld	ra,8(sp)
    80006270:	6402                	ld	s0,0(sp)
    80006272:	0141                	addi	sp,sp,16
    80006274:	8082                	ret
    panic("pop_off - interruptible");
    80006276:	00002517          	auipc	a0,0x2
    8000627a:	64a50513          	addi	a0,a0,1610 # 800088c0 <digits+0x28>
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	a1a080e7          	jalr	-1510(ra) # 80005c98 <panic>
    panic("pop_off");
    80006286:	00002517          	auipc	a0,0x2
    8000628a:	65250513          	addi	a0,a0,1618 # 800088d8 <digits+0x40>
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	a0a080e7          	jalr	-1526(ra) # 80005c98 <panic>

0000000080006296 <release>:
{
    80006296:	1101                	addi	sp,sp,-32
    80006298:	ec06                	sd	ra,24(sp)
    8000629a:	e822                	sd	s0,16(sp)
    8000629c:	e426                	sd	s1,8(sp)
    8000629e:	1000                	addi	s0,sp,32
    800062a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	ec6080e7          	jalr	-314(ra) # 80006168 <holding>
    800062aa:	c115                	beqz	a0,800062ce <release+0x38>
  lk->cpu = 0;
    800062ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b4:	0f50000f          	fence	iorw,ow
    800062b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	f7a080e7          	jalr	-134(ra) # 80006236 <pop_off>
}
    800062c4:	60e2                	ld	ra,24(sp)
    800062c6:	6442                	ld	s0,16(sp)
    800062c8:	64a2                	ld	s1,8(sp)
    800062ca:	6105                	addi	sp,sp,32
    800062cc:	8082                	ret
    panic("release");
    800062ce:	00002517          	auipc	a0,0x2
    800062d2:	61250513          	addi	a0,a0,1554 # 800088e0 <digits+0x48>
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	9c2080e7          	jalr	-1598(ra) # 80005c98 <panic>
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
