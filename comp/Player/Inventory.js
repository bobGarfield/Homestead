(function() {
  var Container, block;

  Container = this.Items.Container;

  block = /(dirt|stone|wood)/;

  namespace('Player', function() {
    return this.Inventory = (function() {

      function Inventory() {
        this.container = new Container;
        this.current = null;
      }

      Inventory.prototype.put = function(id) {
        if (!id) return;
        if (block.test(id)) {
          return this.container.putBlock(id);
        } else {
          return this.container.putItem(id);
        }
      };

      Inventory.prototype.takeBlock = function() {
        var blocks, current, _ref;
        _ref = this.container, blocks = _ref.blocks, current = _ref.current;
        if (blocks[current]) {
          --blocks[current];
          return current;
        }
      };

      return Inventory;

    })();
  });

}).call(this);
