cd ../OneLifeData7
git checkout custom

cd ../miniOneLifeCompile
./cleanOldBuildsAndOptionallyCaches.sh 1
./compile.sh && (
cd ..

if [ -d "client" ]; then
    cp client/settings/* output/settings
    cp client/settings/* clientSettings
else
    cp clientSettings/* output/settings
fi

rm -rf client
mv output client
cp -r custom-sprites/all/* client/sprites
)