#!/bin/bash

FILE="`pwd`/materialscene.json"

cat << EOF > "$FILE"
{
	"prefabs": {
		"pointlight": {
			"material": {
				"shaderName": "color",
				"ambient": 1.0
			},
			"geometry": "debug/sphere.obj",
			"scale": 0.1
		}
	},
	"objects": [
	{
EOF

cd textures
X=0
Y=0

for i in `ls *.jpg`; do
	cat << EOF >> "$FILE"
		"material": {
			"shaderName": "nsmap",
			"diffuseMap": "textures/$i",
			"specularMap": "textures/specular/$i",
			"normalMap": "textures/normal/$i",
			"uvRepeat": 2
		},
		"geometry": "debug/plane.obj",
		"position": [ $X, 0, $Y ],
		"scale": 2
	},{
EOF
	if [ $X -gt 12 ]; then
		X=0
		Y=$(($Y+2))
	else
		X=$(($X+2))
	fi
done

CONTENTS=`head --lines=-1 "$FILE"`
echo "$CONTENTS" > "$FILE"
echo -e "\t}\n]}" >> "$FILE"

