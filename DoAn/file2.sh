#!/bin/bash

# 1. Định nghĩa tên file dữ liệu chứa kho CD
FILE_DATA="file.txt"
#Hiện thị menu
menu_hien_thi() {
    # 2. KIỂM TRA ĐIỀU KIỆN ĐẦU VÀO
    if [ ! -f "$FILE_DATA" ]; then
        echo "Loi: Khong tim thay file du lieu $FILE_DATA!"
        exit 1
    fi

    if [ ! -s "$FILE_DATA" ]; then
        echo "-> Kho dang trong."
        exit 0
    fi
    
    echo "=== MENU HIEN THI ==="
    echo "1. Xem ngan gon"
    echo "2. Xem day du"
    echo "0. Thoat"
    echo -n "Nhap lua chon cua ban (0-2): "
    read -r lua_chon

    echo "--------------------------------------------------------"

    if [ "$lua_chon" -eq 1 ]; then

        printf "%-12s | %-25s | %-12s | %-8s\n" \
        "Ma CD" "Ten CD" "Gia" "Ton kho"

        echo "--------------------------------------------------------"

        while IFS="|" read -r maCD tenCD tenTG the_loai gia ton_kho ds_bai_hat
        do
            [ -z "$maCD" ] && continue

            printf "%-12s | %-25s | %-12s | %-8s\n" \
            "$maCD" "$tenCD" "$gia" "$ton_kho"

        done < "$FILE_DATA"

        echo "--------------------------------------------------------"

    elif [ "$lua_chon" -eq 2 ]; then

        stt=1

        while IFS="|" read -r maCD tenCD tenTG the_loai gia ton_kho ds_bai_hat
        do
            [ -z "$maCD" ] && continue

            echo "--- CD #$stt ---"
            echo "Ma so: $maCD"
            echo "Ten CD: $tenCD"
            echo "The loai: $the_loai"
            echo "Tac gia: $tenTG"
            echo "Gia ban: $gia"
            echo "So luong ton kho: $ton_kho"
            echo "Danh sach bai hat:"

            if [ -z "$ds_bai_hat" ]; then
                echo "  (Khong co bai hat)"
            else
                echo "$ds_bai_hat" | tr ',' '\n' | while read -r song
                do
                    song=$(echo "$song" | sed 's/^[[:space:]]*//')
                    echo "  - $song"
                done
            fi

            echo "-------------------------"
            ((stt++))

        done < "$FILE_DATA"

    elif [ "$lua_chon" -eq 0 ]; then
        return

    else
        echo "Lua chon khong hop le!"
    fi
}

