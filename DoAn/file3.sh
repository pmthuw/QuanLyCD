#!/bin/bash
# 1. Dinh nghia ten file du lieu chua kho CD
FILE_DATA="file.txt"

# 2. KIEM TRA DIEU KIEN DAU VAO
if [ ! -f "$FILE_DATA" ]; then
    echo "Loi: Khong tim thay file du lieu $FILE_DATA!"
    return 1
fi
if [ ! -s "$FILE_DATA" ]; then
    echo "-> Kho dang trong."
    exit 0
fi

# 3. HAM TIM KIEM CD THEO THE LOAI
tim_cd_the_loai() {
    echo -n "Nhap the loai can tim: "
    read -r the_loai_tim
    if [ -z "$the_loai_tim" ]; then
        echo "The loai khong duoc de trong!"
        return
    fi
    the_loai_tim_lc=$(echo "$the_loai_tim" | tr '[:upper:]' '[:lower:]')
    found=0

    printf "%-10s | %-25s | %-20s | %-15s | %10s\n" "Ma CD" "Ten CD" "Tac gia" "The loai" "Gia"
    echo "--------------------------------------------------------"

    # Thu tu bien phai khop voi thu tu cot trong file du lieu
    while IFS="|" read -r maCD tenCD tenTG the_loai gia ds_bai_hat
    do
        [ -z "$maCD" ] && continue

        the_loai_lc=$(echo "$the_loai" | tr '[:upper:]' '[:lower:]')
        case "$the_loai_lc" in
            *"$the_loai_tim_lc"*)
                printf "%-10s | %-25s | %-20s | %-15s | %10s\n" "$maCD" "$tenCD" "$tenTG" "$the_loai" "$gia"
                found=1
                ;;
        esac
    done < "$FILE_DATA"

    echo "--------------------------------------------------------"
    if [ "$found" -eq 0 ]; then
        echo "Khong tim thay CD nao co the loai '$the_loai_tim'."
    fi
}

# 4. HAM TIM KIEM CD THEO TAC GIA
tim_cd_tac_gia() {
    echo -n "Nhap tac gia can tim: "
    read -r tac_gia_tim
    if [ -z "$tac_gia_tim" ]; then
        echo "Tac gia khong duoc de trong!"
        return
    fi
    tac_gia_tim_lc=$(echo "$tac_gia_tim" | tr '[:upper:]' '[:lower:]')
    found=0

    printf "%-10s | %-25s | %-20s | %-15s | %10s\n" "Ma CD" "Ten CD" "Tac gia" "The loai" "Gia"
    echo "--------------------------------------------------------"

    # Thu tu bien phai khop voi thu tu cot trong file du lieu
    while IFS="|" read -r maCD tenCD tenTG the_loai gia ds_bai_hat
    do
        [ -z "$maCD" ] && continue

        tenTG_lc=$(echo "$tenTG" | tr '[:upper:]' '[:lower:]')
        case "$tenTG_lc" in
            *"$tac_gia_tim_lc"*)
                printf "%-10s | %-25s | %-20s | %-15s | %10s\n" "$maCD" "$tenCD" "$tenTG" "$the_loai" "$gia"
                found=1
                ;;
        esac
    done < "$FILE_DATA"

    echo "--------------------------------------------------------"
    if [ "$found" -eq 0 ]; then
        echo "Khong tim thay CD nao co tac gia '$tac_gia_tim'."
    fi
}

# 5. HAM TIM KIEM CD THEO TEN BAI HAT
tim_cd_bai_hat() {
    echo -n "Nhap ten bai hat can tim: "
    read -r bai_hat_tim
    if [ -z "$bai_hat_tim" ]; then
        echo "Ten bai hat khong duoc de trong!"
        return
    fi
    bai_hat_tim_lc=$(echo "$bai_hat_tim" | tr '[:upper:]' '[:lower:]')
    found=0

    # Thu tu bien phai khop voi thu tu cot trong file du lieu
    while IFS="|" read -r maCD tenCD tenTG the_loai gia ds_bai_hat
    do
        [ -z "$maCD" ] && continue
        [ -z "$ds_bai_hat" ] && continue

        match_list=()
        # Tach cac bai hat bang cach doi dau phay ',' thanh tung phan tu
        IFS=',' read -r -a songs <<< "$ds_bai_hat"
        for song in "${songs[@]}"; do
            song=$(echo "$song" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            song_lc=$(echo "$song" | tr '[:upper:]' '[:lower:]')
            case "$song_lc" in
                *"$bai_hat_tim_lc"*) match_list+=("$song") ;;
            esac
        done

        if [ ${#match_list[@]} -gt 0 ]; then
            echo "--- $maCD ---"
            echo "Ten CD: $tenCD"
            echo "Tac gia: $tenTG"
            echo "The loai: $the_loai"
            echo "Bai hat khop:"
            for song in "${match_list[@]}"; do
                echo "  - $song"
            done
            echo "-------------------------"
            found=1
        fi
    done < "$FILE_DATA"

    if [ "$found" -eq 0 ]; then
        echo "Khong tim thay CD nao chua bai hat '$bai_hat_tim'."
    fi
}

# 6. HIEN THI MENU TIM KIEM
menu_tim_kiem() {
    while true; do
        echo "=== MENU TIM KIEM CD ==="
        echo "1. Tim kiem CD theo the loai"
        echo "2. Tim kiem CD theo tac gia"
        echo "3. Tim kiem CD theo ten bai hat"
        echo "0. Thoat chuong trinh"
        echo "--------------------------------------------------------"
        echo -n "Nhap lua chon cua ban (0-3): "
        read -r lua_chon
        echo "--------------------------------------------------------"

        # 7. XU LY LOGIC THEO LUA CHON
        if ! [[ "$lua_chon" =~ ^[0-9]+$ ]]; then
            echo "Lua chon khong hop le!"
        elif [ "$lua_chon" -eq 1 ]; then
            tim_cd_the_loai
        elif [ "$lua_chon" -eq 2 ]; then
            tim_cd_tac_gia
        elif [ "$lua_chon" -eq 3 ]; then
            tim_cd_bai_hat
        elif [ "$lua_chon" -eq 0 ]; then
            return
        else
            echo "Lua chon khong hop le!"
        fi
        echo
    done
}
