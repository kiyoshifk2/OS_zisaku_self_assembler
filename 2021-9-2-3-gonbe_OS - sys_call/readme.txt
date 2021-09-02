readme

$ ./build.sh         にて  gonbe.img  が作成される

ソースファイル
    boot_loader.nasm        16bit アッセンブラ、これ単体で１つのバイナリファイルを作る
    os_start.nasm           32bit アッセンブラ、OS の頭
    gonbe_main.c            OS 本体

gonbe.img は 1440KByte でフロッピィイメージである

gonge.img: 0～0x400         boot_loader  0x7c00～0x7e00 番地にロードされて実行される, 後半の 512バイトは boot_loader にてロードされる
           0x400～0x800     os_start     0x8000～0x8400 番地にロードされる
           0x800～90KB      gonbe_main   0x8400～       にロードされて 0x00280000 へ移動して実行する、初めはセグメント先頭を0x00280000 番地で動かす、次に先頭を 0番地にして実行する
