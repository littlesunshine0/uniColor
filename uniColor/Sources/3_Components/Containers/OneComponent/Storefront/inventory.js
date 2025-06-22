// Atomic inventory: EVERY element, style, and component is an item
window.inventory = [
  // Layouts
  {
    id: "main-grid-layout",
    name: "Main Grid Layout",
    type: "Layout",
    category: "Layouts",
    description: "The responsive 2-column grid layout using CSS Grid for sidebar + main content.",
    preview: `<div style="display:grid;grid-template-columns:120px 1fr;gap:16px;background:#1d1d1f;padding:8px;border-radius:12px;">
      <div style="background:#161617;color:#fff;padding:16px;border-radius:8px;">Sidebar</div>
      <div style="background:#232325;color:#fff;padding:16px;border-radius:8px;">Main</div>
    </div>`,
    code: `
.page-wrapper {
  display: grid;
  grid-template-columns: 280px 1fr;
  grid-template-areas: "sidebar main";
  min-height: 100vh;
}
    `,
    stock: 10,
    price: 2
  },
  // Atoms: Colors, Radius, Shadows
  {
    id: "theme-dark-vars",
    name: "Theme Variables: Dark Mode",
    type: "Style",
    category: "Tokens",
    description: "CSS custom properties for dark theme colors and fonts.",
    preview: `<div style="background:#161617;color:#f5f5f7;padding:12px;border-radius:8px;">Dark Theme Example</div>`,
    code: `
:root {
  --bg: #161617;
  --text-primary: #f5f5f7;
  --border: #3a3a3c;
  --accent-blue: #0a84ff;
  --radius-large: 20px;
  --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
}
    `,
    stock: 25,
    price: 1
  },
  {
    id: "border-radius-large",
    name: "Border Radius: Large",
    type: "Style",
    category: "Tokens",
    description: "Large border-radius for cards and panels (20px).",
    preview: `<div style="background:#232325;color:#fff;padding:10px;border-radius:20px;">radius: 20px</div>`,
    code: `border-radius: 20px;`,
    stock: 30,
    price: 1
  },
  {
    id: "timing-fast",
    name: "Transition (Fast)",
    type: "Style",
    category: "Tokens",
    description: "Quick transition timing for hover/focus effects.",
    preview: `<button style="transition:background 0.2s;background:#0a84ff;color:#fff;padding:8px 16px;border-radius:10px;">Hover me</button>`,
    code: `transition: background 0.2s;`,
    stock: 30,
    price: 1
  },
  // Molecules: Search Bar
  {
    id: "search-bar-container",
    name: "Search Bar: Container",
    type: "Component",
    category: "Controls",
    description: "A flex container for search input and button.",
    preview: `<div style="display:flex;align-items:center;background:#1d1d1f;padding:8px 0;">
      <input style="padding:6px 10px;background:#232325;color:#fff;border:1px solid #3a3a3c;border-radius:10px 0 0 10px;width:80px;" placeholder="search"/>
      <button style="background:#0a84ff;color:#fff;padding:6px 14px;border:none;border-radius:0 10px 10px 0;">🔍</button>
    </div>`,
    code: `
<div class="search-bar">
  <input type="text" ...>
  <button>...</button>
</div>
.search-bar { display: flex; align-items: center; }
    `,
    stock: 12,
    price: 2
  },
  {
    id: "search-bar-input",
    name: "Search Bar: Input",
    type: "Element",
    category: "Controls",
    description: "Styled search input with border, color, and radius.",
    preview: `<input style="padding:6px 10px;background:#232325;color:#fff;border:1px solid #3a3a3c;border-radius:10px;" placeholder="search"/>`,
    code: `
input[type="text"] {
  padding: 10px;
  border: 1px solid var(--border);
  border-radius: var(--radius-medium);
  background-color: var(--bg-content);
  color: var(--text-primary);
}
    `,
    stock: 20,
    price: 1
  },
  {
    id: "search-bar-button",
    name: "Search Bar: Button",
    type: "Element",
    category: "Controls",
    description: "Accent search button, blue background, rounded.",
    preview: `<button style="background:#0a84ff;color:#fff;padding:6px 14px;border:none;border-radius:10px;">🔍</button>`,
    code: `
button {
  background-color: var(--accent-blue);
  color: #fff;
  border-radius: var(--radius-medium);
  padding: 10px 16px;
}
    `,
    stock: 20,
    price: 1
  },
  // Card
  {
    id: "feature-card-container",
    name: "Card Container",
    type: "Component",
    category: "Cards",
    description: "Primary card container for feature/product display.",
    preview: `<div style="background:#1d1d1f;border-radius:20px;border:1px solid #3a3a3c;padding:16px;color:#fff;width:200px;">
      Card Content
    </div>`,
    code: `
.feature-card {
  background-color: var(--bg-content);
  border: 1px solid var(--border);
  border-radius: var(--radius-large);
}
    `,
    stock: 18,
    price: 2
  },
  // Card Gradients
  {
    id: "card-gradient-conic",
    name: "Card Gradient: Conic",
    type: "Style",
    category: "Effects",
    description: "Conic gradient background (Universal Color card).",
    preview: `<div style="height:50px;width:90px;border-radius:14px;background:conic-gradient(from 180deg at 50% 50%, #ff2d55, #ffcc00, #34c759, #007aff, #af52de, #ff2d55);"></div>`,
    code: `background: conic-gradient(from 180deg at 50% 50%, #ff2d55, #ffcc00, #34c759, #007aff, #af52de, #ff2d55);`,
    stock: 8,
    price: 1
  },
  // Sidebar
  {
    id: "sidebar-container",
    name: "Sidebar Panel",
    type: "Component",
    category: "Layouts",
    description: "Vertical sidebar with sticky positioning.",
    preview: `<div style="background:#161617;width:100px;height:80px;padding:8px;border-radius:10px;color:#fff;">Sidebar</div>`,
    code: `
.sidebar {
  background-color: var(--bg);
  border-right: 1px solid var(--border);
  position: sticky; top: 0; height: 100vh;
}
    `,
    stock: 12,
    price: 2
  },
  {
    id: "sidebar-link",
    name: "Sidebar Navigation Link",
    type: "Element",
    category: "Navigation",
    description: "Sidebar link with icon and hover effect.",
    preview: `<a style="display:flex;align-items:center;gap:8px;padding:6px 8px;color:#86868b;background:none;border-radius:8px;" href="#"><span style="width:16px;text-align:center;">📦</span>Link</a>`,
    code: `
.sidebar-nav a {
  display: flex; align-items: center; gap: 12px; padding: 8px 12px;
  color: var(--text-secondary);
  border-radius: var(--radius-medium);
}
.sidebar-nav a:hover { color: var(--text-primary); }
    `,
    stock: 32,
    price: 1
  },
  {
    id: "sidebar-toggle",
    name: "Sidebar Toggle Button",
    type: "Control",
    category: "Navigation",
    description: "Button to toggle sidebar open/close (mobile).",
    preview: `<button style="background:#0a84ff;color:#fff;padding:4px 12px;border-radius:10px;">☰</button>`,
    code: `
<button id="sidebar-toggle">☰</button>
/* JS toggles .sidebar { display: none/block; } */
    `,
    stock: 14,
    price: 1
  },
  // 🧊 Liquid Glass Merchandise
  {
    id: "glass-panel",
    name: "Liquid Glass Panel",
    type: "Component",
    category: "Effects",
    description: "Blurred, glassy background container for modern UI cards.",
    preview: `<div style="backdrop-filter: blur(10px); background: rgba(255,255,255,0.1); border-radius: 16px; border: 1px solid rgba(255,255,255,0.2); box-shadow: 0 2px 16px rgba(0,0,0,0.09); padding: 18px 20px; color:#fff; width:180px;">Liquid Glass</div>`,
    code: `
.glass-panel {
  backdrop-filter: blur(10px);
  background: rgba(255,255,255,0.1);
  border-radius: 16px;
  border: 1px solid rgba(255,255,255,0.2);
  box-shadow: 0 2px 16px rgba(0,0,0,0.09);
}
    `,
    stock: 12,
    price: 3
  },
  {
    id: "glass-shine-anim",
    name: "Glass Shine Animation",
    type: "Style",
    category: "Effects",
    description: "Pseudo-element animation for a soft shine pass over glass panels.",
    preview: `<div style="position:relative;backdrop-filter: blur(10px); background: rgba(255,255,255,0.12); border-radius: 16px; width:160px; height:50px; overflow:hidden;">
      <div style="position:absolute;left:-60px;top:0;width:60px;height:100%;background:linear-gradient(120deg,rgba(255,255,255,0) 0%,rgba(255,255,255,0.5) 50%,rgba(255,255,255,0) 100%);animation:shine 1.8s linear infinite;"></div>
      <span style="position:relative;z-index:1;color:#fff;line-height:50px;left:16px;">Shine</span>
    </div>`,
    code: `
@keyframes shine {
  0% { left: -60px; }
  100% { left: 120%; }
}
.glass-panel::before {
  content: "";
  position: absolute;
  top: 0; left: -60px;
  width: 60px; height: 100%;
  background: linear-gradient(120deg,rgba(255,255,255,0) 0%,rgba(255,255,255,0.5) 50%,rgba(255,255,255,0) 100%);
  animation: shine 1.8s linear infinite;
}
    `,
    stock: 10,
    price: 2
  },
  {
    id: "glass-ring-hover",
    name: "Glass Ring Hover",
    type: "Effect",
    category: "Interaction",
    description: "Glowing ring effect on hover for frosted glass UI elements.",
    preview: `<div style="width:90px;height:34px;border-radius:12px;background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.2);transition:box-shadow 0.2s;" onmouseover="this.style.boxShadow='0 0 0 4px rgba(10,132,255,0.25)'" onmouseout="this.style.boxShadow=''">Hover Me</div>`,
    code: `
.glass-panel:hover {
  box-shadow: 0 0 0 4px rgba(10,132,255,0.25);
}
    `,
    stock: 16,
    price: 1
  }
];

// Utility functions stay the same as before
window.getCategories = function() {
  const cats = {};
  window.inventory.forEach(item => cats[item.category] = true);
  return Object.keys(cats);
};