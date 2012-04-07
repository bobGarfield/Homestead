(function() {

  namespace('Items', function() {
    return this.Container = (function() {

      function Container() {
        this.blocks = {};
        this.items = {};
      }

      Container.prototype.putBlock = function(id) {
        var _base;
        if ((_base = this.blocks)[id] == null) _base[id] = 0;
        return ++this.blocks[id];
      };

      Container.prototype.putItem = function(id) {
        var _base;
        if ((_base = this.items)[id] == null) _base[id] = 0;
        return ++this.items[id];
      };

      return Container;

    })();
  });

}).call(this);
