#!/bin/bash
# Ensure the script is called with the correct number of arguments
if [ "$#" -lt 2 ]; then
	echo "Usage: $0 <source_directory> <program_name> {add_main=0,1}"
	exit 1
fi

# Assign arguments to variables
SRC_DIR="src"
PARENT_DIR=$1
PROGRAM_NAME=$2
ADD_MAIN=${3:-0}

# Detect all subdirectories in project/src and generate CATEGORY_DIR and CATEGORY_SRC
SUBDIRS=$(find "$PARENT_DIR/$SRC_DIR" -mindepth 1 -type d -exec basename {} \;)
CATEGORIES=""
SOURCE="SOURCE_DIR			=	src
SOURCE				=	\$(SOURCE_DIR)/main.cpp"

for DIR in $SUBDIRS; do
	# Generate CATEGORY_DIR and CATEGORY_SRC for each subdirectory
	CATEGORY_SRC=$(find "$PARENT_DIR/$SRC_DIR/$DIR" -name "*.cpp" -exec basename {} \; | sort -u | awk '{
		if (NR == 1) printf "%s", $0;
		else printf " \\\n\t\t\t\t\t\t%s", $0;
	}')
	CATEGORIES="$CATEGORIES
${DIR^^}_DIR			=	$DIR
${DIR^^}_SRC			=	$CATEGORY_SRC
"
	SOURCE="$SOURCE \\
						\$(addprefix \$(SOURCE_DIR)/\$(${DIR^^}_DIR)/, \$(${DIR^^}_SRC))"
done

# Create the Makefile
cat > "$PARENT_DIR/Makefile" <<EOF
CC					=	c++
CFLAGS				=	-std=c++98 -Wall -Werror -Wextra -Wshadow

NAME				=	$PROGRAM_NAME
$CATEGORIES
$SOURCE

OBJECTS_DIR			=	objects
OBJECTS				=	\$(SOURCE:\$(SOURCE_DIR)/%.cpp=\$(OBJECTS_DIR)/%.o)

all: \$(NAME)

\$(OBJECTS_DIR)/%.o: \$(SOURCE_DIR)/%.cpp
	@mkdir -p \$(dir \$@)
	\$(CC) \$(CFLAGS) -I./ -I\$(SOURCE_DIR) -o \$@ -c \$<

\$(NAME): \$(OBJECTS)
	\$(CC) \$(CFLAGS) \$(OBJECTS) -o \$(NAME)

clean:
	@if [ -n "\$(OBJECTS_DIR)" ] && [ "\$(OBJECTS_DIR)" != "/" ] && [ -d "\$(OBJECTS_DIR)" ]; then \\
		rm -rf \$(OBJECTS_DIR); \\
	else \\
		echo "Error: OBJECTS_DIR is undefined or invalid"; \\
	fi

fclean: clean
	rm -f \$(NAME)

re: clean all

fre: fclean all

.PHONY: all clean fclean re fre
EOF

# Notify the user of the created file
echo "Makefile created for program: $PROGRAM_NAME"

# Conditionally create main.cpp if add_main is set to 1
if [ "$ADD_MAIN" -eq 1 ]; then
	# Generate #include list for all .hpp files in project/src and its subdirectories
	INCLUDES=$(find "$PARENT_DIR/$SRC_DIR" -name "*.hpp" | sort | awk -v base="$PARENT_DIR/$SRC_DIR/" '{
		# Remove the base directory and "src/" prefix to adjust paths for #include
		sub(base, "", $0);
		printf "#include \"%s\"\n", $0;
	}')

	# Create main.cpp
	cat > "$PARENT_DIR/$SRC_DIR/main.cpp" <<EOF
# include <iostream>

$INCLUDES

int	main(void)
{
}
EOF

	# Notify the user of the created file
	echo "main.cpp created with heading:"
	echo "$INCLUDES"
fi
