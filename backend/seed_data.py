import json
import os
from datetime import datetime, timedelta

from database import Base, SessionLocal, engine
from models import JournalEntry, User

Base.metadata.create_all(bind=engine)

db = SessionLocal()

# 测试模式使用 testuser，生产模式使用 playeriv65
TEST_MODE = os.getenv("TEST_MODE", "false").lower() == "true"
USERNAME = "testuser" if TEST_MODE else "playeriv65"
TEST_PASSWORD = "testpass123"
PROD_PASSWORD = "password123"
user = db.query(User).filter(User.username == USERNAME).first()
if not user:
    from auth import hash_password

    user = User(
        username=USERNAME,
        email=f"{USERNAME}@example.com",
        hashed_password=hash_password(TEST_PASSWORD if TEST_MODE else PROD_PASSWORD),
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    print(f"Created user: {USERNAME}")
else:
    print(f"User already exists: {USERNAME}")

entries_data: list[dict] = [
    {
        "id": "f148a145-b0ef-4303-90e8-54bba8af0d45",
        "title": "年夜饭",
        "content": "今天是大年三十，全家人一起吃年夜饭。这是我最期待的时刻，一大家子人围坐在一起，分享着一年来的大小事。妈妈的厨艺依旧那么棒，满满一桌子菜：红烧鱼、狮子头、白切鸡、还有各种海鲜。大家有说有笑，气氛温馨极了！",
        "category": "life",
        "weather": "sunny",
        "location": "家中",
        "tags": ["春节", "家庭", "美食"],
        "days_ago": 0,
    },
    {
        "id": "e3a2c5d8-a4b1-4c6d-8e9f-0123456789ab",
        "title": "春日散步",
        "content": "今天阳光明媚，去公园散步。樱花开了，粉色的花瓣随风飘落，非常美丽。在湖边看到几只天鹅在游泳，心情很愉快。",
        "category": "life",
        "weather": "sunny",
        "location": "中央公园",
        "tags": ["散步", "春天", "樱花"],
        "days_ago": 1,
    },
    {
        "id": "b2c4e6a8-d5c4-4b7a-9e1f-2345678901cd",
        "title": "学习 TypeScript",
        "content": "今天花了一整天学习 TypeScript 的高级特性，包括泛型、条件类型和映射类型。感觉收获很大，对类型系统有了更深的理解。",
        "category": "study",
        "weather": "cloudy",
        "location": "家中书房",
        "tags": ["编程", "学习", "TypeScript"],
        "days_ago": 3,
    },
    {
        "id": "c9f8a1b2-e3d4-4f5a-8b9c-3456789012ef",
        "title": "项目上线",
        "content": "经过几个月的努力，我们的项目终于上线了！虽然还有一些小问题需要修复，但整体运行稳定。团队一起庆祝了一下，点了披萨和蛋糕。",
        "category": "work",
        "weather": "sunny",
        "location": "公司",
        "tags": ["工作", "上线", "团队"],
        "days_ago": 5,
    },
    {
        "id": "d4e5f6a7-b8c9-4d1e-9f2a-4567890134gh",
        "title": "京都一日游",
        "content": "参观了金阁寺，金色的建筑在阳光下闪闪发光。然后去了岚山竹林，漫步在竹林间感觉非常宁静。晚上在祇园吃了正宗的京都料理。",
        "category": "travel",
        "weather": "sunny",
        "location": "京都",
        "tags": ["旅行", "日本", "京都"],
        "days_ago": 10,
    },
    {
        "id": "f6a7b8c9-d1e2-4f3a-8b4c-5678901245ij",
        "title": "晨跑打卡",
        "content": "早上6点起床去跑步，跑了5公里。虽然开始有点困，但跑完之后神清气爽。以后要坚持每天早起锻炼身体。",
        "category": "health",
        "weather": "cloudy",
        "location": "小区公园",
        "tags": ["运动", "健康", "晨跑"],
        "days_ago": 15,
    },
    {
        "id": "a7b8c9d1-e2f3-4a4b-9c5d-6789012345kl",
        "title": "读书笔记",
        "content": "今天读了《人类简史》的第三章，关于农业革命的讨论很有意思。作者认为农业革命是历史上最大的骗局，让人深思。",
        "category": "study",
        "weather": "rainy",
        "location": "咖啡馆",
        "tags": ["阅读", "历史", "思考"],
        "days_ago": 25,
    },
    {
        "id": "b8c9d1e2-f3a4-4b5c-8d6e-7890123456mn",
        "title": "周末聚餐",
        "content": "和老朋友们一起吃火锅，聊了很多以前的事情。时间过得真快，大家都有了自己的生活和事业，但友谊依旧。",
        "category": "life",
        "weather": "rainy",
        "location": "海底捞",
        "tags": ["朋友", "聚餐", "周末"],
        "days_ago": 35,
    },
    {
        "id": "c9d1e2f3-a4b5-4c6d-9e7f-8901234567op",
        "title": "代码重构",
        "content": "对项目进行了大规模重构，优化了组件结构，提取了公共逻辑。代码更清晰了，维护起来也更方便。",
        "category": "work",
        "weather": "cloudy",
        "location": "公司",
        "tags": ["编程", "重构", "优化"],
        "days_ago": 45,
    },
    {
        "id": "d1e2f3a4-b5c6-4d7e-8f90-1234567890qr",
        "title": "新年计划",
        "content": "新的一年，给自己定了一些目标：多读书、坚持运动、学习新技能、多陪伴家人。希望年底能完成这些目标！",
        "category": "life",
        "weather": "sunny",
        "location": "家中",
        "tags": ["计划", "新年", "目标"],
        "days_ago": 60,
    },
    {
        "id": "e2f3a4b5-c6d7-4e8f-9012-3456789012st",
        "title": "滑雪初体验",
        "content": "第一次去 skiing，摔了很多次但很开心。教练很耐心，教了我基本的刹车和转弯技巧。下次还想再去！",
        "category": "travel",
        "weather": "snowy",
        "location": "北海道",
        "tags": ["旅行", "滑雪", "冬天"],
        "days_ago": 75,
    },
    {
        "id": "f3a4b5c6-d7e8-4f90-1234-5678901234uv",
        "title": "健身三个月总结",
        "content": "坚持健身三个月了，体重减了5公斤，肌肉也明显增加了。最重要的是养成了规律运动的习惯，感觉整个人都更有活力了。",
        "category": "health",
        "weather": "sunny",
        "location": "健身房",
        "tags": ["运动", "健身", "减肥"],
        "days_ago": 90,
    },
    {
        "id": "a4b5c6d7-e8f9-4012-3456-7890123456wx",
        "title": "学会做红烧肉",
        "content": "今天跟着视频学会了做红烧肉，虽然卖相一般，但味道还不错。以后要多练习做饭，不能总点外卖了。",
        "category": "life",
        "weather": "cloudy",
        "location": "家中厨房",
        "tags": ["做饭", "美食", "学习"],
        "days_ago": 120,
    },
]

try:
    db.query(JournalEntry).delete()
    db.commit()

    for data in entries_data:
        entry_time = datetime.now() - timedelta(days=data["days_ago"])
        entry = JournalEntry(
            id=data["id"],
            title=data["title"],
            content=data["content"],
            category=data["category"],
            weather=data["weather"],
            location=data["location"],
            tags=json.dumps(data["tags"], ensure_ascii=False),
            created_at=entry_time,
            updated_at=entry_time,
            user_id=user.id,
        )
        db.add(entry)

    db.commit()
    print(f"Created {len(entries_data)} entries for user: {USERNAME}")

    print("\nTime range:")
    print("  Latest: 1 day ago")
    print("  Oldest: 120 days ago (4 months)")

finally:
    db.close()
