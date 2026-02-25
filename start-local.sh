#!/bin/bash
# 本地启动服务：1) 可选执行一次爬虫 2) Web 报告服务(8080) 3) MCP 服务(3333)
cd "$(dirname "$0")"

echo "TrendRadar 本地服务"
echo ""

# 1. 执行一次爬虫（可选，生成/更新 output）
if [ "$1" = "run" ] || [ "${RUN_CRAWLER:-0}" = "1" ]; then
  echo "[1/2] 执行爬虫..."
  uv run python -m trendradar || exit 1
  echo ""
fi

# 2. Web 报告服务 8080
if [ ! -d "output" ]; then
  echo "⚠ output/ 不存在，先执行一次爬虫: ./start-local.sh run"
  mkdir -p output
fi
echo "[*] 启动 Web 报告: http://localhost:8080 (目录 output/)"
python3 -m http.server 8080 --directory output --bind 127.0.0.1 &
WEB_PID=$!
echo "    PID: $WEB_PID"

# 3. MCP 服务 3333
echo "[*] 启动 MCP: http://localhost:3333/mcp"
uv run python -m mcp_server.server --transport http --host 127.0.0.1 --port 3333 &
MCP_PID=$!
echo "    PID: $MCP_PID"
echo ""
echo "按 Ctrl+C 停止所有服务"
trap "kill $WEB_PID $MCP_PID 2>/dev/null; exit" INT TERM
wait
