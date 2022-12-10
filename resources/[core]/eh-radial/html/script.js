'use strict';

var menuItems = [
    {
        id   : 'dashboard',
        title: 'Dashboard',
        icon: '#dashboard'
    },
    {
        id   : 'seat',
        title: 'Seats',
        icon: '#more',
        items: [
            {
                id: 'seat -1',
                title: 'Driver',
                icon: '#seat'
            },
            {
                id: 'seat 0',
                title: 'Passenger',
                icon: '#seat'
            },
            {
                id: 'seat 1',
                title: 'Back 1',
                icon: '#seat'
            },
            {
                id: 'seat 2',
                title: 'Back 2',
                icon: '#seat'
            },
            {
                id: 'seat 3',
                title: 'Back 3',
                icon: '#seat'
            },
            {
                id: 'seat 4',
                title: 'Back 4',
                icon: '#seat'
            }
        ]
    },
    {
        id   : 'engine',
        title: 'Engine',
        icon: '#drive'
    },
    {
        id   : 'hood',
        title: 'Hood',
        icon: '#hood'
    },
    {
        id   : 'window',
        title: 'Windows',
        icon: '#more',
        items: [
            {
                id: 'rlwindow',
                title: 'RL Window',
                icon: '#windowLeft'
            },
            {
                id: 'flwindow',
                title: 'FL Window',
                icon: '#windowLeft'
            },
            {
                id: 'frwindow',
                title: 'FR Window',
                icon: '#windowRight'
            },
            {
                id: 'rrwindow',
                title: 'RR Window',
                icon: '#windowRight'
            }
        ]
    },
    {
        id: 'door',
        title: 'Doors',
        icon: '#more',
        items: [
            {
                id: 'rldoor',
                title: 'RL Door',
                icon: '#doorLeft'
            },
            {
                id: 'fldoor',
                title: 'FL Door',
                icon: '#doorLeft'
            },
            {
                id: 'frdoor',
                title: 'FR Door',
                icon: '#doorRight'
            },
            {
                id: 'rrdoor',
                title: 'RR Door',
                icon: '#doorRight'
            }
        ]
    }
];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
window.onload = function () {
    var svgMenu = new RadialMenu({
        parent      : document.body,
        size        : 400,
        closeOnClick: true,
        menuItems   : menuItems,
        onClick     : function (item) {
            NUIcommand(item.id);
        }
    });


    window.addEventListener('message', (event) => {
        let item = event.data;

        if (item.type === 'open-radial') {
            svgMenu.open();
        }

        if (item.type === 'close-radial') {
            svgMenu.close();
        }
    });

    window.addEventListener('keyup', (event) => {
        if (event.key === 'F1' && svgMenu.currentMenu) {
            svgMenu.close();
            NUIclose();
        }
    });
};

function NUIclose() {
    $.post(`https://${GetParentResourceName()}/close-radial`);
}

function NUIcommand(commandString) {
    $.post(`https://${GetParentResourceName()}/command`, JSON.stringify({
        commandId: commandString
    }));
}

var DEFAULT_SIZE = 100;
var MIN_SECTORS  = 6;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RadialMenu(params) {
    var self = this;

    self.parent  = params.parent  || [];

    self.size      = params.size    || DEFAULT_SIZE;
    self.onClick   = params.onClick || null;
    self.menuItems = params.menuItems ? params.menuItems : [{id: 'one', title: 'One'}, {id: 'two', title: 'Two'}];

    self.radius      = 50;
    self.innerRadius = self.radius * 0.4;
    self.sectorSpace = self.radius * 0.06;
    self.sectorCount = Math.max(self.menuItems.length, MIN_SECTORS);
    self.closeOnClick = params.closeOnClick !== undefined ? !!params.closeOnClick : false;

    self.scale       = 1;
    self.holder      = null;
    self.parentMenu  = [];
    self.parentItems = [];
    self.levelItems  = null;

    self.createHolder();
    self.addIconSymbols();

    self.currentMenu = null;
    document.addEventListener('wheel', self.onMouseWheel.bind(self));
    document.addEventListener('keydown', self.onKeyDown.bind(self));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.open = function () {
    var self = this;
    if (!self.currentMenu) {
        self.currentMenu = self.createMenu('menu inner', self.menuItems);
        self.holder.appendChild(self.currentMenu);

        // wait DOM commands to apply and then set class to allow transition to take effect
        RadialMenu.nextTick(function () {
            self.currentMenu.setAttribute('class', 'menu');
        });
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.close = function () {
    var self = this;

    if (self.currentMenu) {
        var parentMenu;
        while (parentMenu = self.parentMenu.pop()) {
            parentMenu.remove();
        }
        self.parentItems = [];

        RadialMenu.setClassAndWaitForTransition(self.currentMenu, 'menu inner').then(function () {
            self.currentMenu.remove();
            self.currentMenu = null;
            NUIclose();
        });
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.getParentMenu = function () {
    var self = this;
    if (self.parentMenu.length > 0) {
        return self.parentMenu[self.parentMenu.length - 1];
    } else {
        return null;
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createHolder = function () {
    var self = this;

    self.holder = document.createElement('div');
    self.holder.className = 'menuHolder';
    self.holder.style.width  = self.size + 'px';
    self.holder.style.height = self.size + 'px';

    self.parent.appendChild(self.holder);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.showNestedMenu = function (item) {
    var self = this;
    self.parentMenu.push(self.currentMenu);
    self.parentItems.push(self.levelItems);
    self.currentMenu = self.createMenu('menu inner', item.items, true);
    self.holder.appendChild(self.currentMenu);

    // wait DOM commands to apply and then set class to allow transition to take effect
    RadialMenu.nextTick(function () {
        self.getParentMenu().setAttribute('class', 'menu outer');
        self.currentMenu.setAttribute('class', 'menu');
    });
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.returnToParentMenu = function () {
    var self = this;
    self.getParentMenu().setAttribute('class', 'menu');
    RadialMenu.setClassAndWaitForTransition(self.currentMenu, 'menu inner').then(function () {
        self.currentMenu.remove();
        self.currentMenu = self.parentMenu.pop();
        self.levelItems = self.parentItems.pop();
    });
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.handleClick = function () {
    var self = this;

    var selectedIndex = self.getSelectedIndex();
    if (selectedIndex >= 0) {
        var item = self.levelItems[selectedIndex];
        if (item.items) {
            self.showNestedMenu(item);
        } else {
            if (self.onClick) {
                self.onClick(item);
                if (self.closeOnClick) {
                    self.close();
                }
            }
        }
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.handleCenterClick = function () {
    var self = this;
    if (self.parentItems.length > 0) {
        self.returnToParentMenu();
    } else {
        self.close();
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createCenter = function (svg, title, icon, size) {
    var self = this;
    size = size || 8;
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    g.setAttribute('class', 'center');

    var centerCircle = self.createCircle(0, 0, self.innerRadius - self.sectorSpace / 3);
    g.appendChild(centerCircle);
    if (text) {
        var text = self.createText(0,0, title);
        g.appendChild(text);
    }

    if (icon) {
        var use = self.createUseTag(0,0, icon);
        use.setAttribute('width', size);
        use.setAttribute('height', size);
        use.setAttribute('transform', 'translate(-' + RadialMenu.numberToString(size / 2) + ',-' + RadialMenu.numberToString(size / 2) + ')');
        g.appendChild(use);
    }

    svg.appendChild(g);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.getIndexOffset = function () {
    var self = this;
    if (self.levelItems.length < self.sectorCount) {
        switch (self.levelItems.length) {
            case 1:
                return -2;
            case 2:
                return -2;
            case 3:
                return -2;
            default:
                return -1;
        }
    } else {
        return -1;
    }

};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createMenu = function (classValue, levelItems, nested) {
    var self = this;

    self.levelItems = levelItems;

    self.sectorCount = Math.max(self.levelItems.length, MIN_SECTORS);
    self.scale       = self.calcScale();

    var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('class', classValue);
    svg.setAttribute('viewBox', '-50 -50 100 100');
    svg.setAttribute('width', self.size);
    svg.setAttribute('height', self.size);

    var angleStep   = 360 / self.sectorCount;
    var angleShift  = angleStep / 2 + 270;

    var indexOffset = self.getIndexOffset();

    for (var i = 0; i < self.sectorCount; ++i) {
        var startAngle = angleShift + angleStep * i;
        var endAngle   = angleShift + angleStep * (i + 1);

        var itemIndex = RadialMenu.resolveLoopIndex(self.sectorCount - i + indexOffset, self.sectorCount);
        var item;
        if (itemIndex >= 0 && itemIndex < self.levelItems.length) {
            item = self.levelItems[itemIndex];
        } else {
            item = null;
        }

        self.appendSectorPath(startAngle, endAngle, svg, item, itemIndex);
    }

    if (nested) {
        self.createCenter(svg, 'Close', '#return', 8);
    } else {
        self.createCenter(svg, 'Close', '#close', 7);
    }

    svg.addEventListener('mousedown', function (event) {
        var className = event.target.parentNode.getAttribute('class').split(' ')[0];
        switch (className) {
            case 'sector':
                var index = parseInt(event.target.parentNode.getAttribute('data-index'));
                if (!isNaN(index)) {
                    self.setSelectedIndex(index);
                }
                break;
            default:
        }
    });

    svg.addEventListener('click', function (event) {
        var className = event.target.parentNode.getAttribute('class').split(' ')[0];
        switch (className) {
            case 'sector':
                self.handleClick();
                break;
            case 'center':
                self.handleCenterClick();
                break;
            default:
        }
    });
    return svg;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.selectDelta = function (indexDelta) {
    var self = this;
    var selectedIndex = self.getSelectedIndex();
    if (selectedIndex < 0) {
        selectedIndex = 0;
    }
    selectedIndex += indexDelta;

    if (selectedIndex < 0) {
        selectedIndex = self.levelItems.length + selectedIndex;
    } else if (selectedIndex >= self.levelItems.length) {
        selectedIndex -= self.levelItems.length;
    }
    self.setSelectedIndex(selectedIndex);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.onKeyDown = function (event) {
    var self = this;
    if (self.currentMenu) {
        switch (event.key) {
            case 'Escape':
            case 'Backspace':
                self.handleCenterClick();
                event.preventDefault();
                break;
            case 'Enter':
                self.handleClick();
                event.preventDefault();
                break;
            case 'ArrowRight':
            case 'ArrowUp':
                self.selectDelta(1);
                event.preventDefault();
                break;
            case 'ArrowLeft':
            case 'ArrowDown':
                self.selectDelta(-1);
                event.preventDefault();
                break;
        }
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.onMouseWheel = function (event) {
    var self = this;
    if (self.currentMenu) {
        var delta = -event.deltaY;

        if (delta > 0) {
            self.selectDelta(1)
        } else {
            self.selectDelta(-1)
        }
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.getSelectedNode = function () {
    var self = this;
    var items = self.currentMenu.getElementsByClassName('selected');
    if (items.length > 0) {
        return items[0];
    } else {
        return null;
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.getSelectedIndex = function () {
    var self = this;
    var selectedNode = self.getSelectedNode();
    if (selectedNode) {
        return parseInt(selectedNode.getAttribute('data-index'));
    } else {
        return -1;
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.setSelectedIndex = function (index) {
    var self = this;
    if (index >=0 && index < self.levelItems.length) {
        var items = self.currentMenu.querySelectorAll('g[data-index="' + index + '"]');
        if (items.length > 0) {
            var itemToSelect = items[0];
            var selectedNode = self.getSelectedNode();
            if (selectedNode) {
                selectedNode.setAttribute('class', 'sector');
            }
            itemToSelect.setAttribute('class', 'sector selected');
        }
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createUseTag = function (x, y, link) {
    var use = document.createElementNS('http://www.w3.org/2000/svg', 'use');
    use.setAttribute('x', RadialMenu.numberToString(x));
    use.setAttribute('y', RadialMenu.numberToString(y));
    use.setAttribute('width', '10');
    use.setAttribute('height', '10');
    use.setAttribute('fill', 'white');
    use.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', link);
    return use;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.appendSectorPath = function (startAngleDeg, endAngleDeg, svg, item, index) {
    var self = this;

    var centerPoint = self.getSectorCenter(startAngleDeg, endAngleDeg);
    var translate = {
        x: RadialMenu.numberToString((1 - self.scale) * centerPoint.x),
        y: RadialMenu.numberToString((1 - self.scale) * centerPoint.y)
    };

    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    g.setAttribute('transform','translate(' +translate.x + ' ,' + translate.y + ') scale(' + self.scale + ')');

    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', self.createSectorCmds(startAngleDeg, endAngleDeg));
    g.appendChild(path);

    if (item) {
        g.setAttribute('class', 'sector');
        if (index == 0) {
            g.setAttribute('class', 'sector selected');
        }
        g.setAttribute('data-id', item.id);
        g.setAttribute('data-index', index);

        if (item.title) {
            var text = self.createText(centerPoint.x, centerPoint.y, item.title);
            if (item.icon) {
                text.setAttribute('transform', 'translate(0,8)');
            } else {
                text.setAttribute('transform', 'translate(0,2)');
            }

            g.appendChild(text);
        }

        if (item.icon) {
            var use = self.createUseTag(centerPoint.x, centerPoint.y, item.icon);
            if (item.title) {
                use.setAttribute('transform', 'translate(-5,-8)');
            } else {
                use.setAttribute('transform', 'translate(-5,-5)');
            }

            g.appendChild(use);
        }

    } else {
        g.setAttribute('class', 'dummy');
    }

    svg.appendChild(g);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createSectorCmds = function (startAngleDeg, endAngleDeg) {
    var self = this;

    var initPoint = RadialMenu.getDegreePos(startAngleDeg, self.radius);
    var path = 'M' + RadialMenu.pointToString(initPoint);

    var radiusAfterScale = self.radius * (1 / self.scale);
    path += 'A' + radiusAfterScale + ' ' + radiusAfterScale + ' 0 0 0' + RadialMenu.pointToString(RadialMenu.getDegreePos(endAngleDeg, self.radius));
    path += 'L' + RadialMenu.pointToString(RadialMenu.getDegreePos(endAngleDeg, self.innerRadius));

    var radiusDiff = self.radius - self.innerRadius;
    var radiusDelta = (radiusDiff - (radiusDiff * self.scale)) / 2;
    var innerRadius = (self.innerRadius + radiusDelta) * (1 / self.scale);
    path += 'A' + innerRadius + ' ' + innerRadius + ' 0 0 1 ' + RadialMenu.pointToString(RadialMenu.getDegreePos(startAngleDeg, self.innerRadius));
    path += 'Z';

    return path;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createText = function (x, y, title) {
    var self = this;
    var text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    text.setAttribute('text-anchor', 'middle');
    text.setAttribute('x', RadialMenu.numberToString(x));
    text.setAttribute('y', RadialMenu.numberToString(y));
    text.setAttribute('font-size', '38%');
    text.innerHTML = title;
    return text;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.createCircle = function (x, y, r) {
    var circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    circle.setAttribute('cx',RadialMenu.numberToString(x));
    circle.setAttribute('cy',RadialMenu.numberToString(y));
    circle.setAttribute('r',r);
    return circle;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.calcScale = function () {
    var self = this;
    var totalSpace = self.sectorSpace * self.sectorCount;
    var circleLength = Math.PI * 2 * self.radius;
    var radiusDelta = self.radius - (circleLength - totalSpace) / (Math.PI * 2);
    return (self.radius - radiusDelta) / self.radius;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.getSectorCenter = function (startAngleDeg, endAngleDeg) {
    var self = this;
    return RadialMenu.getDegreePos((startAngleDeg + endAngleDeg) / 2, self.innerRadius + (self.radius - self.innerRadius) / 2);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.prototype.addIconSymbols = function () {
    var self = this;
    var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('class', 'icons');

    // return
    var returnSymbol = document.createElementNS('http://www.w3.org/2000/svg', 'symbol');
    returnSymbol.setAttribute('id', 'return');
    returnSymbol.setAttribute('viewBox', '0 0 512 512');
    var returnPath =   document.createElementNS('http://www.w3.org/2000/svg', 'path');
    returnPath.setAttribute('d', "M48.5 224H40c-13.3 0-24-10.7-24-24V72c0-9.7 5.8-18.5 14.8-22.2s19.3-1.7 26.2 5.2L98.6 96.6c87.6-86.5 228.7-86.2 315.8 1c87.5 87.5 87.5 229.3 0 316.8s-229.3 87.5-316.8 0c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0c62.5 62.5 163.8 62.5 226.3 0s62.5-163.8 0-226.3c-62.2-62.2-162.7-62.5-225.3-1L185 183c6.9 6.9 8.9 17.2 5.2 26.2s-12.5 14.8-22.2 14.8H48.5z");
    returnSymbol.appendChild(returnPath);
    svg.appendChild(returnSymbol);

    var closeSymbol = document.createElementNS('http://www.w3.org/2000/svg', 'symbol');
    closeSymbol.setAttribute('id', 'close');
    closeSymbol.setAttribute('viewBox', '0 0 512 512');

    var closePath = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    closePath.setAttribute('d', "M160 96c17.7 0 32-14.3 32-32s-14.3-32-32-32H96C43 32 0 75 0 128V384c0 53 43 96 96 96h64c17.7 0 32-14.3 32-32s-14.3-32-32-32H96c-17.7 0-32-14.3-32-32l0-256c0-17.7 14.3-32 32-32h64zM504.5 273.4c4.8-4.5 7.5-10.8 7.5-17.4s-2.7-12.9-7.5-17.4l-144-136c-7-6.6-17.2-8.4-26-4.6s-14.5 12.5-14.5 22v72H192c-17.7 0-32 14.3-32 32l0 64c0 17.7 14.3 32 32 32H320v72c0 9.6 5.7 18.2 14.5 22s19 2 26-4.6l144-136z");
    closeSymbol.appendChild(closePath);
    svg.appendChild(closeSymbol);

    self.holder.appendChild(svg);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.getDegreePos = function (angleDeg, length) {
    return {
        x: Math.sin(RadialMenu.degToRad(angleDeg)) * length,
        y: Math.cos(RadialMenu.degToRad(angleDeg)) * length
    };
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.pointToString = function (point) {
    return RadialMenu.numberToString(point.x) + ' ' + RadialMenu.numberToString(point.y);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.numberToString = function (n) {
    if (Number.isInteger(n)) {
        return n.toString();
    } else if (n) {
        var r = (+n).toFixed(5);
        if (r.match(/\./)) {
            r = r.replace(/\.?0+$/, '');
        }
        return r;
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.resolveLoopIndex = function (index, length) {
    if (index < 0) {
        index = length + index;
    }
    if (index >= length) {
        index = index - length;
    }
    if (index < length) {
        return index;
    } else {
        return null;
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.degToRad = function (deg) {
    return deg * (Math.PI / 180);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.setClassAndWaitForTransition = function (node, newClass) {
    return new Promise(function (resolve) {
        function handler(event) {
            if (event.target == node && event.propertyName == 'visibility') {
                node.removeEventListener('transitionend', handler);
                resolve();
            }
        }
        node.addEventListener('transitionend', handler);
        node.setAttribute('class', newClass);
    });
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RadialMenu.nextTick = function (fn) {
    setTimeout(fn, 10);
};

function NUIclose() {
    $.post(`https://${GetParentResourceName()}/close-radial`);
}