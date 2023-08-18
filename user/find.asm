
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char *
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    char *p;
    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	2b4080e7          	jalr	692(ra) # 2c0 <strlen>
  14:	1502                	slli	a0,a0,0x20
  16:	9101                	srli	a0,a0,0x20
  18:	9526                	add	a0,a0,s1
  1a:	02f00713          	li	a4,47
  1e:	00956963          	bltu	a0,s1,30 <fmtname+0x30>
  22:	00054783          	lbu	a5,0(a0)
  26:	00e78563          	beq	a5,a4,30 <fmtname+0x30>
  2a:	157d                	addi	a0,a0,-1
  2c:	fe957be3          	bgeu	a0,s1,22 <fmtname+0x22>
        ;
    p++;
    return p;
}
  30:	0505                	addi	a0,a0,1
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	64a2                	ld	s1,8(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret

000000000000003c <find>:

void find(char *path, char *filename)
{
  3c:	d8010113          	addi	sp,sp,-640
  40:	26113c23          	sd	ra,632(sp)
  44:	26813823          	sd	s0,624(sp)
  48:	26913423          	sd	s1,616(sp)
  4c:	27213023          	sd	s2,608(sp)
  50:	25313c23          	sd	s3,600(sp)
  54:	25413823          	sd	s4,592(sp)
  58:	25513423          	sd	s5,584(sp)
  5c:	25613023          	sd	s6,576(sp)
  60:	23713c23          	sd	s7,568(sp)
  64:	0500                	addi	s0,sp,640
  66:	892a                	mv	s2,a0
  68:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
    if ((fd = open(path, 0)) < 0)
  6a:	4581                	li	a1,0
  6c:	00000097          	auipc	ra,0x0
  70:	4c2080e7          	jalr	1218(ra) # 52e <open>
  74:	06054a63          	bltz	a0,e8 <find+0xac>
  78:	84aa                	mv	s1,a0
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
  7a:	d8840593          	addi	a1,s0,-632
  7e:	00000097          	auipc	ra,0x0
  82:	4c8080e7          	jalr	1224(ra) # 546 <fstat>
  86:	06054c63          	bltz	a0,fe <find+0xc2>
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
  8a:	d9041783          	lh	a5,-624(s0)
  8e:	0007869b          	sext.w	a3,a5
  92:	4705                	li	a4,1
  94:	08e68f63          	beq	a3,a4,132 <find+0xf6>
  98:	4709                	li	a4,2
  9a:	00e69d63          	bne	a3,a4,b4 <find+0x78>
    {
    case T_FILE:
        if (strcmp(fmtname(path), filename) == 0)
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	f60080e7          	jalr	-160(ra) # 0 <fmtname>
  a8:	85ce                	mv	a1,s3
  aa:	00000097          	auipc	ra,0x0
  ae:	1ea080e7          	jalr	490(ra) # 294 <strcmp>
  b2:	c535                	beqz	a0,11e <find+0xe2>
                find(buf, filename);
            }
        }
        break;
    }
    close(fd);
  b4:	8526                	mv	a0,s1
  b6:	00000097          	auipc	ra,0x0
  ba:	460080e7          	jalr	1120(ra) # 516 <close>
}
  be:	27813083          	ld	ra,632(sp)
  c2:	27013403          	ld	s0,624(sp)
  c6:	26813483          	ld	s1,616(sp)
  ca:	26013903          	ld	s2,608(sp)
  ce:	25813983          	ld	s3,600(sp)
  d2:	25013a03          	ld	s4,592(sp)
  d6:	24813a83          	ld	s5,584(sp)
  da:	24013b03          	ld	s6,576(sp)
  de:	23813b83          	ld	s7,568(sp)
  e2:	28010113          	addi	sp,sp,640
  e6:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
  e8:	864a                	mv	a2,s2
  ea:	00001597          	auipc	a1,0x1
  ee:	92e58593          	addi	a1,a1,-1746 # a18 <malloc+0xe4>
  f2:	4509                	li	a0,2
  f4:	00000097          	auipc	ra,0x0
  f8:	754080e7          	jalr	1876(ra) # 848 <fprintf>
        return;
  fc:	b7c9                	j	be <find+0x82>
        fprintf(2, "find: cannot stat %s\n", path);
  fe:	864a                	mv	a2,s2
 100:	00001597          	auipc	a1,0x1
 104:	93058593          	addi	a1,a1,-1744 # a30 <malloc+0xfc>
 108:	4509                	li	a0,2
 10a:	00000097          	auipc	ra,0x0
 10e:	73e080e7          	jalr	1854(ra) # 848 <fprintf>
        close(fd);
 112:	8526                	mv	a0,s1
 114:	00000097          	auipc	ra,0x0
 118:	402080e7          	jalr	1026(ra) # 516 <close>
        return;
 11c:	b74d                	j	be <find+0x82>
            printf("%s\n", path);
 11e:	85ca                	mv	a1,s2
 120:	00001517          	auipc	a0,0x1
 124:	92850513          	addi	a0,a0,-1752 # a48 <malloc+0x114>
 128:	00000097          	auipc	ra,0x0
 12c:	74e080e7          	jalr	1870(ra) # 876 <printf>
 130:	b751                	j	b4 <find+0x78>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 132:	854a                	mv	a0,s2
 134:	00000097          	auipc	ra,0x0
 138:	18c080e7          	jalr	396(ra) # 2c0 <strlen>
 13c:	2541                	addiw	a0,a0,16
 13e:	20000793          	li	a5,512
 142:	00a7fb63          	bgeu	a5,a0,158 <find+0x11c>
            printf("find: path too long\n");
 146:	00001517          	auipc	a0,0x1
 14a:	90a50513          	addi	a0,a0,-1782 # a50 <malloc+0x11c>
 14e:	00000097          	auipc	ra,0x0
 152:	728080e7          	jalr	1832(ra) # 876 <printf>
            break;
 156:	bfb9                	j	b4 <find+0x78>
        strcpy(buf, path);
 158:	85ca                	mv	a1,s2
 15a:	db040513          	addi	a0,s0,-592
 15e:	00000097          	auipc	ra,0x0
 162:	11a080e7          	jalr	282(ra) # 278 <strcpy>
        p = buf + strlen(buf);
 166:	db040513          	addi	a0,s0,-592
 16a:	00000097          	auipc	ra,0x0
 16e:	156080e7          	jalr	342(ra) # 2c0 <strlen>
 172:	02051913          	slli	s2,a0,0x20
 176:	02095913          	srli	s2,s2,0x20
 17a:	db040793          	addi	a5,s0,-592
 17e:	993e                	add	s2,s2,a5
        *p++ = '/';
 180:	00190a13          	addi	s4,s2,1
 184:	02f00793          	li	a5,47
 188:	00f90023          	sb	a5,0(s2)
            if (strcmp(fmtname(buf), ".") != 0 && strcmp(fmtname(buf), "..") != 0)
 18c:	00001a97          	auipc	s5,0x1
 190:	8dca8a93          	addi	s5,s5,-1828 # a68 <malloc+0x134>
 194:	00001b97          	auipc	s7,0x1
 198:	8dcb8b93          	addi	s7,s7,-1828 # a70 <malloc+0x13c>
                printf("find: cannot stat %s\n", buf);
 19c:	00001b17          	auipc	s6,0x1
 1a0:	894b0b13          	addi	s6,s6,-1900 # a30 <malloc+0xfc>
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 1a4:	4641                	li	a2,16
 1a6:	da040593          	addi	a1,s0,-608
 1aa:	8526                	mv	a0,s1
 1ac:	00000097          	auipc	ra,0x0
 1b0:	35a080e7          	jalr	858(ra) # 506 <read>
 1b4:	47c1                	li	a5,16
 1b6:	eef51fe3          	bne	a0,a5,b4 <find+0x78>
            if (de.inum == 0)
 1ba:	da045783          	lhu	a5,-608(s0)
 1be:	d3fd                	beqz	a5,1a4 <find+0x168>
            memmove(p, de.name, DIRSIZ);
 1c0:	4639                	li	a2,14
 1c2:	da240593          	addi	a1,s0,-606
 1c6:	8552                	mv	a0,s4
 1c8:	00000097          	auipc	ra,0x0
 1cc:	270080e7          	jalr	624(ra) # 438 <memmove>
            p[DIRSIZ] = 0;
 1d0:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0)
 1d4:	d8840593          	addi	a1,s0,-632
 1d8:	db040513          	addi	a0,s0,-592
 1dc:	00000097          	auipc	ra,0x0
 1e0:	1cc080e7          	jalr	460(ra) # 3a8 <stat>
 1e4:	04054263          	bltz	a0,228 <find+0x1ec>
            if (strcmp(fmtname(buf), ".") != 0 && strcmp(fmtname(buf), "..") != 0)
 1e8:	db040513          	addi	a0,s0,-592
 1ec:	00000097          	auipc	ra,0x0
 1f0:	e14080e7          	jalr	-492(ra) # 0 <fmtname>
 1f4:	85d6                	mv	a1,s5
 1f6:	00000097          	auipc	ra,0x0
 1fa:	09e080e7          	jalr	158(ra) # 294 <strcmp>
 1fe:	d15d                	beqz	a0,1a4 <find+0x168>
 200:	db040513          	addi	a0,s0,-592
 204:	00000097          	auipc	ra,0x0
 208:	dfc080e7          	jalr	-516(ra) # 0 <fmtname>
 20c:	85de                	mv	a1,s7
 20e:	00000097          	auipc	ra,0x0
 212:	086080e7          	jalr	134(ra) # 294 <strcmp>
 216:	d559                	beqz	a0,1a4 <find+0x168>
                find(buf, filename);
 218:	85ce                	mv	a1,s3
 21a:	db040513          	addi	a0,s0,-592
 21e:	00000097          	auipc	ra,0x0
 222:	e1e080e7          	jalr	-482(ra) # 3c <find>
 226:	bfbd                	j	1a4 <find+0x168>
                printf("find: cannot stat %s\n", buf);
 228:	db040593          	addi	a1,s0,-592
 22c:	855a                	mv	a0,s6
 22e:	00000097          	auipc	ra,0x0
 232:	648080e7          	jalr	1608(ra) # 876 <printf>
                continue;
 236:	b7bd                	j	1a4 <find+0x168>

0000000000000238 <main>:

int main(int argc, char *argv[])
{
 238:	1141                	addi	sp,sp,-16
 23a:	e406                	sd	ra,8(sp)
 23c:	e022                	sd	s0,0(sp)
 23e:	0800                	addi	s0,sp,16
    if (argc != 3)
 240:	470d                	li	a4,3
 242:	00e50f63          	beq	a0,a4,260 <main+0x28>
    {
        printf("usage: find [path] [filename]\n");
 246:	00001517          	auipc	a0,0x1
 24a:	83250513          	addi	a0,a0,-1998 # a78 <malloc+0x144>
 24e:	00000097          	auipc	ra,0x0
 252:	628080e7          	jalr	1576(ra) # 876 <printf>
        exit(0);
 256:	4501                	li	a0,0
 258:	00000097          	auipc	ra,0x0
 25c:	296080e7          	jalr	662(ra) # 4ee <exit>
 260:	87ae                	mv	a5,a1
    }
    find(argv[1], argv[2]);
 262:	698c                	ld	a1,16(a1)
 264:	6788                	ld	a0,8(a5)
 266:	00000097          	auipc	ra,0x0
 26a:	dd6080e7          	jalr	-554(ra) # 3c <find>
    exit(0);
 26e:	4501                	li	a0,0
 270:	00000097          	auipc	ra,0x0
 274:	27e080e7          	jalr	638(ra) # 4ee <exit>

0000000000000278 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27e:	87aa                	mv	a5,a0
 280:	0585                	addi	a1,a1,1
 282:	0785                	addi	a5,a5,1
 284:	fff5c703          	lbu	a4,-1(a1)
 288:	fee78fa3          	sb	a4,-1(a5)
 28c:	fb75                	bnez	a4,280 <strcpy+0x8>
    ;
  return os;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29a:	00054783          	lbu	a5,0(a0)
 29e:	cb91                	beqz	a5,2b2 <strcmp+0x1e>
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00f71763          	bne	a4,a5,2b2 <strcmp+0x1e>
    p++, q++;
 2a8:	0505                	addi	a0,a0,1
 2aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	fbe5                	bnez	a5,2a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b2:	0005c503          	lbu	a0,0(a1)
}
 2b6:	40a7853b          	subw	a0,a5,a0
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strlen>:

uint
strlen(const char *s)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cf91                	beqz	a5,2e6 <strlen+0x26>
 2cc:	0505                	addi	a0,a0,1
 2ce:	87aa                	mv	a5,a0
 2d0:	4685                	li	a3,1
 2d2:	9e89                	subw	a3,a3,a0
 2d4:	00f6853b          	addw	a0,a3,a5
 2d8:	0785                	addi	a5,a5,1
 2da:	fff7c703          	lbu	a4,-1(a5)
 2de:	fb7d                	bnez	a4,2d4 <strlen+0x14>
    ;
  return n;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  for(n = 0; s[n]; n++)
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <strlen+0x20>

00000000000002ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f0:	ce09                	beqz	a2,30a <memset+0x20>
 2f2:	87aa                	mv	a5,a0
 2f4:	fff6071b          	addiw	a4,a2,-1
 2f8:	1702                	slli	a4,a4,0x20
 2fa:	9301                	srli	a4,a4,0x20
 2fc:	0705                	addi	a4,a4,1
 2fe:	972a                	add	a4,a4,a0
    cdst[i] = c;
 300:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 304:	0785                	addi	a5,a5,1
 306:	fee79de3          	bne	a5,a4,300 <memset+0x16>
  }
  return dst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cb99                	beqz	a5,330 <strchr+0x20>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1a>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xc>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strchr+0x1a>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	1080                	addi	s0,sp,96
 34a:	8baa                	mv	s7,a0
 34c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34e:	892a                	mv	s2,a0
 350:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 352:	4aa9                	li	s5,10
 354:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	2485                	addiw	s1,s1,1
 35a:	0344d863          	bge	s1,s4,38a <gets+0x56>
    cc = read(0, &c, 1);
 35e:	4605                	li	a2,1
 360:	faf40593          	addi	a1,s0,-81
 364:	4501                	li	a0,0
 366:	00000097          	auipc	ra,0x0
 36a:	1a0080e7          	jalr	416(ra) # 506 <read>
    if(cc < 1)
 36e:	00a05e63          	blez	a0,38a <gets+0x56>
    buf[i++] = c;
 372:	faf44783          	lbu	a5,-81(s0)
 376:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37a:	01578763          	beq	a5,s5,388 <gets+0x54>
 37e:	0905                	addi	s2,s2,1
 380:	fd679be3          	bne	a5,s6,356 <gets+0x22>
  for(i=0; i+1 < max; ){
 384:	89a6                	mv	s3,s1
 386:	a011                	j	38a <gets+0x56>
 388:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 38a:	99de                	add	s3,s3,s7
 38c:	00098023          	sb	zero,0(s3)
  return buf;
}
 390:	855e                	mv	a0,s7
 392:	60e6                	ld	ra,88(sp)
 394:	6446                	ld	s0,80(sp)
 396:	64a6                	ld	s1,72(sp)
 398:	6906                	ld	s2,64(sp)
 39a:	79e2                	ld	s3,56(sp)
 39c:	7a42                	ld	s4,48(sp)
 39e:	7aa2                	ld	s5,40(sp)
 3a0:	7b02                	ld	s6,32(sp)
 3a2:	6be2                	ld	s7,24(sp)
 3a4:	6125                	addi	sp,sp,96
 3a6:	8082                	ret

00000000000003a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	e426                	sd	s1,8(sp)
 3b0:	e04a                	sd	s2,0(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b6:	4581                	li	a1,0
 3b8:	00000097          	auipc	ra,0x0
 3bc:	176080e7          	jalr	374(ra) # 52e <open>
  if(fd < 0)
 3c0:	02054563          	bltz	a0,3ea <stat+0x42>
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	00000097          	auipc	ra,0x0
 3cc:	17e080e7          	jalr	382(ra) # 546 <fstat>
 3d0:	892a                	mv	s2,a0
  close(fd);
 3d2:	8526                	mv	a0,s1
 3d4:	00000097          	auipc	ra,0x0
 3d8:	142080e7          	jalr	322(ra) # 516 <close>
  return r;
}
 3dc:	854a                	mv	a0,s2
 3de:	60e2                	ld	ra,24(sp)
 3e0:	6442                	ld	s0,16(sp)
 3e2:	64a2                	ld	s1,8(sp)
 3e4:	6902                	ld	s2,0(sp)
 3e6:	6105                	addi	sp,sp,32
 3e8:	8082                	ret
    return -1;
 3ea:	597d                	li	s2,-1
 3ec:	bfc5                	j	3dc <stat+0x34>

00000000000003ee <atoi>:

int
atoi(const char *s)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f4:	00054603          	lbu	a2,0(a0)
 3f8:	fd06079b          	addiw	a5,a2,-48
 3fc:	0ff7f793          	andi	a5,a5,255
 400:	4725                	li	a4,9
 402:	02f76963          	bltu	a4,a5,434 <atoi+0x46>
 406:	86aa                	mv	a3,a0
  n = 0;
 408:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 40a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 40c:	0685                	addi	a3,a3,1
 40e:	0025179b          	slliw	a5,a0,0x2
 412:	9fa9                	addw	a5,a5,a0
 414:	0017979b          	slliw	a5,a5,0x1
 418:	9fb1                	addw	a5,a5,a2
 41a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 41e:	0006c603          	lbu	a2,0(a3)
 422:	fd06071b          	addiw	a4,a2,-48
 426:	0ff77713          	andi	a4,a4,255
 42a:	fee5f1e3          	bgeu	a1,a4,40c <atoi+0x1e>
  return n;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
  n = 0;
 434:	4501                	li	a0,0
 436:	bfe5                	j	42e <atoi+0x40>

0000000000000438 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43e:	02b57663          	bgeu	a0,a1,46a <memmove+0x32>
    while(n-- > 0)
 442:	02c05163          	blez	a2,464 <memmove+0x2c>
 446:	fff6079b          	addiw	a5,a2,-1
 44a:	1782                	slli	a5,a5,0x20
 44c:	9381                	srli	a5,a5,0x20
 44e:	0785                	addi	a5,a5,1
 450:	97aa                	add	a5,a5,a0
  dst = vdst;
 452:	872a                	mv	a4,a0
      *dst++ = *src++;
 454:	0585                	addi	a1,a1,1
 456:	0705                	addi	a4,a4,1
 458:	fff5c683          	lbu	a3,-1(a1)
 45c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 460:	fee79ae3          	bne	a5,a4,454 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 464:	6422                	ld	s0,8(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 470:	fec05ae3          	blez	a2,464 <memmove+0x2c>
 474:	fff6079b          	addiw	a5,a2,-1
 478:	1782                	slli	a5,a5,0x20
 47a:	9381                	srli	a5,a5,0x20
 47c:	fff7c793          	not	a5,a5
 480:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 482:	15fd                	addi	a1,a1,-1
 484:	177d                	addi	a4,a4,-1
 486:	0005c683          	lbu	a3,0(a1)
 48a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48e:	fee79ae3          	bne	a5,a4,482 <memmove+0x4a>
 492:	bfc9                	j	464 <memmove+0x2c>

0000000000000494 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 49a:	ca05                	beqz	a2,4ca <memcmp+0x36>
 49c:	fff6069b          	addiw	a3,a2,-1
 4a0:	1682                	slli	a3,a3,0x20
 4a2:	9281                	srli	a3,a3,0x20
 4a4:	0685                	addi	a3,a3,1
 4a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4a8:	00054783          	lbu	a5,0(a0)
 4ac:	0005c703          	lbu	a4,0(a1)
 4b0:	00e79863          	bne	a5,a4,4c0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4b4:	0505                	addi	a0,a0,1
    p2++;
 4b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b8:	fed518e3          	bne	a0,a3,4a8 <memcmp+0x14>
  }
  return 0;
 4bc:	4501                	li	a0,0
 4be:	a019                	j	4c4 <memcmp+0x30>
      return *p1 - *p2;
 4c0:	40e7853b          	subw	a0,a5,a4
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
  return 0;
 4ca:	4501                	li	a0,0
 4cc:	bfe5                	j	4c4 <memcmp+0x30>

00000000000004ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e406                	sd	ra,8(sp)
 4d2:	e022                	sd	s0,0(sp)
 4d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d6:	00000097          	auipc	ra,0x0
 4da:	f62080e7          	jalr	-158(ra) # 438 <memmove>
}
 4de:	60a2                	ld	ra,8(sp)
 4e0:	6402                	ld	s0,0(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e6:	4885                	li	a7,1
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ee:	4889                	li	a7,2
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f6:	488d                	li	a7,3
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4fe:	4891                	li	a7,4
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <read>:
.global read
read:
 li a7, SYS_read
 506:	4895                	li	a7,5
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <write>:
.global write
write:
 li a7, SYS_write
 50e:	48c1                	li	a7,16
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <close>:
.global close
close:
 li a7, SYS_close
 516:	48d5                	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kill>:
.global kill
kill:
 li a7, SYS_kill
 51e:	4899                	li	a7,6
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exec>:
.global exec
exec:
 li a7, SYS_exec
 526:	489d                	li	a7,7
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <open>:
.global open
open:
 li a7, SYS_open
 52e:	48bd                	li	a7,15
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 536:	48c5                	li	a7,17
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 53e:	48c9                	li	a7,18
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 546:	48a1                	li	a7,8
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <link>:
.global link
link:
 li a7, SYS_link
 54e:	48cd                	li	a7,19
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 556:	48d1                	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 55e:	48a5                	li	a7,9
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <dup>:
.global dup
dup:
 li a7, SYS_dup
 566:	48a9                	li	a7,10
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56e:	48ad                	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 576:	48b1                	li	a7,12
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 57e:	48b5                	li	a7,13
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 586:	48b9                	li	a7,14
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <trace>:
.global trace
trace:
 li a7, SYS_trace
 58e:	48d9                	li	a7,22
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 596:	48dd                	li	a7,23
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59e:	1101                	addi	sp,sp,-32
 5a0:	ec06                	sd	ra,24(sp)
 5a2:	e822                	sd	s0,16(sp)
 5a4:	1000                	addi	s0,sp,32
 5a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5aa:	4605                	li	a2,1
 5ac:	fef40593          	addi	a1,s0,-17
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f5e080e7          	jalr	-162(ra) # 50e <write>
}
 5b8:	60e2                	ld	ra,24(sp)
 5ba:	6442                	ld	s0,16(sp)
 5bc:	6105                	addi	sp,sp,32
 5be:	8082                	ret

00000000000005c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c0:	7139                	addi	sp,sp,-64
 5c2:	fc06                	sd	ra,56(sp)
 5c4:	f822                	sd	s0,48(sp)
 5c6:	f426                	sd	s1,40(sp)
 5c8:	f04a                	sd	s2,32(sp)
 5ca:	ec4e                	sd	s3,24(sp)
 5cc:	0080                	addi	s0,sp,64
 5ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d0:	c299                	beqz	a3,5d6 <printint+0x16>
 5d2:	0805c863          	bltz	a1,662 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d6:	2581                	sext.w	a1,a1
  neg = 0;
 5d8:	4881                	li	a7,0
 5da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e0:	2601                	sext.w	a2,a2
 5e2:	00000517          	auipc	a0,0x0
 5e6:	4be50513          	addi	a0,a0,1214 # aa0 <digits>
 5ea:	883a                	mv	a6,a4
 5ec:	2705                	addiw	a4,a4,1
 5ee:	02c5f7bb          	remuw	a5,a1,a2
 5f2:	1782                	slli	a5,a5,0x20
 5f4:	9381                	srli	a5,a5,0x20
 5f6:	97aa                	add	a5,a5,a0
 5f8:	0007c783          	lbu	a5,0(a5)
 5fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 600:	0005879b          	sext.w	a5,a1
 604:	02c5d5bb          	divuw	a1,a1,a2
 608:	0685                	addi	a3,a3,1
 60a:	fec7f0e3          	bgeu	a5,a2,5ea <printint+0x2a>
  if(neg)
 60e:	00088b63          	beqz	a7,624 <printint+0x64>
    buf[i++] = '-';
 612:	fd040793          	addi	a5,s0,-48
 616:	973e                	add	a4,a4,a5
 618:	02d00793          	li	a5,45
 61c:	fef70823          	sb	a5,-16(a4)
 620:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 624:	02e05863          	blez	a4,654 <printint+0x94>
 628:	fc040793          	addi	a5,s0,-64
 62c:	00e78933          	add	s2,a5,a4
 630:	fff78993          	addi	s3,a5,-1
 634:	99ba                	add	s3,s3,a4
 636:	377d                	addiw	a4,a4,-1
 638:	1702                	slli	a4,a4,0x20
 63a:	9301                	srli	a4,a4,0x20
 63c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 640:	fff94583          	lbu	a1,-1(s2)
 644:	8526                	mv	a0,s1
 646:	00000097          	auipc	ra,0x0
 64a:	f58080e7          	jalr	-168(ra) # 59e <putc>
  while(--i >= 0)
 64e:	197d                	addi	s2,s2,-1
 650:	ff3918e3          	bne	s2,s3,640 <printint+0x80>
}
 654:	70e2                	ld	ra,56(sp)
 656:	7442                	ld	s0,48(sp)
 658:	74a2                	ld	s1,40(sp)
 65a:	7902                	ld	s2,32(sp)
 65c:	69e2                	ld	s3,24(sp)
 65e:	6121                	addi	sp,sp,64
 660:	8082                	ret
    x = -xx;
 662:	40b005bb          	negw	a1,a1
    neg = 1;
 666:	4885                	li	a7,1
    x = -xx;
 668:	bf8d                	j	5da <printint+0x1a>

000000000000066a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66a:	7119                	addi	sp,sp,-128
 66c:	fc86                	sd	ra,120(sp)
 66e:	f8a2                	sd	s0,112(sp)
 670:	f4a6                	sd	s1,104(sp)
 672:	f0ca                	sd	s2,96(sp)
 674:	ecce                	sd	s3,88(sp)
 676:	e8d2                	sd	s4,80(sp)
 678:	e4d6                	sd	s5,72(sp)
 67a:	e0da                	sd	s6,64(sp)
 67c:	fc5e                	sd	s7,56(sp)
 67e:	f862                	sd	s8,48(sp)
 680:	f466                	sd	s9,40(sp)
 682:	f06a                	sd	s10,32(sp)
 684:	ec6e                	sd	s11,24(sp)
 686:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 688:	0005c903          	lbu	s2,0(a1)
 68c:	18090f63          	beqz	s2,82a <vprintf+0x1c0>
 690:	8aaa                	mv	s5,a0
 692:	8b32                	mv	s6,a2
 694:	00158493          	addi	s1,a1,1
  state = 0;
 698:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69a:	02500a13          	li	s4,37
      if(c == 'd'){
 69e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6a2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6a6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6aa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ae:	00000b97          	auipc	s7,0x0
 6b2:	3f2b8b93          	addi	s7,s7,1010 # aa0 <digits>
 6b6:	a839                	j	6d4 <vprintf+0x6a>
        putc(fd, c);
 6b8:	85ca                	mv	a1,s2
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	ee2080e7          	jalr	-286(ra) # 59e <putc>
 6c4:	a019                	j	6ca <vprintf+0x60>
    } else if(state == '%'){
 6c6:	01498f63          	beq	s3,s4,6e4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6ca:	0485                	addi	s1,s1,1
 6cc:	fff4c903          	lbu	s2,-1(s1)
 6d0:	14090d63          	beqz	s2,82a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6d8:	fe0997e3          	bnez	s3,6c6 <vprintf+0x5c>
      if(c == '%'){
 6dc:	fd479ee3          	bne	a5,s4,6b8 <vprintf+0x4e>
        state = '%';
 6e0:	89be                	mv	s3,a5
 6e2:	b7e5                	j	6ca <vprintf+0x60>
      if(c == 'd'){
 6e4:	05878063          	beq	a5,s8,724 <vprintf+0xba>
      } else if(c == 'l') {
 6e8:	05978c63          	beq	a5,s9,740 <vprintf+0xd6>
      } else if(c == 'x') {
 6ec:	07a78863          	beq	a5,s10,75c <vprintf+0xf2>
      } else if(c == 'p') {
 6f0:	09b78463          	beq	a5,s11,778 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6f4:	07300713          	li	a4,115
 6f8:	0ce78663          	beq	a5,a4,7c4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fc:	06300713          	li	a4,99
 700:	0ee78e63          	beq	a5,a4,7fc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 704:	11478863          	beq	a5,s4,814 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 708:	85d2                	mv	a1,s4
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e92080e7          	jalr	-366(ra) # 59e <putc>
        putc(fd, c);
 714:	85ca                	mv	a1,s2
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	e86080e7          	jalr	-378(ra) # 59e <putc>
      }
      state = 0;
 720:	4981                	li	s3,0
 722:	b765                	j	6ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 724:	008b0913          	addi	s2,s6,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000b2583          	lw	a1,0(s6)
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e8e080e7          	jalr	-370(ra) # 5c0 <printint>
 73a:	8b4a                	mv	s6,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b771                	j	6ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 740:	008b0913          	addi	s2,s6,8
 744:	4681                	li	a3,0
 746:	4629                	li	a2,10
 748:	000b2583          	lw	a1,0(s6)
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	e72080e7          	jalr	-398(ra) # 5c0 <printint>
 756:	8b4a                	mv	s6,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	bf85                	j	6ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 75c:	008b0913          	addi	s2,s6,8
 760:	4681                	li	a3,0
 762:	4641                	li	a2,16
 764:	000b2583          	lw	a1,0(s6)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e56080e7          	jalr	-426(ra) # 5c0 <printint>
 772:	8b4a                	mv	s6,s2
      state = 0;
 774:	4981                	li	s3,0
 776:	bf91                	j	6ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 778:	008b0793          	addi	a5,s6,8
 77c:	f8f43423          	sd	a5,-120(s0)
 780:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 784:	03000593          	li	a1,48
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	e14080e7          	jalr	-492(ra) # 59e <putc>
  putc(fd, 'x');
 792:	85ea                	mv	a1,s10
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e08080e7          	jalr	-504(ra) # 59e <putc>
 79e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a0:	03c9d793          	srli	a5,s3,0x3c
 7a4:	97de                	add	a5,a5,s7
 7a6:	0007c583          	lbu	a1,0(a5)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	df2080e7          	jalr	-526(ra) # 59e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b4:	0992                	slli	s3,s3,0x4
 7b6:	397d                	addiw	s2,s2,-1
 7b8:	fe0914e3          	bnez	s2,7a0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7bc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b721                	j	6ca <vprintf+0x60>
        s = va_arg(ap, char*);
 7c4:	008b0993          	addi	s3,s6,8
 7c8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7cc:	02090163          	beqz	s2,7ee <vprintf+0x184>
        while(*s != 0){
 7d0:	00094583          	lbu	a1,0(s2)
 7d4:	c9a1                	beqz	a1,824 <vprintf+0x1ba>
          putc(fd, *s);
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	dc6080e7          	jalr	-570(ra) # 59e <putc>
          s++;
 7e0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7e2:	00094583          	lbu	a1,0(s2)
 7e6:	f9e5                	bnez	a1,7d6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7e8:	8b4e                	mv	s6,s3
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bdf9                	j	6ca <vprintf+0x60>
          s = "(null)";
 7ee:	00000917          	auipc	s2,0x0
 7f2:	2aa90913          	addi	s2,s2,682 # a98 <malloc+0x164>
        while(*s != 0){
 7f6:	02800593          	li	a1,40
 7fa:	bff1                	j	7d6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7fc:	008b0913          	addi	s2,s6,8
 800:	000b4583          	lbu	a1,0(s6)
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	d98080e7          	jalr	-616(ra) # 59e <putc>
 80e:	8b4a                	mv	s6,s2
      state = 0;
 810:	4981                	li	s3,0
 812:	bd65                	j	6ca <vprintf+0x60>
        putc(fd, c);
 814:	85d2                	mv	a1,s4
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	d86080e7          	jalr	-634(ra) # 59e <putc>
      state = 0;
 820:	4981                	li	s3,0
 822:	b565                	j	6ca <vprintf+0x60>
        s = va_arg(ap, char*);
 824:	8b4e                	mv	s6,s3
      state = 0;
 826:	4981                	li	s3,0
 828:	b54d                	j	6ca <vprintf+0x60>
    }
  }
}
 82a:	70e6                	ld	ra,120(sp)
 82c:	7446                	ld	s0,112(sp)
 82e:	74a6                	ld	s1,104(sp)
 830:	7906                	ld	s2,96(sp)
 832:	69e6                	ld	s3,88(sp)
 834:	6a46                	ld	s4,80(sp)
 836:	6aa6                	ld	s5,72(sp)
 838:	6b06                	ld	s6,64(sp)
 83a:	7be2                	ld	s7,56(sp)
 83c:	7c42                	ld	s8,48(sp)
 83e:	7ca2                	ld	s9,40(sp)
 840:	7d02                	ld	s10,32(sp)
 842:	6de2                	ld	s11,24(sp)
 844:	6109                	addi	sp,sp,128
 846:	8082                	ret

0000000000000848 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 848:	715d                	addi	sp,sp,-80
 84a:	ec06                	sd	ra,24(sp)
 84c:	e822                	sd	s0,16(sp)
 84e:	1000                	addi	s0,sp,32
 850:	e010                	sd	a2,0(s0)
 852:	e414                	sd	a3,8(s0)
 854:	e818                	sd	a4,16(s0)
 856:	ec1c                	sd	a5,24(s0)
 858:	03043023          	sd	a6,32(s0)
 85c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 864:	8622                	mv	a2,s0
 866:	00000097          	auipc	ra,0x0
 86a:	e04080e7          	jalr	-508(ra) # 66a <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6161                	addi	sp,sp,80
 874:	8082                	ret

0000000000000876 <printf>:

void
printf(const char *fmt, ...)
{
 876:	711d                	addi	sp,sp,-96
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e40c                	sd	a1,8(s0)
 880:	e810                	sd	a2,16(s0)
 882:	ec14                	sd	a3,24(s0)
 884:	f018                	sd	a4,32(s0)
 886:	f41c                	sd	a5,40(s0)
 888:	03043823          	sd	a6,48(s0)
 88c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	00840613          	addi	a2,s0,8
 894:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 898:	85aa                	mv	a1,a0
 89a:	4505                	li	a0,1
 89c:	00000097          	auipc	ra,0x0
 8a0:	dce080e7          	jalr	-562(ra) # 66a <vprintf>
}
 8a4:	60e2                	ld	ra,24(sp)
 8a6:	6442                	ld	s0,16(sp)
 8a8:	6125                	addi	sp,sp,96
 8aa:	8082                	ret

00000000000008ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ac:	1141                	addi	sp,sp,-16
 8ae:	e422                	sd	s0,8(sp)
 8b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	00000797          	auipc	a5,0x0
 8ba:	2027b783          	ld	a5,514(a5) # ab8 <freep>
 8be:	a805                	j	8ee <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c0:	4618                	lw	a4,8(a2)
 8c2:	9db9                	addw	a1,a1,a4
 8c4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	6318                	ld	a4,0(a4)
 8cc:	fee53823          	sd	a4,-16(a0)
 8d0:	a091                	j	914 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d2:	ff852703          	lw	a4,-8(a0)
 8d6:	9e39                	addw	a2,a2,a4
 8d8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8da:	ff053703          	ld	a4,-16(a0)
 8de:	e398                	sd	a4,0(a5)
 8e0:	a099                	j	926 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e2:	6398                	ld	a4,0(a5)
 8e4:	00e7e463          	bltu	a5,a4,8ec <free+0x40>
 8e8:	00e6ea63          	bltu	a3,a4,8fc <free+0x50>
{
 8ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	fed7fae3          	bgeu	a5,a3,8e2 <free+0x36>
 8f2:	6398                	ld	a4,0(a5)
 8f4:	00e6e463          	bltu	a3,a4,8fc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f8:	fee7eae3          	bltu	a5,a4,8ec <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8fc:	ff852583          	lw	a1,-8(a0)
 900:	6390                	ld	a2,0(a5)
 902:	02059713          	slli	a4,a1,0x20
 906:	9301                	srli	a4,a4,0x20
 908:	0712                	slli	a4,a4,0x4
 90a:	9736                	add	a4,a4,a3
 90c:	fae60ae3          	beq	a2,a4,8c0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 910:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 914:	4790                	lw	a2,8(a5)
 916:	02061713          	slli	a4,a2,0x20
 91a:	9301                	srli	a4,a4,0x20
 91c:	0712                	slli	a4,a4,0x4
 91e:	973e                	add	a4,a4,a5
 920:	fae689e3          	beq	a3,a4,8d2 <free+0x26>
  } else
    p->s.ptr = bp;
 924:	e394                	sd	a3,0(a5)
  freep = p;
 926:	00000717          	auipc	a4,0x0
 92a:	18f73923          	sd	a5,402(a4) # ab8 <freep>
}
 92e:	6422                	ld	s0,8(sp)
 930:	0141                	addi	sp,sp,16
 932:	8082                	ret

0000000000000934 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 934:	7139                	addi	sp,sp,-64
 936:	fc06                	sd	ra,56(sp)
 938:	f822                	sd	s0,48(sp)
 93a:	f426                	sd	s1,40(sp)
 93c:	f04a                	sd	s2,32(sp)
 93e:	ec4e                	sd	s3,24(sp)
 940:	e852                	sd	s4,16(sp)
 942:	e456                	sd	s5,8(sp)
 944:	e05a                	sd	s6,0(sp)
 946:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 948:	02051493          	slli	s1,a0,0x20
 94c:	9081                	srli	s1,s1,0x20
 94e:	04bd                	addi	s1,s1,15
 950:	8091                	srli	s1,s1,0x4
 952:	0014899b          	addiw	s3,s1,1
 956:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 958:	00000517          	auipc	a0,0x0
 95c:	16053503          	ld	a0,352(a0) # ab8 <freep>
 960:	c515                	beqz	a0,98c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 962:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 964:	4798                	lw	a4,8(a5)
 966:	02977f63          	bgeu	a4,s1,9a4 <malloc+0x70>
 96a:	8a4e                	mv	s4,s3
 96c:	0009871b          	sext.w	a4,s3
 970:	6685                	lui	a3,0x1
 972:	00d77363          	bgeu	a4,a3,978 <malloc+0x44>
 976:	6a05                	lui	s4,0x1
 978:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 980:	00000917          	auipc	s2,0x0
 984:	13890913          	addi	s2,s2,312 # ab8 <freep>
  if(p == (char*)-1)
 988:	5afd                	li	s5,-1
 98a:	a88d                	j	9fc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 98c:	00000797          	auipc	a5,0x0
 990:	13478793          	addi	a5,a5,308 # ac0 <base>
 994:	00000717          	auipc	a4,0x0
 998:	12f73223          	sd	a5,292(a4) # ab8 <freep>
 99c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a2:	b7e1                	j	96a <malloc+0x36>
      if(p->s.size == nunits)
 9a4:	02e48b63          	beq	s1,a4,9da <malloc+0xa6>
        p->s.size -= nunits;
 9a8:	4137073b          	subw	a4,a4,s3
 9ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ae:	1702                	slli	a4,a4,0x20
 9b0:	9301                	srli	a4,a4,0x20
 9b2:	0712                	slli	a4,a4,0x4
 9b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ba:	00000717          	auipc	a4,0x0
 9be:	0ea73f23          	sd	a0,254(a4) # ab8 <freep>
      return (void*)(p + 1);
 9c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c6:	70e2                	ld	ra,56(sp)
 9c8:	7442                	ld	s0,48(sp)
 9ca:	74a2                	ld	s1,40(sp)
 9cc:	7902                	ld	s2,32(sp)
 9ce:	69e2                	ld	s3,24(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
 9d6:	6121                	addi	sp,sp,64
 9d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9da:	6398                	ld	a4,0(a5)
 9dc:	e118                	sd	a4,0(a0)
 9de:	bff1                	j	9ba <malloc+0x86>
  hp->s.size = nu;
 9e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e4:	0541                	addi	a0,a0,16
 9e6:	00000097          	auipc	ra,0x0
 9ea:	ec6080e7          	jalr	-314(ra) # 8ac <free>
  return freep;
 9ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f2:	d971                	beqz	a0,9c6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f6:	4798                	lw	a4,8(a5)
 9f8:	fa9776e3          	bgeu	a4,s1,9a4 <malloc+0x70>
    if(p == freep)
 9fc:	00093703          	ld	a4,0(s2)
 a00:	853e                	mv	a0,a5
 a02:	fef719e3          	bne	a4,a5,9f4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a06:	8552                	mv	a0,s4
 a08:	00000097          	auipc	ra,0x0
 a0c:	b6e080e7          	jalr	-1170(ra) # 576 <sbrk>
  if(p == (char*)-1)
 a10:	fd5518e3          	bne	a0,s5,9e0 <malloc+0xac>
        return 0;
 a14:	4501                	li	a0,0
 a16:	bf45                	j	9c6 <malloc+0x92>
