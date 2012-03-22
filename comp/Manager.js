(function() {
  var all, down, left, leftButton, makeJumpKey, openJournalKey, right, rightButton, up, walkLeftKey, walkRightKey;

  all = 4;

  left = -5;

  right = 5;

  up = 50;

  down = 5;

  walkLeftKey = 'a';

  walkRightKey = 'd';

  openJournalKey = 'j';

  makeJumpKey = 'space';

  leftButton = 0;

  rightButton = 2;

  this.Manager = (function() {

    function Manager(opts) {
      var canvas, paper;
      this.opts = opts;
      canvas = opts.canvas, paper = opts.paper;
      paper.setup(canvas);
      paper.install(this);
    }

    Manager.prototype.start = function() {
      this.drawMap();
      this.spawnPlayer();
      this.defineLoop();
      this.defineMouseHandlers();
      return this.defineKeyboardHandlers();
    };

    Manager.prototype.defineKeyboardHandlers = function() {
      var interface, player, textures, _ref,
        _this = this;
      _ref = this.opts, interface = _ref.interface, player = _ref.player, textures = _ref.textures;
      this.tool.onKeyDown = function(event) {
        if (event.key === openJournalKey) {
          interface.openJournal();
          interface.drawContainer(player.inventory.container)();
        }
        if (event.key === walkRightKey) player.shape.image = textures.playerRun;
        if (event.key === walkLeftKey) {
          return player.shape.image = textures.playerRunLeft;
        }
      };
      return this.tool.onKeyUp = function(event) {
        if (event.key === walkRightKey) player.shape.image = textures.player;
        if (event.key === walkLeftKey) {
          return player.shape.image = textures.playerLeft;
        }
      };
    };

    Manager.prototype.defineMouseHandlers = function() {
      var map, player, _ref,
        _this = this;
      _ref = this.opts, player = _ref.player, map = _ref.map;
      return this.tool.onMouseDown = function(event) {
        var block, button, coord, dist, inventory;
        dist = _this.view.camera.x;
        coord = event.point.clone();
        coord.x += dist;
        button = event.event.button;
        inventory = player.inventory;
        switch (button) {
          case leftButton:
            block = map.blockAt(coord);
            inventory.put(block);
            return map.destroyBlockAt(coord);
          case rightButton:
            return map.putBlockTo(coord, inventory.current);
        }
      };
    };

    Manager.prototype.defineLoop = function() {
      var camera, key, map, player, _ref,
        _this = this;
      _ref = this.opts, map = _ref.map, player = _ref.player;
      key = this.Key;
      camera = this.view.camera = [0, 0].point();
      return this.view.onFrame = function() {
        var vector;
        if (key.isDown(walkRightKey)) {
          if (map.checkX(player.head, 0) && map.checkX(player.body, 0)) {
            player.move(right);
            if ((camera.x + _this.view.size.width) / map.cellSize < map.width) {
              vector = [left, 0].point();
              _this.view.translate(vector);
            }
          }
        }
        if (key.isDown(walkLeftKey)) {
          if (map.checkX(player.head, -1) && map.checkX(player.body, -1)) {
            player.move(left);
            if (camera.x > 0) {
              vector = [right, 0].point();
              _this.view.translate(vector);
            }
          }
        }
        if (map.checkY(player.body, 1)) {
          player.fall(down);
          return;
        }
        if (key.isDown(makeJumpKey)) {
          if (map.checkY(player.head, -1)) return player.jump(up);
        }
      };
    };

    Manager.prototype.spawnPlayer = function() {
      var coord, map, player, texture, textures, _ref;
      _ref = this.opts, map = _ref.map, player = _ref.player, textures = _ref.textures;
      coord = map.spawnPoint;
      texture = textures.player;
      player.spawn(coord);
      return player.shape = new this.Raster(texture, coord);
    };

    Manager.prototype.drawMap = function() {
      var height, map, size, width,
        _this = this;
      map = this.opts.map;
      height = map.height;
      width = map.width;
      size = map.cellSize;
      return height.times(function(y) {
        return width.times(function(x) {
          var block, rel;
          block = map.matrix[y][x];
          rel = [x, y].point();
          if (block) return map.blocks[y][x] = _this.makeBlock(block, rel, size);
        });
      });
    };

    Manager.prototype.makeBlock = function(type, rel, size) {
      var coord, kind, texture, textures;
      textures = this.opts.textures;
      coord = rel.multiply(size).add(size / 2);
      kind = all.rand();
      switch (type) {
        case 1:
          texture = textures["land" + kind];
          return new this.Raster(texture, coord);
      }
    };

    return Manager;

  })();

}).call(this);
