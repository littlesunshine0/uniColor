// Main UI logic for inventory & modal
window.currentCategory = null;

// Sidebar nav: categories
function renderSidebarNav() {
  const nav = document.getElementById('sidebar-nav');
  nav.innerHTML = '';
  // 'All' option
  const allA = document.createElement('a');
  allA.href = "#";
  allA.innerHTML = `<i class="fa-solid fa-box-archive"></i>All`;
  if (!window.currentCategory) allA.classList.add('active');
  allA.onclick = (e) => { e.preventDefault(); window.currentCategory = null; renderSidebarNav(); renderInventory(); };
  nav.appendChild(allA);

  // Category filters
  window.getCategories().forEach(cat => {
    const a = document.createElement('a');
    a.href = "#";
    a.innerHTML = `<i class="fa-solid fa-tag"></i>${cat}`;
    if (window.currentCategory === cat) a.classList.add('active');
    a.onclick = (e) => { e.preventDefault(); window.currentCategory = cat; renderSidebarNav(); renderInventory(); };
    nav.appendChild(a);
  });
}

// Render inventory cards (with modal/detail)
function renderInventory(filter = '', category = window.currentCategory) {
  const grid = document.getElementById('inventory-grid');
  grid.innerHTML = '';
  window.inventory.forEach(item => {
    if (
      (filter && !item.name.toLowerCase().includes(filter) && !item.description.toLowerCase().includes(filter)) ||
      (category && item.category !== category)
    ) return;
    const card = document.createElement('div');
    card.className = 'feature-card';
    card.id = item.id;
    card.innerHTML = `
      <div class="card-visual" id="${item.visualId}">
        <i class="fa-solid ${item.icon}"></i>
      </div>
      <div class="card-text">
        <span class="card-category">${item.type}</span>
        <h3 class="card-title">${item.name}</h3>
        <p class="card-description">${item.description}</p>
        <button class="add-to-cart-btn" data-id="${item.id}" ${item.stock <= 0 ? 'disabled' : ''}>
          ${item.stock > 0 ? 'Add to Cart' : 'Out of Stock'}
        </button>
        <button class="details-btn" data-details="${item.id}">
          <i class="fa-solid fa-circle-info"></i> Details
        </button>
      </div>
    `;
    grid.appendChild(card);
  });
}

// Search functionality
function setupSearch() {
  const input = document.getElementById('search');
  const btn = document.getElementById('search-btn');
  function search() {
    renderInventory(input.value.trim().toLowerCase(), window.currentCategory);
  }
  btn.addEventListener('click', search);
  input.addEventListener('keypress', function(event) {
    if (event.key === 'Enter') search();
  });
}

// Add-to-cart & Details (event delegation)
function setupInventoryEvents() {
  document.getElementById('inventory-grid').addEventListener('click', function(e) {
    if (e.target.closest('.add-to-cart-btn')) {
      const id = e.target.closest('.add-to-cart-btn').getAttribute('data-id');
      addToCart(id);
    } else if (e.target.closest('.details-btn')) {
      const id = e.target.closest('.details-btn').getAttribute('data-details');
      showDetailsModal(id);
    }
  });
}

// Modal logic
function showDetailsModal(itemId) {
  const item = window.inventory.find(i => i.id === itemId);
  if (!item) return;
  document.getElementById('modal-title').innerHTML = item.name;
  document.getElementById('modal-content').innerHTML = item.details || item.description;
  document.getElementById('modal').classList.add('show');
}
document.getElementById('modal-close').onclick = function() {
  document.getElementById('modal').classList.remove('show');
};
// Click outside modal to close
document.getElementById('modal').onclick = function(e) {
  if (e.target === this) this.classList.remove('show');
};

// Initial render
renderSidebarNav();
renderInventory();
setupSearch();
setupInventoryEvents();