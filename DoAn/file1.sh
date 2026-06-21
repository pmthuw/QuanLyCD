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
            read so_luong
            
            #Cho phép số lượng phải là số thứ tự
            if [[ "$so_luong" =~ ^[0-9]+$ ]]
                then echo "Số lượng hợp lệ."
            break
            else
                echo "Số lượng không hợp lệ. Hãy nhập lại."
            fi
        done

    echo "Hãy nhập danh sách bài hát của CD:"
    read ds_bai_hat
}

#Hiện thị Menu chọn 1 trong 2
echo "-------------Chọn 1 trong 2-------------"
echo "1.Thêm CD"
echo "2.ThemThongTinCD"

read Chon  #Nhập lựa chọn 1 hoặc 2

#Menu chọn
case $Chon in
    1) 
        ThemCD
        echo "$maCD|$tenCD|$tenTG| | |" >> file.txt  # Lưu CD vào file.txt
        echo "Đã lưu vào hệ thống."
    ;;

    2) 
        ThemThongTinCD
        
        #Lấy thông tin CD ở cột 2 và 3
        tenCD=$(grep "^$maCD|" file.txt | cut -d "|" -f 2)
        tenTG=$(grep "^$maCD|" file.txt | cut -d "|" -f 3)

        #Xóa dòng có mã đã nhập 
        grep -v "^$maCD|" file.txt > temp.txt

        #Tạo dòng có mã đã nhập và cập nhật thông tin đầy đủ
        echo "$maCD|$tenCD|$tenTG|$the_loai|$gia|$so_luong|$ds_bai_hat" >> temp.txt

        #Đổi tên và cập nhật thành công
        mv temp.txt file.txt
        echo "Cập nhật thông tin thành công."
    ;;
esac
