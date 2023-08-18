
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	487050ef          	jal	ra,80005c9c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
    8000002e:	84aa                	mv	s1,a0
  struct run *r;
  push_off();
    80000030:	00006097          	auipc	ra,0x6
    80000034:	604080e7          	jalr	1540(ra) # 80006634 <push_off>
  int c = cpuid();
    80000038:	00001097          	auipc	ra,0x1
    8000003c:	ed2080e7          	jalr	-302(ra) # 80000f0a <cpuid>
    80000040:	8a2a                	mv	s4,a0
  pop_off();
    80000042:	00006097          	auipc	ra,0x6
    80000046:	6ae080e7          	jalr	1710(ra) # 800066f0 <pop_off>

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000004a:	03449793          	slli	a5,s1,0x34
    8000004e:	e7a5                	bnez	a5,800000b6 <kfree+0x9a>
    80000050:	0002b797          	auipc	a5,0x2b
    80000054:	1f878793          	addi	a5,a5,504 # 8002b248 <end>
    80000058:	04f4ef63          	bltu	s1,a5,800000b6 <kfree+0x9a>
    8000005c:	47c5                	li	a5,17
    8000005e:	07ee                	slli	a5,a5,0x1b
    80000060:	04f4fb63          	bgeu	s1,a5,800000b6 <kfree+0x9a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000064:	6605                	lui	a2,0x1
    80000066:	4585                	li	a1,1
    80000068:	8526                	mv	a0,s1
    8000006a:	00000097          	auipc	ra,0x0
    8000006e:	1ec080e7          	jalr	492(ra) # 80000256 <memset>

  r = (struct run*)pa;

  acquire(&kmem[c].lock);
    80000072:	00009a97          	auipc	s5,0x9
    80000076:	fbea8a93          	addi	s5,s5,-66 # 80009030 <kmem>
    8000007a:	002a1993          	slli	s3,s4,0x2
    8000007e:	01498933          	add	s2,s3,s4
    80000082:	090e                	slli	s2,s2,0x3
    80000084:	9956                	add	s2,s2,s5
    80000086:	854a                	mv	a0,s2
    80000088:	00006097          	auipc	ra,0x6
    8000008c:	5f8080e7          	jalr	1528(ra) # 80006680 <acquire>
  r->next = kmem[c].freelist;
    80000090:	02093783          	ld	a5,32(s2)
    80000094:	e09c                	sd	a5,0(s1)
  kmem[c].freelist = r;
    80000096:	02993023          	sd	s1,32(s2)
  release(&kmem[c].lock);
    8000009a:	854a                	mv	a0,s2
    8000009c:	00006097          	auipc	ra,0x6
    800000a0:	6b4080e7          	jalr	1716(ra) # 80006750 <release>
}
    800000a4:	70e2                	ld	ra,56(sp)
    800000a6:	7442                	ld	s0,48(sp)
    800000a8:	74a2                	ld	s1,40(sp)
    800000aa:	7902                	ld	s2,32(sp)
    800000ac:	69e2                	ld	s3,24(sp)
    800000ae:	6a42                	ld	s4,16(sp)
    800000b0:	6aa2                	ld	s5,8(sp)
    800000b2:	6121                	addi	sp,sp,64
    800000b4:	8082                	ret
    panic("kfree");
    800000b6:	00008517          	auipc	a0,0x8
    800000ba:	f5a50513          	addi	a0,a0,-166 # 80008010 <etext+0x10>
    800000be:	00006097          	auipc	ra,0x6
    800000c2:	08e080e7          	jalr	142(ra) # 8000614c <panic>

00000000800000c6 <freerange>:
{
    800000c6:	7179                	addi	sp,sp,-48
    800000c8:	f406                	sd	ra,40(sp)
    800000ca:	f022                	sd	s0,32(sp)
    800000cc:	ec26                	sd	s1,24(sp)
    800000ce:	e84a                	sd	s2,16(sp)
    800000d0:	e44e                	sd	s3,8(sp)
    800000d2:	e052                	sd	s4,0(sp)
    800000d4:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d6:	6785                	lui	a5,0x1
    800000d8:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000dc:	94aa                	add	s1,s1,a0
    800000de:	757d                	lui	a0,0xfffff
    800000e0:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e2:	94be                	add	s1,s1,a5
    800000e4:	0095ee63          	bltu	a1,s1,80000100 <freerange+0x3a>
    800000e8:	892e                	mv	s2,a1
    kfree(p);
    800000ea:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ec:	6985                	lui	s3,0x1
    kfree(p);
    800000ee:	01448533          	add	a0,s1,s4
    800000f2:	00000097          	auipc	ra,0x0
    800000f6:	f2a080e7          	jalr	-214(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fa:	94ce                	add	s1,s1,s3
    800000fc:	fe9979e3          	bgeu	s2,s1,800000ee <freerange+0x28>
}
    80000100:	70a2                	ld	ra,40(sp)
    80000102:	7402                	ld	s0,32(sp)
    80000104:	64e2                	ld	s1,24(sp)
    80000106:	6942                	ld	s2,16(sp)
    80000108:	69a2                	ld	s3,8(sp)
    8000010a:	6a02                	ld	s4,0(sp)
    8000010c:	6145                	addi	sp,sp,48
    8000010e:	8082                	ret

0000000080000110 <kinit>:
{
    80000110:	7179                	addi	sp,sp,-48
    80000112:	f406                	sd	ra,40(sp)
    80000114:	f022                	sd	s0,32(sp)
    80000116:	ec26                	sd	s1,24(sp)
    80000118:	e84a                	sd	s2,16(sp)
    8000011a:	e44e                	sd	s3,8(sp)
    8000011c:	1800                	addi	s0,sp,48
  for (int i = 0; i<NCPU; i++)
    8000011e:	00009497          	auipc	s1,0x9
    80000122:	f1248493          	addi	s1,s1,-238 # 80009030 <kmem>
    80000126:	00009997          	auipc	s3,0x9
    8000012a:	04a98993          	addi	s3,s3,74 # 80009170 <pid_lock>
    initlock(&kmem[i].lock, "kmem");
    8000012e:	00008917          	auipc	s2,0x8
    80000132:	eea90913          	addi	s2,s2,-278 # 80008018 <etext+0x18>
    80000136:	85ca                	mv	a1,s2
    80000138:	8526                	mv	a0,s1
    8000013a:	00006097          	auipc	ra,0x6
    8000013e:	6c2080e7          	jalr	1730(ra) # 800067fc <initlock>
  for (int i = 0; i<NCPU; i++)
    80000142:	02848493          	addi	s1,s1,40
    80000146:	ff3498e3          	bne	s1,s3,80000136 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    8000014a:	45c5                	li	a1,17
    8000014c:	05ee                	slli	a1,a1,0x1b
    8000014e:	0002b517          	auipc	a0,0x2b
    80000152:	0fa50513          	addi	a0,a0,250 # 8002b248 <end>
    80000156:	00000097          	auipc	ra,0x0
    8000015a:	f70080e7          	jalr	-144(ra) # 800000c6 <freerange>
}
    8000015e:	70a2                	ld	ra,40(sp)
    80000160:	7402                	ld	s0,32(sp)
    80000162:	64e2                	ld	s1,24(sp)
    80000164:	6942                	ld	s2,16(sp)
    80000166:	69a2                	ld	s3,8(sp)
    80000168:	6145                	addi	sp,sp,48
    8000016a:	8082                	ret

000000008000016c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000016c:	7139                	addi	sp,sp,-64
    8000016e:	fc06                	sd	ra,56(sp)
    80000170:	f822                	sd	s0,48(sp)
    80000172:	f426                	sd	s1,40(sp)
    80000174:	f04a                	sd	s2,32(sp)
    80000176:	ec4e                	sd	s3,24(sp)
    80000178:	e852                	sd	s4,16(sp)
    8000017a:	e456                	sd	s5,8(sp)
    8000017c:	0080                	addi	s0,sp,64
  struct run *r;
  push_off();
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	4b6080e7          	jalr	1206(ra) # 80006634 <push_off>
  int c = cpuid();
    80000186:	00001097          	auipc	ra,0x1
    8000018a:	d84080e7          	jalr	-636(ra) # 80000f0a <cpuid>
    8000018e:	84aa                	mv	s1,a0
  pop_off();
    80000190:	00006097          	auipc	ra,0x6
    80000194:	560080e7          	jalr	1376(ra) # 800066f0 <pop_off>

  acquire(&kmem[c].lock);
    80000198:	00249993          	slli	s3,s1,0x2
    8000019c:	99a6                	add	s3,s3,s1
    8000019e:	00399793          	slli	a5,s3,0x3
    800001a2:	00009997          	auipc	s3,0x9
    800001a6:	e8e98993          	addi	s3,s3,-370 # 80009030 <kmem>
    800001aa:	99be                	add	s3,s3,a5
    800001ac:	854e                	mv	a0,s3
    800001ae:	00006097          	auipc	ra,0x6
    800001b2:	4d2080e7          	jalr	1234(ra) # 80006680 <acquire>
  r = kmem[c].freelist;
    800001b6:	0209b903          	ld	s2,32(s3)
  if(r)
    800001ba:	02090c63          	beqz	s2,800001f2 <kalloc+0x86>
  {
    kmem[c].freelist = r->next;
    800001be:	00093703          	ld	a4,0(s2)
    800001c2:	02e9b023          	sd	a4,32(s3)
    release(&kmem[c].lock);
    800001c6:	854e                	mv	a0,s3
    800001c8:	00006097          	auipc	ra,0x6
    800001cc:	588080e7          	jalr	1416(ra) # 80006750 <release>
        release(&kmem[i].lock);
      }
    }
  }
  if(r)
    memset((char*)r, 5, PGSIZE);  // fill with junk
    800001d0:	6605                	lui	a2,0x1
    800001d2:	4595                	li	a1,5
    800001d4:	854a                	mv	a0,s2
    800001d6:	00000097          	auipc	ra,0x0
    800001da:	080080e7          	jalr	128(ra) # 80000256 <memset>
  return (void*)r;
}
    800001de:	854a                	mv	a0,s2
    800001e0:	70e2                	ld	ra,56(sp)
    800001e2:	7442                	ld	s0,48(sp)
    800001e4:	74a2                	ld	s1,40(sp)
    800001e6:	7902                	ld	s2,32(sp)
    800001e8:	69e2                	ld	s3,24(sp)
    800001ea:	6a42                	ld	s4,16(sp)
    800001ec:	6aa2                	ld	s5,8(sp)
    800001ee:	6121                	addi	sp,sp,64
    800001f0:	8082                	ret
    release(&kmem[c].lock);
    800001f2:	854e                	mv	a0,s3
    800001f4:	00006097          	auipc	ra,0x6
    800001f8:	55c080e7          	jalr	1372(ra) # 80006750 <release>
    for (int i = 0; i<NCPU; i++)
    800001fc:	00009497          	auipc	s1,0x9
    80000200:	e3448493          	addi	s1,s1,-460 # 80009030 <kmem>
    80000204:	4981                	li	s3,0
    80000206:	4a21                	li	s4,8
      acquire(&kmem[i].lock);
    80000208:	8526                	mv	a0,s1
    8000020a:	00006097          	auipc	ra,0x6
    8000020e:	476080e7          	jalr	1142(ra) # 80006680 <acquire>
      r = kmem[i].freelist;
    80000212:	0204b903          	ld	s2,32(s1)
      if(r)
    80000216:	00091d63          	bnez	s2,80000230 <kalloc+0xc4>
        release(&kmem[i].lock);
    8000021a:	8526                	mv	a0,s1
    8000021c:	00006097          	auipc	ra,0x6
    80000220:	534080e7          	jalr	1332(ra) # 80006750 <release>
    for (int i = 0; i<NCPU; i++)
    80000224:	2985                	addiw	s3,s3,1
    80000226:	02848493          	addi	s1,s1,40
    8000022a:	fd499fe3          	bne	s3,s4,80000208 <kalloc+0x9c>
    8000022e:	bf45                	j	800001de <kalloc+0x72>
        kmem[i].freelist = r->next;
    80000230:	00093703          	ld	a4,0(s2)
    80000234:	00299793          	slli	a5,s3,0x2
    80000238:	99be                	add	s3,s3,a5
    8000023a:	098e                	slli	s3,s3,0x3
    8000023c:	00009797          	auipc	a5,0x9
    80000240:	df478793          	addi	a5,a5,-524 # 80009030 <kmem>
    80000244:	99be                	add	s3,s3,a5
    80000246:	02e9b023          	sd	a4,32(s3)
        release(&kmem[i].lock);
    8000024a:	8526                	mv	a0,s1
    8000024c:	00006097          	auipc	ra,0x6
    80000250:	504080e7          	jalr	1284(ra) # 80006750 <release>
        break;
    80000254:	bfb5                	j	800001d0 <kalloc+0x64>

0000000080000256 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e422                	sd	s0,8(sp)
    8000025a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000025c:	ce09                	beqz	a2,80000276 <memset+0x20>
    8000025e:	87aa                	mv	a5,a0
    80000260:	fff6071b          	addiw	a4,a2,-1
    80000264:	1702                	slli	a4,a4,0x20
    80000266:	9301                	srli	a4,a4,0x20
    80000268:	0705                	addi	a4,a4,1
    8000026a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000026c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000270:	0785                	addi	a5,a5,1
    80000272:	fee79de3          	bne	a5,a4,8000026c <memset+0x16>
  }
  return dst;
}
    80000276:	6422                	ld	s0,8(sp)
    80000278:	0141                	addi	sp,sp,16
    8000027a:	8082                	ret

000000008000027c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e422                	sd	s0,8(sp)
    80000280:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000282:	ca05                	beqz	a2,800002b2 <memcmp+0x36>
    80000284:	fff6069b          	addiw	a3,a2,-1
    80000288:	1682                	slli	a3,a3,0x20
    8000028a:	9281                	srli	a3,a3,0x20
    8000028c:	0685                	addi	a3,a3,1
    8000028e:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000290:	00054783          	lbu	a5,0(a0)
    80000294:	0005c703          	lbu	a4,0(a1)
    80000298:	00e79863          	bne	a5,a4,800002a8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000029c:	0505                	addi	a0,a0,1
    8000029e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002a0:	fed518e3          	bne	a0,a3,80000290 <memcmp+0x14>
  }

  return 0;
    800002a4:	4501                	li	a0,0
    800002a6:	a019                	j	800002ac <memcmp+0x30>
      return *s1 - *s2;
    800002a8:	40e7853b          	subw	a0,a5,a4
}
    800002ac:	6422                	ld	s0,8(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret
  return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	bfe5                	j	800002ac <memcmp+0x30>

00000000800002b6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002b6:	1141                	addi	sp,sp,-16
    800002b8:	e422                	sd	s0,8(sp)
    800002ba:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002bc:	ca0d                	beqz	a2,800002ee <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002be:	00a5f963          	bgeu	a1,a0,800002d0 <memmove+0x1a>
    800002c2:	02061693          	slli	a3,a2,0x20
    800002c6:	9281                	srli	a3,a3,0x20
    800002c8:	00d58733          	add	a4,a1,a3
    800002cc:	02e56463          	bltu	a0,a4,800002f4 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002d0:	fff6079b          	addiw	a5,a2,-1
    800002d4:	1782                	slli	a5,a5,0x20
    800002d6:	9381                	srli	a5,a5,0x20
    800002d8:	0785                	addi	a5,a5,1
    800002da:	97ae                	add	a5,a5,a1
    800002dc:	872a                	mv	a4,a0
      *d++ = *s++;
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0705                	addi	a4,a4,1
    800002e2:	fff5c683          	lbu	a3,-1(a1)
    800002e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002ea:	fef59ae3          	bne	a1,a5,800002de <memmove+0x28>

  return dst;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret
    d += n;
    800002f4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002f6:	fff6079b          	addiw	a5,a2,-1
    800002fa:	1782                	slli	a5,a5,0x20
    800002fc:	9381                	srli	a5,a5,0x20
    800002fe:	fff7c793          	not	a5,a5
    80000302:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000304:	177d                	addi	a4,a4,-1
    80000306:	16fd                	addi	a3,a3,-1
    80000308:	00074603          	lbu	a2,0(a4)
    8000030c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000310:	fef71ae3          	bne	a4,a5,80000304 <memmove+0x4e>
    80000314:	bfe9                	j	800002ee <memmove+0x38>

0000000080000316 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000316:	1141                	addi	sp,sp,-16
    80000318:	e406                	sd	ra,8(sp)
    8000031a:	e022                	sd	s0,0(sp)
    8000031c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000031e:	00000097          	auipc	ra,0x0
    80000322:	f98080e7          	jalr	-104(ra) # 800002b6 <memmove>
}
    80000326:	60a2                	ld	ra,8(sp)
    80000328:	6402                	ld	s0,0(sp)
    8000032a:	0141                	addi	sp,sp,16
    8000032c:	8082                	ret

000000008000032e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000032e:	1141                	addi	sp,sp,-16
    80000330:	e422                	sd	s0,8(sp)
    80000332:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000334:	ce11                	beqz	a2,80000350 <strncmp+0x22>
    80000336:	00054783          	lbu	a5,0(a0)
    8000033a:	cf89                	beqz	a5,80000354 <strncmp+0x26>
    8000033c:	0005c703          	lbu	a4,0(a1)
    80000340:	00f71a63          	bne	a4,a5,80000354 <strncmp+0x26>
    n--, p++, q++;
    80000344:	367d                	addiw	a2,a2,-1
    80000346:	0505                	addi	a0,a0,1
    80000348:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000034a:	f675                	bnez	a2,80000336 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000034c:	4501                	li	a0,0
    8000034e:	a809                	j	80000360 <strncmp+0x32>
    80000350:	4501                	li	a0,0
    80000352:	a039                	j	80000360 <strncmp+0x32>
  if(n == 0)
    80000354:	ca09                	beqz	a2,80000366 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000356:	00054503          	lbu	a0,0(a0)
    8000035a:	0005c783          	lbu	a5,0(a1)
    8000035e:	9d1d                	subw	a0,a0,a5
}
    80000360:	6422                	ld	s0,8(sp)
    80000362:	0141                	addi	sp,sp,16
    80000364:	8082                	ret
    return 0;
    80000366:	4501                	li	a0,0
    80000368:	bfe5                	j	80000360 <strncmp+0x32>

000000008000036a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e422                	sd	s0,8(sp)
    8000036e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000370:	872a                	mv	a4,a0
    80000372:	8832                	mv	a6,a2
    80000374:	367d                	addiw	a2,a2,-1
    80000376:	01005963          	blez	a6,80000388 <strncpy+0x1e>
    8000037a:	0705                	addi	a4,a4,1
    8000037c:	0005c783          	lbu	a5,0(a1)
    80000380:	fef70fa3          	sb	a5,-1(a4)
    80000384:	0585                	addi	a1,a1,1
    80000386:	f7f5                	bnez	a5,80000372 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000388:	00c05d63          	blez	a2,800003a2 <strncpy+0x38>
    8000038c:	86ba                	mv	a3,a4
    *s++ = 0;
    8000038e:	0685                	addi	a3,a3,1
    80000390:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000394:	fff6c793          	not	a5,a3
    80000398:	9fb9                	addw	a5,a5,a4
    8000039a:	010787bb          	addw	a5,a5,a6
    8000039e:	fef048e3          	bgtz	a5,8000038e <strncpy+0x24>
  return os;
}
    800003a2:	6422                	ld	s0,8(sp)
    800003a4:	0141                	addi	sp,sp,16
    800003a6:	8082                	ret

00000000800003a8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003a8:	1141                	addi	sp,sp,-16
    800003aa:	e422                	sd	s0,8(sp)
    800003ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003ae:	02c05363          	blez	a2,800003d4 <safestrcpy+0x2c>
    800003b2:	fff6069b          	addiw	a3,a2,-1
    800003b6:	1682                	slli	a3,a3,0x20
    800003b8:	9281                	srli	a3,a3,0x20
    800003ba:	96ae                	add	a3,a3,a1
    800003bc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003be:	00d58963          	beq	a1,a3,800003d0 <safestrcpy+0x28>
    800003c2:	0585                	addi	a1,a1,1
    800003c4:	0785                	addi	a5,a5,1
    800003c6:	fff5c703          	lbu	a4,-1(a1)
    800003ca:	fee78fa3          	sb	a4,-1(a5)
    800003ce:	fb65                	bnez	a4,800003be <safestrcpy+0x16>
    ;
  *s = 0;
    800003d0:	00078023          	sb	zero,0(a5)
  return os;
}
    800003d4:	6422                	ld	s0,8(sp)
    800003d6:	0141                	addi	sp,sp,16
    800003d8:	8082                	ret

00000000800003da <strlen>:

int
strlen(const char *s)
{
    800003da:	1141                	addi	sp,sp,-16
    800003dc:	e422                	sd	s0,8(sp)
    800003de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003e0:	00054783          	lbu	a5,0(a0)
    800003e4:	cf91                	beqz	a5,80000400 <strlen+0x26>
    800003e6:	0505                	addi	a0,a0,1
    800003e8:	87aa                	mv	a5,a0
    800003ea:	4685                	li	a3,1
    800003ec:	9e89                	subw	a3,a3,a0
    800003ee:	00f6853b          	addw	a0,a3,a5
    800003f2:	0785                	addi	a5,a5,1
    800003f4:	fff7c703          	lbu	a4,-1(a5)
    800003f8:	fb7d                	bnez	a4,800003ee <strlen+0x14>
    ;
  return n;
}
    800003fa:	6422                	ld	s0,8(sp)
    800003fc:	0141                	addi	sp,sp,16
    800003fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000400:	4501                	li	a0,0
    80000402:	bfe5                	j	800003fa <strlen+0x20>

0000000080000404 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000404:	1101                	addi	sp,sp,-32
    80000406:	ec06                	sd	ra,24(sp)
    80000408:	e822                	sd	s0,16(sp)
    8000040a:	e426                	sd	s1,8(sp)
    8000040c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000040e:	00001097          	auipc	ra,0x1
    80000412:	afc080e7          	jalr	-1284(ra) # 80000f0a <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000416:	00009497          	auipc	s1,0x9
    8000041a:	bea48493          	addi	s1,s1,-1046 # 80009000 <started>
  if(cpuid() == 0){
    8000041e:	c531                	beqz	a0,8000046a <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000420:	8526                	mv	a0,s1
    80000422:	00006097          	auipc	ra,0x6
    80000426:	470080e7          	jalr	1136(ra) # 80006892 <lockfree_read4>
    8000042a:	d97d                	beqz	a0,80000420 <main+0x1c>
      ;
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000430:	00001097          	auipc	ra,0x1
    80000434:	ada080e7          	jalr	-1318(ra) # 80000f0a <cpuid>
    80000438:	85aa                	mv	a1,a0
    8000043a:	00008517          	auipc	a0,0x8
    8000043e:	bfe50513          	addi	a0,a0,-1026 # 80008038 <etext+0x38>
    80000442:	00006097          	auipc	ra,0x6
    80000446:	d54080e7          	jalr	-684(ra) # 80006196 <printf>
    kvminithart();    // turn on paging
    8000044a:	00000097          	auipc	ra,0x0
    8000044e:	0e0080e7          	jalr	224(ra) # 8000052a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000452:	00001097          	auipc	ra,0x1
    80000456:	730080e7          	jalr	1840(ra) # 80001b82 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000045a:	00005097          	auipc	ra,0x5
    8000045e:	e96080e7          	jalr	-362(ra) # 800052f0 <plicinithart>
  }

  scheduler();        
    80000462:	00001097          	auipc	ra,0x1
    80000466:	fde080e7          	jalr	-34(ra) # 80001440 <scheduler>
    consoleinit();
    8000046a:	00006097          	auipc	ra,0x6
    8000046e:	bf4080e7          	jalr	-1036(ra) # 8000605e <consoleinit>
    statsinit();
    80000472:	00005097          	auipc	ra,0x5
    80000476:	564080e7          	jalr	1380(ra) # 800059d6 <statsinit>
    printfinit();
    8000047a:	00006097          	auipc	ra,0x6
    8000047e:	f02080e7          	jalr	-254(ra) # 8000637c <printfinit>
    printf("\n");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	3e650513          	addi	a0,a0,998 # 80008868 <digits+0x88>
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	d0c080e7          	jalr	-756(ra) # 80006196 <printf>
    printf("xv6 kernel is booting\n");
    80000492:	00008517          	auipc	a0,0x8
    80000496:	b8e50513          	addi	a0,a0,-1138 # 80008020 <etext+0x20>
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	cfc080e7          	jalr	-772(ra) # 80006196 <printf>
    printf("\n");
    800004a2:	00008517          	auipc	a0,0x8
    800004a6:	3c650513          	addi	a0,a0,966 # 80008868 <digits+0x88>
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	cec080e7          	jalr	-788(ra) # 80006196 <printf>
    kinit();         // physical page allocator
    800004b2:	00000097          	auipc	ra,0x0
    800004b6:	c5e080e7          	jalr	-930(ra) # 80000110 <kinit>
    kvminit();       // create kernel page table
    800004ba:	00000097          	auipc	ra,0x0
    800004be:	322080e7          	jalr	802(ra) # 800007dc <kvminit>
    kvminithart();   // turn on paging
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	068080e7          	jalr	104(ra) # 8000052a <kvminithart>
    procinit();      // process table
    800004ca:	00001097          	auipc	ra,0x1
    800004ce:	990080e7          	jalr	-1648(ra) # 80000e5a <procinit>
    trapinit();      // trap vectors
    800004d2:	00001097          	auipc	ra,0x1
    800004d6:	688080e7          	jalr	1672(ra) # 80001b5a <trapinit>
    trapinithart();  // install kernel trap vector
    800004da:	00001097          	auipc	ra,0x1
    800004de:	6a8080e7          	jalr	1704(ra) # 80001b82 <trapinithart>
    plicinit();      // set up interrupt controller
    800004e2:	00005097          	auipc	ra,0x5
    800004e6:	df8080e7          	jalr	-520(ra) # 800052da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004ea:	00005097          	auipc	ra,0x5
    800004ee:	e06080e7          	jalr	-506(ra) # 800052f0 <plicinithart>
    binit();         // buffer cache
    800004f2:	00002097          	auipc	ra,0x2
    800004f6:	dd2080e7          	jalr	-558(ra) # 800022c4 <binit>
    iinit();         // inode table
    800004fa:	00002097          	auipc	ra,0x2
    800004fe:	670080e7          	jalr	1648(ra) # 80002b6a <iinit>
    fileinit();      // file table
    80000502:	00003097          	auipc	ra,0x3
    80000506:	61a080e7          	jalr	1562(ra) # 80003b1c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000050a:	00005097          	auipc	ra,0x5
    8000050e:	f08080e7          	jalr	-248(ra) # 80005412 <virtio_disk_init>
    userinit();      // first user process
    80000512:	00001097          	auipc	ra,0x1
    80000516:	cfc080e7          	jalr	-772(ra) # 8000120e <userinit>
    __sync_synchronize();
    8000051a:	0ff0000f          	fence
    started = 1;
    8000051e:	4785                	li	a5,1
    80000520:	00009717          	auipc	a4,0x9
    80000524:	aef72023          	sw	a5,-1312(a4) # 80009000 <started>
    80000528:	bf2d                	j	80000462 <main+0x5e>

000000008000052a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000052a:	1141                	addi	sp,sp,-16
    8000052c:	e422                	sd	s0,8(sp)
    8000052e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000530:	00009797          	auipc	a5,0x9
    80000534:	ad87b783          	ld	a5,-1320(a5) # 80009008 <kernel_pagetable>
    80000538:	83b1                	srli	a5,a5,0xc
    8000053a:	577d                	li	a4,-1
    8000053c:	177e                	slli	a4,a4,0x3f
    8000053e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000540:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000544:	12000073          	sfence.vma
  sfence_vma();
}
    80000548:	6422                	ld	s0,8(sp)
    8000054a:	0141                	addi	sp,sp,16
    8000054c:	8082                	ret

000000008000054e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000054e:	7139                	addi	sp,sp,-64
    80000550:	fc06                	sd	ra,56(sp)
    80000552:	f822                	sd	s0,48(sp)
    80000554:	f426                	sd	s1,40(sp)
    80000556:	f04a                	sd	s2,32(sp)
    80000558:	ec4e                	sd	s3,24(sp)
    8000055a:	e852                	sd	s4,16(sp)
    8000055c:	e456                	sd	s5,8(sp)
    8000055e:	e05a                	sd	s6,0(sp)
    80000560:	0080                	addi	s0,sp,64
    80000562:	84aa                	mv	s1,a0
    80000564:	89ae                	mv	s3,a1
    80000566:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000568:	57fd                	li	a5,-1
    8000056a:	83e9                	srli	a5,a5,0x1a
    8000056c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000056e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000570:	04b7f263          	bgeu	a5,a1,800005b4 <walk+0x66>
    panic("walk");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	adc50513          	addi	a0,a0,-1316 # 80008050 <etext+0x50>
    8000057c:	00006097          	auipc	ra,0x6
    80000580:	bd0080e7          	jalr	-1072(ra) # 8000614c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000584:	060a8663          	beqz	s5,800005f0 <walk+0xa2>
    80000588:	00000097          	auipc	ra,0x0
    8000058c:	be4080e7          	jalr	-1052(ra) # 8000016c <kalloc>
    80000590:	84aa                	mv	s1,a0
    80000592:	c529                	beqz	a0,800005dc <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000594:	6605                	lui	a2,0x1
    80000596:	4581                	li	a1,0
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	cbe080e7          	jalr	-834(ra) # 80000256 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005a0:	00c4d793          	srli	a5,s1,0xc
    800005a4:	07aa                	slli	a5,a5,0xa
    800005a6:	0017e793          	ori	a5,a5,1
    800005aa:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005ae:	3a5d                	addiw	s4,s4,-9
    800005b0:	036a0063          	beq	s4,s6,800005d0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005b4:	0149d933          	srl	s2,s3,s4
    800005b8:	1ff97913          	andi	s2,s2,511
    800005bc:	090e                	slli	s2,s2,0x3
    800005be:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005c0:	00093483          	ld	s1,0(s2)
    800005c4:	0014f793          	andi	a5,s1,1
    800005c8:	dfd5                	beqz	a5,80000584 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005ca:	80a9                	srli	s1,s1,0xa
    800005cc:	04b2                	slli	s1,s1,0xc
    800005ce:	b7c5                	j	800005ae <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005d0:	00c9d513          	srli	a0,s3,0xc
    800005d4:	1ff57513          	andi	a0,a0,511
    800005d8:	050e                	slli	a0,a0,0x3
    800005da:	9526                	add	a0,a0,s1
}
    800005dc:	70e2                	ld	ra,56(sp)
    800005de:	7442                	ld	s0,48(sp)
    800005e0:	74a2                	ld	s1,40(sp)
    800005e2:	7902                	ld	s2,32(sp)
    800005e4:	69e2                	ld	s3,24(sp)
    800005e6:	6a42                	ld	s4,16(sp)
    800005e8:	6aa2                	ld	s5,8(sp)
    800005ea:	6b02                	ld	s6,0(sp)
    800005ec:	6121                	addi	sp,sp,64
    800005ee:	8082                	ret
        return 0;
    800005f0:	4501                	li	a0,0
    800005f2:	b7ed                	j	800005dc <walk+0x8e>

00000000800005f4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005f4:	57fd                	li	a5,-1
    800005f6:	83e9                	srli	a5,a5,0x1a
    800005f8:	00b7f463          	bgeu	a5,a1,80000600 <walkaddr+0xc>
    return 0;
    800005fc:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005fe:	8082                	ret
{
    80000600:	1141                	addi	sp,sp,-16
    80000602:	e406                	sd	ra,8(sp)
    80000604:	e022                	sd	s0,0(sp)
    80000606:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000608:	4601                	li	a2,0
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	f44080e7          	jalr	-188(ra) # 8000054e <walk>
  if(pte == 0)
    80000612:	c105                	beqz	a0,80000632 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000614:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000616:	0117f693          	andi	a3,a5,17
    8000061a:	4745                	li	a4,17
    return 0;
    8000061c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000061e:	00e68663          	beq	a3,a4,8000062a <walkaddr+0x36>
}
    80000622:	60a2                	ld	ra,8(sp)
    80000624:	6402                	ld	s0,0(sp)
    80000626:	0141                	addi	sp,sp,16
    80000628:	8082                	ret
  pa = PTE2PA(*pte);
    8000062a:	00a7d513          	srli	a0,a5,0xa
    8000062e:	0532                	slli	a0,a0,0xc
  return pa;
    80000630:	bfcd                	j	80000622 <walkaddr+0x2e>
    return 0;
    80000632:	4501                	li	a0,0
    80000634:	b7fd                	j	80000622 <walkaddr+0x2e>

0000000080000636 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000636:	715d                	addi	sp,sp,-80
    80000638:	e486                	sd	ra,72(sp)
    8000063a:	e0a2                	sd	s0,64(sp)
    8000063c:	fc26                	sd	s1,56(sp)
    8000063e:	f84a                	sd	s2,48(sp)
    80000640:	f44e                	sd	s3,40(sp)
    80000642:	f052                	sd	s4,32(sp)
    80000644:	ec56                	sd	s5,24(sp)
    80000646:	e85a                	sd	s6,16(sp)
    80000648:	e45e                	sd	s7,8(sp)
    8000064a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000064c:	c205                	beqz	a2,8000066c <mappages+0x36>
    8000064e:	8aaa                	mv	s5,a0
    80000650:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000652:	77fd                	lui	a5,0xfffff
    80000654:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000658:	15fd                	addi	a1,a1,-1
    8000065a:	00c589b3          	add	s3,a1,a2
    8000065e:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000662:	8952                	mv	s2,s4
    80000664:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000668:	6b85                	lui	s7,0x1
    8000066a:	a015                	j	8000068e <mappages+0x58>
    panic("mappages: size");
    8000066c:	00008517          	auipc	a0,0x8
    80000670:	9ec50513          	addi	a0,a0,-1556 # 80008058 <etext+0x58>
    80000674:	00006097          	auipc	ra,0x6
    80000678:	ad8080e7          	jalr	-1320(ra) # 8000614c <panic>
      panic("mappages: remap");
    8000067c:	00008517          	auipc	a0,0x8
    80000680:	9ec50513          	addi	a0,a0,-1556 # 80008068 <etext+0x68>
    80000684:	00006097          	auipc	ra,0x6
    80000688:	ac8080e7          	jalr	-1336(ra) # 8000614c <panic>
    a += PGSIZE;
    8000068c:	995e                	add	s2,s2,s7
  for(;;){
    8000068e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000692:	4605                	li	a2,1
    80000694:	85ca                	mv	a1,s2
    80000696:	8556                	mv	a0,s5
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	eb6080e7          	jalr	-330(ra) # 8000054e <walk>
    800006a0:	cd19                	beqz	a0,800006be <mappages+0x88>
    if(*pte & PTE_V)
    800006a2:	611c                	ld	a5,0(a0)
    800006a4:	8b85                	andi	a5,a5,1
    800006a6:	fbf9                	bnez	a5,8000067c <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006a8:	80b1                	srli	s1,s1,0xc
    800006aa:	04aa                	slli	s1,s1,0xa
    800006ac:	0164e4b3          	or	s1,s1,s6
    800006b0:	0014e493          	ori	s1,s1,1
    800006b4:	e104                	sd	s1,0(a0)
    if(a == last)
    800006b6:	fd391be3          	bne	s2,s3,8000068c <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800006ba:	4501                	li	a0,0
    800006bc:	a011                	j	800006c0 <mappages+0x8a>
      return -1;
    800006be:	557d                	li	a0,-1
}
    800006c0:	60a6                	ld	ra,72(sp)
    800006c2:	6406                	ld	s0,64(sp)
    800006c4:	74e2                	ld	s1,56(sp)
    800006c6:	7942                	ld	s2,48(sp)
    800006c8:	79a2                	ld	s3,40(sp)
    800006ca:	7a02                	ld	s4,32(sp)
    800006cc:	6ae2                	ld	s5,24(sp)
    800006ce:	6b42                	ld	s6,16(sp)
    800006d0:	6ba2                	ld	s7,8(sp)
    800006d2:	6161                	addi	sp,sp,80
    800006d4:	8082                	ret

00000000800006d6 <kvmmap>:
{
    800006d6:	1141                	addi	sp,sp,-16
    800006d8:	e406                	sd	ra,8(sp)
    800006da:	e022                	sd	s0,0(sp)
    800006dc:	0800                	addi	s0,sp,16
    800006de:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006e0:	86b2                	mv	a3,a2
    800006e2:	863e                	mv	a2,a5
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	f52080e7          	jalr	-174(ra) # 80000636 <mappages>
    800006ec:	e509                	bnez	a0,800006f6 <kvmmap+0x20>
}
    800006ee:	60a2                	ld	ra,8(sp)
    800006f0:	6402                	ld	s0,0(sp)
    800006f2:	0141                	addi	sp,sp,16
    800006f4:	8082                	ret
    panic("kvmmap");
    800006f6:	00008517          	auipc	a0,0x8
    800006fa:	98250513          	addi	a0,a0,-1662 # 80008078 <etext+0x78>
    800006fe:	00006097          	auipc	ra,0x6
    80000702:	a4e080e7          	jalr	-1458(ra) # 8000614c <panic>

0000000080000706 <kvmmake>:
{
    80000706:	1101                	addi	sp,sp,-32
    80000708:	ec06                	sd	ra,24(sp)
    8000070a:	e822                	sd	s0,16(sp)
    8000070c:	e426                	sd	s1,8(sp)
    8000070e:	e04a                	sd	s2,0(sp)
    80000710:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000712:	00000097          	auipc	ra,0x0
    80000716:	a5a080e7          	jalr	-1446(ra) # 8000016c <kalloc>
    8000071a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000071c:	6605                	lui	a2,0x1
    8000071e:	4581                	li	a1,0
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b36080e7          	jalr	-1226(ra) # 80000256 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000728:	4719                	li	a4,6
    8000072a:	6685                	lui	a3,0x1
    8000072c:	10000637          	lui	a2,0x10000
    80000730:	100005b7          	lui	a1,0x10000
    80000734:	8526                	mv	a0,s1
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	fa0080e7          	jalr	-96(ra) # 800006d6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000073e:	4719                	li	a4,6
    80000740:	6685                	lui	a3,0x1
    80000742:	10001637          	lui	a2,0x10001
    80000746:	100015b7          	lui	a1,0x10001
    8000074a:	8526                	mv	a0,s1
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	f8a080e7          	jalr	-118(ra) # 800006d6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000754:	4719                	li	a4,6
    80000756:	004006b7          	lui	a3,0x400
    8000075a:	0c000637          	lui	a2,0xc000
    8000075e:	0c0005b7          	lui	a1,0xc000
    80000762:	8526                	mv	a0,s1
    80000764:	00000097          	auipc	ra,0x0
    80000768:	f72080e7          	jalr	-142(ra) # 800006d6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000076c:	00008917          	auipc	s2,0x8
    80000770:	89490913          	addi	s2,s2,-1900 # 80008000 <etext>
    80000774:	4729                	li	a4,10
    80000776:	80008697          	auipc	a3,0x80008
    8000077a:	88a68693          	addi	a3,a3,-1910 # 8000 <_entry-0x7fff8000>
    8000077e:	4605                	li	a2,1
    80000780:	067e                	slli	a2,a2,0x1f
    80000782:	85b2                	mv	a1,a2
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	f50080e7          	jalr	-176(ra) # 800006d6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000078e:	4719                	li	a4,6
    80000790:	46c5                	li	a3,17
    80000792:	06ee                	slli	a3,a3,0x1b
    80000794:	412686b3          	sub	a3,a3,s2
    80000798:	864a                	mv	a2,s2
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8526                	mv	a0,s1
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	f38080e7          	jalr	-200(ra) # 800006d6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007a6:	4729                	li	a4,10
    800007a8:	6685                	lui	a3,0x1
    800007aa:	00007617          	auipc	a2,0x7
    800007ae:	85660613          	addi	a2,a2,-1962 # 80007000 <_trampoline>
    800007b2:	040005b7          	lui	a1,0x4000
    800007b6:	15fd                	addi	a1,a1,-1
    800007b8:	05b2                	slli	a1,a1,0xc
    800007ba:	8526                	mv	a0,s1
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	f1a080e7          	jalr	-230(ra) # 800006d6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007c4:	8526                	mv	a0,s1
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	5fe080e7          	jalr	1534(ra) # 80000dc4 <proc_mapstacks>
}
    800007ce:	8526                	mv	a0,s1
    800007d0:	60e2                	ld	ra,24(sp)
    800007d2:	6442                	ld	s0,16(sp)
    800007d4:	64a2                	ld	s1,8(sp)
    800007d6:	6902                	ld	s2,0(sp)
    800007d8:	6105                	addi	sp,sp,32
    800007da:	8082                	ret

00000000800007dc <kvminit>:
{
    800007dc:	1141                	addi	sp,sp,-16
    800007de:	e406                	sd	ra,8(sp)
    800007e0:	e022                	sd	s0,0(sp)
    800007e2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	f22080e7          	jalr	-222(ra) # 80000706 <kvmmake>
    800007ec:	00009797          	auipc	a5,0x9
    800007f0:	80a7be23          	sd	a0,-2020(a5) # 80009008 <kernel_pagetable>
}
    800007f4:	60a2                	ld	ra,8(sp)
    800007f6:	6402                	ld	s0,0(sp)
    800007f8:	0141                	addi	sp,sp,16
    800007fa:	8082                	ret

00000000800007fc <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007fc:	715d                	addi	sp,sp,-80
    800007fe:	e486                	sd	ra,72(sp)
    80000800:	e0a2                	sd	s0,64(sp)
    80000802:	fc26                	sd	s1,56(sp)
    80000804:	f84a                	sd	s2,48(sp)
    80000806:	f44e                	sd	s3,40(sp)
    80000808:	f052                	sd	s4,32(sp)
    8000080a:	ec56                	sd	s5,24(sp)
    8000080c:	e85a                	sd	s6,16(sp)
    8000080e:	e45e                	sd	s7,8(sp)
    80000810:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000812:	03459793          	slli	a5,a1,0x34
    80000816:	e795                	bnez	a5,80000842 <uvmunmap+0x46>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	892e                	mv	s2,a1
    8000081c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000081e:	0632                	slli	a2,a2,0xc
    80000820:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000824:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000826:	6b05                	lui	s6,0x1
    80000828:	0735e863          	bltu	a1,s3,80000898 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000082c:	60a6                	ld	ra,72(sp)
    8000082e:	6406                	ld	s0,64(sp)
    80000830:	74e2                	ld	s1,56(sp)
    80000832:	7942                	ld	s2,48(sp)
    80000834:	79a2                	ld	s3,40(sp)
    80000836:	7a02                	ld	s4,32(sp)
    80000838:	6ae2                	ld	s5,24(sp)
    8000083a:	6b42                	ld	s6,16(sp)
    8000083c:	6ba2                	ld	s7,8(sp)
    8000083e:	6161                	addi	sp,sp,80
    80000840:	8082                	ret
    panic("uvmunmap: not aligned");
    80000842:	00008517          	auipc	a0,0x8
    80000846:	83e50513          	addi	a0,a0,-1986 # 80008080 <etext+0x80>
    8000084a:	00006097          	auipc	ra,0x6
    8000084e:	902080e7          	jalr	-1790(ra) # 8000614c <panic>
      panic("uvmunmap: walk");
    80000852:	00008517          	auipc	a0,0x8
    80000856:	84650513          	addi	a0,a0,-1978 # 80008098 <etext+0x98>
    8000085a:	00006097          	auipc	ra,0x6
    8000085e:	8f2080e7          	jalr	-1806(ra) # 8000614c <panic>
      panic("uvmunmap: not mapped");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	84650513          	addi	a0,a0,-1978 # 800080a8 <etext+0xa8>
    8000086a:	00006097          	auipc	ra,0x6
    8000086e:	8e2080e7          	jalr	-1822(ra) # 8000614c <panic>
      panic("uvmunmap: not a leaf");
    80000872:	00008517          	auipc	a0,0x8
    80000876:	84e50513          	addi	a0,a0,-1970 # 800080c0 <etext+0xc0>
    8000087a:	00006097          	auipc	ra,0x6
    8000087e:	8d2080e7          	jalr	-1838(ra) # 8000614c <panic>
      uint64 pa = PTE2PA(*pte);
    80000882:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000884:	0532                	slli	a0,a0,0xc
    80000886:	fffff097          	auipc	ra,0xfffff
    8000088a:	796080e7          	jalr	1942(ra) # 8000001c <kfree>
    *pte = 0;
    8000088e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000892:	995a                	add	s2,s2,s6
    80000894:	f9397ce3          	bgeu	s2,s3,8000082c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000898:	4601                	li	a2,0
    8000089a:	85ca                	mv	a1,s2
    8000089c:	8552                	mv	a0,s4
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	cb0080e7          	jalr	-848(ra) # 8000054e <walk>
    800008a6:	84aa                	mv	s1,a0
    800008a8:	d54d                	beqz	a0,80000852 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008aa:	6108                	ld	a0,0(a0)
    800008ac:	00157793          	andi	a5,a0,1
    800008b0:	dbcd                	beqz	a5,80000862 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008b2:	3ff57793          	andi	a5,a0,1023
    800008b6:	fb778ee3          	beq	a5,s7,80000872 <uvmunmap+0x76>
    if(do_free){
    800008ba:	fc0a8ae3          	beqz	s5,8000088e <uvmunmap+0x92>
    800008be:	b7d1                	j	80000882 <uvmunmap+0x86>

00000000800008c0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008c0:	1101                	addi	sp,sp,-32
    800008c2:	ec06                	sd	ra,24(sp)
    800008c4:	e822                	sd	s0,16(sp)
    800008c6:	e426                	sd	s1,8(sp)
    800008c8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	8a2080e7          	jalr	-1886(ra) # 8000016c <kalloc>
    800008d2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008d4:	c519                	beqz	a0,800008e2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008d6:	6605                	lui	a2,0x1
    800008d8:	4581                	li	a1,0
    800008da:	00000097          	auipc	ra,0x0
    800008de:	97c080e7          	jalr	-1668(ra) # 80000256 <memset>
  return pagetable;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret

00000000800008ee <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008ee:	7179                	addi	sp,sp,-48
    800008f0:	f406                	sd	ra,40(sp)
    800008f2:	f022                	sd	s0,32(sp)
    800008f4:	ec26                	sd	s1,24(sp)
    800008f6:	e84a                	sd	s2,16(sp)
    800008f8:	e44e                	sd	s3,8(sp)
    800008fa:	e052                	sd	s4,0(sp)
    800008fc:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800008fe:	6785                	lui	a5,0x1
    80000900:	04f67863          	bgeu	a2,a5,80000950 <uvminit+0x62>
    80000904:	8a2a                	mv	s4,a0
    80000906:	89ae                	mv	s3,a1
    80000908:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	862080e7          	jalr	-1950(ra) # 8000016c <kalloc>
    80000912:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000914:	6605                	lui	a2,0x1
    80000916:	4581                	li	a1,0
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	93e080e7          	jalr	-1730(ra) # 80000256 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000920:	4779                	li	a4,30
    80000922:	86ca                	mv	a3,s2
    80000924:	6605                	lui	a2,0x1
    80000926:	4581                	li	a1,0
    80000928:	8552                	mv	a0,s4
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	d0c080e7          	jalr	-756(ra) # 80000636 <mappages>
  memmove(mem, src, sz);
    80000932:	8626                	mv	a2,s1
    80000934:	85ce                	mv	a1,s3
    80000936:	854a                	mv	a0,s2
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	97e080e7          	jalr	-1666(ra) # 800002b6 <memmove>
}
    80000940:	70a2                	ld	ra,40(sp)
    80000942:	7402                	ld	s0,32(sp)
    80000944:	64e2                	ld	s1,24(sp)
    80000946:	6942                	ld	s2,16(sp)
    80000948:	69a2                	ld	s3,8(sp)
    8000094a:	6a02                	ld	s4,0(sp)
    8000094c:	6145                	addi	sp,sp,48
    8000094e:	8082                	ret
    panic("inituvm: more than a page");
    80000950:	00007517          	auipc	a0,0x7
    80000954:	78850513          	addi	a0,a0,1928 # 800080d8 <etext+0xd8>
    80000958:	00005097          	auipc	ra,0x5
    8000095c:	7f4080e7          	jalr	2036(ra) # 8000614c <panic>

0000000080000960 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000960:	1101                	addi	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000096a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000096c:	00b67d63          	bgeu	a2,a1,80000986 <uvmdealloc+0x26>
    80000970:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000972:	6785                	lui	a5,0x1
    80000974:	17fd                	addi	a5,a5,-1
    80000976:	00f60733          	add	a4,a2,a5
    8000097a:	767d                	lui	a2,0xfffff
    8000097c:	8f71                	and	a4,a4,a2
    8000097e:	97ae                	add	a5,a5,a1
    80000980:	8ff1                	and	a5,a5,a2
    80000982:	00f76863          	bltu	a4,a5,80000992 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000986:	8526                	mv	a0,s1
    80000988:	60e2                	ld	ra,24(sp)
    8000098a:	6442                	ld	s0,16(sp)
    8000098c:	64a2                	ld	s1,8(sp)
    8000098e:	6105                	addi	sp,sp,32
    80000990:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000992:	8f99                	sub	a5,a5,a4
    80000994:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000996:	4685                	li	a3,1
    80000998:	0007861b          	sext.w	a2,a5
    8000099c:	85ba                	mv	a1,a4
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	e5e080e7          	jalr	-418(ra) # 800007fc <uvmunmap>
    800009a6:	b7c5                	j	80000986 <uvmdealloc+0x26>

00000000800009a8 <uvmalloc>:
  if(newsz < oldsz)
    800009a8:	0ab66163          	bltu	a2,a1,80000a4a <uvmalloc+0xa2>
{
    800009ac:	7139                	addi	sp,sp,-64
    800009ae:	fc06                	sd	ra,56(sp)
    800009b0:	f822                	sd	s0,48(sp)
    800009b2:	f426                	sd	s1,40(sp)
    800009b4:	f04a                	sd	s2,32(sp)
    800009b6:	ec4e                	sd	s3,24(sp)
    800009b8:	e852                	sd	s4,16(sp)
    800009ba:	e456                	sd	s5,8(sp)
    800009bc:	0080                	addi	s0,sp,64
    800009be:	8aaa                	mv	s5,a0
    800009c0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009c2:	6985                	lui	s3,0x1
    800009c4:	19fd                	addi	s3,s3,-1
    800009c6:	95ce                	add	a1,a1,s3
    800009c8:	79fd                	lui	s3,0xfffff
    800009ca:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009ce:	08c9f063          	bgeu	s3,a2,80000a4e <uvmalloc+0xa6>
    800009d2:	894e                	mv	s2,s3
    mem = kalloc();
    800009d4:	fffff097          	auipc	ra,0xfffff
    800009d8:	798080e7          	jalr	1944(ra) # 8000016c <kalloc>
    800009dc:	84aa                	mv	s1,a0
    if(mem == 0){
    800009de:	c51d                	beqz	a0,80000a0c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009e0:	6605                	lui	a2,0x1
    800009e2:	4581                	li	a1,0
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	872080e7          	jalr	-1934(ra) # 80000256 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009ec:	4779                	li	a4,30
    800009ee:	86a6                	mv	a3,s1
    800009f0:	6605                	lui	a2,0x1
    800009f2:	85ca                	mv	a1,s2
    800009f4:	8556                	mv	a0,s5
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	c40080e7          	jalr	-960(ra) # 80000636 <mappages>
    800009fe:	e905                	bnez	a0,80000a2e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a00:	6785                	lui	a5,0x1
    80000a02:	993e                	add	s2,s2,a5
    80000a04:	fd4968e3          	bltu	s2,s4,800009d4 <uvmalloc+0x2c>
  return newsz;
    80000a08:	8552                	mv	a0,s4
    80000a0a:	a809                	j	80000a1c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a0c:	864e                	mv	a2,s3
    80000a0e:	85ca                	mv	a1,s2
    80000a10:	8556                	mv	a0,s5
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	f4e080e7          	jalr	-178(ra) # 80000960 <uvmdealloc>
      return 0;
    80000a1a:	4501                	li	a0,0
}
    80000a1c:	70e2                	ld	ra,56(sp)
    80000a1e:	7442                	ld	s0,48(sp)
    80000a20:	74a2                	ld	s1,40(sp)
    80000a22:	7902                	ld	s2,32(sp)
    80000a24:	69e2                	ld	s3,24(sp)
    80000a26:	6a42                	ld	s4,16(sp)
    80000a28:	6aa2                	ld	s5,8(sp)
    80000a2a:	6121                	addi	sp,sp,64
    80000a2c:	8082                	ret
      kfree(mem);
    80000a2e:	8526                	mv	a0,s1
    80000a30:	fffff097          	auipc	ra,0xfffff
    80000a34:	5ec080e7          	jalr	1516(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a38:	864e                	mv	a2,s3
    80000a3a:	85ca                	mv	a1,s2
    80000a3c:	8556                	mv	a0,s5
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	f22080e7          	jalr	-222(ra) # 80000960 <uvmdealloc>
      return 0;
    80000a46:	4501                	li	a0,0
    80000a48:	bfd1                	j	80000a1c <uvmalloc+0x74>
    return oldsz;
    80000a4a:	852e                	mv	a0,a1
}
    80000a4c:	8082                	ret
  return newsz;
    80000a4e:	8532                	mv	a0,a2
    80000a50:	b7f1                	j	80000a1c <uvmalloc+0x74>

0000000080000a52 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a52:	7179                	addi	sp,sp,-48
    80000a54:	f406                	sd	ra,40(sp)
    80000a56:	f022                	sd	s0,32(sp)
    80000a58:	ec26                	sd	s1,24(sp)
    80000a5a:	e84a                	sd	s2,16(sp)
    80000a5c:	e44e                	sd	s3,8(sp)
    80000a5e:	e052                	sd	s4,0(sp)
    80000a60:	1800                	addi	s0,sp,48
    80000a62:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a64:	84aa                	mv	s1,a0
    80000a66:	6905                	lui	s2,0x1
    80000a68:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a6a:	4985                	li	s3,1
    80000a6c:	a821                	j	80000a84 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a6e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a70:	0532                	slli	a0,a0,0xc
    80000a72:	00000097          	auipc	ra,0x0
    80000a76:	fe0080e7          	jalr	-32(ra) # 80000a52 <freewalk>
      pagetable[i] = 0;
    80000a7a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a7e:	04a1                	addi	s1,s1,8
    80000a80:	03248163          	beq	s1,s2,80000aa2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a84:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a86:	00f57793          	andi	a5,a0,15
    80000a8a:	ff3782e3          	beq	a5,s3,80000a6e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a8e:	8905                	andi	a0,a0,1
    80000a90:	d57d                	beqz	a0,80000a7e <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a92:	00007517          	auipc	a0,0x7
    80000a96:	66650513          	addi	a0,a0,1638 # 800080f8 <etext+0xf8>
    80000a9a:	00005097          	auipc	ra,0x5
    80000a9e:	6b2080e7          	jalr	1714(ra) # 8000614c <panic>
    }
  }
  kfree((void*)pagetable);
    80000aa2:	8552                	mv	a0,s4
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	578080e7          	jalr	1400(ra) # 8000001c <kfree>
}
    80000aac:	70a2                	ld	ra,40(sp)
    80000aae:	7402                	ld	s0,32(sp)
    80000ab0:	64e2                	ld	s1,24(sp)
    80000ab2:	6942                	ld	s2,16(sp)
    80000ab4:	69a2                	ld	s3,8(sp)
    80000ab6:	6a02                	ld	s4,0(sp)
    80000ab8:	6145                	addi	sp,sp,48
    80000aba:	8082                	ret

0000000080000abc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000abc:	1101                	addi	sp,sp,-32
    80000abe:	ec06                	sd	ra,24(sp)
    80000ac0:	e822                	sd	s0,16(sp)
    80000ac2:	e426                	sd	s1,8(sp)
    80000ac4:	1000                	addi	s0,sp,32
    80000ac6:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ac8:	e999                	bnez	a1,80000ade <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000aca:	8526                	mv	a0,s1
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	f86080e7          	jalr	-122(ra) # 80000a52 <freewalk>
}
    80000ad4:	60e2                	ld	ra,24(sp)
    80000ad6:	6442                	ld	s0,16(sp)
    80000ad8:	64a2                	ld	s1,8(sp)
    80000ada:	6105                	addi	sp,sp,32
    80000adc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ade:	6605                	lui	a2,0x1
    80000ae0:	167d                	addi	a2,a2,-1
    80000ae2:	962e                	add	a2,a2,a1
    80000ae4:	4685                	li	a3,1
    80000ae6:	8231                	srli	a2,a2,0xc
    80000ae8:	4581                	li	a1,0
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	d12080e7          	jalr	-750(ra) # 800007fc <uvmunmap>
    80000af2:	bfe1                	j	80000aca <uvmfree+0xe>

0000000080000af4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000af4:	c679                	beqz	a2,80000bc2 <uvmcopy+0xce>
{
    80000af6:	715d                	addi	sp,sp,-80
    80000af8:	e486                	sd	ra,72(sp)
    80000afa:	e0a2                	sd	s0,64(sp)
    80000afc:	fc26                	sd	s1,56(sp)
    80000afe:	f84a                	sd	s2,48(sp)
    80000b00:	f44e                	sd	s3,40(sp)
    80000b02:	f052                	sd	s4,32(sp)
    80000b04:	ec56                	sd	s5,24(sp)
    80000b06:	e85a                	sd	s6,16(sp)
    80000b08:	e45e                	sd	s7,8(sp)
    80000b0a:	0880                	addi	s0,sp,80
    80000b0c:	8b2a                	mv	s6,a0
    80000b0e:	8aae                	mv	s5,a1
    80000b10:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b12:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b14:	4601                	li	a2,0
    80000b16:	85ce                	mv	a1,s3
    80000b18:	855a                	mv	a0,s6
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	a34080e7          	jalr	-1484(ra) # 8000054e <walk>
    80000b22:	c531                	beqz	a0,80000b6e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b24:	6118                	ld	a4,0(a0)
    80000b26:	00177793          	andi	a5,a4,1
    80000b2a:	cbb1                	beqz	a5,80000b7e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b2c:	00a75593          	srli	a1,a4,0xa
    80000b30:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b34:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b38:	fffff097          	auipc	ra,0xfffff
    80000b3c:	634080e7          	jalr	1588(ra) # 8000016c <kalloc>
    80000b40:	892a                	mv	s2,a0
    80000b42:	c939                	beqz	a0,80000b98 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b44:	6605                	lui	a2,0x1
    80000b46:	85de                	mv	a1,s7
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	76e080e7          	jalr	1902(ra) # 800002b6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b50:	8726                	mv	a4,s1
    80000b52:	86ca                	mv	a3,s2
    80000b54:	6605                	lui	a2,0x1
    80000b56:	85ce                	mv	a1,s3
    80000b58:	8556                	mv	a0,s5
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	adc080e7          	jalr	-1316(ra) # 80000636 <mappages>
    80000b62:	e515                	bnez	a0,80000b8e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b64:	6785                	lui	a5,0x1
    80000b66:	99be                	add	s3,s3,a5
    80000b68:	fb49e6e3          	bltu	s3,s4,80000b14 <uvmcopy+0x20>
    80000b6c:	a081                	j	80000bac <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b6e:	00007517          	auipc	a0,0x7
    80000b72:	59a50513          	addi	a0,a0,1434 # 80008108 <etext+0x108>
    80000b76:	00005097          	auipc	ra,0x5
    80000b7a:	5d6080e7          	jalr	1494(ra) # 8000614c <panic>
      panic("uvmcopy: page not present");
    80000b7e:	00007517          	auipc	a0,0x7
    80000b82:	5aa50513          	addi	a0,a0,1450 # 80008128 <etext+0x128>
    80000b86:	00005097          	auipc	ra,0x5
    80000b8a:	5c6080e7          	jalr	1478(ra) # 8000614c <panic>
      kfree(mem);
    80000b8e:	854a                	mv	a0,s2
    80000b90:	fffff097          	auipc	ra,0xfffff
    80000b94:	48c080e7          	jalr	1164(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b98:	4685                	li	a3,1
    80000b9a:	00c9d613          	srli	a2,s3,0xc
    80000b9e:	4581                	li	a1,0
    80000ba0:	8556                	mv	a0,s5
    80000ba2:	00000097          	auipc	ra,0x0
    80000ba6:	c5a080e7          	jalr	-934(ra) # 800007fc <uvmunmap>
  return -1;
    80000baa:	557d                	li	a0,-1
}
    80000bac:	60a6                	ld	ra,72(sp)
    80000bae:	6406                	ld	s0,64(sp)
    80000bb0:	74e2                	ld	s1,56(sp)
    80000bb2:	7942                	ld	s2,48(sp)
    80000bb4:	79a2                	ld	s3,40(sp)
    80000bb6:	7a02                	ld	s4,32(sp)
    80000bb8:	6ae2                	ld	s5,24(sp)
    80000bba:	6b42                	ld	s6,16(sp)
    80000bbc:	6ba2                	ld	s7,8(sp)
    80000bbe:	6161                	addi	sp,sp,80
    80000bc0:	8082                	ret
  return 0;
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret

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
    80000bd4:	97e080e7          	jalr	-1666(ra) # 8000054e <walk>
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
    80000bec:	56050513          	addi	a0,a0,1376 # 80008148 <etext+0x148>
    80000bf0:	00005097          	auipc	ra,0x5
    80000bf4:	55c080e7          	jalr	1372(ra) # 8000614c <panic>

0000000080000bf8 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bf8:	c6bd                	beqz	a3,80000c66 <copyout+0x6e>
{
    80000bfa:	715d                	addi	sp,sp,-80
    80000bfc:	e486                	sd	ra,72(sp)
    80000bfe:	e0a2                	sd	s0,64(sp)
    80000c00:	fc26                	sd	s1,56(sp)
    80000c02:	f84a                	sd	s2,48(sp)
    80000c04:	f44e                	sd	s3,40(sp)
    80000c06:	f052                	sd	s4,32(sp)
    80000c08:	ec56                	sd	s5,24(sp)
    80000c0a:	e85a                	sd	s6,16(sp)
    80000c0c:	e45e                	sd	s7,8(sp)
    80000c0e:	e062                	sd	s8,0(sp)
    80000c10:	0880                	addi	s0,sp,80
    80000c12:	8b2a                	mv	s6,a0
    80000c14:	8c2e                	mv	s8,a1
    80000c16:	8a32                	mv	s4,a2
    80000c18:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c1a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c1c:	6a85                	lui	s5,0x1
    80000c1e:	a015                	j	80000c42 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c20:	9562                	add	a0,a0,s8
    80000c22:	0004861b          	sext.w	a2,s1
    80000c26:	85d2                	mv	a1,s4
    80000c28:	41250533          	sub	a0,a0,s2
    80000c2c:	fffff097          	auipc	ra,0xfffff
    80000c30:	68a080e7          	jalr	1674(ra) # 800002b6 <memmove>

    len -= n;
    80000c34:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c38:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c3a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c3e:	02098263          	beqz	s3,80000c62 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c42:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c46:	85ca                	mv	a1,s2
    80000c48:	855a                	mv	a0,s6
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	9aa080e7          	jalr	-1622(ra) # 800005f4 <walkaddr>
    if(pa0 == 0)
    80000c52:	cd01                	beqz	a0,80000c6a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c54:	418904b3          	sub	s1,s2,s8
    80000c58:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c5a:	fc99f3e3          	bgeu	s3,s1,80000c20 <copyout+0x28>
    80000c5e:	84ce                	mv	s1,s3
    80000c60:	b7c1                	j	80000c20 <copyout+0x28>
  }
  return 0;
    80000c62:	4501                	li	a0,0
    80000c64:	a021                	j	80000c6c <copyout+0x74>
    80000c66:	4501                	li	a0,0
}
    80000c68:	8082                	ret
      return -1;
    80000c6a:	557d                	li	a0,-1
}
    80000c6c:	60a6                	ld	ra,72(sp)
    80000c6e:	6406                	ld	s0,64(sp)
    80000c70:	74e2                	ld	s1,56(sp)
    80000c72:	7942                	ld	s2,48(sp)
    80000c74:	79a2                	ld	s3,40(sp)
    80000c76:	7a02                	ld	s4,32(sp)
    80000c78:	6ae2                	ld	s5,24(sp)
    80000c7a:	6b42                	ld	s6,16(sp)
    80000c7c:	6ba2                	ld	s7,8(sp)
    80000c7e:	6c02                	ld	s8,0(sp)
    80000c80:	6161                	addi	sp,sp,80
    80000c82:	8082                	ret

0000000080000c84 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c84:	c6bd                	beqz	a3,80000cf2 <copyin+0x6e>
{
    80000c86:	715d                	addi	sp,sp,-80
    80000c88:	e486                	sd	ra,72(sp)
    80000c8a:	e0a2                	sd	s0,64(sp)
    80000c8c:	fc26                	sd	s1,56(sp)
    80000c8e:	f84a                	sd	s2,48(sp)
    80000c90:	f44e                	sd	s3,40(sp)
    80000c92:	f052                	sd	s4,32(sp)
    80000c94:	ec56                	sd	s5,24(sp)
    80000c96:	e85a                	sd	s6,16(sp)
    80000c98:	e45e                	sd	s7,8(sp)
    80000c9a:	e062                	sd	s8,0(sp)
    80000c9c:	0880                	addi	s0,sp,80
    80000c9e:	8b2a                	mv	s6,a0
    80000ca0:	8a2e                	mv	s4,a1
    80000ca2:	8c32                	mv	s8,a2
    80000ca4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca8:	6a85                	lui	s5,0x1
    80000caa:	a015                	j	80000cce <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cac:	9562                	add	a0,a0,s8
    80000cae:	0004861b          	sext.w	a2,s1
    80000cb2:	412505b3          	sub	a1,a0,s2
    80000cb6:	8552                	mv	a0,s4
    80000cb8:	fffff097          	auipc	ra,0xfffff
    80000cbc:	5fe080e7          	jalr	1534(ra) # 800002b6 <memmove>

    len -= n;
    80000cc0:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cc4:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cc6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cca:	02098263          	beqz	s3,80000cee <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000cce:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cd2:	85ca                	mv	a1,s2
    80000cd4:	855a                	mv	a0,s6
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	91e080e7          	jalr	-1762(ra) # 800005f4 <walkaddr>
    if(pa0 == 0)
    80000cde:	cd01                	beqz	a0,80000cf6 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000ce0:	418904b3          	sub	s1,s2,s8
    80000ce4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000ce6:	fc99f3e3          	bgeu	s3,s1,80000cac <copyin+0x28>
    80000cea:	84ce                	mv	s1,s3
    80000cec:	b7c1                	j	80000cac <copyin+0x28>
  }
  return 0;
    80000cee:	4501                	li	a0,0
    80000cf0:	a021                	j	80000cf8 <copyin+0x74>
    80000cf2:	4501                	li	a0,0
}
    80000cf4:	8082                	ret
      return -1;
    80000cf6:	557d                	li	a0,-1
}
    80000cf8:	60a6                	ld	ra,72(sp)
    80000cfa:	6406                	ld	s0,64(sp)
    80000cfc:	74e2                	ld	s1,56(sp)
    80000cfe:	7942                	ld	s2,48(sp)
    80000d00:	79a2                	ld	s3,40(sp)
    80000d02:	7a02                	ld	s4,32(sp)
    80000d04:	6ae2                	ld	s5,24(sp)
    80000d06:	6b42                	ld	s6,16(sp)
    80000d08:	6ba2                	ld	s7,8(sp)
    80000d0a:	6c02                	ld	s8,0(sp)
    80000d0c:	6161                	addi	sp,sp,80
    80000d0e:	8082                	ret

0000000080000d10 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d10:	c6c5                	beqz	a3,80000db8 <copyinstr+0xa8>
{
    80000d12:	715d                	addi	sp,sp,-80
    80000d14:	e486                	sd	ra,72(sp)
    80000d16:	e0a2                	sd	s0,64(sp)
    80000d18:	fc26                	sd	s1,56(sp)
    80000d1a:	f84a                	sd	s2,48(sp)
    80000d1c:	f44e                	sd	s3,40(sp)
    80000d1e:	f052                	sd	s4,32(sp)
    80000d20:	ec56                	sd	s5,24(sp)
    80000d22:	e85a                	sd	s6,16(sp)
    80000d24:	e45e                	sd	s7,8(sp)
    80000d26:	0880                	addi	s0,sp,80
    80000d28:	8a2a                	mv	s4,a0
    80000d2a:	8b2e                	mv	s6,a1
    80000d2c:	8bb2                	mv	s7,a2
    80000d2e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d30:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d32:	6985                	lui	s3,0x1
    80000d34:	a035                	j	80000d60 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d36:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d3a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d3c:	0017b793          	seqz	a5,a5
    80000d40:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d44:	60a6                	ld	ra,72(sp)
    80000d46:	6406                	ld	s0,64(sp)
    80000d48:	74e2                	ld	s1,56(sp)
    80000d4a:	7942                	ld	s2,48(sp)
    80000d4c:	79a2                	ld	s3,40(sp)
    80000d4e:	7a02                	ld	s4,32(sp)
    80000d50:	6ae2                	ld	s5,24(sp)
    80000d52:	6b42                	ld	s6,16(sp)
    80000d54:	6ba2                	ld	s7,8(sp)
    80000d56:	6161                	addi	sp,sp,80
    80000d58:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d5a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d5e:	c8a9                	beqz	s1,80000db0 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d60:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d64:	85ca                	mv	a1,s2
    80000d66:	8552                	mv	a0,s4
    80000d68:	00000097          	auipc	ra,0x0
    80000d6c:	88c080e7          	jalr	-1908(ra) # 800005f4 <walkaddr>
    if(pa0 == 0)
    80000d70:	c131                	beqz	a0,80000db4 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d72:	41790833          	sub	a6,s2,s7
    80000d76:	984e                	add	a6,a6,s3
    if(n > max)
    80000d78:	0104f363          	bgeu	s1,a6,80000d7e <copyinstr+0x6e>
    80000d7c:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d7e:	955e                	add	a0,a0,s7
    80000d80:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d84:	fc080be3          	beqz	a6,80000d5a <copyinstr+0x4a>
    80000d88:	985a                	add	a6,a6,s6
    80000d8a:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d8c:	41650633          	sub	a2,a0,s6
    80000d90:	14fd                	addi	s1,s1,-1
    80000d92:	9b26                	add	s6,s6,s1
    80000d94:	00f60733          	add	a4,a2,a5
    80000d98:	00074703          	lbu	a4,0(a4)
    80000d9c:	df49                	beqz	a4,80000d36 <copyinstr+0x26>
        *dst = *p;
    80000d9e:	00e78023          	sb	a4,0(a5)
      --max;
    80000da2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000da6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000da8:	ff0796e3          	bne	a5,a6,80000d94 <copyinstr+0x84>
      dst++;
    80000dac:	8b42                	mv	s6,a6
    80000dae:	b775                	j	80000d5a <copyinstr+0x4a>
    80000db0:	4781                	li	a5,0
    80000db2:	b769                	j	80000d3c <copyinstr+0x2c>
      return -1;
    80000db4:	557d                	li	a0,-1
    80000db6:	b779                	j	80000d44 <copyinstr+0x34>
  int got_null = 0;
    80000db8:	4781                	li	a5,0
  if(got_null){
    80000dba:	0017b793          	seqz	a5,a5
    80000dbe:	40f00533          	neg	a0,a5
}
    80000dc2:	8082                	ret

0000000080000dc4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dc4:	7139                	addi	sp,sp,-64
    80000dc6:	fc06                	sd	ra,56(sp)
    80000dc8:	f822                	sd	s0,48(sp)
    80000dca:	f426                	sd	s1,40(sp)
    80000dcc:	f04a                	sd	s2,32(sp)
    80000dce:	ec4e                	sd	s3,24(sp)
    80000dd0:	e852                	sd	s4,16(sp)
    80000dd2:	e456                	sd	s5,8(sp)
    80000dd4:	e05a                	sd	s6,0(sp)
    80000dd6:	0080                	addi	s0,sp,64
    80000dd8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dda:	00008497          	auipc	s1,0x8
    80000dde:	7d648493          	addi	s1,s1,2006 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000de2:	8b26                	mv	s6,s1
    80000de4:	00007a97          	auipc	s5,0x7
    80000de8:	21ca8a93          	addi	s5,s5,540 # 80008000 <etext>
    80000dec:	04000937          	lui	s2,0x4000
    80000df0:	197d                	addi	s2,s2,-1
    80000df2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df4:	0000ea17          	auipc	s4,0xe
    80000df8:	3bca0a13          	addi	s4,s4,956 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000dfc:	fffff097          	auipc	ra,0xfffff
    80000e00:	370080e7          	jalr	880(ra) # 8000016c <kalloc>
    80000e04:	862a                	mv	a2,a0
    if(pa == 0)
    80000e06:	c131                	beqz	a0,80000e4a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e08:	416485b3          	sub	a1,s1,s6
    80000e0c:	8591                	srai	a1,a1,0x4
    80000e0e:	000ab783          	ld	a5,0(s5)
    80000e12:	02f585b3          	mul	a1,a1,a5
    80000e16:	2585                	addiw	a1,a1,1
    80000e18:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e1c:	4719                	li	a4,6
    80000e1e:	6685                	lui	a3,0x1
    80000e20:	40b905b3          	sub	a1,s2,a1
    80000e24:	854e                	mv	a0,s3
    80000e26:	00000097          	auipc	ra,0x0
    80000e2a:	8b0080e7          	jalr	-1872(ra) # 800006d6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2e:	17048493          	addi	s1,s1,368
    80000e32:	fd4495e3          	bne	s1,s4,80000dfc <proc_mapstacks+0x38>
  }
}
    80000e36:	70e2                	ld	ra,56(sp)
    80000e38:	7442                	ld	s0,48(sp)
    80000e3a:	74a2                	ld	s1,40(sp)
    80000e3c:	7902                	ld	s2,32(sp)
    80000e3e:	69e2                	ld	s3,24(sp)
    80000e40:	6a42                	ld	s4,16(sp)
    80000e42:	6aa2                	ld	s5,8(sp)
    80000e44:	6b02                	ld	s6,0(sp)
    80000e46:	6121                	addi	sp,sp,64
    80000e48:	8082                	ret
      panic("kalloc");
    80000e4a:	00007517          	auipc	a0,0x7
    80000e4e:	30e50513          	addi	a0,a0,782 # 80008158 <etext+0x158>
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	2fa080e7          	jalr	762(ra) # 8000614c <panic>

0000000080000e5a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e5a:	7139                	addi	sp,sp,-64
    80000e5c:	fc06                	sd	ra,56(sp)
    80000e5e:	f822                	sd	s0,48(sp)
    80000e60:	f426                	sd	s1,40(sp)
    80000e62:	f04a                	sd	s2,32(sp)
    80000e64:	ec4e                	sd	s3,24(sp)
    80000e66:	e852                	sd	s4,16(sp)
    80000e68:	e456                	sd	s5,8(sp)
    80000e6a:	e05a                	sd	s6,0(sp)
    80000e6c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e6e:	00007597          	auipc	a1,0x7
    80000e72:	2f258593          	addi	a1,a1,754 # 80008160 <etext+0x160>
    80000e76:	00008517          	auipc	a0,0x8
    80000e7a:	2fa50513          	addi	a0,a0,762 # 80009170 <pid_lock>
    80000e7e:	00006097          	auipc	ra,0x6
    80000e82:	97e080e7          	jalr	-1666(ra) # 800067fc <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e86:	00007597          	auipc	a1,0x7
    80000e8a:	2e258593          	addi	a1,a1,738 # 80008168 <etext+0x168>
    80000e8e:	00008517          	auipc	a0,0x8
    80000e92:	30250513          	addi	a0,a0,770 # 80009190 <wait_lock>
    80000e96:	00006097          	auipc	ra,0x6
    80000e9a:	966080e7          	jalr	-1690(ra) # 800067fc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9e:	00008497          	auipc	s1,0x8
    80000ea2:	71248493          	addi	s1,s1,1810 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000ea6:	00007b17          	auipc	s6,0x7
    80000eaa:	2d2b0b13          	addi	s6,s6,722 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000eae:	8aa6                	mv	s5,s1
    80000eb0:	00007a17          	auipc	s4,0x7
    80000eb4:	150a0a13          	addi	s4,s4,336 # 80008000 <etext>
    80000eb8:	04000937          	lui	s2,0x4000
    80000ebc:	197d                	addi	s2,s2,-1
    80000ebe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec0:	0000e997          	auipc	s3,0xe
    80000ec4:	2f098993          	addi	s3,s3,752 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000ec8:	85da                	mv	a1,s6
    80000eca:	8526                	mv	a0,s1
    80000ecc:	00006097          	auipc	ra,0x6
    80000ed0:	930080e7          	jalr	-1744(ra) # 800067fc <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ed4:	415487b3          	sub	a5,s1,s5
    80000ed8:	8791                	srai	a5,a5,0x4
    80000eda:	000a3703          	ld	a4,0(s4)
    80000ede:	02e787b3          	mul	a5,a5,a4
    80000ee2:	2785                	addiw	a5,a5,1
    80000ee4:	00d7979b          	slliw	a5,a5,0xd
    80000ee8:	40f907b3          	sub	a5,s2,a5
    80000eec:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eee:	17048493          	addi	s1,s1,368
    80000ef2:	fd349be3          	bne	s1,s3,80000ec8 <procinit+0x6e>
  }
}
    80000ef6:	70e2                	ld	ra,56(sp)
    80000ef8:	7442                	ld	s0,48(sp)
    80000efa:	74a2                	ld	s1,40(sp)
    80000efc:	7902                	ld	s2,32(sp)
    80000efe:	69e2                	ld	s3,24(sp)
    80000f00:	6a42                	ld	s4,16(sp)
    80000f02:	6aa2                	ld	s5,8(sp)
    80000f04:	6b02                	ld	s6,0(sp)
    80000f06:	6121                	addi	sp,sp,64
    80000f08:	8082                	ret

0000000080000f0a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f0a:	1141                	addi	sp,sp,-16
    80000f0c:	e422                	sd	s0,8(sp)
    80000f0e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f10:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f12:	2501                	sext.w	a0,a0
    80000f14:	6422                	ld	s0,8(sp)
    80000f16:	0141                	addi	sp,sp,16
    80000f18:	8082                	ret

0000000080000f1a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f1a:	1141                	addi	sp,sp,-16
    80000f1c:	e422                	sd	s0,8(sp)
    80000f1e:	0800                	addi	s0,sp,16
    80000f20:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f22:	2781                	sext.w	a5,a5
    80000f24:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f26:	00008517          	auipc	a0,0x8
    80000f2a:	28a50513          	addi	a0,a0,650 # 800091b0 <cpus>
    80000f2e:	953e                	add	a0,a0,a5
    80000f30:	6422                	ld	s0,8(sp)
    80000f32:	0141                	addi	sp,sp,16
    80000f34:	8082                	ret

0000000080000f36 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f36:	1101                	addi	sp,sp,-32
    80000f38:	ec06                	sd	ra,24(sp)
    80000f3a:	e822                	sd	s0,16(sp)
    80000f3c:	e426                	sd	s1,8(sp)
    80000f3e:	1000                	addi	s0,sp,32
  push_off();
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	6f4080e7          	jalr	1780(ra) # 80006634 <push_off>
    80000f48:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f4a:	2781                	sext.w	a5,a5
    80000f4c:	079e                	slli	a5,a5,0x7
    80000f4e:	00008717          	auipc	a4,0x8
    80000f52:	22270713          	addi	a4,a4,546 # 80009170 <pid_lock>
    80000f56:	97ba                	add	a5,a5,a4
    80000f58:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	796080e7          	jalr	1942(ra) # 800066f0 <pop_off>
  return p;
}
    80000f62:	8526                	mv	a0,s1
    80000f64:	60e2                	ld	ra,24(sp)
    80000f66:	6442                	ld	s0,16(sp)
    80000f68:	64a2                	ld	s1,8(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret

0000000080000f6e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f6e:	1141                	addi	sp,sp,-16
    80000f70:	e406                	sd	ra,8(sp)
    80000f72:	e022                	sd	s0,0(sp)
    80000f74:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	fc0080e7          	jalr	-64(ra) # 80000f36 <myproc>
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	7d2080e7          	jalr	2002(ra) # 80006750 <release>

  if (first) {
    80000f86:	00008797          	auipc	a5,0x8
    80000f8a:	93a7a783          	lw	a5,-1734(a5) # 800088c0 <first.1691>
    80000f8e:	eb89                	bnez	a5,80000fa0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f90:	00001097          	auipc	ra,0x1
    80000f94:	c0a080e7          	jalr	-1014(ra) # 80001b9a <usertrapret>
}
    80000f98:	60a2                	ld	ra,8(sp)
    80000f9a:	6402                	ld	s0,0(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret
    first = 0;
    80000fa0:	00008797          	auipc	a5,0x8
    80000fa4:	9207a023          	sw	zero,-1760(a5) # 800088c0 <first.1691>
    fsinit(ROOTDEV);
    80000fa8:	4505                	li	a0,1
    80000faa:	00002097          	auipc	ra,0x2
    80000fae:	b40080e7          	jalr	-1216(ra) # 80002aea <fsinit>
    80000fb2:	bff9                	j	80000f90 <forkret+0x22>

0000000080000fb4 <allocpid>:
allocpid() {
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fc0:	00008917          	auipc	s2,0x8
    80000fc4:	1b090913          	addi	s2,s2,432 # 80009170 <pid_lock>
    80000fc8:	854a                	mv	a0,s2
    80000fca:	00005097          	auipc	ra,0x5
    80000fce:	6b6080e7          	jalr	1718(ra) # 80006680 <acquire>
  pid = nextpid;
    80000fd2:	00008797          	auipc	a5,0x8
    80000fd6:	8f278793          	addi	a5,a5,-1806 # 800088c4 <nextpid>
    80000fda:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fdc:	0014871b          	addiw	a4,s1,1
    80000fe0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fe2:	854a                	mv	a0,s2
    80000fe4:	00005097          	auipc	ra,0x5
    80000fe8:	76c080e7          	jalr	1900(ra) # 80006750 <release>
}
    80000fec:	8526                	mv	a0,s1
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <proc_pagetable>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	e04a                	sd	s2,0(sp)
    80001004:	1000                	addi	s0,sp,32
    80001006:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	8b8080e7          	jalr	-1864(ra) # 800008c0 <uvmcreate>
    80001010:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001012:	c121                	beqz	a0,80001052 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001014:	4729                	li	a4,10
    80001016:	00006697          	auipc	a3,0x6
    8000101a:	fea68693          	addi	a3,a3,-22 # 80007000 <_trampoline>
    8000101e:	6605                	lui	a2,0x1
    80001020:	040005b7          	lui	a1,0x4000
    80001024:	15fd                	addi	a1,a1,-1
    80001026:	05b2                	slli	a1,a1,0xc
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	60e080e7          	jalr	1550(ra) # 80000636 <mappages>
    80001030:	02054863          	bltz	a0,80001060 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001034:	4719                	li	a4,6
    80001036:	06093683          	ld	a3,96(s2)
    8000103a:	6605                	lui	a2,0x1
    8000103c:	020005b7          	lui	a1,0x2000
    80001040:	15fd                	addi	a1,a1,-1
    80001042:	05b6                	slli	a1,a1,0xd
    80001044:	8526                	mv	a0,s1
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	5f0080e7          	jalr	1520(ra) # 80000636 <mappages>
    8000104e:	02054163          	bltz	a0,80001070 <proc_pagetable+0x76>
}
    80001052:	8526                	mv	a0,s1
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret
    uvmfree(pagetable, 0);
    80001060:	4581                	li	a1,0
    80001062:	8526                	mv	a0,s1
    80001064:	00000097          	auipc	ra,0x0
    80001068:	a58080e7          	jalr	-1448(ra) # 80000abc <uvmfree>
    return 0;
    8000106c:	4481                	li	s1,0
    8000106e:	b7d5                	j	80001052 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001070:	4681                	li	a3,0
    80001072:	4605                	li	a2,1
    80001074:	040005b7          	lui	a1,0x4000
    80001078:	15fd                	addi	a1,a1,-1
    8000107a:	05b2                	slli	a1,a1,0xc
    8000107c:	8526                	mv	a0,s1
    8000107e:	fffff097          	auipc	ra,0xfffff
    80001082:	77e080e7          	jalr	1918(ra) # 800007fc <uvmunmap>
    uvmfree(pagetable, 0);
    80001086:	4581                	li	a1,0
    80001088:	8526                	mv	a0,s1
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	a32080e7          	jalr	-1486(ra) # 80000abc <uvmfree>
    return 0;
    80001092:	4481                	li	s1,0
    80001094:	bf7d                	j	80001052 <proc_pagetable+0x58>

0000000080001096 <proc_freepagetable>:
{
    80001096:	1101                	addi	sp,sp,-32
    80001098:	ec06                	sd	ra,24(sp)
    8000109a:	e822                	sd	s0,16(sp)
    8000109c:	e426                	sd	s1,8(sp)
    8000109e:	e04a                	sd	s2,0(sp)
    800010a0:	1000                	addi	s0,sp,32
    800010a2:	84aa                	mv	s1,a0
    800010a4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010a6:	4681                	li	a3,0
    800010a8:	4605                	li	a2,1
    800010aa:	040005b7          	lui	a1,0x4000
    800010ae:	15fd                	addi	a1,a1,-1
    800010b0:	05b2                	slli	a1,a1,0xc
    800010b2:	fffff097          	auipc	ra,0xfffff
    800010b6:	74a080e7          	jalr	1866(ra) # 800007fc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010ba:	4681                	li	a3,0
    800010bc:	4605                	li	a2,1
    800010be:	020005b7          	lui	a1,0x2000
    800010c2:	15fd                	addi	a1,a1,-1
    800010c4:	05b6                	slli	a1,a1,0xd
    800010c6:	8526                	mv	a0,s1
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	734080e7          	jalr	1844(ra) # 800007fc <uvmunmap>
  uvmfree(pagetable, sz);
    800010d0:	85ca                	mv	a1,s2
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	9e8080e7          	jalr	-1560(ra) # 80000abc <uvmfree>
}
    800010dc:	60e2                	ld	ra,24(sp)
    800010de:	6442                	ld	s0,16(sp)
    800010e0:	64a2                	ld	s1,8(sp)
    800010e2:	6902                	ld	s2,0(sp)
    800010e4:	6105                	addi	sp,sp,32
    800010e6:	8082                	ret

00000000800010e8 <freeproc>:
{
    800010e8:	1101                	addi	sp,sp,-32
    800010ea:	ec06                	sd	ra,24(sp)
    800010ec:	e822                	sd	s0,16(sp)
    800010ee:	e426                	sd	s1,8(sp)
    800010f0:	1000                	addi	s0,sp,32
    800010f2:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010f4:	7128                	ld	a0,96(a0)
    800010f6:	c509                	beqz	a0,80001100 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	f24080e7          	jalr	-220(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001100:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001104:	6ca8                	ld	a0,88(s1)
    80001106:	c511                	beqz	a0,80001112 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001108:	68ac                	ld	a1,80(s1)
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	f8c080e7          	jalr	-116(ra) # 80001096 <proc_freepagetable>
  p->pagetable = 0;
    80001112:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001116:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000111a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000111e:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001122:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001126:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000112a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000112e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001132:	0204a023          	sw	zero,32(s1)
}
    80001136:	60e2                	ld	ra,24(sp)
    80001138:	6442                	ld	s0,16(sp)
    8000113a:	64a2                	ld	s1,8(sp)
    8000113c:	6105                	addi	sp,sp,32
    8000113e:	8082                	ret

0000000080001140 <allocproc>:
{
    80001140:	1101                	addi	sp,sp,-32
    80001142:	ec06                	sd	ra,24(sp)
    80001144:	e822                	sd	s0,16(sp)
    80001146:	e426                	sd	s1,8(sp)
    80001148:	e04a                	sd	s2,0(sp)
    8000114a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000114c:	00008497          	auipc	s1,0x8
    80001150:	46448493          	addi	s1,s1,1124 # 800095b0 <proc>
    80001154:	0000e917          	auipc	s2,0xe
    80001158:	05c90913          	addi	s2,s2,92 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	522080e7          	jalr	1314(ra) # 80006680 <acquire>
    if(p->state == UNUSED) {
    80001166:	509c                	lw	a5,32(s1)
    80001168:	cf81                	beqz	a5,80001180 <allocproc+0x40>
      release(&p->lock);
    8000116a:	8526                	mv	a0,s1
    8000116c:	00005097          	auipc	ra,0x5
    80001170:	5e4080e7          	jalr	1508(ra) # 80006750 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001174:	17048493          	addi	s1,s1,368
    80001178:	ff2492e3          	bne	s1,s2,8000115c <allocproc+0x1c>
  return 0;
    8000117c:	4481                	li	s1,0
    8000117e:	a889                	j	800011d0 <allocproc+0x90>
  p->pid = allocpid();
    80001180:	00000097          	auipc	ra,0x0
    80001184:	e34080e7          	jalr	-460(ra) # 80000fb4 <allocpid>
    80001188:	dc88                	sw	a0,56(s1)
  p->state = USED;
    8000118a:	4785                	li	a5,1
    8000118c:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	fde080e7          	jalr	-34(ra) # 8000016c <kalloc>
    80001196:	892a                	mv	s2,a0
    80001198:	f0a8                	sd	a0,96(s1)
    8000119a:	c131                	beqz	a0,800011de <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	e5c080e7          	jalr	-420(ra) # 80000ffa <proc_pagetable>
    800011a6:	892a                	mv	s2,a0
    800011a8:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011aa:	c531                	beqz	a0,800011f6 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011ac:	07000613          	li	a2,112
    800011b0:	4581                	li	a1,0
    800011b2:	06848513          	addi	a0,s1,104
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	0a0080e7          	jalr	160(ra) # 80000256 <memset>
  p->context.ra = (uint64)forkret;
    800011be:	00000797          	auipc	a5,0x0
    800011c2:	db078793          	addi	a5,a5,-592 # 80000f6e <forkret>
    800011c6:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011c8:	64bc                	ld	a5,72(s1)
    800011ca:	6705                	lui	a4,0x1
    800011cc:	97ba                	add	a5,a5,a4
    800011ce:	f8bc                	sd	a5,112(s1)
}
    800011d0:	8526                	mv	a0,s1
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    freeproc(p);
    800011de:	8526                	mv	a0,s1
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	f08080e7          	jalr	-248(ra) # 800010e8 <freeproc>
    release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	00005097          	auipc	ra,0x5
    800011ee:	566080e7          	jalr	1382(ra) # 80006750 <release>
    return 0;
    800011f2:	84ca                	mv	s1,s2
    800011f4:	bff1                	j	800011d0 <allocproc+0x90>
    freeproc(p);
    800011f6:	8526                	mv	a0,s1
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	ef0080e7          	jalr	-272(ra) # 800010e8 <freeproc>
    release(&p->lock);
    80001200:	8526                	mv	a0,s1
    80001202:	00005097          	auipc	ra,0x5
    80001206:	54e080e7          	jalr	1358(ra) # 80006750 <release>
    return 0;
    8000120a:	84ca                	mv	s1,s2
    8000120c:	b7d1                	j	800011d0 <allocproc+0x90>

000000008000120e <userinit>:
{
    8000120e:	1101                	addi	sp,sp,-32
    80001210:	ec06                	sd	ra,24(sp)
    80001212:	e822                	sd	s0,16(sp)
    80001214:	e426                	sd	s1,8(sp)
    80001216:	1000                	addi	s0,sp,32
  p = allocproc();
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	f28080e7          	jalr	-216(ra) # 80001140 <allocproc>
    80001220:	84aa                	mv	s1,a0
  initproc = p;
    80001222:	00008797          	auipc	a5,0x8
    80001226:	dea7b723          	sd	a0,-530(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000122a:	03400613          	li	a2,52
    8000122e:	00007597          	auipc	a1,0x7
    80001232:	6a258593          	addi	a1,a1,1698 # 800088d0 <initcode>
    80001236:	6d28                	ld	a0,88(a0)
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	6b6080e7          	jalr	1718(ra) # 800008ee <uvminit>
  p->sz = PGSIZE;
    80001240:	6785                	lui	a5,0x1
    80001242:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001244:	70b8                	ld	a4,96(s1)
    80001246:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000124a:	70b8                	ld	a4,96(s1)
    8000124c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000124e:	4641                	li	a2,16
    80001250:	00007597          	auipc	a1,0x7
    80001254:	f3058593          	addi	a1,a1,-208 # 80008180 <etext+0x180>
    80001258:	16048513          	addi	a0,s1,352
    8000125c:	fffff097          	auipc	ra,0xfffff
    80001260:	14c080e7          	jalr	332(ra) # 800003a8 <safestrcpy>
  p->cwd = namei("/");
    80001264:	00007517          	auipc	a0,0x7
    80001268:	f2c50513          	addi	a0,a0,-212 # 80008190 <etext+0x190>
    8000126c:	00002097          	auipc	ra,0x2
    80001270:	2ac080e7          	jalr	684(ra) # 80003518 <namei>
    80001274:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001278:	478d                	li	a5,3
    8000127a:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000127c:	8526                	mv	a0,s1
    8000127e:	00005097          	auipc	ra,0x5
    80001282:	4d2080e7          	jalr	1234(ra) # 80006750 <release>
}
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret

0000000080001290 <growproc>:
{
    80001290:	1101                	addi	sp,sp,-32
    80001292:	ec06                	sd	ra,24(sp)
    80001294:	e822                	sd	s0,16(sp)
    80001296:	e426                	sd	s1,8(sp)
    80001298:	e04a                	sd	s2,0(sp)
    8000129a:	1000                	addi	s0,sp,32
    8000129c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	c98080e7          	jalr	-872(ra) # 80000f36 <myproc>
    800012a6:	892a                	mv	s2,a0
  sz = p->sz;
    800012a8:	692c                	ld	a1,80(a0)
    800012aa:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800012ae:	00904f63          	bgtz	s1,800012cc <growproc+0x3c>
  } else if(n < 0){
    800012b2:	0204cc63          	bltz	s1,800012ea <growproc+0x5a>
  p->sz = sz;
    800012b6:	1602                	slli	a2,a2,0x20
    800012b8:	9201                	srli	a2,a2,0x20
    800012ba:	04c93823          	sd	a2,80(s2)
  return 0;
    800012be:	4501                	li	a0,0
}
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6902                	ld	s2,0(sp)
    800012c8:	6105                	addi	sp,sp,32
    800012ca:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800012cc:	9e25                	addw	a2,a2,s1
    800012ce:	1602                	slli	a2,a2,0x20
    800012d0:	9201                	srli	a2,a2,0x20
    800012d2:	1582                	slli	a1,a1,0x20
    800012d4:	9181                	srli	a1,a1,0x20
    800012d6:	6d28                	ld	a0,88(a0)
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	6d0080e7          	jalr	1744(ra) # 800009a8 <uvmalloc>
    800012e0:	0005061b          	sext.w	a2,a0
    800012e4:	fa69                	bnez	a2,800012b6 <growproc+0x26>
      return -1;
    800012e6:	557d                	li	a0,-1
    800012e8:	bfe1                	j	800012c0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ea:	9e25                	addw	a2,a2,s1
    800012ec:	1602                	slli	a2,a2,0x20
    800012ee:	9201                	srli	a2,a2,0x20
    800012f0:	1582                	slli	a1,a1,0x20
    800012f2:	9181                	srli	a1,a1,0x20
    800012f4:	6d28                	ld	a0,88(a0)
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	66a080e7          	jalr	1642(ra) # 80000960 <uvmdealloc>
    800012fe:	0005061b          	sext.w	a2,a0
    80001302:	bf55                	j	800012b6 <growproc+0x26>

0000000080001304 <fork>:
{
    80001304:	7179                	addi	sp,sp,-48
    80001306:	f406                	sd	ra,40(sp)
    80001308:	f022                	sd	s0,32(sp)
    8000130a:	ec26                	sd	s1,24(sp)
    8000130c:	e84a                	sd	s2,16(sp)
    8000130e:	e44e                	sd	s3,8(sp)
    80001310:	e052                	sd	s4,0(sp)
    80001312:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001314:	00000097          	auipc	ra,0x0
    80001318:	c22080e7          	jalr	-990(ra) # 80000f36 <myproc>
    8000131c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	e22080e7          	jalr	-478(ra) # 80001140 <allocproc>
    80001326:	10050b63          	beqz	a0,8000143c <fork+0x138>
    8000132a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000132c:	05093603          	ld	a2,80(s2)
    80001330:	6d2c                	ld	a1,88(a0)
    80001332:	05893503          	ld	a0,88(s2)
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	7be080e7          	jalr	1982(ra) # 80000af4 <uvmcopy>
    8000133e:	04054663          	bltz	a0,8000138a <fork+0x86>
  np->sz = p->sz;
    80001342:	05093783          	ld	a5,80(s2)
    80001346:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    8000134a:	06093683          	ld	a3,96(s2)
    8000134e:	87b6                	mv	a5,a3
    80001350:	0609b703          	ld	a4,96(s3)
    80001354:	12068693          	addi	a3,a3,288
    80001358:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000135c:	6788                	ld	a0,8(a5)
    8000135e:	6b8c                	ld	a1,16(a5)
    80001360:	6f90                	ld	a2,24(a5)
    80001362:	01073023          	sd	a6,0(a4)
    80001366:	e708                	sd	a0,8(a4)
    80001368:	eb0c                	sd	a1,16(a4)
    8000136a:	ef10                	sd	a2,24(a4)
    8000136c:	02078793          	addi	a5,a5,32
    80001370:	02070713          	addi	a4,a4,32
    80001374:	fed792e3          	bne	a5,a3,80001358 <fork+0x54>
  np->trapframe->a0 = 0;
    80001378:	0609b783          	ld	a5,96(s3)
    8000137c:	0607b823          	sd	zero,112(a5)
    80001380:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001384:	15800a13          	li	s4,344
    80001388:	a03d                	j	800013b6 <fork+0xb2>
    freeproc(np);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	d5c080e7          	jalr	-676(ra) # 800010e8 <freeproc>
    release(&np->lock);
    80001394:	854e                	mv	a0,s3
    80001396:	00005097          	auipc	ra,0x5
    8000139a:	3ba080e7          	jalr	954(ra) # 80006750 <release>
    return -1;
    8000139e:	5a7d                	li	s4,-1
    800013a0:	a069                	j	8000142a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800013a2:	00003097          	auipc	ra,0x3
    800013a6:	80c080e7          	jalr	-2036(ra) # 80003bae <filedup>
    800013aa:	009987b3          	add	a5,s3,s1
    800013ae:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800013b0:	04a1                	addi	s1,s1,8
    800013b2:	01448763          	beq	s1,s4,800013c0 <fork+0xbc>
    if(p->ofile[i])
    800013b6:	009907b3          	add	a5,s2,s1
    800013ba:	6388                	ld	a0,0(a5)
    800013bc:	f17d                	bnez	a0,800013a2 <fork+0x9e>
    800013be:	bfcd                	j	800013b0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800013c0:	15893503          	ld	a0,344(s2)
    800013c4:	00002097          	auipc	ra,0x2
    800013c8:	960080e7          	jalr	-1696(ra) # 80002d24 <idup>
    800013cc:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013d0:	4641                	li	a2,16
    800013d2:	16090593          	addi	a1,s2,352
    800013d6:	16098513          	addi	a0,s3,352
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	fce080e7          	jalr	-50(ra) # 800003a8 <safestrcpy>
  pid = np->pid;
    800013e2:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    800013e6:	854e                	mv	a0,s3
    800013e8:	00005097          	auipc	ra,0x5
    800013ec:	368080e7          	jalr	872(ra) # 80006750 <release>
  acquire(&wait_lock);
    800013f0:	00008497          	auipc	s1,0x8
    800013f4:	da048493          	addi	s1,s1,-608 # 80009190 <wait_lock>
    800013f8:	8526                	mv	a0,s1
    800013fa:	00005097          	auipc	ra,0x5
    800013fe:	286080e7          	jalr	646(ra) # 80006680 <acquire>
  np->parent = p;
    80001402:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	348080e7          	jalr	840(ra) # 80006750 <release>
  acquire(&np->lock);
    80001410:	854e                	mv	a0,s3
    80001412:	00005097          	auipc	ra,0x5
    80001416:	26e080e7          	jalr	622(ra) # 80006680 <acquire>
  np->state = RUNNABLE;
    8000141a:	478d                	li	a5,3
    8000141c:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001420:	854e                	mv	a0,s3
    80001422:	00005097          	auipc	ra,0x5
    80001426:	32e080e7          	jalr	814(ra) # 80006750 <release>
}
    8000142a:	8552                	mv	a0,s4
    8000142c:	70a2                	ld	ra,40(sp)
    8000142e:	7402                	ld	s0,32(sp)
    80001430:	64e2                	ld	s1,24(sp)
    80001432:	6942                	ld	s2,16(sp)
    80001434:	69a2                	ld	s3,8(sp)
    80001436:	6a02                	ld	s4,0(sp)
    80001438:	6145                	addi	sp,sp,48
    8000143a:	8082                	ret
    return -1;
    8000143c:	5a7d                	li	s4,-1
    8000143e:	b7f5                	j	8000142a <fork+0x126>

0000000080001440 <scheduler>:
{
    80001440:	7139                	addi	sp,sp,-64
    80001442:	fc06                	sd	ra,56(sp)
    80001444:	f822                	sd	s0,48(sp)
    80001446:	f426                	sd	s1,40(sp)
    80001448:	f04a                	sd	s2,32(sp)
    8000144a:	ec4e                	sd	s3,24(sp)
    8000144c:	e852                	sd	s4,16(sp)
    8000144e:	e456                	sd	s5,8(sp)
    80001450:	e05a                	sd	s6,0(sp)
    80001452:	0080                	addi	s0,sp,64
    80001454:	8792                	mv	a5,tp
  int id = r_tp();
    80001456:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001458:	00779a93          	slli	s5,a5,0x7
    8000145c:	00008717          	auipc	a4,0x8
    80001460:	d1470713          	addi	a4,a4,-748 # 80009170 <pid_lock>
    80001464:	9756                	add	a4,a4,s5
    80001466:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    8000146a:	00008717          	auipc	a4,0x8
    8000146e:	d4e70713          	addi	a4,a4,-690 # 800091b8 <cpus+0x8>
    80001472:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001474:	498d                	li	s3,3
        p->state = RUNNING;
    80001476:	4b11                	li	s6,4
        c->proc = p;
    80001478:	079e                	slli	a5,a5,0x7
    8000147a:	00008a17          	auipc	s4,0x8
    8000147e:	cf6a0a13          	addi	s4,s4,-778 # 80009170 <pid_lock>
    80001482:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001484:	0000e917          	auipc	s2,0xe
    80001488:	d2c90913          	addi	s2,s2,-724 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001490:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001494:	10079073          	csrw	sstatus,a5
    80001498:	00008497          	auipc	s1,0x8
    8000149c:	11848493          	addi	s1,s1,280 # 800095b0 <proc>
    800014a0:	a03d                	j	800014ce <scheduler+0x8e>
        p->state = RUNNING;
    800014a2:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014a6:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014aa:	06848593          	addi	a1,s1,104
    800014ae:	8556                	mv	a0,s5
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	640080e7          	jalr	1600(ra) # 80001af0 <swtch>
        c->proc = 0;
    800014b8:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    800014bc:	8526                	mv	a0,s1
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	292080e7          	jalr	658(ra) # 80006750 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014c6:	17048493          	addi	s1,s1,368
    800014ca:	fd2481e3          	beq	s1,s2,8000148c <scheduler+0x4c>
      acquire(&p->lock);
    800014ce:	8526                	mv	a0,s1
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	1b0080e7          	jalr	432(ra) # 80006680 <acquire>
      if(p->state == RUNNABLE) {
    800014d8:	509c                	lw	a5,32(s1)
    800014da:	ff3791e3          	bne	a5,s3,800014bc <scheduler+0x7c>
    800014de:	b7d1                	j	800014a2 <scheduler+0x62>

00000000800014e0 <sched>:
{
    800014e0:	7179                	addi	sp,sp,-48
    800014e2:	f406                	sd	ra,40(sp)
    800014e4:	f022                	sd	s0,32(sp)
    800014e6:	ec26                	sd	s1,24(sp)
    800014e8:	e84a                	sd	s2,16(sp)
    800014ea:	e44e                	sd	s3,8(sp)
    800014ec:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014ee:	00000097          	auipc	ra,0x0
    800014f2:	a48080e7          	jalr	-1464(ra) # 80000f36 <myproc>
    800014f6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	10e080e7          	jalr	270(ra) # 80006606 <holding>
    80001500:	c93d                	beqz	a0,80001576 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001502:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	00008717          	auipc	a4,0x8
    8000150c:	c6870713          	addi	a4,a4,-920 # 80009170 <pid_lock>
    80001510:	97ba                	add	a5,a5,a4
    80001512:	0b87a703          	lw	a4,184(a5)
    80001516:	4785                	li	a5,1
    80001518:	06f71763          	bne	a4,a5,80001586 <sched+0xa6>
  if(p->state == RUNNING)
    8000151c:	5098                	lw	a4,32(s1)
    8000151e:	4791                	li	a5,4
    80001520:	06f70b63          	beq	a4,a5,80001596 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001524:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001528:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000152a:	efb5                	bnez	a5,800015a6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000152c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000152e:	00008917          	auipc	s2,0x8
    80001532:	c4290913          	addi	s2,s2,-958 # 80009170 <pid_lock>
    80001536:	2781                	sext.w	a5,a5
    80001538:	079e                	slli	a5,a5,0x7
    8000153a:	97ca                	add	a5,a5,s2
    8000153c:	0bc7a983          	lw	s3,188(a5)
    80001540:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001542:	2781                	sext.w	a5,a5
    80001544:	079e                	slli	a5,a5,0x7
    80001546:	00008597          	auipc	a1,0x8
    8000154a:	c7258593          	addi	a1,a1,-910 # 800091b8 <cpus+0x8>
    8000154e:	95be                	add	a1,a1,a5
    80001550:	06848513          	addi	a0,s1,104
    80001554:	00000097          	auipc	ra,0x0
    80001558:	59c080e7          	jalr	1436(ra) # 80001af0 <swtch>
    8000155c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000155e:	2781                	sext.w	a5,a5
    80001560:	079e                	slli	a5,a5,0x7
    80001562:	97ca                	add	a5,a5,s2
    80001564:	0b37ae23          	sw	s3,188(a5)
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6145                	addi	sp,sp,48
    80001574:	8082                	ret
    panic("sched p->lock");
    80001576:	00007517          	auipc	a0,0x7
    8000157a:	c2250513          	addi	a0,a0,-990 # 80008198 <etext+0x198>
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	bce080e7          	jalr	-1074(ra) # 8000614c <panic>
    panic("sched locks");
    80001586:	00007517          	auipc	a0,0x7
    8000158a:	c2250513          	addi	a0,a0,-990 # 800081a8 <etext+0x1a8>
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	bbe080e7          	jalr	-1090(ra) # 8000614c <panic>
    panic("sched running");
    80001596:	00007517          	auipc	a0,0x7
    8000159a:	c2250513          	addi	a0,a0,-990 # 800081b8 <etext+0x1b8>
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	bae080e7          	jalr	-1106(ra) # 8000614c <panic>
    panic("sched interruptible");
    800015a6:	00007517          	auipc	a0,0x7
    800015aa:	c2250513          	addi	a0,a0,-990 # 800081c8 <etext+0x1c8>
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	b9e080e7          	jalr	-1122(ra) # 8000614c <panic>

00000000800015b6 <yield>:
{
    800015b6:	1101                	addi	sp,sp,-32
    800015b8:	ec06                	sd	ra,24(sp)
    800015ba:	e822                	sd	s0,16(sp)
    800015bc:	e426                	sd	s1,8(sp)
    800015be:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	976080e7          	jalr	-1674(ra) # 80000f36 <myproc>
    800015c8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	0b6080e7          	jalr	182(ra) # 80006680 <acquire>
  p->state = RUNNABLE;
    800015d2:	478d                	li	a5,3
    800015d4:	d09c                	sw	a5,32(s1)
  sched();
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	f0a080e7          	jalr	-246(ra) # 800014e0 <sched>
  release(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	170080e7          	jalr	368(ra) # 80006750 <release>
}
    800015e8:	60e2                	ld	ra,24(sp)
    800015ea:	6442                	ld	s0,16(sp)
    800015ec:	64a2                	ld	s1,8(sp)
    800015ee:	6105                	addi	sp,sp,32
    800015f0:	8082                	ret

00000000800015f2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015f2:	7179                	addi	sp,sp,-48
    800015f4:	f406                	sd	ra,40(sp)
    800015f6:	f022                	sd	s0,32(sp)
    800015f8:	ec26                	sd	s1,24(sp)
    800015fa:	e84a                	sd	s2,16(sp)
    800015fc:	e44e                	sd	s3,8(sp)
    800015fe:	1800                	addi	s0,sp,48
    80001600:	89aa                	mv	s3,a0
    80001602:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001604:	00000097          	auipc	ra,0x0
    80001608:	932080e7          	jalr	-1742(ra) # 80000f36 <myproc>
    8000160c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	072080e7          	jalr	114(ra) # 80006680 <acquire>
  release(lk);
    80001616:	854a                	mv	a0,s2
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	138080e7          	jalr	312(ra) # 80006750 <release>

  // Go to sleep.
  p->chan = chan;
    80001620:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001624:	4789                	li	a5,2
    80001626:	d09c                	sw	a5,32(s1)

  sched();
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	eb8080e7          	jalr	-328(ra) # 800014e0 <sched>

  // Tidy up.
  p->chan = 0;
    80001630:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	11a080e7          	jalr	282(ra) # 80006750 <release>
  acquire(lk);
    8000163e:	854a                	mv	a0,s2
    80001640:	00005097          	auipc	ra,0x5
    80001644:	040080e7          	jalr	64(ra) # 80006680 <acquire>
}
    80001648:	70a2                	ld	ra,40(sp)
    8000164a:	7402                	ld	s0,32(sp)
    8000164c:	64e2                	ld	s1,24(sp)
    8000164e:	6942                	ld	s2,16(sp)
    80001650:	69a2                	ld	s3,8(sp)
    80001652:	6145                	addi	sp,sp,48
    80001654:	8082                	ret

0000000080001656 <wait>:
{
    80001656:	715d                	addi	sp,sp,-80
    80001658:	e486                	sd	ra,72(sp)
    8000165a:	e0a2                	sd	s0,64(sp)
    8000165c:	fc26                	sd	s1,56(sp)
    8000165e:	f84a                	sd	s2,48(sp)
    80001660:	f44e                	sd	s3,40(sp)
    80001662:	f052                	sd	s4,32(sp)
    80001664:	ec56                	sd	s5,24(sp)
    80001666:	e85a                	sd	s6,16(sp)
    80001668:	e45e                	sd	s7,8(sp)
    8000166a:	e062                	sd	s8,0(sp)
    8000166c:	0880                	addi	s0,sp,80
    8000166e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001670:	00000097          	auipc	ra,0x0
    80001674:	8c6080e7          	jalr	-1850(ra) # 80000f36 <myproc>
    80001678:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000167a:	00008517          	auipc	a0,0x8
    8000167e:	b1650513          	addi	a0,a0,-1258 # 80009190 <wait_lock>
    80001682:	00005097          	auipc	ra,0x5
    80001686:	ffe080e7          	jalr	-2(ra) # 80006680 <acquire>
    havekids = 0;
    8000168a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000168c:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000168e:	0000e997          	auipc	s3,0xe
    80001692:	b2298993          	addi	s3,s3,-1246 # 8000f1b0 <tickslock>
        havekids = 1;
    80001696:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001698:	00008c17          	auipc	s8,0x8
    8000169c:	af8c0c13          	addi	s8,s8,-1288 # 80009190 <wait_lock>
    havekids = 0;
    800016a0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016a2:	00008497          	auipc	s1,0x8
    800016a6:	f0e48493          	addi	s1,s1,-242 # 800095b0 <proc>
    800016aa:	a0bd                	j	80001718 <wait+0xc2>
          pid = np->pid;
    800016ac:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016b0:	000b0e63          	beqz	s6,800016cc <wait+0x76>
    800016b4:	4691                	li	a3,4
    800016b6:	03448613          	addi	a2,s1,52
    800016ba:	85da                	mv	a1,s6
    800016bc:	05893503          	ld	a0,88(s2)
    800016c0:	fffff097          	auipc	ra,0xfffff
    800016c4:	538080e7          	jalr	1336(ra) # 80000bf8 <copyout>
    800016c8:	02054563          	bltz	a0,800016f2 <wait+0x9c>
          freeproc(np);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	a1a080e7          	jalr	-1510(ra) # 800010e8 <freeproc>
          release(&np->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	078080e7          	jalr	120(ra) # 80006750 <release>
          release(&wait_lock);
    800016e0:	00008517          	auipc	a0,0x8
    800016e4:	ab050513          	addi	a0,a0,-1360 # 80009190 <wait_lock>
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	068080e7          	jalr	104(ra) # 80006750 <release>
          return pid;
    800016f0:	a09d                	j	80001756 <wait+0x100>
            release(&np->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	05c080e7          	jalr	92(ra) # 80006750 <release>
            release(&wait_lock);
    800016fc:	00008517          	auipc	a0,0x8
    80001700:	a9450513          	addi	a0,a0,-1388 # 80009190 <wait_lock>
    80001704:	00005097          	auipc	ra,0x5
    80001708:	04c080e7          	jalr	76(ra) # 80006750 <release>
            return -1;
    8000170c:	59fd                	li	s3,-1
    8000170e:	a0a1                	j	80001756 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001710:	17048493          	addi	s1,s1,368
    80001714:	03348463          	beq	s1,s3,8000173c <wait+0xe6>
      if(np->parent == p){
    80001718:	60bc                	ld	a5,64(s1)
    8000171a:	ff279be3          	bne	a5,s2,80001710 <wait+0xba>
        acquire(&np->lock);
    8000171e:	8526                	mv	a0,s1
    80001720:	00005097          	auipc	ra,0x5
    80001724:	f60080e7          	jalr	-160(ra) # 80006680 <acquire>
        if(np->state == ZOMBIE){
    80001728:	509c                	lw	a5,32(s1)
    8000172a:	f94781e3          	beq	a5,s4,800016ac <wait+0x56>
        release(&np->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	020080e7          	jalr	32(ra) # 80006750 <release>
        havekids = 1;
    80001738:	8756                	mv	a4,s5
    8000173a:	bfd9                	j	80001710 <wait+0xba>
    if(!havekids || p->killed){
    8000173c:	c701                	beqz	a4,80001744 <wait+0xee>
    8000173e:	03092783          	lw	a5,48(s2)
    80001742:	c79d                	beqz	a5,80001770 <wait+0x11a>
      release(&wait_lock);
    80001744:	00008517          	auipc	a0,0x8
    80001748:	a4c50513          	addi	a0,a0,-1460 # 80009190 <wait_lock>
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	004080e7          	jalr	4(ra) # 80006750 <release>
      return -1;
    80001754:	59fd                	li	s3,-1
}
    80001756:	854e                	mv	a0,s3
    80001758:	60a6                	ld	ra,72(sp)
    8000175a:	6406                	ld	s0,64(sp)
    8000175c:	74e2                	ld	s1,56(sp)
    8000175e:	7942                	ld	s2,48(sp)
    80001760:	79a2                	ld	s3,40(sp)
    80001762:	7a02                	ld	s4,32(sp)
    80001764:	6ae2                	ld	s5,24(sp)
    80001766:	6b42                	ld	s6,16(sp)
    80001768:	6ba2                	ld	s7,8(sp)
    8000176a:	6c02                	ld	s8,0(sp)
    8000176c:	6161                	addi	sp,sp,80
    8000176e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001770:	85e2                	mv	a1,s8
    80001772:	854a                	mv	a0,s2
    80001774:	00000097          	auipc	ra,0x0
    80001778:	e7e080e7          	jalr	-386(ra) # 800015f2 <sleep>
    havekids = 0;
    8000177c:	b715                	j	800016a0 <wait+0x4a>

000000008000177e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000177e:	7139                	addi	sp,sp,-64
    80001780:	fc06                	sd	ra,56(sp)
    80001782:	f822                	sd	s0,48(sp)
    80001784:	f426                	sd	s1,40(sp)
    80001786:	f04a                	sd	s2,32(sp)
    80001788:	ec4e                	sd	s3,24(sp)
    8000178a:	e852                	sd	s4,16(sp)
    8000178c:	e456                	sd	s5,8(sp)
    8000178e:	0080                	addi	s0,sp,64
    80001790:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001792:	00008497          	auipc	s1,0x8
    80001796:	e1e48493          	addi	s1,s1,-482 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000179a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000179c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	0000e917          	auipc	s2,0xe
    800017a2:	a1290913          	addi	s2,s2,-1518 # 8000f1b0 <tickslock>
    800017a6:	a821                	j	800017be <wakeup+0x40>
        p->state = RUNNABLE;
    800017a8:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    800017ac:	8526                	mv	a0,s1
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	fa2080e7          	jalr	-94(ra) # 80006750 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b6:	17048493          	addi	s1,s1,368
    800017ba:	03248463          	beq	s1,s2,800017e2 <wakeup+0x64>
    if(p != myproc()){
    800017be:	fffff097          	auipc	ra,0xfffff
    800017c2:	778080e7          	jalr	1912(ra) # 80000f36 <myproc>
    800017c6:	fea488e3          	beq	s1,a0,800017b6 <wakeup+0x38>
      acquire(&p->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	eb4080e7          	jalr	-332(ra) # 80006680 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017d4:	509c                	lw	a5,32(s1)
    800017d6:	fd379be3          	bne	a5,s3,800017ac <wakeup+0x2e>
    800017da:	749c                	ld	a5,40(s1)
    800017dc:	fd4798e3          	bne	a5,s4,800017ac <wakeup+0x2e>
    800017e0:	b7e1                	j	800017a8 <wakeup+0x2a>
    }
  }
}
    800017e2:	70e2                	ld	ra,56(sp)
    800017e4:	7442                	ld	s0,48(sp)
    800017e6:	74a2                	ld	s1,40(sp)
    800017e8:	7902                	ld	s2,32(sp)
    800017ea:	69e2                	ld	s3,24(sp)
    800017ec:	6a42                	ld	s4,16(sp)
    800017ee:	6aa2                	ld	s5,8(sp)
    800017f0:	6121                	addi	sp,sp,64
    800017f2:	8082                	ret

00000000800017f4 <reparent>:
{
    800017f4:	7179                	addi	sp,sp,-48
    800017f6:	f406                	sd	ra,40(sp)
    800017f8:	f022                	sd	s0,32(sp)
    800017fa:	ec26                	sd	s1,24(sp)
    800017fc:	e84a                	sd	s2,16(sp)
    800017fe:	e44e                	sd	s3,8(sp)
    80001800:	e052                	sd	s4,0(sp)
    80001802:	1800                	addi	s0,sp,48
    80001804:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001806:	00008497          	auipc	s1,0x8
    8000180a:	daa48493          	addi	s1,s1,-598 # 800095b0 <proc>
      pp->parent = initproc;
    8000180e:	00008a17          	auipc	s4,0x8
    80001812:	802a0a13          	addi	s4,s4,-2046 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001816:	0000e997          	auipc	s3,0xe
    8000181a:	99a98993          	addi	s3,s3,-1638 # 8000f1b0 <tickslock>
    8000181e:	a029                	j	80001828 <reparent+0x34>
    80001820:	17048493          	addi	s1,s1,368
    80001824:	01348d63          	beq	s1,s3,8000183e <reparent+0x4a>
    if(pp->parent == p){
    80001828:	60bc                	ld	a5,64(s1)
    8000182a:	ff279be3          	bne	a5,s2,80001820 <reparent+0x2c>
      pp->parent = initproc;
    8000182e:	000a3503          	ld	a0,0(s4)
    80001832:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001834:	00000097          	auipc	ra,0x0
    80001838:	f4a080e7          	jalr	-182(ra) # 8000177e <wakeup>
    8000183c:	b7d5                	j	80001820 <reparent+0x2c>
}
    8000183e:	70a2                	ld	ra,40(sp)
    80001840:	7402                	ld	s0,32(sp)
    80001842:	64e2                	ld	s1,24(sp)
    80001844:	6942                	ld	s2,16(sp)
    80001846:	69a2                	ld	s3,8(sp)
    80001848:	6a02                	ld	s4,0(sp)
    8000184a:	6145                	addi	sp,sp,48
    8000184c:	8082                	ret

000000008000184e <exit>:
{
    8000184e:	7179                	addi	sp,sp,-48
    80001850:	f406                	sd	ra,40(sp)
    80001852:	f022                	sd	s0,32(sp)
    80001854:	ec26                	sd	s1,24(sp)
    80001856:	e84a                	sd	s2,16(sp)
    80001858:	e44e                	sd	s3,8(sp)
    8000185a:	e052                	sd	s4,0(sp)
    8000185c:	1800                	addi	s0,sp,48
    8000185e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001860:	fffff097          	auipc	ra,0xfffff
    80001864:	6d6080e7          	jalr	1750(ra) # 80000f36 <myproc>
    80001868:	89aa                	mv	s3,a0
  if(p == initproc)
    8000186a:	00007797          	auipc	a5,0x7
    8000186e:	7a67b783          	ld	a5,1958(a5) # 80009010 <initproc>
    80001872:	0d850493          	addi	s1,a0,216
    80001876:	15850913          	addi	s2,a0,344
    8000187a:	02a79363          	bne	a5,a0,800018a0 <exit+0x52>
    panic("init exiting");
    8000187e:	00007517          	auipc	a0,0x7
    80001882:	96250513          	addi	a0,a0,-1694 # 800081e0 <etext+0x1e0>
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	8c6080e7          	jalr	-1850(ra) # 8000614c <panic>
      fileclose(f);
    8000188e:	00002097          	auipc	ra,0x2
    80001892:	372080e7          	jalr	882(ra) # 80003c00 <fileclose>
      p->ofile[fd] = 0;
    80001896:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000189a:	04a1                	addi	s1,s1,8
    8000189c:	01248563          	beq	s1,s2,800018a6 <exit+0x58>
    if(p->ofile[fd]){
    800018a0:	6088                	ld	a0,0(s1)
    800018a2:	f575                	bnez	a0,8000188e <exit+0x40>
    800018a4:	bfdd                	j	8000189a <exit+0x4c>
  begin_op();
    800018a6:	00002097          	auipc	ra,0x2
    800018aa:	e8e080e7          	jalr	-370(ra) # 80003734 <begin_op>
  iput(p->cwd);
    800018ae:	1589b503          	ld	a0,344(s3)
    800018b2:	00001097          	auipc	ra,0x1
    800018b6:	66a080e7          	jalr	1642(ra) # 80002f1c <iput>
  end_op();
    800018ba:	00002097          	auipc	ra,0x2
    800018be:	efa080e7          	jalr	-262(ra) # 800037b4 <end_op>
  p->cwd = 0;
    800018c2:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800018c6:	00008497          	auipc	s1,0x8
    800018ca:	8ca48493          	addi	s1,s1,-1846 # 80009190 <wait_lock>
    800018ce:	8526                	mv	a0,s1
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	db0080e7          	jalr	-592(ra) # 80006680 <acquire>
  reparent(p);
    800018d8:	854e                	mv	a0,s3
    800018da:	00000097          	auipc	ra,0x0
    800018de:	f1a080e7          	jalr	-230(ra) # 800017f4 <reparent>
  wakeup(p->parent);
    800018e2:	0409b503          	ld	a0,64(s3)
    800018e6:	00000097          	auipc	ra,0x0
    800018ea:	e98080e7          	jalr	-360(ra) # 8000177e <wakeup>
  acquire(&p->lock);
    800018ee:	854e                	mv	a0,s3
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	d90080e7          	jalr	-624(ra) # 80006680 <acquire>
  p->xstate = status;
    800018f8:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800018fc:	4795                	li	a5,5
    800018fe:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	e4c080e7          	jalr	-436(ra) # 80006750 <release>
  sched();
    8000190c:	00000097          	auipc	ra,0x0
    80001910:	bd4080e7          	jalr	-1068(ra) # 800014e0 <sched>
  panic("zombie exit");
    80001914:	00007517          	auipc	a0,0x7
    80001918:	8dc50513          	addi	a0,a0,-1828 # 800081f0 <etext+0x1f0>
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	830080e7          	jalr	-2000(ra) # 8000614c <panic>

0000000080001924 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001924:	7179                	addi	sp,sp,-48
    80001926:	f406                	sd	ra,40(sp)
    80001928:	f022                	sd	s0,32(sp)
    8000192a:	ec26                	sd	s1,24(sp)
    8000192c:	e84a                	sd	s2,16(sp)
    8000192e:	e44e                	sd	s3,8(sp)
    80001930:	1800                	addi	s0,sp,48
    80001932:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001934:	00008497          	auipc	s1,0x8
    80001938:	c7c48493          	addi	s1,s1,-900 # 800095b0 <proc>
    8000193c:	0000e997          	auipc	s3,0xe
    80001940:	87498993          	addi	s3,s3,-1932 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	d3a080e7          	jalr	-710(ra) # 80006680 <acquire>
    if(p->pid == pid){
    8000194e:	5c9c                	lw	a5,56(s1)
    80001950:	01278d63          	beq	a5,s2,8000196a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001954:	8526                	mv	a0,s1
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	dfa080e7          	jalr	-518(ra) # 80006750 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000195e:	17048493          	addi	s1,s1,368
    80001962:	ff3491e3          	bne	s1,s3,80001944 <kill+0x20>
  }
  return -1;
    80001966:	557d                	li	a0,-1
    80001968:	a829                	j	80001982 <kill+0x5e>
      p->killed = 1;
    8000196a:	4785                	li	a5,1
    8000196c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000196e:	5098                	lw	a4,32(s1)
    80001970:	4789                	li	a5,2
    80001972:	00f70f63          	beq	a4,a5,80001990 <kill+0x6c>
      release(&p->lock);
    80001976:	8526                	mv	a0,s1
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	dd8080e7          	jalr	-552(ra) # 80006750 <release>
      return 0;
    80001980:	4501                	li	a0,0
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6145                	addi	sp,sp,48
    8000198e:	8082                	ret
        p->state = RUNNABLE;
    80001990:	478d                	li	a5,3
    80001992:	d09c                	sw	a5,32(s1)
    80001994:	b7cd                	j	80001976 <kill+0x52>

0000000080001996 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001996:	7179                	addi	sp,sp,-48
    80001998:	f406                	sd	ra,40(sp)
    8000199a:	f022                	sd	s0,32(sp)
    8000199c:	ec26                	sd	s1,24(sp)
    8000199e:	e84a                	sd	s2,16(sp)
    800019a0:	e44e                	sd	s3,8(sp)
    800019a2:	e052                	sd	s4,0(sp)
    800019a4:	1800                	addi	s0,sp,48
    800019a6:	84aa                	mv	s1,a0
    800019a8:	892e                	mv	s2,a1
    800019aa:	89b2                	mv	s3,a2
    800019ac:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	588080e7          	jalr	1416(ra) # 80000f36 <myproc>
  if(user_dst){
    800019b6:	c08d                	beqz	s1,800019d8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019b8:	86d2                	mv	a3,s4
    800019ba:	864e                	mv	a2,s3
    800019bc:	85ca                	mv	a1,s2
    800019be:	6d28                	ld	a0,88(a0)
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	238080e7          	jalr	568(ra) # 80000bf8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019c8:	70a2                	ld	ra,40(sp)
    800019ca:	7402                	ld	s0,32(sp)
    800019cc:	64e2                	ld	s1,24(sp)
    800019ce:	6942                	ld	s2,16(sp)
    800019d0:	69a2                	ld	s3,8(sp)
    800019d2:	6a02                	ld	s4,0(sp)
    800019d4:	6145                	addi	sp,sp,48
    800019d6:	8082                	ret
    memmove((char *)dst, src, len);
    800019d8:	000a061b          	sext.w	a2,s4
    800019dc:	85ce                	mv	a1,s3
    800019de:	854a                	mv	a0,s2
    800019e0:	fffff097          	auipc	ra,0xfffff
    800019e4:	8d6080e7          	jalr	-1834(ra) # 800002b6 <memmove>
    return 0;
    800019e8:	8526                	mv	a0,s1
    800019ea:	bff9                	j	800019c8 <either_copyout+0x32>

00000000800019ec <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019ec:	7179                	addi	sp,sp,-48
    800019ee:	f406                	sd	ra,40(sp)
    800019f0:	f022                	sd	s0,32(sp)
    800019f2:	ec26                	sd	s1,24(sp)
    800019f4:	e84a                	sd	s2,16(sp)
    800019f6:	e44e                	sd	s3,8(sp)
    800019f8:	e052                	sd	s4,0(sp)
    800019fa:	1800                	addi	s0,sp,48
    800019fc:	892a                	mv	s2,a0
    800019fe:	84ae                	mv	s1,a1
    80001a00:	89b2                	mv	s3,a2
    80001a02:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a04:	fffff097          	auipc	ra,0xfffff
    80001a08:	532080e7          	jalr	1330(ra) # 80000f36 <myproc>
  if(user_src){
    80001a0c:	c08d                	beqz	s1,80001a2e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a0e:	86d2                	mv	a3,s4
    80001a10:	864e                	mv	a2,s3
    80001a12:	85ca                	mv	a1,s2
    80001a14:	6d28                	ld	a0,88(a0)
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	26e080e7          	jalr	622(ra) # 80000c84 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a1e:	70a2                	ld	ra,40(sp)
    80001a20:	7402                	ld	s0,32(sp)
    80001a22:	64e2                	ld	s1,24(sp)
    80001a24:	6942                	ld	s2,16(sp)
    80001a26:	69a2                	ld	s3,8(sp)
    80001a28:	6a02                	ld	s4,0(sp)
    80001a2a:	6145                	addi	sp,sp,48
    80001a2c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a2e:	000a061b          	sext.w	a2,s4
    80001a32:	85ce                	mv	a1,s3
    80001a34:	854a                	mv	a0,s2
    80001a36:	fffff097          	auipc	ra,0xfffff
    80001a3a:	880080e7          	jalr	-1920(ra) # 800002b6 <memmove>
    return 0;
    80001a3e:	8526                	mv	a0,s1
    80001a40:	bff9                	j	80001a1e <either_copyin+0x32>

0000000080001a42 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a42:	715d                	addi	sp,sp,-80
    80001a44:	e486                	sd	ra,72(sp)
    80001a46:	e0a2                	sd	s0,64(sp)
    80001a48:	fc26                	sd	s1,56(sp)
    80001a4a:	f84a                	sd	s2,48(sp)
    80001a4c:	f44e                	sd	s3,40(sp)
    80001a4e:	f052                	sd	s4,32(sp)
    80001a50:	ec56                	sd	s5,24(sp)
    80001a52:	e85a                	sd	s6,16(sp)
    80001a54:	e45e                	sd	s7,8(sp)
    80001a56:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a58:	00007517          	auipc	a0,0x7
    80001a5c:	e1050513          	addi	a0,a0,-496 # 80008868 <digits+0x88>
    80001a60:	00004097          	auipc	ra,0x4
    80001a64:	736080e7          	jalr	1846(ra) # 80006196 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a68:	00008497          	auipc	s1,0x8
    80001a6c:	ca848493          	addi	s1,s1,-856 # 80009710 <proc+0x160>
    80001a70:	0000e917          	auipc	s2,0xe
    80001a74:	8a090913          	addi	s2,s2,-1888 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a78:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a7a:	00006997          	auipc	s3,0x6
    80001a7e:	78698993          	addi	s3,s3,1926 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a82:	00006a97          	auipc	s5,0x6
    80001a86:	786a8a93          	addi	s5,s5,1926 # 80008208 <etext+0x208>
    printf("\n");
    80001a8a:	00007a17          	auipc	s4,0x7
    80001a8e:	ddea0a13          	addi	s4,s4,-546 # 80008868 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a92:	00006b97          	auipc	s7,0x6
    80001a96:	7aeb8b93          	addi	s7,s7,1966 # 80008240 <states.1728>
    80001a9a:	a00d                	j	80001abc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a9c:	ed86a583          	lw	a1,-296(a3)
    80001aa0:	8556                	mv	a0,s5
    80001aa2:	00004097          	auipc	ra,0x4
    80001aa6:	6f4080e7          	jalr	1780(ra) # 80006196 <printf>
    printf("\n");
    80001aaa:	8552                	mv	a0,s4
    80001aac:	00004097          	auipc	ra,0x4
    80001ab0:	6ea080e7          	jalr	1770(ra) # 80006196 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ab4:	17048493          	addi	s1,s1,368
    80001ab8:	03248163          	beq	s1,s2,80001ada <procdump+0x98>
    if(p->state == UNUSED)
    80001abc:	86a6                	mv	a3,s1
    80001abe:	ec04a783          	lw	a5,-320(s1)
    80001ac2:	dbed                	beqz	a5,80001ab4 <procdump+0x72>
      state = "???";
    80001ac4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ac6:	fcfb6be3          	bltu	s6,a5,80001a9c <procdump+0x5a>
    80001aca:	1782                	slli	a5,a5,0x20
    80001acc:	9381                	srli	a5,a5,0x20
    80001ace:	078e                	slli	a5,a5,0x3
    80001ad0:	97de                	add	a5,a5,s7
    80001ad2:	6390                	ld	a2,0(a5)
    80001ad4:	f661                	bnez	a2,80001a9c <procdump+0x5a>
      state = "???";
    80001ad6:	864e                	mv	a2,s3
    80001ad8:	b7d1                	j	80001a9c <procdump+0x5a>
  }
}
    80001ada:	60a6                	ld	ra,72(sp)
    80001adc:	6406                	ld	s0,64(sp)
    80001ade:	74e2                	ld	s1,56(sp)
    80001ae0:	7942                	ld	s2,48(sp)
    80001ae2:	79a2                	ld	s3,40(sp)
    80001ae4:	7a02                	ld	s4,32(sp)
    80001ae6:	6ae2                	ld	s5,24(sp)
    80001ae8:	6b42                	ld	s6,16(sp)
    80001aea:	6ba2                	ld	s7,8(sp)
    80001aec:	6161                	addi	sp,sp,80
    80001aee:	8082                	ret

0000000080001af0 <swtch>:
    80001af0:	00153023          	sd	ra,0(a0)
    80001af4:	00253423          	sd	sp,8(a0)
    80001af8:	e900                	sd	s0,16(a0)
    80001afa:	ed04                	sd	s1,24(a0)
    80001afc:	03253023          	sd	s2,32(a0)
    80001b00:	03353423          	sd	s3,40(a0)
    80001b04:	03453823          	sd	s4,48(a0)
    80001b08:	03553c23          	sd	s5,56(a0)
    80001b0c:	05653023          	sd	s6,64(a0)
    80001b10:	05753423          	sd	s7,72(a0)
    80001b14:	05853823          	sd	s8,80(a0)
    80001b18:	05953c23          	sd	s9,88(a0)
    80001b1c:	07a53023          	sd	s10,96(a0)
    80001b20:	07b53423          	sd	s11,104(a0)
    80001b24:	0005b083          	ld	ra,0(a1)
    80001b28:	0085b103          	ld	sp,8(a1)
    80001b2c:	6980                	ld	s0,16(a1)
    80001b2e:	6d84                	ld	s1,24(a1)
    80001b30:	0205b903          	ld	s2,32(a1)
    80001b34:	0285b983          	ld	s3,40(a1)
    80001b38:	0305ba03          	ld	s4,48(a1)
    80001b3c:	0385ba83          	ld	s5,56(a1)
    80001b40:	0405bb03          	ld	s6,64(a1)
    80001b44:	0485bb83          	ld	s7,72(a1)
    80001b48:	0505bc03          	ld	s8,80(a1)
    80001b4c:	0585bc83          	ld	s9,88(a1)
    80001b50:	0605bd03          	ld	s10,96(a1)
    80001b54:	0685bd83          	ld	s11,104(a1)
    80001b58:	8082                	ret

0000000080001b5a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b5a:	1141                	addi	sp,sp,-16
    80001b5c:	e406                	sd	ra,8(sp)
    80001b5e:	e022                	sd	s0,0(sp)
    80001b60:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b62:	00006597          	auipc	a1,0x6
    80001b66:	70e58593          	addi	a1,a1,1806 # 80008270 <states.1728+0x30>
    80001b6a:	0000d517          	auipc	a0,0xd
    80001b6e:	64650513          	addi	a0,a0,1606 # 8000f1b0 <tickslock>
    80001b72:	00005097          	auipc	ra,0x5
    80001b76:	c8a080e7          	jalr	-886(ra) # 800067fc <initlock>
}
    80001b7a:	60a2                	ld	ra,8(sp)
    80001b7c:	6402                	ld	s0,0(sp)
    80001b7e:	0141                	addi	sp,sp,16
    80001b80:	8082                	ret

0000000080001b82 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b82:	1141                	addi	sp,sp,-16
    80001b84:	e422                	sd	s0,8(sp)
    80001b86:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b88:	00003797          	auipc	a5,0x3
    80001b8c:	69878793          	addi	a5,a5,1688 # 80005220 <kernelvec>
    80001b90:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b94:	6422                	ld	s0,8(sp)
    80001b96:	0141                	addi	sp,sp,16
    80001b98:	8082                	ret

0000000080001b9a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b9a:	1141                	addi	sp,sp,-16
    80001b9c:	e406                	sd	ra,8(sp)
    80001b9e:	e022                	sd	s0,0(sp)
    80001ba0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	394080e7          	jalr	916(ra) # 80000f36 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001baa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bb4:	00005617          	auipc	a2,0x5
    80001bb8:	44c60613          	addi	a2,a2,1100 # 80007000 <_trampoline>
    80001bbc:	00005697          	auipc	a3,0x5
    80001bc0:	44468693          	addi	a3,a3,1092 # 80007000 <_trampoline>
    80001bc4:	8e91                	sub	a3,a3,a2
    80001bc6:	040007b7          	lui	a5,0x4000
    80001bca:	17fd                	addi	a5,a5,-1
    80001bcc:	07b2                	slli	a5,a5,0xc
    80001bce:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bd0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bd4:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bd6:	180026f3          	csrr	a3,satp
    80001bda:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bdc:	7138                	ld	a4,96(a0)
    80001bde:	6534                	ld	a3,72(a0)
    80001be0:	6585                	lui	a1,0x1
    80001be2:	96ae                	add	a3,a3,a1
    80001be4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001be6:	7138                	ld	a4,96(a0)
    80001be8:	00000697          	auipc	a3,0x0
    80001bec:	13868693          	addi	a3,a3,312 # 80001d20 <usertrap>
    80001bf0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bf2:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bf4:	8692                	mv	a3,tp
    80001bf6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bfc:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c00:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c04:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c08:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c0a:	6f18                	ld	a4,24(a4)
    80001c0c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c10:	6d2c                	ld	a1,88(a0)
    80001c12:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c14:	00005717          	auipc	a4,0x5
    80001c18:	47c70713          	addi	a4,a4,1148 # 80007090 <userret>
    80001c1c:	8f11                	sub	a4,a4,a2
    80001c1e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c20:	577d                	li	a4,-1
    80001c22:	177e                	slli	a4,a4,0x3f
    80001c24:	8dd9                	or	a1,a1,a4
    80001c26:	02000537          	lui	a0,0x2000
    80001c2a:	157d                	addi	a0,a0,-1
    80001c2c:	0536                	slli	a0,a0,0xd
    80001c2e:	9782                	jalr	a5
}
    80001c30:	60a2                	ld	ra,8(sp)
    80001c32:	6402                	ld	s0,0(sp)
    80001c34:	0141                	addi	sp,sp,16
    80001c36:	8082                	ret

0000000080001c38 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c42:	0000d497          	auipc	s1,0xd
    80001c46:	56e48493          	addi	s1,s1,1390 # 8000f1b0 <tickslock>
    80001c4a:	8526                	mv	a0,s1
    80001c4c:	00005097          	auipc	ra,0x5
    80001c50:	a34080e7          	jalr	-1484(ra) # 80006680 <acquire>
  ticks++;
    80001c54:	00007517          	auipc	a0,0x7
    80001c58:	3c450513          	addi	a0,a0,964 # 80009018 <ticks>
    80001c5c:	411c                	lw	a5,0(a0)
    80001c5e:	2785                	addiw	a5,a5,1
    80001c60:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	b1c080e7          	jalr	-1252(ra) # 8000177e <wakeup>
  release(&tickslock);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	00005097          	auipc	ra,0x5
    80001c70:	ae4080e7          	jalr	-1308(ra) # 80006750 <release>
}
    80001c74:	60e2                	ld	ra,24(sp)
    80001c76:	6442                	ld	s0,16(sp)
    80001c78:	64a2                	ld	s1,8(sp)
    80001c7a:	6105                	addi	sp,sp,32
    80001c7c:	8082                	ret

0000000080001c7e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c7e:	1101                	addi	sp,sp,-32
    80001c80:	ec06                	sd	ra,24(sp)
    80001c82:	e822                	sd	s0,16(sp)
    80001c84:	e426                	sd	s1,8(sp)
    80001c86:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c88:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c8c:	00074d63          	bltz	a4,80001ca6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c90:	57fd                	li	a5,-1
    80001c92:	17fe                	slli	a5,a5,0x3f
    80001c94:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c96:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c98:	06f70363          	beq	a4,a5,80001cfe <devintr+0x80>
  }
}
    80001c9c:	60e2                	ld	ra,24(sp)
    80001c9e:	6442                	ld	s0,16(sp)
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	6105                	addi	sp,sp,32
    80001ca4:	8082                	ret
     (scause & 0xff) == 9){
    80001ca6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001caa:	46a5                	li	a3,9
    80001cac:	fed792e3          	bne	a5,a3,80001c90 <devintr+0x12>
    int irq = plic_claim();
    80001cb0:	00003097          	auipc	ra,0x3
    80001cb4:	678080e7          	jalr	1656(ra) # 80005328 <plic_claim>
    80001cb8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cba:	47a9                	li	a5,10
    80001cbc:	02f50763          	beq	a0,a5,80001cea <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cc0:	4785                	li	a5,1
    80001cc2:	02f50963          	beq	a0,a5,80001cf4 <devintr+0x76>
    return 1;
    80001cc6:	4505                	li	a0,1
    } else if(irq){
    80001cc8:	d8f1                	beqz	s1,80001c9c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cca:	85a6                	mv	a1,s1
    80001ccc:	00006517          	auipc	a0,0x6
    80001cd0:	5ac50513          	addi	a0,a0,1452 # 80008278 <states.1728+0x38>
    80001cd4:	00004097          	auipc	ra,0x4
    80001cd8:	4c2080e7          	jalr	1218(ra) # 80006196 <printf>
      plic_complete(irq);
    80001cdc:	8526                	mv	a0,s1
    80001cde:	00003097          	auipc	ra,0x3
    80001ce2:	66e080e7          	jalr	1646(ra) # 8000534c <plic_complete>
    return 1;
    80001ce6:	4505                	li	a0,1
    80001ce8:	bf55                	j	80001c9c <devintr+0x1e>
      uartintr();
    80001cea:	00005097          	auipc	ra,0x5
    80001cee:	8cc080e7          	jalr	-1844(ra) # 800065b6 <uartintr>
    80001cf2:	b7ed                	j	80001cdc <devintr+0x5e>
      virtio_disk_intr();
    80001cf4:	00004097          	auipc	ra,0x4
    80001cf8:	b38080e7          	jalr	-1224(ra) # 8000582c <virtio_disk_intr>
    80001cfc:	b7c5                	j	80001cdc <devintr+0x5e>
    if(cpuid() == 0){
    80001cfe:	fffff097          	auipc	ra,0xfffff
    80001d02:	20c080e7          	jalr	524(ra) # 80000f0a <cpuid>
    80001d06:	c901                	beqz	a0,80001d16 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d08:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d0c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d0e:	14479073          	csrw	sip,a5
    return 2;
    80001d12:	4509                	li	a0,2
    80001d14:	b761                	j	80001c9c <devintr+0x1e>
      clockintr();
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	f22080e7          	jalr	-222(ra) # 80001c38 <clockintr>
    80001d1e:	b7ed                	j	80001d08 <devintr+0x8a>

0000000080001d20 <usertrap>:
{
    80001d20:	1101                	addi	sp,sp,-32
    80001d22:	ec06                	sd	ra,24(sp)
    80001d24:	e822                	sd	s0,16(sp)
    80001d26:	e426                	sd	s1,8(sp)
    80001d28:	e04a                	sd	s2,0(sp)
    80001d2a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d30:	1007f793          	andi	a5,a5,256
    80001d34:	e3ad                	bnez	a5,80001d96 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d36:	00003797          	auipc	a5,0x3
    80001d3a:	4ea78793          	addi	a5,a5,1258 # 80005220 <kernelvec>
    80001d3e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	1f4080e7          	jalr	500(ra) # 80000f36 <myproc>
    80001d4a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d4c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4e:	14102773          	csrr	a4,sepc
    80001d52:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d54:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d58:	47a1                	li	a5,8
    80001d5a:	04f71c63          	bne	a4,a5,80001db2 <usertrap+0x92>
    if(p->killed)
    80001d5e:	591c                	lw	a5,48(a0)
    80001d60:	e3b9                	bnez	a5,80001da6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d62:	70b8                	ld	a4,96(s1)
    80001d64:	6f1c                	ld	a5,24(a4)
    80001d66:	0791                	addi	a5,a5,4
    80001d68:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d72:	10079073          	csrw	sstatus,a5
    syscall();
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	2e0080e7          	jalr	736(ra) # 80002056 <syscall>
  if(p->killed)
    80001d7e:	589c                	lw	a5,48(s1)
    80001d80:	ebc1                	bnez	a5,80001e10 <usertrap+0xf0>
  usertrapret();
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	e18080e7          	jalr	-488(ra) # 80001b9a <usertrapret>
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6902                	ld	s2,0(sp)
    80001d92:	6105                	addi	sp,sp,32
    80001d94:	8082                	ret
    panic("usertrap: not from user mode");
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	50250513          	addi	a0,a0,1282 # 80008298 <states.1728+0x58>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	3ae080e7          	jalr	942(ra) # 8000614c <panic>
      exit(-1);
    80001da6:	557d                	li	a0,-1
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	aa6080e7          	jalr	-1370(ra) # 8000184e <exit>
    80001db0:	bf4d                	j	80001d62 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	ecc080e7          	jalr	-308(ra) # 80001c7e <devintr>
    80001dba:	892a                	mv	s2,a0
    80001dbc:	c501                	beqz	a0,80001dc4 <usertrap+0xa4>
  if(p->killed)
    80001dbe:	589c                	lw	a5,48(s1)
    80001dc0:	c3a1                	beqz	a5,80001e00 <usertrap+0xe0>
    80001dc2:	a815                	j	80001df6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dc8:	5c90                	lw	a2,56(s1)
    80001dca:	00006517          	auipc	a0,0x6
    80001dce:	4ee50513          	addi	a0,a0,1262 # 800082b8 <states.1728+0x78>
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	3c4080e7          	jalr	964(ra) # 80006196 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dda:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dde:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	50650513          	addi	a0,a0,1286 # 800082e8 <states.1728+0xa8>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	3ac080e7          	jalr	940(ra) # 80006196 <printf>
    p->killed = 1;
    80001df2:	4785                	li	a5,1
    80001df4:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001df6:	557d                	li	a0,-1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	a56080e7          	jalr	-1450(ra) # 8000184e <exit>
  if(which_dev == 2)
    80001e00:	4789                	li	a5,2
    80001e02:	f8f910e3          	bne	s2,a5,80001d82 <usertrap+0x62>
    yield();
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	7b0080e7          	jalr	1968(ra) # 800015b6 <yield>
    80001e0e:	bf95                	j	80001d82 <usertrap+0x62>
  int which_dev = 0;
    80001e10:	4901                	li	s2,0
    80001e12:	b7d5                	j	80001df6 <usertrap+0xd6>

0000000080001e14 <kerneltrap>:
{
    80001e14:	7179                	addi	sp,sp,-48
    80001e16:	f406                	sd	ra,40(sp)
    80001e18:	f022                	sd	s0,32(sp)
    80001e1a:	ec26                	sd	s1,24(sp)
    80001e1c:	e84a                	sd	s2,16(sp)
    80001e1e:	e44e                	sd	s3,8(sp)
    80001e20:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e26:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e2e:	1004f793          	andi	a5,s1,256
    80001e32:	cb85                	beqz	a5,80001e62 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e38:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e3a:	ef85                	bnez	a5,80001e72 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	e42080e7          	jalr	-446(ra) # 80001c7e <devintr>
    80001e44:	cd1d                	beqz	a0,80001e82 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e46:	4789                	li	a5,2
    80001e48:	06f50a63          	beq	a0,a5,80001ebc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e4c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e50:	10049073          	csrw	sstatus,s1
}
    80001e54:	70a2                	ld	ra,40(sp)
    80001e56:	7402                	ld	s0,32(sp)
    80001e58:	64e2                	ld	s1,24(sp)
    80001e5a:	6942                	ld	s2,16(sp)
    80001e5c:	69a2                	ld	s3,8(sp)
    80001e5e:	6145                	addi	sp,sp,48
    80001e60:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	4a650513          	addi	a0,a0,1190 # 80008308 <states.1728+0xc8>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	2e2080e7          	jalr	738(ra) # 8000614c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	4be50513          	addi	a0,a0,1214 # 80008330 <states.1728+0xf0>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	2d2080e7          	jalr	722(ra) # 8000614c <panic>
    printf("scause %p\n", scause);
    80001e82:	85ce                	mv	a1,s3
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	4cc50513          	addi	a0,a0,1228 # 80008350 <states.1728+0x110>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	30a080e7          	jalr	778(ra) # 80006196 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e94:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e98:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	4c450513          	addi	a0,a0,1220 # 80008360 <states.1728+0x120>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	2f2080e7          	jalr	754(ra) # 80006196 <printf>
    panic("kerneltrap");
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	4cc50513          	addi	a0,a0,1228 # 80008378 <states.1728+0x138>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	298080e7          	jalr	664(ra) # 8000614c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	07a080e7          	jalr	122(ra) # 80000f36 <myproc>
    80001ec4:	d541                	beqz	a0,80001e4c <kerneltrap+0x38>
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	070080e7          	jalr	112(ra) # 80000f36 <myproc>
    80001ece:	5118                	lw	a4,32(a0)
    80001ed0:	4791                	li	a5,4
    80001ed2:	f6f71de3          	bne	a4,a5,80001e4c <kerneltrap+0x38>
    yield();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	6e0080e7          	jalr	1760(ra) # 800015b6 <yield>
    80001ede:	b7bd                	j	80001e4c <kerneltrap+0x38>

0000000080001ee0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	1000                	addi	s0,sp,32
    80001eea:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	04a080e7          	jalr	74(ra) # 80000f36 <myproc>
  switch (n) {
    80001ef4:	4795                	li	a5,5
    80001ef6:	0497e163          	bltu	a5,s1,80001f38 <argraw+0x58>
    80001efa:	048a                	slli	s1,s1,0x2
    80001efc:	00006717          	auipc	a4,0x6
    80001f00:	4b470713          	addi	a4,a4,1204 # 800083b0 <states.1728+0x170>
    80001f04:	94ba                	add	s1,s1,a4
    80001f06:	409c                	lw	a5,0(s1)
    80001f08:	97ba                	add	a5,a5,a4
    80001f0a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f0c:	713c                	ld	a5,96(a0)
    80001f0e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret
    return p->trapframe->a1;
    80001f1a:	713c                	ld	a5,96(a0)
    80001f1c:	7fa8                	ld	a0,120(a5)
    80001f1e:	bfcd                	j	80001f10 <argraw+0x30>
    return p->trapframe->a2;
    80001f20:	713c                	ld	a5,96(a0)
    80001f22:	63c8                	ld	a0,128(a5)
    80001f24:	b7f5                	j	80001f10 <argraw+0x30>
    return p->trapframe->a3;
    80001f26:	713c                	ld	a5,96(a0)
    80001f28:	67c8                	ld	a0,136(a5)
    80001f2a:	b7dd                	j	80001f10 <argraw+0x30>
    return p->trapframe->a4;
    80001f2c:	713c                	ld	a5,96(a0)
    80001f2e:	6bc8                	ld	a0,144(a5)
    80001f30:	b7c5                	j	80001f10 <argraw+0x30>
    return p->trapframe->a5;
    80001f32:	713c                	ld	a5,96(a0)
    80001f34:	6fc8                	ld	a0,152(a5)
    80001f36:	bfe9                	j	80001f10 <argraw+0x30>
  panic("argraw");
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	45050513          	addi	a0,a0,1104 # 80008388 <states.1728+0x148>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	20c080e7          	jalr	524(ra) # 8000614c <panic>

0000000080001f48 <fetchaddr>:
{
    80001f48:	1101                	addi	sp,sp,-32
    80001f4a:	ec06                	sd	ra,24(sp)
    80001f4c:	e822                	sd	s0,16(sp)
    80001f4e:	e426                	sd	s1,8(sp)
    80001f50:	e04a                	sd	s2,0(sp)
    80001f52:	1000                	addi	s0,sp,32
    80001f54:	84aa                	mv	s1,a0
    80001f56:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	fde080e7          	jalr	-34(ra) # 80000f36 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f60:	693c                	ld	a5,80(a0)
    80001f62:	02f4f863          	bgeu	s1,a5,80001f92 <fetchaddr+0x4a>
    80001f66:	00848713          	addi	a4,s1,8
    80001f6a:	02e7e663          	bltu	a5,a4,80001f96 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f6e:	46a1                	li	a3,8
    80001f70:	8626                	mv	a2,s1
    80001f72:	85ca                	mv	a1,s2
    80001f74:	6d28                	ld	a0,88(a0)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	d0e080e7          	jalr	-754(ra) # 80000c84 <copyin>
    80001f7e:	00a03533          	snez	a0,a0
    80001f82:	40a00533          	neg	a0,a0
}
    80001f86:	60e2                	ld	ra,24(sp)
    80001f88:	6442                	ld	s0,16(sp)
    80001f8a:	64a2                	ld	s1,8(sp)
    80001f8c:	6902                	ld	s2,0(sp)
    80001f8e:	6105                	addi	sp,sp,32
    80001f90:	8082                	ret
    return -1;
    80001f92:	557d                	li	a0,-1
    80001f94:	bfcd                	j	80001f86 <fetchaddr+0x3e>
    80001f96:	557d                	li	a0,-1
    80001f98:	b7fd                	j	80001f86 <fetchaddr+0x3e>

0000000080001f9a <fetchstr>:
{
    80001f9a:	7179                	addi	sp,sp,-48
    80001f9c:	f406                	sd	ra,40(sp)
    80001f9e:	f022                	sd	s0,32(sp)
    80001fa0:	ec26                	sd	s1,24(sp)
    80001fa2:	e84a                	sd	s2,16(sp)
    80001fa4:	e44e                	sd	s3,8(sp)
    80001fa6:	1800                	addi	s0,sp,48
    80001fa8:	892a                	mv	s2,a0
    80001faa:	84ae                	mv	s1,a1
    80001fac:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	f88080e7          	jalr	-120(ra) # 80000f36 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fb6:	86ce                	mv	a3,s3
    80001fb8:	864a                	mv	a2,s2
    80001fba:	85a6                	mv	a1,s1
    80001fbc:	6d28                	ld	a0,88(a0)
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	d52080e7          	jalr	-686(ra) # 80000d10 <copyinstr>
  if(err < 0)
    80001fc6:	00054763          	bltz	a0,80001fd4 <fetchstr+0x3a>
  return strlen(buf);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	ffffe097          	auipc	ra,0xffffe
    80001fd0:	40e080e7          	jalr	1038(ra) # 800003da <strlen>
}
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	64e2                	ld	s1,24(sp)
    80001fda:	6942                	ld	s2,16(sp)
    80001fdc:	69a2                	ld	s3,8(sp)
    80001fde:	6145                	addi	sp,sp,48
    80001fe0:	8082                	ret

0000000080001fe2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fe2:	1101                	addi	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	1000                	addi	s0,sp,32
    80001fec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	ef2080e7          	jalr	-270(ra) # 80001ee0 <argraw>
    80001ff6:	c088                	sw	a0,0(s1)
  return 0;
}
    80001ff8:	4501                	li	a0,0
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002010:	00000097          	auipc	ra,0x0
    80002014:	ed0080e7          	jalr	-304(ra) # 80001ee0 <argraw>
    80002018:	e088                	sd	a0,0(s1)
  return 0;
}
    8000201a:	4501                	li	a0,0
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6105                	addi	sp,sp,32
    80002024:	8082                	ret

0000000080002026 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002026:	1101                	addi	sp,sp,-32
    80002028:	ec06                	sd	ra,24(sp)
    8000202a:	e822                	sd	s0,16(sp)
    8000202c:	e426                	sd	s1,8(sp)
    8000202e:	e04a                	sd	s2,0(sp)
    80002030:	1000                	addi	s0,sp,32
    80002032:	84ae                	mv	s1,a1
    80002034:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	eaa080e7          	jalr	-342(ra) # 80001ee0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000203e:	864a                	mv	a2,s2
    80002040:	85a6                	mv	a1,s1
    80002042:	00000097          	auipc	ra,0x0
    80002046:	f58080e7          	jalr	-168(ra) # 80001f9a <fetchstr>
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6902                	ld	s2,0(sp)
    80002052:	6105                	addi	sp,sp,32
    80002054:	8082                	ret

0000000080002056 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002056:	1101                	addi	sp,sp,-32
    80002058:	ec06                	sd	ra,24(sp)
    8000205a:	e822                	sd	s0,16(sp)
    8000205c:	e426                	sd	s1,8(sp)
    8000205e:	e04a                	sd	s2,0(sp)
    80002060:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	ed4080e7          	jalr	-300(ra) # 80000f36 <myproc>
    8000206a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000206c:	06053903          	ld	s2,96(a0)
    80002070:	0a893783          	ld	a5,168(s2)
    80002074:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002078:	37fd                	addiw	a5,a5,-1
    8000207a:	4751                	li	a4,20
    8000207c:	00f76f63          	bltu	a4,a5,8000209a <syscall+0x44>
    80002080:	00369713          	slli	a4,a3,0x3
    80002084:	00006797          	auipc	a5,0x6
    80002088:	34478793          	addi	a5,a5,836 # 800083c8 <syscalls>
    8000208c:	97ba                	add	a5,a5,a4
    8000208e:	639c                	ld	a5,0(a5)
    80002090:	c789                	beqz	a5,8000209a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002092:	9782                	jalr	a5
    80002094:	06a93823          	sd	a0,112(s2)
    80002098:	a839                	j	800020b6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000209a:	16048613          	addi	a2,s1,352
    8000209e:	5c8c                	lw	a1,56(s1)
    800020a0:	00006517          	auipc	a0,0x6
    800020a4:	2f050513          	addi	a0,a0,752 # 80008390 <states.1728+0x150>
    800020a8:	00004097          	auipc	ra,0x4
    800020ac:	0ee080e7          	jalr	238(ra) # 80006196 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020b0:	70bc                	ld	a5,96(s1)
    800020b2:	577d                	li	a4,-1
    800020b4:	fbb8                	sd	a4,112(a5)
  }
}
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6902                	ld	s2,0(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret

00000000800020c2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020ca:	fec40593          	addi	a1,s0,-20
    800020ce:	4501                	li	a0,0
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	f12080e7          	jalr	-238(ra) # 80001fe2 <argint>
    return -1;
    800020d8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020da:	00054963          	bltz	a0,800020ec <sys_exit+0x2a>
  exit(n);
    800020de:	fec42503          	lw	a0,-20(s0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	76c080e7          	jalr	1900(ra) # 8000184e <exit>
  return 0;  // not reached
    800020ea:	4781                	li	a5,0
}
    800020ec:	853e                	mv	a0,a5
    800020ee:	60e2                	ld	ra,24(sp)
    800020f0:	6442                	ld	s0,16(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020f6:	1141                	addi	sp,sp,-16
    800020f8:	e406                	sd	ra,8(sp)
    800020fa:	e022                	sd	s0,0(sp)
    800020fc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	e38080e7          	jalr	-456(ra) # 80000f36 <myproc>
}
    80002106:	5d08                	lw	a0,56(a0)
    80002108:	60a2                	ld	ra,8(sp)
    8000210a:	6402                	ld	s0,0(sp)
    8000210c:	0141                	addi	sp,sp,16
    8000210e:	8082                	ret

0000000080002110 <sys_fork>:

uint64
sys_fork(void)
{
    80002110:	1141                	addi	sp,sp,-16
    80002112:	e406                	sd	ra,8(sp)
    80002114:	e022                	sd	s0,0(sp)
    80002116:	0800                	addi	s0,sp,16
  return fork();
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	1ec080e7          	jalr	492(ra) # 80001304 <fork>
}
    80002120:	60a2                	ld	ra,8(sp)
    80002122:	6402                	ld	s0,0(sp)
    80002124:	0141                	addi	sp,sp,16
    80002126:	8082                	ret

0000000080002128 <sys_wait>:

uint64
sys_wait(void)
{
    80002128:	1101                	addi	sp,sp,-32
    8000212a:	ec06                	sd	ra,24(sp)
    8000212c:	e822                	sd	s0,16(sp)
    8000212e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002130:	fe840593          	addi	a1,s0,-24
    80002134:	4501                	li	a0,0
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	ece080e7          	jalr	-306(ra) # 80002004 <argaddr>
    8000213e:	87aa                	mv	a5,a0
    return -1;
    80002140:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002142:	0007c863          	bltz	a5,80002152 <sys_wait+0x2a>
  return wait(p);
    80002146:	fe843503          	ld	a0,-24(s0)
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	50c080e7          	jalr	1292(ra) # 80001656 <wait>
}
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret

000000008000215a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000215a:	7179                	addi	sp,sp,-48
    8000215c:	f406                	sd	ra,40(sp)
    8000215e:	f022                	sd	s0,32(sp)
    80002160:	ec26                	sd	s1,24(sp)
    80002162:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002164:	fdc40593          	addi	a1,s0,-36
    80002168:	4501                	li	a0,0
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	e78080e7          	jalr	-392(ra) # 80001fe2 <argint>
    80002172:	87aa                	mv	a5,a0
    return -1;
    80002174:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002176:	0207c063          	bltz	a5,80002196 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	dbc080e7          	jalr	-580(ra) # 80000f36 <myproc>
    80002182:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002184:	fdc42503          	lw	a0,-36(s0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	108080e7          	jalr	264(ra) # 80001290 <growproc>
    80002190:	00054863          	bltz	a0,800021a0 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002194:	8526                	mv	a0,s1
}
    80002196:	70a2                	ld	ra,40(sp)
    80002198:	7402                	ld	s0,32(sp)
    8000219a:	64e2                	ld	s1,24(sp)
    8000219c:	6145                	addi	sp,sp,48
    8000219e:	8082                	ret
    return -1;
    800021a0:	557d                	li	a0,-1
    800021a2:	bfd5                	j	80002196 <sys_sbrk+0x3c>

00000000800021a4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021a4:	7139                	addi	sp,sp,-64
    800021a6:	fc06                	sd	ra,56(sp)
    800021a8:	f822                	sd	s0,48(sp)
    800021aa:	f426                	sd	s1,40(sp)
    800021ac:	f04a                	sd	s2,32(sp)
    800021ae:	ec4e                	sd	s3,24(sp)
    800021b0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021b2:	fcc40593          	addi	a1,s0,-52
    800021b6:	4501                	li	a0,0
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	e2a080e7          	jalr	-470(ra) # 80001fe2 <argint>
    return -1;
    800021c0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021c2:	06054563          	bltz	a0,8000222c <sys_sleep+0x88>
  acquire(&tickslock);
    800021c6:	0000d517          	auipc	a0,0xd
    800021ca:	fea50513          	addi	a0,a0,-22 # 8000f1b0 <tickslock>
    800021ce:	00004097          	auipc	ra,0x4
    800021d2:	4b2080e7          	jalr	1202(ra) # 80006680 <acquire>
  ticks0 = ticks;
    800021d6:	00007917          	auipc	s2,0x7
    800021da:	e4292903          	lw	s2,-446(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021de:	fcc42783          	lw	a5,-52(s0)
    800021e2:	cf85                	beqz	a5,8000221a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e4:	0000d997          	auipc	s3,0xd
    800021e8:	fcc98993          	addi	s3,s3,-52 # 8000f1b0 <tickslock>
    800021ec:	00007497          	auipc	s1,0x7
    800021f0:	e2c48493          	addi	s1,s1,-468 # 80009018 <ticks>
    if(myproc()->killed){
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	d42080e7          	jalr	-702(ra) # 80000f36 <myproc>
    800021fc:	591c                	lw	a5,48(a0)
    800021fe:	ef9d                	bnez	a5,8000223c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002200:	85ce                	mv	a1,s3
    80002202:	8526                	mv	a0,s1
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	3ee080e7          	jalr	1006(ra) # 800015f2 <sleep>
  while(ticks - ticks0 < n){
    8000220c:	409c                	lw	a5,0(s1)
    8000220e:	412787bb          	subw	a5,a5,s2
    80002212:	fcc42703          	lw	a4,-52(s0)
    80002216:	fce7efe3          	bltu	a5,a4,800021f4 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000221a:	0000d517          	auipc	a0,0xd
    8000221e:	f9650513          	addi	a0,a0,-106 # 8000f1b0 <tickslock>
    80002222:	00004097          	auipc	ra,0x4
    80002226:	52e080e7          	jalr	1326(ra) # 80006750 <release>
  return 0;
    8000222a:	4781                	li	a5,0
}
    8000222c:	853e                	mv	a0,a5
    8000222e:	70e2                	ld	ra,56(sp)
    80002230:	7442                	ld	s0,48(sp)
    80002232:	74a2                	ld	s1,40(sp)
    80002234:	7902                	ld	s2,32(sp)
    80002236:	69e2                	ld	s3,24(sp)
    80002238:	6121                	addi	sp,sp,64
    8000223a:	8082                	ret
      release(&tickslock);
    8000223c:	0000d517          	auipc	a0,0xd
    80002240:	f7450513          	addi	a0,a0,-140 # 8000f1b0 <tickslock>
    80002244:	00004097          	auipc	ra,0x4
    80002248:	50c080e7          	jalr	1292(ra) # 80006750 <release>
      return -1;
    8000224c:	57fd                	li	a5,-1
    8000224e:	bff9                	j	8000222c <sys_sleep+0x88>

0000000080002250 <sys_kill>:

uint64
sys_kill(void)
{
    80002250:	1101                	addi	sp,sp,-32
    80002252:	ec06                	sd	ra,24(sp)
    80002254:	e822                	sd	s0,16(sp)
    80002256:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002258:	fec40593          	addi	a1,s0,-20
    8000225c:	4501                	li	a0,0
    8000225e:	00000097          	auipc	ra,0x0
    80002262:	d84080e7          	jalr	-636(ra) # 80001fe2 <argint>
    80002266:	87aa                	mv	a5,a0
    return -1;
    80002268:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000226a:	0007c863          	bltz	a5,8000227a <sys_kill+0x2a>
  return kill(pid);
    8000226e:	fec42503          	lw	a0,-20(s0)
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	6b2080e7          	jalr	1714(ra) # 80001924 <kill>
}
    8000227a:	60e2                	ld	ra,24(sp)
    8000227c:	6442                	ld	s0,16(sp)
    8000227e:	6105                	addi	sp,sp,32
    80002280:	8082                	ret

0000000080002282 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002282:	1101                	addi	sp,sp,-32
    80002284:	ec06                	sd	ra,24(sp)
    80002286:	e822                	sd	s0,16(sp)
    80002288:	e426                	sd	s1,8(sp)
    8000228a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000228c:	0000d517          	auipc	a0,0xd
    80002290:	f2450513          	addi	a0,a0,-220 # 8000f1b0 <tickslock>
    80002294:	00004097          	auipc	ra,0x4
    80002298:	3ec080e7          	jalr	1004(ra) # 80006680 <acquire>
  xticks = ticks;
    8000229c:	00007497          	auipc	s1,0x7
    800022a0:	d7c4a483          	lw	s1,-644(s1) # 80009018 <ticks>
  release(&tickslock);
    800022a4:	0000d517          	auipc	a0,0xd
    800022a8:	f0c50513          	addi	a0,a0,-244 # 8000f1b0 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	4a4080e7          	jalr	1188(ra) # 80006750 <release>
  return xticks;
}
    800022b4:	02049513          	slli	a0,s1,0x20
    800022b8:	9101                	srli	a0,a0,0x20
    800022ba:	60e2                	ld	ra,24(sp)
    800022bc:	6442                	ld	s0,16(sp)
    800022be:	64a2                	ld	s1,8(sp)
    800022c0:	6105                	addi	sp,sp,32
    800022c2:	8082                	ret

00000000800022c4 <binit>:
struct buf head[NBUCKET];
} bcache;

void
binit(void)
{
    800022c4:	7179                	addi	sp,sp,-48
    800022c6:	f406                	sd	ra,40(sp)
    800022c8:	f022                	sd	s0,32(sp)
    800022ca:	ec26                	sd	s1,24(sp)
    800022cc:	e84a                	sd	s2,16(sp)
    800022ce:	e44e                	sd	s3,8(sp)
    800022d0:	1800                	addi	s0,sp,48
  struct buf *b;
for (int i = 0; i < NBUCKET; i++)
    800022d2:	0000d497          	auipc	s1,0xd
    800022d6:	efe48493          	addi	s1,s1,-258 # 8000f1d0 <bcache>
    800022da:	0000d997          	auipc	s3,0xd
    800022de:	09698993          	addi	s3,s3,150 # 8000f370 <bcache+0x1a0>
{
  initlock(&bcache.lock[i], "bcache");
    800022e2:	00006917          	auipc	s2,0x6
    800022e6:	19690913          	addi	s2,s2,406 # 80008478 <syscalls+0xb0>
    800022ea:	85ca                	mv	a1,s2
    800022ec:	8526                	mv	a0,s1
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	50e080e7          	jalr	1294(ra) # 800067fc <initlock>
for (int i = 0; i < NBUCKET; i++)
    800022f6:	02048493          	addi	s1,s1,32
    800022fa:	ff3498e3          	bne	s1,s3,800022ea <binit+0x26>
}
bcache.head[0].next = &bcache.buf[0];
    800022fe:	0000d497          	auipc	s1,0xd
    80002302:	07248493          	addi	s1,s1,114 # 8000f370 <bcache+0x1a0>
    80002306:	00015797          	auipc	a5,0x15
    8000230a:	4e97b923          	sd	s1,1266(a5) # 800177f8 <bcache+0x8628>
for (b=bcache.buf;b<bcache.buf+NBUF-1;b++)
{
  b->next = b+1;
  initsleeplock(&b->lock, "buffer");
    8000230e:	00006997          	auipc	s3,0x6
    80002312:	17298993          	addi	s3,s3,370 # 80008480 <syscalls+0xb8>
for (b=bcache.buf;b<bcache.buf+NBUF-1;b++)
    80002316:	00015917          	auipc	s2,0x15
    8000231a:	02290913          	addi	s2,s2,34 # 80017338 <bcache+0x8168>
  b->next = b+1;
    8000231e:	46848493          	addi	s1,s1,1128
    80002322:	be94b823          	sd	s1,-1040(s1)
  initsleeplock(&b->lock, "buffer");
    80002326:	85ce                	mv	a1,s3
    80002328:	ba848513          	addi	a0,s1,-1112
    8000232c:	00001097          	auipc	ra,0x1
    80002330:	6c6080e7          	jalr	1734(ra) # 800039f2 <initsleeplock>
for (b=bcache.buf;b<bcache.buf+NBUF-1;b++)
    80002334:	ff2495e3          	bne	s1,s2,8000231e <binit+0x5a>
  }
  initsleeplock(&b->lock,"buffer");
    80002338:	00006597          	auipc	a1,0x6
    8000233c:	14858593          	addi	a1,a1,328 # 80008480 <syscalls+0xb8>
    80002340:	00015517          	auipc	a0,0x15
    80002344:	00850513          	addi	a0,a0,8 # 80017348 <bcache+0x8178>
    80002348:	00001097          	auipc	ra,0x1
    8000234c:	6aa080e7          	jalr	1706(ra) # 800039f2 <initsleeplock>
}
    80002350:	70a2                	ld	ra,40(sp)
    80002352:	7402                	ld	s0,32(sp)
    80002354:	64e2                	ld	s1,24(sp)
    80002356:	6942                	ld	s2,16(sp)
    80002358:	69a2                	ld	s3,8(sp)
    8000235a:	6145                	addi	sp,sp,48
    8000235c:	8082                	ret

000000008000235e <can_lock>:

int can_lock(int cur_idx, int req_idx)
{
    8000235e:	1141                	addi	sp,sp,-16
    80002360:	e422                	sd	s0,8(sp)
    80002362:	0800                	addi	s0,sp,16
int mid = NBUCKET / 2;
// non-reentrant
if (cur_idx == req_idx)
    80002364:	00b50e63          	beq	a0,a1,80002380 <can_lock+0x22>
{
  return 0;
}
else if (cur_idx < req_idx)
    80002368:	00b55863          	bge	a0,a1,80002378 <can_lock+0x1a>
{
  if (req_idx <= (cur_idx + mid))
    8000236c:	2519                	addiw	a0,a0,6
  return 0;
    8000236e:	00b52533          	slt	a0,a0,a1
  {
    return 0;
  }
}
return 1;
}
    80002372:	6422                	ld	s0,8(sp)
    80002374:	0141                	addi	sp,sp,16
    80002376:	8082                	ret
  if (cur_idx >= (req_idx + mid))
    80002378:	2599                	addiw	a1,a1,6
  return 0;
    8000237a:	00b52533          	slt	a0,a0,a1
    8000237e:	bfd5                	j	80002372 <can_lock+0x14>
    80002380:	4501                	li	a0,0
    80002382:	bfc5                	j	80002372 <can_lock+0x14>

0000000080002384 <write_cache>:

void
write_cache(struct buf *take_buf, uint dev, uint blockno)
{
    80002384:	1141                	addi	sp,sp,-16
    80002386:	e422                	sd	s0,8(sp)
    80002388:	0800                	addi	s0,sp,16
  take_buf->dev = dev;
    8000238a:	c50c                	sw	a1,8(a0)
  take_buf->blockno = blockno;
    8000238c:	c550                	sw	a2,12(a0)
  take_buf->valid = 0;
    8000238e:	00052023          	sw	zero,0(a0)
  take_buf->refcnt = 1;
    80002392:	4785                	li	a5,1
    80002394:	c53c                	sw	a5,72(a0)
  take_buf->time = ticks;
    80002396:	00007797          	auipc	a5,0x7
    8000239a:	c827a783          	lw	a5,-894(a5) # 80009018 <ticks>
    8000239e:	46f52023          	sw	a5,1120(a0)
}
    800023a2:	6422                	ld	s0,8(sp)
    800023a4:	0141                	addi	sp,sp,16
    800023a6:	8082                	ret

00000000800023a8 <brelse>:
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    800023a8:	1101                	addi	sp,sp,-32
    800023aa:	ec06                	sd	ra,24(sp)
    800023ac:	e822                	sd	s0,16(sp)
    800023ae:	e426                	sd	s1,8(sp)
    800023b0:	e04a                	sd	s2,0(sp)
    800023b2:	1000                	addi	s0,sp,32
    800023b4:	892a                	mv	s2,a0
  if (!holdingsleep(&b->lock))
    800023b6:	01050493          	addi	s1,a0,16
    800023ba:	8526                	mv	a0,s1
    800023bc:	00001097          	auipc	ra,0x1
    800023c0:	70a080e7          	jalr	1802(ra) # 80003ac6 <holdingsleep>
    800023c4:	c531                	beqz	a0,80002410 <brelse+0x68>
    panic("brelse");
  releasesleep(&b->lock);
    800023c6:	8526                	mv	a0,s1
    800023c8:	00001097          	auipc	ra,0x1
    800023cc:	6ba080e7          	jalr	1722(ra) # 80003a82 <releasesleep>
  int h=HASH(b->blockno);
    800023d0:	00c92483          	lw	s1,12(s2)
  acquire(&bcache.lock[h]);
    800023d4:	47b5                	li	a5,13
    800023d6:	02f4f4bb          	remuw	s1,s1,a5
    800023da:	0496                	slli	s1,s1,0x5
    800023dc:	0000d797          	auipc	a5,0xd
    800023e0:	df478793          	addi	a5,a5,-524 # 8000f1d0 <bcache>
    800023e4:	94be                	add	s1,s1,a5
    800023e6:	8526                	mv	a0,s1
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	298080e7          	jalr	664(ra) # 80006680 <acquire>
  b->refcnt--;
    800023f0:	04892783          	lw	a5,72(s2)
    800023f4:	37fd                	addiw	a5,a5,-1
    800023f6:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[h]);
    800023fa:	8526                	mv	a0,s1
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	354080e7          	jalr	852(ra) # 80006750 <release>
}
    80002404:	60e2                	ld	ra,24(sp)
    80002406:	6442                	ld	s0,16(sp)
    80002408:	64a2                	ld	s1,8(sp)
    8000240a:	6902                	ld	s2,0(sp)
    8000240c:	6105                	addi	sp,sp,32
    8000240e:	8082                	ret
    panic("brelse");
    80002410:	00006517          	auipc	a0,0x6
    80002414:	07850513          	addi	a0,a0,120 # 80008488 <syscalls+0xc0>
    80002418:	00004097          	auipc	ra,0x4
    8000241c:	d34080e7          	jalr	-716(ra) # 8000614c <panic>

0000000080002420 <bpin>:

void bpin(struct buf *b)
{
    80002420:	7179                	addi	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	e84a                	sd	s2,16(sp)
    8000242a:	e44e                	sd	s3,8(sp)
    8000242c:	1800                	addi	s0,sp,48
    8000242e:	84aa                	mv	s1,a0
  acquire(&bcache.lock[HASH(b->blockno)]);
    80002430:	455c                	lw	a5,12(a0)
    80002432:	49b5                	li	s3,13
    80002434:	0337f7bb          	remuw	a5,a5,s3
    80002438:	1782                	slli	a5,a5,0x20
    8000243a:	9381                	srli	a5,a5,0x20
    8000243c:	0796                	slli	a5,a5,0x5
    8000243e:	0000d917          	auipc	s2,0xd
    80002442:	d9290913          	addi	s2,s2,-622 # 8000f1d0 <bcache>
    80002446:	00f90533          	add	a0,s2,a5
    8000244a:	00004097          	auipc	ra,0x4
    8000244e:	236080e7          	jalr	566(ra) # 80006680 <acquire>
  b->refcnt++;
    80002452:	44bc                	lw	a5,72(s1)
    80002454:	2785                	addiw	a5,a5,1
    80002456:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock[HASH(b->blockno)]);
    80002458:	44c8                	lw	a0,12(s1)
    8000245a:	0335753b          	remuw	a0,a0,s3
    8000245e:	1502                	slli	a0,a0,0x20
    80002460:	9101                	srli	a0,a0,0x20
    80002462:	0516                	slli	a0,a0,0x5
    80002464:	954a                	add	a0,a0,s2
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	2ea080e7          	jalr	746(ra) # 80006750 <release>
}
    8000246e:	70a2                	ld	ra,40(sp)
    80002470:	7402                	ld	s0,32(sp)
    80002472:	64e2                	ld	s1,24(sp)
    80002474:	6942                	ld	s2,16(sp)
    80002476:	69a2                	ld	s3,8(sp)
    80002478:	6145                	addi	sp,sp,48
    8000247a:	8082                	ret

000000008000247c <bunpin>:

void bunpin(struct buf *b)
{
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	1800                	addi	s0,sp,48
    8000248a:	84aa                	mv	s1,a0
  acquire(&bcache.lock[HASH(b->blockno)]);
    8000248c:	455c                	lw	a5,12(a0)
    8000248e:	49b5                	li	s3,13
    80002490:	0337f7bb          	remuw	a5,a5,s3
    80002494:	1782                	slli	a5,a5,0x20
    80002496:	9381                	srli	a5,a5,0x20
    80002498:	0796                	slli	a5,a5,0x5
    8000249a:	0000d917          	auipc	s2,0xd
    8000249e:	d3690913          	addi	s2,s2,-714 # 8000f1d0 <bcache>
    800024a2:	00f90533          	add	a0,s2,a5
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	1da080e7          	jalr	474(ra) # 80006680 <acquire>
  b->refcnt--;
    800024ae:	44bc                	lw	a5,72(s1)
    800024b0:	37fd                	addiw	a5,a5,-1
    800024b2:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock[HASH(b->blockno)]);
    800024b4:	44c8                	lw	a0,12(s1)
    800024b6:	0335753b          	remuw	a0,a0,s3
    800024ba:	1502                	slli	a0,a0,0x20
    800024bc:	9101                	srli	a0,a0,0x20
    800024be:	0516                	slli	a0,a0,0x5
    800024c0:	954a                	add	a0,a0,s2
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	28e080e7          	jalr	654(ra) # 80006750 <release>
}
    800024ca:	70a2                	ld	ra,40(sp)
    800024cc:	7402                	ld	s0,32(sp)
    800024ce:	64e2                	ld	s1,24(sp)
    800024d0:	6942                	ld	s2,16(sp)
    800024d2:	69a2                	ld	s3,8(sp)
    800024d4:	6145                	addi	sp,sp,48
    800024d6:	8082                	ret

00000000800024d8 <bread>:

struct buf*
bread(uint dev, uint blockno)
{
    800024d8:	7135                	addi	sp,sp,-160
    800024da:	ed06                	sd	ra,152(sp)
    800024dc:	e922                	sd	s0,144(sp)
    800024de:	e526                	sd	s1,136(sp)
    800024e0:	e14a                	sd	s2,128(sp)
    800024e2:	fcce                	sd	s3,120(sp)
    800024e4:	f8d2                	sd	s4,112(sp)
    800024e6:	f4d6                	sd	s5,104(sp)
    800024e8:	f0da                	sd	s6,96(sp)
    800024ea:	ecde                	sd	s7,88(sp)
    800024ec:	e8e2                	sd	s8,80(sp)
    800024ee:	e4e6                	sd	s9,72(sp)
    800024f0:	e0ea                	sd	s10,64(sp)
    800024f2:	fc6e                	sd	s11,56(sp)
    800024f4:	1100                	addi	s0,sp,160
    800024f6:	f6a43823          	sd	a0,-144(s0)
    800024fa:	8c2e                	mv	s8,a1
int id = HASH(blockno);
    800024fc:	4bb5                	li	s7,13
    800024fe:	0375fbbb          	remuw	s7,a1,s7
acquire(&bcache.lock[id]);
    80002502:	005b9c93          	slli	s9,s7,0x5
    80002506:	0000d497          	auipc	s1,0xd
    8000250a:	cca48493          	addi	s1,s1,-822 # 8000f1d0 <bcache>
    8000250e:	009c87b3          	add	a5,s9,s1
    80002512:	f6f43023          	sd	a5,-160(s0)
    80002516:	853e                	mv	a0,a5
    80002518:	00004097          	auipc	ra,0x4
    8000251c:	168080e7          	jalr	360(ra) # 80006680 <acquire>
b = bcache.head[id].next;
    80002520:	46800793          	li	a5,1128
    80002524:	02fb87b3          	mul	a5,s7,a5
    80002528:	00f486b3          	add	a3,s1,a5
    8000252c:	6721                	lui	a4,0x8
    8000252e:	96ba                	add	a3,a3,a4
    80002530:	6286b903          	ld	s2,1576(a3)
last=&(bcache.head[id]);
    80002534:	5d070a13          	addi	s4,a4,1488 # 85d0 <_entry-0x7fff7a30>
    80002538:	97d2                	add	a5,a5,s4
    8000253a:	00978a33          	add	s4,a5,s1
for(;b;b=b->next,last=last->next)
    8000253e:	06090363          	beqz	s2,800025a4 <bread+0xcc>
struct buf *take_buf=0;
    80002542:	4481                	li	s1,0
    80002544:	a0a1                	j	8000258c <bread+0xb4>
  if (b->dev == dev && b->blockno == blockno)
    80002546:	00c92783          	lw	a5,12(s2)
    8000254a:	05879763          	bne	a5,s8,80002598 <bread+0xc0>
    b->time=ticks;
    8000254e:	00007797          	auipc	a5,0x7
    80002552:	aca7a783          	lw	a5,-1334(a5) # 80009018 <ticks>
    80002556:	46f92023          	sw	a5,1120(s2)
    b->refcnt++;
    8000255a:	04892783          	lw	a5,72(s2)
    8000255e:	2785                	addiw	a5,a5,1
    80002560:	04f92423          	sw	a5,72(s2)
    release(&bcache.lock[id]);
    80002564:	f6043503          	ld	a0,-160(s0)
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	1e8080e7          	jalr	488(ra) # 80006750 <release>
    acquiresleep(&b->lock);
    80002570:	01090513          	addi	a0,s2,16
    80002574:	00001097          	auipc	ra,0x1
    80002578:	4b8080e7          	jalr	1208(ra) # 80003a2c <acquiresleep>
    return b;
    8000257c:	84ca                	mv	s1,s2
    8000257e:	a255                	j	80002722 <bread+0x24a>
for(;b;b=b->next,last=last->next)
    80002580:	05893903          	ld	s2,88(s2)
    80002584:	058a3a03          	ld	s4,88(s4)
    80002588:	00090d63          	beqz	s2,800025a2 <bread+0xca>
  if (b->dev == dev && b->blockno == blockno)
    8000258c:	00892783          	lw	a5,8(s2)
    80002590:	f7043703          	ld	a4,-144(s0)
    80002594:	fae789e3          	beq	a5,a4,80002546 <bread+0x6e>
  if(b->refcnt==0)
    80002598:	04892783          	lw	a5,72(s2)
    8000259c:	f3f5                	bnez	a5,80002580 <bread+0xa8>
    8000259e:	84ca                	mv	s1,s2
    800025a0:	b7c5                	j	80002580 <bread+0xa8>
if(take_buf)
    800025a2:	e095                	bnez	s1,800025c6 <bread+0xee>
for (int i = 0; i < NBUCKET; ++i)
    800025a4:	0000dd97          	auipc	s11,0xd
    800025a8:	c2cd8d93          	addi	s11,s11,-980 # 8000f1d0 <bcache>
    800025ac:	00015d17          	auipc	s10,0x15
    800025b0:	1f4d0d13          	addi	s10,s10,500 # 800177a0 <bcache+0x85d0>
uint64 time =__UINT64_MAX__;
    800025b4:	57fd                	li	a5,-1
    800025b6:	f8f43023          	sd	a5,-128(s0)
int lock_num = -1;
    800025ba:	597d                	li	s2,-1
struct buf *last_take=0;
    800025bc:	f8043423          	sd	zero,-120(s0)
    800025c0:	4481                	li	s1,0
for (int i = 0; i < NBUCKET; ++i)
    800025c2:	4a81                	li	s5,0
    800025c4:	a8c9                	j	80002696 <bread+0x1be>
  take_buf->dev = dev;
    800025c6:	f7043783          	ld	a5,-144(s0)
    800025ca:	c49c                	sw	a5,8(s1)
  take_buf->blockno = blockno;
    800025cc:	0184a623          	sw	s8,12(s1)
  take_buf->valid = 0;
    800025d0:	0004a023          	sw	zero,0(s1)
  take_buf->refcnt = 1;
    800025d4:	4785                	li	a5,1
    800025d6:	c4bc                	sw	a5,72(s1)
  take_buf->time = ticks;
    800025d8:	00007797          	auipc	a5,0x7
    800025dc:	a407a783          	lw	a5,-1472(a5) # 80009018 <ticks>
    800025e0:	46f4a023          	sw	a5,1120(s1)
  release(&bcache.lock[id]);
    800025e4:	f6043503          	ld	a0,-160(s0)
    800025e8:	00004097          	auipc	ra,0x4
    800025ec:	168080e7          	jalr	360(ra) # 80006750 <release>
  acquiresleep(&(take_buf->lock));
    800025f0:	01048513          	addi	a0,s1,16
    800025f4:	00001097          	auipc	ra,0x1
    800025f8:	438080e7          	jalr	1080(ra) # 80003a2c <acquiresleep>
  return take_buf;
    800025fc:	a21d                	j	80002722 <bread+0x24a>
        &&holding(&(bcache.lock[lock_num])))
    800025fe:	0916                	slli	s2,s2,0x5
    80002600:	0000d797          	auipc	a5,0xd
    80002604:	bd078793          	addi	a5,a5,-1072 # 8000f1d0 <bcache>
    80002608:	993e                	add	s2,s2,a5
    8000260a:	854a                	mv	a0,s2
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	ffa080e7          	jalr	-6(ra) # 80006606 <holding>
    80002614:	e519                	bnez	a0,80002622 <bread+0x14a>
    80002616:	f9643423          	sd	s6,-120(s0)
    8000261a:	f7843903          	ld	s2,-136(s0)
    8000261e:	84ce                	mv	s1,s3
    80002620:	a831                	j	8000263c <bread+0x164>
        release(&(bcache.lock[lock_num]));
    80002622:	854a                	mv	a0,s2
    80002624:	00004097          	auipc	ra,0x4
    80002628:	12c080e7          	jalr	300(ra) # 80006750 <release>
    8000262c:	f9643423          	sd	s6,-120(s0)
    80002630:	f7843903          	ld	s2,-136(s0)
    80002634:	84ce                	mv	s1,s3
    80002636:	a019                	j	8000263c <bread+0x164>
    80002638:	f8043c83          	ld	s9,-128(s0)
b;b=b->next,tmp=tmp->next)
    8000263c:	0589b983          	ld	s3,88(s3)
    80002640:	058b3b03          	ld	s6,88(s6)
  for(b=bcache.head[i].next,tmp=&(bcache.head[i]);
    80002644:	02098d63          	beqz	s3,8000267e <bread+0x1a6>
    80002648:	f9943023          	sd	s9,-128(s0)
    if(b->refcnt==0)
    8000264c:	0489a783          	lw	a5,72(s3)
    80002650:	f8043703          	ld	a4,-128(s0)
    80002654:	8cba                	mv	s9,a4
    80002656:	f3fd                	bnez	a5,8000263c <bread+0x164>
      if(b->time<time)
    80002658:	4609ec83          	lwu	s9,1120(s3)
    8000265c:	fcecfee3          	bgeu	s9,a4,80002638 <bread+0x160>
        if(lock_num!=-1&&lock_num!=i
    80002660:	57fd                	li	a5,-1
    80002662:	00f90863          	beq	s2,a5,80002672 <bread+0x19a>
    80002666:	f92a9ce3          	bne	s5,s2,800025fe <bread+0x126>
    8000266a:	f9643423          	sd	s6,-120(s0)
    8000266e:	84ce                	mv	s1,s3
    80002670:	b7f1                	j	8000263c <bread+0x164>
    80002672:	f9643423          	sd	s6,-120(s0)
    80002676:	f7843903          	ld	s2,-136(s0)
    8000267a:	84ce                	mv	s1,s3
    8000267c:	b7c1                	j	8000263c <bread+0x164>
    8000267e:	f9943023          	sd	s9,-128(s0)
  if(lock_num!=i)
    80002682:	032a9b63          	bne	s5,s2,800026b8 <bread+0x1e0>
for (int i = 0; i < NBUCKET; ++i)
    80002686:	2a85                	addiw	s5,s5,1
    80002688:	020d8d93          	addi	s11,s11,32
    8000268c:	468d0d13          	addi	s10,s10,1128
    80002690:	47b5                	li	a5,13
    80002692:	02fa8a63          	beq	s5,a5,800026c6 <bread+0x1ee>
  if(i==id)
    80002696:	ff5b88e3          	beq	s7,s5,80002686 <bread+0x1ae>
  acquire(&bcache.lock[i]);
    8000269a:	f7b43423          	sd	s11,-152(s0)
    8000269e:	856e                	mv	a0,s11
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	fe0080e7          	jalr	-32(ra) # 80006680 <acquire>
  for(b=bcache.head[i].next,tmp=&(bcache.head[i]);
    800026a8:	8b6a                	mv	s6,s10
    800026aa:	058d3983          	ld	s3,88(s10)
    800026ae:	fc098ae3          	beqz	s3,80002682 <bread+0x1aa>
    800026b2:	f7543c23          	sd	s5,-136(s0)
    800026b6:	bf59                	j	8000264c <bread+0x174>
    release(&(bcache.lock[i]));
    800026b8:	f6843503          	ld	a0,-152(s0)
    800026bc:	00004097          	auipc	ra,0x4
    800026c0:	094080e7          	jalr	148(ra) # 80006750 <release>
    800026c4:	b7c9                	j	80002686 <bread+0x1ae>
if (!take_buf)
    800026c6:	c0c1                	beqz	s1,80002746 <bread+0x26e>
last_take->next=take_buf->next;
    800026c8:	6cbc                	ld	a5,88(s1)
    800026ca:	f8843703          	ld	a4,-120(s0)
    800026ce:	ef3c                	sd	a5,88(a4)
take_buf->next=0;
    800026d0:	0404bc23          	sd	zero,88(s1)
release(&(bcache.lock[lock_num]));
    800026d4:	0916                	slli	s2,s2,0x5
    800026d6:	0000d517          	auipc	a0,0xd
    800026da:	afa50513          	addi	a0,a0,-1286 # 8000f1d0 <bcache>
    800026de:	954a                	add	a0,a0,s2
    800026e0:	00004097          	auipc	ra,0x4
    800026e4:	070080e7          	jalr	112(ra) # 80006750 <release>
b->next=take_buf;
    800026e8:	049a3c23          	sd	s1,88(s4)
  take_buf->dev = dev;
    800026ec:	f7043783          	ld	a5,-144(s0)
    800026f0:	c49c                	sw	a5,8(s1)
  take_buf->blockno = blockno;
    800026f2:	0184a623          	sw	s8,12(s1)
  take_buf->valid = 0;
    800026f6:	0004a023          	sw	zero,0(s1)
  take_buf->refcnt = 1;
    800026fa:	4785                	li	a5,1
    800026fc:	c4bc                	sw	a5,72(s1)
  take_buf->time = ticks;
    800026fe:	00007797          	auipc	a5,0x7
    80002702:	91a7a783          	lw	a5,-1766(a5) # 80009018 <ticks>
    80002706:	46f4a023          	sw	a5,1120(s1)
release(&bcache.lock[id]);
    8000270a:	f6043503          	ld	a0,-160(s0)
    8000270e:	00004097          	auipc	ra,0x4
    80002712:	042080e7          	jalr	66(ra) # 80006750 <release>
acquiresleep(&take_buf->lock);
    80002716:	01048513          	addi	a0,s1,16
    8000271a:	00001097          	auipc	ra,0x1
    8000271e:	312080e7          	jalr	786(ra) # 80003a2c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002722:	409c                	lw	a5,0(s1)
    80002724:	cb8d                	beqz	a5,80002756 <bread+0x27e>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002726:	8526                	mv	a0,s1
    80002728:	60ea                	ld	ra,152(sp)
    8000272a:	644a                	ld	s0,144(sp)
    8000272c:	64aa                	ld	s1,136(sp)
    8000272e:	690a                	ld	s2,128(sp)
    80002730:	79e6                	ld	s3,120(sp)
    80002732:	7a46                	ld	s4,112(sp)
    80002734:	7aa6                	ld	s5,104(sp)
    80002736:	7b06                	ld	s6,96(sp)
    80002738:	6be6                	ld	s7,88(sp)
    8000273a:	6c46                	ld	s8,80(sp)
    8000273c:	6ca6                	ld	s9,72(sp)
    8000273e:	6d06                	ld	s10,64(sp)
    80002740:	7de2                	ld	s11,56(sp)
    80002742:	610d                	addi	sp,sp,160
    80002744:	8082                	ret
  panic("bget: no buffers");
    80002746:	00006517          	auipc	a0,0x6
    8000274a:	d4a50513          	addi	a0,a0,-694 # 80008490 <syscalls+0xc8>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	9fe080e7          	jalr	-1538(ra) # 8000614c <panic>
    virtio_disk_rw(b, 0);
    80002756:	4581                	li	a1,0
    80002758:	8526                	mv	a0,s1
    8000275a:	00003097          	auipc	ra,0x3
    8000275e:	dfc080e7          	jalr	-516(ra) # 80005556 <virtio_disk_rw>
    b->valid = 1;
    80002762:	4785                	li	a5,1
    80002764:	c09c                	sw	a5,0(s1)
  return b;
    80002766:	b7c1                	j	80002726 <bread+0x24e>

0000000080002768 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	1000                	addi	s0,sp,32
    80002772:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002774:	0541                	addi	a0,a0,16
    80002776:	00001097          	auipc	ra,0x1
    8000277a:	350080e7          	jalr	848(ra) # 80003ac6 <holdingsleep>
    8000277e:	cd01                	beqz	a0,80002796 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002780:	4585                	li	a1,1
    80002782:	8526                	mv	a0,s1
    80002784:	00003097          	auipc	ra,0x3
    80002788:	dd2080e7          	jalr	-558(ra) # 80005556 <virtio_disk_rw>
}
    8000278c:	60e2                	ld	ra,24(sp)
    8000278e:	6442                	ld	s0,16(sp)
    80002790:	64a2                	ld	s1,8(sp)
    80002792:	6105                	addi	sp,sp,32
    80002794:	8082                	ret
    panic("bwrite");
    80002796:	00006517          	auipc	a0,0x6
    8000279a:	d1250513          	addi	a0,a0,-750 # 800084a8 <syscalls+0xe0>
    8000279e:	00004097          	auipc	ra,0x4
    800027a2:	9ae080e7          	jalr	-1618(ra) # 8000614c <panic>

00000000800027a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027a6:	1101                	addi	sp,sp,-32
    800027a8:	ec06                	sd	ra,24(sp)
    800027aa:	e822                	sd	s0,16(sp)
    800027ac:	e426                	sd	s1,8(sp)
    800027ae:	e04a                	sd	s2,0(sp)
    800027b0:	1000                	addi	s0,sp,32
    800027b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027b4:	00d5d59b          	srliw	a1,a1,0xd
    800027b8:	00019797          	auipc	a5,0x19
    800027bc:	94c7a783          	lw	a5,-1716(a5) # 8001b104 <sb+0x1c>
    800027c0:	9dbd                	addw	a1,a1,a5
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	d16080e7          	jalr	-746(ra) # 800024d8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027ca:	0074f713          	andi	a4,s1,7
    800027ce:	4785                	li	a5,1
    800027d0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027d4:	14ce                	slli	s1,s1,0x33
    800027d6:	90d9                	srli	s1,s1,0x36
    800027d8:	00950733          	add	a4,a0,s1
    800027dc:	06074703          	lbu	a4,96(a4)
    800027e0:	00e7f6b3          	and	a3,a5,a4
    800027e4:	c69d                	beqz	a3,80002812 <bfree+0x6c>
    800027e6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027e8:	94aa                	add	s1,s1,a0
    800027ea:	fff7c793          	not	a5,a5
    800027ee:	8ff9                	and	a5,a5,a4
    800027f0:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    800027f4:	00001097          	auipc	ra,0x1
    800027f8:	118080e7          	jalr	280(ra) # 8000390c <log_write>
  brelse(bp);
    800027fc:	854a                	mv	a0,s2
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	baa080e7          	jalr	-1110(ra) # 800023a8 <brelse>
}
    80002806:	60e2                	ld	ra,24(sp)
    80002808:	6442                	ld	s0,16(sp)
    8000280a:	64a2                	ld	s1,8(sp)
    8000280c:	6902                	ld	s2,0(sp)
    8000280e:	6105                	addi	sp,sp,32
    80002810:	8082                	ret
    panic("freeing free block");
    80002812:	00006517          	auipc	a0,0x6
    80002816:	c9e50513          	addi	a0,a0,-866 # 800084b0 <syscalls+0xe8>
    8000281a:	00004097          	auipc	ra,0x4
    8000281e:	932080e7          	jalr	-1742(ra) # 8000614c <panic>

0000000080002822 <balloc>:
{
    80002822:	711d                	addi	sp,sp,-96
    80002824:	ec86                	sd	ra,88(sp)
    80002826:	e8a2                	sd	s0,80(sp)
    80002828:	e4a6                	sd	s1,72(sp)
    8000282a:	e0ca                	sd	s2,64(sp)
    8000282c:	fc4e                	sd	s3,56(sp)
    8000282e:	f852                	sd	s4,48(sp)
    80002830:	f456                	sd	s5,40(sp)
    80002832:	f05a                	sd	s6,32(sp)
    80002834:	ec5e                	sd	s7,24(sp)
    80002836:	e862                	sd	s8,16(sp)
    80002838:	e466                	sd	s9,8(sp)
    8000283a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000283c:	00019797          	auipc	a5,0x19
    80002840:	8b07a783          	lw	a5,-1872(a5) # 8001b0ec <sb+0x4>
    80002844:	cbd1                	beqz	a5,800028d8 <balloc+0xb6>
    80002846:	8baa                	mv	s7,a0
    80002848:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000284a:	00019b17          	auipc	s6,0x19
    8000284e:	89eb0b13          	addi	s6,s6,-1890 # 8001b0e8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002852:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002854:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002856:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002858:	6c89                	lui	s9,0x2
    8000285a:	a831                	j	80002876 <balloc+0x54>
    brelse(bp);
    8000285c:	854a                	mv	a0,s2
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	b4a080e7          	jalr	-1206(ra) # 800023a8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002866:	015c87bb          	addw	a5,s9,s5
    8000286a:	00078a9b          	sext.w	s5,a5
    8000286e:	004b2703          	lw	a4,4(s6)
    80002872:	06eaf363          	bgeu	s5,a4,800028d8 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002876:	41fad79b          	sraiw	a5,s5,0x1f
    8000287a:	0137d79b          	srliw	a5,a5,0x13
    8000287e:	015787bb          	addw	a5,a5,s5
    80002882:	40d7d79b          	sraiw	a5,a5,0xd
    80002886:	01cb2583          	lw	a1,28(s6)
    8000288a:	9dbd                	addw	a1,a1,a5
    8000288c:	855e                	mv	a0,s7
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	c4a080e7          	jalr	-950(ra) # 800024d8 <bread>
    80002896:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002898:	004b2503          	lw	a0,4(s6)
    8000289c:	000a849b          	sext.w	s1,s5
    800028a0:	8662                	mv	a2,s8
    800028a2:	faa4fde3          	bgeu	s1,a0,8000285c <balloc+0x3a>
      m = 1 << (bi % 8);
    800028a6:	41f6579b          	sraiw	a5,a2,0x1f
    800028aa:	01d7d69b          	srliw	a3,a5,0x1d
    800028ae:	00c6873b          	addw	a4,a3,a2
    800028b2:	00777793          	andi	a5,a4,7
    800028b6:	9f95                	subw	a5,a5,a3
    800028b8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028bc:	4037571b          	sraiw	a4,a4,0x3
    800028c0:	00e906b3          	add	a3,s2,a4
    800028c4:	0606c683          	lbu	a3,96(a3)
    800028c8:	00d7f5b3          	and	a1,a5,a3
    800028cc:	cd91                	beqz	a1,800028e8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ce:	2605                	addiw	a2,a2,1
    800028d0:	2485                	addiw	s1,s1,1
    800028d2:	fd4618e3          	bne	a2,s4,800028a2 <balloc+0x80>
    800028d6:	b759                	j	8000285c <balloc+0x3a>
  panic("balloc: out of blocks");
    800028d8:	00006517          	auipc	a0,0x6
    800028dc:	bf050513          	addi	a0,a0,-1040 # 800084c8 <syscalls+0x100>
    800028e0:	00004097          	auipc	ra,0x4
    800028e4:	86c080e7          	jalr	-1940(ra) # 8000614c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028e8:	974a                	add	a4,a4,s2
    800028ea:	8fd5                	or	a5,a5,a3
    800028ec:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    800028f0:	854a                	mv	a0,s2
    800028f2:	00001097          	auipc	ra,0x1
    800028f6:	01a080e7          	jalr	26(ra) # 8000390c <log_write>
        brelse(bp);
    800028fa:	854a                	mv	a0,s2
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	aac080e7          	jalr	-1364(ra) # 800023a8 <brelse>
  bp = bread(dev, bno);
    80002904:	85a6                	mv	a1,s1
    80002906:	855e                	mv	a0,s7
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	bd0080e7          	jalr	-1072(ra) # 800024d8 <bread>
    80002910:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002912:	40000613          	li	a2,1024
    80002916:	4581                	li	a1,0
    80002918:	06050513          	addi	a0,a0,96
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	93a080e7          	jalr	-1734(ra) # 80000256 <memset>
  log_write(bp);
    80002924:	854a                	mv	a0,s2
    80002926:	00001097          	auipc	ra,0x1
    8000292a:	fe6080e7          	jalr	-26(ra) # 8000390c <log_write>
  brelse(bp);
    8000292e:	854a                	mv	a0,s2
    80002930:	00000097          	auipc	ra,0x0
    80002934:	a78080e7          	jalr	-1416(ra) # 800023a8 <brelse>
}
    80002938:	8526                	mv	a0,s1
    8000293a:	60e6                	ld	ra,88(sp)
    8000293c:	6446                	ld	s0,80(sp)
    8000293e:	64a6                	ld	s1,72(sp)
    80002940:	6906                	ld	s2,64(sp)
    80002942:	79e2                	ld	s3,56(sp)
    80002944:	7a42                	ld	s4,48(sp)
    80002946:	7aa2                	ld	s5,40(sp)
    80002948:	7b02                	ld	s6,32(sp)
    8000294a:	6be2                	ld	s7,24(sp)
    8000294c:	6c42                	ld	s8,16(sp)
    8000294e:	6ca2                	ld	s9,8(sp)
    80002950:	6125                	addi	sp,sp,96
    80002952:	8082                	ret

0000000080002954 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002954:	7179                	addi	sp,sp,-48
    80002956:	f406                	sd	ra,40(sp)
    80002958:	f022                	sd	s0,32(sp)
    8000295a:	ec26                	sd	s1,24(sp)
    8000295c:	e84a                	sd	s2,16(sp)
    8000295e:	e44e                	sd	s3,8(sp)
    80002960:	e052                	sd	s4,0(sp)
    80002962:	1800                	addi	s0,sp,48
    80002964:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002966:	47ad                	li	a5,11
    80002968:	04b7fe63          	bgeu	a5,a1,800029c4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000296c:	ff45849b          	addiw	s1,a1,-12
    80002970:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002974:	0ff00793          	li	a5,255
    80002978:	0ae7e363          	bltu	a5,a4,80002a1e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000297c:	08852583          	lw	a1,136(a0)
    80002980:	c5ad                	beqz	a1,800029ea <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002982:	00092503          	lw	a0,0(s2)
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	b52080e7          	jalr	-1198(ra) # 800024d8 <bread>
    8000298e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002990:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002994:	02049593          	slli	a1,s1,0x20
    80002998:	9181                	srli	a1,a1,0x20
    8000299a:	058a                	slli	a1,a1,0x2
    8000299c:	00b784b3          	add	s1,a5,a1
    800029a0:	0004a983          	lw	s3,0(s1)
    800029a4:	04098d63          	beqz	s3,800029fe <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029a8:	8552                	mv	a0,s4
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	9fe080e7          	jalr	-1538(ra) # 800023a8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029b2:	854e                	mv	a0,s3
    800029b4:	70a2                	ld	ra,40(sp)
    800029b6:	7402                	ld	s0,32(sp)
    800029b8:	64e2                	ld	s1,24(sp)
    800029ba:	6942                	ld	s2,16(sp)
    800029bc:	69a2                	ld	s3,8(sp)
    800029be:	6a02                	ld	s4,0(sp)
    800029c0:	6145                	addi	sp,sp,48
    800029c2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029c4:	02059493          	slli	s1,a1,0x20
    800029c8:	9081                	srli	s1,s1,0x20
    800029ca:	048a                	slli	s1,s1,0x2
    800029cc:	94aa                	add	s1,s1,a0
    800029ce:	0584a983          	lw	s3,88(s1)
    800029d2:	fe0990e3          	bnez	s3,800029b2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029d6:	4108                	lw	a0,0(a0)
    800029d8:	00000097          	auipc	ra,0x0
    800029dc:	e4a080e7          	jalr	-438(ra) # 80002822 <balloc>
    800029e0:	0005099b          	sext.w	s3,a0
    800029e4:	0534ac23          	sw	s3,88(s1)
    800029e8:	b7e9                	j	800029b2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029ea:	4108                	lw	a0,0(a0)
    800029ec:	00000097          	auipc	ra,0x0
    800029f0:	e36080e7          	jalr	-458(ra) # 80002822 <balloc>
    800029f4:	0005059b          	sext.w	a1,a0
    800029f8:	08b92423          	sw	a1,136(s2)
    800029fc:	b759                	j	80002982 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029fe:	00092503          	lw	a0,0(s2)
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	e20080e7          	jalr	-480(ra) # 80002822 <balloc>
    80002a0a:	0005099b          	sext.w	s3,a0
    80002a0e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a12:	8552                	mv	a0,s4
    80002a14:	00001097          	auipc	ra,0x1
    80002a18:	ef8080e7          	jalr	-264(ra) # 8000390c <log_write>
    80002a1c:	b771                	j	800029a8 <bmap+0x54>
  panic("bmap: out of range");
    80002a1e:	00006517          	auipc	a0,0x6
    80002a22:	ac250513          	addi	a0,a0,-1342 # 800084e0 <syscalls+0x118>
    80002a26:	00003097          	auipc	ra,0x3
    80002a2a:	726080e7          	jalr	1830(ra) # 8000614c <panic>

0000000080002a2e <iget>:
{
    80002a2e:	7179                	addi	sp,sp,-48
    80002a30:	f406                	sd	ra,40(sp)
    80002a32:	f022                	sd	s0,32(sp)
    80002a34:	ec26                	sd	s1,24(sp)
    80002a36:	e84a                	sd	s2,16(sp)
    80002a38:	e44e                	sd	s3,8(sp)
    80002a3a:	e052                	sd	s4,0(sp)
    80002a3c:	1800                	addi	s0,sp,48
    80002a3e:	89aa                	mv	s3,a0
    80002a40:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a42:	00018517          	auipc	a0,0x18
    80002a46:	6c650513          	addi	a0,a0,1734 # 8001b108 <itable>
    80002a4a:	00004097          	auipc	ra,0x4
    80002a4e:	c36080e7          	jalr	-970(ra) # 80006680 <acquire>
  empty = 0;
    80002a52:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a54:	00018497          	auipc	s1,0x18
    80002a58:	6d448493          	addi	s1,s1,1748 # 8001b128 <itable+0x20>
    80002a5c:	0001a697          	auipc	a3,0x1a
    80002a60:	2ec68693          	addi	a3,a3,748 # 8001cd48 <log>
    80002a64:	a039                	j	80002a72 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a66:	02090b63          	beqz	s2,80002a9c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a6a:	09048493          	addi	s1,s1,144
    80002a6e:	02d48a63          	beq	s1,a3,80002aa2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a72:	449c                	lw	a5,8(s1)
    80002a74:	fef059e3          	blez	a5,80002a66 <iget+0x38>
    80002a78:	4098                	lw	a4,0(s1)
    80002a7a:	ff3716e3          	bne	a4,s3,80002a66 <iget+0x38>
    80002a7e:	40d8                	lw	a4,4(s1)
    80002a80:	ff4713e3          	bne	a4,s4,80002a66 <iget+0x38>
      ip->ref++;
    80002a84:	2785                	addiw	a5,a5,1
    80002a86:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a88:	00018517          	auipc	a0,0x18
    80002a8c:	68050513          	addi	a0,a0,1664 # 8001b108 <itable>
    80002a90:	00004097          	auipc	ra,0x4
    80002a94:	cc0080e7          	jalr	-832(ra) # 80006750 <release>
      return ip;
    80002a98:	8926                	mv	s2,s1
    80002a9a:	a03d                	j	80002ac8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a9c:	f7f9                	bnez	a5,80002a6a <iget+0x3c>
    80002a9e:	8926                	mv	s2,s1
    80002aa0:	b7e9                	j	80002a6a <iget+0x3c>
  if(empty == 0)
    80002aa2:	02090c63          	beqz	s2,80002ada <iget+0xac>
  ip->dev = dev;
    80002aa6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aaa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aae:	4785                	li	a5,1
    80002ab0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ab4:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002ab8:	00018517          	auipc	a0,0x18
    80002abc:	65050513          	addi	a0,a0,1616 # 8001b108 <itable>
    80002ac0:	00004097          	auipc	ra,0x4
    80002ac4:	c90080e7          	jalr	-880(ra) # 80006750 <release>
}
    80002ac8:	854a                	mv	a0,s2
    80002aca:	70a2                	ld	ra,40(sp)
    80002acc:	7402                	ld	s0,32(sp)
    80002ace:	64e2                	ld	s1,24(sp)
    80002ad0:	6942                	ld	s2,16(sp)
    80002ad2:	69a2                	ld	s3,8(sp)
    80002ad4:	6a02                	ld	s4,0(sp)
    80002ad6:	6145                	addi	sp,sp,48
    80002ad8:	8082                	ret
    panic("iget: no inodes");
    80002ada:	00006517          	auipc	a0,0x6
    80002ade:	a1e50513          	addi	a0,a0,-1506 # 800084f8 <syscalls+0x130>
    80002ae2:	00003097          	auipc	ra,0x3
    80002ae6:	66a080e7          	jalr	1642(ra) # 8000614c <panic>

0000000080002aea <fsinit>:
fsinit(int dev) {
    80002aea:	7179                	addi	sp,sp,-48
    80002aec:	f406                	sd	ra,40(sp)
    80002aee:	f022                	sd	s0,32(sp)
    80002af0:	ec26                	sd	s1,24(sp)
    80002af2:	e84a                	sd	s2,16(sp)
    80002af4:	e44e                	sd	s3,8(sp)
    80002af6:	1800                	addi	s0,sp,48
    80002af8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002afa:	4585                	li	a1,1
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	9dc080e7          	jalr	-1572(ra) # 800024d8 <bread>
    80002b04:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b06:	00018997          	auipc	s3,0x18
    80002b0a:	5e298993          	addi	s3,s3,1506 # 8001b0e8 <sb>
    80002b0e:	02000613          	li	a2,32
    80002b12:	06050593          	addi	a1,a0,96
    80002b16:	854e                	mv	a0,s3
    80002b18:	ffffd097          	auipc	ra,0xffffd
    80002b1c:	79e080e7          	jalr	1950(ra) # 800002b6 <memmove>
  brelse(bp);
    80002b20:	8526                	mv	a0,s1
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	886080e7          	jalr	-1914(ra) # 800023a8 <brelse>
  if(sb.magic != FSMAGIC)
    80002b2a:	0009a703          	lw	a4,0(s3)
    80002b2e:	102037b7          	lui	a5,0x10203
    80002b32:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b36:	02f71263          	bne	a4,a5,80002b5a <fsinit+0x70>
  initlog(dev, &sb);
    80002b3a:	00018597          	auipc	a1,0x18
    80002b3e:	5ae58593          	addi	a1,a1,1454 # 8001b0e8 <sb>
    80002b42:	854a                	mv	a0,s2
    80002b44:	00001097          	auipc	ra,0x1
    80002b48:	b4c080e7          	jalr	-1204(ra) # 80003690 <initlog>
}
    80002b4c:	70a2                	ld	ra,40(sp)
    80002b4e:	7402                	ld	s0,32(sp)
    80002b50:	64e2                	ld	s1,24(sp)
    80002b52:	6942                	ld	s2,16(sp)
    80002b54:	69a2                	ld	s3,8(sp)
    80002b56:	6145                	addi	sp,sp,48
    80002b58:	8082                	ret
    panic("invalid file system");
    80002b5a:	00006517          	auipc	a0,0x6
    80002b5e:	9ae50513          	addi	a0,a0,-1618 # 80008508 <syscalls+0x140>
    80002b62:	00003097          	auipc	ra,0x3
    80002b66:	5ea080e7          	jalr	1514(ra) # 8000614c <panic>

0000000080002b6a <iinit>:
{
    80002b6a:	7179                	addi	sp,sp,-48
    80002b6c:	f406                	sd	ra,40(sp)
    80002b6e:	f022                	sd	s0,32(sp)
    80002b70:	ec26                	sd	s1,24(sp)
    80002b72:	e84a                	sd	s2,16(sp)
    80002b74:	e44e                	sd	s3,8(sp)
    80002b76:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b78:	00006597          	auipc	a1,0x6
    80002b7c:	9a858593          	addi	a1,a1,-1624 # 80008520 <syscalls+0x158>
    80002b80:	00018517          	auipc	a0,0x18
    80002b84:	58850513          	addi	a0,a0,1416 # 8001b108 <itable>
    80002b88:	00004097          	auipc	ra,0x4
    80002b8c:	c74080e7          	jalr	-908(ra) # 800067fc <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b90:	00018497          	auipc	s1,0x18
    80002b94:	5a848493          	addi	s1,s1,1448 # 8001b138 <itable+0x30>
    80002b98:	0001a997          	auipc	s3,0x1a
    80002b9c:	1c098993          	addi	s3,s3,448 # 8001cd58 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ba0:	00006917          	auipc	s2,0x6
    80002ba4:	98890913          	addi	s2,s2,-1656 # 80008528 <syscalls+0x160>
    80002ba8:	85ca                	mv	a1,s2
    80002baa:	8526                	mv	a0,s1
    80002bac:	00001097          	auipc	ra,0x1
    80002bb0:	e46080e7          	jalr	-442(ra) # 800039f2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bb4:	09048493          	addi	s1,s1,144
    80002bb8:	ff3498e3          	bne	s1,s3,80002ba8 <iinit+0x3e>
}
    80002bbc:	70a2                	ld	ra,40(sp)
    80002bbe:	7402                	ld	s0,32(sp)
    80002bc0:	64e2                	ld	s1,24(sp)
    80002bc2:	6942                	ld	s2,16(sp)
    80002bc4:	69a2                	ld	s3,8(sp)
    80002bc6:	6145                	addi	sp,sp,48
    80002bc8:	8082                	ret

0000000080002bca <ialloc>:
{
    80002bca:	715d                	addi	sp,sp,-80
    80002bcc:	e486                	sd	ra,72(sp)
    80002bce:	e0a2                	sd	s0,64(sp)
    80002bd0:	fc26                	sd	s1,56(sp)
    80002bd2:	f84a                	sd	s2,48(sp)
    80002bd4:	f44e                	sd	s3,40(sp)
    80002bd6:	f052                	sd	s4,32(sp)
    80002bd8:	ec56                	sd	s5,24(sp)
    80002bda:	e85a                	sd	s6,16(sp)
    80002bdc:	e45e                	sd	s7,8(sp)
    80002bde:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be0:	00018717          	auipc	a4,0x18
    80002be4:	51472703          	lw	a4,1300(a4) # 8001b0f4 <sb+0xc>
    80002be8:	4785                	li	a5,1
    80002bea:	04e7fa63          	bgeu	a5,a4,80002c3e <ialloc+0x74>
    80002bee:	8aaa                	mv	s5,a0
    80002bf0:	8bae                	mv	s7,a1
    80002bf2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bf4:	00018a17          	auipc	s4,0x18
    80002bf8:	4f4a0a13          	addi	s4,s4,1268 # 8001b0e8 <sb>
    80002bfc:	00048b1b          	sext.w	s6,s1
    80002c00:	0044d593          	srli	a1,s1,0x4
    80002c04:	018a2783          	lw	a5,24(s4)
    80002c08:	9dbd                	addw	a1,a1,a5
    80002c0a:	8556                	mv	a0,s5
    80002c0c:	00000097          	auipc	ra,0x0
    80002c10:	8cc080e7          	jalr	-1844(ra) # 800024d8 <bread>
    80002c14:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c16:	06050993          	addi	s3,a0,96
    80002c1a:	00f4f793          	andi	a5,s1,15
    80002c1e:	079a                	slli	a5,a5,0x6
    80002c20:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c22:	00099783          	lh	a5,0(s3)
    80002c26:	c785                	beqz	a5,80002c4e <ialloc+0x84>
    brelse(bp);
    80002c28:	fffff097          	auipc	ra,0xfffff
    80002c2c:	780080e7          	jalr	1920(ra) # 800023a8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c30:	0485                	addi	s1,s1,1
    80002c32:	00ca2703          	lw	a4,12(s4)
    80002c36:	0004879b          	sext.w	a5,s1
    80002c3a:	fce7e1e3          	bltu	a5,a4,80002bfc <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c3e:	00006517          	auipc	a0,0x6
    80002c42:	8f250513          	addi	a0,a0,-1806 # 80008530 <syscalls+0x168>
    80002c46:	00003097          	auipc	ra,0x3
    80002c4a:	506080e7          	jalr	1286(ra) # 8000614c <panic>
      memset(dip, 0, sizeof(*dip));
    80002c4e:	04000613          	li	a2,64
    80002c52:	4581                	li	a1,0
    80002c54:	854e                	mv	a0,s3
    80002c56:	ffffd097          	auipc	ra,0xffffd
    80002c5a:	600080e7          	jalr	1536(ra) # 80000256 <memset>
      dip->type = type;
    80002c5e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c62:	854a                	mv	a0,s2
    80002c64:	00001097          	auipc	ra,0x1
    80002c68:	ca8080e7          	jalr	-856(ra) # 8000390c <log_write>
      brelse(bp);
    80002c6c:	854a                	mv	a0,s2
    80002c6e:	fffff097          	auipc	ra,0xfffff
    80002c72:	73a080e7          	jalr	1850(ra) # 800023a8 <brelse>
      return iget(dev, inum);
    80002c76:	85da                	mv	a1,s6
    80002c78:	8556                	mv	a0,s5
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	db4080e7          	jalr	-588(ra) # 80002a2e <iget>
}
    80002c82:	60a6                	ld	ra,72(sp)
    80002c84:	6406                	ld	s0,64(sp)
    80002c86:	74e2                	ld	s1,56(sp)
    80002c88:	7942                	ld	s2,48(sp)
    80002c8a:	79a2                	ld	s3,40(sp)
    80002c8c:	7a02                	ld	s4,32(sp)
    80002c8e:	6ae2                	ld	s5,24(sp)
    80002c90:	6b42                	ld	s6,16(sp)
    80002c92:	6ba2                	ld	s7,8(sp)
    80002c94:	6161                	addi	sp,sp,80
    80002c96:	8082                	ret

0000000080002c98 <iupdate>:
{
    80002c98:	1101                	addi	sp,sp,-32
    80002c9a:	ec06                	sd	ra,24(sp)
    80002c9c:	e822                	sd	s0,16(sp)
    80002c9e:	e426                	sd	s1,8(sp)
    80002ca0:	e04a                	sd	s2,0(sp)
    80002ca2:	1000                	addi	s0,sp,32
    80002ca4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ca6:	415c                	lw	a5,4(a0)
    80002ca8:	0047d79b          	srliw	a5,a5,0x4
    80002cac:	00018597          	auipc	a1,0x18
    80002cb0:	4545a583          	lw	a1,1108(a1) # 8001b100 <sb+0x18>
    80002cb4:	9dbd                	addw	a1,a1,a5
    80002cb6:	4108                	lw	a0,0(a0)
    80002cb8:	00000097          	auipc	ra,0x0
    80002cbc:	820080e7          	jalr	-2016(ra) # 800024d8 <bread>
    80002cc0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc2:	06050793          	addi	a5,a0,96
    80002cc6:	40c8                	lw	a0,4(s1)
    80002cc8:	893d                	andi	a0,a0,15
    80002cca:	051a                	slli	a0,a0,0x6
    80002ccc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cce:	04c49703          	lh	a4,76(s1)
    80002cd2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cd6:	04e49703          	lh	a4,78(s1)
    80002cda:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cde:	05049703          	lh	a4,80(s1)
    80002ce2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ce6:	05249703          	lh	a4,82(s1)
    80002cea:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cee:	48f8                	lw	a4,84(s1)
    80002cf0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cf2:	03400613          	li	a2,52
    80002cf6:	05848593          	addi	a1,s1,88
    80002cfa:	0531                	addi	a0,a0,12
    80002cfc:	ffffd097          	auipc	ra,0xffffd
    80002d00:	5ba080e7          	jalr	1466(ra) # 800002b6 <memmove>
  log_write(bp);
    80002d04:	854a                	mv	a0,s2
    80002d06:	00001097          	auipc	ra,0x1
    80002d0a:	c06080e7          	jalr	-1018(ra) # 8000390c <log_write>
  brelse(bp);
    80002d0e:	854a                	mv	a0,s2
    80002d10:	fffff097          	auipc	ra,0xfffff
    80002d14:	698080e7          	jalr	1688(ra) # 800023a8 <brelse>
}
    80002d18:	60e2                	ld	ra,24(sp)
    80002d1a:	6442                	ld	s0,16(sp)
    80002d1c:	64a2                	ld	s1,8(sp)
    80002d1e:	6902                	ld	s2,0(sp)
    80002d20:	6105                	addi	sp,sp,32
    80002d22:	8082                	ret

0000000080002d24 <idup>:
{
    80002d24:	1101                	addi	sp,sp,-32
    80002d26:	ec06                	sd	ra,24(sp)
    80002d28:	e822                	sd	s0,16(sp)
    80002d2a:	e426                	sd	s1,8(sp)
    80002d2c:	1000                	addi	s0,sp,32
    80002d2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d30:	00018517          	auipc	a0,0x18
    80002d34:	3d850513          	addi	a0,a0,984 # 8001b108 <itable>
    80002d38:	00004097          	auipc	ra,0x4
    80002d3c:	948080e7          	jalr	-1720(ra) # 80006680 <acquire>
  ip->ref++;
    80002d40:	449c                	lw	a5,8(s1)
    80002d42:	2785                	addiw	a5,a5,1
    80002d44:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d46:	00018517          	auipc	a0,0x18
    80002d4a:	3c250513          	addi	a0,a0,962 # 8001b108 <itable>
    80002d4e:	00004097          	auipc	ra,0x4
    80002d52:	a02080e7          	jalr	-1534(ra) # 80006750 <release>
}
    80002d56:	8526                	mv	a0,s1
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6105                	addi	sp,sp,32
    80002d60:	8082                	ret

0000000080002d62 <ilock>:
{
    80002d62:	1101                	addi	sp,sp,-32
    80002d64:	ec06                	sd	ra,24(sp)
    80002d66:	e822                	sd	s0,16(sp)
    80002d68:	e426                	sd	s1,8(sp)
    80002d6a:	e04a                	sd	s2,0(sp)
    80002d6c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d6e:	c115                	beqz	a0,80002d92 <ilock+0x30>
    80002d70:	84aa                	mv	s1,a0
    80002d72:	451c                	lw	a5,8(a0)
    80002d74:	00f05f63          	blez	a5,80002d92 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d78:	0541                	addi	a0,a0,16
    80002d7a:	00001097          	auipc	ra,0x1
    80002d7e:	cb2080e7          	jalr	-846(ra) # 80003a2c <acquiresleep>
  if(ip->valid == 0){
    80002d82:	44bc                	lw	a5,72(s1)
    80002d84:	cf99                	beqz	a5,80002da2 <ilock+0x40>
}
    80002d86:	60e2                	ld	ra,24(sp)
    80002d88:	6442                	ld	s0,16(sp)
    80002d8a:	64a2                	ld	s1,8(sp)
    80002d8c:	6902                	ld	s2,0(sp)
    80002d8e:	6105                	addi	sp,sp,32
    80002d90:	8082                	ret
    panic("ilock");
    80002d92:	00005517          	auipc	a0,0x5
    80002d96:	7b650513          	addi	a0,a0,1974 # 80008548 <syscalls+0x180>
    80002d9a:	00003097          	auipc	ra,0x3
    80002d9e:	3b2080e7          	jalr	946(ra) # 8000614c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002da2:	40dc                	lw	a5,4(s1)
    80002da4:	0047d79b          	srliw	a5,a5,0x4
    80002da8:	00018597          	auipc	a1,0x18
    80002dac:	3585a583          	lw	a1,856(a1) # 8001b100 <sb+0x18>
    80002db0:	9dbd                	addw	a1,a1,a5
    80002db2:	4088                	lw	a0,0(s1)
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	724080e7          	jalr	1828(ra) # 800024d8 <bread>
    80002dbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dbe:	06050593          	addi	a1,a0,96
    80002dc2:	40dc                	lw	a5,4(s1)
    80002dc4:	8bbd                	andi	a5,a5,15
    80002dc6:	079a                	slli	a5,a5,0x6
    80002dc8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dca:	00059783          	lh	a5,0(a1)
    80002dce:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002dd2:	00259783          	lh	a5,2(a1)
    80002dd6:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002dda:	00459783          	lh	a5,4(a1)
    80002dde:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002de2:	00659783          	lh	a5,6(a1)
    80002de6:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002dea:	459c                	lw	a5,8(a1)
    80002dec:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dee:	03400613          	li	a2,52
    80002df2:	05b1                	addi	a1,a1,12
    80002df4:	05848513          	addi	a0,s1,88
    80002df8:	ffffd097          	auipc	ra,0xffffd
    80002dfc:	4be080e7          	jalr	1214(ra) # 800002b6 <memmove>
    brelse(bp);
    80002e00:	854a                	mv	a0,s2
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	5a6080e7          	jalr	1446(ra) # 800023a8 <brelse>
    ip->valid = 1;
    80002e0a:	4785                	li	a5,1
    80002e0c:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002e0e:	04c49783          	lh	a5,76(s1)
    80002e12:	fbb5                	bnez	a5,80002d86 <ilock+0x24>
      panic("ilock: no type");
    80002e14:	00005517          	auipc	a0,0x5
    80002e18:	73c50513          	addi	a0,a0,1852 # 80008550 <syscalls+0x188>
    80002e1c:	00003097          	auipc	ra,0x3
    80002e20:	330080e7          	jalr	816(ra) # 8000614c <panic>

0000000080002e24 <iunlock>:
{
    80002e24:	1101                	addi	sp,sp,-32
    80002e26:	ec06                	sd	ra,24(sp)
    80002e28:	e822                	sd	s0,16(sp)
    80002e2a:	e426                	sd	s1,8(sp)
    80002e2c:	e04a                	sd	s2,0(sp)
    80002e2e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e30:	c905                	beqz	a0,80002e60 <iunlock+0x3c>
    80002e32:	84aa                	mv	s1,a0
    80002e34:	01050913          	addi	s2,a0,16
    80002e38:	854a                	mv	a0,s2
    80002e3a:	00001097          	auipc	ra,0x1
    80002e3e:	c8c080e7          	jalr	-884(ra) # 80003ac6 <holdingsleep>
    80002e42:	cd19                	beqz	a0,80002e60 <iunlock+0x3c>
    80002e44:	449c                	lw	a5,8(s1)
    80002e46:	00f05d63          	blez	a5,80002e60 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e4a:	854a                	mv	a0,s2
    80002e4c:	00001097          	auipc	ra,0x1
    80002e50:	c36080e7          	jalr	-970(ra) # 80003a82 <releasesleep>
}
    80002e54:	60e2                	ld	ra,24(sp)
    80002e56:	6442                	ld	s0,16(sp)
    80002e58:	64a2                	ld	s1,8(sp)
    80002e5a:	6902                	ld	s2,0(sp)
    80002e5c:	6105                	addi	sp,sp,32
    80002e5e:	8082                	ret
    panic("iunlock");
    80002e60:	00005517          	auipc	a0,0x5
    80002e64:	70050513          	addi	a0,a0,1792 # 80008560 <syscalls+0x198>
    80002e68:	00003097          	auipc	ra,0x3
    80002e6c:	2e4080e7          	jalr	740(ra) # 8000614c <panic>

0000000080002e70 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e70:	7179                	addi	sp,sp,-48
    80002e72:	f406                	sd	ra,40(sp)
    80002e74:	f022                	sd	s0,32(sp)
    80002e76:	ec26                	sd	s1,24(sp)
    80002e78:	e84a                	sd	s2,16(sp)
    80002e7a:	e44e                	sd	s3,8(sp)
    80002e7c:	e052                	sd	s4,0(sp)
    80002e7e:	1800                	addi	s0,sp,48
    80002e80:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e82:	05850493          	addi	s1,a0,88
    80002e86:	08850913          	addi	s2,a0,136
    80002e8a:	a021                	j	80002e92 <itrunc+0x22>
    80002e8c:	0491                	addi	s1,s1,4
    80002e8e:	01248d63          	beq	s1,s2,80002ea8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e92:	408c                	lw	a1,0(s1)
    80002e94:	dde5                	beqz	a1,80002e8c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	90c080e7          	jalr	-1780(ra) # 800027a6 <bfree>
      ip->addrs[i] = 0;
    80002ea2:	0004a023          	sw	zero,0(s1)
    80002ea6:	b7dd                	j	80002e8c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ea8:	0889a583          	lw	a1,136(s3)
    80002eac:	e185                	bnez	a1,80002ecc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eae:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002eb2:	854e                	mv	a0,s3
    80002eb4:	00000097          	auipc	ra,0x0
    80002eb8:	de4080e7          	jalr	-540(ra) # 80002c98 <iupdate>
}
    80002ebc:	70a2                	ld	ra,40(sp)
    80002ebe:	7402                	ld	s0,32(sp)
    80002ec0:	64e2                	ld	s1,24(sp)
    80002ec2:	6942                	ld	s2,16(sp)
    80002ec4:	69a2                	ld	s3,8(sp)
    80002ec6:	6a02                	ld	s4,0(sp)
    80002ec8:	6145                	addi	sp,sp,48
    80002eca:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ecc:	0009a503          	lw	a0,0(s3)
    80002ed0:	fffff097          	auipc	ra,0xfffff
    80002ed4:	608080e7          	jalr	1544(ra) # 800024d8 <bread>
    80002ed8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002eda:	06050493          	addi	s1,a0,96
    80002ede:	46050913          	addi	s2,a0,1120
    80002ee2:	a811                	j	80002ef6 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ee4:	0009a503          	lw	a0,0(s3)
    80002ee8:	00000097          	auipc	ra,0x0
    80002eec:	8be080e7          	jalr	-1858(ra) # 800027a6 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ef0:	0491                	addi	s1,s1,4
    80002ef2:	01248563          	beq	s1,s2,80002efc <itrunc+0x8c>
      if(a[j])
    80002ef6:	408c                	lw	a1,0(s1)
    80002ef8:	dde5                	beqz	a1,80002ef0 <itrunc+0x80>
    80002efa:	b7ed                	j	80002ee4 <itrunc+0x74>
    brelse(bp);
    80002efc:	8552                	mv	a0,s4
    80002efe:	fffff097          	auipc	ra,0xfffff
    80002f02:	4aa080e7          	jalr	1194(ra) # 800023a8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f06:	0889a583          	lw	a1,136(s3)
    80002f0a:	0009a503          	lw	a0,0(s3)
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	898080e7          	jalr	-1896(ra) # 800027a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f16:	0809a423          	sw	zero,136(s3)
    80002f1a:	bf51                	j	80002eae <itrunc+0x3e>

0000000080002f1c <iput>:
{
    80002f1c:	1101                	addi	sp,sp,-32
    80002f1e:	ec06                	sd	ra,24(sp)
    80002f20:	e822                	sd	s0,16(sp)
    80002f22:	e426                	sd	s1,8(sp)
    80002f24:	e04a                	sd	s2,0(sp)
    80002f26:	1000                	addi	s0,sp,32
    80002f28:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f2a:	00018517          	auipc	a0,0x18
    80002f2e:	1de50513          	addi	a0,a0,478 # 8001b108 <itable>
    80002f32:	00003097          	auipc	ra,0x3
    80002f36:	74e080e7          	jalr	1870(ra) # 80006680 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f3a:	4498                	lw	a4,8(s1)
    80002f3c:	4785                	li	a5,1
    80002f3e:	02f70363          	beq	a4,a5,80002f64 <iput+0x48>
  ip->ref--;
    80002f42:	449c                	lw	a5,8(s1)
    80002f44:	37fd                	addiw	a5,a5,-1
    80002f46:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f48:	00018517          	auipc	a0,0x18
    80002f4c:	1c050513          	addi	a0,a0,448 # 8001b108 <itable>
    80002f50:	00004097          	auipc	ra,0x4
    80002f54:	800080e7          	jalr	-2048(ra) # 80006750 <release>
}
    80002f58:	60e2                	ld	ra,24(sp)
    80002f5a:	6442                	ld	s0,16(sp)
    80002f5c:	64a2                	ld	s1,8(sp)
    80002f5e:	6902                	ld	s2,0(sp)
    80002f60:	6105                	addi	sp,sp,32
    80002f62:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f64:	44bc                	lw	a5,72(s1)
    80002f66:	dff1                	beqz	a5,80002f42 <iput+0x26>
    80002f68:	05249783          	lh	a5,82(s1)
    80002f6c:	fbf9                	bnez	a5,80002f42 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f6e:	01048913          	addi	s2,s1,16
    80002f72:	854a                	mv	a0,s2
    80002f74:	00001097          	auipc	ra,0x1
    80002f78:	ab8080e7          	jalr	-1352(ra) # 80003a2c <acquiresleep>
    release(&itable.lock);
    80002f7c:	00018517          	auipc	a0,0x18
    80002f80:	18c50513          	addi	a0,a0,396 # 8001b108 <itable>
    80002f84:	00003097          	auipc	ra,0x3
    80002f88:	7cc080e7          	jalr	1996(ra) # 80006750 <release>
    itrunc(ip);
    80002f8c:	8526                	mv	a0,s1
    80002f8e:	00000097          	auipc	ra,0x0
    80002f92:	ee2080e7          	jalr	-286(ra) # 80002e70 <itrunc>
    ip->type = 0;
    80002f96:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	00000097          	auipc	ra,0x0
    80002fa0:	cfc080e7          	jalr	-772(ra) # 80002c98 <iupdate>
    ip->valid = 0;
    80002fa4:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002fa8:	854a                	mv	a0,s2
    80002faa:	00001097          	auipc	ra,0x1
    80002fae:	ad8080e7          	jalr	-1320(ra) # 80003a82 <releasesleep>
    acquire(&itable.lock);
    80002fb2:	00018517          	auipc	a0,0x18
    80002fb6:	15650513          	addi	a0,a0,342 # 8001b108 <itable>
    80002fba:	00003097          	auipc	ra,0x3
    80002fbe:	6c6080e7          	jalr	1734(ra) # 80006680 <acquire>
    80002fc2:	b741                	j	80002f42 <iput+0x26>

0000000080002fc4 <iunlockput>:
{
    80002fc4:	1101                	addi	sp,sp,-32
    80002fc6:	ec06                	sd	ra,24(sp)
    80002fc8:	e822                	sd	s0,16(sp)
    80002fca:	e426                	sd	s1,8(sp)
    80002fcc:	1000                	addi	s0,sp,32
    80002fce:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	e54080e7          	jalr	-428(ra) # 80002e24 <iunlock>
  iput(ip);
    80002fd8:	8526                	mv	a0,s1
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	f42080e7          	jalr	-190(ra) # 80002f1c <iput>
}
    80002fe2:	60e2                	ld	ra,24(sp)
    80002fe4:	6442                	ld	s0,16(sp)
    80002fe6:	64a2                	ld	s1,8(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fec:	1141                	addi	sp,sp,-16
    80002fee:	e422                	sd	s0,8(sp)
    80002ff0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ff2:	411c                	lw	a5,0(a0)
    80002ff4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ff6:	415c                	lw	a5,4(a0)
    80002ff8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ffa:	04c51783          	lh	a5,76(a0)
    80002ffe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003002:	05251783          	lh	a5,82(a0)
    80003006:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000300a:	05456783          	lwu	a5,84(a0)
    8000300e:	e99c                	sd	a5,16(a1)
}
    80003010:	6422                	ld	s0,8(sp)
    80003012:	0141                	addi	sp,sp,16
    80003014:	8082                	ret

0000000080003016 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003016:	497c                	lw	a5,84(a0)
    80003018:	0ed7e963          	bltu	a5,a3,8000310a <readi+0xf4>
{
    8000301c:	7159                	addi	sp,sp,-112
    8000301e:	f486                	sd	ra,104(sp)
    80003020:	f0a2                	sd	s0,96(sp)
    80003022:	eca6                	sd	s1,88(sp)
    80003024:	e8ca                	sd	s2,80(sp)
    80003026:	e4ce                	sd	s3,72(sp)
    80003028:	e0d2                	sd	s4,64(sp)
    8000302a:	fc56                	sd	s5,56(sp)
    8000302c:	f85a                	sd	s6,48(sp)
    8000302e:	f45e                	sd	s7,40(sp)
    80003030:	f062                	sd	s8,32(sp)
    80003032:	ec66                	sd	s9,24(sp)
    80003034:	e86a                	sd	s10,16(sp)
    80003036:	e46e                	sd	s11,8(sp)
    80003038:	1880                	addi	s0,sp,112
    8000303a:	8baa                	mv	s7,a0
    8000303c:	8c2e                	mv	s8,a1
    8000303e:	8ab2                	mv	s5,a2
    80003040:	84b6                	mv	s1,a3
    80003042:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003044:	9f35                	addw	a4,a4,a3
    return 0;
    80003046:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003048:	0ad76063          	bltu	a4,a3,800030e8 <readi+0xd2>
  if(off + n > ip->size)
    8000304c:	00e7f463          	bgeu	a5,a4,80003054 <readi+0x3e>
    n = ip->size - off;
    80003050:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003054:	0a0b0963          	beqz	s6,80003106 <readi+0xf0>
    80003058:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000305a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000305e:	5cfd                	li	s9,-1
    80003060:	a82d                	j	8000309a <readi+0x84>
    80003062:	020a1d93          	slli	s11,s4,0x20
    80003066:	020ddd93          	srli	s11,s11,0x20
    8000306a:	06090613          	addi	a2,s2,96
    8000306e:	86ee                	mv	a3,s11
    80003070:	963a                	add	a2,a2,a4
    80003072:	85d6                	mv	a1,s5
    80003074:	8562                	mv	a0,s8
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	920080e7          	jalr	-1760(ra) # 80001996 <either_copyout>
    8000307e:	05950d63          	beq	a0,s9,800030d8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003082:	854a                	mv	a0,s2
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	324080e7          	jalr	804(ra) # 800023a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000308c:	013a09bb          	addw	s3,s4,s3
    80003090:	009a04bb          	addw	s1,s4,s1
    80003094:	9aee                	add	s5,s5,s11
    80003096:	0569f763          	bgeu	s3,s6,800030e4 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000309a:	000ba903          	lw	s2,0(s7)
    8000309e:	00a4d59b          	srliw	a1,s1,0xa
    800030a2:	855e                	mv	a0,s7
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	8b0080e7          	jalr	-1872(ra) # 80002954 <bmap>
    800030ac:	0005059b          	sext.w	a1,a0
    800030b0:	854a                	mv	a0,s2
    800030b2:	fffff097          	auipc	ra,0xfffff
    800030b6:	426080e7          	jalr	1062(ra) # 800024d8 <bread>
    800030ba:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030bc:	3ff4f713          	andi	a4,s1,1023
    800030c0:	40ed07bb          	subw	a5,s10,a4
    800030c4:	413b06bb          	subw	a3,s6,s3
    800030c8:	8a3e                	mv	s4,a5
    800030ca:	2781                	sext.w	a5,a5
    800030cc:	0006861b          	sext.w	a2,a3
    800030d0:	f8f679e3          	bgeu	a2,a5,80003062 <readi+0x4c>
    800030d4:	8a36                	mv	s4,a3
    800030d6:	b771                	j	80003062 <readi+0x4c>
      brelse(bp);
    800030d8:	854a                	mv	a0,s2
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	2ce080e7          	jalr	718(ra) # 800023a8 <brelse>
      tot = -1;
    800030e2:	59fd                	li	s3,-1
  }
  return tot;
    800030e4:	0009851b          	sext.w	a0,s3
}
    800030e8:	70a6                	ld	ra,104(sp)
    800030ea:	7406                	ld	s0,96(sp)
    800030ec:	64e6                	ld	s1,88(sp)
    800030ee:	6946                	ld	s2,80(sp)
    800030f0:	69a6                	ld	s3,72(sp)
    800030f2:	6a06                	ld	s4,64(sp)
    800030f4:	7ae2                	ld	s5,56(sp)
    800030f6:	7b42                	ld	s6,48(sp)
    800030f8:	7ba2                	ld	s7,40(sp)
    800030fa:	7c02                	ld	s8,32(sp)
    800030fc:	6ce2                	ld	s9,24(sp)
    800030fe:	6d42                	ld	s10,16(sp)
    80003100:	6da2                	ld	s11,8(sp)
    80003102:	6165                	addi	sp,sp,112
    80003104:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003106:	89da                	mv	s3,s6
    80003108:	bff1                	j	800030e4 <readi+0xce>
    return 0;
    8000310a:	4501                	li	a0,0
}
    8000310c:	8082                	ret

000000008000310e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000310e:	497c                	lw	a5,84(a0)
    80003110:	10d7e863          	bltu	a5,a3,80003220 <writei+0x112>
{
    80003114:	7159                	addi	sp,sp,-112
    80003116:	f486                	sd	ra,104(sp)
    80003118:	f0a2                	sd	s0,96(sp)
    8000311a:	eca6                	sd	s1,88(sp)
    8000311c:	e8ca                	sd	s2,80(sp)
    8000311e:	e4ce                	sd	s3,72(sp)
    80003120:	e0d2                	sd	s4,64(sp)
    80003122:	fc56                	sd	s5,56(sp)
    80003124:	f85a                	sd	s6,48(sp)
    80003126:	f45e                	sd	s7,40(sp)
    80003128:	f062                	sd	s8,32(sp)
    8000312a:	ec66                	sd	s9,24(sp)
    8000312c:	e86a                	sd	s10,16(sp)
    8000312e:	e46e                	sd	s11,8(sp)
    80003130:	1880                	addi	s0,sp,112
    80003132:	8b2a                	mv	s6,a0
    80003134:	8c2e                	mv	s8,a1
    80003136:	8ab2                	mv	s5,a2
    80003138:	8936                	mv	s2,a3
    8000313a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000313c:	00e687bb          	addw	a5,a3,a4
    80003140:	0ed7e263          	bltu	a5,a3,80003224 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003144:	00043737          	lui	a4,0x43
    80003148:	0ef76063          	bltu	a4,a5,80003228 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000314c:	0c0b8863          	beqz	s7,8000321c <writei+0x10e>
    80003150:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003152:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003156:	5cfd                	li	s9,-1
    80003158:	a091                	j	8000319c <writei+0x8e>
    8000315a:	02099d93          	slli	s11,s3,0x20
    8000315e:	020ddd93          	srli	s11,s11,0x20
    80003162:	06048513          	addi	a0,s1,96
    80003166:	86ee                	mv	a3,s11
    80003168:	8656                	mv	a2,s5
    8000316a:	85e2                	mv	a1,s8
    8000316c:	953a                	add	a0,a0,a4
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	87e080e7          	jalr	-1922(ra) # 800019ec <either_copyin>
    80003176:	07950263          	beq	a0,s9,800031da <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000317a:	8526                	mv	a0,s1
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	790080e7          	jalr	1936(ra) # 8000390c <log_write>
    brelse(bp);
    80003184:	8526                	mv	a0,s1
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	222080e7          	jalr	546(ra) # 800023a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318e:	01498a3b          	addw	s4,s3,s4
    80003192:	0129893b          	addw	s2,s3,s2
    80003196:	9aee                	add	s5,s5,s11
    80003198:	057a7663          	bgeu	s4,s7,800031e4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000319c:	000b2483          	lw	s1,0(s6)
    800031a0:	00a9559b          	srliw	a1,s2,0xa
    800031a4:	855a                	mv	a0,s6
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	7ae080e7          	jalr	1966(ra) # 80002954 <bmap>
    800031ae:	0005059b          	sext.w	a1,a0
    800031b2:	8526                	mv	a0,s1
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	324080e7          	jalr	804(ra) # 800024d8 <bread>
    800031bc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031be:	3ff97713          	andi	a4,s2,1023
    800031c2:	40ed07bb          	subw	a5,s10,a4
    800031c6:	414b86bb          	subw	a3,s7,s4
    800031ca:	89be                	mv	s3,a5
    800031cc:	2781                	sext.w	a5,a5
    800031ce:	0006861b          	sext.w	a2,a3
    800031d2:	f8f674e3          	bgeu	a2,a5,8000315a <writei+0x4c>
    800031d6:	89b6                	mv	s3,a3
    800031d8:	b749                	j	8000315a <writei+0x4c>
      brelse(bp);
    800031da:	8526                	mv	a0,s1
    800031dc:	fffff097          	auipc	ra,0xfffff
    800031e0:	1cc080e7          	jalr	460(ra) # 800023a8 <brelse>
  }

  if(off > ip->size)
    800031e4:	054b2783          	lw	a5,84(s6)
    800031e8:	0127f463          	bgeu	a5,s2,800031f0 <writei+0xe2>
    ip->size = off;
    800031ec:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031f0:	855a                	mv	a0,s6
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	aa6080e7          	jalr	-1370(ra) # 80002c98 <iupdate>

  return tot;
    800031fa:	000a051b          	sext.w	a0,s4
}
    800031fe:	70a6                	ld	ra,104(sp)
    80003200:	7406                	ld	s0,96(sp)
    80003202:	64e6                	ld	s1,88(sp)
    80003204:	6946                	ld	s2,80(sp)
    80003206:	69a6                	ld	s3,72(sp)
    80003208:	6a06                	ld	s4,64(sp)
    8000320a:	7ae2                	ld	s5,56(sp)
    8000320c:	7b42                	ld	s6,48(sp)
    8000320e:	7ba2                	ld	s7,40(sp)
    80003210:	7c02                	ld	s8,32(sp)
    80003212:	6ce2                	ld	s9,24(sp)
    80003214:	6d42                	ld	s10,16(sp)
    80003216:	6da2                	ld	s11,8(sp)
    80003218:	6165                	addi	sp,sp,112
    8000321a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000321c:	8a5e                	mv	s4,s7
    8000321e:	bfc9                	j	800031f0 <writei+0xe2>
    return -1;
    80003220:	557d                	li	a0,-1
}
    80003222:	8082                	ret
    return -1;
    80003224:	557d                	li	a0,-1
    80003226:	bfe1                	j	800031fe <writei+0xf0>
    return -1;
    80003228:	557d                	li	a0,-1
    8000322a:	bfd1                	j	800031fe <writei+0xf0>

000000008000322c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000322c:	1141                	addi	sp,sp,-16
    8000322e:	e406                	sd	ra,8(sp)
    80003230:	e022                	sd	s0,0(sp)
    80003232:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003234:	4639                	li	a2,14
    80003236:	ffffd097          	auipc	ra,0xffffd
    8000323a:	0f8080e7          	jalr	248(ra) # 8000032e <strncmp>
}
    8000323e:	60a2                	ld	ra,8(sp)
    80003240:	6402                	ld	s0,0(sp)
    80003242:	0141                	addi	sp,sp,16
    80003244:	8082                	ret

0000000080003246 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003246:	7139                	addi	sp,sp,-64
    80003248:	fc06                	sd	ra,56(sp)
    8000324a:	f822                	sd	s0,48(sp)
    8000324c:	f426                	sd	s1,40(sp)
    8000324e:	f04a                	sd	s2,32(sp)
    80003250:	ec4e                	sd	s3,24(sp)
    80003252:	e852                	sd	s4,16(sp)
    80003254:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003256:	04c51703          	lh	a4,76(a0)
    8000325a:	4785                	li	a5,1
    8000325c:	00f71a63          	bne	a4,a5,80003270 <dirlookup+0x2a>
    80003260:	892a                	mv	s2,a0
    80003262:	89ae                	mv	s3,a1
    80003264:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003266:	497c                	lw	a5,84(a0)
    80003268:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000326a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000326c:	e79d                	bnez	a5,8000329a <dirlookup+0x54>
    8000326e:	a8a5                	j	800032e6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003270:	00005517          	auipc	a0,0x5
    80003274:	2f850513          	addi	a0,a0,760 # 80008568 <syscalls+0x1a0>
    80003278:	00003097          	auipc	ra,0x3
    8000327c:	ed4080e7          	jalr	-300(ra) # 8000614c <panic>
      panic("dirlookup read");
    80003280:	00005517          	auipc	a0,0x5
    80003284:	30050513          	addi	a0,a0,768 # 80008580 <syscalls+0x1b8>
    80003288:	00003097          	auipc	ra,0x3
    8000328c:	ec4080e7          	jalr	-316(ra) # 8000614c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003290:	24c1                	addiw	s1,s1,16
    80003292:	05492783          	lw	a5,84(s2)
    80003296:	04f4f763          	bgeu	s1,a5,800032e4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000329a:	4741                	li	a4,16
    8000329c:	86a6                	mv	a3,s1
    8000329e:	fc040613          	addi	a2,s0,-64
    800032a2:	4581                	li	a1,0
    800032a4:	854a                	mv	a0,s2
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	d70080e7          	jalr	-656(ra) # 80003016 <readi>
    800032ae:	47c1                	li	a5,16
    800032b0:	fcf518e3          	bne	a0,a5,80003280 <dirlookup+0x3a>
    if(de.inum == 0)
    800032b4:	fc045783          	lhu	a5,-64(s0)
    800032b8:	dfe1                	beqz	a5,80003290 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032ba:	fc240593          	addi	a1,s0,-62
    800032be:	854e                	mv	a0,s3
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	f6c080e7          	jalr	-148(ra) # 8000322c <namecmp>
    800032c8:	f561                	bnez	a0,80003290 <dirlookup+0x4a>
      if(poff)
    800032ca:	000a0463          	beqz	s4,800032d2 <dirlookup+0x8c>
        *poff = off;
    800032ce:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032d2:	fc045583          	lhu	a1,-64(s0)
    800032d6:	00092503          	lw	a0,0(s2)
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	754080e7          	jalr	1876(ra) # 80002a2e <iget>
    800032e2:	a011                	j	800032e6 <dirlookup+0xa0>
  return 0;
    800032e4:	4501                	li	a0,0
}
    800032e6:	70e2                	ld	ra,56(sp)
    800032e8:	7442                	ld	s0,48(sp)
    800032ea:	74a2                	ld	s1,40(sp)
    800032ec:	7902                	ld	s2,32(sp)
    800032ee:	69e2                	ld	s3,24(sp)
    800032f0:	6a42                	ld	s4,16(sp)
    800032f2:	6121                	addi	sp,sp,64
    800032f4:	8082                	ret

00000000800032f6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032f6:	711d                	addi	sp,sp,-96
    800032f8:	ec86                	sd	ra,88(sp)
    800032fa:	e8a2                	sd	s0,80(sp)
    800032fc:	e4a6                	sd	s1,72(sp)
    800032fe:	e0ca                	sd	s2,64(sp)
    80003300:	fc4e                	sd	s3,56(sp)
    80003302:	f852                	sd	s4,48(sp)
    80003304:	f456                	sd	s5,40(sp)
    80003306:	f05a                	sd	s6,32(sp)
    80003308:	ec5e                	sd	s7,24(sp)
    8000330a:	e862                	sd	s8,16(sp)
    8000330c:	e466                	sd	s9,8(sp)
    8000330e:	1080                	addi	s0,sp,96
    80003310:	84aa                	mv	s1,a0
    80003312:	8b2e                	mv	s6,a1
    80003314:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003316:	00054703          	lbu	a4,0(a0)
    8000331a:	02f00793          	li	a5,47
    8000331e:	02f70363          	beq	a4,a5,80003344 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003322:	ffffe097          	auipc	ra,0xffffe
    80003326:	c14080e7          	jalr	-1004(ra) # 80000f36 <myproc>
    8000332a:	15853503          	ld	a0,344(a0)
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	9f6080e7          	jalr	-1546(ra) # 80002d24 <idup>
    80003336:	89aa                	mv	s3,a0
  while(*path == '/')
    80003338:	02f00913          	li	s2,47
  len = path - s;
    8000333c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000333e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003340:	4c05                	li	s8,1
    80003342:	a865                	j	800033fa <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003344:	4585                	li	a1,1
    80003346:	4505                	li	a0,1
    80003348:	fffff097          	auipc	ra,0xfffff
    8000334c:	6e6080e7          	jalr	1766(ra) # 80002a2e <iget>
    80003350:	89aa                	mv	s3,a0
    80003352:	b7dd                	j	80003338 <namex+0x42>
      iunlockput(ip);
    80003354:	854e                	mv	a0,s3
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	c6e080e7          	jalr	-914(ra) # 80002fc4 <iunlockput>
      return 0;
    8000335e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003360:	854e                	mv	a0,s3
    80003362:	60e6                	ld	ra,88(sp)
    80003364:	6446                	ld	s0,80(sp)
    80003366:	64a6                	ld	s1,72(sp)
    80003368:	6906                	ld	s2,64(sp)
    8000336a:	79e2                	ld	s3,56(sp)
    8000336c:	7a42                	ld	s4,48(sp)
    8000336e:	7aa2                	ld	s5,40(sp)
    80003370:	7b02                	ld	s6,32(sp)
    80003372:	6be2                	ld	s7,24(sp)
    80003374:	6c42                	ld	s8,16(sp)
    80003376:	6ca2                	ld	s9,8(sp)
    80003378:	6125                	addi	sp,sp,96
    8000337a:	8082                	ret
      iunlock(ip);
    8000337c:	854e                	mv	a0,s3
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	aa6080e7          	jalr	-1370(ra) # 80002e24 <iunlock>
      return ip;
    80003386:	bfe9                	j	80003360 <namex+0x6a>
      iunlockput(ip);
    80003388:	854e                	mv	a0,s3
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	c3a080e7          	jalr	-966(ra) # 80002fc4 <iunlockput>
      return 0;
    80003392:	89d2                	mv	s3,s4
    80003394:	b7f1                	j	80003360 <namex+0x6a>
  len = path - s;
    80003396:	40b48633          	sub	a2,s1,a1
    8000339a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000339e:	094cd463          	bge	s9,s4,80003426 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033a2:	4639                	li	a2,14
    800033a4:	8556                	mv	a0,s5
    800033a6:	ffffd097          	auipc	ra,0xffffd
    800033aa:	f10080e7          	jalr	-240(ra) # 800002b6 <memmove>
  while(*path == '/')
    800033ae:	0004c783          	lbu	a5,0(s1)
    800033b2:	01279763          	bne	a5,s2,800033c0 <namex+0xca>
    path++;
    800033b6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b8:	0004c783          	lbu	a5,0(s1)
    800033bc:	ff278de3          	beq	a5,s2,800033b6 <namex+0xc0>
    ilock(ip);
    800033c0:	854e                	mv	a0,s3
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	9a0080e7          	jalr	-1632(ra) # 80002d62 <ilock>
    if(ip->type != T_DIR){
    800033ca:	04c99783          	lh	a5,76(s3)
    800033ce:	f98793e3          	bne	a5,s8,80003354 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033d2:	000b0563          	beqz	s6,800033dc <namex+0xe6>
    800033d6:	0004c783          	lbu	a5,0(s1)
    800033da:	d3cd                	beqz	a5,8000337c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033dc:	865e                	mv	a2,s7
    800033de:	85d6                	mv	a1,s5
    800033e0:	854e                	mv	a0,s3
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	e64080e7          	jalr	-412(ra) # 80003246 <dirlookup>
    800033ea:	8a2a                	mv	s4,a0
    800033ec:	dd51                	beqz	a0,80003388 <namex+0x92>
    iunlockput(ip);
    800033ee:	854e                	mv	a0,s3
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	bd4080e7          	jalr	-1068(ra) # 80002fc4 <iunlockput>
    ip = next;
    800033f8:	89d2                	mv	s3,s4
  while(*path == '/')
    800033fa:	0004c783          	lbu	a5,0(s1)
    800033fe:	05279763          	bne	a5,s2,8000344c <namex+0x156>
    path++;
    80003402:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003404:	0004c783          	lbu	a5,0(s1)
    80003408:	ff278de3          	beq	a5,s2,80003402 <namex+0x10c>
  if(*path == 0)
    8000340c:	c79d                	beqz	a5,8000343a <namex+0x144>
    path++;
    8000340e:	85a6                	mv	a1,s1
  len = path - s;
    80003410:	8a5e                	mv	s4,s7
    80003412:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003414:	01278963          	beq	a5,s2,80003426 <namex+0x130>
    80003418:	dfbd                	beqz	a5,80003396 <namex+0xa0>
    path++;
    8000341a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000341c:	0004c783          	lbu	a5,0(s1)
    80003420:	ff279ce3          	bne	a5,s2,80003418 <namex+0x122>
    80003424:	bf8d                	j	80003396 <namex+0xa0>
    memmove(name, s, len);
    80003426:	2601                	sext.w	a2,a2
    80003428:	8556                	mv	a0,s5
    8000342a:	ffffd097          	auipc	ra,0xffffd
    8000342e:	e8c080e7          	jalr	-372(ra) # 800002b6 <memmove>
    name[len] = 0;
    80003432:	9a56                	add	s4,s4,s5
    80003434:	000a0023          	sb	zero,0(s4)
    80003438:	bf9d                	j	800033ae <namex+0xb8>
  if(nameiparent){
    8000343a:	f20b03e3          	beqz	s6,80003360 <namex+0x6a>
    iput(ip);
    8000343e:	854e                	mv	a0,s3
    80003440:	00000097          	auipc	ra,0x0
    80003444:	adc080e7          	jalr	-1316(ra) # 80002f1c <iput>
    return 0;
    80003448:	4981                	li	s3,0
    8000344a:	bf19                	j	80003360 <namex+0x6a>
  if(*path == 0)
    8000344c:	d7fd                	beqz	a5,8000343a <namex+0x144>
  while(*path != '/' && *path != 0)
    8000344e:	0004c783          	lbu	a5,0(s1)
    80003452:	85a6                	mv	a1,s1
    80003454:	b7d1                	j	80003418 <namex+0x122>

0000000080003456 <dirlink>:
{
    80003456:	7139                	addi	sp,sp,-64
    80003458:	fc06                	sd	ra,56(sp)
    8000345a:	f822                	sd	s0,48(sp)
    8000345c:	f426                	sd	s1,40(sp)
    8000345e:	f04a                	sd	s2,32(sp)
    80003460:	ec4e                	sd	s3,24(sp)
    80003462:	e852                	sd	s4,16(sp)
    80003464:	0080                	addi	s0,sp,64
    80003466:	892a                	mv	s2,a0
    80003468:	8a2e                	mv	s4,a1
    8000346a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000346c:	4601                	li	a2,0
    8000346e:	00000097          	auipc	ra,0x0
    80003472:	dd8080e7          	jalr	-552(ra) # 80003246 <dirlookup>
    80003476:	e93d                	bnez	a0,800034ec <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003478:	05492483          	lw	s1,84(s2)
    8000347c:	c49d                	beqz	s1,800034aa <dirlink+0x54>
    8000347e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003480:	4741                	li	a4,16
    80003482:	86a6                	mv	a3,s1
    80003484:	fc040613          	addi	a2,s0,-64
    80003488:	4581                	li	a1,0
    8000348a:	854a                	mv	a0,s2
    8000348c:	00000097          	auipc	ra,0x0
    80003490:	b8a080e7          	jalr	-1142(ra) # 80003016 <readi>
    80003494:	47c1                	li	a5,16
    80003496:	06f51163          	bne	a0,a5,800034f8 <dirlink+0xa2>
    if(de.inum == 0)
    8000349a:	fc045783          	lhu	a5,-64(s0)
    8000349e:	c791                	beqz	a5,800034aa <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034a0:	24c1                	addiw	s1,s1,16
    800034a2:	05492783          	lw	a5,84(s2)
    800034a6:	fcf4ede3          	bltu	s1,a5,80003480 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034aa:	4639                	li	a2,14
    800034ac:	85d2                	mv	a1,s4
    800034ae:	fc240513          	addi	a0,s0,-62
    800034b2:	ffffd097          	auipc	ra,0xffffd
    800034b6:	eb8080e7          	jalr	-328(ra) # 8000036a <strncpy>
  de.inum = inum;
    800034ba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034be:	4741                	li	a4,16
    800034c0:	86a6                	mv	a3,s1
    800034c2:	fc040613          	addi	a2,s0,-64
    800034c6:	4581                	li	a1,0
    800034c8:	854a                	mv	a0,s2
    800034ca:	00000097          	auipc	ra,0x0
    800034ce:	c44080e7          	jalr	-956(ra) # 8000310e <writei>
    800034d2:	872a                	mv	a4,a0
    800034d4:	47c1                	li	a5,16
  return 0;
    800034d6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034d8:	02f71863          	bne	a4,a5,80003508 <dirlink+0xb2>
}
    800034dc:	70e2                	ld	ra,56(sp)
    800034de:	7442                	ld	s0,48(sp)
    800034e0:	74a2                	ld	s1,40(sp)
    800034e2:	7902                	ld	s2,32(sp)
    800034e4:	69e2                	ld	s3,24(sp)
    800034e6:	6a42                	ld	s4,16(sp)
    800034e8:	6121                	addi	sp,sp,64
    800034ea:	8082                	ret
    iput(ip);
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	a30080e7          	jalr	-1488(ra) # 80002f1c <iput>
    return -1;
    800034f4:	557d                	li	a0,-1
    800034f6:	b7dd                	j	800034dc <dirlink+0x86>
      panic("dirlink read");
    800034f8:	00005517          	auipc	a0,0x5
    800034fc:	09850513          	addi	a0,a0,152 # 80008590 <syscalls+0x1c8>
    80003500:	00003097          	auipc	ra,0x3
    80003504:	c4c080e7          	jalr	-948(ra) # 8000614c <panic>
    panic("dirlink");
    80003508:	00005517          	auipc	a0,0x5
    8000350c:	19850513          	addi	a0,a0,408 # 800086a0 <syscalls+0x2d8>
    80003510:	00003097          	auipc	ra,0x3
    80003514:	c3c080e7          	jalr	-964(ra) # 8000614c <panic>

0000000080003518 <namei>:

struct inode*
namei(char *path)
{
    80003518:	1101                	addi	sp,sp,-32
    8000351a:	ec06                	sd	ra,24(sp)
    8000351c:	e822                	sd	s0,16(sp)
    8000351e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003520:	fe040613          	addi	a2,s0,-32
    80003524:	4581                	li	a1,0
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	dd0080e7          	jalr	-560(ra) # 800032f6 <namex>
}
    8000352e:	60e2                	ld	ra,24(sp)
    80003530:	6442                	ld	s0,16(sp)
    80003532:	6105                	addi	sp,sp,32
    80003534:	8082                	ret

0000000080003536 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003536:	1141                	addi	sp,sp,-16
    80003538:	e406                	sd	ra,8(sp)
    8000353a:	e022                	sd	s0,0(sp)
    8000353c:	0800                	addi	s0,sp,16
    8000353e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003540:	4585                	li	a1,1
    80003542:	00000097          	auipc	ra,0x0
    80003546:	db4080e7          	jalr	-588(ra) # 800032f6 <namex>
}
    8000354a:	60a2                	ld	ra,8(sp)
    8000354c:	6402                	ld	s0,0(sp)
    8000354e:	0141                	addi	sp,sp,16
    80003550:	8082                	ret

0000000080003552 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003552:	1101                	addi	sp,sp,-32
    80003554:	ec06                	sd	ra,24(sp)
    80003556:	e822                	sd	s0,16(sp)
    80003558:	e426                	sd	s1,8(sp)
    8000355a:	e04a                	sd	s2,0(sp)
    8000355c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000355e:	00019917          	auipc	s2,0x19
    80003562:	7ea90913          	addi	s2,s2,2026 # 8001cd48 <log>
    80003566:	02092583          	lw	a1,32(s2)
    8000356a:	03092503          	lw	a0,48(s2)
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	f6a080e7          	jalr	-150(ra) # 800024d8 <bread>
    80003576:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003578:	03492683          	lw	a3,52(s2)
    8000357c:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000357e:	02d05763          	blez	a3,800035ac <write_head+0x5a>
    80003582:	00019797          	auipc	a5,0x19
    80003586:	7fe78793          	addi	a5,a5,2046 # 8001cd80 <log+0x38>
    8000358a:	06450713          	addi	a4,a0,100
    8000358e:	36fd                	addiw	a3,a3,-1
    80003590:	1682                	slli	a3,a3,0x20
    80003592:	9281                	srli	a3,a3,0x20
    80003594:	068a                	slli	a3,a3,0x2
    80003596:	00019617          	auipc	a2,0x19
    8000359a:	7ee60613          	addi	a2,a2,2030 # 8001cd84 <log+0x3c>
    8000359e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035a0:	4390                	lw	a2,0(a5)
    800035a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035a4:	0791                	addi	a5,a5,4
    800035a6:	0711                	addi	a4,a4,4
    800035a8:	fed79ce3          	bne	a5,a3,800035a0 <write_head+0x4e>
  }
  bwrite(buf);
    800035ac:	8526                	mv	a0,s1
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	1ba080e7          	jalr	442(ra) # 80002768 <bwrite>
  brelse(buf);
    800035b6:	8526                	mv	a0,s1
    800035b8:	fffff097          	auipc	ra,0xfffff
    800035bc:	df0080e7          	jalr	-528(ra) # 800023a8 <brelse>
}
    800035c0:	60e2                	ld	ra,24(sp)
    800035c2:	6442                	ld	s0,16(sp)
    800035c4:	64a2                	ld	s1,8(sp)
    800035c6:	6902                	ld	s2,0(sp)
    800035c8:	6105                	addi	sp,sp,32
    800035ca:	8082                	ret

00000000800035cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035cc:	00019797          	auipc	a5,0x19
    800035d0:	7b07a783          	lw	a5,1968(a5) # 8001cd7c <log+0x34>
    800035d4:	0af05d63          	blez	a5,8000368e <install_trans+0xc2>
{
    800035d8:	7139                	addi	sp,sp,-64
    800035da:	fc06                	sd	ra,56(sp)
    800035dc:	f822                	sd	s0,48(sp)
    800035de:	f426                	sd	s1,40(sp)
    800035e0:	f04a                	sd	s2,32(sp)
    800035e2:	ec4e                	sd	s3,24(sp)
    800035e4:	e852                	sd	s4,16(sp)
    800035e6:	e456                	sd	s5,8(sp)
    800035e8:	e05a                	sd	s6,0(sp)
    800035ea:	0080                	addi	s0,sp,64
    800035ec:	8b2a                	mv	s6,a0
    800035ee:	00019a97          	auipc	s5,0x19
    800035f2:	792a8a93          	addi	s5,s5,1938 # 8001cd80 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f8:	00019997          	auipc	s3,0x19
    800035fc:	75098993          	addi	s3,s3,1872 # 8001cd48 <log>
    80003600:	a035                	j	8000362c <install_trans+0x60>
      bunpin(dbuf);
    80003602:	8526                	mv	a0,s1
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	e78080e7          	jalr	-392(ra) # 8000247c <bunpin>
    brelse(lbuf);
    8000360c:	854a                	mv	a0,s2
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	d9a080e7          	jalr	-614(ra) # 800023a8 <brelse>
    brelse(dbuf);
    80003616:	8526                	mv	a0,s1
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	d90080e7          	jalr	-624(ra) # 800023a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003620:	2a05                	addiw	s4,s4,1
    80003622:	0a91                	addi	s5,s5,4
    80003624:	0349a783          	lw	a5,52(s3)
    80003628:	04fa5963          	bge	s4,a5,8000367a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000362c:	0209a583          	lw	a1,32(s3)
    80003630:	014585bb          	addw	a1,a1,s4
    80003634:	2585                	addiw	a1,a1,1
    80003636:	0309a503          	lw	a0,48(s3)
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	e9e080e7          	jalr	-354(ra) # 800024d8 <bread>
    80003642:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003644:	000aa583          	lw	a1,0(s5)
    80003648:	0309a503          	lw	a0,48(s3)
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	e8c080e7          	jalr	-372(ra) # 800024d8 <bread>
    80003654:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003656:	40000613          	li	a2,1024
    8000365a:	06090593          	addi	a1,s2,96
    8000365e:	06050513          	addi	a0,a0,96
    80003662:	ffffd097          	auipc	ra,0xffffd
    80003666:	c54080e7          	jalr	-940(ra) # 800002b6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000366a:	8526                	mv	a0,s1
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	0fc080e7          	jalr	252(ra) # 80002768 <bwrite>
    if(recovering == 0)
    80003674:	f80b1ce3          	bnez	s6,8000360c <install_trans+0x40>
    80003678:	b769                	j	80003602 <install_trans+0x36>
}
    8000367a:	70e2                	ld	ra,56(sp)
    8000367c:	7442                	ld	s0,48(sp)
    8000367e:	74a2                	ld	s1,40(sp)
    80003680:	7902                	ld	s2,32(sp)
    80003682:	69e2                	ld	s3,24(sp)
    80003684:	6a42                	ld	s4,16(sp)
    80003686:	6aa2                	ld	s5,8(sp)
    80003688:	6b02                	ld	s6,0(sp)
    8000368a:	6121                	addi	sp,sp,64
    8000368c:	8082                	ret
    8000368e:	8082                	ret

0000000080003690 <initlog>:
{
    80003690:	7179                	addi	sp,sp,-48
    80003692:	f406                	sd	ra,40(sp)
    80003694:	f022                	sd	s0,32(sp)
    80003696:	ec26                	sd	s1,24(sp)
    80003698:	e84a                	sd	s2,16(sp)
    8000369a:	e44e                	sd	s3,8(sp)
    8000369c:	1800                	addi	s0,sp,48
    8000369e:	892a                	mv	s2,a0
    800036a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036a2:	00019497          	auipc	s1,0x19
    800036a6:	6a648493          	addi	s1,s1,1702 # 8001cd48 <log>
    800036aa:	00005597          	auipc	a1,0x5
    800036ae:	ef658593          	addi	a1,a1,-266 # 800085a0 <syscalls+0x1d8>
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	148080e7          	jalr	328(ra) # 800067fc <initlock>
  log.start = sb->logstart;
    800036bc:	0149a583          	lw	a1,20(s3)
    800036c0:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800036c2:	0109a783          	lw	a5,16(s3)
    800036c6:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800036c8:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036cc:	854a                	mv	a0,s2
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	e0a080e7          	jalr	-502(ra) # 800024d8 <bread>
  log.lh.n = lh->n;
    800036d6:	513c                	lw	a5,96(a0)
    800036d8:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036da:	02f05563          	blez	a5,80003704 <initlog+0x74>
    800036de:	06450713          	addi	a4,a0,100
    800036e2:	00019697          	auipc	a3,0x19
    800036e6:	69e68693          	addi	a3,a3,1694 # 8001cd80 <log+0x38>
    800036ea:	37fd                	addiw	a5,a5,-1
    800036ec:	1782                	slli	a5,a5,0x20
    800036ee:	9381                	srli	a5,a5,0x20
    800036f0:	078a                	slli	a5,a5,0x2
    800036f2:	06850613          	addi	a2,a0,104
    800036f6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036f8:	4310                	lw	a2,0(a4)
    800036fa:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036fc:	0711                	addi	a4,a4,4
    800036fe:	0691                	addi	a3,a3,4
    80003700:	fef71ce3          	bne	a4,a5,800036f8 <initlog+0x68>
  brelse(buf);
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	ca4080e7          	jalr	-860(ra) # 800023a8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000370c:	4505                	li	a0,1
    8000370e:	00000097          	auipc	ra,0x0
    80003712:	ebe080e7          	jalr	-322(ra) # 800035cc <install_trans>
  log.lh.n = 0;
    80003716:	00019797          	auipc	a5,0x19
    8000371a:	6607a323          	sw	zero,1638(a5) # 8001cd7c <log+0x34>
  write_head(); // clear the log
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	e34080e7          	jalr	-460(ra) # 80003552 <write_head>
}
    80003726:	70a2                	ld	ra,40(sp)
    80003728:	7402                	ld	s0,32(sp)
    8000372a:	64e2                	ld	s1,24(sp)
    8000372c:	6942                	ld	s2,16(sp)
    8000372e:	69a2                	ld	s3,8(sp)
    80003730:	6145                	addi	sp,sp,48
    80003732:	8082                	ret

0000000080003734 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003734:	1101                	addi	sp,sp,-32
    80003736:	ec06                	sd	ra,24(sp)
    80003738:	e822                	sd	s0,16(sp)
    8000373a:	e426                	sd	s1,8(sp)
    8000373c:	e04a                	sd	s2,0(sp)
    8000373e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003740:	00019517          	auipc	a0,0x19
    80003744:	60850513          	addi	a0,a0,1544 # 8001cd48 <log>
    80003748:	00003097          	auipc	ra,0x3
    8000374c:	f38080e7          	jalr	-200(ra) # 80006680 <acquire>
  while(1){
    if(log.committing){
    80003750:	00019497          	auipc	s1,0x19
    80003754:	5f848493          	addi	s1,s1,1528 # 8001cd48 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003758:	4979                	li	s2,30
    8000375a:	a039                	j	80003768 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000375c:	85a6                	mv	a1,s1
    8000375e:	8526                	mv	a0,s1
    80003760:	ffffe097          	auipc	ra,0xffffe
    80003764:	e92080e7          	jalr	-366(ra) # 800015f2 <sleep>
    if(log.committing){
    80003768:	54dc                	lw	a5,44(s1)
    8000376a:	fbed                	bnez	a5,8000375c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000376c:	549c                	lw	a5,40(s1)
    8000376e:	0017871b          	addiw	a4,a5,1
    80003772:	0007069b          	sext.w	a3,a4
    80003776:	0027179b          	slliw	a5,a4,0x2
    8000377a:	9fb9                	addw	a5,a5,a4
    8000377c:	0017979b          	slliw	a5,a5,0x1
    80003780:	58d8                	lw	a4,52(s1)
    80003782:	9fb9                	addw	a5,a5,a4
    80003784:	00f95963          	bge	s2,a5,80003796 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003788:	85a6                	mv	a1,s1
    8000378a:	8526                	mv	a0,s1
    8000378c:	ffffe097          	auipc	ra,0xffffe
    80003790:	e66080e7          	jalr	-410(ra) # 800015f2 <sleep>
    80003794:	bfd1                	j	80003768 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003796:	00019517          	auipc	a0,0x19
    8000379a:	5b250513          	addi	a0,a0,1458 # 8001cd48 <log>
    8000379e:	d514                	sw	a3,40(a0)
      release(&log.lock);
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	fb0080e7          	jalr	-80(ra) # 80006750 <release>
      break;
    }
  }
}
    800037a8:	60e2                	ld	ra,24(sp)
    800037aa:	6442                	ld	s0,16(sp)
    800037ac:	64a2                	ld	s1,8(sp)
    800037ae:	6902                	ld	s2,0(sp)
    800037b0:	6105                	addi	sp,sp,32
    800037b2:	8082                	ret

00000000800037b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037b4:	7139                	addi	sp,sp,-64
    800037b6:	fc06                	sd	ra,56(sp)
    800037b8:	f822                	sd	s0,48(sp)
    800037ba:	f426                	sd	s1,40(sp)
    800037bc:	f04a                	sd	s2,32(sp)
    800037be:	ec4e                	sd	s3,24(sp)
    800037c0:	e852                	sd	s4,16(sp)
    800037c2:	e456                	sd	s5,8(sp)
    800037c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c6:	00019497          	auipc	s1,0x19
    800037ca:	58248493          	addi	s1,s1,1410 # 8001cd48 <log>
    800037ce:	8526                	mv	a0,s1
    800037d0:	00003097          	auipc	ra,0x3
    800037d4:	eb0080e7          	jalr	-336(ra) # 80006680 <acquire>
  log.outstanding -= 1;
    800037d8:	549c                	lw	a5,40(s1)
    800037da:	37fd                	addiw	a5,a5,-1
    800037dc:	0007891b          	sext.w	s2,a5
    800037e0:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800037e2:	54dc                	lw	a5,44(s1)
    800037e4:	efb9                	bnez	a5,80003842 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e6:	06091663          	bnez	s2,80003852 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037ea:	00019497          	auipc	s1,0x19
    800037ee:	55e48493          	addi	s1,s1,1374 # 8001cd48 <log>
    800037f2:	4785                	li	a5,1
    800037f4:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f6:	8526                	mv	a0,s1
    800037f8:	00003097          	auipc	ra,0x3
    800037fc:	f58080e7          	jalr	-168(ra) # 80006750 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003800:	58dc                	lw	a5,52(s1)
    80003802:	06f04763          	bgtz	a5,80003870 <end_op+0xbc>
    acquire(&log.lock);
    80003806:	00019497          	auipc	s1,0x19
    8000380a:	54248493          	addi	s1,s1,1346 # 8001cd48 <log>
    8000380e:	8526                	mv	a0,s1
    80003810:	00003097          	auipc	ra,0x3
    80003814:	e70080e7          	jalr	-400(ra) # 80006680 <acquire>
    log.committing = 0;
    80003818:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffffe097          	auipc	ra,0xffffe
    80003822:	f60080e7          	jalr	-160(ra) # 8000177e <wakeup>
    release(&log.lock);
    80003826:	8526                	mv	a0,s1
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	f28080e7          	jalr	-216(ra) # 80006750 <release>
}
    80003830:	70e2                	ld	ra,56(sp)
    80003832:	7442                	ld	s0,48(sp)
    80003834:	74a2                	ld	s1,40(sp)
    80003836:	7902                	ld	s2,32(sp)
    80003838:	69e2                	ld	s3,24(sp)
    8000383a:	6a42                	ld	s4,16(sp)
    8000383c:	6aa2                	ld	s5,8(sp)
    8000383e:	6121                	addi	sp,sp,64
    80003840:	8082                	ret
    panic("log.committing");
    80003842:	00005517          	auipc	a0,0x5
    80003846:	d6650513          	addi	a0,a0,-666 # 800085a8 <syscalls+0x1e0>
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	902080e7          	jalr	-1790(ra) # 8000614c <panic>
    wakeup(&log);
    80003852:	00019497          	auipc	s1,0x19
    80003856:	4f648493          	addi	s1,s1,1270 # 8001cd48 <log>
    8000385a:	8526                	mv	a0,s1
    8000385c:	ffffe097          	auipc	ra,0xffffe
    80003860:	f22080e7          	jalr	-222(ra) # 8000177e <wakeup>
  release(&log.lock);
    80003864:	8526                	mv	a0,s1
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	eea080e7          	jalr	-278(ra) # 80006750 <release>
  if(do_commit){
    8000386e:	b7c9                	j	80003830 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003870:	00019a97          	auipc	s5,0x19
    80003874:	510a8a93          	addi	s5,s5,1296 # 8001cd80 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003878:	00019a17          	auipc	s4,0x19
    8000387c:	4d0a0a13          	addi	s4,s4,1232 # 8001cd48 <log>
    80003880:	020a2583          	lw	a1,32(s4)
    80003884:	012585bb          	addw	a1,a1,s2
    80003888:	2585                	addiw	a1,a1,1
    8000388a:	030a2503          	lw	a0,48(s4)
    8000388e:	fffff097          	auipc	ra,0xfffff
    80003892:	c4a080e7          	jalr	-950(ra) # 800024d8 <bread>
    80003896:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003898:	000aa583          	lw	a1,0(s5)
    8000389c:	030a2503          	lw	a0,48(s4)
    800038a0:	fffff097          	auipc	ra,0xfffff
    800038a4:	c38080e7          	jalr	-968(ra) # 800024d8 <bread>
    800038a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038aa:	40000613          	li	a2,1024
    800038ae:	06050593          	addi	a1,a0,96
    800038b2:	06048513          	addi	a0,s1,96
    800038b6:	ffffd097          	auipc	ra,0xffffd
    800038ba:	a00080e7          	jalr	-1536(ra) # 800002b6 <memmove>
    bwrite(to);  // write the log
    800038be:	8526                	mv	a0,s1
    800038c0:	fffff097          	auipc	ra,0xfffff
    800038c4:	ea8080e7          	jalr	-344(ra) # 80002768 <bwrite>
    brelse(from);
    800038c8:	854e                	mv	a0,s3
    800038ca:	fffff097          	auipc	ra,0xfffff
    800038ce:	ade080e7          	jalr	-1314(ra) # 800023a8 <brelse>
    brelse(to);
    800038d2:	8526                	mv	a0,s1
    800038d4:	fffff097          	auipc	ra,0xfffff
    800038d8:	ad4080e7          	jalr	-1324(ra) # 800023a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038dc:	2905                	addiw	s2,s2,1
    800038de:	0a91                	addi	s5,s5,4
    800038e0:	034a2783          	lw	a5,52(s4)
    800038e4:	f8f94ee3          	blt	s2,a5,80003880 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	c6a080e7          	jalr	-918(ra) # 80003552 <write_head>
    install_trans(0); // Now install writes to home locations
    800038f0:	4501                	li	a0,0
    800038f2:	00000097          	auipc	ra,0x0
    800038f6:	cda080e7          	jalr	-806(ra) # 800035cc <install_trans>
    log.lh.n = 0;
    800038fa:	00019797          	auipc	a5,0x19
    800038fe:	4807a123          	sw	zero,1154(a5) # 8001cd7c <log+0x34>
    write_head();    // Erase the transaction from the log
    80003902:	00000097          	auipc	ra,0x0
    80003906:	c50080e7          	jalr	-944(ra) # 80003552 <write_head>
    8000390a:	bdf5                	j	80003806 <end_op+0x52>

000000008000390c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	e426                	sd	s1,8(sp)
    80003914:	e04a                	sd	s2,0(sp)
    80003916:	1000                	addi	s0,sp,32
    80003918:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000391a:	00019917          	auipc	s2,0x19
    8000391e:	42e90913          	addi	s2,s2,1070 # 8001cd48 <log>
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	d5c080e7          	jalr	-676(ra) # 80006680 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000392c:	03492603          	lw	a2,52(s2)
    80003930:	47f5                	li	a5,29
    80003932:	06c7c563          	blt	a5,a2,8000399c <log_write+0x90>
    80003936:	00019797          	auipc	a5,0x19
    8000393a:	4367a783          	lw	a5,1078(a5) # 8001cd6c <log+0x24>
    8000393e:	37fd                	addiw	a5,a5,-1
    80003940:	04f65e63          	bge	a2,a5,8000399c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003944:	00019797          	auipc	a5,0x19
    80003948:	42c7a783          	lw	a5,1068(a5) # 8001cd70 <log+0x28>
    8000394c:	06f05063          	blez	a5,800039ac <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003950:	4781                	li	a5,0
    80003952:	06c05563          	blez	a2,800039bc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003956:	44cc                	lw	a1,12(s1)
    80003958:	00019717          	auipc	a4,0x19
    8000395c:	42870713          	addi	a4,a4,1064 # 8001cd80 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003960:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003962:	4314                	lw	a3,0(a4)
    80003964:	04b68c63          	beq	a3,a1,800039bc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003968:	2785                	addiw	a5,a5,1
    8000396a:	0711                	addi	a4,a4,4
    8000396c:	fef61be3          	bne	a2,a5,80003962 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003970:	0631                	addi	a2,a2,12
    80003972:	060a                	slli	a2,a2,0x2
    80003974:	00019797          	auipc	a5,0x19
    80003978:	3d478793          	addi	a5,a5,980 # 8001cd48 <log>
    8000397c:	963e                	add	a2,a2,a5
    8000397e:	44dc                	lw	a5,12(s1)
    80003980:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003982:	8526                	mv	a0,s1
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	a9c080e7          	jalr	-1380(ra) # 80002420 <bpin>
    log.lh.n++;
    8000398c:	00019717          	auipc	a4,0x19
    80003990:	3bc70713          	addi	a4,a4,956 # 8001cd48 <log>
    80003994:	5b5c                	lw	a5,52(a4)
    80003996:	2785                	addiw	a5,a5,1
    80003998:	db5c                	sw	a5,52(a4)
    8000399a:	a835                	j	800039d6 <log_write+0xca>
    panic("too big a transaction");
    8000399c:	00005517          	auipc	a0,0x5
    800039a0:	c1c50513          	addi	a0,a0,-996 # 800085b8 <syscalls+0x1f0>
    800039a4:	00002097          	auipc	ra,0x2
    800039a8:	7a8080e7          	jalr	1960(ra) # 8000614c <panic>
    panic("log_write outside of trans");
    800039ac:	00005517          	auipc	a0,0x5
    800039b0:	c2450513          	addi	a0,a0,-988 # 800085d0 <syscalls+0x208>
    800039b4:	00002097          	auipc	ra,0x2
    800039b8:	798080e7          	jalr	1944(ra) # 8000614c <panic>
  log.lh.block[i] = b->blockno;
    800039bc:	00c78713          	addi	a4,a5,12
    800039c0:	00271693          	slli	a3,a4,0x2
    800039c4:	00019717          	auipc	a4,0x19
    800039c8:	38470713          	addi	a4,a4,900 # 8001cd48 <log>
    800039cc:	9736                	add	a4,a4,a3
    800039ce:	44d4                	lw	a3,12(s1)
    800039d0:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039d2:	faf608e3          	beq	a2,a5,80003982 <log_write+0x76>
  }
  release(&log.lock);
    800039d6:	00019517          	auipc	a0,0x19
    800039da:	37250513          	addi	a0,a0,882 # 8001cd48 <log>
    800039de:	00003097          	auipc	ra,0x3
    800039e2:	d72080e7          	jalr	-654(ra) # 80006750 <release>
}
    800039e6:	60e2                	ld	ra,24(sp)
    800039e8:	6442                	ld	s0,16(sp)
    800039ea:	64a2                	ld	s1,8(sp)
    800039ec:	6902                	ld	s2,0(sp)
    800039ee:	6105                	addi	sp,sp,32
    800039f0:	8082                	ret

00000000800039f2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039f2:	1101                	addi	sp,sp,-32
    800039f4:	ec06                	sd	ra,24(sp)
    800039f6:	e822                	sd	s0,16(sp)
    800039f8:	e426                	sd	s1,8(sp)
    800039fa:	e04a                	sd	s2,0(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
    80003a00:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a02:	00005597          	auipc	a1,0x5
    80003a06:	bee58593          	addi	a1,a1,-1042 # 800085f0 <syscalls+0x228>
    80003a0a:	0521                	addi	a0,a0,8
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	df0080e7          	jalr	-528(ra) # 800067fc <initlock>
  lk->name = name;
    80003a14:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003a18:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1c:	0204a823          	sw	zero,48(s1)
}
    80003a20:	60e2                	ld	ra,24(sp)
    80003a22:	6442                	ld	s0,16(sp)
    80003a24:	64a2                	ld	s1,8(sp)
    80003a26:	6902                	ld	s2,0(sp)
    80003a28:	6105                	addi	sp,sp,32
    80003a2a:	8082                	ret

0000000080003a2c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a2c:	1101                	addi	sp,sp,-32
    80003a2e:	ec06                	sd	ra,24(sp)
    80003a30:	e822                	sd	s0,16(sp)
    80003a32:	e426                	sd	s1,8(sp)
    80003a34:	e04a                	sd	s2,0(sp)
    80003a36:	1000                	addi	s0,sp,32
    80003a38:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a3a:	00850913          	addi	s2,a0,8
    80003a3e:	854a                	mv	a0,s2
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	c40080e7          	jalr	-960(ra) # 80006680 <acquire>
  while (lk->locked) {
    80003a48:	409c                	lw	a5,0(s1)
    80003a4a:	cb89                	beqz	a5,80003a5c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a4c:	85ca                	mv	a1,s2
    80003a4e:	8526                	mv	a0,s1
    80003a50:	ffffe097          	auipc	ra,0xffffe
    80003a54:	ba2080e7          	jalr	-1118(ra) # 800015f2 <sleep>
  while (lk->locked) {
    80003a58:	409c                	lw	a5,0(s1)
    80003a5a:	fbed                	bnez	a5,80003a4c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a5c:	4785                	li	a5,1
    80003a5e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a60:	ffffd097          	auipc	ra,0xffffd
    80003a64:	4d6080e7          	jalr	1238(ra) # 80000f36 <myproc>
    80003a68:	5d1c                	lw	a5,56(a0)
    80003a6a:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	ce2080e7          	jalr	-798(ra) # 80006750 <release>
}
    80003a76:	60e2                	ld	ra,24(sp)
    80003a78:	6442                	ld	s0,16(sp)
    80003a7a:	64a2                	ld	s1,8(sp)
    80003a7c:	6902                	ld	s2,0(sp)
    80003a7e:	6105                	addi	sp,sp,32
    80003a80:	8082                	ret

0000000080003a82 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a82:	1101                	addi	sp,sp,-32
    80003a84:	ec06                	sd	ra,24(sp)
    80003a86:	e822                	sd	s0,16(sp)
    80003a88:	e426                	sd	s1,8(sp)
    80003a8a:	e04a                	sd	s2,0(sp)
    80003a8c:	1000                	addi	s0,sp,32
    80003a8e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a90:	00850913          	addi	s2,a0,8
    80003a94:	854a                	mv	a0,s2
    80003a96:	00003097          	auipc	ra,0x3
    80003a9a:	bea080e7          	jalr	-1046(ra) # 80006680 <acquire>
  lk->locked = 0;
    80003a9e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa2:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003aa6:	8526                	mv	a0,s1
    80003aa8:	ffffe097          	auipc	ra,0xffffe
    80003aac:	cd6080e7          	jalr	-810(ra) # 8000177e <wakeup>
  release(&lk->lk);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	c9e080e7          	jalr	-866(ra) # 80006750 <release>
}
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6902                	ld	s2,0(sp)
    80003ac2:	6105                	addi	sp,sp,32
    80003ac4:	8082                	ret

0000000080003ac6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ac6:	7179                	addi	sp,sp,-48
    80003ac8:	f406                	sd	ra,40(sp)
    80003aca:	f022                	sd	s0,32(sp)
    80003acc:	ec26                	sd	s1,24(sp)
    80003ace:	e84a                	sd	s2,16(sp)
    80003ad0:	e44e                	sd	s3,8(sp)
    80003ad2:	1800                	addi	s0,sp,48
    80003ad4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad6:	00850913          	addi	s2,a0,8
    80003ada:	854a                	mv	a0,s2
    80003adc:	00003097          	auipc	ra,0x3
    80003ae0:	ba4080e7          	jalr	-1116(ra) # 80006680 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae4:	409c                	lw	a5,0(s1)
    80003ae6:	ef99                	bnez	a5,80003b04 <holdingsleep+0x3e>
    80003ae8:	4481                	li	s1,0
  release(&lk->lk);
    80003aea:	854a                	mv	a0,s2
    80003aec:	00003097          	auipc	ra,0x3
    80003af0:	c64080e7          	jalr	-924(ra) # 80006750 <release>
  return r;
}
    80003af4:	8526                	mv	a0,s1
    80003af6:	70a2                	ld	ra,40(sp)
    80003af8:	7402                	ld	s0,32(sp)
    80003afa:	64e2                	ld	s1,24(sp)
    80003afc:	6942                	ld	s2,16(sp)
    80003afe:	69a2                	ld	s3,8(sp)
    80003b00:	6145                	addi	sp,sp,48
    80003b02:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b04:	0304a983          	lw	s3,48(s1)
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	42e080e7          	jalr	1070(ra) # 80000f36 <myproc>
    80003b10:	5d04                	lw	s1,56(a0)
    80003b12:	413484b3          	sub	s1,s1,s3
    80003b16:	0014b493          	seqz	s1,s1
    80003b1a:	bfc1                	j	80003aea <holdingsleep+0x24>

0000000080003b1c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b1c:	1141                	addi	sp,sp,-16
    80003b1e:	e406                	sd	ra,8(sp)
    80003b20:	e022                	sd	s0,0(sp)
    80003b22:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b24:	00005597          	auipc	a1,0x5
    80003b28:	adc58593          	addi	a1,a1,-1316 # 80008600 <syscalls+0x238>
    80003b2c:	00019517          	auipc	a0,0x19
    80003b30:	36c50513          	addi	a0,a0,876 # 8001ce98 <ftable>
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	cc8080e7          	jalr	-824(ra) # 800067fc <initlock>
}
    80003b3c:	60a2                	ld	ra,8(sp)
    80003b3e:	6402                	ld	s0,0(sp)
    80003b40:	0141                	addi	sp,sp,16
    80003b42:	8082                	ret

0000000080003b44 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b44:	1101                	addi	sp,sp,-32
    80003b46:	ec06                	sd	ra,24(sp)
    80003b48:	e822                	sd	s0,16(sp)
    80003b4a:	e426                	sd	s1,8(sp)
    80003b4c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b4e:	00019517          	auipc	a0,0x19
    80003b52:	34a50513          	addi	a0,a0,842 # 8001ce98 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	b2a080e7          	jalr	-1238(ra) # 80006680 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b5e:	00019497          	auipc	s1,0x19
    80003b62:	35a48493          	addi	s1,s1,858 # 8001ceb8 <ftable+0x20>
    80003b66:	0001a717          	auipc	a4,0x1a
    80003b6a:	2f270713          	addi	a4,a4,754 # 8001de58 <ftable+0xfc0>
    if(f->ref == 0){
    80003b6e:	40dc                	lw	a5,4(s1)
    80003b70:	cf99                	beqz	a5,80003b8e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b72:	02848493          	addi	s1,s1,40
    80003b76:	fee49ce3          	bne	s1,a4,80003b6e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b7a:	00019517          	auipc	a0,0x19
    80003b7e:	31e50513          	addi	a0,a0,798 # 8001ce98 <ftable>
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	bce080e7          	jalr	-1074(ra) # 80006750 <release>
  return 0;
    80003b8a:	4481                	li	s1,0
    80003b8c:	a819                	j	80003ba2 <filealloc+0x5e>
      f->ref = 1;
    80003b8e:	4785                	li	a5,1
    80003b90:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b92:	00019517          	auipc	a0,0x19
    80003b96:	30650513          	addi	a0,a0,774 # 8001ce98 <ftable>
    80003b9a:	00003097          	auipc	ra,0x3
    80003b9e:	bb6080e7          	jalr	-1098(ra) # 80006750 <release>
}
    80003ba2:	8526                	mv	a0,s1
    80003ba4:	60e2                	ld	ra,24(sp)
    80003ba6:	6442                	ld	s0,16(sp)
    80003ba8:	64a2                	ld	s1,8(sp)
    80003baa:	6105                	addi	sp,sp,32
    80003bac:	8082                	ret

0000000080003bae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bae:	1101                	addi	sp,sp,-32
    80003bb0:	ec06                	sd	ra,24(sp)
    80003bb2:	e822                	sd	s0,16(sp)
    80003bb4:	e426                	sd	s1,8(sp)
    80003bb6:	1000                	addi	s0,sp,32
    80003bb8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bba:	00019517          	auipc	a0,0x19
    80003bbe:	2de50513          	addi	a0,a0,734 # 8001ce98 <ftable>
    80003bc2:	00003097          	auipc	ra,0x3
    80003bc6:	abe080e7          	jalr	-1346(ra) # 80006680 <acquire>
  if(f->ref < 1)
    80003bca:	40dc                	lw	a5,4(s1)
    80003bcc:	02f05263          	blez	a5,80003bf0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bd0:	2785                	addiw	a5,a5,1
    80003bd2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bd4:	00019517          	auipc	a0,0x19
    80003bd8:	2c450513          	addi	a0,a0,708 # 8001ce98 <ftable>
    80003bdc:	00003097          	auipc	ra,0x3
    80003be0:	b74080e7          	jalr	-1164(ra) # 80006750 <release>
  return f;
}
    80003be4:	8526                	mv	a0,s1
    80003be6:	60e2                	ld	ra,24(sp)
    80003be8:	6442                	ld	s0,16(sp)
    80003bea:	64a2                	ld	s1,8(sp)
    80003bec:	6105                	addi	sp,sp,32
    80003bee:	8082                	ret
    panic("filedup");
    80003bf0:	00005517          	auipc	a0,0x5
    80003bf4:	a1850513          	addi	a0,a0,-1512 # 80008608 <syscalls+0x240>
    80003bf8:	00002097          	auipc	ra,0x2
    80003bfc:	554080e7          	jalr	1364(ra) # 8000614c <panic>

0000000080003c00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c00:	7139                	addi	sp,sp,-64
    80003c02:	fc06                	sd	ra,56(sp)
    80003c04:	f822                	sd	s0,48(sp)
    80003c06:	f426                	sd	s1,40(sp)
    80003c08:	f04a                	sd	s2,32(sp)
    80003c0a:	ec4e                	sd	s3,24(sp)
    80003c0c:	e852                	sd	s4,16(sp)
    80003c0e:	e456                	sd	s5,8(sp)
    80003c10:	0080                	addi	s0,sp,64
    80003c12:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c14:	00019517          	auipc	a0,0x19
    80003c18:	28450513          	addi	a0,a0,644 # 8001ce98 <ftable>
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	a64080e7          	jalr	-1436(ra) # 80006680 <acquire>
  if(f->ref < 1)
    80003c24:	40dc                	lw	a5,4(s1)
    80003c26:	06f05163          	blez	a5,80003c88 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c2a:	37fd                	addiw	a5,a5,-1
    80003c2c:	0007871b          	sext.w	a4,a5
    80003c30:	c0dc                	sw	a5,4(s1)
    80003c32:	06e04363          	bgtz	a4,80003c98 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c36:	0004a903          	lw	s2,0(s1)
    80003c3a:	0094ca83          	lbu	s5,9(s1)
    80003c3e:	0104ba03          	ld	s4,16(s1)
    80003c42:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c46:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c4a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c4e:	00019517          	auipc	a0,0x19
    80003c52:	24a50513          	addi	a0,a0,586 # 8001ce98 <ftable>
    80003c56:	00003097          	auipc	ra,0x3
    80003c5a:	afa080e7          	jalr	-1286(ra) # 80006750 <release>

  if(ff.type == FD_PIPE){
    80003c5e:	4785                	li	a5,1
    80003c60:	04f90d63          	beq	s2,a5,80003cba <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c64:	3979                	addiw	s2,s2,-2
    80003c66:	4785                	li	a5,1
    80003c68:	0527e063          	bltu	a5,s2,80003ca8 <fileclose+0xa8>
    begin_op();
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	ac8080e7          	jalr	-1336(ra) # 80003734 <begin_op>
    iput(ff.ip);
    80003c74:	854e                	mv	a0,s3
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	2a6080e7          	jalr	678(ra) # 80002f1c <iput>
    end_op();
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	b36080e7          	jalr	-1226(ra) # 800037b4 <end_op>
    80003c86:	a00d                	j	80003ca8 <fileclose+0xa8>
    panic("fileclose");
    80003c88:	00005517          	auipc	a0,0x5
    80003c8c:	98850513          	addi	a0,a0,-1656 # 80008610 <syscalls+0x248>
    80003c90:	00002097          	auipc	ra,0x2
    80003c94:	4bc080e7          	jalr	1212(ra) # 8000614c <panic>
    release(&ftable.lock);
    80003c98:	00019517          	auipc	a0,0x19
    80003c9c:	20050513          	addi	a0,a0,512 # 8001ce98 <ftable>
    80003ca0:	00003097          	auipc	ra,0x3
    80003ca4:	ab0080e7          	jalr	-1360(ra) # 80006750 <release>
  }
}
    80003ca8:	70e2                	ld	ra,56(sp)
    80003caa:	7442                	ld	s0,48(sp)
    80003cac:	74a2                	ld	s1,40(sp)
    80003cae:	7902                	ld	s2,32(sp)
    80003cb0:	69e2                	ld	s3,24(sp)
    80003cb2:	6a42                	ld	s4,16(sp)
    80003cb4:	6aa2                	ld	s5,8(sp)
    80003cb6:	6121                	addi	sp,sp,64
    80003cb8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cba:	85d6                	mv	a1,s5
    80003cbc:	8552                	mv	a0,s4
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	34c080e7          	jalr	844(ra) # 8000400a <pipeclose>
    80003cc6:	b7cd                	j	80003ca8 <fileclose+0xa8>

0000000080003cc8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cc8:	715d                	addi	sp,sp,-80
    80003cca:	e486                	sd	ra,72(sp)
    80003ccc:	e0a2                	sd	s0,64(sp)
    80003cce:	fc26                	sd	s1,56(sp)
    80003cd0:	f84a                	sd	s2,48(sp)
    80003cd2:	f44e                	sd	s3,40(sp)
    80003cd4:	0880                	addi	s0,sp,80
    80003cd6:	84aa                	mv	s1,a0
    80003cd8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cda:	ffffd097          	auipc	ra,0xffffd
    80003cde:	25c080e7          	jalr	604(ra) # 80000f36 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ce2:	409c                	lw	a5,0(s1)
    80003ce4:	37f9                	addiw	a5,a5,-2
    80003ce6:	4705                	li	a4,1
    80003ce8:	04f76763          	bltu	a4,a5,80003d36 <filestat+0x6e>
    80003cec:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cee:	6c88                	ld	a0,24(s1)
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	072080e7          	jalr	114(ra) # 80002d62 <ilock>
    stati(f->ip, &st);
    80003cf8:	fb840593          	addi	a1,s0,-72
    80003cfc:	6c88                	ld	a0,24(s1)
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	2ee080e7          	jalr	750(ra) # 80002fec <stati>
    iunlock(f->ip);
    80003d06:	6c88                	ld	a0,24(s1)
    80003d08:	fffff097          	auipc	ra,0xfffff
    80003d0c:	11c080e7          	jalr	284(ra) # 80002e24 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d10:	46e1                	li	a3,24
    80003d12:	fb840613          	addi	a2,s0,-72
    80003d16:	85ce                	mv	a1,s3
    80003d18:	05893503          	ld	a0,88(s2)
    80003d1c:	ffffd097          	auipc	ra,0xffffd
    80003d20:	edc080e7          	jalr	-292(ra) # 80000bf8 <copyout>
    80003d24:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d28:	60a6                	ld	ra,72(sp)
    80003d2a:	6406                	ld	s0,64(sp)
    80003d2c:	74e2                	ld	s1,56(sp)
    80003d2e:	7942                	ld	s2,48(sp)
    80003d30:	79a2                	ld	s3,40(sp)
    80003d32:	6161                	addi	sp,sp,80
    80003d34:	8082                	ret
  return -1;
    80003d36:	557d                	li	a0,-1
    80003d38:	bfc5                	j	80003d28 <filestat+0x60>

0000000080003d3a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d3a:	7179                	addi	sp,sp,-48
    80003d3c:	f406                	sd	ra,40(sp)
    80003d3e:	f022                	sd	s0,32(sp)
    80003d40:	ec26                	sd	s1,24(sp)
    80003d42:	e84a                	sd	s2,16(sp)
    80003d44:	e44e                	sd	s3,8(sp)
    80003d46:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d48:	00854783          	lbu	a5,8(a0)
    80003d4c:	c3d5                	beqz	a5,80003df0 <fileread+0xb6>
    80003d4e:	84aa                	mv	s1,a0
    80003d50:	89ae                	mv	s3,a1
    80003d52:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d54:	411c                	lw	a5,0(a0)
    80003d56:	4705                	li	a4,1
    80003d58:	04e78963          	beq	a5,a4,80003daa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d5c:	470d                	li	a4,3
    80003d5e:	04e78d63          	beq	a5,a4,80003db8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d62:	4709                	li	a4,2
    80003d64:	06e79e63          	bne	a5,a4,80003de0 <fileread+0xa6>
    ilock(f->ip);
    80003d68:	6d08                	ld	a0,24(a0)
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	ff8080e7          	jalr	-8(ra) # 80002d62 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d72:	874a                	mv	a4,s2
    80003d74:	5094                	lw	a3,32(s1)
    80003d76:	864e                	mv	a2,s3
    80003d78:	4585                	li	a1,1
    80003d7a:	6c88                	ld	a0,24(s1)
    80003d7c:	fffff097          	auipc	ra,0xfffff
    80003d80:	29a080e7          	jalr	666(ra) # 80003016 <readi>
    80003d84:	892a                	mv	s2,a0
    80003d86:	00a05563          	blez	a0,80003d90 <fileread+0x56>
      f->off += r;
    80003d8a:	509c                	lw	a5,32(s1)
    80003d8c:	9fa9                	addw	a5,a5,a0
    80003d8e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d90:	6c88                	ld	a0,24(s1)
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	092080e7          	jalr	146(ra) # 80002e24 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d9a:	854a                	mv	a0,s2
    80003d9c:	70a2                	ld	ra,40(sp)
    80003d9e:	7402                	ld	s0,32(sp)
    80003da0:	64e2                	ld	s1,24(sp)
    80003da2:	6942                	ld	s2,16(sp)
    80003da4:	69a2                	ld	s3,8(sp)
    80003da6:	6145                	addi	sp,sp,48
    80003da8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003daa:	6908                	ld	a0,16(a0)
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	3d2080e7          	jalr	978(ra) # 8000417e <piperead>
    80003db4:	892a                	mv	s2,a0
    80003db6:	b7d5                	j	80003d9a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003db8:	02451783          	lh	a5,36(a0)
    80003dbc:	03079693          	slli	a3,a5,0x30
    80003dc0:	92c1                	srli	a3,a3,0x30
    80003dc2:	4725                	li	a4,9
    80003dc4:	02d76863          	bltu	a4,a3,80003df4 <fileread+0xba>
    80003dc8:	0792                	slli	a5,a5,0x4
    80003dca:	00019717          	auipc	a4,0x19
    80003dce:	02e70713          	addi	a4,a4,46 # 8001cdf8 <devsw>
    80003dd2:	97ba                	add	a5,a5,a4
    80003dd4:	639c                	ld	a5,0(a5)
    80003dd6:	c38d                	beqz	a5,80003df8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dd8:	4505                	li	a0,1
    80003dda:	9782                	jalr	a5
    80003ddc:	892a                	mv	s2,a0
    80003dde:	bf75                	j	80003d9a <fileread+0x60>
    panic("fileread");
    80003de0:	00005517          	auipc	a0,0x5
    80003de4:	84050513          	addi	a0,a0,-1984 # 80008620 <syscalls+0x258>
    80003de8:	00002097          	auipc	ra,0x2
    80003dec:	364080e7          	jalr	868(ra) # 8000614c <panic>
    return -1;
    80003df0:	597d                	li	s2,-1
    80003df2:	b765                	j	80003d9a <fileread+0x60>
      return -1;
    80003df4:	597d                	li	s2,-1
    80003df6:	b755                	j	80003d9a <fileread+0x60>
    80003df8:	597d                	li	s2,-1
    80003dfa:	b745                	j	80003d9a <fileread+0x60>

0000000080003dfc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dfc:	715d                	addi	sp,sp,-80
    80003dfe:	e486                	sd	ra,72(sp)
    80003e00:	e0a2                	sd	s0,64(sp)
    80003e02:	fc26                	sd	s1,56(sp)
    80003e04:	f84a                	sd	s2,48(sp)
    80003e06:	f44e                	sd	s3,40(sp)
    80003e08:	f052                	sd	s4,32(sp)
    80003e0a:	ec56                	sd	s5,24(sp)
    80003e0c:	e85a                	sd	s6,16(sp)
    80003e0e:	e45e                	sd	s7,8(sp)
    80003e10:	e062                	sd	s8,0(sp)
    80003e12:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e14:	00954783          	lbu	a5,9(a0)
    80003e18:	10078663          	beqz	a5,80003f24 <filewrite+0x128>
    80003e1c:	892a                	mv	s2,a0
    80003e1e:	8aae                	mv	s5,a1
    80003e20:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e22:	411c                	lw	a5,0(a0)
    80003e24:	4705                	li	a4,1
    80003e26:	02e78263          	beq	a5,a4,80003e4a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e2a:	470d                	li	a4,3
    80003e2c:	02e78663          	beq	a5,a4,80003e58 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e30:	4709                	li	a4,2
    80003e32:	0ee79163          	bne	a5,a4,80003f14 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e36:	0ac05d63          	blez	a2,80003ef0 <filewrite+0xf4>
    int i = 0;
    80003e3a:	4981                	li	s3,0
    80003e3c:	6b05                	lui	s6,0x1
    80003e3e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e42:	6b85                	lui	s7,0x1
    80003e44:	c00b8b9b          	addiw	s7,s7,-1024
    80003e48:	a861                	j	80003ee0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e4a:	6908                	ld	a0,16(a0)
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	238080e7          	jalr	568(ra) # 80004084 <pipewrite>
    80003e54:	8a2a                	mv	s4,a0
    80003e56:	a045                	j	80003ef6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e58:	02451783          	lh	a5,36(a0)
    80003e5c:	03079693          	slli	a3,a5,0x30
    80003e60:	92c1                	srli	a3,a3,0x30
    80003e62:	4725                	li	a4,9
    80003e64:	0cd76263          	bltu	a4,a3,80003f28 <filewrite+0x12c>
    80003e68:	0792                	slli	a5,a5,0x4
    80003e6a:	00019717          	auipc	a4,0x19
    80003e6e:	f8e70713          	addi	a4,a4,-114 # 8001cdf8 <devsw>
    80003e72:	97ba                	add	a5,a5,a4
    80003e74:	679c                	ld	a5,8(a5)
    80003e76:	cbdd                	beqz	a5,80003f2c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e78:	4505                	li	a0,1
    80003e7a:	9782                	jalr	a5
    80003e7c:	8a2a                	mv	s4,a0
    80003e7e:	a8a5                	j	80003ef6 <filewrite+0xfa>
    80003e80:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	8b0080e7          	jalr	-1872(ra) # 80003734 <begin_op>
      ilock(f->ip);
    80003e8c:	01893503          	ld	a0,24(s2)
    80003e90:	fffff097          	auipc	ra,0xfffff
    80003e94:	ed2080e7          	jalr	-302(ra) # 80002d62 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e98:	8762                	mv	a4,s8
    80003e9a:	02092683          	lw	a3,32(s2)
    80003e9e:	01598633          	add	a2,s3,s5
    80003ea2:	4585                	li	a1,1
    80003ea4:	01893503          	ld	a0,24(s2)
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	266080e7          	jalr	614(ra) # 8000310e <writei>
    80003eb0:	84aa                	mv	s1,a0
    80003eb2:	00a05763          	blez	a0,80003ec0 <filewrite+0xc4>
        f->off += r;
    80003eb6:	02092783          	lw	a5,32(s2)
    80003eba:	9fa9                	addw	a5,a5,a0
    80003ebc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ec0:	01893503          	ld	a0,24(s2)
    80003ec4:	fffff097          	auipc	ra,0xfffff
    80003ec8:	f60080e7          	jalr	-160(ra) # 80002e24 <iunlock>
      end_op();
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	8e8080e7          	jalr	-1816(ra) # 800037b4 <end_op>

      if(r != n1){
    80003ed4:	009c1f63          	bne	s8,s1,80003ef2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ed8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003edc:	0149db63          	bge	s3,s4,80003ef2 <filewrite+0xf6>
      int n1 = n - i;
    80003ee0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ee4:	84be                	mv	s1,a5
    80003ee6:	2781                	sext.w	a5,a5
    80003ee8:	f8fb5ce3          	bge	s6,a5,80003e80 <filewrite+0x84>
    80003eec:	84de                	mv	s1,s7
    80003eee:	bf49                	j	80003e80 <filewrite+0x84>
    int i = 0;
    80003ef0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ef2:	013a1f63          	bne	s4,s3,80003f10 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ef6:	8552                	mv	a0,s4
    80003ef8:	60a6                	ld	ra,72(sp)
    80003efa:	6406                	ld	s0,64(sp)
    80003efc:	74e2                	ld	s1,56(sp)
    80003efe:	7942                	ld	s2,48(sp)
    80003f00:	79a2                	ld	s3,40(sp)
    80003f02:	7a02                	ld	s4,32(sp)
    80003f04:	6ae2                	ld	s5,24(sp)
    80003f06:	6b42                	ld	s6,16(sp)
    80003f08:	6ba2                	ld	s7,8(sp)
    80003f0a:	6c02                	ld	s8,0(sp)
    80003f0c:	6161                	addi	sp,sp,80
    80003f0e:	8082                	ret
    ret = (i == n ? n : -1);
    80003f10:	5a7d                	li	s4,-1
    80003f12:	b7d5                	j	80003ef6 <filewrite+0xfa>
    panic("filewrite");
    80003f14:	00004517          	auipc	a0,0x4
    80003f18:	71c50513          	addi	a0,a0,1820 # 80008630 <syscalls+0x268>
    80003f1c:	00002097          	auipc	ra,0x2
    80003f20:	230080e7          	jalr	560(ra) # 8000614c <panic>
    return -1;
    80003f24:	5a7d                	li	s4,-1
    80003f26:	bfc1                	j	80003ef6 <filewrite+0xfa>
      return -1;
    80003f28:	5a7d                	li	s4,-1
    80003f2a:	b7f1                	j	80003ef6 <filewrite+0xfa>
    80003f2c:	5a7d                	li	s4,-1
    80003f2e:	b7e1                	j	80003ef6 <filewrite+0xfa>

0000000080003f30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f30:	7179                	addi	sp,sp,-48
    80003f32:	f406                	sd	ra,40(sp)
    80003f34:	f022                	sd	s0,32(sp)
    80003f36:	ec26                	sd	s1,24(sp)
    80003f38:	e84a                	sd	s2,16(sp)
    80003f3a:	e44e                	sd	s3,8(sp)
    80003f3c:	e052                	sd	s4,0(sp)
    80003f3e:	1800                	addi	s0,sp,48
    80003f40:	84aa                	mv	s1,a0
    80003f42:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f44:	0005b023          	sd	zero,0(a1)
    80003f48:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	bf8080e7          	jalr	-1032(ra) # 80003b44 <filealloc>
    80003f54:	e088                	sd	a0,0(s1)
    80003f56:	c551                	beqz	a0,80003fe2 <pipealloc+0xb2>
    80003f58:	00000097          	auipc	ra,0x0
    80003f5c:	bec080e7          	jalr	-1044(ra) # 80003b44 <filealloc>
    80003f60:	00aa3023          	sd	a0,0(s4)
    80003f64:	c92d                	beqz	a0,80003fd6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f66:	ffffc097          	auipc	ra,0xffffc
    80003f6a:	206080e7          	jalr	518(ra) # 8000016c <kalloc>
    80003f6e:	892a                	mv	s2,a0
    80003f70:	c125                	beqz	a0,80003fd0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f72:	4985                	li	s3,1
    80003f74:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003f78:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003f7c:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003f80:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003f84:	00004597          	auipc	a1,0x4
    80003f88:	6bc58593          	addi	a1,a1,1724 # 80008640 <syscalls+0x278>
    80003f8c:	00003097          	auipc	ra,0x3
    80003f90:	870080e7          	jalr	-1936(ra) # 800067fc <initlock>
  (*f0)->type = FD_PIPE;
    80003f94:	609c                	ld	a5,0(s1)
    80003f96:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f9a:	609c                	ld	a5,0(s1)
    80003f9c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fa0:	609c                	ld	a5,0(s1)
    80003fa2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fa6:	609c                	ld	a5,0(s1)
    80003fa8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fac:	000a3783          	ld	a5,0(s4)
    80003fb0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fb4:	000a3783          	ld	a5,0(s4)
    80003fb8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fbc:	000a3783          	ld	a5,0(s4)
    80003fc0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fc4:	000a3783          	ld	a5,0(s4)
    80003fc8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fcc:	4501                	li	a0,0
    80003fce:	a025                	j	80003ff6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fd0:	6088                	ld	a0,0(s1)
    80003fd2:	e501                	bnez	a0,80003fda <pipealloc+0xaa>
    80003fd4:	a039                	j	80003fe2 <pipealloc+0xb2>
    80003fd6:	6088                	ld	a0,0(s1)
    80003fd8:	c51d                	beqz	a0,80004006 <pipealloc+0xd6>
    fileclose(*f0);
    80003fda:	00000097          	auipc	ra,0x0
    80003fde:	c26080e7          	jalr	-986(ra) # 80003c00 <fileclose>
  if(*f1)
    80003fe2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fe6:	557d                	li	a0,-1
  if(*f1)
    80003fe8:	c799                	beqz	a5,80003ff6 <pipealloc+0xc6>
    fileclose(*f1);
    80003fea:	853e                	mv	a0,a5
    80003fec:	00000097          	auipc	ra,0x0
    80003ff0:	c14080e7          	jalr	-1004(ra) # 80003c00 <fileclose>
  return -1;
    80003ff4:	557d                	li	a0,-1
}
    80003ff6:	70a2                	ld	ra,40(sp)
    80003ff8:	7402                	ld	s0,32(sp)
    80003ffa:	64e2                	ld	s1,24(sp)
    80003ffc:	6942                	ld	s2,16(sp)
    80003ffe:	69a2                	ld	s3,8(sp)
    80004000:	6a02                	ld	s4,0(sp)
    80004002:	6145                	addi	sp,sp,48
    80004004:	8082                	ret
  return -1;
    80004006:	557d                	li	a0,-1
    80004008:	b7fd                	j	80003ff6 <pipealloc+0xc6>

000000008000400a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000400a:	1101                	addi	sp,sp,-32
    8000400c:	ec06                	sd	ra,24(sp)
    8000400e:	e822                	sd	s0,16(sp)
    80004010:	e426                	sd	s1,8(sp)
    80004012:	e04a                	sd	s2,0(sp)
    80004014:	1000                	addi	s0,sp,32
    80004016:	84aa                	mv	s1,a0
    80004018:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000401a:	00002097          	auipc	ra,0x2
    8000401e:	666080e7          	jalr	1638(ra) # 80006680 <acquire>
  if(writable){
    80004022:	04090263          	beqz	s2,80004066 <pipeclose+0x5c>
    pi->writeopen = 0;
    80004026:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    8000402a:	22048513          	addi	a0,s1,544
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	750080e7          	jalr	1872(ra) # 8000177e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004036:	2284b783          	ld	a5,552(s1)
    8000403a:	ef9d                	bnez	a5,80004078 <pipeclose+0x6e>
    release(&pi->lock);
    8000403c:	8526                	mv	a0,s1
    8000403e:	00002097          	auipc	ra,0x2
    80004042:	712080e7          	jalr	1810(ra) # 80006750 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    80004046:	8526                	mv	a0,s1
    80004048:	00002097          	auipc	ra,0x2
    8000404c:	750080e7          	jalr	1872(ra) # 80006798 <freelock>
#endif    
    kfree((char*)pi);
    80004050:	8526                	mv	a0,s1
    80004052:	ffffc097          	auipc	ra,0xffffc
    80004056:	fca080e7          	jalr	-54(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000405a:	60e2                	ld	ra,24(sp)
    8000405c:	6442                	ld	s0,16(sp)
    8000405e:	64a2                	ld	s1,8(sp)
    80004060:	6902                	ld	s2,0(sp)
    80004062:	6105                	addi	sp,sp,32
    80004064:	8082                	ret
    pi->readopen = 0;
    80004066:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    8000406a:	22448513          	addi	a0,s1,548
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	710080e7          	jalr	1808(ra) # 8000177e <wakeup>
    80004076:	b7c1                	j	80004036 <pipeclose+0x2c>
    release(&pi->lock);
    80004078:	8526                	mv	a0,s1
    8000407a:	00002097          	auipc	ra,0x2
    8000407e:	6d6080e7          	jalr	1750(ra) # 80006750 <release>
}
    80004082:	bfe1                	j	8000405a <pipeclose+0x50>

0000000080004084 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004084:	7159                	addi	sp,sp,-112
    80004086:	f486                	sd	ra,104(sp)
    80004088:	f0a2                	sd	s0,96(sp)
    8000408a:	eca6                	sd	s1,88(sp)
    8000408c:	e8ca                	sd	s2,80(sp)
    8000408e:	e4ce                	sd	s3,72(sp)
    80004090:	e0d2                	sd	s4,64(sp)
    80004092:	fc56                	sd	s5,56(sp)
    80004094:	f85a                	sd	s6,48(sp)
    80004096:	f45e                	sd	s7,40(sp)
    80004098:	f062                	sd	s8,32(sp)
    8000409a:	ec66                	sd	s9,24(sp)
    8000409c:	1880                	addi	s0,sp,112
    8000409e:	84aa                	mv	s1,a0
    800040a0:	8aae                	mv	s5,a1
    800040a2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	e92080e7          	jalr	-366(ra) # 80000f36 <myproc>
    800040ac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	5d0080e7          	jalr	1488(ra) # 80006680 <acquire>
  while(i < n){
    800040b8:	0d405163          	blez	s4,8000417a <pipewrite+0xf6>
    800040bc:	8ba6                	mv	s7,s1
  int i = 0;
    800040be:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040c0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040c2:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800040c6:	22448c13          	addi	s8,s1,548
    800040ca:	a08d                	j	8000412c <pipewrite+0xa8>
      release(&pi->lock);
    800040cc:	8526                	mv	a0,s1
    800040ce:	00002097          	auipc	ra,0x2
    800040d2:	682080e7          	jalr	1666(ra) # 80006750 <release>
      return -1;
    800040d6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040d8:	854a                	mv	a0,s2
    800040da:	70a6                	ld	ra,104(sp)
    800040dc:	7406                	ld	s0,96(sp)
    800040de:	64e6                	ld	s1,88(sp)
    800040e0:	6946                	ld	s2,80(sp)
    800040e2:	69a6                	ld	s3,72(sp)
    800040e4:	6a06                	ld	s4,64(sp)
    800040e6:	7ae2                	ld	s5,56(sp)
    800040e8:	7b42                	ld	s6,48(sp)
    800040ea:	7ba2                	ld	s7,40(sp)
    800040ec:	7c02                	ld	s8,32(sp)
    800040ee:	6ce2                	ld	s9,24(sp)
    800040f0:	6165                	addi	sp,sp,112
    800040f2:	8082                	ret
      wakeup(&pi->nread);
    800040f4:	8566                	mv	a0,s9
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	688080e7          	jalr	1672(ra) # 8000177e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040fe:	85de                	mv	a1,s7
    80004100:	8562                	mv	a0,s8
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	4f0080e7          	jalr	1264(ra) # 800015f2 <sleep>
    8000410a:	a839                	j	80004128 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000410c:	2244a783          	lw	a5,548(s1)
    80004110:	0017871b          	addiw	a4,a5,1
    80004114:	22e4a223          	sw	a4,548(s1)
    80004118:	1ff7f793          	andi	a5,a5,511
    8000411c:	97a6                	add	a5,a5,s1
    8000411e:	f9f44703          	lbu	a4,-97(s0)
    80004122:	02e78023          	sb	a4,32(a5)
      i++;
    80004126:	2905                	addiw	s2,s2,1
  while(i < n){
    80004128:	03495d63          	bge	s2,s4,80004162 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000412c:	2284a783          	lw	a5,552(s1)
    80004130:	dfd1                	beqz	a5,800040cc <pipewrite+0x48>
    80004132:	0309a783          	lw	a5,48(s3)
    80004136:	fbd9                	bnez	a5,800040cc <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004138:	2204a783          	lw	a5,544(s1)
    8000413c:	2244a703          	lw	a4,548(s1)
    80004140:	2007879b          	addiw	a5,a5,512
    80004144:	faf708e3          	beq	a4,a5,800040f4 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004148:	4685                	li	a3,1
    8000414a:	01590633          	add	a2,s2,s5
    8000414e:	f9f40593          	addi	a1,s0,-97
    80004152:	0589b503          	ld	a0,88(s3)
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	b2e080e7          	jalr	-1234(ra) # 80000c84 <copyin>
    8000415e:	fb6517e3          	bne	a0,s6,8000410c <pipewrite+0x88>
  wakeup(&pi->nread);
    80004162:	22048513          	addi	a0,s1,544
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	618080e7          	jalr	1560(ra) # 8000177e <wakeup>
  release(&pi->lock);
    8000416e:	8526                	mv	a0,s1
    80004170:	00002097          	auipc	ra,0x2
    80004174:	5e0080e7          	jalr	1504(ra) # 80006750 <release>
  return i;
    80004178:	b785                	j	800040d8 <pipewrite+0x54>
  int i = 0;
    8000417a:	4901                	li	s2,0
    8000417c:	b7dd                	j	80004162 <pipewrite+0xde>

000000008000417e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000417e:	715d                	addi	sp,sp,-80
    80004180:	e486                	sd	ra,72(sp)
    80004182:	e0a2                	sd	s0,64(sp)
    80004184:	fc26                	sd	s1,56(sp)
    80004186:	f84a                	sd	s2,48(sp)
    80004188:	f44e                	sd	s3,40(sp)
    8000418a:	f052                	sd	s4,32(sp)
    8000418c:	ec56                	sd	s5,24(sp)
    8000418e:	e85a                	sd	s6,16(sp)
    80004190:	0880                	addi	s0,sp,80
    80004192:	84aa                	mv	s1,a0
    80004194:	892e                	mv	s2,a1
    80004196:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	d9e080e7          	jalr	-610(ra) # 80000f36 <myproc>
    800041a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041a2:	8b26                	mv	s6,s1
    800041a4:	8526                	mv	a0,s1
    800041a6:	00002097          	auipc	ra,0x2
    800041aa:	4da080e7          	jalr	1242(ra) # 80006680 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ae:	2204a703          	lw	a4,544(s1)
    800041b2:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b6:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ba:	02f71463          	bne	a4,a5,800041e2 <piperead+0x64>
    800041be:	22c4a783          	lw	a5,556(s1)
    800041c2:	c385                	beqz	a5,800041e2 <piperead+0x64>
    if(pr->killed){
    800041c4:	030a2783          	lw	a5,48(s4)
    800041c8:	ebc1                	bnez	a5,80004258 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ca:	85da                	mv	a1,s6
    800041cc:	854e                	mv	a0,s3
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	424080e7          	jalr	1060(ra) # 800015f2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d6:	2204a703          	lw	a4,544(s1)
    800041da:	2244a783          	lw	a5,548(s1)
    800041de:	fef700e3          	beq	a4,a5,800041be <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e2:	09505263          	blez	s5,80004266 <piperead+0xe8>
    800041e6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041e8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041ea:	2204a783          	lw	a5,544(s1)
    800041ee:	2244a703          	lw	a4,548(s1)
    800041f2:	02f70d63          	beq	a4,a5,8000422c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041f6:	0017871b          	addiw	a4,a5,1
    800041fa:	22e4a023          	sw	a4,544(s1)
    800041fe:	1ff7f793          	andi	a5,a5,511
    80004202:	97a6                	add	a5,a5,s1
    80004204:	0207c783          	lbu	a5,32(a5)
    80004208:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000420c:	4685                	li	a3,1
    8000420e:	fbf40613          	addi	a2,s0,-65
    80004212:	85ca                	mv	a1,s2
    80004214:	058a3503          	ld	a0,88(s4)
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	9e0080e7          	jalr	-1568(ra) # 80000bf8 <copyout>
    80004220:	01650663          	beq	a0,s6,8000422c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004224:	2985                	addiw	s3,s3,1
    80004226:	0905                	addi	s2,s2,1
    80004228:	fd3a91e3          	bne	s5,s3,800041ea <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000422c:	22448513          	addi	a0,s1,548
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	54e080e7          	jalr	1358(ra) # 8000177e <wakeup>
  release(&pi->lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	516080e7          	jalr	1302(ra) # 80006750 <release>
  return i;
}
    80004242:	854e                	mv	a0,s3
    80004244:	60a6                	ld	ra,72(sp)
    80004246:	6406                	ld	s0,64(sp)
    80004248:	74e2                	ld	s1,56(sp)
    8000424a:	7942                	ld	s2,48(sp)
    8000424c:	79a2                	ld	s3,40(sp)
    8000424e:	7a02                	ld	s4,32(sp)
    80004250:	6ae2                	ld	s5,24(sp)
    80004252:	6b42                	ld	s6,16(sp)
    80004254:	6161                	addi	sp,sp,80
    80004256:	8082                	ret
      release(&pi->lock);
    80004258:	8526                	mv	a0,s1
    8000425a:	00002097          	auipc	ra,0x2
    8000425e:	4f6080e7          	jalr	1270(ra) # 80006750 <release>
      return -1;
    80004262:	59fd                	li	s3,-1
    80004264:	bff9                	j	80004242 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004266:	4981                	li	s3,0
    80004268:	b7d1                	j	8000422c <piperead+0xae>

000000008000426a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000426a:	df010113          	addi	sp,sp,-528
    8000426e:	20113423          	sd	ra,520(sp)
    80004272:	20813023          	sd	s0,512(sp)
    80004276:	ffa6                	sd	s1,504(sp)
    80004278:	fbca                	sd	s2,496(sp)
    8000427a:	f7ce                	sd	s3,488(sp)
    8000427c:	f3d2                	sd	s4,480(sp)
    8000427e:	efd6                	sd	s5,472(sp)
    80004280:	ebda                	sd	s6,464(sp)
    80004282:	e7de                	sd	s7,456(sp)
    80004284:	e3e2                	sd	s8,448(sp)
    80004286:	ff66                	sd	s9,440(sp)
    80004288:	fb6a                	sd	s10,432(sp)
    8000428a:	f76e                	sd	s11,424(sp)
    8000428c:	0c00                	addi	s0,sp,528
    8000428e:	84aa                	mv	s1,a0
    80004290:	dea43c23          	sd	a0,-520(s0)
    80004294:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	c9e080e7          	jalr	-866(ra) # 80000f36 <myproc>
    800042a0:	892a                	mv	s2,a0

  begin_op();
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	492080e7          	jalr	1170(ra) # 80003734 <begin_op>

  if((ip = namei(path)) == 0){
    800042aa:	8526                	mv	a0,s1
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	26c080e7          	jalr	620(ra) # 80003518 <namei>
    800042b4:	c92d                	beqz	a0,80004326 <exec+0xbc>
    800042b6:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	aaa080e7          	jalr	-1366(ra) # 80002d62 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042c0:	04000713          	li	a4,64
    800042c4:	4681                	li	a3,0
    800042c6:	e5040613          	addi	a2,s0,-432
    800042ca:	4581                	li	a1,0
    800042cc:	8526                	mv	a0,s1
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	d48080e7          	jalr	-696(ra) # 80003016 <readi>
    800042d6:	04000793          	li	a5,64
    800042da:	00f51a63          	bne	a0,a5,800042ee <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042de:	e5042703          	lw	a4,-432(s0)
    800042e2:	464c47b7          	lui	a5,0x464c4
    800042e6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ea:	04f70463          	beq	a4,a5,80004332 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042ee:	8526                	mv	a0,s1
    800042f0:	fffff097          	auipc	ra,0xfffff
    800042f4:	cd4080e7          	jalr	-812(ra) # 80002fc4 <iunlockput>
    end_op();
    800042f8:	fffff097          	auipc	ra,0xfffff
    800042fc:	4bc080e7          	jalr	1212(ra) # 800037b4 <end_op>
  }
  return -1;
    80004300:	557d                	li	a0,-1
}
    80004302:	20813083          	ld	ra,520(sp)
    80004306:	20013403          	ld	s0,512(sp)
    8000430a:	74fe                	ld	s1,504(sp)
    8000430c:	795e                	ld	s2,496(sp)
    8000430e:	79be                	ld	s3,488(sp)
    80004310:	7a1e                	ld	s4,480(sp)
    80004312:	6afe                	ld	s5,472(sp)
    80004314:	6b5e                	ld	s6,464(sp)
    80004316:	6bbe                	ld	s7,456(sp)
    80004318:	6c1e                	ld	s8,448(sp)
    8000431a:	7cfa                	ld	s9,440(sp)
    8000431c:	7d5a                	ld	s10,432(sp)
    8000431e:	7dba                	ld	s11,424(sp)
    80004320:	21010113          	addi	sp,sp,528
    80004324:	8082                	ret
    end_op();
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	48e080e7          	jalr	1166(ra) # 800037b4 <end_op>
    return -1;
    8000432e:	557d                	li	a0,-1
    80004330:	bfc9                	j	80004302 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004332:	854a                	mv	a0,s2
    80004334:	ffffd097          	auipc	ra,0xffffd
    80004338:	cc6080e7          	jalr	-826(ra) # 80000ffa <proc_pagetable>
    8000433c:	8baa                	mv	s7,a0
    8000433e:	d945                	beqz	a0,800042ee <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004340:	e7042983          	lw	s3,-400(s0)
    80004344:	e8845783          	lhu	a5,-376(s0)
    80004348:	c7ad                	beqz	a5,800043b2 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000434a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000434c:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000434e:	6c85                	lui	s9,0x1
    80004350:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004354:	def43823          	sd	a5,-528(s0)
    80004358:	a42d                	j	80004582 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000435a:	00004517          	auipc	a0,0x4
    8000435e:	2ee50513          	addi	a0,a0,750 # 80008648 <syscalls+0x280>
    80004362:	00002097          	auipc	ra,0x2
    80004366:	dea080e7          	jalr	-534(ra) # 8000614c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000436a:	8756                	mv	a4,s5
    8000436c:	012d86bb          	addw	a3,s11,s2
    80004370:	4581                	li	a1,0
    80004372:	8526                	mv	a0,s1
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	ca2080e7          	jalr	-862(ra) # 80003016 <readi>
    8000437c:	2501                	sext.w	a0,a0
    8000437e:	1aaa9963          	bne	s5,a0,80004530 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004382:	6785                	lui	a5,0x1
    80004384:	0127893b          	addw	s2,a5,s2
    80004388:	77fd                	lui	a5,0xfffff
    8000438a:	01478a3b          	addw	s4,a5,s4
    8000438e:	1f897163          	bgeu	s2,s8,80004570 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004392:	02091593          	slli	a1,s2,0x20
    80004396:	9181                	srli	a1,a1,0x20
    80004398:	95ea                	add	a1,a1,s10
    8000439a:	855e                	mv	a0,s7
    8000439c:	ffffc097          	auipc	ra,0xffffc
    800043a0:	258080e7          	jalr	600(ra) # 800005f4 <walkaddr>
    800043a4:	862a                	mv	a2,a0
    if(pa == 0)
    800043a6:	d955                	beqz	a0,8000435a <exec+0xf0>
      n = PGSIZE;
    800043a8:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043aa:	fd9a70e3          	bgeu	s4,s9,8000436a <exec+0x100>
      n = sz - i;
    800043ae:	8ad2                	mv	s5,s4
    800043b0:	bf6d                	j	8000436a <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b2:	4901                	li	s2,0
  iunlockput(ip);
    800043b4:	8526                	mv	a0,s1
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	c0e080e7          	jalr	-1010(ra) # 80002fc4 <iunlockput>
  end_op();
    800043be:	fffff097          	auipc	ra,0xfffff
    800043c2:	3f6080e7          	jalr	1014(ra) # 800037b4 <end_op>
  p = myproc();
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	b70080e7          	jalr	-1168(ra) # 80000f36 <myproc>
    800043ce:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043d0:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800043d4:	6785                	lui	a5,0x1
    800043d6:	17fd                	addi	a5,a5,-1
    800043d8:	993e                	add	s2,s2,a5
    800043da:	757d                	lui	a0,0xfffff
    800043dc:	00a977b3          	and	a5,s2,a0
    800043e0:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043e4:	6609                	lui	a2,0x2
    800043e6:	963e                	add	a2,a2,a5
    800043e8:	85be                	mv	a1,a5
    800043ea:	855e                	mv	a0,s7
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	5bc080e7          	jalr	1468(ra) # 800009a8 <uvmalloc>
    800043f4:	8b2a                	mv	s6,a0
  ip = 0;
    800043f6:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043f8:	12050c63          	beqz	a0,80004530 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043fc:	75f9                	lui	a1,0xffffe
    800043fe:	95aa                	add	a1,a1,a0
    80004400:	855e                	mv	a0,s7
    80004402:	ffffc097          	auipc	ra,0xffffc
    80004406:	7c4080e7          	jalr	1988(ra) # 80000bc6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000440a:	7c7d                	lui	s8,0xfffff
    8000440c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000440e:	e0043783          	ld	a5,-512(s0)
    80004412:	6388                	ld	a0,0(a5)
    80004414:	c535                	beqz	a0,80004480 <exec+0x216>
    80004416:	e9040993          	addi	s3,s0,-368
    8000441a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000441e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004420:	ffffc097          	auipc	ra,0xffffc
    80004424:	fba080e7          	jalr	-70(ra) # 800003da <strlen>
    80004428:	2505                	addiw	a0,a0,1
    8000442a:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000442e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004432:	13896363          	bltu	s2,s8,80004558 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004436:	e0043d83          	ld	s11,-512(s0)
    8000443a:	000dba03          	ld	s4,0(s11)
    8000443e:	8552                	mv	a0,s4
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	f9a080e7          	jalr	-102(ra) # 800003da <strlen>
    80004448:	0015069b          	addiw	a3,a0,1
    8000444c:	8652                	mv	a2,s4
    8000444e:	85ca                	mv	a1,s2
    80004450:	855e                	mv	a0,s7
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	7a6080e7          	jalr	1958(ra) # 80000bf8 <copyout>
    8000445a:	10054363          	bltz	a0,80004560 <exec+0x2f6>
    ustack[argc] = sp;
    8000445e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004462:	0485                	addi	s1,s1,1
    80004464:	008d8793          	addi	a5,s11,8
    80004468:	e0f43023          	sd	a5,-512(s0)
    8000446c:	008db503          	ld	a0,8(s11)
    80004470:	c911                	beqz	a0,80004484 <exec+0x21a>
    if(argc >= MAXARG)
    80004472:	09a1                	addi	s3,s3,8
    80004474:	fb3c96e3          	bne	s9,s3,80004420 <exec+0x1b6>
  sz = sz1;
    80004478:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000447c:	4481                	li	s1,0
    8000447e:	a84d                	j	80004530 <exec+0x2c6>
  sp = sz;
    80004480:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004482:	4481                	li	s1,0
  ustack[argc] = 0;
    80004484:	00349793          	slli	a5,s1,0x3
    80004488:	f9040713          	addi	a4,s0,-112
    8000448c:	97ba                	add	a5,a5,a4
    8000448e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004492:	00148693          	addi	a3,s1,1
    80004496:	068e                	slli	a3,a3,0x3
    80004498:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000449c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044a0:	01897663          	bgeu	s2,s8,800044ac <exec+0x242>
  sz = sz1;
    800044a4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a8:	4481                	li	s1,0
    800044aa:	a059                	j	80004530 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044ac:	e9040613          	addi	a2,s0,-368
    800044b0:	85ca                	mv	a1,s2
    800044b2:	855e                	mv	a0,s7
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	744080e7          	jalr	1860(ra) # 80000bf8 <copyout>
    800044bc:	0a054663          	bltz	a0,80004568 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044c0:	060ab783          	ld	a5,96(s5)
    800044c4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044c8:	df843783          	ld	a5,-520(s0)
    800044cc:	0007c703          	lbu	a4,0(a5)
    800044d0:	cf11                	beqz	a4,800044ec <exec+0x282>
    800044d2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044d4:	02f00693          	li	a3,47
    800044d8:	a039                	j	800044e6 <exec+0x27c>
      last = s+1;
    800044da:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044de:	0785                	addi	a5,a5,1
    800044e0:	fff7c703          	lbu	a4,-1(a5)
    800044e4:	c701                	beqz	a4,800044ec <exec+0x282>
    if(*s == '/')
    800044e6:	fed71ce3          	bne	a4,a3,800044de <exec+0x274>
    800044ea:	bfc5                	j	800044da <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800044ec:	4641                	li	a2,16
    800044ee:	df843583          	ld	a1,-520(s0)
    800044f2:	160a8513          	addi	a0,s5,352
    800044f6:	ffffc097          	auipc	ra,0xffffc
    800044fa:	eb2080e7          	jalr	-334(ra) # 800003a8 <safestrcpy>
  oldpagetable = p->pagetable;
    800044fe:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004502:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    80004506:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000450a:	060ab783          	ld	a5,96(s5)
    8000450e:	e6843703          	ld	a4,-408(s0)
    80004512:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004514:	060ab783          	ld	a5,96(s5)
    80004518:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000451c:	85ea                	mv	a1,s10
    8000451e:	ffffd097          	auipc	ra,0xffffd
    80004522:	b78080e7          	jalr	-1160(ra) # 80001096 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004526:	0004851b          	sext.w	a0,s1
    8000452a:	bbe1                	j	80004302 <exec+0x98>
    8000452c:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004530:	e0843583          	ld	a1,-504(s0)
    80004534:	855e                	mv	a0,s7
    80004536:	ffffd097          	auipc	ra,0xffffd
    8000453a:	b60080e7          	jalr	-1184(ra) # 80001096 <proc_freepagetable>
  if(ip){
    8000453e:	da0498e3          	bnez	s1,800042ee <exec+0x84>
  return -1;
    80004542:	557d                	li	a0,-1
    80004544:	bb7d                	j	80004302 <exec+0x98>
    80004546:	e1243423          	sd	s2,-504(s0)
    8000454a:	b7dd                	j	80004530 <exec+0x2c6>
    8000454c:	e1243423          	sd	s2,-504(s0)
    80004550:	b7c5                	j	80004530 <exec+0x2c6>
    80004552:	e1243423          	sd	s2,-504(s0)
    80004556:	bfe9                	j	80004530 <exec+0x2c6>
  sz = sz1;
    80004558:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000455c:	4481                	li	s1,0
    8000455e:	bfc9                	j	80004530 <exec+0x2c6>
  sz = sz1;
    80004560:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004564:	4481                	li	s1,0
    80004566:	b7e9                	j	80004530 <exec+0x2c6>
  sz = sz1;
    80004568:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000456c:	4481                	li	s1,0
    8000456e:	b7c9                	j	80004530 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004570:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004574:	2b05                	addiw	s6,s6,1
    80004576:	0389899b          	addiw	s3,s3,56
    8000457a:	e8845783          	lhu	a5,-376(s0)
    8000457e:	e2fb5be3          	bge	s6,a5,800043b4 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004582:	2981                	sext.w	s3,s3
    80004584:	03800713          	li	a4,56
    80004588:	86ce                	mv	a3,s3
    8000458a:	e1840613          	addi	a2,s0,-488
    8000458e:	4581                	li	a1,0
    80004590:	8526                	mv	a0,s1
    80004592:	fffff097          	auipc	ra,0xfffff
    80004596:	a84080e7          	jalr	-1404(ra) # 80003016 <readi>
    8000459a:	03800793          	li	a5,56
    8000459e:	f8f517e3          	bne	a0,a5,8000452c <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800045a2:	e1842783          	lw	a5,-488(s0)
    800045a6:	4705                	li	a4,1
    800045a8:	fce796e3          	bne	a5,a4,80004574 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800045ac:	e4043603          	ld	a2,-448(s0)
    800045b0:	e3843783          	ld	a5,-456(s0)
    800045b4:	f8f669e3          	bltu	a2,a5,80004546 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045b8:	e2843783          	ld	a5,-472(s0)
    800045bc:	963e                	add	a2,a2,a5
    800045be:	f8f667e3          	bltu	a2,a5,8000454c <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045c2:	85ca                	mv	a1,s2
    800045c4:	855e                	mv	a0,s7
    800045c6:	ffffc097          	auipc	ra,0xffffc
    800045ca:	3e2080e7          	jalr	994(ra) # 800009a8 <uvmalloc>
    800045ce:	e0a43423          	sd	a0,-504(s0)
    800045d2:	d141                	beqz	a0,80004552 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800045d4:	e2843d03          	ld	s10,-472(s0)
    800045d8:	df043783          	ld	a5,-528(s0)
    800045dc:	00fd77b3          	and	a5,s10,a5
    800045e0:	fba1                	bnez	a5,80004530 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045e2:	e2042d83          	lw	s11,-480(s0)
    800045e6:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045ea:	f80c03e3          	beqz	s8,80004570 <exec+0x306>
    800045ee:	8a62                	mv	s4,s8
    800045f0:	4901                	li	s2,0
    800045f2:	b345                	j	80004392 <exec+0x128>

00000000800045f4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045f4:	7179                	addi	sp,sp,-48
    800045f6:	f406                	sd	ra,40(sp)
    800045f8:	f022                	sd	s0,32(sp)
    800045fa:	ec26                	sd	s1,24(sp)
    800045fc:	e84a                	sd	s2,16(sp)
    800045fe:	1800                	addi	s0,sp,48
    80004600:	892e                	mv	s2,a1
    80004602:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004604:	fdc40593          	addi	a1,s0,-36
    80004608:	ffffe097          	auipc	ra,0xffffe
    8000460c:	9da080e7          	jalr	-1574(ra) # 80001fe2 <argint>
    80004610:	04054063          	bltz	a0,80004650 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004614:	fdc42703          	lw	a4,-36(s0)
    80004618:	47bd                	li	a5,15
    8000461a:	02e7ed63          	bltu	a5,a4,80004654 <argfd+0x60>
    8000461e:	ffffd097          	auipc	ra,0xffffd
    80004622:	918080e7          	jalr	-1768(ra) # 80000f36 <myproc>
    80004626:	fdc42703          	lw	a4,-36(s0)
    8000462a:	01a70793          	addi	a5,a4,26
    8000462e:	078e                	slli	a5,a5,0x3
    80004630:	953e                	add	a0,a0,a5
    80004632:	651c                	ld	a5,8(a0)
    80004634:	c395                	beqz	a5,80004658 <argfd+0x64>
    return -1;
  if(pfd)
    80004636:	00090463          	beqz	s2,8000463e <argfd+0x4a>
    *pfd = fd;
    8000463a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000463e:	4501                	li	a0,0
  if(pf)
    80004640:	c091                	beqz	s1,80004644 <argfd+0x50>
    *pf = f;
    80004642:	e09c                	sd	a5,0(s1)
}
    80004644:	70a2                	ld	ra,40(sp)
    80004646:	7402                	ld	s0,32(sp)
    80004648:	64e2                	ld	s1,24(sp)
    8000464a:	6942                	ld	s2,16(sp)
    8000464c:	6145                	addi	sp,sp,48
    8000464e:	8082                	ret
    return -1;
    80004650:	557d                	li	a0,-1
    80004652:	bfcd                	j	80004644 <argfd+0x50>
    return -1;
    80004654:	557d                	li	a0,-1
    80004656:	b7fd                	j	80004644 <argfd+0x50>
    80004658:	557d                	li	a0,-1
    8000465a:	b7ed                	j	80004644 <argfd+0x50>

000000008000465c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000465c:	1101                	addi	sp,sp,-32
    8000465e:	ec06                	sd	ra,24(sp)
    80004660:	e822                	sd	s0,16(sp)
    80004662:	e426                	sd	s1,8(sp)
    80004664:	1000                	addi	s0,sp,32
    80004666:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004668:	ffffd097          	auipc	ra,0xffffd
    8000466c:	8ce080e7          	jalr	-1842(ra) # 80000f36 <myproc>
    80004670:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004672:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd3e90>
    80004676:	4501                	li	a0,0
    80004678:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000467a:	6398                	ld	a4,0(a5)
    8000467c:	cb19                	beqz	a4,80004692 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000467e:	2505                	addiw	a0,a0,1
    80004680:	07a1                	addi	a5,a5,8
    80004682:	fed51ce3          	bne	a0,a3,8000467a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004686:	557d                	li	a0,-1
}
    80004688:	60e2                	ld	ra,24(sp)
    8000468a:	6442                	ld	s0,16(sp)
    8000468c:	64a2                	ld	s1,8(sp)
    8000468e:	6105                	addi	sp,sp,32
    80004690:	8082                	ret
      p->ofile[fd] = f;
    80004692:	01a50793          	addi	a5,a0,26
    80004696:	078e                	slli	a5,a5,0x3
    80004698:	963e                	add	a2,a2,a5
    8000469a:	e604                	sd	s1,8(a2)
      return fd;
    8000469c:	b7f5                	j	80004688 <fdalloc+0x2c>

000000008000469e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000469e:	715d                	addi	sp,sp,-80
    800046a0:	e486                	sd	ra,72(sp)
    800046a2:	e0a2                	sd	s0,64(sp)
    800046a4:	fc26                	sd	s1,56(sp)
    800046a6:	f84a                	sd	s2,48(sp)
    800046a8:	f44e                	sd	s3,40(sp)
    800046aa:	f052                	sd	s4,32(sp)
    800046ac:	ec56                	sd	s5,24(sp)
    800046ae:	0880                	addi	s0,sp,80
    800046b0:	89ae                	mv	s3,a1
    800046b2:	8ab2                	mv	s5,a2
    800046b4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046b6:	fb040593          	addi	a1,s0,-80
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	e7c080e7          	jalr	-388(ra) # 80003536 <nameiparent>
    800046c2:	892a                	mv	s2,a0
    800046c4:	12050f63          	beqz	a0,80004802 <create+0x164>
    return 0;

  ilock(dp);
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	69a080e7          	jalr	1690(ra) # 80002d62 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046d0:	4601                	li	a2,0
    800046d2:	fb040593          	addi	a1,s0,-80
    800046d6:	854a                	mv	a0,s2
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	b6e080e7          	jalr	-1170(ra) # 80003246 <dirlookup>
    800046e0:	84aa                	mv	s1,a0
    800046e2:	c921                	beqz	a0,80004732 <create+0x94>
    iunlockput(dp);
    800046e4:	854a                	mv	a0,s2
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	8de080e7          	jalr	-1826(ra) # 80002fc4 <iunlockput>
    ilock(ip);
    800046ee:	8526                	mv	a0,s1
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	672080e7          	jalr	1650(ra) # 80002d62 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046f8:	2981                	sext.w	s3,s3
    800046fa:	4789                	li	a5,2
    800046fc:	02f99463          	bne	s3,a5,80004724 <create+0x86>
    80004700:	04c4d783          	lhu	a5,76(s1)
    80004704:	37f9                	addiw	a5,a5,-2
    80004706:	17c2                	slli	a5,a5,0x30
    80004708:	93c1                	srli	a5,a5,0x30
    8000470a:	4705                	li	a4,1
    8000470c:	00f76c63          	bltu	a4,a5,80004724 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004710:	8526                	mv	a0,s1
    80004712:	60a6                	ld	ra,72(sp)
    80004714:	6406                	ld	s0,64(sp)
    80004716:	74e2                	ld	s1,56(sp)
    80004718:	7942                	ld	s2,48(sp)
    8000471a:	79a2                	ld	s3,40(sp)
    8000471c:	7a02                	ld	s4,32(sp)
    8000471e:	6ae2                	ld	s5,24(sp)
    80004720:	6161                	addi	sp,sp,80
    80004722:	8082                	ret
    iunlockput(ip);
    80004724:	8526                	mv	a0,s1
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	89e080e7          	jalr	-1890(ra) # 80002fc4 <iunlockput>
    return 0;
    8000472e:	4481                	li	s1,0
    80004730:	b7c5                	j	80004710 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004732:	85ce                	mv	a1,s3
    80004734:	00092503          	lw	a0,0(s2)
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	492080e7          	jalr	1170(ra) # 80002bca <ialloc>
    80004740:	84aa                	mv	s1,a0
    80004742:	c529                	beqz	a0,8000478c <create+0xee>
  ilock(ip);
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	61e080e7          	jalr	1566(ra) # 80002d62 <ilock>
  ip->major = major;
    8000474c:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    80004750:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    80004754:	4785                	li	a5,1
    80004756:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    8000475a:	8526                	mv	a0,s1
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	53c080e7          	jalr	1340(ra) # 80002c98 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004764:	2981                	sext.w	s3,s3
    80004766:	4785                	li	a5,1
    80004768:	02f98a63          	beq	s3,a5,8000479c <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000476c:	40d0                	lw	a2,4(s1)
    8000476e:	fb040593          	addi	a1,s0,-80
    80004772:	854a                	mv	a0,s2
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	ce2080e7          	jalr	-798(ra) # 80003456 <dirlink>
    8000477c:	06054b63          	bltz	a0,800047f2 <create+0x154>
  iunlockput(dp);
    80004780:	854a                	mv	a0,s2
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	842080e7          	jalr	-1982(ra) # 80002fc4 <iunlockput>
  return ip;
    8000478a:	b759                	j	80004710 <create+0x72>
    panic("create: ialloc");
    8000478c:	00004517          	auipc	a0,0x4
    80004790:	edc50513          	addi	a0,a0,-292 # 80008668 <syscalls+0x2a0>
    80004794:	00002097          	auipc	ra,0x2
    80004798:	9b8080e7          	jalr	-1608(ra) # 8000614c <panic>
    dp->nlink++;  // for ".."
    8000479c:	05295783          	lhu	a5,82(s2)
    800047a0:	2785                	addiw	a5,a5,1
    800047a2:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800047a6:	854a                	mv	a0,s2
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	4f0080e7          	jalr	1264(ra) # 80002c98 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047b0:	40d0                	lw	a2,4(s1)
    800047b2:	00004597          	auipc	a1,0x4
    800047b6:	ec658593          	addi	a1,a1,-314 # 80008678 <syscalls+0x2b0>
    800047ba:	8526                	mv	a0,s1
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	c9a080e7          	jalr	-870(ra) # 80003456 <dirlink>
    800047c4:	00054f63          	bltz	a0,800047e2 <create+0x144>
    800047c8:	00492603          	lw	a2,4(s2)
    800047cc:	00004597          	auipc	a1,0x4
    800047d0:	eb458593          	addi	a1,a1,-332 # 80008680 <syscalls+0x2b8>
    800047d4:	8526                	mv	a0,s1
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	c80080e7          	jalr	-896(ra) # 80003456 <dirlink>
    800047de:	f80557e3          	bgez	a0,8000476c <create+0xce>
      panic("create dots");
    800047e2:	00004517          	auipc	a0,0x4
    800047e6:	ea650513          	addi	a0,a0,-346 # 80008688 <syscalls+0x2c0>
    800047ea:	00002097          	auipc	ra,0x2
    800047ee:	962080e7          	jalr	-1694(ra) # 8000614c <panic>
    panic("create: dirlink");
    800047f2:	00004517          	auipc	a0,0x4
    800047f6:	ea650513          	addi	a0,a0,-346 # 80008698 <syscalls+0x2d0>
    800047fa:	00002097          	auipc	ra,0x2
    800047fe:	952080e7          	jalr	-1710(ra) # 8000614c <panic>
    return 0;
    80004802:	84aa                	mv	s1,a0
    80004804:	b731                	j	80004710 <create+0x72>

0000000080004806 <sys_dup>:
{
    80004806:	7179                	addi	sp,sp,-48
    80004808:	f406                	sd	ra,40(sp)
    8000480a:	f022                	sd	s0,32(sp)
    8000480c:	ec26                	sd	s1,24(sp)
    8000480e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004810:	fd840613          	addi	a2,s0,-40
    80004814:	4581                	li	a1,0
    80004816:	4501                	li	a0,0
    80004818:	00000097          	auipc	ra,0x0
    8000481c:	ddc080e7          	jalr	-548(ra) # 800045f4 <argfd>
    return -1;
    80004820:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004822:	02054363          	bltz	a0,80004848 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004826:	fd843503          	ld	a0,-40(s0)
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	e32080e7          	jalr	-462(ra) # 8000465c <fdalloc>
    80004832:	84aa                	mv	s1,a0
    return -1;
    80004834:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004836:	00054963          	bltz	a0,80004848 <sys_dup+0x42>
  filedup(f);
    8000483a:	fd843503          	ld	a0,-40(s0)
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	370080e7          	jalr	880(ra) # 80003bae <filedup>
  return fd;
    80004846:	87a6                	mv	a5,s1
}
    80004848:	853e                	mv	a0,a5
    8000484a:	70a2                	ld	ra,40(sp)
    8000484c:	7402                	ld	s0,32(sp)
    8000484e:	64e2                	ld	s1,24(sp)
    80004850:	6145                	addi	sp,sp,48
    80004852:	8082                	ret

0000000080004854 <sys_read>:
{
    80004854:	7179                	addi	sp,sp,-48
    80004856:	f406                	sd	ra,40(sp)
    80004858:	f022                	sd	s0,32(sp)
    8000485a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000485c:	fe840613          	addi	a2,s0,-24
    80004860:	4581                	li	a1,0
    80004862:	4501                	li	a0,0
    80004864:	00000097          	auipc	ra,0x0
    80004868:	d90080e7          	jalr	-624(ra) # 800045f4 <argfd>
    return -1;
    8000486c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486e:	04054163          	bltz	a0,800048b0 <sys_read+0x5c>
    80004872:	fe440593          	addi	a1,s0,-28
    80004876:	4509                	li	a0,2
    80004878:	ffffd097          	auipc	ra,0xffffd
    8000487c:	76a080e7          	jalr	1898(ra) # 80001fe2 <argint>
    return -1;
    80004880:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004882:	02054763          	bltz	a0,800048b0 <sys_read+0x5c>
    80004886:	fd840593          	addi	a1,s0,-40
    8000488a:	4505                	li	a0,1
    8000488c:	ffffd097          	auipc	ra,0xffffd
    80004890:	778080e7          	jalr	1912(ra) # 80002004 <argaddr>
    return -1;
    80004894:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004896:	00054d63          	bltz	a0,800048b0 <sys_read+0x5c>
  return fileread(f, p, n);
    8000489a:	fe442603          	lw	a2,-28(s0)
    8000489e:	fd843583          	ld	a1,-40(s0)
    800048a2:	fe843503          	ld	a0,-24(s0)
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	494080e7          	jalr	1172(ra) # 80003d3a <fileread>
    800048ae:	87aa                	mv	a5,a0
}
    800048b0:	853e                	mv	a0,a5
    800048b2:	70a2                	ld	ra,40(sp)
    800048b4:	7402                	ld	s0,32(sp)
    800048b6:	6145                	addi	sp,sp,48
    800048b8:	8082                	ret

00000000800048ba <sys_write>:
{
    800048ba:	7179                	addi	sp,sp,-48
    800048bc:	f406                	sd	ra,40(sp)
    800048be:	f022                	sd	s0,32(sp)
    800048c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c2:	fe840613          	addi	a2,s0,-24
    800048c6:	4581                	li	a1,0
    800048c8:	4501                	li	a0,0
    800048ca:	00000097          	auipc	ra,0x0
    800048ce:	d2a080e7          	jalr	-726(ra) # 800045f4 <argfd>
    return -1;
    800048d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d4:	04054163          	bltz	a0,80004916 <sys_write+0x5c>
    800048d8:	fe440593          	addi	a1,s0,-28
    800048dc:	4509                	li	a0,2
    800048de:	ffffd097          	auipc	ra,0xffffd
    800048e2:	704080e7          	jalr	1796(ra) # 80001fe2 <argint>
    return -1;
    800048e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e8:	02054763          	bltz	a0,80004916 <sys_write+0x5c>
    800048ec:	fd840593          	addi	a1,s0,-40
    800048f0:	4505                	li	a0,1
    800048f2:	ffffd097          	auipc	ra,0xffffd
    800048f6:	712080e7          	jalr	1810(ra) # 80002004 <argaddr>
    return -1;
    800048fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048fc:	00054d63          	bltz	a0,80004916 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004900:	fe442603          	lw	a2,-28(s0)
    80004904:	fd843583          	ld	a1,-40(s0)
    80004908:	fe843503          	ld	a0,-24(s0)
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	4f0080e7          	jalr	1264(ra) # 80003dfc <filewrite>
    80004914:	87aa                	mv	a5,a0
}
    80004916:	853e                	mv	a0,a5
    80004918:	70a2                	ld	ra,40(sp)
    8000491a:	7402                	ld	s0,32(sp)
    8000491c:	6145                	addi	sp,sp,48
    8000491e:	8082                	ret

0000000080004920 <sys_close>:
{
    80004920:	1101                	addi	sp,sp,-32
    80004922:	ec06                	sd	ra,24(sp)
    80004924:	e822                	sd	s0,16(sp)
    80004926:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004928:	fe040613          	addi	a2,s0,-32
    8000492c:	fec40593          	addi	a1,s0,-20
    80004930:	4501                	li	a0,0
    80004932:	00000097          	auipc	ra,0x0
    80004936:	cc2080e7          	jalr	-830(ra) # 800045f4 <argfd>
    return -1;
    8000493a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000493c:	02054463          	bltz	a0,80004964 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004940:	ffffc097          	auipc	ra,0xffffc
    80004944:	5f6080e7          	jalr	1526(ra) # 80000f36 <myproc>
    80004948:	fec42783          	lw	a5,-20(s0)
    8000494c:	07e9                	addi	a5,a5,26
    8000494e:	078e                	slli	a5,a5,0x3
    80004950:	97aa                	add	a5,a5,a0
    80004952:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80004956:	fe043503          	ld	a0,-32(s0)
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	2a6080e7          	jalr	678(ra) # 80003c00 <fileclose>
  return 0;
    80004962:	4781                	li	a5,0
}
    80004964:	853e                	mv	a0,a5
    80004966:	60e2                	ld	ra,24(sp)
    80004968:	6442                	ld	s0,16(sp)
    8000496a:	6105                	addi	sp,sp,32
    8000496c:	8082                	ret

000000008000496e <sys_fstat>:
{
    8000496e:	1101                	addi	sp,sp,-32
    80004970:	ec06                	sd	ra,24(sp)
    80004972:	e822                	sd	s0,16(sp)
    80004974:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004976:	fe840613          	addi	a2,s0,-24
    8000497a:	4581                	li	a1,0
    8000497c:	4501                	li	a0,0
    8000497e:	00000097          	auipc	ra,0x0
    80004982:	c76080e7          	jalr	-906(ra) # 800045f4 <argfd>
    return -1;
    80004986:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004988:	02054563          	bltz	a0,800049b2 <sys_fstat+0x44>
    8000498c:	fe040593          	addi	a1,s0,-32
    80004990:	4505                	li	a0,1
    80004992:	ffffd097          	auipc	ra,0xffffd
    80004996:	672080e7          	jalr	1650(ra) # 80002004 <argaddr>
    return -1;
    8000499a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000499c:	00054b63          	bltz	a0,800049b2 <sys_fstat+0x44>
  return filestat(f, st);
    800049a0:	fe043583          	ld	a1,-32(s0)
    800049a4:	fe843503          	ld	a0,-24(s0)
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	320080e7          	jalr	800(ra) # 80003cc8 <filestat>
    800049b0:	87aa                	mv	a5,a0
}
    800049b2:	853e                	mv	a0,a5
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	6105                	addi	sp,sp,32
    800049ba:	8082                	ret

00000000800049bc <sys_link>:
{
    800049bc:	7169                	addi	sp,sp,-304
    800049be:	f606                	sd	ra,296(sp)
    800049c0:	f222                	sd	s0,288(sp)
    800049c2:	ee26                	sd	s1,280(sp)
    800049c4:	ea4a                	sd	s2,272(sp)
    800049c6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c8:	08000613          	li	a2,128
    800049cc:	ed040593          	addi	a1,s0,-304
    800049d0:	4501                	li	a0,0
    800049d2:	ffffd097          	auipc	ra,0xffffd
    800049d6:	654080e7          	jalr	1620(ra) # 80002026 <argstr>
    return -1;
    800049da:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049dc:	10054e63          	bltz	a0,80004af8 <sys_link+0x13c>
    800049e0:	08000613          	li	a2,128
    800049e4:	f5040593          	addi	a1,s0,-176
    800049e8:	4505                	li	a0,1
    800049ea:	ffffd097          	auipc	ra,0xffffd
    800049ee:	63c080e7          	jalr	1596(ra) # 80002026 <argstr>
    return -1;
    800049f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f4:	10054263          	bltz	a0,80004af8 <sys_link+0x13c>
  begin_op();
    800049f8:	fffff097          	auipc	ra,0xfffff
    800049fc:	d3c080e7          	jalr	-708(ra) # 80003734 <begin_op>
  if((ip = namei(old)) == 0){
    80004a00:	ed040513          	addi	a0,s0,-304
    80004a04:	fffff097          	auipc	ra,0xfffff
    80004a08:	b14080e7          	jalr	-1260(ra) # 80003518 <namei>
    80004a0c:	84aa                	mv	s1,a0
    80004a0e:	c551                	beqz	a0,80004a9a <sys_link+0xde>
  ilock(ip);
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	352080e7          	jalr	850(ra) # 80002d62 <ilock>
  if(ip->type == T_DIR){
    80004a18:	04c49703          	lh	a4,76(s1)
    80004a1c:	4785                	li	a5,1
    80004a1e:	08f70463          	beq	a4,a5,80004aa6 <sys_link+0xea>
  ip->nlink++;
    80004a22:	0524d783          	lhu	a5,82(s1)
    80004a26:	2785                	addiw	a5,a5,1
    80004a28:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	26a080e7          	jalr	618(ra) # 80002c98 <iupdate>
  iunlock(ip);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	3ec080e7          	jalr	1004(ra) # 80002e24 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a40:	fd040593          	addi	a1,s0,-48
    80004a44:	f5040513          	addi	a0,s0,-176
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	aee080e7          	jalr	-1298(ra) # 80003536 <nameiparent>
    80004a50:	892a                	mv	s2,a0
    80004a52:	c935                	beqz	a0,80004ac6 <sys_link+0x10a>
  ilock(dp);
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	30e080e7          	jalr	782(ra) # 80002d62 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a5c:	00092703          	lw	a4,0(s2)
    80004a60:	409c                	lw	a5,0(s1)
    80004a62:	04f71d63          	bne	a4,a5,80004abc <sys_link+0x100>
    80004a66:	40d0                	lw	a2,4(s1)
    80004a68:	fd040593          	addi	a1,s0,-48
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	9e8080e7          	jalr	-1560(ra) # 80003456 <dirlink>
    80004a76:	04054363          	bltz	a0,80004abc <sys_link+0x100>
  iunlockput(dp);
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	548080e7          	jalr	1352(ra) # 80002fc4 <iunlockput>
  iput(ip);
    80004a84:	8526                	mv	a0,s1
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	496080e7          	jalr	1174(ra) # 80002f1c <iput>
  end_op();
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	d26080e7          	jalr	-730(ra) # 800037b4 <end_op>
  return 0;
    80004a96:	4781                	li	a5,0
    80004a98:	a085                	j	80004af8 <sys_link+0x13c>
    end_op();
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	d1a080e7          	jalr	-742(ra) # 800037b4 <end_op>
    return -1;
    80004aa2:	57fd                	li	a5,-1
    80004aa4:	a891                	j	80004af8 <sys_link+0x13c>
    iunlockput(ip);
    80004aa6:	8526                	mv	a0,s1
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	51c080e7          	jalr	1308(ra) # 80002fc4 <iunlockput>
    end_op();
    80004ab0:	fffff097          	auipc	ra,0xfffff
    80004ab4:	d04080e7          	jalr	-764(ra) # 800037b4 <end_op>
    return -1;
    80004ab8:	57fd                	li	a5,-1
    80004aba:	a83d                	j	80004af8 <sys_link+0x13c>
    iunlockput(dp);
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	506080e7          	jalr	1286(ra) # 80002fc4 <iunlockput>
  ilock(ip);
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	29a080e7          	jalr	666(ra) # 80002d62 <ilock>
  ip->nlink--;
    80004ad0:	0524d783          	lhu	a5,82(s1)
    80004ad4:	37fd                	addiw	a5,a5,-1
    80004ad6:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	1bc080e7          	jalr	444(ra) # 80002c98 <iupdate>
  iunlockput(ip);
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	4de080e7          	jalr	1246(ra) # 80002fc4 <iunlockput>
  end_op();
    80004aee:	fffff097          	auipc	ra,0xfffff
    80004af2:	cc6080e7          	jalr	-826(ra) # 800037b4 <end_op>
  return -1;
    80004af6:	57fd                	li	a5,-1
}
    80004af8:	853e                	mv	a0,a5
    80004afa:	70b2                	ld	ra,296(sp)
    80004afc:	7412                	ld	s0,288(sp)
    80004afe:	64f2                	ld	s1,280(sp)
    80004b00:	6952                	ld	s2,272(sp)
    80004b02:	6155                	addi	sp,sp,304
    80004b04:	8082                	ret

0000000080004b06 <sys_unlink>:
{
    80004b06:	7151                	addi	sp,sp,-240
    80004b08:	f586                	sd	ra,232(sp)
    80004b0a:	f1a2                	sd	s0,224(sp)
    80004b0c:	eda6                	sd	s1,216(sp)
    80004b0e:	e9ca                	sd	s2,208(sp)
    80004b10:	e5ce                	sd	s3,200(sp)
    80004b12:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b14:	08000613          	li	a2,128
    80004b18:	f3040593          	addi	a1,s0,-208
    80004b1c:	4501                	li	a0,0
    80004b1e:	ffffd097          	auipc	ra,0xffffd
    80004b22:	508080e7          	jalr	1288(ra) # 80002026 <argstr>
    80004b26:	18054163          	bltz	a0,80004ca8 <sys_unlink+0x1a2>
  begin_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	c0a080e7          	jalr	-1014(ra) # 80003734 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b32:	fb040593          	addi	a1,s0,-80
    80004b36:	f3040513          	addi	a0,s0,-208
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	9fc080e7          	jalr	-1540(ra) # 80003536 <nameiparent>
    80004b42:	84aa                	mv	s1,a0
    80004b44:	c979                	beqz	a0,80004c1a <sys_unlink+0x114>
  ilock(dp);
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	21c080e7          	jalr	540(ra) # 80002d62 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b4e:	00004597          	auipc	a1,0x4
    80004b52:	b2a58593          	addi	a1,a1,-1238 # 80008678 <syscalls+0x2b0>
    80004b56:	fb040513          	addi	a0,s0,-80
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	6d2080e7          	jalr	1746(ra) # 8000322c <namecmp>
    80004b62:	14050a63          	beqz	a0,80004cb6 <sys_unlink+0x1b0>
    80004b66:	00004597          	auipc	a1,0x4
    80004b6a:	b1a58593          	addi	a1,a1,-1254 # 80008680 <syscalls+0x2b8>
    80004b6e:	fb040513          	addi	a0,s0,-80
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	6ba080e7          	jalr	1722(ra) # 8000322c <namecmp>
    80004b7a:	12050e63          	beqz	a0,80004cb6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b7e:	f2c40613          	addi	a2,s0,-212
    80004b82:	fb040593          	addi	a1,s0,-80
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	6be080e7          	jalr	1726(ra) # 80003246 <dirlookup>
    80004b90:	892a                	mv	s2,a0
    80004b92:	12050263          	beqz	a0,80004cb6 <sys_unlink+0x1b0>
  ilock(ip);
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	1cc080e7          	jalr	460(ra) # 80002d62 <ilock>
  if(ip->nlink < 1)
    80004b9e:	05291783          	lh	a5,82(s2)
    80004ba2:	08f05263          	blez	a5,80004c26 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ba6:	04c91703          	lh	a4,76(s2)
    80004baa:	4785                	li	a5,1
    80004bac:	08f70563          	beq	a4,a5,80004c36 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bb0:	4641                	li	a2,16
    80004bb2:	4581                	li	a1,0
    80004bb4:	fc040513          	addi	a0,s0,-64
    80004bb8:	ffffb097          	auipc	ra,0xffffb
    80004bbc:	69e080e7          	jalr	1694(ra) # 80000256 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc0:	4741                	li	a4,16
    80004bc2:	f2c42683          	lw	a3,-212(s0)
    80004bc6:	fc040613          	addi	a2,s0,-64
    80004bca:	4581                	li	a1,0
    80004bcc:	8526                	mv	a0,s1
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	540080e7          	jalr	1344(ra) # 8000310e <writei>
    80004bd6:	47c1                	li	a5,16
    80004bd8:	0af51563          	bne	a0,a5,80004c82 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bdc:	04c91703          	lh	a4,76(s2)
    80004be0:	4785                	li	a5,1
    80004be2:	0af70863          	beq	a4,a5,80004c92 <sys_unlink+0x18c>
  iunlockput(dp);
    80004be6:	8526                	mv	a0,s1
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	3dc080e7          	jalr	988(ra) # 80002fc4 <iunlockput>
  ip->nlink--;
    80004bf0:	05295783          	lhu	a5,82(s2)
    80004bf4:	37fd                	addiw	a5,a5,-1
    80004bf6:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	09c080e7          	jalr	156(ra) # 80002c98 <iupdate>
  iunlockput(ip);
    80004c04:	854a                	mv	a0,s2
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	3be080e7          	jalr	958(ra) # 80002fc4 <iunlockput>
  end_op();
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	ba6080e7          	jalr	-1114(ra) # 800037b4 <end_op>
  return 0;
    80004c16:	4501                	li	a0,0
    80004c18:	a84d                	j	80004cca <sys_unlink+0x1c4>
    end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	b9a080e7          	jalr	-1126(ra) # 800037b4 <end_op>
    return -1;
    80004c22:	557d                	li	a0,-1
    80004c24:	a05d                	j	80004cca <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c26:	00004517          	auipc	a0,0x4
    80004c2a:	a8250513          	addi	a0,a0,-1406 # 800086a8 <syscalls+0x2e0>
    80004c2e:	00001097          	auipc	ra,0x1
    80004c32:	51e080e7          	jalr	1310(ra) # 8000614c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c36:	05492703          	lw	a4,84(s2)
    80004c3a:	02000793          	li	a5,32
    80004c3e:	f6e7f9e3          	bgeu	a5,a4,80004bb0 <sys_unlink+0xaa>
    80004c42:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c46:	4741                	li	a4,16
    80004c48:	86ce                	mv	a3,s3
    80004c4a:	f1840613          	addi	a2,s0,-232
    80004c4e:	4581                	li	a1,0
    80004c50:	854a                	mv	a0,s2
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	3c4080e7          	jalr	964(ra) # 80003016 <readi>
    80004c5a:	47c1                	li	a5,16
    80004c5c:	00f51b63          	bne	a0,a5,80004c72 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c60:	f1845783          	lhu	a5,-232(s0)
    80004c64:	e7a1                	bnez	a5,80004cac <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c66:	29c1                	addiw	s3,s3,16
    80004c68:	05492783          	lw	a5,84(s2)
    80004c6c:	fcf9ede3          	bltu	s3,a5,80004c46 <sys_unlink+0x140>
    80004c70:	b781                	j	80004bb0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c72:	00004517          	auipc	a0,0x4
    80004c76:	a4e50513          	addi	a0,a0,-1458 # 800086c0 <syscalls+0x2f8>
    80004c7a:	00001097          	auipc	ra,0x1
    80004c7e:	4d2080e7          	jalr	1234(ra) # 8000614c <panic>
    panic("unlink: writei");
    80004c82:	00004517          	auipc	a0,0x4
    80004c86:	a5650513          	addi	a0,a0,-1450 # 800086d8 <syscalls+0x310>
    80004c8a:	00001097          	auipc	ra,0x1
    80004c8e:	4c2080e7          	jalr	1218(ra) # 8000614c <panic>
    dp->nlink--;
    80004c92:	0524d783          	lhu	a5,82(s1)
    80004c96:	37fd                	addiw	a5,a5,-1
    80004c98:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	ffa080e7          	jalr	-6(ra) # 80002c98 <iupdate>
    80004ca6:	b781                	j	80004be6 <sys_unlink+0xe0>
    return -1;
    80004ca8:	557d                	li	a0,-1
    80004caa:	a005                	j	80004cca <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	316080e7          	jalr	790(ra) # 80002fc4 <iunlockput>
  iunlockput(dp);
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	ffffe097          	auipc	ra,0xffffe
    80004cbc:	30c080e7          	jalr	780(ra) # 80002fc4 <iunlockput>
  end_op();
    80004cc0:	fffff097          	auipc	ra,0xfffff
    80004cc4:	af4080e7          	jalr	-1292(ra) # 800037b4 <end_op>
  return -1;
    80004cc8:	557d                	li	a0,-1
}
    80004cca:	70ae                	ld	ra,232(sp)
    80004ccc:	740e                	ld	s0,224(sp)
    80004cce:	64ee                	ld	s1,216(sp)
    80004cd0:	694e                	ld	s2,208(sp)
    80004cd2:	69ae                	ld	s3,200(sp)
    80004cd4:	616d                	addi	sp,sp,240
    80004cd6:	8082                	ret

0000000080004cd8 <sys_open>:

uint64
sys_open(void)
{
    80004cd8:	7131                	addi	sp,sp,-192
    80004cda:	fd06                	sd	ra,184(sp)
    80004cdc:	f922                	sd	s0,176(sp)
    80004cde:	f526                	sd	s1,168(sp)
    80004ce0:	f14a                	sd	s2,160(sp)
    80004ce2:	ed4e                	sd	s3,152(sp)
    80004ce4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ce6:	08000613          	li	a2,128
    80004cea:	f5040593          	addi	a1,s0,-176
    80004cee:	4501                	li	a0,0
    80004cf0:	ffffd097          	auipc	ra,0xffffd
    80004cf4:	336080e7          	jalr	822(ra) # 80002026 <argstr>
    return -1;
    80004cf8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cfa:	0c054163          	bltz	a0,80004dbc <sys_open+0xe4>
    80004cfe:	f4c40593          	addi	a1,s0,-180
    80004d02:	4505                	li	a0,1
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	2de080e7          	jalr	734(ra) # 80001fe2 <argint>
    80004d0c:	0a054863          	bltz	a0,80004dbc <sys_open+0xe4>

  begin_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	a24080e7          	jalr	-1500(ra) # 80003734 <begin_op>

  if(omode & O_CREATE){
    80004d18:	f4c42783          	lw	a5,-180(s0)
    80004d1c:	2007f793          	andi	a5,a5,512
    80004d20:	cbdd                	beqz	a5,80004dd6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d22:	4681                	li	a3,0
    80004d24:	4601                	li	a2,0
    80004d26:	4589                	li	a1,2
    80004d28:	f5040513          	addi	a0,s0,-176
    80004d2c:	00000097          	auipc	ra,0x0
    80004d30:	972080e7          	jalr	-1678(ra) # 8000469e <create>
    80004d34:	892a                	mv	s2,a0
    if(ip == 0){
    80004d36:	c959                	beqz	a0,80004dcc <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d38:	04c91703          	lh	a4,76(s2)
    80004d3c:	478d                	li	a5,3
    80004d3e:	00f71763          	bne	a4,a5,80004d4c <sys_open+0x74>
    80004d42:	04e95703          	lhu	a4,78(s2)
    80004d46:	47a5                	li	a5,9
    80004d48:	0ce7ec63          	bltu	a5,a4,80004e20 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	df8080e7          	jalr	-520(ra) # 80003b44 <filealloc>
    80004d54:	89aa                	mv	s3,a0
    80004d56:	10050263          	beqz	a0,80004e5a <sys_open+0x182>
    80004d5a:	00000097          	auipc	ra,0x0
    80004d5e:	902080e7          	jalr	-1790(ra) # 8000465c <fdalloc>
    80004d62:	84aa                	mv	s1,a0
    80004d64:	0e054663          	bltz	a0,80004e50 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d68:	04c91703          	lh	a4,76(s2)
    80004d6c:	478d                	li	a5,3
    80004d6e:	0cf70463          	beq	a4,a5,80004e36 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d72:	4789                	li	a5,2
    80004d74:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d78:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d7c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d80:	f4c42783          	lw	a5,-180(s0)
    80004d84:	0017c713          	xori	a4,a5,1
    80004d88:	8b05                	andi	a4,a4,1
    80004d8a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d8e:	0037f713          	andi	a4,a5,3
    80004d92:	00e03733          	snez	a4,a4
    80004d96:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d9a:	4007f793          	andi	a5,a5,1024
    80004d9e:	c791                	beqz	a5,80004daa <sys_open+0xd2>
    80004da0:	04c91703          	lh	a4,76(s2)
    80004da4:	4789                	li	a5,2
    80004da6:	08f70f63          	beq	a4,a5,80004e44 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004daa:	854a                	mv	a0,s2
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	078080e7          	jalr	120(ra) # 80002e24 <iunlock>
  end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	a00080e7          	jalr	-1536(ra) # 800037b4 <end_op>

  return fd;
}
    80004dbc:	8526                	mv	a0,s1
    80004dbe:	70ea                	ld	ra,184(sp)
    80004dc0:	744a                	ld	s0,176(sp)
    80004dc2:	74aa                	ld	s1,168(sp)
    80004dc4:	790a                	ld	s2,160(sp)
    80004dc6:	69ea                	ld	s3,152(sp)
    80004dc8:	6129                	addi	sp,sp,192
    80004dca:	8082                	ret
      end_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	9e8080e7          	jalr	-1560(ra) # 800037b4 <end_op>
      return -1;
    80004dd4:	b7e5                	j	80004dbc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dd6:	f5040513          	addi	a0,s0,-176
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	73e080e7          	jalr	1854(ra) # 80003518 <namei>
    80004de2:	892a                	mv	s2,a0
    80004de4:	c905                	beqz	a0,80004e14 <sys_open+0x13c>
    ilock(ip);
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	f7c080e7          	jalr	-132(ra) # 80002d62 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dee:	04c91703          	lh	a4,76(s2)
    80004df2:	4785                	li	a5,1
    80004df4:	f4f712e3          	bne	a4,a5,80004d38 <sys_open+0x60>
    80004df8:	f4c42783          	lw	a5,-180(s0)
    80004dfc:	dba1                	beqz	a5,80004d4c <sys_open+0x74>
      iunlockput(ip);
    80004dfe:	854a                	mv	a0,s2
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	1c4080e7          	jalr	452(ra) # 80002fc4 <iunlockput>
      end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	9ac080e7          	jalr	-1620(ra) # 800037b4 <end_op>
      return -1;
    80004e10:	54fd                	li	s1,-1
    80004e12:	b76d                	j	80004dbc <sys_open+0xe4>
      end_op();
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	9a0080e7          	jalr	-1632(ra) # 800037b4 <end_op>
      return -1;
    80004e1c:	54fd                	li	s1,-1
    80004e1e:	bf79                	j	80004dbc <sys_open+0xe4>
    iunlockput(ip);
    80004e20:	854a                	mv	a0,s2
    80004e22:	ffffe097          	auipc	ra,0xffffe
    80004e26:	1a2080e7          	jalr	418(ra) # 80002fc4 <iunlockput>
    end_op();
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	98a080e7          	jalr	-1654(ra) # 800037b4 <end_op>
    return -1;
    80004e32:	54fd                	li	s1,-1
    80004e34:	b761                	j	80004dbc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e36:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e3a:	04e91783          	lh	a5,78(s2)
    80004e3e:	02f99223          	sh	a5,36(s3)
    80004e42:	bf2d                	j	80004d7c <sys_open+0xa4>
    itrunc(ip);
    80004e44:	854a                	mv	a0,s2
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	02a080e7          	jalr	42(ra) # 80002e70 <itrunc>
    80004e4e:	bfb1                	j	80004daa <sys_open+0xd2>
      fileclose(f);
    80004e50:	854e                	mv	a0,s3
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	dae080e7          	jalr	-594(ra) # 80003c00 <fileclose>
    iunlockput(ip);
    80004e5a:	854a                	mv	a0,s2
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	168080e7          	jalr	360(ra) # 80002fc4 <iunlockput>
    end_op();
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	950080e7          	jalr	-1712(ra) # 800037b4 <end_op>
    return -1;
    80004e6c:	54fd                	li	s1,-1
    80004e6e:	b7b9                	j	80004dbc <sys_open+0xe4>

0000000080004e70 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e70:	7175                	addi	sp,sp,-144
    80004e72:	e506                	sd	ra,136(sp)
    80004e74:	e122                	sd	s0,128(sp)
    80004e76:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	8bc080e7          	jalr	-1860(ra) # 80003734 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e80:	08000613          	li	a2,128
    80004e84:	f7040593          	addi	a1,s0,-144
    80004e88:	4501                	li	a0,0
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	19c080e7          	jalr	412(ra) # 80002026 <argstr>
    80004e92:	02054963          	bltz	a0,80004ec4 <sys_mkdir+0x54>
    80004e96:	4681                	li	a3,0
    80004e98:	4601                	li	a2,0
    80004e9a:	4585                	li	a1,1
    80004e9c:	f7040513          	addi	a0,s0,-144
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	7fe080e7          	jalr	2046(ra) # 8000469e <create>
    80004ea8:	cd11                	beqz	a0,80004ec4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	11a080e7          	jalr	282(ra) # 80002fc4 <iunlockput>
  end_op();
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	902080e7          	jalr	-1790(ra) # 800037b4 <end_op>
  return 0;
    80004eba:	4501                	li	a0,0
}
    80004ebc:	60aa                	ld	ra,136(sp)
    80004ebe:	640a                	ld	s0,128(sp)
    80004ec0:	6149                	addi	sp,sp,144
    80004ec2:	8082                	ret
    end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	8f0080e7          	jalr	-1808(ra) # 800037b4 <end_op>
    return -1;
    80004ecc:	557d                	li	a0,-1
    80004ece:	b7fd                	j	80004ebc <sys_mkdir+0x4c>

0000000080004ed0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ed0:	7135                	addi	sp,sp,-160
    80004ed2:	ed06                	sd	ra,152(sp)
    80004ed4:	e922                	sd	s0,144(sp)
    80004ed6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	85c080e7          	jalr	-1956(ra) # 80003734 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ee0:	08000613          	li	a2,128
    80004ee4:	f7040593          	addi	a1,s0,-144
    80004ee8:	4501                	li	a0,0
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	13c080e7          	jalr	316(ra) # 80002026 <argstr>
    80004ef2:	04054a63          	bltz	a0,80004f46 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ef6:	f6c40593          	addi	a1,s0,-148
    80004efa:	4505                	li	a0,1
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	0e6080e7          	jalr	230(ra) # 80001fe2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f04:	04054163          	bltz	a0,80004f46 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f08:	f6840593          	addi	a1,s0,-152
    80004f0c:	4509                	li	a0,2
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	0d4080e7          	jalr	212(ra) # 80001fe2 <argint>
     argint(1, &major) < 0 ||
    80004f16:	02054863          	bltz	a0,80004f46 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f1a:	f6841683          	lh	a3,-152(s0)
    80004f1e:	f6c41603          	lh	a2,-148(s0)
    80004f22:	458d                	li	a1,3
    80004f24:	f7040513          	addi	a0,s0,-144
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	776080e7          	jalr	1910(ra) # 8000469e <create>
     argint(2, &minor) < 0 ||
    80004f30:	c919                	beqz	a0,80004f46 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	092080e7          	jalr	146(ra) # 80002fc4 <iunlockput>
  end_op();
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	87a080e7          	jalr	-1926(ra) # 800037b4 <end_op>
  return 0;
    80004f42:	4501                	li	a0,0
    80004f44:	a031                	j	80004f50 <sys_mknod+0x80>
    end_op();
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	86e080e7          	jalr	-1938(ra) # 800037b4 <end_op>
    return -1;
    80004f4e:	557d                	li	a0,-1
}
    80004f50:	60ea                	ld	ra,152(sp)
    80004f52:	644a                	ld	s0,144(sp)
    80004f54:	610d                	addi	sp,sp,160
    80004f56:	8082                	ret

0000000080004f58 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f58:	7135                	addi	sp,sp,-160
    80004f5a:	ed06                	sd	ra,152(sp)
    80004f5c:	e922                	sd	s0,144(sp)
    80004f5e:	e526                	sd	s1,136(sp)
    80004f60:	e14a                	sd	s2,128(sp)
    80004f62:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f64:	ffffc097          	auipc	ra,0xffffc
    80004f68:	fd2080e7          	jalr	-46(ra) # 80000f36 <myproc>
    80004f6c:	892a                	mv	s2,a0
  
  begin_op();
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	7c6080e7          	jalr	1990(ra) # 80003734 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f76:	08000613          	li	a2,128
    80004f7a:	f6040593          	addi	a1,s0,-160
    80004f7e:	4501                	li	a0,0
    80004f80:	ffffd097          	auipc	ra,0xffffd
    80004f84:	0a6080e7          	jalr	166(ra) # 80002026 <argstr>
    80004f88:	04054b63          	bltz	a0,80004fde <sys_chdir+0x86>
    80004f8c:	f6040513          	addi	a0,s0,-160
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	588080e7          	jalr	1416(ra) # 80003518 <namei>
    80004f98:	84aa                	mv	s1,a0
    80004f9a:	c131                	beqz	a0,80004fde <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	dc6080e7          	jalr	-570(ra) # 80002d62 <ilock>
  if(ip->type != T_DIR){
    80004fa4:	04c49703          	lh	a4,76(s1)
    80004fa8:	4785                	li	a5,1
    80004faa:	04f71063          	bne	a4,a5,80004fea <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fae:	8526                	mv	a0,s1
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	e74080e7          	jalr	-396(ra) # 80002e24 <iunlock>
  iput(p->cwd);
    80004fb8:	15893503          	ld	a0,344(s2)
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	f60080e7          	jalr	-160(ra) # 80002f1c <iput>
  end_op();
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	7f0080e7          	jalr	2032(ra) # 800037b4 <end_op>
  p->cwd = ip;
    80004fcc:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fd0:	4501                	li	a0,0
}
    80004fd2:	60ea                	ld	ra,152(sp)
    80004fd4:	644a                	ld	s0,144(sp)
    80004fd6:	64aa                	ld	s1,136(sp)
    80004fd8:	690a                	ld	s2,128(sp)
    80004fda:	610d                	addi	sp,sp,160
    80004fdc:	8082                	ret
    end_op();
    80004fde:	ffffe097          	auipc	ra,0xffffe
    80004fe2:	7d6080e7          	jalr	2006(ra) # 800037b4 <end_op>
    return -1;
    80004fe6:	557d                	li	a0,-1
    80004fe8:	b7ed                	j	80004fd2 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fea:	8526                	mv	a0,s1
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	fd8080e7          	jalr	-40(ra) # 80002fc4 <iunlockput>
    end_op();
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	7c0080e7          	jalr	1984(ra) # 800037b4 <end_op>
    return -1;
    80004ffc:	557d                	li	a0,-1
    80004ffe:	bfd1                	j	80004fd2 <sys_chdir+0x7a>

0000000080005000 <sys_exec>:

uint64
sys_exec(void)
{
    80005000:	7145                	addi	sp,sp,-464
    80005002:	e786                	sd	ra,456(sp)
    80005004:	e3a2                	sd	s0,448(sp)
    80005006:	ff26                	sd	s1,440(sp)
    80005008:	fb4a                	sd	s2,432(sp)
    8000500a:	f74e                	sd	s3,424(sp)
    8000500c:	f352                	sd	s4,416(sp)
    8000500e:	ef56                	sd	s5,408(sp)
    80005010:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005012:	08000613          	li	a2,128
    80005016:	f4040593          	addi	a1,s0,-192
    8000501a:	4501                	li	a0,0
    8000501c:	ffffd097          	auipc	ra,0xffffd
    80005020:	00a080e7          	jalr	10(ra) # 80002026 <argstr>
    return -1;
    80005024:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005026:	0c054a63          	bltz	a0,800050fa <sys_exec+0xfa>
    8000502a:	e3840593          	addi	a1,s0,-456
    8000502e:	4505                	li	a0,1
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	fd4080e7          	jalr	-44(ra) # 80002004 <argaddr>
    80005038:	0c054163          	bltz	a0,800050fa <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000503c:	10000613          	li	a2,256
    80005040:	4581                	li	a1,0
    80005042:	e4040513          	addi	a0,s0,-448
    80005046:	ffffb097          	auipc	ra,0xffffb
    8000504a:	210080e7          	jalr	528(ra) # 80000256 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000504e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005052:	89a6                	mv	s3,s1
    80005054:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005056:	02000a13          	li	s4,32
    8000505a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000505e:	00391513          	slli	a0,s2,0x3
    80005062:	e3040593          	addi	a1,s0,-464
    80005066:	e3843783          	ld	a5,-456(s0)
    8000506a:	953e                	add	a0,a0,a5
    8000506c:	ffffd097          	auipc	ra,0xffffd
    80005070:	edc080e7          	jalr	-292(ra) # 80001f48 <fetchaddr>
    80005074:	02054a63          	bltz	a0,800050a8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005078:	e3043783          	ld	a5,-464(s0)
    8000507c:	c3b9                	beqz	a5,800050c2 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000507e:	ffffb097          	auipc	ra,0xffffb
    80005082:	0ee080e7          	jalr	238(ra) # 8000016c <kalloc>
    80005086:	85aa                	mv	a1,a0
    80005088:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000508c:	cd11                	beqz	a0,800050a8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000508e:	6605                	lui	a2,0x1
    80005090:	e3043503          	ld	a0,-464(s0)
    80005094:	ffffd097          	auipc	ra,0xffffd
    80005098:	f06080e7          	jalr	-250(ra) # 80001f9a <fetchstr>
    8000509c:	00054663          	bltz	a0,800050a8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050a0:	0905                	addi	s2,s2,1
    800050a2:	09a1                	addi	s3,s3,8
    800050a4:	fb491be3          	bne	s2,s4,8000505a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a8:	10048913          	addi	s2,s1,256
    800050ac:	6088                	ld	a0,0(s1)
    800050ae:	c529                	beqz	a0,800050f8 <sys_exec+0xf8>
    kfree(argv[i]);
    800050b0:	ffffb097          	auipc	ra,0xffffb
    800050b4:	f6c080e7          	jalr	-148(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b8:	04a1                	addi	s1,s1,8
    800050ba:	ff2499e3          	bne	s1,s2,800050ac <sys_exec+0xac>
  return -1;
    800050be:	597d                	li	s2,-1
    800050c0:	a82d                	j	800050fa <sys_exec+0xfa>
      argv[i] = 0;
    800050c2:	0a8e                	slli	s5,s5,0x3
    800050c4:	fc040793          	addi	a5,s0,-64
    800050c8:	9abe                	add	s5,s5,a5
    800050ca:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050ce:	e4040593          	addi	a1,s0,-448
    800050d2:	f4040513          	addi	a0,s0,-192
    800050d6:	fffff097          	auipc	ra,0xfffff
    800050da:	194080e7          	jalr	404(ra) # 8000426a <exec>
    800050de:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e0:	10048993          	addi	s3,s1,256
    800050e4:	6088                	ld	a0,0(s1)
    800050e6:	c911                	beqz	a0,800050fa <sys_exec+0xfa>
    kfree(argv[i]);
    800050e8:	ffffb097          	auipc	ra,0xffffb
    800050ec:	f34080e7          	jalr	-204(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f0:	04a1                	addi	s1,s1,8
    800050f2:	ff3499e3          	bne	s1,s3,800050e4 <sys_exec+0xe4>
    800050f6:	a011                	j	800050fa <sys_exec+0xfa>
  return -1;
    800050f8:	597d                	li	s2,-1
}
    800050fa:	854a                	mv	a0,s2
    800050fc:	60be                	ld	ra,456(sp)
    800050fe:	641e                	ld	s0,448(sp)
    80005100:	74fa                	ld	s1,440(sp)
    80005102:	795a                	ld	s2,432(sp)
    80005104:	79ba                	ld	s3,424(sp)
    80005106:	7a1a                	ld	s4,416(sp)
    80005108:	6afa                	ld	s5,408(sp)
    8000510a:	6179                	addi	sp,sp,464
    8000510c:	8082                	ret

000000008000510e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000510e:	7139                	addi	sp,sp,-64
    80005110:	fc06                	sd	ra,56(sp)
    80005112:	f822                	sd	s0,48(sp)
    80005114:	f426                	sd	s1,40(sp)
    80005116:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	e1e080e7          	jalr	-482(ra) # 80000f36 <myproc>
    80005120:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005122:	fd840593          	addi	a1,s0,-40
    80005126:	4501                	li	a0,0
    80005128:	ffffd097          	auipc	ra,0xffffd
    8000512c:	edc080e7          	jalr	-292(ra) # 80002004 <argaddr>
    return -1;
    80005130:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005132:	0e054063          	bltz	a0,80005212 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005136:	fc840593          	addi	a1,s0,-56
    8000513a:	fd040513          	addi	a0,s0,-48
    8000513e:	fffff097          	auipc	ra,0xfffff
    80005142:	df2080e7          	jalr	-526(ra) # 80003f30 <pipealloc>
    return -1;
    80005146:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005148:	0c054563          	bltz	a0,80005212 <sys_pipe+0x104>
  fd0 = -1;
    8000514c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005150:	fd043503          	ld	a0,-48(s0)
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	508080e7          	jalr	1288(ra) # 8000465c <fdalloc>
    8000515c:	fca42223          	sw	a0,-60(s0)
    80005160:	08054c63          	bltz	a0,800051f8 <sys_pipe+0xea>
    80005164:	fc843503          	ld	a0,-56(s0)
    80005168:	fffff097          	auipc	ra,0xfffff
    8000516c:	4f4080e7          	jalr	1268(ra) # 8000465c <fdalloc>
    80005170:	fca42023          	sw	a0,-64(s0)
    80005174:	06054863          	bltz	a0,800051e4 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005178:	4691                	li	a3,4
    8000517a:	fc440613          	addi	a2,s0,-60
    8000517e:	fd843583          	ld	a1,-40(s0)
    80005182:	6ca8                	ld	a0,88(s1)
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	a74080e7          	jalr	-1420(ra) # 80000bf8 <copyout>
    8000518c:	02054063          	bltz	a0,800051ac <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005190:	4691                	li	a3,4
    80005192:	fc040613          	addi	a2,s0,-64
    80005196:	fd843583          	ld	a1,-40(s0)
    8000519a:	0591                	addi	a1,a1,4
    8000519c:	6ca8                	ld	a0,88(s1)
    8000519e:	ffffc097          	auipc	ra,0xffffc
    800051a2:	a5a080e7          	jalr	-1446(ra) # 80000bf8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051a6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051a8:	06055563          	bgez	a0,80005212 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051ac:	fc442783          	lw	a5,-60(s0)
    800051b0:	07e9                	addi	a5,a5,26
    800051b2:	078e                	slli	a5,a5,0x3
    800051b4:	97a6                	add	a5,a5,s1
    800051b6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051ba:	fc042503          	lw	a0,-64(s0)
    800051be:	0569                	addi	a0,a0,26
    800051c0:	050e                	slli	a0,a0,0x3
    800051c2:	9526                	add	a0,a0,s1
    800051c4:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051c8:	fd043503          	ld	a0,-48(s0)
    800051cc:	fffff097          	auipc	ra,0xfffff
    800051d0:	a34080e7          	jalr	-1484(ra) # 80003c00 <fileclose>
    fileclose(wf);
    800051d4:	fc843503          	ld	a0,-56(s0)
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	a28080e7          	jalr	-1496(ra) # 80003c00 <fileclose>
    return -1;
    800051e0:	57fd                	li	a5,-1
    800051e2:	a805                	j	80005212 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051e4:	fc442783          	lw	a5,-60(s0)
    800051e8:	0007c863          	bltz	a5,800051f8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051ec:	01a78513          	addi	a0,a5,26
    800051f0:	050e                	slli	a0,a0,0x3
    800051f2:	9526                	add	a0,a0,s1
    800051f4:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051f8:	fd043503          	ld	a0,-48(s0)
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	a04080e7          	jalr	-1532(ra) # 80003c00 <fileclose>
    fileclose(wf);
    80005204:	fc843503          	ld	a0,-56(s0)
    80005208:	fffff097          	auipc	ra,0xfffff
    8000520c:	9f8080e7          	jalr	-1544(ra) # 80003c00 <fileclose>
    return -1;
    80005210:	57fd                	li	a5,-1
}
    80005212:	853e                	mv	a0,a5
    80005214:	70e2                	ld	ra,56(sp)
    80005216:	7442                	ld	s0,48(sp)
    80005218:	74a2                	ld	s1,40(sp)
    8000521a:	6121                	addi	sp,sp,64
    8000521c:	8082                	ret
	...

0000000080005220 <kernelvec>:
    80005220:	7111                	addi	sp,sp,-256
    80005222:	e006                	sd	ra,0(sp)
    80005224:	e40a                	sd	sp,8(sp)
    80005226:	e80e                	sd	gp,16(sp)
    80005228:	ec12                	sd	tp,24(sp)
    8000522a:	f016                	sd	t0,32(sp)
    8000522c:	f41a                	sd	t1,40(sp)
    8000522e:	f81e                	sd	t2,48(sp)
    80005230:	fc22                	sd	s0,56(sp)
    80005232:	e0a6                	sd	s1,64(sp)
    80005234:	e4aa                	sd	a0,72(sp)
    80005236:	e8ae                	sd	a1,80(sp)
    80005238:	ecb2                	sd	a2,88(sp)
    8000523a:	f0b6                	sd	a3,96(sp)
    8000523c:	f4ba                	sd	a4,104(sp)
    8000523e:	f8be                	sd	a5,112(sp)
    80005240:	fcc2                	sd	a6,120(sp)
    80005242:	e146                	sd	a7,128(sp)
    80005244:	e54a                	sd	s2,136(sp)
    80005246:	e94e                	sd	s3,144(sp)
    80005248:	ed52                	sd	s4,152(sp)
    8000524a:	f156                	sd	s5,160(sp)
    8000524c:	f55a                	sd	s6,168(sp)
    8000524e:	f95e                	sd	s7,176(sp)
    80005250:	fd62                	sd	s8,184(sp)
    80005252:	e1e6                	sd	s9,192(sp)
    80005254:	e5ea                	sd	s10,200(sp)
    80005256:	e9ee                	sd	s11,208(sp)
    80005258:	edf2                	sd	t3,216(sp)
    8000525a:	f1f6                	sd	t4,224(sp)
    8000525c:	f5fa                	sd	t5,232(sp)
    8000525e:	f9fe                	sd	t6,240(sp)
    80005260:	bb5fc0ef          	jal	ra,80001e14 <kerneltrap>
    80005264:	6082                	ld	ra,0(sp)
    80005266:	6122                	ld	sp,8(sp)
    80005268:	61c2                	ld	gp,16(sp)
    8000526a:	7282                	ld	t0,32(sp)
    8000526c:	7322                	ld	t1,40(sp)
    8000526e:	73c2                	ld	t2,48(sp)
    80005270:	7462                	ld	s0,56(sp)
    80005272:	6486                	ld	s1,64(sp)
    80005274:	6526                	ld	a0,72(sp)
    80005276:	65c6                	ld	a1,80(sp)
    80005278:	6666                	ld	a2,88(sp)
    8000527a:	7686                	ld	a3,96(sp)
    8000527c:	7726                	ld	a4,104(sp)
    8000527e:	77c6                	ld	a5,112(sp)
    80005280:	7866                	ld	a6,120(sp)
    80005282:	688a                	ld	a7,128(sp)
    80005284:	692a                	ld	s2,136(sp)
    80005286:	69ca                	ld	s3,144(sp)
    80005288:	6a6a                	ld	s4,152(sp)
    8000528a:	7a8a                	ld	s5,160(sp)
    8000528c:	7b2a                	ld	s6,168(sp)
    8000528e:	7bca                	ld	s7,176(sp)
    80005290:	7c6a                	ld	s8,184(sp)
    80005292:	6c8e                	ld	s9,192(sp)
    80005294:	6d2e                	ld	s10,200(sp)
    80005296:	6dce                	ld	s11,208(sp)
    80005298:	6e6e                	ld	t3,216(sp)
    8000529a:	7e8e                	ld	t4,224(sp)
    8000529c:	7f2e                	ld	t5,232(sp)
    8000529e:	7fce                	ld	t6,240(sp)
    800052a0:	6111                	addi	sp,sp,256
    800052a2:	10200073          	sret
    800052a6:	00000013          	nop
    800052aa:	00000013          	nop
    800052ae:	0001                	nop

00000000800052b0 <timervec>:
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	e10c                	sd	a1,0(a0)
    800052b6:	e510                	sd	a2,8(a0)
    800052b8:	e914                	sd	a3,16(a0)
    800052ba:	6d0c                	ld	a1,24(a0)
    800052bc:	7110                	ld	a2,32(a0)
    800052be:	6194                	ld	a3,0(a1)
    800052c0:	96b2                	add	a3,a3,a2
    800052c2:	e194                	sd	a3,0(a1)
    800052c4:	4589                	li	a1,2
    800052c6:	14459073          	csrw	sip,a1
    800052ca:	6914                	ld	a3,16(a0)
    800052cc:	6510                	ld	a2,8(a0)
    800052ce:	610c                	ld	a1,0(a0)
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	30200073          	mret
	...

00000000800052da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e422                	sd	s0,8(sp)
    800052de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052e0:	0c0007b7          	lui	a5,0xc000
    800052e4:	4705                	li	a4,1
    800052e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052e8:	c3d8                	sw	a4,4(a5)
}
    800052ea:	6422                	ld	s0,8(sp)
    800052ec:	0141                	addi	sp,sp,16
    800052ee:	8082                	ret

00000000800052f0 <plicinithart>:

void
plicinithart(void)
{
    800052f0:	1141                	addi	sp,sp,-16
    800052f2:	e406                	sd	ra,8(sp)
    800052f4:	e022                	sd	s0,0(sp)
    800052f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	c12080e7          	jalr	-1006(ra) # 80000f0a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005300:	0085171b          	slliw	a4,a0,0x8
    80005304:	0c0027b7          	lui	a5,0xc002
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	40200713          	li	a4,1026
    8000530e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005312:	00d5151b          	slliw	a0,a0,0xd
    80005316:	0c2017b7          	lui	a5,0xc201
    8000531a:	953e                	add	a0,a0,a5
    8000531c:	00052023          	sw	zero,0(a0)
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005328:	1141                	addi	sp,sp,-16
    8000532a:	e406                	sd	ra,8(sp)
    8000532c:	e022                	sd	s0,0(sp)
    8000532e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	bda080e7          	jalr	-1062(ra) # 80000f0a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005338:	00d5179b          	slliw	a5,a0,0xd
    8000533c:	0c201537          	lui	a0,0xc201
    80005340:	953e                	add	a0,a0,a5
  return irq;
}
    80005342:	4148                	lw	a0,4(a0)
    80005344:	60a2                	ld	ra,8(sp)
    80005346:	6402                	ld	s0,0(sp)
    80005348:	0141                	addi	sp,sp,16
    8000534a:	8082                	ret

000000008000534c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000534c:	1101                	addi	sp,sp,-32
    8000534e:	ec06                	sd	ra,24(sp)
    80005350:	e822                	sd	s0,16(sp)
    80005352:	e426                	sd	s1,8(sp)
    80005354:	1000                	addi	s0,sp,32
    80005356:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	bb2080e7          	jalr	-1102(ra) # 80000f0a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005360:	00d5151b          	slliw	a0,a0,0xd
    80005364:	0c2017b7          	lui	a5,0xc201
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	c3c4                	sw	s1,4(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret

0000000080005376 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005376:	1141                	addi	sp,sp,-16
    80005378:	e406                	sd	ra,8(sp)
    8000537a:	e022                	sd	s0,0(sp)
    8000537c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000537e:	479d                	li	a5,7
    80005380:	06a7c963          	blt	a5,a0,800053f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005384:	00019797          	auipc	a5,0x19
    80005388:	c7c78793          	addi	a5,a5,-900 # 8001e000 <disk>
    8000538c:	00a78733          	add	a4,a5,a0
    80005390:	6789                	lui	a5,0x2
    80005392:	97ba                	add	a5,a5,a4
    80005394:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005398:	e7ad                	bnez	a5,80005402 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000539a:	00451793          	slli	a5,a0,0x4
    8000539e:	0001b717          	auipc	a4,0x1b
    800053a2:	c6270713          	addi	a4,a4,-926 # 80020000 <disk+0x2000>
    800053a6:	6314                	ld	a3,0(a4)
    800053a8:	96be                	add	a3,a3,a5
    800053aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053ae:	6314                	ld	a3,0(a4)
    800053b0:	96be                	add	a3,a3,a5
    800053b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053b6:	6314                	ld	a3,0(a4)
    800053b8:	96be                	add	a3,a3,a5
    800053ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053be:	6318                	ld	a4,0(a4)
    800053c0:	97ba                	add	a5,a5,a4
    800053c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053c6:	00019797          	auipc	a5,0x19
    800053ca:	c3a78793          	addi	a5,a5,-966 # 8001e000 <disk>
    800053ce:	97aa                	add	a5,a5,a0
    800053d0:	6509                	lui	a0,0x2
    800053d2:	953e                	add	a0,a0,a5
    800053d4:	4785                	li	a5,1
    800053d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053da:	0001b517          	auipc	a0,0x1b
    800053de:	c3e50513          	addi	a0,a0,-962 # 80020018 <disk+0x2018>
    800053e2:	ffffc097          	auipc	ra,0xffffc
    800053e6:	39c080e7          	jalr	924(ra) # 8000177e <wakeup>
}
    800053ea:	60a2                	ld	ra,8(sp)
    800053ec:	6402                	ld	s0,0(sp)
    800053ee:	0141                	addi	sp,sp,16
    800053f0:	8082                	ret
    panic("free_desc 1");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	2f650513          	addi	a0,a0,758 # 800086e8 <syscalls+0x320>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	d52080e7          	jalr	-686(ra) # 8000614c <panic>
    panic("free_desc 2");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	2f650513          	addi	a0,a0,758 # 800086f8 <syscalls+0x330>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	d42080e7          	jalr	-702(ra) # 8000614c <panic>

0000000080005412 <virtio_disk_init>:
{
    80005412:	1101                	addi	sp,sp,-32
    80005414:	ec06                	sd	ra,24(sp)
    80005416:	e822                	sd	s0,16(sp)
    80005418:	e426                	sd	s1,8(sp)
    8000541a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000541c:	00003597          	auipc	a1,0x3
    80005420:	2ec58593          	addi	a1,a1,748 # 80008708 <syscalls+0x340>
    80005424:	0001b517          	auipc	a0,0x1b
    80005428:	d0450513          	addi	a0,a0,-764 # 80020128 <disk+0x2128>
    8000542c:	00001097          	auipc	ra,0x1
    80005430:	3d0080e7          	jalr	976(ra) # 800067fc <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	4398                	lw	a4,0(a5)
    8000543a:	2701                	sext.w	a4,a4
    8000543c:	747277b7          	lui	a5,0x74727
    80005440:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005444:	0ef71163          	bne	a4,a5,80005526 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005448:	100017b7          	lui	a5,0x10001
    8000544c:	43dc                	lw	a5,4(a5)
    8000544e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005450:	4705                	li	a4,1
    80005452:	0ce79a63          	bne	a5,a4,80005526 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	479c                	lw	a5,8(a5)
    8000545c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000545e:	4709                	li	a4,2
    80005460:	0ce79363          	bne	a5,a4,80005526 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005464:	100017b7          	lui	a5,0x10001
    80005468:	47d8                	lw	a4,12(a5)
    8000546a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546c:	554d47b7          	lui	a5,0x554d4
    80005470:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005474:	0af71963          	bne	a4,a5,80005526 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005478:	100017b7          	lui	a5,0x10001
    8000547c:	4705                	li	a4,1
    8000547e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005480:	470d                	li	a4,3
    80005482:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005484:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005486:	c7ffe737          	lui	a4,0xc7ffe
    8000548a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    8000548e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005490:	2701                	sext.w	a4,a4
    80005492:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005494:	472d                	li	a4,11
    80005496:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005498:	473d                	li	a4,15
    8000549a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000549c:	6705                	lui	a4,0x1
    8000549e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054a4:	5bdc                	lw	a5,52(a5)
    800054a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054a8:	c7d9                	beqz	a5,80005536 <virtio_disk_init+0x124>
  if(max < NUM)
    800054aa:	471d                	li	a4,7
    800054ac:	08f77d63          	bgeu	a4,a5,80005546 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054b0:	100014b7          	lui	s1,0x10001
    800054b4:	47a1                	li	a5,8
    800054b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054b8:	6609                	lui	a2,0x2
    800054ba:	4581                	li	a1,0
    800054bc:	00019517          	auipc	a0,0x19
    800054c0:	b4450513          	addi	a0,a0,-1212 # 8001e000 <disk>
    800054c4:	ffffb097          	auipc	ra,0xffffb
    800054c8:	d92080e7          	jalr	-622(ra) # 80000256 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054cc:	00019717          	auipc	a4,0x19
    800054d0:	b3470713          	addi	a4,a4,-1228 # 8001e000 <disk>
    800054d4:	00c75793          	srli	a5,a4,0xc
    800054d8:	2781                	sext.w	a5,a5
    800054da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054dc:	0001b797          	auipc	a5,0x1b
    800054e0:	b2478793          	addi	a5,a5,-1244 # 80020000 <disk+0x2000>
    800054e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054e6:	00019717          	auipc	a4,0x19
    800054ea:	b9a70713          	addi	a4,a4,-1126 # 8001e080 <disk+0x80>
    800054ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054f0:	0001a717          	auipc	a4,0x1a
    800054f4:	b1070713          	addi	a4,a4,-1264 # 8001f000 <disk+0x1000>
    800054f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054fa:	4705                	li	a4,1
    800054fc:	00e78c23          	sb	a4,24(a5)
    80005500:	00e78ca3          	sb	a4,25(a5)
    80005504:	00e78d23          	sb	a4,26(a5)
    80005508:	00e78da3          	sb	a4,27(a5)
    8000550c:	00e78e23          	sb	a4,28(a5)
    80005510:	00e78ea3          	sb	a4,29(a5)
    80005514:	00e78f23          	sb	a4,30(a5)
    80005518:	00e78fa3          	sb	a4,31(a5)
}
    8000551c:	60e2                	ld	ra,24(sp)
    8000551e:	6442                	ld	s0,16(sp)
    80005520:	64a2                	ld	s1,8(sp)
    80005522:	6105                	addi	sp,sp,32
    80005524:	8082                	ret
    panic("could not find virtio disk");
    80005526:	00003517          	auipc	a0,0x3
    8000552a:	1f250513          	addi	a0,a0,498 # 80008718 <syscalls+0x350>
    8000552e:	00001097          	auipc	ra,0x1
    80005532:	c1e080e7          	jalr	-994(ra) # 8000614c <panic>
    panic("virtio disk has no queue 0");
    80005536:	00003517          	auipc	a0,0x3
    8000553a:	20250513          	addi	a0,a0,514 # 80008738 <syscalls+0x370>
    8000553e:	00001097          	auipc	ra,0x1
    80005542:	c0e080e7          	jalr	-1010(ra) # 8000614c <panic>
    panic("virtio disk max queue too short");
    80005546:	00003517          	auipc	a0,0x3
    8000554a:	21250513          	addi	a0,a0,530 # 80008758 <syscalls+0x390>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	bfe080e7          	jalr	-1026(ra) # 8000614c <panic>

0000000080005556 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005556:	7159                	addi	sp,sp,-112
    80005558:	f486                	sd	ra,104(sp)
    8000555a:	f0a2                	sd	s0,96(sp)
    8000555c:	eca6                	sd	s1,88(sp)
    8000555e:	e8ca                	sd	s2,80(sp)
    80005560:	e4ce                	sd	s3,72(sp)
    80005562:	e0d2                	sd	s4,64(sp)
    80005564:	fc56                	sd	s5,56(sp)
    80005566:	f85a                	sd	s6,48(sp)
    80005568:	f45e                	sd	s7,40(sp)
    8000556a:	f062                	sd	s8,32(sp)
    8000556c:	ec66                	sd	s9,24(sp)
    8000556e:	e86a                	sd	s10,16(sp)
    80005570:	1880                	addi	s0,sp,112
    80005572:	892a                	mv	s2,a0
    80005574:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005576:	00c52c83          	lw	s9,12(a0)
    8000557a:	001c9c9b          	slliw	s9,s9,0x1
    8000557e:	1c82                	slli	s9,s9,0x20
    80005580:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005584:	0001b517          	auipc	a0,0x1b
    80005588:	ba450513          	addi	a0,a0,-1116 # 80020128 <disk+0x2128>
    8000558c:	00001097          	auipc	ra,0x1
    80005590:	0f4080e7          	jalr	244(ra) # 80006680 <acquire>
  for(int i = 0; i < 3; i++){
    80005594:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005596:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005598:	00019b97          	auipc	s7,0x19
    8000559c:	a68b8b93          	addi	s7,s7,-1432 # 8001e000 <disk>
    800055a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800055a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055a4:	8a4e                	mv	s4,s3
    800055a6:	a051                	j	8000562a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800055a8:	00fb86b3          	add	a3,s7,a5
    800055ac:	96da                	add	a3,a3,s6
    800055ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055b4:	0207c563          	bltz	a5,800055de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055b8:	2485                	addiw	s1,s1,1
    800055ba:	0711                	addi	a4,a4,4
    800055bc:	25548063          	beq	s1,s5,800057fc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055c2:	0001b697          	auipc	a3,0x1b
    800055c6:	a5668693          	addi	a3,a3,-1450 # 80020018 <disk+0x2018>
    800055ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055cc:	0006c583          	lbu	a1,0(a3)
    800055d0:	fde1                	bnez	a1,800055a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055d2:	2785                	addiw	a5,a5,1
    800055d4:	0685                	addi	a3,a3,1
    800055d6:	ff879be3          	bne	a5,s8,800055cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055da:	57fd                	li	a5,-1
    800055dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055de:	02905a63          	blez	s1,80005612 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055e2:	f9042503          	lw	a0,-112(s0)
    800055e6:	00000097          	auipc	ra,0x0
    800055ea:	d90080e7          	jalr	-624(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    800055ee:	4785                	li	a5,1
    800055f0:	0297d163          	bge	a5,s1,80005612 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055f4:	f9442503          	lw	a0,-108(s0)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	d7e080e7          	jalr	-642(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    80005600:	4789                	li	a5,2
    80005602:	0097d863          	bge	a5,s1,80005612 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005606:	f9842503          	lw	a0,-104(s0)
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	d6c080e7          	jalr	-660(ra) # 80005376 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005612:	0001b597          	auipc	a1,0x1b
    80005616:	b1658593          	addi	a1,a1,-1258 # 80020128 <disk+0x2128>
    8000561a:	0001b517          	auipc	a0,0x1b
    8000561e:	9fe50513          	addi	a0,a0,-1538 # 80020018 <disk+0x2018>
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	fd0080e7          	jalr	-48(ra) # 800015f2 <sleep>
  for(int i = 0; i < 3; i++){
    8000562a:	f9040713          	addi	a4,s0,-112
    8000562e:	84ce                	mv	s1,s3
    80005630:	bf41                	j	800055c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005632:	20058713          	addi	a4,a1,512
    80005636:	00471693          	slli	a3,a4,0x4
    8000563a:	00019717          	auipc	a4,0x19
    8000563e:	9c670713          	addi	a4,a4,-1594 # 8001e000 <disk>
    80005642:	9736                	add	a4,a4,a3
    80005644:	4685                	li	a3,1
    80005646:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000564a:	20058713          	addi	a4,a1,512
    8000564e:	00471693          	slli	a3,a4,0x4
    80005652:	00019717          	auipc	a4,0x19
    80005656:	9ae70713          	addi	a4,a4,-1618 # 8001e000 <disk>
    8000565a:	9736                	add	a4,a4,a3
    8000565c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005660:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005664:	7679                	lui	a2,0xffffe
    80005666:	963e                	add	a2,a2,a5
    80005668:	0001b697          	auipc	a3,0x1b
    8000566c:	99868693          	addi	a3,a3,-1640 # 80020000 <disk+0x2000>
    80005670:	6298                	ld	a4,0(a3)
    80005672:	9732                	add	a4,a4,a2
    80005674:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005676:	6298                	ld	a4,0(a3)
    80005678:	9732                	add	a4,a4,a2
    8000567a:	4541                	li	a0,16
    8000567c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000567e:	6298                	ld	a4,0(a3)
    80005680:	9732                	add	a4,a4,a2
    80005682:	4505                	li	a0,1
    80005684:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005688:	f9442703          	lw	a4,-108(s0)
    8000568c:	6288                	ld	a0,0(a3)
    8000568e:	962a                	add	a2,a2,a0
    80005690:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005694:	0712                	slli	a4,a4,0x4
    80005696:	6290                	ld	a2,0(a3)
    80005698:	963a                	add	a2,a2,a4
    8000569a:	06090513          	addi	a0,s2,96
    8000569e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056a0:	6294                	ld	a3,0(a3)
    800056a2:	96ba                	add	a3,a3,a4
    800056a4:	40000613          	li	a2,1024
    800056a8:	c690                	sw	a2,8(a3)
  if(write)
    800056aa:	140d0063          	beqz	s10,800057ea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056ae:	0001b697          	auipc	a3,0x1b
    800056b2:	9526b683          	ld	a3,-1710(a3) # 80020000 <disk+0x2000>
    800056b6:	96ba                	add	a3,a3,a4
    800056b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056bc:	00019817          	auipc	a6,0x19
    800056c0:	94480813          	addi	a6,a6,-1724 # 8001e000 <disk>
    800056c4:	0001b517          	auipc	a0,0x1b
    800056c8:	93c50513          	addi	a0,a0,-1732 # 80020000 <disk+0x2000>
    800056cc:	6114                	ld	a3,0(a0)
    800056ce:	96ba                	add	a3,a3,a4
    800056d0:	00c6d603          	lhu	a2,12(a3)
    800056d4:	00166613          	ori	a2,a2,1
    800056d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056dc:	f9842683          	lw	a3,-104(s0)
    800056e0:	6110                	ld	a2,0(a0)
    800056e2:	9732                	add	a4,a4,a2
    800056e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056e8:	20058613          	addi	a2,a1,512
    800056ec:	0612                	slli	a2,a2,0x4
    800056ee:	9642                	add	a2,a2,a6
    800056f0:	577d                	li	a4,-1
    800056f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056f6:	00469713          	slli	a4,a3,0x4
    800056fa:	6114                	ld	a3,0(a0)
    800056fc:	96ba                	add	a3,a3,a4
    800056fe:	03078793          	addi	a5,a5,48
    80005702:	97c2                	add	a5,a5,a6
    80005704:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005706:	611c                	ld	a5,0(a0)
    80005708:	97ba                	add	a5,a5,a4
    8000570a:	4685                	li	a3,1
    8000570c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000570e:	611c                	ld	a5,0(a0)
    80005710:	97ba                	add	a5,a5,a4
    80005712:	4809                	li	a6,2
    80005714:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005718:	611c                	ld	a5,0(a0)
    8000571a:	973e                	add	a4,a4,a5
    8000571c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005720:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005724:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005728:	6518                	ld	a4,8(a0)
    8000572a:	00275783          	lhu	a5,2(a4)
    8000572e:	8b9d                	andi	a5,a5,7
    80005730:	0786                	slli	a5,a5,0x1
    80005732:	97ba                	add	a5,a5,a4
    80005734:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005738:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000573c:	6518                	ld	a4,8(a0)
    8000573e:	00275783          	lhu	a5,2(a4)
    80005742:	2785                	addiw	a5,a5,1
    80005744:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005748:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000574c:	100017b7          	lui	a5,0x10001
    80005750:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005754:	00492703          	lw	a4,4(s2)
    80005758:	4785                	li	a5,1
    8000575a:	02f71163          	bne	a4,a5,8000577c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000575e:	0001b997          	auipc	s3,0x1b
    80005762:	9ca98993          	addi	s3,s3,-1590 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005766:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005768:	85ce                	mv	a1,s3
    8000576a:	854a                	mv	a0,s2
    8000576c:	ffffc097          	auipc	ra,0xffffc
    80005770:	e86080e7          	jalr	-378(ra) # 800015f2 <sleep>
  while(b->disk == 1) {
    80005774:	00492783          	lw	a5,4(s2)
    80005778:	fe9788e3          	beq	a5,s1,80005768 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000577c:	f9042903          	lw	s2,-112(s0)
    80005780:	20090793          	addi	a5,s2,512
    80005784:	00479713          	slli	a4,a5,0x4
    80005788:	00019797          	auipc	a5,0x19
    8000578c:	87878793          	addi	a5,a5,-1928 # 8001e000 <disk>
    80005790:	97ba                	add	a5,a5,a4
    80005792:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005796:	0001b997          	auipc	s3,0x1b
    8000579a:	86a98993          	addi	s3,s3,-1942 # 80020000 <disk+0x2000>
    8000579e:	00491713          	slli	a4,s2,0x4
    800057a2:	0009b783          	ld	a5,0(s3)
    800057a6:	97ba                	add	a5,a5,a4
    800057a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057ac:	854a                	mv	a0,s2
    800057ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b2:	00000097          	auipc	ra,0x0
    800057b6:	bc4080e7          	jalr	-1084(ra) # 80005376 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057ba:	8885                	andi	s1,s1,1
    800057bc:	f0ed                	bnez	s1,8000579e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057be:	0001b517          	auipc	a0,0x1b
    800057c2:	96a50513          	addi	a0,a0,-1686 # 80020128 <disk+0x2128>
    800057c6:	00001097          	auipc	ra,0x1
    800057ca:	f8a080e7          	jalr	-118(ra) # 80006750 <release>
}
    800057ce:	70a6                	ld	ra,104(sp)
    800057d0:	7406                	ld	s0,96(sp)
    800057d2:	64e6                	ld	s1,88(sp)
    800057d4:	6946                	ld	s2,80(sp)
    800057d6:	69a6                	ld	s3,72(sp)
    800057d8:	6a06                	ld	s4,64(sp)
    800057da:	7ae2                	ld	s5,56(sp)
    800057dc:	7b42                	ld	s6,48(sp)
    800057de:	7ba2                	ld	s7,40(sp)
    800057e0:	7c02                	ld	s8,32(sp)
    800057e2:	6ce2                	ld	s9,24(sp)
    800057e4:	6d42                	ld	s10,16(sp)
    800057e6:	6165                	addi	sp,sp,112
    800057e8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057ea:	0001b697          	auipc	a3,0x1b
    800057ee:	8166b683          	ld	a3,-2026(a3) # 80020000 <disk+0x2000>
    800057f2:	96ba                	add	a3,a3,a4
    800057f4:	4609                	li	a2,2
    800057f6:	00c69623          	sh	a2,12(a3)
    800057fa:	b5c9                	j	800056bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057fc:	f9042583          	lw	a1,-112(s0)
    80005800:	20058793          	addi	a5,a1,512
    80005804:	0792                	slli	a5,a5,0x4
    80005806:	00019517          	auipc	a0,0x19
    8000580a:	8a250513          	addi	a0,a0,-1886 # 8001e0a8 <disk+0xa8>
    8000580e:	953e                	add	a0,a0,a5
  if(write)
    80005810:	e20d11e3          	bnez	s10,80005632 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005814:	20058713          	addi	a4,a1,512
    80005818:	00471693          	slli	a3,a4,0x4
    8000581c:	00018717          	auipc	a4,0x18
    80005820:	7e470713          	addi	a4,a4,2020 # 8001e000 <disk>
    80005824:	9736                	add	a4,a4,a3
    80005826:	0a072423          	sw	zero,168(a4)
    8000582a:	b505                	j	8000564a <virtio_disk_rw+0xf4>

000000008000582c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000582c:	1101                	addi	sp,sp,-32
    8000582e:	ec06                	sd	ra,24(sp)
    80005830:	e822                	sd	s0,16(sp)
    80005832:	e426                	sd	s1,8(sp)
    80005834:	e04a                	sd	s2,0(sp)
    80005836:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005838:	0001b517          	auipc	a0,0x1b
    8000583c:	8f050513          	addi	a0,a0,-1808 # 80020128 <disk+0x2128>
    80005840:	00001097          	auipc	ra,0x1
    80005844:	e40080e7          	jalr	-448(ra) # 80006680 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005848:	10001737          	lui	a4,0x10001
    8000584c:	533c                	lw	a5,96(a4)
    8000584e:	8b8d                	andi	a5,a5,3
    80005850:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005852:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005856:	0001a797          	auipc	a5,0x1a
    8000585a:	7aa78793          	addi	a5,a5,1962 # 80020000 <disk+0x2000>
    8000585e:	6b94                	ld	a3,16(a5)
    80005860:	0207d703          	lhu	a4,32(a5)
    80005864:	0026d783          	lhu	a5,2(a3)
    80005868:	06f70163          	beq	a4,a5,800058ca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000586c:	00018917          	auipc	s2,0x18
    80005870:	79490913          	addi	s2,s2,1940 # 8001e000 <disk>
    80005874:	0001a497          	auipc	s1,0x1a
    80005878:	78c48493          	addi	s1,s1,1932 # 80020000 <disk+0x2000>
    __sync_synchronize();
    8000587c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005880:	6898                	ld	a4,16(s1)
    80005882:	0204d783          	lhu	a5,32(s1)
    80005886:	8b9d                	andi	a5,a5,7
    80005888:	078e                	slli	a5,a5,0x3
    8000588a:	97ba                	add	a5,a5,a4
    8000588c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000588e:	20078713          	addi	a4,a5,512
    80005892:	0712                	slli	a4,a4,0x4
    80005894:	974a                	add	a4,a4,s2
    80005896:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000589a:	e731                	bnez	a4,800058e6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000589c:	20078793          	addi	a5,a5,512
    800058a0:	0792                	slli	a5,a5,0x4
    800058a2:	97ca                	add	a5,a5,s2
    800058a4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058a6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058aa:	ffffc097          	auipc	ra,0xffffc
    800058ae:	ed4080e7          	jalr	-300(ra) # 8000177e <wakeup>

    disk.used_idx += 1;
    800058b2:	0204d783          	lhu	a5,32(s1)
    800058b6:	2785                	addiw	a5,a5,1
    800058b8:	17c2                	slli	a5,a5,0x30
    800058ba:	93c1                	srli	a5,a5,0x30
    800058bc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058c0:	6898                	ld	a4,16(s1)
    800058c2:	00275703          	lhu	a4,2(a4)
    800058c6:	faf71be3          	bne	a4,a5,8000587c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058ca:	0001b517          	auipc	a0,0x1b
    800058ce:	85e50513          	addi	a0,a0,-1954 # 80020128 <disk+0x2128>
    800058d2:	00001097          	auipc	ra,0x1
    800058d6:	e7e080e7          	jalr	-386(ra) # 80006750 <release>
}
    800058da:	60e2                	ld	ra,24(sp)
    800058dc:	6442                	ld	s0,16(sp)
    800058de:	64a2                	ld	s1,8(sp)
    800058e0:	6902                	ld	s2,0(sp)
    800058e2:	6105                	addi	sp,sp,32
    800058e4:	8082                	ret
      panic("virtio_disk_intr status");
    800058e6:	00003517          	auipc	a0,0x3
    800058ea:	e9250513          	addi	a0,a0,-366 # 80008778 <syscalls+0x3b0>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	85e080e7          	jalr	-1954(ra) # 8000614c <panic>

00000000800058f6 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    800058f6:	1141                	addi	sp,sp,-16
    800058f8:	e422                	sd	s0,8(sp)
    800058fa:	0800                	addi	s0,sp,16
  return -1;
}
    800058fc:	557d                	li	a0,-1
    800058fe:	6422                	ld	s0,8(sp)
    80005900:	0141                	addi	sp,sp,16
    80005902:	8082                	ret

0000000080005904 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005904:	7179                	addi	sp,sp,-48
    80005906:	f406                	sd	ra,40(sp)
    80005908:	f022                	sd	s0,32(sp)
    8000590a:	ec26                	sd	s1,24(sp)
    8000590c:	e84a                	sd	s2,16(sp)
    8000590e:	e44e                	sd	s3,8(sp)
    80005910:	e052                	sd	s4,0(sp)
    80005912:	1800                	addi	s0,sp,48
    80005914:	892a                	mv	s2,a0
    80005916:	89ae                	mv	s3,a1
    80005918:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    8000591a:	0001b517          	auipc	a0,0x1b
    8000591e:	6e650513          	addi	a0,a0,1766 # 80021000 <stats>
    80005922:	00001097          	auipc	ra,0x1
    80005926:	d5e080e7          	jalr	-674(ra) # 80006680 <acquire>

  if(stats.sz == 0) {
    8000592a:	0001c797          	auipc	a5,0x1c
    8000592e:	6f67a783          	lw	a5,1782(a5) # 80022020 <stats+0x1020>
    80005932:	cbb5                	beqz	a5,800059a6 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005934:	0001c797          	auipc	a5,0x1c
    80005938:	6cc78793          	addi	a5,a5,1740 # 80022000 <stats+0x1000>
    8000593c:	53d8                	lw	a4,36(a5)
    8000593e:	539c                	lw	a5,32(a5)
    80005940:	9f99                	subw	a5,a5,a4
    80005942:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005946:	06d05e63          	blez	a3,800059c2 <statsread+0xbe>
    if(m > n)
    8000594a:	8a3e                	mv	s4,a5
    8000594c:	00d4d363          	bge	s1,a3,80005952 <statsread+0x4e>
    80005950:	8a26                	mv	s4,s1
    80005952:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005956:	86a6                	mv	a3,s1
    80005958:	0001b617          	auipc	a2,0x1b
    8000595c:	6c860613          	addi	a2,a2,1736 # 80021020 <stats+0x20>
    80005960:	963a                	add	a2,a2,a4
    80005962:	85ce                	mv	a1,s3
    80005964:	854a                	mv	a0,s2
    80005966:	ffffc097          	auipc	ra,0xffffc
    8000596a:	030080e7          	jalr	48(ra) # 80001996 <either_copyout>
    8000596e:	57fd                	li	a5,-1
    80005970:	00f50a63          	beq	a0,a5,80005984 <statsread+0x80>
      stats.off += m;
    80005974:	0001c717          	auipc	a4,0x1c
    80005978:	68c70713          	addi	a4,a4,1676 # 80022000 <stats+0x1000>
    8000597c:	535c                	lw	a5,36(a4)
    8000597e:	014787bb          	addw	a5,a5,s4
    80005982:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005984:	0001b517          	auipc	a0,0x1b
    80005988:	67c50513          	addi	a0,a0,1660 # 80021000 <stats>
    8000598c:	00001097          	auipc	ra,0x1
    80005990:	dc4080e7          	jalr	-572(ra) # 80006750 <release>
  return m;
}
    80005994:	8526                	mv	a0,s1
    80005996:	70a2                	ld	ra,40(sp)
    80005998:	7402                	ld	s0,32(sp)
    8000599a:	64e2                	ld	s1,24(sp)
    8000599c:	6942                	ld	s2,16(sp)
    8000599e:	69a2                	ld	s3,8(sp)
    800059a0:	6a02                	ld	s4,0(sp)
    800059a2:	6145                	addi	sp,sp,48
    800059a4:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    800059a6:	6585                	lui	a1,0x1
    800059a8:	0001b517          	auipc	a0,0x1b
    800059ac:	67850513          	addi	a0,a0,1656 # 80021020 <stats+0x20>
    800059b0:	00001097          	auipc	ra,0x1
    800059b4:	f28080e7          	jalr	-216(ra) # 800068d8 <statslock>
    800059b8:	0001c797          	auipc	a5,0x1c
    800059bc:	66a7a423          	sw	a0,1640(a5) # 80022020 <stats+0x1020>
    800059c0:	bf95                	j	80005934 <statsread+0x30>
    stats.sz = 0;
    800059c2:	0001c797          	auipc	a5,0x1c
    800059c6:	63e78793          	addi	a5,a5,1598 # 80022000 <stats+0x1000>
    800059ca:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    800059ce:	0207a223          	sw	zero,36(a5)
    m = -1;
    800059d2:	54fd                	li	s1,-1
    800059d4:	bf45                	j	80005984 <statsread+0x80>

00000000800059d6 <statsinit>:

void
statsinit(void)
{
    800059d6:	1141                	addi	sp,sp,-16
    800059d8:	e406                	sd	ra,8(sp)
    800059da:	e022                	sd	s0,0(sp)
    800059dc:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    800059de:	00003597          	auipc	a1,0x3
    800059e2:	db258593          	addi	a1,a1,-590 # 80008790 <syscalls+0x3c8>
    800059e6:	0001b517          	auipc	a0,0x1b
    800059ea:	61a50513          	addi	a0,a0,1562 # 80021000 <stats>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	e0e080e7          	jalr	-498(ra) # 800067fc <initlock>

  devsw[STATS].read = statsread;
    800059f6:	00017797          	auipc	a5,0x17
    800059fa:	40278793          	addi	a5,a5,1026 # 8001cdf8 <devsw>
    800059fe:	00000717          	auipc	a4,0x0
    80005a02:	f0670713          	addi	a4,a4,-250 # 80005904 <statsread>
    80005a06:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005a08:	00000717          	auipc	a4,0x0
    80005a0c:	eee70713          	addi	a4,a4,-274 # 800058f6 <statswrite>
    80005a10:	f798                	sd	a4,40(a5)
}
    80005a12:	60a2                	ld	ra,8(sp)
    80005a14:	6402                	ld	s0,0(sp)
    80005a16:	0141                	addi	sp,sp,16
    80005a18:	8082                	ret

0000000080005a1a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005a1a:	1101                	addi	sp,sp,-32
    80005a1c:	ec22                	sd	s0,24(sp)
    80005a1e:	1000                	addi	s0,sp,32
    80005a20:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005a22:	c299                	beqz	a3,80005a28 <sprintint+0xe>
    80005a24:	0805c163          	bltz	a1,80005aa6 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005a28:	2581                	sext.w	a1,a1
    80005a2a:	4301                	li	t1,0

  i = 0;
    80005a2c:	fe040713          	addi	a4,s0,-32
    80005a30:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005a32:	2601                	sext.w	a2,a2
    80005a34:	00003697          	auipc	a3,0x3
    80005a38:	d7c68693          	addi	a3,a3,-644 # 800087b0 <digits>
    80005a3c:	88aa                	mv	a7,a0
    80005a3e:	2505                	addiw	a0,a0,1
    80005a40:	02c5f7bb          	remuw	a5,a1,a2
    80005a44:	1782                	slli	a5,a5,0x20
    80005a46:	9381                	srli	a5,a5,0x20
    80005a48:	97b6                	add	a5,a5,a3
    80005a4a:	0007c783          	lbu	a5,0(a5)
    80005a4e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005a52:	0005879b          	sext.w	a5,a1
    80005a56:	02c5d5bb          	divuw	a1,a1,a2
    80005a5a:	0705                	addi	a4,a4,1
    80005a5c:	fec7f0e3          	bgeu	a5,a2,80005a3c <sprintint+0x22>

  if(sign)
    80005a60:	00030b63          	beqz	t1,80005a76 <sprintint+0x5c>
    buf[i++] = '-';
    80005a64:	ff040793          	addi	a5,s0,-16
    80005a68:	97aa                	add	a5,a5,a0
    80005a6a:	02d00713          	li	a4,45
    80005a6e:	fee78823          	sb	a4,-16(a5)
    80005a72:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005a76:	02a05c63          	blez	a0,80005aae <sprintint+0x94>
    80005a7a:	fe040793          	addi	a5,s0,-32
    80005a7e:	00a78733          	add	a4,a5,a0
    80005a82:	87c2                	mv	a5,a6
    80005a84:	0805                	addi	a6,a6,1
    80005a86:	fff5061b          	addiw	a2,a0,-1
    80005a8a:	1602                	slli	a2,a2,0x20
    80005a8c:	9201                	srli	a2,a2,0x20
    80005a8e:	9642                	add	a2,a2,a6
  *s = c;
    80005a90:	fff74683          	lbu	a3,-1(a4)
    80005a94:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005a98:	177d                	addi	a4,a4,-1
    80005a9a:	0785                	addi	a5,a5,1
    80005a9c:	fec79ae3          	bne	a5,a2,80005a90 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005aa0:	6462                	ld	s0,24(sp)
    80005aa2:	6105                	addi	sp,sp,32
    80005aa4:	8082                	ret
    x = -xx;
    80005aa6:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005aaa:	4305                	li	t1,1
    x = -xx;
    80005aac:	b741                	j	80005a2c <sprintint+0x12>
  while(--i >= 0)
    80005aae:	4501                	li	a0,0
    80005ab0:	bfc5                	j	80005aa0 <sprintint+0x86>

0000000080005ab2 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005ab2:	7171                	addi	sp,sp,-176
    80005ab4:	fc86                	sd	ra,120(sp)
    80005ab6:	f8a2                	sd	s0,112(sp)
    80005ab8:	f4a6                	sd	s1,104(sp)
    80005aba:	f0ca                	sd	s2,96(sp)
    80005abc:	ecce                	sd	s3,88(sp)
    80005abe:	e8d2                	sd	s4,80(sp)
    80005ac0:	e4d6                	sd	s5,72(sp)
    80005ac2:	e0da                	sd	s6,64(sp)
    80005ac4:	fc5e                	sd	s7,56(sp)
    80005ac6:	f862                	sd	s8,48(sp)
    80005ac8:	f466                	sd	s9,40(sp)
    80005aca:	f06a                	sd	s10,32(sp)
    80005acc:	ec6e                	sd	s11,24(sp)
    80005ace:	0100                	addi	s0,sp,128
    80005ad0:	e414                	sd	a3,8(s0)
    80005ad2:	e818                	sd	a4,16(s0)
    80005ad4:	ec1c                	sd	a5,24(s0)
    80005ad6:	03043023          	sd	a6,32(s0)
    80005ada:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005ade:	ca0d                	beqz	a2,80005b10 <snprintf+0x5e>
    80005ae0:	8baa                	mv	s7,a0
    80005ae2:	89ae                	mv	s3,a1
    80005ae4:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005ae6:	00840793          	addi	a5,s0,8
    80005aea:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005aee:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005af0:	4901                	li	s2,0
    80005af2:	02b05763          	blez	a1,80005b20 <snprintf+0x6e>
    if(c != '%'){
    80005af6:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005afa:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005afe:	02800d93          	li	s11,40
  *s = c;
    80005b02:	02500d13          	li	s10,37
    switch(c){
    80005b06:	07800c93          	li	s9,120
    80005b0a:	06400c13          	li	s8,100
    80005b0e:	a01d                	j	80005b34 <snprintf+0x82>
    panic("null fmt");
    80005b10:	00003517          	auipc	a0,0x3
    80005b14:	c9050513          	addi	a0,a0,-880 # 800087a0 <syscalls+0x3d8>
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	634080e7          	jalr	1588(ra) # 8000614c <panic>
  int off = 0;
    80005b20:	4481                	li	s1,0
    80005b22:	a86d                	j	80005bdc <snprintf+0x12a>
  *s = c;
    80005b24:	009b8733          	add	a4,s7,s1
    80005b28:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b2c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b2e:	2905                	addiw	s2,s2,1
    80005b30:	0b34d663          	bge	s1,s3,80005bdc <snprintf+0x12a>
    80005b34:	012a07b3          	add	a5,s4,s2
    80005b38:	0007c783          	lbu	a5,0(a5)
    80005b3c:	0007871b          	sext.w	a4,a5
    80005b40:	cfd1                	beqz	a5,80005bdc <snprintf+0x12a>
    if(c != '%'){
    80005b42:	ff5711e3          	bne	a4,s5,80005b24 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005b46:	2905                	addiw	s2,s2,1
    80005b48:	012a07b3          	add	a5,s4,s2
    80005b4c:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005b50:	c7d1                	beqz	a5,80005bdc <snprintf+0x12a>
    switch(c){
    80005b52:	05678c63          	beq	a5,s6,80005baa <snprintf+0xf8>
    80005b56:	02fb6763          	bltu	s6,a5,80005b84 <snprintf+0xd2>
    80005b5a:	0b578763          	beq	a5,s5,80005c08 <snprintf+0x156>
    80005b5e:	0b879b63          	bne	a5,s8,80005c14 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005b62:	f8843783          	ld	a5,-120(s0)
    80005b66:	00878713          	addi	a4,a5,8
    80005b6a:	f8e43423          	sd	a4,-120(s0)
    80005b6e:	4685                	li	a3,1
    80005b70:	4629                	li	a2,10
    80005b72:	438c                	lw	a1,0(a5)
    80005b74:	009b8533          	add	a0,s7,s1
    80005b78:	00000097          	auipc	ra,0x0
    80005b7c:	ea2080e7          	jalr	-350(ra) # 80005a1a <sprintint>
    80005b80:	9ca9                	addw	s1,s1,a0
      break;
    80005b82:	b775                	j	80005b2e <snprintf+0x7c>
    switch(c){
    80005b84:	09979863          	bne	a5,s9,80005c14 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005b88:	f8843783          	ld	a5,-120(s0)
    80005b8c:	00878713          	addi	a4,a5,8
    80005b90:	f8e43423          	sd	a4,-120(s0)
    80005b94:	4685                	li	a3,1
    80005b96:	4641                	li	a2,16
    80005b98:	438c                	lw	a1,0(a5)
    80005b9a:	009b8533          	add	a0,s7,s1
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	e7c080e7          	jalr	-388(ra) # 80005a1a <sprintint>
    80005ba6:	9ca9                	addw	s1,s1,a0
      break;
    80005ba8:	b759                	j	80005b2e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005baa:	f8843783          	ld	a5,-120(s0)
    80005bae:	00878713          	addi	a4,a5,8
    80005bb2:	f8e43423          	sd	a4,-120(s0)
    80005bb6:	639c                	ld	a5,0(a5)
    80005bb8:	c3b1                	beqz	a5,80005bfc <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005bba:	0007c703          	lbu	a4,0(a5)
    80005bbe:	db25                	beqz	a4,80005b2e <snprintf+0x7c>
    80005bc0:	0134de63          	bge	s1,s3,80005bdc <snprintf+0x12a>
    80005bc4:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005bc8:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005bcc:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005bce:	0785                	addi	a5,a5,1
    80005bd0:	0007c703          	lbu	a4,0(a5)
    80005bd4:	df29                	beqz	a4,80005b2e <snprintf+0x7c>
    80005bd6:	0685                	addi	a3,a3,1
    80005bd8:	fe9998e3          	bne	s3,s1,80005bc8 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005bdc:	8526                	mv	a0,s1
    80005bde:	70e6                	ld	ra,120(sp)
    80005be0:	7446                	ld	s0,112(sp)
    80005be2:	74a6                	ld	s1,104(sp)
    80005be4:	7906                	ld	s2,96(sp)
    80005be6:	69e6                	ld	s3,88(sp)
    80005be8:	6a46                	ld	s4,80(sp)
    80005bea:	6aa6                	ld	s5,72(sp)
    80005bec:	6b06                	ld	s6,64(sp)
    80005bee:	7be2                	ld	s7,56(sp)
    80005bf0:	7c42                	ld	s8,48(sp)
    80005bf2:	7ca2                	ld	s9,40(sp)
    80005bf4:	7d02                	ld	s10,32(sp)
    80005bf6:	6de2                	ld	s11,24(sp)
    80005bf8:	614d                	addi	sp,sp,176
    80005bfa:	8082                	ret
        s = "(null)";
    80005bfc:	00003797          	auipc	a5,0x3
    80005c00:	b9c78793          	addi	a5,a5,-1124 # 80008798 <syscalls+0x3d0>
      for(; *s && off < sz; s++)
    80005c04:	876e                	mv	a4,s11
    80005c06:	bf6d                	j	80005bc0 <snprintf+0x10e>
  *s = c;
    80005c08:	009b87b3          	add	a5,s7,s1
    80005c0c:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005c10:	2485                	addiw	s1,s1,1
      break;
    80005c12:	bf31                	j	80005b2e <snprintf+0x7c>
  *s = c;
    80005c14:	009b8733          	add	a4,s7,s1
    80005c18:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005c1c:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005c20:	975e                	add	a4,a4,s7
    80005c22:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c26:	2489                	addiw	s1,s1,2
      break;
    80005c28:	b719                	j	80005b2e <snprintf+0x7c>

0000000080005c2a <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c2a:	1141                	addi	sp,sp,-16
    80005c2c:	e422                	sd	s0,8(sp)
    80005c2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c30:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c34:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c38:	0037979b          	slliw	a5,a5,0x3
    80005c3c:	02004737          	lui	a4,0x2004
    80005c40:	97ba                	add	a5,a5,a4
    80005c42:	0200c737          	lui	a4,0x200c
    80005c46:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c4a:	000f4637          	lui	a2,0xf4
    80005c4e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c52:	95b2                	add	a1,a1,a2
    80005c54:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c56:	00269713          	slli	a4,a3,0x2
    80005c5a:	9736                	add	a4,a4,a3
    80005c5c:	00371693          	slli	a3,a4,0x3
    80005c60:	0001c717          	auipc	a4,0x1c
    80005c64:	3d070713          	addi	a4,a4,976 # 80022030 <timer_scratch>
    80005c68:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c6a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c6c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c6e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c72:	fffff797          	auipc	a5,0xfffff
    80005c76:	63e78793          	addi	a5,a5,1598 # 800052b0 <timervec>
    80005c7a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c7e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c82:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c86:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c8a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c8e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c92:	30479073          	csrw	mie,a5
}
    80005c96:	6422                	ld	s0,8(sp)
    80005c98:	0141                	addi	sp,sp,16
    80005c9a:	8082                	ret

0000000080005c9c <start>:
{
    80005c9c:	1141                	addi	sp,sp,-16
    80005c9e:	e406                	sd	ra,8(sp)
    80005ca0:	e022                	sd	s0,0(sp)
    80005ca2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ca4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005ca8:	7779                	lui	a4,0xffffe
    80005caa:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005cae:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005cb0:	6705                	lui	a4,0x1
    80005cb2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005cb6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005cb8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005cbc:	ffffa797          	auipc	a5,0xffffa
    80005cc0:	74878793          	addi	a5,a5,1864 # 80000404 <main>
    80005cc4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005cc8:	4781                	li	a5,0
    80005cca:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005cce:	67c1                	lui	a5,0x10
    80005cd0:	17fd                	addi	a5,a5,-1
    80005cd2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005cd6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cda:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cde:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005ce2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005ce6:	57fd                	li	a5,-1
    80005ce8:	83a9                	srli	a5,a5,0xa
    80005cea:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cee:	47bd                	li	a5,15
    80005cf0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	f36080e7          	jalr	-202(ra) # 80005c2a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cfc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005d00:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005d02:	823e                	mv	tp,a5
  asm volatile("mret");
    80005d04:	30200073          	mret
}
    80005d08:	60a2                	ld	ra,8(sp)
    80005d0a:	6402                	ld	s0,0(sp)
    80005d0c:	0141                	addi	sp,sp,16
    80005d0e:	8082                	ret

0000000080005d10 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d10:	715d                	addi	sp,sp,-80
    80005d12:	e486                	sd	ra,72(sp)
    80005d14:	e0a2                	sd	s0,64(sp)
    80005d16:	fc26                	sd	s1,56(sp)
    80005d18:	f84a                	sd	s2,48(sp)
    80005d1a:	f44e                	sd	s3,40(sp)
    80005d1c:	f052                	sd	s4,32(sp)
    80005d1e:	ec56                	sd	s5,24(sp)
    80005d20:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005d22:	04c05663          	blez	a2,80005d6e <consolewrite+0x5e>
    80005d26:	8a2a                	mv	s4,a0
    80005d28:	84ae                	mv	s1,a1
    80005d2a:	89b2                	mv	s3,a2
    80005d2c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d2e:	5afd                	li	s5,-1
    80005d30:	4685                	li	a3,1
    80005d32:	8626                	mv	a2,s1
    80005d34:	85d2                	mv	a1,s4
    80005d36:	fbf40513          	addi	a0,s0,-65
    80005d3a:	ffffc097          	auipc	ra,0xffffc
    80005d3e:	cb2080e7          	jalr	-846(ra) # 800019ec <either_copyin>
    80005d42:	01550c63          	beq	a0,s5,80005d5a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005d46:	fbf44503          	lbu	a0,-65(s0)
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	78e080e7          	jalr	1934(ra) # 800064d8 <uartputc>
  for(i = 0; i < n; i++){
    80005d52:	2905                	addiw	s2,s2,1
    80005d54:	0485                	addi	s1,s1,1
    80005d56:	fd299de3          	bne	s3,s2,80005d30 <consolewrite+0x20>
  }

  return i;
}
    80005d5a:	854a                	mv	a0,s2
    80005d5c:	60a6                	ld	ra,72(sp)
    80005d5e:	6406                	ld	s0,64(sp)
    80005d60:	74e2                	ld	s1,56(sp)
    80005d62:	7942                	ld	s2,48(sp)
    80005d64:	79a2                	ld	s3,40(sp)
    80005d66:	7a02                	ld	s4,32(sp)
    80005d68:	6ae2                	ld	s5,24(sp)
    80005d6a:	6161                	addi	sp,sp,80
    80005d6c:	8082                	ret
  for(i = 0; i < n; i++){
    80005d6e:	4901                	li	s2,0
    80005d70:	b7ed                	j	80005d5a <consolewrite+0x4a>

0000000080005d72 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d72:	7119                	addi	sp,sp,-128
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
    80005d90:	8b2a                	mv	s6,a0
    80005d92:	8aae                	mv	s5,a1
    80005d94:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d96:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005d9a:	00024517          	auipc	a0,0x24
    80005d9e:	3d650513          	addi	a0,a0,982 # 8002a170 <cons>
    80005da2:	00001097          	auipc	ra,0x1
    80005da6:	8de080e7          	jalr	-1826(ra) # 80006680 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005daa:	00024497          	auipc	s1,0x24
    80005dae:	3c648493          	addi	s1,s1,966 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005db2:	89a6                	mv	s3,s1
    80005db4:	00024917          	auipc	s2,0x24
    80005db8:	45c90913          	addi	s2,s2,1116 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005dbc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005dbe:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005dc0:	4da9                	li	s11,10
  while(n > 0){
    80005dc2:	07405863          	blez	s4,80005e32 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005dc6:	0a04a783          	lw	a5,160(s1)
    80005dca:	0a44a703          	lw	a4,164(s1)
    80005dce:	02f71463          	bne	a4,a5,80005df6 <consoleread+0x84>
      if(myproc()->killed){
    80005dd2:	ffffb097          	auipc	ra,0xffffb
    80005dd6:	164080e7          	jalr	356(ra) # 80000f36 <myproc>
    80005dda:	591c                	lw	a5,48(a0)
    80005ddc:	e7b5                	bnez	a5,80005e48 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005dde:	85ce                	mv	a1,s3
    80005de0:	854a                	mv	a0,s2
    80005de2:	ffffc097          	auipc	ra,0xffffc
    80005de6:	810080e7          	jalr	-2032(ra) # 800015f2 <sleep>
    while(cons.r == cons.w){
    80005dea:	0a04a783          	lw	a5,160(s1)
    80005dee:	0a44a703          	lw	a4,164(s1)
    80005df2:	fef700e3          	beq	a4,a5,80005dd2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005df6:	0017871b          	addiw	a4,a5,1
    80005dfa:	0ae4a023          	sw	a4,160(s1)
    80005dfe:	07f7f713          	andi	a4,a5,127
    80005e02:	9726                	add	a4,a4,s1
    80005e04:	02074703          	lbu	a4,32(a4)
    80005e08:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005e0c:	079c0663          	beq	s8,s9,80005e78 <consoleread+0x106>
    cbuf = c;
    80005e10:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e14:	4685                	li	a3,1
    80005e16:	f8f40613          	addi	a2,s0,-113
    80005e1a:	85d6                	mv	a1,s5
    80005e1c:	855a                	mv	a0,s6
    80005e1e:	ffffc097          	auipc	ra,0xffffc
    80005e22:	b78080e7          	jalr	-1160(ra) # 80001996 <either_copyout>
    80005e26:	01a50663          	beq	a0,s10,80005e32 <consoleread+0xc0>
    dst++;
    80005e2a:	0a85                	addi	s5,s5,1
    --n;
    80005e2c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005e2e:	f9bc1ae3          	bne	s8,s11,80005dc2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005e32:	00024517          	auipc	a0,0x24
    80005e36:	33e50513          	addi	a0,a0,830 # 8002a170 <cons>
    80005e3a:	00001097          	auipc	ra,0x1
    80005e3e:	916080e7          	jalr	-1770(ra) # 80006750 <release>

  return target - n;
    80005e42:	414b853b          	subw	a0,s7,s4
    80005e46:	a811                	j	80005e5a <consoleread+0xe8>
        release(&cons.lock);
    80005e48:	00024517          	auipc	a0,0x24
    80005e4c:	32850513          	addi	a0,a0,808 # 8002a170 <cons>
    80005e50:	00001097          	auipc	ra,0x1
    80005e54:	900080e7          	jalr	-1792(ra) # 80006750 <release>
        return -1;
    80005e58:	557d                	li	a0,-1
}
    80005e5a:	70e6                	ld	ra,120(sp)
    80005e5c:	7446                	ld	s0,112(sp)
    80005e5e:	74a6                	ld	s1,104(sp)
    80005e60:	7906                	ld	s2,96(sp)
    80005e62:	69e6                	ld	s3,88(sp)
    80005e64:	6a46                	ld	s4,80(sp)
    80005e66:	6aa6                	ld	s5,72(sp)
    80005e68:	6b06                	ld	s6,64(sp)
    80005e6a:	7be2                	ld	s7,56(sp)
    80005e6c:	7c42                	ld	s8,48(sp)
    80005e6e:	7ca2                	ld	s9,40(sp)
    80005e70:	7d02                	ld	s10,32(sp)
    80005e72:	6de2                	ld	s11,24(sp)
    80005e74:	6109                	addi	sp,sp,128
    80005e76:	8082                	ret
      if(n < target){
    80005e78:	000a071b          	sext.w	a4,s4
    80005e7c:	fb777be3          	bgeu	a4,s7,80005e32 <consoleread+0xc0>
        cons.r--;
    80005e80:	00024717          	auipc	a4,0x24
    80005e84:	38f72823          	sw	a5,912(a4) # 8002a210 <cons+0xa0>
    80005e88:	b76d                	j	80005e32 <consoleread+0xc0>

0000000080005e8a <consputc>:
{
    80005e8a:	1141                	addi	sp,sp,-16
    80005e8c:	e406                	sd	ra,8(sp)
    80005e8e:	e022                	sd	s0,0(sp)
    80005e90:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e92:	10000793          	li	a5,256
    80005e96:	00f50a63          	beq	a0,a5,80005eaa <consputc+0x20>
    uartputc_sync(c);
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	564080e7          	jalr	1380(ra) # 800063fe <uartputc_sync>
}
    80005ea2:	60a2                	ld	ra,8(sp)
    80005ea4:	6402                	ld	s0,0(sp)
    80005ea6:	0141                	addi	sp,sp,16
    80005ea8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005eaa:	4521                	li	a0,8
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	552080e7          	jalr	1362(ra) # 800063fe <uartputc_sync>
    80005eb4:	02000513          	li	a0,32
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	546080e7          	jalr	1350(ra) # 800063fe <uartputc_sync>
    80005ec0:	4521                	li	a0,8
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	53c080e7          	jalr	1340(ra) # 800063fe <uartputc_sync>
    80005eca:	bfe1                	j	80005ea2 <consputc+0x18>

0000000080005ecc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ecc:	1101                	addi	sp,sp,-32
    80005ece:	ec06                	sd	ra,24(sp)
    80005ed0:	e822                	sd	s0,16(sp)
    80005ed2:	e426                	sd	s1,8(sp)
    80005ed4:	e04a                	sd	s2,0(sp)
    80005ed6:	1000                	addi	s0,sp,32
    80005ed8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005eda:	00024517          	auipc	a0,0x24
    80005ede:	29650513          	addi	a0,a0,662 # 8002a170 <cons>
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	79e080e7          	jalr	1950(ra) # 80006680 <acquire>

  switch(c){
    80005eea:	47d5                	li	a5,21
    80005eec:	0af48663          	beq	s1,a5,80005f98 <consoleintr+0xcc>
    80005ef0:	0297ca63          	blt	a5,s1,80005f24 <consoleintr+0x58>
    80005ef4:	47a1                	li	a5,8
    80005ef6:	0ef48763          	beq	s1,a5,80005fe4 <consoleintr+0x118>
    80005efa:	47c1                	li	a5,16
    80005efc:	10f49a63          	bne	s1,a5,80006010 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005f00:	ffffc097          	auipc	ra,0xffffc
    80005f04:	b42080e7          	jalr	-1214(ra) # 80001a42 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005f08:	00024517          	auipc	a0,0x24
    80005f0c:	26850513          	addi	a0,a0,616 # 8002a170 <cons>
    80005f10:	00001097          	auipc	ra,0x1
    80005f14:	840080e7          	jalr	-1984(ra) # 80006750 <release>
}
    80005f18:	60e2                	ld	ra,24(sp)
    80005f1a:	6442                	ld	s0,16(sp)
    80005f1c:	64a2                	ld	s1,8(sp)
    80005f1e:	6902                	ld	s2,0(sp)
    80005f20:	6105                	addi	sp,sp,32
    80005f22:	8082                	ret
  switch(c){
    80005f24:	07f00793          	li	a5,127
    80005f28:	0af48e63          	beq	s1,a5,80005fe4 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f2c:	00024717          	auipc	a4,0x24
    80005f30:	24470713          	addi	a4,a4,580 # 8002a170 <cons>
    80005f34:	0a872783          	lw	a5,168(a4)
    80005f38:	0a072703          	lw	a4,160(a4)
    80005f3c:	9f99                	subw	a5,a5,a4
    80005f3e:	07f00713          	li	a4,127
    80005f42:	fcf763e3          	bltu	a4,a5,80005f08 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f46:	47b5                	li	a5,13
    80005f48:	0cf48763          	beq	s1,a5,80006016 <consoleintr+0x14a>
      consputc(c);
    80005f4c:	8526                	mv	a0,s1
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	f3c080e7          	jalr	-196(ra) # 80005e8a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f56:	00024797          	auipc	a5,0x24
    80005f5a:	21a78793          	addi	a5,a5,538 # 8002a170 <cons>
    80005f5e:	0a87a703          	lw	a4,168(a5)
    80005f62:	0017069b          	addiw	a3,a4,1
    80005f66:	0006861b          	sext.w	a2,a3
    80005f6a:	0ad7a423          	sw	a3,168(a5)
    80005f6e:	07f77713          	andi	a4,a4,127
    80005f72:	97ba                	add	a5,a5,a4
    80005f74:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f78:	47a9                	li	a5,10
    80005f7a:	0cf48563          	beq	s1,a5,80006044 <consoleintr+0x178>
    80005f7e:	4791                	li	a5,4
    80005f80:	0cf48263          	beq	s1,a5,80006044 <consoleintr+0x178>
    80005f84:	00024797          	auipc	a5,0x24
    80005f88:	28c7a783          	lw	a5,652(a5) # 8002a210 <cons+0xa0>
    80005f8c:	0807879b          	addiw	a5,a5,128
    80005f90:	f6f61ce3          	bne	a2,a5,80005f08 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f94:	863e                	mv	a2,a5
    80005f96:	a07d                	j	80006044 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f98:	00024717          	auipc	a4,0x24
    80005f9c:	1d870713          	addi	a4,a4,472 # 8002a170 <cons>
    80005fa0:	0a872783          	lw	a5,168(a4)
    80005fa4:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005fa8:	00024497          	auipc	s1,0x24
    80005fac:	1c848493          	addi	s1,s1,456 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80005fb0:	4929                	li	s2,10
    80005fb2:	f4f70be3          	beq	a4,a5,80005f08 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005fb6:	37fd                	addiw	a5,a5,-1
    80005fb8:	07f7f713          	andi	a4,a5,127
    80005fbc:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005fbe:	02074703          	lbu	a4,32(a4)
    80005fc2:	f52703e3          	beq	a4,s2,80005f08 <consoleintr+0x3c>
      cons.e--;
    80005fc6:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005fca:	10000513          	li	a0,256
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	ebc080e7          	jalr	-324(ra) # 80005e8a <consputc>
    while(cons.e != cons.w &&
    80005fd6:	0a84a783          	lw	a5,168(s1)
    80005fda:	0a44a703          	lw	a4,164(s1)
    80005fde:	fcf71ce3          	bne	a4,a5,80005fb6 <consoleintr+0xea>
    80005fe2:	b71d                	j	80005f08 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005fe4:	00024717          	auipc	a4,0x24
    80005fe8:	18c70713          	addi	a4,a4,396 # 8002a170 <cons>
    80005fec:	0a872783          	lw	a5,168(a4)
    80005ff0:	0a472703          	lw	a4,164(a4)
    80005ff4:	f0f70ae3          	beq	a4,a5,80005f08 <consoleintr+0x3c>
      cons.e--;
    80005ff8:	37fd                	addiw	a5,a5,-1
    80005ffa:	00024717          	auipc	a4,0x24
    80005ffe:	20f72f23          	sw	a5,542(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    80006002:	10000513          	li	a0,256
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	e84080e7          	jalr	-380(ra) # 80005e8a <consputc>
    8000600e:	bded                	j	80005f08 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006010:	ee048ce3          	beqz	s1,80005f08 <consoleintr+0x3c>
    80006014:	bf21                	j	80005f2c <consoleintr+0x60>
      consputc(c);
    80006016:	4529                	li	a0,10
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	e72080e7          	jalr	-398(ra) # 80005e8a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006020:	00024797          	auipc	a5,0x24
    80006024:	15078793          	addi	a5,a5,336 # 8002a170 <cons>
    80006028:	0a87a703          	lw	a4,168(a5)
    8000602c:	0017069b          	addiw	a3,a4,1
    80006030:	0006861b          	sext.w	a2,a3
    80006034:	0ad7a423          	sw	a3,168(a5)
    80006038:	07f77713          	andi	a4,a4,127
    8000603c:	97ba                	add	a5,a5,a4
    8000603e:	4729                	li	a4,10
    80006040:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80006044:	00024797          	auipc	a5,0x24
    80006048:	1cc7a823          	sw	a2,464(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    8000604c:	00024517          	auipc	a0,0x24
    80006050:	1c450513          	addi	a0,a0,452 # 8002a210 <cons+0xa0>
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	72a080e7          	jalr	1834(ra) # 8000177e <wakeup>
    8000605c:	b575                	j	80005f08 <consoleintr+0x3c>

000000008000605e <consoleinit>:

void
consoleinit(void)
{
    8000605e:	1141                	addi	sp,sp,-16
    80006060:	e406                	sd	ra,8(sp)
    80006062:	e022                	sd	s0,0(sp)
    80006064:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006066:	00002597          	auipc	a1,0x2
    8000606a:	76258593          	addi	a1,a1,1890 # 800087c8 <digits+0x18>
    8000606e:	00024517          	auipc	a0,0x24
    80006072:	10250513          	addi	a0,a0,258 # 8002a170 <cons>
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	786080e7          	jalr	1926(ra) # 800067fc <initlock>

  uartinit();
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	330080e7          	jalr	816(ra) # 800063ae <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006086:	00017797          	auipc	a5,0x17
    8000608a:	d7278793          	addi	a5,a5,-654 # 8001cdf8 <devsw>
    8000608e:	00000717          	auipc	a4,0x0
    80006092:	ce470713          	addi	a4,a4,-796 # 80005d72 <consoleread>
    80006096:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006098:	00000717          	auipc	a4,0x0
    8000609c:	c7870713          	addi	a4,a4,-904 # 80005d10 <consolewrite>
    800060a0:	ef98                	sd	a4,24(a5)
}
    800060a2:	60a2                	ld	ra,8(sp)
    800060a4:	6402                	ld	s0,0(sp)
    800060a6:	0141                	addi	sp,sp,16
    800060a8:	8082                	ret

00000000800060aa <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800060aa:	7179                	addi	sp,sp,-48
    800060ac:	f406                	sd	ra,40(sp)
    800060ae:	f022                	sd	s0,32(sp)
    800060b0:	ec26                	sd	s1,24(sp)
    800060b2:	e84a                	sd	s2,16(sp)
    800060b4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800060b6:	c219                	beqz	a2,800060bc <printint+0x12>
    800060b8:	08054663          	bltz	a0,80006144 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800060bc:	2501                	sext.w	a0,a0
    800060be:	4881                	li	a7,0
    800060c0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800060c4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800060c6:	2581                	sext.w	a1,a1
    800060c8:	00002617          	auipc	a2,0x2
    800060cc:	71860613          	addi	a2,a2,1816 # 800087e0 <digits>
    800060d0:	883a                	mv	a6,a4
    800060d2:	2705                	addiw	a4,a4,1
    800060d4:	02b577bb          	remuw	a5,a0,a1
    800060d8:	1782                	slli	a5,a5,0x20
    800060da:	9381                	srli	a5,a5,0x20
    800060dc:	97b2                	add	a5,a5,a2
    800060de:	0007c783          	lbu	a5,0(a5)
    800060e2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060e6:	0005079b          	sext.w	a5,a0
    800060ea:	02b5553b          	divuw	a0,a0,a1
    800060ee:	0685                	addi	a3,a3,1
    800060f0:	feb7f0e3          	bgeu	a5,a1,800060d0 <printint+0x26>

  if(sign)
    800060f4:	00088b63          	beqz	a7,8000610a <printint+0x60>
    buf[i++] = '-';
    800060f8:	fe040793          	addi	a5,s0,-32
    800060fc:	973e                	add	a4,a4,a5
    800060fe:	02d00793          	li	a5,45
    80006102:	fef70823          	sb	a5,-16(a4)
    80006106:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000610a:	02e05763          	blez	a4,80006138 <printint+0x8e>
    8000610e:	fd040793          	addi	a5,s0,-48
    80006112:	00e784b3          	add	s1,a5,a4
    80006116:	fff78913          	addi	s2,a5,-1
    8000611a:	993a                	add	s2,s2,a4
    8000611c:	377d                	addiw	a4,a4,-1
    8000611e:	1702                	slli	a4,a4,0x20
    80006120:	9301                	srli	a4,a4,0x20
    80006122:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006126:	fff4c503          	lbu	a0,-1(s1)
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	d60080e7          	jalr	-672(ra) # 80005e8a <consputc>
  while(--i >= 0)
    80006132:	14fd                	addi	s1,s1,-1
    80006134:	ff2499e3          	bne	s1,s2,80006126 <printint+0x7c>
}
    80006138:	70a2                	ld	ra,40(sp)
    8000613a:	7402                	ld	s0,32(sp)
    8000613c:	64e2                	ld	s1,24(sp)
    8000613e:	6942                	ld	s2,16(sp)
    80006140:	6145                	addi	sp,sp,48
    80006142:	8082                	ret
    x = -xx;
    80006144:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006148:	4885                	li	a7,1
    x = -xx;
    8000614a:	bf9d                	j	800060c0 <printint+0x16>

000000008000614c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000614c:	1101                	addi	sp,sp,-32
    8000614e:	ec06                	sd	ra,24(sp)
    80006150:	e822                	sd	s0,16(sp)
    80006152:	e426                	sd	s1,8(sp)
    80006154:	1000                	addi	s0,sp,32
    80006156:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006158:	00024797          	auipc	a5,0x24
    8000615c:	0e07a423          	sw	zero,232(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    80006160:	00002517          	auipc	a0,0x2
    80006164:	67050513          	addi	a0,a0,1648 # 800087d0 <digits+0x20>
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	02e080e7          	jalr	46(ra) # 80006196 <printf>
  printf(s);
    80006170:	8526                	mv	a0,s1
    80006172:	00000097          	auipc	ra,0x0
    80006176:	024080e7          	jalr	36(ra) # 80006196 <printf>
  printf("\n");
    8000617a:	00002517          	auipc	a0,0x2
    8000617e:	6ee50513          	addi	a0,a0,1774 # 80008868 <digits+0x88>
    80006182:	00000097          	auipc	ra,0x0
    80006186:	014080e7          	jalr	20(ra) # 80006196 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000618a:	4785                	li	a5,1
    8000618c:	00003717          	auipc	a4,0x3
    80006190:	e8f72823          	sw	a5,-368(a4) # 8000901c <panicked>
  for(;;)
    80006194:	a001                	j	80006194 <panic+0x48>

0000000080006196 <printf>:
{
    80006196:	7131                	addi	sp,sp,-192
    80006198:	fc86                	sd	ra,120(sp)
    8000619a:	f8a2                	sd	s0,112(sp)
    8000619c:	f4a6                	sd	s1,104(sp)
    8000619e:	f0ca                	sd	s2,96(sp)
    800061a0:	ecce                	sd	s3,88(sp)
    800061a2:	e8d2                	sd	s4,80(sp)
    800061a4:	e4d6                	sd	s5,72(sp)
    800061a6:	e0da                	sd	s6,64(sp)
    800061a8:	fc5e                	sd	s7,56(sp)
    800061aa:	f862                	sd	s8,48(sp)
    800061ac:	f466                	sd	s9,40(sp)
    800061ae:	f06a                	sd	s10,32(sp)
    800061b0:	ec6e                	sd	s11,24(sp)
    800061b2:	0100                	addi	s0,sp,128
    800061b4:	8a2a                	mv	s4,a0
    800061b6:	e40c                	sd	a1,8(s0)
    800061b8:	e810                	sd	a2,16(s0)
    800061ba:	ec14                	sd	a3,24(s0)
    800061bc:	f018                	sd	a4,32(s0)
    800061be:	f41c                	sd	a5,40(s0)
    800061c0:	03043823          	sd	a6,48(s0)
    800061c4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800061c8:	00024d97          	auipc	s11,0x24
    800061cc:	078dad83          	lw	s11,120(s11) # 8002a240 <pr+0x20>
  if(locking)
    800061d0:	020d9b63          	bnez	s11,80006206 <printf+0x70>
  if (fmt == 0)
    800061d4:	040a0263          	beqz	s4,80006218 <printf+0x82>
  va_start(ap, fmt);
    800061d8:	00840793          	addi	a5,s0,8
    800061dc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061e0:	000a4503          	lbu	a0,0(s4)
    800061e4:	16050263          	beqz	a0,80006348 <printf+0x1b2>
    800061e8:	4481                	li	s1,0
    if(c != '%'){
    800061ea:	02500a93          	li	s5,37
    switch(c){
    800061ee:	07000b13          	li	s6,112
  consputc('x');
    800061f2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061f4:	00002b97          	auipc	s7,0x2
    800061f8:	5ecb8b93          	addi	s7,s7,1516 # 800087e0 <digits>
    switch(c){
    800061fc:	07300c93          	li	s9,115
    80006200:	06400c13          	li	s8,100
    80006204:	a82d                	j	8000623e <printf+0xa8>
    acquire(&pr.lock);
    80006206:	00024517          	auipc	a0,0x24
    8000620a:	01a50513          	addi	a0,a0,26 # 8002a220 <pr>
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	472080e7          	jalr	1138(ra) # 80006680 <acquire>
    80006216:	bf7d                	j	800061d4 <printf+0x3e>
    panic("null fmt");
    80006218:	00002517          	auipc	a0,0x2
    8000621c:	58850513          	addi	a0,a0,1416 # 800087a0 <syscalls+0x3d8>
    80006220:	00000097          	auipc	ra,0x0
    80006224:	f2c080e7          	jalr	-212(ra) # 8000614c <panic>
      consputc(c);
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	c62080e7          	jalr	-926(ra) # 80005e8a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006230:	2485                	addiw	s1,s1,1
    80006232:	009a07b3          	add	a5,s4,s1
    80006236:	0007c503          	lbu	a0,0(a5)
    8000623a:	10050763          	beqz	a0,80006348 <printf+0x1b2>
    if(c != '%'){
    8000623e:	ff5515e3          	bne	a0,s5,80006228 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006242:	2485                	addiw	s1,s1,1
    80006244:	009a07b3          	add	a5,s4,s1
    80006248:	0007c783          	lbu	a5,0(a5)
    8000624c:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006250:	cfe5                	beqz	a5,80006348 <printf+0x1b2>
    switch(c){
    80006252:	05678a63          	beq	a5,s6,800062a6 <printf+0x110>
    80006256:	02fb7663          	bgeu	s6,a5,80006282 <printf+0xec>
    8000625a:	09978963          	beq	a5,s9,800062ec <printf+0x156>
    8000625e:	07800713          	li	a4,120
    80006262:	0ce79863          	bne	a5,a4,80006332 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006266:	f8843783          	ld	a5,-120(s0)
    8000626a:	00878713          	addi	a4,a5,8
    8000626e:	f8e43423          	sd	a4,-120(s0)
    80006272:	4605                	li	a2,1
    80006274:	85ea                	mv	a1,s10
    80006276:	4388                	lw	a0,0(a5)
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	e32080e7          	jalr	-462(ra) # 800060aa <printint>
      break;
    80006280:	bf45                	j	80006230 <printf+0x9a>
    switch(c){
    80006282:	0b578263          	beq	a5,s5,80006326 <printf+0x190>
    80006286:	0b879663          	bne	a5,s8,80006332 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000628a:	f8843783          	ld	a5,-120(s0)
    8000628e:	00878713          	addi	a4,a5,8
    80006292:	f8e43423          	sd	a4,-120(s0)
    80006296:	4605                	li	a2,1
    80006298:	45a9                	li	a1,10
    8000629a:	4388                	lw	a0,0(a5)
    8000629c:	00000097          	auipc	ra,0x0
    800062a0:	e0e080e7          	jalr	-498(ra) # 800060aa <printint>
      break;
    800062a4:	b771                	j	80006230 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800062a6:	f8843783          	ld	a5,-120(s0)
    800062aa:	00878713          	addi	a4,a5,8
    800062ae:	f8e43423          	sd	a4,-120(s0)
    800062b2:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800062b6:	03000513          	li	a0,48
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	bd0080e7          	jalr	-1072(ra) # 80005e8a <consputc>
  consputc('x');
    800062c2:	07800513          	li	a0,120
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	bc4080e7          	jalr	-1084(ra) # 80005e8a <consputc>
    800062ce:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062d0:	03c9d793          	srli	a5,s3,0x3c
    800062d4:	97de                	add	a5,a5,s7
    800062d6:	0007c503          	lbu	a0,0(a5)
    800062da:	00000097          	auipc	ra,0x0
    800062de:	bb0080e7          	jalr	-1104(ra) # 80005e8a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062e2:	0992                	slli	s3,s3,0x4
    800062e4:	397d                	addiw	s2,s2,-1
    800062e6:	fe0915e3          	bnez	s2,800062d0 <printf+0x13a>
    800062ea:	b799                	j	80006230 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800062ec:	f8843783          	ld	a5,-120(s0)
    800062f0:	00878713          	addi	a4,a5,8
    800062f4:	f8e43423          	sd	a4,-120(s0)
    800062f8:	0007b903          	ld	s2,0(a5)
    800062fc:	00090e63          	beqz	s2,80006318 <printf+0x182>
      for(; *s; s++)
    80006300:	00094503          	lbu	a0,0(s2)
    80006304:	d515                	beqz	a0,80006230 <printf+0x9a>
        consputc(*s);
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	b84080e7          	jalr	-1148(ra) # 80005e8a <consputc>
      for(; *s; s++)
    8000630e:	0905                	addi	s2,s2,1
    80006310:	00094503          	lbu	a0,0(s2)
    80006314:	f96d                	bnez	a0,80006306 <printf+0x170>
    80006316:	bf29                	j	80006230 <printf+0x9a>
        s = "(null)";
    80006318:	00002917          	auipc	s2,0x2
    8000631c:	48090913          	addi	s2,s2,1152 # 80008798 <syscalls+0x3d0>
      for(; *s; s++)
    80006320:	02800513          	li	a0,40
    80006324:	b7cd                	j	80006306 <printf+0x170>
      consputc('%');
    80006326:	8556                	mv	a0,s5
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	b62080e7          	jalr	-1182(ra) # 80005e8a <consputc>
      break;
    80006330:	b701                	j	80006230 <printf+0x9a>
      consputc('%');
    80006332:	8556                	mv	a0,s5
    80006334:	00000097          	auipc	ra,0x0
    80006338:	b56080e7          	jalr	-1194(ra) # 80005e8a <consputc>
      consputc(c);
    8000633c:	854a                	mv	a0,s2
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	b4c080e7          	jalr	-1204(ra) # 80005e8a <consputc>
      break;
    80006346:	b5ed                	j	80006230 <printf+0x9a>
  if(locking)
    80006348:	020d9163          	bnez	s11,8000636a <printf+0x1d4>
}
    8000634c:	70e6                	ld	ra,120(sp)
    8000634e:	7446                	ld	s0,112(sp)
    80006350:	74a6                	ld	s1,104(sp)
    80006352:	7906                	ld	s2,96(sp)
    80006354:	69e6                	ld	s3,88(sp)
    80006356:	6a46                	ld	s4,80(sp)
    80006358:	6aa6                	ld	s5,72(sp)
    8000635a:	6b06                	ld	s6,64(sp)
    8000635c:	7be2                	ld	s7,56(sp)
    8000635e:	7c42                	ld	s8,48(sp)
    80006360:	7ca2                	ld	s9,40(sp)
    80006362:	7d02                	ld	s10,32(sp)
    80006364:	6de2                	ld	s11,24(sp)
    80006366:	6129                	addi	sp,sp,192
    80006368:	8082                	ret
    release(&pr.lock);
    8000636a:	00024517          	auipc	a0,0x24
    8000636e:	eb650513          	addi	a0,a0,-330 # 8002a220 <pr>
    80006372:	00000097          	auipc	ra,0x0
    80006376:	3de080e7          	jalr	990(ra) # 80006750 <release>
}
    8000637a:	bfc9                	j	8000634c <printf+0x1b6>

000000008000637c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000637c:	1101                	addi	sp,sp,-32
    8000637e:	ec06                	sd	ra,24(sp)
    80006380:	e822                	sd	s0,16(sp)
    80006382:	e426                	sd	s1,8(sp)
    80006384:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006386:	00024497          	auipc	s1,0x24
    8000638a:	e9a48493          	addi	s1,s1,-358 # 8002a220 <pr>
    8000638e:	00002597          	auipc	a1,0x2
    80006392:	44a58593          	addi	a1,a1,1098 # 800087d8 <digits+0x28>
    80006396:	8526                	mv	a0,s1
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	464080e7          	jalr	1124(ra) # 800067fc <initlock>
  pr.locking = 1;
    800063a0:	4785                	li	a5,1
    800063a2:	d09c                	sw	a5,32(s1)
}
    800063a4:	60e2                	ld	ra,24(sp)
    800063a6:	6442                	ld	s0,16(sp)
    800063a8:	64a2                	ld	s1,8(sp)
    800063aa:	6105                	addi	sp,sp,32
    800063ac:	8082                	ret

00000000800063ae <uartinit>:

void uartstart();

void
uartinit(void)
{
    800063ae:	1141                	addi	sp,sp,-16
    800063b0:	e406                	sd	ra,8(sp)
    800063b2:	e022                	sd	s0,0(sp)
    800063b4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800063b6:	100007b7          	lui	a5,0x10000
    800063ba:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800063be:	f8000713          	li	a4,-128
    800063c2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800063c6:	470d                	li	a4,3
    800063c8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800063cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800063d0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800063d4:	469d                	li	a3,7
    800063d6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800063da:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063de:	00002597          	auipc	a1,0x2
    800063e2:	41a58593          	addi	a1,a1,1050 # 800087f8 <digits+0x18>
    800063e6:	00024517          	auipc	a0,0x24
    800063ea:	e6250513          	addi	a0,a0,-414 # 8002a248 <uart_tx_lock>
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	40e080e7          	jalr	1038(ra) # 800067fc <initlock>
}
    800063f6:	60a2                	ld	ra,8(sp)
    800063f8:	6402                	ld	s0,0(sp)
    800063fa:	0141                	addi	sp,sp,16
    800063fc:	8082                	ret

00000000800063fe <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800063fe:	1101                	addi	sp,sp,-32
    80006400:	ec06                	sd	ra,24(sp)
    80006402:	e822                	sd	s0,16(sp)
    80006404:	e426                	sd	s1,8(sp)
    80006406:	1000                	addi	s0,sp,32
    80006408:	84aa                	mv	s1,a0
  push_off();
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	22a080e7          	jalr	554(ra) # 80006634 <push_off>

  if(panicked){
    80006412:	00003797          	auipc	a5,0x3
    80006416:	c0a7a783          	lw	a5,-1014(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000641a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000641e:	c391                	beqz	a5,80006422 <uartputc_sync+0x24>
    for(;;)
    80006420:	a001                	j	80006420 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006422:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006426:	0ff7f793          	andi	a5,a5,255
    8000642a:	0207f793          	andi	a5,a5,32
    8000642e:	dbf5                	beqz	a5,80006422 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006430:	0ff4f793          	andi	a5,s1,255
    80006434:	10000737          	lui	a4,0x10000
    80006438:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000643c:	00000097          	auipc	ra,0x0
    80006440:	2b4080e7          	jalr	692(ra) # 800066f0 <pop_off>
}
    80006444:	60e2                	ld	ra,24(sp)
    80006446:	6442                	ld	s0,16(sp)
    80006448:	64a2                	ld	s1,8(sp)
    8000644a:	6105                	addi	sp,sp,32
    8000644c:	8082                	ret

000000008000644e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000644e:	00003717          	auipc	a4,0x3
    80006452:	bd273703          	ld	a4,-1070(a4) # 80009020 <uart_tx_r>
    80006456:	00003797          	auipc	a5,0x3
    8000645a:	bd27b783          	ld	a5,-1070(a5) # 80009028 <uart_tx_w>
    8000645e:	06e78c63          	beq	a5,a4,800064d6 <uartstart+0x88>
{
    80006462:	7139                	addi	sp,sp,-64
    80006464:	fc06                	sd	ra,56(sp)
    80006466:	f822                	sd	s0,48(sp)
    80006468:	f426                	sd	s1,40(sp)
    8000646a:	f04a                	sd	s2,32(sp)
    8000646c:	ec4e                	sd	s3,24(sp)
    8000646e:	e852                	sd	s4,16(sp)
    80006470:	e456                	sd	s5,8(sp)
    80006472:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006474:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006478:	00024a17          	auipc	s4,0x24
    8000647c:	dd0a0a13          	addi	s4,s4,-560 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    80006480:	00003497          	auipc	s1,0x3
    80006484:	ba048493          	addi	s1,s1,-1120 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006488:	00003997          	auipc	s3,0x3
    8000648c:	ba098993          	addi	s3,s3,-1120 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006490:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006494:	0ff7f793          	andi	a5,a5,255
    80006498:	0207f793          	andi	a5,a5,32
    8000649c:	c785                	beqz	a5,800064c4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000649e:	01f77793          	andi	a5,a4,31
    800064a2:	97d2                	add	a5,a5,s4
    800064a4:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    800064a8:	0705                	addi	a4,a4,1
    800064aa:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800064ac:	8526                	mv	a0,s1
    800064ae:	ffffb097          	auipc	ra,0xffffb
    800064b2:	2d0080e7          	jalr	720(ra) # 8000177e <wakeup>
    
    WriteReg(THR, c);
    800064b6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800064ba:	6098                	ld	a4,0(s1)
    800064bc:	0009b783          	ld	a5,0(s3)
    800064c0:	fce798e3          	bne	a5,a4,80006490 <uartstart+0x42>
  }
}
    800064c4:	70e2                	ld	ra,56(sp)
    800064c6:	7442                	ld	s0,48(sp)
    800064c8:	74a2                	ld	s1,40(sp)
    800064ca:	7902                	ld	s2,32(sp)
    800064cc:	69e2                	ld	s3,24(sp)
    800064ce:	6a42                	ld	s4,16(sp)
    800064d0:	6aa2                	ld	s5,8(sp)
    800064d2:	6121                	addi	sp,sp,64
    800064d4:	8082                	ret
    800064d6:	8082                	ret

00000000800064d8 <uartputc>:
{
    800064d8:	7179                	addi	sp,sp,-48
    800064da:	f406                	sd	ra,40(sp)
    800064dc:	f022                	sd	s0,32(sp)
    800064de:	ec26                	sd	s1,24(sp)
    800064e0:	e84a                	sd	s2,16(sp)
    800064e2:	e44e                	sd	s3,8(sp)
    800064e4:	e052                	sd	s4,0(sp)
    800064e6:	1800                	addi	s0,sp,48
    800064e8:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800064ea:	00024517          	auipc	a0,0x24
    800064ee:	d5e50513          	addi	a0,a0,-674 # 8002a248 <uart_tx_lock>
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	18e080e7          	jalr	398(ra) # 80006680 <acquire>
  if(panicked){
    800064fa:	00003797          	auipc	a5,0x3
    800064fe:	b227a783          	lw	a5,-1246(a5) # 8000901c <panicked>
    80006502:	c391                	beqz	a5,80006506 <uartputc+0x2e>
    for(;;)
    80006504:	a001                	j	80006504 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006506:	00003797          	auipc	a5,0x3
    8000650a:	b227b783          	ld	a5,-1246(a5) # 80009028 <uart_tx_w>
    8000650e:	00003717          	auipc	a4,0x3
    80006512:	b1273703          	ld	a4,-1262(a4) # 80009020 <uart_tx_r>
    80006516:	02070713          	addi	a4,a4,32
    8000651a:	02f71b63          	bne	a4,a5,80006550 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000651e:	00024a17          	auipc	s4,0x24
    80006522:	d2aa0a13          	addi	s4,s4,-726 # 8002a248 <uart_tx_lock>
    80006526:	00003497          	auipc	s1,0x3
    8000652a:	afa48493          	addi	s1,s1,-1286 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000652e:	00003917          	auipc	s2,0x3
    80006532:	afa90913          	addi	s2,s2,-1286 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006536:	85d2                	mv	a1,s4
    80006538:	8526                	mv	a0,s1
    8000653a:	ffffb097          	auipc	ra,0xffffb
    8000653e:	0b8080e7          	jalr	184(ra) # 800015f2 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006542:	00093783          	ld	a5,0(s2)
    80006546:	6098                	ld	a4,0(s1)
    80006548:	02070713          	addi	a4,a4,32
    8000654c:	fef705e3          	beq	a4,a5,80006536 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006550:	00024497          	auipc	s1,0x24
    80006554:	cf848493          	addi	s1,s1,-776 # 8002a248 <uart_tx_lock>
    80006558:	01f7f713          	andi	a4,a5,31
    8000655c:	9726                	add	a4,a4,s1
    8000655e:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    80006562:	0785                	addi	a5,a5,1
    80006564:	00003717          	auipc	a4,0x3
    80006568:	acf73223          	sd	a5,-1340(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000656c:	00000097          	auipc	ra,0x0
    80006570:	ee2080e7          	jalr	-286(ra) # 8000644e <uartstart>
      release(&uart_tx_lock);
    80006574:	8526                	mv	a0,s1
    80006576:	00000097          	auipc	ra,0x0
    8000657a:	1da080e7          	jalr	474(ra) # 80006750 <release>
}
    8000657e:	70a2                	ld	ra,40(sp)
    80006580:	7402                	ld	s0,32(sp)
    80006582:	64e2                	ld	s1,24(sp)
    80006584:	6942                	ld	s2,16(sp)
    80006586:	69a2                	ld	s3,8(sp)
    80006588:	6a02                	ld	s4,0(sp)
    8000658a:	6145                	addi	sp,sp,48
    8000658c:	8082                	ret

000000008000658e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000658e:	1141                	addi	sp,sp,-16
    80006590:	e422                	sd	s0,8(sp)
    80006592:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006594:	100007b7          	lui	a5,0x10000
    80006598:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000659c:	8b85                	andi	a5,a5,1
    8000659e:	cb91                	beqz	a5,800065b2 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800065a0:	100007b7          	lui	a5,0x10000
    800065a4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800065a8:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800065ac:	6422                	ld	s0,8(sp)
    800065ae:	0141                	addi	sp,sp,16
    800065b0:	8082                	ret
    return -1;
    800065b2:	557d                	li	a0,-1
    800065b4:	bfe5                	j	800065ac <uartgetc+0x1e>

00000000800065b6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800065b6:	1101                	addi	sp,sp,-32
    800065b8:	ec06                	sd	ra,24(sp)
    800065ba:	e822                	sd	s0,16(sp)
    800065bc:	e426                	sd	s1,8(sp)
    800065be:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800065c0:	54fd                	li	s1,-1
    int c = uartgetc();
    800065c2:	00000097          	auipc	ra,0x0
    800065c6:	fcc080e7          	jalr	-52(ra) # 8000658e <uartgetc>
    if(c == -1)
    800065ca:	00950763          	beq	a0,s1,800065d8 <uartintr+0x22>
      break;
    consoleintr(c);
    800065ce:	00000097          	auipc	ra,0x0
    800065d2:	8fe080e7          	jalr	-1794(ra) # 80005ecc <consoleintr>
  while(1){
    800065d6:	b7f5                	j	800065c2 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800065d8:	00024497          	auipc	s1,0x24
    800065dc:	c7048493          	addi	s1,s1,-912 # 8002a248 <uart_tx_lock>
    800065e0:	8526                	mv	a0,s1
    800065e2:	00000097          	auipc	ra,0x0
    800065e6:	09e080e7          	jalr	158(ra) # 80006680 <acquire>
  uartstart();
    800065ea:	00000097          	auipc	ra,0x0
    800065ee:	e64080e7          	jalr	-412(ra) # 8000644e <uartstart>
  release(&uart_tx_lock);
    800065f2:	8526                	mv	a0,s1
    800065f4:	00000097          	auipc	ra,0x0
    800065f8:	15c080e7          	jalr	348(ra) # 80006750 <release>
}
    800065fc:	60e2                	ld	ra,24(sp)
    800065fe:	6442                	ld	s0,16(sp)
    80006600:	64a2                	ld	s1,8(sp)
    80006602:	6105                	addi	sp,sp,32
    80006604:	8082                	ret

0000000080006606 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006606:	411c                	lw	a5,0(a0)
    80006608:	e399                	bnez	a5,8000660e <holding+0x8>
    8000660a:	4501                	li	a0,0
  return r;
}
    8000660c:	8082                	ret
{
    8000660e:	1101                	addi	sp,sp,-32
    80006610:	ec06                	sd	ra,24(sp)
    80006612:	e822                	sd	s0,16(sp)
    80006614:	e426                	sd	s1,8(sp)
    80006616:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006618:	6904                	ld	s1,16(a0)
    8000661a:	ffffb097          	auipc	ra,0xffffb
    8000661e:	900080e7          	jalr	-1792(ra) # 80000f1a <mycpu>
    80006622:	40a48533          	sub	a0,s1,a0
    80006626:	00153513          	seqz	a0,a0
}
    8000662a:	60e2                	ld	ra,24(sp)
    8000662c:	6442                	ld	s0,16(sp)
    8000662e:	64a2                	ld	s1,8(sp)
    80006630:	6105                	addi	sp,sp,32
    80006632:	8082                	ret

0000000080006634 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006634:	1101                	addi	sp,sp,-32
    80006636:	ec06                	sd	ra,24(sp)
    80006638:	e822                	sd	s0,16(sp)
    8000663a:	e426                	sd	s1,8(sp)
    8000663c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000663e:	100024f3          	csrr	s1,sstatus
    80006642:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006646:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006648:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000664c:	ffffb097          	auipc	ra,0xffffb
    80006650:	8ce080e7          	jalr	-1842(ra) # 80000f1a <mycpu>
    80006654:	5d3c                	lw	a5,120(a0)
    80006656:	cf89                	beqz	a5,80006670 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006658:	ffffb097          	auipc	ra,0xffffb
    8000665c:	8c2080e7          	jalr	-1854(ra) # 80000f1a <mycpu>
    80006660:	5d3c                	lw	a5,120(a0)
    80006662:	2785                	addiw	a5,a5,1
    80006664:	dd3c                	sw	a5,120(a0)
}
    80006666:	60e2                	ld	ra,24(sp)
    80006668:	6442                	ld	s0,16(sp)
    8000666a:	64a2                	ld	s1,8(sp)
    8000666c:	6105                	addi	sp,sp,32
    8000666e:	8082                	ret
    mycpu()->intena = old;
    80006670:	ffffb097          	auipc	ra,0xffffb
    80006674:	8aa080e7          	jalr	-1878(ra) # 80000f1a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006678:	8085                	srli	s1,s1,0x1
    8000667a:	8885                	andi	s1,s1,1
    8000667c:	dd64                	sw	s1,124(a0)
    8000667e:	bfe9                	j	80006658 <push_off+0x24>

0000000080006680 <acquire>:
{
    80006680:	1101                	addi	sp,sp,-32
    80006682:	ec06                	sd	ra,24(sp)
    80006684:	e822                	sd	s0,16(sp)
    80006686:	e426                	sd	s1,8(sp)
    80006688:	1000                	addi	s0,sp,32
    8000668a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000668c:	00000097          	auipc	ra,0x0
    80006690:	fa8080e7          	jalr	-88(ra) # 80006634 <push_off>
  if(holding(lk))
    80006694:	8526                	mv	a0,s1
    80006696:	00000097          	auipc	ra,0x0
    8000669a:	f70080e7          	jalr	-144(ra) # 80006606 <holding>
    8000669e:	e911                	bnez	a0,800066b2 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800066a0:	4785                	li	a5,1
    800066a2:	01c48713          	addi	a4,s1,28
    800066a6:	0f50000f          	fence	iorw,ow
    800066aa:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800066ae:	4705                	li	a4,1
    800066b0:	a839                	j	800066ce <acquire+0x4e>
    panic("acquire");
    800066b2:	00002517          	auipc	a0,0x2
    800066b6:	14e50513          	addi	a0,a0,334 # 80008800 <digits+0x20>
    800066ba:	00000097          	auipc	ra,0x0
    800066be:	a92080e7          	jalr	-1390(ra) # 8000614c <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    800066c2:	01848793          	addi	a5,s1,24
    800066c6:	0f50000f          	fence	iorw,ow
    800066ca:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800066ce:	87ba                	mv	a5,a4
    800066d0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800066d4:	2781                	sext.w	a5,a5
    800066d6:	f7f5                	bnez	a5,800066c2 <acquire+0x42>
  __sync_synchronize();
    800066d8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800066dc:	ffffb097          	auipc	ra,0xffffb
    800066e0:	83e080e7          	jalr	-1986(ra) # 80000f1a <mycpu>
    800066e4:	e888                	sd	a0,16(s1)
}
    800066e6:	60e2                	ld	ra,24(sp)
    800066e8:	6442                	ld	s0,16(sp)
    800066ea:	64a2                	ld	s1,8(sp)
    800066ec:	6105                	addi	sp,sp,32
    800066ee:	8082                	ret

00000000800066f0 <pop_off>:

void
pop_off(void)
{
    800066f0:	1141                	addi	sp,sp,-16
    800066f2:	e406                	sd	ra,8(sp)
    800066f4:	e022                	sd	s0,0(sp)
    800066f6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066f8:	ffffb097          	auipc	ra,0xffffb
    800066fc:	822080e7          	jalr	-2014(ra) # 80000f1a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006700:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006704:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006706:	e78d                	bnez	a5,80006730 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006708:	5d3c                	lw	a5,120(a0)
    8000670a:	02f05b63          	blez	a5,80006740 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000670e:	37fd                	addiw	a5,a5,-1
    80006710:	0007871b          	sext.w	a4,a5
    80006714:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006716:	eb09                	bnez	a4,80006728 <pop_off+0x38>
    80006718:	5d7c                	lw	a5,124(a0)
    8000671a:	c799                	beqz	a5,80006728 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000671c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006720:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006724:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006728:	60a2                	ld	ra,8(sp)
    8000672a:	6402                	ld	s0,0(sp)
    8000672c:	0141                	addi	sp,sp,16
    8000672e:	8082                	ret
    panic("pop_off - interruptible");
    80006730:	00002517          	auipc	a0,0x2
    80006734:	0d850513          	addi	a0,a0,216 # 80008808 <digits+0x28>
    80006738:	00000097          	auipc	ra,0x0
    8000673c:	a14080e7          	jalr	-1516(ra) # 8000614c <panic>
    panic("pop_off");
    80006740:	00002517          	auipc	a0,0x2
    80006744:	0e050513          	addi	a0,a0,224 # 80008820 <digits+0x40>
    80006748:	00000097          	auipc	ra,0x0
    8000674c:	a04080e7          	jalr	-1532(ra) # 8000614c <panic>

0000000080006750 <release>:
{
    80006750:	1101                	addi	sp,sp,-32
    80006752:	ec06                	sd	ra,24(sp)
    80006754:	e822                	sd	s0,16(sp)
    80006756:	e426                	sd	s1,8(sp)
    80006758:	1000                	addi	s0,sp,32
    8000675a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000675c:	00000097          	auipc	ra,0x0
    80006760:	eaa080e7          	jalr	-342(ra) # 80006606 <holding>
    80006764:	c115                	beqz	a0,80006788 <release+0x38>
  lk->cpu = 0;
    80006766:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000676a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000676e:	0f50000f          	fence	iorw,ow
    80006772:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006776:	00000097          	auipc	ra,0x0
    8000677a:	f7a080e7          	jalr	-134(ra) # 800066f0 <pop_off>
}
    8000677e:	60e2                	ld	ra,24(sp)
    80006780:	6442                	ld	s0,16(sp)
    80006782:	64a2                	ld	s1,8(sp)
    80006784:	6105                	addi	sp,sp,32
    80006786:	8082                	ret
    panic("release");
    80006788:	00002517          	auipc	a0,0x2
    8000678c:	0a050513          	addi	a0,a0,160 # 80008828 <digits+0x48>
    80006790:	00000097          	auipc	ra,0x0
    80006794:	9bc080e7          	jalr	-1604(ra) # 8000614c <panic>

0000000080006798 <freelock>:
{
    80006798:	1101                	addi	sp,sp,-32
    8000679a:	ec06                	sd	ra,24(sp)
    8000679c:	e822                	sd	s0,16(sp)
    8000679e:	e426                	sd	s1,8(sp)
    800067a0:	1000                	addi	s0,sp,32
    800067a2:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800067a4:	00024517          	auipc	a0,0x24
    800067a8:	ae450513          	addi	a0,a0,-1308 # 8002a288 <lock_locks>
    800067ac:	00000097          	auipc	ra,0x0
    800067b0:	ed4080e7          	jalr	-300(ra) # 80006680 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800067b4:	00024717          	auipc	a4,0x24
    800067b8:	af470713          	addi	a4,a4,-1292 # 8002a2a8 <locks>
    800067bc:	4781                	li	a5,0
    800067be:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    800067c2:	6314                	ld	a3,0(a4)
    800067c4:	00968763          	beq	a3,s1,800067d2 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    800067c8:	2785                	addiw	a5,a5,1
    800067ca:	0721                	addi	a4,a4,8
    800067cc:	fec79be3          	bne	a5,a2,800067c2 <freelock+0x2a>
    800067d0:	a809                	j	800067e2 <freelock+0x4a>
      locks[i] = 0;
    800067d2:	078e                	slli	a5,a5,0x3
    800067d4:	00024717          	auipc	a4,0x24
    800067d8:	ad470713          	addi	a4,a4,-1324 # 8002a2a8 <locks>
    800067dc:	97ba                	add	a5,a5,a4
    800067de:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    800067e2:	00024517          	auipc	a0,0x24
    800067e6:	aa650513          	addi	a0,a0,-1370 # 8002a288 <lock_locks>
    800067ea:	00000097          	auipc	ra,0x0
    800067ee:	f66080e7          	jalr	-154(ra) # 80006750 <release>
}
    800067f2:	60e2                	ld	ra,24(sp)
    800067f4:	6442                	ld	s0,16(sp)
    800067f6:	64a2                	ld	s1,8(sp)
    800067f8:	6105                	addi	sp,sp,32
    800067fa:	8082                	ret

00000000800067fc <initlock>:
{
    800067fc:	1101                	addi	sp,sp,-32
    800067fe:	ec06                	sd	ra,24(sp)
    80006800:	e822                	sd	s0,16(sp)
    80006802:	e426                	sd	s1,8(sp)
    80006804:	1000                	addi	s0,sp,32
    80006806:	84aa                	mv	s1,a0
  lk->name = name;
    80006808:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000680a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000680e:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006812:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006816:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    8000681a:	00024517          	auipc	a0,0x24
    8000681e:	a6e50513          	addi	a0,a0,-1426 # 8002a288 <lock_locks>
    80006822:	00000097          	auipc	ra,0x0
    80006826:	e5e080e7          	jalr	-418(ra) # 80006680 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000682a:	00024717          	auipc	a4,0x24
    8000682e:	a7e70713          	addi	a4,a4,-1410 # 8002a2a8 <locks>
    80006832:	4781                	li	a5,0
    80006834:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    80006838:	6310                	ld	a2,0(a4)
    8000683a:	ce09                	beqz	a2,80006854 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    8000683c:	2785                	addiw	a5,a5,1
    8000683e:	0721                	addi	a4,a4,8
    80006840:	fed79ce3          	bne	a5,a3,80006838 <initlock+0x3c>
  panic("findslot");
    80006844:	00002517          	auipc	a0,0x2
    80006848:	fec50513          	addi	a0,a0,-20 # 80008830 <digits+0x50>
    8000684c:	00000097          	auipc	ra,0x0
    80006850:	900080e7          	jalr	-1792(ra) # 8000614c <panic>
      locks[i] = lk;
    80006854:	078e                	slli	a5,a5,0x3
    80006856:	00024717          	auipc	a4,0x24
    8000685a:	a5270713          	addi	a4,a4,-1454 # 8002a2a8 <locks>
    8000685e:	97ba                	add	a5,a5,a4
    80006860:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006862:	00024517          	auipc	a0,0x24
    80006866:	a2650513          	addi	a0,a0,-1498 # 8002a288 <lock_locks>
    8000686a:	00000097          	auipc	ra,0x0
    8000686e:	ee6080e7          	jalr	-282(ra) # 80006750 <release>
}
    80006872:	60e2                	ld	ra,24(sp)
    80006874:	6442                	ld	s0,16(sp)
    80006876:	64a2                	ld	s1,8(sp)
    80006878:	6105                	addi	sp,sp,32
    8000687a:	8082                	ret

000000008000687c <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000687c:	1141                	addi	sp,sp,-16
    8000687e:	e422                	sd	s0,8(sp)
    80006880:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006882:	0ff0000f          	fence
    80006886:	6108                	ld	a0,0(a0)
    80006888:	0ff0000f          	fence
  return val;
}
    8000688c:	6422                	ld	s0,8(sp)
    8000688e:	0141                	addi	sp,sp,16
    80006890:	8082                	ret

0000000080006892 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006892:	1141                	addi	sp,sp,-16
    80006894:	e422                	sd	s0,8(sp)
    80006896:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006898:	0ff0000f          	fence
    8000689c:	4108                	lw	a0,0(a0)
    8000689e:	0ff0000f          	fence
  return val;
}
    800068a2:	2501                	sext.w	a0,a0
    800068a4:	6422                	ld	s0,8(sp)
    800068a6:	0141                	addi	sp,sp,16
    800068a8:	8082                	ret

00000000800068aa <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    800068aa:	4e5c                	lw	a5,28(a2)
    800068ac:	00f04463          	bgtz	a5,800068b4 <snprint_lock+0xa>
  int n = 0;
    800068b0:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    800068b2:	8082                	ret
{
    800068b4:	1141                	addi	sp,sp,-16
    800068b6:	e406                	sd	ra,8(sp)
    800068b8:	e022                	sd	s0,0(sp)
    800068ba:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    800068bc:	4e18                	lw	a4,24(a2)
    800068be:	6614                	ld	a3,8(a2)
    800068c0:	00002617          	auipc	a2,0x2
    800068c4:	f8060613          	addi	a2,a2,-128 # 80008840 <digits+0x60>
    800068c8:	fffff097          	auipc	ra,0xfffff
    800068cc:	1ea080e7          	jalr	490(ra) # 80005ab2 <snprintf>
}
    800068d0:	60a2                	ld	ra,8(sp)
    800068d2:	6402                	ld	s0,0(sp)
    800068d4:	0141                	addi	sp,sp,16
    800068d6:	8082                	ret

00000000800068d8 <statslock>:

int
statslock(char *buf, int sz) {
    800068d8:	7159                	addi	sp,sp,-112
    800068da:	f486                	sd	ra,104(sp)
    800068dc:	f0a2                	sd	s0,96(sp)
    800068de:	eca6                	sd	s1,88(sp)
    800068e0:	e8ca                	sd	s2,80(sp)
    800068e2:	e4ce                	sd	s3,72(sp)
    800068e4:	e0d2                	sd	s4,64(sp)
    800068e6:	fc56                	sd	s5,56(sp)
    800068e8:	f85a                	sd	s6,48(sp)
    800068ea:	f45e                	sd	s7,40(sp)
    800068ec:	f062                	sd	s8,32(sp)
    800068ee:	ec66                	sd	s9,24(sp)
    800068f0:	e86a                	sd	s10,16(sp)
    800068f2:	e46e                	sd	s11,8(sp)
    800068f4:	1880                	addi	s0,sp,112
    800068f6:	8aaa                	mv	s5,a0
    800068f8:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    800068fa:	00024517          	auipc	a0,0x24
    800068fe:	98e50513          	addi	a0,a0,-1650 # 8002a288 <lock_locks>
    80006902:	00000097          	auipc	ra,0x0
    80006906:	d7e080e7          	jalr	-642(ra) # 80006680 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    8000690a:	00002617          	auipc	a2,0x2
    8000690e:	f6660613          	addi	a2,a2,-154 # 80008870 <digits+0x90>
    80006912:	85da                	mv	a1,s6
    80006914:	8556                	mv	a0,s5
    80006916:	fffff097          	auipc	ra,0xfffff
    8000691a:	19c080e7          	jalr	412(ra) # 80005ab2 <snprintf>
    8000691e:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006920:	00024c97          	auipc	s9,0x24
    80006924:	988c8c93          	addi	s9,s9,-1656 # 8002a2a8 <locks>
    80006928:	00025c17          	auipc	s8,0x25
    8000692c:	920c0c13          	addi	s8,s8,-1760 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006930:	84e6                	mv	s1,s9
  int tot = 0;
    80006932:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006934:	00002b97          	auipc	s7,0x2
    80006938:	b44b8b93          	addi	s7,s7,-1212 # 80008478 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    8000693c:	00001d17          	auipc	s10,0x1
    80006940:	6dcd0d13          	addi	s10,s10,1756 # 80008018 <etext+0x18>
    80006944:	a01d                	j	8000696a <statslock+0x92>
      tot += locks[i]->nts;
    80006946:	0009b603          	ld	a2,0(s3)
    8000694a:	4e1c                	lw	a5,24(a2)
    8000694c:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006950:	412b05bb          	subw	a1,s6,s2
    80006954:	012a8533          	add	a0,s5,s2
    80006958:	00000097          	auipc	ra,0x0
    8000695c:	f52080e7          	jalr	-174(ra) # 800068aa <snprint_lock>
    80006960:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006964:	04a1                	addi	s1,s1,8
    80006966:	05848763          	beq	s1,s8,800069b4 <statslock+0xdc>
    if(locks[i] == 0)
    8000696a:	89a6                	mv	s3,s1
    8000696c:	609c                	ld	a5,0(s1)
    8000696e:	c3b9                	beqz	a5,800069b4 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006970:	0087bd83          	ld	s11,8(a5)
    80006974:	855e                	mv	a0,s7
    80006976:	ffffa097          	auipc	ra,0xffffa
    8000697a:	a64080e7          	jalr	-1436(ra) # 800003da <strlen>
    8000697e:	0005061b          	sext.w	a2,a0
    80006982:	85de                	mv	a1,s7
    80006984:	856e                	mv	a0,s11
    80006986:	ffffa097          	auipc	ra,0xffffa
    8000698a:	9a8080e7          	jalr	-1624(ra) # 8000032e <strncmp>
    8000698e:	dd45                	beqz	a0,80006946 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006990:	609c                	ld	a5,0(s1)
    80006992:	0087bd83          	ld	s11,8(a5)
    80006996:	856a                	mv	a0,s10
    80006998:	ffffa097          	auipc	ra,0xffffa
    8000699c:	a42080e7          	jalr	-1470(ra) # 800003da <strlen>
    800069a0:	0005061b          	sext.w	a2,a0
    800069a4:	85ea                	mv	a1,s10
    800069a6:	856e                	mv	a0,s11
    800069a8:	ffffa097          	auipc	ra,0xffffa
    800069ac:	986080e7          	jalr	-1658(ra) # 8000032e <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069b0:	f955                	bnez	a0,80006964 <statslock+0x8c>
    800069b2:	bf51                	j	80006946 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    800069b4:	00002617          	auipc	a2,0x2
    800069b8:	edc60613          	addi	a2,a2,-292 # 80008890 <digits+0xb0>
    800069bc:	412b05bb          	subw	a1,s6,s2
    800069c0:	012a8533          	add	a0,s5,s2
    800069c4:	fffff097          	auipc	ra,0xfffff
    800069c8:	0ee080e7          	jalr	238(ra) # 80005ab2 <snprintf>
    800069cc:	012509bb          	addw	s3,a0,s2
    800069d0:	4b95                	li	s7,5
  int last = 100000000;
    800069d2:	05f5e537          	lui	a0,0x5f5e
    800069d6:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    800069da:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069dc:	00024497          	auipc	s1,0x24
    800069e0:	8cc48493          	addi	s1,s1,-1844 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    800069e4:	1f400913          	li	s2,500
    800069e8:	a881                	j	80006a38 <statslock+0x160>
    800069ea:	2705                	addiw	a4,a4,1
    800069ec:	06a1                	addi	a3,a3,8
    800069ee:	03270063          	beq	a4,s2,80006a0e <statslock+0x136>
      if(locks[i] == 0)
    800069f2:	629c                	ld	a5,0(a3)
    800069f4:	cf89                	beqz	a5,80006a0e <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069f6:	4f90                	lw	a2,24(a5)
    800069f8:	00359793          	slli	a5,a1,0x3
    800069fc:	97a6                	add	a5,a5,s1
    800069fe:	639c                	ld	a5,0(a5)
    80006a00:	4f9c                	lw	a5,24(a5)
    80006a02:	fec7d4e3          	bge	a5,a2,800069ea <statslock+0x112>
    80006a06:	fea652e3          	bge	a2,a0,800069ea <statslock+0x112>
    80006a0a:	85ba                	mv	a1,a4
    80006a0c:	bff9                	j	800069ea <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006a0e:	058e                	slli	a1,a1,0x3
    80006a10:	00b48d33          	add	s10,s1,a1
    80006a14:	000d3603          	ld	a2,0(s10)
    80006a18:	413b05bb          	subw	a1,s6,s3
    80006a1c:	013a8533          	add	a0,s5,s3
    80006a20:	00000097          	auipc	ra,0x0
    80006a24:	e8a080e7          	jalr	-374(ra) # 800068aa <snprint_lock>
    80006a28:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006a2c:	000d3783          	ld	a5,0(s10)
    80006a30:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006a32:	3bfd                	addiw	s7,s7,-1
    80006a34:	000b8663          	beqz	s7,80006a40 <statslock+0x168>
  int tot = 0;
    80006a38:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006a3a:	8762                	mv	a4,s8
    int top = 0;
    80006a3c:	85e2                	mv	a1,s8
    80006a3e:	bf55                	j	800069f2 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006a40:	86d2                	mv	a3,s4
    80006a42:	00002617          	auipc	a2,0x2
    80006a46:	e6e60613          	addi	a2,a2,-402 # 800088b0 <digits+0xd0>
    80006a4a:	413b05bb          	subw	a1,s6,s3
    80006a4e:	013a8533          	add	a0,s5,s3
    80006a52:	fffff097          	auipc	ra,0xfffff
    80006a56:	060080e7          	jalr	96(ra) # 80005ab2 <snprintf>
    80006a5a:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006a5e:	00024517          	auipc	a0,0x24
    80006a62:	82a50513          	addi	a0,a0,-2006 # 8002a288 <lock_locks>
    80006a66:	00000097          	auipc	ra,0x0
    80006a6a:	cea080e7          	jalr	-790(ra) # 80006750 <release>
  return n;
}
    80006a6e:	854e                	mv	a0,s3
    80006a70:	70a6                	ld	ra,104(sp)
    80006a72:	7406                	ld	s0,96(sp)
    80006a74:	64e6                	ld	s1,88(sp)
    80006a76:	6946                	ld	s2,80(sp)
    80006a78:	69a6                	ld	s3,72(sp)
    80006a7a:	6a06                	ld	s4,64(sp)
    80006a7c:	7ae2                	ld	s5,56(sp)
    80006a7e:	7b42                	ld	s6,48(sp)
    80006a80:	7ba2                	ld	s7,40(sp)
    80006a82:	7c02                	ld	s8,32(sp)
    80006a84:	6ce2                	ld	s9,24(sp)
    80006a86:	6d42                	ld	s10,16(sp)
    80006a88:	6da2                	ld	s11,8(sp)
    80006a8a:	6165                	addi	sp,sp,112
    80006a8c:	8082                	ret
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
