#!/bin/bash

# 引数で指定されたテーブル名を取得
TABLE_NAME=$1

# 必要な変数を設定
PROD_HOST="vook-rails-db.ctutkiavfpne.ap-northeast-1.rds.amazonaws.com"
DEV_HOST="vook-rails-db-dev-1.ctutkiavfpne.ap-northeast-1.rds.amazonaws.com"
PROD_DB="vook_web_v3_production"
DEV_DB="vook_web_v3_development"
MYSQL_USER="root"

# パスワード入力を促す
echo "Enter password for MySQL user ${MYSQL_USER}:"
read -s MYSQL_PASSWORD

# ステップ 1: テーブル構造をエクスポート
echo "Exporting table structure for ${TABLE_NAME} from production database..."
mysqldump -u "${MYSQL_USER}" -h "${PROD_HOST}" -p"${MYSQL_PASSWORD}" --no-data --set-gtid-purged=OFF "${PROD_DB}" "${TABLE_NAME}" > "${TABLE_NAME}_schema.sql"

# ステップ 2: テーブル構造をインポート
echo "Importing table structure for ${TABLE_NAME} into development database..."
mysql -u "${MYSQL_USER}" -h "${DEV_HOST}" -p"${MYSQL_PASSWORD}" "${DEV_DB}" < "${TABLE_NAME}_schema.sql"

# ステップ 3: テーブルデータをエクスポート
echo "Exporting table data for ${TABLE_NAME} from production database..."
mysqldump -u "${MYSQL_USER}" -h "${PROD_HOST}" -p"${MYSQL_PASSWORD}" --no-create-info --set-gtid-purged=OFF "${PROD_DB}" "${TABLE_NAME}" > "${TABLE_NAME}_data.sql"

# ステップ 4: テーブルデータをインポート
echo "Importing table data for ${TABLE_NAME} into development database..."
mysql -u "${MYSQL_USER}" -h "${DEV_HOST}" -p"${MYSQL_PASSWORD}" "${DEV_DB}" < "${TABLE_NAME}_data.sql"

echo "Migration of table ${TABLE_NAME} from production to development completed!"
