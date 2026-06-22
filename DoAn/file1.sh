#!/bin/bash

#Hàm thêm CD mới vào hệ thống (maCD|tenCD|tenTG)
ThemCD() {
    while true 
        do 
            echo "Hãy nhập mã CD:"
            read maCD

            #Kiểm tra mã CD có bị trùng không
            if grep -q "^$maCD|" file.txt  
                then echo "Mã CD đã có trong hệ thống.Hãy nhập lại mã."
            else 
                echo "Mã CD hợp lệ."
                break
            fi
        done
        
        echo "Hãy nhập tên CD:"
        read tenCD

        echo "Hãy nhập tên tác giả:"
        read tenTG
}

#Hàm cập nhật thông tin bổ sung của CD vào hệ thống (the_loại|gia|ds_bai_hat)
ThemThongTinCD() {
    echo "Nhập mã CD cần thêm thông tin:"
    read maCD

    #Kiểm tra mã CD có được lưu ở hệ thông chưa
    if grep -q "^$maCD|" file.txt
        then echo "Tồn tại mã CD trong hệ thống."
    else
        echo "Không tìm thấy mã CD trong hệ thống."
        return
    fi

    echo "Hãy nhập thể loại CD:"
    read the_loai
    
    while true
        do
            echo "Hãy nhập giá tiền CD:"
            read gia

            #Kiểm tra giá phải là số thứ tự
            if [[ "$gia" =~ ^[0-9]+$ ]]
                then echo "Giá hợp lệ"
                break
            else
                echo "Giá không hợp lệ. Hãy nhập lại giá."
            fi
        done
    
    while true
        do
            echo "Hãy nhập số lượng tồn kho:"
            read ton_kho
            
            #Cho phép số lượng phải là số thứ tự
            if [[ "$ton_kho" =~ ^[0-9]+$ ]]
                then echo "Số lượng hợp lệ."
            break
            else
                echo "Số lượng không hợp lệ. Hãy nhập lại."
            fi
        done

    echo "Hãy nhập danh sách bài hát của CD:"
    read ds_bai_hat
}

menu_file1() {
    echo "-------------CHUC NANG QUAN LY CD-------------"
    echo "1. Them CD"
    echo "2. Them thong tin CD"
    echo "0. Thoat"

    read -p "Nhap lua chon: " Chon

    case $Chon in
        1)
            ThemCD
            echo "$maCD|$tenCD|$tenTG| | | |" >> file.txt
            echo "Da luu vao he thong."
        ;;

        2)
            ThemThongTinCD

            tenCD=$(grep "^$maCD|" file.txt | cut -d "|" -f2)
            tenTG=$(grep "^$maCD|" file.txt | cut -d "|" -f3)

            grep -v "^$maCD|" file.txt > temp.txt

            echo "$maCD|$tenCD|$tenTG|$the_loai|$gia|$ton_kho|$ds_bai_hat" >> temp.txt

            mv temp.txt file.txt

            echo "Cap nhat thong tin thanh cong."
        ;;

        0)
            return
        ;;

        *)
            echo "Lua chon khong hop le."
        ;;
    esac
}
