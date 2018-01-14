/*
 * Copyright (C) 2017-2018 Madura A. (madura.x86@gmail.com)
 *
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_MATCHES 32
#define MAX_ARGS 1024
#define MAX_ARGS_LEN 4096
static void loader_main() __attribute__((constructor));

char cmdline[MAX_ARGS_LEN];
char *args[MAX_ARGS];
char loader[] = "firejail";
char confFile[256];
char *names[MAX_MATCHES];

#ifdef DEBUG
#define DBG printf
#else
#define DBG
#endif
void remove_trailing_spaces(char *str)
{
    while (!isspace(*str))
    {
        str++;
    }

    while (*str != '\0')
    {
        *str = '\0';
        str++;
    }
}

void read_cmdline()
{
    int fd = open("/proc/self/cmdline", O_RDONLY);
    ssize_t ret = 0, total = 0;
    char* wcmdbuf = cmdline;
    while ((ret = read(fd, wcmdbuf, 1)) != 0)
    {
        wcmdbuf++;
        total += ret;
        if (total > MAX_ARGS_LEN)
        {
            printf("Not enough memory\n");
            close(fd);
            return ;
        }
    }
    close(fd);
}

void make_args()
{
    int cI = 0, argI=0;
    char* argstart = &cmdline[0];
    for (;cI<MAX_ARGS_LEN;cI++)
    {
        if (cmdline[cI] == '\0')
        {
            args[argI]= argstart;
            argstart = &cmdline[cI+1];
            argI++;
            if (*argstart  == '\0')
            {
                break;
            }
        }
    }
    args[argI] = argstart;
    argI++;
    args[argI] = NULL;
}

void loader_main()
{
    snprintf(confFile, 255, "%s/.loader.conf", getenv("HOME"));

    struct stat confFileStat;

    stat(confFile, &confFileStat);

    int confFd = open(confFile, O_RDONLY);

    if (confFd == -1)
    {
        close(confFd);
        return;
    }
    char* conf = (char*) malloc(confFileStat.st_size);
    if (conf == NULL)
    {
        close(confFd);
        return;
    }
    ssize_t ret  = read(confFd, conf, confFileStat.st_size);
    if (ret == -1)
    {
        close(confFd);
        return;
    }

    close(confFd);
    size_t fI = 0;
    int matchId = 0;
    names[matchId] = conf;
    matchId++;
    for (;fI < confFileStat.st_size-1;fI++)
    {
        if (conf[fI] == ',')
        {
            names[matchId] = &conf[fI+1];
            conf[fI] = '\0';

            matchId++;
        }
    }

    remove_trailing_spaces(names[matchId-1]);

    read_cmdline();

    make_args();

#ifdef DEBUG
    int xarg=0;
    while (args[xarg] != NULL)
    {
        DBG(".%s\n", args[xarg]);
        xarg++;
    }
#endif

    int x;

    for (x = 0;x<matchId;x++)
    {
        DBG("%s\n",names[x]);
        if (strstr(args[0], names[x]) != NULL)
        {
            DBG("highjack!\n");

            free(conf);

            execvp(loader, args );
        }
    }

}
