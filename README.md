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
[![Clothing Video](https://img.youtube.com/vi/rrxA_MiPnsM/0.jpg)](https://www.youtube.com/watch?v=rrxA_MiPnsM)

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

### QB-TARGET
Add this to config.lua in qb-target:

```lua
  ["clothing01"] = {
        name = 'clothing01',
        coords = vector3(124.09, -223.50, 54.55),
        length = 0.80,
        width = 2.00,
        heading = 49.0,
        debugPoly = false,
        minZ = 53.55,
        maxZ = 55.00,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing02"] = {
        name = 'clothing02',
        coords = vector3(424.24, -802.66, 29.49),
        length = 0.60,
        width = 2.00,
        heading = 90.0,
        debugPoly = false,
        minZ = 27.49,
        maxZ = 29.89,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing03"] = {
        name = 'clothing03',
        coords = vector3(76.63, -1396.55, 29.37),
        length = 0.50,
        width = 2.00,
        heading = 90.0,
        debugPoly = false,
        minZ = 27.80,
        maxZ = 29.80,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing04"] = {
        name = 'clothing04',
        coords = vector3(-824.94, -1076.50, 11.33),
        length = 0.50,
        width = 2.00,
        heading = 28.0,
        debugPoly = false,
        minZ = 10.33,
        maxZ = 11.73,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing05"] = {
        name = 'clothing05',
        coords = vector3(-1192.42, -770.02, 17.32),
        length = 0.70,
        width = 2.00,
        heading = 18.0,
        debugPoly = false,
        minZ = 16.52,
        maxZ = 17.72,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing06"] = {
        name = 'clothing06',
        coords = vector3(-1458.18, -242.75, 49.80),
        length = 0.80,
        width = 5.20,
        heading = 137.0,
        debugPoly = false,
        minZ = 49.00,
        maxZ = 50.80,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing07"] = {
        name = 'clothing07',
        coords = vector3(-707.30, -162.12, 37.41),
        length = 0.80,
        width = 5.20,
        heading = 30.0,
        debugPoly = false,
        minZ = 36.91,
        maxZ = 38.41,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing08"] = {
        name = 'clothing08',
        coords = vector3(-158.04,-295.08,39.73),
        length = 0.80,
        width = 5.20,
        heading = 160.0,
        debugPoly = false,
        minZ = 38.93,
        maxZ = 40.73,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing09"] = {
        name = 'clothing09',
        coords = vector3(-3172.13, 1045.22, 20.86),
        length = 0.70,
        width = 2.00,
        heading = 45.0,
        debugPoly = false,
        minZ = 19.86,
        maxZ = 21.36,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing10"] = {
        name = 'clothing10',
        coords = vector3(-1103.13, 2707.27, 19.10),
        length = 0.60,
        width = 2.00,
        heading = 42.0,
        debugPoly = false,
        minZ = 18.10,
        maxZ = 19.50,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing11"] = {
        name = 'clothing11',
        coords = vector3(616.34, 2762.36, 42.08),
        length = 0.60,
        width = 2.00,
        heading = 72.0,
        debugPoly = false,
        minZ = 41.08,
        maxZ = 42.68,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing12"] = {
        name = 'clothing12',
        coords = vector3(1193.16, 2708.91, 38.22),
        length = 0.60,
        width = 2.00,
        heading = 0.0,
        debugPoly = false,
        minZ = 37.22,
        maxZ = 38.62,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
    ["clothing13"] = {
        name = 'clothing13',
        coords = vector3(1692.06, 4826.13, 42.07),
        length = 0.80,
        width = 2.00,
        heading = 95.0,
        debugPoly = false,
        minZ = 41.07,
        maxZ = 42.87,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
	["clothing14"] = {
        name = 'clothing14',
        coords = vector3(6.51, 6515.73, 31.87),
        length = 0.50,
        width = 2.00,
        heading = 45.0,
        debugPoly = false,
        minZ = 30.80,
        maxZ = 32.40,
        options = {
            {
                type = "client",
                event = "qz_clothing:openMenu",
                icon = "fas fa-newspaper",
                label = "Open Clothing",
                --job = {"all"},
            },
        },
        distance = 3.5
    },
```

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
