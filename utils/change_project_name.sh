#! /bin/bash


# Function that displays help message and exits
display_help() {
    echo
    echo "Change project name. Old project name must match current project name under src/ directory."
    echo
    echo "Usage: $0 --old <old-project-name> --new <new-project-name>"
    echo
    echo "   -o, --old                  old project name"
    echo "   -n, --new                  new project name"
    echo "   -h, --help                 this help message"
    echo
    exit 1
}

# If no arguments were supplied, display the help message (and exit)
[ $# -eq 0 ] && { display_help; }

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_help
            shift
            ;;
        -o|--old)
            shift
            OLD_NAME=$1
            ;;
        -n|--new)
            shift
            NEW_NAME=$1
            ;;
        *)
            echo
            echo "Unknown parameter passed: $1"
            display_help
            ;;
    esac
    shift
done

# Check if --dir argument was supplied
if [ -z "$OLD_NAME" ]
    then
        echo
        echo "ERROR: Please supply mandatory --old argument."
        display_help
fi

# Check if --uri argument was supplied
if [ -z "$NEW_NAME" ]
    then
        echo
        echo "ERROR: Please supply mandatory --new argument."
        display_help
fi


PROJECT_PATH="$(git rev-parse --show-toplevel)"
REPOSITORY_NAME="$(basename $PROJECT_PATH)"
SRC_PATH="$PROJECT_PATH/src"


if [ ! -d "$SRC_PATH/$OLD_NAME" ]
    then
        echo
        echo "ERROR: $OLD_NAME does not match the current project name"
        display_help
fi


# if a new name is not supplied as a second argument, use the repository name
if [ -z "$NEW_NAME" ]
then
    NEW_NAME=$(echo $REPOSITORY_NAME | tr "[-.]" "_" | tr "[:upper:]" "[:lower:]")
else
    NEW_NAME=$(echo $NEW_NAME | tr "[-.]" "_" | tr "[:upper:]" "[:lower:]")
fi


# change the project name in src/
mv $SRC_PATH/$OLD_NAME $SRC_PATH/$NEW_NAME


# change <old-project-name> references in all files
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    find . -type f -name "*" ! -path "$SRC_PATH/*.egg-info/*" ! -path "**/.git/*" -print | xargs sed -i "s/$OLD_NAME/$NEW_NAME/g"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    find . -type f -name "*" ! -path "$SRC_PATH/*.egg-info/*" ! -path "**/.git/*" -print | xargs perl -pi -e "s/$OLD_NAME/$NEW_NAME/g"
else
    # cygwin; msys; win32; freebsd
    echo "Unsupported OS!"
fi
