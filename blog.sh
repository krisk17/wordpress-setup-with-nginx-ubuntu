#!/bin/bash

#switch cases to handle post category and help
case $1 in
    post)
	case $2 in
		add)
			if ([ ! -z "$3" -a "$3" != " " ] && [ ! -z "$4" -a "$4" != " " ] && [ $# -eq 4 ])
			then
				sqlite3 blog "insert into post(title,content) values('$3','$4');"				
			fi
			case $5 in 
				--category)	
					if ([ ! -z "$3" -a "$3" != " " ] && [ ! -z "$4" -a "$4" != " " ] && [ ! -z "$6" -a "$6" != " " ])
					then
						sqlite3 blog "insert into post(title,content) values('$3','$4');"
						post_id=`sqlite3 blog "select ID from post where title='$3'"`
						cat=`sqlite3 blog "select name from category where name = '$6';"`	
						if [ ! -z "$cat" -a "$cat" != " " ]
						then
							cat_id=`sqlite3 blog "select ID from category where name='$6'"`
							sqlite3 blog "insert into assign(post_id,cat_id) values($post_id,$cat_id);"
						else
							sqlite3 blog "insert into category (name) values('$6');"
                                        		cat_id=`sqlite3 blog "select ID from category where name='$6'"`
                                        		sqlite3 blog "insert into assign(post_id,cat_id) values($post_id,$cat_id);"
						fi
					fi
				;;
			esac
			
			:
				
		;;
		list)
			sqlite3 blog "select * from post;"
		;;
		search)
			if [ ! -z "$3" -a "$3" != " " ]
                        then
                                sqlite3 blog "select * from post where title = '$3';"
                        fi
	
		;;
		*)
			echo "Usage: $0 --help"
        		exit 3
        	;;	
	esac

	:
   ;;
    category)
	case $2 in
		add)
			if [ ! -z "$3" -a "$3" != " " ]
                        then
                                sqlite3 blog "insert into category (name) values('$3');"
                        fi

                ;;
                list)
			sqlite3 blog "select * from category;"
                ;;
                assign)
			if ([ ! -z "$3" -a "$3" != " " ] && [ ! -z "$4" -a "$4" != " " ])
                        then
                                sqlite3 blog "insert into assign(post_id,cat_id) values($3,$4);"
                        fi
	
                ;;
                *)
                        echo "Usage: $0 --help"
                        exit 3
                ;;
        esac

        :
   ;;
   --help)
   	echo "Usage: $0 [POST|CATEGORY]... [OPTIONS]..."
	echo "1: $0 post add \"title\" \"content\""
	echo "2: $0 post list"
	echo "3: $0 post search \"keyword\""
	echo "4: $0 category add category-name\""
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
