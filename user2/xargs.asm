
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readline>:
char ch;
char arg_buf[512];
int n;

int readline()
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	e062                	sd	s8,0(sp)
  16:	0880                	addi	s0,sp,80
    argnum = preargnum;
  18:	00001797          	auipc	a5,0x1
  1c:	a947a783          	lw	a5,-1388(a5) # aac <preargnum>
  20:	00001717          	auipc	a4,0x1
  24:	a8f72423          	sw	a5,-1400(a4) # aa8 <argnum>
    // memset(args, 0, sizeof(args));
    memset(arg_buf, 0, sizeof(arg_buf));
  28:	20000613          	li	a2,512
  2c:	4581                	li	a1,0
  2e:	00001517          	auipc	a0,0x1
  32:	a8a50513          	addi	a0,a0,-1398 # ab8 <arg_buf>
  36:	00000097          	auipc	ra,0x0
  3a:	2c4080e7          	jalr	708(ra) # 2fa <memset>
    for (;;)
    {
        n = read(0, &ch, sizeof(ch));
  3e:	00001497          	auipc	s1,0x1
  42:	a6648493          	addi	s1,s1,-1434 # aa4 <ch>
  46:	00001997          	auipc	s3,0x1
  4a:	a5a98993          	addi	s3,s3,-1446 # aa0 <n>
            fprintf(2, "read error\n");
            exit(1);
        }
        else
        {
            if (ch == '\n')
  4e:	4a29                	li	s4,10
            {
                memcpy(args[argnum], arg_buf, strlen(arg_buf) + 1);
                argnum++;
                return 1;
            }
            else if (ch == ' ')
  50:	02000b13          	li	s6,32
                argnum++;
                memset(arg_buf, 0, sizeof(arg_buf));
            }
            else
            {
                arg_buf[strlen(arg_buf)] = ch;
  54:	00001917          	auipc	s2,0x1
  58:	a6490913          	addi	s2,s2,-1436 # ab8 <arg_buf>
                memcpy(args[argnum], arg_buf, strlen(arg_buf) + 1);
  5c:	00001a97          	auipc	s5,0x1
  60:	a4ca8a93          	addi	s5,s5,-1460 # aa8 <argnum>
  64:	00001b97          	auipc	s7,0x1
  68:	d54b8b93          	addi	s7,s7,-684 # db8 <args>
  6c:	a851                	j	100 <readline+0x100>
            fprintf(2, "read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	9ba58593          	addi	a1,a1,-1606 # a28 <malloc+0xe4>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	7e0080e7          	jalr	2016(ra) # 858 <fprintf>
            exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	47c080e7          	jalr	1148(ra) # 4fe <exit>
                memcpy(args[argnum], arg_buf, strlen(arg_buf) + 1);
  8a:	00001917          	auipc	s2,0x1
  8e:	a1e90913          	addi	s2,s2,-1506 # aa8 <argnum>
  92:	00092483          	lw	s1,0(s2)
  96:	04a6                	slli	s1,s1,0x9
  98:	00001797          	auipc	a5,0x1
  9c:	d2078793          	addi	a5,a5,-736 # db8 <args>
  a0:	94be                	add	s1,s1,a5
  a2:	00001997          	auipc	s3,0x1
  a6:	a1698993          	addi	s3,s3,-1514 # ab8 <arg_buf>
  aa:	854e                	mv	a0,s3
  ac:	00000097          	auipc	ra,0x0
  b0:	224080e7          	jalr	548(ra) # 2d0 <strlen>
  b4:	0015061b          	addiw	a2,a0,1
  b8:	85ce                	mv	a1,s3
  ba:	8526                	mv	a0,s1
  bc:	00000097          	auipc	ra,0x0
  c0:	422080e7          	jalr	1058(ra) # 4de <memcpy>
                argnum++;
  c4:	00092783          	lw	a5,0(s2)
  c8:	2785                	addiw	a5,a5,1
  ca:	00f92023          	sw	a5,0(s2)
                return 1;
  ce:	4505                	li	a0,1
            }
        }
    }
}
  d0:	60a6                	ld	ra,72(sp)
  d2:	6406                	ld	s0,64(sp)
  d4:	74e2                	ld	s1,56(sp)
  d6:	7942                	ld	s2,48(sp)
  d8:	79a2                	ld	s3,40(sp)
  da:	7a02                	ld	s4,32(sp)
  dc:	6ae2                	ld	s5,24(sp)
  de:	6b42                	ld	s6,16(sp)
  e0:	6ba2                	ld	s7,8(sp)
  e2:	6c02                	ld	s8,0(sp)
  e4:	6161                	addi	sp,sp,80
  e6:	8082                	ret
                arg_buf[strlen(arg_buf)] = ch;
  e8:	854a                	mv	a0,s2
  ea:	00000097          	auipc	ra,0x0
  ee:	1e6080e7          	jalr	486(ra) # 2d0 <strlen>
  f2:	1502                	slli	a0,a0,0x20
  f4:	9101                	srli	a0,a0,0x20
  f6:	954a                	add	a0,a0,s2
  f8:	0004c783          	lbu	a5,0(s1)
  fc:	00f50023          	sb	a5,0(a0)
        n = read(0, &ch, sizeof(ch));
 100:	4605                	li	a2,1
 102:	85a6                	mv	a1,s1
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	410080e7          	jalr	1040(ra) # 516 <read>
 10e:	00a9a023          	sw	a0,0(s3)
        if (n == 0)
 112:	dd5d                	beqz	a0,d0 <readline+0xd0>
        else if (n < 0)
 114:	f4054de3          	bltz	a0,6e <readline+0x6e>
            if (ch == '\n')
 118:	0004c783          	lbu	a5,0(s1)
 11c:	f74787e3          	beq	a5,s4,8a <readline+0x8a>
            else if (ch == ' ')
 120:	fd6794e3          	bne	a5,s6,e8 <readline+0xe8>
                memcpy(args[argnum], arg_buf, strlen(arg_buf) + 1);
 124:	000aac03          	lw	s8,0(s5)
 128:	0c26                	slli	s8,s8,0x9
 12a:	9c5e                	add	s8,s8,s7
 12c:	854a                	mv	a0,s2
 12e:	00000097          	auipc	ra,0x0
 132:	1a2080e7          	jalr	418(ra) # 2d0 <strlen>
 136:	0015061b          	addiw	a2,a0,1
 13a:	85ca                	mv	a1,s2
 13c:	8562                	mv	a0,s8
 13e:	00000097          	auipc	ra,0x0
 142:	3a0080e7          	jalr	928(ra) # 4de <memcpy>
                argnum++;
 146:	000aa783          	lw	a5,0(s5)
 14a:	2785                	addiw	a5,a5,1
 14c:	00faa023          	sw	a5,0(s5)
                memset(arg_buf, 0, sizeof(arg_buf));
 150:	20000613          	li	a2,512
 154:	4581                	li	a1,0
 156:	854a                	mv	a0,s2
 158:	00000097          	auipc	ra,0x0
 15c:	1a2080e7          	jalr	418(ra) # 2fa <memset>
 160:	b745                	j	100 <readline+0x100>

0000000000000162 <main>:

int main(int argc, char *argv[])
{
 162:	7139                	addi	sp,sp,-64
 164:	fc06                	sd	ra,56(sp)
 166:	f822                	sd	s0,48(sp)
 168:	f426                	sd	s1,40(sp)
 16a:	f04a                	sd	s2,32(sp)
 16c:	ec4e                	sd	s3,24(sp)
 16e:	e852                	sd	s4,16(sp)
 170:	e456                	sd	s5,8(sp)
 172:	e05a                	sd	s6,0(sp)
 174:	0080                	addi	s0,sp,64
    if (argc < 2)
 176:	4785                	li	a5,1
 178:	06a7da63          	bge	a5,a0,1ec <main+0x8a>
    {
        printf("usage: xargs [command] [arg1] [arg2] ... [argn]\n");
        exit(0);
    }
    preargnum = argc - 1;
 17c:	357d                	addiw	a0,a0,-1
 17e:	00001797          	auipc	a5,0x1
 182:	92a7a723          	sw	a0,-1746(a5) # aac <preargnum>
    for (int i = 0; i < preargnum; i++)
 186:	00858493          	addi	s1,a1,8
 18a:	00001a97          	auipc	s5,0x1
 18e:	c2ea8a93          	addi	s5,s5,-978 # db8 <args>
    preargnum = argc - 1;
 192:	89d6                	mv	s3,s5
    for (int i = 0; i < preargnum; i++)
 194:	4901                	li	s2,0
 196:	00001b17          	auipc	s6,0x1
 19a:	916b0b13          	addi	s6,s6,-1770 # aac <preargnum>
        memcpy(args[i], argv[i + 1], strlen(argv[i + 1]));
 19e:	0004ba03          	ld	s4,0(s1)
 1a2:	8552                	mv	a0,s4
 1a4:	00000097          	auipc	ra,0x0
 1a8:	12c080e7          	jalr	300(ra) # 2d0 <strlen>
 1ac:	0005061b          	sext.w	a2,a0
 1b0:	85d2                	mv	a1,s4
 1b2:	854e                	mv	a0,s3
 1b4:	00000097          	auipc	ra,0x0
 1b8:	32a080e7          	jalr	810(ra) # 4de <memcpy>
    for (int i = 0; i < preargnum; i++)
 1bc:	2905                	addiw	s2,s2,1
 1be:	04a1                	addi	s1,s1,8
 1c0:	20098993          	addi	s3,s3,512
 1c4:	000b2783          	lw	a5,0(s6)
 1c8:	fcf94be3          	blt	s2,a5,19e <main+0x3c>
    while (readline())
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e34080e7          	jalr	-460(ra) # 0 <readline>
 1d4:	c555                	beqz	a0,280 <main+0x11e>
    {
        if (fork() == 0)
 1d6:	00000097          	auipc	ra,0x0
 1da:	320080e7          	jalr	800(ra) # 4f6 <fork>
 1de:	c505                	beqz	a0,206 <main+0xa4>
            printf("exec error\n");
            exit(0);
        }
        else
        {
            wait((int *)0);
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	324080e7          	jalr	804(ra) # 506 <wait>
 1ea:	b7cd                	j	1cc <main+0x6a>
        printf("usage: xargs [command] [arg1] [arg2] ... [argn]\n");
 1ec:	00001517          	auipc	a0,0x1
 1f0:	84c50513          	addi	a0,a0,-1972 # a38 <malloc+0xf4>
 1f4:	00000097          	auipc	ra,0x0
 1f8:	692080e7          	jalr	1682(ra) # 886 <printf>
        exit(0);
 1fc:	4501                	li	a0,0
 1fe:	00000097          	auipc	ra,0x0
 202:	300080e7          	jalr	768(ra) # 4fe <exit>
            *args[argnum] = 0;
 206:	00001697          	auipc	a3,0x1
 20a:	8a26a683          	lw	a3,-1886(a3) # aa8 <argnum>
 20e:	00001717          	auipc	a4,0x1
 212:	baa70713          	addi	a4,a4,-1110 # db8 <args>
 216:	00969793          	slli	a5,a3,0x9
 21a:	97ba                	add	a5,a5,a4
 21c:	00078023          	sb	zero,0(a5)
            while (*args[i])
 220:	00074783          	lbu	a5,0(a4)
 224:	cf89                	beqz	a5,23e <main+0xdc>
 226:	00001717          	auipc	a4,0x1
 22a:	a9270713          	addi	a4,a4,-1390 # cb8 <pass_args>
                pass_args[i] = (char *)&args[i];
 22e:	01573023          	sd	s5,0(a4)
            while (*args[i])
 232:	0721                	addi	a4,a4,8
 234:	200ac783          	lbu	a5,512(s5)
 238:	200a8a93          	addi	s5,s5,512
 23c:	fbed                	bnez	a5,22e <main+0xcc>
            *pass_args[argnum] = 0;
 23e:	00001797          	auipc	a5,0x1
 242:	87a78793          	addi	a5,a5,-1926 # ab8 <arg_buf>
 246:	068e                	slli	a3,a3,0x3
 248:	96be                	add	a3,a3,a5
 24a:	2006b703          	ld	a4,512(a3)
 24e:	00070023          	sb	zero,0(a4)
            exec(pass_args[0], pass_args);
 252:	00001597          	auipc	a1,0x1
 256:	a6658593          	addi	a1,a1,-1434 # cb8 <pass_args>
 25a:	2007b503          	ld	a0,512(a5)
 25e:	00000097          	auipc	ra,0x0
 262:	2d8080e7          	jalr	728(ra) # 536 <exec>
            printf("exec error\n");
 266:	00001517          	auipc	a0,0x1
 26a:	80a50513          	addi	a0,a0,-2038 # a70 <malloc+0x12c>
 26e:	00000097          	auipc	ra,0x0
 272:	618080e7          	jalr	1560(ra) # 886 <printf>
            exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	286080e7          	jalr	646(ra) # 4fe <exit>
        }
    }
    exit(0);
 280:	00000097          	auipc	ra,0x0
 284:	27e080e7          	jalr	638(ra) # 4fe <exit>

0000000000000288 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 28e:	87aa                	mv	a5,a0
 290:	0585                	addi	a1,a1,1
 292:	0785                	addi	a5,a5,1
 294:	fff5c703          	lbu	a4,-1(a1)
 298:	fee78fa3          	sb	a4,-1(a5)
 29c:	fb75                	bnez	a4,290 <strcpy+0x8>
    ;
  return os;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	cb91                	beqz	a5,2c2 <strcmp+0x1e>
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00f71763          	bne	a4,a5,2c2 <strcmp+0x1e>
    p++, q++;
 2b8:	0505                	addi	a0,a0,1
 2ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	fbe5                	bnez	a5,2b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2c2:	0005c503          	lbu	a0,0(a1)
}
 2c6:	40a7853b          	subw	a0,a5,a0
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cf91                	beqz	a5,2f6 <strlen+0x26>
 2dc:	0505                	addi	a0,a0,1
 2de:	87aa                	mv	a5,a0
 2e0:	4685                	li	a3,1
 2e2:	9e89                	subw	a3,a3,a0
 2e4:	00f6853b          	addw	a0,a3,a5
 2e8:	0785                	addi	a5,a5,1
 2ea:	fff7c703          	lbu	a4,-1(a5)
 2ee:	fb7d                	bnez	a4,2e4 <strlen+0x14>
    ;
  return n;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  for(n = 0; s[n]; n++)
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <strlen+0x20>

00000000000002fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 300:	ce09                	beqz	a2,31a <memset+0x20>
 302:	87aa                	mv	a5,a0
 304:	fff6071b          	addiw	a4,a2,-1
 308:	1702                	slli	a4,a4,0x20
 30a:	9301                	srli	a4,a4,0x20
 30c:	0705                	addi	a4,a4,1
 30e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 310:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 314:	0785                	addi	a5,a5,1
 316:	fee79de3          	bne	a5,a4,310 <memset+0x16>
  }
  return dst;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <strchr>:

char*
strchr(const char *s, char c)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  for(; *s; s++)
 326:	00054783          	lbu	a5,0(a0)
 32a:	cb99                	beqz	a5,340 <strchr+0x20>
    if(*s == c)
 32c:	00f58763          	beq	a1,a5,33a <strchr+0x1a>
  for(; *s; s++)
 330:	0505                	addi	a0,a0,1
 332:	00054783          	lbu	a5,0(a0)
 336:	fbfd                	bnez	a5,32c <strchr+0xc>
      return (char*)s;
  return 0;
 338:	4501                	li	a0,0
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  return 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <strchr+0x1a>

0000000000000344 <gets>:

char*
gets(char *buf, int max)
{
 344:	711d                	addi	sp,sp,-96
 346:	ec86                	sd	ra,88(sp)
 348:	e8a2                	sd	s0,80(sp)
 34a:	e4a6                	sd	s1,72(sp)
 34c:	e0ca                	sd	s2,64(sp)
 34e:	fc4e                	sd	s3,56(sp)
 350:	f852                	sd	s4,48(sp)
 352:	f456                	sd	s5,40(sp)
 354:	f05a                	sd	s6,32(sp)
 356:	ec5e                	sd	s7,24(sp)
 358:	1080                	addi	s0,sp,96
 35a:	8baa                	mv	s7,a0
 35c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35e:	892a                	mv	s2,a0
 360:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 362:	4aa9                	li	s5,10
 364:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 366:	89a6                	mv	s3,s1
 368:	2485                	addiw	s1,s1,1
 36a:	0344d863          	bge	s1,s4,39a <gets+0x56>
    cc = read(0, &c, 1);
 36e:	4605                	li	a2,1
 370:	faf40593          	addi	a1,s0,-81
 374:	4501                	li	a0,0
 376:	00000097          	auipc	ra,0x0
 37a:	1a0080e7          	jalr	416(ra) # 516 <read>
    if(cc < 1)
 37e:	00a05e63          	blez	a0,39a <gets+0x56>
    buf[i++] = c;
 382:	faf44783          	lbu	a5,-81(s0)
 386:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 38a:	01578763          	beq	a5,s5,398 <gets+0x54>
 38e:	0905                	addi	s2,s2,1
 390:	fd679be3          	bne	a5,s6,366 <gets+0x22>
  for(i=0; i+1 < max; ){
 394:	89a6                	mv	s3,s1
 396:	a011                	j	39a <gets+0x56>
 398:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 39a:	99de                	add	s3,s3,s7
 39c:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a0:	855e                	mv	a0,s7
 3a2:	60e6                	ld	ra,88(sp)
 3a4:	6446                	ld	s0,80(sp)
 3a6:	64a6                	ld	s1,72(sp)
 3a8:	6906                	ld	s2,64(sp)
 3aa:	79e2                	ld	s3,56(sp)
 3ac:	7a42                	ld	s4,48(sp)
 3ae:	7aa2                	ld	s5,40(sp)
 3b0:	7b02                	ld	s6,32(sp)
 3b2:	6be2                	ld	s7,24(sp)
 3b4:	6125                	addi	sp,sp,96
 3b6:	8082                	ret

00000000000003b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e426                	sd	s1,8(sp)
 3c0:	e04a                	sd	s2,0(sp)
 3c2:	1000                	addi	s0,sp,32
 3c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c6:	4581                	li	a1,0
 3c8:	00000097          	auipc	ra,0x0
 3cc:	176080e7          	jalr	374(ra) # 53e <open>
  if(fd < 0)
 3d0:	02054563          	bltz	a0,3fa <stat+0x42>
 3d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d6:	85ca                	mv	a1,s2
 3d8:	00000097          	auipc	ra,0x0
 3dc:	17e080e7          	jalr	382(ra) # 556 <fstat>
 3e0:	892a                	mv	s2,a0
  close(fd);
 3e2:	8526                	mv	a0,s1
 3e4:	00000097          	auipc	ra,0x0
 3e8:	142080e7          	jalr	322(ra) # 526 <close>
  return r;
}
 3ec:	854a                	mv	a0,s2
 3ee:	60e2                	ld	ra,24(sp)
 3f0:	6442                	ld	s0,16(sp)
 3f2:	64a2                	ld	s1,8(sp)
 3f4:	6902                	ld	s2,0(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret
    return -1;
 3fa:	597d                	li	s2,-1
 3fc:	bfc5                	j	3ec <stat+0x34>

00000000000003fe <atoi>:

int
atoi(const char *s)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 404:	00054603          	lbu	a2,0(a0)
 408:	fd06079b          	addiw	a5,a2,-48
 40c:	0ff7f793          	andi	a5,a5,255
 410:	4725                	li	a4,9
 412:	02f76963          	bltu	a4,a5,444 <atoi+0x46>
 416:	86aa                	mv	a3,a0
  n = 0;
 418:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 41a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 41c:	0685                	addi	a3,a3,1
 41e:	0025179b          	slliw	a5,a0,0x2
 422:	9fa9                	addw	a5,a5,a0
 424:	0017979b          	slliw	a5,a5,0x1
 428:	9fb1                	addw	a5,a5,a2
 42a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 42e:	0006c603          	lbu	a2,0(a3)
 432:	fd06071b          	addiw	a4,a2,-48
 436:	0ff77713          	andi	a4,a4,255
 43a:	fee5f1e3          	bgeu	a1,a4,41c <atoi+0x1e>
  return n;
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret
  n = 0;
 444:	4501                	li	a0,0
 446:	bfe5                	j	43e <atoi+0x40>

0000000000000448 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 448:	1141                	addi	sp,sp,-16
 44a:	e422                	sd	s0,8(sp)
 44c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 44e:	02b57663          	bgeu	a0,a1,47a <memmove+0x32>
    while(n-- > 0)
 452:	02c05163          	blez	a2,474 <memmove+0x2c>
 456:	fff6079b          	addiw	a5,a2,-1
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	0785                	addi	a5,a5,1
 460:	97aa                	add	a5,a5,a0
  dst = vdst;
 462:	872a                	mv	a4,a0
      *dst++ = *src++;
 464:	0585                	addi	a1,a1,1
 466:	0705                	addi	a4,a4,1
 468:	fff5c683          	lbu	a3,-1(a1)
 46c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 470:	fee79ae3          	bne	a5,a4,464 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
    dst += n;
 47a:	00c50733          	add	a4,a0,a2
    src += n;
 47e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 480:	fec05ae3          	blez	a2,474 <memmove+0x2c>
 484:	fff6079b          	addiw	a5,a2,-1
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	fff7c793          	not	a5,a5
 490:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 492:	15fd                	addi	a1,a1,-1
 494:	177d                	addi	a4,a4,-1
 496:	0005c683          	lbu	a3,0(a1)
 49a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 49e:	fee79ae3          	bne	a5,a4,492 <memmove+0x4a>
 4a2:	bfc9                	j	474 <memmove+0x2c>

00000000000004a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4aa:	ca05                	beqz	a2,4da <memcmp+0x36>
 4ac:	fff6069b          	addiw	a3,a2,-1
 4b0:	1682                	slli	a3,a3,0x20
 4b2:	9281                	srli	a3,a3,0x20
 4b4:	0685                	addi	a3,a3,1
 4b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	0005c703          	lbu	a4,0(a1)
 4c0:	00e79863          	bne	a5,a4,4d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4c4:	0505                	addi	a0,a0,1
    p2++;
 4c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4c8:	fed518e3          	bne	a0,a3,4b8 <memcmp+0x14>
  }
  return 0;
 4cc:	4501                	li	a0,0
 4ce:	a019                	j	4d4 <memcmp+0x30>
      return *p1 - *p2;
 4d0:	40e7853b          	subw	a0,a5,a4
}
 4d4:	6422                	ld	s0,8(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
  return 0;
 4da:	4501                	li	a0,0
 4dc:	bfe5                	j	4d4 <memcmp+0x30>

00000000000004de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e6:	00000097          	auipc	ra,0x0
 4ea:	f62080e7          	jalr	-158(ra) # 448 <memmove>
}
 4ee:	60a2                	ld	ra,8(sp)
 4f0:	6402                	ld	s0,0(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret

00000000000004f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f6:	4885                	li	a7,1
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fe:	4889                	li	a7,2
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <wait>:
.global wait
wait:
 li a7, SYS_wait
 506:	488d                	li	a7,3
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50e:	4891                	li	a7,4
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <read>:
.global read
read:
 li a7, SYS_read
 516:	4895                	li	a7,5
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <write>:
.global write
write:
 li a7, SYS_write
 51e:	48c1                	li	a7,16
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <close>:
.global close
close:
 li a7, SYS_close
 526:	48d5                	li	a7,21
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <kill>:
.global kill
kill:
 li a7, SYS_kill
 52e:	4899                	li	a7,6
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <exec>:
.global exec
exec:
 li a7, SYS_exec
 536:	489d                	li	a7,7
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <open>:
.global open
open:
 li a7, SYS_open
 53e:	48bd                	li	a7,15
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 546:	48c5                	li	a7,17
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54e:	48c9                	li	a7,18
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 556:	48a1                	li	a7,8
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <link>:
.global link
link:
 li a7, SYS_link
 55e:	48cd                	li	a7,19
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 566:	48d1                	li	a7,20
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56e:	48a5                	li	a7,9
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <dup>:
.global dup
dup:
 li a7, SYS_dup
 576:	48a9                	li	a7,10
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57e:	48ad                	li	a7,11
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 586:	48b1                	li	a7,12
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 58e:	48b5                	li	a7,13
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 596:	48b9                	li	a7,14
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <trace>:
.global trace
trace:
 li a7, SYS_trace
 59e:	48d9                	li	a7,22
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5a6:	48dd                	li	a7,23
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	addi	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	addi	a1,s0,-17
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f5e080e7          	jalr	-162(ra) # 51e <write>
}
 5c8:	60e2                	ld	ra,24(sp)
 5ca:	6442                	ld	s0,16(sp)
 5cc:	6105                	addi	sp,sp,32
 5ce:	8082                	ret

00000000000005d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	7139                	addi	sp,sp,-64
 5d2:	fc06                	sd	ra,56(sp)
 5d4:	f822                	sd	s0,48(sp)
 5d6:	f426                	sd	s1,40(sp)
 5d8:	f04a                	sd	s2,32(sp)
 5da:	ec4e                	sd	s3,24(sp)
 5dc:	0080                	addi	s0,sp,64
 5de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e0:	c299                	beqz	a3,5e6 <printint+0x16>
 5e2:	0805c863          	bltz	a1,672 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e6:	2581                	sext.w	a1,a1
  neg = 0;
 5e8:	4881                	li	a7,0
 5ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f0:	2601                	sext.w	a2,a2
 5f2:	00000517          	auipc	a0,0x0
 5f6:	49650513          	addi	a0,a0,1174 # a88 <digits>
 5fa:	883a                	mv	a6,a4
 5fc:	2705                	addiw	a4,a4,1
 5fe:	02c5f7bb          	remuw	a5,a1,a2
 602:	1782                	slli	a5,a5,0x20
 604:	9381                	srli	a5,a5,0x20
 606:	97aa                	add	a5,a5,a0
 608:	0007c783          	lbu	a5,0(a5)
 60c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 610:	0005879b          	sext.w	a5,a1
 614:	02c5d5bb          	divuw	a1,a1,a2
 618:	0685                	addi	a3,a3,1
 61a:	fec7f0e3          	bgeu	a5,a2,5fa <printint+0x2a>
  if(neg)
 61e:	00088b63          	beqz	a7,634 <printint+0x64>
    buf[i++] = '-';
 622:	fd040793          	addi	a5,s0,-48
 626:	973e                	add	a4,a4,a5
 628:	02d00793          	li	a5,45
 62c:	fef70823          	sb	a5,-16(a4)
 630:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 634:	02e05863          	blez	a4,664 <printint+0x94>
 638:	fc040793          	addi	a5,s0,-64
 63c:	00e78933          	add	s2,a5,a4
 640:	fff78993          	addi	s3,a5,-1
 644:	99ba                	add	s3,s3,a4
 646:	377d                	addiw	a4,a4,-1
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 650:	fff94583          	lbu	a1,-1(s2)
 654:	8526                	mv	a0,s1
 656:	00000097          	auipc	ra,0x0
 65a:	f58080e7          	jalr	-168(ra) # 5ae <putc>
  while(--i >= 0)
 65e:	197d                	addi	s2,s2,-1
 660:	ff3918e3          	bne	s2,s3,650 <printint+0x80>
}
 664:	70e2                	ld	ra,56(sp)
 666:	7442                	ld	s0,48(sp)
 668:	74a2                	ld	s1,40(sp)
 66a:	7902                	ld	s2,32(sp)
 66c:	69e2                	ld	s3,24(sp)
 66e:	6121                	addi	sp,sp,64
 670:	8082                	ret
    x = -xx;
 672:	40b005bb          	negw	a1,a1
    neg = 1;
 676:	4885                	li	a7,1
    x = -xx;
 678:	bf8d                	j	5ea <printint+0x1a>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	7119                	addi	sp,sp,-128
 67c:	fc86                	sd	ra,120(sp)
 67e:	f8a2                	sd	s0,112(sp)
 680:	f4a6                	sd	s1,104(sp)
 682:	f0ca                	sd	s2,96(sp)
 684:	ecce                	sd	s3,88(sp)
 686:	e8d2                	sd	s4,80(sp)
 688:	e4d6                	sd	s5,72(sp)
 68a:	e0da                	sd	s6,64(sp)
 68c:	fc5e                	sd	s7,56(sp)
 68e:	f862                	sd	s8,48(sp)
 690:	f466                	sd	s9,40(sp)
 692:	f06a                	sd	s10,32(sp)
 694:	ec6e                	sd	s11,24(sp)
 696:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 698:	0005c903          	lbu	s2,0(a1)
 69c:	18090f63          	beqz	s2,83a <vprintf+0x1c0>
 6a0:	8aaa                	mv	s5,a0
 6a2:	8b32                	mv	s6,a2
 6a4:	00158493          	addi	s1,a1,1
  state = 0;
 6a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6aa:	02500a13          	li	s4,37
      if(c == 'd'){
 6ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6b2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6b6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6ba:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	3cab8b93          	addi	s7,s7,970 # a88 <digits>
 6c6:	a839                	j	6e4 <vprintf+0x6a>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	ee2080e7          	jalr	-286(ra) # 5ae <putc>
 6d4:	a019                	j	6da <vprintf+0x60>
    } else if(state == '%'){
 6d6:	01498f63          	beq	s3,s4,6f4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6da:	0485                	addi	s1,s1,1
 6dc:	fff4c903          	lbu	s2,-1(s1)
 6e0:	14090d63          	beqz	s2,83a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6e4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6e8:	fe0997e3          	bnez	s3,6d6 <vprintf+0x5c>
      if(c == '%'){
 6ec:	fd479ee3          	bne	a5,s4,6c8 <vprintf+0x4e>
        state = '%';
 6f0:	89be                	mv	s3,a5
 6f2:	b7e5                	j	6da <vprintf+0x60>
      if(c == 'd'){
 6f4:	05878063          	beq	a5,s8,734 <vprintf+0xba>
      } else if(c == 'l') {
 6f8:	05978c63          	beq	a5,s9,750 <vprintf+0xd6>
      } else if(c == 'x') {
 6fc:	07a78863          	beq	a5,s10,76c <vprintf+0xf2>
      } else if(c == 'p') {
 700:	09b78463          	beq	a5,s11,788 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 704:	07300713          	li	a4,115
 708:	0ce78663          	beq	a5,a4,7d4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70c:	06300713          	li	a4,99
 710:	0ee78e63          	beq	a5,a4,80c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 714:	11478863          	beq	a5,s4,824 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 718:	85d2                	mv	a1,s4
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e92080e7          	jalr	-366(ra) # 5ae <putc>
        putc(fd, c);
 724:	85ca                	mv	a1,s2
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e86080e7          	jalr	-378(ra) # 5ae <putc>
      }
      state = 0;
 730:	4981                	li	s3,0
 732:	b765                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 734:	008b0913          	addi	s2,s6,8
 738:	4685                	li	a3,1
 73a:	4629                	li	a2,10
 73c:	000b2583          	lw	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e8e080e7          	jalr	-370(ra) # 5d0 <printint>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b771                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b0913          	addi	s2,s6,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000b2583          	lw	a1,0(s6)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e72080e7          	jalr	-398(ra) # 5d0 <printint>
 766:	8b4a                	mv	s6,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bf85                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 76c:	008b0913          	addi	s2,s6,8
 770:	4681                	li	a3,0
 772:	4641                	li	a2,16
 774:	000b2583          	lw	a1,0(s6)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	e56080e7          	jalr	-426(ra) # 5d0 <printint>
 782:	8b4a                	mv	s6,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bf91                	j	6da <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 788:	008b0793          	addi	a5,s6,8
 78c:	f8f43423          	sd	a5,-120(s0)
 790:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 794:	03000593          	li	a1,48
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e14080e7          	jalr	-492(ra) # 5ae <putc>
  putc(fd, 'x');
 7a2:	85ea                	mv	a1,s10
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e08080e7          	jalr	-504(ra) # 5ae <putc>
 7ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b0:	03c9d793          	srli	a5,s3,0x3c
 7b4:	97de                	add	a5,a5,s7
 7b6:	0007c583          	lbu	a1,0(a5)
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	df2080e7          	jalr	-526(ra) # 5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c4:	0992                	slli	s3,s3,0x4
 7c6:	397d                	addiw	s2,s2,-1
 7c8:	fe0914e3          	bnez	s2,7b0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7cc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b721                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 7d4:	008b0993          	addi	s3,s6,8
 7d8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7dc:	02090163          	beqz	s2,7fe <vprintf+0x184>
        while(*s != 0){
 7e0:	00094583          	lbu	a1,0(s2)
 7e4:	c9a1                	beqz	a1,834 <vprintf+0x1ba>
          putc(fd, *s);
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	dc6080e7          	jalr	-570(ra) # 5ae <putc>
          s++;
 7f0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	f9e5                	bnez	a1,7e6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7f8:	8b4e                	mv	s6,s3
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	bdf9                	j	6da <vprintf+0x60>
          s = "(null)";
 7fe:	00000917          	auipc	s2,0x0
 802:	28290913          	addi	s2,s2,642 # a80 <malloc+0x13c>
        while(*s != 0){
 806:	02800593          	li	a1,40
 80a:	bff1                	j	7e6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 80c:	008b0913          	addi	s2,s6,8
 810:	000b4583          	lbu	a1,0(s6)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	d98080e7          	jalr	-616(ra) # 5ae <putc>
 81e:	8b4a                	mv	s6,s2
      state = 0;
 820:	4981                	li	s3,0
 822:	bd65                	j	6da <vprintf+0x60>
        putc(fd, c);
 824:	85d2                	mv	a1,s4
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	d86080e7          	jalr	-634(ra) # 5ae <putc>
      state = 0;
 830:	4981                	li	s3,0
 832:	b565                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 834:	8b4e                	mv	s6,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b54d                	j	6da <vprintf+0x60>
    }
  }
}
 83a:	70e6                	ld	ra,120(sp)
 83c:	7446                	ld	s0,112(sp)
 83e:	74a6                	ld	s1,104(sp)
 840:	7906                	ld	s2,96(sp)
 842:	69e6                	ld	s3,88(sp)
 844:	6a46                	ld	s4,80(sp)
 846:	6aa6                	ld	s5,72(sp)
 848:	6b06                	ld	s6,64(sp)
 84a:	7be2                	ld	s7,56(sp)
 84c:	7c42                	ld	s8,48(sp)
 84e:	7ca2                	ld	s9,40(sp)
 850:	7d02                	ld	s10,32(sp)
 852:	6de2                	ld	s11,24(sp)
 854:	6109                	addi	sp,sp,128
 856:	8082                	ret

0000000000000858 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e010                	sd	a2,0(s0)
 862:	e414                	sd	a3,8(s0)
 864:	e818                	sd	a4,16(s0)
 866:	ec1c                	sd	a5,24(s0)
 868:	03043023          	sd	a6,32(s0)
 86c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 874:	8622                	mv	a2,s0
 876:	00000097          	auipc	ra,0x0
 87a:	e04080e7          	jalr	-508(ra) # 67a <vprintf>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6161                	addi	sp,sp,80
 884:	8082                	ret

0000000000000886 <printf>:

void
printf(const char *fmt, ...)
{
 886:	711d                	addi	sp,sp,-96
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	addi	s0,sp,32
 88e:	e40c                	sd	a1,8(s0)
 890:	e810                	sd	a2,16(s0)
 892:	ec14                	sd	a3,24(s0)
 894:	f018                	sd	a4,32(s0)
 896:	f41c                	sd	a5,40(s0)
 898:	03043823          	sd	a6,48(s0)
 89c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	00840613          	addi	a2,s0,8
 8a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a8:	85aa                	mv	a1,a0
 8aa:	4505                	li	a0,1
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dce080e7          	jalr	-562(ra) # 67a <vprintf>
}
 8b4:	60e2                	ld	ra,24(sp)
 8b6:	6442                	ld	s0,16(sp)
 8b8:	6125                	addi	sp,sp,96
 8ba:	8082                	ret

00000000000008bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bc:	1141                	addi	sp,sp,-16
 8be:	e422                	sd	s0,8(sp)
 8c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	00000797          	auipc	a5,0x0
 8ca:	1ea7b783          	ld	a5,490(a5) # ab0 <freep>
 8ce:	a805                	j	8fe <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d0:	4618                	lw	a4,8(a2)
 8d2:	9db9                	addw	a1,a1,a4
 8d4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	6398                	ld	a4,0(a5)
 8da:	6318                	ld	a4,0(a4)
 8dc:	fee53823          	sd	a4,-16(a0)
 8e0:	a091                	j	924 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e2:	ff852703          	lw	a4,-8(a0)
 8e6:	9e39                	addw	a2,a2,a4
 8e8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8ea:	ff053703          	ld	a4,-16(a0)
 8ee:	e398                	sd	a4,0(a5)
 8f0:	a099                	j	936 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	6398                	ld	a4,0(a5)
 8f4:	00e7e463          	bltu	a5,a4,8fc <free+0x40>
 8f8:	00e6ea63          	bltu	a3,a4,90c <free+0x50>
{
 8fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	fed7fae3          	bgeu	a5,a3,8f2 <free+0x36>
 902:	6398                	ld	a4,0(a5)
 904:	00e6e463          	bltu	a3,a4,90c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 908:	fee7eae3          	bltu	a5,a4,8fc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 90c:	ff852583          	lw	a1,-8(a0)
 910:	6390                	ld	a2,0(a5)
 912:	02059713          	slli	a4,a1,0x20
 916:	9301                	srli	a4,a4,0x20
 918:	0712                	slli	a4,a4,0x4
 91a:	9736                	add	a4,a4,a3
 91c:	fae60ae3          	beq	a2,a4,8d0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 920:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 924:	4790                	lw	a2,8(a5)
 926:	02061713          	slli	a4,a2,0x20
 92a:	9301                	srli	a4,a4,0x20
 92c:	0712                	slli	a4,a4,0x4
 92e:	973e                	add	a4,a4,a5
 930:	fae689e3          	beq	a3,a4,8e2 <free+0x26>
  } else
    p->s.ptr = bp;
 934:	e394                	sd	a3,0(a5)
  freep = p;
 936:	00000717          	auipc	a4,0x0
 93a:	16f73d23          	sd	a5,378(a4) # ab0 <freep>
}
 93e:	6422                	ld	s0,8(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret

0000000000000944 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 944:	7139                	addi	sp,sp,-64
 946:	fc06                	sd	ra,56(sp)
 948:	f822                	sd	s0,48(sp)
 94a:	f426                	sd	s1,40(sp)
 94c:	f04a                	sd	s2,32(sp)
 94e:	ec4e                	sd	s3,24(sp)
 950:	e852                	sd	s4,16(sp)
 952:	e456                	sd	s5,8(sp)
 954:	e05a                	sd	s6,0(sp)
 956:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 958:	02051493          	slli	s1,a0,0x20
 95c:	9081                	srli	s1,s1,0x20
 95e:	04bd                	addi	s1,s1,15
 960:	8091                	srli	s1,s1,0x4
 962:	0014899b          	addiw	s3,s1,1
 966:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 968:	00000517          	auipc	a0,0x0
 96c:	14853503          	ld	a0,328(a0) # ab0 <freep>
 970:	c515                	beqz	a0,99c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 974:	4798                	lw	a4,8(a5)
 976:	02977f63          	bgeu	a4,s1,9b4 <malloc+0x70>
 97a:	8a4e                	mv	s4,s3
 97c:	0009871b          	sext.w	a4,s3
 980:	6685                	lui	a3,0x1
 982:	00d77363          	bgeu	a4,a3,988 <malloc+0x44>
 986:	6a05                	lui	s4,0x1
 988:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 990:	00000917          	auipc	s2,0x0
 994:	12090913          	addi	s2,s2,288 # ab0 <freep>
  if(p == (char*)-1)
 998:	5afd                	li	s5,-1
 99a:	a88d                	j	a0c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 99c:	00004797          	auipc	a5,0x4
 9a0:	41c78793          	addi	a5,a5,1052 # 4db8 <base>
 9a4:	00000717          	auipc	a4,0x0
 9a8:	10f73623          	sd	a5,268(a4) # ab0 <freep>
 9ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b2:	b7e1                	j	97a <malloc+0x36>
      if(p->s.size == nunits)
 9b4:	02e48b63          	beq	s1,a4,9ea <malloc+0xa6>
        p->s.size -= nunits;
 9b8:	4137073b          	subw	a4,a4,s3
 9bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9be:	1702                	slli	a4,a4,0x20
 9c0:	9301                	srli	a4,a4,0x20
 9c2:	0712                	slli	a4,a4,0x4
 9c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ca:	00000717          	auipc	a4,0x0
 9ce:	0ea73323          	sd	a0,230(a4) # ab0 <freep>
      return (void*)(p + 1);
 9d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9d6:	70e2                	ld	ra,56(sp)
 9d8:	7442                	ld	s0,48(sp)
 9da:	74a2                	ld	s1,40(sp)
 9dc:	7902                	ld	s2,32(sp)
 9de:	69e2                	ld	s3,24(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	6121                	addi	sp,sp,64
 9e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ea:	6398                	ld	a4,0(a5)
 9ec:	e118                	sd	a4,0(a0)
 9ee:	bff1                	j	9ca <malloc+0x86>
  hp->s.size = nu;
 9f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f4:	0541                	addi	a0,a0,16
 9f6:	00000097          	auipc	ra,0x0
 9fa:	ec6080e7          	jalr	-314(ra) # 8bc <free>
  return freep;
 9fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a02:	d971                	beqz	a0,9d6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a06:	4798                	lw	a4,8(a5)
 a08:	fa9776e3          	bgeu	a4,s1,9b4 <malloc+0x70>
    if(p == freep)
 a0c:	00093703          	ld	a4,0(s2)
 a10:	853e                	mv	a0,a5
 a12:	fef719e3          	bne	a4,a5,a04 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a16:	8552                	mv	a0,s4
 a18:	00000097          	auipc	ra,0x0
 a1c:	b6e080e7          	jalr	-1170(ra) # 586 <sbrk>
  if(p == (char*)-1)
 a20:	fd5518e3          	bne	a0,s5,9f0 <malloc+0xac>
        return 0;
 a24:	4501                	li	a0,0
 a26:	bf45                	j	9d6 <malloc+0x92>
