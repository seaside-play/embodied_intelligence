tar -xvzf ./clash_2.0.24_linux_amd64.tar
sudo mv clash /usr/local/bin/
clash # 在~/.config/clash生成3个文件cache.db config.yaml Country.mmdb
# 6. 将从 Windows 下拿到的 Country.mmdb 替换掉 ~/.config/clash 目录下的 Country.mmdb
# 7. 将从 Windows 下拿到的 xxxxxxxx.yml 中的内容，完全复制进 ~/.config/clash 目录下的 config.yaml，原 config.yaml 中只有一行内容，可以直接删除，完成复制后的内容如下

