echo -e "#include <errno.h>\n#include <attr/xattr.h>" | \
    cpp -dD | \
    grep "^#define E" | \
    sed -e '{s/#define \(.*\) .*/\t"\1", \1,/g}'
