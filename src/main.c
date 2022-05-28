#include <stdio.h>
#include <string.h>

#include <locale.h>
#include <dirent.h>

#include <sys/stat.h>
#include <sys/types.h>

int travel(const char* dir) {
	/* this should be large enough of a buffer */
	char pathname[1024];
	DIR* dfd;

	if ((dfd = opendir(dir)) == NULL) {
		fprintf(stderr, "Can't open %s\n", dir);
		return 0;
	}

	struct dirent* dp;
	while ((dp = readdir(dfd)) != NULL) {
		struct stat stbuf;
		if ((strcmp(dp->d_name, ".") == 0) || (strcmp(dp->d_name, "..") == 0)) {
			continue;
		}

		sprintf(pathname, "%s/%s", dir, dp->d_name);

		if (stat(pathname, &stbuf) == -1) {
			printf("Unable to stat path: %s\n", pathname);
			continue;
		}

		puts(pathname);

		if ((stbuf.st_mode & S_IFMT) == S_IFDIR) {
			travel(pathname);
		}
	}
	return 0;
}

int main(int argc, char** argv) {
	char* locale;
	locale = setlocale(LC_ALL, "");
	if (argc <= 1) {
		fprintf(stderr, "Usage: %s <dirname>", argv[0]);
		return -1;
	}
	travel(argv[1]);
}