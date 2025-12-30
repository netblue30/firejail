#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define MAXBUF 1024

int main(int argc, char **argv) {
	printf("Hello, Firejail!\n");

	// test args
	int i;
	for (i = 1; i < argc; i++)
		printf("%d - %s\n", i, argv[i]);

	char *cont = getenv("container");
	if (cont)
		printf("\n*** container %s ***\n", cont);
	else
		printf("\n*** container none ***\n");
	sleep(1);

	FILE *fp = fopen("/proc/self/status", "r");
	if (!fp)
		printf("Cannot open proc self status\n");
	else {
		char buf[MAXBUF];
		while (fgets(buf, MAXBUF, fp)) {
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';

			if (strncmp(buf, "NoNewPrivs:", 11) == 0) {
				ptr = buf + 11;
				while (*ptr == ' ' || *ptr == '\t')
					ptr++;
				printf("*** NoNewPrivs %s ***\n", ptr);
				sleep(1);
			}

			if (strncmp(buf, "Seccomp:", 8) == 0) {
				ptr = buf + 8;
				while (*ptr == ' ' || *ptr == '\t')
					ptr++;
				printf("*** Seccomp %s ***\n", ptr);
			}
		}
		fclose(fp);
	}

	return 0;
}
