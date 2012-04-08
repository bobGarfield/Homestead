(function() {
  var cellSize, container, dirt, door, hcellSize, hollow, interpret, left, right, stone, translate, wood;

  cellSize = 40;

  hcellSize = cellSize / 2;

  hollow = '0';

  dirt = '1';

  stone = '2';

  wood = '3';

  door = 'd';

  container = 'c';

  left = -1;

  right = 1;

  translate = function(type) {
    switch (type) {
      case dirt:
        return 'dirt';
      case stone:
        return 'stone';
      case wood:
        return 'wood';
      default:
        return null;
    }
  };

  interpret = function(id) {
    switch (id) {
      case 'dirt':
        return dirt;
      case 'stone':
        return stone;
      case 'wood':
        return wood;
      default:
        return null;
    }
  };

  namespace("Map", function() {
    return this.Location = (function() {

      function Location(matrix, index) {
        var _this = this;
        this.matrix = matrix;
        this.index = index;
        this.points = {};
        this.points.left = this.absoluteFrom([3, 3].point());
        this.points.right = this.absoluteFrom([this.width - 4, 3].point());
        this.points.end = this.absoluteFrom([this.width - 20, 0].point());
        this.cellSize = cellSize;
        this.blocks = [];
        this.height.times(function(y) {
          _this.blocks[y] = [];
          return _this.width.times(function(x) {
            return _this.blocks[y][x] = null;
          });
        });
      }

      Location.prototype.checkX = function(point, side) {
        var relative, x, y, _ref;
        relative = point.divide(cellSize).round();
        x = relative.x, y = relative.y;
        x += side;
        return ((_ref = this.matrix[y]) != null ? _ref[x] : void 0) === hollow;
      };

      Location.prototype.checkY = function(point, side) {
        var relative, x, y, _ref;
        relative = this.relativeFrom(point);
        x = relative.x, y = relative.y;
        y += side;
        return ((_ref = this.matrix[y]) != null ? _ref[x] : void 0) === hollow;
      };

      Location.prototype.checkBorder = function(point) {
        var relative, x, y;
        relative = this.relativeFrom(point);
        x = relative.x, y = relative.y;
        switch (x) {
          case 0:
            return left;
          case this.width - 1:
            return right;
          default:
            return null;
        }
      };

      Location.prototype.destroyBlockAt = function(point) {
        var relative, x, y, _ref;
        point = point.add(-cellSize / 4);
        relative = this.relativeFrom(point);
        x = relative.x, y = relative.y;
        this.matrix[y][x] = hollow;
        return (_ref = this.blocks[y][x]) != null ? _ref.remove() : void 0;
      };

      Location.prototype.destroy = function() {
        return this.blocks.each(function(row) {
          return row.each(function(block) {
            return block != null ? block.remove() : void 0;
          });
        });
      };

      Location.prototype.blockAt = function(point) {
        var id, relative, type, x, y, _ref;
        relative = this.relativeFrom(point);
        x = relative.x, y = relative.y;
        type = (_ref = this.matrix[y]) != null ? _ref[x] : void 0;
        if (!type) return 'null';
        id = translate(type);
        return id;
      };

      Location.prototype.putBlockTo = function(point, id, shape) {
        var relative, type, x, y;
        if (!shape) return;
        type = interpret(id);
        relative = this.relativeFrom(point);
        shape.position = this.absoluteFrom(relative).add(hcellSize);
        x = relative.x, y = relative.y;
        this.matrix[y][x] = type;
        return this.blocks[y][x] = shape;
      };

      Location.prototype.spawnBlockAt = function(point, shape) {
        var relative, x, y;
        relative = this.relativeFrom(point);
        shape.position = this.absoluteFrom(relative).add(hcellSize);
        x = relative.x, y = relative.y;
        return this.blocks[y][x] = shape;
      };

      Location.prototype.relativeFrom = function(absolute) {
        return absolute.divide(cellSize).floor();
      };

      Location.prototype.absoluteFrom = function(relative) {
        return relative.multiply(cellSize);
      };

      Location.prototype.floorFrom = function(absolute) {
        return this.absoluteFrom(absolute.divide(cellSize).floor());
      };

      Location.get('height', function() {
        var _ref;
        return (_ref = this.height_) != null ? _ref : this.height_ = this.matrix.length;
      });

      Location.get('width', function() {
        var _ref;
        return (_ref = this.width_) != null ? _ref : this.width_ = this.matrix[0].length;
      });

      return Location;

    })();
  });

}).call(this);
