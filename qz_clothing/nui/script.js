const bcategories = [
    { id: 'upper', title: 'UPPER BODY', icon: 'fa-shirt' },
    { id: 'lower', title: 'LOWER BODY', icon: 'fa-shoe-prints' },
    { id: 'accessories', title: 'ACCESSORIES', icon: 'fa-glasses' }
];

const parts = [
    { cat: 'upper', id: 'hat', title: 'HATS', img: 'assets/hat.png' },
    { cat: 'upper', id: 'hoodie', title: 'HOODIES', img: 'assets/hanorac.png' },
    { cat: 'upper', id: 'shirt', title: 'SHIRTS', img: 'assets/shirt.png' },
    { cat: 'upper', id: 'glove', title: 'GLOVES', img: 'assets/gloves.png' },
    { cat: 'upper', id: 'vest', title: 'VESTS', img: 'assets/vest.png' },
    { cat: 'upper', id: 'mask', title: 'MASKS', img: 'assets/mask.png' },

    { cat: 'lower', id: 'pants', title: 'PANTS', img: 'assets/pants.png' },
    { cat: 'lower', id: 'shoes', title: 'SHOES', img: 'assets/shoes.png' },

    { cat: 'accessories', id: 'bags', title: 'BAGS', img: 'assets/bags.png' },
    { cat: 'accessories', id: 'neck', title: 'NECK', img: 'assets/neck.png' },
    { cat: 'accessories', id: 'glasses', title: 'GLASSES', img: 'assets/glasses.png' },
    { cat: 'accessories', id: 'ears', title: 'EAR', img: 'assets/ear.png' },
];

let selectedBodyPart = null;
let selectedPart = null;
let selectedClothing = null;
let clothingData = null;
let cart = [];
let allItems = [];
let itemsRendered = 0;
const initialLoad = 50;
const loadMore = 30;
let isLoading = false;
let hasMoreItems = true;
let purchaseSuccessful = false;

function renderBodyParts() {
    const container = document.querySelector('.body-category');
    container.innerHTML = '';

    bcategories.forEach(category => {
        const item = document.createElement('button');
        item.className = 'body-category-item';
        if (selectedBodyPart === category.id) {
            item.classList.add('active');
        }
        item.innerHTML = `
            <i class="fas ${category.icon} body-category-icon"></i>
            <span class="body-category-title">${category.title}</span>
        `;
        item.addEventListener('click', () => {
            selectedBodyPart = category.id;
            selectedClothing = null;
            renderBodyParts();
            renderParts();
            hasMoreItems = false;
            selectedPart = null;
            document.querySelector('.clothes-container').innerHTML = '';
            fetch('https://qz_clothing/changeCategory', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ category: category.id })
            });
        });
        container.appendChild(item);
    });
}

function renderParts() {
    const container = document.querySelector('.parts-category');
    container.innerHTML = '';

    const filteredParts = parts.filter(part => part.cat === selectedBodyPart);

    filteredParts.forEach(part => {
        const item = document.createElement('button');
        item.className = 'part-item';
        if (selectedPart === part.id) {
            item.classList.add('active');
        }
        item.innerHTML = `
            <img src="${part.img}" alt="${part.title}" class="part-image">
            <span class="part-title">${part.title}</span>
        `;
        item.addEventListener('click', () => {
            selectedPart = part.id;
            currentPage = 0;
            renderParts();
            renderClothes();
        });
        container.appendChild(item);
    });
}

function getAllItemsForCategory(category) {
    const allItems = [];
    for (const compKey in clothingData.components) {
        const comp = clothingData.components[compKey];
        comp.items.forEach(item => {
            if (item.category === category) {
                allItems.push({ ...item, component: compKey, type: 'component' });
            }
        });
    }
    for (const propKey in clothingData.props) {
        const prop = clothingData.props[propKey];
        prop.items.forEach(item => {
            if (item.category === category) {
                allItems.push({ ...item, component: propKey, type: 'prop' });
            }
        });
    }
    return allItems;
}

function loadMoreItems() {
    if (isLoading || !hasMoreItems || !selectedPart) return;
    
    isLoading = true;
    const container = document.querySelector('.clothes-container');
    const endIndex = Math.min(itemsRendered + loadMore, allItems.length);
    
    for (let i = itemsRendered; i < endIndex; i++) {
        const item = allItems[i];
        const div = document.createElement('div');
        div.className = 'clothing-item';
        if (selectedClothing && selectedClothing.id === item.id) {
            div.classList.add('active');
        }
        div.innerHTML = `
            <img src="${item.image}" alt="Clothing" class="clothing-image" onerror="this.src='assets/default.png'">
            <span class="clothing-price">${item.price}</span>
            <span class="clothing-name">${item.name}</span>
        `;
        div.addEventListener('click', () => {
            selectedClothing = item;
            document.querySelectorAll('.clothing-item').forEach(el => el.classList.remove('active'));
            div.classList.add('active');
            addToCart(item);
            fetch('https://qz_clothing/changeClothing', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: item.type,
                    component: parseInt(item.component),
                    drawable: item.drawable,
                    texture: item.texture
                })
            });
        });
        container.appendChild(div);
    }
    
    itemsRendered = endIndex;
    hasMoreItems = itemsRendered < allItems.length;
    isLoading = false;
}

function renderClothes() {
    const container = document.querySelector('.clothes-container');
    container.innerHTML = '';
    if (!selectedPart || !clothingData) return;
    
    allItems = getAllItemsForCategory(selectedPart);
    itemsRendered = 0;
    hasMoreItems = true;
    isLoading = false;

    loadMoreItems();

    container.onscroll = function() {
        if (hasMoreItems && !isLoading) {
            const scrollTop = container.scrollTop;
            const scrollHeight = container.scrollHeight;
            const clientHeight = container.clientHeight;

            if (scrollTop + clientHeight >= scrollHeight - 200) {
                loadMoreItems();
            }
        }
    };
}

function addToCart(item) {
    const existingIndex = cart.findIndex(cartItem => cartItem.category === item.category);
    if (existingIndex !== -1) {
        cart.splice(existingIndex, 1);
    }
    cart.push(item);
    renderCart();
}

function removeFromCart(index) {
    const item = cart[index];
    cart.splice(index, 1);
    if (item && item.category) {
        fetch('https://qz_clothing/restoreClothing', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                category: item.category,
                type: item.type,
                component: parseInt(item.component)
            })
        });
    }
    
    renderCart();
}

function renderCart() {
    const container = document.querySelector('.items-container');
    container.innerHTML = '';
    cart.forEach((item, index) => {
        const cartItem = document.createElement('div');
        cartItem.className = 'cart-item';
        cartItem.innerHTML = `
            <img src="${item.image}" alt="${item.name}" class="cart-item-image">
            <div class="cart-item-details">
                <span class="cart-item-name">${item.name}</span>
                <span class="cart-item-category">${item.category}</span>
                <span class="cart-item-price">$${item.price}</span>
            </div>
            <button class="remove-btn"><i class="fa-regular fa-trash-can"></i></button>
        `;
        const removeBtn = cartItem.querySelector('.remove-btn');
        removeBtn.addEventListener('click', () => removeFromCart(index));
        container.appendChild(cartItem);
    });
    updateTotal();
}

function updateTotal() {
    const total = cart.reduce((sum, item) => sum + item.price, 0);
    document.querySelector('.final-price').textContent = `$${total.toFixed(2)}`;
}

window.addEventListener('message', function(event) {
    if (event.data.action === 'open') {
        document.body.style.display = 'block';
        purchaseSuccessful = false;
        renderBodyParts();
        renderParts();
        if (clothingData && selectedPart) {
            renderClothes();
        }
    } else if (event.data.action === 'purchaseSuccess') {
        purchaseSuccessful = true;
        cart = [];
        renderCart();
        document.body.style.display = 'none';
        fetch('https://qz_clothing/close', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ keepClothes: true })
        });
    } else if (event.data.action === 'purchaseError') {
    }
});

document.addEventListener('DOMContentLoaded', async () => {
    fetch('clothing.json')
    .then(response => response.json())
    .then(data => {
        clothingData = data;
        console.log('Clothing data loaded:', clothingData);
        console.log('Props 0 items:', clothingData.props ? clothingData.props['0'] : 'no props');
        console.log('Props 0 items count:', clothingData.props && clothingData.props['0'] ? clothingData.props['0'].items.length : 0);
    });

    let rotateInterval = null;
    
    document.addEventListener('keydown', (e) => {
        if (document.body.style.display === 'none') return;
        
        if (e.key === 'a' || e.key === 'A') {
            if (!rotateInterval) {
                fetch('https://qz_clothing/rotateCharacter', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ direction: 'left' })
                });
                rotateInterval = setInterval(() => {
                    fetch('https://qz_clothing/rotateCharacter', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ direction: 'left' })
                    });
                }, 50);
            }
        } else if (e.key === 'd' || e.key === 'D') {
            if (!rotateInterval) {
                fetch('https://qz_clothing/rotateCharacter', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ direction: 'right' })
                });
                rotateInterval = setInterval(() => {
                    fetch('https://qz_clothing/rotateCharacter', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ direction: 'right' })
                    });
                }, 50);
            }
        }
    });
    
    document.addEventListener('keyup', (e) => {
        if (e.key === 'a' || e.key === 'A' || e.key === 'd' || e.key === 'D') {
            if (rotateInterval) {
                clearInterval(rotateInterval);
                rotateInterval = null;
            }
        }
    });

    document.getElementById('exit-btn').addEventListener('click', function() {
        cart = [];
        renderCart();
        document.body.style.display = 'none';
        fetch('https://qz_clothing/close', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ keepClothes: purchaseSuccessful })
        });
    });

    document.getElementById('purchase').addEventListener('click', function() {
        if (cart.length === 0) {
            return;
        }
        fetch('https://qz_clothing/purchase', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ cart: cart })
        });
    });
});