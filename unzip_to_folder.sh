zipfile="$1"
dirname="${zipfile%.zip}"
mkdir -p "$dirname"
unzip -o "$zipfile" -d "$dirname"
