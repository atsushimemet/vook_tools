#!/bin/bash

# 引数から環境名を取得
ENV_NAME=$1

# 環境名が指定されていない場合はエラーを出力
if [ -z "$ENV_NAME" ]; then
  echo "Usage: $0 <env_name>"
  echo "env_name should be 'dev' or 'prd'."
  exit 1
fi

# 環境に応じて設定を切り替え
if [ "$ENV_NAME" = "dev" ]; then
  DB_HOST="vook-rails-db-dev-1.ctutkiavfpne.ap-northeast-1.rds.amazonaws.com"
  DB_NAME="vook_web_v3_development"
elif [ "$ENV_NAME" = "prd" ]; then
  DB_HOST="vook-rails-db.ctutkiavfpne.ap-northeast-1.rds.amazonaws.com"
  DB_NAME="vook_web_v3_development"
else
  echo "Invalid env_name: $ENV_NAME"
  echo "env_name should be 'dev' or 'prd'."
  exit 1
fi

# パスワード入力を促す
echo "Enter password for MySQL user root:"
read -s MYSQL_PASSWORD

# MySQLコマンドを実行
mysql -u root -h "$DB_HOST" -p"$MYSQL_PASSWORD" "$DB_NAME"
