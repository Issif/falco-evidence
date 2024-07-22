#!/bin/bash

download_csv() {
    curl -s -H "Authorization: Bearer ${SCARF_TOKEN}" "https://api.scarf.sh/v2/packages/falco/${1}/events?start_date=${2}&end_date=${2}" > data.csv
}

import_data() {
    duckdb scarf.duckdb < insert.sql
}

for i in {01..90};
do
    DATE=$(date -d "-${i} day" "+%Y-%m-%d")

    # kmod
    echo "--- KMOD - ${DATE} ---"
    echo "download the .csv"
    download_csv 7c6ee869-0db4-4dbb-8a20-cf9f7bdfc1c5 ${DATE}
    echo "import the data into duckdb"
    import_data

    # ebpf
    echo "--- EBPF - ${DATE} ---"
    echo "download the .csv"
    download_csv 861b0e1b-7ae8-4fa9-ad51-890367152196 ${DATE}
    echo "import the data into duckdb"
    import_data
done