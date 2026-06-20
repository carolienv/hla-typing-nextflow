#!/usr/bin/env bash
set -euo pipefail

OUTFILE="combined_optitype_results.tsv"

echo "Collecting OptiType result files..."
echo "sample	$(head -n 1 "$1" | cut -f2-)" > "$OUTFILE"

for result_file in "$@"; do
    sample=$(basename "$result_file" _result.tsv)

    tail -n +2 "$result_file" | while IFS= read -r line; do
        echo -e "${sample}\t$(echo "$line" | cut -f2-)"
    done >> "$OUTFILE"
done

echo "Written: $OUTFILE"