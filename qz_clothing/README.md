# qz_clothing

## Features

### 👕 Clothing Shop System
- Interactive web-based clothing store interface
- Browse clothing by category (Upper Body, Lower Body, Accessories)
- Preview clothing items on your character before purchasing
- Real-time clothing preview and application

### 🛒 Shopping Cart
- Add clothing items to cart
- One item per category restriction (adding new item replaces existing)
- Easy cart management with remove functionality
- Total price calculation

### 🎯 One-Click Purchase
- Click on clothing to add to cart AND preview on character
- Remove from cart to restore original clothing
- Purchase completes the transaction
- Original clothing restored if exiting without purchase

### 📱 Web UI Interface
- Clean, modern web interface
- Scrollable clothing and cart lists
- Visual category selection

## Video Preview

### Clothing Shop Showcase
[![Clothing Video](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)

*Watch the full clothing shop experience in action*

## Installation

1. Download the script files
2. Place the `qz_clothing` folder in your `resources` directory
3. Add `start qz_clothing` to your `server.cfg`

## Dependencies

- vRP2 Framework

### Browsing Clothing
1. Select a category (Upper Body, Lower Body, Accessories)
2. Choose a clothing type (Hats, Hoodies, Shirts, Pants, etc.)
3. Browse available items

### Purchasing
1. Click on any clothing item to add to cart and preview
2. View cart items on the right panel
3. Click purchase to complete transaction
4. Items are permanently saved to your character

## Configuration

### Categories
Edit `nui/script.js` to modify clothing categories:

```javascript
const parts = [
    { cat: 'upper', id: 'hat', title: 'HATS', img: 'assets/hat.png' },
    { cat: 'upper', id: 'hoodie', title: 'HOODIES', img: 'assets/hanorac.png' },
    // Add more categories here
];
```

### UI Styling
Edit `nui/style.css` to customize appearance.

### Camera Positions
Modify camera angles in `client.lua`:

```lua
local cameraPositions = {
    upper = {
        coords = vector3(0.0, -1.5, 0.3),
        rot = vector3(0.0, 0.0, 0.0)
    },
    -- Configure other positions
}
```

### Changing Prices
Edit the clothing database in `nui/clothing.json` to modify prices.

### UI Colors
Modify the CSS variables and gradient colors in `nui/style.css`.

## Troubleshooting

- **Clothing not showing**: Check `clothing.json` format
- **Purchase failing**: Check vRP payment integration

## Support

For issues or questions, please create an issue on the GitHub repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
