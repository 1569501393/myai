const pptxgen = require("pptxgenjs");

const pres = new pptxgen();
pres.layout = 'LAYOUT_16x9';
pres.title = 'OpenCode 使用指南';
pres.author = 'AI Assistant';

// Color palette - Teal Trust
const COLORS = {
    primary: '028090',
    secondary: '00A896',
    accent: '02C39A',
    dark: '1A365D',
    light: 'F7FAFC',
    text: '2D3748',
    white: 'FFFFFF'
};

// ========== Slide 1: Title ==========
let slide1 = pres.addSlide();
slide1.background = { color: COLORS.dark };

// Accent shape top
slide1.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 0.15, fill: { color: COLORS.accent }
});

// Title
slide1.addText("OpenCode", {
    x: 0.5, y: 1.8, w: 9, h: 1.2,
    fontSize: 60, fontFace: 'Arial Black', color: COLORS.white,
    bold: true, align: 'center'
});

slide1.addText("AI 编程助手完全指南", {
    x: 0.5, y: 3.0, w: 9, h: 0.8,
    fontSize: 28, fontFace: 'Arial', color: COLORS.accent,
    align: 'center'
});

// Bottom line
slide1.addShape(pres.shapes.RECTANGLE, {
    x: 3.5, y: 4.0, w: 3, h: 0.05, fill: { color: COLORS.secondary }
});

slide1.addText("知识点 · 配置 · 最佳实践", {
    x: 0.5, y: 4.3, w: 9, h: 0.5,
    fontSize: 16, fontFace: 'Arial', color: COLORS.white,
    align: 'center'
});

// ========== Slide 2: What is OpenCode ==========
let slide2 = pres.addSlide();
slide2.background = { color: COLORS.light };

// Header bar
slide2.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 1.0, fill: { color: COLORS.primary }
});

slide2.addText("什么是 OpenCode？", {
    x: 0.5, y: 0.25, w: 9, h: 0.6,
    fontSize: 32, fontFace: 'Arial', color: COLORS.white,
    bold: true, margin: 0
});

// Content card
slide2.addShape(pres.shapes.RECTANGLE, {
    x: 0.5, y: 1.3, w: 9, h: 3.8, fill: { color: COLORS.white },
    shadow: { type: "outer", color: "000000", blur: 8, offset: 3, angle: 135, opacity: 0.1 }
});

slide2.addText("开源 AI 编程助手", {
    x: 0.8, y: 1.5, w: 8.4, h: 0.5,
    fontSize: 22, fontFace: 'Arial', color: COLORS.primary, bold: true
});

slide2.addText([
    { text: "OpenCode 是一个开源的终端 AI 编程工具，支持多 AI 模型，", options: { breakLine: true } },
    { text: "帮助开发者高效完成代码编写、审查、调试等任务。", options: {} }
], {
    x: 0.8, y: 2.1, w: 8.4, h: 0.8,
    fontSize: 16, fontFace: 'Arial', color: COLORS.text
});

// Key points
const keyPoints = [
    "完全开源免费",
    "支持 Claude、GPT、DeepSeek 等多模型",
    "跨平台：Linux、macOS、Windows",
    "可扩展的 Skills 技能系统"
];

keyPoints.forEach((point, i) => {
    slide2.addShape(pres.shapes.RECTANGLE, {
        x: 0.8, y: 3.0 + i * 0.5, w: 0.08, h: 0.3, fill: { color: COLORS.accent }
    });
    slide2.addText(point, {
        x: 1.1, y: 3.0 + i * 0.5, w: 8, h: 0.4,
        fontSize: 16, fontFace: 'Arial', color: COLORS.text, valign: 'middle'
    });
});

// ========== Slide 3: Core Features ==========
let slide3 = pres.addSlide();
slide3.background = { color: COLORS.light };

slide3.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 1.0, fill: { color: COLORS.primary }
});

slide3.addText("核心特性", {
    x: 0.5, y: 0.25, w: 9, h: 0.6,
    fontSize: 32, fontFace: 'Arial', color: COLORS.white,
    bold: true, margin: 0
});

// Feature cards - 2x2 grid
const features = [
    { title: "多模型支持", desc: "灵活切换 Claude、GPT、DeepSeek 等 AI 模型" },
    { title: "Skills 技能系统", desc: "可定制开发工作流自动化" },
    { title: "AGENTS.md 配置", desc: "项目级规则和上下文管理" },
    { title: "MCP 插件扩展", desc: "连接外部工具和服务" }
];

features.forEach((feat, i) => {
    const x = 0.5 + (i % 2) * 4.6;
    const y = 1.3 + Math.floor(i / 2) * 2.1;
    
    slide3.addShape(pres.shapes.RECTANGLE, {
        x: x, y: y, w: 4.3, h: 1.9, fill: { color: COLORS.white },
        shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 }
    });
    
    // Accent bar
    slide3.addShape(pres.shapes.RECTANGLE, {
        x: x, y: y, w: 0.1, h: 1.9, fill: { color: COLORS.accent }
    });
    
    slide3.addText(feat.title, {
        x: x + 0.3, y: y + 0.3, w: 3.8, h: 0.5,
        fontSize: 20, fontFace: 'Arial', color: COLORS.primary, bold: true
    });
    
    slide3.addText(feat.desc, {
        x: x + 0.3, y: y + 0.9, w: 3.8, h: 0.8,
        fontSize: 14, fontFace: 'Arial', color: COLORS.text
    });
});

// ========== Slide 4: Installation ==========
let slide4 = pres.addSlide();
slide4.background = { color: COLORS.light };

slide4.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 1.0, fill: { color: COLORS.primary }
});

slide4.addText("安装与配置", {
    x: 0.5, y: 0.25, w: 9, h: 0.6,
    fontSize: 32, fontFace: 'Arial', color: COLORS.white,
    bold: true, margin: 0
});

// Left column - Installation
slide4.addShape(pres.shapes.RECTANGLE, {
    x: 0.5, y: 1.3, w: 4.3, h: 3.8, fill: { color: COLORS.white },
    shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 }
});

slide4.addText("安装命令", {
    x: 0.7, y: 1.5, w: 4, h: 0.5,
    fontSize: 20, fontFace: 'Arial', color: COLORS.primary, bold: true
});

slide4.addShape(pres.shapes.RECTANGLE, {
    x: 0.7, y: 2.1, w: 3.9, h: 1.0, fill: { color: '1A202C' }
});

slide4.addText([
    { text: "# macOS/Linux", options: { color: '718096', breakLine: true } },
    { text: "curl -sL ... | sh", options: { color: '68D391', breakLine: true } },
    { text: "", options: { breakLine: true } },
    { text: "# 或使用 npm", options: { color: '718096', breakLine: true } },
    { text: "npm install -g opencode-cli", options: { color: '68D391' } }
], {
    x: 0.85, y: 2.2, w: 3.6, h: 0.9,
    fontSize: 11, fontFace: 'Consolas'
});

// Right column - Config
slide4.addShape(pres.shapes.RECTANGLE, {
    x: 5.2, y: 1.3, w: 4.3, h: 3.8, fill: { color: COLORS.white },
    shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 }
});

slide4.addText("配置文件", {
    x: 5.4, y: 1.5, w: 4, h: 0.5,
    fontSize: 20, fontFace: 'Arial', color: COLORS.primary, bold: true
});

slide4.addText([
    { text: "opencode.json", options: { bold: true, breakLine: true } },
    { text: "  全局/项目配置", options: { breakLine: true, color: COLORS.text } },
    { text: "", options: { breakLine: true } },
    { text: "AGENTS.md", options: { bold: true, breakLine: true } },
    { text: "  项目规则和上下文", options: { breakLine: true, color: COLORS.text } },
    { text: "", options: { breakLine: true } },
    { text: "~/.config/opencode/", options: { bold: true, breakLine: true } },
    { text: "  全局设置目录", options: { color: COLORS.text } }
], {
    x: 5.4, y: 2.1, w: 4, h: 2.8,
    fontSize: 14, fontFace: 'Arial', color: COLORS.primary
});

// ========== Slide 5: Basic Usage ==========
let slide5 = pres.addSlide();
slide5.background = { color: COLORS.light };

slide5.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 1.0, fill: { color: COLORS.primary }
});

slide5.addText("基础使用", {
    x: 0.5, y: 0.25, w: 9, h: 0.6,
    fontSize: 32, fontFace: 'Arial', color: COLORS.white,
    bold: true, margin: 0
});

// Command table
const commands = [
    { cmd: "opencode", desc: "启动会话（当前目录）" },
    { cmd: "opencode ./src", desc: "指定目录启动" },
    { cmd: "/help", desc: "显示帮助信息" },
    { cmd: "/model", desc: "切换 AI 模型" },
    { cmd: "/skills", desc: "查看可用技能" }
];

commands.forEach((item, i) => {
    const y = 1.3 + i * 0.65;
    
    slide5.addShape(pres.shapes.RECTANGLE, {
        x: 0.5, y: y, w: 3.5, h: 0.55, fill: { color: '1A202C' }
    });
    
    slide5.addText(item.cmd, {
        x: 0.7, y: y, w: 3.1, h: 0.55,
        fontSize: 14, fontFace: 'Consolas', color: '68D391', valign: 'middle'
    });
    
    slide5.addText(item.desc, {
        x: 4.2, y: y, w: 5.3, h: 0.55,
        fontSize: 16, fontFace: 'Arial', color: COLORS.text, valign: 'middle'
    });
});

// Tip box
slide5.addShape(pres.shapes.RECTANGLE, {
    x: 0.5, y: 4.6, w: 9, h: 0.8, fill: { color: COLORS.accent, transparency: 15 }
});

slide5.addText("💡 提示：使用 @ 引用文件，保持上下文精确", {
    x: 0.7, y: 4.6, w: 8.6, h: 0.8,
    fontSize: 15, fontFace: 'Arial', color: COLORS.primary, valign: 'middle'
});

// ========== Slide 6: Skills System ==========
let slide6 = pres.addSlide();
slide6.background = { color: COLORS.light };

slide6.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 1.0, fill: { color: COLORS.primary }
});

slide6.addText("Skills 技能系统", {
    x: 0.5, y: 0.25, w: 9, h: 0.6,
    fontSize: 32, fontFace: 'Arial', color: COLORS.white,
    bold: true, margin: 0
});

// Structure
slide6.addShape(pres.shapes.RECTANGLE, {
    x: 0.5, y: 1.3, w: 4.3, h: 2.0, fill: { color: COLORS.white },
    shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 }
});

slide6.addText("目录结构", {
    x: 0.7, y: 1.5, w: 4, h: 0.4,
    fontSize: 18, fontFace: 'Arial', color: COLORS.primary, bold: true
});

slide6.addShape(pres.shapes.RECTANGLE, {
    x: 0.7, y: 2.0, w: 3.9, h: 1.1, fill: { color: '1A202C' }
});

slide6.addText([
    { text: "~/.opencode/skills/", options: { color: 'F6E05E', breakLine: true } },
    { text: "  └── my-skill/", options: { color: '68D391', breakLine: true } },
    { text: "      └── SKILL.md", options: { color: '68D391' } }
], {
    x: 0.85, y: 2.1, w: 3.6, h: 0.9,
    fontSize: 12, fontFace: 'Consolas'
});

// SKILL.md content
slide6.addShape(pres.shapes.RECTANGLE, {
    x: 5.2, y: 1.3, w: 4.3, h: 2.0, fill: { color: COLORS.white },
    shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 }
});

slide6.addText("SKILL.md 内容", {
    x: 5.4, y: 1.5, w: 4, h: 0.4,
    fontSize: 18, fontFace: 'Arial', color: COLORS.primary, bold: true
});

slide6.addText([
    { text: "- 触发条件", options: { breakLine: true } },
    { text: "- 工作流程", options: { breakLine: true } },
    { text: "- 输出格式", options: { breakLine: true } },
    { text: "- 示例代码", options: {} }
], {
    x: 5.4, y: 2.0, w: 4, h: 1.2,
    fontSize: 14, fontFace: 'Arial', color: COLORS.text
});

// Available skills
slide6.addShape(pres.shapes.RECTANGLE, {
    x: 0.5, y: 3.5, w: 9, h: 1.8, fill: { color: COLORS.white },
    shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.1 }
});

slide6.addText("内置技能", {
    x: 0.7, y: 3.7, w: 8.6, h: 0.4,
    fontSize: 18, fontFace: 'Arial', color: COLORS.primary, bold: true
});

const skills = ['pdf', 'pptx', 'github', 'weather', 'daily-report', 'sc-refactor-review'];
skills.forEach((skill, i) => {
    const x = 0.7 + (i % 3) * 3;
    const y = 4.2 + Math.floor(i / 3) * 0.5;
    
    slide6.addShape(pres.shapes.RECTANGLE, {
        x: x, y: y, w: 2.8, h: 0.4, fill: { color: COLORS.accent, transparency: 20 }
    });
    
    slide6.addText(skill, {
        x: x, y: y, w: 2.8, h: 0.4,
        fontSize: 12, fontFace: 'Consolas', color: COLORS.primary,
        align: 'center', valign: 'middle'
    });
});

// ========== Slide 7: Best Practices ==========
let slide7 = pres.addSlide();
slide7.background = { color: COLORS.light };

slide7.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 1.0, fill: { color: COLORS.primary }
});

slide7.addText("最佳实践", {
    x: 0.5, y: 0.25, w: 9, h: 0.6,
    fontSize: 32, fontFace: 'Arial', color: COLORS.white,
    bold: true, margin: 0
});

const practices = [
    { title: "精准引用文件", tip: "使用 @ 语法引用具体文件，保持上下文精确" },
    { title: "分步执行", tip: "复杂任务拆解为多个步骤，逐步验证" },
    { title: "自动化工作流", tip: "利用 Skills 自动化重复性任务" },
    { title: "安全第一", tip: "不暴露敏感信息，使用环境变量" }
];

practices.forEach((p, i) => {
    const y = 1.25 + i * 1.05;
    
    slide7.addShape(pres.shapes.RECTANGLE, {
        x: 0.5, y: y, w: 9, h: 0.95, fill: { color: COLORS.white },
        shadow: { type: "outer", color: "000000", blur: 4, offset: 2, angle: 135, opacity: 0.08 }
    });
    
    // Number circle
    slide7.addShape(pres.shapes.OVAL, {
        x: 0.7, y: y + 0.2, w: 0.55, h: 0.55, fill: { color: COLORS.accent }
    });
    
    slide7.addText(String(i + 1), {
        x: 0.7, y: y + 0.2, w: 0.55, h: 0.55,
        fontSize: 16, fontFace: 'Arial', color: COLORS.white,
        align: 'center', valign: 'middle', bold: true
    });
    
    slide7.addText(p.title, {
        x: 1.5, y: y + 0.15, w: 7.8, h: 0.4,
        fontSize: 18, fontFace: 'Arial', color: COLORS.primary, bold: true
    });
    
    slide7.addText(p.tip, {
        x: 1.5, y: y + 0.5, w: 7.8, h: 0.4,
        fontSize: 14, fontFace: 'Arial', color: COLORS.text
    });
});

// ========== Slide 8: Summary ==========
let slide8 = pres.addSlide();
slide8.background = { color: COLORS.dark };

slide8.addShape(pres.shapes.RECTANGLE, {
    x: 0, y: 0, w: 10, h: 0.15, fill: { color: COLORS.accent }
});

slide8.addText("总结", {
    x: 0.5, y: 1.0, w: 9, h: 0.8,
    fontSize: 44, fontFace: 'Arial Black', color: COLORS.white,
    align: 'center'
});

slide8.addShape(pres.shapes.RECTANGLE, {
    x: 3.5, y: 1.9, w: 3, h: 0.05, fill: { color: COLORS.secondary }
});

slide8.addText([
    { text: "OpenCode = 强大的 AI 编程能力", options: { breakLine: true } },
    { text: "                     + 灵活的扩展系统", options: { breakLine: true } },
    { text: "                     + 开源免费", options: {} }
], {
    x: 0.5, y: 2.3, w: 9, h: 1.5,
    fontSize: 22, fontFace: 'Arial', color: COLORS.accent,
    align: 'center'
});

slide8.addText("立即开始使用，提升开发效率！", {
    x: 0.5, y: 4.2, w: 9, h: 0.6,
    fontSize: 20, fontFace: 'Arial', color: COLORS.white,
    align: 'center'
});

slide8.addText("https://opencode.ai", {
    x: 0.5, y: 4.8, w: 9, h: 0.5,
    fontSize: 16, fontFace: 'Arial', color: COLORS.secondary,
    align: 'center'
});

// Save
pres.writeFile({ fileName: "/home/jieqiang/tmp/www/docs/OpenCode_Guide.pptx" })
    .then(() => console.log("PPT created: docs/OpenCode_Guide.pptx"))
    .catch(err => console.error(err));
