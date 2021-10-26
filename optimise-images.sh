find ./ -type f -name '*.png' -exec sh -c 'cwebp $1 -o "${1%.png}.webp"' _ {} \;
find ./ -type f -name '*.jpg' -exec sh -c 'cwebp $1 -o "${1%.jpg}.webp"' _ {} \;
find ./ -type f -name '*.jpeg' -exec sh -c 'cwebp $1 -o "${1%.jpeg}.webp"' _ {} \;
find ./ -type f -name '*.png' -exec sh -c 'avifenc --min 10 --max 30 $1 "${1%.png}.avif"' _ {} \;
find ./ -type f -name '*.jpg' -exec sh -c 'avifenc --min 10 --max 30 $1 "${1%.jpg}.avif"' _ {} \;
find ./ -type f -name '*.jpeg' -exec sh -c 'avifenc --min 10 --max 30 $1 "${1%.jpeg}.avif"' _ {} \;