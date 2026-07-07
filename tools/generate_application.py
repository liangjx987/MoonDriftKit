from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf" / "MoonDriftKit_项目申报书.pdf"
FONT = "C:/Windows/Fonts/msyh.ttc"


def register_font():
    pdfmetrics.registerFont(TTFont("MSYH", FONT))


def p(text, style):
    return Paragraph(text, style)


def build():
    register_font()
    OUT.parent.mkdir(parents=True, exist_ok=True)
    styles = getSampleStyleSheet()
    title = ParagraphStyle(
        "TitleCN",
        parent=styles["Title"],
        fontName="MSYH",
        fontSize=18,
        leading=24,
        textColor=colors.HexColor("#12355b"),
        alignment=1,
        spaceAfter=8,
    )
    h = ParagraphStyle(
        "HeadingCN",
        parent=styles["Heading2"],
        fontName="MSYH",
        fontSize=11.5,
        leading=15,
        textColor=colors.HexColor("#12355b"),
        spaceBefore=6,
        spaceAfter=4,
    )
    body = ParagraphStyle(
        "BodyCN",
        parent=styles["BodyText"],
        fontName="MSYH",
        fontSize=9.2,
        leading=13.2,
        firstLineIndent=0,
        spaceAfter=4,
    )
    small = ParagraphStyle(
        "SmallCN",
        parent=body,
        fontSize=8.7,
        leading=12.5,
    )

    doc = SimpleDocTemplate(
        str(OUT),
        pagesize=A4,
        rightMargin=16 * mm,
        leftMargin=16 * mm,
        topMargin=14 * mm,
        bottomMargin=14 * mm,
    )

    story = [p("MoonDriftKit 项目申报书", title)]

    data = [
        ["项目名称", "MoonDriftKit：面向 MoonBit 的流式数据漂移检测与稳定性评估基础库"],
        ["参赛者", "梁佳潇"],
        ["联系方式", "15005479112"],
        ["GitHub 仓库", "https://github.com/liangjx987/MoonDriftKit"],
        ["GitLink 仓库", "https://www.gitlink.org.cn/liangjx666/MoonDriftKit"],
        ["项目方向", "MoonBit 数据质量监控 / 流式分布漂移检测基础库"],
        ["是否移植", "否，原创 MoonBit 基础库项目"],
    ]
    table = Table(data, colWidths=[30 * mm, 132 * mm])
    table.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, -1), "MSYH"),
                ("FONTSIZE", (0, 0), (-1, -1), 8.5),
                ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#edf4fb")),
                ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor("#12355b")),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#c9d6e2")),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ]
        )
    )
    story.append(table)
    story.append(Spacer(1, 6))

    sections = [
        (
            "一、项目简介",
            "MoonDriftKit 面向 MoonBit 生态提供轻量、可复现的数据漂移检测能力。项目聚焦模型输入监控、数据流水线回归、实验指标护栏和线上遥测质量检查，通过直方图基线、当前窗口和漂移报告判断分布是否发生稳定性变化。",
        ),
        (
            "二、核心功能",
            "项目已实现等宽整数分桶 BucketSpec、Histogram 基线/当前窗口、basis point 分布占比、compare_histograms 漂移报告、stable/watch/drift 三级判断、DriftWindow 滑动窗口、DriftPolicy 可配置阈值、稳定 JSON 导出和 CLI 演示。",
        ),
        (
            "三、创新点和价值",
            "MoonDriftKit 不做图表、DataFrame 或模型训练，而是补足 MoonBit 在数据质量监控侧的基础能力。项目使用整数基点计算，避免不同后端浮点差异，适合在 JS、Wasm、Wasm-GC 和 Native 目标中生成一致的 CI 证据。",
        ),
        (
            "四、与社区项目差异",
            "社区已有图表、颜色、几何、解析、哈希和通用数据结构项目。MoonDriftKit 的边界是分布漂移和稳定性报告：它输出可被仪表盘消费的监控结论，而不是负责绘图、存储、训练或网络采集。",
        ),
    ]
    for heading, text in sections:
        story.append(p(heading, h))
        story.append(p(text, body))

    story.append(PageBreak())
    story.append(p("MoonDriftKit 项目申报书", title))
    story.append(p("五、当前完成情况", h))
    story.append(
        p(
            "仓库包含 MoonBit 源码、8 个回归测试、CLI 示例、README、RELATED_WORK、ACCEPTANCE、CHANGELOG 和 GitHub Actions CI。当前可运行 moon check --target all、moon test --target wasm、moon test --target wasm-gc 与 moon run cmd/main。",
            body,
        )
    )
    story.append(p("六、技术路线", h))
    story.append(
        p(
            "项目以 BucketSpec 统一分桶边界，以 Histogram 保存基线和当前窗口，以 compare_histograms 生成漂移报告。分布占比使用 basis point 整数表示，避免不同后端浮点差异。DriftPolicy 将告警阈值从算法中分离，便于业务按监控敏感度调整。",
            body,
        )
    )
    story.append(p("七、验收与质量保障", h))
    story.append(
        p(
            "项目包含覆盖分桶、直方图、漂移判断、滑动窗口、JSON 导出和策略边界的回归测试。CI 使用官方 MoonBit 安装流程，并执行 check、test、fmt diff、moon info 和 CLI 演示，避免缺失 CI 或命令不兼容问题。",
            body,
        )
    )
    story.append(p("八、后续计划", h))
    story.append(
        p(
            "后续将补充分位点近似、分桶自动推荐、更多真实数据样例、告警解释文本、报表导出和与可视化库的对接示例，同时保持核心包后端中立、无平台依赖。",
            body,
        )
    )
    story.append(p("九、提交说明", h))
    story.append(
        p(
            "项目围绕公开仓库持续开发，提交记录按基础结构、漂移报告、滑动窗口、JSON 导出、CLI、文档、CI、策略和申报材料逐步形成，便于评审追踪真实开发过程。",
            small,
        )
    )

    doc.build(story)


if __name__ == "__main__":
    build()
