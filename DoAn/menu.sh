#!/bin/bash

source file1.sh
source file2.sh
source file3.sh
source file4.sh

while true; do
    clear
    echo "========================================================"
    echo "          CHƯƠNG TRÌNH QUẢN LÝ CỬA HÀNG CD"
    echo "========================================================"
    echo "1. Thêm CD & Cập nhật thông tin"
    echo "2. Hiển thị danh sách kho CD"
    echo "3. Tìm kiếm CD"
    echo "4. Bán hàng & In hóa đơn"
    echo "0. Thoát chương trình"
    echo "========================================================"
    echo -n "Nhập lựa chọn của bạn (0-4): "
    read -r lua_chon

    case $lua_chon in
        1)
            menu_file1
        ;;

        2)
            menu_hien_thi
        ;;

        3)
            menu_tim_kiem
        ;;

        4)
            menu_ban_hang
        ;;
        
        0)
            echo "Đã thoát chương trình. Tạm biệt!"
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại!"
            ;;
    esac

    echo ""
    echo -n "Nhấn Enter để quay lại Menu Chính..."
    read -r
done


