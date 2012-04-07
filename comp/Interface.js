(function() {
  var body, currentItemClass, itemClass, makeRow, onContextMenu, row;

  row = 'tr';

  body = 'body';

  onContextMenu = 'oncontextmenu';

  itemClass = 'item';

  currentItemClass = 'currentItem';

  makeRow = function(id, quantity) {
    var item, nameCell, quantityCell;
    item = make(row, itemClass, id);
    nameCell = item.insertCell(0);
    nameCell.textContent = id;
    quantityCell = item.insertCell(1);
    quantityCell.textContent = quantity;
    return item;
  };

  this.Interface = (function() {

    function Interface() {
      preventDefaults($(body), onContextMenu);
    }

    Interface.prototype.importElements = function() {
      var buttons, elem, elements, _results;
      buttons = this.buttons, elements = this.elements;
      for (elem in elements) {
        elements[elem] = $(elements[elem]);
      }
      _results = [];
      for (elem in buttons) {
        _results.push(buttons[elem] = $$(buttons[elem]));
      }
      return _results;
    };

    Interface.prototype.bindEvents = function() {
      var app, buttons, elements, open,
        _this = this;
      buttons = this.buttons, elements = this.elements, app = this.app;
      open = this.open.bind(this);
      elements.journal.onopen = function() {
        return _this.drawJournal();
      };
      buttons.bStartGame.each(function(button) {
        return button.onclick = function() {
          open(elements.game);
          app.start();
          this.textContent = 'Continue';
          return this.onclick = function() {
            return open(elements.game);
          };
        };
      });
      buttons.bOpenOptions.each(function(button) {
        return button.onclick = function() {
          return open(elements.options);
        };
      });
      buttons.bOpenJournal.each(function(button) {
        return button.onclick = function() {
          open(elements.journal);
          return elements.journal.onopen();
        };
      });
      buttons.bOpenGame.each(function(button) {
        return button.onclick = function() {
          return open(elements.game);
        };
      });
      return buttons.bOpenMenu.each(function(button) {
        return button.onclick = function() {
          return open(elements.menu);
        };
      });
    };

    Interface.prototype.init = function(app, elements, buttons) {
      this.app = app;
      this.elements = elements;
      this.buttons = buttons;
      this.importElements();
      this.bindEvents();
      return this.current = this.elements.menu;
    };

    Interface.prototype.open = function(section) {
      var current;
      current = this.current;
      toggleDisplay(current, 'none');
      toggleDisplay(section, 'block');
      return this.current = section;
    };

    Interface.prototype.drawJournal = function() {
      var container, id, item, list, quantity, _ref, _results;
      container = this.container;
      list = this.elements.list;
      removeRowsFrom(list);
      _ref = container.blocks;
      _results = [];
      for (id in _ref) {
        quantity = _ref[id];
        item = makeRow(id, quantity);
        if (id === container.current) item.className = currentItemClass;
        item.onclick = function() {
          resetClassNamesFor(list.children);
          container.current = this.id;
          return this.className = currentItemClass;
        };
        _results.push(list.appendChild(item));
      }
      return _results;
    };

    return Interface;

  })();

}).call(this);
