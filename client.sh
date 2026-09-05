cd ../OneLifeData7
git checkout custom

cd ../miniOneLifeCompile
./cleanOldBuildsAndOptionallyCaches.sh 1
./compile.sh && (
cd ..

cp clientSettings/* output/settings
rm -r client
mv output client
)