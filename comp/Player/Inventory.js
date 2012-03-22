(function() {
  var Container;

  Container = this.Items.Container;

  namespace('Player', function() {
    return this.Inventory = (function() {

      function Inventory() {
        this.container = new Container;
      }

      Inventory.prototype.put = function(thing) {
        var contr, digit;
        contr = this.container;
        digit = /\d/;
        if (digit.test(thing)) {
          return contr.blocks[thing]++;
        } else {
          return contr.items.push(thing);
        }
      };

      return Inventory;

    })();
  });

}).call(this);
