/**
 * uniColor - Universal Scripts
 * Created by garyrobertellis on 6/21/25.
 *
 * This script handles sitewide functionality, such as filtering
 * documentation cards based on user input in the search bar.
 */
document.addEventListener('DOMContentLoaded', () => {
    const searchButton = document.getElementById('search-btn');
    const searchInput = document.getElementById('search-input');

    /**
     * Filters feature cards based on the search query.
     * Hides cards that do not match the query in their title or description.
     */
    const filterCards = () => {
        const query = searchInput.value.toLowerCase().trim();
        const cards = document.querySelectorAll('.feature-card');

        cards.forEach(card => {
            const title = card.querySelector('.card-title')?.textContent.toLowerCase() || '';
            const description = card.querySelector('.card-description')?.textContent.toLowerCase() || '';
            
            const isVisible = title.includes(query) || description.includes(query);
            card.style.display = isVisible ? 'flex' : 'none';
        });
    };

    // Add event listener for the search button click
    if (searchButton) {
        searchButton.addEventListener('click', filterCards);
    }

    // Add event listener for the Enter key in the search input
    if (searchInput) {
        searchInput.addEventListener('keypress', (event) => {
            if (event.key === 'Enter') {
                filterCards();
            }
        });
    }

    // --- Active Sidebar Link Highlighting ---
    // Get the current page name (e.g., "documentation.html")
    const currentPage = window.location.pathname.split('/').pop();
    
    // Find the corresponding link in the sidebar and add the 'active' class
    if (currentPage) {
        const activeLink = document.querySelector(`.sidebar-nav a[href="${currentPage}"]`);
        if (activeLink) {
            // First, remove 'active' from any other link to be safe
            document.querySelectorAll('.sidebar-nav a.active').forEach(link => link.classList.remove('active'));
            // Then, add it to the correct one
            activeLink.classList.add('active');
        }
    }
});
