readme

$ ./build.sh         �ɂ�  gonbe.img  ���쐬�����

�\�[�X�t�@�C��
    boot_loader.nasm        16bit �A�b�Z���u���A����P�̂łP�̃o�C�i���t�@�C�������
    os_start.nasm           32bit �A�b�Z���u���AOS �̓�
    gonbe_main.c            OS �{��

gonbe.img �� 1440KByte �Ńt���b�s�B�C���[�W�ł���

gonge.img: 0�`0x400         boot_loader  0x7c00�`0x7e00 �Ԓn�Ƀ��[�h����Ď��s�����, �㔼�� 512�o�C�g�� boot_loader �ɂă��[�h�����
           0x400�`0x800     os_start     0x8000�`0x8400 �Ԓn�Ƀ��[�h�����
           0x800�`90KB      gonbe_main   0x8400�`       �Ƀ��[�h����� 0x00280000 �ֈړ����Ď��s����A���߂̓Z�O�����g�擪��0x00280000 �Ԓn�œ������A���ɐ擪�� 0�Ԓn�ɂ��Ď��s����
