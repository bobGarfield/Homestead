(function() {
  var cellSize, dirt, getRelative, hollow, interpret, stone, translate, wood;

  cellSize = 40;

  hollow = 0;

  dirt = 1;

  stone = 2;

  wood = 3;

  interpret = function(type) {
    switch (type) {
      case 1:
        return dirt;
      case 2:
        return stone;
      case 3:
        return wood;
    }
  };

  translate = function(name) {
    switch (name) {
      case dirt:
        return 1;
      case stone:
        return 2;
      case wood:
        return 3;
    }
  };

  getRelative = function(abs) {
    var rel;
    return rel = abs.multiply(1 / cellSize).floor();
  };

  this.Map = (function() {

    function Map(matrix) {
      var _this = this;
      this.matrix = matrix;
      this.spawnPoint = matrix.spawnPoint.multiply(cellSize);
      this.cellSize = cellSize;
      this.blocks = [];
      this.height.times(function(y) {
        _this.blocks[y] = [];
        return _this.width.times(function(x) {
          return _this.blocks[y][x] = hollow;
        });
      });
    }

    Map.prototype.checkX = function(point, side) {
      var rel, x, y;
      rel = point.multiply(1 / cellSize).round();
      x = rel.x + side;
      y = rel.y;
      return this.matrix[y][x] === hollow;
    };

    Map.prototype.checkY = function(point, side) {
      var rel, x, y;
      rel = getRelative(point);
      x = rel.x;
      y = rel.y + side;
      return this.matrix[y][x] === hollow;
    };

    Map.prototype.destroyBlockAt = function(point) {
      var rel, x, y;
      rel = getRelative(point);
      x = rel.x;
      y = rel.y;
      this.matrix[y][x] = hollow;
      return this.blocks[y][x].remove();
    };

    Map.prototype.blockAt = function(point) {
      var name, rel, type, x, y;
      point.x -= cellSize / 2;
      rel = getRelative(point);
      x = rel.x;
      y = rel.y;
      type = this.blocks[y][x];
      name = interpret(type);
      return name;
    };

    Map.prototype.putBlockTo = function(coord, block) {};

    Map.get('height', function() {
      var _ref;
      return (_ref = this.height_) != null ? _ref : this.height_ = this.matrix.length;
    });

    Map.get('width', function() {
      var _ref;
      return (_ref = this.width_) != null ? _ref : this.width_ = this.matrix[0].length;
    });

    return Map;

  })();

}).call(this);
