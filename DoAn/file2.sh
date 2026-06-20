#!/bin/bash

# 1. Định nghĩa tên file dữ liệu chứa kho CD
FILE_DATA="file.txt"

# 2. KIỂM TRA ĐIỀU KIỆN ĐẦU VÀO
if [ ! -f "$FILE_DATA" ]; then
    echo "Loi: Khong tim thay file du lieu $FILE_DATA!"
    exit 1
fi

if [ ! -s "$FILE_DATA" ]; then
    echo "-> Kho dang trong."
    exit 0
fi

# 3. HIỂN THỊ MENU PHỤ
echo "=== MENU HIEN THI ==="
echo "1. Xem ngan gon"
echo "2. Xem day du"
echo -n "Nhap lua chon cua ban (1-2): "
read -r lua_chon

echo "--------------------------------------------------------"

# 4. XỬ LÝ LOGIC HIỂN THỊ THEO LỰA CHỌN
if [ "$lua_chon" -eq 1 ]; then
    # ==========================================================
    # CHẾ ĐỘ 1: XEM NGẮN GỌN (Dạng bảng 3 cột)
    # ==========================================================
    printf "%-12s | %-25s | %-12s\n" "Ma CD" "Ten CD" "Gia"
    echo "--------------------------------------------------------"
   
    #Thứ tự biến phải khớp với thứ tự cột trong file dữ liệu
    while IFS="|" read -r maCD tenCD tenTG the_loai gia ds_bai_hat
    do
        [ -z "$maCD" ] && continue
        
        # Gọi dấu $ theo tên biến mới
        printf "%-12s | %-25s | %-12s\n" "$maCD" "$tenCD" "$gia"
        
    done < "$FILE_DATA"
    echo "--------------------------------------------------------"

elif [ "$lua_chon" -eq 2 ]; then
    # ==========================================================
    # CHẾ ĐỘ 2: XEM ĐẦY ĐỦ (Echo ra bình thường từng dòng)
    # ==========================================================
    stt=1
    
    # Đổi tên biến trong lệnh read tương tự chế độ 1
    while IFS="|" read -r maCD tenCD tenTG the_loai gia ds_bai_hat
    do
        [ -z "$maCD" ] && continue
        
        echo "--- CD #$stt ---"
        echo "Ma so: $maCD"
        echo "Ten CD: $tenCD"
        echo "The loai: $the_loai"
        echo "Tac gia: $tenTG"
        echo "Gia ban: $gia"
        echo "Danh sach bai hat:"
        
        if [ -z "$ds_bai_hat" ]; then
            echo "  (Khong co bai hat)"
        else
            # Tách các bài hát bằng cách đổi dấu phẩy ',' thành xuống dòng
            echo "$ds_bai_hat" | tr ',' '\n' | while read -r song
            do
                song=$(echo "$song" | sed 's/^[[:space:]]*//')
                echo "  - $song"
            done
        fi
        echo "-------------------------"
        ((stt++))
        
    done < "$FILE_DATA"

else
    echo "Lua chon khong hop le!"
fi