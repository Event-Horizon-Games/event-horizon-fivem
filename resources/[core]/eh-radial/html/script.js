$(() => {
    // Hide the radial menu to start
    $('.radial-menu').addClass('is-hidden');
    $('.radial-menu').removeClass('is-active');

    //
    //  BASIC SETUP
    //–––––––––––––––––––––––––––––––––––––

    var container = document.querySelector('.radial-menu');

    var menuDimensions = container.offsetWidth;

    var menuItems = container.querySelectorAll('.radial-menu__menu-item');

    var menuItemsCount = countMenuItems(menuItems);


    //
    //  COUNT MENU ITEMS
    //–––––––––––––––––––––––––––––––––––––

    function countMenuItems(elems) {

        // Count elems.
        var elemsCount = elems.length;

        // Initialise empty counter.
        var elemCounter = 0;

        for (var i = 0; i < elemsCount; i++) {

            var elem = elems[i];

            // Get elements current "display" value.
            var elemDisplay = elem.currentStyle ? elem.currentStyle.display : getComputedStyle(elem, null).display;

            // If the elem is not hidden.
            if (elemDisplay !== 'none') {

                // Increment the elem counter.
                elemCounter++;
            }
        }

        return elemCounter;
    }


    //
    //  LINKS
    //–––––––––––––––––––––––––––––––––––––

    var links = document.querySelectorAll('.radial-menu__menu-link');

    setupLinks(links);
    setupLinkHovers(links);


    //
    //  LINK BGs
    //–––––––––––––––––––––––––––––––––––––

    var linkBGs = document.querySelectorAll('.radial-menu__menu-link-bg');

    setupLinks(linkBGs);


    //
    //  SETUP LINKS
    //–––––––––––––––––––––––––––––––––––––

    function setupLinks(elems) {

        // Count elems.
        var elemsCount = elems.length;
        // var elemsCount = countMenuItems( menuItems );

        var menuItems = container.querySelectorAll('.radial-menu__menu-item');

        // Count menu items.
        var menuItemsCount = countMenuItems(menuItems);


        // Find degree interval.
        var degreeInterval = 360 / menuItemsCount;

        // Loop through elems.
        for (var i = 0; i < elemsCount; i++) {

            var elem = elems[i];

            var parentMenuItem = elem.parentElement;

            // Get parent menu item's current "display" value.
            var parentMenuItemDisplay = parentMenuItem.currentStyle ? parentMenuItem.currentStyle.display : getComputedStyle(parentMenuItem, null).display;

            if (parentMenuItemDisplay !== 'none') {
                var phase = i / menuItemsCount;
                // console.log('phase(' + i + '): ' + phase);

                var theta = phase * 2 * Math.PI;
                // console.log('theta(' + i + '): ' + theta);

                var cssTransform = 'translateY(-50%) translateZ(0) rotateZ(' + degreeInterval * i + 'deg) perspective(' + menuDimensions / 1.5 + 'px)';

                var transformString = getLinkTransforms(menuItemsCount);

                // cssTransform += 'rotateY(-83.8deg) scaleX(1.38)';
                cssTransform += transformString;

                // console.log(cssTransform);

                elem.style.transform = cssTransform;
            }
        }
    }


    //
    //  ON LINK HOVER
    //–––––––––––––––––––––––––––––––––––––

    function setupLinkHovers(elems) {

        // Count elems.
        var elemsCount = elems.length;

        // Loop through elems.
        for (var i = 0; i < elemsCount; i++) {

            var elem = elems[i];
            var parentMenuItem = elem.parentElement;

            // Get parent menu item's current "display" value.
            var parentMenuItemDisplay = elem.currentStyle ? elem.currentStyle.display : getComputedStyle(elem, null).display;

            // If the menu item's display is not set to none.'
            if (parentMenuItemDisplay !== 'none') {
                elem.addEventListener('mouseenter', function (event) {
                    var parentMenuItem = this.parentElement;
                    parentMenuItem.classList.add('hovered');
                    container.classList.add('item-is-hovered');
                });

                elem.addEventListener('mouseleave', function (event) {
                    var parentMenuItem = this.parentElement;
                    parentMenuItem.classList.remove('hovered');
                    container.classList.remove('item-is-hovered');
                });
            }
        }
    }


    //
    //  GET LINK TRANSFORMS
    //–––––––––––––––––––––––––––––––––––––

    function getLinkTransforms(count) {

        var transformString;

        switch (count) {
            case 3:
                transformString = 'rotateY(-88.012deg) scaleX(1.45)';
                break;

            case 4:
                transformString = 'rotateY(-86.45deg) scaleX(1.425)';
                break;

            case 5:
                transformString = 'rotateY(-85.025deg) scaleX(1.39)';
                break;

            case 6:
                transformString = 'rotateY(-83.65deg) scaleX(1.36)';
                break;

            case 7:
                transformString = 'rotateY(-82.1deg) scaleX(1.325)';
                break;

            case 8:
                transformString = 'rotateY(-80.8deg) scaleX(1.3)';
                break;

            case 9:
                transformString = 'rotateY(-79deg) scaleX(1.265)';
                break;

            case 10:
                transformString = 'rotateY(-77.3deg) scaleX(1.23)';
                break;

            case 11:
                transformString = 'rotateY(-76deg) scaleX(1.21)';
                break;

            case 12:
                transformString = 'rotateY(-74.75deg) scaleX(1.185)';
                break;

            case 13:
                transformString = 'rotateY(-72.1deg) scaleX(1.14)';
                break;

            case 14:
                transformString = 'rotateY(-69.8deg) scaleX(1.11)';
                break;

            case 15:
                transformString = 'rotateY(-67.7deg) scaleX(1.086)';
                break;
        }

        return transformString;
    }


    //
    //  ICONS
    //–––––––––––––––––––––––––––––––––––––

    var icons = document.querySelectorAll('.radial-menu__menu-icon');
    var iconDistance = 95;

    positionIcons(icons, iconDistance);

    function positionIcons(icons, iconDistance) {

        var menuItems = container.querySelectorAll('.radial-menu__menu-item');

        // Count menu items.
        var menuItemsCount = countMenuItems(menuItems);

        // Count icons.
        var iconsCount = icons.length;
        var iconOffset = 1.575; // Used to rotate 90deg.

        // Loop through icons.
        for (var i = 0; i < iconsCount; i++) {
            var icon = icons[i];

            var parentMenuItem = icon.parentElement;

            // Get parent menu item's current "display" value.
            var parentMenuItemDisplay = parentMenuItem.currentStyle ? parentMenuItem.currentStyle.display : getComputedStyle(parentMenuItem, null).display;

            // If the menu item's display is not set to none.'
            if (parentMenuItemDisplay !== 'none') {

                var phase = i / menuItemsCount;
                // console.log('phase(' + i + '): ' + phase);

                var theta = phase * 2 * Math.PI;
                theta = theta + iconOffset;
                // console.log('theta(' + i + '): ' + theta);

                icon.style.top = (-iconDistance * Math.cos(theta)).toFixed(1) + 'px';
                icon.style.left = (iconDistance * Math.sin(theta)).toFixed(1) + 'px';
            }
        }
    }


    //
    //  RIGHT CLICK
    //–––––––––––––––––––––––––––––––––––––

    // document.addEventListener('contextmenu', function (e) {
    //     e.preventDefault();
    //     var mousePosX = e.clientX;
    //     var mousePosY = e.clientY;
    //     // console.log( 'mousePosX: ' + mousePosX );
    //     // console.log( 'mousePosY: ' + mousePosY );

    //     container.classList.remove('is-hidden');
    //     container.classList.add('is-active');

    //     container.style.top = mousePosY + 'px';
    //     container.style.left = mousePosX + 'px';

    //     mouseMoveListener(mousePosX, mousePosY);

    //     return false;
    // }, false);


    //
    //  RIGHT CLICK MOUSE UP
    //–––––––––––––––––––––––––––––––––––––

    // document.addEventListener('mouseup', function (e) {

    //     var mouseButton = e.button;

    //     // If it's the right mouse button.
    //     if (mouseButton == 2) {

    //         // Hide the menu.
    //         container.classList.add('is-hidden');
    //         container.classList.remove('is-active');
    //     }
    // });


    //
    //  MOUSE MOVE LISTENER
    //–––––––––––––––––––––––––––––––––––––

    function mouseMoveListener(x, y) {
        document.addEventListener('mousemove', function (e) {
            

            // If the radial menu is active.
            if (container.classList.contains('is-active')) {
                var newX = e.clientX;
                var newY = e.clientY;
                var scale = Math.round(Math.sqrt(Math.pow(y - newY, 2) + Math.pow(x - newX, 2)));

                // console.log('scale: ' + scale);

                scale = scale * 0.01;
                // console.log('scale / 100: ' + scale);

                // container.style.transform = 'translate(-50%, -50%) scale(' + scale  + ')';
                // console.log('e.clientX: ' + e.clientX);
                // console.log('e.clientY: ' + e.clientY);
            }
        });
    }

    // move the mouse hover tooltip
    document.addEventListener('mousemove', function (e) {
        $('#tooltip').css('left', `${e.clientX}px`);
        $('#tooltip').css('top', `${e.clientY}px`);
    });

    $('.radial-menu__menu-item.hovered .radial-menu__menu-content .radial-menu__menu-content-description').mouseover(() => {
        var tip = $('.radial-menu__menu-item.hovered .radial-menu__menu-content .radial-menu__menu-content-description p').text();
        $('#tooltip').text(tip);
        $('#tooltip').css('visibility', 'visible');
    });

    $('.radial-menu__menu-item.hovered .radial-menu__menu-content .radial-menu__menu-content-description').mouseout(() => {
        $('#tooltip').css('visibility', 'hidden');
    });

    
})

window.addEventListener('message', (event) => {
    let item = event.data

    if (item.type === 'open-radial') {
        if (!($('.radial-menu').hasClass('is-active'))) {
            $('.radial-menu').addClass('is-active');
            $('.radial-menu').removeClass('is-hidden');
        }
    }
})

window.addEventListener('keyup', (event) => {
    if (event.key === 'Escape' && $('.radial-menu').hasClass('is-active')) {
        $('.radial-menu').addClass('is-hidden');
        $('.radial-menu').removeClass('is-active');

        $.post(`https://${GetParentResourceName()}/close-radial`);
    }
})