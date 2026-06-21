#!/bin/bash
# 1. Dinh nghia ten file du lieu
FILE_DATA="file.txt"
INVOICE_FILE="invoices.txt"

# 2. KIEM TRA DIEU KIEN DAU VAO
if [ ! -f "$FILE_DATA" ]; then
    echo "Loi: Khong tim thay file du lieu $FILE_DATA!"
    exit 1
fi
if [ ! -s "$FILE_DATA" ]; then
    echo "-> Kho dang trong."
    exit 0
fi

# 3. HAM SINH MA HOA DON TU DONG (HD001, HD002, ...)
sinh_ma_hoa_don() {
    if [ ! -s "$INVOICE_FILE" ]; then
        echo "HD001"
        return
    fi
    last=$(grep -oE '^HD[0-9]+' "$INVOICE_FILE" | grep -oE '[0-9]+' | sort -n | tail -1)
    [ -z "$last" ] && last=0
    printf "HD%03d\n" $((last + 1))
}

# 4. HAM BAN CD
ban_cd() {
    echo -n "Nhap ma CD can ban: "
    read -r maCD
    maCD=$(echo "$maCD" | tr '[:lower:]' '[:upper:]')

    dong=$(grep "^${maCD}|" "$FILE_DATA")
    if [ -z "$dong" ]; then
        echo "Khong tim thay CD co ma '$maCD'!"
        return
    fi

    # Thu tu cot: maCD|tenCD|tenTG|the_loai|gia|ds_bai_hat
    tenCD=$(echo "$dong" | cut -d'|' -f2)
    gia=$(echo "$dong" | cut -d'|' -f5)

    echo "Ten CD : $tenCD"
    echo "Gia ban: $gia VND"

    while true; do
        echo -n "Nhap so luong can ban: "
        read -r so_luong
        if [[ "$so_luong" =~ ^[0-9]+$ ]] && [ "$so_luong" -gt 0 ]; then
            break
        fi
        echo "So luong phai la so nguyen duong!"
    done

    echo -n "Nhap ten khach hang: "
    read -r ten_kh
    if [ -z "$ten_kh" ]; then
        echo "Ten khach hang khong duoc de trong!"
        return
    fi

    thanh_tien=$((gia * so_luong))
    ma_hd=$(sinh_ma_hoa_don)
    ngay_ban=$(date +"%d/%m/%Y")

    echo "${ma_hd}|${ngay_ban}|${ten_kh}|${maCD}|${tenCD}|${so_luong}|${gia}|${thanh_tien}" >> "$INVOICE_FILE"

    echo "Da ban thanh cong $so_luong dia CD $maCD. Ma hoa don: $ma_hd"
}

# 5. HAM IN HOA DON BAN HANG
in_hoa_don() {
    if [ ! -s "$INVOICE_FILE" ]; then
        echo "Chua co hoa don nao."
        return
    fi

    echo -n "Nhap ma hoa don can in (de trong = hoa don gan nhat): "
    read -r ma_hd_can_in

    if [ -z "$ma_hd_can_in" ]; then
        ma_hd_can_in=$(tail -n 1 "$INVOICE_FILE" | cut -d'|' -f1)
    fi

    dong=$(grep "^${ma_hd_can_in}|" "$INVOICE_FILE")
    if [ -z "$dong" ]; then
        echo "Khong tim thay hoa don '$ma_hd_can_in'."
        return
    fi

    IFS='|' read -r ma_hd ngay ten_kh maCD tenCD so_luong gia thanh_tien <<< "$dong"

    echo "=========================================="
    echo "          HOA DON BAN HANG"
    echo "=========================================="
    echo "Ma hoa don : $ma_hd"
    echo "Ngay lap   : $ngay"
    echo "Khach hang : $ten_kh"
    echo "Ma CD      : $maCD"
    echo "Ten CD     : $tenCD"
    echo "So luong   : $so_luong"
    echo "Don gia    : $gia VND"
    echo "Thanh tien : $thanh_tien VND"
    echo "=========================================="
}

# 6. HIEN THI MENU CHINH
menu_chinh() {
    while true; do
        echo "=== MENU BAN HANG ==="
        echo "1. Ban CD"
        echo "2. In hoa don ban hang"
        echo "0. Thoat chuong trinh"
        echo "--------------------------------------------------------"
        echo -n "Nhap lua chon cua ban (0-2): "
        read -r lua_chon
        echo "--------------------------------------------------------"

        # 7. XU LY LOGIC THEO LUA CHON
        if ! [[ "$lua_chon" =~ ^[0-9]+$ ]]; then
            echo "Lua chon khong hop le!"
        elif [ "$lua_chon" -eq 1 ]; then
            ban_cd
        elif [ "$lua_chon" -eq 2 ]; then
            in_hoa_don
        elif [ "$lua_chon" -eq 0 ]; then
            echo "Tam biet!"
            exit 0
        else
            echo "Lua chon khong hop le!"
        fi
        echo
    done
}

# 8. CHAY CHUONG TRINH
menu_chinh