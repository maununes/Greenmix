#!/bin/bash
# Greenmix iFood — Monitor de Atualização do Dashboard
# Duplo-clique para iniciar. Deixe esta janela aberta.

PASTA="$HOME/Desktop/TesteClaude"
SCRIPT="$PASTA/gerar_dashboard.py"
LOG="$PASTA/monitorar.log"

clear
echo "╔══════════════════════════════════════════════════════╗"
echo "║       GREENMIX · Monitor Dashboard iFood            ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "📁 Pasta monitorada: $PASTA"
echo "📊 Dashboard:        $PASTA/dashboard_greenmix.html"
echo ""
echo "✅ Monitorando... Deixe esta janela aberta."
echo "   Qualquer .xlsx novo na pasta atualiza o dashboard."
echo ""
echo "──────────────────────────────────────────────────────"

ULTIMO_HASH=""

while true; do
    ARQUIVO=$(ls -t "$PASTA"/*.xlsx "$PASTA"/*.xls 2>/dev/null | grep -v '~\$' | head -1)

    if [ -n "$ARQUIVO" ]; then
        HASH=$(md5 -q "$ARQUIVO" 2>/dev/null)

        if [ "$HASH" != "$ULTIMO_HASH" ]; then
            TS=$(date '+%H:%M:%S')
            echo "[$TS] 🔄 Novo arquivo: $(basename "$ARQUIVO")"
            python3 "$SCRIPT" "$ARQUIVO" "$PASTA" 2>/dev/null

            if [ $? -eq 0 ]; then
                echo "[$TS] ✅ Dashboard atualizado!"
                open "$PASTA/dashboard_greenmix.html"
            else
                echo "[$TS] ❌ Erro ao gerar dashboard. Verifique o arquivo."
            fi
            ULTIMO_HASH="$HASH"
        fi
    fi

    sleep 30
done
