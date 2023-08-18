
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
int p1[2], fdr, fdw;
long p, n;
int is_first = 1;

int main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  14:	8a2a                	mv	s4,a0
  16:	8aae                	mv	s5,a1
    if (is_first == 1)
  18:	00001717          	auipc	a4,0x1
  1c:	96072703          	lw	a4,-1696(a4) # 978 <is_first>
  20:	4785                	li	a5,1
  22:	06f70e63          	beq	a4,a5,9e <main+0x9e>
        {
            write(fdw, (void *)&n, 8);
        }
        close(fdw);
    }
    if (fork() == 0)
  26:	00000097          	auipc	ra,0x0
  2a:	3ee080e7          	jalr	1006(ra) # 414 <fork>
  2e:	14051a63          	bnez	a0,182 <main+0x182>
    {
        if (read(fdr, (void *)&p, 8))
  32:	4621                	li	a2,8
  34:	00001597          	auipc	a1,0x1
  38:	95458593          	addi	a1,a1,-1708 # 988 <p>
  3c:	00001517          	auipc	a0,0x1
  40:	95852503          	lw	a0,-1704(a0) # 994 <fdr>
  44:	00000097          	auipc	ra,0x0
  48:	3f0080e7          	jalr	1008(ra) # 434 <read>
  4c:	e961                	bnez	a0,11c <main+0x11c>
            printf("prime %d\n", p);
            pipe(p1);
            fdw = p1[1];
        }

        while (read(fdr, (void *)&n, 8))
  4e:	00001917          	auipc	s2,0x1
  52:	94690913          	addi	s2,s2,-1722 # 994 <fdr>
  56:	00001497          	auipc	s1,0x1
  5a:	92a48493          	addi	s1,s1,-1750 # 980 <n>
        {
            if (n % p != 0)
  5e:	00001997          	auipc	s3,0x1
  62:	92a98993          	addi	s3,s3,-1750 # 988 <p>
                write(fdw, (void *)&n, 8);
  66:	00001b17          	auipc	s6,0x1
  6a:	92ab0b13          	addi	s6,s6,-1750 # 990 <fdw>
        while (read(fdr, (void *)&n, 8))
  6e:	4621                	li	a2,8
  70:	85a6                	mv	a1,s1
  72:	00092503          	lw	a0,0(s2)
  76:	00000097          	auipc	ra,0x0
  7a:	3be080e7          	jalr	958(ra) # 434 <read>
  7e:	cd61                	beqz	a0,156 <main+0x156>
            if (n % p != 0)
  80:	609c                	ld	a5,0(s1)
  82:	0009b703          	ld	a4,0(s3)
  86:	02e7e7b3          	rem	a5,a5,a4
  8a:	d3f5                	beqz	a5,6e <main+0x6e>
                write(fdw, (void *)&n, 8);
  8c:	4621                	li	a2,8
  8e:	85a6                	mv	a1,s1
  90:	000b2503          	lw	a0,0(s6)
  94:	00000097          	auipc	ra,0x0
  98:	3a8080e7          	jalr	936(ra) # 43c <write>
  9c:	bfc9                	j	6e <main+0x6e>
        is_first = 0;
  9e:	00001797          	auipc	a5,0x1
  a2:	8c07ad23          	sw	zero,-1830(a5) # 978 <is_first>
        pipe(p1);
  a6:	00001517          	auipc	a0,0x1
  aa:	8f250513          	addi	a0,a0,-1806 # 998 <p1>
  ae:	00000097          	auipc	ra,0x0
  b2:	37e080e7          	jalr	894(ra) # 42c <pipe>
        fdr = p1[0];
  b6:	00001797          	auipc	a5,0x1
  ba:	8e278793          	addi	a5,a5,-1822 # 998 <p1>
  be:	4398                	lw	a4,0(a5)
  c0:	00001697          	auipc	a3,0x1
  c4:	8ce6aa23          	sw	a4,-1836(a3) # 994 <fdr>
        fdw = p1[1];
  c8:	43dc                	lw	a5,4(a5)
  ca:	00001717          	auipc	a4,0x1
  ce:	8cf72323          	sw	a5,-1850(a4) # 990 <fdw>
        for (n = 2; n <= MAX_NUM; n++)
  d2:	4789                	li	a5,2
  d4:	00001717          	auipc	a4,0x1
  d8:	8af73623          	sd	a5,-1876(a4) # 980 <n>
            write(fdw, (void *)&n, 8);
  dc:	00001997          	auipc	s3,0x1
  e0:	8b498993          	addi	s3,s3,-1868 # 990 <fdw>
  e4:	00001497          	auipc	s1,0x1
  e8:	89c48493          	addi	s1,s1,-1892 # 980 <n>
        for (n = 2; n <= MAX_NUM; n++)
  ec:	02300913          	li	s2,35
            write(fdw, (void *)&n, 8);
  f0:	4621                	li	a2,8
  f2:	85a6                	mv	a1,s1
  f4:	0009a503          	lw	a0,0(s3)
  f8:	00000097          	auipc	ra,0x0
  fc:	344080e7          	jalr	836(ra) # 43c <write>
        for (n = 2; n <= MAX_NUM; n++)
 100:	609c                	ld	a5,0(s1)
 102:	0785                	addi	a5,a5,1
 104:	e09c                	sd	a5,0(s1)
 106:	fef955e3          	bge	s2,a5,f0 <main+0xf0>
        close(fdw);
 10a:	00001517          	auipc	a0,0x1
 10e:	88652503          	lw	a0,-1914(a0) # 990 <fdw>
 112:	00000097          	auipc	ra,0x0
 116:	332080e7          	jalr	818(ra) # 444 <close>
 11a:	b731                	j	26 <main+0x26>
            printf("prime %d\n", p);
 11c:	00001597          	auipc	a1,0x1
 120:	86c5b583          	ld	a1,-1940(a1) # 988 <p>
 124:	00001517          	auipc	a0,0x1
 128:	82450513          	addi	a0,a0,-2012 # 948 <malloc+0xe6>
 12c:	00000097          	auipc	ra,0x0
 130:	678080e7          	jalr	1656(ra) # 7a4 <printf>
            pipe(p1);
 134:	00001517          	auipc	a0,0x1
 138:	86450513          	addi	a0,a0,-1948 # 998 <p1>
 13c:	00000097          	auipc	ra,0x0
 140:	2f0080e7          	jalr	752(ra) # 42c <pipe>
            fdw = p1[1];
 144:	00001797          	auipc	a5,0x1
 148:	8587a783          	lw	a5,-1960(a5) # 99c <p1+0x4>
 14c:	00001717          	auipc	a4,0x1
 150:	84f72223          	sw	a5,-1980(a4) # 990 <fdw>
 154:	bded                	j	4e <main+0x4e>
        }
        fdr = p1[0];
 156:	00001797          	auipc	a5,0x1
 15a:	8427a783          	lw	a5,-1982(a5) # 998 <p1>
 15e:	00001717          	auipc	a4,0x1
 162:	82f72b23          	sw	a5,-1994(a4) # 994 <fdr>
        close(fdw);
 166:	00001517          	auipc	a0,0x1
 16a:	82a52503          	lw	a0,-2006(a0) # 990 <fdw>
 16e:	00000097          	auipc	ra,0x0
 172:	2d6080e7          	jalr	726(ra) # 444 <close>
        main(argc, argv);
 176:	85d6                	mv	a1,s5
 178:	8552                	mv	a0,s4
 17a:	00000097          	auipc	ra,0x0
 17e:	e86080e7          	jalr	-378(ra) # 0 <main>
    }
    else
    {
        wait((int *)0);
 182:	4501                	li	a0,0
 184:	00000097          	auipc	ra,0x0
 188:	2a0080e7          	jalr	672(ra) # 424 <wait>
        close(fdr);
 18c:	00001517          	auipc	a0,0x1
 190:	80852503          	lw	a0,-2040(a0) # 994 <fdr>
 194:	00000097          	auipc	ra,0x0
 198:	2b0080e7          	jalr	688(ra) # 444 <close>
    }

    exit(0);
 19c:	4501                	li	a0,0
 19e:	00000097          	auipc	ra,0x0
 1a2:	27e080e7          	jalr	638(ra) # 41c <exit>

00000000000001a6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ac:	87aa                	mv	a5,a0
 1ae:	0585                	addi	a1,a1,1
 1b0:	0785                	addi	a5,a5,1
 1b2:	fff5c703          	lbu	a4,-1(a1)
 1b6:	fee78fa3          	sb	a4,-1(a5)
 1ba:	fb75                	bnez	a4,1ae <strcpy+0x8>
    ;
  return os;
}
 1bc:	6422                	ld	s0,8(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret

00000000000001c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	cb91                	beqz	a5,1e0 <strcmp+0x1e>
 1ce:	0005c703          	lbu	a4,0(a1)
 1d2:	00f71763          	bne	a4,a5,1e0 <strcmp+0x1e>
    p++, q++;
 1d6:	0505                	addi	a0,a0,1
 1d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbe5                	bnez	a5,1ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e0:	0005c503          	lbu	a0,0(a1)
}
 1e4:	40a7853b          	subw	a0,a5,a0
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret

00000000000001ee <strlen>:

uint
strlen(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf91                	beqz	a5,214 <strlen+0x26>
 1fa:	0505                	addi	a0,a0,1
 1fc:	87aa                	mv	a5,a0
 1fe:	4685                	li	a3,1
 200:	9e89                	subw	a3,a3,a0
 202:	00f6853b          	addw	a0,a3,a5
 206:	0785                	addi	a5,a5,1
 208:	fff7c703          	lbu	a4,-1(a5)
 20c:	fb7d                	bnez	a4,202 <strlen+0x14>
    ;
  return n;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  for(n = 0; s[n]; n++)
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <strlen+0x20>

0000000000000218 <memset>:

void*
memset(void *dst, int c, uint n)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 21e:	ce09                	beqz	a2,238 <memset+0x20>
 220:	87aa                	mv	a5,a0
 222:	fff6071b          	addiw	a4,a2,-1
 226:	1702                	slli	a4,a4,0x20
 228:	9301                	srli	a4,a4,0x20
 22a:	0705                	addi	a4,a4,1
 22c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x16>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  for(; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if(*s == c)
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for(; *s; s++)
 24e:	0505                	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
      return (char*)s;
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	711d                	addi	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	addi	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	2485                	addiw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	addi	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	1a0080e7          	jalr	416(ra) # 434 <read>
    if(cc < 1)
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	addi	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
  for(i=0; i+1 < max; ){
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	addi	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e426                	sd	s1,8(sp)
 2de:	e04a                	sd	s2,0(sp)
 2e0:	1000                	addi	s0,sp,32
 2e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e4:	4581                	li	a1,0
 2e6:	00000097          	auipc	ra,0x0
 2ea:	176080e7          	jalr	374(ra) # 45c <open>
  if(fd < 0)
 2ee:	02054563          	bltz	a0,318 <stat+0x42>
 2f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	17e080e7          	jalr	382(ra) # 474 <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	00000097          	auipc	ra,0x0
 306:	142080e7          	jalr	322(ra) # 444 <close>
  return r;
}
 30a:	854a                	mv	a0,s2
 30c:	60e2                	ld	ra,24(sp)
 30e:	6442                	ld	s0,16(sp)
 310:	64a2                	ld	s1,8(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	597d                	li	s2,-1
 31a:	bfc5                	j	30a <stat+0x34>

000000000000031c <atoi>:

int
atoi(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 322:	00054603          	lbu	a2,0(a0)
 326:	fd06079b          	addiw	a5,a2,-48
 32a:	0ff7f793          	andi	a5,a5,255
 32e:	4725                	li	a4,9
 330:	02f76963          	bltu	a4,a5,362 <atoi+0x46>
 334:	86aa                	mv	a3,a0
  n = 0;
 336:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 338:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 33a:	0685                	addi	a3,a3,1
 33c:	0025179b          	slliw	a5,a0,0x2
 340:	9fa9                	addw	a5,a5,a0
 342:	0017979b          	slliw	a5,a5,0x1
 346:	9fb1                	addw	a5,a5,a2
 348:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34c:	0006c603          	lbu	a2,0(a3)
 350:	fd06071b          	addiw	a4,a2,-48
 354:	0ff77713          	andi	a4,a4,255
 358:	fee5f1e3          	bgeu	a1,a4,33a <atoi+0x1e>
  return n;
}
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  n = 0;
 362:	4501                	li	a0,0
 364:	bfe5                	j	35c <atoi+0x40>

0000000000000366 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36c:	02b57663          	bgeu	a0,a1,398 <memmove+0x32>
    while(n-- > 0)
 370:	02c05163          	blez	a2,392 <memmove+0x2c>
 374:	fff6079b          	addiw	a5,a2,-1
 378:	1782                	slli	a5,a5,0x20
 37a:	9381                	srli	a5,a5,0x20
 37c:	0785                	addi	a5,a5,1
 37e:	97aa                	add	a5,a5,a0
  dst = vdst;
 380:	872a                	mv	a4,a0
      *dst++ = *src++;
 382:	0585                	addi	a1,a1,1
 384:	0705                	addi	a4,a4,1
 386:	fff5c683          	lbu	a3,-1(a1)
 38a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38e:	fee79ae3          	bne	a5,a4,382 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
    dst += n;
 398:	00c50733          	add	a4,a0,a2
    src += n;
 39c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 39e:	fec05ae3          	blez	a2,392 <memmove+0x2c>
 3a2:	fff6079b          	addiw	a5,a2,-1
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	fff7c793          	not	a5,a5
 3ae:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b0:	15fd                	addi	a1,a1,-1
 3b2:	177d                	addi	a4,a4,-1
 3b4:	0005c683          	lbu	a3,0(a1)
 3b8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3bc:	fee79ae3          	bne	a5,a4,3b0 <memmove+0x4a>
 3c0:	bfc9                	j	392 <memmove+0x2c>

00000000000003c2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c8:	ca05                	beqz	a2,3f8 <memcmp+0x36>
 3ca:	fff6069b          	addiw	a3,a2,-1
 3ce:	1682                	slli	a3,a3,0x20
 3d0:	9281                	srli	a3,a3,0x20
 3d2:	0685                	addi	a3,a3,1
 3d4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	0005c703          	lbu	a4,0(a1)
 3de:	00e79863          	bne	a5,a4,3ee <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e2:	0505                	addi	a0,a0,1
    p2++;
 3e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e6:	fed518e3          	bne	a0,a3,3d6 <memcmp+0x14>
  }
  return 0;
 3ea:	4501                	li	a0,0
 3ec:	a019                	j	3f2 <memcmp+0x30>
      return *p1 - *p2;
 3ee:	40e7853b          	subw	a0,a5,a4
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret
  return 0;
 3f8:	4501                	li	a0,0
 3fa:	bfe5                	j	3f2 <memcmp+0x30>

00000000000003fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e406                	sd	ra,8(sp)
 400:	e022                	sd	s0,0(sp)
 402:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 404:	00000097          	auipc	ra,0x0
 408:	f62080e7          	jalr	-158(ra) # 366 <memmove>
}
 40c:	60a2                	ld	ra,8(sp)
 40e:	6402                	ld	s0,0(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret

0000000000000414 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 414:	4885                	li	a7,1
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exit>:
.global exit
exit:
 li a7, SYS_exit
 41c:	4889                	li	a7,2
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <wait>:
.global wait
wait:
 li a7, SYS_wait
 424:	488d                	li	a7,3
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 42c:	4891                	li	a7,4
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <read>:
.global read
read:
 li a7, SYS_read
 434:	4895                	li	a7,5
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <write>:
.global write
write:
 li a7, SYS_write
 43c:	48c1                	li	a7,16
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <close>:
.global close
close:
 li a7, SYS_close
 444:	48d5                	li	a7,21
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <kill>:
.global kill
kill:
 li a7, SYS_kill
 44c:	4899                	li	a7,6
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <exec>:
.global exec
exec:
 li a7, SYS_exec
 454:	489d                	li	a7,7
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <open>:
.global open
open:
 li a7, SYS_open
 45c:	48bd                	li	a7,15
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 464:	48c5                	li	a7,17
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 46c:	48c9                	li	a7,18
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 474:	48a1                	li	a7,8
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <link>:
.global link
link:
 li a7, SYS_link
 47c:	48cd                	li	a7,19
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 484:	48d1                	li	a7,20
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 48c:	48a5                	li	a7,9
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <dup>:
.global dup
dup:
 li a7, SYS_dup
 494:	48a9                	li	a7,10
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 49c:	48ad                	li	a7,11
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a4:	48b1                	li	a7,12
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ac:	48b5                	li	a7,13
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b4:	48b9                	li	a7,14
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <trace>:
.global trace
trace:
 li a7, SYS_trace
 4bc:	48d9                	li	a7,22
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4c4:	48dd                	li	a7,23
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4cc:	1101                	addi	sp,sp,-32
 4ce:	ec06                	sd	ra,24(sp)
 4d0:	e822                	sd	s0,16(sp)
 4d2:	1000                	addi	s0,sp,32
 4d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d8:	4605                	li	a2,1
 4da:	fef40593          	addi	a1,s0,-17
 4de:	00000097          	auipc	ra,0x0
 4e2:	f5e080e7          	jalr	-162(ra) # 43c <write>
}
 4e6:	60e2                	ld	ra,24(sp)
 4e8:	6442                	ld	s0,16(sp)
 4ea:	6105                	addi	sp,sp,32
 4ec:	8082                	ret

00000000000004ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ee:	7139                	addi	sp,sp,-64
 4f0:	fc06                	sd	ra,56(sp)
 4f2:	f822                	sd	s0,48(sp)
 4f4:	f426                	sd	s1,40(sp)
 4f6:	f04a                	sd	s2,32(sp)
 4f8:	ec4e                	sd	s3,24(sp)
 4fa:	0080                	addi	s0,sp,64
 4fc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fe:	c299                	beqz	a3,504 <printint+0x16>
 500:	0805c863          	bltz	a1,590 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 504:	2581                	sext.w	a1,a1
  neg = 0;
 506:	4881                	li	a7,0
 508:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 50c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 50e:	2601                	sext.w	a2,a2
 510:	00000517          	auipc	a0,0x0
 514:	45050513          	addi	a0,a0,1104 # 960 <digits>
 518:	883a                	mv	a6,a4
 51a:	2705                	addiw	a4,a4,1
 51c:	02c5f7bb          	remuw	a5,a1,a2
 520:	1782                	slli	a5,a5,0x20
 522:	9381                	srli	a5,a5,0x20
 524:	97aa                	add	a5,a5,a0
 526:	0007c783          	lbu	a5,0(a5)
 52a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 52e:	0005879b          	sext.w	a5,a1
 532:	02c5d5bb          	divuw	a1,a1,a2
 536:	0685                	addi	a3,a3,1
 538:	fec7f0e3          	bgeu	a5,a2,518 <printint+0x2a>
  if(neg)
 53c:	00088b63          	beqz	a7,552 <printint+0x64>
    buf[i++] = '-';
 540:	fd040793          	addi	a5,s0,-48
 544:	973e                	add	a4,a4,a5
 546:	02d00793          	li	a5,45
 54a:	fef70823          	sb	a5,-16(a4)
 54e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 552:	02e05863          	blez	a4,582 <printint+0x94>
 556:	fc040793          	addi	a5,s0,-64
 55a:	00e78933          	add	s2,a5,a4
 55e:	fff78993          	addi	s3,a5,-1
 562:	99ba                	add	s3,s3,a4
 564:	377d                	addiw	a4,a4,-1
 566:	1702                	slli	a4,a4,0x20
 568:	9301                	srli	a4,a4,0x20
 56a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 56e:	fff94583          	lbu	a1,-1(s2)
 572:	8526                	mv	a0,s1
 574:	00000097          	auipc	ra,0x0
 578:	f58080e7          	jalr	-168(ra) # 4cc <putc>
  while(--i >= 0)
 57c:	197d                	addi	s2,s2,-1
 57e:	ff3918e3          	bne	s2,s3,56e <printint+0x80>
}
 582:	70e2                	ld	ra,56(sp)
 584:	7442                	ld	s0,48(sp)
 586:	74a2                	ld	s1,40(sp)
 588:	7902                	ld	s2,32(sp)
 58a:	69e2                	ld	s3,24(sp)
 58c:	6121                	addi	sp,sp,64
 58e:	8082                	ret
    x = -xx;
 590:	40b005bb          	negw	a1,a1
    neg = 1;
 594:	4885                	li	a7,1
    x = -xx;
 596:	bf8d                	j	508 <printint+0x1a>

0000000000000598 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 598:	7119                	addi	sp,sp,-128
 59a:	fc86                	sd	ra,120(sp)
 59c:	f8a2                	sd	s0,112(sp)
 59e:	f4a6                	sd	s1,104(sp)
 5a0:	f0ca                	sd	s2,96(sp)
 5a2:	ecce                	sd	s3,88(sp)
 5a4:	e8d2                	sd	s4,80(sp)
 5a6:	e4d6                	sd	s5,72(sp)
 5a8:	e0da                	sd	s6,64(sp)
 5aa:	fc5e                	sd	s7,56(sp)
 5ac:	f862                	sd	s8,48(sp)
 5ae:	f466                	sd	s9,40(sp)
 5b0:	f06a                	sd	s10,32(sp)
 5b2:	ec6e                	sd	s11,24(sp)
 5b4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b6:	0005c903          	lbu	s2,0(a1)
 5ba:	18090f63          	beqz	s2,758 <vprintf+0x1c0>
 5be:	8aaa                	mv	s5,a0
 5c0:	8b32                	mv	s6,a2
 5c2:	00158493          	addi	s1,a1,1
  state = 0;
 5c6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c8:	02500a13          	li	s4,37
      if(c == 'd'){
 5cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5d0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5d4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5d8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5dc:	00000b97          	auipc	s7,0x0
 5e0:	384b8b93          	addi	s7,s7,900 # 960 <digits>
 5e4:	a839                	j	602 <vprintf+0x6a>
        putc(fd, c);
 5e6:	85ca                	mv	a1,s2
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	ee2080e7          	jalr	-286(ra) # 4cc <putc>
 5f2:	a019                	j	5f8 <vprintf+0x60>
    } else if(state == '%'){
 5f4:	01498f63          	beq	s3,s4,612 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5f8:	0485                	addi	s1,s1,1
 5fa:	fff4c903          	lbu	s2,-1(s1)
 5fe:	14090d63          	beqz	s2,758 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 602:	0009079b          	sext.w	a5,s2
    if(state == 0){
 606:	fe0997e3          	bnez	s3,5f4 <vprintf+0x5c>
      if(c == '%'){
 60a:	fd479ee3          	bne	a5,s4,5e6 <vprintf+0x4e>
        state = '%';
 60e:	89be                	mv	s3,a5
 610:	b7e5                	j	5f8 <vprintf+0x60>
      if(c == 'd'){
 612:	05878063          	beq	a5,s8,652 <vprintf+0xba>
      } else if(c == 'l') {
 616:	05978c63          	beq	a5,s9,66e <vprintf+0xd6>
      } else if(c == 'x') {
 61a:	07a78863          	beq	a5,s10,68a <vprintf+0xf2>
      } else if(c == 'p') {
 61e:	09b78463          	beq	a5,s11,6a6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 622:	07300713          	li	a4,115
 626:	0ce78663          	beq	a5,a4,6f2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62a:	06300713          	li	a4,99
 62e:	0ee78e63          	beq	a5,a4,72a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 632:	11478863          	beq	a5,s4,742 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 636:	85d2                	mv	a1,s4
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e92080e7          	jalr	-366(ra) # 4cc <putc>
        putc(fd, c);
 642:	85ca                	mv	a1,s2
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e86080e7          	jalr	-378(ra) # 4cc <putc>
      }
      state = 0;
 64e:	4981                	li	s3,0
 650:	b765                	j	5f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 652:	008b0913          	addi	s2,s6,8
 656:	4685                	li	a3,1
 658:	4629                	li	a2,10
 65a:	000b2583          	lw	a1,0(s6)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	e8e080e7          	jalr	-370(ra) # 4ee <printint>
 668:	8b4a                	mv	s6,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b771                	j	5f8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b0913          	addi	s2,s6,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000b2583          	lw	a1,0(s6)
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e72080e7          	jalr	-398(ra) # 4ee <printint>
 684:	8b4a                	mv	s6,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bf85                	j	5f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 68a:	008b0913          	addi	s2,s6,8
 68e:	4681                	li	a3,0
 690:	4641                	li	a2,16
 692:	000b2583          	lw	a1,0(s6)
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	e56080e7          	jalr	-426(ra) # 4ee <printint>
 6a0:	8b4a                	mv	s6,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bf91                	j	5f8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b0793          	addi	a5,s6,8
 6aa:	f8f43423          	sd	a5,-120(s0)
 6ae:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6b2:	03000593          	li	a1,48
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e14080e7          	jalr	-492(ra) # 4cc <putc>
  putc(fd, 'x');
 6c0:	85ea                	mv	a1,s10
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e08080e7          	jalr	-504(ra) # 4cc <putc>
 6cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ce:	03c9d793          	srli	a5,s3,0x3c
 6d2:	97de                	add	a5,a5,s7
 6d4:	0007c583          	lbu	a1,0(a5)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	df2080e7          	jalr	-526(ra) # 4cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e2:	0992                	slli	s3,s3,0x4
 6e4:	397d                	addiw	s2,s2,-1
 6e6:	fe0914e3          	bnez	s2,6ce <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6ea:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b721                	j	5f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6f2:	008b0993          	addi	s3,s6,8
 6f6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6fa:	02090163          	beqz	s2,71c <vprintf+0x184>
        while(*s != 0){
 6fe:	00094583          	lbu	a1,0(s2)
 702:	c9a1                	beqz	a1,752 <vprintf+0x1ba>
          putc(fd, *s);
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	dc6080e7          	jalr	-570(ra) # 4cc <putc>
          s++;
 70e:	0905                	addi	s2,s2,1
        while(*s != 0){
 710:	00094583          	lbu	a1,0(s2)
 714:	f9e5                	bnez	a1,704 <vprintf+0x16c>
        s = va_arg(ap, char*);
 716:	8b4e                	mv	s6,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	bdf9                	j	5f8 <vprintf+0x60>
          s = "(null)";
 71c:	00000917          	auipc	s2,0x0
 720:	23c90913          	addi	s2,s2,572 # 958 <malloc+0xf6>
        while(*s != 0){
 724:	02800593          	li	a1,40
 728:	bff1                	j	704 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 72a:	008b0913          	addi	s2,s6,8
 72e:	000b4583          	lbu	a1,0(s6)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	d98080e7          	jalr	-616(ra) # 4cc <putc>
 73c:	8b4a                	mv	s6,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	bd65                	j	5f8 <vprintf+0x60>
        putc(fd, c);
 742:	85d2                	mv	a1,s4
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	d86080e7          	jalr	-634(ra) # 4cc <putc>
      state = 0;
 74e:	4981                	li	s3,0
 750:	b565                	j	5f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 752:	8b4e                	mv	s6,s3
      state = 0;
 754:	4981                	li	s3,0
 756:	b54d                	j	5f8 <vprintf+0x60>
    }
  }
}
 758:	70e6                	ld	ra,120(sp)
 75a:	7446                	ld	s0,112(sp)
 75c:	74a6                	ld	s1,104(sp)
 75e:	7906                	ld	s2,96(sp)
 760:	69e6                	ld	s3,88(sp)
 762:	6a46                	ld	s4,80(sp)
 764:	6aa6                	ld	s5,72(sp)
 766:	6b06                	ld	s6,64(sp)
 768:	7be2                	ld	s7,56(sp)
 76a:	7c42                	ld	s8,48(sp)
 76c:	7ca2                	ld	s9,40(sp)
 76e:	7d02                	ld	s10,32(sp)
 770:	6de2                	ld	s11,24(sp)
 772:	6109                	addi	sp,sp,128
 774:	8082                	ret

0000000000000776 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 776:	715d                	addi	sp,sp,-80
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e010                	sd	a2,0(s0)
 780:	e414                	sd	a3,8(s0)
 782:	e818                	sd	a4,16(s0)
 784:	ec1c                	sd	a5,24(s0)
 786:	03043023          	sd	a6,32(s0)
 78a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 792:	8622                	mv	a2,s0
 794:	00000097          	auipc	ra,0x0
 798:	e04080e7          	jalr	-508(ra) # 598 <vprintf>
}
 79c:	60e2                	ld	ra,24(sp)
 79e:	6442                	ld	s0,16(sp)
 7a0:	6161                	addi	sp,sp,80
 7a2:	8082                	ret

00000000000007a4 <printf>:

void
printf(const char *fmt, ...)
{
 7a4:	711d                	addi	sp,sp,-96
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	e40c                	sd	a1,8(s0)
 7ae:	e810                	sd	a2,16(s0)
 7b0:	ec14                	sd	a3,24(s0)
 7b2:	f018                	sd	a4,32(s0)
 7b4:	f41c                	sd	a5,40(s0)
 7b6:	03043823          	sd	a6,48(s0)
 7ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7be:	00840613          	addi	a2,s0,8
 7c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c6:	85aa                	mv	a1,a0
 7c8:	4505                	li	a0,1
 7ca:	00000097          	auipc	ra,0x0
 7ce:	dce080e7          	jalr	-562(ra) # 598 <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6125                	addi	sp,sp,96
 7d8:	8082                	ret

00000000000007da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7da:	1141                	addi	sp,sp,-16
 7dc:	e422                	sd	s0,8(sp)
 7de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	00000797          	auipc	a5,0x0
 7e8:	1bc7b783          	ld	a5,444(a5) # 9a0 <freep>
 7ec:	a805                	j	81c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ee:	4618                	lw	a4,8(a2)
 7f0:	9db9                	addw	a1,a1,a4
 7f2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	6318                	ld	a4,0(a4)
 7fa:	fee53823          	sd	a4,-16(a0)
 7fe:	a091                	j	842 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 800:	ff852703          	lw	a4,-8(a0)
 804:	9e39                	addw	a2,a2,a4
 806:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 808:	ff053703          	ld	a4,-16(a0)
 80c:	e398                	sd	a4,0(a5)
 80e:	a099                	j	854 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	6398                	ld	a4,0(a5)
 812:	00e7e463          	bltu	a5,a4,81a <free+0x40>
 816:	00e6ea63          	bltu	a3,a4,82a <free+0x50>
{
 81a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81c:	fed7fae3          	bgeu	a5,a3,810 <free+0x36>
 820:	6398                	ld	a4,0(a5)
 822:	00e6e463          	bltu	a3,a4,82a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	fee7eae3          	bltu	a5,a4,81a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 82a:	ff852583          	lw	a1,-8(a0)
 82e:	6390                	ld	a2,0(a5)
 830:	02059713          	slli	a4,a1,0x20
 834:	9301                	srli	a4,a4,0x20
 836:	0712                	slli	a4,a4,0x4
 838:	9736                	add	a4,a4,a3
 83a:	fae60ae3          	beq	a2,a4,7ee <free+0x14>
    bp->s.ptr = p->s.ptr;
 83e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 842:	4790                	lw	a2,8(a5)
 844:	02061713          	slli	a4,a2,0x20
 848:	9301                	srli	a4,a4,0x20
 84a:	0712                	slli	a4,a4,0x4
 84c:	973e                	add	a4,a4,a5
 84e:	fae689e3          	beq	a3,a4,800 <free+0x26>
  } else
    p->s.ptr = bp;
 852:	e394                	sd	a3,0(a5)
  freep = p;
 854:	00000717          	auipc	a4,0x0
 858:	14f73623          	sd	a5,332(a4) # 9a0 <freep>
}
 85c:	6422                	ld	s0,8(sp)
 85e:	0141                	addi	sp,sp,16
 860:	8082                	ret

0000000000000862 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 862:	7139                	addi	sp,sp,-64
 864:	fc06                	sd	ra,56(sp)
 866:	f822                	sd	s0,48(sp)
 868:	f426                	sd	s1,40(sp)
 86a:	f04a                	sd	s2,32(sp)
 86c:	ec4e                	sd	s3,24(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
 874:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	02051493          	slli	s1,a0,0x20
 87a:	9081                	srli	s1,s1,0x20
 87c:	04bd                	addi	s1,s1,15
 87e:	8091                	srli	s1,s1,0x4
 880:	0014899b          	addiw	s3,s1,1
 884:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 886:	00000517          	auipc	a0,0x0
 88a:	11a53503          	ld	a0,282(a0) # 9a0 <freep>
 88e:	c515                	beqz	a0,8ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	02977f63          	bgeu	a4,s1,8d2 <malloc+0x70>
 898:	8a4e                	mv	s4,s3
 89a:	0009871b          	sext.w	a4,s3
 89e:	6685                	lui	a3,0x1
 8a0:	00d77363          	bgeu	a4,a3,8a6 <malloc+0x44>
 8a4:	6a05                	lui	s4,0x1
 8a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ae:	00000917          	auipc	s2,0x0
 8b2:	0f290913          	addi	s2,s2,242 # 9a0 <freep>
  if(p == (char*)-1)
 8b6:	5afd                	li	s5,-1
 8b8:	a88d                	j	92a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8ba:	00000797          	auipc	a5,0x0
 8be:	0ee78793          	addi	a5,a5,238 # 9a8 <base>
 8c2:	00000717          	auipc	a4,0x0
 8c6:	0cf73f23          	sd	a5,222(a4) # 9a0 <freep>
 8ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d0:	b7e1                	j	898 <malloc+0x36>
      if(p->s.size == nunits)
 8d2:	02e48b63          	beq	s1,a4,908 <malloc+0xa6>
        p->s.size -= nunits;
 8d6:	4137073b          	subw	a4,a4,s3
 8da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8dc:	1702                	slli	a4,a4,0x20
 8de:	9301                	srli	a4,a4,0x20
 8e0:	0712                	slli	a4,a4,0x4
 8e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	0aa73c23          	sd	a0,184(a4) # 9a0 <freep>
      return (void*)(p + 1);
 8f0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f4:	70e2                	ld	ra,56(sp)
 8f6:	7442                	ld	s0,48(sp)
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	7902                	ld	s2,32(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 908:	6398                	ld	a4,0(a5)
 90a:	e118                	sd	a4,0(a0)
 90c:	bff1                	j	8e8 <malloc+0x86>
  hp->s.size = nu;
 90e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 912:	0541                	addi	a0,a0,16
 914:	00000097          	auipc	ra,0x0
 918:	ec6080e7          	jalr	-314(ra) # 7da <free>
  return freep;
 91c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 920:	d971                	beqz	a0,8f4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 924:	4798                	lw	a4,8(a5)
 926:	fa9776e3          	bgeu	a4,s1,8d2 <malloc+0x70>
    if(p == freep)
 92a:	00093703          	ld	a4,0(s2)
 92e:	853e                	mv	a0,a5
 930:	fef719e3          	bne	a4,a5,922 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 934:	8552                	mv	a0,s4
 936:	00000097          	auipc	ra,0x0
 93a:	b6e080e7          	jalr	-1170(ra) # 4a4 <sbrk>
  if(p == (char*)-1)
 93e:	fd5518e3          	bne	a0,s5,90e <malloc+0xac>
        return 0;
 942:	4501                	li	a0,0
 944:	bf45                	j	8f4 <malloc+0x92>
