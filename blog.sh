#!/bin/bash

#switch cases to handle post category and help
case $1 in
    post)
   ;;
    category)
   ;;
   --help)
   	echo "Usage: $0 [POST|CATEGORY]... [OPTIONS]..."
	echo "1: $0 post add \"title\" \"content\""
	echo "2: $0 post list"
	echo "3: $0 post search \"keyword\""
	echo "4: $0 category add \category-name\""
	echo "5: $0 category list"
	echo "6: $0 category assign <post-id> <cat-id>"
	echo "7: $0 post add \"title\" \"content\" --category \"cat-name\""
   ;;
    *)
        echo "Usage: $0 --help"
        exit 3
        ;;
esac

:
