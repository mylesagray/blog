# Resize images to max 740px width
find ./content -type f -name '*.png' -exec sh -c 'mogrify -resize 740x $1' _ {} \;
find ./content -type f -name '*.jpg' -exec sh -c 'mogrify -resize 740x $1' _ {} \;
find ./content -type f -name '*.jpeg' -exec sh -c 'mogrify -resize 740x $1' _ {} \;
# Convert all images to webp
find ./content -type f -name '*.png' -exec sh -c 'cwebp $1 -o "${1%.png}.webp"' _ {} \;
find ./content -type f -name '*.jpg' -exec sh -c 'cwebp $1 -o "${1%.jpg}.webp"' _ {} \;
find ./content -type f -name '*.jpeg' -exec sh -c 'cwebp $1 -o "${1%.jpeg}.webp"' _ {} \;
# Convert all images to avif
find ./content -type f -name '*.png' -exec sh -c 'avifenc --min 10 --max 30 $1 "${1%.png}.avif"' _ {} \;
find ./content -type f -name '*.jpg' -exec sh -c 'avifenc --min 10 --max 30 $1 "${1%.jpg}.avif"' _ {} \;
find ./content -type f -name '*.jpeg' -exec sh -c 'avifenc --min 10 --max 30 $1 "${1%.jpeg}.avif"' _ {} \;