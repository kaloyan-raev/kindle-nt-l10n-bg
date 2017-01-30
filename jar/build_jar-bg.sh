LANG_CODE=bg_BG
export JAVAC=/home/kraev/Downloads/jdk1.7.0_51/bin/javac
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

echo ===MobiReader===================================================
mkdir -p MobiReader/META-INF
cp src/Meta-inf/MobiReader/* MobiReader/META-INF

mkdir -p MobiReader/com/amazon/ebook/booklet/reader/resources
cp src/ReaderResources_bg_BG.java ReaderResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 ReaderResources_bg_BG.java
mv ReaderResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/reader/resources

mkdir -p MobiReader/com/amazon/ebook/booklet/reader/gui/resources
cp src/BookGUIUtilResources_pref_bg_BG.java BookGUIUtilResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 BookGUIUtilResources_bg_BG.java
mv BookGUIUtilResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/reader/gui/resources

mkdir -p MobiReader/com/amazon/ebook/booklet/reader/gui/infobox/resources
cp src/SupplementaryInfoBoxResources_bg_BG.java SupplementaryInfoBoxResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 SupplementaryInfoBoxResources_bg_BG.java
mv SupplementaryInfoBoxResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/reader/gui/infobox/resources

mkdir -p MobiReader/com/amazon/ebook/booklet/reader/gui/view/pagecontentview/resources
cp src/FullScreenReadingViewResources_pref_bg_BG.java FullScreenReadingViewResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 FullScreenReadingViewResources_bg_BG.java
mv FullScreenReadingViewResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/reader/gui/view/pagecontentview/resources

cp src/ReadingModeViewResources_pref_bg_BG.java ReadingModeViewResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 ReadingModeViewResources_bg_BG.java
mv ReadingModeViewResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/reader/gui/view/pagecontentview/resources

mkdir -p MobiReader/com/amazon/ebook/booklet/pdfreader/impl/resources
cp src/PDFResources_bg_BG.java PDFResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 PDFResources_bg_BG.java
mv PDFResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/pdfreader/impl/resources

mkdir -p MobiReader/com/amazon/ebook/booklet/reader/gui/overlay/cursoroptions/resources
cp src/CursorOptionsResources_bg_BG.java CursorOptionsResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 CursorOptionsResources_bg_BG.java
mv CursorOptionsResources_bg_BG.class MobiReader/com/amazon/ebook/booklet/reader/gui/overlay/cursoroptions/resources

cd MobiReader
7za a -r -tzip MobiReader com META-INF
cd ..
mv MobiReader/MobiReader.zip ../loc_hack/src/MobiReader-bg_BG.jar

#echo ===framework-impl===============================================

#mkdir -p framework-impl/META-INF
#cp src/Meta-inf/framework-impl/* framework-impl/META-INF

#mkdir -p framework-impl/com/amazon/ebook/framework/impl/resources
#cp src/StatusBarResources_bg_BG.java StatusBarResources_bg_BG.java
#$JAVAC -target 1.4 -source 1.4 StatusBarResources_bg_BG.java
#mv StatusBarResources_bg_BG.class framework-impl/com/amazon/ebook/framework/impl/resources

#cd framework-impl
#7za a -r -tzip framework-impl com META-INF
#cd ..
#mv framework-impl/framework-impl.zip ../loc_hack/src/framework-impl-bg_BG.jar

echo ===framework-api================================================

mkdir -p framework-api/META-INF
cp src/Meta-inf/framework-api/* framework-api/META-INF

mkdir -p framework-api/com/amazon/ebook/framework/resources
cp src/UIResources_pref_bg_BG.java UIResources_bg_BG.java
$JAVAC -target 1.4 -source 1.4 UIResources_bg_BG.java
mv UIResources_bg_BG.class framework-api/com/amazon/ebook/framework/resources

cd framework-api
7za a -r -tzip framework-api com META-INF
cd ..
mv framework-api/framework-api.zip ../loc_hack/src/framework-api-bg_BG.jar

echo ===clean dir====================================================
rm -rf framework-impl
rm -rf framework-api
rm -rf MobiReader
rm *.java
