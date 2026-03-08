"""
数据库迁移脚本：为 journal_entries 表添加 deleted 字段

运行方式：
    cd backend && uv run python migrate_add_deleted_field.py

说明：
    - 此脚本为已存在的 SQLite 数据库添加 deleted 字段
    - 幂等设计：可重复运行，不会重复添加字段
    - 所有现有记录默认 deleted=False（未删除）
"""

import sqlite3
import sys
from pathlib import Path

# 数据库文件路径
DB_PATH = Path(__file__).parent / "aidiary.db"


def check_column_exists(conn: sqlite3.Connection, table: str, column: str) -> bool:
    """检查表中是否已存在指定字段"""
    cursor = conn.cursor()
    cursor.execute(f"PRAGMA table_info({table})")
    columns = cursor.fetchall()
    return any(col[1] == column for col in columns)


def migrate():
    """执行迁移"""
    if not DB_PATH.exists():
        print(f"❌ 数据库文件不存在: {DB_PATH}")
        sys.exit(1)

    print(f"📁 数据库路径: {DB_PATH}")
    print("🔍 检查 deleted 字段...")

    conn = sqlite3.connect(DB_PATH)
    try:
        # 检查字段是否已存在
        if check_column_exists(conn, "journal_entries", "deleted"):
            print("✅ deleted 字段已存在，无需迁移")
            return

        print("📝 添加 deleted 字段...")

        # 添加 deleted 字段，默认值为 0 (False)
        cursor = conn.cursor()
        cursor.execute("ALTER TABLE journal_entries ADD COLUMN deleted BOOLEAN DEFAULT 0")

        # 创建索引以优化查询性能
        cursor.execute(
            "CREATE INDEX IF NOT EXISTS ix_journal_entries_deleted ON journal_entries(deleted)"
        )

        conn.commit()
        print("✅ 迁移成功！")
        print("   - 已添加 deleted 字段 (BOOLEAN, DEFAULT 0)")
        print("   - 已创建索引 ix_journal_entries_deleted")

    except sqlite3.Error as e:
        conn.rollback()
        print(f"❌ 迁移失败: {e}")
        sys.exit(1)
    finally:
        conn.close()


if __name__ == "__main__":
    migrate()
