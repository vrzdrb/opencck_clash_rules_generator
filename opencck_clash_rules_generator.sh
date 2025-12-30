#!/bin/bash

echo "Что вы хотите сгенерировать?"
echo "1) Домены (DOMAIN-SUFFIX)"
echo "2) CIDR (IP-CIDR)"
echo -n "Введите 1 или 2: "
read USER_CHOICE

if [[ "$USER_CHOICE" == "1" ]]; then

    # URL для получения списка доменов в формате ClashX/Surge
    DOMAIN_LIST_URL="https://iplist.opencck.org/?format=clashx&data=domains&append=timeout%3D1d%22%20mode=https%20dst-path=domains.rsc"

    # Имя выходного файла
    OUTPUT_FILE="domain_clash_rules.yaml"

    echo "---Загрузка доменов...---"

    # Загрузка данных с помощью curl
    DOMAIN_DATA=$(curl -sL "$DOMAIN_LIST_URL")

    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: Не удалось загрузить данные с URL."
        exit 1
    fi

    echo "✅ Данные успешно загружены."

    # Извлечение строк вида DOMAIN-SUFFIX,<domain> и добавление "  - " в начало
    GENERATED_RULES=$(echo "$DOMAIN_DATA" | \
        awk -F, '
            /^(DOMAIN-SUFFIX|DOMAIN),/ {
                print "  - "$1","$2""
            }
        ' | \
        sort -u) 

    # Запись в файл
    (echo "payload:"; echo "$GENERATED_RULES") > "$OUTPUT_FILE"

    # Вывод результата
    RULE_COUNT=$(echo "$GENERATED_RULES" | wc -l)
    echo "✅ Сгенерировано $RULE_COUNT уникальных правил."
    echo "✅ Правила сохранены в файл: $OUTPUT_FILE"
    echo "--- Готово ---"

    # Первые 5 правил для проверки
    echo ""
    echo "Первые 5 сгенерированных правил:"
    echo "$GENERATED_RULES" | head -n 5

elif [[ "$USER_CHOICE" == "2" ]]; then

    # URL для загрузки списка CIDR-ов.
    IPCIDR_LIST_URL="https://iplist.opencck.org/?format=clashx&data=cidr4&append=timeout%3D1d%22%20mode=https%20dst-path=cidr4.rsc"

    # Имя выходного файла
    OUTPUT_FILE="IP-CIDR_clash_rules.yaml"

    echo "--- Загрузка IP-CIDR... ---"

    # Загрузка данных с помощью curl
    IPCIDR_DATA=$(curl -sL "$IPCIDR_LIST_URL")

    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: Не удалось загрузить данные с URL."
        exit 1
    fi

    echo "✅ Данные успешно загружены."

    # Извлечение строк вида IP-CIDR,<cidr> и добавление "  - " в начало
    GENERATED_RULES=$(echo "$IPCIDR_DATA" | \
        awk -F, '
            /^(IP-CIDR|CIDR),/ {
                print "  - "$1","$2""
            }
        ' | \
        sort -u) 

    # Запись в файл
    (echo "payload:"; echo "$GENERATED_RULES") > "$OUTPUT_FILE"

    #. Вывод результата
    RULE_COUNT=$(echo "$GENERATED_RULES" | wc -l)
    echo "✅ Сгенерировано $RULE_COUNT уникальных правил."
    echo "✅ Правила сохранены в файл: $OUTPUT_FILE"
    echo "--- Готово ---"

    # Первые 5 правил для проверки
    echo ""
    echo "Первые 5 сгенерированных правил:"
    echo "$GENERATED_RULES" | head -n 5

else
    # 4. Обработка неверного ввода
    echo "❌ Неверный ввод. Пожалуйста, введите 1 или 2."
    exit 1
fi
