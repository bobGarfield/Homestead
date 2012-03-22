(function() {
  var column, item, makeUnit, raw;

  raw = 'tr';

  column = 'td';

  item = 'item';

  makeUnit = function(id, text, number) {
    var elem, name, num;
    elem = make(raw);
    elem["class"] = item;
    elem.id = id;
    name = make(column);
    name.textContent = text;
    num = make(column);
    name.textContent = number;
    elem.appendChild(name);
    return console.log('here');
  };

  this.Interface = (function() {

    function Interface() {}

    Interface.prototype.init = function(app, opts) {
      var elem,
        _this = this;
      this.app = app;
      for (elem in opts) {
        this[elem] = $(opts[elem]);
      }
      this.current = this.menu;
      this.bStartGame.onclick = function() {
        _this.openGame();
        return _this.app.start();
      };
      return preventDefaults(this.game, 'oncontextmenu');
    };

    Interface.prototype.openGame = function() {
      toggleDisplay(this.current, 'none');
      toggleDisplay(this.game, 'block');
      return this.current = this.game;
    };

    Interface.prototype.openJournal = function() {
      toggleDisplay(this.current, 'none');
      toggleDisplay(this.journal, 'block');
      return this.current = this.journal;
    };

    Interface.prototype.drawContainer = function(container) {
      var _this = this;
      return container.blocks.each(function(number, block) {
        var name;
        name = makeName(block);
        return makeUnit(block, name, number);
      });
    };

    return Interface;

  })();

}).call(this);
