. config
#remove old resources
rm -rf translation_4.1.1/source/com
rm -rf translation_4.1.1/translation/com
rm -rf translation_4.1.1/translation_jar/
rm -rf translation_4.1.1/translation_unfinished/
rm kindle_loc.sqlite

echo =create sqlite DB=
cp strings_4.1.1/string_4.1.1.sql kindle_loc.sql
echo change ===version===
sed -i "s/#VERSION#/${VERSION}/g" kindle_loc.sql
cat kindle_loc.sql | sqlite3 kindle_loc.sqlite
rm kindle_loc.sql

sqlite3 -header -csv kindle_loc.sqlite "select * from trans;" > strings_4.1.1/table.csv
cd jar && ./build_jar-bg.sh
cd ..
echo ===sqlite2source===
./sqlite2source
./sqlite2translation
./translation2transjar
./build-hack
