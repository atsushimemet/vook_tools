#!/bin/bash

# 引数チェック
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 [prd|dev] [table_name]"
  exit 1
fi

# 環境に応じた設定
ENV="$1"
TABLE="$2"
if [ "$ENV" = "prd" ]; then
  HOST="vook-rails-db.ctutkiavfpne.ap-northeast-1.rds.amazonaws.com"
  DATABASE="vook_web_v3_production"
elif [ "$ENV" = "dev" ]; then
  HOST="vook-rails-db-dev-1.ctutkiavfpne.ap-northeast-1.rds.amazonaws.com"
  DATABASE="vook_web_v3_development"
else
  echo "Invalid environment: $ENV. Use 'prd' or 'dev'."
  exit 1
fi

# MySQL接続情報
USER="root"

# パスワード入力を促す
echo "Enter password for MySQL user ${USER}:"
read -s PASSWORD

# タイムスタンプ生成
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 出力ファイル名（カレントディレクトリに保存）
OUTPUT_FILE="./${TABLE}_${ENV}_${TIMESTAMP}.csv"

# MySQLコマンドでカレントディレクトリにCSV出力
mysql -h "$HOST" -u "$USER" -p"$PASSWORD" -e "
USE $DATABASE;
SELECT * FROM $TABLE INTO OUTFILE '$OUTPUT_FILE'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"' 
LINES TERMINATED BY '\n';
"

# 処理結果の確認
if [ -f "$OUTPUT_FILE" ]; then
  echo "CSVファイルがカレントディレクトリに保存されました: $OUTPUT_FILE"
else
  echo "エクスポートに失敗しました。"
  exit 1
fi
