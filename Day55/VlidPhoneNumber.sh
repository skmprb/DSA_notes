# Read from the file file.txt and output all valid phone numbers to stdout.
# p1='\([0-9][0-9][0-9]\)\ [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
# p2='[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'

# while read line; do
#   case "$line" in
#   $p1 | $p2) echo "$line" ;;
#   esac
# done <file.txt

# Read from the file file.txt and output all valid phone numbers to stdout.
# Read from the file file.txt and output all valid phone numbers to stdout.
p=\([0-9][0-9][0-9]\)\ [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]
p1=[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]

while read -r line 
 do
  case "$line" in
  $p)
  echo $line
  ;;
  $p1)
  echo $line
  ;;
  esac
 done < file.txt