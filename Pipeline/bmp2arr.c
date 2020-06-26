
#if defined(REC98_PROJECT)
# include "platform.h" /* see also [https://github.com/nmlgc/ReC98/issues/8] */
#else
# include <stdint.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

#if defined(__GNUC__)
# include <endian.h>
#else
# define le16toh(x) (x)
# define le32toh(x) (x)
#endif

/* O_BINARY is needed for MS-DOS, Windows, etc.
 * Linux, Mac OS X, etc. do not have O_BINARY */
#ifndef O_BINARY
#define O_BINARY (0)
#endif

/* what to emit */
enum rec98_bmp2arr_output_type {
    REC98_OUT_C=0,
    REC98_OUT_ASM,
    REC98_OUT_OMF
};

/* the task at hand */
struct rec98_bmp2arr_task {
    char*           input_bmp;
    char*           output_symname;     /* what to name the symbol */
    char*           output_file;
    unsigned char   output_type;
    unsigned char   sprite_width;       /* 8, or 16 [https://github.com/nmlgc/ReC98/issues/8 ref. dots8_t, dots16_t] */
    unsigned char   sprite_height;      /* according to list, either 4, 8, or 16 */
    unsigned char   preshift;           /* 1=generate preshifted variations or 0=don't   This makes the bitmap one byte wider */
    unsigned char   upsidedown;         /* 1=output upside down  (ref. game 3 score bitmap) */
    unsigned char   preshift_inner;     /* 1=[number][PRESHIFT][height]    0=[PRESHIFT][number][height] */

    /* working state */
    unsigned int    bmp_width;          /* width of bmp */
    unsigned int    bmp_height;         /* height of bmp */
    unsigned int    bmp_stride;         /* bytes per scanline */
    unsigned char*  bmp;                /* bitmap in memory (NTS: All examples listed can easily fit in 64KB or less) */

    unsigned long   output_size;
    unsigned char*  output;             /* again, output can fit in far less than 64KB */
};

/* C-string utils */
void cstr_free(char **s) {
    if (s != NULL) {
        if (*s != NULL) {
            free(*s);
            *s = NULL;
        }
    }
}

void cstr_set(char **s,const char *n) {
    if (s != NULL) {
        cstr_free(s);
        if (n != NULL) *s = strdup(n);
    }
}

void rec98_bmp2arr_task_free_output(struct rec98_bmp2arr_task *t) {
    if (t != NULL) {
        if (t->output != NULL) {
            free(t->output);
            t->output = NULL;
        }
    }
}

void rec98_bmp2arr_task_free_bmp(struct rec98_bmp2arr_task *t) {
    if (t != NULL) {
        if (t->bmp != NULL) {
            free(t->bmp);
            t->bmp = NULL;
        }
    }
}

/* assume *t is uninitialized data */
int rec98_bmp2arr_task_init(struct rec98_bmp2arr_task *t) {
    if (t == NULL) return -1; /* failure */
    memset(t,0,sizeof(*t));
    return 0; /* success */
}

/* assume *t is initialized data */
int rec98_bmp2arr_task_free(struct rec98_bmp2arr_task *t) {
    if (t == NULL) return -1; /* failure */
    rec98_bmp2arr_task_free_output(t);
    rec98_bmp2arr_task_free_bmp(t);
    cstr_free(&t->output_symname);
    cstr_free(&t->output_file);
    cstr_free(&t->input_bmp);
    memset(t,0,sizeof(*t));
    return 0; /* success */
}

static unsigned char bmp_tmp[128]; /* more than enough */

/*
    typedef struct tagBITMAPFILEHEADER {
        WORD  bfType;                                           +0
        DWORD bfSize;                                           +2
        WORD  bfReserved1;                                      +6
        WORD  bfReserved2;                                      +8
        DWORD bfOffBits;                                        +10
    } BITMAPFILEHEADER, *LPBITMAPFILEHEADER, *PBITMAPFILEHEADER;=14

    typedef struct tagBITMAPINFOHEADER {
        DWORD biSize;                                           +0
        LONG  biWidth;                                          +4
        LONG  biHeight;                                         +8
        WORD  biPlanes;                                         +12
        WORD  biBitCount;                                       +14
        DWORD biCompression;                                    +16
        DWORD biSizeImage;                                      +20
        LONG  biXPelsPerMeter;                                  +24
        LONG  biYPelsPerMeter;                                  +28
        DWORD biClrUsed;                                        +32
        DWORD biClrImportant;                                   +36
    } BITMAPINFOHEADER, *PBITMAPINFOHEADER;                     =40
 */

int rec98_bmp2arr_load_bitmap(struct rec98_bmp2arr_task *t) {
    uint32_t offbits;
    uint32_t bisize;
    uint16_t bpp;
    uint32_t row;
    int fd;

    if (t == NULL || t->input_bmp == NULL) return -1;
    if (t->bmp != NULL) return -1;

    fd = open(t->input_bmp,O_RDONLY|O_BINARY);
    if (fd < 0) return -1;
    if (lseek(fd,0,SEEK_SET) != 0) goto fioerr;

    /* BITMAPFILEHEADER */
    if (read(fd,bmp_tmp,14) != 14) goto fioerr;
    if (memcmp(bmp_tmp,"BM",2)) goto fioerr;
    offbits = le32toh( *((uint32_t*)(bmp_tmp+10)) ); /* endian.h little endian to host */

    /* BITMAPINFOHEADER */
    if (read(fd,bmp_tmp,40) != 40) goto fioerr;
    bisize = le32toh( *((uint32_t*)(bmp_tmp+0)) );
    if (bisize != 40) goto fioerr; /* TODO: Adapt to support BITMAPV4INFO, BITMAPV5INFO, later on */

    t->bmp_width = le32toh( *((uint32_t*)(bmp_tmp+4)) );
    t->bmp_height = le32toh( *((uint32_t*)(bmp_tmp+8)) );
    if (t->bmp_width < 1 || t->bmp_height < 1 || t->bmp_width > 1024 || t->bmp_height > 1024) goto fioerr;

    if ( le16toh( *((uint16_t*)(bmp_tmp+12)) ) != 1 /* biPlanes*/ ||
         le32toh( *((uint32_t*)(bmp_tmp+16)) ) != 0 /* biCompression*/)
        goto fioerr;

    bpp = le16toh( *((uint16_t*)(bmp_tmp+14)) );
    if (!(bpp == 1 || bpp == 24 || bpp == 32)) goto fioerr;

    if (bpp > 1)
        t->bmp_stride = ((t->bmp_width + 3u) & (~3u)) * (bpp / 8u); /* 4-pixel align */
    else
        t->bmp_stride = (t->bmp_width + 7u) / 8u; /* BYTE align */

#if TARGET_MSDOS == 16
    if ((32768u / t->bmp_stride) < t->bmp_height) /* cannot fit into 32KB */
        goto fioerr;
#endif

    t->bmp = malloc(t->bmp_height * t->bmp_stride);
    if (t->bmp == NULL) goto fioerr;

    /* read bitmap bits. BMPs are upside-down */
    if (lseek(fd,offbits,SEEK_SET) != offbits) goto fioerr;

    /* count: height-1 to 0 inclusive */
    row = t->bmp_height - 1u;
    do {
        if (read(fd,t->bmp + (row * t->bmp_stride),t->bmp_stride) != t->bmp_stride) goto fioerr;
    } while (row-- != 0u); /* compare against post decrement to break out if it is zero */

    close(fd);

    return 0;
fioerr:
    close(fd);
    return -1;
}

static int parse_argv(struct rec98_bmp2arr_task *tsk,int argc,char **argv) {
    char *a;
    int i;

    for (i=1;i < argc;) {
        a = argv[i++];

        if (*a == '-') {
            do { a++; } while (*a == '-');

            if (!strcmp(a,"i")) {
                a = argv[i++];
                if (a == NULL) return -1;
                cstr_set(&tsk->input_bmp,a);
            }
            else if (!strcmp(a,"o")) {
                a = argv[i++];
                if (a == NULL) return -1;
                cstr_set(&tsk->output_file,a);
            }
            else if (!strcmp(a,"of")) {
                a = argv[i++];
                if (a == NULL) return -1;

                if (!strcmp(a,"omf"))
                    tsk->output_type = REC98_OUT_OMF;
                else if (!strcmp(a,"asm"))
                    tsk->output_type = REC98_OUT_ASM;
                else if (!strcmp(a,"c"))
                    tsk->output_type = REC98_OUT_C;
                else
                    return -1;
            }
            else if (!strcmp(a,"sw")) {
                a = argv[i++];
                if (a == NULL) return -1;
                tsk->sprite_width = atoi(a);
                if (!(tsk->sprite_width == 8 || tsk->sprite_width == 16)) return -1;
            }
            else if (!strcmp(a,"sh")) {
                a = argv[i++];
                if (a == NULL) return -1;
                tsk->sprite_height = atoi(a);
                if (tsk->sprite_height < 1 || tsk->sprite_height > 32) return -1;
            }
            else if (!strcmp(a,"u")) {
                tsk->upsidedown = 1;
            }
            else if (!strcmp(a,"pshf")) {
                a = argv[i++];
                if (a == NULL) return -1;

                tsk->preshift = 1;
                if (!strcmp(a,"inner"))
                    tsk->preshift_inner = 1;
                else if (!strcmp(a,"outer"))
                    tsk->preshift_inner = 0;
                else
                    return -1;
            }
            else {
                fprintf(stderr,"Unknown switch '%s'\n",a);
            }
        }
        else {
            fprintf(stderr,"Unexpected\n");
            return -1;
        }
    }

    /* input BMP is required */
    if (tsk->input_bmp == NULL) {
        fprintf(stderr,"Input BMP required (-i)\n");
        return -1;
    }

    /* output file is required */
    if (tsk->output_file == NULL) {
        fprintf(stderr,"Output file required (-o)\n");
        return -1;
    }

    return 0; /* success */
}

int main(int argc,char **argv) {
    struct rec98_bmp2arr_task tsk;

    if (rec98_bmp2arr_task_init(&tsk))
        return 1;

    if (parse_argv(&tsk,argc,argv))
        return 1;

    if (rec98_bmp2arr_load_bitmap(&tsk))
        return 1;

    rec98_bmp2arr_task_free(&tsk);
    return 0;
}

