LANG_CODE=bg

echo ===MobiReader===================================================
mkdir -p MobiReader/META-INF
cp src/Meta-inf/MobiReader/* MobiReader/META-INF

mkdir -p MobiReader/com/amazon/ebook/booklet/reader/gui/overlay/cursoroptions/resources
cp src/CursorOptionsResources_${LANG_CODE}.java CursorOptionsResources_${LANG_CODE}.java
javac -target 1.4 -source 1.4 CursorOptionsResources_${LANG_CODE}.java
mv CursorOptionsResources_${LANG_CODE}.class MobiReader/com/amazon/ebook/booklet/reader/gui/overlay/cursoroptions/resources

cd MobiReader
7za a -r -tzip MobiReader com META-INF
cd ..
mv MobiReader/MobiReader.zip ../loc_hack/src/MobiReader-${LANG_CODE}.jar

echo ===clean dir====================================================
rm -rf MobiReader
rm *.java
