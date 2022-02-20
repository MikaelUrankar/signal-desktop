env SIGNAL_ENV=production \
yarn run electron-builder \
                        --linux --dir --config.npmRebuild=false \
                        --config.electronVersion=16 \
                        --config.electronDist=/home/miki/.cache/electron/usr/local/share/electron16
