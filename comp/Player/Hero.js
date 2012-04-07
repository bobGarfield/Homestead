(function() {

  namespace('Player', function() {
    var Inventory, height;
    height = 80;
    Inventory = this.Inventory;
    return this.Hero = (function() {

      function Hero() {
        this.inventory = new Inventory;
      }

      Hero.prototype.spawn = function(coord) {
        var _ref;
        this.coord = coord;
        return (_ref = this.shape) != null ? _ref.position = coord : void 0;
      };

      Hero.prototype.move = function(dist) {
        this.shape.position.x += dist;
        return this.coord.x += dist;
      };

      Hero.prototype.jump = function(height) {
        this.shape.position.y -= height;
        return this.coord.y -= height;
      };

      Hero.prototype.fall = function(height) {
        this.shape.position.y += height;
        return this.coord.y += height;
      };

      Hero.get('head', function() {
        var head;
        head = this.coord.clone();
        head.y -= height / 2;
        return head;
      });

      Hero.get('body', function() {
        var body;
        body = this.coord;
        return body;
      });

      return Hero;

    })();
  });

}).call(this);
