#!/bin/bash

FILE="`pwd`/materialscene.json"

cat << EOF > "$FILE"
{
	"include": [ "prefabs.json", "environment.json" ],
	"objects": [
	{
		"prefab": "camera",
		"body": {
			"noGravity": true
		}
	},{
EOF

cd textures
X=0
Y=-12

for i in `ls *.jpg`; do
	cat << EOF >> "$FILE"
		"material": {
			"diffuseMap": "textures/$i",
			"specularMap": "textures/specular/$i",
			"normalMap": "textures/normal/$i",
EOF
	# Handle emission map if exists
	emimap="${i%.*}"
	emimap=`ls "emission/$emimap."* 2>/dev/null`
	if [ $? -eq 0 ]; then
		cat << EOF >> "$FILE"
			"emissionMap": "textures/$emimap",
			"emissive": 0.75,
EOF
	fi
	# Handle height map if exists
	heimap="${i%.*}"
	heimap=`ls "height/$heimap."* 2>/dev/null`
	if [ $? -eq 0 ]; then
		cat << EOF >> "$FILE"
			"heightMap": "textures/$heimap",
			"parallax": 0.03,
EOF
	fi

cat << EOF >> "$FILE"
			"uvRepeat": 1
		},
		"geometry": "debug/sphere.obj",
		"position": [ $X, -0.25, $Y ],
		"scale": 0.75
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

