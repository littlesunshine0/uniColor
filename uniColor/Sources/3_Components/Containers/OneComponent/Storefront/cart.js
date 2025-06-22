// Persistent cart state using localStorage
window.cart = JSON.parse(localStorage.getItem('component-cart') || '{}');

// Add to cart
function addToCart(itemId) {
  const item = window.inventory.find(i => i.id === itemId);
  if (!item || item.stock <= 0) return;
  if (!window.cart[itemId]) window.cart[itemId] = 0;
  window.cart[itemId]++;
  item.stock--;
  persistCart();
  renderInventory(document.getElementById('search').value.trim().toLowerCase(), window.currentCategory);
  renderCart();
}

// Remove from cart
function removeFromCart(itemId) {
  if (!window.cart[itemId]) return;
  window.cart[itemId]--;
  if (window.cart[itemId] <= 0) delete window.cart[itemId];
  // Restock inventory
  const item = window.inventory.find(i => i.id === itemId);
  if (item) item.stock++;
  persistCart();
  renderInventory(document.getElementById('search').value.trim().toLowerCase(), window.currentCategory);
  renderCart();
}

// Persist cart to localStorage
function persistCart() {
  localStorage.setItem('component-cart', JSON.stringify(window.cart));
}

// Render Cart
function renderCart() {
  const cartList = document.getElementById('cart-list');
  const cartTotal = document.getElementById('cart-total');
  const cartBadge = document.getElementById('cart-badge');
  cartList.innerHTML = '';
  let totalCount = 0;
  Object.keys(window.cart).forEach(itemId => {
    const item = window.inventory.find(i => i.id === itemId);
    const qty = window.cart[itemId];
    if (!item) return;
    totalCount += qty;
    const li = document.createElement('li');
    li.innerHTML = `
      ${item.name} x${qty} 
      <button data-remove="${item.id}" class="remove-from-cart-btn" title="Remove one">
        <i class="fa-solid fa-minus-circle"></i>
      </button>
    `;
    cartList.appendChild(li);
  });
  cartTotal.textContent = totalCount === 0 ? 'Cart is empty.' : `Total items: ${totalCount}`;
  cartBadge.textContent = totalCount ? totalCount : '';
}

// Cart event (remove)
document.getElementById('cart-list').addEventListener('click', function(e) {
  if (e.target.closest('.remove-from-cart-btn')) {
    const id = e.target.closest('.remove-from-cart-btn').getAttribute('data-remove');
    removeFromCart(id);
  }
});

// Inventory restock (for demo/admin)
document.getElementById('restock-btn').addEventListener('click', function() {
  window.inventory.forEach(item => item.stock = 10);
  persistCart();
  window.cart = {};
  persistCart();
  renderInventory(document.getElementById('search').value.trim().toLowerCase(), window.currentCategory);
  renderCart();
});

// Initial cart render
renderCart();